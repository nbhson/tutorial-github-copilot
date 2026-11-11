# 01 — Hiện trạng & bệnh (kết quả investigate, chưa sửa gì)

File này ghi lại **bằng chứng đo được** về 3 bệnh bạn nêu, để mỗi quyết định cắt/gọt trong plan có gốc. Nguồn số liệu: script đo trên `01-huong-dan-su-dung/` + audit tay từng file + đối chiếu `code.visualstudio.com/docs` (11/2026).

> **Tóm gọn 1 câu:** Bệnh không phải "viết sai chính tả" mà là 3 thứ: khoá học lấy **Local harness làm mặc định** khi dạy, **một block nội dung bị nhân bản 2–4 nơi**, và **thuật ngữ không có trong docs gốc** — cả ba đều sửa được bằng cắt + đổi chủ sở hữu, không phải viết thêm.

## 1. Số nền (baseline để đo tiến bộ sau khi sửa)

| Chỉ số | Hiện tại | Ghi chú |
|---|---|---|
| Bài học trong `01-huong-dan-su-dung/` | 18 bài + README, **5.460 dòng** | trung bình **303 dòng/bài**; dài nhất 361 (bài 06), ngắn nhất 200 (bài 12) |
|README nhóm | 67 dòng | index, giữ nguyên độ dài |
| Lệnh trong `commands/` | **47 slug**, README lệnh **4.619 dòng** (TB ~98), + 4 README nhóm + `commands/README.md` | 4 nhóm: chat-session 12, model-agent 10, code-actions 10, system-knowledge 15 |
| `examples/` của bài học | 77 file (55 `.sh`, 11 `.jsonc`, 6 `.json`, 4 `.yaml`, 1 `.ts`) | 80 link `](examples/...)` từ các bài, **tất cả đều trúng file thật** |
| Link tương đối bên trong `commands/` | **237 chỗ `](../`trên 52 file** | move thêm 1 cấp là lệch toàn bộ → phải sửa bằng script |
| Link tới `commands/<nhóm>/<slug>` từ ngoài | **47 link** (bài 04 = 45, `01-huong-dan-su-dung/README.md` = 2) + **5 chỗ text** (CHANGELOG 3, README gốc 1, CONTRIBUTING 1) | mọi chỗ phải chèn `<bucket>/` |
| Link gãy hiện tại | **1/663** (`09-…md` dòng 57) | `../../copilot-extensions-ai-powered/README.md` thiếu 1 cấp `..` → phải là `../copilot-extensions-ai-powered/README.md` |
| Rule độ dài trong `CONTRIBUTING.md` | bài **300–450 dòng**, lệnh 60–200 | **chính rule này là nguyên nhân cấu trúc của bệnh "quá dài"** — sửa bài mà không sửa rule thì lần sau lại phình |

## 2. Bệnh 1 — Khoá học mặc định dạy Local harness, không phải Copilot harness

Docs gốc (11/2026) nói rõ: **Local = "legacy editor harness"**, chạy trong *extension host*, không có trong Agents window, đóng cửa sổ editor là agent dừng việc. **Copilot = harness chạy trong Agent Host bằng Copilot SDK**, runtime chung cho VS Code + Copilot CLI + Copilot app, session chạy nền và tiếp tục được giữa các interface. Docs kết luận: *"Start with **Copilot** for day-to-day coding and agent tasks."*

Vậy mà toàn bộ course đang lấy Local làm chuẩn vô thức:

