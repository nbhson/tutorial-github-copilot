# Cheatsheet GitHub Copilot (2026) — 1 trang (lệnh nào cũng có ví dụ mini)

> **Dành cho:** bạn đang giữa task và cần tra nhanh · **Tra xong:** biết gõ gì, ở đâu, và tốn bao nhiêu (~5 phút).

Đừng đọc file này từ đầu. Nó là một bảng tra, không phải bài học: đang ở terminal thì nhảy xuống **CLI**, đang trong VS Code thì xem **VS Code Chat**, sắp giao việc lớn thì xem **Modes** và **Coding agent + Review**, lo tiền thì xem **AI Credits**. Mỗi dòng đều có ví dụ mini bên cạnh để copy-paste luôn, khỏi phải đoán cú pháp.

> **Cách đọc:** `lệnh` → ví dụ copy-paste ngay bên cạnh (sau `→`). Trong Chat, gõ `/` (slash), `@` (participant), `#` (biến) để xem list khả dụng ở máy bạn.

## CLI (terminal)

*Khi nào dùng:* bạn đang đứng ở terminal và muốn sinh/giải thích một lệnh shell, hoặc giao hẳn task cho CLI agent — không cần mở IDE.

| Lệnh | Ví dụ mini |
|---|---|
| `gh copilot suggest` | `gh copilot suggest "tìm file >100MB trong git history" → dán lệnh được gợi ý vào terminal` |
| `gh copilot explain` | `gh copilot explain "docker run -p 5432:5432 postgres" → hiểu từng flag trước khi chạy` |
| `copilot -p` (Copilot CLI) | `copilot -p "sửa lỗi test ở packages/api, chỉ đụng 2 file" → agent chạy trong terminal` |
| Check version | `gh copilot --version && gh extension list → thấy version để đối chiếu docs` |

> Lưu ý: có **2 CLI khác nhau** — `gh copilot` (suggest/explain shell) vs `copilot` (agent terminal, 3 chế độ). Đừng nhầm.

## VS Code Chat (hỏi + sửa)

*Khi nào dùng:* bạn đang trong editor. Hỏi cho hiểu thì dùng mấy lệnh nhẹ (`/explain`, quick chat); muốn nó đụng vào code thì mới tới `/fix`, `/tests`, `Ctrl+I` — và luôn đọc diff trước khi Accept.

| Phím tắt / lệnh | Ví dụ mini |
|---|---|
| `Ctrl+I` inline chat | `bôi đen hàm → Ctrl+I → "thêm null check, giữ nguyên API" → review diff từng hunk` |
| `Ctrl+Shift+I` quick chat | `đang code dở → Ctrl+Shift+I → "hàm này time complexity bao nhiêu?" → trả lời xong về code ngay` |
| `Ctrl+Alt+I` mở Chat view | `Ctrl+Alt+I → "@workspace hàm login nằm ở file nào?" → tìm file không cần grep` |
| `@workspace` | `@workspace "liệt kê chỗ nào gọi API /payments?" → tìm cross-file thay vì đoán` |
| `@terminal` | `@terminal "giải thích lỗi đỏ vừa rồi + gợi ý fix" → biến log thành task` |
| `/explain` | `bôi đen 20 dòng → /explain "giải thích như cho intern mới" → hiểu code lạ trong 30s` |
| `/fix` | `bôi đen dòng lỗi → /fix "thêm null check cho params" → Accept sau khi đọc diff` |
| `/tests` | `bôi đen hàm → /tests "sinh test theo mẫu repo, mock DB" → chạy thử, phải xanh mới Accept` |
| `/doc` | `bôi đen hàm → /doc "viết JSDoc gồm params + example" → docs chuẩn repo trong 1 nốt` |
| `/new` | `/new "bắt đầu task refactor login, cho checklist 5 bước" → chat sạch mỗi task mới` |
| `/clear` | `/clear → xóa turns cũ khi chat bắt đầu loạn, giữ instructions` |
| `/summarize` | `/summarize "nén chat này thành 5 gạch đầu dòng + việc còn dở" → giữ đà task dài` |
| `/help` | `/help → xem slash/participant khả dụng ở plan + version của bạn` |
| `Tab` nhận gợi ý | `gõ nửa hàm → Tab nhận, Alt+] / Alt+[ đổi gợi ý, Esc từ chối` |

