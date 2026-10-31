# 01 — Cài Đặt, Xác Thực & Kiểm Tra Sức Khỏe Copilot

> **Dành cho:** người mới bắt đầu dùng GitHub Copilot, hoặc đã cài nhưng chưa xác thực/hoạt động được.
> **Vấn đề:** chọn sai plan, cài nhầm bề mặt, login sai tài khoản → Copilot báo lỗi hoặc không gợi ý code.
> **Đọc xong:** chọn đúng plan, cài được Copilot trên VS Code / JetBrains / Visual Studio / Neovim + Copilot CLI, login thành công và fix được 90% lỗi setup.
> **Thời gian:** ~25 phút đọc + 15 phút làm theo. *(Bài 01 của series)*

Luồng chuẩn: tạo account → chọn plan → cài extension (VS Code / JetBrains / VS / Neovim) → OAuth đúng account → cài Copilot CLI + gh copilot → verify (status + ghost text + Chat + CLI). `gh auth status` phải thấy `Logged in to github.com as <tên-bạn>` — sai tên là sai account.

## Mục tiêu bài học

- Chọn đúng **plan/trial** và phân biệt hoạt động nào tốn AI Credits, hoạt động nào miễn phí.
- Cài và xác thực Copilot trên **VS Code / JetBrains / Visual Studio / Neovim** + **Copilot CLI**.
- Chạy được **checklist verify 30 giây** (status bar, ghost text, Chat, CLI) và biết sai thì sửa ở đâu.
- Tự xử **90% lỗi setup** bằng bảng chẩn đoán, thay vì đoán mò rồi cài lại từ đầu.

---

## 1. Vì sao Copilot 2026 khác trước?

Copilot 2026 là **hệ multi-model + multi-surface**: một tài khoản, nhiều "động cơ" (model) và nhiều nơi chạy (IDE, web, terminal).

- **Là gì (1 câu):** hệ multi-model + multi-surface, không còn là 1 extension gợi ý code.
- **Nôm na:** ngày xưa là xe số 1 tốc độ; nay là xe ga có nhiều chế độ lái (GPT-5.2-Codex / Claude / Gemini) + chạy được cả đường phố (IDE) lẫn cao tốc (cloud).
- **Ví dụ kỹ thuật:** cùng prompt "thêm rate-limit", chọn model rẻ ra code đơn giản, chọn model mạnh ra code + test + giải thích trade-off.

Từ 2025–2026: multi-model picker (đổi GPT/Claude/Gemini ngay trong Chat), Agent mode tự đọc/sửa/chạy terminal, coding agent trên github.com (assign issue → PR, khởi động nhanh hơn 50% từ 03/2026), `AGENTS.md` + Agent Skills, **Copilot CLI GA 03/2026** (agentic trong terminal cho mọi subscriber trả phí), **GPT-5.2-Codex GA 01/2026**.

---

## 2. Plans + trial: chọn gói nào?

> **Plan là gì?** Gói trả phí quyết định bạn có bao nhiêu **AI Credits** (hạn mức dùng) + dùng được model nào. Nôm na: như gói cước điện thoại — gói rẻ dùng cơ bản, gói doanh nghiệp có thêm quản lý + policy.

| Bạn là ai | Chọn | Được gì | Lưu ý |
|---|---|---|---|
| Cá nhân thử lần đầu | Free / Trial (github.com/copilot) | Dùng thử giới hạn | Hết trial phải chọn plan trả phí |
| Sinh viên / giáo viên | Student / Teacher | Free + credits allowance | Không thấy ưu đãi thì xác thực email trường |
| Dev cá nhân | Pro / Pro+ / Max | AI Credits cá nhân + full IDE + CLI | Credits nhiều nhất ở Max |
| Team 5–50 người | Business | Credits + org policy + usage dashboard | Admin quản lý seats, content exclusion |
| Corp / compliance | Enterprise | BYOK, audit log, policy chi tiết | Cần admin setup SSO + policy |

