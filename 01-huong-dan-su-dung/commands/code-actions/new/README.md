# /new (code) — Sinh code mới từ mô tả

> Nôm na: đọc đề bài rồi viết code nháp — bạn duyệt rồi mới dùng.

## Lệnh làm gì (1 câu nôm na)

Nôm na: đọc đề bài rồi viết code nháp — bạn duyệt rồi mới dùng. Thuộc nhóm lệnh dùng hàng ngày — gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

- Sinh hàm/file/module mới từ mô tả rõ.
- Tạo boilerplate theo mẫu repo.
- Spike nhanh 1 ý tưởng.

## Cách gọi (copy-paste)

```bash
/new (code)
/new viết hàm retry fetch 3 lần, backoff 1s
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/new (code)`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
/new “viết hàm fetchWithRetry(url): retry 3 lần, backoff 1s, throw lỗi cuối — theo style repo”
```

**Kết quả mong đợi:** Code mới đúng style repo + xử lý lỗi cơ bản; bạn review diff rồi mới giữ.

**Cách verify:** Chạy thử + viết 1 test nhanh cho hàm mới là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Code sinh ra không khớp style | Thiếu file mẫu | Attach 1 file mẫu + “theo đúng style file này” |
| Thiếu xử lý lỗi/edge | Mô tả thiếu | Thêm “xử lý null/timeout/lỗi mạng” vào đề |
| Sinh cả module quá to | Ôm đồm 1 lần | Chia: types → hàm → test, từng bước |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
