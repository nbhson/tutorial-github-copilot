# Khóa Học GitHub Copilot — Từ Zero tới Pro (2026)

> **Dành cho:** dev mới nghe tên Copilot, dev đã dùng nhưng muốn lên pro, và tech lead cần chuẩn hóa cách cả team dùng Copilot.
> **Vấn đề:** Copilot 2026 có quá nhiều mảnh (autocomplete, Chat, Agent mode, Copilot cloud agent, CLI, SDK, MCP, skills) — không biết mảnh nào dùng khi nào, tài liệu gốc thì tản mát.
> **Đọc xong:** nắm repo này có gì, chọn đúng folder cho việc đang làm, và có lộ trình 5 ngày để đi từ con số 0 tới dùng agent thành thạo.
> **Thời gian:** ~5 phút cho trang này; học đủ khóa là 5 ngày.

Bộ tài liệu tiếng Việt full "deep-dive" về **GitHub Copilot (2026)**, verify với docs gốc `docs.github.com/copilot` và `code.visualstudio.com/docs/copilot`.
Nguồn tổng hợp: GitHub Docs, VS Code Copilot docs, best-practices, guide về custom instructions/agents/prompts/skills/MCP + kinh nghiệm thực chiến.

## Cho ai đọc?

- Dev mới nghe tên Copilot, muốn setup và dùng đúng ngay từ đầu (đừng đoán mò).
- Dev đã dùng, muốn lên pro: Chat + Agent mode + Copilot cloud agent + Copilot CLI + SDK + code review.
- Tech lead muốn chuẩn hóa workflow cho cả team (một cách dùng chung, không mỗi người một kiểu).

> **Nếu bạn chỉ có 30 phút:** đọc [00 — Tổng quan Copilot](./01-huong-dan-su-dung/00-tong-quan-copilot.md) để hiểu 5 chế độ và vòng lặp agent trước khi làm bất cứ việc gì khác. Hiểu sai chế độ là 90% lý do người ta thất vọng với Copilot.

## Cấu trúc khóa học (mỗi phần = 1 folder)

| Folder | Nội dung (nói thẳng) | Số bài |
|---|---|---|
| [`01-huong-dan-su-dung/`](./01-huong-dan-su-dung/) | **Hướng dẫn sử dụng**: inline completions, Chat, built-in agents Ask/Plan/Agent (Edit thuộc Local harness), 5 Session Target (Local · Copilot · Claude · Codex · Cloud), custom agent, instructions/skills, MCP, Copilot CLI, SDK, Copilot cloud agent, code review, Agent Customizations editor | 18 bài + commands/ (57 lệnh, chia 3 harness: copilot 43 · local 8 · cloud 6) |
| [`02-tips-thuc-chien/`](./02-tips-thuc-chien/) | **Tips thực chiến**: context hygiene, prompt engineering, plan-first, verification, parallel tasks, instructions design, tiết kiệm AI Credits, teamwork | 11 bài deep-dive |
| [`03-cau-hoi-thuong-gap/`](./03-cau-hoi-thuong-gap/) | **Q&A thường gặp**: tài khoản & pricing, model & AI Credits, permissions, MCP, instructions, custom agent, lỗi & troubleshooting, bảo mật, Spaces/Spark/Workspace | 11 bài deep-dive |
| [`templates/`](./templates/) | Template copy-paste: `.github/copilot-instructions.md`, `instructions/`, `prompts/`, `agents/`, `skills/`, `.mcp.json` (+ `.vscode/mcp.json` cho Local harness), workflows | templates copy-paste: instructions, prompts, agents, skills, mcp.json, copilot-review + ci-triage |
| [`CHEATSHEET.md`](./CHEATSHEET.md) | Bảng tra nhanh lệnh, phím tắt, slash + `#`-mentions/Add Context, modes, MCP | 1 trang |

> **Đọc bảng này thế nào:** `01-` là "học nghề" (đọc tuần tự 00 → 17), `02-` là "lên trình" (thói quen thực chiến), `03-` là "tủ thuốc" (tra khi kẹt, không đọc từ đầu), `templates/` là bộ khung copy vào repo thật. Phần lớn người dùng chỉ cần `01-` + `CHEATSHEET.md` trong tuần đầu.

