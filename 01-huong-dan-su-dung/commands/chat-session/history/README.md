# /history — Xem và quay lại chat cũ

> Nôm na: mở sổ đầu bài cũ ra xem lại, tiếp tục từ chỗ hôm qua dừng.

## Lệnh làm gì (1 câu nôm na)

Nôm na: mở sổ đầu bài cũ ra xem lại, tiếp tục từ chỗ hôm qua dừng. Thuộc nhóm lệnh dùng hàng ngày — gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

- Muốn tiếp tục việc hôm qua làm dở.
- So sánh 2 cách giải quyết ở 2 chat khác nhau.
- Tìm lại prompt hay để lưu thành template.

## Cách gọi (copy-paste)

```bash
/history
# hoặc Ctrl+Shift+P → “Chat: Show History”
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/history`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
/history — tìm chat “refactor login hôm qua” mở lại
```

**Kết quả mong đợi:** Thấy list chats cũ theo thời gian; mở lại đúng phiên, tiếp tục không cần giải thích lại.

**Cách verify:** Nhắn 1 câu follow-up, model nhớ context cũ là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Không thấy chat hôm qua | Chat ở máy/profile khác hoặc đã xóa | Check đúng VS Code profile + máy |
| Mở lại nhưng model quên | History chỉ lưu text, không lưu full tool state | Tóm tắt lại 3 dòng rồi hỏi tiếp |
| List quá dài khó tìm | Đặt tên chat xấu | /export chat hay ra file để lần sau khỏi mò |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
