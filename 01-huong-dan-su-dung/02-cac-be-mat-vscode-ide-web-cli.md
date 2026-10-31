# 02 — Các Bề Mặt Copilot: VS Code, IDE, Web, CLI

> **Dành cho:** dev đã cài xong Copilot (bài 01), muốn biết task nào nên làm ở bề mặt nào.
> **Vấn đề:** không biết code chạy ở đâu (máy bạn hay cloud), config nào được dùng, khi nào nên giao việc cho coding agent.
> **Đọc xong:** chọn đúng bề mặt cho từng task, biết code chạy ở đâu + config nào được dùng, phân biệt rõ Local / Copilot / Cloud (Session Target), setup được coding agent trên github.com và Copilot CLI.
> **Thời gian:** ~25 phút. *(Bài 02 của series)*

## Mục tiêu bài học

- Trả lời được trong 10 giây, cho mỗi task: **code chạy ở đâu và agent thấy được gì**.
- Phân biệt **local agent** vs **coding agent cloud** và biết task nào hợp bên nào.
- Phân biệt **Session Target (Local / Copilot / Cloud)** — công tắc bên trong VS Code Chat.
- Dùng **Copilot CLI** an toàn: `explain` trước, chạy sau với lệnh nguy hiểm.

---

## 1. Khái niệm cốt lõi

**1 câu định nghĩa:** "bề mặt" (surface) là nơi bạn gặp Copilot — VS Code, web GitHub, terminal, điện thoại.

**Nôm na:** cùng một đầu bếp, nhưng ông ấy có nhiều quầy: quầy tại bàn (VS Code), giao tận nhà (coding agent trên cloud), quầy take-away (CLI). Bạn không chọn đầu bếp, bạn chọn chỗ làm việc.

**Ví dụ:** cùng yêu cầu "thêm rate-limit", làm ở VS Code thì nó chạy `npm test` trên máy bạn; giao coding agent thì nó chạy CI trên cloud.

### Câu hỏi duy nhất cần hỏi: **"Code sẽ chạy ở đâu, và agent thấy được gì?"**

| Nhóm | Nơi code chạy | Agent thấy được gì | Gồm |
|---|---|---|---|
| **Local** (máy bạn) | Trên máy của bạn | File máy bạn, `.env`, DB local, MCP local, setting VS Code | VS Code, Visual Studio, JetBrains, Neovim, Copilot CLI, GH Desktop |
| **Cloud** (GitHub) | Máy chủ GitHub/provider | Chỉ code trong repo + CI. **Không** thấy setting local, `.env`, DB máy bạn | github.com chat, coding agent, github.dev |

Đây là lý do GitHub tách: task 5 phút (fix typo) cần độ trễ thấp → local. Task 2 giờ (migrate, refactor 50 file) cần máy chạy tiếp khi bạn gập laptop → cloud. Không bề mặt nào thắng mọi trường hợp.

**Nếu làm sai thì sao?** Giao coding agent task cần DB local → nó chạy mà không thấy DB → fail chắc chắn. Ngược lại, việc 5 phút đẩy lên cloud thì chờ lâu hơn tự làm.

> Phân biệt 2 từ: **bề mặt** = nơi bạn gặp Copilot (phạm vi cả bài); **Session Target** = công tắc *bên trong* VS Code Chat chọn harness + nơi chạy (Local/Copilot/Cloud — mục 3.4).

---

## 2. Bảng quyết định nhanh + 5 task mẫu

| Bề mặt | Nơi code chạy | Config nào được dùng | Khi nào dùng |
|---|---|---|---|
| **VS Code** | Máy bạn | `.github/` + `.vscode/` + MCP local | Mặc định; agent multi-file + terminal |
| **Visual Studio** | Máy bạn | `.github/` (agent hạn chế) | Dev .NET/C++ hàng ngày |
| **JetBrains** | Máy bạn | `.github/` (agent hạn chế) | Java/Kotlin/Python/Go hàng ngày |
| **Neovim** | Máy bạn | `.github/` (chủ yếu autocomplete) | Gõ nhanh, fix nhỏ |
| **github.com chat** | Cloud (chỉ đọc/hỏi) | Chỉ repo | Hỏi/review khi không có máy dev |
| **Coding agent** | GitHub cloud VM | Chỉ repo + cloud env/CI | Task độc lập, chạy qua đêm → PR |
| **github.dev** | Browser | Chỉ repo | Sửa nhanh không clone |
| **Mobile** | Điện thoại | Chỉ repo | Đọc/giải thích PR ngoài giờ |
| **Copilot CLI** | Terminal bạn | `.mcp.json` / repo config | Agentic trong terminal + gợi ý lệnh shell |
| **GH Desktop** | Máy bạn (GUI git) | Không | Commit message/PR summary nhanh |

