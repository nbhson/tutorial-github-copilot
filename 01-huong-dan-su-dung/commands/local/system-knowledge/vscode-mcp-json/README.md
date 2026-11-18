# `.vscode/mcp.json` — File MCP của Local harness (key gốc `servers`), Copilot harness không đọc

> **Harness:** Local · **Surface:** file workspace `.vscode/mcp.json`, do extension host phía Local đọc — Copilot harness dùng `.mcp.json` ở root repo + `~/.copilot/mcp-config.json` · **Đọc:** ~2 phút

**Nôm na:** "Dải điện gắn trong tủ extension host": Local harness đọc file này, key gốc **`servers`**, kèm hai món riêng của Local là `${input:…}` (hỏi secret khi khởi động) và sandbox per-server. Hợp khi bạn còn chạy session Local hoặc đang audit file cũ để migrate sang `.mcp.json`.

## Vì sao dùng?

Hai harness ăn hai file MCP khác nhau, và đó là nguồn cơn triệu chứng kinh điển: server "test ngon" ở phiên Local, mở phiên Copilot thì "mất tool" — không phải file hỏng, mà là không ai đọc nó. Đổi harness là đổi **file**, không phải đổi setting — phân file theo harness dưới đây tiết kiệm một buổi chiều "restart đủ kiểu":

| Harness | File | Key gốc | Ghi chú |
|---|---|---|---|
| Local | `.vscode/mcp.json` | `servers` | có `${input:…}` (hỏi secret lúc khởi động) + sandbox per-server |
| Copilot | `.mcp.json` (root repo) | `mcpServers` | `${input:}` và sandbox **không port** sang đây |
| Copilot (mọi project) | `~/.copilot/mcp-config.json` | `mcpServers` | thứ tự nạp CLI: `~/.copilot/mcp-config.json` → plugin → `--additional-mcp-config`, trùng tên bậc cao thắng |

**Nếu làm sai:** khai trùng một server ở cả hai file thì tool xung đột, agent hành vi lật bật — migrate là chuyển hẳn, file cũ đổi hậu tố `.bak`; secret tuyệt đối không hard-code trong file, và `${input:dsn}` khi sang `.mcp.json` phải thay bằng biến môi trường đặt ngoài file.

## Cách dùng

File path `.vscode/mcp.json` trong repo — extension host bên Local harness đọc:

```jsonc
{ "servers": { "my-db": { "command": "npx", "args": ["-y", "db-mcp"],
    "env": { "DSN": "${input:dsn}" } } },
  "inputs": [{ "id": "dsn", "type": "promptString", "password": true }] }
```

- **Biến thể:** migrate sang Copilot — chuyển khai báo vào `.mcp.json` ở root, đổi key thành `mcpServers`, thay `${input:dsn}` bằng env var.
- **Setting:** key gốc phân biệt hai thế giới — Local: `servers`; Copilot: `mcpServers`; `${input:}` và sandbox chỉ tồn tại ở phía Local.
- **✅ Verify:** mở Customizations editor, card MCP Servers hiện `my-db` đúng harness; hỏi một câu cần dữ liệu DB — agent gọi tool thay vì báo không có cách truy cập.

## Liên quan

- Thêm server đường Copilot: [mcp-add](../../../copilot/system-knowledge/mcp-add/README.md) · xem/reconnect: [mcp](../../../copilot/system-knowledge/mcp/README.md) · customization Local khác: [prompt-file](../prompt-file/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — MCP configuration](https://code.visualstudio.com/docs/agents/reference/mcp-configuration#configuration-file) · [VS Code Docs — Move to Copilot](https://code.visualstudio.com/docs/agents/run/move-to-copilot)
