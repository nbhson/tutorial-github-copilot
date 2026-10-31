# FAQ 01 — Tài Khoản, Pricing & Cài Đặt

> **Vấn đề:** "dùng GitHub Copilot 2026 cần tài khoản gì, tốn bao nhiêu, cài sao cho sạch" — chọn sai plan thì trả thừa tiền hoặc cạn AI Credits giữa tháng; cài trùng extension thì suggestions chết; login nhầm account thì policy org "không ăn". 10 câu dưới đây trả lời đủ cả ba mối lo đó.

## Bảng tổng hợp: chọn đường vào nhanh

| Bạn là ai | Plan cần | Cài thế nào | Việc đầu tiên |
|---|---|---|---|
| Dev cá nhân | Free ($0) hoặc Pro ($10/tháng) | Extension VS Code / JetBrains / Neovim | Mở IDE → sign-in GitHub → check status bar |
| Dev xài nhiều model mạnh | Pro+ ($39) hoặc Max ($100) | Extension + Copilot CLI | `gh copilot --help` test CLI |
| Dev công ty | Business ($19/user) seat do admin cấp | Extension, policy theo org | Xin admin assign seat |
| Enterprise / compliance nặng | Enterprise ($39/user) | SSO/SAML + org policy + audit | Đọc SSO doc nội bộ |
| Thử trước khi mua | Free / Business trial 30 ngày | Như plan tương ứng | Set reminder trước ngày hết hạn |

---

## 1. Các plan khác nhau gì?

**Trả lời 1 câu:** Cá nhân gồm Free / Pro / Pro+ / Max, tổ chức gồm Business / Enterprise — tất cả dùng chung đơn vị thanh toán **AI Credits (1 credit = $0.01)**, tính theo usage từ 01/06/2026.

Giá tham khảo 10/2026 (check `github.com/features/copilot` trước khi chốt):

- **Free ($0):** allowance credits nhỏ, chỉ auto model selection, inline suggestions giới hạn 2.000 completions/tháng. Student/Teacher miễn phí sau xác thực.
- **Pro ($10/tháng):** 1.000 base + 500 flex = **1.500 credits**. Hợp dev cá nhân, side-project.
- **Pro+ ($39/tháng):** 3.900 + 3.100 = **7.000 credits**. Ưu tiên model mới, dùng agent thoải mái hơn.
- **Max ($100/tháng):** 10.000 + 10.000 = **20.000 credits**. Dùng Copilot như pair-programmer full-time.
- **Business ($19/user/tháng):** 1.900 credits/seat/tháng, **pooled cả org**. Thêm org management, policy control, audit cơ bản, IP indemnity. Seat do admin assign.
- **Enterprise ($39/user/tháng):** 3.900 credits/seat/tháng, pooled. Thêm SSO/SAML, audit logs đầy đủ, data residency, review & approve coding-agent PR, SLA.

Quy tắc tính tiền cần nhớ:

- **Code completions + next edit suggestions KHÔNG trừ AI Credits** — không giới hạn trên plan trả phí.
- Plan trả phí dùng **auto model selection được giảm 10%**.
- Hết credits → dùng tiếp tính vào **additional usage budget** (spend cap cấu hình được). **Paid usage policy bật mặc định** — admin phải chủ động tắt để cắt chi tiêu.
- Code review tốn thêm **GitHub Actions minutes** (ngoài AI Credits).

Mấu chốt: **Free/Pro/Pro+/Max = tự trả, tự quản; Business/Enterprise = admin quản, policy đè lên setting cá nhân.**

```bash
# Xem plan hiện tại (cần gh CLI đã login)
gh api user --jq '{login, plan: .plan.name}'
gh api /user/copilot_seat_details --jq . 2>/dev/null || echo "Chua co seat"
# Verify: ra login + tên plan, không phải 404
```

> **Nếu vẫn lỗi:** chạy `gh auth status` xem đúng account chưa; mở `github.com/settings/copilot` đối chiếu plan thật; org thì hỏi admin seat đã gán chưa.

## 2. Trial hoạt động thế nào, hết trial thì sao?

**Trả lời 1 câu:** Plan Free dùng thử không cần thẻ với giới hạn rõ ràng (2.000 completions/tháng); Business trial 30 ngày là full tính năng cho cả org và hết hạn tự chuyển sang trả phí nếu không hủy.

Hết trial: Free → suggestions dừng, chat báo hạn mức; Business trial → org bị downgrade, seat mất, coding agent PR dở dang vẫn giữ nhưng không tạo mới được. Không có lệnh CLI xem trial — check web `github.com/settings/copilot` → "Trial ends on..." và đặt reminder trước 3 ngày.

> **Khi nào áp dụng:** trước khi onboarding team >5 người — luôn trial Business trước, đừng mua blind.

## 3. Seat là gì, admin assign / thu hồi thế nào?

**Trả lời 1 câu:** Seat = 1 ghế Copilot gắn với 1 GitHub user trong org, admin cấp ở `Org → Settings → Copilot → Access`; hết seat thì người kế tiếp báo "No seat available".

Hai chế độ: allow all members (tốn seat theo headcount) hoặc selected teams/users (tiết kiệm). Credits org **pooled ở mức billing entity** — seat nào xài nhiều vẫn lấy chung hạn mức tổ chức.

```bash
# Admin: xem ai đang giữ seat
gh api orgs/<ORG>/copilot/billing/seats --jq '.seats[] | {login: .assignee.login, plan}'
# Assign seat cho 1 team
gh api -X POST orgs/<ORG>/copilot/billing/selected_teams -f selected_teams='["team-slug"]'
# Verify: list ra login + plan; dev trong team thấy Copilot chạy
```

> **Khi nào áp dụng:** khi dev báo "Copilot đòi mua dù đã join org" — 90% là chưa được assign seat.

