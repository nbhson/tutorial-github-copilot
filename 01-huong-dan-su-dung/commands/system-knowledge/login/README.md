# /login — Đăng nhập GitHub cho Copilot

> Nôm na: xuất trình thẻ nhân viên để vào tòa nhà.

## Lệnh làm gì (1 câu nôm na)

Nôm na: xuất trình thẻ nhân viên để vào tòa nhà. Thuộc nhóm lệnh dùng hàng ngày — gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

- Mới cài / đổi máy.
- Token hết hạn, Copilot silent fail.
- Đổi account cá nhân ↔ công ty.

## Cách gọi (copy-paste)

```bash
/login
# làm theo popup GitHub → verify bằng /status
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/login`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
/login → sign-in GitHub → /status thấy account đúng → gõ thử 1 hàm thấy gợi ý
```

**Kết quả mong đợi:** Login đúng account; /status hiện đúng login + plan; gợi ý chạy.

**Cách verify:** Gợi ý + chat đều chạy sau login là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Login nhầm account | 2 GitHub accounts | /logout rồi /login lại đúng account |
| Popup bị chặn | Browser/proxy chặn | Mở browser mặc định, tắt chặn popup tạm |
| Login xong vẫn không gợi ý | Chưa có seat / exclusion | Check seat + exclusion + /status |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
