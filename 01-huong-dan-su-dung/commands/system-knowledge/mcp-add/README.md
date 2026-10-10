# MCP add — Thêm MCP server mới vào config

> **Dành cho:** người thêm MCP server mới (github, playwright, postgres...) · **Vấn đề:** sai key/transport thì server không lên, lỡ hardcode secret thì rò rỉ · **Đọc xong:** thêm server connected, secrets qua env, DB trỏ read-replica (~3 phút)

## Lệnh làm gì (1 câu nôm na)

Nôm na: lắp thêm ổ cắm mới vào bảng điện — đúng dây, đúng aptomat. Dùng “MCP: Add Server” trong Command Palette, hoặc sửa `.vscode/mcp.json` tay rồi reload — key của workspace là `servers`.

## Khi nào dùng

Section này trả lời: khi nào thêm server, và 3 bẫy hay gặp nhất (sai key, secret hardcode, trỏ nhầm prod).

- **Cho ai:** người cấu hình tool cho repo, admin set MCP cho team.
- Cần thêm server: github/playwright/postgres/fetch...
- Thêm server nội bộ team (http/sse).
- Thay server cũ hỏng.

## Cách gọi (copy-paste)

Cách gọi `MCP add` — làm đúng theo khối dưới đây, kèm câu kiểm tra lệnh có ở máy bạn hay không:

```bash
"MCP: Add Server" trong Command Palette
# hoặc sửa .vscode/mcp.json tay rồi reload
# Kỳ vọng: server mới connected, secrets qua env không hardcode
# Verify: grep token thật trong mcp.json — trống + tool chạy được
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `MCP add`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

Prompt mẫu cho `MCP add` — đổi phần tên file/task cho đúng việc của bạn:

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
Thêm postgres-dev (read-replica, user readonly) vào .vscode/mcp.json → reload → /mcp thấy connected
```

**Kết quả mong đợi:** Server mới connected; test 1 tool chỉ-đọc thành công; secrets qua env.

**Cách verify:** grep token thật trong mcp.json — trống + tool chạy là đạt.

## Lỗi thường gặp

Ba triệu chứng hay gặp nhất với lệnh này — kèm nhanh cách xử lý:

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Thêm mà không hiện | Sai transport/key | stdio cần command+args; remote cần url+headers; key là servers |
| Hardcode secret vào file | Tiện tay paste token | Dùng ${input}/${env}; lỡ lộ → xoay ngay |
| Trỏ nhầm prod writable | Copy URL prod | Postgres LUÔN read-replica + GRANT SELECT |

## Tham khảo

Liên quan — index nhóm, cheatsheet 1 trang và FAQ phòng khi kẹt:

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