## 4. Cài đặt thế nào cho sạch: VS Code / JetBrains / Neovim / CLI?

**Trả lời 1 câu:** Mỗi IDE chỉ giữ đúng 1 extension Copilot chính chủ + Copilot Chat — đừng cài thêm fork trôi nổi.

| Bề mặt | Cài gì | Cách auth |
|---|---|---|
| VS Code | `GitHub.copilot` + `GitHub.copilot-chat` | Command Palette → Sign in to GitHub |
| JetBrains | Plugin `GitHub Copilot` (Marketplace) | Login qua browser |
| Neovim | `github/copilot.vim` hoặc `zbirenbaum/copilot.lua` | `:Copilot auth` |
| CLI | `gh extension install github/gh-copilot` hoặc binary `copilot` | `gh auth login` / `copilot init` |

```bash
code --install-extension GitHub.copilot
code --install-extension GitHub.copilot-chat
# Verify: code --list-extensions | grep -i copilot ra đúng 2 dòng

gh extension install github/gh-copilot && gh copilot --help
# Verify: ra help, không phải "command not found"
```

Bản CLI độc lập 2026 là binary `copilot` (có `copilot init`, slash command `/mcp`, `/usage`) — xem [bài 10](10-ci-sdk-review-web.md).

## 5. Sign-in / đổi account (cá nhân ↔ công ty) thế nào?

**Trả lời 1 câu:** Copilot dùng đúng GitHub account đang login trong IDE; đổi bằng sign-out → sign-in (VS Code), `gh auth login/logout` (CLI) hoặc Remove/Add account (JetBrains).

Lỗi kinh điển: máy công ty login nhầm account cá nhân → policy org không áp dụng, bill sai chỗ. Check trước khi đổi: `gh auth status` + `gh api user --jq .login`. Đổi: `gh auth logout && gh auth login --web -h github.com`, hoặc `gh auth switch --user <login>` nếu có nhiều account. Freelancer 2 account nên dùng 2 VS Code profile riêng để khỏi lẫn seat/bill.

> **Khi nào áp dụng:** đầu mỗi máy mới, khi bill sai, và khi policy org "không ăn" (thường do sai account).

## 6. Policy của org đè lên setting cá nhân ra sao?

**Trả lời 1 câu:** Với Business/Enterprise, policy org **luôn thắng** setting cá nhân — bạn bật trong IDE cũng bị ép tắt.

Triệu chứng: setting tự revert sau restart, model picker thiếu model, chat báo "disabled by your administrator". Dev không tự xem được policy — check `github.com/organizations/<ORG>/settings/copilot` → Policies tab, hoặc hỏi admin. Chi tiết [bài 05](05-policies-guardrails-faq.md).

## 7. Lỗi cài đặt kinh điển?

**Trả lời 1 câu:** 3 lỗi top là 2 plugin Copilot đè nhau, IDE quá cũ, và máy thiếu `gh` — gỡ bản lạ, update IDE, cài `gh` là chạy lại.

```bash
code --list-extensions | grep -i copilot
# Verify: ra đúng 2 dòng (GitHub.copilot + GitHub.copilot-chat), thêm = conflict
code --uninstall-extension <ten-la>   # gỡ bản lạ

gh --version && gh extension list | grep copilot
# Verify: gh ra số version, extension list có "github/gh-copilot"
```

> **Khi nào áp dụng:** khi suggestions/chat đột nhiên chết sau update IDE hoặc sau khi vọc extension.

## 8. Bắt đầu repo mới: 5 việc setup đầu?

**Trả lời 1 câu:** Verify suggestions chạy → copy `templates/` (copilot-instructions + mcp.json + settings) → thêm instructions theo stack → thêm MCP nếu cần data ngoài repo → thêm content exclusion cho path nhạy cảm.

```bash
cd ~/code/my-repo && code .
# Trong IDE: gõ thử 1 hàm để verify suggestions (gợi ý xám → Tab)

cp -r /path/to/tutorial-copilot/templates/.github ./
cp -r /path/to/tutorial-copilot/templates/.vscode ./
# Verify: ls .github/ .vscode/ thấy đủ file
```

Copilot đọc instructions tĩnh — repo trống vẫn setup được full khung, chỉ cần sửa ~20% cho khớp stack thật (template ghi `npm test` mà bạn dùng `pnpm` thì sửa ngay, không Copilot gợi ý sai lệnh cả tháng). Team thì commit `.github/` + `.vscode/` để người sau khỏi setup lại.

## 9. Báo lỗi / nhờ hỗ trợ GitHub thế nào?

**Trả lời 1 câu:** Báo qua GitHub Discussions (`github.com/community`) hoặc Support ticket (Business/Enterprise), kèm đủ 3 thứ: plan + IDE version + log thì mới xử lý nhanh.

```bash
gh --version && code --version && code --list-extensions | grep -i copilot
# VS Code: Output panel -> "GitHub Copilot" -> copy đoạn lỗi
```

---

## Vẫn lỗi thì sao? (thứ tự debug chuẩn)

1. `gh auth status` — đúng account chưa, seat còn không.
2. `code --list-extensions | grep -i copilot` — chỉ còn bản chính chủ.
3. Update IDE + extension lên bản mới nhất.
4. Sign-out → sign-in lại GitHub trong IDE.
5. Check `github.com/settings/copilot` — hạn mức/seat/policy có đỏ gì không.

Tham khảo chéo: [bài 02](02-model-context-premium.md) (model + chi phí) · [bài 05](05-policies-guardrails-faq.md) (policy) · [bài 08](08-loi-thuong-gap-troubleshooting.md) (bảng lỗi full) · [../templates/README.md](../templates/README.md) (templates copy ngay).
