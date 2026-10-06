# Changelog — Khóa Học Muse (tiếng Việt)

## [Unreleased] — đợt biên tập tài liệu (2026-10-06)

- `03-cau-hoi-thuong-gap/` (01–10 + README): chuẩn hóa mỗi câu hỏi theo cấu trúc **Hỏi ngắn gọn → Trả lời 1 câu → Giải thích chi tiết + ví dụ → Làm thế nào (steps copy-paste) → Nếu vẫn lỗi thì...**; thêm mermaid tư duy nhanh cho cả 10 bài; bài `04-mcp-faq.md` bổ sung mục 0 đồng bộ **Tools / Resources / Prompts** với bài 08 (ví dụ `github.create_pr`, `github://repos/.../issues/123`, template review-pr/triage-issue).
- `CHEATSHEET.md`: giữ 1 trang nhưng mỗi lệnh giờ có **ví dụ mini copy-paste** bên cạnh (CLI, Chat, modes, instructions/prompts/skills/MCP, coding agent + review).
- `01-huong-dan-su-dung/commands/` (~46 lệnh + index): chuẩn hóa mỗi `README.md` theo format **Tên lệnh → Lệnh làm gì (1 câu nôm na) → Khi nào dùng → Cách gọi → Ví dụ prompt thật + kết quả mong đợi → Lỗi thường gặp**; thay nội dung mẫu lặp lại bằng ví dụ riêng từng lệnh (tối thiểu 30–50 dòng/file).
- `README.md`, `01-huong-dan-su-dung/README.md`, `02-tips-thuc-chien/README.md`, `templates/README.md`, `commands/README.md`, `03-cau-hoi-thuong-gap/README.md`, `CONTRIBUTING.md`: viết lại/diễn giải rõ hơn cách tra cứu, cấu trúc FAQ mới và quy ước format lệnh.

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
