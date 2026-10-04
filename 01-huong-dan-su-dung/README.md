# 01 — Hướng dẫn sử dụng Muse

Đọc theo thứ tự **00 → 16**: từ tổng quan, cài đặt, bề mặt sử dụng, cấu hình nền tảng
(`muse-instructions.md`, chat commands, prompt files, custom agents, instructions,
rules, MCP, extensions, policies), tới agent mode, code review, testing,
models, security và best practices team.

## Danh sách bài (17 bài)

| # | Tên bài | Mô tả 1 dòng | Link |
|---|---------|--------------|------|
| 00 | Tổng quan Copilot | Bức tranh toàn cảnh: autocomplete vs chat vs agent mode vs coding agent vs CLI | [00-tong-quan-copilot.md](./00-tong-quan-copilot.md) |
| 01 | Cài đặt và xác thực | Plans, trial, setup VS Code/JetBrains/Visual Studio/Neovim + Copilot CLI | [01-cai-dat-va-xac-thuc.md](./01-cai-dat-va-xac-thuc.md) |
| 02 | Các bề mặt: VS Code, IDE, Web, CLI | So sánh VS Code, Visual Studio, JetBrains, Neovim, github.com, CLI | [02-cac-be-mat-vscode-ide-web-cli.md](./02-cac-be-mat-vscode-ide-web-cli.md) |
| 03 | Instructions, Memory, Rules | Ghi nhớ dự án: muse-instructions.md, *.instructions.md, AGENTS.md | [03-instructions-memory-rules.md](./03-instructions-memory-rules.md) |
| 04 | Chat commands toàn tập | Index tra cứu ~70 slash commands/participants + công thức 5 lệnh đầu | [04-chat-commands-toan-tap.md](./04-chat-commands-toan-tap.md) |
| 05 | Prompt files & Custom instructions | Tái dùng prompt files, Agent Skills, Copilot Extensions | [05-prompt-files-custom-instructions.md](./05-prompt-files-custom-instructions.md) |
| 06 | Custom agents & Parallel | Chạy nhiều agent song song, custom agents .github/agents | [06-custom-agents-parallel.md](./06-custom-agents-parallel.md) |
| 07 | Policies & Guardrails tự động hóa | Instruction enforcement, pre-commit, branch protection | [07-policies-guardrails-tu-dong-hoa.md](./07-policies-guardrails-tu-dong-hoa.md) |
| 08 | MCP — kết nối công cụ ngoài | Mở rộng Copilot bằng MCP servers (.vscode/mcp.json) | [08-mcp-ket-noi-cong-cu-ngoai.md](./08-mcp-ket-noi-cong-cu-ngoai.md) |
| 09 | Extensions & Marketplaces | Cài, chia sẻ và quản lý Copilot Extensions | [09-extensions-marketplaces.md](./09-extensions-marketplaces.md) |
| 10 | Modes, Permissions, Availability | Ask/Edit/Agent, tool approval, content exclusion | [10-modes-permissions-availability.md](./10-modes-permissions-availability.md) |
| 11 | Git worktrees & Checkpoints | Làm việc song song, checkpoints/undo an toàn | [11-git-worktrees-checkpoints.md](./11-git-worktrees-checkpoints.md) |
| 12 | Copilot SDK, CI/CD, Automation | Tự động hóa bằng SDK, gh copilot CLI, Actions | [12-copilot-sdk-ci-cd-automation.md](./12-copilot-sdk-ci-cd-automation.md) |
| 13 | Code intelligence, Indexing, Telemetry | @workspace index, knowledge bases, audit logs | [13-code-intelligence-indexing-telemetry.md](./13-code-intelligence-indexing-telemetry.md) |
| 14 | Models: chọn model đúng | GPT/Claude/Gemini: premium requests, khi nào dùng | [14-models-chon-model-dung.md](./14-models-chon-model-dung.md) |
| 15 | Security stack 5 tầng | Defense-in-depth cho Copilot: exclusion → audit | [15-security-stack-5-tang.md](./15-security-stack-5-tang.md) |
| 16 | Extensions/MCP: bảo mật & validate | Validate extension/MCP trước khi cài | [16-extensions-mcp-bao-mat-validate.md](./16-extensions-mcp-bao-mat-validate.md) |

## Tra cứu lệnh chi tiết (`commands/`)

- Tổng số: **46** thư mục lệnh (`find 01-huong-dan-su-dung/commands -mindepth 2 -type d | wc -l`).
- Index đầy đủ theo 4 nhóm: [commands/README.md](./commands/README.md)
- Ví dụ tra cứu nhanh: [commands/chat-session/new-chat/README.md](./commands/chat-session/new-chat/README.md)
  (thay `new-chat` bằng slug bất kỳ, vd `./commands/model-agent/agent-mode/README.md`, `./commands/system-knowledge/instructions/README.md`).