## Lộ trình học đề xuất (5 ngày đủ hết)

Mục này cho bạn một lịch học cụ thể: mỗi ngày học gì, dừng ở bài nào — bám theo nó là hết khóa trong một tuần làm việc, không cần tự khớp lịch.

```
Ngày 1: 01 bài 00 → 04 (tổng quan, cài đặt, các bề mặt, instructions/memory, chat commands)
Ngày 2: 01 bài 05 → 09 (Agent Skills, custom agents, policies/guardrails, MCP, extensions & plugins)
Ngày 3: 01 bài 10 → 17 (modes/permissions, worktrees/checkpoints, CLI/SDK/CI-CD, indexing, models, security, validate, Agent Customizations editor)
Ngày 4: 02 tips 01 → 05 (context, prompt, plan, verify, parallel)
Ngày 5: 02 tips 06 → 11 + 03 FAQ tra cứu khi gặp lỗi
```

Tra cứu lệnh nhanh: `01-huong-dan-su-dung/commands/<harness>/<nhóm>/<tên-lệnh>/` với harness = `copilot` · `local` · `cloud` (vd `commands/copilot/code-actions/fix/`).

Quy tắc vàng (nhớ 4 câu này là đủ 80% sức mạnh):

1. **Context là bottleneck, không phải model** — giữ instructions gọn (xem `02-tips-thuc-chien/01`).
2. **Ask → Plan → Agent (Copilot harness) rồi mới giao Copilot in the cloud — leo thang theo cỡ việc** (Edit là mode của Local harness); không bao giờ giao task lớn cho Agent ngay.
3. **instructions là gợi ý, policy/MCP-allowlist là luật** — rule nào hay bị quên thì đưa vào policy.
4. **Việc ồn ào đẩy sang custom agent/sub-task** — Chat chính chỉ giữ quyết định.

> **Tóm gọn 1 câu:** Bốn quy tắc vàng là 4 chiếc phao: context sạch, leo thang từ từ, luật cứng đặt đúng tầng, và việc ồn để dành cho thợ phụ.

## Cách dùng repo này (đọc 3 phút rồi hãy học)

- Đọc theo thứ tự file `00-*` → `NN-*` trong mỗi folder (đã đánh số). Mỗi bài FAQ trong `03-*` theo cấu trúc gọn: **Trả lời 1 câu → giải thích + lệnh copy-paste → "Vẫn lỗi thì sao?" cuối file** — bận thì chỉ đọc "Trả lời 1 câu", rảnh thì làm theo lệnh.
- Mọi code block đều copy-paste được. Template trong `templates/` dùng được ngay (copy `.github/` + `.vscode/` sang repo thật, sửa stack/lệnh/glob cho khớp).
- Gõ `/` trong Copilot Chat để xem slash commands khả dụng, `#` để gắn context (Add Context) — `@` participants đã deprecated, không chạy ở Copilot harness.
- Kẹt ở đâu tra đó: `CHEATSHEET.md` (1 trang, lệnh nào cũng có ví dụ mini) → `01-huong-dan-su-dung/commands/` (57 lệnh, mỗi lệnh 1 folder chi tiết) → `03-cau-hoi-thuong-gap/` (11 bài FAQ, mỗi bài có mục "Vẫn lỗi thì sao?").

> **Tóm gọn 1 câu:** Repo này là bản đồ + tủ tra: đi đường dài bằng lộ trình 5 ngày ở `01-`/`02-`, còn lúc kẹt việc thì mở đúng ngăn — cheatsheet cho cú pháp, FAQ cho lỗi, templates cho repo thật.

## So sánh với Claude Code

Repo này viết cho Copilot, nhưng nếu bạn đã quen Claude Code thì chuyển sang gần như 1-1 — chỉ khác *tên file* và *nơi chạy*. Bảng dưới là bản đồ ở mức repo, để bạn biết bắt đầu đọc từ đâu:

| Việc | GitHub Copilot | Claude Code | Học ở đâu trong repo này |
|---|---|---|---|
| Gõ code từng dòng | Autocomplete là điểm mạnh, không trừ AI Credits | Không phải trọng tâm | [01 — bài 00](./01-huong-dan-su-dung/00-tong-quan-copilot.md) |
| Chạy ở đâu | VS Code / JetBrains / Neovim / github.com / CLI | CLI trong terminal (và IDE extension) | [01 — bài 02](./01-huong-dan-su-dung/02-cac-be-mat-vscode-ide-web-cli.md) |
| Chọn model | Đổi ngay trong Chat: GPT / Claude / Gemini | Gắn với model Anthropic (Claude) | [01 — bài 14](./01-huong-dan-su-dung/14-models-chon-model-dung.md) |
| Luật trong repo | `.github/copilot-instructions.md` + `AGENTS.md` | `CLAUDE.md` + `.claude/` | [01 — bài 03](./01-huong-dan-su-dung/03-instructions-memory-rules.md) |
| Slash command tự tạo | Agent Skills / prompt files | `.claude/commands/` | [01 — bài 05](./01-huong-dan-su-dung/05-agent-skills-reusable-workflows.md) |
| Nối hệ thống ngoài | MCP (`.mcp.json` ở root + `~/.copilot/mcp-config.json`; `.vscode/mcp.json` chỉ Local harness) | MCP (`.mcp.json`) | [01 — bài 08](./01-huong-dan-su-dung/08-mcp-ket-noi-cong-cu-ngoai.md) |
| Xếp task tự động hoá | Copilot cloud agent (assign issue) / Actions | Session cloud + tích hợp GitHub | [01 — bài 12](./01-huong-dan-su-dung/12-copilot-sdk-ci-cd-automation.md) |
| Tính chi phí | AI Credits (1 credit = 0,01 USD) | Gói subscription theo cửa sổ usage | [02 — tips 08](./02-tips-thuc-chien/08-tiet-kiem-ai-credits.md) |

> **Đọc bảng này thế nào:** khái niệm chuyển gần 1-1 (instructions, agent loop, MCP, slash command) — cái cần học thêm là *tên file* của Copilot và khái niệm **Session Target** (5 lựa chọn: Local · Copilot · Claude · Codex · Cloud) mà Claude Code không có tương đương trực tiếp. Phần Copilot hơn hẳn là **autocomplete + đổi model trong 1 tài khoản**; phần Claude Code mạnh là **agentic mặc định + terminal-first**.

## Hiểu nhầm hay gặp khi mới vào repo (❌ SAI / ✅ ĐÚNG)

**1. Tưởng repo này là "mẹo vặt" để đọc một lần**

```text
❌ SAI: đọc hết 1 lượt rồi để đó, khi kẹt lại hỏi người khác
✅ ĐÚNG: đọc 01- lấy nền, rồi bookmark CHEATSHEET.md + 03-cau-hoi-thuong-gap/ để tra mỗi khi kẹt
```
**Bài học:** repo được xếp như sách giáo khoa + tủ thuốc, không phải bài blog. Đọc một lần rồi quên là mất nửa giá trị.

**2. Copy nguyên `templates/` vào repo rồi để y nguyên**

```text
❌ SAI: cp -r templates/.github ./ rồi commit luôn, giữ cả instructions không dùng
✅ ĐÚNG: copy rồi sửa stack/lệnh/glob cho khớp repo, xóa file không liên quan
```
**Bài học:** template chỉ là bộ bàn ghế đóng gói sẵn — lắp vào nhà thì phải kê lại cho vừa phòng.

## Phiên bản & nguồn

