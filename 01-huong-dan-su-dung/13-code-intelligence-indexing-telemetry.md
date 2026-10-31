# 13 — Code Intelligence, Indexing & Telemetry: `@workspace` Hiểu Cả Repo Bạn

> **Dành cho:** dev đã dùng Copilot Chat nhưng `@workspace` hay trả lời chung chung, và admin/tech lead muốn đọc được index + usage của team (bài 13 series 01).
> **Vấn đề:** repo lớn mà không index thì chat chỉ đoán từ vài file đang mở; AI Credits hết mà không nhìn dashboard thì chỉ đoán ai ngốn cái gì.
> **Đọc xong:** bật được codebase indexing (Business/Enterprise), dùng `@workspace` + semantic search đúng cách, nối knowledge base, hiểu synergy LSP + Copilot, và đọc được audit log + usage dashboard.

## Mục tiêu bài học

- Dùng `@workspace` + semantic search để hỏi cả repo mà không bị trả lời chung chung.
- Bật + cấu hình codebase indexing (Business/Enterprise), gồm content exclusion TRƯỚC khi bật.
- Biết khi nào cần knowledge base và vì sao LSP là lớp kiểm chứng bắt buộc cho retrieve.
- Đọc được audit log + usage dashboard và biến số liệu thành đúng 1 hành động mỗi tuần.

---

## 1. Vì sao index + telemetry?

Hai lớp giải quyết 2 vấn đề khác nhau:

| Vấn đề | Công cụ | Nôm na |
|---|---|---|
| `@workspace` trả lời chung chung | **Codebase indexing** (Business/Enterprise): vector index cả repo → retrieve đúng 5–10 chunks | Thư viện có mục lục thay vì đọc bừa cả kho |
| AI Credits hết nhanh mà không biết vì sao | **Telemetry** (audit logs + usage dashboards): ai dùng gì, model nào ngốn | Sao kê thay vì đoán mò |

```text
Không index:     mở 3 files → hỏi @workspace → trả lời chung chung, thiếu db layer
Có index:        hỏi 1 câu → retrieve auth.ts + session.ts + migration → trả lời đúng graph
Không telemetry: "sao credits hết nhanh?" → đoán
Có telemetry:    dashboard: agent mode × model mạnh = 70% AI Credits → biết kẻ ngốn
# Quy tắc: repo > 50 files mà chưa bật indexing là tự handicap.
#          AI Credits hết mà chưa nhìn dashboard là đoán mò.
```

---

## 2. `@workspace` hoạt động thế nào

`@workspace` là chat participant đại diện cho cả repo — Copilot KHÔNG đọc toàn bộ repo mà retrieve top chunks liên quan từ index (embeddings + keyword hybrid), rồi đưa vào context trả lời.

```text
@workspace trong apps/api, flow POST /login chạy qua những files nào?
# Kỳ vọng: trả ≤10 files, mỗi file 1 dòng lý do, kèm file:dòng.
```

**Index ở đâu?**

| Tiêu chí | Local (Individual) | GitHub-hosted (Business/Enterprise) |
|---|---|---|
| Index ở đâu | Trên máy bạn | Phía GitHub |
| Cập nhật | Khi mở VS Code / build local | Khi push lên repo |
| Ai dùng chung | Một mình bạn | Cả org/team |
| Thêm docs ngoài code | Không | Có (knowledge bases — mục 5) |

**Khi nào `@workspace` thắng `#file`:**

| Nhu cầu | `#file` / mở tay | `@workspace` |
|---|---|---|
| Hỏi 1 file cụ thể | ✓ nhanh, chính xác | Thừa (retrieve nhiễu) |
| Flow xuyên mấy lớp | Mở tay 10 files | ✓ retrieve theo graph thật |
| Tìm pattern lặp (error handling) | Grep tay từng chỗ | ✓ semantic search cả repo |
| Repo JS thuần nhỏ (<20 files) | ✓ đủ | Không cần index |
| Monorepo 500+ files | Mở tay là chết | ✓ bắt buộc index |

**Giới hạn:** index trễ ~5 phút sau push; files trong content exclusion không được index; binary + lockfiles bị bỏ qua. Verify: `git log --oneline -3` xem giờ push — file mới chưa kịp index thì hỏi bằng `#file`.

---

## 3. Bật codebase indexing (copy-paste)

