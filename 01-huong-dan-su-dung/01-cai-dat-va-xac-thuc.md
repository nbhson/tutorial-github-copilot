# 01 — Cài Đặt, Xác Thực & Kiểm Tra Sức Khỏe Copilot

> **Dành cho:** người mới bắt đầu dùng GitHub Copilot — hoặc đã cài nhưng chưa xác thực được, verify mãi không xanh.
> **Vấn đề:** chọn sai plan, login nhầm tài khoản, cài nhầm tool (`gh copilot` ≠ Copilot CLI) → Copilot báo lỗi hoặc không gợi ý code.
> **Đọc xong:** biết chọn 1 trong 4 plan cá nhân, cài + login OAuth **đúng tài khoản** trên VS Code, chạy được checklist verify 30 giây và sửa được 90% lỗi setup.
> **Thời gian:** ~15 phút đọc + 15 phút làm theo. *(Bài 01 của series)*

## Mục tiêu bài học

Mục này cho bạn biết sau 30 phút sẽ mang được gì về — như danh sách đồ cần mua trước khi vào chợ.

- Liệt kê được **4 plan cá nhân: Free / Pro / Pro+ / Max** và nói plan ảnh hưởng thế nào tới login + hạn mức AI Credits.
- Cài **Copilot trên VS Code** (trọng tâm bài) và login OAuth **đúng tài khoản**; biết JetBrains / Visual Studio / Neovim cũng có chỗ cài.
- Phân biệt **Copilot CLI (binary `copilot`)** với extension cộng đồng **`gh copilot`**, và verify từng cái bằng 1 lệnh.
- Chạy đủ **checklist verify** (`gh auth status`, `copilot --version`, `gh extension list`, status bar, ghost text, Chat) và làm **walkthrough §6.3** trên repo thật.

> **Tóm gọn 1 câu:** "Cài xong" chưa phải "dùng được" — mốc "dùng được" là verify: plan đúng, account đúng, bề mặt đúng, kiểm bằng lệnh chứ không đoán.

---

## 1. Vì sao Copilot 2026 khác trước?

Copilot không còn là một extension gõ tắt: **một subscription chạy trên nhiều bề mặt** — editor (VS Code, JetBrains, Visual Studio), terminal (**Copilot CLI**), github.com + mobile, và cloud — và bạn đổi model ngay trong chat. Docs GitHub ghi mọi plan, kể cả Free, đều kèm Copilot CLI và Copilot app. Cả khoá mặc định thao tác trên **Copilot harness** — runtime chung cho VS Code + CLI + Copilot app, chạy trong **Agent Host**; định nghĩa harness và bản đồ bề mặt thuộc **bài 00 và 02**, bài này không lặp.

## 2. Plan: chọn trước khi cài

### 2.1. Plan ảnh hưởng gì tới cài đặt và đăng nhập

> **Plan là gì?** Gói gắn với tài khoản GitHub — như gói cước điện thoại: gói rẻ dùng cơ bản, gói org kèm đồ quản lý. Cá nhân có **4 plan: Free / Pro / Pro+ / Max** (kèm **Student** cho tài khoản đã xác minh); tổ chức có **Business / Enterprise** — seat và policy do admin quản. Giá và định mức credits do **bài 14** sở hữu; lúc cài chỉ cần 3 điều:

| Plan | Điều cần biết khi cài / đăng nhập |
|---|---|
| Free | Login như bình thường — chưa có subscription thì sign-in tự enrol vào Free; chỉ auto model selection, agent bị giới hạn, chat/agent dừng khi cạn credits |
| Pro / Pro+ / Max | Cùng một luồng cài, khác nhau ở lượng AI credits — lỗi "hết credits giữa task" bắt đầu từ đây; Copilot in the cloud cần plan trả phí |
| Business / Enterprise | Phải login đúng account do org quản, vì policy (content exclusion, model gating) đi theo org — login nhầm là dính policy người khác cả buổi |

Tiền, 1 dòng: billing hiện hành là **GitHub AI Credits — 1 credit = $0,01, tính theo token của model**; **code completions và next edit suggestions không trừ credits** · đăng ký plan + xác nhận subscription đã active: [`examples/01-2-dang-ky-plan-va-verify-tai-khoan.sh`](examples/01-2-dang-ky-plan-va-verify-tai-khoan.sh)

