# /tests — Sinh tests theo mẫu repo

> **Dành cho:** dev vừa viết/sửa hàm cần test bao · **Vấn đề:** test sinh ra không khớp framework/mẫu của repo · **Đọc xong:** có file test chạy xanh, cover đúng nhánh vừa sửa (~2 phút)

## Lệnh làm gì (1 câu nôm na)

Nôm na: bảo “viết bài kiểm tra cho bài này, theo đúng mẫu lớp mình”. Bôi đen hàm rồi `/tests`; nêu rõ framework + file mẫu + mock DB thì test mới chạy được ngay.

## Khi nào dùng

Section này trả lời: lúc nào sinh test bằng lệnh, và làm sao tránh test ảo (assert true).

- **Cho ai:** dev tăng coverage, người cần test đúng mẫu repo trước khi mở PR.
- Vừa viết/sửa hàm, cần test bao lại.
- Tăng coverage cho module quan trọng.
- Chuẩn hóa test mới theo mẫu repo.

## Cách gọi (copy-paste)

Cách gọi `/tests` — làm đúng theo khối dưới đây, kèm câu kiểm tra lệnh có ở máy bạn hay không:

```bash
Bôi đen hàm → /tests
/tests sinh test theo mẫu repo, mock DB
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/tests`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

Prompt mẫu cho `/tests` — đổi phần tên file/task cho đúng việc của bạn:

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
(bôi đen hàm tính phí) /tests “sinh 3 cases: thường, biên, null — mock DB theo mẫu repo”
```

**Kết quả mong đợi:** File test theo đúng framework/mẫu repo; chạy xanh ngay hoặc sửa nhỏ là xanh.

**Cách verify:** Chạy test mới — xanh + cover được nhánh vừa sửa là đạt.

## Lỗi thường gặp

Ba triệu chứng hay gặp nhất với lệnh này — kèm nhanh cách xử lý:

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Test sinh ra không chạy được | Sai import/framework với repo | Nêu rõ framework + file mẫu trong prompt |
| Test ảo (assert true) | Mô tả quá chung | Bắt “mỗi test phải fail nếu logic sai” + review tay |
| Quên mock DB/API | Prompt thiếu | Thêm “mock DB/API theo mẫu X” |

## Tham khảo

Liên quan — index nhóm, cheatsheet 1 trang và FAQ phòng khi kẹt:

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
