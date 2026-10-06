# /status — Xem trạng thái Copilot

> Nôm na: nhìn đồng hồ xe trước khi đi — xăng, máy, đèn báo có ổn không.

## Lệnh làm gì (1 câu nôm na)

Nôm na: nhìn đồng hồ xe trước khi đi — xăng, máy, đèn báo có ổn không. Thuộc nhóm lệnh dùng hàng ngày — gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

- Session đầu (làm 1 lần/repo).
- Khi lệnh vắng mặt / báo lỗi.
- Trước khi đổ lỗi cho AI.

## Cách gọi (copy-paste)

```bash
/status
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/status`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
/status
```

**Kết quả mong đợi:** Thấy active/account/plan/model/MCP overview; biết máy mình đang ở đâu.

**Cách verify:** Nói được “plan X, model Y, login Z” là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Đọc /status vẫn không hiểu | Thiếu checklist | Theo checklist 30s: plan → quota → list / → update ext |
| Status ok mà vẫn lỗi | Lỗi ở scope/policy | Tiếp tục check scope (#file) + policy org |
| Quên check đầu session | Vào là hỏi ngay | /status → /instructions → /mcp mỗi repo mới |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