- GitHub Copilot **(2026)**. Kiểm tra Copilot CLI bằng `copilot --version`; extension cộng đồng `gh copilot` xem bằng `gh extension list`.
- Docs gốc: https://docs.github.com/en/copilot — VS Code Copilot: https://code.visualstudio.com/docs/setup/copilot
- **Cập nhật sự kiện 2026-10-16** (verify `github.blog/changelog` + docs):
  - Model mới: `Gemini 4 Argon` GA 13/10 (Pro+/Max/Business/Enterprise, mạnh nhất ở CLI) · `Claude Haiku 5.5` GA 07/10 (Pro→Enterprise, subagent/quick-edit rẻ-nhanh) · `HydraFusion Max` mới 14/10 (research preview, pool Opus 5.5 + GPT-6 Astra/6.1 Sol/6 Luna).
  - Sắp gỡ **19/10/2026**: Gemini 3.7 Flash, GPT-5.5, GPT-5.4 (+mini), GPT-5 mini, Grok 4.5 → thay bằng 3.8 Flash / GPT-5.6 Sol/Luna / Grok 4.7.
  - Sắp gỡ **16/11/2026**: Claude Opus 4.8*, Opus 5, GPT-5.6 Terra → Opus 5.5 / GPT-6.1 Sol / GPT-6 Luna (*Opus 4.8 giữ cho individual annual).
  - Local sandboxing **GA 07/10** (CLI + app + VS Code Agent Host, MXC, miễn phí, enterprise enforce được) · Computer use **preview 01/10** (CLI `/computer on`, app Settings → Computer Use, macOS cần Accessibility + Screen Recording).
  - App dùng 2 account tách biệt · CLI `/model` thấy local Ollama · VS Code 1.141 Agents side-by-side + worktree cleanup · Code review effort mặc định Balanced (từ 28/09) · Governance: telemetry attribution + managed-settings fail-closed.
- **Cập nhật sự kiện 2026-10-09** (giữ để tra lịch sử):
  - `.github/copilot-instructions.md` (không còn `muse-instructions.md`).
  - Copilot **có** hooks (`.github/hooks/*.json` + `~/.copilot/hooks/`, schema `{"version":1,"hooks":{"<Event>":[{matcher}]}}`, events camelCase `preToolUse`/`postToolUse` hoặc alias PascalCase; chạy ở Copilot CLI + Copilot in the cloud (subset event), VS Code = Preview — bài 07/17).
  - Prompt files (`.prompt.md`) **chỉ chạy ở Local harness** (VS Code docs; docs GitHub không dùng chữ deprecated) → ưu tiên **Agent Skills** (`SKILL.md`).
  - Billing theo **AI Credits** (1 credit = $0.01, trừ per-token; code completions & next edit suggestions không trừ credits).
  - Model roster mới (GPT-5.x/6.x, Claude Opus/Sonnet 5.x, Gemini 3.x, MAI-Code; deprecate 4 model 02/10/2026).
  - **2 CLI khác nhau**: `gh copilot` (extension cộng đồng, suggest/explain shell) vs `copilot` (Copilot CLI — agent terminal, 2 chế độ interactive/headless).

- **Cập nhật sự kiện 2026-10-27** (verify `github.blog/changelog` + docs):
  - **Copilot Extensions (GitHub App, gọi bằng `@` trong Chat): deprecated 24/09/2025, retired 10/11/2025** — docs GitHub 11/2026 không còn trang này; đường mở rộng hiện hành là **Agent Plugins + MCP servers + Copilot connectors** (bài 09 đã rewrite). Tư liệu background: [`copilot-extensions-ai-powered/README.md`](./copilot-extensions-ai-powered/README.md) — tài liệu song hành tiếng Anh cho [bài 09 — Extensions & Marketplaces](./01-huong-dan-su-dung/09-extensions-marketplaces.md), **đọc như hồ sơ lịch sử, không phải hướng dẫn dùng**.
  - **Agent của bên thứ ba** (Claude Code, Codex) chạy song song Copilot cloud agent trên github.com (docs: `copilot/concepts/agents/about-third-party-coding-agents`); hướng nền tảng là Agent HQ (GitHub Universe 2025).
  - Copilot cloud agent có mặt cho mọi subscriber trả phí; approve từ GitHub Mobile (mobile = review/duyệt, không phải bề mặt code).

## Đóng góp & thay đổi

- Muốn thêm bài? Đọc [`CONTRIBUTING.md`](./CONTRIBUTING.md) và [`STYLE.md`](./STYLE.md) trước khi mở PR để bài mới khớp khuôn "dễ hiểu".
- Xem [`CHANGELOG.md`](./CHANGELOG.md) để biết repo đã đổi gì qua các lần cập nhật.

> **Chốt trang này:** đừng cố đọc hết repo trong một buổi — mở [bài 00](./01-huong-dan-su-dung/00-tong-quan-copilot.md) trước để chọn đúng "động cơ" cho công việc của bạn, rồi quay lại bảng cấu trúc chọn folder. Biết mình đang ở folder nào và đang dùng chế độ nào là bạn đã đi nhanh hơn phần lớn người mới.
