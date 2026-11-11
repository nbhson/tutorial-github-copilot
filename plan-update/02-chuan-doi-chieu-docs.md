# 02 — Chuẩn đối chiếu docs (rules chỉnh cho mọi bài và mọi lệnh)

File này là **luật biên tập**. Khi file `03`/`04` nói "cắt đoạn này", căn cứ nằm ở đây. Nguồn: `code.visualstudio.com/docs` — bản `.md` sạch, fetch trực tiếp ngày 10/11/2026; trang cheat sheet có `ms.date = 11/4/2026`.

> **Tóm gọn 1 câu:** Mọi khẳng định trong khoá học phải rơi vào 1 trong 3 ô: (A) docs VS Code nói đúng như vậy → giữ + dẫn URL; (B) docs nói khác → sửa theo docs; (C) docs VS Code không nói → hoặc dẫn `docs.github.com` (nếu thuộc Copilot CLI/coding agent/org settings), hoặc cắt.

## 1. Taxonomy harness — dùng đúng 4 từ, không tự chế

| Thuật ngữ | Docs định nghĩa | Khoá học được phép dạy gì |
|---|---|---|
| **agent harness** | "coordinates the language model, context, and tools that an agent uses to complete your task" — `docs/agents/concepts/agent-harnesses.md` | khái niệm nền, dạy ở bài 00 + 02 |
| **Local harness** | harness **legacy**, chạy trong *extension host* của editor; **không có trong Agents window**; đóng cửa sổ editor là agent dừng; có Ask/**Edit**/Agent modes; đọc `*.prompt.md`, participants, tool sets, `${input:}` MCP, `chat.editing.autoAcceptDelay` | chỉ dạy để so sánh (bài 02/10/17) và cho `commands/local/` |
| **Copilot harness** | chạy trong **Agent Host** bằng **Copilot SDK**; runtime chung VS Code + Copilot CLI + Copilot app; session chạy nền, tiếp nối giữa các surface; built-in agents **Ask / Plan / Agent**; sandbox + permission levels enforce được | **mặc định dạy của cả khoá** |
| **provider harness** | **Claude** (Anthropic) và **Codex** (OpenAI) — harness thật, hiện trong picker; bị chặn khi org bật enterprise-managed settings | nhắc 1 dòng ở bài 02/10 |
| **Cloud** | **không phải harness** — là *execution target* chạy Copilot harness trên hạ tầng managed của GitHub (`cloud-sandbox-sessions.md`, `feature(cloud-sessions)`); coding agent trên github.com là sản phẩm nền tảng | dồn vào `commands/cloud/` + bài 12 |
| **Agent Host** | "a dedicated process that runs agent harnesses and manages their sessions"; `code agent host`, `--tunnel` | khái niệm, bài 12/17 |
| **AHP (Agent Host Protocol)** | giao thức **host ↔ client** (JSON-RPC, open spec `microsoft.github.io/agent-host-protocol`) — **không phải tên của Copilot harness** | sửa câu chữ bài 12, giữ khái niệm |
| **Session Target / Choose a harness** | picker chọn harness + execution target; docs gọi là "Choose an agent harness" (`agent-harnesses#choose-a-session-target`) | bài 02 §3.1 + `commands/copilot/model-agent/session-target` |

**Cấm dùng:** "Session Target: Local/Copilot/Cloud" (thiếu Claude/Codex), "harness = VS Code", "Local = chạy offline trên máy tôi" (docs FAQ: *"the Local harness is not Copilot CLI"*, model vẫn chạy remote).

## 2. Slash commands — bảng chính thức (nguồn duy nhất: `docs/agents/reference/ai-features-cheat-sheet.md`)

Docs ghi nguyên văn: *"Type `/` to see commands available in the current session. Availability depends on the chat surface, harness, role, and enabled features."*