## Modes (Ask → Edit → Agent leo thang)

*Khi nào dùng:* chọn chế độ **trước** khi viết prompt — sai chế độ thì prompt hay cỡ nào cũng vô ích.

> Quy tắc: việc nhỏ thì chế độ nhẹ. Chỉ leo lên chế độ mạnh khi chế độ dưới không kham nổi.

| Mode | Ví dụ mini |
|---|---|
| `Ask` (chỉ hỏi, không sửa) | `chọn Ask → "so sánh 2 cách cache này, chưa cần sửa code" → an toàn khi tìm hiểu` |
| `Edit` (sửa file chỉ định) | `chọn Edit + tick 2 file → "đổi message lỗi sang tiếng Việt" → sửa có kiểm soát` |
| `Agent` (tự tìm file + chạy tool) | `chọn Agent → "thêm rate-limit cho /api/login + test" → duyệt plan trước khi để nó chạy` |
| `Plan` persona (chỉ lập kế hoạch) | `chọn Plan → "thiết kế lại module auth" → duyệt plan rồi bấm Start Implementation mới code` |
| `Autopilot` persona (tự chạy tới xong) | `task dài → Autopilot chỉ trong worktree riêng + đã bật sandbox; vẫn trừ AI Credits` |
| Permissions picker | `Manual (mặc định) → Assisted (LLM tự chấm rủi ro) → Allow all; ưu tiên bật sandbox thay vì Allow all` |
| Session Target | `đáy khung Chat → Local (làm tay) / Copilot (chạy nền) / Cloud (giao hẳn, mở PR); Copilot → /delegate sang Cloud` |
| `/model` đổi model | `/model → chọn model rẻ cho /explain, model mạnh cho agent/kiến trúc khó` |
| `/usage` xem quota | `/usage → xem AI Credits đã dùng; hết thì đổi model nhẹ chờ reset` |

## instructions / prompts / skills / MCP

*Khi nào dùng:* khi bạn cần agent nhớ một quy ước, chạy một workflow lặp lại, hoặc nối tới hệ thống ngoài repo. Câu hỏi tự vấn: việc này có đúng **mọi chat** không? Có → `copilot-instructions.md`. Chỉ đúng **một thư mục** → `*.instructions.md`. Chỉ đúng **lúc cần** → prompt file/skill.

| Cái gì | Ví dụ mini |
|---|---|
| `.github/copilot-instructions.md` | `ghi stack + 6 lệnh Dev/Build/Test đã chạy thử → mọi câu trả lời theo chuẩn team` |
| `*.instructions.md` + `applyTo` | `backend-api.instructions.md với applyTo: apps/api/** → chỉ áp cho backend` |
| `*.prompt.md` | `/review-pr "review diff này theo correctness/security/tests" → prompt tái dùng (deprecated trên Agent Host — chuyển sang Skills, FAQ 06)` |
| `*.agent.md` | `gọi agent explorer: "vẽ bản đồ file chạm tới auth" → việc ồn ào đẩy sang sub-agent` |
| `.github/skills/` | `nhờ "review PR giúp" → model tự gọi Skill review-pr, không cần nhớ tên (Skills là chuẩn 2026)` |
| `.vscode/mcp.json` | `thêm server github → hỏi "dùng github tool liệt kê 5 PRs mới nhất" → test sống` |
| MCP config mẫu | Xem JSON mẫu ở `templates/README.md` → copy rồi sửa token qua `${input}` (không hardcode) |
| Agent Customizations hub | `gear icon Chat → Chat: Open Customizations → Customize Your Agent draft file; quản Plugins/Skills/Instructions/Agents/Hooks/Tools + voice.md/dictation.md (bài 17)` |

## Vòng chuẩn (mọi task)

`Explore (explorer vẽ bản đồ) → Plan (duyệt plan) → Implement (chia phase, mỗi phase xong chạy test) → Verify (test + review fresh). Rule nào miss 2 lần → đưa vào instructions/policy.`

## Coding agent + Review

