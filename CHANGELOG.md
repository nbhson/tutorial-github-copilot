# Changelog — Khóa Học GitHub Copilot (tiếng Việt)

## [Unreleased] — CẬP NHẬT SỰ KIỆN 2026-10-09 (rename `muse-instructions.md` → `copilot-instructions.md`, hooks in-process, prompt files deprecated)

- **Sửa naming (toàn repo):** đổi tên file template `templates/.github/muse-instructions.md` → `templates/.github/copilot-instructions.md`; thay toàn bộ ~100 tham chiếu `muse-instructions.md` bằng `copilot-instructions.md` (khớp filename `.github/copilot-instructions.md` chính thức trong docs GitHub 2026).
- **Hooks in-process (sự thật mới):** Copilot 2026 **có** hooks in-process (`.github/hooks/*.json`, events `PreToolUse`/`PostToolUse`/`SessionStart`/`SubagentStart`/`PreCompact`/`Stop`/`UserPromptSubmit`) — chế độ **preview, chỉ Local, tôn trọng allow/ask/deny, không phải security boundary**. Sửa lại claim "Copilot không có hooks" trong:
  - `01-huong-dan-su-dung/07-policies-guardrails-tu-dong-hoa.md` (tiêu đề + mục 1 + bảng hiểu nhầm + lớp 4).
  - `01-huong-dan-su-dung/10-modes-permissions-availability.md` (hàng "Copilot có PreToolUse hooks như Claude" + so sánh Claude Code).
  - `03-cau-hoi-thuong-gap/05-policies-guardrails-faq.md` (intro + câu pre-commit).
  - Chi tiết hooks chính thức: `01-huong-dan-su-dung/17-agent-customizations-hub.md` (mục Hooks + `/create-hook`).
- **Prompt files deprecated (ghi chú mới):** `.prompt.md` **deprecated cho Agent Host sessions** (Copilot/Cloud) — vẫn chạy được trên Local/VS Code. Khuyến nghị mới: **Agent Skills** (`SKILL.md`, chuẩn mở, port mọi nơi). Ghi chú bổ sung vào:
  - `01-huong-dan-su-dung/05-prompt-files-custom-instructions.md` — **viết lại skill-first** (tiêu đề "Agent Skills & Custom Instructions — Chuẩn 2026", mục 1–11 hướng skill, recipe port prompt→skill mục 3.3, Agent Plugins thay Extensions).
  - `01-huong-dan-su-dung/README.md` (dòng bài 05 + lead-in), `04-chat-commands-toan-tap.md` (`/prompts` legacy), `commands/README.md` + `commands/system-knowledge/{README,prompt-file/README}.md` (legacy note).
  - `01-huong-dan-su-dung/06-custom-agents-parallel.md` (bảng + link chéo bài 05).
  - `03-cau-hoi-thuong-gap/06-prompts-agents-instructions.md` (bảng tổng hợp + câu 4/6/8 ghi deprecated/legacy, skill = khuyến nghị).
  - `02-tips-thuc-chien/07-thiet-ke-prompts-skills.md` (banner lưu ý, bảng thuật ngữ, mục 3 legacy, walkthrough + bảng tra nhanh hướng skill).
  - `02-tips-thuc-chien/08-tiet-kiem-premium-requests.md` (ví dụ team-bug → skill 2026).
  - `02-tips-thuc-chien/09-teamwork-chuan-hoa.md` (bảng + ví dụ 2 ghi Agent Skills 2026 + prompt legacy).
  - `CHEATSHEET.md` (dòng `*.prompt.md` deprecated), `templates/README.md` (3 prompt files đánh dấu Legacy + skill khuyến nghị).
- **AI Credits + pricing (verify 2026-10-09 với docs.github.com/copilot/billing):**
  - 1 credit = $0.01; code completions + next edit suggestions không tính.
  - Pro $10/1.500 credits · Pro+ $39/7.000 · Max $100/20.000 · Business $19/seat/1.900 · Enterprise $39/seat/3.900 (pooled).
  - Paid usage policy MẶC ĐỊNH BẬT (admin muốn cap chi phí phải tắt).
  - Auto model selection: 3 tier (Efficiency/Balance/Intelligence) ra mắt 14/09/2026; plan trả phí giảm 10% khi dùng Auto.
  - Free/Student: chỉ dùng Auto (không có model picker tay).
