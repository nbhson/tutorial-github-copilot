# 03 — Kế hoạch từng bài (00 → 17 + README)

Ký hiệu: **GIỮ** = không đụng · **CẮT/DỜI** = xoá khỏi bài, có nơi nhận · **SỬA** = thay nội dung theo file `02` · **NỘP** = thêm vì docs có mà course thiếu.
Mọi bài giữ nguyên khối: blockquote meta (Dành cho / Vấn đề / Đọc xong / Thời gian) → **`## Mục tiêu bài học`** → Mục lục → nội dung → … → Bài tập → Link chéo → Reference.

**Tổng:** 5.460 dòng → **3.300 dòng** (cắt 2.160 = 39,6%), trung bình **180 dòng/bài**, không bài nào vượt 210.

| Bài | Sekarang | Đích | Cắt chủ yếu bằng |
|---|---:|---:|---|
| README | 67 | 65 | sửa ~8 chỗ mô tả sai, không cắt |
| 00 | 359 | 190 | trả bảng giá + walkthrough cho 01 |
| 01 | 283 | 170 | bỏ §1 lặp 00, bảng giá chỉ còn 6 dòng |
| 02 | 341 | 200 | nén §5 cloud, giữ §3.1 |
| 03 | 350 | 185 | 2 file mẫu inline → `examples/` |
| 04 | 310 | 185 | bỏ §7 + §10, sửa §6/§8 khớp index |
| 05 | 320 | 180 → **đã ra 200** ✅ | **cắt §6 plugin + §5 instructions** |
| 06 | 361 | 190 | §4: 4 agent mẫu → 1 mẫu + 3 khung |
| 07 | 277 | 175 | rewrite hooks theo docs, 1 recipe |
| 08 | 321 | 185 | đảo mặc định `.vscode/mcp.json` → `.mcp.json` |
| 09 | 238 | 150 | **rewrite quanh Copilot Extensions đã retired** |
| 10 | 314 | 200 | §3/§5 → pointer, sửa bảng Session Target |
| 11 | 215 | 160 | trả flow cloud agent cho 12 |
| 12 | 200 | 165 | sửa §2.1 AHP/SDK attribution |
| 13 | 306 | 180 | bỏ §7.4 |
| 14 | 291 | 175 | bỏ roster model + bảng giá |
| 15 | 259 | 170 | bỏ network allowlist (trỏ 07) |
| 16 | 291 | 180 | bỏ §4.1 (trỏ 08), gộp §6.2 với 09 |
| 17 | 357 | 195 | §4.1–4.5 mỗi card 4 dòng |

---

## README.md (67 → 65)

**GIỮ:** toàn bộ cấu trúc + bảng 18 bài + cách học nhanh.
**SỬA (8 chỗ):** dòng 8 (bỏ "testing/best practices team" không có bài; đổi "Agent Customizations hub" → **editor**) · dòng 22 ("~70 commands" → **47 lệnh + ~25 slash chính thức**) · dòng 26 (bỏ neo `.vscode/mcp.json`) · dòng 27 (mô tả 09: thêm "VS Code extensions + plugins") · dòng 28 & 57 (Session Target = **Local / Copilot / Claude / Codex / Cloud**) · dòng 30 ("gh copilot CLI" → **Copilot CLI binary `copilot`**) · dòng 32 (thêm Grok/Kimi/MAI) · dòng 59 (sandbox profile thuộc **16**, không phải 17).
**THÊM:** 1 dòng đầu trang: *"Khoá học dạy **Copilot harness**; Local/Cloud chỉ xuất hiện ở 00, 02, 10, 17 để so sánh."* + bảng link sang `commands/copilot|local|cloud/`.

## 00 — Tổng quan (359 → 190)

- **GIỮ:** Mục tiêu bài học (siết còn 4 gạch) · §1 định nghĩa + 5 chế độ (bài overview được so sánh) · §2 vòng lặp agent · §3 4 họ tool · §5 bản đồ tùy biến (đổi tiêu đề: bỏ chữ "extension") · §7 hiểu nhầm + bài tập.
- **CẮT/DỜI:** §1.3 bảng "vs Claude Code" (23 dòng) → **00 là chủ sở hữu**, các bài 03/04/05 bỏ bảng của họ · §4.1 bảng giá (18 dòng) → trả **01** · §4.2 ví dụ tính nhẩm (18 dòng) → còn 6 dòng · §6 walkthrough 5 bước (55 dòng) → trả **01** (chỉ giữ 4 dòng "xem bài 01 §6") · §7 dòng 300–305 lặp §1.
- **SỬA:** dòng 90–96 *"VS Code (harness) thực thi tool"* → **"Agent Host chạy Copilot harness; extension host chạy Local harness"**; thêm 1 bảng nhỏ 6 dòng "5 Session Target" (nâng cấp từ docs).
- **NỘP:** 1 câu "Docs khuyến nghị bắt đầu với Copilot harness" + link `move-to-copilot`.