```text
# Checklist admin (github.com → Org Settings → Copilot → Policies):
[ ] Codebase indexing: ON (chọn repos thí điểm — đừng index cả org ngày đầu)
[ ] Content exclusion: cấu hình TRƯỚC khi bật index (không index .env, secrets/)
[ ] Repos thí điểm: 2–3 repos core trước, đo hit rate rồi mở rộng
[ ] Thông báo team: "push xong chờ ~5 phút index mới có code mới"

# Paths nên exclude khỏi index (admin cấu hình trên github.com):
**/.env*  **/secrets/**  **/*.pem  **/*.key  vendor/  dist/  *.min.js
# Verify exclusion (máy dev): chat "@workspace tìm chuỗi STRIPE_KEY trong .env?"
# → kỳ vọng: "không thấy / excluded". Đọc được key thật → exclusion hỏng, sửa paths.
```

```bash
# Repo settings tối ưu index (máy bạn):
# 1. .vscode/settings.json — files.exclude + search.exclude cho node_modules, dist, .next, coverage.
# 2. .gitignore sạch = index sạch (index theo git-tracked files):
git check-ignore -v dist/bundle.js node_modules/.package-lock.json   # phải ra "ignored"
# 3. Monorepo: chỉ mở package bạn làm (Add Folder to Workspace → apps/api) — index nhanh ~10x.
# VS Code: Chat → @workspace hiện "indexing..." là đang build lần đầu (repo lớn: 10–30 phút).
```

---

## 4. Semantic search: hỏi cả repo đúng cách

### 4.1. Công thức hỏi (4 mẫu copy-paste)

```text
# Mẫu 1 — flow xuyên lớp (thay grep mù):
@workspace flow POST /login chạy qua những files nào (handler → domain → db)?
Trả về ≤10 files + 1 dòng/file vì sao liên quan.

# Mẫu 2 — find references ngữ nghĩa (thay grep 200 kết quả):
@workspace liệt kê mọi call sites thật của refreshToken trong src/,
bỏ test snapshot, comment và log. Chỉ code chạy thật.

# Mẫu 3 — pattern audit (việc grep không làm được):
@workspace tìm mọi chỗ catch error mà chỉ console.log rồi nuốt (swallowed errors)
trong apps/api. Liệt kê file:dòng.

# Mẫu 4 — impact analysis trước refactor:
@workspace nếu tôi đổi signature loginWithSSO, những files nào vỡ?
Xếp theo rủi ro (trực tiếp → gián tiếp qua re-export).
```

> Mỗi câu ≤1 flow. "Giải thích cả repo" là câu hỏi không có đáp án đúng.

### 4.2. Thu hẹp scope + debug khi trả lời sai

```text
3 kỹ thuật thu hẹp:
1. Kèm đường dẫn: "@workspace trong apps/api (bỏ apps/web) auth flow dùng session hay JWT?"
2. 2 bước: @workspace định vị → #file đọc sâu ("#file src/lib/retry.ts giải thích backoff").
3. Loại test: "@workspace (bỏ qua **/*.test.ts) middleware nào chạy trước mọi route /admin?"

Debug checklist khi @workspace trả lời sai:
1. Index cũ? (push < 5 phút → hỏi lại sau hoặc #file)
2. File bị excluded? (hỏi "@workspace có thấy file X không?")
3. Câu hỏi quá rộng? (chia nhỏ, mỗi câu ≤1 flow)
4. Monorepo mở cả root? (đóng bớt folder, chỉ mở package liên quan)
```

---

## 5. Knowledge bases: ký ức team dùng chung (Enterprise)

Knowledge base là tập docs ngoài code (markdown, wiki, ADRs, runbooks) được index riêng — Copilot retrieve khi bạn hỏi. Code trả lời "làm gì", knowledge base trả lời "vì sao làm thế".

**Khi nào cần?** Team > 5 người, có ADRs/conventions, onboarding tốn 2 tuần vì "quy ước nằm trong đầu senior". Không có docs thì knowledge base rỗng — viết docs trước (ít nhất `copilot-instructions.md`, bài 03).

```bash
# Tạo (admin, github.com → Copilot → Knowledge bases):
# 1. New knowledge base → chọn repos chứa docs (docs/, .github/, wiki)
# 2. Đặt tên rõ: "backend-conventions", "payment-domain"
# 3. Gán repos nào được dùng base này (đừng gán all — nhiễu chéo domain)
```

```text
# Dùng trong chat:
@workspace theo knowledge base backend-conventions, viết API mới phải tuân thủ
những quy ước nào (error format, logging, auth)? → trích docs team, không bịa.
# Quy tắc docs: mỗi ADR ≤1 trang; runbook incident: symptom → fix → verify.
```

---

## 6. LSP + Copilot synergy