| Lệnh | Mục đích (docs) | Availability trong docs |
|---|---|---|
| `/plan` | research + propose plan | Copilot & Claude (Local có **Plan agent**) |
| `/explain`, `/fix`, `/tests` | giải thích / sửa / sinh test | bảng chat reference; nhóm "editor" |
| `/doc` | docstring | **từ editor inline chat** |
| `/setupTests` | chọn test framework | Experimental |
| `/new`, `/newNotebook` | **scaffold a workspace, file, or notebook** (KHÔNG phải "mở chat mới") | chat reference |
| `/compact` | nén ngữ cảnh hội thoại | Local, Copilot, Claude |
| `/fork`, `/fork <title>`, `/fork prompt <...>` | fork hội thoại kèm history | cần **Agent Host session** được hỗ trợ |
| `/clear` | **mở chat mới** + archive/mark done chat hiện tại | chat reference |
| `/rename <name>`, `/help` | đổi tên / liệt kê lệnh+agent | **"a local chat" / "a local Ask chat"** |
| `/models`, `/tools` | mở model picker / cấu hình tools | **"a local chat"** |
| `/init` | sinh/cập nhật workspace instructions | **"a local agent session"** |
| `/agents` `/instructions` `/skills` `/prompts` `/hooks` | cấu hình customization type | Chat view: **Local có tất cả; Copilot chỉ có `/prompts` và `/hooks`** |
| `/create-agent`, `/create-instructions`, `/create-skill`, `/create-prompt`, `/create-hook` | sinh customization | "in a local agent session" |
| `/troubleshoot` | phân tích debug logs | local **hoặc Copilot CLI session** |
| `/debug` | mở Chat Debug view | Chat view, **không phải Agents window** |
| `/sandbox policy` | xem effective sandbox policy | **Copilot session** |
| `/<name>` | gọi **agent skill** hoặc reusable prompt by name | mọi harness (skill) — vd `/webapp-testing` |
| `/plugin list\|install\|update\|enable\|disable\|uninstall\|marketplace add\|browse\|update\|remove` | quản lý Agent Plugins | **chỉ Copilot harness session** |
| `/yolo`, `/autoApprove`, `/disableYolo`, `/disableAutoApprove` | permission/Autopilot | "supported local or Copilot CLI session" |
| `/btw <question>` | side chat | **không có ở Local** & Codex-extension |
| `/chronicle:standup\|tips\|cost-tips\|search <q>\|reindex` | Chronicle | docs sessions |

**Kết luận biên tập quan trọng nhất:** ở **Copilot harness**, `skills` / `instructions` / `agents` **không quản lý bằng slash command** trong Chat view — mà bằng **Agent Customizations editor** (`Chat: Open Customizations`). Khoá học đang dạy `/instructions`, `/skills`, `/agents` như lệnh chính → phải (a) gắn nhãn "Local harness" hoặc (b) viết lại thành "mở Customizations editor".

**Bị docs VS Code phủ nhận (sửa hoặc cắt):** `/summarize` → `/compact` · `/history` `/export` `/resume` → panel Session History + `Chat: Export Chat…` + **Resume in Terminal** · `@workspace`/`@terminal` → **"Chat participants (deprecated)… not supported in the Copilot harness"**.

**Nhầm chủ sở hữu tài liệu (docs VS Code không có, docs GitHub có → giữ nhưng đổi nguồn & gắn nhãn surface):** `MXC` (GitHub: `about-local-sandboxing`) · `/permissions`, `/limits`, `/sandbox [config|status|policy|enable|disable|ca]`, `/settings --repo|--local`, `/plugin`, `/computer` (GitHub: `cli-command-reference`) · `--plan`, `--mode autopilot`, `--autopilot[=REVIEW|FULL]`, `--max-ai-credits` (**soft cap cho lượt tiếp theo**, không phải cả phiên — cap cả phiên là `--max-session-credits`), `Shift+Tab`, exit code `0/1/2`, `-p` headless, `~/.copilot/settings.json`, `.github/copilot/settings.json`, `~/.copilot/mcp-config.json`.
**Cả hai nguồn đều không có → cắt hoặc ghi "kinh nghiệm thực hành":** `128 tools/request`, `virtualTools.threshold`, `Waza`, `/delegate`, `/policy`, `/customAgent`, `"premium session"`, policy `"instruction enforcement"`, auto-select `−10%`, audit retention `180 ngày`, ngày "CLI GA 03/2026", `Copilot CLI v1.0.39 BREAKING`, multiplier `×13` cho code review.