> **Vì sao quan trọng?** Sai plan thì hoặc thiếu credits (agent dừng giữa task, code dở dang), hoặc trả tiền cho tính năng không ai dùng.
> **Nếu làm sai?** Đăng ký một nơi, login một nơi: `github.com/settings/copilot` không hiện plan nghĩa là **đang sai tài khoản**, không phải extension hỏng — kiểm tài khoản trước khi debug bất cứ gì (§6.1).
> **Tóm gọn 1 câu:** Chọn gói nhỏ đủ dùng; xác nhận subscription active trên đúng tài khoản trước khi cài.

## 3. VS Code setup (trọng tâm của khoá)

> **OAuth login là gì?** Cách VS Code nhờ GitHub xác nhận "đúng là bạn" mà không gõ mật khẩu vào VS Code: bấm **Sign in** → browser mở `github.com/login/oauth` → **Allow** → VS Code nhận token lưu ở máy. Token hết hạn thì sign out + sign in lại, **không phải cài lại extension** — như "ra thẻ căn cước ở cổng", thẻ hết hạn thì đổi thẻ, không làm lại hồ sơ.

```text
1. VS Code 2026 da tich hop san Copilot. Khong thay o status bar?
   Ctrl+Shift+X -> tim "GitHub Copilot" -> Install -> Reload window.
2. Hover icon Copilot -> "Use AI Features" -> chon cach dang nhap
   -> browser mo github.com/login/oauth -> Allow (hoac lenh "GitHub Copilot: Sign in").
3. Mo mot REPO THAT (khong phai folder trong) de agent doc duoc workspace context.
```

> 📄 [`examples/01-3-cai-vs-code-va-dang-nhap.sh`](examples/01-3-cai-vs-code-va-dang-nhap.sh) — lệnh đầy đủ, kể cả chọn account cho từng workspace/profile · [`examples/01-3-verify-vs-code-30-giay.sh`](examples/01-3-verify-vs-code-30-giay.sh) — 30 giây verify bằng mắt + bảng phím tắt.

### 3.1. Settings nên bật — và một setting không cần bật

| Setting | Cài đặt | Vì sao |
|---|---|---|
| `chat.disableAIFeatures` | `false` (mặc định) | `true` tắt sạch AI trong VS Code và ẩn luôn icon Copilot — nhiều ca "mất Copilot" chết ở đây |
| `editor.inlineSuggest.enabled` + `github.copilot.enable` | `true` / `{"*": true}` | ghost text im lặng dù login đúng = thường do hai cái này (bật/tắt theo ngôn ngữ, file quá lớn), không phải do tài khoản |
| `github.copilot.chat.codeGeneration.useInstructionFiles` | **không cần bật** | là setting của **Local harness**; Copilot harness tự đọc `.github/copilot-instructions.md` / `AGENTS.md` (bài 03) |

> 📄 [`examples/01-3-settings-nen-bat.jsonc`](examples/01-3-settings-nen-bat.jsonc)

> **Vì sao quan trọng?** VS Code có hàng trăm setting, nhưng đúng ba cái dưới đây quyết định "Copilot có hiện ra hay không"; phần còn lại cứ để mặc định.
> **Nếu làm sai?** Nhét `github.copilot.chat.codeGeneration.useInstructionFiles: true` vào `.vscode/settings.json` rồi tưởng đã bật instructions: đó là setting của **Local harness**, Copilot harness không cần nó — muốn chắc thì verify bằng **Chat: Open Customizations** + mục **References** (§6.3 và bài 03).
> **Tóm gọn 1 câu:** Kiểm ba setting "Copilot có hiện hay không" trước, rồi mới tới 30 giây verify bằng mắt ở §7.

## 4. JetBrains / Visual Studio / Neovim (ghi nhanh)

JetBrains và Visual Studio có extension chính thức; Neovim dùng plugin `github/copilot.vim`. Ba bề mặt này mạnh về gõ + hỏi nhanh; **năng lực agent khác nhau giữa các bề mặt là việc của bài 02** — bài này không lặp bảng so sánh. Đường cài từng IDE (JetBrains: `Ctrl+Alt+S` → Plugins → Marketplace → "GitHub Copilot"; Visual Studio: Extensions → Manage Extensions; Neovim: `:Copilot setup` rồi `:Copilot status` = `Enabled`):

> 📄 [`examples/01-4-jetbrains-visual-studio-neovim.sh`](examples/01-4-jetbrains-visual-studio-neovim.sh)