Copilot completions + chat đọc text; Language Server (LSP) hiểu types/symbols. Bật cả hai = gợi ý khớp type, jump chính xác, verify retrieve trước khi sửa.

| Nhu cầu | Chỉ Copilot | Copilot + LSP (VS Code) |
|---|---|---|
| Jump to definition | Đoán theo text | ✓ chính xác (F12 qua server) |
| Rename hàm an toàn | Sửa tay từng chỗ | ✓ F2 rename symbol cả repo |
| Diagnostics sau sửa | Chờ chạy test | ✓ gạch đỏ live (Problems panel) |
| Copilot hỏi "còn lỗi type?" | Không biết | ✓ đọc Problems panel |

```bash
# Bật LSP theo stack: TS (có sẵn) · Python (Pylance/Pyright) · Go (ext Go) ·
# Rust (rust-analyzer) · Java (Extension Pack for Java):
code --list-extensions | grep -i -E "pylance|go|rust-analyzer|redhat.java"
```

```text
# Workflow chuẩn task typed: @workspace định vị → F12 jump (def thật) →
# Edit (Copilot inline) → Problems panel xanh → focused test file đổi.
# Prompt kết hợp: "@workspace find references của refreshToken, với mỗi ref cho biết
# type signature tại đó. Chỗ nào truyền sai type?" → retrieve + verify 2 lớp chéo nhau.
```

## 7. Audit logs + usage dashboards

### 7.1. Audit logs: ai làm gì (admin)

```text
Xem: github.com → Org/Enterprise Settings → Audit log. Filters hay dùng:
  action:copilot          → mọi sự kiện Copilot
  action:copilot_policy   → ai đổi policy/exclusion
  action:copilot_seat     → ai được thêm/bớt seat
Ví dụ: "ai tắt content exclusion tuần trước?" → filter action:copilot_policy
+ time range 7 ngày → ra actor + trước/sau của policy.

gh api /orgs/<ORG>/audit-log --paginate -f per_page=100 \
  -f phrase="action:copilot" --jq '.[] | [.actor, .action, .created_at] | @tsv' \
  > /tmp/copilot-audit.tsv    # pivot count by actor/action/tuần
```

Giới hạn phải thuộc lòng: **giữ 180 ngày** (cần lâu hơn → stream sang SIEM); **không chứa prompt/session data của client** (muốn log prompt → tự gắn hook, vd CLI events → logging riêng).

### 7.2. Usage dashboards: tiền đi đâu

| Metric | Câu hỏi | Ngưỡng action |
|---|---|---|
| AI credits / user (tên cũ legacy: premium requests) | Ai ngốn nhiều nhất? | Top 5 user > 3x median → coaching |
| Requests by model | Model nào ngốn? | Model đắt > 50% requests → gate lại (bài 14) |
| Agent mode % | Agent có bị lạm dụng? | Agent cho task 1 dòng → training lại modes (bài 10) |
| Exclusion blocks | Chặn nhầm? | Tăng đột biến → paths sai (bài 15) |
| Seats vs active | Thừa seats? | Active < 50% seats 2 tháng → thu hồi |

### 7.3. Vòng lặp tối ưu hàng tuần (15 phút)

```text
# Thứ 2 hàng tuần:
# 1. Dashboard: top model + top user ngốn (5 phút)
# 2. "Ngốn có chính đáng không?" (agent refactor lớn: ok; ask typo bằng model đắt: coaching)
# 3. Fix 1 cái: gate model / hẹp scope / training (bài 14 + 15)
# Quy tắc: metrics không action là sưu tầm. Mỗi tuần fix đúng 1 cái.
```

### 7.4. OpenTelemetry export + budget controls (admin)

```jsonc
// managed-settings.json — Copilot bắn telemetry về endpoint OTLP của bạn:
// {
//   "telemetry": {
//     "enabled": true,
//     "endpoint": "https://otel.example.com/v1/traces",
//     "protocol": "http/json",        // hoặc "http/protobuf"
//     "captureContent": false,        // có gửi cả nội dung prompt?
//     "lockCaptureContent": true,     // khóa để user không override
//     "serviceName": "copilot-cli",
//     "resourceAttributes": { "team": "payments" }
//   }
// }
// Áp dụng cho: Copilot CLI, VS Code, Copilot app, cloud agent, JetBrains.
// Verify: sau 1 phiên, log phải về đúng endpoint khai.
```

