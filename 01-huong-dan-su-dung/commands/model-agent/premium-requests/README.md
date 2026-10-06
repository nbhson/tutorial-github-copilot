# /usage — Xem quota premium đã dùng

> Nôm na: xem công-tơ điện — biết đã xài bao nhiêu để khỏi bị cúp giữa tháng.

## Lệnh làm gì (1 câu nôm na)

Nôm na: xem công-tơ điện — biết đã xài bao nhiêu để khỏi bị cúp giữa tháng. Thuộc nhóm lệnh dùng hàng ngày — gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

- Đầu tuần: check còn bao nhiêu.
- Thấy báo quota exhausted.
- Cuối tháng: rút kinh nghiệm phân bổ.

## Cách gọi (copy-paste)

```bash
/usage
# hoặc github.com/settings/copilot → quota
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/usage`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
/usage “cho biết đã dùng bao nhiêu, còn lại bao nhiêu, reset ngày nào”
```

**Kết quả mong đợi:** Biết con số đã dùng/còn lại + ngày reset; quyết được “tiết kiệm hay xả”.

**Cách verify:** Nói được “còn X, đủ/không đủ tới reset” là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Hết quota giữa tháng | Dùng model mạnh cho việc nhẹ | Việc nhẹ → model rẻ; agent → mạnh; prune MCP |
| Không biết ai xài nhiều (team) | Thiếu theo dõi org | Admin xem billing/seats + audit |
| Nhầm quota với bug | Báo error là tưởng hỏng | Đọc kỹ message: quota vs model unavailable khác nhau |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
