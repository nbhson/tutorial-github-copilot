# Edit mode — Sửa file chỉ định, có kiểm soát

> **Dành cho:** người đã biết sửa file nào (1–5 file) · **Vấn đề:** agent sửa ngoài phạm vi cho phép · **Đọc xong:** kiểm soát được file nào được chạm, diff gọn để review (~2 phút)

## Lệnh làm gì (1 câu nôm na)

Nôm na: đưa thợ danh sách phòng được sửa — ngoài danh sách cấm đụng. Chat → mode Edit → tick files, rồi ghi rõ “chỉ đụng những file đã tick”.

## Khi nào dùng

Section này trả lời: khi nào chọn Edit thay vì Agent, và làm sao không tick quá nhiều file.

- **Cho ai:** người sửa có chủ đích, muốn review từng hunk trước khi Accept.
- Đã biết sửa file nào (1–5 file).
- Sửa vừa: đổi message, thêm validation, refactor nhỏ.
- Muốn kiểm soát chặt file nào được chạm.

## Cách gọi (copy-paste)

Cách gọi `Edit mode` — làm đúng theo khối dưới đây, kèm câu kiểm tra lệnh có ở máy bạn hay không:

```bash
Chat → mode Edit → tick files
“đổi message lỗi sang tiếng Việt, chỉ 2 file đã tick”
# Kỳ vọng: diff chỉ nằm trong 2 file đã tick, không lan thêm
# Verify: git diff --stat chỉ hiện files đã tick
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `Edit mode`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

Prompt mẫu cho `Edit mode` — đổi phần tên file/task cho đúng việc của bạn:

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
(Edit, tick 2 file) “thêm validation email + test, chỉ đụng 2 file này”
```

**Kết quả mong đợi:** Diff chỉ trong files đã tick; review từng hunk rồi Accept; test xanh.

**Cách verify:** git diff --stat chỉ hiện files đã tick là đạt.

## Lỗi thường gặp

Ba triệu chứng hay gặp nhất với lệnh này — kèm nhanh cách xử lý:

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Sửa lan sang file chưa tick | Prompt thiếu “chỉ ... ” | Ghi rõ “chỉ đụng files đã tick” |
| Tick quá nhiều file | Ôm cả chục file | Tick ≤5 file/lần, chia phase |
| Accept mù | Lười đọc diff | Đọc từng hunk + chạy test trước Accept |

## Tham khảo

Liên quan — index nhóm, cheatsheet 1 trang và FAQ phòng khi kẹt:

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