## 5. Copilot CLI — đừng nhầm với `gh copilot`

**Copilot CLI** là binary tên **`copilot`** (`brew install --cask copilot-cli` · `npm install -g @github/copilot` · `winget install GitHub.Copilot`), chạy đúng Copilot harness trong terminal; lần đầu gõ `/login` (hoặc `copilot login`). **`gh copilot` chỉ là extension cộng đồng của GitHub CLI** — 2 lệnh `suggest`/`explain` cho lệnh shell, tiện khi quên flag, nhưng không phải Copilot CLI. Nhầm hai cái là install xong ngồi hỏi "sao terminal không có agent". CLI sâu hơn (flags, modes, headless, CI/CD): **bài 12** · hai lệnh `gh copilot`: [cli-suggest](commands/local/system-knowledge/cli-suggest/README.md).

## 6. Login, verify, xử lý lỗi

### 6.1. Login đúng cách

```text
VS Code / JetBrains / Visual Studio: hover icon Copilot -> "Sign in to GitHub" -> OAuth -> Allow.
Neovim: :Copilot setup -> OAuth -> paste code.    Copilot CLI: chay `copilot`, go /login
  # automation: xuat PAT fine-grained (quyen "Copilot Requests") trong COPILOT_GITHUB_TOKEN.
Co 2 account (ca nhan + cong ty): VS Code -> Accounts menu -> "Manage Extension Account
  Preferences" -> chon account cho workspace/profile; kiem bang `gh auth status` truoc khi lam gi.
```

Login sai account giống "quẹt thẻ nhầm ví": máy vẫn chạy, nhưng tiêu tiền (quota, policy) của ví khác.

### 6.2. Verify tổng + bảng lỗi hay gặp

```text
copilot --version      # Copilot CLI, binary la `copilot` — KHONG phai `gh copilot`
gh extension list      # thay gh-copilot? chi khi do `gh copilot suggest/explain` moi ton tai
gh auth status         # dung account (ca nhan vs cong ty) — kiem dau tien
```

> 📄 [`examples/01-6-verify-tong-va-bang-loi.sh`](examples/01-6-verify-tong-va-bang-loi.sh)

| Triệu chứng | Nguyên nhân likely | Fix (copy-paste) |
|---|---|---|
| Status bar báo "Sign in" mãi sau OAuth | Login sai account / token hết hạn | Sign out → sign in lại đúng account; `gh auth login` lại |
| Ghost text không hiện | Extension tắt cho ngôn ngữ / file quá lớn / duplicate install | Check `github.copilot.enable`, thử file <2000 dòng |
| Chat trả lời sai về repo | Index chưa xong / mở sai folder | Mở đúng root (`code .` tại root), đợi index, hỏi lại |
| `gh copilot: command not found` | Chưa cài extension cộng đồng cho gh | `gh extension install github/gh-copilot` (KHÔNG phải Copilot CLI) |
| `no Copilot subscription` trong CLI | CLI/`gh` login sai account / trial hết | `/login` lại trong `copilot`; check `github.com/settings/copilot` |
| 2 bản Copilot xung đột (ghost text chập chờn) | Còn cả stable + nightly | Chạy `code --list-extensions` rồi grep `copilot`, gỡ bản thừa |
| Neovim `:Copilot status` = Not authenticated | Chưa `:Copilot setup` | Chạy `:Copilot setup`, OAuth lại |
| Chat panel trắng sau update | Version lệch extension vs editor | Reload Window; update editor bản Stable mới nhất |

**Cách đọc bảng:** tìm đúng dòng ở cột "Triệu chứng" rồi chép cột "Fix" chạy luôn; "gỡ cài đặt làm lại" là bước cuối, không phải bước đầu. Extensions tự update theo setting — update tay: `copilot update` (CLI), `gh extension upgrade github/gh-copilot`, Neovim `git -C .../copilot.vim pull`. Sau mọi bản update, chạy lại 3 lệnh trên + hover icon Copilot để mở **Copilot status dashboard** (plan + % allowance tháng đã dùng). Lỗi khó hơn bảng này: [troubleshoot](commands/copilot/chat-session/troubleshoot/README.md) · FAQ series: bài 03.

### 6.3. Walkthrough 15 phút: session đầu chuẩn

