# /extensions — Quản lý Copilot Extensions

> Nôm na: kho ứng dụng — xem đã cài gì, cái nào thừa thì gỡ.

## Lệnh làm gì (1 câu nôm na)

Nôm na: kho ứng dụng — xem đã cài gì, cái nào thừa thì gỡ. Thuộc nhóm lệnh dùng hàng ngày — gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

- Cài extension mới theo docs team.
- Nghi xung đột 2 extensions.
- Dọn extension cũ sau update.

## Cách gọi (copy-paste)

```bash
/extensions
# hoặc Ctrl+Shift+X → search Copilot
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/extensions`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
/extensions “liệt kê extensions Copilot đã cài + cái nào đang active”
```

**Kết quả mong đợi:** Biết list đã cài/active; gỡ/bật đúng cái cần; xung đột hết.

**Cách verify:** Chat/inline chạy ổn sau khi dọn là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| 2 extensions đè nhau | Cài trùng chức năng | Giữ 1, disable cái kia rồi test lại |
| Extension cũ sau update IDE | Quên update theo | Update IDE → update extensions → reload |
| Cài extension lạ không rõ nguồn | Nghe đồn hay | Chỉ cài từ marketplace/docs chính thức; validate trước |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
