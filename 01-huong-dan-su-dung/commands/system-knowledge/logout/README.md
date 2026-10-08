# /logout — Đăng xuất, xóa credentials

> **Dành cho:** người dùng máy chung / máy mượn · **Vấn đề:** credentials kẹt lại trên máy lạ sau khi trả · **Đọc xong:** xóa sạch credentials local và tự verify đã signed-out (~2 phút)

## Lệnh làm gì (1 câu nôm na)

Nôm na: trả thẻ, xóa dấu vân tay khỏi máy lạ. `/logout` xóa credentials local, cần thì `/login` lại sau; tắt extension không phải là logout.

## Khi nào dùng

Section này trả lời: khi nào bắt buộc logout, và cách kiểm tra máy đã sạch thật chưa.

- **Cho ai:** ai xài máy chung/mượn, người đổi account công ty ↔ cá nhân.
- Dùng máy chung/máy mượn.
- Đổi account.
- Nghi credentials kẹt/lỗi.

## Cách gọi (copy-paste)

Cách gọi `/logout` — làm đúng theo khối dưới đây, kèm câu kiểm tra lệnh có ở máy bạn hay không:

```bash
/logout
# xong /login lại nếu cần
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/logout`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

Prompt mẫu cho `/logout` — đổi phần tên file/task cho đúng việc của bạn:

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
/logout trên máy mượn → verify /status báo chưa login → trả máy
```

**Kết quả mong đợi:** Credentials local sạch; máy không còn vào được account bạn.

**Cách verify:** /status báo signed-out là đạt.

## Lỗi thường gặp

Ba triệu chứng hay gặp nhất với lệnh này — kèm nhanh cách xử lý:

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Quên logout máy chung | Vội trả máy | Checklist trả máy: /logout + xóa token env |
| Logout rồi login vẫn lỗi | Cache token kẹt | Xóa credentials OS keychain + login lại |
| Nhầm logout với tắt extension | Tắt extension ≠ logout | Muốn sạch hẳn thì /logout |

## Tham khảo

Liên quan — index nhóm, cheatsheet 1 trang và FAQ phòng khi kẹt:

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
