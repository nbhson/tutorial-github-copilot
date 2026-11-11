# 01 — Hướng dẫn sử dụng GitHub Copilot (đọc từ 00 → 17)

> **Dành cho:** người mới bắt đầu, và dev đã dùng Copilot nhưng muốn đi lại cho đúng thứ tự.
> **Vấn đề:** 18 bài học + 57 thư mục lệnh — đọc cái nào trước, bài nào liên quan tới việc mình đang làm.
> **Đọc xong:** biết thứ tự đọc 00 → 17, biết ghép bài với lệnh trong `commands/`, và chọn được bài đúng nhu cầu ngay lúc này.
> **Thời gian:** ~5 phút.

Đây là nhóm "học nghề": 18 bài xếp liền mạch từ **tổng quan → cài đặt → bề mặt sử dụng → cấu hình nền tảng → vận hành nâng cao**. Cấu hình nền tảng gồm `copilot-instructions.md` và rules, Agent Skills (chuẩn 2026, thay prompt files vốn chỉ còn chạy ở Local harness), custom agents, MCP, hooks, Agent Plugins. Vận hành nâng cao gồm modes/permissions, worktrees & checkpoints, CLI/SDK/CI, indexing & telemetry, models & AI credits, security, và **Agent Customizations editor** (màn hình quản mọi tuỳ biến — `Chat: Open Customizations`). Đọc tuần tự thì mạch kiến thức liền; đọc nhảy cóc thì tra bảng dưới rồi mở đúng bài.

Cách học nhanh, đỡ khô: đọc trước 4 bài tổng quan (**00–04**), rồi vừa đọc vừa mở `commands/` tra lệnh tương ứng — ví dụ đọc bài 04 thì mở [`commands/copilot/code-actions/fix/`](commands/copilot/code-actions/fix/README.md) xem ví dụ prompt thật. Khoá học mặc định dạy **Copilot harness**; mỗi folder lệnh theo cùng một khuôn: **lệnh làm gì (1 câu nôm na) → khi nào dùng/không dùng → cách gọi → ví dụ thật + verify → ❌ SAI/✅ ĐÚNG → so sánh Claude Code → best practices (kèm "vì sao") → bài tập nhỏ → nguồn docs**.

Muốn nhảy cóc? Bảng dưới mô tả đúng 1 dòng mỗi bài — đọc cột "Mô tả 1 dòng" là đủ để quyết định có mở bài đó không.

## Danh sách bài (18 bài)

| # | Tên bài | Mô tả 1 dòng | Link |
|---|---------|--------------|------|
| 00 | Tổng quan Copilot | 5 chế độ + CLI, harness là gì, 5 Session Target, tiền rơi ở đâu | [00-tong-quan-copilot.md](./00-tong-quan-copilot.md) |
| 01 | Cài đặt & xác thực | Plan (Free/Pro/Pro+/Max…), login, verify sức khoẻ từng surface, walkthrough 5 bước | [01-cai-dat-va-xac-thuc.md](./01-cai-dat-va-xac-thuc.md) |
| 02 | Các bề mặt | VS Code · IDE khác · github.com · Copilot CLI · Copilot cloud agent — chọn Session Target | [02-cac-be-mat-vscode-ide-web-cli.md](./02-cac-be-mat-vscode-ide-web-cli.md) |
| 03 | Instructions, Memory & Rules | `copilot-instructions.md`, rules `applyTo`, `AGENTS.md`, Copilot Memory | [03-instructions-memory-rules.md](./03-instructions-memory-rules.md) |
| 04 | Chat commands toàn tập | Bảng tra slash commands của cả series + công thức 5 lệnh đầu | [04-chat-commands-toan-tap.md](./04-chat-commands-toan-tap.md) |
| 05 | Agent Skills (chuẩn 2026) | Viết `SKILL.md` để agent tự nạp theo `description`; port prompt files legacy | [05-agent-skills-reusable-workflows.md](./05-agent-skills-reusable-workflows.md) |
| 06 | Custom agents & Parallel | `.github/agents/*.agent.md`, tool whitelist, chạy nhiều agent song song | [06-custom-agents-parallel.md](./06-custom-agents-parallel.md) |
| 07 | Policies & Guardrails | Hooks (CLI + cloud, VS Code Preview) + các khoá chạy ngoài model | [07-policies-guardrails-tu-dong-hoa.md](./07-policies-guardrails-tu-dong-hoa.md) |
| 08 | MCP | `.mcp.json` + `~/.copilot/mcp-config.json`, approval, connectors, secrets qua env | [08-mcp-ket-noi-cong-cu-ngoai.md](./08-mcp-ket-noi-cong-cu-ngoai.md) |
| 09 | Extensions & Marketplaces | Ba tầng mở rộng: VS Code extensions, Agent Plugins, connectors — Copilot Extensions đã retired | [09-extensions-marketplaces.md](./09-extensions-marketplaces.md) |
| 10 | Modes, Permissions & Availability | Built-in agents Ask/Plan/Agent (Edit thuộc Local), 3 mức duyệt, sandbox, plan nào mở gì | [10-modes-permissions-availability.md](./10-modes-permissions-availability.md) |
| 11 | Worktrees & Checkpoints | Chạy song song không giẫm chân nhau, quay lui đúng lúc | [11-git-worktrees-checkpoints.md](./11-git-worktrees-checkpoints.md) |
| 12 | CLI, SDK & CI/CD | Copilot CLI (binary `copilot`), SDK TypeScript, agent làm ca đêm | [12-copilot-sdk-ci-cd-automation.md](./12-copilot-sdk-ci-cd-automation.md) |
| 13 | Code Intelligence | Indexing ≠ context window ≠ code search; telemetry cho admin | [13-code-intelligence-indexing-telemetry.md](./13-code-intelligence-indexing-telemetry.md) |
| 14 | Models — chọn model đúng | Bảng theo task, AI credits (1 credit = $0,01), BYOK, deprecation | [14-models-chon-model-dung.md](./14-models-chon-model-dung.md) |
| 15 | Security stack 5 tầng | Content exclusion → push protection → code review → branch protection → audit | [15-security-stack-5-tang.md](./15-security-stack-5-tang.md) |
| 16 | Bảo mật Extensions & MCP | Schema plugin `com.github.copilot/`, pin SHA, org policy | [16-extensions-mcp-bao-mat-validate.md](./16-extensions-mcp-bao-mat-validate.md) |
| 17 | Agent Customizations editor | Mọi tuỳ biến agent trên một màn hình: Plugins/Skills/Instructions/Agents/Hooks/Tools + Voice | [17-agent-customizations-hub.md](./17-agent-customizations-hub.md) |