```text
5 task mẫu:
Task 1: "Giải thích hàm này" (5 phút)              -> Ask mode ở IDE bạn đang mở
Task 2: "Thêm rate-limit + test + chạy verify"      -> Agent mode VS Code (mạnh nhất)
Task 3: "Fix issue độc lập, tạo PR, tối đi ngủ"      -> Coding agent (assign issue)
Task 4: "Quên flag docker/git"                       -> gh copilot suggest/explain ngay terminal
Task 5: "Review PR của coding agent lúc đang cafe"  -> github.com chat / Mobile
```

```text
Cây hỏi 10 giây (dán lên màn hình):
1. Task này có cần môi trường máy bạn không? (.env, DB local, MCP local)
   Có  -> VS Code (Local). Không -> hỏi tiếp
2. Cần chạy tiếp khi tôi tắt máy / đi ngủ không?
   Có  -> coding agent (Cloud). Không -> hỏi tiếp
3. Chỉ quên cách gõ lệnh shell thôi à?
   Có  -> Copilot CLI, đừng mở IDE. Không -> về câu 1
```

---

## 3. VS Code — bề mặt mạnh nhất

Agent mode full tools: read/edit/search/terminal/MCP trong 1 loop; model picker + mode picker (Ask/Edit/Agent) ngay trong Chat; đọc config repo đầy đủ (`.github/copilot-instructions.md`, `*.instructions.md`, `.github/prompts/`, `.github/agents/`, `.vscode/mcp.json`); inline diff + Accept/Reject từng hunk.

| Mode | Sửa file? | Chạy terminal? | Khi dùng |
|---|---|---|---|
| **Ask** | Không | Không | Hỏi, giải thích, tra cứu (`@workspace` + `#file`) |
| **Edit** | Có (files bạn chọn) | Không/hạn chế | Sửa có scope rõ, bạn kiểm soát files |
| **Agent** | Có (tự tìm files) | Có | Task mở, multi-file, cần verify bằng test |

```text
# Flow khuyến nghị: chưa rõ -> Ask; rõ scope -> Edit; việc mở -> Agent.
# Ask:  "@workspace @file:package.json repo này chạy dev/test/lint bằng lệnh nào?"
# Edit: "#file:src/routes/login.ts #file:src/middleware/auth.ts
#        Thêm rate-limit 5 req/phút cho POST /login dùng express-rate-limit.
#        Giữ nguyên response shape { code, message, requestId }."
# Agent:"Trong apps/api, POST /orders crash khi thiếu customerId.
#        Tìm root cause, fix, thêm regression test, chạy npm test. Đừng sửa ngoài scope."

# Phím tắt đáng nhớ:
Ctrl+Alt+I            mở Copilot Chat panel
Tab                   nhận ghost text (autocomplete)
/  @  #               trong Chat input: lệnh / participant / biến
Up/Down trong input   lịch sử prompt
```

### 3.1. Session Target: Local / Copilot / Cloud (phần dễ nhầm nhất)

**Nôm na:** Model = chọn **tài xế** (bộ não). Session Target = chọn **loại xe + nơi chạy** (ai thực thi tool, chạy ở đâu). Đổi target **không phải** đổi model — model đổi ở model picker.

| Target | Chạy ở đâu | Truy cập code | Khi dùng |
|---|---|---|---|
| **Local** | Extension host VS Code (máy bạn), **trong cửa sổ hiện tại** | Workspace hiện tại | Cần tool built-in / tool extension / model cấu hình trong VS Code |
| **Copilot** | Agent Host (máy bạn / remote / Dev Container), **chạy nền** | Folder hiện tại hoặc worktree cô lập | Chạy nền, nhiều phiên song song, mở lại ở cửa sổ/browser khác |
| **Cloud** | Hạ tầng remote của provider | 1 GitHub repo → mở PR | Task gọn, async, cần team review |
| **Claude / Codex** | Máy bạn (hoặc Agent Host, experimental) | Folder hiện tại hoặc worktree | Đã quen workflow + permission của provider đó |

