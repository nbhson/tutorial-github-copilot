# Policy approval — Duyệt policy, cho phép lệnh nhạy cảm

> Nôm na: cổng bảo vệ — lệnh lành cho qua, lệnh nguy hiểm phải xuất trình.

## Lệnh làm gì (1 câu nôm na)

Nôm na: cổng bảo vệ — lệnh lành cho qua, lệnh nguy hiểm phải xuất trình. Thuộc nhóm lệnh dùng hàng ngày — gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

- Agent xin Allow chạy lệnh (terminal/MCP tool).
- Muốn set baseline allow/ask/deny cho team.
- Khi nghi policy org đang chặn.

## Cách gọi (copy-paste)

```bash
Popup Allow/Deny khi agent xin
Team: settings → policies → allow/ask/deny theo tool
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `Policy approval`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
Agent xin chạy migration → chọn Deny + bảo “chỉ chạy trên DB dev, show lệnh trước”
```

**Kết quả mong đợi:** Lệnh nguy hiểm bị chặn/hỏi trước; lệnh lành chạy trơn; baseline team thống nhất.

**Cách verify:** Thử 1 lệnh nhạy cảm bị hỏi/chặn đúng là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Bấm Allow mù cho qua | Mỏi tay | Deny mặc định cho lệnh ghi/xóa; chỉ allow tools đọc |
| Không biết ai chặn | Nhầm policy vs bug | Hỏi admin tab Policies + xem audit log |
| Mỗi máy 1 kiểu approval | Thiếu baseline team | Commit baseline vào repo + docs |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