## 3. Phím tắt chính thức (render từ `dynamic-keybinding`, cheat sheet 11/4/2026)

| Hành động | macOS | Windows/Linux | Lệnh |
|---|---|---|---|
| Mở Chat view | `⌃⌘I` | **`Ctrl+Alt+I`** | `workbench.action.chat.open` |
| Chat mới | `⌘N` | `Ctrl+N` | `workbench.action.chat.newChat` |
| Inline chat trong editor | `⌘I` | **`Ctrl+I`** | `inlineChat.start` |
| Inline chat trong terminal | `⌘I` | `Ctrl+I` | `workbench.action.terminal.chat.start` |
| **Quick Chat** | `⇧⌥⌘L` | **`Ctrl+Shift+Alt+L`** | `workbench.action.quickchat.toggle` |
| Accept / dismiss suggestion | `Tab` / `Esc` | `Tab` / `Esc` | — |

→ Ba biến thể `Shift+Alt+I`, `Ctrl+Shift+I` trong repo đều **sai**; `Ctrl+Alt+I` là **Chat view**, không phải Quick Chat. Thay toàn bộ bằng bảng này (`commands/local/quick-chat`, `local/shortcuts`, `commands/README.md`, bài 02/04/06, CHEATSHEET).

## 4. Customization × harness (nguồn: `docs/agent-customization/*` + `migrate-customizations.md`)

