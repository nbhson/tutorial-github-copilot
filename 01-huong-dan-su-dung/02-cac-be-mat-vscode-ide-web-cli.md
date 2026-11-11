# 02 — Các Bề Mặt Copilot: VS Code, IDE, Web, CLI

> **Dành cho:** dev đã cài xong Copilot (bài 01), muốn biết task nào nên làm ở bề mặt nào.
> **Vấn đề:** không biết code chạy ở đâu (máy bạn hay cloud), config nào được dùng, khi nào nên giao việc cho **Copilot cloud agent**.
> **Đọc xong:** chọn đúng bề mặt cho từng task; giải thích rõ **Local / Copilot / Cloud / Claude / Codex** trong Session Target; giao việc cho cloud agent ra PR; dùng Copilot CLI an toàn.
> **Thời gian:** ~25 phút. *(Bài 02 của series)*
>
> **Lưu ý 2026:** bài lấy **Copilot harness** làm mặc định của cả khoá; **Local harness** là legacy — chỉ xuất hiện trong các block ⚠️ so sánh. Docs gọi picker là **Choose an agent harness**: cùng một chỗ bạn chọn cả harness lẫn nơi chạy.

## Mục tiêu bài học

Đọc xong quay lại đây tự kiểm tra — gạch nào trả lời không được thì quay lại mục tương ứng.

- Trả lời được trong 10 giây, cho mỗi task: **code chạy ở đâu và agent thấy được gì**.
- Dùng đúng Session Target: chọn harness + nơi chạy, nhớ **Cloud KHÔNG phải harness** — nó là execution target chạy Copilot harness.
- Giao 1 task độc lập cho **Copilot cloud agent** bằng mẫu issue có scope + verify, rồi review PR.
- Phân biệt 3 thứ hay nhầm: **Copilot CLI** ≠ **Local harness** ≠ `gh copilot` (extension cộng đồng).

> **Tóm gọn 1 câu:** Sau bài này, nhìn task nào bạn cũng biết ngay nên chạy nó ở "quầy" nào — và "xe + tài xế" là bộ nào.

---

## 1. Khái niệm cốt lõi: bề mặt là nơi bạn gặp Copilot

**1 câu định nghĩa:** "bề mặt" (surface) là nơi bạn gặp Copilot: VS Code, Visual Studio / JetBrains / Neovim, github.com, Copilot CLI, điện thoại.

**Ví dụ:** cũng yêu cầu "thêm rate-limit" — làm ở VS Code thì agent chạy `npm test` trên máy bạn; giao cloud agent thì nó chạy CI trên hạ tầng GitHub.

| Nhóm | Nơi code chạy | Agent thấy được gì | Gồm |
|---|---|---|---|
| **Local (máy bạn)** | Máy của bạn | File máy, `.env`, DB local, MCP local, setting editor | VS Code, Visual Studio, JetBrains, Neovim, Copilot CLI |
| **Cloud (GitHub)** | Máy chủ GitHub/provider | Chỉ code trong repo + CI; **không** thấy setting local, `.env`, DB máy bạn | github.com chat, Copilot cloud agent, github.dev |

> **Cách đọc bảng này:** cột giữa là then chốt — "agent thấy được gì" quyết định task làm nổi hay không, nên trước mỗi task hãy hỏi "code chạy ở đâu, agent thấy gì" rồi mới chọn quầy.

**Vì sao quan trọng?** Nó quyết định chia việc: task 5 phút (fix typo) cần độ trễ thấp → local; task 2 giờ (migrate, refactor 50 file) cần chạy tiếp khi gập laptop → cloud. Không bề mặt nào thắng mọi trường hợp.

> **Tóm gọn 1 câu:** Trước mỗi task hỏi "code chạy ở đâu, agent thấy gì" — trả lời xong là biết chọn Local hay Cloud.

## 2. Bảng quyết định: chọn bề mặt trong 30 giây

| Bề mặt | Nơi code chạy | Config nào được dùng | Khi nào dùng |
|---|---|---|---|
| **VS Code** | Máy bạn | `.github/` + `.mcp.json` (Copilot harness) hoặc `.vscode/` (Local) | Mặc định; agent multi-file + terminal |
| **Visual Studio** | Máy bạn | `.github/` (agent hạn chế) | Dev .NET/C++ hàng ngày |
| **JetBrains** | Máy bạn | `.github/` (agent hạn chế) | Java/Kotlin/Python/Go hàng ngày |
| **github.com chat** | Cloud (chỉ đọc/hỏi) | Chỉ repo | Hỏi/review khi không có máy dev |
| **Copilot cloud agent** | Hạ tầng cloud GitHub | Chỉ repo + cloud env/CI | Task độc lập, chạy qua đêm → PR |
| **github.dev** | Browser | Chỉ repo | Sửa nhanh không clone |
| **Copilot CLI** | Terminal bạn | `.mcp.json` / repo config | Agentic trong terminal + gợi ý lệnh shell |

