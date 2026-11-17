# Ctrl+I (inline chat) — Chat ngay tại dòng code bôi đen, sửa tại chỗ không rời editor

> **Harness:** Copilot · **Surface:** editor inline chat & terminal inline chat (phím `Ctrl+I` / macOS `⌘I`) · **Đọc:** ~2 phút

**Nôm na:** Bôi đen code → `Ctrl+I` → nhập mô tả → diff hiện ngay tại dòng đang đứng, duyệt Keep/Undo từng hunk; cùng tổ hợp trong terminal mở inline chat hỏi về shell command. Hợp khi cần đổi một đoạn nhỏ 5–20 dòng mà không muốn nhảy tab, giữ liền mạch đọc code.

## Vì sao dùng?

Phần lớn sửa code hằng ngày rất nhỏ — thêm null check, đổi tên biến, bọc `try/catch` — mở hẳn Chat view cho mấy việc này là thừa. Inline chat giữ bạn **trong editor**, scope tự nhiên là selection, và duyệt từng hunk nên kiểm soát chặt. Hai lỗi hay gặp: chưa bôi đen đã bấm nên không thấy gì; yêu cầu quá to một lần khiến diff khó đọc, dễ Keep nhầm.

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Bấm `Ctrl+I` không hiện gì | chưa bôi đen / extension chưa active | bôi đen code trước; kiểm Copilot status bar |
| `Ctrl+I` lại nhảy sang Chat view | file thuộc phiên chat đang mở (`inlineChat.askInChat`) | gõ tiếp trong "Ask in Chat" hoặc set `false` để luôn inline |
| Diff khó đọc | gom quá nhiều việc vào một lần | mỗi `Ctrl+I` một việc, bôi hẹp |

**Nếu làm sai:** việc cần nhiều file hoặc tool ngoài thì đừng cố inline — mở Chat view với Agent mode hợp hơn; terminal inline chat thì luôn đọc command trước khi bấm Run, vì Run là thực thi thật.

## Cách dùng

Bôi đen code → `Ctrl+I` (macOS `⌘I`) → nhập mô tả sửa → Keep/Undo diff tại chỗ.

```prompt
thêm null check cho process.env.CONFIG, giữ nguyên API, chỉ sửa đoạn đã chọn
```

- **Biến thể:** terminal inline chat (cùng `Ctrl+I`) — Run = `Ctrl+Enter`, Insert = `Alt+Enter` (chèn để sửa tay thì an toàn hơn).
- **Setting:** `inlineChat.askInChat` — true thì file thuộc phiên chat đang mở sẽ bị dẫn vào "Ask in Chat" của Chat view; `inlineChat.defaultModel` — model mặc định cho inline chat.
- **✅ Verify:** chạy test focused cho hàm vừa sửa — xanh là đạt.

## Liên quan

- Hỏi nhanh không sửa tại chỗ: [quick-chat](../quick-chat/README.md) · Gắn scope trước khi hỏi: [attachments](../attachments/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — Editor inline chat](https://code.visualstudio.com/docs/chat/inline-chat#use-editor-inline-chat)
