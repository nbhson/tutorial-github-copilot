# /btw — Hỏi câu bên lề trong side chat, không phá mạch task chính

> **Harness:** Copilot · **Surface:** side chat mở từ Chat view (Copilot harness) · **Đọc:** ~2 phút

**Nôm na:** `/btw` tách câu hỏi "à tiện thể" ra một side chat riêng, hỏi xong đóng là mạch chính vẫn nguyên ngữ cảnh. Hợp khi đang giữa task agent, chợt nhớ câu hỏi phụ sợ để dành thì quên.

## Vì sao dùng?

Hỏi câu phụ vào chat chính thì model phải trộn hai ngữ cảnh; mở chat mới thì phải gắn lại context. `/btw` là kênh phụ đúng chỗ cho câu 30 giây — nhưng side chat **không có ngữ cảnh của chat chính**, nên câu nào cần biết code repo vẫn phải về chat chính. Docs ghi rõ `/btw` **không có ở Local** và Codex-extension.

| Loại câu hỏi | Hỏi ở đâu | Vì sao |
|---|---|---|
| Cú pháp / thư viện / kinh nghiệm độc lập với task | `/btw` (side chat) | không cần ngữ cảnh, hỏi nhanh đóng gọn |
| Một phần của task hiện tại | chat chính, kèm `#file` nếu cần | side chat không biết gì về mạch đang làm |
| Kết quả side chat đáng giữ | chép ra file trước khi đóng | nó không nằm trong Session History của chat chính |

**Nếu làm sai:** dùng `/btw` cho câu *liên quan trực tiếp* đến task thì trả lời ra chung chung — coi nó là bàn phụ cho câu ngoài lề, không phải "chat chính thứ hai"; gõ `/` không thấy `/btw` nhiều khả năng bạn đang ở Local harness.

## Cách dùng

Gõ trong Chat view (Copilot harness); câu hỏi mở ở side chat, chat chính giữ nguyên.

```prompt
/btw
/btw cách format date trong Python 3.12?
```

- **Biến thể:** `/btw <câu hỏi>` — câu càng độc lập với task càng hợp.
- **✅ Verify:** sau khi gõ `/btw`, chat chính vẫn còn nguyên câu/ngữ cảnh cũ.

## Liên quan

- Cần ngữ cảnh repo cho câu hỏi: [attachments](../attachments/README.md) · Hai luồng của cùng một task: [fork](../fork/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — AI features cheat sheet](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet)