> **Cách đọc bảng này:** hàng nào "Nơi code chạy" là "Máy bạn" thì được dùng tài nguyên máy bạn; hàng cloud chỉ giới hạn trong repo. Cây hỏi 10 giây đã có ở **bài 00 §1.1** — khỏi dựng lại cây trùng nhau.

```text
3 tầng config, ap dung theo thu tu uu tien:
User      -> ap dung moi repo ban mo tren may nay
Org       -> chinh sach cua cong ty, override User
Workspace (`.github/`, `.vscode/`) -> duoc commit, ap cho tung repo
```

```text
5 task mau:
Task 1: "Giải thích hàm này" (5 phút)             -> Ask ở IDE bạn đang mở
Task 2: "Thêm rate-limit + test + chạy verify"    -> Agent (Copilot harness) ở VS Code
Task 3: "Fix issue độc lập, tạo PR, tối đi ngủ"   -> Copilot cloud agent (assign issue)
Task 4: "Quên flag docker/git"                    -> gh copilot suggest/explain (extension cộng đồng)
Task 5: "Review PR của cloud agent lúc đang cafe" -> github.com chat / Mobile
```

> **Tóm gọn 1 câu:** Bảng trên là tầng lọc thứ nhất: hỏi "cần môi trường máy bạn không", hỏi "cần chạy tiếp khi tắt máy không", cuối cùng mới tính tới terminal.

## 3. Session Target: 2 câu hỏi trong 1 picker

**1 câu định nghĩa:** **Session Target** là picker trong VS Code Chat, trả lời cùng lúc 2 câu hỏi: câu 1 "xe + tài xế nào" = **harness** (Copilot / Local / Claude / Codex), câu 2 "chạy ở đâu" = **execution target** (đổi máy giữa máy bạn và cloud).

**Nôm na:** harness là "xe + tài xế", execution target là "đường chạy". Cloud **không phải một harness** — cloud là chỗ chạy của Copilot harness; docs ghi rõ trong danh sách tính năng cloud agent có feature `cloud-sessions`.

**Ví dụ:** bạn muốn Copilot tự chạy `pytest` trên venv của máy → đừng **đổi máy** sang Cloud; chọn Cloud thì `pytest` chạy trên runner — venv máy bạn vô hình với nó.

| Harness | Chạy ở đâu | Thấy gì | File config |
|---|---|---|---|
| **Copilot** (mặc định) | Máy bạn **hoặc** cloud | repo + MCP + customizations `.github/` | `.github/` + `.mcp.json` |
| **Local** (legacy) | chỉ máy bạn | như trên + cache/memories local | `.vscode/*` (legacy) |
| **Claude** / **Codex** (bên thứ ba) | **cloud** — remote service | **chỉ code trong repo + CI** | customizations `.github/` của Copilot |

Trích nguyên văn docs: *"the Claude and Codex experience is focused on the code and CI within your repository — it does not have access to the settings, extensions, MCP servers, or other resources on your machine."*

**Hiểu lầm hay gặp:**

| Hiểu lầm | Thực tế |
|---|---|
| Cloud là một harness | Cloud là execution target chạy Copilot harness (feature `cloud-sessions`) |
| Agent cloud "nhìn máy em" | Cloud không thấy file `.env` hay setting local của bạn |

> **Tip:** harness và nơi chạy độc lập nhau — cùng Copilot harness nhưng mỗi lần có thể chọn máy bạn hoặc cloud; cloud agent chat chỉ tồn tại khi target đang là cloud. Lệnh đổi harness giữa session: `/model` — chi tiết [`/model`](commands/copilot/model-agent/session-target/README.md).

**Lỗi thường gặp:** chọn bừa harness bên thứ ba cho task cần DB local → agent chỉ thấy repo, fail. ✅ Đổi về Copilot + máy bạn trước khi chạy lệnh verify.

> **Tóm gọn 1 câu:** Một picker trả lời 2 câu hỏi — "xe + tài xế" (harness) và "đường chạy" (nơi chạy); mọi task của cloud agent chỉ thấy repo.

## 4. Chạy agent trên cloud: assign issue là xong

**1 câu định nghĩa:** giao việc cho **Copilot cloud agent** trên hạ tầng GitHub, qua 2 cửa: chat ở github.com / mobile, hoặc **assign issue** cho `copilot` — docs gọi việc từ VS Code là *hand off a session* qua picker.