| Customization | Copilot harness | Local harness | Đường dẫn chính thức |
|---|---|---|---|
| **Agent Skills** | ✅ (chuẩn mở agentskills.io) | ✅ (đọc thêm `.claude/skills`, `.agents/skills`) | project `.github/skills/`, user `~/.copilot/skills/`; gọi `/<skill-name>`, plugin skill bị namespace `/plugin:skill` |
| **Agent Skills — frontmatter** | docs **GitHub**: `name`, `description`, **`license`**, **`allowed-tools`** (kèm cảnh báo chỉ pre-approve shell khi đã review — risk prompt injection). docs **VS Code**: `name` (≤64, chỉ a-z 0-9 `-`, **BẮT BUỘC trùng tên thư mục cha**; ký tự sai/namespace prefix → *"silently fail to load"*). docs **GitHub** nói nhẹ hơn: *"typically matches the name of the skill's directory"* → khi dạy hãy dùng chữ VS Code (chặt hơn), `description` (≤1024), `argument-hint`, `user-invocable`, `disable-model-invocation`, `context: fork` | như Copilot | mọi field đều có nguồn → **khi dạy phải ghi trường nào thuộc trang nào**; `description ≤1024` là **VS Code docs**, không phải luật GitHub |
| **Agent Skills — progressive loading** | ✅ docs VS Code "How Copilot uses skills": **(1) discovery** chỉ `name`+`description` của mọi skill được đưa vào đầu session → **(2) instructions** thân `SKILL.md` nạp khi prompt khớp description hoặc gọi `/<skill>` → **(3) resources** chỉ file được reference trong body; file không được nhắc tới **không bao giờ nạp** | như Copilot | đây là lý do "cài 20 skill không nặng"; cũng là lý do `description` phải có từ khoá user thật nói — **bài 05 đã dạy bảng 3 mức** |
| **Agent Skills — `context: fork` tiền điều kiện** | cần feature `forked-skill-context` + setting `github.copilot.chat.skillTool.enabled`; chạy trong subagent riêng, chỉ trả kết quả cuối | docs VS Code ghi `context` kèm nhãn `feature(forked-skill-context)`; **không có cột "chỉ Local"** trong docs | dạy kèm điều kiện bật (`forked-skill-context` + `github.copilot.chat.skillTool.enabled`), nếu không learner hỏi "sao không thấy" |
| **Agent Skills — không có biến nội suy** | docs **không** khai báo `${input}`/`${workspaceFolder}`/`$ARGUMENTS` cho `SKILL.md`; `argument-hint` chỉ là **gợi ý hiển thị**. Truyền thêm dữ liệu = viết tự do sau `/skill <text>` | như Copilot | `${input:}` là cú pháp **MCP input config / tasks.json** — hết sức tránh dạy nhầm (bản cũ của bài 05 có, đã bỏ) |
| **Agent Skills — `#file:` & path** | docs VS Code: reference file bằng link markdown hoặc `#file:` với đường dẫn **tương đối tới `SKILL.md`**; dùng `/` (Unix) để port; `~` trỏ home user | như Copilot | đây là cơ chế duy nhất để mức 3 (resources) nạp — body không nhắc tới file thì file chết |
| **Agent Skills — verify 3 bước** | docs VS Code: (1) gõ `/` thấy skill trong menu? (2) gọi tay `/<skill>` việc nhỏ, xem tool activity; (3) test **tự nạp** tách riêng bằng câu khớp description — **menu liệt kê ≠ agent sẽ chọn** (discovery không đảm bảo selection) | như Copilot | dedup theo `name`, first-loaded wins → nếu skill không hiện: sai `name`/tên thư mục hoặc đặt ở đường dẫn harness đó không đọc |
| **Agent Skills — Copilot code review** | docs GitHub: skill tên thư mục **`code-review`** được code review chắc chắn đọc; skill trong `.github/skills/` nhìn chung được dùng khi relevant | — | câu này nên có 1 dòng ở bài 05 (bản rewrite đã có) |
| **Agent Skills — đường dẫn** | project `.github/skills` → `.agents/skills` → `.claude/skills` → plugin → `COPILOT_SKILLS_DIRS`; personal `~/.copilot/skills`, `~/.agents/skills`; cloud sandbox `.copilot/skills` (dotfiles, **không áp dụng cho GitHub Actions sessions**) | như Copilot | docs GitHub: *"Supported locations depend on the surface"* → **không có bảng universal**; docs VS Code: trùng `name` giữa các **workspace root** thì **root chính thắng**; `~/.claude/skills` (user-level) **không có** trong load-order docs GitHub |
| **`gh skill`** | ✓ **public preview**, cần GitHub CLI ≥ 2.90.0: `search / preview / install OWNER/REPO [SKILL] [@TAG] [--pin] [--agent HOST --scope user\|project] / update --all / publish --dry-run --fix` | — | kèm provenance metadata ghi vào frontmatter + cảnh báo *"Skills are not verified by GitHub"* → bài 05 nên có 4 dòng |
| **Agent Skills — nguồn discovery trong editor** | docs VS Code: **Customizations editor → Browse → GitHub Feed** (*experimental*), tìm theo `@type:skill`; nguyên văn: *"The experimental GitHub Feed requires a harness that provides marketplace search. Local sessions don't provide this source, and organization policy can restrict access."* | ❌ GitHub Feed | bài nào dạy "mở chợ cài skill" phải gắn nhãn Copilot-harness-only (bản rewrite bài 05 đã ghi) |
| **Agent Skills — `chat.agentSkillsLocations`** | **deprecated**; VS Code chỉ *forward* cho harness khác khi chạy trong editor — **client độc lập (CLI/app) không kế** | còn chạy ở Local | dạy "move vào native folder", đừng dạy thêm custom location setting |
| **Prompt files** | ❌ *"Prompt files run only in Local harness sessions in the Chat view"*; migrate: Copilot *"do not load `*.prompt.md`"* nhưng *"remain supported"* ở Local | ✅ | `.github/prompts/*.prompt.md` |
| **Instructions** | ✅ | ✅ | `.github/copilot-instructions.md` **hoặc `AGENTS.md`**; rules `.github/instructions/*.instructions.md` + **`applyTo`**; user `~/.copilot/instructions` |
| **Instructions — thứ tự nạp** | docs GitHub: *Personal > Repository > Org*, **nhưng** nguyên văn *"all sets of relevant instructions are provided to Copilot"* → **cả ba đều được nạp**, thứ tự chỉ phân xử khi mâu thuẫn. docs VS Code: *"combination rules differ by harness"* → **không có universal precedence** | như trái | **sửa bài 03**: bỏ luật "file cao nhất thắng / hierarchy 1 bảng", thay bằng "cái nào cũng vào context; khi mâu thuẫn thì Personal thắng" |
| **Instructions — path-specific** | ✓ **chỉ** Copilot cloud agent + Copilot code review trên GitHub.com (*"only supported for…"*); org instructions **có** chạy cho chat on GitHub.com | ✓ editor | `excludeAgent: "code-review" \| "cloud-agent"` là field **chính thức**; code review đọc instructions **từ head branch**, không phải base |
| **`AGENTS.md` / `CLAUDE.md` / `GEMINI.md`** | `AGENTS.md` đặt bất kỳ đâu trong repo, **nearest wins**; `CLAUDE.md` **hoặc** `GEMINI.md` là **thay thế hợp lệ** cho 1 file ở root | ✓ | sửa chỗ nào trong repo đang nói "CLAUDE.md/GEMINI.md không được hỗ trợ" |
| **Copilot Memory** | cloud-backed; docs 11/2026 **bỏ nhãn public preview** — khả dụng cho mọi plan trả phí, VS Code bật mặc định (`chat.copilot.memory.enabled`); surface dùng được: cloud agent, code review, CLI, app, Mobile, Slack, Teams; bản experimental repo-local `chat.copilot.memory.local.enabled` → `.github/copilot-memories.jsonl` | Local memory files | **không tự convert**; hết hạn: docs GitHub 90 ngày mặc định (org chỉnh 7–180) · docs VS Code ghi 28 ngày — dạy cả hai kèm nguồn; "quên cái này" chỉ downvote, xoá thật phải làm trên GitHub |
| **Custom agents** | ✅ | ✅ (`.vscode/agents` legacy, user agents nằm trong **profile storage** → phải migrate) | `.github/agents/<NAME>.agent.md` **hoặc `.md`**; user `~/.copilot/agents/` |
| **Hooks** | ✅ **chạy cả trên Copilot in the cloud** (subset events, sandbox ephemeral) — docs GitHub ghi *"Hooks are supported in two Copilot surfaces: Copilot CLI and Copilot in the cloud"*. Ở VS Code: **Preview** | ⚠️ không auto-convert sang harness khác | `.github/hooks/*.json` + `~/.copilot/hooks/`; schema `{"version":1,"hooks":{"<Event>":[{"type","bash\|powershell\|command","matcher","timeoutSec"}]}}` — object keyed by event, lọc bằng **`matcher`** (regex), **không phải** `if` |
| **MCP servers** | ✅ | ✅ | Copilot: **`.mcp.json`** (root) + `~/.copilot/mcp-config.json`; Local: `.vscode/mcp.json` (key `servers`); `${input:}` **không port sang** |
| **Agent Plugins** | ✅ **chỉ Copilot harness** (`chat.plugins.enabled`, marketplace = Git repo, cài vào `~/.copilot/installed-plugins/<MARKETPLACE>/<PLUGIN>`, cache `~/Library/Caches/copilot/marketplaces/`) — docs VS Code: *"Agent plugins are **distinct from VS Code extensions**"* | ❌ | **Agent Plugins 1.0 = schema ĐÓNG**: portable chỉ `skills/` + root `mcp.json`; agents / hooks / commands / rules / LSP phải vào namespace **`com.github.copilot/`**. Field lạ → *"Unknown top-level fields are reported and ignored"*; schema không hỗ trợ → **reject cả plugin**. Dạng `plugin.json` khai `agents/skills/hooks/mcpServers` = **legacy format** (manifest legacy tìm ở `.plugin/plugin.json`, `plugin.json`, `.github/plugin/plugin.json`, `.claude-plugin/plugin.json`) |
| **Plugin marketplace & quản lý** | ✅ `/plugin list\|install\|update\|enable\|disable\|uninstall\|marketplace add\|browse\|update\|remove [--force]` **chỉ trong Copilot harness session**; `copilot plugin install` nhận `plugin@marketplace` \| `OWNER/REPO` \| `OWNER/REPO:PATH` \| git URL \| local path; pin bằng `@TAG`/`sha` (**`--ref` là flag của `gh skill`, không phải plugin**) | ❌ | `marketplace.json` đặt tại **`.github/plugin/`** (docs CLI nguyên văn); `awesome-copilot` = built-in **không remove được**; **`copilot-plugins` KHÔNG còn built-in** → phải `copilot plugin marketplace add github/copilot-plugins`; enterprise quản bằng managed settings `enabledPlugins` + `extraKnownMarketplaces` + `strictKnownMarketplaces` (badge "Managed"); auto-update mỗi session, tắt bằng `COPILOT_AUTO_UPDATE=false` |
| **Copilot Extensions (GitHub App, gọi bằng `@`)** | ❌ **deprecated 24/09/2025 → retired 10/11/2025**; docs GitHub 11/2026 **không còn trang** này; VS Code docs cũng không liên hệ nó với connectors | ❌ | **rewrite bài 09 + slug `extensions` + CHEATSHEET**: đường mở rộng hiện hành = **Agent Plugins + MCP servers + Copilot connectors**. Lưu ý `/extensions` trong **CLI** = quản lý **CLI extensions (JS modules, experimental)**, **không phải** Copilot Extensions → đừng dạy lẫn |
| **Copilot connectors** (GitHub-managed MCP) | ✅ **chỉ Copilot harness** — *"Connectors provide tools to the Copilot harness, not Local harness sessions"* | ❌ | Browse → Copilot Connectors → Connect; hiện trong MCP Servers với nhãn `Connector: <name>` |
| **Chat participants** (`@…`) | ❌ **deprecated, not supported** | ⚠️ còn chạy | docs bảo thay bằng agent + context/tools |
| **User-defined tool sets** | ❌ **deprecated** ("Replace tool sets") | ⚠️ | — |
| **`#reader`-style aliases** | ❌ mất khi migrate | ✅ | — |
| **Memory** | Copilot Memory (cloud-backed default) | Local memory files | **không tự convert** |
| **Checkpoints** | `chat.checkpoints.enabled` (default **on**), **Restore Checkpoint**; khôi phục file + history, **không** hoàn tác terminal/deploy | ✅ | `agents/run/review-code-edits.md` (docs **không** công bố bảng harness-support cho checkpoints) |
| **Sandboxing** | ✅ **Preview** macOS/Linux/WSL2, **Experimental** Windows; `chat.agent.sandbox.enabled` = `off` (default)/`on`; `/sandbox policy` in effective policy **kể cả khi sandbox tắt** | ⚠️ chỉ sandbox lệnh terminal, **không enforce** managed permission/sandbox rules | VS Code `agents/run/agent-sandboxing.md` + GitHub `about-local-sandboxing`: powered by **MXC (Microsoft eXecution Container)**; per-OS: macOS ≥15 Seatbelt / Linux-WSL2 bubblewrap+slirp4netns+iptables / Win11 BaseContainer; Alpine-musl & WSL1 ✗; managed: `sandbox.enabled`, `sandbox.failIfUnavailable`, `sandbox.allowBypass`; CLI `/sandbox [config\|status\|policy\|enable\|disable\|ca]`. Docs: *"A Git worktree separates code changes, but **is not a security boundary**"* |