*Khi nào dùng:* khi bạn muốn việc chạy ngoài máy — assign issue để nó tự mở PR, hoặc bắt nó rà diff trước khi bạn merge.

| Việc | Ví dụ mini |
|---|---|
| Giao issue cho agent | `trên GitHub: assign issue cho Copilot → nó tự tạo branch + PR → bạn review → merge` |
| Review tự động | `mở PR → Copilot comment "thiếu test cho nhánh null" → sửa trước khi merge` |
| `/review` trong Chat | `/review "check diff này về security + missing tests" → review trước khi đẩy` |
| Policy là luật chặn cuối | `policy` chặn `*.pem` → dù prompt bảo đọc, Copilot vẫn từ chối (xem FAQ 05) |

## AI Credits (tính tiền)

*Khi nào dùng:* khi thấy hoá đơn tăng nhanh, hoặc trước khi giao một task agent dài — tra bảng này để biết chỗ nào tốn nhất.

> Nôm na: mỗi lần gọi model = trả tiền theo token, quy ra "credit". 1 credit = $0.01. Code completion (gợi ý dòng tiếp) thì miễn phí.

| Việc | Ví dụ mini |
|---|---|
| `1 credit = $0.01` | chi phí 1 lượt = giá per-token × số token (code completion không trừ) |
| `/usage` | `mở Chat → /usage → xem AI Credits đã dùng hôm nay/tháng` |
| Auto model selection | `mặc định, được giảm 10% credits (plan trả phí); 3 tier: Efficiency/Balance/Intelligence (14/09/2026)` |

## Model roster (10/2026 — verify với picker)

*Khi nào dùng:* trước khi chọn model cho một task — model đổi liên tục nên đừng tin trí nhớ, mở picker đối chiếu.

> Bảng này đổi theo thời gian. Khi dùng, mở model picker trong Chat để đối chiếu list hiện tại.

| Nhóm | Model |
|---|---|
| OpenAI | GPT-5.3-Codex, GPT-5.6 Luna/Sol, GPT-6 Astra, GPT-6 Luna, GPT-6 Sol, GPT-6.1 Sol (+ HydraFusion/HydraFusion Max orchestrate đa model, preview) |
| Anthropic | Claude Haiku 4.5, **Haiku 5.5 (mới 07/10, subagent rẻ-nhanh)**, Sonnet 4.5/4.6/5/5.5, Opus 4.5/4.6/4.8/5/5.5 (+ fast preview) |
| Google | Gemini 3.1 Pro (preview), 3.8 Flash, **Gemini 4 Argon (mới 13/10, Pro+/Max/Biz/Ent, mạnh nhất ở CLI)** |
| Microsoft | MAI-Code-1-Flash, MAI-Code-1.1-Flash, Raptor mini |
| Khác | Kimi K3, Grok 4.6 |
| Gỡ 02/10/2026 (xong) | Gemini 3.5/3.6 Flash → 3.8 Flash; Kimi K2.7 Code → K3; Claude Opus 4.7 → 5.5 |
| Gỡ 19/10/2026 (sắp) | Gemini 3.7 Flash → 3.8 Flash; GPT-5.5/5.4 → GPT-5.6 Sol; GPT-5.4 mini/5 mini → GPT-5.6 Luna; Grok 4.5 → 4.6 |
| Gỡ 16/11/2026 (sắp) | Opus 4.8* → 5.5; Opus 5 → 5.5; GPT-5.6 Terra → GPT-6.1 Sol / GPT-6 Luna (*4.8 giữ cho individual annual) |

## Hooks in-process (preview, Local)

*Khi nào dùng:* khi bạn muốn "chèn cửa kiểm tra" vào giữa vòng lặp agent — ví dụ chặn lệnh nguy hiểm trước khi nó chạy, hoặc tự format sau khi nó sửa file.

> Nôm na: hooks = "cửa kiểm tra" chạy ngay trong quá trình agent làm việc (chạy local, chưa phải preview cho mọi bề mặt). Bạn gắn một script vào event `PreToolUse` (trước khi agent chạy tool) hoặc `PostToolUse` (sau khi chạy xong).

