# Cheatsheet GitHub Copilot (2026) — 1 trang (lệnh nào cũng có ví dụ mini)

> **Dành cho:** bạn đang giữa task và cần tra nhanh · **Tra xong:** biết gõ gì, ở đâu, và tốn bao nhiêu (~5 phút).

Đừng đọc file này từ đầu. Nó là một bảng tra, không phải bài học: đứng ở terminal thì xem **CLI (Copilot CLI)**, đang trong VS Code thì xem **VS Code Chat (Copilot harness)**, sắp giao việc chạy ngoài máy thì xem **GitHub.com**, lo tiền thì xem **AI credits & chi phí**. Mỗi dòng có ví dụ mini sau `→` để copy-paste luôn, khỏi phải đoán cú pháp.

> **Cách đọc:** `lệnh` → ví dụ bên cạnh. Trong Chat, gõ `/` để xem slash commands khả dụng, `#` để gắn context (Add Context) — `@` participants đã deprecated, không chạy ở Copilot harness.

> **Tóm gọn 1 câu:** Trang này là hộp dụng cụ xếp theo nơi làm việc (terminal → editor → GitHub.com → tính tiền) — mở đúng ngăn đang cần, lấy lệnh là đi ngay.

## CLI (Copilot CLI)

*Khi nào dùng:* bạn đứng ở terminal và muốn giao task cho agent bằng binary `copilot` (2 chế độ: interactive và headless) — không cần mở IDE.

| Lệnh | Ví dụ mini |
|---|---|
| `copilot` (interactive) | `cd repo → copilot → "sửa lỗi test ở packages/api, chỉ đụng 2 file" → agent chạy trong terminal` |
| `copilot -p` (headless) | `copilot -p "tóm tắt diff mới nhất" → exit code 0/1/2 để bắt trong CI` |
| `copilot --version` | `copilot --version → đối chiếu version với docs CLI trước khi làm theo hướng dẫn` |
| `--plan` · `Shift+Tab` | `copilot --plan (= --mode=plan, chỉ đọc + ghi plan file) → Shift+Tab xoay standard/plan/autopilot` |
| `/permissions` · `/status` · `/limits` | `/permissions show → default/assisted/allow-all · /status xem phiên · /limits view\|set\|reset để chạy tiếp khi đụng soft cap` |
| `/sandbox config\|status\|policy\|enable\|disable\|ca` | `/sandbox policy → xem policy hiệu lực kể cả khi sandbox tắt; local sandboxing chạy ở CLI/app/VS Code Agent Host, nền tảng MXC, enterprise enforce được (bài 10)` |
| `/plugin …` · `/computer on\|off` | `/plugin list\|install OWNER/REPO\|marketplace add … → quản Agent Plugins, chỉ Copilot harness; /computer = computer-use plugin, macOS cần Accessibility + Screen Recording` |
| `~/.copilot/settings.json` | `user settings; .github/copilot/settings.json là overlay repo; /settings --repo\|--local để sửa` |

> Lưu ý: `gh copilot suggest/explain` **không phải** CLI này — đó là extension cộng đồng của GitHub CLI (`gh`), xem mục **Local harness**.

## VS Code Chat (Copilot harness)

*Khi nào dùng:* bạn đang trong editor. Phím dưới là bản Windows/Linux; macOS: `Ctrl+Cmd+I` (Chat view), `Cmd+I` (inline), `Shift+Option+Cmd+L` (Quick Chat).

| Phím | Ví dụ mini |
|---|---|
| `Ctrl+Alt+I` mở Chat view | `Ctrl+Alt+I → "hàm login nằm ở file nào?" → agent tự tìm, không cần grep` |
| `Ctrl+N` chat mới | `sang task mới → Ctrl+N cho sạch, đừng xoá dần chat cũ` |
| `Ctrl+I` inline chat | `bôi đen hàm → Ctrl+I → "thêm null check, giữ nguyên API" → duyệt diff từng hunk rồi Accept` |
| `Ctrl+Shift+Alt+L` Quick Chat | `Ctrl+Shift+Alt+L → "hàm này time complexity bao nhiêu?" → trả lời xong về code ngay` |
| `Tab` / `Esc` | `gõ nửa hàm → Tab nhận gợi ý, Alt+] / Alt+[ đổi, Esc từ chối` |

