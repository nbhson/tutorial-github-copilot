# /new — Mở chat mới sạch sẽ, nhẹ quota

> Nôm na: đóng chat cũ đang rối, mở tờ giấy trắng để bắt đầu task mới.

## Lệnh làm gì (1 câu nôm na)

Nôm na: đóng chat cũ đang rối, mở tờ giấy trắng để bắt đầu task mới. Dùng đúng lúc giúp bắt đầu sạch, tiết kiệm 3–5 turns làm rõ.

## Khi nào dùng

- Bắt đầu task mới khác hẳn task cũ.
- Chat hiện tại dài, model trả lời bắt đầu lan man.
- Muốn chốt scope + model ngay từ turn 1 thay vì sửa dần.
- KHÔNG dùng khi chỉ muốn hỏi tiếp việc đang dở (dùng /resume).

## Cách gọi (copy-paste)

```bash
/new
/new bắt đầu task refactor login, cho checklist 5 bước
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/new`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
/new bắt đầu task refactor login, cho tôi checklist 5 bước
```

**Kết quả mong đợi:** Chat trắng + checklist 5 bước đúng scope; history cũ không lẫn vào.

**Cách verify:** Hỏi tiếp 1 câu follow-up, nếu model không nhắc chuyện cũ là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Gõ /new mất hết context đang cần | Xóa cả phần còn dở | /export trước khi /new nếu còn việc dở |
| Kết quả chung chung | Không kèm mô tả sau /new | Gọi lại kèm file + mong đợi rõ |
| Không thấy /new trong list / | Extension cũ / plan gating | /status → xem plan → update extension |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
