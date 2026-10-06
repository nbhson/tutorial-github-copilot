# /export — Lưu hội thoại ra file để share

> Nôm na: chụp lại toàn bộ cuộc trò chuyện thành file để lưu wiki hoặc gửi teammate.

## Lệnh làm gì (1 câu nôm na)

Nôm na: chụp lại toàn bộ cuộc trò chuyện thành file để lưu wiki hoặc gửi teammate. Thuộc nhóm lệnh dùng hàng ngày — gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

- Chat ra kết quả hay, muốn lưu cho team.
- Cần gửi context cho người khác tiếp tục.
- Trước khi /new hoặc /clear mà còn việc dở.

## Cách gọi (copy-paste)

```bash
/export
/export lưu chat này ra docs/chat-refactor-login.md
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/export`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
/export lưu chat này ra file markdown để tôi đưa vào wiki
```

**Kết quả mong đợi:** File markdown chứa đủ turns + code blocks; share được, secrets đã soát.

**Cách verify:** Mở file export, đọc lại 1 lượt thấy đủ ý là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| File export lọt secrets | Attach file chứa token rồi export nguyên | Soát secrets trước khi share; xóa token khỏi file |
| Export quá dài khó đọc | Chat 50+ turns | /summarize trước rồi export bản gọn |
| Không biết lưu đâu | Chưa quy ước chỗ lưu | Team chốt 1 folder docs/chats/ |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