### 2.1. Giá tham khảo (10/2026 — luôn check lại tại `github.com/settings/copilot`)

> Billing hiện tại là **usage-based / GitHub AI Credits** (từ 01/06/2026, thay "premium requests"). 1 AI credit = $0.01; chi phí = giá mỗi token của model × số token.

| Gói | Giá | Credits kèm |
|---|---|---|
| Free | 0 USD | Giới hạn thấp (autocomplete ~2.000 completions/tháng) |
| Pro | 10 USD/tháng | 1.500 AI credits/tháng (base 1.000 + flex 500) |
| Pro+ | 39 USD/tháng | 7.000 AI credits/tháng (base 3.900 + flex 3.100) |
| Max | 100 USD/tháng | 20.000 AI credits/tháng (base 10.000 + flex 10.000) |
| Business | 19 USD/seat | 1.900 AI credits/seat/tháng |
| Enterprise | 39 USD/seat | 3.900 AI credits/seat/tháng (pooled) |

> Free/Student có hạn mức credits không công bố số cụ thể (check dashboard). Giá đổi theo quý — `github.com/pricing` là chuẩn cuối.

**Vì sao quan trọng?** Chọn sai plan hoặc là thiếu credits giữa việc (agent mode dừng giữa task, code dở dang), hoặc trả tiền cho tính năng không ai dùng.

### 2.2. Đăng ký trial + verify (copy-paste)

```bash
# 1. Vào https://github.com/copilot -> chọn plan (Pro để bắt đầu) + payment method.
# 2. Verify tại https://github.com/settings/copilot — phải thấy plan + ngày hết hạn trial.
#    Không thấy = chưa active, đừng cài tiếp.

# Kiểm tra bằng CLI (sau khi cài gh + extension, mục 4):
gh auth login
gh copilot --help
# Kỳ vọng: hiện help, không báo "no Copilot subscription".
```

### 2.3. Hoạt động nào tốn AI Credits?

| Hoạt động | Tốn AI Credits? | Ghi chú |
|---|---|---|
| Autocomplete (ghost text) + next edit suggestions | Không | Miễn phí mọi plan trả phí; Free giới hạn 2.000 completions/tháng |
| Agent mode + model mạnh | Có (nhiều) | Chi phí = giá token model × số token |
| Coding agent trên github.com | Có | Mỗi task cloud = nhiều lượt truy cập |
| Auto model selection | Có, nhưng giảm 10% | Áp cho Copilot Chat, CLI, app, cloud agent |
| Vượt hạn mức credits trong gói | Có | Tính vào additional usage budget (admin cài spend cap nếu muốn) |

> Admin Business/Enterprise xem usage theo user tại org settings — ai cháy credits nhiều nhất lộ ngay (chi tiết bài 07).

---

## 3. VS Code setup (mạnh nhất)

VS Code là bề mặt mạnh nhất 2026: agent mode full tools + MCP + custom agents + skills.

> **OAuth login là gì?** Cách VS Code nhờ GitHub xác nhận "đúng là bạn" mà không gõ mật khẩu vào VS Code — click "Sign in" → browser mở `github.com/login/oauth` → Allow → VS Code nhận token lưu local. Token hết hạn thì sign out + sign in lại, không phải cài lại extension.

```bash
# 1. Cài VS Code Stable mới nhất (>= 1.90 để có agent mode ổn định):
#    https://code.visualstudio.com/
code --version
# Kỳ vọng / Verify: hiện 3 dòng, version >= 1.90. Cũ hơn → tải bản mới.

# 2. Ctrl+Shift+X (Extensions) → tìm "GitHub Copilot" → Install
#    (kèm "GitHub Copilot Chat" nếu bản của bạn tách 2 extensions — cài cả 2).
# 3. Reload VS Code khi được yêu cầu.
# 4. Status bar góc dưới-phải: icon Copilot → "Sign in to GitHub" → OAuth → Allow.
```

### 3.1. Verify VS Code

