# /new — Mở chat mới sạch sẽ, nhẹ quota

> **Dành cho:** dev bắt đầu task mới trong VS Code · **Vấn đề:** chat cũ dài khiến model lẫn context, trả lời lan man · **Đọc xong:** biết chính xác lúc nào gõ `/new`, có prompt mẫu copy-paste và cách kiểm tra (~2 phút)

## Lệnh làm gì (1 câu nôm na)

Nôm na: đóng chat cũ đang rối, mở tờ giấy trắng để bắt đầu task mới. Lệnh mở chat trắng, history cũ không lẫn vào, instructions vẫn load lại từ file. Gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

Section này trả lời: nên bấm New Chat vào lúc nào, và khi nào thì KHÔNG nên (để khỏi mất việc đang dở).

- **Cho ai:** mọi người mở task mới hằng ngày — người mới nên xem đây là thói quen #1 mỗi task.
- Bắt đầu task mới khác hẳn task cũ.
- Chat hiện tại dài, model trả lời bắt đầu lan man.
- Muốn chốt scope + model ngay từ turn 1 thay vì sửa dần.
- KHÔNG dùng khi chỉ muốn hỏi tiếp việc đang dở (dùng /resume).

## Cách gọi (copy-paste)

Cách gọi `/new` — làm đúng theo khối dưới đây, kèm câu kiểm tra lệnh có ở máy bạn hay không:

```bash
/new
/new bắt đầu task refactor login, cho checklist 5 bước
# Kỳ vọng: chat trắng sạch, history cũ không lẫn
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/new`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

Prompt mẫu cho `/new` — đổi phần tên file/task cho đúng việc của bạn:

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
/new bắt đầu task refactor login, cho tôi checklist 5 bước
# Verify: hỏi tiếp 1 câu, model không nhắc chuyện chat cũ
```

**Kết quả mong đợi:** Chat trắng + checklist 5 bước đúng scope; history cũ không lẫn vào.

**Cách verify:** Hỏi tiếp 1 câu follow-up, nếu model không nhắc chuyện cũ là đạt.

## Lỗi thường gặp

Ba triệu chứng hay gặp nhất với lệnh này — kèm nhanh cách xử lý:

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Gõ /new mất hết context đang cần | Xóa cả phần còn dở | /export trước khi /new nếu còn việc dở |
| Kết quả chung chung | Không kèm mô tả sau /new | Gọi lại kèm file + mong đợi rõ |
| Không thấy /new trong list / | Extension cũ / plan gating | /status → xem plan → update extension |

## Tham khảo

Liên quan — index nhóm, cheatsheet 1 trang và FAQ phòng khi kẹt:

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
