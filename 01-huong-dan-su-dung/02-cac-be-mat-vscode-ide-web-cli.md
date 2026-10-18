# 02 — Các Bề Mặt Copilot: VS Code, IDE, Web, CLI

> **Dành cho:** dev đã cài xong Copilot (bài 01), muốn biết task nào nên làm ở bề mặt nào.
> **Vấn đề:** không biết code chạy ở đâu (máy bạn hay cloud), config nào được dùng, khi nào nên giao việc cho coding agent.
> **Đọc xong:** chọn đúng bề mặt cho từng task, biết code chạy ở đâu + config nào được dùng, phân biệt rõ Local / Copilot / Cloud, setup được coding agent trên github.com và Copilot trong Windows Terminal/GH Desktop.
> **Thời gian:** ~30 phút. *(Bài 02 của series)*

## Mục tiêu bài học

- Trả lời được trong 10 giây, cho mỗi task: **code chạy ở đâu và config nào được dùng**.
- Phân biệt **local agent** vs **coding agent cloud** và biết task nào hợp bên nào.
- Phân biệt rõ 3 từ hay bị gộp: **Local / Copilot / Cloud** (Session Target trong VS Code).
- Setup được **coding agent** trên github.com (từ issue → branch → PR) và biết cách review PR nó mở.
- Dùng **Copilot CLI** an toàn: `explain` trước, chạy sau, với lệnh nguy hiểm.

## Mục lục

