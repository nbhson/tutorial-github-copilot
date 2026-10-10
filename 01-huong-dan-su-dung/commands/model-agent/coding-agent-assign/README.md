# Coding agent assign — Giao issue cho agent làm async

> **Dành cho:** người có issue đã rõ (mục tiêu + phạm vi + lệnh verify) · **Vấn đề:** issue mơ hồ khiến agent làm sai, hoặc 2 agent conflict · **Đọc xong:** giao issue async, sáng ra có PR chờ review (~2 phút)

## Lệnh làm gì (1 câu nôm na)

Nôm na: giao việc cho ca đêm — sáng ngủ dậy có PR chờ review. GitHub issue → Assign → Copilot, kèm Mục tiêu / Phạm vi / Lệnh verify; mỗi agent 1 vùng/branch để khỏi conflict.

## Khi nào dùng

Section này trả lời: issue nào đáng giao cho coding agent, và mẫu issue 4 dòng để không bị làm sai.

- **Cho ai:** tech lead chia việc, người muốn song song nhiều issue.
- Issue đã rõ (mục tiêu + phạm vi + lệnh verify).
- Việc độc lập, không cần quyết liên tục.
- Muốn song song nhiều issues.

## Cách gọi (copy-paste)

Cách gọi `Coding agent assign` — làm đúng theo khối dưới đây, kèm câu kiểm tra lệnh có ở máy bạn hay không:

```bash
GitHub issue → Assign → Copilot
Kèm: mục tiêu / phạm vi / lệnh verify
# Kỳ vọng: sáng ra có PR chờ review, diff đúng phạm vi, test xanh
# Verify: PR mở từ branch agent, CI xanh, không đụng file ngoài phạm vi
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `Coding agent assign`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

Prompt mẫu cho `Coding agent assign` — đổi phần tên file/task cho đúng việc của bạn:

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
Issue: “thêm rate-limit /api/login. Phạm vi: apps/api/**. Verify: pnpm --filter api test. Không đụng web/.” → assign Copilot
```

**Kết quả mong đợi:** Agent tự tạo branch + PR kèm log/test; bạn chỉ review + merge.

**Cách verify:** PR có test xanh + diff đúng phạm vi là đạt.

## Lỗi thường gặp

Ba triệu chứng hay gặp nhất với lệnh này — kèm nhanh cách xử lý:

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Agent làm sai vì issue mơ hồ | Thiếu mục tiêu/phạm vi/verify | Viết issue theo mẫu: Mục tiêu/Phạm vi/Xong khi/Lệnh verify |
| Conflict với PR người khác | 2 người đụng 1 vùng | Mỗi agent 1 vùng/branch; rebase trước merge |
| Giao việc quá to | Issue ôm cả epic | Tách issue nhỏ, mỗi issue 1 PR |

## Tham khảo

Liên quan — index nhóm, cheatsheet 1 trang và FAQ phòng khi kẹt:

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