```text
Buoc 1 (2 phut): mo repo THAT trong VS Code, mo Chat moi (Ctrl+Alt+I, roi Ctrl+N).
Buoc 2 (3 phut): Session Target = Copilot; chon built-in agent = Agent, model mac dinh team dang dung.
Buoc 3 (5 phut): go prompt:
"Doc README + package.json, tom tat: project nay la gi,
 chay dev bang lenh nao, test bang lenh nao. Khong sua gi, chi tra loi."
Buoc 4 (3 phut): luu ket qua vao AGENTS.md hoac .github/copilot-instructions.md (mau o bai 03).
Buoc 5 (2 phut): "Chat: Open Customizations" -> tab Instructions -> file phai duoc liet ke;
  mo chat MOI, hoi lai cau cu -> muc "References" phai co ten file.
```

**Vì sao quan trọng?** Đây là "bài thi" của cả khối cài đặt + xác thực: mỗi bước chạm đúng một thứ có thể hỏng (extension, account, index, instructions) và bước cuối tự kiểm chứng bằng chính docs VS Code — Customizations editor chứng minh file được **khám ra**, mục References chứng minh nó **được gửi vào request**.
**Nếu làm sai?** Bỏ bước 5 — instructions lưu rồi nhưng chưa session nào đọc qua, bạn chỉ phát hiện khi một người khác chạy repo này.
> **Tóm gọn 1 câu:** Session đầu chuẩn = mở Chat → Agent → prompt "tóm tắt repo" → lưu instructions → **verify bằng Customizations editor + References**, rồi hỏi lại trong chat mới.

## 7. Checklist sau cài đặt (30 giây bằng mắt + 3 lệnh)

- [ ] Status bar: icon Copilot không còn báo "Sign in"; hỏi "Repo này làm gì?" gọi được tên file **thật** trong repo (index chạy).
- [ ] Ghost text hiện trong file `.ts`/`.py` ở repo thật và **Tab** nhận được.
- [ ] Chat view (`Ctrl+Alt+I`): chọn được Model + built-in agent (Ask / Plan / Agent).
- [ ] `AGENTS.md` / `.github/copilot-instructions.md` hiện trong **Chat: Open Customizations**.
- [ ] `gh auth status` đúng account (cá nhân vs công ty).
- [ ] `copilot --version` chạy được; `gh extension list` thấy `gh-copilot` **nếu** bạn dùng `suggest/explain`.
- [ ] Đã chạy walkthrough §6.3 trên 1 repo thật.

## Lỗi thường gặp (❌ SAI / ✅ ĐÚNG)

| ❌ SAI | Hệ quả | ✅ ĐÚNG |
|---|---|---|
| "Cài extension là xong, cần gì login đúng account" | Tiêu quota và policy của tài khoản khác cả buổi mà không hiểu sao | `gh auth status` trước khi làm bất cứ gì |
| "Copilot CLI = `gh copilot`" | Cài nhầm tool, rồi hỏi sao terminal không có agent | `copilot --version` cho CLI; `gh extension list` cho extension cộng đồng |
| Thấy "Sign in" hoài → gỡ extension cài lại | Mất 30 phút, lỗi vẫn còn | Sign out → sign in lại; token hết hạn thì đổi token, không đổi hồ sơ |
| Ghost text không hiện → kết luận Copilot hỏng | Bỏ qua nguyên nhân thật: tắt cho ngôn ngữ / file quá lớn / 2 bản cài | Chạy dọc bảng §6.2 trước khi kết luận |
| Nghĩ `Ctrl+Alt+I` là Quick Chat | Không tìm thấy ô nhập nhỏ, tưởng phím bị gỡ | `Ctrl+Alt+I` = mở **Chat view**; Quick Chat = `Ctrl+Shift+Alt+L`; inline chat = `Ctrl+I` |

**Bài học:** 90% lỗi setup không phải tool hỏng mà là **account** hoặc **tên tool** — luôn bắt đầu debug bằng `gh auth status`, rồi đọc bảng §6.2, cuối cùng mới nghĩ tới cài lại.

## Best practices (kèm "Vì sao?")

