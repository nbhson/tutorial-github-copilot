# Edit mode — Sửa file chỉ định, có kiểm soát

> Nôm na: đưa thợ danh sách phòng được sửa — ngoài danh sách cấm đụng.

## Lệnh làm gì (1 câu nôm na)

Nôm na: đưa thợ danh sách phòng được sửa — ngoài danh sách cấm đụng. Thuộc nhóm lệnh dùng hàng ngày — gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

- Đã biết sửa file nào (1–5 file).
- Sửa vừa: đổi message, thêm validation, refactor nhỏ.
- Muốn kiểm soát chặt file nào được chạm.

## Cách gọi (copy-paste)

```bash
Chat → mode Edit → tick files
“đổi message lỗi sang tiếng Việt, chỉ 2 file đã tick”
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `Edit mode`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
(Edit, tick 2 file) “thêm validation email + test, chỉ đụng 2 file này”
```

**Kết quả mong đợi:** Diff chỉ trong files đã tick; review từng hunk rồi Accept; test xanh.

**Cách verify:** git diff --stat chỉ hiện files đã tick là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Sửa lan sang file chưa tick | Prompt thiếu “chỉ ... ” | Ghi rõ “chỉ đụng files đã tick” |
| Tick quá nhiều file | Ôm cả chục file | Tick ≤5 file/lần, chia phase |
| Accept mù | Lười đọc diff | Đọc từng hunk + chạy test trước Accept |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
