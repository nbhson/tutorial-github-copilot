# /usage — Xem quota premium đã dùng

> **Dành cho:** người muốn biết đã tốn bao nhiêu AI Credits · **Vấn đề:** hết credit giữa tháng, hoặc không biết ai xài nhiều · **Đọc xong:** đọc được đã dùng / còn lại / ngày reset để quyết tiết kiệm hay xả (~2 phút)

## Lệnh làm gì (1 câu nôm na)

Nôm na: xem công-tơ điện — biết đã xài bao nhiêu để khỏi bị cúp giữa tháng. Lưu ý fact mới: từ 01/06/2026 Copilot dùng mô hình **AI Credits** (1 credit = $0.01, usage-based) thay cho “AI Credits” cũ; code completion vẫn không tính credit trên các plan trả phí.

## Khi nào dùng

Section này trả lời: khi nào mở công-tơ, và cách phân biệt “hết credit” với “lỗi model”.

- **Cho ai:** người dùng plan cá nhân trả phí, admin theo dõi credit của team.
- Đầu tuần: check còn bao nhiêu.
- Thấy báo quota exhausted.
- Cuối tháng: rút kinh nghiệm phân bổ.

## Cách gọi (copy-paste)

Cách gọi `/usage` — làm đúng theo khối dưới đây, kèm câu kiểm tra lệnh có ở máy bạn hay không:

```bash
/usage
# hoặc github.com/settings/copilot → quota
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/usage`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

Prompt mẫu cho `/usage` — đổi phần tên file/task cho đúng việc của bạn:

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
/usage “cho biết đã dùng bao nhiêu, còn lại bao nhiêu, reset ngày nào”
```

**Kết quả mong đợi:** Biết con số đã dùng/còn lại + ngày reset; quyết được “tiết kiệm hay xả”.

**Cách verify:** Nói được “còn X, đủ/không đủ tới reset” là đạt.

## Lỗi thường gặp

Ba triệu chứng hay gặp nhất với lệnh này — kèm nhanh cách xử lý:

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Hết quota giữa tháng | Dùng model mạnh cho việc nhẹ | Việc nhẹ → model rẻ; agent → mạnh; prune MCP |
| Không biết ai xài nhiều (team) | Thiếu theo dõi org | Admin xem billing/seats + audit |
| Nhầm quota với bug | Báo error là tưởng hỏng | Đọc kỹ message: quota vs model unavailable khác nhau |

## Tham khảo

Liên quan — index nhóm, cheatsheet 1 trang và FAQ phòng khi kẹt:

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