## 01 — Cài đặt & xác thực (283 → 170)

- **GIỮ:** Mục tiêu · §3 VS Code setup (trọng tâm) · §6 login/verify/bảng lỗi (giá trị cao nhất bài) · §7 checklist.
- **CẮT/DỜI:** §1 "vì sao 2026 khác trước" (16 dòng, lặp 00) → 4 dòng · §2.1 bảng giá → **00 là chủ**, giữ 6 dòng "plan ảnh hưởng login/quota" · §4 JetBrains/VS/Neovim: bỏ bảng "agent mạnh/yếu" (trùng 02) · §5 Copilot CLI (20 dòng) → còn 4 dòng + link 02/12 · §6.3 walkthrough → **01 là chủ sở hữu** (giữ, vì 00 đã trả về đây).
- **SỬA:** dòng 116 phím `Ctrl+Alt+I` = **mở Chat view** (đúng), nhưng nếu chỗ nào ghi Quick Chat thì đổi thành `Ctrl+Shift+Alt+L`; dòng 98/130 terminology harness chuẩn.
- **NỘP:** `copilot --version` / `gh extension list` trong bước verify; 1 dòng về **4 plan gồm Max**.

## 02 — Các bề mặt (341 → 200) — *bài overview, được so sánh*

- **GIỮ:** §3.1 Session Target (đoạn chuẩn nhất series — dùng làm văn bản gốc để các bài khác trích) · §2 bảng quyết định · §6 bề mặt nhỏ · §7 Copilot CLI.
- **SỬA:** §1 dòng 46 "mục 3.4" → **§3.1** · bảng §3.1 thêm gạch: **Cloud không phải harness riêng**, là execution target chạy Copilot harness · dòng 145–146 "Handoff chỉ từ Local" + `/delegate` → docs gọi là **hand off a session** qua picker, **không có `/delegate`** → bỏ slash, giữ thao tác · §5 cloud: sửa tên **Copilot cloud agent / Copilot in the cloud**, nén mẫu issue 16 dòng còn 6.
- **CẮT/DỜI:** cây hỏi dòng 80–88 (trùng 00) · §4 bảng agent mạnh/yếu (trùng 01) · §8 hai dòng đầu bảng hiểu nhầm.
- **NỘP:** 5 dòng "CLI ≠ Local harness" (docs FAQ nguyên văn) — chống nhầm phổ biến nhất.

## 03 — Instructions, memory, rules (350 → 185) — *chủ sở hữu instructions*

- **GIỮ:** Mục tiêu · §1 vì sao (token economics) · §2 3 loại file · §4 `applyTo` globs · §5 `AGENTS.md` · §6 front-load · §8 hiểu nhầm.
- **SỬA:** §1/bảng hierarchy: **bỏ luật "file cao nhất thắng"**, thay bằng "cả Personal/Repo/Org đều được nạp; Personal phân xử khi mâu thuẫn; mỗi harness một quy tắc" · thêm `excludeAgent` (chính thức) + "code review đọc từ **head branch**" · đường dẫn cá nhân: `~/.copilot/copilot-instructions.md` + `~/.copilot/instructions/` · **xoá** mọi `~/.copilot/org-customizations/` (không có trong docs — org làm qua UI).
- **CẮT/DỜI:** §3 hai file mẫu inline (70 dòng) → **2 file mới** `examples/03-instructions-memory-rules/mau-instructions-backend.md`, `examples/03-instructions-memory-rules/mau-instructions-frontend.md`, trong bài còn 1 mẫu 12 dòng · §9 bảng Claude Code (20 dòng) → 2 dòng trỏ 00.
- **NỘP:** Memory: Copilot Memory **public preview** + `Chat: Show Memory Files`; Local memory files **không tự convert** sang Copilot Memory.

