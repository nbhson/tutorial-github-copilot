# Nhóm System & Knowledge (15 lệnh)

> **Dành cho:** người cấu hình và xử lý sự cố cho hệ thống, tri thức của Copilot · **Đọc xong:** tra đúng lệnh theo bảng dưới rồi bấm sang README chi tiết (~2 phút).

Nhóm này là "phòng máy" của Copilot: rules mà nó nạp (`/instructions`), cách mở rộng năng lực (prompt files, skills, MCP, extensions), thứ nó *không được* đọc (content exclusion), dữ liệu nó gửi đi (telemetry), tài khoản và trạng thái (`/status`, `/login`, `/logout`), cùng các công cụ ngoài Chat (knowledge base, `gh copilot`). Đây là nhóm bạn chỉ mở khi cần thiết lập hoặc khi có gì đó không chạy như mong đợi.

**Tra thế nào?** Phân theo mục đích: *"làm cho Copilot hiểu repo/team tôi"* → `/instructions`, tri thức nhóm; *"cắm thêm công cụ/skill"* → `/skills`, MCP, extensions; *"kiểm soát quyền riêng tư"* → content exclusion, telemetry; *"đăng nhập / kiểm tra sống chết"* → `/status`, `/login`, `/logout`; *"báo lỗi cho GitHub"* → `/feedback + /bug`; *"dùng Copilot ngoài Chat"* → `gh copilot`.

**Vì sao quan trọng?** Nhóm này quyết định Copilot trả lời dựa trên *luật nào*. Nạp sai instructions thì mọi câu trả lời trong repo đều lệch; thêm MCP/skill ẩu thì model gọi công cụ ngoài ý muốn. Cấu hình đúng một lần dùng được cho cả team.

**Nếu làm sai?** Hai cái bẫy: (1) tưởng `/prompts` vẫn là chuẩn chính — nó đã legacy, việc mới nên dùng `/skills`; (2) chỉnh telemetry/exclusion rồi quên rằng nó áp ở cấp tổ chức, có thể ảnh hưởng người khác chứ không riêng bạn.

| Lệnh | Mô tả 1 dòng | Chi tiết |
|---|---|---|
| `/instructions` | Xem/sửa instructions đang load cho repo này | [./instructions/README.md](./instructions/README.md) |
| `/prompts` | Liệt kê prompt files .github/prompts/ khả dụng (**legacy**, deprecated Agent Host) | [./prompt-file/README.md](./prompt-file/README.md) |
| `/skills` | Liệt kê Agent Skills .github/skills/ khả dụng | [./agent-skill/README.md](./agent-skill/README.md) |
| `/mcp` | Xem MCP servers/tools đang bật, reconnect khi rớt | [./mcp/README.md](./mcp/README.md) |
| `MCP add` | Thêm MCP server mới vào cấu hình | [./mcp-add/README.md](./mcp-add/README.md) |
| `/extensions` | Quản lý Copilot Extensions đã cài | [./extensions/README.md](./extensions/README.md) |
| `Content exclusion` | Xem files Copilot không được đọc | [./content-exclusion/README.md](./content-exclusion/README.md) |
| `Telemetry` | Xem/sửa code-telemetry consent | [./telemetry/README.md](./telemetry/README.md) |
| `/status` | Xem trạng thái Copilot: active, account, model | [./status/README.md](./status/README.md) |
| `/login` | Đăng nhập GitHub account cho Copilot | [./login/README.md](./login/README.md) |
| `/logout` | Đăng xuất, xóa credentials local | [./logout/README.md](./logout/README.md) |
| `/feedback + /bug` | Gửi feedback/bug về câu trả lời cho GitHub | [./bug-feedback/README.md](./bug-feedback/README.md) |
| `Knowledge base` | Hỏi tri thức team (docs nội bộ, wiki, RAG) | [./knowledge-base/README.md](./knowledge-base/README.md) |
| `gh copilot suggest` | Gợi ý lệnh CLI trong terminal (gh copilot) | [./cli-suggest/README.md](./cli-suggest/README.md) |
| `gh copilot explain` | Giải thích lệnh CLI vừa chạy/gặp | [./cli-explain/README.md](./cli-explain/README.md) |

## So sánh với Claude Code

| Việc | Copilot | Claude Code |
|---|---|---|
| Rules/memory nạp vào phiên | `/instructions` (`.github/copilot-instructions.md`, `AGENTS.md`) | `/memory` + `CLAUDE.md` |
| Lệnh tái sử dụng theo tên | Prompt files (`.github/prompts/`, **legacy**) → chuyển sang Skills | Custom slash commands trong `.claude/commands/` |
| Năng lực tự gọi khi task khớp | Agent Skills (`.github/skills/`, `/skills`) | Skills (`SKILL.md` trong `.claude/skills/`) |
| Kết nối công cụ ngoài | `/mcp`, `MCP add` | `claude mcp add`, `/mcp` |
| Chợ extension | Copilot Extensions (`/extensions`) | Không có tương đương trực tiếp — dùng MCP/plugins |
| Chặn đọc file | Content exclusion (cấp tổ chức) | Không có tương đương trực tiếp ở cấp org — dựa vào permission settings và `.gitignore` |
| Đồng ý telemetry | `Telemetry` (code-telemetry consent) | Cấu hình qua settings/env — không có lệnh riêng |
| Trạng thái & đăng nhập | `/status`, `/login`, `/logout` | `/status`; xác thực qua `claude` login/setup |
| Báo lỗi cho nhà cung cấp | `/feedback + /bug` | `/bug` |
| Hỏi tri thức nội bộ team | Knowledge base (docs/wiki/RAG) | Không có tương đương trực tiếp — thường cắm qua MCP |
| Gợi ý/giải thích lệnh shell | `gh copilot suggest`, `gh copilot explain` | Không có tương đương trực tiếp — Claude Code là một agent CLI |

Quay về: [../README.md](../README.md) · Bài tổng: [../../04-chat-commands-toan-tap.md](../../04-chat-commands-toan-tap.md)

> Đây là nhóm ít mở nhất nhưng đáng đầu tư nhất: cấu hình instructions, skills và MCP cho đúng một lần, cả team hưởng lợi ở mọi câu trả lời về sau.