```bash
# Ctrl+Shift+P, chạy lần lượt:
# > "Copilot: Check Status"       -> kỳ vọng: Active, đúng account
# > "Chat: New Chat"              -> kỳ vọng: mở Chat panel bên phải
```

```text
Verify bằng mắt (3 giây):
1. Status bar: icon Copilot không báo lỗi.
2. Gõ code trong file .ts/.py: có ghost text mờ (Tab nhận được).
3. Mở Chat panel (Ctrl+Alt+I): chọn được Model + Mode (Ask/Edit/Agent).
4. Gõ "@workspace repo này làm gì?" -> trả lời đúng (chứng tỏ index chạy).
```

### 3.2. Settings nên bật ngay

```json
// .vscode/settings.json — mẫu team (copy-paste, sửa lại)
{
  "github.copilot.enable": { "*": true },
  "github.copilot.chat.localeOverride": "en",
  "github.copilot.chat.codeGeneration.useInstructionFiles": true
}
```

> `useInstructionFiles: true` là quan trọng nhất — bật thì `.github/copilot-instructions.md` mới được load (chi tiết bài 03).

---

## 4. JetBrains / Visual Studio / Neovim

Quy tắc: **Neovim/VS/JetBrains để gõ + hỏi nhanh. VS Code để agent.** Cùng một Copilot nhưng "đội thợ" (harness) khác nhau — IDE thiếu terminal tool thì task mở sẽ yếu hơn hẳn.

| Tiêu chí | VS Code | JetBrains | Visual Studio | Neovim |
|---|---|---|---|---|
| Cài extension | Marketplace "GitHub Copilot" | Settings → Plugins → Marketplace | Manage Extensions (VS 2022 17.8+) | `copilot.vim` |
| Verify | Status bar active + ghost text Tab | Ghost text + Chat tool window | Ghost text + View → Copilot Chat | `:Copilot status` = Enabled |
| Agent mode | Full tools (đọc/sửa/terminal/MCP) | Hạn chế (terminal tool yếu) | Hạn chế (terminal tool yếu) | Không full |
| Khi nào dùng | Mặc định; task multi-file + terminal | Dev Java/Kotlin/Python/Go | Dev .NET/C++ | Gõ nhanh, fix nhỏ |

```text
# JetBrains: Settings (Ctrl+Alt+S) → Plugins → Marketplace → "GitHub Copilot" → Install
#   → Restart → Tools → "Sign in to GitHub" → OAuth.
# Visual Studio: Extensions → Manage Extensions → "GitHub Copilot" → Install (VS 2022 17.8+)
#   → Restart → Help → "Sign in to GitHub".
```

```bash
# Neovim — cài plugin copilot.vim:
git clone https://github.com/github/copilot.vim.git ~/.config/nvim/pack/github/start/copilot.vim
# Mở nvim, login: :Copilot setup  (OAuth, paste code về nvim)
# Verify:  :Copilot status   -> "Copilot: Enabled" ("Not authenticated" -> chạy lại :Copilot setup)
# Phím tắt: Tab nhận gợi ý · :Copilot enable/disable bật/tắt tạm
```

---

## 5. Copilot CLI

### 5.1. Hai CLI — đừng nhầm

> **Update quan trọng:** Copilot CLI (binary `copilot`) đã **GA từ 03/2026** cho mọi subscriber trả phí — agent hoàn chỉnh trong terminal: agentic workflows, đổi nhiều model, tích hợp GitHub (repo/issue/PR). Chi tiết persona Interactive/Plan/Autopilot + `/permissions`, `/sandbox`: [bài 02 mục 7](./02-cac-be-mat-vscode-ide-web-cli.md).
>
> Riêng `gh copilot` là gh extension **cũ hơn**, chỉ có 2 lệnh `suggest`/`explain` cho lệnh shell — vẫn tiện khi quên flag docker/git.