## 04 — Chat commands toàn tập (310 → 185) — *chủ sở hữu slash commands*

- **GIỮ:** 4 bảng index (giá trị tra cứu) · §1 cách đọc index · §8 walkthrough (bỏ lệnh sai).
- **SỬA:** đổi 100% sang bảng slash của `02` §2 — **xoá `/summarize` (→ `/compact`)**, `/history`→panel Session History, `/export`→`Chat: Export Chat…`, `/resume`→Resume in Terminal, `/customAgent`→`/agents`+picker, `/policy`→`settings → policies` hoặc `/sandbox policy`, `/usage`→Copilot status dashboard · thêm dòng **"ở Copilot harness, `/agents` `/instructions` `/skills` KHÔNG có trong Chat view — dùng Agent Customizations editor; chỉ `/prompts` và `/hooks` có"** (nguyên văn docs) · §6 công thức 5 lệnh phải dùng lệnh có trong index · dòng 222/224 **hai dòng đúp → xoá 1** · đổi phím Quick Chat theo `02` §3 · **bỏ mọi `@participant`** (`@workspace`/`@terminal` — deprecated, không chạy Copilot) → thay bằng `#`-mentions/Add Context · `/prompts` giữ nhưng ghi "chỉ Local harness".
- **CẮT/DỜI:** §7 plan/model gating (22 dòng) → 4 gạch · §10 bảng Claude Code (17 dòng) → trỏ 00.
- **NỘP:** bảng 8 slash **mà course đang thiếu**: `/plan`, `/compact`, `/fork`, `/btw`, `/models`, `/tools`, `/init`, `/troubleshoot`, `/debug`, `/sandbox policy`, `/yolo`, `/autoApprove`, `/rename`, `/help`, `/plugin`, `/<skill-name>`.
- **LINK:** 46 chỗ `./commands/<nhóm>/<slug>/README.md` → đổi prefix theo file `04`.

## 05 — Agent Skills (320 → 180) — *chủ sở hữu skills* (đây là bài bạn nêu ví dụ)

- **GIỮ:** Mục tiêu (sửa 2 gạch: bỏ chữ "plugin") · §1 skill là gì · §3 giải phẫu `SKILL.md` · §4.1 mẫu skill · §7 walkthrough · §8 pitfalls.
- **CẮT/DỜI (đây là ca chính):** §6 "Agent Plugin — khi nào mới đáng" (19 dòng, 18 lượt "plugin") → **dời 17 §4.1**; bài 05 còn **3 dòng**: "Khi nào cần gói nhiều skill+MCP để chia sẻ? Đó là Agent Plugins — xem bài 17." · §5 "custom instructions đặt ở đâu" (31 dòng) → **về 03**, giữ 4 dòng trỏ · §9 bảng Claude Code (17 dòng) → 1 dòng · bảng harness-support dòng 197–208 → còn 3 dòng (`SKILL.md` mọi harness; `.prompt.md` chỉ Local).
- **SỬA:** đường dẫn `.github/skills/` + `~/.copilot/skills/` · frontmatter đúng docs (`name` ≤64 & trùng tên thư mục, `description` ≤1024 *theo VS Code docs*, `user-invocable`, `disable-model-invocation`, `argument-hint`, `context: fork`; `license`/`allowed-tools` *theo docs GitHub*) · invoke `/<skill-name>`; plugin skill bị namespace · migration: tự map `name`/`description`/argument, **gắn `disable-model-invocation: true`**, **mất** `agent`/`model`/`tools`; **bỏ chữ "deprecated"** về prompt files → "chỉ chạy Local harness (VS Code docs), docs GitHub không dùng từ deprecated".
- **NỘP:** 4 dòng `gh skill install/update/publish` (public preview) + cảnh báo "skills không được GitHub verify → đọc trước khi cài".
- **RENAME (✅ đã làm 2026-11-11):** `05-prompt-files-custom-instructions.md` → **`05-agent-skills-reusable-workflows.md`**. Bằng chứng quét thật: **11 chỗ** chứa tên file cũ, trong đó 10 là link/đường dẫn sống (`README.md` gốc 1, `templates/README.md` 1, `01-huong-dan-su-dung/README.md` 2, `00-tong-quan-copilot.md` 1, `commands/system-knowledge/{agent-skill:1, instructions:1, prompt-file:3}`) + 1 dòng lịch sử trong `CHANGELOG.md` (giữ nguyên vì là nhật ký cũ). **CHEATSHEET.md và bài 02/03/04 không chứa tên file** — chỉ chứa *label chữ* ("Bài 05 — Prompt files" ở `02:333`, "Agent Skills & Custom instructions" ở `01/README:23`, "05 — Agent Skills & prompt files" ở `00:347`) → đã sửa 4 label + 3 anchor `bài 05 mục 3.3` → `mục 8` (`templates/README.md:49`, `prompt-file/README.md:5,96`).