## 5. Permission & modes — chốt một lần

- **Permission levels (Copilot harness): `Manual permissions` (default) · `Assisted permissions` · `Allow all`** — đúng như bài 10 đang dạy ✓ (nguồn `agents/run/approvals.md#permission-levels`).
- **Autopilot = agent mode** (mode picker), **không phải permission level**; ở Local mới là permission level. Autopilot auto-approve mọi tool, retry lỗi, tự trả lời câu hỏi chặn tiến trình, **tiêu tốn AI credits như chat thường**. `chat.autopilot.advanced.enabled` = Advanced Autopilot (Experimental).
- **Ask / Plan / Agent = built-in agents** (không phải "persona"); **Edit** là mode riêng của Local.
- Countdown auto-accept `chat.editing.autoAcceptDelay` = **Local only**.
- Claude harness dùng *permission modes* (Edit automatically / Request approval / Plan); Codex dùng *approval presets* (Default Permissions / Auto-Review / Full Access) → bài 10 chỉ được nhắc 1 dòng.

## 6. migrate Local → Copilot (`agents/run/move-to-copilot.md`) — xương sống cho bài mới/02/10/17

**Được thêm:** sandbox + permission enforcement, assisted permissions, Copilot Fusion, session chạy nền khi đóng editor window, tiếp nối Chat view ↔ Agents window ↔ máy khác (remote), cloud sandbox sessions, connectors, canvases, managed distribution (admin bắt buộc plugin/skill/hook).
**Phải migrate (không tự động):** prompt files → convert skills (tự map `name`/`description`/argument, gắn `disable-model-invocation: true`, **mất** `agent`/`model`/`tools`); agents/instructions trong profile storage → `~/.copilot/...`; hooks đổi event + payload; MCP `${input:}`/`${command:}` + sandbox per-server → env vars; tool sets + participants → tools/skills/plugins; memory files.
**Verify sau migrate:** chạy 1 task đại diện + `Developer: Policy Diagnostics` + `/sandbox policy`. File gốc và file migrate **không sync nhau**.
**Fallback khi org chưa cho:** `vscode.temporaryDefaultToLocalHarness: true` (≥1.142), `vscode.temporaryAllowLocalHarness: false` (≥1.143); user settings `chat.defaultToCopilotHarness`, `chat.editor.preferCopilotHarness`, `chat.editor.localAgent.enabled`.

