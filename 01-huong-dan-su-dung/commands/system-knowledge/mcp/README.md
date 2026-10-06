# /mcp — Xem MCP servers/tools đang bật

> Nôm na: bảng điện tổng — xem cầu dao nào đang bật, cái nào nhảy.

## Lệnh làm gì (1 câu nôm na)

Nôm na: bảng điện tổng — xem cầu dao nào đang bật, cái nào nhảy. Session đầu nên setup GitHub (+ DB nếu có) rồi test bằng 1 câu hỏi nhỏ.

## Khi nào dùng

- Session đầu mỗi repo (setup 1 lần).
- Tools MCP đột nhiên mất.
- Trước khi nhờ việc cần tool ngoài (PR/DB/browser).

## Cách gọi (copy-paste)

```bash
/mcp
/mcp liệt kê servers/tools đang bật
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/mcp`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
/mcp “liệt kê servers/tools đang bật” → rồi “dùng github tool liệt kê 5 PRs mới nhất”
```

**Kết quả mong đợi:** Thấy list servers connected + tools; test 1 tool nhỏ thành công.

**Cách verify:** 1 tool thật (list PRs/query/test browser) chạy được là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Tools không hiện | Sai key servers/mcpServers / server crash | So key với mẫu + xem Output → MCP log |
| Auth fail | Token sai/thiếu env | Token qua ${input}/env, không hardcode; test lại |
| Server nặng (playwright) | Mỗi máy spawn riêng | Team share 1 remote http/sse server |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
