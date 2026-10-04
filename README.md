# Khóa Học Muse — Từ Zero tới Pro (2026)

> Bộ tài liệu tiếng Việt đầy đủ, chi tiết, deep-dive về **Muse (2026)** — verified với docs chính thức `docs.github.com/copilot` và `code.visualstudio.com/docs/copilot`.
> Tác giả tổng hợp từ: GitHub Docs, VS Code Copilot docs, best-practices, custom instructions/agents/prompts/skills/MCP guides, và kinh nghiệm thực chiến.

## Đối tượng

- Dev mới nghe tên Copilot, muốn setup và dùng đúng ngay từ đầu.
- Dev đã dùng, muốn lên pro: Chat + Agent mode + Coding Agent + Copilot CLI + SDK + code review.
- Tech lead muốn chuẩn hóa workflow cho cả team.

## Cấu trúc khóa học (mỗi phần = 1 folder)

| Folder | Nội dung | Số bài |
|---|---|---|
| [`01-huong-dan-su-dung/`](./01-huong-dan-su-dung/) | **Hướng dẫn sử dụng**: inline completions, Chat, Ask/Edit/Agent mode, custom agent, instructions/prompts/skills, MCP, Copilot CLI, SDK, coding agent, code review | 17 bài + commands/ (46 lệnh) |
| [`02-tips-thuc-chien/`](./02-tips-thuc-chien/) | **Tips thực chiến**: context hygiene, prompt engineering, plan-first, verification, parallel tasks, instructions design, tiết kiệm premium requests, teamwork | 11 bài deep-dive |
| [`03-cau-hoi-thuong-gap/`](./03-cau-hoi-thuong-gap/) | **Q&A thường gặp**: tài khoản & pricing, model & context, permissions, MCP, instructions, custom agent, lỗi & troubleshooting, bảo mật | 10 bài deep-dive |
| [`templates/`](./templates/) | Template copy-paste: `.github/muse-instructions.md`, `instructions/`, `prompts/`, `agents/`, `skills/`, `.vscode/mcp.json`, workflows | templates copy-paste: instructions, prompts, agents, skills, mcp.json, copilot-review + ci-triage |
| [`CHEATSHEET.md`](./CHEATSHEET.md) | Bảng tra nhanh lệnh, phím tắt, Chat participants/slashes, modes, MCP | 1 trang |

## Lộ trình học đề xuất

```
Ngày 1: 01 bài 00 → 04 (tổng quan, cài đặt, inline completions, Chat cơ bản)
Ngày 2: 01 bài 05 → 09 (Ask/Edit/Agent mode, custom agent, instructions/prompts)
Ngày 3: 01 bài 10 → 16 (skills, MCP, CLI, SDK, coding agent, code review, CI)
Ngày 4: 02 tips 01 → 05 (context, prompt, plan, verify, parallel)
Ngày 5: 02 tips 06 → 10 + 03 FAQ tra cứu khi gặp lỗi
```

Tra cứu lệnh: 01-huong-dan-su-dung/commands/<nhóm>/<tên-lệnh>/ (vd commands/code-actions/fix/)

Quy tắc vàng (nhớ 4 câu này là đủ 80% sức mạnh):

1. **Context là bottleneck, không phải model** — giữ instructions gọn (xem `02-tips-thuc-chien/01`).
2. **Ask → Edit → Agent → Coding Agent leo thang** — không bao giờ giao task lớn cho Agent ngay.
3. **instructions là gợi ý, policy/MCP-allowlist là luật** — rule nào hay bị quên thì đưa vào policy.
4. **Việc ồn ào đẩy sang custom agent/sub-task** — Chat chính chỉ giữ quyết định.

## Phiên bản & nguồn

- Muse **(2026)**. Lệnh `gh copilot --version` / `gh extension list` để kiểm tra version.
- Docs gốc: https://docs.github.com/copilot — VS Code Copilot: https://code.visualstudio.com/docs/copilot
- Chú ý: model picker GPT-5/Claude/Gemini/o-series, premium requests, coding agent gán issue.

## Cách dùng repo này

- Đọc theo thứ tự file `00-*` → `NN-*` trong mỗi folder (đã đánh số).
- Mọi code block đều copy-paste được. Template trong `templates/` dùng được ngay.
- Gõ `/` trong Copilot Chat để xem slash commands khả dụng, `@` để xem participants ở môi trường của bạn.