## 7. Tiền & plan — chốt theo docs GitHub `reference/copilot-billing/models-and-pricing`

| Repo đang dạy | Docs 11/2026 | Việc |
|---|---|---|
| "premium requests" (tên slug `premium-requests`, nhiều bảng) | **legacy** từ 01/06/2026; hiện hành **GitHub AI Credits**, **1 credit = $0.01**, billing **per-token** (bảng per-million-token) | đổi tên slug + toàn bộ tiêu đề bảng |
| Plans Free / Pro / Pro+ | **4 plan cá nhân: Free / Pro / Pro+ / Max** | thêm Max vào bài 01/10 |
| Code completions trừ credits | *"Code completions and next edit suggestions **are not billed in AI credits**… unlimited for all paid plans"* | sửa bài 00/13 |
| Code review **×13 multiplier** | multiplier chỉ còn cho **annual Pro/Pro+ chưa migrate**; hiện hành = **review effort Lite / Balanced / Max ≈ $0.25 / $1.50 / $10 mỗi review** + GitHub Actions minutes | sửa bài 10/12/15 (bỏ 13x, dùng effort table) |
| "auto model selection giảm 10%" | **không có trong docs** | cắt |
| "`premium session`" | **chưa từng là thuật ngữ** | cắt |
| `--max-ai-credits` cap **cả phiên** | **soft cap cho lượt tiếp theo**; cap cả phiên = `--max-session-credits`; resume bằng `/limits` | sửa bài 12 + `examples/` CLI |
| Mốc ngày/giá ("+50% nhanh hơn 19/03/2026", "Effort Balanced từ 28/09/2026", "Max $100 + base/flex") | docs không nêu | cắt hoặc gắn "as of 11/2026" + URL changelog |
| Budget | cơ chế chính thức: **Bundled AI credits budget** + *"Stop usage when budget limit is reached"*, đặt $0 | bài 13/14 dùng đúng tên |
| Image generation | billed **riêng** (bảng riêng) | thêm 1 dòng ở bài 14 |

