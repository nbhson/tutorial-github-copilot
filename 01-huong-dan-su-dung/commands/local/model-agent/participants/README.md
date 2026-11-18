# @workspace, @terminal, @vscode — Participants đã deprecated, chỉ còn chạy ở Local harness

> **Harness:** Local · **Surface:** `@…` trong VS Code Chat — docs đánh dấu chat participants deprecated và **không được hỗ trợ ở Copilot harness** · **Đọc:** ~2 phút

**Nôm na:** Kiểu "gọi chuyên viên trong chat" — `@workspace` lo repo, `@terminal` lo lỗi shell, `@vscode` chạy lệnh editor — nay được gộp vào **một harness với tools**, không còn ai để gọi. Hợp khi prompt cũ gõ `@` bị im lặng ở phiên mới và bạn cần biết vì sao, đổi sang đường nào.

## Vì sao dùng?

Đây là trang "vì sao không còn chạy", không phải lệnh để gọi — và cũng đừng dạy `@…` cho người mới, vì họ sẽ mất nửa ngày debug một cú pháp đã chết. Chỗ nguy hiểm nhất: mất `@` **không báo lỗi** — prompt chỉ mất người thực hiện mà bạn không hay, có khi vẫn trả lời đúng nhưng là ăn may từ file đang mở. Vì Local vẫn còn chạy chúng, prompt cũ "còn sống" trong một cửa sổ — nguồn cơn mọi hiểu lầm; phải soát kho prompt bằng grep, không bằng mắt.

| Cú pháp cũ (chỉ Local) | Ở Copilot harness | Thay bằng |
|---|---|---|
| `@workspace + câu hỏi` | participant không chạy; model chỉ thấy text | cứ hỏi — Agent tự quét repo; cần chính xác thì `#file` / **Add Context** |
| `@terminal + mô tả lỗi` | không có participant terminal | inline chat trong terminal (`Ctrl+I`) |
| `@vscode + tên lệnh` | không chạy | Command Palette, hoặc nói mong muốn bằng tiếng người |

**Nếu làm sai:** đừng thay `@workspace` bằng cách bỏ trống — bỏ cú pháp mà giữ giả định "sẽ có người lo ngữ cảnh" thì chất lượng trả lời giảm âm thầm; việc lặp lại thành quy tắc repo thì đưa vào instructions / `AGENTS.md` (nạp tự động), không nhét vào prompt hằng ngày.

## Cách dùng

Cú pháp sống của chat hiện tại: `/` để chạy lệnh, `#` để gắn file/vùng chọn, `@` không còn là ký hiệu ngữ cảnh:

```sh
grep -rn "@workspace\|@terminal\|@vscode" . --include="*.md"   # tìm bệnh trong kho prompt cũ
# viết lại: "liệt kê endpoint trong #file:src/routes/index.ts và các file nó import"
```

- **Biến thể:** cần ngữ cảnh hẹp và chính xác → `#file` / selection / nút **Add Context**, không phải `@workspace`.
- **Setting:** Session Target cho biết bạn ở harness nào — `@…` chỉ còn chạy ở Local; kiểm ở picker này trước khi gửi prompt.
- **✅ Verify:** gửi cùng một prompt ở phiên Local và phiên Copilot — Local hiện bước `@workspace` thực thi; Copilot không có bước đó nhưng Agent vẫn tự gather bằng tools.

## Liên quan

- Hiểu phạm vi Local: [edit-mode](../edit-mode/README.md) · gắn file bằng `#`: [attachments](../../../copilot/chat-session/attachments/README.md) · terminal: [debug-terminal](../../../copilot/code-actions/debug-terminal/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — Migrate customizations (Replace chat participants)](https://code.visualstudio.com/docs/agent-customization/migrate-customizations#replace-chat-participants)