```bash
# Cài Copilot CLI (agent GA 03/2026):
npm install -g @github/copilot
copilot --version
# Login đúng GitHub account có subscription Copilot trả phí.

# Cài gh + gh-copilot (extension suggest/explain):
brew install gh          # hoặc: sudo apt install -y gh; Windows: https://cli.github.com/
gh auth login            # chọn đúng account trước khi cài extension
gh extension install github/gh-copilot
gh extension upgrade github/gh-copilot   # update khi có bản mới
gh copilot --help        # kỳ vọng: hiện suggest/explain
```

### 5.2. Hai lệnh dùng 90% thời gian (`gh copilot`)

```bash
# suggest: gợi ý lệnh shell:
gh copilot suggest "xoa cac git branch local da merge vao main"
gh copilot suggest "tim file >100MB trong repo hien tai"

# explain: giải thích lệnh khó trước khi chạy:
gh copilot explain "docker run -p 5432:5432 -e POSTGRES_PASSWORD=secret postgres:16"
gh copilot explain "git rebase -i HEAD~3"

# Alias cho gọn (thêm vào ~/.zshrc hoặc ~/.bashrc):
alias cps='gh copilot suggest'
alias cpe='gh copilot explain'
```

> **Nguyên tắc an toàn:** với lệnh nguy hiểm (`rm`, `find -delete`, `docker prune`) — explain trước, chạy khô (`| head`) sau, rồi mới chạy thật.

---

## 6. Login, verify, xử lý lỗi

### 6.1. Login đúng cách

```text
VS Code / JetBrains / Visual Studio: click Copilot status bar/badge → "Sign in to GitHub" → OAuth → Allow.
Neovim: :Copilot setup → OAuth → paste code.
Copilot CLI + gh: gh auth login (chọn đúng account TRƯỚC khi cài copilot extension).

Có 2 account (cá nhân + công ty)? Login sai account = sai quota/policy cả buổi.
Fix: click icon → Sign out → sign in lại đúng account.
```

### 6.2. Verify tổng + bảng lỗi hay gặp

```bash
gh auth status          # kỳ vọng: Logged in to github.com as <bạn>
gh copilot --help       # kỳ vọng: hiện suggest/explain
code --version          # kỳ vọng: VS Code >= 1.90
```

| Triệu chứng | Nguyên nhân likely | Fix (copy-paste) |
|---|---|---|
| Status bar báo "Sign in" mãi sau OAuth | Login sai account / token hết hạn | Sign out → sign in lại đúng account; `gh auth login` lại |
| Ghost text không hiện | Extension tắt cho ngôn ngữ / file quá lớn / duplicate install | Check `github.copilot.enable`, thử file <2000 dòng |
| `@workspace` trả lời sai repo | Index chưa xong / mở sai folder | Mở đúng root (`code .` tại root), đợi index, hỏi lại |
| `gh copilot: command not found` | Chưa cài extension cho gh | `gh extension install github/gh-copilot` |
| `no Copilot subscription` trong CLI | `gh` login sai account / trial hết | `gh auth login` đúng account; check `github.com/settings/copilot` |
| 2 bản Copilot xung đột (ghost text chập chờn) | Còn cả stable + nightly | `code --list-extensions | grep -i copilot`, gỡ bản thừa |
| Neovim `:Copilot status` = Not authenticated | Chưa `:Copilot setup` | Chạy `:Copilot setup`, OAuth lại |
| Chat panel trắng sau update | Version lệch extension vs VS Code | Reload Window; update VS Code Stable mới nhất |

Extensions tự update theo setting. Update tay: `gh extension upgrade github/gh-copilot`; Neovim `git -C ~/.config/nvim/pack/github/start/copilot.vim pull`. Sau update verify lại: `gh copilot --version` + "Copilot: Check Status" → Active.

### 6.3. Walkthrough 15 phút: session đầu chuẩn

