# Coding agent assign — Giao issue cho agent làm async

> Nôm na: giao việc cho ca đêm — sáng ngủ dậy có PR chờ review.

## Lệnh làm gì (1 câu nôm na)

Nôm na: giao việc cho ca đêm — sáng ngủ dậy có PR chờ review. Thuộc nhóm lệnh dùng hàng ngày — gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

- Issue đã rõ (mục tiêu + phạm vi + lệnh verify).
- Việc độc lập, không cần quyết liên tục.
- Muốn song song nhiều issues.

## Cách gọi (copy-paste)

```bash
GitHub issue → Assign → Copilot
Kèm: mục tiêu / phạm vi / lệnh verify
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `Coding agent assign`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
Issue: “thêm rate-limit /api/login. Phạm vi: apps/api/**. Verify: pnpm --filter api test. Không đụng web/.” → assign Copilot
```

**Kết quả mong đợi:** Agent tự tạo branch + PR kèm log/test; bạn chỉ review + merge.

**Cách verify:** PR có test xanh + diff đúng phạm vi là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Agent làm sai vì issue mơ hồ | Thiếu mục tiêu/phạm vi/verify | Viết issue theo mẫu: Mục tiêu/Phạm vi/Xong khi/Lệnh verify |
| Conflict với PR người khác | 2 người đụng 1 vùng | Mỗi agent 1 vùng/branch; rebase trước merge |
| Giao việc quá to | Issue ôm cả epic | Tách issue nhỏ, mỗi issue 1 PR |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
