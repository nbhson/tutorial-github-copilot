# Khóa Học GitHub Copilot — Từ Zero tới Pro (2026)

> Bộ tài liệu tiếng Việt full "deep-dive" về **GitHub Copilot (2026)**, verify với docs gốc `docs.github.com/copilot` và `code.visualstudio.com/docs/copilot`.
> Nguồn tổng hợp: GitHub Docs, VS Code Copilot docs, best-practices, guide về custom instructions/agents/prompts/skills/MCP + kinh nghiệm thực chiến.

## Cho ai đọc?

- Dev mới nghe tên Copilot, muốn setup và dùng đúng ngay từ đầu (đừng đoán mò).
- Dev đã dùng, muốn lên pro: Chat + Agent mode + Coding Agent + Copilot CLI + SDK + code review.
- Tech lead muốn chuẩn hóa workflow cho cả team (một cách dùng chung, không mỗi người một kiểu).

## Cấu trúc khóa học (mỗi phần = 1 folder)

| Folder | Nội dung (nói thẳng) | Số bài |
|---|---|---|
| [`01-huong-dan-su-dung/`](./01-huong-dan-su-dung/) | **Hướng dẫn sử dụng**: inline completions, Chat, Ask/Edit/Agent mode, Session Target (Local/Copilot/Cloud), custom agent, instructions/prompts/skills, MCP, Copilot CLI, SDK, coding agent, code review, Agent Customizations hub | 18 bài + commands/ (47 lệnh) |
| [`02-tips-thuc-chien/`](./02-tips-thuc-chien/) | **Tips thực chiến**: context hygiene, prompt engineering, plan-first, verification, parallel tasks, instructions design, tiết kiệm AI Credits, teamwork | 11 bài deep-dive |
| [`03-cau-hoi-thuong-gap/`](./03-cau-hoi-thuong-gap/) | **Q&A thường gặp**: tài khoản & pricing, model & context, permissions, MCP, instructions, custom agent, lỗi & troubleshooting, bảo mật | 10 bài deep-dive |
| [`templates/`](./templates/) | Template copy-paste: `.github/copilot-instructions.md`, `instructions/`, `prompts/`, `agents/`, `skills/`, `.vscode/mcp.json`, workflows | templates copy-paste: instructions, prompts, agents, skills, mcp.json, copilot-review + ci-triage |
| [`CHEATSHEET.md`](./CHEATSHEET.md) | Bảng tra nhanh lệnh, phím tắt, Chat participants/slashes, modes, MCP | 1 trang |

## Lộ trình học đề xuất (5 ngày đủ hết)

```
Ngày 1: 01 bài 00 → 04 (tổng quan, cài đặt, inline completions, Chat cơ bản)
Ngày 2: 01 bài 05 → 09 (Ask/Edit/Agent mode, custom agent, instructions/prompts)
Ngày 3: 01 bài 10 → 16 (skills, MCP, CLI, SDK, coding agent, code review, CI)
Ngày 4: 02 tips 01 → 05 (context, prompt, plan, verify, parallel)
Ngày 5: 02 tips 06 → 10 + 03 FAQ tra cứu khi gặp lỗi
```

Tra cứu lệnh nhanh: `01-huong-dan-su-dung/commands/<nhóm>/<tên-lệnh>/` (vd `commands/code-actions/fix/`).

Quy tắc vàng (nhớ 4 câu này là đủ 80% sức mạnh):

1. **Context là bottleneck, không phải model** — giữ instructions gọn (xem `02-tips-thuc-chien/01`).
2. **Ask → Edit → Agent → Coding Agent leo thang** — không bao giờ giao task lớn cho Agent ngay.
3. **instructions là gợi ý, policy/MCP-allowlist là luật** — rule nào hay bị quên thì đưa vào policy.
4. **Việc ồn ào đẩy sang custom agent/sub-task** — Chat chính chỉ giữ quyết định.

## Phiên bản & nguồn

- GitHub Copilot **(2026)**. Kiểm tra version bằng `gh copilot --version` / `gh extension list`.
- Docs gốc: https://docs.github.com/copilot — VS Code Copilot: https://code.visualstudio.com/docs/copilot
- **Cập nhật sự kiện 2026-10-09** (verify docs + changelog):
  - `.github/copilot-instructions.md` (không còn `muse-instructions.md`).
  - Copilot **có** hooks in-process (`.github/hooks/*.json`, events `PreToolUse`/`PostToolUse`, preview Local — bài 17).
  - Prompt files (`.prompt.md`) **deprecated cho Agent Host** → ưu tiên **Agent Skills** (`SKILL.md`).
  - Billing theo **AI Credits** (1 credit = $0.01; code completion miễn phí; Auto model selection 3 tier, giảm 10% plan trả phí).
  - Model roster mới (GPT-5.x/6.x, Claude Opus/Sonnet 5.x, Gemini 3.x, MAI-Code; deprecate 4 model 02/10/2026).
  - **2 CLI khác nhau**: `gh copilot` (suggest/explain shell) vs `copilot` (agent terminal, 3 chế độ).

## Cách dùng repo này (đọc 3 phút rồi hãy học)

- Đọc theo thứ tự file `00-*` → `NN-*` trong mỗi folder (đã đánh số). Mỗi bài FAQ trong `03-*` đều theo cấu trúc cố định: **Hỏi ngắn gọn → Trả lời 1 câu → Giải thích chi tiết + ví dụ → Làm thế nào (steps copy-paste) → Nếu vẫn lỗi thì...** — bận thì chỉ đọc "Trả lời 1 câu", rảnh thì làm theo steps.
- Mọi code block đều copy-paste được. Template trong `templates/` dùng được ngay (copy `.github/` + `.vscode/` sang repo thật, sửa stack/lệnh/glob cho khớp).
- Gõ `/` trong Copilot Chat để xem slash commands khả dụng, `@` để xem participants ở môi trường của bạn.
- Kẹt ở đâu tra đó: `CHEATSHEET.md` (1 trang, lệnh nào cũng có ví dụ mini) → `01-huong-dan-su-dung/commands/` (47 lệnh, mỗi lệnh 1 folder chi tiết) → `03-cau-hoi-thuong-gap/` (10 bài FAQ, mỗi bài có mermaid + mục "Vẫn lỗi thì sao?").
