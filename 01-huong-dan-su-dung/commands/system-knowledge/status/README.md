# /status — Xem trạng thái Copilot

> **Dành cho:** mọi người, đặc biệt đầu session mới · **Vấn đề:** lệnh vắng mặt, báo lỗi, dễ đổ oan cho AI trong khi lỗi ở plan/scope · **Đọc xong:** đọc được active/account/plan/model trong 30 giây (~2 phút)

## Lệnh làm gì (1 câu nôm na)

Nôm na: nhìn đồng hồ xe trước khi đi — xăng, máy, đèn báo có ổn không. `/status` cho xem trạng thái Copilot: active, account, plan, model và overview MCP; mỗi repo check 1 lần là đủ.

## Khi nào dùng

Section này trả lời: khi nào mở nắp ca-pô, và checklist 30 giây khi status vẫn ổn mà vẫn lỗi.

- **Cho ai:** mọi người — đặc biệt người mới, trước khi kết luận “Copilot hỏng”.
- Session đầu (làm 1 lần/repo).
- Khi lệnh vắng mặt / báo lỗi.
- Trước khi đổ lỗi cho AI.

## Cách gọi (copy-paste)

Cách gọi `/status` — làm đúng theo khối dưới đây, kèm câu kiểm tra lệnh có ở máy bạn hay không:

```bash
/status
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/status`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

Prompt mẫu cho `/status` — đổi phần tên file/task cho đúng việc của bạn:

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
/status
```

**Kết quả mong đợi:** Thấy active/account/plan/model/MCP overview; biết máy mình đang ở đâu.

**Cách verify:** Nói được “plan X, model Y, login Z” là đạt.

## Lỗi thường gặp

Ba triệu chứng hay gặp nhất với lệnh này — kèm nhanh cách xử lý:

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Đọc /status vẫn không hiểu | Thiếu checklist | Theo checklist 30s: plan → quota → list / → update ext |
| Status ok mà vẫn lỗi | Lỗi ở scope/policy | Tiếp tục check scope (#file) + policy org |
| Quên check đầu session | Vào là hỏi ngay | /status → /instructions → /mcp mỗi repo mới |

## Tham khảo

Liên quan — index nhóm, cheatsheet 1 trang và FAQ phòng khi kẹt:

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