## 8. Chủ sở hữu tài liệu: VS Code docs ⟂ GitHub docs

**Ranh giới phải ghi đúng** (bài 12 và 17 đang gán sai):

| Nội dung | Nguồn **duy nhất** được phép dẫn | Ghi chú |
|---|---|---|
| Harness, Agent Host, **AHP**, Chat view/Agents window, customizations editor, slash trong Chat, permission levels VS Code, sandbox VS Code, checkpoints, memory | `code.visualstudio.com/docs` | AHP là **giao thức host↔client của Microsoft** (`microsoft.github.io/agent-host-protocol`) — **docs GitHub không document AHP** → bài 12 phải đổi attribution |
| Copilot **CLI** flags/slash/plugins-marketplace, **cloud agent / Copilot in the cloud**, code review, content exclusion, audit log events, org policies + supported surfaces, AI credits/giá, skills trên GitHub.com, repo/org instructions | `docs.github.com/en/copilot/*` | CLI có **ACP** (`--acp`, public preview) — **ACP ≠ AHP**, đừng lẫn |
| `gh copilot suggest/explain` | **không có ở cả hai** (docs VS Code không có; GitHub docs không document extension `gh copilot`) → dạy như **GitHub CLI extension của cộng đồng**, không dẫn "docs nói vậy" | |