```text
Budget controls — chặn AI Credits chạy vượt (checklist admin):
[ ] Paid usage policy (cho phép chi vượt credit kèm theo) = BẬT MẶC ĐỊNH
    → muốn cap chi phí phải TẮT đi.
[ ] Hết credit kèm theo → "additional usage budget" áp dụng (spend cap cấu hình được).
[ ] User hết limit → xin tăng budget; admin approve/adjust/deny trong settings
    (GA Business/Enterprise 09/2026, không gồm enterprise managed users).
[ ] Tiết kiệm hợp pháp: auto model selection giảm 10% cho plan trả phí
    (Chat, CLI, Copilot app, cloud agent).
```

---

## 8. Pitfalls + bài tập

| Pitfall | Fix |
|---|---|
| Hỏi `@workspace` ngay sau push | Chờ ~5 phút hoặc `#file` file mới trực tiếp |
| Exclusion chặn file cần (exclude cả `src/` nhầm) | Verify bằng câu hỏi `.env`, sửa paths |
| Mở cả monorepo root | Chỉ mở package đang làm |
| Câu hỏi cả repo 1 lúc | Chia nhỏ theo flow, mỗi câu ≤1 flow |
| Không docs mà đòi knowledge base | Viết `copilot-instructions.md` + ADRs trước (bài 03) |
| Tin `@workspace` thay LSP verify | F12 + Problems panel trước khi sửa |
| Dashboard đẹp không action | Mỗi tuần fix top 1 ngốn (mục 7.3) |

**❌ SAI / ✅ ĐÚNG nhìn là nhớ:**

```text
❌ SAI: vừa push xong hỏi "@workspace hàm mới nằm đâu?" → "không thấy" → kết luận Copilot dở
✅ ĐÚNG: chờ index ~5 phút hoặc #file; index là ảnh chụp có độ trễ

❌ SAI: retrieve ra 1 file → sửa luôn theo lời Copilot
✅ ĐÚNG: F12 jump tới định nghĩa thật + Problems panel — retrieve có thể "gần đúng",
        chỉ LSP mới xác nhận đúng symbol/type

❌ SAI: mở dashboard gật gù rồi đóng tab
✅ ĐÚNG: mỗi tuần fix đúng 1 cái (gate model / hẹp scope / training) + đo lại sau 1 tuần
```

**Bài tập nhỏ:** (1) Chạy mẫu 1 + mẫu 3 (mục 4.1) kèm scope hẹp; so số files đọc với grep tay (kỳ vọng giảm 5–10x); 1 hit sai → debug checklist. (2) F12 jump 3 hàm @workspace tìm được; F2 rename thử + `git diff --stat`; chèn lỗi type → Problems bắt trong bao lâu. (3) Mở usage dashboard: top model + top 3 user ngốn; audit log `action:copilot_policy`: ai đổi lần cuối; đề xuất 1 fix + metric verify sau 1 tuần.

---

## 9. So sánh với Claude Code + link chéo

| Việc | Copilot | Claude Code |
|---|---|---|
| Hiểu cả repo | Codebase indexing + `@workspace` | Agentic search (grep/glob khi cần), không cần index trước |
| Docs ngoài code | Enterprise knowledge bases | Không tương đương — docs trong repo (`CLAUDE.md`) |
| Content exclusion cấp org | Cấu hình server-side, chặn trước khi index | Không có cấp org; chặn ở phía truy cập |
| Semantic search | Index vector + keyword hybrid | Tìm agentic theo ngữ cảnh |
| Audit / usage | Org/enterprise audit log + usage dashboard | Anthropic Console usage/analytics |
| OpenTelemetry | `managed-settings.json` → `telemetry.endpoint` | Có hỗ trợ OTel |

> Copilot (Business/Enterprise) có cấu hình quản trị rõ ràng hơn cho index + knowledge base + exclusion; Claude Code mạnh ở việc dò file theo yêu cầu không cần dựng index. LSP và telemetry là lớp kiểm chứng/quan sát ở cả hai — không phải nguồn chân lý.

**Link chéo:** Bài 03 (copilot-instructions.md — docs tối thiểu cho knowledge base) · Bài 04 (`@workspace`, `#file`, `#selection` đầy đủ) · Bài 07 (content exclusion cấu hình chi tiết) · Bài 08 (nối tools ngoài khi `@workspace` không đủ) · Bài 10 (approval gate trước khi agent chạy retrieve) · Bài 14 (model nào ngốn credits → gate) · Bài 15 (exclusion là tầng 1, secret scanning là tầng 2) · Bài 16 (tools retrieve thêm có đáng tin không).

> **Chốt bài 13:** index cho Copilot cái mục lục của repo, telemetry cho bạn cái hóa đơn của team — và cả hai đều vô dụng nếu bạn không verify bằng LSP rồi biến số liệu thành đúng một hành động mỗi tuần.