```text
Bước 1 (2 phút): mở repo thật trong VS Code, mở Chat mới (Ctrl+Alt+I).
Bước 2 (3 phút): chọn Mode = Agent, chọn model mặc định team dùng.
Bước 3 (5 phút): gõ prompt khôn:
"Đọc README + package.json, tóm tắt: project này là gì,
chạy dev bằng lệnh nào, test bằng lệnh nào. Không sửa gì, chỉ trả lời."
Bước 4 (3 phút): lưu kết quả vào .github/copilot-instructions.md (mẫu ở bài 00).
Bước 5 (2 phút): mở chat mới, hỏi lại câu cũ để kiểm tra instructions có load không.
```

---

## 7. Checklist + pitfalls

### 7.1. Checklist sau cài đặt

- [ ] `gh auth status` đúng account (cá nhân vs công ty).
- [ ] `gh copilot --help` hiện suggest/explain; Copilot CLI `copilot --version` chạy được.
- [ ] VS Code: status bar active + ghost text Tab nhận được.
- [ ] Chat panel: chọn được Model + Mode (Ask/Edit/Agent).
- [ ] `@workspace` trả lời đúng repo (index chạy).
- [ ] `.vscode/settings.json` bật `useInstructionFiles`.
- [ ] Đã chạy walkthrough mục 6.3 trên 1 repo thật.

### 7.2. Hiểu nhầm thường gặp

| Hiểu nhầm | Sự thật |
|---|---|
| "Cài extension là xong, không cần login đúng account" | Sai account = sai quota/policy cả buổi. Luôn `gh auth status` trước |
| "Ghost text không hiện là Copilot hỏng" | Thường do file >2000 dòng, extension tắt cho ngôn ngữ đó, hoặc duplicate install |
| "`gh copilot: command not found` là máy hỏng" | Chỉ là chưa chạy `gh extension install github/gh-copilot` |
| "Copilot CLI = `gh copilot`" | CLI GA 03/2026 là binary `copilot` riêng (agentic); `gh copilot` chỉ suggest/explain lệnh shell |

**Bài học:** kiểm tra account là bước số 0 khi debug (`gh auth status` trước khi nghi tool hỏng); nhiều lỗi CLI chỉ là thiếu một extension, không phải hỏng cài đặt.

---

## Bài tập nhỏ

1. **(10 phút) Verify cài đặt:** chạy hết lệnh mục 6.2 + checklist bằng mắt. Chụp output `gh auth status` (che token), giải thích từng dòng cho đồng nghiệp.
2. **(15 phút) Multi-IDE check:** nếu team có cả VS Code + JetBrains, lập bảng: mỗi IDE cài bằng cách nào, verify bằng lệnh nào, agent mode mạnh tới đâu. Ghi vào team wiki.
3. **(15 phút) CLI drill:** dùng `gh copilot suggest` giải 3 việc thật (git cleanup, docker, ffmpeg...). Chạy thử trong thư mục test trước. Alias `cps/cpe` vào shell config.
4. **(15 phút) Session đầu chuẩn:** trên 1 repo thật, chạy đủ walkthrough mục 6.3. Lưu `copilot-instructions.md` nháp đầu tiên.

---

## Link chéo

- **Bài 00 — Tổng quan**: nếu chưa phân biệt Ask/Edit/Agent, quay lại đọc trước.
- **Bài 02 — Surfaces**: chọn VS Code/JetBrains/github.com/CLI cho từng task.
- **Bài 03 — Instructions**: file `copilot-instructions.md` vừa tạo cần cắt <200 dòng.
- **Bài 04 — Chat commands**: tra cứu `/`, `@`, `#`.
- **Bài 07 — Policies**: quota, model gating, content exclusion.

## Reference

- GitHub Copilot plans & pricing: https://github.com/pricing
- Quản lý plan / AI Credits: https://github.com/settings/copilot
- VS Code Copilot docs: https://code.visualstudio.com/docs/copilot
- GitHub CLI: https://cli.github.com/ · Copilot extension: https://github.com/github/gh-copilot

> **Chốt bài 01:** Copilot chỉ chạy đúng khi plan, account và bề mặt khớp nhau — xác thực bằng `gh auth status` + status bar + ghost text trước khi gõ dòng prompt đầu tiên.
