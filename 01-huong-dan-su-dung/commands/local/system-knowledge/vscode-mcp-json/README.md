# .vscode/mcp.json — file MCP của Local harness (key `servers`), Copilot không đọc

> **Dành cho:** người thêm MCP server vào `.vscode/mcp.json` rồi thấy "tool biến mất" khi đổi harness · **Vấn đề:** không phân biệt file nào thuộc harness nào, `${input:}` hết hiệu lực · **Đọc xong:** chuyển đúng đường cấu hình MCP giữa Local và Copilot (~2 phút)
> **Harness:** Local — Copilot harness dùng `.mcp.json` (root repo) + `~/.copilot/mcp-config.json`

## 1 câu nôm na

`.vscode/mcp.json` là "dải điện gắn trong tủ extension host": Local harness đọc nó, key gốc là **`servers`**, và nó chơi được cả hai món riêng của Local là `${input:…}` (hỏi secret khi khởi động) lẫn sandbox per-server. Copilot harness chạy ở phòng khác, dùng ổ điện khác: **`.mcp.json` ở root repo** (key `mcpServers`) + `~/.copilot/mcp-config.json` — và theo docs hướng migrate, `${input:}`/sandbox per-server **không port** sang đó.

## Vì sao tách bài này khỏi bài MCP?

Các bài [../../../copilot/system-knowledge/mcp/README.md](../../../copilot/system-knowledge/mcp/README.md) và [../../../copilot/system-knowledge/mcp-add/README.md](../../../copilot/system-knowledge/mcp-add/README.md) dạy đường mặc định của **Copilot harness** (`.mcp.json` + `~/.copilot/mcp-config.json`). Phần Local cũ bị nhét lẫn vào đó, khiến người đọc tưởng `.vscode/mcp.json` là file chung của mọi harness. Hậu quả thật: thêm server "đã test ngon" trong phiên Local, mở phiên Copilot thì tool không có — và người dùng đổ oan cho model.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** bạn còn chạy session Local harness (`*.prompt.md`, mode Edit — xem [../prompt-file/README.md](../prompt-file/README.md), [../../model-agent/edit-mode/README.md](../../model-agent/edit-mode/README.md)); hoặc audit file cũ để migrate.
- **ĐỪNG dùng khi:** session chạy Copilot harness — file này nằm im, không ai đọc; khai báo server vào `.mcp.json` (root) như [../../../copilot/system-knowledge/mcp-add/README.md](../../../copilot/system-knowledge/mcp-add/README.md).
- **ĐỪNG coi nó là "file MCP mặc định của Copilot"** — câu đó đúng ở thời Local, sai từ khi khoá học mặc định dạy Copilot harness.

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

Hình dạng file Local (đặt tại `.vscode/mcp.json` trong repo):

```jsonc
{ "servers": { "my-db": { "command": "npx", "args": ["-y", "db-mcp"],
    "env": { "DSN": "${input:dsn}" } } },
  "inputs": [{ "id": "dsn", "type": "promptString", "password": true }] }
```

Bản Copilot harness đặt ở **root repo**, tên `.mcp.json`, key `mcpServers`, secret lấy từ biến môi trường — không có khối `inputs`.

## Ví dụ thật

Nghiệp vụ: server đọc DB staging đang chạy tốt ở phiên Local; team chuyển sang Copilot harness và "mất tool DB".

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh)

**Kết quả mong đợi:** sau khi chuyển khai báo sang `.mcp.json` (root) + `mcpServers` và đổi `${input:dsn}` thành env, server xuất hiện trong card MCP Servers của Agent Customizations editor; phiên Copilot gọi được tool.

**✅ Verify:** chạy một câu hỏi cần đúng dữ liệu DB đó — agent gọi tool của `my-db` thay vì báo không có cách truy cập.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — thêm server vào `.vscode/mcp.json` rồi mở session Copilot chờ tool hiện.** Copilot harness không đọc file này; bạn sẽ mất nửa ngày "restart đủ kiểu".
**✅ ĐÚNG — chọn file theo harness:** Local → `.vscode/mcp.json` (key `servers`); Copilot → `.mcp.json` ở root (key `mcpServers`) hoặc `~/.copilot/mcp-config.json` cho mọi project.

**❌ SAI — bê nguyên `${input:dsn}` sang `.mcp.json`.** Cú pháp input không port sang Copilot; server khởi động với giá trị rác hoặc chết.
**✅ ĐÚNG — thay bằng biến môi trường** đặt ngoài file (shell/profile); sandbox per-server kiểu Local cũng bỏ, dùng sandbox của Copilot harness.