**Điểm khác Local vs Copilot:** cả hai có thể chạy trên máy bạn, nhưng **Local** nằm trong extension host (tương tác, 1 cửa sổ, dùng tool của VS Code/extension), còn **Copilot** chạy trên **Agent Host** (nền tảng Copilot SDK) — chạy nền, nhiều phiên song song, session do host sở hữu nên mở lại được ở nơi khác.

```text
# Cách dùng:
# - Đáy khung Chat: Session Target -> chọn Local / Copilot / Cloud / Claude / Codex...
# - Agent Sessions sidebar: xem mọi session ở 1 chỗ (Local + Copilot + Cloud).
# - Handoff: đổi target giữa phiên, mang theo history + context (CHỈ khởi tạo từ session Local).
# - Copilot -> Cloud nhanh: trong session Copilot gõ /delegate.
# Verify: list target chỉ hiện cái khả dụng ở cửa sổ hiện tại.
# Không thấy Copilot/Cloud -> check đăng nhập GitHub + extension + policy.
```

---

## 4. Các IDE khác: Visual Studio, JetBrains, Neovim

**Visual Studio (.NET/C++):** mạnh ghost text + Chat cho solution lớn, hiểu MSBuild/C# tốt; agent mode hạn chế terminal tools. Verify: mở `.cs` → ghost text; View → Copilot Chat; thử Edit nhỏ 1 method.

**JetBrains:** mạnh ghost text + Chat hiểu project model (module indexes); agent terminal tool hạn chế. Dev Java/Kotlin/Python/Go dùng hàng ngày ổn.

**Neovim:**

```bash
# Mạnh: gõ nhanh, nhẹ, ghost text ngay trong buffer. Yếu: không agent mode full.
:Copilot status    # kiểm tra
:Copilot enable    # bật lại
# Khi chuyển: task cần đọc nhiều file + chạy test -> sang VS Code.
```

> Cố ép agent mode ở IDE thiếu terminal tool rồi kết luận "Copilot dở" là hiểu nhầm tốn thời gian — chuyển bề mặt rẻ hơn cãi với tool.

---

## 5. Cloud: github.com chat + coding agent

### 5.1. github.com Chat (hỏi trên web)

```text
Vào repo trên github.com -> icon Copilot (góc phải) -> hỏi bằng tiếng Việt/Anh.
Dùng được: hỏi toàn repo, đọc file/PR/issue. Kể cả GPT-5.2-Codex (GA 01/2026).
Mạnh: không cần setup local, hỏi từ điện thoại được.
Yếu: không thấy settings local, không chạy terminal local, không MCP local.
```

### 5.2. Coding agent (assign issue → branch → PR)

- **1 câu:** Copilot chạy trên máy cloud của GitHub, tự code rồi mở PR khi bạn assign issue cho nó.
- **Nôm na:** gửi xe vào gara qua đêm — tối giao chìa khóa (issue), sáng nhận xe đã sửa (PR).
- **Ví dụ:** issue "Fix crash POST /orders" → agent tạo branch `copilot/fix-orders-422`, sửa `orders.ts`, chạy CI, mở PR link về issue. Từ 03/2026 agent khởi động nhanh hơn 50% — feedback loop ngắn hơn hẳn.

```text
Flow chuẩn:
1. Tạo issue mô tả rõ: mục tiêu + scope files + lệnh verify + "đừng dùng X".
2. Trong issue, Assign -> chọn "copilot" (bot) như assign dev.
3. Agent tự: tạo branch copilot/..., đọc code, sửa, chạy test, mở PR + link về issue.
4. Review PR như review junior dev: đọc diff, xem CI, comment yêu cầu sửa.
5. Agent tự push thêm commits theo review comments (nếu bạn tag nó).
6. CI xanh + duyệt -> merge.
```

```text
# Mẫu issue giao cho coding agent (copy-paste, sửa lại):
## Mục tiêu
Fix crash POST /orders khi payload thiếu customerId (trả 422 + { code, message }).

## Scope
- Chỉ sửa: apps/api/src/routes/orders.ts + test tương ứng.
- Đừng sửa: schema DB, auth middleware.

## Verify (agent phải chạy thật trên cloud)
- npm test -- --filter api (pass)
- npm run lint (pass)

## Báo cáo trong PR
- File nào đổi, vì sao; còn rủi ro gì.
```

