# PR title + body — ✨ Generate Description khi mở Pull Request

> **Dành cho:** dev mở PR cho nhánh vừa xong · **Vấn đề:** body chung chung khiến reviewer phải hỏi lại · **Đọc xong:** ra title + body có Đổi gì / Vì sao / Test, reviewer đọc 1 phút là hiểu (~2 phút)
> **Harness:** Copilot · **Surface:** GitHub Pull Requests and Issues extension — nút ✨ trong Create Pull Request view; docs **không** có slash `/pr` trong Chat

## 1 câu nôm na

Nhờ viết "bìa hồ sơ" — tên, nội dung, đã kiểm tra những gì. Khi mở Create Pull Request view, bấm **sparkle ✨ cạnh ô title**: Copilot tóm tắt diff thành title + body; nhưng nếu diff to thì phải **chia PR nhỏ trước**, vì không lời tóm tắt nào cứu được một PR ôm 40 file. · 📄 [VS Code Docs: Copilot smart actions](https://code.visualstudio.com/docs/editing/copilot-smart-actions)

## Vì sao dùng ✨ sinh PR description?

Body PR là nơi reviewer đọc **đầu tiên** — viết tốt thì được review nhanh, viết chung chung thì reviewer phải hỏi lại rồi ngồi chờ bạn trả lời. Nút ✨ dựng sẵn khung Đổi gì / Vì sao nên không quên mục nào (bạn bổ sung Test + Rủi ro). Với team cần chuẩn hóa format PR, repo có **pull request template** thì extension tự điền template — ✨ viết vào đúng khung đó. Giống sinh commit message, việc này dùng **utility model** (`chat.utilitySmallModel`), không phải model phiên chat.

**Nếu làm sai thì sao?** Mặt trái là **PR quá to**: body có hay cỡ nào cũng không cứu được diff ôm nhiều mục đích — reviewer bối rối, comment lan man, merge chậm. Và body thiếu mục **rủi ro** khiến người merge không biết chỗ nào cần soi kỹ (xem mục ❌/✅).

> **Tóm gọn 1 câu:** ✨ viết bìa hồ sơ hộ — nhưng hồ sơ dày 40 trang thì bìa hay đến mấy reviewer cũng bỏ cuộc, nên tách PR nhỏ trước đã. · 📄 [VS Code Docs: Copilot smart actions](https://code.visualstudio.com/docs/editing/copilot-smart-actions)

## Khi nào dùng / khi nào đừng

- **Dùng khi:** bạn mở PR cho nhánh vừa xong, cần body nêu rõ đổi gì + test gì, hoặc muốn chuẩn hóa PR cho team dễ review.
- **ĐỪNG dùng khi:** nhánh đang gộp nhiều việc không liên quan (hãy tách PR trước), hoặc bạn chỉ muốn soi diff của chính mình — mở file trong Source Control hoặc dùng nút **Code Review** (docs: review proposed changes with AI) thay vì đi tìm `/diff` `/review` — hai slash đó docs không có.
- **Cho ai:** mọi người mở PR, đặc biệt team cần chuẩn hóa format PR. · 📄 [VS Code Docs: Choose a feature](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet#choose-a-feature)

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

> Đi tìm slash `/pr` trong Chat? Docs cheat-sheet không liệt kê. Cửa thật: Palette → **GitHub Pull Requests: Create Pull Request** (hoặc nút Create Pull Request trong Pull Requests view) → trong Create view bấm ✨ cạnh ô title. · 📄 [VS Code Docs: Generate PR information](https://code.visualstudio.com/docs/editing/copilot-smart-actions#generate-a-commit-message-and-pr-information)

## Ví dụ thật

Nghiệp vụ: nhánh `feat/login-rate-limit` vừa thêm giới hạn số lần đăng nhập + test, sắp mở PR.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh) · 📄 [VS Code Docs: Code generation & editing](https://code.visualstudio.com/docs/agents/guides/prompt-examples#code-generation-and-editing)

**Kết quả mong đợi:** title conventional + body rõ (đổi gì, vì sao, test, rủi ro); reviewer đọc 1 phút là hiểu và biết chỗ nào cần soi.

**✅ Verify:** đưa body cho 1 teammate đọc — không phải hỏi lại câu nào là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — đợi slash `/pr` + nhánh gộp nhiều việc, body chung chung:**

> 📄 **Code ví dụ:** [`examples/03-neu-lam-sai-thi-sao-sai-ung.sh`](examples/03-neu-lam-sai-thi-sao-sai-ung.sh)

**✅ ĐÚNG — PR một mục đích, ✨ sinh nháp rồi bổ sung Test + Rủi ro:**

> 📄 **Code ví dụ:** [`examples/04-neu-lam-sai-thi-sao-sai-ung.sh`](examples/04-neu-lam-sai-thi-sao-sai-ung.sh) · 📄 [VS Code Docs: Choose a troubleshooting path](https://code.visualstudio.com/docs/agents/agent-troubleshooting/troubleshooting#choose-a-troubleshooting-path)

**Bài học:** PR nhỏ, một mục đích thì body mới rõ; mục **Test** và **Rủi ro** là bắt buộc, không phải tùy chọn.

## Lỗi thường gặp

📄 [VS Code Docs: Creating pull requests](https://code.visualstudio.com/docs/sourcecontrol/github#creating-pull-requests)

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Body chung chung | Diff quá to | Chia PR nhỏ; mỗi PR 1 mục đích |
| Thiếu phần test/rủi ro | ✨ chỉ viết từ diff — test nằm ngoài diff | Tự bổ mục Test + Rủi ro trước khi Create |
| Không thấy nút ✨ | Create view chưa mở đúng (extension PRs) | Cài/ký nhập extension GitHub PRs; mở PR từ view hoặc Palette |
## So sánh với Claude Code

📄 [GitHub Docs: Third-party coding agents](https://docs.github.com/en/copilot/concepts/agent-capabilities/about-agents/about-third-party-coding-agents)

| Việc | Copilot (✨ in PR view) | Claude Code | Ghi chú |
|---|---|---|---|
| Sinh PR title + body | Nút ✨ trong Create Pull Request view | Không có lệnh riêng — yêu cầu bằng prompt hoặc tự tạo command | Copilot: nút trong UI; Claude: luôn qua prompt |
| Đọc diff của nhánh | Tóm tắt từ diff/branch hiện tại | Agent tự đọc `git diff` khi được yêu cầu | Cả hai đều cần bạn nêu đúng nhánh/base |
| Kiểm chứng | Bạn đọc lại body trước khi tạo PR | Bạn vẫn đọc lại | Tạo PR là hành động thật, bản nháp không tự đăng |
## Best practices (kèm "vì sao")

- **Giữ PR một mục đích, diff nhỏ.** *Vì sao?* Reviewer tốn ít thời gian hơn, comment tập trung, merge nhanh hơn.
- **Bổ mục Test đã chạy vào body.** *Vì sao?* Reviewer cần biết bạn đã kiểm chứng gì để tin, thay vì tự đoán — mà diff thì không chứa lịch sử chạy test.
- **Nêu rõ "rủi ro còn lại".** *Vì sao?* Nói ra chỗ chưa chắc giúp người merge soi đúng chỗ và giảm bất ngờ sau deploy.
- **Luôn đọc lại body trước khi bấm Create.** *Vì sao?* ✨ chỉ sinh nháp — PR là thứ đồng nghiệp nhìn thấy, bạn vẫn là người chịu trách nhiệm. · 📄 [VS Code Docs: AI assistance for PRs](https://code.visualstudio.com/docs/sourcecontrol/github#use-ai-assistance-for-pull-requests)

## Bài tập nhỏ

1. **(5 phút)** Mở Create Pull Request view trên nhánh demo, bấm ✨ khi repo **có** template và khi **không** có — so khung sinh ra.
2. **(10 phút)** Viết body cho 1 PR với đủ mục Test + Rủi ro; nhờ 1 teammate đọc xem họ còn hỏi lại gì.
3. **(10 phút)** Lấy 1 nhánh "ôm" nhiều việc, tách thành 2 PR nhỏ — ghi lại PR nào review nhanh hơn. · 📄 [VS Code Docs: Generate PR information](https://code.visualstudio.com/docs/editing/copilot-smart-actions#generate-a-commit-message-and-pr-information)

## Tham khảo

- Docs: [Collaborate on GitHub — Use AI assistance for pull requests](https://code.visualstudio.com/docs/sourcecontrol/github) · [Staging & committing (commit message ✨)](https://code.visualstudio.com/docs/sourcecontrol/staging-commits)
- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Code Actions.
- Cheatsheet 1 trang: [../../../../../CHEATSHEET.md](../../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Bước trước đó (commit message): [commit-message](../commit-message/README.md).

> Chốt: PR là **lời đề nghị bạn gửi đồng nghiệp**, không phải bản báo cáo cho chính bạn — viết để reviewer hiểu trong 1 phút và biết chính xác chỗ nào cần soi.