**Làm đúng trong 4 bước:**
1. Repo có Copilot cloud agent (settings → *Allow Copilot cloud agent access*), bật access repo.
2. Draft issue: 1 mục tiêu, scope (file nào đụng, file nào không), cách verify (lệnh test), definition of done.
3. Assign issue cho `copilot` — hoặc từ chat VS Code, chọn target cloud rồi **hand off a session**.
4. Review PR như PR của đồng nghiệp: test có xanh không, scope có vượt `CODEOWNERS` không, có bịa API không.

```text
Mau issue — copy ve repo cua ban, dien cho trong:

Title:   Them email validation cho form dang ky
Goal:    Chan email sai dinh dang o form dang ky
Scope:   `src/auth.ts`, `src/register.tsx`; KHONG doi database
Verify:  `npm test -- auth`, chay demo tren `localhost:3000`
Definition of done: PR co test moi + screenshot truong hop sai
```

**Lỗi thường gặp:** issue mơ hồ ("làm lại auth cho sạch") → agent hỏi lại hoặc sửa tràn lan. ✅ Scope 1 mục tiêu + file được đụng + lệnh verify.

> **Billing:** cloud agent **và** chat trên github.com đều tiêu **AI credits** (1 credit = $0.01, per-token) — còn lại bao nhiêu xem ở Settings → Copilot.

> **Tóm gọn 1 câu:** Task độc lập + scope rõ + lệnh verify → assign issue → review PR.

## 5. Chat trên github.com + Copilot cloud agent

**1 câu định nghĩa:** trên github.com có 2 chế độ: **Chat** (hỏi repo/PR/code, chạy trên web, chỉ đọc) và **Copilot cloud agent** (tự làm task, mở PR).

| | Chat ở github.com | Copilot cloud agent |
|---|---|---|
| Code chạy ở đâu | Cloud, chế độ **chỉ đọc** | Cloud, có sandbox + branch + PR |
| Được làm gì | Hỏi, giải thích code/PR, đọc issue khác trong repo | Sửa code, chạy test, tạo PR; **không** bấm merge hộ |

**Cấu hình cho agent cloud:** env trong cloud agent settings; secrets **kế thừa từ Actions của repo**, cần bật cho agent. **Branch bảo vệ:** PR của agent phải qua CI + review như mọi PR — `CODEOWNERS` và required checks **không ngoại lệ**.

**Lỗi thường gặp:** chờ cloud agent merge hộ → không bao giờ xảy ra. ✅ Merge luôn là việc của người; đọc code trước khi bấm.

> **Tóm gọn 1 câu:** Chat để đọc và hiểu; cloud agent để làm ra PR — vẫn bắt buộc qua review.

## 6. Các IDE khác: JetBrains, Visual Studio, Neovim

**1 câu định nghĩa:** Copilot chạy trong Visual Studio, JetBrains (IDEA/PyCharm/GoLand/WebStorm...), Neovim; cùng `.github/` như VS Code nhưng mức hỗ trợ agent khác nhau.

| IDE | Mạnh nhất | Agent | Hay vấp |
|---|---|---|---|
| **JetBrains** | Java/Kotlin/Python/Go | có, hạn chế hơn VS Code | config VS Code không migrate tự động |
| **Visual Studio** | .NET, C++ | có, hạn chế hơn | feature sau VS Code một bậc |
| **Neovim** | gõ nhanh, fix nhỏ | chủ yếu autocomplete — không có agent picker như VS Code | kỳ vọng Chat như IDE desktop |

> **Đọc bảng này:** VS Code dẫn đầu tính năng — khi so sánh IDE, tìm docs JetBrains/MS rồi hãy kết luận (kỷ luật đối chiếu docs, bài 00 §4). File MCP cấu hình chung vẫn là `.mcp.json` ở thư mục project — docs VS Code hướng dẫn dùng cùng file cho các editor.

> **Tóm gọn 1 câu:** VS Code dẫn đầu; JetBrains/VS mạnh trong hệ sinh thái riêng; Neovim để gõ nhanh và fix nhỏ.

## 7. Copilot CLI: agent trong terminal + gợi ý lệnh

**1 câu định nghĩa:** **Copilot CLI** (github.com/github/copilot-cli) là agent chạy trong terminal (lệnh `copilot`). Đừng nhầm với **`gh copilot`** (extension cộng đồng github.com/github/gh-copilot): chỉ `suggest` + `explain`.

