# /pr — PR title + body + checklist test

> Nôm na: nhờ viết bìa hồ sơ — tên, nội dung, đã kiểm tra những gì.

## Lệnh làm gì (1 câu nôm na)

Nôm na: nhờ viết bìa hồ sơ — tên, nội dung, đã kiểm tra những gì. Thuộc nhóm lệnh dùng hàng ngày — gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

- Mở PR cho nhánh vừa xong.
- Cần body nêu rõ đổi gì + test gì.
- Chuẩn hóa PR cho team dễ review.

## Cách gọi (copy-paste)

```bash
/pr
/pr tóm tắt diff thành title + body + checklist test
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/pr`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
/pr “tóm tắt diff này: title conventional, body có Đổi gì / Vì sao / Test, checklist đã chạy”
```

**Kết quả mong đợi:** PR title + body rõ (đổi gì, vì sao, test, rủi ro); reviewer đọc 1 phút hiểu.

**Cách verify:** Teammate đọc body không cần hỏi thêm là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Body chung chung | Diff quá to | Chia PR nhỏ; mỗi PR 1 mục đích |
| Thiếu phần test/rủi ro | Prompt thiếu | Bắt buộc có mục Test + Rủi ro |
| Title sai chuẩn team | Chưa nêu chuẩn | Nêu chuẩn title team trong prompt |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