| Bằng chứng | Vị trí | Hệ quả khi người học theo |
|---|---|---|
| "VS Code (**harness**) mới là cái mở file, chạy lệnh" — mô tả extension host, không phải Copilot harness | `00` dòng 94 | học viên tưởng VS Code = harness duy nhất |
| MCP đặt ở **`.vscode/mcp.json`** là chuẩn | `08` dòng 72–108, `README` dòng 26 | Copilot harness **không đọc file này** — nó đọc `.mcp.json` ở root repo + `~/.copilot/mcp-config.json`. Làm theo là MCP không hiện ra |
| `*.prompt.md` + `/prompts` được dạy như cách làm việc | `05` dòng 7, 199–208; `commands/system-knowledge/prompt-file` | Copilot harness **không load prompt files** — chỉ Local. Muốn chạy Copilot phải convert sang `SKILL.md` |
| `@workspace`, `@terminal` và participants nói là cách gắn context | `04`, `13`, `commands/code-actions/debug-terminal` | **Chat participants đã deprecated và không được Copilot harness hỗ trợ** (docs: "Replace chat participants") |
| Hook events `PreToolUse`/`PostToolUse`, `.github/hooks`, nói "preview, chỉ Local" | `07` dòng 21, 27; `10` dòng 276 | **Phần đúng:** PascalCase được docs GitHub hỗ trợ chính thức (alias của tên camelCase, và kích hoạt payload tương thích VS Code). **Phần sai:** (a) `10:276` nói hooks "chỉ Local" — docs GitHub: *"Hooks are supported in two Copilot surfaces: Copilot CLI and Copilot in the cloud"* (subset event, sandbox ephemeral, chỉ `.github/hooks/*.json` trong repo); (b) schema trong `07` dùng `hooks: [...]` + field lọc `if` — docs dùng **object keyed by event** `{"version":1,"hooks":{"PreToolUse":[{matcher,…}]}}`, lọc bằng **`matcher`**; (c) `~/.copilot/config.json` **không còn** đọc hooks (chuyển sang `settings.json`); (d) ba nơi vẫn mâu thuẫn nhau (`10:102` vs `10:276` vs `17:188`) |
| "MCP client nằm trong VS Code Copilot extension" | `08` dòng 47–48, 62 | sai framing: harness nào spawn client quyết định tool/permission |
| Tool sets, `#reader`, `chat.hookFilesLocations`… | `17` dòng 200–223 | **tool sets deprecated, không hỗ trợ ở Copilot harness** |
| `commands/` 22 slug đầu tiên (chat-session + code-actions) | **0/22 README có một chữ về harness** | người học không biết lệnh nào chạy được khi Session Target = Copilot |

Mật độ từ khoá Local/Cloud/harness (số dòng chứa, đã loại false-positive bằng tay — xem `*`):

| Bài | Dòng | Local | Cloud | harness | ST | Ghi chú |
|---|---|---|---|---|---|---|
| 02 (bề mặt — **được phép** so sánh) | 341 | 37 | 34 | 4 | 11 | dày nhất nhưng đúng vai; vẫn phải nén |
| 10 (modes — **được phép**, nhưng quá dài) | 314 | 11 | 5 | 5 | 4 | §2.1 persona 28 dòng + §2.2 thiếu 2 target = bệnh |
| 17 (hub — **được phép**, nhưng phình) | 357 | 13 | 5 | 21 | 4 | plugin 26 dòng, card §4.x chép lại bài khác |
| 11 | 215 | 11* | 6 | 0 | 0 | "Local" ở đây = worktree/máy bạn; **Cloud 6 dòng thật** (coding agent) |
| 05 | 320 | 7 | 4 | 4 | 0 | chủ yếu nằm ở bảng harness-support 197–208 |
| 16 | 291 | 9* | 1 | 0 | 0 | `*` = local-install/local-settings, không phải Local harness |
| 09, 13, 14, 15 | — | * | 0–1 | 0 | 0 | **sạch**, không cần động vào vì harness |
| 00, 01, 03, 04, 06, 07, 08, 12 | — | 1–11 | 0–5 | 0–2 | 0 | rải rác, có chủ đích (07 dạy hooks) |

→ **Kết luận:** không phải "cắt Local/Cloud khắp nơi". Việc phải làm là (a) **đảo mặc định dạy sang Copilot harness** ở 05/08/07/04/13/17 (đường dẫn file, hook events, participants), (b) **nén 3 bài overview** (02, 10, 17) còn phần so sánh tối đa, (c) **dời 2 cụm Cloud-thật** (coding agent flow ở `11 §4`, multi-cloud-agent ở `06 §5`) về bài 12.

