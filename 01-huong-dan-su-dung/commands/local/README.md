# Bucket `local/` — 9 lệnh & đường dẫn chỉ chạy ở Local harness

> **Dành cho:** người từng dùng VS Code Chat trước khi Copilot harness ra mặc định · **Vấn đề:** `/export`, Edit mode, prompt files, `@workspace`… "tự nhiên mất" · **Đọc xong:** hiểu vì sao chúng không chạy ở harness mới và đường dẫn thay thế là gì (~2 phút).

Local harness là chat engine cũ của VS Code (kênh mở rộng, `workbench.panel.chat` — phím `Shift+Alt+P` hay `Ctrl+Shift+P` → `Chat: Open Local Chat`). Nó **vẫn chạy song song, không bị gỡ** — nhưng các tính năng dưới đây **không được Copilot harness kế tục**. Khoá học mặc định dạy Copilot harness; bucket này tồn tại để giải thích các lệnh legacy, không phải để dạy chúng như tính năng hiện hành.

## Mục lục

| Nhóm | Nội dung | Slug |
|---|---|---|
| [Chat & phiên](./chat-session/README.md) | lệnh phiên chỉ Local có | `/export` · `/help` |
| [Model & agent](./model-agent/README.md) | chế độ & participant legacy | `Edit mode` · `@workspace/@terminal/@vscode` |
| [System & kiến thức repo](./system-knowledge/README.md) | file & CLI legacy | `/prompts` + `.prompt.md` · `.vscode/mcp.json` · `gh copilot suggest/explain` |

## Tra nhanh: "lệnh cũ của tôi đâu rồi?"

| Bạn từng gõ / dùng | Giờ ở đâu (Copilot harness) | Giải thích chi tiết |
|---|---|---|
| `/export` | `Chat: Export Chat…` (command palette) | [./chat-session/export/README.md](./chat-session/export/README.md) |
| `/help` | không có slash tương đương — xem index lệnh trong [../README.md](../README.md) | [./chat-session/help/README.md](./chat-session/help/README.md) |
| `Edit mode` | Plan/Agent qua **built-in agents**; cần đúng Local thì `chat.editSessions.enabled` | [./model-agent/edit-mode/README.md](./model-agent/edit-mode/README.md) |
| `@workspace` `@terminal` `@vscode` | context qua `#`-mentions / `Attach`; chat participants **deprecated** | [./model-agent/participants/README.md](./model-agent/participants/README.md) |
| `/prompts` + `.prompt.md` | **Agent Skills** (bài 05); `/prompts` + `chat.promptFiles` vẫn sống ở Local | [./system-knowledge/prompt-file/README.md](./system-knowledge/prompt-file/README.md) |
| `.vscode/mcp.json` (`servers`) | Copilot đọc `.mcp.json` root + `~/.copilot/mcp-config.json` (key `mcpServers`) | [./system-knowledge/vscode-mcp-json/README.md](./system-knowledge/vscode-mcp-json/README.md) |
| `gh copilot suggest/explain` | GitHub Copilot CLI (binary `copilot`) — **khác sản phẩm** | [./system-knowledge/cli-suggest/README.md](./system-knowledge/cli-suggest/README.md) · [./system-knowledge/cli-explain/README.md](./system-knowledge/cli-explain/README.md) |

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — "VS Code gỡ mất `/export` rồi, Copilot kém hơn".** Không gỡ — nó đổi chỗ sang lệnh palette, và `/export` vẫn tồn tại ở Local harness.

**✅ ĐÚNG — xác định harness trước khi kết luận "mất tính năng":** `Chat: Manage Chat Sessions` / Agent Customizations editor cho biết bạn đang ở engine nào; nếu đang ở Copilot harness, tra bảng trên; nếu muốn quay về Local, `chat.sharedProxyConnectionMode.enabled = false` (docs VS Code).

**Bài học:** 8 slug này trả lời câu hỏi "sao lệnh cũ không chạy", không phải "hãy dùng lệnh cũ".

## Tham khảo

- Bài liên quan: [04 — Chat commands toàn tập](../../04-chat-commands-toan-tap.md) (cột Local/Copilot) · [05 — Agent Skills](../../05-agent-skills-reusable-workflows.md) · [08 — MCP](../../08-mcp-ket-noi-cong-cu-ngoai.md) · [17 — Agent Customizations editor](../../17-agent-customizations-hub.md).
- Docs: [Agent harnesses (VS Code)](https://code.visualstudio.com/docs/agents/run/agent-harnesses) · [Copilot harness](https://code.visualstudio.com/docs/setup/copilot) · [gh-copilot extension](https://github.com/github/gh-copilot).
- Index lệnh: [../README.md](../README.md) · Cheatsheet: [../../../CHEATSHEET.md](../../../CHEATSHEET.md).

> **Chốt:** bucket này là bảo tàng có chức năng — 8 slug để bạn nhận diện lệnh legacy và chọn đúng đường dẫn thay thế, còn lệnh hằng ngày nằm hết ở [`../copilot/`](../copilot/README.md).