| Slash | Ví dụ mini |
|---|---|
| `/plan` | `/plan "thiết kế lại module auth" → research + propose plan, duyệt rồi mới code` |
| `/explain` `/fix` `/tests` `/doc` | `bôi đen code → /fix "thêm null check cho params" → Accept sau khi đọc diff; /doc thuộc inline chat (Ctrl+I). Nhóm slash editor — không có trong CLI` |
| `/compact` · `/clear` | `/compact → nén ngữ cảnh hội thoại (Local, Copilot, Claude cùng có); /clear → mở chat mới + archive chat hiện tại` |
| `/new` · `/newNotebook` | `/new → scaffold workspace/file/notebook — KHÔNG phải "bắt đầu task mới"; chat mới là Ctrl+N` |
| `/fork` · `/btw <câu hỏi>` | `/fork "làm biến thể khác" → phân nhánh hội thoại kèm history (cần Agent Host session); /btw = side chat, không loãng thread chính (không có ở Local)` |
| `/<skill-name>` | `bảo "review PR giúp" → model tự gọi skill khớp description; hoặc gõ /review-pr để gọi tường minh` |
| `/sandbox policy` | `trước khi giao việc risky → Copilot session cho xem policy hiệu lực, kể cả khi sandbox đang tắt` |
| `/prompts` `/hooks` | `2 slash customization còn ở Copilot harness; agents/instructions/skills quản bằng Agent Customizations editor (lệnh Chat: Open Customizations — bài 17)` |

## Local harness (tham khảo)

*Khi nào dùng:* chỉ để hiểu vì sao vài thứ "hồi trước chạy, giờ không thấy". Khoá học mặc định dạy Copilot harness; chi tiết ở `01-huong-dan-su-dung/commands/local/`.

| Thứ chỉ sống ở Local | Ghi chú |
|---|---|
| `gh copilot suggest/explain` | **extension cộng đồng** của GitHub CLI (`gh`), không phải Copilot CLI (binary `copilot`); vd `gh copilot suggest "tìm file >100MB"` |
| Slash "in a local chat" | `/help` (liệt kê lệnh trong local Ask chat), `/rename`, `/models`, `/tools`, `/init`, `/agents`, `/instructions`, `/skills`, `/create-agent`…`/create-hook` (local agent session) |
| `*.prompt.md` | Copilot harness không load → migrate sang Skill (bài 05) |
| `.vscode/mcp.json` (key `servers`) + `${input:}` | Copilot đọc `.mcp.json` ở root + `~/.copilot/mcp-config.json`; `${input:}` không port sang → dùng env vars |
| `@` participants | deprecated, không chạy ở Copilot harness → thay bằng `#`-mentions/Add Context + agent tự gather context |
| Edit mode · `chat.editing.autoAcceptDelay` | Copilot harness thay bằng built-in agents Ask/Plan/Agent |

## GitHub.com (Copilot in the cloud)

*Khi nào dùng:* muốn việc chạy ngoài máy — giao issue để agent tự mở PR, hoặc bắt code review rà diff trước khi merge.

| Việc | Ví dụ mini |
|---|---|
| Giao issue cho Copilot cloud agent | `assign issue cho Copilot → branch + PR draft → review → merge; modes Interactive/Autopilot · tool permissions Assisted/Always ask/Allow all · environment Cloud sandbox/GitHub Actions/Remote (giới hạn 59 phút chỉ áp dụng session chạy bằng Actions minutes, không áp dụng cloud sandbox — bài 12)` |
| Copilot code review | `mở PR → chọn effort Lite/Balanced/Max → đọc instructions + skills từ HEAD branch; path-specific instructions chỉ hỗ trợ cho cloud agent + code review` |
| Content exclusion | `chặn file nhạy cảm — CÓ áp dụng cho Copilot in the cloud (gồm cloud sandbox) + code review + CLI; không phải security boundary (FAQ 05)` |

## Modes (leo thang trong Copilot harness)