## 3. Bệnh 2 — "Một block, bốn nhà": map nội dung trùng (đây là lý do bài dài)

Đây là phát hiện lớn nhất về mặt cấu trúc: độ dài phình không do giải thích dài, mà do **cùng một block được chép ở nhiều bài**. Mỗi bản chép là một nguy cơ lệch thông tin (đã lệch thật — xem cột phải).

| Block trùng | Nằm ở | Chủ sở hữu đề xuất | Lệch đã xảy ra |
|---|---|---|---|
| Bảng giá plans / trial | `00 §4.1` ≡ `01 §2.1` (gần 100%), lặp lại ở `04`, `10 §6.1` ≡ `14 §4` | **01** (bài cài đặt) | `10` và `14` copy từng chữ → đổi giá là hỏng 4 nơi |
| AI Credits: 1 credit = $0.01, auto-selection −10% | `00 §4.2`, `01`, `06 §6` dòng 304–309, `10 §3`, `13 §7.4`, `14 §4` | **00** (khái niệm) + **14** (chọn model) | tier block `10:116–118` ≡ `14:104–118` |
| Walkthrough "mở Chat → tóm tắt repo → lưu instructions" | `00 §6` ≡ `01 §6.3` | **01** | hai bài cùng dạy một thao tác |
| Cây hỏi "chọn chế độ nào" | `00 §1.1` ≡ `02 §2` | **00** | |
| Bảng "So sánh với Claude Code" | có ở **00, 03, 04, 05** (+ mọi lệnh) | **00** cho khái niệm; bài khác chỉ 1 dòng trỏ | STYLE bắt mỗi file ≥1 bảng → cần rule mới để khỏi thành bệnh |
| Sơ đồ instructions/skill/agent/plugin | `05 §2` ≡ `17 §3` | **17** (hub) | `05` tự nhận là bài về skills nhưng vẽ cả plugin |
| SKILL.md frontmatter, `.github/skills/` | `05 §3` ≡ `17 §4.3` | **05** | |
| `copilot-instructions.md` + `applyTo` | `03 §2` ≡ `05 §5` ≡ `17 §4.4` | **03** | `05` dòng 185 tự thừa nhận "cú pháp đã ở bài 03" |
| `.agent.md` frontmatter | `06 §3` ≡ `17 §4.5` | **06** | `17:180` tự ghi "chi tiết bài 06" |
| Vị trí file MCP + key `servers` vs `mcpServers` | `08 §3` ≡ `16 §4.1` ≡ `17 §4.2` | **08** | 3 bản, 2 bản nói khác nhau về `.vscode/mcp.json` |
| Content exclusion: danh sách paths | `07 §5` ≡ `10 §5` ≡ `13 §3` ≡ `15 §3` | **07** | 4 nơi |
| `deny > ask > allow`, "ask không bypass", `[] = lockdown` | `08 §5` ≡ `10 §4.2` ≡ `16 §3.1` | **10** | |
| Network allowlist (domain githubcopilot/collector/ghe) | `07` dòng 124 ≡ `15` dòng 196–206 | **07** | |
| Kinh tế code review Lite/Balanced + Rulesets | `10` ≡ `12 §6` ≡ `15 §6` | **15** | claim "Effort Balanced từ 28/09/2026" ở 3 nơi |
| Flow coding agent assign→PR + "nhanh hơn 50% (19/03/2026)" | `11 §4` dòng 115 ≡ `12 §5` dòng 123 | **12** | nguyên văn cả claim ngày/giá |
| Org policy allow/block + review extension | `09 §6` (157–186) ≡ `16 §2–§6` | **16** | `09` là bản rút gọn của `16` |
| Migrate prompt→skill | `05 §4.3` ≡ `17 §7` | **05** | |
| 4 agent mẫu inline | `06 §4` = **143 dòng = 40% cả bài** | đổi sang `examples/` | |
| Bảng 12/10 lệnh ở `commands/<nhóm>/README.md` | ≡ `commands/README.md` (sai thứ tự một chút) | nhóm giữ bảng, index giữ routing | CHANGELOG đã lệch số: ghi "code-actions 9" (thực tế 10) |