1. [Khái niệm cốt lõi](#1-khái-niệm-cốt-lõi-bề-mặt-là-gì-chọn-dựa-trên-đâu)
2. [Bảng quyết định nhanh + 5 task mẫu](#2-bảng-quyết-định-nhanh--5-task-mẫu)
3. [VS Code — bề mặt mạnh nhất](#3-vs-code--bề-mặt-mạnh-nhất)
4. [Các IDE khác: Visual Studio, JetBrains, Neovim](#4-các-ide-khác-visual-studio-jetbrains-neovim)
5. [Cloud: github.com chat + coding agent](#5-cloud-githubcom-chat--coding-agent)
6. [Các bề mặt nhỏ: github.dev, Mobile, GH Desktop, Windows Terminal](#6-các-bề-mặt-nhỏ-githubdev-mobile-gh-desktop-windows-terminal)
7. [Copilot CLI](#7-copilot-cli)
8. [Bảng thuật ngữ tra nhanh](#8-bảng-thuật-ngữ-tra-nhanh)
9. [So sánh với Claude Code](#9-so-sánh-với-claude-code)
10. [Hiểu nhầm thường gặp + Pitfalls](#10-hiểu-nhầm-thường-gặp--pitfalls)
11. [Best practices (kèm "vì sao")](#11-best-practices-kèm-vì-sao)
12. [Bài tập nhỏ](#12-bài-tập-nhỏ)
13. [Link chéo + Reference](#13-link-chéo--reference)

---

## 1. Khái niệm cốt lõi: bề mặt là gì, chọn dựa trên đâu?

Bài này chỉ dạy **1 tư tưởng**: chọn đúng "quầy" của Copilot dựa trên việc code sẽ chạy ở đâu. Mọi thứ khác là chi tiết.

**1 câu định nghĩa:** "bề mặt" (surface) là nơi bạn gặp Copilot — VS Code, web GitHub, terminal, điện thoại.

**Nôm na:** cùng một đầu bếp, nhưng ông ấy có nhiều quầy: quầy tại bàn (VS Code), giao tận nhà (coding agent chạy trên cloud), quầy take-away (CLI). Bạn không chọn đầu bếp, bạn chọn chỗ làm việc.

**Ví dụ:** cùng yêu cầu "thêm rate-limit", làm ở VS Code thì nó chạy `npm test` trên máy bạn; giao cho coding agent thì nó chạy CI trên cloud.

### Câu hỏi duy nhất cần hỏi

> **"Code sẽ chạy ở đâu, và agent thấy được gì?"**

Từ câu hỏi đó, mọi bề mặt rơi vào **2 nhóm**:

| Nhóm | Nơi code chạy | Agent thấy được gì | Gồm |
|---|---|---|---|
| **Local** (máy bạn) | Trên máy của bạn | File máy bạn, `.env`, DB local, MCP local, setting VS Code | VS Code, Visual Studio, JetBrains, Neovim, Copilot CLI, GH Desktop |
| **Cloud** (GitHub) | Trên máy chủ của GitHub/provider | Chỉ code trong repo + CI. **Không** thấy setting local, `.env`, DB máy bạn | github.com chat, coding agent, github.dev (VS Code trong browser) |

Đây là lý do GitHub tách: task 5 phút (fix typo) cần độ trễ thấp → local. Task 2 giờ (migrate, refactor 50 file) cần máy chạy tiếp khi bạn gập laptop → cloud. Không bề mặt nào thắng mọi trường hợp.

**Vì sao quan trọng?** "Code chạy ở đâu" quyết định agent thấy được gì. Local thấy `.env`, DB và MCP máy bạn; cloud chỉ thấy repo + CI. Hiểu điều này giúp bạn giao đúng việc cho đúng nơi ngay lần đầu.

**Nếu làm sai thì sao?** Giao coding agent một task cần DB local thì nó chạy mà không thấy DB → fail chắc chắn, tốn thời gian review. Ngược lại, việc 5 phút mà đẩy lên cloud thì chờ lâu hơn tự làm.

### Hai từ dễ nhầm: "bề mặt" vs "Session Target"

Bài này dùng 2 từ, và chúng **khác nhau**:

- **Bề mặt (surface)** = nơi bạn gặp Copilot: VS Code, web, terminal, điện thoại. Đây là phạm vi cả bài.
- **Session Target** = một công tắc **bên trong** VS Code Chat, chọn *harness* (ai thực thi tool) + *nơi chạy*: Local / Copilot / Cloud. Chi tiết ở mục 3.4.

Nói cách khác: "bề mặt" là quầy nào, "Session Target" là bên trong quầy VS Code bạn chọn ai thợ và nó làm ở đâu.

---

## 2. Bảng quyết định nhanh + 5 task mẫu

Đọc bảng trước, chi tiết ở các mục sau.

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
| **Copilot CLI** | Terminal bạn | Không (hỏi đáp shell) | Gợi ý/explain lệnh shell |
| **GH Desktop** | Máy bạn (GUI git) | Không | Commit message/PR summary nhanh |
| **Windows Terminal** | Máy bạn | Qua gh CLI | Suggest lệnh PowerShell |

### 5 task mẫu, chọn bề mặt nào?

```text
Task 1: "Giải thích hàm này" (5 phút)              -> Ask mode ở IDE bạn đang mở
Task 2: "Thêm rate-limit + test + chạy verify"      -> Agent mode VS Code (mạnh nhất)
Task 3: "Fix issue độc lập, tạo PR, tối đi ngủ"      -> Coding agent (assign issue)
Task 4: "Quên flag docker/git"                       -> gh copilot suggest/explain ngay terminal
Task 5: "Review PR của coding agent lúc đang cafe"  -> github.com chat / Mobile
```

### Cây hỏi 10 giây (dán lên màn hình)

```text
1. Task này có cần môi trường máy bạn không? (.env, DB local, MCP local)
   Có  -> VS Code (Local)
   Không -> hỏi tiếp
2. Cần chạy tiếp khi tôi tắt máy / đi ngủ không?
   Có  -> coding agent (Cloud)
   Không -> hỏi tiếp
3. Chỉ quên cách gõ lệnh shell thôi à?
   Có  -> Copilot CLI, đừng mở IDE
   Không -> về câu 1, chọn bề mặt phù hợp
```

**Kỳ vọng / Verify:** đọc xong bảng, bạn trả lời được trong 10 giây cho mỗi task: "code chạy ở đâu + config nào được dùng". Test: hỏi "task này cần `.env` local không?" → Có = local agent; Không, CI đủ = coding agent.

---

## 3. VS Code — bề mặt mạnh nhất

### 3.1. Vì sao mạnh nhất?

- Agent mode full tools: read/edit/search/terminal/MCP trong 1 loop.
- Model picker + mode picker (Ask/Edit/Agent) ngay trong Chat panel.
- **Session Target** (Local / Copilot / Cloud) chọn harness + nơi agent chạy (chi tiết 3.4).
- Đọc config repo đầy đủ: `.github/copilot-instructions.md`, `*.instructions.md`, `.github/prompts/`, `.github/agents/`, `.vscode/mcp.json`.
- Inline diff + Accept/Reject từng hunk, `#file`/`#selection` gắn scope chính xác.

### 3.2. 3 modes trong Chat (Ask / Edit / Agent)

> **Ask / Edit / Agent khác nhau thế nào (3 lớp)?**
> - 1 câu: 3 mức "quyền" bạn cấp cho Copilot trong 1 phiên chat.
> - Nôm na: Ask = hỏi thầy (chỉ nghe), Edit = thuê thợ sửa 2 viên gạch bạn chỉ, Agent = giao cả nhà cho thầu.
> - Ví dụ: Ask không tạo diff; Edit tạo diff trong files bạn chọn; Agent tự mở thêm files + chạy `npm test`.

| Mode | Sửa file? | Chạy terminal? | Khi dùng |
|---|---|---|---|
| **Ask** | Không | Không | Hỏi, giải thích, tra cứu (`@workspace` + `#file`) |
| **Edit** | Có (files bạn chọn) | Không/hạn chế | Sửa có scope rõ, bạn kiểm soát files |
| **Agent** | Có (tự tìm files) | Có | Task mở, multi-file, cần verify bằng test |

```text
# Flow khuyến nghị (copy-paste tư duy):
# 1. Chưa rõ -> Ask: "@workspace hàm login chạy qua những file nào?"
# 2. Rõ scope -> Edit: chọn 2-3 files + "thêm null check, giữ nguyên API".
# 3. Việc mở -> Agent: "thêm rate-limit cho POST /login, chạy test xác nhận."
```

### 3.3. Ví dụ thực tế + phím tắt

```text
# Ask (không sửa gì, hiểu trước):
"@workspace @file:package.json repo này chạy dev/test/lint bằng lệnh nào?
Trả lời ngắn gọn, không sửa file."

# Edit (scope hẹp, duyệt diff):
"#file:src/routes/login.ts #file:src/middleware/auth.ts
Thêm rate-limit 5 req/phút cho POST /login dùng express-rate-limit.
Giữ nguyên response shape { code, message, requestId }."

# Agent (task mở, có verify):
"Trong apps/api, endpoint POST /orders crash khi thiếu customerId.
Tìm root cause, fix, thêm regression test, chạy npm test để xác nhận.
Đừng sửa gì ngoài scope này."
```

```text
# Phím tắt đáng nhớ:
Ctrl+Alt+I            mở Copilot Chat panel
Ctrl+Shift+P > Chat   lệnh chat (New Chat, Attach File...)
Tab                   nhận ghost text (autocomplete)
/  @  #               trong Chat input: lệnh / participant @ / biến #
Up/Down trong input   lịch sử prompt (dùng lại prompt cũ sửa nhanh)
```

### 3.4. Session Target: Local / Copilot / Cloud (phần dễ nhầm nhất)

**Nôm na:** Model = chọn **tài xế** (bộ não). Session Target = chọn **loại xe + nơi chạy** (ai thực thi tool, chạy ở đâu). Cùng tài xế nhưng chạy phố (local) hay cao tốc (cloud).

> Đổi Session Target **không phải** đổi model. Đổi model ở model picker.

Bốn target thường gặp:

| Target | Chạy ở đâu | Truy cập code | Khi dùng |
|---|---|---|---|
| **Local** | Extension host VS Code (máy bạn), **chỉ trong cửa sổ VS Code** | Workspace hiện tại | Cần tool built-in / tool từ extension / model cấu hình trong VS Code |
| **Copilot** | Agent Host (máy bạn / host remote / Dev Container), **chạy nền** | Folder hiện tại hoặc worktree cô lập | Coding chung, chạy nền, nhiều phiên song song, mở lại ở cửa sổ/browser khác |
| **Cloud** | Hạ tầng remote của provider | 1 GitHub repo → mở PR | Task gọn, async, cần team review |
| **Claude / Codex** | Máy bạn (hoặc Agent Host, experimental) | Folder hiện tại hoặc worktree | Đã quen workflow + permission của provider đó |

**Điểm khác Local và Copilot (chỗ hay bị gộp):** cả hai *có thể* chạy trên máy bạn, nhưng khác **harness**:

- **Local** nằm trong extension host VS Code, làm việc tương tác ngay trong cửa sổ hiện tại, dùng được tool của VS Code/extension.
- **Copilot** chạy trên **Agent Host** (nền tảng Copilot SDK), chạy nền, mở được nhiều phiên song song, và session do host sở hữu nên mở lại được ở cửa sổ/browser khác.

**Vì sao quan trọng?** Chọn Local hay Copilot quyết định bạn có dùng được tool extension, có chạy được nhiều phiên nền song song hay không. Cloud thì giao hẳn để nhận PR, nhưng không thấy context local.

**Nếu làm sai thì sao?** Muốn chạy nền mà cứ dùng Local → phải giữ cửa sổ mở. Ngược lại, cần tool built-in của VS Code mà giao Cloud → Cloud không thấy context local, kết quả cụt.

```text
# Cách dùng:
# - Đáy khung Chat: Session Target -> chọn Local / Copilot / Cloud / Claude / Codex...
# - Agent Sessions sidebar: xem mọi session ở 1 chỗ (Local + Copilot + Cloud).
# - Handoff: đổi target giữa phiên, mang theo history + context.
#   CHỈ khởi tạo được handoff từ session Local.
# - Copilot -> Cloud nhanh: trong session Copilot gõ /delegate.
# Verify: mở Session Target -> list chỉ hiện target khả dụng ở cửa sổ hiện tại.
# Không thấy Copilot/Cloud -> check prerequisite (đăng nhập GitHub, extension, policy).
# Chi tiết + phân biệt model/harness/isolation: bài 10 mục 3.3.
```

---

## 4. Các IDE khác: Visual Studio, JetBrains, Neovim

Quy tắc team: **Neovim/VS/JetBrains để gõ + hỏi nhanh. VS Code để agent.** Đừng cố ép agent mode ở IDE yếu — chuyển bề mặt rẻ hơn cãi với tool.

### 4.1. Visual Studio (Windows, .NET/C++)

```text
Mạnh: ghost text + Chat cho solution .NET lớn, hiểu MSBuild/C# context tốt.
Yếu hơn VS Code: agent mode hạn chế terminal tools; MCP/custom agents hỗ trợ chậm hơn.
Khi dùng: dev .NET/WinForms/WPF/C++ hàng ngày.
Khi chuyển: task multi-file + terminal phức tạp -> sang VS Code.

Verify 30 giây:
1. Mở file .cs -> ghost text hiện, Tab nhận được.
2. View -> Copilot Chat -> hỏi "@workspace solution này có mấy projects?"
3. Thử Edit nhỏ: chọn 1 method + "thêm null check cho params".
```

### 4.2. JetBrains (IntelliJ / PyCharm / WebStorm / GoLand...)

```text
Mạnh: ghost text + Chat hiểu project model JetBrains (module indexes).
Yếu hơn VS Code: agent terminal tool hạn chế; prompt files/agents có thể hỗ trợ chậm.
Khi dùng: Java/Kotlin/Python/Go hàng ngày trong IDE quen tay.
Khi chuyển: cần MCP + custom agents đầy đủ -> sang VS Code.
```

### 4.3. Neovim

```bash
# Mạnh: gõ nhanh, nhẹ, ghost text ngay trong buffer.
# Yếu: không có agent mode full (không terminal tool như VS Code).
# Khi dùng: edit nhanh, fix nhỏ, gõ code tốc độ cao.
# Khi chuyển: task cần đọc nhiều file + chạy test -> sang VS Code.

# Lệnh hàng ngày:
# :Copilot status    -> kiểm tra
# :Copilot enable    -> bật lại
# Tab                -> nhận gợi ý
```

**Vì sao quan trọng?** Cùng là Copilot nhưng harness khác nhau. VS Code có đủ terminal/MCP tool để agent tự chạy test; các IDE còn lại thiếu vài tool nên task mở sẽ yếu hơn. Biết giới hạn này giúp bạn không mất niềm tin vào tool đúng.

**Nếu làm sai thì sao?** Cố dùng JetBrains/Neovim cho task multi-file + terminal rồi đổ lỗi "Copilot dở" — trong khi việc đó chỉ cần mở VS Code là xong.

---

## 5. Cloud: github.com chat + coding agent

### 5.1. github.com Chat (hỏi trên web)

```text
Vào repo trên github.com -> nhấn icon Copilot (góc phải) -> hỏi bằng tiếng Việt/Anh.
Dùng được: "@workspace" tương đương (hỏi toàn repo), đọc file/PR/issue.

Mạnh: không cần setup local, hỏi từ điện thoại được.
Yếu: không thấy settings local, không chạy terminal local, không MCP local.
Khi dùng: review PR ngoài giờ, hỏi code khi không có máy dev.
```

### 5.2. Coding agent (assign issue → branch → PR)

- **1 câu:** coding agent là Copilot chạy trên máy cloud của GitHub, tự code rồi mở PR khi bạn assign issue cho nó.
- **Nôm na:** gửi xe vào gara qua đêm — tối giao chìa khóa (issue), sáng nhận xe đã sửa (PR).
- **Ví dụ:** issue "Fix crash POST /orders" → agent tạo branch `copilot/fix-orders-422`, sửa `orders.ts`, chạy CI, mở PR link về issue.

```text
Flow chuẩn (copy-paste từng bước):
1. Tạo issue mô tả rõ: mục tiêu + scope files + lệnh verify + "đừng dùng X".
   Ví dụ: "POST /orders crash khi thiếu customerId. Fix + regression test.
   Verify: npm test -- --filter api. Đừng đổi schema DB."
2. Trong issue, Assign -> chọn "copilot" (bot) như assign dev.
3. Agent tự: tạo branch copilot/fix-..., đọc code, sửa, chạy test, mở PR + link về issue.
4. Bạn review PR như review của junior dev: đọc diff, xem CI, comment yêu cầu sửa.
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

> **Kỳ vọng / Verify:** sau khi assign 2–5 phút, issue phải hiện dòng "Copilot started work..." và có branch `copilot/...` mới. Không thấy = assign nhầm người, hoặc repo chưa bật coding agent.

### 5.3. Khi nào dùng coding agent vs local agent?

| Tiêu chí | Local Agent (VS Code) | Coding agent (github.com) |
|---|---|---|
| Chạy trên | Máy bạn | GitHub cloud VM |
| Config dùng | `.github/` + settings local + MCP local | Chỉ repo + cloud env |
| Cần setup local | Có | Không |
| Chạy tiếp khi gập laptop | Không | Có |
| Hợp task | Task cần terminal local, DB local, MCP local | Task độc lập, verify bằng CI, việc qua đêm |

---

## 6. Các bề mặt nhỏ: github.dev, Mobile, GH Desktop, Windows Terminal

### 6.1. github.dev (VS Code trên browser)

```text
Nhấn "." (chấm) khi đang xem repo trên github.com -> mở github.dev (VS Code web).
Đăng nhập Copilot -> có ghost text + Chat cơ bản.
Khi dùng: sửa nhanh không cần clone, demo, máy lạ.
Giới hạn: không terminal thật, không MCP local.
```

### 6.2. Mobile (iOS/Android)

```text
GitHub Mobile app -> mở repo/PR/issue -> icon Copilot -> hỏi.
Khi dùng: đọc giải thích PR khi đang đi đường, duyệt coding-agent PR.
Không dùng: viết code nghiêm túc (màn hình nhỏ, không diff tốt).
```

### 6.3. GitHub Desktop

```text
GH Desktop 2026 có tích hợp Copilot: gợi ý commit message + mở PR body summary.
Khi dùng: bạn thích GUI git, muốn commit message tự động theo diff.
Verify: stage files -> nút "Generate commit message" (icon Copilot) -> duyệt trước khi commit.
```

```bash
# Tương đương CLI (khi không dùng GUI):
git diff --staged --stat
gh copilot suggest "viet commit message conventional commits cho diff hien tai"
```

### 6.4. Copilot trong Windows Terminal

```text
Windows Terminal + GitHub Copilot CLI hỗ trợ gợi ý lệnh ngay trong terminal.
Khi dùng: dev Windows không dùng WSL, muốn suggest lệnh PowerShell.
Cài: Windows Terminal mới nhất + gh + gh-copilot (mục 7) + đăng nhập.
Giới hạn: PowerShell suggestion kém hơn bash/zsh (test kỹ trước khi Enter).
```

---

## 7. Copilot CLI

> **Update 10/2026:** có **2 CLI khác nhau** — `gh copilot` (gh extension: `suggest`/`explain` lệnh shell) vs `copilot` (Copilot CLI binary: agent trong terminal, Interactive/Plan/Autopilot, `/permissions`, `/sandbox`, `--max-ai-credits`). Đừng nhầm. CLI hiện còn: `/model` thấy local models từ Ollama đang chạy (07/10, offline mode vẫn là switch riêng `COPILOT_OFFLINE`, telemetry vẫn chạy), local sandboxing GA (07/10), computer use preview `/computer on|show|off` (01/10, macOS/Windows).

### 7.1. Hai lệnh gốc (dùng hàng ngày) — `gh copilot`

```bash
# suggest: sinh lệnh shell từ mô tả tiếng Việt/Anh:
gh copilot suggest "xoa cac git branch local da merge vao main"
gh copilot suggest "tim 10 file lon nhat trong thu muc hien tai"
gh copilot suggest "backup folder data sang data-$(date +%F).tar.gz"

# explain: giải thích lệnh khó hiểu trước khi chạy:
gh copilot explain "find . -type f -name '*.log' -mtime +7 -delete"
gh copilot explain "git rebase --onto main feature-old feature-new"
```

### 7.2. Flow an toàn với lệnh nguy hiểm

```bash
# NGUYÊN TẮC: explain trước, chạy sau. Đặc biệt với rm/find/docker prune.
gh copilot explain "find . -type f -name '*.log' -mtime +7 -delete"
# Đọc kỹ: đúng folder không? có -delete nhầm không?
# Test khô trước (thêm echo / chạy trên folder test):
find . -type f -name '*.log' -mtime +7 | head
# Đúng mới chạy thật (bỏ | head, thêm -delete).
```

### 7.3. Kết hợp CLI + IDE (pattern hay)

```bash
# Pattern: CLI soạn lệnh khó -> paste vào VS Code terminal -> agent mode chạy + verify.
gh copilot suggest "chay migration prisma tren staging (dry-run truoc)"
# Copy lệnh được gợi ý -> đưa cho agent mode VS Code:
# "Chạy lệnh này ở terminal, đọc output, nếu lỗi thì fix config thiếu."
```

### 7.4. Copilot CLI agent (`copilot` binary) + computer use — mới 10/2026

```bash
# 3 persona: Shift+Tab xoay standard → plan → autopilot;
# copilot --mode=interactive|plan|autopilot, --plan, --max-ai-credits N
# /permissions [default|assisted|allow-all|show] · /sandbox on|off · /model (kèm local Ollama)
/computer on    # bật computer use (preview 01/10, macOS/Windows)
/computer show  # xem trạng thái
/computer off   # tắt
# Computer use: click/gõ/scroll/drag xuyên desktop apps (legacy/GUI-only không API/MCP).
# Luôn xin approval trước khi điều khiển app; macOS cấp Accessibility + Screen Recording;
# org có thể disable. Mô tả outcome + apps + constraints thì chạy ổn nhất.
# Verify: /computer show → on? Thử task nhỏ ("tóm tắt notifications trong browser") trước.
```

> VS Code 1.141 (10/2026): Agents window xem sessions side-by-side · "Open worktree cleanup" dọn worktree inactive. App 10/2026: dùng 2 account tách biệt (license Copilot riêng + repos riêng). JetBrains 10/10 có controls + chat improvements riêng — đừng assume parity với VS Code.

---

## 8. Bảng thuật ngữ tra nhanh

Gặp từ lạ thì tra ở đây, khỏi đọc lại từ đầu.

| Thuật ngữ | Là gì (hiểu nôm na) | Ví dụ cụ thể | Khi nào dùng |
|---|---|---|---|
| **Surface** | Quầy gặp đầu bếp: VS Code, web, CLI, mobile | VS Code = quầy tại bàn, CLI = quầy take-away | Khi chọn nơi làm việc |
| **Local agent** | Thợ làm tại nhà bạn, thấy tủ lạnh (`.env`, DB) | VS Code agent chạy `npm test` local | Task cần env/DB/MCP local |
| **Coding agent** | Đội thi công qua đêm trên xưởng cloud | Assign issue → sáng có PR `copilot/fix-...` | Task độc lập, verify bằng CI |
| **github.dev** | VS Code chạy trong browser (nhấn `.`) | Sửa typo không cần clone | Sửa nhanh, máy lạ, demo |
| **Copilot CLI** | Từ điển lệnh shell biết nói tiếng Việt | `gh copilot suggest "nén folder dist"` | Quên flag docker/git/ffmpeg |
| **Session Target** | Công tắc chọn "ai thực thi tool" + "chạy ở đâu" (Local/Copilot/Cloud) | Đáy khung Chat → Session Target | Khi muốn đổi nơi agent chạy mà không đổi model |
| **Agent Host** | Tiến trình riêng chạy harness, sở hữu session độc lập cửa sổ | Copilot target chạy trên Agent Host | Khi dùng Copilot/phiên chạy nền |
| **Handoff** | Chuyển phiên sang target khác, mang theo history + context | Local → Cloud bằng `/delegate` | Khi target hiện tại hết phù hợp |

---

## 9. So sánh với Claude Code

| Việc | Copilot | Claude Code | Ghi chú |
|---|---|---|---|
| Bề mặt chính | IDE (VS Code/JetBrains/VS/Neovim) + github.com + CLI + mobile | CLI terminal là chính, có thêm IDE extension | Copilot phủ nhiều bề mặt hơn |
| Chạy ở đâu | Local (IDE/CLI) hoặc cloud (coding agent) | Chủ yếu local trong terminal/IDE | Copilot có coding agent cloud gắn issue → PR; Claude Code không có tương đương trực tiếp cho luồng đó |
| Chọn nơi agent chạy | Session Target (Local/Copilot/Cloud) | Không có tương đương trực tiếp — chạy local hoặc qua CI/Actions | Đây là điểm khác biệt lớn |
| Config repo | `.github/` + `.vscode/` + `AGENTS.md` | `CLAUDE.md` + `AGENTS.md` + `.claude/` | Cùng tư tưởng: file trong repo là "luật" |
| Mobile / web chat | github.com chat + GitHub Mobile | Không có tương đương trực tiếp tính đến thời điểm viết | Copilot phủ mobile/web |
| CLI | `gh copilot suggest` / `explain` (chỉ gợi ý lệnh) | `claude` CLI là agent đầy đủ | Khác mục đích: một cái tra lệnh, một cái làm việc |
| MCP (tool ngoài) | Có (`.vscode/mcp.json`) | Có | Cùng chuẩn giao thức |
| Kiểm chứng | Bạn tự chạy test/CI | Bạn tự chạy test/CI | Không agent nào tự chịu trách nhiệm đúng/sai |

> Nếu bạn quen Claude Code: tư tưởng "repo config + MCP + agent loop" chuyển sang Copilot gần như 1-1. Khác biệt lớn nhất là Copilot có **nhiều bề mặt** (IDE, cloud coding agent, mobile) và có **Session Target**, còn Claude Code **terminal-first**.

---

## 10. Hiểu nhầm thường gặp + Pitfalls

### 10.1. Hiểu nhầm thường gặp về bề mặt

| Hiểu nhầm | Sự thật | Ví dụ |
|---|---|---|
| "VS Code và github.com agent giống hệt nhau" | Local thấy `.env`/DB/MCP local; cloud chỉ thấy repo + CI | Task cần DB local mà giao cloud là fail chắc |
| "Neovim agent yếu là do Copilot dở" | Do harness Neovim thiếu terminal tool full, không phải model dở | Chuyển task khó sang VS Code là xong |
| "github.dev có terminal thật" | github.dev chạy trên browser, không có terminal local | Cần chạy test thật → về VS Code local |
| "CLI suggest luôn đúng" | Suggest là gợi ý, có thể sai flag nguy hiểm (`rm`, `find -delete`) | Luôn `explain` + chạy khô (`head`/dry-run) trước |
| "Local và Copilot giống nhau vì đều 'máy bạn'" | Khác harness: Local trong extension host (tương tác, 1 cửa sổ); Copilot trên Agent Host (nền, nhiều phiên, mở lại được ở cửa sổ khác) | Muốn chạy nền → Copilot; cần tool VS Code → Local |
| "Đổi Session Target là đổi model" | Target đổi "nơi chạy + tay chân"; model đổi ở model picker | Hỏi "não" → model picker; hỏi "xe + nơi chạy" → Session Target |

### 10.2. Lưu ý config theo bề mặt

```text
- .github/copilot-instructions.md + *.instructions.md: VS Code/JetBrains/VS/nvim đọc được;
  coding agent chỉ đọc phần trong repo (không thấy settings local của bạn).
- .vscode/mcp.json (MCP local): chỉ VS Code local thấy; cloud phải cấu hình MCP cloud riêng.
- Env secrets (.env local): cloud KHÔNG thấy -> task cần DB local đừng làm trên cloud.
- Model picker: mỗi bề mặt có list model hơi khác (theo plan) -> hết AI Credits của model mạnh
  thì đổi model rẻ hơn thay vì đổi bề mặt.
```

| Pitfall | Vì sao xảy ra | Fix |
|---|---|---|
| Ép agent mode ở IDE yếu rồi chê "Copilot dở" | JetBrains/VS terminal tool hạn chế | Task khó → sang VS Code, IDE kia để gõ/hỏi |
| Giao coding agent task cần DB local | Cloud không thấy `.env`/DB máy bạn | Task cần local → local agent; cloud chỉ task CI-verify được |
| Hỏi github.com chat rồi trách "không sửa file" | Web chat chủ yếu hỏi/review | Muốn sửa → coding agent (assign) hoặc về VS Code |
| Chạy lệnh CLI gợi ý mà không explain | Tin suggest 100% | Luôn `explain` + test khô (`head`/dry-run) trước |
| Mở task mới trên chat coding-agent cũ | History dài làm agent loạn | Issue mới cho task mới, PR riêng từng task |

### 10.3. Pitfall: ❌ SAI / ✅ ĐÚNG

**1. Giao task cần môi trường local cho cloud**

```text
❌ SAI: assign coding agent "chạy migration + test với DB local của tôi"
✅ ĐÚNG: task cần DB/.env -> làm ở VS Code local; task độc lập, CI-verify được -> mới giao cloud
```

**Bài học:** cloud không thấy `.env`/DB máy bạn — chọn bề mặt theo "code chạy ở đâu", không theo tiện tay.

**2. Ép agent mode ở IDE thiếu tool rồi kết luận "Copilot dở"**

```text
❌ SAI: cố chạy task multi-file + terminal trong Neovim/JetBrains rồi chê tool yếu
✅ ĐÚNG: gõ/hỏi nhanh ở IDE đó, chuyển task khó sang VS Code agent
```

**Bài học:** "yếu" thường là do harness thiếu tool, không phải model kém — đổi bề mặt rẻ hơn cãi với tool.

**3. Chạy lệnh CLI gợi ý mà không kiểm**

```text
❌ SAI: copy lệnh `find ... -delete` từ suggest rồi Enter luôn
✅ ĐÚNG: `gh copilot explain "..."` + chạy khô (`| head`) trước, xác nhận đúng mới chạy thật
```

**Bài học:** `suggest` là gợi ý, không đảm bảo đúng — một flag sai có thể xóa dữ liệu.

---

## 11. Best practices (kèm "vì sao")

- **Chọn bề mặt theo "code chạy ở đâu".** *Vì sao?* Task cần `.env`/DB local mà giao cloud là fail chắc; tự hỏi 10 giây trước khi mở tool.
- **Task đã biết chỗ đau ở lại IDE; task mở đẩy sang Agent/VS Code.** *Vì sao?* Đổi bề mặt đúng rẻ hơn cố ép agent mode trong IDE thiếu terminal tool.
- **Coding agent chỉ nhận task verify được bằng CI.** *Vì sao?* Cloud không thấy môi trường máy bạn, nên chỉ task độc lập + test tự động mới an toàn để giao.
- **Phân biệt model với Session Target.** *Vì sao?* Đổi model ở model picker, đổi nơi chạy ở Session Target — gộp hai thứ này là nguồn của nhiều hiểu nhầm.
- **`explain` trước, `run` sau với lệnh CLI nguy hiểm.** *Vì sao?* `suggest` có thể sinh `rm`/`find -delete` sai; đọc kỹ rẻ hơn khôi phục dữ liệu.
- **Một task = một issue/PR trên coding agent.** *Vì sao?* History chat dài làm agent loạn; tách issue giữ context sạch và review dễ hơn.
- **Mobile/web để đọc và review, không để viết code.** *Vì sao?* Thiếu diff tốt, không chạy terminal local — viết code nghiêm túc cần IDE.

---

## 12. Bài tập nhỏ

1. **(15 phút) So sánh Ask/Edit/Agent:** Cùng 1 task nhỏ ("thêm null check cho hàm login"), chạy lần lượt 3 modes trong VS Code. Ghi lại: mode nào sửa đúng nhất, tốn mấy turns, diff khác nhau ra sao.
2. **(20 phút) Coding agent end-to-end:** Tạo 1 issue test (scope 1–2 files, có lệnh verify), assign cho copilot, review PR nó mở. Liệt kê 3 điểm nó làm tốt + 3 điểm bạn phải sửa tay.
3. **(15 phút) CLI drill:** Giải 3 việc terminal thật bằng `suggest` + `explain` (git cleanup, tìm file lớn, nén backup). Ghi lại lệnh nào chạy được ngay, lệnh nào phải sửa tay.
4. **(15 phút) Chọn bề mặt:** Lấy 5 tasks thật của team bạn tuần này, điền vào bảng mục 2: mỗi task hợp bề mặt nào? Vì sao? Đối chiếu với đồng nghiệp xem có đồng thuận không.
5. **(10 phút) Session Target:** Mở Session Target, liệt kê target đang khả dụng; chạy 1 task nhỏ ở Local rồi Handoff sang target khác và kiểm tra ngữ cảnh còn nguyên không.

---

## 13. Link chéo + Reference

### Link chéo

- **Bài 00 — Tổng quan**: nếu chưa phân biệt Ask/Edit/Agent/coding agent, đọc lại.
- **Bài 01 — Cài đặt**: bề mặt nào chưa cài/login được thì quay lại bài 01.
- **Bài 03 — Instructions**: config repo nào đi theo bề mặt nào (local vs cloud).
- **Bài 04 — Chat commands**: `@`, `#`, `/` dùng trên từng bề mặt.
- **Bài 05 — Prompt files**: mang checklist theo mọi bề mặt qua repo files.
- **Bài 10 — Modes & Permissions**: chi tiết Session Target/harness + phân biệt model.
- **Bài 11 (README) — Coding agent & GitHub flow**: giao issue → PR chi tiết.
- **Bài 12 (README) — CLI & Terminal automation**: `gh copilot` trong pipeline.

### Reference

- GitHub Copilot docs: https://docs.github.com/copilot
- VS Code Copilot docs: https://code.visualstudio.com/docs/copilot
- Copilot coding agent: https://docs.github.com/copilot/using-github-copilot/coding-agent
- GitHub CLI Copilot extension: https://github.com/github/gh-copilot

> **Chốt bài 02:** Trước mỗi task, tự hỏi "code chạy ở đâu và agent thấy được gì" — trả lời xong là bạn đã chọn đúng quầy. Local cho việc cần môi trường máy bạn, Cloud cho việc độc lập chạy qua đêm, Copilot để chạy nền nhiều phiên, CLI cho việc tra lệnh.
