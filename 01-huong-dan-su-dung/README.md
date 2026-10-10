# 01 — Hướng dẫn sử dụng GitHub Copilot (đọc từ 00 → 17)

> **Dành cho:** người mới bắt đầu, và dev đã dùng Copilot nhưng muốn đi lại cho đúng thứ tự.
> **Vấn đề:** 18 bài học + 47 thư mục lệnh — đọc cái nào trước, bài nào liên quan tới việc mình đang làm.
> **Đọc xong:** biết thứ tự đọc 00 → 17, biết ghép bài đọc với lệnh trong `commands/`, và chọn được bài đúng nhu cầu ngay lúc này.
> **Thời gian:** ~5 phút.

Đọc theo thứ tự **00 → 17**: từ tổng quan, cài đặt, bề mặt sử dụng, cấu hình nền tảng
(`copilot-instructions.md`, chat commands, Agent Skills (chuẩn 2026, thay prompt files),
custom agents, instructions, rules, MCP, Agent Plugins, policies), tới agent mode,
code review, testing, models, security, best practices team và Agent Customizations hub.

Cách học nhanh: đọc bài tổng quan trước (00–04), vừa đọc vừa mở `commands/` tra lệnh tương ứng
(ví dụ đọc bài 04 thì mở `commands/code-actions/fix/` xem ví dụ prompt thật). Mỗi folder lệnh trong
`commands/` đều theo format cố định: **lệnh làm gì → khi nào dùng → cách gọi → ví dụ prompt thật +
kết quả mong đợi → lỗi thường gặp**.

Muốn nhảy cóc? Bảng dưới đây mô tả đúng 1 dòng mỗi bài — đọc cột "Mô tả 1 dòng" là đủ để quyết định có cần mở bài đó không.

## Danh sách bài (18 bài)

| # | Tên bài | Mô tả 1 dòng | Link |
|---|---------|--------------|------|
| 00 | Tổng quan Copilot | Bức tranh toàn cảnh: autocomplete vs chat vs agent mode vs coding agent vs CLI | [00-tong-quan-copilot.md](./00-tong-quan-copilot.md) |
| 01 | Cài đặt và xác thực | Plans, trial, setup VS Code/JetBrains/Visual Studio/Neovim + Copilot CLI | [01-cai-dat-va-xac-thuc.md](./01-cai-dat-va-xac-thuc.md) |
| 02 | Các bề mặt: VS Code, IDE, Web, CLI | So sánh VS Code, Visual Studio, JetBrains, Neovim, github.com, CLI | [02-cac-be-mat-vscode-ide-web-cli.md](./02-cac-be-mat-vscode-ide-web-cli.md) |
| 03 | Instructions, Memory, Rules | Ghi nhớ dự án: copilot-instructions.md, *.instructions.md, AGENTS.md | [03-instructions-memory-rules.md](./03-instructions-memory-rules.md) |
| 04 | Chat commands toàn tập | Index tra cứu ~70 slash commands/participants + công thức 5 lệnh đầu | [04-chat-commands-toan-tap.md](./04-chat-commands-toan-tap.md) |
| 05 | Agent Skills & Custom instructions (chuẩn 2026) | Tái dùng Agent Skills `SKILL.md` (chuẩn khuyến nghị, chạy mọi harness) + port prompt files legacy; Agent Plugins | [05-prompt-files-custom-instructions.md](./05-prompt-files-custom-instructions.md) |
| 06 | Custom agents & Parallel | Chạy nhiều agent song song, custom agents .github/agents | [06-custom-agents-parallel.md](./06-custom-agents-parallel.md) |
| 07 | Policies & Guardrails tự động hóa | Instruction enforcement, pre-commit, branch protection | [07-policies-guardrails-tu-dong-hoa.md](./07-policies-guardrails-tu-dong-hoa.md) |
| 08 | MCP — kết nối công cụ ngoài | Mở rộng Copilot bằng MCP servers (.vscode/mcp.json) | [08-mcp-ket-noi-cong-cu-ngoai.md](./08-mcp-ket-noi-cong-cu-ngoai.md) |
| 09 | Extensions & Marketplaces | Cài, chia sẻ và quản lý Copilot Extensions | [09-extensions-marketplaces.md](./09-extensions-marketplaces.md) |
| 10 | Modes, Permissions, Availability | Ask/Edit/Agent + Interactive/Plan/Autopilot, Session Target (Local/Copilot/Cloud), permission level (Manual/Assisted/Allow all), sandbox, content exclusion | [10-modes-permissions-availability.md](./10-modes-permissions-availability.md) |
| 11 | Git worktrees & Checkpoints | Làm việc song song, checkpoints/undo an toàn | [11-git-worktrees-checkpoints.md](./11-git-worktrees-checkpoints.md) |
| 12 | Copilot SDK, CI/CD, Automation | Tự động hóa bằng SDK, gh copilot CLI, Actions | [12-copilot-sdk-ci-cd-automation.md](./12-copilot-sdk-ci-cd-automation.md) |
| 13 | Code intelligence, Indexing, Telemetry | @workspace index, knowledge bases, audit logs | [13-code-intelligence-indexing-telemetry.md](./13-code-intelligence-indexing-telemetry.md) |
| 14 | Models: chọn model đúng | GPT/Claude/Gemini: AI Credits, khi nào dùng model nào | [14-models-chon-model-dung.md](./14-models-chon-model-dung.md) |
| 15 | Security stack 5 tầng | Defense-in-depth cho Copilot: exclusion → audit | [15-security-stack-5-tang.md](./15-security-stack-5-tang.md) |
| 16 | Extensions/MCP: bảo mật & validate | Validate extension/MCP trước khi cài | [16-extensions-mcp-bao-mat-validate.md](./16-extensions-mcp-bao-mat-validate.md) |
| 17 | Agent Customizations Hub | Bảng điện tổng: Customize Your Agent + Plugins/Skills/Instructions/Agents/Hooks/Tools + Voice/Dictation | [17-agent-customizations-hub.md](./17-agent-customizations-hub.md) |

## Tra cứu lệnh chi tiết (`commands/`)

Phần này dùng để tra nhanh khi đang làm việc — không cần đọc từ đầu.

- Tổng số: **46** thư mục lệnh (`find 01-huong-dan-su-dung/commands -mindepth 2 -type d | wc -l`).
- Index đầy đủ theo 4 nhóm: [commands/README.md](./commands/README.md)
- Ví dụ tra cứu nhanh: [commands/chat-session/new-chat/README.md](./commands/chat-session/new-chat/README.md)
  (thay `new-chat` bằng slug bất kỳ, vd `./commands/model-agent/agent-mode/README.md`, `./commands/system-knowledge/instructions/README.md`).