### ✅ ĐÃ THỰC HIỆN (bản thử nghiệm 2026-11-11 — làm mẫu cho 17 bài còn lại)

- Rename **đã** `git mv` + sửa **11 chỗ chứa tên file (10 link sống + 1 dòng lịch sử CHANGELOG)** (README gốc, `01/README.md` ×2, `00:347`, `templates/README.md`, `commands/system-knowledge/{agent-skill,instructions,prompt-file}/README.md` ×5). CHEATSHEET/02/03 **không** chứa tên file — chỉ chứa label chữ, đã sửa 4 label ("Bài 05 — Prompt files" → "Agent Skills").
- Anchor cũ "bài 05 **mục 3.3**" (3 chỗ: `templates/README.md:49`, `prompt-file/README.md:5,96`) → **mục 8** (mục port prompt→skill của bản mới).
- Kết quả: **320 → 200 dòng** (đúng đích 150–200, dưới cap 210). 8 mục đánh số 1–8 + Lỗi thường gặp + Bài tập + Link qua + Reference; **0 link tương đối gãy**, 8/8 external link HTTP 200, 0 ký tự CJK, không còn `premium`/`Customizations Hub`/"Copilot coding agent", không còn claim version "VS Code 1.127+" (không có nguồn).
- Cấu trúc đã chốt (dùng làm khuôn): 1 Agent Skill là gì (**kèm bảng 3 mức nạp**) · 2 skill-vs-instructions-vs-agent (kèm ⚠️ `/skills` là Local shortcut) · 3 giải phẫu `SKILL.md` (**kèm bảng frontmatter ghi rõ field thuộc docs nào**) · 4 tạo skill qua Customizations editor + bảng đường dẫn theo harness · 5 gọi skill (matrix `user-invocable`/`disable-model-invocation`) · 6 verify 3 bước · 7 `gh skill` + cảnh báo injection · 8 port `.prompt.md` (mất `agent`/`model`/`tools`).
- Khối đã cắt thật: §5 instructions 31 dòng → 2 dòng + trỏ bài 03; §6 plugin 19 dòng → 1 dòng + trỏ bài 17; bảng Claude Code 17 dòng → 4 gạch ở Link qua + 1 dòng §1; **mẫu `review-pr` 23 dòng → bỏ hẳn** (bài đã có 1 mẫu đầy đủ ở §3, mẫu thứ hai là thủ phạm phình), thay bằng `SKILL.md` mẫu `gen-test` nằm trong `examples/05-agent-skills-reusable-workflows/walkthrough-…sh` (viết lại thành heredoc tự tạo skill + 3 bước verify, 31 dòng).
- Đã sửa luôn: link gãy `09:57` → `../copilot-extensions-ai-powered/README.md` (bảng kiểm ở `05` §3 vốn ghi đúng `../`; hai ghi chú ở `00:22` và `04:165` đã cập nhật thành "đã sửa"). Toàn bộ repo giờ **0 link gãy**.

## 06 — Custom agents & song song (361 → 190) — *chủ sở hữu `.agent.md`*

- **GIỮ:** §1 vì sao · §2 `@workspace` vs agent (sửa: `@workspace` deprecated → "agent tự gather workspace context") · §3 anatomy · §6 patterns song song · §7 pitfalls.
- **SỬA:** field đúng docs: `name`, `description`, `tools`, `model`, `model-policy`, `reasoning-effort`, `skills`, `agents`, `user-invocable`, `disable-model-invocation`, `target` (`vscode`/`github-copilot`), `hooks`, `mcp-servers`, `deferred-tool-loading`, `strict-tools-list`, `include-custom-instructions`; **`handoffs` (số nhiều) = Local only**, `infer` = deprecated; tên file `.github/agents/<NAME>.agent.md` **hoặc `.md`**, user `~/.copilot/agents/`; tool name Local `agent/runSubagent` ⟂ Copilot `task`.
- **CẮT/DỜI:** §4 4 agent mẫu (143 dòng = 40% bài) → giữ **1 mẫu** + 3 khung 5 dòng; **3 file examples mới** `06-4-agent-*.md` · §5 Cách 2 multi cloud-agent (10 dòng) → **về 12** · §6 cost math (AI credits) → trỏ 00/14 · `model: claude-sonnet-5` hard-code → placeholder.
- **NỘP:** subagents theo `agents/run/subagents.md` (1 block 6 dòng) + Customizations editor để tạo agent (`/create-agent` = local agent session).

