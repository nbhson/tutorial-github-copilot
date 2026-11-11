# Commit message — sparkle "Generate Commit Message" từ diff

> **Dành cho:** dev vừa stage xong và sắp commit · **Vấn đề:** message "update stuff" không nói được đổi gì + vì sao · **Đọc xong:** sinh message conventional từ staged diff bằng nút sparkle, duyệt trước khi Commit (~2 phút)
> **Harness:** Copilot · **Surface:** Source Control — sparkle trong ô commit message (docs: "Generate commit messages with AI"); KHÔNG có slash `/commit` trong chat reference

## 1 câu nôm na

Nhìn đống hàng đã gói, viết phiếu gửi đúng mẫu bưu điện. Nút **sparkle ✨** ở ô commit message đọc diff rồi viết message theo conventional commits (feat/fix + scope + mô tả); nó chỉ nhìn phần bạn đã **stage**, nên stage gọn từng phần thì message mới đúng. · 📄 [VS Code Docs: Copilot smart actions](https://code.visualstudio.com/docs/editing/copilot-smart-actions)

## Vì sao dùng sparkle sinh message?

Message tốt là message nói được cả **đổi gì** lẫn **vì sao** — thứ mà lịch sử commit sẽ trả lời cho đồng nghiệp (và cho chính bạn) sáu tháng sau. Sparkle dựng sẵn dòng đầu theo chuẩn conventional (để CI/changelog parse được) kèm body ngắn. Nó biến việc "nghĩ message" từ 2 phút xuống 10 giây, và giữ log của cả team nhất quán.

**Hai điều ít người để ý từ docs:** (1) việc sinh message dùng **utility model** (`chat.utilitySmallModel`), không phải model bạn chọn cho chat/agent; (2) có thể khai **instructions riêng cho commit message sinh tự động** (Custom Instructions → Generated content) để nó bám chuẩn team.

**Nếu làm sai thì sao?** Cạm bẫy là **stage quá to rồi commit một cục**: diff lộn xộn thì message sinh ra cũng chung chung (`chore: update files`) — đúng cái bạn muốn tránh. Và sparkle chỉ *gợi ý*: commit là hành động thật, bạn vẫn phải đọc lại message trước khi Commit (xem mục ❌/✅).

> **Tóm gọn 1 câu:** Sparkle viết phiếu gửi từ đống hàng bạn đã gói — stage gọn thì message chuẩn, và bạn vẫn là người duyệt cuối trước khi Commit. · 📄 [VS Code Docs: Copilot smart actions](https://code.visualstudio.com/docs/editing/copilot-smart-actions)

## Khi nào dùng / khi nào đừng

- **Dùng khi:** bạn vừa stage xong và cần message gọn đúng chuẩn, team ép conventional commits, hoặc muốn message nêu được "đổi gì + vì sao".
- **ĐỪNG dùng khi:** bạn chưa stage gì (nó chỉ nhìn phần diff được đưa vào commit), hoặc thay đổi gộp nhiều mục đích — hãy tách thành nhiều commit trước.
- **Muốn AI soi code trước khi commit?** Source Control view còn có nút **Code Review** — review uncommitted changes, khác việc sinh message. · 📄 [VS Code Docs: Choose a feature](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet#choose-a-feature)

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

> Đi tìm slash `/commit` trong Chat? Docs cheat-sheet không liệt kê — cửa thật là ✨ ở ô commit message của Source Control view (`Ctrl+Shift+G`). · 📄 [VS Code Docs: Generate commit message](https://code.visualstudio.com/docs/editing/copilot-smart-actions#generate-a-commit-message-and-pr-information)

## Ví dụ thật

Nghiệp vụ: vừa thêm null check cho email có dấu trong luồng login (fix bug 500), đã stage đúng 2 file.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh) · 📄 [VS Code Docs: Code generation & editing](https://code.visualstudio.com/docs/agents/guides/prompt-examples#code-generation-and-editing)

**Kết quả mong đợi:** `fix(auth): handle accented email in login` kèm body ngắn nêu nguyên nhân — log sạch, CI parse được.

**✅ Verify:** đọc lại message trong 5 giây mà hiểu "đổi gì + vì sao" là đạt; không thì sửa tay trước khi Commit.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — tìm slash `/commit`, rồi stage một cục lộn xộn:**

> 📄 **Code ví dụ:** [`examples/03-neu-lam-sai-thi-sao-sai-ung.sh`](examples/03-neu-lam-sai-thi-sao-sai-ung.sh)

**✅ ĐÚNG — stage gọn theo mục đích, bấm ✨, đọc lại message:**

> 📄 **Code ví dụ:** [`examples/04-neu-lam-sai-thi-sao-sai-ung.sh`](examples/04-neu-lam-sai-thi-sao-sai-ung.sh) · 📄 [VS Code Docs: Choose a troubleshooting path](https://code.visualstudio.com/docs/agents/agent-troubleshooting/troubleshooting#choose-a-troubleshooting-path)

**Bài học:** message tốt bắt đầu từ **diff gọn**; và sparkle chỉ sinh nháp — commit là hành động thật, bạn duyệt cuối.

## Lỗi thường gặp

📄 [VS Code Docs: Git troubleshooting](https://code.visualstudio.com/docs/sourcecontrol/troubleshooting)

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Message chung chung ("update stuff") | Diff stage quá to/lộn xộn | Stage gọn từng phần, commit từng phần |
| Sai scope conventional | Model đoán scope | Khai instructions sinh commit message theo chuẩn team |
| Quên bối cảnh "vì sao" | Chỉ liệt kê "đổi gì" | Thêm 1 dòng "vì sao" vào body trước khi Commit |
## So sánh với Claude Code

📄 [GitHub Docs: Third-party coding agents](https://docs.github.com/en/copilot/concepts/agent-capabilities/about-agents/about-third-party-coding-agents)

| Việc | Copilot (sparkle commit) | Claude Code | Ghi chú |
|---|---|---|---|
| Sinh commit message | Nút ✨ trong Source Control (utility model) | Yêu cầu bằng prompt ("write a commit for these changes") | Copilot: một cú click ngoài chat; Claude: luôn qua prompt |
| Đọc staged diff | Lấy diff được commit làm nguồn | Cũng đọc staged diff khi được yêu cầu | Cả hai chỉ thấy phần đã stage |
| Kiểm chứng | Bạn đọc lại message trước khi Commit | Bạn vẫn đọc lại | Commit là hành động thật, không tin mù bản nháp |
## Best practices (kèm "vì sao")

- **Stage gọn theo một mục đích trước khi bấm ✨.** *Vì sao?* Message chỉ tốt bằng diff nó nhìn thấy — diff lộn xộn thì message cũng lộn xộn.
- **Khai instructions cho commit message sinh tự động.** *Vì sao?* Mỗi team một chuẩn; khai một lần để mọi message hợp chuẩn, khỏi sửa tay.
- **Bắt body nêu "vì sao", không chỉ "đổi gì".** *Vì sao?* Diff đã cho biết "đổi gì"; thứ lịch sử commit không tự nói được là lý do.
- **Luôn đọc lại trước khi Commit.** *Vì sao?* Sparkle sinh nháp; commit sai phải viết lại lịch sử — phiền hơn nhiều. · 📄 [VS Code Docs: Staging & commits](https://code.visualstudio.com/docs/sourcecontrol/staging-commits)

## Bài tập nhỏ

1. **(5 phút)** Stage tất cả một cục rồi bấm ✨; sau đó stage gọn 1 file và làm lại. So sánh hai message.
2. **(10 phút)** Sinh message cho 1 fix thật, bắt body phải có 1 dòng "vì sao". Đọc lại xem 6 tháng sau bạn có hiểu không.
3. **(5 phút)** Bấm nút **Code Review** trong Source Control trước khi commit — phân biệt kết quả review với message được sinh ra. · 📄 [VS Code Docs: Generate commit message](https://code.visualstudio.com/docs/editing/copilot-smart-actions#generate-a-commit-message-and-pr-information)

## Tham khảo

- Docs: [Staging & committing — Generate commit messages with AI](https://code.visualstudio.com/docs/sourcecontrol/staging-commits) · [Custom instructions cho generated content](https://code.visualstudio.com/docs/agents/reference/custom-instructions-reference)
- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Code Actions.
- Cheatsheet 1 trang: [../../../../../CHEATSHEET.md](../../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Bước tiếp theo sau commit (mở PR): [pr-desc](../pr-desc/README.md).

> Chốt: log của bạn là cuốn nhật ký đọc lại lúc 2 giờ sáng đang sửa sự cố — viết message sao cho tương lai thấy được **đổi gì và vì sao**, chứ không phải "update stuff".