> **Verify:** sau khi assign 2–5 phút, issue phải hiện "Copilot started work..." + branch `copilot/...`. Không thấy = assign nhầm hoặc repo chưa bật coding agent.

| Tiêu chí | Local Agent (VS Code) | Coding agent (github.com) |
|---|---|---|
| Chạy trên | Máy bạn | GitHub cloud VM |
| Config dùng | `.github/` + settings local + MCP local | Chỉ repo + cloud env |
| Chạy tiếp khi gập laptop | Không | Có |
| Hợp task | Cần terminal/DB/MCP local | Task độc lập, verify bằng CI, việc qua đêm |

---

## 6. Các bề mặt nhỏ

- **github.dev:** nhấn `.` khi xem repo trên github.com → VS Code web. Ghost text + Chat cơ bản; không terminal thật, không MCP local. Sửa nhanh không clone.
- **GitHub Mobile:** đọc/giải thích PR khi đi đường, duyệt coding-agent PR. Không dùng viết code nghiêm túc.
- **GitHub Desktop:** tích hợp Copilot — gợi ý commit message + PR body summary. Verify: stage files → nút "Generate commit message" → duyệt trước khi commit.
- **Windows Terminal:** Copilot CLI hỗ trợ gợi ý lệnh PowerShell ngay trong terminal. PowerShell suggestion kém hơn bash/zsh — test kỹ trước khi Enter.

---

## 7. Copilot CLI

> **2 CLI khác nhau — đừng nhầm:**
> - `copilot` (Copilot CLI): **GA 03/2026** cho mọi subscriber trả phí — agent hoàn chỉnh trong terminal, 3 persona (Shift+Tab xoay standard → plan → autopilot; hoặc `--mode=interactive|plan|autopilot`), đổi model `/model`, `/permissions`, `/sandbox`, `--max-ai-credits N`. Tích hợp GitHub (repo/issue/PR).
> - `gh copilot` (gh extension): chỉ `suggest`/`explain` lệnh shell.

### 7.1. `gh copilot` — 2 lệnh gốc dùng hàng ngày

```bash
# suggest: sinh lệnh shell từ mô tả:
gh copilot suggest "xoa cac git branch local da merge vao main"
gh copilot suggest "tim 10 file lon nhat trong thu muc hien tai"

# explain: giải thích lệnh khó hiểu trước khi chạy:
gh copilot explain "find . -type f -name '*.log' -mtime +7 -delete"
gh copilot explain "git rebase --onto main feature-old feature-new"
```

### 7.2. Flow an toàn với lệnh nguy hiểm

```bash
# NGUYÊN TẮC: explain trước, chạy sau. Đặc biệt với rm/find/docker prune.
gh copilot explain "find . -type f -name '*.log' -mtime +7 -delete"
# Đọc kỹ: đúng folder không? có -delete nhầm không?
find . -type f -name '*.log' -mtime +7 | head   # chạy khô trước
# Đúng mới chạy thật (bỏ | head, thêm -delete).
```

### 7.3. Copilot CLI agent (`copilot` binary)

```bash
copilot --mode=plan            # bắt đầu ở persona plan
# /permissions [default|assisted|allow-all|show] · /sandbox on|off · /model
# /model còn thấy local models từ Ollama đang chạy (offline mode là switch riêng COPILOT_OFFLINE)
# Local sandboxing đã GA (07/10/2026); computer use preview (01/10/2026, macOS/Windows):
/computer on    # bật computer use (preview — click/gõ/scroll xuyên desktop apps, luon xin approval)
/computer show  # xem trạng thái
/computer off   # tắt
```

> Tin mới 10/2026: VS Code 1.141 có Agents window xem sessions side-by-side + "Open worktree cleanup"; Copilot app hỗ trợ 2 account tách biệt; JetBrains có controls riêng — đừng assume parity với VS Code.

---

## 8. Hiểu nhầm thường gặp + pitfalls