## 07 — Policies & guardrails (277 → 175) — *chủ sở hữu hooks + exclusion + allowlist*

- **SỬA TOÀN BỘ §1 theo docs GitHub `hooks-reference`:** schema `{"version":1,"hooks":{"PreToolUse":[{"type":"command","command":"…","matcher":"Bash(git *)","timeoutSec":5}]}}` (object keyed by event, **không có field `if`**); tên event: camelCase runtime **hoặc** PascalCase alias — **cả hai chính thức** (docs GitHub), PascalCase còn kích hoạt payload tương thích VS Code; exit `0`=ok, **`2`=deny cho `preToolUse`/`permissionRequest`**, event khác = warning, non-zero khác = fail-open; **`preToolUse` fail-closed nhưng timeout fail-open**; output bounded 10 MiB, `additionalContext` cap 10 KB; 8 lần `block` liên tiếp → CLI tự kết thúc turn; đường dẫn `.github/hooks/*.json` + `~/.copilot/hooks/` + inline trong `.github/copilot/settings.json`; **CLI không còn đọc `~/.copilot/config.json` cho hooks**; `disableAllHooks` không tắt **policy hooks** (`/etc/github-copilot/policy.d/*.json`).
- **SỬA định vị harness:** hooks **không phải "chỉ Local"** — chạy ở **Copilot CLI + Copilot in the cloud** (subset), VS Code = Preview.
- **SỬA §4 `managed-settings.json`:** chỉ giữ key có nguồn: `sandbox.enabled`, `sandbox.failIfUnavailable`, `sandbox.allowBypass`, `enabledPlugins`, `extraKnownMarketplaces`, `strictKnownMarketplaces`, `autoUpdates`; **xoá `autoTier`, `permissions.disableBypassPermissionsMode`, `chat.assistedPermissions.enabled`** hoặc chuyển sang VS Code docs + enterprise policy (`vscode.*`, `ChatEditorPreferCopilotHarness`, verify bằng `Developer: Policy Diagnostics`).
- **SỬA §5 content exclusion:** thêm "có áp dụng cho **Copilot in the cloud** (gồm cloud sandbox) + code review + CLI"; giữ đúng 4 giới hạn docs (not a security boundary / third-party MCP / symlink+remote FS / indirect access); cấu hình bởi **repo admin + org owner** (bỏ chữ "enterprise" tự phát).
- **CẮT/DỜI:** §6 3 recipe pre-commit (34 dòng) → giữ Recipe A, 2 recipe sang `examples/` · §3 lớp 1 (21 dòng, tự nhận trùng 03) → 5 dòng · §7 dòng 211–213 mốc ngày/giá → bỏ.
- **NỘP:** `modifiedArgs` (`preToolUse`) / `modifiedResponse` / `type:"http"` (`COPILOT_HOOK_ALLOW_LOCALHOST=1`) / `type:"prompt"` (chỉ `sessionStart`) — mỗi thứ 1 dòng, vì đây là công cụ enforce mạnh nhất docs nêu.

## 08 — MCP (321 → 185) — *chủ sở hữu MCP*