- **Chạy `gh auth status` đầu mỗi ngày làm việc, không đợi có lỗi.** *Vì sao:* login sai account chỉ lộ ra ở lỗi quota hay policy đầu tiên, và lỗi đó trông hệt "tool hỏng".
- **Bảo đảm subscription active (plan hoặc Free) trước khi cài.** *Vì sao:* chưa active thì sign in vẫn được nhưng mọi thứ lỗi — bạn sẽ debug sai chỗ.
- **Đưa nguyên walkthrough §6.3 vào onboarding người mới.** *Vì sao:* 15 phút đó là "health check" toàn máy: extension, account, index, instructions — mỗi bước soi đúng một chỗ.
- **Dùng một profile browser duy nhất cho OAuth (VS Code, CLI, github.com).** *Vì sao:* ai có 2 tài khoản rất hay dính "browser nhớ account cũ" — sign out trên browser trước, rồi sign in lại trong IDE.

## Bài tập

1. **(10 phút) Verify bằng mắt:** chạy hết 3 lệnh ở §6.2 + checklist §7. Lưu output `gh auth status` và `copilot --version` (che token), giải thích từng dòng cho một đồng nghiệp.
2. **(15 phút) Session đầu thật sự:** chạy đủ walkthrough §6.3 trên một repo của bạn; giữ lại `AGENTS.md` draft đầu tiên (rẽ tiếp ở bài 03).
3. **(5 phút) Phân biệt 2 CLI:** chạy `copilot --version` và `gh copilot suggest --help`; nếu `gh extension list` chưa thấy `gh-copilot` mà bạn vẫn muốn dùng `suggest`, cài `gh extension install github/gh-copilot` rồi thử 1 lệnh git cleanup (chạy ở thư mục test trước).

## Link qua

- Chưa phân biệt Ask/Plan/Agent, chưa rõ "harness" là gì → **bài 00**. · Task nào nên ở IDE nào / web / terminal → **bài 02**.
- Walkthrough bước 4 vừa lưu file → mở **bài 03** để cắt <200 dòng và viết đúng. · Cần biết VS Code extensions nào bắt buộc → **bài 09**.
- Copilot CLI sâu hơn (flags, modes, headless, sandbox) → **bài 12**. · Giá + AI Credits chi tiết → **bài 14**.
- Tra nhanh: [login](commands/copilot/system-knowledge/login/README.md) · [logout](commands/copilot/system-knowledge/logout/README.md) · [status](commands/copilot/system-knowledge/status/README.md) · [session-target](commands/copilot/model-agent/session-target/README.md) · [cli-suggest](commands/local/system-knowledge/cli-suggest/README.md).

## Reference

- GitHub — [Plans for GitHub Copilot](https://docs.github.com/en/copilot/get-started/plans) (Free / Pro / Pro+ / Max + Student, Business, Enterprise) · [Models and pricing — GitHub AI Credits](https://docs.github.com/en/copilot/reference/copilot-billing/models-and-pricing) (1 credit = $0,01, per-token, code completions không trừ credits) · quản lý subscription: [github.com/settings/copilot](https://github.com/settings/copilot)
- GitHub — [Install Copilot CLI](https://docs.github.com/en/copilot/how-tos/set-up/install-copilot-cli) (`brew install --cask copilot-cli` / `npm install -g @github/copilot` / `winget install GitHub.Copilot`, `/login`) · [CLI command reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference) (`copilot --version`, `copilot update`)
- VS Code — [Set up GitHub Copilot](https://code.visualstudio.com/docs/setup/copilot) ("Use AI Features", GHE, đổi account, `chat.disableAIFeatures`) · [Agent harnesses](https://code.visualstudio.com/docs/agents/concepts/agent-harnesses) · [Cheat sheet — phím tắt](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet) · [Custom instructions reference](https://code.visualstudio.com/docs/agents/reference/custom-instructions-reference) (settings instructions thuộc Local harness)
- Khác — [GitHub CLI](https://cli.github.com/) · extension cộng đồng `gh copilot`: [github/gh-copilot](https://github.com/github/gh-copilot) · [github/copilot.vim](https://github.com/github/copilot.vim) · JetBrains [GitHub Copilot plugin](https://plugins.jetbrains.com/plugin/17718-github-copilot)

**Chốt:** Copilot chỉ chạy đúng khi plan, account và bề mặt khớp nhau — ba lệnh `gh auth status`, `copilot --version`, `gh extension list` cùng 30 giây nhìn status bar/ghost text/Chat là ranh giới giữa "đã cài" và "dùng được"; `copilot` mới là Copilot CLI, `gh copilot` chỉ là extension cộng đồng.