**Bài học:** hai file cùng nói về MCP nhưng thuộc hai harness khác nhau — đổi harness là đổi *file*, không phải đổi *setting*.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Server có ở Local, mất ở Copilot | Copilot không đọc `.vscode/mcp.json` | Khai báo lại vào `.mcp.json` root với key `mcpServers` |
| Copilot báo lỗi parse khi đổi key `servers` → `mcpServers` ngược lại | Hai harness dùng key gốc khác nhau | Local: `servers`; Copilot: `mcpServers` — viết đúng theo file |
| `${input:}` không hỏi secret trong Copilot | Đúng thiết kế — không port | Chuyển secret sang env var |
| Trùng server giữa hai file, agent "lật bật" tool | Một server khai 2 nơi, cả 2 harness cùng mở | Mỗi harness một nguồn khai báo; file cũ đổi hậu tố `.bak` khi migrate |
| Không rõ thứ tự nạp MCP phía Copilot CLI | Docs CLI: `~/.copilot/mcp-config.json` (thấp nhất) → plugin → `--additional-mcp-config` (cao nhất) | Trùng tên thì nguồn bậc cao thắng; đọc docs CLI để chắc |

## So sánh với Claude Code

| Việc | Copilot | Claude Code | Ghi chú |
|---|---|---|---|
| File MCP project | `.mcp.json` root repo (`mcpServers`) | `.mcp.json` root repo | Copilot theo định dạng file mà Claude Code dùng; `.vscode/mcp.json` chỉ là di sản Local |
| File user-level | `~/.copilot/mcp-config.json` | Cấu hình user của CLI Claude | Đều "mọi project cùng thấy" |
| Secret trong MCP config | env var (khuyến nghị) | env / expansion trong config | Không ai trong hai bên khuyến nghị secret hard-code trong file |

## Best practices (kèm "vì sao")

- **Nhãn harness ngay đầu file khi còn giữ cả hai:** comment "LOCAL ONLY" trong `.vscode/mcp.json`. *Vì sao?* Người sau trong team không mất buổi chiều đoán file nào còn sống.
- **Migrate là chuyển hẳn, không "để phòng khi".** *Vì sao?* Hai bản khai cùng tên tạo tool trùng, hành vi agent khó tái hiện để debug.
- **Secret luôn nằm ngoài file commit.** *Vì sao?* `.vscode/mcp.json` và `.mcp.json` đều nằm trong repo; token trong git diff là token đã lộ.
- **Kiểm tra bằng card MCP Servers của Customizations editor trước khi hỏi "tool đâu".** *Vì sao?* Nó cho biết harness hiện tại có thấy server không, cắt đôi nghi ngờ.

## Bài tập nhỏ

1. **(4 phút)** `cat .vscode/mcp.json` trong repo của bạn: đếm số server dưới key `servers` và số chỗ dùng `${input:`.
2. **(8 phút)** Migrate một server ít rủi ro sang `.mcp.json` (root, key `mcpServers`, env thay `${input:}`); xác nhận nó hiện trong card MCP Servers khi đang Copilot harness.
3. **(3 phút)** Ghi 3 dòng vào tài liệu onboarding: harness nào đọc file nào, key gốc từng file.

## Tham khảo

- Index nhóm: [../README.md](../README.md) · Bản Copilot harness: [../../../copilot/system-knowledge/mcp/README.md](../../../copilot/system-knowledge/mcp/README.md) · Thêm server cho Copilot: [../../../copilot/system-knowledge/mcp-add/README.md](../../../copilot/system-knowledge/mcp-add/README.md) · Customization Local khác: [../prompt-file/README.md](../prompt-file/README.md)
- Bài học: [08 — MCP & kết nối](../../../../08-mcp-ket-noi-cong-cu-ngoai.md) · [16 — extensions/MCP & bảo mật](../../../../16-extensions-mcp-bao-mat-validate.md) · FAQ: [MCP](../../../../../03-cau-hoi-thuong-gap/04-mcp-faq.md) · Index lệnh: [../../../README.md](../../../README.md) · [CHEATSHEET](../../../../../CHEATSHEET.md)
- VS Code docs — MCP servers: https://code.visualstudio.com/docs/agent-customization/mcp-servers · Move Local → Copilot (`${input:}` không port): https://code.visualstudio.com/docs/agents/run/move-to-copilot
- GitHub docs — CLI, thứ tự nguồn MCP config: https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-plugin-reference

> Đổi harness là đổi *file*, không phải đổi *ý may mắn*: `.vscode/mcp.json` nuôi Local, Copilot chỉ ngửi `.mcp.json` và `~/.copilot/mcp-config.json`.