*Khi nào dùng:* chọn chế độ **trước** khi viết prompt — sai chế độ thì prompt hay cỡ nào cũng vô ích. Việc nhỏ để số thấp, chỉ leo lên khi số dưới không kham nổi.

| Mode / setting | Ví dụ mini |
|---|---|
| `Ask` (built-in agent, chỉ hỏi không sửa) | `chọn Ask → "so sánh 2 cách cache này, chưa cần sửa code" → an toàn khi tìm hiểu` |
| `Plan` (built-in agent) | `chọn Plan → "thiết kế lại module auth" → duyệt plan rồi bấm Start Implementation mới code` |
| `Agent` (built-in agent, tự tìm file + chạy tool) | `chọn Agent → "thêm rate-limit cho /api/login + test" → duyệt plan trước khi để nó chạy` |
| `Edit` (mode của **Local harness**) | `Copilot harness không có Edit → thay bằng Agent/Plan` |
| `Autopilot` (agent mode, KHÔNG phải permission level) | `task dài → tự approve + retry, vẫn trừ AI credits → chỉ dùng trong worktree/sandbox riêng (bài 11)` |
| Permission levels | `Manual (default) → Assisted → Allow all; ưu tiên bật sandbox thay vì Allow all — sandbox vẫn chặn kể cả Allow all (bài 10)` |
| Session Target | `5 lựa chọn: Local · Copilot · Claude · Codex · Cloud — Cloud không phải harness, là execution target chạy Copilot harness (bài 02)` |
| Model | `VS Code: picker đáy Chat · CLI: /model · Local chat: /models — roster đổi theo quý, mở picker đối chiếu, đừng tin trí nhớ (bài 14)` |

> **Tóm gọn 1 câu:** Modes là hộp số của xe: việc nhỏ số thấp (Ask), dốc mới số cao (Agent/Autopilot) — và luôn nhìn pin AI credits trước khi lên dốc dài.

## AI credits & chi phí

*Khi nào dùng:* khi thấy hoá đơn tăng nhanh, hoặc trước khi giao một task agent dài — tra bảng này để biết chỗ nào tốn nhất. Cách tiết kiệm: [02 — tips 08](02-tips-thuc-chien/08-tiet-kiem-ai-credits.md).

| Fact | Con số / lệnh |
|---|---|
| Giá credit | `1 credit = $0,01`; chi phí một lượt = giá per-token × số token · Plans cá nhân: Free / Pro / Pro+ / Max |
| Code completions + next edit suggestions | không trừ credits, unlimited cho mọi plan trả phí |
| Copilot code review | effort Lite/Balanced/Max ≈ $0,25 / $1,50 / $10 mỗi review + GitHub Actions minutes |
| Image generation | billed riêng theo bảng giá riêng |
| Xem usage | dashboard `github.com/settings/copilot` · CLI `/limits` |
| Trần chi tiêu CLI | `--max-ai-credits` = soft cap cho **lượt tiếp theo** (chạy tiếp bằng `/limits`) · `--max-session-credits` = cap cả phiên |
| Budget | Bundled AI credits budget + "Stop usage when budget limit is reached" — đặt $0 để chặn cứng |

## File nào sống ở đâu

| File | Việc |
|---|---|
| `.github/copilot-instructions.md` hoặc `AGENTS.md` | repo-wide instructions; `CLAUDE.md`/`GEMINI.md` thay được 1 file ở root; nearest `AGENTS.md` wins (bài 03) |
| `.github/instructions/*.instructions.md` + `applyTo` | path-specific rules; `excludeAgent: "code-review"\|"cloud-agent"` là field chính thức |
| `.github/skills/<tên>/SKILL.md` · `~/.copilot/skills/` | Agent Skills — chuẩn 2026, chạy mọi harness; gọi `/<skill-name>` (bài 05) |
| `.github/agents/*.agent.md` · `~/.copilot/agents/` | custom agents — việc ồn ào đẩy sang sub-agent (bài 06) |
| `.github/prompts/*.prompt.md` | prompt files — chỉ Local harness chạy (FAQ 06) |
| `.github/hooks/*.json` · `~/.copilot/hooks/` | schema `{"version":1,"hooks":{"preToolUse":[{"matcher":"Bash(git *)"}]}}` (camelCase hoặc alias PascalCase); chạy ở Copilot CLI + Copilot in the cloud (subset event), VS Code = Preview — KHÔNG phải "chỉ Local" (bài 07/17) |
| `.mcp.json` (root) + `~/.copilot/mcp-config.json` | MCP cho Copilot harness (`.vscode/mcp.json` chỉ Local); secrets qua env vars, mẫu ở `templates/README.md` (bài 08) |

