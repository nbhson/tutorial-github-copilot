# Changelog — Khóa Học Muse (tiếng Việt)

## [Unreleased]

- Chưa có thay đổi mới sau v1.0.0. Mở PR theo `CONTRIBUTING.md` để bổ sung bài/tips/lệnh.

## [v1.0.0] — 2026-10-05

Bản đầu tiên hoàn chỉnh theo Muse (2026).

- `01-huong-dan-su-dung/`: 17 bài (00–16: tổng quan, cài đặt, inline completions,
  Chat, Ask/Edit/Agent mode, custom agent, instructions/prompts, skills, MCP,
  Copilot CLI, SDK, coding agent, code review, CI) + `commands/` ~70 folders
  (mỗi lệnh 1 `README.md` 8 mục: cú pháp, cơ chế, ví dụ, rủi ro, workflow, lỗi, tham khảo).
- `02-tips-thuc-chien/`: 11 bài (01–11: context hygiene, prompt engineering,
  plan-first, verification, parallel tasks, instructions design,
  tiết kiệm premium requests, teamwork, bảo mật, troubleshooting, nâng cao).
- `03-cau-hoi-thuong-gap/`: 10 bài (01–10: tài khoản/pricing, model/context,
  permissions, MCP, instructions, custom agent, troubleshooting, bảo mật, CLI/SDK, coding agent).
- `templates/`: `.github/muse-instructions.md`, `instructions/` (`*.instructions.md` + `applyTo`),
  `prompts/` (`*.prompt.md`), `agents/` (`*.agent.md`), `skills/` (`.github/skills/`),
  `.vscode/mcp.json` + `.github/workflows/` (copilot-review: review PR tự động;
  ci-triage: phân tích CI failure overnight mở issue).
- Gốc: `README.md` lộ trình 5 ngày, `CHEATSHEET.md` 1 trang, `LICENSE` MIT,
  `CONTRIBUTING.md` quy ước đóng góp.