- **Model roster (verify 2026-10-09 với model picker + changelog):**
  - OpenAI: GPT-5 mini, GPT-5.3-Codex, GPT-5.4 (+mini/nano), GPT-5.5, GPT-5.6 Luna/Sol/Terra, GPT-6 Astra (GA 04/09/2026), GPT-6 Luna, GPT-6 Sol, GPT-6.1 Sol (GA 29/09/2026).
  - Anthropic: Claude Fable 5/5.1, Haiku 4.5, Opus 4.5/4.6/4.7/4.8 (fast mode preview)/5/5.5, Sonnet 4.5/4.6/5/5.5.
  - Google: Gemini 3.1 Pro (preview), 3.5/3.6/3.7/3.8 Flash.
  - Microsoft: MAI-Code-1-Flash, MAI-Code-1.1-Flash, Raptor mini.
  - Khác: Kimi K2.7 Code, Kimi K3, Grok 4.5, Grok 4.6 (4.7 — verify).
  - Deprecated **02/10/2026**: Gemini 3.5/3.6 Flash → 3.8 Flash; Kimi K2.7 Code → K3; Claude Opus 4.7 → 5.5.
- **Copilot CLI (2 CLI khác nhau — phân biệt rõ):**
  - `gh copilot` (gh extension): `suggest`/`explain` lệnh shell (bài 01, tips 11).
  - `copilot` (Copilot CLI binary): agent trong terminal, 3 chế độ Interactive/Plan/Autopilot (`--plan`, `--mode autopilot`, `Shift+Tab`), `/permissions`, `/sandbox`, `--max-ai-credits` (bài 10 mục 3.2/5.3/5.4, tips 11 mục 3).
  - Ghi chú bổ sung vào: `02-tips-thuc-chien/11-nang-cao-cli-web-coding-agent.md` (mục 3), `01-huong-dan-su-dung/12-copilot-sdk-ci-cd-automation.md` (mục 5.1).
- **CHEATSHEET.md:** thêm bảng "AI Credits (tính tiền)", "Model roster (10/2026)", "Hooks in-process (preview, Local)".

## [Unreleased] — Bài 17 Agent Customizations Hub (2026-10-09)

- `01-huong-dan-su-dung/17-agent-customizations-hub.md` (**mới**, bài 17): hub cho màn hình Agent Customizations — `Customize Your Agent` (draft qua `/init`, `/create-*`), bảng quyết định cần-gì→dùng-gì, 7 cards Explore chi tiết (Plugins Agent Plugins 1.0 + governance / MCP Servers / Skills SKILL.md / Instructions theo harness / Agents `.agent.md` / Hooks Local-vs-Copilot / Tools + tool sets + 128-limit), 2 cards Other (`voice.md`, `dictation.md`), Discover/Marketplace, migrations (prompt→skills), evaluations/Waza, walkthrough 20 phút + troubleshooting matrix.
- `01-huong-dan-su-dung/README.md`: 17 → **18 bài**, thêm dòng bài 17, sửa tiêu đề 00 → 17. `README.md` gốc: 17 → 18 bài.
- `CHEATSHEET.md`: thêm dòng Agent Customizations hub vào bảng instructions/prompts/skills/MCP.

## [Unreleased] — UI agent persona, permission levels + Session Target/harness (2026-10-09)

- `01-huong-dan-su-dung/10-modes-permissions-availability.md`: thêm mục **3.2 Agent personas (Interactive / Plan / Autopilot)**, **3.3 Session Target / harness (Local / Copilot / Cloud / Claude / Codex + Agent Host + handoff)**, **5.3 Permissions UI (Manual / Assisted / Allow all)**, **5.4 Sandboxing for terminal + Configure auto-accept countdown**; bổ sung 6 dòng vào bảng thuật ngữ 1.1; ghi CLI parity (`Shift+Tab`, `--mode`, `/permissions`, `/sandbox`, `--max-ai-credits`, `/delegate`).
- `03-cau-hoi-thuong-gap/03-modes-permissions.md`: thêm **câu 11** (ánh xạ UI mới ↔ Ask/Edit/Agent + `allow/ask/deny`) và **câu 12** (Session Target/harness); ghi chú dưới bảng chọn mode; cập nhật số câu 10 → 12.
- `01-huong-dan-su-dung/commands/model-agent/session-target/README.md` (mới): lệnh **Session Target** theo format 6 phần; khác biệt Local/Copilot/Cloud, handoff, `/delegate`.
- `01-huong-dan-su-dung/commands/model-agent/agent-mode/README.md`: ghi chú 3 persona trong Agent mode.
- `01-huong-dan-su-dung/02-cac-be-mat-vscode-ide-web-cli.md`: thêm mục **2.5 Session Target** + bullet trong "vì sao VS Code mạnh nhất".
- `01-huong-dan-su-dung/00-tong-quan-copilot.md`: ghi chú harness giờ **chọn được** qua Session Target.
- Cập nhật đếm lệnh 46 → **47** (nhóm Model & Agent 9 → 10): `commands/README.md`, `commands/model-agent/README.md`, `04-chat-commands-toan-tap.md` (TOC + bảng), `README.md`, `CHEATSHEET.md`.
- `CHEATSHEET.md`: thêm `Plan`, `Autopilot`, `Permissions picker`, `Session Target` vào bảng Modes.

