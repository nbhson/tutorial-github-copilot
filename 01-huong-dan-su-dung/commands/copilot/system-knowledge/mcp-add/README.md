# MCP add (`.mcp.json`) — Thêm MCP server đúng chỗ, đúng key, secret qua env

> **Harness:** Copilot · **Surface:** VS Code Chat (Copilot harness) / Copilot CLI · **Đọc:** ~3 phút

**Nôm na:** Lắp thêm ổ cắm vào bảng điện: đúng dây, đúng aptomat thì thiết bị mới chạy — có ba chỗ để lắp và chọn sai chỗ là Copilot không bao giờ thấy server. Hợp khi cần thêm server mới (github, playwright, postgres…) hoặc thay server cũ đã hỏng.

## Vì sao dùng?

Đây là bước cấp cho agent một "cánh tay" vươn ra ngoài repo (tạo PR, query DB, mở browser) — cũng là bước cấp thêm quyền, nên "thêm đúng" quan trọng hơn "thêm nhanh": sai transport thì server im lặng, hardcode token thì rò rỉ, trỏ nhầm prod thì nguy hiểm. Làm qua UI có form thì ít sai key; làm qua file thì nhanh và review được trong PR.

| Chỗ đặt | Key gốc | Ai đọc | Điểm phải nhớ |
|---|---|---|---|
| `.mcp.json` (root repo) | `mcpServers` | **Copilot harness** đọc trực tiếp | portable, commit cho team; chỉ `stdio` + `http`; env `${NAME}` / `${NAME:-default}`; **không** có `cwd`, `envFile`, `${input:}` |
| `~/.copilot/mcp-config.json` | `mcpServers` | Copilot harness + Copilot CLI | mọi máy của bạn; thêm `sse`; field riêng CLI: `tools` (bắt buộc), `cwd`, `timeout` (ms, default 30000) |
| `.vscode/mcp.json` (workspace) | `servers` | **Local harness**; VS Code **forward** server đủ điều kiện sang Copilot session | `${input:}`/`envFile`/`cwd` chỉ ở đây; server cần input tương tác **không** được forward |

**Nếu làm sai:** dán token thẳng vào file rồi commit là coi như đã công khai — xóa commit không đủ, phải xoay key ngay; `${input:}` không port sang Copilot harness; DB thì luôn trỏ read-replica + `GRANT SELECT` để một lệnh ghi nhầm của agent không thành tai nạn trên dữ liệu thật.

## Cách dùng

Sửa file ở root repo — chắc tay hơn thì dùng `MCP: Add Server` hoặc form trong tab MCP Servers; CLI trong phiên: `/mcp add` ghi `~/.copilot/mcp-config.json`:

```jsonc
// .mcp.json — key "mcpServers" (KHÔNG phải "servers" như .vscode/mcp.json)
{ "mcpServers": { "team-tools": {
    "type": "http", "url": "https://<server-cua-team>",
    "headers": { "Authorization": "Bearer ${TOKEN}" }   // export TOKEN trên máy chạy server
} } }
```

- **Biến thể:** `code --add-mcp '{"name": …}'` ghi vào user profile của VS Code; server nặng (playwright) cho cả team thì share một remote `http`/`sse` thay vì mỗi máy spawn một process.
- **Setting:** env dạng `${NAME}` = bắt buộc có; `${NAME:-default}` = có giá trị bồi khi thiếu — secret không bao giờ nằm trong file.
- **✅ Verify:** grep token thật trong `.mcp.json` — **trống**, mà một tool chỉ-đọc vẫn chạy; commit `.mcp.json` qua PR để team review như soi code.

## Liên quan

- Xem/reconnect sau khi thêm: [mcp](../mcp/README.md) · Tool do GitHub host: [connector](../connector/README.md) · Bản Local: [vscode-mcp-json](../../../local/system-knowledge/vscode-mcp-json/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/) · Bài chủ: [08-mcp-ket-noi-cong-cu-ngoai.md](../../../../08-mcp-ket-noi-cong-cu-ngoai.md)
- Nguồn: [VS Code Docs — Find and install an MCP server](https://code.visualstudio.com/docs/agent-customization/mcp-servers#find-and-install-a-server) · [GitHub Docs — Add MCP servers (CLI)](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-mcp-servers)