**Vòng chuẩn (mọi task):** Explore (agent vẽ bản đồ file) → Plan (duyệt plan) → Implement (chia phase, mỗi phase xong chạy test) → Verify (test + review fresh). Rule nào miss 2 lần → đưa vào instructions/policy.

## 3 cạm bẫy hay gặp khi tra nhanh

```text
❌ SAI: gõ copilot suggest "..." rồi thắc mắc sao không có gợi ý shell
✅ ĐÚNG: gh copilot suggest (extension cộng đồng của GitHub CLI) để sinh lệnh shell; copilot -p "..." để giao task cho CLI agent
```
**Bài học:** `gh copilot` và `copilot` là hai thứ khác nhau — một cái chỉ nói về shell, một cái là agent.

```text
❌ SAI: @workspace "liệt kê chỗ nào gọi API /payments?" trong Copilot harness
✅ ĐÚNG: participants đã deprecated — để agent tự gather workspace context, gắn thêm file bằng #-mentions/Add Context
```
**Bài học:** `@` là dấu của Local harness ngày trước; Copilot harness dùng `#` và tools.

```text
❌ SAI: copy .vscode/mcp.json sang .mcp.json rồi giữ nguyên ${input:API_KEY}, hoặc dán thẳng token vào file rồi commit
✅ ĐÚNG: ${input:} không port sang Copilot harness → để token trong env vars; secrets không bao giờ hardcode
```
**Bài học:** secrets trong file config là lỗi bảo mật kinh điển; nguyên tắc của repo: secrets chỉ đi qua biến.

## Tra cứu chi tiết & nguồn docs

Index 57 lệnh theo 3 harness (copilot 43 · local 8 · cloud 6) (`commands/<harness>/<nhóm>/<slug>/`): [01-huong-dan-su-dung/commands/README.md](01-huong-dan-su-dung/commands/README.md) · Hỏi đáp: [03-cau-hoi-thuong-gap/README.md](03-cau-hoi-thuong-gap/README.md) · Mẫu copy-paste: [templates/README.md](templates/README.md)

**Reference (docs 11/2026):**
- Slash + phím Chat, harness, approvals, sandbox, migrate: https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet · https://code.visualstudio.com/docs/agents/concepts/agent-harnesses · https://code.visualstudio.com/docs/agents/run/approvals · https://code.visualstudio.com/docs/agents/run/agent-sandboxing · https://code.visualstudio.com/docs/agents/run/move-to-copilot
- Customizations (skills/instructions/agents/hooks/MCP/plugins/connectors/prompt files): https://code.visualstudio.com/docs/agent-customization/overview
- Copilot CLI (flags + slash) và hooks: https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference · https://docs.github.com/en/copilot/reference/hooks-reference
- Copilot in the cloud, surfaces cho policy, local sandboxing (MXC): https://docs.github.com/en/copilot/concepts/agents/cloud-agent/about-cloud-agent · https://docs.github.com/en/copilot/reference/supported-surfaces-for-policies · https://docs.github.com/en/copilot/concepts/security-governance-and-network-settings/understanding-local-sandboxing
- AI credits & giá: https://docs.github.com/en/copilot/reference/copilot-billing/models-and-pricing

> **Chốt:** tra cheatsheet chỉ để bạn gõ đúng cú pháp — thắng hay thua vẫn nằm ở ba việc: chọn đúng chế độ cho đúng cỡ việc, giữ context sạch, và bắt Copilot chạy lệnh verify. Tra xong một dòng ở đây thì quay lại làm việc, đừng đọc hết trang rồi quên mất task.
