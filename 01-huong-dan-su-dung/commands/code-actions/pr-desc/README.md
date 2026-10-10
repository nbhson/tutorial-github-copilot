# /pr — PR title + body + checklist test

> **Dành cho:** dev mở PR cho nhánh vừa xong · **Vấn đề:** body chung chung khiến reviewer phải hỏi lại · **Đọc xong:** ra title + body có Đổi gì / Vì sao / Test, reviewer đọc 1 phút là hiểu (~2 phút)

## Lệnh làm gì (1 câu nôm na)

Nôm na: nhờ viết bìa hồ sơ — tên, nội dung, đã kiểm tra những gì. `/pr` tóm tắt diff thành title + body + checklist test; diff to thì chia PR nhỏ trước.

## Khi nào dùng

Section này trả lời: lúc nào gọi `/pr`, và phần nào của body là bắt buộc để không nợ review.

- **Cho ai:** mọi người mở PR, đặc biệt team cần chuẩn hóa format PR.
- Mở PR cho nhánh vừa xong.
- Cần body nêu rõ đổi gì + test gì.
- Chuẩn hóa PR cho team dễ review.

## Cách gọi (copy-paste)

Cách gọi `/pr` — làm đúng theo khối dưới đây, kèm câu kiểm tra lệnh có ở máy bạn hay không:

```bash
/pr
/pr tóm tắt diff thành title + body + checklist test
# Kỳ vọng: title conventional + body Đổi gì / Vì sao / Test
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/pr`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

Prompt mẫu cho `/pr` — đổi phần tên file/task cho đúng việc của bạn:

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
/pr “tóm tắt diff này: title conventional, body có Đổi gì / Vì sao / Test, checklist đã chạy”
# Verify: teammate đọc body 1 phút không cần hỏi thêm
```

**Kết quả mong đợi:** PR title + body rõ (đổi gì, vì sao, test, rủi ro); reviewer đọc 1 phút hiểu.

**Cách verify:** Teammate đọc body không cần hỏi thêm là đạt.

## Lỗi thường gặp

Ba triệu chứng hay gặp nhất với lệnh này — kèm nhanh cách xử lý:

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Body chung chung | Diff quá to | Chia PR nhỏ; mỗi PR 1 mục đích |
| Thiếu phần test/rủi ro | Prompt thiếu | Bắt buộc có mục Test + Rủi ro |
| Title sai chuẩn team | Chưa nêu chuẩn | Nêu chuẩn title team trong prompt |

## Tham khảo

Liên quan — index nhóm, cheatsheet 1 trang và FAQ phòng khi kẹt:

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
