# Đăng nhập GitHub cho Copilot

> **Dành cho:** người mới cài, người đổi máy hoặc đổi account · **Vấn đề:** token hết hạn làm Copilot im lặng, không gợi ý gì · **Đọc xong:** đăng nhập đúng account và verify được đang ở account/plan nào (~2 phút)
> **Harness:** Copilot · **Surface:** VS Code Chat (Copilot harness) / Copilot CLI / GitHub.com

## 1 câu nôm na

Đăng nhập Copilot giống xuất trình thẻ nhân viên để vào tòa nhà: bạn xác thực bằng OAuth GitHub, rồi kiểm tra lại mình đã vào đúng account chưa. Ở VS Code thì bấm icon Copilot → **Sign in with GitHub**; ở Copilot CLI thì `copilot login` (hoặc `/login` trong phiên). · 📄 [VS Code Docs: Customize AI agents (overview)](https://code.visualstudio.com/docs/agent-customization/overview)

## Vì sao phải để ý chuyện login?

Vì Copilot im lặng khi token hết hạn hoặc khi bạn login sai account — không có thông báo rõ ràng, chỉ là không thấy gợi ý nào. Login lại là cách nhanh nhất để cấp quyền, và verify trạng thái để chắc chắn đã vào đúng account/plan.

| Bạn đang ở đâu | Login | Verify sau login |
|---|---|---|
| VS Code (Copilot harness) | Icon Copilot / Account → **Sign in with GitHub** | Copilot status dashboard (hover icon Copilot ở dưới cùng VS Code) |
| Copilot CLI | `copilot login` (lần đầu, từ shell) hoặc `/login` trong phiên | `/user show` (account/plan), `/diagnose` khi có vấn đề |
| Copilot CLI trên server không có browser | `copilot login --device-code` | `/user show` |
| Script/CI | `copilot login --with-token < mytoken.txt` | `copilot version` + chạy 1 prompt thử |

> **Device code / web flow / token:** `copilot login` có các cờ `--device-code` (máy từ xa, không browser), `--web-flow` (mở browser), `--with-token` (đọc token từ stdin) và `--host <URL>` cho GHES. Nguồn: CLI command reference. · 📄 [VS Code Docs: Customize AI agents (overview)](https://code.visualstudio.com/docs/agent-customization/overview)

**Nếu làm sai thì sao?** Login xong vẫn không có gợi ý là chuyện thường, vì còn hai nguyên nhân khác: chưa được cấp seat, hoặc file bị content exclusion. Đừng vội kết luận "login hỏng" — kiểm tra tiếp seat + exclusion + trạng thái.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** mới cài / đổi máy; token hết hạn (Copilot silent fail); đổi account cá nhân ↔ công ty.
- **ĐỪNG dùng như:** cách chọn account khi máy có hai account mà chưa logout — cache token cũ dễ khiến bạn đăng nhập nhầm. Hãy [logout](../logout/README.md) trước rồi login lại. · 📄 [VS Code Docs: Choose a customization scope](https://code.visualstudio.com/docs/agent-customization/overview#choose-a-customization-scope)

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

> Copilot CLI không phải VS Code: nếu bạn đang ở CLI, `copilot login` chạy từ shell và không cần mở Chat view. · 📄 [VS Code Docs: Set up GitHub Copilot](https://code.visualstudio.com/docs/setup/copilot#set-up-github-copilot)

## Ví dụ thật

Nghiệp vụ: sáng nay Copilot không gợi ý gì sau khi bạn đổi sang laptop công ty.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh) · 📄 [VS Code Docs: Create project instructions](https://code.visualstudio.com/docs/agents/guides/customize-copilot-guide#step-1-create-project-instructions)

**Kết quả mong đợi:** đăng nhập đúng account; status dashboard/`/user show` hiện đúng account + plan; ghost text chạy lại.

**✅ Verify:** ghost text + Chat đều chạy sau login là đạt. Chỉ một cái chạy thì xem tiếp seat/exclusion.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

❌ SAI: máy có 2 account, bạn `copilot login` luôn mà không logout → đăng nhập nhầm account, sai hạn mức và policy.

✅ ĐÚNG: logout trước → login lại → làm theo popup đúng account cần dùng → verify trạng thái.

**Bài học:** hai account là cái bẫy hay gặp nhất. Thứ tự đúng là logout rồi login, không phải login chồng lên cache cũ. · 📄 [VS Code Docs: Troubleshoot customization issues](https://code.visualstudio.com/docs/agent-customization/overview#troubleshoot-customization-issues)

## Lỗi thường gặp

📄 [VS Code Docs: Subscription not detected](https://code.visualstudio.com/docs/agents/agent-troubleshooting/faq#my-copilot-subscription-is-not-detected-in-vs-code)

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Login nhầm account | Máy có 2 GitHub account | Logout rồi login lại đúng account; CLI có `/user switch` |
| Popup đăng nhập bị chặn | Browser/proxy chặn popup | Mở browser mặc định, tắt chặn popup tạm thời; hoặc `--device-code` |
| Login xong vẫn không gợi ý | Chưa có seat / file bị exclusion | Kiểm seat + [content-exclusion](../../../cloud/system-knowledge/content-exclusion/README.md) + status dashboard |
| `copilot login` báo invalid token | Token hết hạn/sai scope | Tạo token mới, truyền lại qua `--with-token` |
## So sánh với Claude Code

📄 [GitHub Docs: Comparing customizations](https://docs.github.com/en/copilot/concepts/customizations/comparing-customizations)

| Việc | Copilot | Claude Code | Ghi chú |
|---|---|---|---|
| Cách xác thực | OAuth tài khoản GitHub (VS Code, CLI) | Đăng nhập Anthropic hoặc API key | Khác nhà cung cấp, cùng ý tưởng "1 login dùng nhiều bề mặt" |
| Đổi account | Logout rồi login lại; CLI `/user switch` | Đổi key/account trong config | Cả hai đều khuyên đổi sạch thay vì chồng |
| Kiểm chứng sau login | Status dashboard + thử ghost text | Chạy thử một prompt | Bạn vẫn là người verify |
## Best practices (kèm "vì sao")

- **Có 2 account thì logout trước khi login lại.** *Vì sao?* Token cũ còn cache dễ khiến bạn vào nhầm account mà không biết.
- **Login xong luôn kiểm tra trạng thái.** *Vì sao?* Đăng nhập "thành công" chưa chắc đúng account/plan — verify mới biết.
- **Popup bị chặn thì đổi browser mặc định.** *Vì sao?* OAuth cần mở đúng URL callback trong browser mặc định; proxy/chặn popup là nguyên nhân phổ biến.
- **Không có gợi ý thì kiểm seat + exclusion trước khi login lại.** *Vì sao?* Login đúng rồi mà thiếu seat thì vẫn im lặng — login lại vô ích. · 📄 [VS Code Docs: Use a different GitHub account](https://code.visualstudio.com/docs/setup/copilot#use-a-different-github-account-with-copilot)

## Bài tập nhỏ

1. **(5 phút)** Login rồi mở Copilot status dashboard, ghi lại account/plan. Nếu có 2 account, logout rồi login lại account còn để thấy khác biệt.
2. **(10 phút)** Mô phỏng lỗi "login xong không gợi ý": kiểm tra seat + content exclusion rồi ghi lại phát hiện. · 📄 [VS Code Docs: Set up GitHub Copilot](https://code.visualstudio.com/docs/setup/copilot#set-up-github-copilot)

## Tham khảo

- Index nhóm: [../README.md](../README.md) · Logout/đổi account: [../logout/README.md](../logout/README.md) · Trạng thái: [../status/README.md](../status/README.md).
- Cài đặt + xác thực chi tiết: [01-cai-dat-va-xac-thuc.md](../../../../01-cai-dat-va-xac-thuc.md) · Cheatsheet: [CHEATSHEET.md](../../../../../CHEATSHEET.md) · Kẹt thì tra [FAQ troubleshooting](../../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- GitHub — [Install & authenticate Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/install-copilot-cli) · VS Code — [Set up Copilot](https://code.visualstudio.com/docs/setup/copilot).

> Chốt: login chỉ là bước mở cửa — nếu đăng nhập đúng rồi mà Copilot vẫn im, vấn đề nằm ở seat hoặc exclusion, đừng quay lại đăng nhập tiếp.
