# /mcp — Bảng điện tổng: MCP servers/tools nào đang sống, reconnect khi rớt

> **Harness:** Copilot · **Surface:** VS Code Chat (Copilot harness) / Copilot CLI · **Đọc:** ~2 phút

**Nôm na:** Nhìn một cái là biết cầu dao nào đang bật, cái nào vừa nhảy — liệt kê MCP servers + tools khả dụng và cho reconnect khi rớt. Hợp khi tools MCP đột nhiên mất, hoặc trước khi nhờ việc cần dữ liệu ngoài (PR, DB, browser).

## Vì sao dùng?

MCP server chạy **ngoài** editor: rớt mạng, hết token, crash sau cập nhật là chuyện thường. Không kiểm trạng thái, bạn chỉ thấy "sao Copilot không mở được PR nữa" mà không biết server chưa lên — đổ oan cho model trong khi lỗi nằm ở tầng kết nối. Mỗi harness đọc config từ nguồn khác nhau, đây là cái bẫy lớn nhất của mục này.

| Bạn ở đâu | Lệnh xem trạng thái | Server đọc từ file nào |
|---|---|---|
| Copilot harness (VS Code) | `Chat: Open Customizations` → tab **MCP Servers**, hoặc `MCP: List Servers` | `.mcp.json` ở root repo (key `mcpServers`) + `~/.copilot/mcp-config.json` |
| Copilot CLI | `copilot mcp` (ngoài phiên), `/mcp list` / `/mcp show` (trong phiên) | như trên |
| Local harness (VS Code Chat) | `MCP: List Servers` | `.vscode/mcp.json` (key `servers`) — **Copilot harness không đọc file này** ([vscode-mcp-json](../../../local/system-knowledge/vscode-mcp-json/README.md)) |

**Nếu làm sai:** gõ `/` trong Chat view mà không thấy `/mcp` — đúng rồi, slash đó thuộc Copilot CLI, VS Code dùng palette/editor; và đừng chờ "Copilot sửa help" để test kết nối: kiểm bằng một việc **nhỏ** trước, fail ở việc lớn không cho bạn biết lỗi nằm ở tầng nào.

## Cách dùng

Gõ trong Copilot CLI (session); ngoài phiên dùng `copilot mcp`:

```prompt
/mcp list
/mcp show
```

- **Biến thể:** thêm/sửa server ở [mcp-add](../mcp-add/README.md); dòng nhãn `Connector: <name>` do GitHub host và chỉ phục vụ Copilot harness ([connector](../connector/README.md)).
- **Quy ước:** tool gọi trong chat theo tên `mcp__<server>__<tool>`; giữ khoảng 3–6 server — càng nhiều tool, model càng dễ chọn nhầm.
- **✅ Verify:** đầu session trên mỗi repo kiểm một lần, rồi test một tool nhỏ ("liệt kê 5 PRs mới nhất") chạy thật là đạt.

## Liên quan

- Bài chủ: [08-mcp-ket-noi-cong-cu-ngoai.md](../../../../08-mcp-ket-noi-cong-cu-ngoai.md) · Thêm server: [mcp-add](../mcp-add/README.md) · Tool do GitHub quản lý: [connector](../connector/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — Troubleshoot MCP servers](https://code.visualstudio.com/docs/agents/run/manage-mcp-servers#troubleshoot-mcp-servers) · [GitHub Docs — MCP](https://docs.github.com/en/copilot/concepts/customizations/mcp)