## [Unreleased] — đợt biên tập tài liệu (2026-10-06)

- `03-cau-hoi-thuong-gap/` (01–10 + README): chuẩn hóa mỗi câu hỏi theo cấu trúc **Hỏi ngắn gọn → Trả lời 1 câu → Giải thích chi tiết + ví dụ → Làm thế nào (steps copy-paste) → Nếu vẫn lỗi thì...**; thêm mermaid tư duy nhanh cho cả 10 bài; bài `04-mcp-faq.md` bổ sung mục 0 đồng bộ **Tools / Resources / Prompts** với bài 08 (ví dụ `github.create_pr`, `github://repos/.../issues/123`, template review-pr/triage-issue).
- `CHEATSHEET.md`: giữ 1 trang nhưng mỗi lệnh giờ có **ví dụ mini copy-paste** bên cạnh (CLI, Chat, modes, instructions/prompts/skills/MCP, coding agent + review).
- `01-huong-dan-su-dung/commands/` (~46 lệnh + index): chuẩn hóa mỗi `README.md` theo format **Tên lệnh → Lệnh làm gì (1 câu nôm na) → Khi nào dùng → Cách gọi → Ví dụ prompt thật + kết quả mong đợi → Lỗi thường gặp**; thay nội dung mẫu lặp lại bằng ví dụ riêng từng lệnh (tối thiểu 30–50 dòng/file).
- `README.md`, `01-huong-dan-su-dung/README.md`, `02-tips-thuc-chien/README.md`, `templates/README.md`, `commands/README.md`, `03-cau-hoi-thuong-gap/README.md`, `CONTRIBUTING.md`: viết lại/diễn giải rõ hơn cách tra cứu, cấu trúc FAQ mới và quy ước format lệnh.

## [v1.0.0] — 2026-10-05

Bản đầu tiên hoàn chỉnh theo GitHub Copilot (2026).

- `01-huong-dan-su-dung/`: 17 bài (00–16: tổng quan, cài đặt, inline completions,
  Chat, Ask/Edit/Agent mode, custom agent, instructions/prompts, skills, MCP,
  Copilot CLI, SDK, coding agent, code review, CI) + `commands/` ~70 folders
  (mỗi lệnh 1 `README.md` 8 mục: cú pháp, cơ chế, ví dụ, rủi ro, workflow, lỗi, tham khảo).
- `02-tips-thuc-chien/`: 11 bài (01–11: context hygiene, prompt engineering,
  plan-first, verification, parallel tasks, instructions design,
  tiết kiệm AI Credits, teamwork, bảo mật, troubleshooting, nâng cao).
- `03-cau-hoi-thuong-gap/`: 10 bài (01–10: tài khoản/pricing, model/context,
  permissions, MCP, instructions, custom agent, troubleshooting, bảo mật, CLI/SDK, coding agent).
- `templates/`: `.github/copilot-instructions.md`, `instructions/` (`*.instructions.md` + `applyTo`),
  `prompts/` (`*.prompt.md`), `agents/` (`*.agent.md`), `skills/` (`.github/skills/`),
  `.vscode/mcp.json` + `.github/workflows/` (copilot-review: review PR tự động;
  ci-triage: phân tích CI failure overnight mở issue).
- Gốc: `README.md` lộ trình 5 ngày, `CHEATSHEET.md` 1 trang, `LICENSE` MIT,
  `CONTRIBUTING.md` quy ước đóng góp.