- **SỬA (đảo mặc định):** Copilot harness = **`.mcp.json` ở root repo** + **`~/.copilot/mcp-config.json`**; `.vscode/mcp.json` (key `servers`) = **Local harness**; `${input:…}` và sandbox per-server **không port sang** → dùng env vars; xoá claim "CLI v1.0.39 BREAKING"; load order docs CLI: `~/.copilot/mcp-config.json` → plugin → `--additional-mcp-config`.
- **SỬA §2 4 nhân vật:** "MCP client nằm trong VS Code Copilot extension" → **"harness spawn client: Copilot = Agent Host, Local = extension host"** (đây là ví dụ điển hình của bệnh 1).
- **SỬA §4/§5:** tên tool `mcp__<server>__<tool>` giữ; approval allow/ask/deny → còn 3 dòng + trỏ **10** (chủ sở hữu matrix).
- **CẮT/DỜI:** §6 5 server day-one (39 dòng) → bảng + **1 file examples** `../01-huong-dan-su-dung/examples/08-mcp-ket-noi-cong-cu-ngoai/mcp-servers-day-one.jsonc` · snippet `db.instructions.md` (10 dòng) → về 03 · §9 dòng 287 lặp 97.
- **NỘP:** **Copilot connectors** (GitHub-managed MCP): *chỉ* cung cấp tool cho Copilot harness, cài qua Customizations editor → Connect, nhãn `Connector: <name>`, Business/Enterprise cần policy **Editor preview features**; 1 dòng "extension-provided tools chỉ chạy khi cửa sổ editor còn kết nối".

## 09 — Extensions & marketplaces (238 → 150) — *bài rewrite nặng nhất vì docs đổi*

- **SỬA:** **Copilot Extensions (GitHub App) đã retired 10/11/2025** → bỏ mọi hướng dẫn "gọi extension bằng `@` trong Chat"; bài mới kể 3 câu chuyện: (1) **VS Code extensions** (cái editor cần để có Copilot + đồ nghề), (2) **Agent Plugins** = đơn vị phân phối customization cho Copilot harness (chỉ 6 dòng + trỏ 17), (3) **marketplace = Git repo chứa `marketplace.json`** (không phải Extension Marketplace); `Ctrl+Shift+X` vẫn đúng cho VS Code extensions.
- **SỬA:** dòng 92–93 dạy kèm `.prompt.md` → đổi `SKILL.md`; **dòng 57 link gãy** → `../copilot-extensions-ai-powered/README.md` (hoặc xoá nếu trang kia cũng nói về Copilot Extensions đã retired — kiểm tra trước).
- **CẮT/DỜI:** §6 org policy allow/block + checklist (32 dòng) → **về 16**, còn 4 dòng · dòng 97 "tự viết Copilot Extension (GitHub App, OAuth, hosting)" → **xoá** (không còn sản phẩm) · §4 pack (15 dòng) → gộp §5 · ẩn dụ nấu cơm (12 dòng) → 4 dòng.
- **GIỮ:** §2 phân biệt 2 loại (viết lại theo trên) · §5 pin version + repo template · §7 hiểu nhầm.

## 10 — Modes, permissions, availability (314 → 200) — *chủ sở hữu permission levels & matrix*

- **GIỮ (đúng docs, chỉ nén):** §4.1–4.2 approval + matrix `deny > ask > allow`, `[] = lockdown`, intersection · §4.3 **Manual / Assisted / Allow all** (chính thức) · §4.4 sandboxing · §6 plans.
- **SỬA:** §2.1 persona Interactive/Plan/Autopilot → **built-in agents Ask / Plan / Agent** + **Autopilot là agent mode** (Copilot) / permission level (Local), `chat.autopilot.advanced.enabled` = Experimental · §2.2 bảng Session Target **thêm Claude + Codex**, sửa Cloud = "execution target chạy **Copilot harness**" · dòng 101–102 "SDK Policy Hooks" → **hooks theo docs GitHub** · dòng 276 "hooks preview, chỉ Local" → **sai, sửa** · §4.4 "MXC" → giữ + dẫn docs.github.com · `chat.editing.autoAcceptDelay` = **Local only** (thêm dòng).
- **CẮT/DỜI:** §3 model picker + AI credits (17 dòng) → 4 dòng trỏ **14** · §5 exclusion/duplication/telemetry (24 dòng) → 3 dòng trỏ **07/13** · §6.1 bảng giá → trả **01/00** (10 giữ khung "plan mở khoá tính năng nào") · block 67–82 (28 dòng) → 8 dòng.
- **NỘP:** 3 harness permission names khác nhau (Copilot: permission levels · Claude: permission modes · Codex: approval presets) — 3 dòng; và "sandbox vẫn chặn kể cả Allow all".

## 11 — Git worktrees & checkpoints (215 → 160)

