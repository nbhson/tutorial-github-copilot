# 01 — Cài Đặt, Xác Thực & Kiểm Tra Sức Khỏe Copilot

> Bài 01 của series. Đọc xong bạn chọn đúng plan, cài được Copilot trên VS Code /
> JetBrains / Visual Studio / Neovim, cài Copilot CLI, login thành công và fix được
> 90% lỗi setup. Thời gian: ~30 phút + 15 phút làm theo.

## Mục lục

1. [Vì sao Copilot 2026 khác trước? (why)](#1-vì-sao-copilot-2026-khác-trước-why)
2. [Plans + trial: chọn gói nào?](#2-plans--trial-chọn-gói-nào)
3. [VS Code setup (mạnh nhất)](#3-vs-code-setup-mạnh-nhất)
4. [JetBrains / Visual Studio / Neovim](#4-jetbrains--visual-studio--neovim)
5. [Copilot CLI (`gh copilot`)](#5-copilot-cli-gh-copilot)
6. [Login, verify, session đầu tiên](#6-login-verify-session-đầu-tiên-walkthrough)
7. [Duplicate install + update](#7-duplicate-install--update)
8. [Checklist + pitfalls + bài tập](#8-checklist-pitfalls-bài-tập)
9. [Link chéo](#9-link-chéo)

---

## 1. Vì sao Copilot 2026 khác trước? (why)

- Là gì (1 câu): Copilot 2026 là hệ multi-model + multi-surface, không còn là 1 extension gợi ý code.
- Hiểu nôm na: ngày xưa là xe số 1 tốc độ; nay là xe tay ga có 3 chế độ lái (GPT/Claude/Gemini) + chạy được cả đường phố (IDE) lẫn cao tốc (cloud).
- Ví dụ kỹ thuật: cùng prompt "thêm rate-limit", chọn GPT-mini ra code đơn giản, chọn Claude ra code + test + giải thích trade-off.

```mermaid
flowchart TD
    A[Chưa có Copilot] --> B[Có GitHub account?]
    B -- Chưa --> C[Tạo account tại github.com/signup]
    B -- Rồi --> D[Chọn plan: Trial / Individual / Business / Enterprise]
    C --> D
    D --> E[Cài IDE extension\nVS Code / JetBrains / VS / Neovim]
    E --> F[Sign in OAuth đúng account]
    F --> G[Cài gh CLI + gh-copilot]
    G --> H[Verify: status + ghost text + Chat + CLI]
    H --> I{Pass hết?}
    I -- Chưa --> J[Tra bảng lỗi mục 8.2]
    J --> H
    I -- Rồi --> K[Chạy session đầu mục 6.3]
```

> **Kỳ vọng / Verify:** đọc xong sơ đồ, bạn biết mình đang ở bước nào. Chạy
> `gh auth status` phải thấy `Logged in to github.com as <tên-bạn>`. Sai tên là sai account.

Trước 2024: Copilot = extension autocomplete + chat đơn giản, 1 model duy nhất.

Từ 2025–2026:

- **Multi-model picker**: cùng 1 Chat panel, bạn đổi giữa GPT / Claude / Gemini.
  Model mạnh tốn premium requests multiplier cao hơn — chọn model = chọn giá.
- **Agent mode mặc định trong VS Code**: tự đọc/sửa/chạy terminal, không còn
  chỉ gợi ý text.
- **Coding agent trên github.com**: assign issue → cloud tự code → PR.
- **`AGENTS.md` + Agent Skills support**: 1 file instructions chạy nhiều agent.
- **Copilot CLI** (`gh extension install copilot`): mang chat xuống terminal.

> Hệ quả thực tế: cài extension thôi chưa đủ — phải hiểu plan/quota (mục 2),
> chọn đúng IDE setup (mục 3–4), và verify status bar + CLI (mục 6).

---

## 2. Plans + trial: chọn gói nào?

### 2.1. Bảng quyết định (why)

> **Plan là gì?** Định nghĩa: plan là gói trả phí quyết định bạn có bao nhiêu quota + dùng được model nào.
> Hiểu nôm na: như gói cước điện thoại — gói rẻ nghe gọi cơ bản, gói doanh nghiệp có thêm roaming + quản lý.
> Ví dụ kỹ thuật: Individual hết premium requests giữa tháng thì agent mode báo quota; Business thì admin mua thêm seats.

| Bạn là ai | Chọn | Được gì | Lưu ý |
|---|---|---|---|
| Cá nhân thử lần đầu | Trial (check github.com/copilot) | Dùng thử giới hạn | Hết trial phải chọn plan trả phí |
| Dev cá nhân | Individual / Pro | Quota cá nhân + full IDE + CLI | Quota ít nhất, mua thêm nếu cháy |
| Team 5–50 người | Business | Quota team + org policy + usage dashboard | Admin quản lý seats, content exclusion |
| Corp / compliance | Enterprise | BYOK, audit log, policy chi tiết | Cần admin setup SSO + policy |

> **Kỳ vọng / Verify:** sau khi đăng ký, vào `https://github.com/settings/copilot`
> phải thấy dòng plan + ngày hết hạn trial. Không thấy = chưa active, đừng cài tiếp.

> Giá và quota đổi theo quý — luôn check `github.com/pricing` và
> `github.com/settings/copilot` làm chuẩn cuối, đừng tin số trong tutorial.

### 2.2. Đăng ký trial (copy-paste flow)

```bash
# 1. Mo trinh duyet, vao trang dang ky:
# https://github.com/copilot -> "Start free trial" (can GitHub account + payment method)
# 2. Chon plan phu hop (Individual de bat dau).
# 3. Sau khi active, verify tai:
# https://github.com/settings/copilot
```

```bash
# Kiem tra trial/plan bang CLI (sau khi cai gh + copilot extension, muc 5):
gh auth login
gh copilot --help
# Ky vong: hien help, khong bao "no Copilot subscription".
```

### 2.3. Ai trả tiền cho premium requests?

- Agent mode với model mạnh (Claude/GPT-5-class) tốn multiplier cao.
- Coding agent trên github.com cũng trừ quota (mỗi task cloud = nhiều requests).
- Autocomplete thường không tốn premium requests (hoặc tốn rất ít) — gõ thoải mái.
- Admin Business/Enterprise xem usage theo user tại org settings → ai cháy quota
  nhiều nhất lộ ngay (chi tiết bài 10 trong README).

---

## 3. VS Code setup (mạnh nhất)

VS Code là bề mặt mạnh nhất 2026: agent mode full tools + MCP + custom agents
+ prompt files. Cài theo thứ tự dưới đây.

### 3.1. Step-by-step (copy-paste)

> **OAuth login là gì?** Định nghĩa: OAuth là cách VS Code nhờ GitHub xác nhận "đúng là bạn" mà không cần bạn gõ mật khẩu vào VS Code.
> Hiểu nôm na: như dùng CCCD để lễ tân cấp thẻ thang máy — lễ tân (GitHub) xác nhận, VS Code chỉ giữ thẻ (token).
> Ví dụ kỹ thuật: click "Sign in" → browser mở `github.com/login/oauth` → bấm Allow → VS Code nhận token lưu local.

```bash
# 1. Cai VS Code moi nhat (>= 1.90 de co agent mode on dinh):
# Tai tu https://code.visualstudio.com/ (dung ban Stable, khong dung Insiders tru khi can test).

# 2. Kiem tra version:
code --version
# Kỳ vọng / Verify: hiện 3 dòng, ví dụ:
# 1.90.2
# commit hash...
# arm64 (hoặc x64). Nếu < 1.90 → tải bản mới, đừng cố dùng agent mode.
```

```text
3. Trong VS Code: Ctrl+Shift+X (Extensions) → tìm "Muse" → Install.
   (Kèm theo "Muse Chat" nếu bản của bạn tách 2 extensions — cài cả 2.)
4. Reload VS Code khi được yêu cầu.
5. Status bar góc dưới-phải phải hiện icon Copilot (chưa login thì hiện "Sign in").
6. Click icon → "Sign in to GitHub" → duyệt OAuth trong browser → Allow.
7. Quay lại VS Code, icon chuyển sang trạng thái active.
```

### 3.2. Verify VS Code (copy-paste)

```bash
# Trong VS Code, mo Command Palette (Ctrl+Shift+P) va chay lan luot:
# > "Copilot: Check Status"       -> ky vong: Active, dung account
# > "Chat: New Chat"              -> ky vong: mo Chat panel ben phai
# > "Copilot: Open Completions Log" (neu co) -> xem ghost text co chay khong
```

```text
Verify bang mat (3 giay):
1. Status bar: icon Copilot khong bao loi.
2. Go code trong file .ts/.py: co ghost text mo (bam Tab nhan duoc).
3. Mo Chat panel (Ctrl+Alt+I): chon duoc Model + Mode (Ask/Edit/Agent).
4. Go "@workspace repo nay lam gi?" -> tra loi dung (chung to index chay).
```

### 3.3. Settings nên bật ngay

```json
// .vscode/settings.json — mau team (copy-paste, sua lai)
{
  "github.copilot.enable": { "*": true },
  "github.copilot.chat.localeOverride": "en",
  "github.copilot.chat.codeGeneration.useInstructionFiles": true,
  "github.copilot.chat.agent.thinkingTool": true
}
```

> `useInstructionFiles: true` là quan trọng nhất — bật thì
> `.github/muse-instructions.md` mới được load (chi tiết bài 03).

---

## 4. JetBrains / Visual Studio / Neovim

### 4.1. JetBrains (IntelliJ / PyCharm / WebStorm...)

```text
1. Settings (Ctrl+Alt+S) → Plugins → Marketplace → tìm "Muse" → Install.
2. Restart IDE khi được yêu cầu.
3. Tools → "Sign in to GitHub" → duyệt OAuth.
4. Verify: gõ code → ghost text hiện; mở Copilot Chat tool window bên phải.
```

```bash
# Luu y JetBrains 2026:
# - Agent mode co nhung khong full tools nhu VS Code (terminal tool han che hon).
# - Repo config (.github/muse-instructions.md) van dung duoc.
# - Task phuc tap (multi-file + terminal) -> lam tren VS Code hoac github.com agent.
```

### 4.2. Visual Studio (Windows, .NET/C++)

```text
1. Extensions → Manage Extensions → tìm "Muse" → Install (can VS 2022 17.8+).
2. Restart Visual Studio.
3. Help → "Sign in to GitHub" (hoac Copilot badge goc tren-phai).
4. Verify: mo file .cs → ghost text; View → "Copilot Chat" mo panel.
```

### 4.3. Neovim

```bash
# Cai plugin copilot.vim (pho bien nhat):
git clone https://github.com/github/copilot.vim.git ~/.config/nvim/pack/github/start/copilot.vim

# Mo nvim, login:
# :Copilot setup
# (mo browser OAuth, paste code ve nvim)

# Verify:
# :Copilot status
# Ky vong: "Copilot: Enabled" (neu "Not authenticated" -> chay lai :Copilot setup)
```

```bash
# Phim tat co ban trong nvim (thu ngay sau cai):
# Tab        -> nhan ghost suggestion (neu khong trung plugin khac)
# :Copilot status   -> kiem tra trang thai
# :Copilot enable   -> bat lai khi bi tat
# :Copilot disable  -> tat tam (khi muon go tay 100%)
```

> Neovim mạnh autocomplete + chat cơ bản, yếu agent mode (không có terminal tool
> full như VS Code). Dùng Neovim để gõ nhanh, chuyển VS Code khi cần agent.

---

## 5. Copilot CLI (`gh copilot`)

### 5.1. Vì sao cần CLI? (why)

IDE Copilot giúp lúc gõ code. CLI giúp lúc ở terminal: quên flag `docker`,
quên cú pháp `git rebase`, muốn explain pipeline dài — hỏi ngay không cần
mở browser.

### 5.2. Cài đặt (copy-paste)

```bash
# 1. Cai GitHub CLI truoc (neu chua co):
# macOS:
brew install gh
# Ubuntu/Debian:
sudo apt update && sudo apt install -y gh
# Windows: tai installer tu https://cli.github.com/

# 2. Login gh:
gh auth login
# Chon: GitHub.com -> HTTPS -> Login with a web browser -> paste code.

# 3. Cai Copilot extension cho gh:
gh extension install github/gh-copilot

# 4. Update khi co ban moi:
gh extension upgrade github/gh-copilot

# 5. Verify:
gh copilot --help
gh copilot --version
```

### 5.3. Hai lệnh dùng 90% thời gian

```bash
# suggest: goi y lenh shell (copy-paste duoc):
gh copilot suggest "xoa cac git branch local da merge vao main"
gh copilot suggest "tim file >100MB trong repo hien tai"

# explain: giai thich lenh kho (hoc 1 lan nho mai):
gh copilot explain "docker run -p 5432:5432 -e POSTGRES_PASSWORD=secret postgres:16"
gh copilot explain "git rebase -i HEAD~3"
```

```bash
# Alias cho gon (them vao ~/.zshrc hoac ~/.bashrc):
alias cps='gh copilot suggest'
alias cpe='gh copilot explain'

# Dung:
cps "nen thu muc dist thanh dist.tar.gz loai tru node_modules"
cpe "awk '{print $2}' access.log | sort | uniq -c | sort -rn | head"
```

---

## 6. Login, verify, session đầu tiên (walkthrough)

### 6.1. Login đúng cách

```text
VS Code / JetBrains / Visual Studio:
- Click Copilot status bar (hoac badge) → "Sign in to GitHub" → OAuth browser → Allow.
- Neu co 2 account (ca nhan + cong ty): login sai account = sai quota/policy.
  Fix: sign out (click icon → Sign out) → sign in lai dung account.

Neovim:
- :Copilot setup → OAuth → paste code.

CLI:
- gh auth login (chon dung account truoc khi cai copilot extension).
```

### 6.2. Verify tổng (copy-paste checklist lệnh)

```bash
# Terminal:
gh auth status          # ky vong: Logged in to github.com as <ban>
gh copilot --help       # ky vong: hien suggest/explain
code --version          # ky vong: VS Code >= 1.90
```

```text
Trong VS Code (mat thay):
[ ] Status bar: icon Copilot active, khong bao loi.
[ ] Ghost text: go code co goi y mo, Tab nhan duoc.
[ ] Chat panel: mo duoc, chon duoc Model + Mode.
[ ] @workspace hoi dung repo (chung to index chay).
[ ] Chay "Chat: New Chat" + prompt thu muc 6.3 pass.
```

### 6.3. Walkthrough 15 phút: session đầu chuẩn

```text
Buoc 1 (2 phut): mo repo that trong VS Code, mo Chat moi (Ctrl+Alt+I).
Buoc 2 (3 phut): chon Mode = Agent, chon model mac dinh team dung.
Buoc 3 (5 phut): go prompt khan:
"Doc README + package.json, tom tat: project nay la gi,
chay dev bang lenh nao, test bang lenh nao. Khong sua gi, chi tra loi."
Buoc 4 (3 phut): luu ket qua vao .github/muse-instructions.md (mau o bai 00 muc 8).
Buoc 5 (2 phut): mo chat moi, hoi lai cau cu de kiem tra instructions co load khong.
```

---

## 7. Duplicate install + update

### 7.1. Duplicate install (2 bản song song)

```bash
# Trieu chung: ghost text luc co luc khong, Chat panel bao version lech.
# Kiem tra:
code --list-extensions | grep -i copilot
gh extension list | grep -i copilot

# Ky vong: moi dong chi 1 ban "github.copilot" + "github.copilot-chat".
# Neu thay 2 ban (vd stable + nightly/pre-release) -> go 1 ban:
code --uninstall-extension github.copilot-nightly
# (thay slug bang ban thua may ban hien)
```

### 7.2. Update (copy-paste)

```bash
# VS Code extensions: tu dong update theo setting; bat tay khi can gap:
# Ctrl+Shift+X -> "Muse" -> Update (neu co nut).

# gh CLI + copilot extension:
gh extension upgrade github/gh-copilot
gh extension upgrade --all

# Neovim (copilot.vim):
# chay lai git pull trong thu muc plugin:
git -C ~/.config/nvim/pack/github/start/copilot.vim pull
```

```bash
# Sau update, verify lai 30 giay:
gh copilot --version
# Trong VS Code: "Copilot: Check Status" -> Active.
# Neu Chat panel tringsau update: Reload Window (Ctrl+Shift+P > Reload Window).
```

---

## 8. Checklist, pitfalls, bài tập

### 8.1. Checklist sau cài đặt (copy-paste)

- [ ] `gh auth status` đúng account (cá nhân vs công ty).
- [ ] `gh copilot --help` hiện suggest/explain.
- [ ] VS Code: status bar active + ghost text Tab nhận được.
- [ ] Chat panel: chọn được Model + Mode (Ask/Edit/Agent).
- [ ] `@workspace` trả lời đúng repo (index chạy).
- [ ] `.vscode/settings.json` bật `useInstructionFiles`.
- [ ] Neovim (nếu dùng): `:Copilot status` = Enabled.
- [ ] Đã chạy walkthrough mục 6.3 trên 1 repo thật.

### 8.1b. Bảng thuật ngữ cài đặt (tra nhanh khi quên)

| Thuật ngữ | Là gì (hiểu nôm na) | Ví dụ cụ thể | Khi nào dùng |
|---|---|---|---|
| **Plan / Trial** | Gói cước quyết định quota | Individual hết quota giữa tháng | Khi chọn gói, khi hết quota |
| **OAuth / Sign in** | Nhờ GitHub cấp thẻ thang máy (token) | Click Sign in → Allow trong browser | Mỗi lần login / đổi account |
| **Ghost text** | Chữ mờ gợi ý, Tab để nhận | Gõ `for` → hiện cả vòng lặp mờ | Khi gõ code hàng ngày |
| **Model picker** | Nút chọn "động cơ" GPT/Claude/Gemini | Task dễ chọn model rẻ, task khó chọn model mạnh | Đầu mỗi task |
| **Duplicate install** | Cài 2 bản đè nhau (stable + nightly) | Ghost text lúc có lúc không | Khi extension chập chờn sau update |

### 8.1c. Hiểu nhầm thường gặp khi cài đặt

| Hiểu nhầm | Sự thật |
|---|---|
| "Cài extension là xong, không cần login đúng account" | Sai account = sai quota/policy cả buổi. Luôn `gh auth status` trước |
| "Ghost text không hiện là Copilot hỏng" | Thường do file >2000 dòng, extension tắt cho ngôn ngữ đó, hoặc duplicate install |
| "`gh copilot: command not found` là máy hỏng" | Chỉ là chưa chạy `gh extension install github/gh-copilot` |
| "Trial hết thì dùng chùa tiếp được" | Hết trial phải mua plan, CLI sẽ báo `no Copilot subscription` |

### 8.2. Lỗi cài đặt hay gặp

| Triệu chứng | Nguyên nhân likely | Fix (copy-paste) |
|---|---|---|
| Status bar báo "Sign in" mãi sau OAuth | Login sai account / token hết hạn | Sign out → sign in lại đúng account; `gh auth login` lại |
| Ghost text không hiện | Extension tắt cho ngôn ngữ này / file quá lớn | Check `github.copilot.enable`, thử file <2000 dòng |
| `@workspace` trả lời sai repo | Index chưa xong / mở sai folder | Mở đúng root (`code .` tại root), đợi index, hỏi lại |
| `gh copilot: command not found` | Chưa cài extension cho gh | `gh extension install github/gh-copilot` |
| `no Copilot subscription` trong CLI | `gh` login sai account / trial hết | `gh auth login` đúng account; check `github.com/settings/copilot` |
| 2 bản Copilot xung đột | Còn cả stable + nightly | `code --list-extensions`, gỡ bản thừa |
| Neovim `:Copilot status` = Not authenticated | Chưa `:Copilot setup` | Chạy `:Copilot setup`, OAuth lại |
| Chat panel trắng sau update | Version lệch extension vs VS Code | Reload Window; update VS Code Stable mới nhất |

### 8.3. Bài tập thực hành

**Bài 1 (10 phút) — Verify cài đặt:**
Chạy hết lệnh mục 6.2 + check list bằng mắt. Chụp output `gh auth status`
(che token), giải thích từng dòng cho đồng nghiệp. Fix hết lỗi trước khi sang bài 2.

**Bài 2 (15 phút) — Multi-IDE check:**
Nếu team có cả VS Code + JetBrains, lập bảng: mỗi IDE cài bằng cách nào,
verify bằng nút/lệnh nào, agent mode mạnh tới đâu. Ghi vào team wiki.

**Bài 3 (20 phút) — CLI drill:**
Dùng `gh copilot suggest` giải 3 việc thật của bạn (git cleanup, docker, ffmpeg...).
Chạy thử lệnh được gợi ý trong thư mục test trước. Alias `cps/cpe` vào shell config.

**Bài 4 (15 phút) — Session đầu chuẩn:**
Trên 1 repo thật, chạy đủ walkthrough mục 6.3. Lưu `muse-instructions.md` nháp
đầu tiên. Liệt kê 3 rules bạn đã viết.

---

## 9. Link chéo

- **Bài 00 — Tổng quan**: nếu chưa phân biệt Ask/Edit/Agent, quay lại đọc trước.
- **Bài 02 — Surfaces**: chọn VS Code/JetBrains/github.com/CLI cho từng task.
- **Bài 03 — Instructions**: file `muse-instructions.md` vừa tạo cần cắt <200 dòng.
- **Bài 04 — Chat commands**: tra cứu `/`, `@`, `#` và công thức 5 lệnh đầu.
- **Bài 05 — Prompt files**: đóng gói checklist lặp lại thành `/deploy`.
- **Bài 10 (README) — Policies & BYOK**: quota, model gating, content exclusion.
- **FAQ (repo này, khi có)**: lỗi lạ không có trong bảng mục 8 → tra FAQ trước khi hỏi.
