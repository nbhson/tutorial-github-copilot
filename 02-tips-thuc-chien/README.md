# 02 — Tips thực chiến (11 bài, đọc khi đã dùng được cơ bản)

> **Dành cho:** dev đã dùng Copilot cơ bản (chat + edit) và muốn lên trình. · **Vấn đề:** dùng được nhưng chậm, tốn credit, output không đồng nhất, team mỗi người một kiểu. · **Đọc xong:** áp được 11 thói quen thực chiến — chat sạch, prompt đủ 4 mảnh, plan-first, verify bằng log, chạy song song, dựng guardrails và tiết kiệm chi phí. · **Thời gian:** mỗi bài ~15 phút, đọc theo thứ tự đề xuất dưới đây.

| # | Bài | Mô tả 1 dòng | Link |
|---|-----|--------------|------|
| 01 | Context hygiene | Giữ chat sạch để Copilot không "loạn" | [01-context-hygiene.md](./01-context-hygiene.md) |
| 02 | Prompt engineering | Viết prompt rõ, cụ thể, kiểm chứng được | [02-prompt-engineering.md](./02-prompt-engineering.md) |
| 03 | Plan-first workflow | Ask → Edit → Agent leo thang, duyệt plan trước khi code | [03-plan-first-workflow.md](./03-plan-first-workflow.md) |
| 04 | Verification ("done that") | Định nghĩa xong-việc và kiểm chứng sau mỗi bước | [04-verification-done-that.md](./04-verification-done-that.md) |
| 05 | Parallel agents | Multi-chat, Coding Agent sessions, worktrees song song | [05-parallel-agents.md](./05-parallel-agents.md) |
| 06 | Policies & guardrails recipes | Recipes instructions, pre-commit, branch protection, MCP approval | [06-policies-guardrails-recipes.md](./06-policies-guardrails-recipes.md) |
| 07 | Thiết kế prompts & skills | Prompt files, instructions, skills tái dùng | [07-thiet-ke-prompts-skills.md](./07-thiet-ke-prompts-skills.md) |
| 08 | Tiết kiệm AI Credits (premium requests) | Model routing, completions vs agent, prune MCP | [08-tiet-kiem-premium-requests.md](./08-tiet-kiem-premium-requests.md) |
| 09 | Teamwork chuẩn hóa | Chuẩn hóa cách cả team dùng Copilot | [09-teamwork-chuan-hoa.md](./09-teamwork-chuan-hoa.md) |
| 10 | Debugging power moves | /fix, test loop, bisect, log→prompt, @terminal | [10-debugging-power-moves.md](./10-debugging-power-moves.md) |
| 11 | Nâng cao: CLI, Web & Coding Agent | CLI, github.com chat, coding agent, mobile/voice | [11-nang-cao-cli-web-coding-agent.md](./11-nang-cao-cli-web-coding-agent.md) |

## Thứ tự đọc đề xuất

Section này trả lời câu hỏi: nên đọc bài nào trước, bài nào sau, và vì sao. Bám đúng 4 nhóm dưới đây là đủ.

1. **Nền tảng (đọc trước):** 02 → 01 → 03 — viết prompt tốt, giữ chat sạch, làm việc theo plan.
2. **Chất lượng:** 04 → 10 — định nghĩa "xong", rồi học chiêu debug.
3. **Mở rộng:** 05 → 06 → 07 — parallel agents, guardrails, prompts/skills.
4. **Tối ưu & team:** 08 → 09 → 11 — tiết kiệm credit, chuẩn hóa team, nâng cao CLI/Web.
