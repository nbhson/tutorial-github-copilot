# Quick Chat — Hộp Copilot thu gọn giữa màn hình, hỏi nhanh không rời layout

> **Harness:** Copilot · **Surface:** Chat view · Quick Chat · **Đọc:** ~2 phút

**Nôm na:** Quick Chat là hộp thoại nổi gọn của **Chat view** — cùng harness, cùng mô hình, chỉ có một ô nhập giữa màn hình, hỏi xong `Esc` là về lại code. Hợp khi bạn cần một câu trả lời ngắn rồi code tiếp, không muốn mở panel bên hông.

## Vì sao dùng?

Mở Chat view cho câu 1–2 lượt ("hàm này làm gì?") làm gãy nhịp gõ; Quick Chat trả lời ngay tại chỗ mà layout editor không đổi, câu đã gửi vẫn xem lại được trong danh sách phiên. Nó thuộc surface Chat view trong VS Code — Agents window không được docs ghi nhận có Quick Chat riêng, và đây cũng không phải lệnh trong Copilot CLI.

| Phím | Tác dụng |
|---|---|
| `Ctrl+Shift+Alt+L` (macOS `⇧⌥⌘L`) | mở/đóng Quick Chat |
| `Enter` | gửi câu hỏi (thêm `#file` nếu cần ngữ cảnh) |
| `Esc` | đóng Quick Chat, về lại editor |

**Nếu làm sai:** bấm phím không thấy gì thường do `Ctrl+Shift+Alt+L` bị extension khác chiếm — thử mở bằng Command Palette để xác nhận tính năng còn sống rồi sửa keybinding; và đây **không** phải inline chat (`Ctrl+I`): Quick Chat hỏi, inline chat sửa ngay đoạn bôi đen.

## Cách dùng

`Ctrl+Shift+Alt+L` (macOS `⇧⌥⌘L`) hoặc Command Palette (`Ctrl+Shift+P` → "Quick Chat").

```sh
Ctrl+Shift+Alt+L → gõ câu hỏi (+ #file) → Enter gửi → Esc đóng
```

- **Biến thể:** việc dài/nhiều vòng thì mở Chat view (`Ctrl+Alt+I`, macOS `⌃⌘I`) để thấy danh sách phiên, checkpoint, `#context` rõ hơn; kết quả quan trọng thì `Chat: Export Chat…`.
- **✅ Verify:** trả lời hiện ngay trong hộp nhỏ, layout editor không đổi.

## Liên quan

- Tra cả bảng phím: [shortcuts](../shortcuts/README.md) · Đưa ngữ cảnh vào câu hỏi: [attachments](../attachments/README.md) · Sửa tại chỗ: [inline-chat](../inline-chat/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — Use Quick Chat](https://code.visualstudio.com/docs/chat/inline-chat#use-quick-chat)
