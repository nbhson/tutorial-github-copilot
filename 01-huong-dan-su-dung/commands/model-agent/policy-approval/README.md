# Policy approval — Duyệt policy, cho phép lệnh nhạy cảm

> **Dành cho:** người thấy popup Allow/Deny, và admin set policy team · **Vấn đề:** bấm Allow mù cho qua lệnh nguy hiểm, hoặc không biết ai đang chặn · **Đọc xong:** set baseline allow/ask/deny đúng chỗ (~2 phút)

## Lệnh làm gì (1 câu nôm na)

Nôm na: cổng bảo vệ — lệnh lành cho qua, lệnh nguy hiểm phải xuất trình. Popup Allow/Deny hiện khi agent xin chạy lệnh; team set baseline allow/ask/deny theo tool ở settings → policies.

## Khi nào dùng

Section này trả lời: khi nào nên Deny thay vì Allow, và cách phân biệt policy chặn với bug.

- **Cho ai:** người duyệt lệnh cho agent, admin/tech lead set policy cho team.
- Agent xin Allow chạy lệnh (terminal/MCP tool).
- Muốn set baseline allow/ask/deny cho team.
- Khi nghi policy org đang chặn.

## Cách gọi (copy-paste)

Cách gọi `Policy approval` — làm đúng theo khối dưới đây, kèm câu kiểm tra lệnh có ở máy bạn hay không:

```bash
Popup Allow/Deny khi agent xin
Team: settings → policies → allow/ask/deny theo tool
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `Policy approval`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

Prompt mẫu cho `Policy approval` — đổi phần tên file/task cho đúng việc của bạn:

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
Agent xin chạy migration → chọn Deny + bảo “chỉ chạy trên DB dev, show lệnh trước”
```

**Kết quả mong đợi:** Lệnh nguy hiểm bị chặn/hỏi trước; lệnh lành chạy trơn; baseline team thống nhất.

**Cách verify:** Thử 1 lệnh nhạy cảm bị hỏi/chặn đúng là đạt.

## Lỗi thường gặp

Ba triệu chứng hay gặp nhất với lệnh này — kèm nhanh cách xử lý:

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Bấm Allow mù cho qua | Mỏi tay | Deny mặc định cho lệnh ghi/xóa; chỉ allow tools đọc |
| Không biết ai chặn | Nhầm policy vs bug | Hỏi admin tab Policies + xem audit log |
| Mỗi máy 1 kiểu approval | Thiếu baseline team | Commit baseline vào repo + docs |

## Tham khảo

Liên quan — index nhóm, cheatsheet 1 trang và FAQ phòng khi kẹt:

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
