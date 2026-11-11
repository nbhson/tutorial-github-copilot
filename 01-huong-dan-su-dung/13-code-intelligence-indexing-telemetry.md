# 13 — Code Intelligence: Codebase Indexing & Telemetry

> **Dành cho:** dev dùng Copilot Chat trên repo lớn, và admin/tech lead muốn đọc được số liệu usage của team (bài 13 series 01).
> **Vấn đề:** repo lớn mà chưa index thì chat trả lời "đoán mò" từ vài file đang mở; AI Credits bị tiêu hết mà không ai biết vì sao; và ba thứ — context window, indexing, code search — bị gọi nhầm là một.
> **Đọc xong:** phân biệt được 3 khái niệm hay nhầm; dùng `#codebase` đúng cách và biết đường lùi khi index chưa sẵn sàng; cấu hình được 6 tham số telemetry `github.copilot.*`; trả lời câu hỏi admin bằng đúng số liệu. **Thời gian:** ~35 phút.

## Mục tiêu bài học

Mục này liệt kê những gì bạn cầm được sau ~35 phút — như danh sách đồ cần mua trước khi vào siêu thị.

- Phân biệt 3 thứ hay nhầm: **context window** (bao nhiêu token được đưa vào model trong một request) ≠ **codebase indexing** (lập chỉ mục semantic để tìm code nhanh) ≠ **code search** (tìm text/regex trong repo, không cần index).
- Dùng `#codebase` cho câu hỏi xuyên repo; biết indexing **chỉ cải thiện search/semantic retrieval**, không ảnh hưởng code completions, và khi index chưa chạy được thì có **local search fallback**.
- Đọc và cấu hình được 6 tham số `github.copilot.chat.otel.*` trong `settings.json` để xuất dữ liệu phiên agent sang OpenTelemetry; biết telemetry VS Code tách biệt với xử lý dữ liệu của AI provider.
- Trả lời được 5 câu hỏi admin bằng đúng nguồn số: dashboard usage metrics (phía GitHub), `/usage` trong Copilot CLI, OTel export, audit log.

> **Tóm gọn 1 câu:** Indexing là *mục lục* để Copilot tìm code nhanh, context window là *trang sách* thực sự đưa vào model, telemetry là *bảng kê* để bạn biết tiền AI credits và công sức của team đi đâu — ba vật khác nhau, đừng nhầm một.

---

## 1. Ba thứ hay nhầm: context window ≠ codebase indexing ≠ code search

Docs VS Code nói thẳng: index giúp *tìm* các đoạn liên quan chứ **không đưa toàn bộ workspace vào mỗi model request**. Vậy "cho Copilot biết cả repo" và "repo nằm trong đầu model" là hai chuyện khác nhau.

| Khái niệm | Trả lời cho câu hỏi | Quy mô thực tế |
|---|---|---|
| **Context window** | Bao nhiêu token của hội thoại này được đưa vào model trong một request | Theo model; thêm gì có nấy (`#file:`, selection, kết quả tool) |
| **Codebase indexing** | Lập chỉ mục semantic (embedding) cho cả repo để **tìm** nhanh theo nghĩa | Cả repo; dựng một lần, cập nhật liên tục — không "nằm trong" model |
| **Code search** | Tìm text/regex trong repo (`grep`, file search theo tên) | Chạy **không cần index**, chính xác từng ký tự |

**Vì sao quan trọng?** Mỗi thứ chữa một bệnh khác nhau: model thiếu file cần thiết → tự đưa vào qua context; tìm theo *nghĩa* bị trượt (code viết `signIn`, bạn hỏi "authentication") → cần index; tìm một chuỗi exact như `STRIPE_KEY` → grep/text search là đủ, index không cần thiết.
**Nếu làm sai?** Tưởng "index cả repo = model thấy cả repo" → bạn hỏi mơ hồ rồi thất vọng và đổ tại Copilot dở. Ngược lại tưởng "tắt indexing là completions chết" → không, completions **không đọc cái index này** (docs: "no effect on code completions").

