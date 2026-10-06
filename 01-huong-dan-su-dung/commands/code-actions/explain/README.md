# /explain — Hiểu code đang chọn trong 30 giây

> Nôm na: chỉ vào đoạn code lạ và hỏi “đoạn này làm gì vậy?”

## Lệnh làm gì (1 câu nôm na)

Nôm na: chỉ vào đoạn code lạ và hỏi “đoạn này làm gì vậy?” Thuộc nhóm lệnh dùng hàng ngày — gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

- Đọc code người khác / code legacy.
- Review PR có đoạn khó hiểu.
- Onboard: hiểu module mới nhanh.

## Cách gọi (copy-paste)

```bash
Bôi đen code → /explain
/explain giải thích như cho intern mới
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/explain`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
(bôi đen 20 dòng middleware) /explain “giải thích từng bước + vẽ flow bằng chữ”
```

**Kết quả mong đợi:** Giải thích từng bước đúng logic + chỉ ra input/output + edge case; hiểu để review/sửa tiếp.

**Cách verify:** Tự giải thích lại bằng lời mình + chỉ ra 1 edge case là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Giải thích chung chung | Bôi quá ít hoặc quá nhiều (cả file) | Bôi 10–40 dòng trọng tâm + nêu file |
| Giải thích sai logic tricky | Code quá mẹo / thiếu context | Gắn thêm #file caller + hỏi “check lại dòng X” |
| Chỉ hiểu mà không verify | Tin luôn | Đặt breakpoint/log chạy thử 1 case |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
