# /prompts — Liệt kê prompt files tái dùng

> Nôm na: mở hộp công thức — món nào nấu nhiều thì lấy công thức có sẵn.

## Lệnh làm gì (1 câu nôm na)

Nôm na: mở hộp công thức — món nào nấu nhiều thì lấy công thức có sẵn. Thuộc nhóm lệnh dùng hàng ngày — gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

- Việc lặp lại: review, deploy, tạo bảng.
- Muốn chuẩn hóa cách cả team ra lệnh.
- Tạo prompt mới từ prompt hay cũ.

## Cách gọi (copy-paste)

```bash
/prompts
/review-pr “review diff này theo correctness/security/tests”
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/prompts`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
/review-pr “review diff hiện tại: nêu 3 lỗi lớn nhất + gợi ý test thiếu”
```

**Kết quả mong đợi:** Prompt chuẩn chạy đúng form team; không cần gõ lại cả đoạn dài.

**Cách verify:** Chạy 2 lần cho 2 diff khác nhau — cùng form output là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Prompt file không hiện | Sai chỗ/frontmatter | File phải ở .github/prompts/ + frontmatter đúng |
| Prompt chung chung | Thiếu tiêu chí xong | Thêm checklist xong-việc vào prompt |
| Ai cũng tự chế prompt riêng | Thiếu chuẩn team | Gom prompt hay vào repo, xóa bản lẻ |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
