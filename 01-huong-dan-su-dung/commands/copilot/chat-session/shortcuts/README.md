# Shortcuts — Tra đúng phím tắt Chat mà docs ghi nhận, đừng tin phím "truyền miệng"

> **Harness:** Copilot · **Surface:** VS Code keybinding (lệnh chat / inline / quickchat) · **Đọc:** ~2 phút

**Nôm na:** Phím tắt chat đúng bằng **6 dòng trong bảng docs**, không phải bí kíp lan truyền; mọi "phím Copilot" nằm ngoài bảng đó đều là đồ cũ hoặc bịa. Hợp khi bạn muốn rời chuột nhưng bấm hoài Copilot không phản hồi.

## Vì sao dùng?

Hỏi Copilot lặp hàng chục lần mỗi ngày, nên phím tắt cắt được đoạn đường rời bàn phím tìm chuột; hành động lác đác thì Command Palette (`Ctrl+Shift+P`, macOS `⇧⌘P`) lo, không cần học thêm phím. Ba ô hay nhầm nhất nằm ngay dưới đây.

| Hành động | Windows/Linux | macOS | Lệnh |
|---|---|---|---|
| Mở Chat view | `Ctrl+Alt+I` | `⌃⌘I` | `workbench.action.chat.open` |
| Chat mới | `Ctrl+N` | `⌘N` | `workbench.action.chat.newChat` |
| Inline chat (editor & terminal) | `Ctrl+I` | `⌘I` | `inlineChat.start` · `workbench.action.terminal.chat.start` |
| Quick Chat | `Ctrl+Shift+Alt+L` | `⇧⌥⌘L` | `workbench.action.quickchat.toggle` |
| Nhận / bỏ gợi ý code | `Tab` / `Esc` | `Tab` / `Esc` | — |

**Nếu làm sai:** tin `Shift+Alt+I` hay `Ctrl+Shift+I` rồi kết luận "Copilot liệt" — hai tổ hợp đó không còn được docs ghi nhận cho chat; phím sai lệnh còn tai hại hơn không phím vì bạn mất 10 phút debug một tính năng vốn chạy bình thường.

## Cách dùng

Học 6 phím trước, mọi thứ sau; nghi phím bị chiếm thì `Ctrl+K Ctrl+S` → tìm "chat" → gán lại.

```sh
Ctrl+K Ctrl+S   # Keyboard Shortcuts → tìm "chat" → gán lại tổ hợp bị extension khác chiếm
```

- **Biến thể:** hành động chưa có phím trong docs → gọi Command Palette theo tên lệnh, đừng tự chế rồi đi dạy lại người khác.
- **✅ Verify:** `Ctrl+K Ctrl+S` gõ `workbench.action.quickchat.toggle` — có mặt là phím còn sống, lỗi nằm ở keybinding chứ không phải Copilot.

## Liên quan

- Phím nào làm gì chi tiết: [quick-chat](../quick-chat/README.md) · [inline-chat](../inline-chat/README.md) · [new-chat](../new-chat/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — Chat and agent keyboard shortcuts](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet#essential-keyboard-shortcuts)
