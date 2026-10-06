# /logout — Đăng xuất, xóa credentials

> Nôm na: trả thẻ, xóa dấu vân tay khỏi máy lạ.

## Lệnh làm gì (1 câu nôm na)

Nôm na: trả thẻ, xóa dấu vân tay khỏi máy lạ. Thuộc nhóm lệnh dùng hàng ngày — gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

- Dùng máy chung/máy mượn.
- Đổi account.
- Nghi credentials kẹt/lỗi.

## Cách gọi (copy-paste)

```bash
/logout
# xong /login lại nếu cần
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/logout`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
/logout trên máy mượn → verify /status báo chưa login → trả máy
```

**Kết quả mong đợi:** Credentials local sạch; máy không còn vào được account bạn.

**Cách verify:** /status báo signed-out là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Quên logout máy chung | Vội trả máy | Checklist trả máy: /logout + xóa token env |
| Logout rồi login vẫn lỗi | Cache token kẹt | Xóa credentials OS keychain + login lại |
| Nhầm logout với tắt extension | Tắt extension ≠ logout | Muốn sạch hẳn thì /logout |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