Ước lượng: **~900–1.100 dòng** trong 5.460 dòng là nội dung trùng hoặc chép lại. Cắt phần trùng + trả về bài chủ sở hữu, *chưa cần cắt gì khác*, đã đưa các bài về gần target.

## 4. Bệnh 3 — Lan man & thuật ngữ không có trong docs gốc

**(a) Lan man kiểu "vượt rào bài" (dù bài không có chủ đề đó):**

| Bài | Nội dung vượt rào | Nên ở |
|---|---|---|
| 05 (skills) | §6 Agent Plugin **18 lượt "plugin"/16 dòng** + bảng extension/plugin §2/§5 + "cần bán/phân phối → Extension marketplace" | 17 (hub) + 09/16 |
| 05 | §5 "custom instructions đặt ở đâu" (2 bảng, lặp bài 03) | 03 |
| 01 (cài đặt) | §5 Copilot CLI tự nhận "chi tiết bài 02", persona Interactive/Plan/Autopilot | 02/10 |
| 06 (custom agents) | §5 Cách 2 "multi coding-agent sessions (cloud)", §6 cost math | 12, 14 |
| 11 (worktrees) | §4 branch strategy + flow assign→PR của coding agent | 12 |
| 12 (SDK/CI) | §2.1 "AHP (Agent Host Protocol)" + bảng version runtime + "npm `@github/copilot-sdk` (verify tên)" | **AHP là thuật ngữ chính thức** (docs/agents/concepts/agent-host) nhưng nó là **giao thức host↔client**, không phải tên Copilot harness → sửa cách diễn đạt, không cắt; bảng version runtime + tên package: cắt nếu không verify được |
| 16 | §4.1 "nơi đặt cấu hình MCP" (kiến thức setup) | 08 |
| 17 | §5 Voice/Dictation 15 dòng cho 2 card phụ; §4.1–4.5 chép format bài khác | 05/06/08/13; hub còn routing |
| 09 | dòng 97 "khi nào tự viết Copilot Extension (GitHub App, manifest, OAuth, hosting)" | 16 / off-scope |
| 04 | §7 plan/model gating (lặp 00/01) | 01/14 |

**(b) Mật độ cao nhất của "thuật ngữ không đối chiếu được với docs" (tập trung ở bài 10, 12, 17 — xem file `02` để biết docs nói gì):**

**Phân loại theo mức độ khớp docs** (đã đối chiếu trực tiếp `code.visualstudio.com/docs`, trang cheat sheet đề ngày 11/4/2026):

