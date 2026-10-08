# /extensions — Quản lý Copilot Extensions

> **Dành cho:** dev cài/dọn Copilot Extensions · **Vấn đề:** 2 extension đè nhau, hoặc extension cũ sau khi update IDE · **Đọc xong:** biết đã cài gì, cái nào active, gỡ đúng cái thừa (~2 phút)

## Lệnh làm gì (1 câu nôm na)

Nôm na: kho ứng dụng — xem đã cài gì, cái nào thừa thì gỡ. `/extensions` liệt kê extension đã cài, hoặc vào Ctrl+Shift+X rồi search Copilot.

## Khi nào dùng

Section này trả lời: khi nào tra extension, và xử lý xung đột giữa 2 extension cùng chức năng.

- **Cho ai:** người mới cài theo docs team, người dọn máy sau khi update IDE.
- Cài extension mới theo docs team.
- Nghi xung đột 2 extensions.
- Dọn extension cũ sau update.

## Cách gọi (copy-paste)

Cách gọi `/extensions` — làm đúng theo khối dưới đây, kèm câu kiểm tra lệnh có ở máy bạn hay không:

```bash
/extensions
# hoặc Ctrl+Shift+X → search Copilot
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/extensions`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

Prompt mẫu cho `/extensions` — đổi phần tên file/task cho đúng việc của bạn:

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
/extensions “liệt kê extensions Copilot đã cài + cái nào đang active”
```

**Kết quả mong đợi:** Biết list đã cài/active; gỡ/bật đúng cái cần; xung đột hết.

**Cách verify:** Chat/inline chạy ổn sau khi dọn là đạt.

## Lỗi thường gặp

Ba triệu chứng hay gặp nhất với lệnh này — kèm nhanh cách xử lý:

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| 2 extensions đè nhau | Cài trùng chức năng | Giữ 1, disable cái kia rồi test lại |
| Extension cũ sau update IDE | Quên update theo | Update IDE → update extensions → reload |
| Cài extension lạ không rõ nguồn | Nghe đồn hay | Chỉ cài từ marketplace/docs chính thức; validate trước |

## Tham khảo

Liên quan — index nhóm, cheatsheet 1 trang và FAQ phòng khi kẹt:

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