- **GIỮ:** §1 hai vấn đề ba lớp (mermaid) · §2 3 cơ chế undo · §3 worktrees · §6 Rewind decision table.
- **SỬA:** §2 checkpoints — docs: `chat.checkpoints.enabled` default **on**, **Restore Checkpoint** hover tại request, khôi phục **file + history**, **không** hoàn tác terminal/deploy/dịch vụ ngoài · thêm 1 dòng "fork hội thoại tại checkpoint (`/fork`, `/fork <title>`)".
- **CẮT/DỜI:** §4 branch strategy + flow assign→PR (26 dòng) → **về 12**, giữ 6 dòng quy tắc tên branch `copilot/*` · Pattern C (13 dòng) → 4 dòng · dòng 160 (cloud agent) → 1 dòng · dòng 178 "4 gotchas" → **6**.
- **NỘP:** câu docs: *"worktree không phải security boundary"* — nối với sandbox ở bài 10/16.

## 12 — SDK, CLI, CI/CD (200 → 165) — *chủ sở hữu Copilot CLI + cloud agent*

- **SỬA attribution:** §2.1 đổi "AHP/Copilot SDK" → **VS Code docs** định nghĩa Agent Host + AHP (protocol host↔client); docs GitHub gọi phần lập trình của CLI là **"SDK mode" (`copilot sdk`, `session.startSubagent`, hooks chương trình với `modifiedPrompt`)**; CLI còn có **ACP** (`--acp`, public preview) — **khác AHP**; bỏ bảng version runtime + "npm `@github/copilot-sdk` (verify)" nếu không có nguồn.
- **SỬA CLI:** `--plan` = shorthand `--mode=plan` · `Shift+Tab` xoay standard/plan/autopilot · **Autopilot không dùng được ở untrusted folder** · `--max-ai-credits` = soft cap **lượt tiếp theo**, `--max-session-credits` cho cả phiên, `/limits view|set|reset` · `--allow-all` ≠ `--yolo` (`--yolo` = 4 cờ gộp) · exit `0/1/2` · `--agent=NAME` (theo **tên**, không phải đường dẫn file) · `--disable-client-telemetry` · NỘP các flag docs mà bài thiếu: `--effort/--reasoning-effort`, `--model=auto`, `--available-tools`, `--deny-tool/--allow-tool`, `--deny-paths/--allow-paths`, `--deny-url/--allow-url`, `--output-format`, `--json-port`.
- **SỬA cloud agent:** đổi tên **Copilot cloud agent / Copilot in the cloud**; modes **Interactive (default) / Autopilot**; tool permissions **Assisted (default) / Always ask / Allow all**; environment **Cloud sandbox (default) / GitHub Actions / Remote**; **59 phút chỉ cho Actions-based**; cloud agent đọc repo instructions + skills + **hooks (subset)**; code review đọc từ **head branch**.
- **CẮT/DỜI:** nhận flow từ **11 §4** (+26 dòng, bù bằng cắt §4.1 AHP 6 dòng và dòng 107 GitLab CI) · §6 kinh tế Lite/Balanced → **về 15**, còn 3 dòng · dòng 123 claim "50%" → **về 12 một nơi** (sửa 11 bỏ).
- **NỘI DUNG cloud/:** bài 12 là chủ sở hữu `commands/cloud/*`.

## 13 — Code intelligence, indexing, telemetry (306 → 180)

- **GIỮ:** §2 `@workspace` → viết lại thành **workspace context** (participant deprecated; `#`-mentions + search/language tools) · bảng "Local (Individual) vs GitHub-hosted" là **nơi lưu index**, giữ nguyên (không phải Local harness — ghi chú 1 dòng để khỏi nhầm) · §4 semantic search (nén 4 mẫu → 2) · §6 LSP.
- **CẮT/DỜI:** §7.4 OTel + budget (14 dòng) → **về 10/14**, giữ 3 dòng · §3 exclusion checklist (4 dòng) → trỏ **07** · §8 dòng 263–277 nén.
- **NỘP:** `Chat: Show Memory Files` + Copilot Memory preview (1 block 5 dòng); docs VS Code: telemetry VS Code **tách biệt** xử lý dữ liệu của AI provider; **OTel chạy cho cả Local & Copilot harness** (`monitoring-agents`).

## 14 — Models (291 → 175) — *chủ sở hữu model/AI credits*

