# /tests — Sinh tests theo mẫu repo

> Nôm na: bảo “viết bài kiểm tra cho bài này, theo đúng mẫu lớp mình”.

## Lệnh làm gì (1 câu nôm na)

Nôm na: bảo “viết bài kiểm tra cho bài này, theo đúng mẫu lớp mình”. Thuộc nhóm lệnh dùng hàng ngày — gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

- Vừa viết/sửa hàm, cần test bao lại.
- Tăng coverage cho module quan trọng.
- Chuẩn hóa test mới theo mẫu repo.

## Cách gọi (copy-paste)

```bash
Bôi đen hàm → /tests
/tests sinh test theo mẫu repo, mock DB
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/tests`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
(bôi đen hàm tính phí) /tests “sinh 3 cases: thường, biên, null — mock DB theo mẫu repo”
```

**Kết quả mong đợi:** File test theo đúng framework/mẫu repo; chạy xanh ngay hoặc sửa nhỏ là xanh.

**Cách verify:** Chạy test mới — xanh + cover được nhánh vừa sửa là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Test sinh ra không chạy được | Sai import/framework với repo | Nêu rõ framework + file mẫu trong prompt |
| Test ảo (assert true) | Mô tả quá chung | Bắt “mỗi test phải fail nếu logic sai” + review tay |
| Quên mock DB/API | Prompt thiếu | Thêm “mock DB/API theo mẫu X” |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
