# /resume — Tiếp tục phiên chat đã lưu

> Nôm na: mở lại vở cũ và viết tiếp, khỏi chép lại từ đầu.

## Lệnh làm gì (1 câu nôm na)

Nôm na: mở lại vở cũ và viết tiếp, khỏi chép lại từ đầu. Thuộc nhóm lệnh dùng hàng ngày — gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

- Việc dở hôm qua, nay làm tiếp.
- Chat bị đóng nhầm (tắt IDE, crash).
- Muốn rẽ nhánh từ 1 chat cũ thành 2 hướng.

## Cách gọi (copy-paste)

```bash
/resume
# hoặc /history → chọn phiên → tiếp tục
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/resume`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
/resume phiên “thêm rate-limit cho /api/login” hôm qua
```

**Kết quả mong đợi:** Phiên cũ mở lại đúng chỗ dừng; hỏi tiếp không cần giải thích lại từ đầu.

**Cách verify:** Nhắn “tiếp tục bước 3 hôm qua” — model làm đúng bước 3 là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Resume nhưng model quên tool state | History chỉ lưu text | Nhắc lại 3 dòng bối cảnh + file liên quan |
| Nhầm phiên cũ khác | Tên chat giống nhau | Đặt tên chat rõ + /export bản quan trọng |
| Phiên quá cũ, code đã đổi | Code trên đĩa khác lúc chat | Chạy git diff + test lại trước khi tin |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
