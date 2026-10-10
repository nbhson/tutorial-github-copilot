# /explain — Hiểu code đang chọn trong 30 giây

> **Dành cho:** dev đọc code người khác / code legacy · **Vấn đề:** đoạn code lạ mất hàng giờ mới hiểu · **Đọc xong:** hiểu từng bước + edge case trong ~30 giây, đủ để review/sửa tiếp (~2 phút)

## Lệnh làm gì (1 câu nôm na)

Nôm na: chỉ vào đoạn code lạ và hỏi “đoạn này làm gì vậy?”. Bôi đen 10–40 dòng trọng tâm rồi `/explain`; bôi cả file thì câu trả lời sẽ chung chung.

## Khi nào dùng

Section này trả lời: bôi đoạn nào để giải thích đúng, và cách verify thay vì tin mù.

- **Cho ai:** người mới vào codebase, reviewer PR, ai phải đọc code legacy.
- Đọc code người khác / code legacy.
- Review PR có đoạn khó hiểu.
- Onboard: hiểu module mới nhanh.

## Cách gọi (copy-paste)

Cách gọi `/explain` — làm đúng theo khối dưới đây, kèm câu kiểm tra lệnh có ở máy bạn hay không:

```bash
Bôi đen code → /explain
/explain giải thích như cho intern mới
# Kỳ vọng: từng bước + input/output + edge case
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/explain`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

Prompt mẫu cho `/explain` — đổi phần tên file/task cho đúng việc của bạn:

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
(bôi đen 20 dòng middleware) /explain “giải thích từng bước + vẽ flow bằng chữ”
# Verify: tự giải thích lại bằng lời mình + chỉ ra 1 edge case
```

**Kết quả mong đợi:** Giải thích từng bước đúng logic + chỉ ra input/output + edge case; hiểu để review/sửa tiếp.

**Cách verify:** Tự giải thích lại bằng lời mình + chỉ ra 1 edge case là đạt.

## Lỗi thường gặp

Ba triệu chứng hay gặp nhất với lệnh này — kèm nhanh cách xử lý:

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Giải thích chung chung | Bôi quá ít hoặc quá nhiều (cả file) | Bôi 10–40 dòng trọng tâm + nêu file |
| Giải thích sai logic tricky | Code quá mẹo / thiếu context | Gắn thêm #file caller + hỏi “check lại dòng X” |
| Chỉ hiểu mà không verify | Tin luôn | Đặt breakpoint/log chạy thử 1 case |

## Tham khảo

Liên quan — index nhóm, cheatsheet 1 trang và FAQ phòng khi kẹt:

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
