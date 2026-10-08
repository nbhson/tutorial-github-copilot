# /export — Lưu hội thoại ra file để share

> **Dành cho:** dev muốn lưu hoặc chia sẻ hội thoại · **Vấn đề:** kết quả hay nằm trong chat, không đưa được cho teammate/wiki · **Đọc xong:** export ra file markdown sạch, không lọt secrets (~2 phút)

## Lệnh làm gì (1 câu nôm na)

Nôm na: chụp lại toàn bộ cuộc trò chuyện thành file để lưu wiki hoặc gửi teammate. Lệnh ghi đủ turns + code blocks ra file. Trước khi `/new` hoặc `/clear` mà còn việc dở thì export trước.

## Khi nào dùng

Section này trả lời: lúc nào nên chụp lại hội thoại, và làm sao để file export không rò rỉ secret.

- **Cho ai:** người cần bàn giao context, hoặc team muốn lưu chat hay vào wiki.
- Chat ra kết quả hay, muốn lưu cho team.
- Cần gửi context cho người khác tiếp tục.
- Trước khi /new hoặc /clear mà còn việc dở.

## Cách gọi (copy-paste)

Cách gọi `/export` — làm đúng theo khối dưới đây, kèm câu kiểm tra lệnh có ở máy bạn hay không:

```bash
/export
/export lưu chat này ra docs/chat-refactor-login.md
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/export`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

Prompt mẫu cho `/export` — đổi phần tên file/task cho đúng việc của bạn:

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
/export lưu chat này ra file markdown để tôi đưa vào wiki
```

**Kết quả mong đợi:** File markdown chứa đủ turns + code blocks; share được, secrets đã soát.

**Cách verify:** Mở file export, đọc lại 1 lượt thấy đủ ý là đạt.

## Lỗi thường gặp

Ba triệu chứng hay gặp nhất với lệnh này — kèm nhanh cách xử lý:

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| File export lọt secrets | Attach file chứa token rồi export nguyên | Soát secrets trước khi share; xóa token khỏi file |
| Export quá dài khó đọc | Chat 50+ turns | /summarize trước rồi export bản gọn |
| Không biết lưu đâu | Chưa quy ước chỗ lưu | Team chốt 1 folder docs/chats/ |

## Tham khảo

Liên quan — index nhóm, cheatsheet 1 trang và FAQ phòng khi kẹt:

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
