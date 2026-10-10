# /mcp — Xem MCP servers/tools đang bật

> **Dành cho:** dev dùng tool ngoài (GitHub, DB, browser) qua MCP · **Vấn đề:** tools đột nhiên mất, không biết server nào đang rớt · **Đọc xong:** xem trạng thái servers/tools và test lại bằng 1 lệnh thật (~2 phút)

## Lệnh làm gì (1 câu nôm na)

Nôm na: bảng điện tổng — xem cầu dao nào đang bật, cái nào nhảy. Session đầu mỗi repo nên chạy `/mcp` 1 lần: setup GitHub (và DB nếu có), test bằng 1 câu hỏi nhỏ.

## Khi nào dùng

Section này trả lời: khi nào mở bảng điện, và 3 lý do tools hay mất (sai key, auth, server crash).

- **Cho ai:** mọi người bắt đầu session mới trên repo, admin config MCP cho team.
- Session đầu mỗi repo (setup 1 lần).
- Tools MCP đột nhiên mất.
- Trước khi nhờ việc cần tool ngoài (PR/DB/browser).

## Cách gọi (copy-paste)

Cách gọi `/mcp` — làm đúng theo khối dưới đây, kèm câu kiểm tra lệnh có ở máy bạn hay không:

```bash
/mcp
# liệt kê servers/tools đang bật
# Kỳ vọng: thấy list servers connected + tools khả dụng
# Verify: test 1 tool thật (list PRs/query/test browser) chạy được
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/mcp`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

Prompt mẫu cho `/mcp` — đổi phần tên file/task cho đúng việc của bạn:

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
/mcp “liệt kê servers/tools đang bật” → rồi “dùng github tool liệt kê 5 PRs mới nhất”
```

**Kết quả mong đợi:** Thấy list servers connected + tools; test 1 tool nhỏ thành công.

**Cách verify:** 1 tool thật (list PRs/query/test browser) chạy được là đạt.

## Lỗi thường gặp

Ba triệu chứng hay gặp nhất với lệnh này — kèm nhanh cách xử lý:

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Tools không hiện | Sai key servers/mcpServers / server crash | So key với mẫu + xem Output → MCP log |
| Auth fail | Token sai/thiếu env | Token qua ${input}/env, không hardcode; test lại |
| Server nặng (playwright) | Mỗi máy spawn riêng | Team share 1 remote http/sse server |

## Tham khảo

Liên quan — index nhóm, cheatsheet 1 trang và FAQ phòng khi kẹt:

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
