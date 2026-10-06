# Shift+Alt+I (quick chat) — Hỏi nhanh phủ trên editor

> Nôm na: giơ tay hỏi nhanh 1 câu rồi hạ xuống code tiếp, khỏi rời editor.

## Lệnh làm gì (1 câu nôm na)

Nôm na: giơ tay hỏi nhanh 1 câu rồi hạ xuống code tiếp, khỏi rời editor. Thuộc nhóm lệnh dùng hàng ngày — gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

- Hỏi định nghĩa, cú pháp, “hàm này làm gì?” trong 30 giây.
- Đang code dở, không muốn mở hẳn Chat view.
- Hỏi xong không cần lưu lịch sử dài.

## Cách gọi (copy-paste)

```bash
Shift+Alt+I → nhập câu hỏi → Enter → Esc đóng
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `Shift+Alt+I (quick chat)`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
Shift+Alt+I → “hàm debounce này delay bao nhiêu ms là hợp lý?”
```

**Kết quả mong đợi:** Popup trả lời ngắn gọn ngay trên editor; đóng là về code tiếp.

**Cách verify:** Áp dụng được câu trả lời trong 1 phút là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Phím tắt không ăn | Xung đột keybinding / layout khác | Vào Keyboard Shortcuts search “quick chat” gán lại |
| Hỏi phức tạp bị trả lời cộc | Quick chat hợp câu ngắn | Việc phức tạp → mở Chat view hoặc Agent mode |
| Quên mất câu trả lời hay | Quick chat không lưu kỹ | Câu nào hay → hỏi lại trong Chat view rồi /export |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
