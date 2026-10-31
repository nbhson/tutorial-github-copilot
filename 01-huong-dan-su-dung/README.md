# 01 — Hướng dẫn sử dụng GitHub Copilot (đọc từ 00 → 17)

> **Dành cho:** người mới bắt đầu, và dev đã dùng Copilot nhưng muốn đi lại cho đúng thứ tự.
> **Vấn đề:** 18 bài học + 47 thư mục lệnh — đọc cái nào trước, bài nào liên quan tới việc mình đang làm.
> **Đọc xong:** biết thứ tự đọc 00 → 17, biết ghép bài đọc với lệnh trong `commands/`, và chọn được bài đúng nhu cầu ngay lúc này.
> **Thời gian:** ~5 phút.

Đây là nhóm "học nghề": 18 bài xếp liền mạch từ **tổng quan → cài đặt → bề mặt sử dụng → cấu hình nền tảng → vận hành nâng cao**. Cấu hình nền tảng gồm `copilot-instructions.md`, chat commands, Agent Skills (chuẩn 2026, thay prompt files), custom agents, instructions, rules, MCP, Agent Plugins và policies. Vận hành nâng cao gồm agent mode, code review, testing, models, security, best practices team và Agent Customizations hub. Đọc tuần tự thì mạch kiến thức liền; đọc nhảy cóc thì tra bảng dưới rồi mở đúng bài.

Cách học nhanh, đỡ khô: đọc trước 4 bài tổng quan (**00–04**), rồi vừa đọc vừa mở `commands/` tra lệnh tương ứng — ví dụ đọc bài 04 thì mở [`commands/code-actions/fix/`](./commands/code-actions/fix/README.md) xem ví dụ prompt thật. Mỗi folder lệnh trong `commands/` đi theo cùng một khuôn: **lệnh làm gì (1 câu nôm na) → khi nào dùng/khi nào đừng → cách gọi → ví dụ thật + kết quả mong đợi → lỗi thường gặp → so sánh Claude Code → best practices (kèm "vì sao") → bài tập nhỏ**.

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

- Tổng số: **47** thư mục lệnh (`find 01-huong-dan-su-dung/commands -mindepth 3 -name README.md | wc -l`).
- Index đầy đủ theo 4 nhóm: [commands/README.md](./commands/README.md)
- Ví dụ tra cứu nhanh: [commands/chat-session/new-chat/README.md](./commands/chat-session/new-chat/README.md)
  (thay `new-chat` bằng slug bất kỳ, vd `./commands/model-agent/agent-mode/README.md`, `./commands/system-knowledge/instructions/README.md`).

## So sánh với Claude Code

Nếu bạn đã quen Claude Code, phần lớn khái niệm trong nhóm này chuyển sang gần như 1-1 — chỉ khác *tên file* và *nơi chạy*. Bảng này là bản đồ nhanh để biết đọc bài nào:

| Việc | Copilot (nhóm này) | Claude Code | Ghi chú |
|---|---|---|---|
| Cấu hình trong repo | `.github/copilot-instructions.md` + `AGENTS.md` | `CLAUDE.md` + `.claude/` | Cùng tư tưởng "file trong repo là luật" — [bài 03](./03-instructions-memory-rules.md) |
| Slash command tự tạo | Agent Skills / prompt files | `.claude/commands/` | Tương đương về ý tưởng — [bài 05](./05-prompt-files-custom-instructions.md) |
| Nối hệ thống ngoài | MCP (`.vscode/mcp.json`, `.mcp.json`) | MCP (`.mcp.json`) | Cùng chuẩn giao thức — [bài 08](./08-mcp-ket-noi-cong-cu-ngoai.md) |
| Agent mode | Ask/Edit/Agent + Session Target (Local/Copilot/Cloud) | Mặc định agentic, terminal-first | Copilot leo thang từng bước — [bài 00](./00-tong-quan-copilot.md), [bài 10](./10-modes-permissions-availability.md) |
| Custom agents | `.github/agents/<ten>.agent.md` | Subagents trong `.claude/agents/` | Cùng ý tưởng persona + tool giới hạn — [bài 06](./06-custom-agents-parallel.md) |
| Hub quản trị tuỳ biến | Agent Customizations Hub (`Chat: Open Customizations`) | Không có màn hình hub tương đương | Copilot gom vào 1 chỗ, có profile `sandbox` — [bài 17](./17-agent-customizations-hub.md) |

> **Đọc bảng này thế nào:** quen Claude Code thì bạn đã có nền cho gần hết nhóm này; cái cần học thêm là *tên file* của Copilot và khái niệm **Session Target** (Local/Copilot/Cloud) — thứ Claude Code không có tương đương trực tiếp.

Quay về: [../README.md](../README.md) · Bài tổng: [00 — Tổng quan Copilot](./00-tong-quan-copilot.md)

> Chốt nhóm 01: đừng đọc 18 bài như 18 thứ rời — chúng là một đường leo thang từ autocomplete tới agent. Đọc 00–04 lấy nền, rồi mỗi khi làm việc thật thì mở `commands/` tra đúng lệnh cho việc đó.