| Nhóm | Thuật ngữ đang dạy | Docs chính thức nói gì |
|---|---|---|
| **SAI tên — đổi là xong** | `Agent Customizations Hub` | **Agent Customizations editor**, mở bằng `Chat: Open Customizations` |
| | `premium requests` | **AI credits** (1 credit = $0.01, per-token) — docs GitHub `models-and-pricing` xác nhận; request-based + multiplier chỉ còn là **legacy** cho annual Pro/Pro+ chưa migrate. Thêm 3 sự thật docs mà repo đang thiếu: plan **Max** có thật, **code completions & next edit suggestions không trừ credits**, chi phí cloud sandbox/Actions tính **đường riêng** |
| | `handoff:` trong frontmatter `.agent.md` | field đúng là **`handoffs`** và **chỉ Local**; `target: vscode \| github-copilot` **có thật** ✓ |
| **KHÔNG TÌM THẤY trong docs VS Code — nhưng docs GitHub CÓ, phải đổi chủ nguồn** | `MXC` | docs GitHub `about-local-sandboxing`: local sandboxing **powered by Microsoft eXecution Container (MXC)** → giữ, nhưng dẫn docs.github.com |
| | `/permissions`, `/limits`, `/sandbox`, `/settings`, `/plugin`, `/computer` | docs GitHub `reference/copilot-cli-reference/cli-command-reference` → giữ, **gắn nhãn "Copilot CLI"**, không dẫn VS Code docs |
| **KHÔNG TÌM THẤY ở CẢ HAI nguồn — cắt hoặc ghi rõ "kinh nghiệm thực hành"** | `128 tools/request`, `virtualTools.threshold`, `chat.assistedPermissions.enabled`, `promptMigration.enabled`, `Waza`, `/delegate`, `/policy`, `/customAgent`, `/summarize`, `/history`, `/export`, `/resume`, `/usage`, `/status`, `/login`, `/logout`, `/feedback`, `/bug`, `/commit`, `/pr`, `/diff`, `/review`, `/optimize`, `/refactor`, `/mcp`, `/extensions` (slash Chat) · `"premium session"` · policy `"instruction enforcement"` · auto-select `−10%` · audit retention `180 ngày` · `CLI GA 03/2026` · `Copilot CLI v1.0.39 BREAKING` · multiplier `×13` (chỉ trang legacy) | docs VS Code dùng `Chat: Export Chat…`, **`/compact`**, `/fork`, `/rename`, `/models`, `/tools`, `/init`, `/plan`, `/troubleshoot`, `/debug`, `/sandbox policy`, `/yolo`, `/autoApprove`; billing hiện hành = **AI credits** + **review effort Lite/Balanced/Max**, không còn multiplier |
| **KHÔNG SAI như nghi ban đầu — giữ, chỉ sửa ngữ cảnh** | `AHP` | có thật: **Agent Host Protocol** là giao thức JSON-RPC host↔client, spec `microsoft.github.io/agent-host-protocol`. Nhưng **AHP ≠ Copilot harness** → sửa câu chữ, đừng xoá |
| | `Manual / Assisted / Allow all` | **đúng nguyên văn** docs `agents/run/approvals.md#permission-levels` → giữ |
| | `Autopilot` | **có thật nhưng là agent mode** ở Copilot harness (Local mới là permission level) → sửa vị trí phân loại |
| | Interactive/Plan personas | docs gọi là **built-in agents Ask / Plan / Agent** (không phải "persona") → đổi từ, giữ nội dung; **Edit là mode riêng của Local** |

Ba chỗ tự mâu thuẫn ngay trong repo (đã chốt được bằng docs):
- **Phím tắt — cả 3 biến thể trong repo đều sai.** Docs (cheat sheet 11/4/2026, render `dynamic-keybinding`): mở Chat view = **⌃⌘I** (macOS) / **Ctrl+Alt+I** (Win-Linux) · chat mới = **⌘N / Ctrl+N** · inline chat trong editor = **⌘I / Ctrl+I** · inline chat trong terminal = **⌘I / Ctrl+I** (cùng phím, khác ngữ cảnh) · **Quick Chat = ⇧⌥⌘L / Ctrl+Shift+Alt+L**. Vậy `Shift+Alt+I` (`quick-chat`, `commands/README` D27) và `Ctrl+Shift+I` (`shortcuts` D32) đều sai; `Ctrl+Alt+I` đúng nhưng bị gán nhầm cho "Chat view đầy đủ" ở `shortcuts` D33 thì lại… đúng một phần. Chốt theo bảng docs.
- **Hooks:** `10:102` (Agent Host nạp "SDK Policy Hooks") vs `10:276` ("preview, **chỉ Local**") vs `17:188`. Docs GitHub `hooks-reference`: **cả hai tên event đều chính thức** — camelCase runtime (`preToolUse`, `agentStop`) và PascalCase alias (`PreToolUse`, …, alias kích hoạt payload tương thích VS Code); schema là **object keyed by event** `{"version":1,"hooks":{"<Event>":[{matcher,…}]}}`, lọc bằng `matcher` **không phải** `if`; `migrate-customizations.md`: hooks **không tự convert**. ⇒ `10:276` **sai** (hooks chạy ở CLI + cloud), `07` sai format, `17:188` đúng một vế.
- **`.vscode/mcp.json`:** `README:26` + `08` coi là chuẩn ⟂ `16:146` + `17:140` nói Copilot/CLI không đọc. Docs: Copilot harness đọc **`.mcp.json`** (root repo) + **`~/.copilot/mcp-config.json`**; `${input:…}` và sandbox per-server **không port sang** → `08` đổi mặc định sang `.mcp.json`, `.vscode/mcp.json` xuất hiện như đường dẫn Local.

