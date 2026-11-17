# Attach / #file — Gắn đúng file vào prompt để model đọc trúng, không đoán mò

> **Harness:** Copilot · **Surface:** Chat view / Quick Chat / inline chat (mọi ô chat có `#`) · **Đọc:** ~2 phút

**Nôm na:** Kẹp tài liệu vào câu hỏi — gõ `#` để gọi context items (file, folder, symbol, terminal output, SCM changes), bấm **Add Context** (`+`) hoặc kéo-thả file/ảnh vào ô chat. Hợp khi hỏi/sửa code cụ thể mà model không tự "nhìn thấy" repo của bạn.

## Vì sao dùng?

Model chỉ thấy những gì bạn đưa nó; attach là kỹ năng nền vì thiếu scope thì model đoán mò và sửa sai file. Gắn đúng 1–3 file/symbol liên quan nhất giúp trả lời trúng hơn, ít token hơn, diff đúng chỗ hơn. Câu hỏi xuyên file ("hàm này ai gọi") không cần attach — hỏi thẳng agent, nó có sẵn tool search + đọc file.

| Cách đưa vào prompt | Hỏi/đọc được gì | Khi nào |
|---|---|---|
| `#file`, `#folder` | đúng 1 file / 1 vùng | sửa-hỏi phạm vi hẹp, cần chính xác cao |
| `#symbol`, `#terminal`, SCM changes | một ký hiệu, output terminal, diff đang treo | gọi thẳng "nguyên liệu" thay vì mô tả bằng chữ |
| Kéo-thả / Add Context (`+`) | file, ảnh ngoài editor (log, screenshot UI) | đưa bằng chứng cho model |
| Hỏi thẳng agent, không attach | quan hệ xuyên file: "hàm này ai gọi" | để agent tự search + đọc file |

**Nếu làm sai:** hai cực đều hại — quên attach thì model đoán mò, attach cả repo thì chậm và loãng; rủi ro âm thầm là attach file chứa token mà không soát (nó có thể đi vào export/share); và tật cũ `@workspace`, `@terminal` là participants đã deprecated, không chạy trong Copilot harness — dùng `#` thay.

## Cách dùng

Gõ `#` trong Chat view / Quick Chat / inline chat; thiếu thì bấm Add Context (`+`) hoặc kéo-thả.

```prompt
#file src/models/customer.ts
customerId được đọc/ghi ở file nào? hàm nào tạo ra nó?
```

- **Biến thể:** kéo-thả screenshot/log ngoài editor; gõ `#` không ra danh sách context items → kiểm extension Copilot Chat đã bật.
- **✅ Verify:** bắt model "liệt kê file mày đã đọc" — khớp file bạn gắn là đạt.

## Liên quan

- Sửa tại chỗ sau khi gắn scope: [inline-chat](../inline-chat/README.md) · Lưu chat có file nhạy cảm: [export](../../../local/chat-session/export/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — Add context to chat](https://code.visualstudio.com/docs/chat/copilot-chat-context#add-files-as-context)