| Lệnh / file | Ví dụ mini |
|---|---|
| `.github/hooks/*.json` | `PreToolUse` chặn lệnh nguy hiểm, `PostToolUse` chạy formatter sau khi agent sửa file (bài 07/17) |
| `/create-hook` | `"/create-hook chạy prettier sau mỗi lần agent sửa file" → sinh hook vào .github/hooks/` |
| `/hooks` | `mở card Hooks trong Customizations hub — xem hook đang bật` |
| Local sandboxing (GA 07/10) | `CLI/app/VS Code Agent Host, MXC, giới hạn files+network+credentials, miễn phí; enterprise enforce được (bài 10)` |
| Computer use (preview 01/10) | `CLI: /computer on|show|off · app: Settings → Computer Use · macOS cần Accessibility + Screen Recording` |

## 3 cạm bẫy hay gặp khi tra nhanh

**1. Nhầm hai CLI với nhau**

```text
❌ SAI: gõ `copilot suggest "..."` rồi thắc mắc sao không có gợi ý shell
✅ ĐÚNG: `gh copilot suggest` để sinh lệnh shell; `copilot -p "..."` để giao task cho CLI agent
```
**Bài học:** `gh copilot` và `copilot` là hai thứ khác nhau — nhìn tên gần giống nhưng một cái chỉ nói về shell, một cái là agent.

**2. Dùng `*.prompt.md` cho Agent Host**

```text
❌ SAI: thêm prompt file mới rồi kỳ vọng nó chạy trên Agent Host
✅ ĐÚNG: prompt file là legacy cho Agent Host → port sang Skill; repo cũ Local vẫn chạy được (FAQ 06)
```
**Bài học:** prompt file vẫn dùng tốt ở môi trường Local, nhưng đừng xây workflow mới dựa trên nó.

**3. Hardcode token trong `mcp.json`**

```text
❌ SAI: dán thẳng token vào .vscode/mcp.json rồi commit
✅ ĐÚNG: để token đi qua `${input}` / `${env}`, copy mẫu ở templates/README.md
```
**Bài học:** secrets trong file config là lỗi bảo mật kinh điển; nguyên tắc của repo là secrets chỉ đi qua biến.

## So sánh với Claude Code

> Nếu bạn quen Claude Code, phần lớn khái niệm chuyển sang Copilot gần như 1-1 — chỉ khác *tên file* và *nơi chạy*.

| Việc | GitHub Copilot | Claude Code | Ghi chú |
|---|---|---|---|
| Cấu hình repo | `.github/copilot-instructions.md` + `AGENTS.md` | `CLAUDE.md` + `.claude/` | Cùng tư tưởng: file trong repo là "luật" |
| Agent mode | Ask → Edit → Agent (leo thang) | Mặc định là agent | Claude Code agentic mặc định; Copilot leo thang từng bước |
| Slash command tự tạo | Prompt files / Skills | `.claude/commands/` | Tương đương về ý tưởng |
| MCP (tool ngoài) | `.vscode/mcp.json` | Có | Cùng chuẩn giao thức |
| Chọn model | Đổi ngay trong Chat: GPT / Claude / Gemini | Gắn với model Anthropic (Claude) | Copilot cho chọn "bộ não"; Claude Code nhất quán 1 nhà |
| Autocomplete | Có (điểm mạnh, miễn phí credits) | Không phải trọng tâm | Copilot mạnh ở gõ code từng dòng |
| Kiểm chứng (verify) | Bạn là người chạy test | Bạn là người chạy test | **Không agent nào tự chịu trách nhiệm đúng/sai** |

## Tra cứu chi tiết

Index 47 lệnh: [01-huong-dan-su-dung/commands/README.md](01-huong-dan-su-dung/commands/README.md) · Hỏi đáp: [03-cau-hoi-thuong-gap/README.md](03-cau-hoi-thuong-gap/README.md) · Mẫu copy-paste: [templates/README.md](templates/README.md)

> **Chốt:** tra cheatsheet chỉ để bạn gõ đúng cú pháp — thắng hay thua vẫn nằm ở ba việc: chọn đúng chế độ cho đúng cỡ việc, giữ context sạch, và bắt Copilot chạy lệnh verify. Tra xong một dòng ở đây thì quay lại làm việc, đừng đọc hết trang rồi quên mất task.