**Ba khẳng định phải đổi vì docs GitHub đã trả lời:**
1. **`Copilot coding agent` → `Copilot cloud agent` / `Copilot in the cloud`** (tên 11/2026, `supported-surfaces-for-policies`). Kèm: **59 phút** chỉ áp dụng cho cloud agent session chạy bằng **GitHub Actions minutes**, không áp dụng cloud sandbox.
2. **Hooks KHÔNG "chỉ Local"** — chạy ở **Copilot CLI + Copilot in the cloud** (subset event; `notification` không fire; `permissionRequest` vô hiệu; `preToolUse` `"ask"` → `"deny"`; chỉ `.github/hooks/*.json` trong repo; chỉ `bash`/`command`). Docs GitHub cũng hỗ trợ **PascalCase alias** → bài 07/10/17 sửa cả hai chiều.
3. **Content exclusion CÓ áp dụng cho Copilot in the cloud (gồm cloud sandbox)** + code review + CLI → sửa khẳng định "cloud agent/sandbox không bị ảnh hưởng" ở bài 07/15; giữ đúng giới hạn docs: *"not a filesystem security boundary"*, không đảm bảo với **third-party MCP**, symlink, remote filesystem, indirect access.

**Vẫn chưa có nguồn → cắt hoặc ghi "thực hành, không phải docs":** Copilot Memory cho cloud agent · quy trình "verify plugin" 5 bước · `audit retention 180 ngày` · policy `instruction enforcement` · `copilot_usage_limit_reached` · ngày GA CLI · `~/.copilot/org-customizations/` · `~/.claude/skills` (user-level).

## 9. Luật biên tập áp dụng cho file `03` và `04`

1. **Một khái niệm — một bài chủ** (ownership map ở file `01` mục 3). Nơi khác tối đa 3 dòng + link.
2. **Không dạy cái docs không có.** Nếu không chỉ được URL → cắt, không để "có lẽ/preview" trừu tượng.
3. **Không có universal precedence cho instructions.** VS Code: *"combination rules differ by harness"*. GitHub: Personal > Repository > Org **nhưng "all sets of relevant instructions are provided to Copilot"**, repo-wide + path-specific dùng đồng thời ("the instructions from both files are used"). → bài 03 bỏ bảng "thuật tử thắng", dạy "cả ba đều vào context; Personal phân xử khi mâu thuẫn; kiểm chứng bằng References / Agent Customizations editor".
4. **Mọi ví dụ copy-paste phải thuộc Copilot harness**: `.mcp.json` (root) + `~/.copilot/mcp-config.json`, `~/.copilot/skills/`, `SKILL.md`, `AGENTS.md`, hooks `{"version":1,"hooks":{"<Event>":[{matcher,…}]}}` (PascalCase **hoặc** camelCase — cả hai chính thức). Ví dụ Local chỉ trong block "⚠️ khác biệt Local harness" ≤6 dòng ở 4 bài overview.
5. **Format "Mục tiêu bài học" giữ nguyên** (blockquote meta → `## Mục tiêu bài học` → Mục lục) cho 18/18 bài; chỉ siết số gạch cho khớp nội dung còn lại.
6. **Đích 150–200 dòng/bài** (README nhóm lệnh giữ ~65; README lệnh giữ ~90–105). Vượt 220 → phải cắt hoặc dời.
7. `STYLE.md` vẫn là luật (3 lớp, "vì sao quan trọng", "nếu làm sai", ❌/✅, best practices kèm vì sao); **sửa rule 300–450 dòng trong `CONTRIBUTING.md`** — đây là gốc bệnh phình.