| Hiểu nhầm | Sự thật | Ví dụ |
|---|---|---|
| "VS Code và github.com agent giống hệt nhau" | Local thấy `.env`/DB/MCP local; cloud chỉ thấy repo + CI | Task cần DB local mà giao cloud là fail chắc |
| "Neovim agent yếu là do Copilot dở" | Do harness Neovim thiếu terminal tool full | Chuyển task khó sang VS Code là xong |
| "github.dev có terminal thật" | Chạy trên browser, không terminal local | Cần chạy test thật → về VS Code local |
| "CLI suggest luôn đúng" | Gợi ý, có thể sai flag nguy hiểm | Luôn `explain` + chạy khô trước |
| "Local và Copilot giống nhau vì đều 'máy bạn'" | Khác harness: Local = extension host (tương tác); Copilot = Agent Host (nền, nhiều phiên) | Muốn chạy nền → Copilot; cần tool VS Code → Local |
| "Đổi Session Target là đổi model" | Target đổi "nơi chạy + tay chân"; model đổi ở model picker | Hỏi "não" → model picker; hỏi "xe + nơi chạy" → Session Target |

```text
# Lưu ý config theo bề mặt:
- .github/copilot-instructions.md + *.instructions.md: IDE local đọc được;
  coding agent chỉ đọc phần trong repo (không thấy settings local).
- .vscode/mcp.json (MCP local): chỉ VS Code local thấy; cloud cấu hình MCP riêng (remote http/sse).
- Env secrets (.env local): cloud KHÔNG thấy -> task cần DB local đừng làm trên cloud.
- Model picker: mỗi bề mặt có list model hơi khác (theo plan) -> hết AI Credits của model mạnh
  thì đổi model rẻ hơn thay vì đổi bề mặt.
```

```text
❌ SAI: assign coding agent "chạy migration + test với DB local của tôi"
✅ ĐÚNG: task cần DB/.env -> làm ở VS Code local; task độc lập, CI-verify được -> mới giao cloud

❌ SAI: copy lệnh `find ... -delete` từ suggest rồi Enter luôn
✅ ĐÚNG: `gh copilot explain "..."` + chạy khô (`| head`) trước, xác nhận đúng mới chạy thật
```

**Best practices:** chọn bề mặt theo "code chạy ở đâu" · task khó ở lại IDE, task mở đẩy sang Agent/VS Code · coding agent chỉ nhận task verify được bằng CI · một task = một issue/PR trên coding agent · mobile/web để đọc review, không viết code.

---

## 9. Bài tập nhỏ

1. **(15 phút) So sánh Ask/Edit/Agent:** cùng 1 task nhỏ, chạy lần lượt 3 modes trong VS Code. Ghi lại: mode nào sửa đúng nhất, tốn mấy turns, diff khác nhau ra sao.
2. **(20 phút) Coding agent end-to-end:** tạo 1 issue test (scope 1–2 files, có lệnh verify), assign cho copilot, review PR nó mở. Liệt kê 3 điểm nó làm tốt + 3 điểm bạn phải sửa tay.
3. **(15 phút) CLI drill:** giải 3 việc terminal thật bằng `suggest` + `explain`. Ghi lại lệnh nào chạy được ngay, lệnh nào phải sửa tay.
4. **(15 phút) Session Target:** liệt kê target khả dụng; chạy 1 task nhỏ ở Local rồi Handoff sang target khác, kiểm tra ngữ cảnh còn nguyên không.

---

## Link chéo + Reference

- **Bài 00 — Tổng quan** · **Bài 01 — Cài đặt** · **Bài 03 — Instructions** (config repo theo bề mặt) · **Bài 04 — Chat commands** (`@`, `#`, `/`) · **Bài 05 — Prompt files** · **Bài 10 — Modes & Permissions** (Session Target/harness chi tiết).
- GitHub Copilot docs: https://docs.github.com/copilot
- VS Code Copilot docs: https://code.visualstudio.com/docs/copilot
- Copilot coding agent: https://docs.github.com/copilot/using-github-copilot/coding-agent
- GitHub CLI Copilot extension: https://github.com/github/gh-copilot

> **Chốt bài 02:** trước mỗi task, tự hỏi "code chạy ở đâu và agent thấy được gì" — trả lời xong là chọn đúng quầy. Local cho việc cần môi trường máy bạn, Cloud cho việc độc lập chạy qua đêm, Copilot target để chạy nền nhiều phiên, CLI cho việc terminal.