**(c) Lỗi nhỏ thấy rõ khi đo (tiện thể sửa):**
- `04` dòng 222 và 224 **hai dòng đúp nguyên văn**; §6/§8 dùng `/diff`, `/review`, `/agent`, `/customAgent`, `/policy` không có trong index "toàn tập" của chính bài.
- `README` dòng 22 hứa "index ~**70** slash commands/participants" — bài 04 thực tế liệt kê ~32 slash + 5 participant; con số 70 không có ở đâu.
- `README` dòng 30 gọi công cụ ở bài 12 là "**gh copilot CLI**" — bài 12 dạy binary **`copilot`** độc lập; `gh copilot suggest/explain` là extension của GitHub CLI, hai thứ khác nhau.
- `README` dòng 59 gán "profile `sandbox`" cho bài 17 — nội dung đó ở bài 16.
- `README` dòng 28 và 57 liệt kê Session Target "Local/Copilot/Cloud" — thiếu Claude/Codex (docs có 5; chính bài 02 dòng 143 đã nêu đủ 5).
- `11` dòng 178 ghi "**4 gotchas**" nhưng bảng có 6 hàng.
- `09` dòng 57 link gãy (1/663 của cả folder).
- `commands/code-actions/fix/README.md` dòng 3 thiếu mục **Vấn đề:** — lệch khuôn STYLE mà CONTRIBUTING gọi là "file vàng" để bắt chước.
- `17` là bài **duy nhất** trong series không có một link `examples/` nào.

## 5. Cái đang làm tốt — phải giữ nguyên (đừng nhân cơ hội mà phá)

1. **`## Mục tiêu bài học`** ở cả 18 bài — bạn nói rất thích: giữ format, giữ vị trí (sau blockquote meta, trước Mục lục), chỉ siết lại 2–4 gạch cho khớp nội dung còn lại sau khi cắt.
2. **Khuôn 13 mục của README lệnh** (`STYLE.md` §4): 22/22 file đang theo đúng khuôn, và examples đặt tên rất nhất quán (`01-cach-goi-copy-paste.sh`, `02-vi-du-that.sh`, `03/04-neu-lam-sai-thi-sao-sai-ung.sh`) → giữ nguyên 100%, move folder không đụng examples.
3. **Chỉ số link sức khoẻ:** 663 link tương đối, 1 gãy. `examples/` và `commands/` đều khớp tên file thật.
4. Bài **13, 14, 15 gần như sạch** (không lẫn harness, chỉ trùng block) → chỉ cần trừ phần trùng, không viết lại.
5. Bài **02 §3.1** mô tả Session Target gần đúng docs nhất series (Local = extension host, Copilot = Agent Host + Copilot SDK, chạy nền, Claude/Codex có mặt) → **chọn làm đoạn chuẩn** để trích dẫn thống nhất toàn khoá, chỉ sửa 1 ý: Cloud *là* Copilot harness trên hạ tầng managed.
6. `STYLE.md` §6 "Giữ nguyên (không phá)" và checklist §7 — giữ làm luật biên tập, chỉ sửa rule độ dài ở `CONTRIBUTING.md` (300–450 → 150–200).
