# /history — Xem và quay lại chat cũ

> **Dành cho:** dev muốn tìm lại chat cũ · **Vấn đề:** không nhớ đã nói gì hôm qua, cần so sánh 2 cách làm ở 2 phiên · **Đọc xong:** tìm và mở lại đúng phiên trong vài giây (~2 phút)

## Lệnh làm gì (1 câu nôm na)

Nôm na: mở sổ đầu bài cũ ra xem lại, tiếp tục từ chỗ hôm qua dừng. Lệnh liệt kê chat cũ theo thời gian để mở lại; dùng khi quên tên phiên còn `/resume` cần nhớ phiên nào.

## Khi nào dùng

Section này trả lời: khi nào cần mở sổ cũ, và cách tìm nhanh khi list chat đã dài.

- **Cho ai:** người làm việc multi-day, hay so sánh solution giữa các phiên khác nhau.
- Muốn tiếp tục việc hôm qua làm dở.
- So sánh 2 cách giải quyết ở 2 chat khác nhau.
- Tìm lại prompt hay để lưu thành template.

## Cách gọi (copy-paste)

Cách gọi `/history` — làm đúng theo khối dưới đây, kèm câu kiểm tra lệnh có ở máy bạn hay không:

```bash
/history
# hoặc Ctrl+Shift+P → “Chat: Show History”
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/history`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

Prompt mẫu cho `/history` — đổi phần tên file/task cho đúng việc của bạn:

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
/history — tìm chat “refactor login hôm qua” mở lại
```

**Kết quả mong đợi:** Thấy list chats cũ theo thời gian; mở lại đúng phiên, tiếp tục không cần giải thích lại.

**Cách verify:** Nhắn 1 câu follow-up, model nhớ context cũ là đạt.

## Lỗi thường gặp

Ba triệu chứng hay gặp nhất với lệnh này — kèm nhanh cách xử lý:

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Không thấy chat hôm qua | Chat ở máy/profile khác hoặc đã xóa | Check đúng VS Code profile + máy |
| Mở lại nhưng model quên | History chỉ lưu text, không lưu full tool state | Tóm tắt lại 3 dòng rồi hỏi tiếp |
| List quá dài khó tìm | Đặt tên chat xấu | /export chat hay ra file để lần sau khỏi mò |

## Tham khảo

Liên quan — index nhóm, cheatsheet 1 trang và FAQ phòng khi kẹt:

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
