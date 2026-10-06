# /agent (Agent mode) — Giao task mở cho agent tự làm

> Nôm na: giao chìa khóa cho đội thợ — tự tìm phòng, tự làm, bạn duyệt cuối.

## Lệnh làm gì (1 câu nôm na)

Nôm na: giao chìa khóa cho đội thợ — tự tìm phòng, tự làm, bạn duyệt cuối. Thuộc nhóm lệnh dùng hàng ngày — gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

- Task mở: “thêm rate-limit cho /api/login + test”.
- Chưa biết chạm file nào, cần agent tìm.
- Multi-step: sửa + chạy lệnh + sửa tiếp.

## Cách gọi (copy-paste)

```bash
Chat → mode Agent
“thêm rate-limit cho /api/login + test; duyệt plan trước khi code”
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/agent (Agent mode)`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
(Agent) “thêm rate-limit /api/login: tìm code hiện tại, đề xuất plan, tôi duyệt rồi mới code + test”
```

**Kết quả mong đợi:** Agent liệt kê file đã đọc + plan để duyệt; code + test theo phase; bạn review diff cuối.

**Cách verify:** Plan được duyệt trước + test xanh + diff gọn là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Agent chạy loạn, sửa lung tung | Giao task quá to không plan | Bắt “đề xuất plan, chờ duyệt” + chia phase |
| Approve tool mù | Mỏi tay bấm Allow | Để ask cho lệnh nguy hiểm; allow chỉ tools đọc |
| Không checkpoint trước | Sửa sai khó về | Commit git tay trước khi giao agent |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