- **CẮT/DỜI:** §2 roster model + ngày gỡ (24 dòng, chính file thừa nhận "đổi theo quý") → **3 dòng "tra picker + changelog"** · §3 tier block (15 dòng) → **14 là chủ**, 10 trỏ · §4 bảng giá (8 dòng) → trỏ 01 · §5 BYOK theo surface (bảng 6 dòng) → giữ nhưng ghi nguồn VS Code docs.
- **SỬA:** **AI credits** per-token, 1 credit = $0.01, code completions không trừ, review effort Lite/Balanced/Max, image generation billed riêng, promo có expiry → gắn "as of 11/2026"; BYOK: docs VS Code — inline suggestions & semantic search **vẫn cần Copilot service**; `inlineChat.defaultModel` cho inline chat.
- **GIỮ:** §6 bảng dán tường + phase (nén 8 dòng) · §7 pitfalls · §8 so sánh.

## 15 — Security stack 5 tầng (259 → 170) — *chủ sở hữu kinh tế code review + Rulesets*

- **GIỮ:** §1–§2 bản đồ 5 tầng + mermaid · §4 secret scanning · §5 CodeQL · §6 (15 là chủ: review effort $0.25/$1.50/$10 + Actions minutes + toggle "Use custom instructions when reviewing pull requests" + Rulesets).
- **SỬA/CẮT:** §3 exclusion → 5 dòng trỏ **07** (giữ đúng 4 giới hạn docs) · §7 dòng 196–206 network allowlist → **về 07**, còn 3 dòng · thêm dòng: content exclusion **có** áp dụng cho cloud sandbox.

## 16 — Validate extensions & MCP (291 → 180) — *chủ sở hữu quy trình validate*

- **GIỮ:** §1 vì sao validate · §2 publisher trust · §3 matrix áp vào tool (khung, dẫn **10**) · §5 sandbox · §7 walkthrough 5 bước.
- **SỬA/CẮT:** §4.1 "nơi đặt cấu hình MCP + key `servers`/`mcpServers`" (18 dòng) → **về 08**, 16 còn 3 dòng "pin transport/URL lạ" · bỏ claim "CLI v1.0.39 không đọc `.vscode/mcp.json`", thay bằng "Copilot harness đọc `.mcp.json` + `~/.copilot/mcp-config.json`" · §6.2 org policy → **16 là chủ**, sửa 09 thành pointer · thêm bước validate **plugin**: đọc `plugin.json`/`com.github.copilot/`, inspect source, kiểm `enabledPlugins`+`strictKnownMarketplaces`, ghi rõ "quy trình thực hành — docs không có checklist chuẩn".

## 17 — Agent Customizations editor (357 → 195) — *chủ sở hữu plugin + hub routing*

- **SỬA:** đổi tên bài **"Agent Customizations editor"** (bỏ "hub"), `Chat: Open Customizations`; mỗi card §4.x còn **4 dòng**: là gì · file sống đâu · harness nào · **link bài chủ** (03/05/06/08) — bỏ toàn bộ format chép lại.
- **§4.1 Plugins (17 là chủ):** Agent Plugins = khái niệm chính thức (agent-plugins.org), `plugin.json` 1.0 **schema đóng** (portable: `skills/` + root `mcp.json`; Copilot-specific trong `com.github.copilot/`), `/plugin …` **chỉ Copilot harness**, marketplace = Git repo (`.github/plugin/marketplace.json`), `~/.copilot/installed-plugins/`, `chat.plugins.enabled`, *"distinct from VS Code extensions"*.
- **§4.6 Hooks:** vẫn là chủ sở hữu duy nhất — viết lại theo `07` (docs GitHub).
- **§4.7 Tools:** **bỏ `128 tools/request` + `virtualTools.threshold`** (không nguồn); dạy: Tools tab trong Customizations editor, selection persist theo harness, enabling ≠ auto-approve, `#` để browse tools/context, tool names **phụ thuộc harness**, extension-provided tools cần editor window kết nối.
- **CẮT/DỜI:** §5 Voice/Dictation (15 dòng) → 5 dòng (`feature(voice-mode)` experimental + built-in dictation) · §6 governance (18 dòng) → **về 16** · §7 migrations → 5 dòng (docs **không** có `promptMigration.enabled` mặc định true; xoá "Waza").
- **NỘP + FIX:** bài duy nhất không có ví dụ → thêm **2 file examples** `../01-huong-dan-su-dung/examples/17-agent-customizations-hub/open-customizations-editor.sh`, `../01-huong-dan-su-dung/examples/05-agent-skills-reusable-workflows/plugin-marketplace.sh` + walkthrough 8 bước nén còn 14 dòng.
