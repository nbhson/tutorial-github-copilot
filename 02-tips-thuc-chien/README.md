# 02 — Tips thực chiến (11 bài, đọc khi đã dùng được cơ bản)

> **Dành cho:** dev đã dùng Copilot cơ bản (chat + edit) và muốn lên trình. · **Vấn đề:** dùng được nhưng chậm, tốn credit, output không đồng nhất, team mỗi người một kiểu. · **Đọc xong:** áp được 11 thói quen thực chiến — chat sạch, prompt đủ 4 mảnh, plan-first, verify bằng log, chạy song song, dựng guardrails và tiết kiệm chi phí. · **Thời gian:** mỗi bài ~15 phút, đọc theo thứ tự đề xuất dưới đây.

Nhóm 01 dạy bạn *Copilot có những gì*. Nhóm 02 này dạy *dùng nó sao cho khôn*: 11 thói quen xếp thành 4 chặng — nền tảng (prompt + context), chất lượng (định nghĩa "xong" + debug), mở rộng (song song, guardrails, đóng gói), và tối ưu/team (tiết kiệm, chuẩn hóa, nâng cao). Mỗi bài đứng độc lập, nhưng ghép lại thành một quy trình: prompt rõ → chat sạch → plan trước → verify bằng log → tự động hóa rồi chuẩn hóa cho cả team.

| # | Bài | Mô tả 1 dòng | Link |
|---|-----|--------------|------|
| 01 | Context hygiene | Giữ chat sạch để Copilot không "loạn" | [01-context-hygiene.md](./01-context-hygiene.md) |
| 02 | Prompt engineering | Viết prompt rõ, cụ thể, kiểm chứng được | [02-prompt-engineering.md](./02-prompt-engineering.md) |
| 03 | Plan-first workflow | Ask → Edit → Agent leo thang, duyệt plan trước khi code | [03-plan-first-workflow.md](./03-plan-first-workflow.md) |
| 04 | Verification ("done that") | Định nghĩa xong-việc và kiểm chứng sau mỗi bước | [04-verification-done-that.md](./04-verification-done-that.md) |
| 05 | Parallel agents | Multi-chat, Coding Agent sessions, worktrees song song | [05-parallel-agents.md](./05-parallel-agents.md) |
| 06 | Policies & guardrails recipes | Recipes instructions, pre-commit, branch protection, MCP approval | [06-policies-guardrails-recipes.md](./06-policies-guardrails-recipes.md) |
| 07 | Thiết kế prompts & skills | Prompt files, instructions, skills tái dùng | [07-thiet-ke-prompts-skills.md](./07-thiet-ke-prompts-skills.md) |
| 08 | Tiết kiệm AI Credits (AI Credits) | Model routing, completions vs agent, prune MCP | [08-tiet-kiem-premium-requests.md](./08-tiet-kiem-premium-requests.md) |
| 09 | Teamwork chuẩn hóa | Chuẩn hóa cách cả team dùng Copilot | [09-teamwork-chuan-hoa.md](./09-teamwork-chuan-hoa.md) |
| 10 | Debugging power moves | /fix, test loop, bisect, log→prompt, @terminal | [10-debugging-power-moves.md](./10-debugging-power-moves.md) |
| 11 | Nâng cao: CLI, Web & Coding Agent | CLI, github.com chat, coding agent, mobile/voice | [11-nang-cao-cli-web-coding-agent.md](./11-nang-cao-cli-web-coding-agent.md) |

## Thứ tự đọc đề xuất

Không cần đọc đủ 11 bài mới dùng được. Bám 4 nhóm dưới đây, mỗi nhóm là một cấp độ trưởng thành — nhóm sau dựa trên nhóm trước:

1. **Nền tảng (đọc trước):** 02 → 01 → 03 — viết prompt tốt, giữ chat sạch, làm việc theo plan.
2. **Chất lượng:** 04 → 10 — định nghĩa "xong", rồi học chiêu debug.
3. **Mở rộng:** 05 → 06 → 07 — parallel agents, guardrails, prompts/skills.
4. **Tối ưu & team:** 08 → 09 → 11 — tiết kiệm credit, chuẩn hóa team, nâng cao CLI/Web.

## So sánh với Claude Code

Quen Claude Code thì bạn đã có nền cho gần hết nhóm này — dưới đây là bản đồ nhanh để biết bài nào nói về cái gì:

| Việc | Copilot (nhóm 02) | Claude Code | Ghi chú |
|---|---|---|---|
| Giữ context sạch | New Chat mỗi task + `#file`/`#selection` hẹp | `/clear` + `/compact` | Cùng mục tiêu "đừng nuôi 1 chat dài" — [bài 01](./01-context-hygiene.md) |
| Viết luật cho repo | `.github/copilot-instructions.md` + `skills/` | `CLAUDE.md` + `.claude/` | File trong repo là luật — [bài 06](./06-policies-guardrails-recipes.md), [bài 07](./07-thiet-ke-prompts-skills.md) |
| Làm việc theo plan | Plan mode + prompt files | Plan mode | Cùng tư tưởng duyệt trước khi code — [bài 03](./03-plan-first-workflow.md) |
| Chạy song song | Git worktrees + Coding Agent cloud | Git worktrees + nhiều session | Cùng ý tưởng, khác cách mở phiên — [bài 05](./05-parallel-agents.md) |
| Sửa lỗi nhanh | `/fix` dựng sẵn | Không có `/fix` dựng sẵn — tự tạo slash command | Copilot bấm-là-chạy — [bài 10](./10-debugging-power-moves.md) |
| Tính chi phí | AI Credits (1 credit = 0,01 USD) | Gói subscription theo cửa sổ usage | Cơ chế khác nhau, cùng phải đo — [bài 08](./08-tiet-kiem-premium-requests.md) |
| Code trên cloud | Coding Agent (assign issue) | Session cloud + tích hợp GitHub | Copilot gắn thẳng vào issue/PR — [bài 11](./11-nang-cao-cli-web-coding-agent.md) |

Quay về: [../README.md](../README.md) · Bài tổng: [00 — Tổng quan Copilot](../01-huong-dan-su-dung/00-tong-quan-copilot.md)

> Chốt nhóm 02: 11 bài này không phải 11 mẹo rời rạc mà là một đường leo thang — bắt đầu từ giữ context sạch và viết prompt rõ, rồi mới tới song song hóa và chuẩn hóa cho team. Làm đúng 3 bài đầu (01, 02, 03) là bạn đã tránh được phần lớn credit bị đốt oan.