> **Cách đọc bảng này:** các bài xếp theo mạch leo thang 00 → 17; mỗi dòng chỉ cần đọc cột "Mô tả 1 dòng" để quyết định có mở bài đó không. Tên file giữ nguyên từ bản cũ (kể cả bài 17 mang tên `…-hub.md`) để link ngoại không gãy.

## Tra cứu lệnh chi tiết (`commands/`)

Phần này dùng để tra nhanh khi đang làm việc — không cần đọc từ đầu.

- Tổng số: **57** thư mục lệnh, chia theo harness: `copilot/` 43 · `local/` 8 · `cloud/` 6 (đường dẫn chuẩn: `commands/<harness>/<nhóm>/<slug>/README.md`; nguồn sự thật: [`commands/bucket.tsv`](commands/bucket.tsv)).
- Index đầy đủ theo 4 nhóm lệnh: [commands/README.md](./commands/README.md)
- Ví dụ tra cứu nhanh: [commands/copilot/chat-session/clear/README.md](commands/copilot/chat-session/clear/README.md)
  (thay `clear` bằng slug bất kỳ, vd `commands/copilot/model-agent/agent-mode/README.md`, `commands/local/system-knowledge/prompt-file/README.md`).
- Mẫu copy-paste cấp bài học: [`examples/`](examples/) — file nào mang tên bài nào, đọc từ đầu bài đó.

## So sánh với Claude Code

Nếu bạn đã quen Claude Code, phần lớn khái niệm chuyển sang gần như 1-1 — chỉ khác *tên file* và *nơi chạy*:

| Việc | Copilot (nhóm này) | Claude Code | Ghi chú |
|---|---|---|---|
| Cấu hình trong repo | `.github/copilot-instructions.md` + `AGENTS.md` | `CLAUDE.md` + `.claude/` | Cùng tư tưởng "file trong repo là luật" — [bài 03](./03-instructions-memory-rules.md) |
| Lệnh tự tạo, tái sử dụng | Agent Skills (`SKILL.md`) | `.claude/commands/` + Skills | Bài 05 là chủ — prompt files legacy chỉ còn ở Local harness |
| Nối hệ thống ngoài | MCP: `.mcp.json` (root) + `~/.copilot/mcp-config.json` | MCP (`.mcp.json`) | Cùng chuẩn — [bài 08](./08-mcp-ket-noi-cong-cu-ngoai.md) |
| Chế độ chạy | Built-in agents Ask/Plan/Agent + 5 Session Target | Mặc định agentic, terminal-first | [bài 00](./00-tong-quan-copilot.md), [bài 10](./10-modes-permissions-availability.md) |
| Custom agents | `.github/agents/<ten>.agent.md` | `.claude/agents/` | Cùng ý tưởng persona + tool giới hạn — [bài 06](./06-custom-agents-parallel.md) |
| Màn hình quản tuỳ biến | Agent Customizations editor (`Chat: Open Customizations`) | Không có màn hình tương đương | [bài 17](./17-agent-customizations-hub.md) |

> **Đọc bảng này thế nào:** quen Claude Code thì bạn đã có nền; cái cần học thêm là *tên file* của Copilot và khái niệm **harness / Session Target** — thứ Claude Code không có tương đương trực tiếp.

> **Tóm gọn 1 câu:** 18 bài là một đường leo thang — mỗi bậc thêm một tầng tự chủ cho Copilot, từ gợi ý chữ tới agent tự giao task.

Quay về: [../README.md](../README.md) · Bài tổng: [00 — Tổng quan Copilot](./00-tong-quan-copilot.md)

> Chốt nhóm 01: đừng đọc 18 bài như 18 thứ rời — chúng là một đường leo thang. Đọc 00–04 lấy nền, rồi mỗi khi làm việc thật thì mở `commands/` tra đúng lệnh cho việc đó.