**Ví dụ:** `gh copilot suggest "undo last commit"` → gợi ý `git reset --soft HEAD~1` (bạn tự chạy); Copilot CLI thì tự đọc repo, sửa file, chạy lệnh.

**Làm đúng trong 3 bước:**
1. Cài: `npm install -g @github/copilot` (hoặc brew) → chạy `copilot` lần đầu để auth.
2. Lệnh nền: `show tools` xem tool, `/allow` phân quyền, thêm MCP bằng `copilot mcp add`; customizations `.github/` dùng chung (bài 17).
3. **Luôn review trước khi chạy:** Copilot CLI *executes shell commands you provide or that it generates* — docs khuyến nghị kiểm tra lệnh generate tự động.

**Copilot CLI ≠ Local harness:** CLI là **terminal surface** đang phát triển chính; Local là **bộ máy cũ trong VS Code Chat** (legacy, config `.vscode/*`). Docs viết nguyên văn: *"Local harness is not Copilot CLI."*

> Gợi ý lệnh shell trong CLI (nhận bằng **Tab**, mở rộng bằng Ctrl+Space) chạy **offline, không gửi prompt đi đâu**; còn Windows Terminal chỉ là bề mặt *chat* với cloud agent (**Ctrl+Alt+Space** mở panel).

> **Tóm gọn 1 câu:** Copilot CLI làm việc trong terminal, `gh copilot` chỉ giải thích/gợi ý lệnh, Local harness là bộ máy cũ trong VS Code Chat — ba thứ khác nhau.

## Lỗi thường gặp (❌ SAI / ✅ ĐÚNG)

- ❌ "Local harness xịn nhất nên mọi bài em dùng Local."
  ✅ Copilot harness là mặc định của khoá; Local chỉ khi bài cố tình dạy `.vscode/*`.
- ❌ Chọn cloud cho task cần DB local.
  ✅ Cloud không thấy `.env` / DB máy bạn — chạy local hoặc đổi task.
- ❌ `gh copilot suggest` rồi than "nó không chịu làm".
  ✅ Nó chỉ gợi ý — muốn tự làm thì dùng Copilot CLI.

## Best practices

- Ghi rõ **target** ở đầu session (đang local hay cloud) — đừng mặc định "biết rồi".
- Task cloud đầu tiên: việc độc lập, scope 1-2 file, có lệnh verify; review PR của cloud agent bằng checklist như review người, có người thứ hai approve.

## Bài tập

- [ ] Mở picker Session Target, chụp 2 trạng thái (Copilot + Local) rồi giải thích khác biệt bằng **3 câu trở xuống** — file: `examples/02-1-session-target-picker.md`.
- [ ] Viết 1 issue theo mẫu §4 vào repo test rồi assign `copilot`, nhận về 1 PR.
- [ ] Chạy `gh copilot explain "git reflog"`, sau đó nói rõ vì sao nó chưa phải agent.

## Link qua

- **Lý do tồn tại của VS Code Chat:** bài 01 §2.
- **Hỗ trợ IDE khác, tính năng mới nhất:** docs VS Code *agent harnesses* + *AI features cheat sheet* (dưới Reference).
- **Sắp tới:** bài 03 dạy `AGENTS.md` — file mà **cả 4 harness cùng đọc**.

## Reference

- [VS Code — Agent harnesses](https://code.visualstudio.com/docs/agents/concepts/agent-harnesses) — khái niệm harness, "Local harness is not Copilot CLI"
- [VS Code — Run agent harnesses in VS Code](https://code.visualstudio.com/docs/agents/run/agent-harnesses) — chạy Copilot/Local/Claude/Codex, đổi harness bằng `/model`
- [VS Code — AI features cheat sheet](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet) — bề mặt nào dùng được tính năng nào
- [VS Code — Move your Copilot sessions to the cloud](https://code.visualstudio.com/docs/agents/run/move-to-copilot) — hand off session, cloud chat khi target là cloud
- [GitHub — About Copilot cloud agent](https://docs.github.com/en/copilot/concepts/agents/cloud-agent/about-cloud-agent) — assign issue, PR, secrets từ Actions
- [github.com/github/copilot-cli](https://github.com/github/copilot-cli) — Copilot CLI: Tab, gợi ý offline, `/allow`
- [github.com/github/gh-copilot](https://github.com/github/gh-copilot) — extension `gh copilot` cộng đồng
- [GitHub — Models and pricing](https://docs.github.com/en/copilot/reference/copilot-billing/models-and-pricing) — AI credits, giá per-token

**Chốt:** giờ bạn đã chọn đúng "quầy" (bề mặt) cho từng task. Câu hỏi kế tiếp: *config để ở đâu*? — bài 03 trả lời.
