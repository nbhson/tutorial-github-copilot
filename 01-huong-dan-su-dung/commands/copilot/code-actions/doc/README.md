# /doc — sinh docstring/JSDoc cho hàm đang chọn, kèm example chạy được

> **Harness:** Copilot · **Surface:** editor inline chat (`Ctrl+I`, macOS `⌘I`) — docs ghi `/doc` gọi từ inline chat; ngoài ra có Code Action **Generate Docs** · **Đọc:** ~2 phút

**Nôm na:** Nhờ viết nhãn mác cho lọ thuốc: tên, công dụng, cách dùng, ví dụ. Bạn bôi đen hàm, mở inline chat và gõ `/doc` — nó viết docstring theo chuẩn repo ngay tại chỗ. Hợp khi vừa viết xong một hàm public, trước khi người khác phải hỏi bạn cách dùng nó.

## Vì sao dùng?

Docs viết tay hay bị bỏ qua, mà khi có thì thường thiếu đúng phần người khác cần nhất: ví dụ chạy được. `/doc` không chỉ điền `@param`/`@returns` mà còn sinh một example copy-paste chạy thử được — chính phần đó biến docs từ "trang trí" thành "hướng dẫn". Cái hay nhầm là coi docs một lần là xong: docs **cũ nhưng nghe rất chắc** còn hại hơn không có docs, vì người sau làm theo rồi dính bug mà vẫn tưởng đã được cảnh báo.

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Docs chung chung, thiếu example | Prompt thiếu yêu cầu example | Thêm "gồm 1 example chạy được" vào prompt |
| Docs nói sai params | Hàm đổi signature, docs không regen | Regen `/doc` ngay sau mỗi lần đổi signature |
| Docs dài hơn code | Cố docs mọi hàm | Chỉ docs cho hàm public/phức tạp |
| Không thấy `/doc` khi gõ `/` ở Chat view | Docs ghi `/doc` cho editor inline chat | Bôi đen code, `Ctrl+I`, rồi gõ `/doc` |

**Nếu làm sai:** đổi tên tham số mà không regen thì example trong docs lệch với code — chạy thử example cũ để tự thấy; và đừng dùng `/doc` khi bạn cần *hiểu* đoạn code đó (đó là việc của `/explain`).

## Cách dùng

Bôi đen hàm trong editor, mở inline chat (`Ctrl+I`, macOS `⌘I`) rồi gõ:

```prompt
/doc viết JSDoc: mô tả, @param, @returns, @throws + 1 example chạy được, theo style module billing
```

- **Biến thể:** `/doc` trần cho hàm ngắn; cửa thứ hai là chuột phải → Generate Code → **Generate Docs** khi không muốn mở inline chat.
- **✅ Verify:** copy nguyên example trong docs vào snippet chạy thử — chạy được và ra kết quả đúng mới là docs đáng tin.

## Liên quan

- Cần hiểu code trước khi viết docs: [explain](../explain/README.md) · Inline chat là cửa thật của `/doc`: [inline-chat](../../chat-session/inline-chat/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — Generate documentation](https://code.visualstudio.com/docs/editing/copilot-smart-actions#generate-documentation)
