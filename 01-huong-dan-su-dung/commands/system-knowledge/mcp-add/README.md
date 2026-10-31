# MCP add — Thêm MCP server mới vào config

> **Dành cho:** người thêm MCP server mới (github, playwright, postgres...) · **Vấn đề:** sai key/transport thì server không lên, lỡ hardcode secret thì rò rỉ · **Đọc xong:** thêm server connected, secret qua env, DB trỏ read-replica (~3 phút)

## 1 câu nôm na

`MCP add` là lắp thêm một ổ cắm mới vào bảng điện: đúng dây, đúng aptomat thì thiết bị mới chạy. Bạn dùng lệnh “MCP: Add Server” trong Command Palette, hoặc sửa `.vscode/mcp.json` bằng tay rồi reload — với workspace của VS Code, key gốc là `servers`.

## Vì sao thêm MCP server (MCP add)?

Đây là bước để cấp cho agent một “cánh tay” mới vươn ra ngoài repo (tạo PR, query DB, mở browser). Làm qua UI thì có form, ít sai key; làm qua file thì nhanh và review được trong PR. Điểm quan trọng nhất không phải tốc độ thêm, mà là **thêm đúng**: sai transport thì server im lặng không lên, hardcode token thì rò rỉ, trỏ nhầm prod thì nguy hiểm.

**Nếu làm sai thì sao?** Ba bẫy hay gặp: (1) sai `transport` → server không connect mà cũng không báo rõ; (2) dán token thẳng vào `mcp.json` rồi commit → lộ key; (3) copy URL prod writable → agent có quyền ghi lên dữ liệu thật.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** cần thêm server github/playwright/postgres/fetch; thêm server nội bộ team (`http`/`sse`); thay một server cũ đã hỏng.
- **ĐỪNG dùng khi:** bạn chỉ muốn **xem** server/tool đang bật hoặc reconnect — đó là `/mcp` (xem [../mcp/README.md](../mcp/README.md)).

> Chọn transport khi thêm server:

| Transport | Config cần | Khi nào dùng |
|---|---|---|
| stdio (local) | `command` + `args` | Server chạy trên máy bạn (`npx`, binary nội bộ) |
| http/sse (remote) | `url` + `headers` | Server dùng chung team, không muốn mỗi máy spawn riêng |

## Cách gọi (copy-paste)

```jsonc
// .vscode/mcp.json — thêm một khối dưới key "servers"
{
  "servers": {
    "github": { "command": "npx", "args": ["-y", "@modelcontextprotocol/server-github"] }
  }
}
```

```bash
# Hoặc qua UI: Command Palette (Ctrl+Shift+P) → "MCP: Add Server"
# Kỳ vọng: server mới connect, secret đi qua env, KHÔNG hardcode trong file
# Verify: grep token thật trong mcp.json → trống, mà tool vẫn chạy được
```

> Không thấy `MCP: Add Server` trong Command Palette? Kiểm `/status` + plan trước khi kết luận lỗi công cụ.

## Ví dụ thật

Nghiệp vụ: bạn muốn agent đọc dữ liệu DB an toàn để viết query, nhưng tuyệt đối không cho nó ghi lên dữ liệu thật.

```jsonc
// .vscode/mcp.json — thêm postgres-dev, trỏ read-replica, user chỉ có quyền đọc
{
  "servers": {
    "postgres-dev": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      // KHÔNG dán connection string thật ở đây:
      "env": { "DATABASE_URL": "${input:pg_readonly_url}" }
    }
  }
}
```

```bash
# Sau khi lưu → reload window → kiểm kết nối bằng lệnh của /mcp:
/mcp              # thấy postgres-dev: connected?
# rồi test 1 tool chỉ-đọc:
"liệt kê 5 bảng trong postgres-dev"
```

**Kết quả mong đợi:** server mới connected; test một tool chỉ-đọc chạy thành công; secret đi qua env, không nằm trong file.

**✅ Verify:** grep token thật trong `.vscode/mcp.json` — **trống**, mà tool vẫn chạy được là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — dán token thẳng vào file rồi commit:**

```jsonc
"env": { "DATABASE_URL": "postgres://readonly:S3cret@prod-db:5432/app" }
// lỡ push lên repo → token lộ vĩnh viễn trong git history.
```

**✅ ĐÚNG — dùng `${input}`/env, giữ bí mật ngoài repo:**

```jsonc
"env": { "DATABASE_URL": "${input:pg_readonly_url}" }   // nhập lúc chạy, không nằm trong file
```

**Bài học:** `mcp.json` là file trong repo — coi như mọi thứ bạn dán vào đó đã công khai. Secret phải đi qua `${input}`/env; lỡ lộ thì **xoay key ngay**, xóa commit là không đủ.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Thêm mà không hiện | Sai transport/key | stdio cần `command`+`args`; remote cần `url`+`headers`; key gốc là `servers` |
| Hardcode secret vào file | Tiện tay paste token | Dùng `${input}`/`${env}`; lỡ lộ → xoay key ngay |
| Trỏ nhầm prod writable | Copy URL prod | Postgres **luôn** trỏ read-replica + `GRANT SELECT` |

## So sánh với Claude Code

| Việc | Copilot (`MCP add`) | Claude Code | Ghi chú |
|---|---|---|---|
| Khai báo server | `.vscode/mcp.json` (key `servers`) | Cấu hình MCP riêng (vd `.mcp.json`/CLI) | Cùng chuẩn MCP; khác tên file |
| Transport | `stdio` (`command`+`args`) hoặc `http`/`sse` (`url`+`headers`) | Cũng hỗ trợ stdio và remote | Cùng hai kiểu transport |
| Bí mật | `${input}`/`${env}`, không hardcode | Env/secret để ngoài file | Nguyên tắc giống nhau: secret không vào file commit |

## Best practices (kèm "vì sao")

- **Secret luôn qua `${input}`/env.** *Vì sao?* File nằm trong git; bất cứ giá trị nào bạn dán vào cũng coi như đã phát tán.
- **DB luôn trỏ read-replica + `GRANT SELECT`.** *Vì sao?* Giới hạn thiệt hại tối đa nếu agent vô tình chạy lệnh ghi.
- **Chọn đúng transport trước khi lưu.** *Vì sao?* Sai kiểu (stdio vs remote) khiến server không lên mà thông báo lỗi lại mơ hồ.
- **Thêm xong test bằng một tool chỉ-đọc.** *Vì sao?* Xác nhận server sống mà không tạo rủi ro nào.
- **Giữ số server vừa phải (3–6).** *Vì sao?* Càng nhiều tool, model càng dễ chọn nhầm khi cần gọi.
- **Commit `mcp.json` qua PR để review.** *Vì sao?* File này ảnh hưởng cả team, đáng được soi như code.

## Bài tập nhỏ

1. **(5 phút)** Thêm server `fetch` (stdio) vào `.vscode/mcp.json`, reload và kiểm bằng `/mcp`.
2. **(10 phút)** Thêm một remote server giả (http) với header truyền qua `${input}`, xem có connect không.
3. **(10 phút)** Tự audit: grep các chuỗi giống token trong `mcp.json`; nếu có hardcode thì chuyển sang `${input}` ngay.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh System & Knowledge.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Xem/reconnect server sau khi thêm: [../mcp/README.md](../mcp/README.md).

> **Chốt:** thêm server là thêm một quyền cho agent — làm chậm một nhịp để chọn đúng transport, không nhét secret vào file, và luôn trỏ DB về read-replica.
