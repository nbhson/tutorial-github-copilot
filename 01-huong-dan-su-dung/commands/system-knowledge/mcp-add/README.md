# MCP add — Thêm MCP server mới vào config

> Nôm na: lắp thêm ổ cắm mới vào bảng điện — đúng dây, đúng aptomat.

## Lệnh làm gì (1 câu nôm na)

Nôm na: lắp thêm ổ cắm mới vào bảng điện — đúng dây, đúng aptomat. Thuộc nhóm lệnh dùng hàng ngày — gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

- Cần thêm server: github/playwright/postgres/fetch...
- Thêm server nội bộ team (http/sse).
- Thay server cũ hỏng.

## Cách gọi (copy-paste)

```bash
"MCP: Add Server" trong Command Palette
# hoặc sửa .vscode/mcp.json tay rồi reload
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `MCP add`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
Thêm postgres-dev (read-replica, user readonly) vào .vscode/mcp.json → reload → /mcp thấy connected
```

**Kết quả mong đợi:** Server mới connected; test 1 tool chỉ-đọc thành công; secrets qua env.

**Cách verify:** grep token thật trong mcp.json — trống + tool chạy là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Thêm mà không hiện | Sai transport/key | stdio cần command+args; remote cần url+headers; key là servers |
| Hardcode secret vào file | Tiện tay paste token | Dùng ${input}/${env}; lỡ lộ → xoay ngay |
| Trỏ nhầm prod writable | Copy URL prod | Postgres LUÔN read-replica + GRANT SELECT |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
