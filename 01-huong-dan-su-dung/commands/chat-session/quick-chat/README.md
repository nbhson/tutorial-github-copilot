# Shift+Alt+I (quick chat) — Hỏi nhanh phủ trên editor

> **Dành cho:** dev cần hỏi nhanh trong 30 giây · **Vấn đề:** câu hỏi ngắn mà mở Chat view thì thừa · **Đọc xong:** hỏi xong đóng ngay, không rời editor, biết việc nào phải chuyển Chat view (~2 phút)

## Lệnh làm gì (1 câu nôm na)

Nôm na: giơ tay hỏi nhanh 1 câu rồi hạ xuống code tiếp, khỏi rời editor. Shift+Alt+I → nhập câu hỏi → Enter → Esc đóng; popup trả lời ngắn ngay trên editor.

## Khi nào dùng

Section này trả lời: câu hỏi nào hợp Quick Chat, câu nào phải chuyển sang Chat view hay Agent mode.

- **Cho ai:** người hỏi lẻ về cú pháp/định nghĩa, không cần lưu lịch sử dài.
- Hỏi định nghĩa, cú pháp, “hàm này làm gì?” trong 30 giây.
- Đang code dở, không muốn mở hẳn Chat view.
- Hỏi xong không cần lưu lịch sử dài.

## Cách gọi (copy-paste)

Cách gọi `Shift+Alt+I (quick chat)` — làm đúng theo khối dưới đây, kèm câu kiểm tra lệnh có ở máy bạn hay không:

```bash
Shift+Alt+I → nhập câu hỏi → Enter → Esc đóng
# Kỳ vọng: popup trả lời ngắn ngay trên editor
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `Shift+Alt+I (quick chat)`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

Prompt mẫu cho `Shift+Alt+I (quick chat)` — đổi phần tên file/task cho đúng việc của bạn:

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
Shift+Alt+I → “hàm debounce này delay bao nhiêu ms là hợp lý?”
# Kỳ vọng: popup trả lời ngắn, Esc là về code tiếp
```

**Kết quả mong đợi:** Popup trả lời ngắn gọn ngay trên editor; đóng là về code tiếp.

**Cách verify:** Áp dụng được câu trả lời trong 1 phút là đạt.

## Lỗi thường gặp

Ba triệu chứng hay gặp nhất với lệnh này — kèm nhanh cách xử lý:

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Phím tắt không ăn | Xung đột keybinding / layout khác | Vào Keyboard Shortcuts search “quick chat” gán lại |
| Hỏi phức tạp bị trả lời cộc | Quick chat hợp câu ngắn | Việc phức tạp → mở Chat view hoặc Agent mode |
| Quên mất câu trả lời hay | Quick chat không lưu kỹ | Câu nào hay → hỏi lại trong Chat view rồi /export |

## Tham khảo

Liên quan — index nhóm, cheatsheet 1 trang và FAQ phòng khi kẹt:

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
