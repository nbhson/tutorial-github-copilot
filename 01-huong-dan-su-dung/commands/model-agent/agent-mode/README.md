# /agent (Agent mode) — Giao task mở cho agent tự làm

> **Dành cho:** người có task mở, chưa biết chạm file nào · **Vấn đề:** giao việc to không plan khiến agent sửa lung tung · **Đọc xong:** giao task nhiều bước mà vẫn có plan để duyệt (~2 phút)

## Lệnh làm gì (1 câu nôm na)

Nôm na: giao chìa khóa cho đội thợ — tự tìm phòng, tự làm, bạn duyệt cuối. Chat → mode Agent; bắt agent “đề xuất plan, chờ duyệt” trước khi code và commit git tay trước khi chạy.

> **UI mới (2026):** Agent tách 3 persona — **Interactive** (dừng hỏi mỗi thay đổi, ≈ Agent + `ask`), **Plan** (chỉ lập kế hoạch, không sửa code), **Autopilot** (tự chạy tới xong, ≈ Agent + `Allow all`). Autopilot chỉ dùng trong worktree riêng + đã bật sandbox. Chi tiết: [10-modes-permissions-availability.md mục 3.2](../../../10-modes-permissions-availability.md).

## Khi nào dùng

Section này trả lời: task nào đáng giao cho Agent, và 3 quy tắc giữ agent trong phạm vi.

- **Cho ai:** người giao việc nhiều bước (sửa + chạy lệnh + sửa tiếp); chưa hợp người mới với task to.
- Task mở: “thêm rate-limit cho /api/login + test”.
- Chưa biết chạm file nào, cần agent tìm.
- Multi-step: sửa + chạy lệnh + sửa tiếp.

## Cách gọi (copy-paste)

Cách gọi `/agent (Agent mode)` — làm đúng theo khối dưới đây, kèm câu kiểm tra lệnh có ở máy bạn hay không:

```bash
Chat → mode Agent
“thêm rate-limit cho /api/login + test; duyệt plan trước khi code”
# Kỳ vọng: agent liệt kê file + plan trước, chờ duyệt, không code tự ý
# Verify: git log mới nhất là commit của bạn (checkpoint), diff agent gọn trong scope
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/agent (Agent mode)`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

Prompt mẫu cho `/agent (Agent mode)` — đổi phần tên file/task cho đúng việc của bạn:

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
(Agent) “thêm rate-limit /api/login: tìm code hiện tại, đề xuất plan, tôi duyệt rồi mới code + test”
```

**Kết quả mong đợi:** Agent liệt kê file đã đọc + plan để duyệt; code + test theo phase; bạn review diff cuối.

**Cách verify:** Plan được duyệt trước + test xanh + diff gọn là đạt.

## Lỗi thường gặp

Ba triệu chứng hay gặp nhất với lệnh này — kèm nhanh cách xử lý:

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Agent chạy loạn, sửa lung tung | Giao task quá to không plan | Bắt “đề xuất plan, chờ duyệt” + chia phase |
| Approve tool mù | Mỏi tay bấm Allow | Để ask cho lệnh nguy hiểm; allow chỉ tools đọc |
| Không checkpoint trước | Sửa sai khó về | Commit git tay trước khi giao agent |

## Tham khảo

Liên quan — index nhóm, cheatsheet 1 trang và FAQ phòng khi kẹt:

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
