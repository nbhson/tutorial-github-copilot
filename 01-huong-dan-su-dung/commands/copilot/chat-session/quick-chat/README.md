# Quick Chat (Chat nhanh)

> **Harness:** Copilot · **Surface:** Chat view · Quick Chat
> **Mục đích:** mở hộp thoại Copilot nhanh mà không cần chuyển sang panel Chat.
> Phím mở Quick Chat là `Ctrl+Shift+Alt+L` (macOS: `⇧⌥⌘L`) — cách nhanh nhất để hỏi Copilot mà
> giữ nguyên layout hiện tại. Trong bảng Chat của
> [Cheat Sheet](../../../../../CHEATSHEET.md), đây là dòng "Mở Quick Chat".

## Quick Chat là gì?

Quick Chat là hộp thoại thu gọn của Chat view: cùng harness Chat, cùng mô hình,
nhưng chỉ có một ô nhập nổi giữa màn hình. Nó là surface của Chat view trong VS Code —
Agents window không được docs ghi nhận có Quick Chat riêng.
Dùng khi bạn cần hỏi nhanh rồi code tiếp,
không muốn mở panel bên hông. · 📄 [VS Code Docs: Sessions (concept)](https://code.visualstudio.com/docs/agents/concepts/sessions)

## Cách mở

📄 [VS Code Docs: Use Quick Chat](https://code.visualstudio.com/docs/chat/inline-chat#use-quick-chat)

| Cách | Thực hiện |
|---|---|
| Phím tắt | `Ctrl+Shift+Alt+L` (macOS: `⇧⌥⌘L`) |
| Command Palette | `Ctrl+Shift+P` (macOS: `⇧⌘P`) → gõ "Quick Chat" rồi chọn lệnh mở Quick Chat |
## Cách sử dụng

1. Mở Quick Chat, gõ câu hỏi (thêm `#file` để đưa ngữ cảnh nếu cần).
2. `Enter` để gửi — câu trả lời hiện ngay trong hộp nhỏ.
3. Câu hỏi dài hoặc nhiều vòng? Mở Chat view (`Ctrl+Alt+I`, macOS: `⌃⌘I` — lệnh "Open Chat view")
   và hỏi tiếp ở đó — panel đầy đủ hiển thị danh sách phiên, checkpoint, giá trị `#context` rõ hơn.
4. `Esc` để đóng. · 📄 [VS Code Docs: Use Quick Chat](https://code.visualstudio.com/docs/chat/inline-chat#use-quick-chat)

## Điều hướng

📄 [VS Code Docs: Chat and agent keyboard shortcuts](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet#essential-keyboard-shortcuts)

| Phím | Tác dụng |
|---|---|
| `Ctrl+Shift+Alt+L` (macOS: `⇧⌥⌘L`) | Mở/đóng Quick Chat |
| `Enter` | Gửi câu hỏi |
| `Esc` | Đóng Quick Chat, về lại editor |
## Mẹo

1. Quick Chat hợp với câu 1–2 lượt ("hàm này làm gì?"); việc nhiều bước hãy dùng Chat view.
2. Quick Chat thuộc Chat view trong VS Code, không phải lệnh trong Copilot CLI —
   muốn làm việc trong terminal thì học CLI sau.
3. Kết quả quan trọng thì giữ lại: `Chat: Export Chat…` lưu Markdown/JSON —
   xem [Clear chat](../clear/README.md). · 📄 [VS Code Docs: Start a quick chat](https://code.visualstudio.com/docs/agents/run/agents-window#start-a-quick-chat)

## Bài tập

→ [01 - Gọi Quick Chat bằng phím](examples/01-cach-goi-copy-paste.sh)
→ [02 - Ví dụ thật](examples/02-vi-du-that.sh)
→ [03 - Làm sai thì sai ở đâu](examples/03-neu-lam-sai-thi-sao-sai-ung.sh)
→ [04 - Câu hỏi quá sức với Quick Chat](examples/04-neu-lam-sai-thi-sao-sai-ung.sh) · 📄 [VS Code Docs: Use Quick Chat](https://code.visualstudio.com/docs/chat/inline-chat#use-quick-chat)

## Tình trạng thường gặp

- **Bấm phím không thấy gì**: `Ctrl+Shift+Alt+L` có thể bị extension khác chiếm.
  Thử mở bằng Command Palette (gõ "Quick Chat") để xác nhận tính năng còn hoạt động, rồi sửa keybinding.
- **Gõ xong quên mất**: Quick Chat không chiếm toàn màn hình; `Esc` là an toàn nhất,
  câu hỏi đã gửi vẫn xem lại được trong danh sách phiên — xem [Session History](../history/README.md). · 📄 [VS Code Docs: Chat settings](https://code.visualstudio.com/docs/agents/reference/ai-settings#chat-settings)

## Học tiếp

- [Shortcuts](../shortcuts/README.md) — bảng phím tắt Chat đầy đủ.
- [Attachments](../attachments/README.md) — đưa ngữ cảnh vào câu hỏi. · 📄 [VS Code Docs: Inline Chat](https://code.visualstudio.com/docs/chat/inline-chat)

## Tham khảo

- [Chat in VS Code - Sessions (Quick Chat)](https://code.visualstudio.com/docs/agents/run/chat-view)
- [Keyboard shortcuts](https://code.visualstudio.com/docs/configure/keybindings#keyboard-shortcuts-editor) · 📄 [Keyboard shortcuts](https://code.visualstudio.com/docs/configure/keybindings#keyboard-shortcuts-editor)
