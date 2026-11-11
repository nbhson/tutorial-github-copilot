# MCP add — Thêm MCP server mới vào config

> **Dành cho:** người thêm MCP server mới (github, playwright, postgres…) · **Vấn đề:** sai key/transport thì server không lên, lỡ hardcode secret thì rò rỉ · **Đọc xong:** thêm server connected cho Copilot harness, secret qua env, DB trỏ read-replica (~3 phút)
> **Harness:** Copilot · **Surface:** VS Code Chat (Copilot harness) / Copilot CLI

## 1 câu nôm na

Lắp thêm một ổ cắm vào bảng điện: đúng dây, đúng aptomat thì thiết bị mới chạy. Có **ba chỗ để lắp**, và chọn sai chỗ là Copilot không thấy server: · 📄 [VS Code Docs: Customize AI agents (overview)](https://code.visualstudio.com/docs/agent-customization/overview)

| Chỗ đặt | Key gốc | Ai đọc | Điểm phải nhớ |
|---|---|---|---|
| `.mcp.json` (root repo) | `mcpServers` | **Copilot harness** (đọc trực tiếp) | portable, commit cho team; chỉ `stdio` + `http`; env dạng `${NAME}` / `${NAME:-default}`; **không** có `cwd`, `envFile`, `${input:}` |
| `~/.copilot/mcp-config.json` (user) | `mcpServers` | Copilot harness + Copilot CLI | mọi machine của bạn; `stdio`/`http`/`sse`; thêm field của CLI: `tools` (bắt buộc), `cwd`, `timeout` (ms) |
| `.vscode/mcp.json` (workspace) | `servers` | **Local harness**; VS Code **forward** server đủ điều kiện sang Copilot session | `${input:}`/`envFile`/`cwd` chỉ ở đây; server cần input tương tác **không** được forward |

## Vì sao phải chọn đúng chỗ đặt?

Đây là bước cấp cho agent một "cánh tay" vươn ra ngoài repo (tạo PR, query DB, mở browser). Làm qua UI (guided flow / Customizations editor) thì có form, ít sai key; làm qua file thì nhanh và review được trong PR. Điểm quan trọng nhất không phải tốc độ thêm, mà là **thêm đúng**: sai transport thì server im lặng, hardcode token thì rò rỉ, trỏ nhầm prod thì nguy hiểm. · 📄 [VS Code Docs: Customize AI agents (overview)](https://code.visualstudio.com/docs/agent-customization/overview)

## Khi nào dùng / khi nào đừng

- **Dùng khi:** cần thêm server github/playwright/postgres/fetch; thêm server nội bộ team (`http`); thay server cũ đã hỏng.
- **ĐỪNG dùng khi:** chỉ muốn **xem/reconnect** server đang bật — đó là [../mcp/README.md](../mcp/README.md); hoặc muốn công cụ do GitHub quản lý sẵn — đó là [connector](../connector/README.md). · 📄 [VS Code Docs: Choose a customization scope](https://code.visualstudio.com/docs/agent-customization/overview#choose-a-customization-scope)

## Cách gọi (copy-paste)

> 📄 **Code ví dụ JSONC:** [`examples/01-cach-goi-copy-paste.jsonc`](examples/01-cach-goi-copy-paste.jsonc) · [`examples/02-cach-goi-copy-paste.sh`](examples/02-cach-goi-copy-paste.sh) · 📄 [VS Code Docs: Find and install an MCP server](https://code.visualstudio.com/docs/agent-customization/mcp-servers#find-and-install-a-server)

| Đường | Lệnh | Ghi vào đâu |
|---|---|---|
| VS Code | `MCP: Add Server` (chọn destination trong guided flow) | `.mcp.json` (portable) hoặc `.vscode/mcp.json` (chỉ Local harness; cần `chat.mcp.workspaceRootConfig.enabled` để thấy lựa chọn root) |
| VS Code | `Chat: Open Customizations` → tab **MCP Servers** → form | portable file (`.mcp.json` / `mcp-config.json`) |
| Terminal | `code --add-mcp '{"name":"playwright", …}'` | user profile của VS Code (format `servers`) |
| Copilot CLI | `copilot mcp` hoặc `/mcp add` trong phiên | `~/.copilot/mcp-config.json` |

## Ví dụ thật

Nghiệp vụ: bạn muốn agent đọc dữ liệu DB an toàn để viết query, nhưng tuyệt đối không cho nó ghi lên dữ liệu thật.

> 📄 **Code ví dụ JSONC:** [`examples/03-vi-du-that.jsonc`](examples/03-vi-du-that.jsonc) · [`examples/04-vi-du-that.sh`](examples/04-vi-du-that.sh) · 📄 [VS Code Docs: Create project instructions](https://code.visualstudio.com/docs/agents/guides/customize-copilot-guide#step-1-create-project-instructions)

**Kết quả mong đợi:** server mới connected; test một tool chỉ-đọc chạy thành công; secret đi qua env, không nằm trong file.

**✅ Verify:** grep token thật trong `.mcp.json` — **trống**, mà tool vẫn chạy được là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — dán token thẳng vào file rồi commit:**

> 📄 **Code ví dụ:** [`examples/05-neu-lam-sai-thi-sao-sai-ung.jsonc`](examples/05-neu-lam-sai-thi-sao-sai-ung.jsonc)

**✅ ĐÚNG — env `${NAME}`, bí mật nằm ngoài repo:**

> 📄 **Code ví dụ:** [`examples/06-neu-lam-sai-thi-sao-sai-ung.jsonc`](examples/06-neu-lam-sai-thi-sao-sai-ung.jsonc) · 📄 [VS Code Docs: Troubleshoot customization issues](https://code.visualstudio.com/docs/agent-customization/overview#troubleshoot-customization-issues)

**Bài học:** file config nằm trong repo — coi như mọi thứ bạn dán vào đó đã công khai. Secret phải đi qua env; lỡ lộ thì **xoay key ngay**, xóa commit là không đủ.

## Lỗi thường gặp

📄 [VS Code Docs: If the server does not work](https://code.visualstudio.com/docs/agent-customization/mcp-servers#if-the-server-does-not-work)

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Thêm mà Copilot không hiện | Sai key (`servers` vs `mcpServers`) hoặc đặt sai file | Portable file dùng `mcpServers`; `.vscode/mcp.json` là của Local |
| Server có `${input:}` không sang Copilot | VS Code không forward server cần input tương tác | Đổi sang `${NAME}` và export env trên máy chạy server |
| CLI báo thiếu cấu hình | `~/.copilot/mcp-config.json` yêu cầu `tools` | Thêm `"tools": ["*"]` hoặc liệt kê tool cụ thể |
| Server local connect chậm/rớt | `timeout` (ms, default `30000`) quá ngắn cho server nặng | Tăng `timeout` trong `~/.copilot/mcp-config.json`; thêm `cwd`/`tools` cũng chỉ có ở file này |
| Trỏ nhầm prod writable | Copy URL prod | Postgres **luôn** trỏ read-replica + `GRANT SELECT` |
## So sánh với Claude Code

📄 [GitHub Docs: Comparing customizations](https://docs.github.com/en/copilot/concepts/customizations/comparing-customizations)

| Việc | Copilot | Claude Code | Ghi chú |
|---|---|---|---|
| File khai server | `.mcp.json` (key `mcpServers`) + `~/.copilot/mcp-config.json` | `.mcp.json` (project) + `claude mcp add` (user) | Cùng chuẩn portable, cùng key `mcpServers` |
| Transport | `stdio` + `http` (root file), thêm `sse` ở user file | stdio + remote | Kiểm capability trước khi copy field |
| Bí mật | env `${NAME}` (portable) / `${input:}` (chỉ `.vscode/mcp.json` — Local harness) | env / secret store riêng | Nguyên tắc chung: secret không vào file commit |
## Best practices (kèm "vì sao")

- **Secret luôn qua env, không hardcode.** *Vì sao?* File nằm trong git; bất cứ giá trị nào dán vào cũng coi như đã phát tán.
- **Đặt server ở file portable khi team dùng cả VS Code lẫn CLI.** *Vì sao?* `.mcp.json`/`mcp-config.json` được cả hai surface đọc; `.vscode/mcp.json` (Local harness) thì Copilot chỉ nhận bản forward.
- **DB luôn trỏ read-replica + `GRANT SELECT`.** *Vì sao?* Giới hạn thiệt hại tối đa nếu agent vô tình chạy lệnh ghi.
- **Thêm xong test bằng một tool chỉ-đọc.** *Vì sao?* Xác nhận server sống mà không tạo rủi ro nào.
- **Commit `.mcp.json` qua PR để review.** *Vì sao?* File này cấp quyền cho cả team, đáng được soi như code. · 📄 [VS Code Docs: Choose a configuration destination](https://code.visualstudio.com/docs/agent-customization/mcp-servers#choose-a-configuration-destination)

## Bài tập nhỏ

1. **(5 phút)** Thêm server `fetch` (stdio) vào `.mcp.json` với key `mcpServers`, reload và kiểm bằng `MCP: List Servers`.
2. **(10 phút)** Thêm một remote server `http` với header `{"Authorization":"Bearer ${TOKEN}"}`, export `TOKEN` rồi kiểm kết nối. · 📄 [VS Code Docs: Find and install an MCP server](https://code.visualstudio.com/docs/agent-customization/mcp-servers#find-and-install-a-server)

## Tham khảo

- Index nhóm: [../README.md](../README.md) · Xem/reconnect sau khi thêm: [../mcp/README.md](../mcp/README.md) · Connector: [../connector/README.md](../connector/README.md) · Bản Local: [vscode-mcp-json](../../../local/system-knowledge/vscode-mcp-json/README.md).
- Bài chủ: [08-mcp-ket-noi-cong-cu-ngoai.md](../../../../08-mcp-ket-noi-cong-cu-ngoai.md) · Cheatsheet: [CHEATSHEET.md](../../../../../CHEATSHEET.md).
- VS Code — [Add MCP servers](https://code.visualstudio.com/docs/agent-customization/mcp-servers) · [MCP configuration reference](https://code.visualstudio.com/docs/agents/reference/mcp-configuration) · GitHub — [Add MCP servers (CLI)](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-mcp-servers).

> Thêm server là thêm một quyền cho agent — làm chậm một nhịp để chọn đúng file và đúng transport, không nhét secret vào file, và luôn trỏ DB về read-replica.