> **Tóm gọn 1 câu:** Gọi đúng tên ba thứ thì chọn đúng thuốc; gọi sai là khám bệnh nhầm cả tháng. · 📄 [VS Code Docs: Context window & compaction](https://code.visualstudio.com/docs/agents/concepts/context#context-window-and-compaction)

## 2. Indexing hoạt động thế nào: embeddings + flow

**Nôm na 1 câu:** embedding là biến đoạn code thành "tọa độ nghĩa" — hai đoạn làm cùng việc đứng gần nhau trên bản đồ dù không trùng từ nào; index là bản đồ tọa độ của cả repo.

```text
hoi "xu ly authentication o dau?" -> model KHONG doc ca repo:

  1. luc lap chi muc (index, chay nem):
     moi file/ham -> embedding = chuoi so hoa "y nghia" (vector)
     toan bo vector -> thanh index; phia GitHub rebuild khi co push
  2. luc hoi:
     cau hoi -> embedding -> so khop vector (semantic search)
     -> chon vai chuc doan lien quan nhat -> agent doc file that
  3. ket qua:
     chi doan file duoc doc moi di vao context window cua request
```

Bốn điều cần thuộc (mọi nguồn ở mục Reference):
- **VS Code 1.96 trở lên** mới có semantic index trong Chat; bản cũ hơn chỉ dùng được các search tool không cần index.
- Indexing **chỉ cải thiện search/semantic retrieval** — **không ảnh hưởng code completions** (completions do model gợi ý riêng đảm nhiệm, unlimited trên mọi paid plan — bài 14).
- Index đang build, bị policy chặn, hoặc workspace không có index → **local search fallback**: text search, grep, file search và language intelligence vẫn chạy tốt mà không cần index.
- Index không "chiếm" context window: nó chỉ quyết định Copilot *tìm thấy đoạn nào*, còn *đoạn nào vào model* là chuyện của context.

**Index nằm ở đâu?** Với repo GitHub, GitHub build và giữ index — build một lần nên thường có sẵn ngay, cả team dùng chung; repo Azure DevOps tương tự; thư mục ngoài GitHub dùng **external ingest** (upload file lên GitHub để search — org phải cho phép bằng policy). Đây là *nơi lưu index*, không phải phân biệt Local/Copilot harness — chuyện harness thuộc bài 02.

> **Tóm gọn 1 câu:** Index = bản đồ tọa độ của code; hỏi bài = giở bản đồ tìm vài file, chỉ mấy file đó bước vào "mặt bàn" của model. · 📄 [VS Code Docs: Semantic search](https://code.visualstudio.com/docs/agents/reference/workspace-context#semantic-search)

## 3. Hỏi cả repo đúng cách: `#codebase` + đường lùi khi index chưa xong

Chỗ hay vấp: các hướng dẫn cũ dạy `@workspace` — đó là **chat participant đã deprecated**, chỉ còn chạy ở Local harness ([participants](commands/local/model-agent/participants/README.md)); ở Copilot harness hôm nay đường chuẩn là `#codebase` và các search tool mà agent **tự chọn** — docs ghi rõ bạn không cần gắn `#codebase` vào mọi prompt, chỉ dùng khi muốn cưỡng bức search theo nghĩa.

Hai mẫu ăn tiền (cú pháp `#`-mentions đầy đủ: bài 04):

```text
# mau 1 — flow xuyen lop (thay grep mu):
#codebase POST /login di qua nhung file nao (handler -> domain -> db)?
# Tra ve toi da 10 file, moi file 1 dong ly do, kem duong dan file:dong.

# mau 2 — audit pattern (grep khong lam duoc):
#codebase tim cho nao catch error roi chi log roi nu (swallowed errors)
# trong apps/api; liet ke file:dong, xep theo rui ro refactor.
```

**Thu hẹp scope** khi kết quả nhiễu: kèm đường dẫn ("trong apps/api, bỏ apps/web"); chia 2 bước — search định vị rồi `#file:` đọc sâu; loại `**/*.test.ts`. **Trả lời sai?** Kiểm theo thứ tự: trạng thái index (Copilot status bar → Codebase Semantic Index), file có bị exclude nhầm không, câu hỏi có đang ôm >1 flow không; bí nữa thì `/troubleshoot` ([README](commands/copilot/chat-session/troubleshoot/README.md)).

So nhanh với đường "không index": Claude Code và Codex không dựng semantic index trước — agent của họ **dò theo yêu cầu** (grep/glob từng vòng); đổi lại mỗi vòng dò tốn thêm lượt tool, còn Copilot trả giá một lần cho cái index.

> **Tóm gọn 1 câu:** Index chỉ giúp *tìm*, không đảm bảo *đúng* — một câu một flow, scope rõ, rồi đọc kỹ file bằng `#file:`. 📄 Settings để index thấy đúng thứ (files.exclude/search.exclude/.gitignore): [`./examples/13-code-intelligence-indexing-telemetry/bat-codebase-indexing-copy-paste.sh`](./examples/13-code-intelligence-indexing-telemetry/bat-codebase-indexing-copy-paste.sh). · 📄 [VS Code Docs: Context items](https://code.visualstudio.com/docs/agents/reference/tools-reference#context-items)

## 4. Bật, dựng lại, giữ cho index sạch

**Plan → số file index được mỗi repo** (theo docs codebase indexing, mục Reference):

| Plan | File được index / repo |
|---|---|
| Free | 10.000 |
| Pro | 50.000 |
| Pro+ | 190.000 |

- File binary (ảnh, PDF) không được index; `.gitignore` và `files.exclude` loại file khỏi **cả index lẫn text search**.
- Dựng lại index on-demand: **Command Palette → Build Codebase Semantic Index**; thanh trạng thái Copilot hiện tiến trình và lý do bị chặn ("External ingest is disabled…").

```text
# Checklist admin (github.com -> Settings -> Copilot -> Policies):
[ ] Bat index 2-3 repo "core" truoc, do ket qua roi mo rong (dung index ca org ngay tuan 1)
[ ] Content exclusion cau hinh TRUOC khi bat index: .env, secrets/, *.pem, *.key
    -> chi day du o bai 07 + [commands/cloud/system-knowledge/content-exclusion]
[ ] Repo ngoai GitHub: policy "Semantic indexing for non-GitHub repositories" = Enabled
    (Business/Enterprise mac dinh chua bat la tinh nang chua dung duoc)
```

> 📄 Settings team + lệnh verify exclusion: [`./examples/13-code-intelligence-indexing-telemetry/bat-codebase-indexing-copy-paste.sh`](./examples/13-code-intelligence-indexing-telemetry/bat-codebase-indexing-copy-paste.sh). Organization còn index được cả **docs ngoài code** (ADRs, runbooks) qua knowledge base — code trả lời "làm gì", docs trả lời "vì sao": [`./examples/13-code-intelligence-indexing-telemetry/knowledge-bases-ky-uc-team-dung-chung.sh`](./examples/13-code-intelligence-indexing-telemetry/knowledge-bases-ky-uc-team-dung-chung.sh) · [knowledge-base](commands/cloud/system-knowledge/knowledge-base/README.md). Dựng index **không phát sinh thêm chi phí** — đồng tiền nằm ở lượt chat/agent, xem bài 14.

**Nếu làm sai?** Bật index mà chưa exclusion thì có ngày `.env` nằm trong kết quả search và lộ vào chat; index cả org cùng lúc thì không đo được repo nào hưởng lợi — pilot trước, mở rộng sau.

> **Tóm gọn 1 câu:** Exclude trước — pilot index trước — mở rộng sau; hai đồ nghề bạn sờ nhiều nhất là **Build Codebase Semantic Index** và status bar. · 📄 [GitHub Docs: Repository indexing](https://docs.github.com/en/copilot/concepts/prompting-and-context/repository-indexing)

## 5. Telemetry: 6 tham số `github.copilot.*` + số liệu admin hay hỏi

Export dữ liệu dùng agent sang OpenTelemetry gồm **6 tham số** trong `settings.json` (docs monitoring-agents):

| Tham số | Mặc định | Ý nghĩa |
|---|---|---|
| `github.copilot.chat.otel.enabled` | `false` | Bật xuất trace/metric/events cho các phiên agent |
| `github.copilot.chat.otel.exporterType` | `otlp-http` | Chọn `otlp-http` · `otlp-grpc` · `console` · `file` |
| `github.copilot.chat.otel.otlpEndpoint` | `http://localhost:4318` | Địa chỉ OTel collector nhận dữ liệu |
| `github.copilot.chat.otel.captureContent` | `false` | Bật lên = **toàn bộ prompt/response** chảy về backend của bạn |
| `github.copilot.chat.otel.captureIdentity` | `false` | Kèm tên account + username OS + hostname (chỉ session Local harness) |
| `github.copilot.chat.otel.maxAttributeSizeChars` | `0` | Chặn độ dài mỗi attribute nội dung; `0` = không cắt |

- Telemetry **của VS Code** (thống kê dùng sản phẩm, crash) là chuyện tách biệt với việc GitHub/AI provider **xử lý dữ liệu request** của bạn — tắt cái này không đổi cái kia; còn OTel export ở bảng trên chạy cho **cả Local lẫn Copilot harness**.
- Bản `settings.json` đầy đủ + câu truy vấn audit log cho admin: [`./examples/13-code-intelligence-indexing-telemetry/telemetry-6-tham-so-audit.json`](./examples/13-code-intelligence-indexing-telemetry/telemetry-6-tham-so-audit.json).

**Câu hỏi admin → số nào trả lời:**

| Câu hỏi | Số liệu trả lời | Đọc ở đâu |
|---|---|---|
| Team có thật sự dùng không? | Active users / seats assigned (adoption) | Cloud/API: dashboard usage metrics + API |
| Tính năng nào được dùng (chat, agent, completions)? | Engagement theo feature | Cloud/API: cùng dashboard (nhóm engagement) |
| Model nào đang ngốn AI credits? | Token per model + credits mỗi lượt | Local: `/usage` trong session `copilot` · metric `gen_ai.*` (OTel) |
| Ai vừa đổi policy/exclusion? | Sự kiện audit `action:copilot*` | `gh api /orgs/<ORG>/audit-log` (có trong examples/13-5) |
| Copilot trả lời sai do index cũ? | Trạng thái index của repo | Local: status bar Copilot → Codebase Semantic Index |

**Vì sao quan trọng?** Không có số thì "credits hết nhanh" mãi là tin đồn — và dashboard đẹp mà không dẫn tới hành động là sưu tầm. **Nếu làm sai?** Bật `captureContent` khi collector chưa kiểm soát truy cập là tự đẩy nguyên prompt (kèm code) vào hệ thống log; và đừng hỏi dashboard usage metrics "ai tắt exclusion" — đó việc của audit log. Consent quyền riêng tư (telemetry ≠ train ≠ duplication): [telemetry](commands/copilot/system-knowledge/telemetry/README.md).

> **Tóm gọn 1 câu:** 6 tham số OTel cho biết *ghi gì*; dashboard cho biết *chuyện gì đang xảy ra*; audit log cho biết *ai vừa thay đổi gì* — mỗi loại câu hỏi một nguồn trả lời. · 📄 [VS Code Docs: Telemetry](https://code.visualstudio.com/docs/configure/telemetry)

## 6. LSP: lớp kiểm chứng sau retrieve

Copilot tìm theo chữ và nghĩa; Language Server (LSP) mới hiểu types/symbols. Quy trình đáng tin: `#codebase` định vị file → **F12** nhảy về definition thật → sửa → **Problems panel** xanh rồi mới chạy test. Index chỉ quyết định "nên tìm ở đâu", không khẳng định "đây là symbol đúng".

| Việc | Chỉ Copilot | Copilot + LSP (VS Code) |
|---|---|---|
| Jump to definition | Đoán theo text | ✓ chính xác qua language server |
| Rename symbol | Sửa tay từng chỗ | ✓ F2 theo symbol, quét cả repo |
| Bắt lỗi sau sửa | Chờ chạy test | ✓ gạch đỏ live ở Problems panel |

> 📄 Bật LSP theo stack + prompt verify 2 lớp: [`./examples/13-code-intelligence-indexing-telemetry/lsp-copilot-synergy.sh`](./examples/13-code-intelligence-indexing-telemetry/lsp-copilot-synergy.sh)

> **Tóm gọn 1 câu:** Retrieve "gần đúng nghĩa" ≠ "đúng symbol" — F12 và Problems panel là bước kiểm chứng rẻ nhất bạn từng bỏ qua. · 📄 [VS Code Docs: IntelliSense](https://code.visualstudio.com/docs/editing/intellisense)

## Lỗi thường gặp (❌ SAI / ✅ ĐÚNG)

| ❌ SAI | Hệ quả | ✅ ĐÚNG |
|---|---|---|
| Vừa push xong hỏi `#codebase`, không thấy code mới → kết luận Copilot dở | Index có độ trễ cập nhật | Chờ index cập nhật hoặc rebuild tay; grep/text search không cần index vẫn chạy ngay; file cụ thể thì `#file:` |
| "Index cả repo nghĩa là model thấy cả repo" | Hỏi mơ hồ, nhận câu trả lời mơ hồ rồi mất tin | Index chỉ dùng để *tìm*; muốn model thấy gì, chủ động thêm vào context |
| Bật `captureContent: true` "cho đầy đủ số liệu" | Toàn bộ prompt + code đổ về collector | Mặc định off; chỉ bật khi backend có kiểm soát truy cập rõ ràng |
| Bật index cả org chưa cấu hình content exclusion | `.env`, secrets vào search index, có ngày lộ vào chat | Exclude trước (bài 07), rồi pilot 2–3 repo |

**Bài học:** đúng thứ tự là *gọi đúng tên 3 khái niệm → exclusion trước index → captureContent sau khi hỏi backend* — sai một bước là mất cả tuần debug nhầm chỗ. · 📄 [VS Code Docs: Improve agent search with exclusions](https://code.visualstudio.com/docs/agents/reference/workspace-context#improve-agent-search-with-exclusion-settings)

## Best practices (kèm "Vì sao?")

- **Giữ `.gitignore` và `files.exclude` gọn theo team.** *Vì sao:* chúng loại file khỏi cả index lẫn text search — giảm nhiễu kết quả và giảm token của kết quả search khi vào context.
- **Để agent tự chọn tool, đừng reflex gắn `#codebase` mọi prompt.** *Vì sao:* docs nói agent tự phối semantic search + grep + file search; `#codebase` dành cho lúc bạn *cưỡng bức* search theo nghĩa.
- **Chạy `/usage` ngay trong session vừa làm việc nặng.** *Vì sao:* số liệu per-model, per-session — đo đúng chỗ đang "ngốn" thì kết luận không bị pha.
- **Mỗi tuần biến số liệu thành đúng 1 hành động.** *Vì sao:* metric không hành động là sưu tầm; một fix + đo lại sau 1 tuần mới thành vòng lặp.
- **Verify kết quả semantic search bằng F12/Problems trước khi sửa.** *Vì sao:* index tìm "gần đúng", chỉ language server xác nhận symbol/type đúng. · 📄 [VS Code Docs: Enable OTel monitoring](https://code.visualstudio.com/docs/agents/guides/monitoring-agents#enable-otel-monitoring)

## Bài tập

1. **(5 phút)** Mở Command Palette → chạy **Build Codebase Semantic Index** trên một repo thật; quan sát status bar Copilot và đọc trạng thái index của repo.
2. **(10 phút)** Chạy cả 2 mẫu prompt mục 3; so với `git grep -l refreshToken` — cách nào tìm được "chỗ gọi nhưng đổi tên khác"? Câu trả lời sai thì chạy 3 bước debug (index / exclude / scope).
3. **(5 phút)** Gõ `copilot` để mở session CLI → chạy `/usage` ngay sau một lượt việc nặng; ghi lại model ngốn token nhiều nhất.
4. **(10 phút)** (admin/tech lead) Chạy lệnh `gh api /orgs/<ORG>/audit-log` với filter `action:copilot_policy` (trong examples/13-5); mở dashboard usage metrics, trả lời 1 câu bất kỳ ở bảng mục 5, và đề xuất đúng **1** fix kèm metric đo lại sau 1 tuần.

## Link qua

- Context mỗi request gồm gì, `#`-mentions, `#file:` → bài 04. · Content exclusion chi tiết → bài 07.
- Harness Local/Copilot/Claude/Codex chạy ở đâu → bài 02. · Copilot CLI và `/usage` → bài 12.
- AI credits, model nào đắt → bài 14. · Tool retrieve có đáng tin không → bài 16.
- Session bí tắc → [troubleshoot](commands/copilot/chat-session/troubleshoot/README.md). · `@workspace` ngày xưa giờ là participant deprecated → [participants](commands/local/model-agent/participants/README.md). · Docs team ngoài code → [knowledge-base](commands/cloud/system-knowledge/knowledge-base/README.md).

## Reference

- VS Code — [Codebase indexing](https://code.visualstudio.com/docs/agents/reference/workspace-context) · [Codebase context](https://code.visualstudio.com/docs/chat/copilot-chat-context) · [Use GitHub repository search](https://code.visualstudio.com/docs/agents/guides/explore-a-codebase) · [Copilot telemetry](https://code.visualstudio.com/docs/agents/guides/monitoring-agents) · bản đang chạy thật: [How Copilot understands your workspace](https://code.visualstudio.com/docs/agents/reference/workspace-context) · [Monitor agent usage with OpenTelemetry](https://code.visualstudio.com/docs/agents/guides/monitoring-agents)
- GitHub — [Private & hybrid indices](https://docs.github.com/en/copilot/concepts/prompting-and-context/repository-indexing) · [Repository indexing](https://docs.github.com/en/copilot/concepts/prompting-and-context/repository-indexing) · [Copilot usage metrics](https://docs.github.com/en/copilot/concepts/billing-and-usage/copilot-usage-metrics) · [Copilot CLI command reference (`/usage`)](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference)

**Chốt:** indexing là nơi agent *tìm*, context window là những gì model *thấy*, telemetry là con số bạn *đo được* — gọi đúng ba cái tên ấy thì "repo to quá" và "tiền đi đâu" hết là chuyện bí ẩn, và mỗi tuần bạn lại đổi được một số liệu thành đúng một hành động.
