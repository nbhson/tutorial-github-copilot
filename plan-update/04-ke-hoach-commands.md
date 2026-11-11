# 04 — Kế hoạch tái cấu trúc `commands/` (47 slug → 3 bucket)

## 1. Tiêu chí chia bucket (áp dụng máy móc, không cảm tính)

Xét **hành động chính mà README lệnh yêu cầu người học làm** (mục "Cách gọi"), không xét chủ đề:

| Bucket | Khi nào |
|---|---|
| **`copilot/`** | Hành động đó thực hiện được trong **Copilot harness session** (Chat view mặc định / Agents window / Copilot CLI) |
| **`local/`** | Hành động đó **cần Local harness**: `*.prompt.md`, mode `Edit`, Chat-view slash mà docs gắn "in a local … chat", `.vscode/mcp.json`, `gh copilot` extension (chạy trong shell, không phải harness nào) |
| **`cloud/`** | Hành động đó **đặt lệnh trên GitHub.com** (cloud agent, org/repo settings, Enterprise KB) |
| **Tie-breaker** | Hành động **harness-agnostic** (mở Chat view, cài VS Code extension, bấm phím) → `copilot/`, vì course mặc định dạy Copilot |
| **Xoá** | Hành động **không còn tồn tại** (`Copilot Extensions` retired 10/11/2025) |

**Hệ quả phải chấp nhận:** `copilot/` sẽ chiếm ~75% và `local/` chỉ ~8 slug. Đây là **đúng yêu cầu** ("khoá học chỉ dạy Copilot harness"), không phải mất cân đối cần sửa.

**Vùng xám (5 slug — đã duyệt theo tiêu chí trên, 10/11/2026;** chỉ đảo nếu 5 câu verify ở `05` §0b cho kết quả khác):

| Slug | Đề xuất | Lý do & rủi ro |
|---|---|---|
| `model-agent/session-target` | **copilot/** | bảng harness có cả Local/Claude/Codex — nhưng đây là *lệnh chọn harness*, thuộc kỹ năng dùng Copilot. Nếu bạn muốn mọi thứ "về harness" nằm `local/` thì đổi |
| `model-agent/model-picker` | **copilot/** | model picker chạy ở cả hai; docs VS Code đặt nó trong trang chat-view của Copilot |
| `system-knowledge/agent-skill` | **copilot/** | `SKILL.md` dùng được cả hai harness; chỉ slash `/skills` là Local → bài sẽ dạy bằng **Agent Customizations editor** |
| `system-knowledge/mcp`, `mcp-add` | **copilot/** | MCP server chạy trong Copilot harness (docs: `.mcp.json`); README hiện tại **dạy sai file** `.vscode/mcp.json` → sửa nội dung, không đổi bucket. Bản `.vscode/mcp.json` sẽ có slug riêng ở `local/` |
| `model-agent/premium-requests` → `ai-credits` | **copilot/** | thao tác chính là mở `github.com/settings/copilot` (= cloud). Chọn copilot/ vì ngữ cảnh là "tiêu phí của session Chat/CLI"; cloud/README sẽ link sang |

## 2. Bảng phân loại 47 slug (bằng chứng = dòng đo thật trong README)

Ký hiệu docs: **✅** docs nói đúng như README · **⚠️** README có chi tiết docs không nêu · **❌** docs phủ nhận.

### `chat-session` (12)

| Slug | Bucket | Bằng chứng (dòng README) | Docs | Việc chính |
|---|---|---|---|---|
| `attachments` | copilot | D34 bảng `@workspace` · D41 gõ `#` | ⚠️ | bỏ mọi `@participant`; giữ `#`-mentions/kéo-thả |
| `checkpoints` | copilot | `Chat: Open Checkpoints…`, Restore | ✅ | ghi `chat.checkpoints.enabled` default on; **không** hoàn tác terminal/deploy |
| `clear` | copilot | `/clear` | ✅ | `/clear` = mở chat mới + archive chat hiện tại (docs) — README đang chỉ nói "xoá ngữ cảnh" |
| `export` | **local** | `Chat: Export Chat…` | ⚠️ | docs không xác nhận cho Copilot session → verify W0 #1, nếu được thì về copilot/ |
| `help` | **local** | `/help` liệt kê slash+participant+agent | ❌ | docs: *"in a local Ask chat"* → gắn nhãn Local + trỏ Customizations editor cho Copilot |
| `history` | copilot | panel Session History | ✅ | xoá slash `/history` (không tồn tại) |
| `inline-chat` | copilot | `Ctrl+I` editor/terminal | ✅ | đổi `Cmd+I` → `Ctrl+I`; thêm `chat.editor.interaction` |
| `new-chat` | copilot | `Ctrl+N`, `/new` | ⚠️ | docs: `/new` = **scaffold workspace/file/notebook** ≠ chat mới → tách nghĩa |
| `quick-chat` | copilot | D1 `Shift+Alt+I` | ⚠️ | phím **sai**: `Ctrl+Shift+Alt+L` (macOS `⇧⌥⌘L`); thêm "surface Chat view, verify không có trong Agents window" |
| `resume` | copilot | `/resume` | ❌ | VS Code không có slash này → Session History + **Resume in Terminal** + CLI `copilot --continue` |
| `shortcuts` | copilot | D32 `Ctrl+Shift+I` | ❌ | thay bằng bảng 6 dòng docs (file `02` §3) |
| `summarize` | copilot → **`compact`** | `/summarize` | ❌ | **rename slug** → `/compact` (docs: Local, Copilot, Claude) |

### `model-agent` (10)

| Slug | Bucket | Bằng chứng | Docs | Việc chính |
|---|---|---|---|---|
| `agent-mode` | copilot | Agent mode mặc định | ✅ | bỏ `handoff:` (field đúng `handoffs`, Local only) |
| `ask-mode` | copilot | D85 `#file`/`@workspace` | ⚠️ | Ask là **built-in agent của Copilot harness**; sửa table "so sánh Claude"; bỏ `@workspace` |
| `edit-mode` | **local** | multi-edit `Edit` | ✅ | docs: Edit là **mode của Local** → gắn nhãn + "Copilot thay bằng Agent/Plan" |
| `coding-agent-assign` | **cloud** | D1 "Coding agent assign", D62 "issue là prompt" | ✅ | đổi tên **Copilot cloud agent**; thêm agents panel, MCP cho cloud agent |
| `coding-agent-pr` | **cloud** | D3 "review PR do coding agent mở" | ✅ | idem + `copilot-instructions.md`, `excludeAgent`, effort Lite/Balanced |
| `custom-agent` | copilot | `.github/agents/*.agent.md` | ✅ | `/create-agent` là *local agent session* → dạy mở **Customizations editor**; tool `task` vs `runSubagent` |
| `model-picker` | copilot | picker + `models.json` | ⚠️ | gắn nhãn `/models` (local chat) vs `/model` (CLI); bỏ hard-code tên model |
| `policy-approval` | copilot | D85 `.vscode/settings.json` + org | ✅ | giữ **Manual/Assisted/Allow all**; thêm `[] = lockdown`, intersection, `--available-tools` |
| `premium-requests` | copilot → **`ai-credits`** | D33/75/92 dashboard github.com | ❌ | **rename** + đổi thuật ngữ (1 credit = $0.01, per-token, Max plan, review effort) |
| `session-target` | copilot | D1 "Chọn harness", D64 "Không thấy Copilot/Cloud" | ✅ | bảng phải đủ Local/Copilot/Claude/Codex + Cloud = **execution target** |

### `code-actions` (10 → 10 copilot, không có bằng chứng Local)

| Slug | Docs | Việc chính |
|---|---|---|
| `explain` | ✅ | giữ; bỏ `@workspace` ở phần "hỏi xuyên repo" |
| `doc` | ✅ | ghi rõ: từ **editor inline chat** |
| `tests` | ⚠️ | `@workspace/test-agent` → agent `.github/agents/` + CLI `--agent` |
| `fix` | ⚠️ | bỏ `@workspace`; `/fix` có trong chat reference nhưng **không** phải slash được đảm bảo ở mọi surface |
| `debug-terminal` | ❌ | **viết lại**: docs = terminal inline chat (`Ctrl+I`), không phải `@terminal` participant |
| `optimize` | ⚠️ | không có slash `/optimize` → inline chat + `Ctrl+Alt+P` command palette |
| `refactor` | ⚠️ | idem (lightbulb → Refactor) |
| `commit-message` | ✅ | `Chat: Commit All/Staged` đúng; **xoá** "Copilot chat in GitHub web UI (Preview)" |
| `pr-desc` | ✅ | `Pull: Create PR from Workspace Changes` ✓; bỏ web-UI claim |
| `new` | ❌ | docs: `/new` = **scaffold workspace/file/notebook** — viết lại toàn bài (hiện dạy "mở chat mới", trùng `new-chat`) |

### `system-knowledge` (15 → 9 copilot, 3 local, 2 cloud, 1 xoá)

| Slug | Bucket | Bằng chứng | Docs | Việc chính |
|---|---|---|---|---|
| `agent-skill` | copilot | D93 secret trong skill | ✅ | `.github/skills/` + `~/.copilot/skills/`; `SKILL.md`; `/skills` slash = Local → Customizations editor |
| `bug-feedback` | copilot | `/bug`, `/feedback` | ❌ | VS Code: `Chat: Provide Feedback`; GitHub: issue/`gh`; bỏ `/usage` `--max-ai-credits` ở D80 |
| `cli-explain` | **local** | D1 `gh copilot explain`, D9 tự nhận "gh extension" | ⚠️ | không phải Copilot harness → `local/`; đổi "chat participants (`@workspace`)" → `#`-mentions |
| `cli-suggest` | **local** | idem | ⚠️ | idem |
| `content-exclusion` | **cloud** | D34 "github.com → Org/Repo Settings" | ✅ | thêm: **có** áp dụng Copilot in the cloud + code review + CLI; 4 giới hạn docs; D94 bỏ `@workspace` |
| `extensions` | ❌ **XOÁ** | D69/80/87 extension pack + `.vscode/extensions.json` | 🔴 | Copilot Extensions retired → nội dung về bài 09 rewrite + slug mới `plugins`; giữ 6 dòng historical note |
| `instructions` | copilot | D18 link `prompt-file` | ✅ | sửa precedence (không có "file cao nhất thắng"); xoá `~/.copilot/org-customizations/`; `excludeAgent` |
| `knowledge-base` | **cloud** | KB GitHub Enterprise | ✅ | ghi rõ chỉ Enterprise/GitHub.com; thêm MCP cho tài liệu nội bộ |
| `login` | copilot | `copilot login` | ✅ | giữ (docs CLI); đổi "Bypass với `/status`" ở examples |
| `logout` | copilot | `copilot logout` | ✅ | gộp, ≤70 dòng |
| `mcp` | copilot | D78 `.vscode/mcp.json`, D25 `MCP add` | ✅ | **sửa file mặc định** → `.mcp.json` + `~/.copilot/mcp-config.json`; `/mcp` slash không có trong docs VS Code → `copilot mcp list`; connectors chỉ Copilot |
| `mcp-add` | copilot | D47 verify token trong `.vscode/mcp.json` | ⚠️ | idem; `timeout` 60s (không 30s), `cwd` (không `workingDir`), `${input:}` **không port sang Copilot** |
| `prompt-file` | **local** | D26 "`/prompts` (legacy)" | ✅ | docs GitHub **không** dùng chữ deprecated → "chỉ chạy ở Local harness"; path dẫn sang skill |
| `status` | copilot | `/status` | ✅(CLI) | docs GitHub có `/status` trong **CLI** → gắn nhãn "Copilot CLI", VS Code = status dashboard |
| `telemetry` | copilot | `/usage`, `COPILOT_OTEL_*` | ⚠️ | `/usage` → CLI `/cost`; OTel chạy cho **cả** Local & Copilot (docs VS Code `monitoring-agents`) |

**Tổng: copilot 36 · local 6 · cloud 4 · xoá 1 = 47.** Kiểm tra: `chat-session` 10+2 · `model-agent` 7+1+2 · `code-actions` 10 · `system-knowledge` 9+3+2+1.
Sau khi thêm 9 slug (mục 3) và 2 rename → **copilot 42 · local 8 · cloud 5 = 55 slug**.

## 3. 9 slug mới — ✅ đã duyệt cả P1 + P2 (mỗi cái phải có URL docs, không có nguồn thì không tạo)

| P | Slug mới | Lệnh | Nguồn docs | Vì sao course cần |
|---|---|---|---|---|
| **P1** | `copilot/code-actions/plan` | `/plan` | cheat sheet VS Code | docs Liệt kê, course im lặng — Plan là workflow chính |
| **P1** | `copilot/system-knowledge/plugins` | `/plugin list\|install\|update\|enable\|disable\|uninstall\|marketplace add`, `copilot plugin install` | VS Code `agent-plugins.md` + GitHub `cli-plugin-reference` | thay chỗ `extensions` đã retired |
| **P1** *(bổ sung 11/11)* | `copilot/system-knowledge/hooks` | `/hooks` (Chat view Copilot + Local); hook file `.github/hooks/*.json` | VS Code `agent-customization/hooks` + `agents/reference/hooks-reference` | bài 04/07 link `/hooks` nhưng plan 04 ban đầu thiếu slug này |
| *(bổ sung 11/11)* | `cloud/system-knowledge/audit-log` | audit log agentic (`actor:Copilot`, fields `action`/`actor_is_agent`/`agent_session_id`/`user`, 180 ngày; streamed usage records public preview) | GitHub `reference/enterprise-administrators/agentic-audit-log-events` + `how-tos/.../review-audit-logs` | folder bị một agent xoá giữa chừng, đã dựng lại; **đích cuối: copilot 43 · local 8 · cloud 6 = 57 slug** |
| **P1** | `copilot/model-agent/sandbox-policy` | `/sandbox policy`, `chat.agent.sandbox.enabled`, `sandbox.failIfUnavailable` | VS Code `agent-sandboxing.md` + GitHub `about-local-sandboxing` | enforce thật mà course chỉ nói ở bài 10/16 dạng văn xuôi |
| **P1** | `cloud/model-agent/cloud-agent-session` | cloud agent modes Interactive/Autopilot · tool permissions Assisted/Always ask/Allow all · environment Cloud sandbox/GitHub Actions/Remote | docs GitHub | 4 slug cloud đang thiếu "lệnh mẹ" |
| **P1** | *(rename)* `copilot/chat-session/compact` | `/compact` | cheat sheet | thay `summarize` |
| **P2** | `copilot/chat-session/fork` | `/fork`, `/fork <title>`, `/fork prompt <…>` | cheat sheet (cần Agent Host session) | checkpoint-branching mà 11 không dạy |
| **P2** | `copilot/chat-session/troubleshoot` | `/troubleshoot` | cheat sheet (local hoặc CLI) | thay cho 10 dòng advice tự chế |
| **P2** | `copilot/system-knowledge/connector` | Copilot connectors | VS Code customizations | "Connectors provide tools to the Copilot harness, not Local" |
| **P2** | `local/model-agent/participants` | `@workspace`, `@terminal`, `@vscode` | docs: **deprecated, not supported in Copilot harness** | học sinh cũ cần 1 trang "vì sao không còn chạy" |
| **P2** | `local/system-knowledge/vscode-mcp-json` | `.vscode/mcp.json` (key `servers`) + `${input:}` | docs migrate: Copilot **không đọc** | tách phần Local ra khỏi `mcp`/`mcp-add` |

**Không tạo slug** cho: `/yolo`, `/autoApprove`, `/history`, `/export`, `/summarize`, `/usage`, `/mcp`, `/extensions`, `/review-pr`, `/create-demo`, `harness:`, `handoff:`, `target: github-copilot` — đã verify **0 nguồn** ở cả hai bộ docs.

## 4. Cấu trúc đích + index

```
commands/
├── README.md              ← viết lại: bảng 55 slug theo harness + cột "Nguồn docs"
├── bucket.tsv             ← nguồn cho script move (slug TAB group TAB bucket)
├── copilot/
│   ├── README.md          (42 slug)  index + "đây là mặc định của khoá học"
│   ├── chat-session/ …    model-agent/ …    code-actions/ …    system-knowledge/ …
├── local/
│   ├── README.md          (8 slug)   mở đầu: "vùng tham khảo — 4 bài overview mới được trích, ≤6 dòng"
│   └── chat-session/ model-agent/ system-knowledge/
└── cloud/
    ├── README.md          (5 slug)   mở đầu: "Cloud KHÔNG phải harness — execution target chạy Copilot harness"
    └── model-agent/ system-knowledge/
```

- Mỗi slug giữ nguyên `README.md` + `examples/`; **không** đụng tên file examples (trừ 2 slug rename).
- **Hệ quả ít thấy:** 4 group README hiện tại → **9 group README** (`copilot` 4 nhóm, `local` 3, `cloud` 2), vì mỗi slug footer `../README.md` phải trỏ vào index nhóm **của bucket đó** (nếu không, 12 footer gãy ngay ở W2). Mỗi file ≤70 dòng, nội dung tailoring: `local/` nhắc "chỉ để tra cứu/so sánh", `cloud/` nhắc "không phải harness".
- 3 footer group README đang lạc phải sửa: `code-actions:103`, `model-agent:67`, `chat-session:69`.
- `commands/README.md`: xoá D27 (phím Quick Chat sai), sửa D49 (Session Target thiếu Claude/Codex), chia bảng theo 3 bucket.

## 5. Quy tắc rewrite link (đo thật: **225** link `](../…)` trong `commands/`, gồm cả `examples/README.md`)

| Loại | Hôm nay | Số | Sau move |
|---|---|---:|---|
| Group index | `../README.md` | **47** | **GIỮ NGUYÊN** (vẫn là `../README.md`) |
| Sibling cùng bucket | `../<slug>/README.md` | 10 | **GIỮ NGUYÊN** |
| Sibling **khác bucket** | `../<slug>/README.md` | **25** | `../../../<bucket>/<group>/<slug>/README.md` |
| Cross-group trong commands | `../../<group>/<slug>/…` | **4** | `../../../<bucket>/<group>/<slug>/…` |
| `commands/README.md` | `../../README.md` | 3 (group footers) | `../../../README.md` |
| Bài học trong `01-huong-dan-su-dung/` | `../../../NN-…md` | **15** | `../../../../NN-…md` |
| Repo-root (`03-cau-hoi-thuong-gap/`, `02-tips-thuc-chien/`) | `../../../../<dir>/…` | **52** | `../../../../../<dir>/…` |
| `CHEATSHEET.md` | `../../../../CHEATSHEET.md` | **47** | `../../../../../CHEATSHEET.md` |
| Trong `examples/` | `../../..` các loại | 80 | **+1 cấp cho link trỏ ra ngoài slug**; link nội bộ slug giữ |

**Nguyên tắc tổng quát** (đúng cho mọi trường hợp): *mọi link đi lên **qua khỏi** `<group>/` phải +1 `../`; link nằm trong phạm vi `<group>/` (group index, sibling, examples của chính mình) giữ nguyên.*

**25 sibling cross-bucket** (danh sách đầy đủ để review tay, vì một nửa sẽ bị xoá khi file `03` thực thi ownership map):
`attachments→export` · `checkpoints→export` · `clear→export` · `history→export` · `new-chat→export` · `shortcuts→quick-chat` · `summarize→export` · `export→summarize` · `export→new-chat` · `help→attachments` · `help→shortcuts` · `inline-chat→quick-chat` · `inline-chat→help` · `quick-chat→inline-chat` · `quick-chat→new-chat` · `agent-mode→edit-mode` · `agent-mode→ask-mode` · `ask-mode→agent-mode` · `edit-mode→agent-mode` · `coding-agent-assign→agent-mode` · `agent-skill→prompt-file` · `instructions→prompt-file` · `prompt-file→agent-skill` (×3) · `knowledge-base→mcp` · `fix→edit-mode`.

**Liên kết từ ngoài vào `commands/`:** **47 markdown links trỏ vào slug** (bài 04 = **45**, `01-huong-dan-su-dung/README.md` = 2) + **5 chỗ text** (`CHANGELOG.md` 3, `README.md` gốc 1, `CONTRIBUTING.md` 1) → chèn `<bucket>/` sau `commands/`. Riêng `README.md` gốc dòng 23/43/59 và `CHEATSHEET.md` còn ghi "47 lệnh" + mô hình `commands/<nhóm>/<tên-lệnh>/` → đổi thành **55** và `commands/<harness>/<nhóm>/<tên-lệnh>/`.

## 6. Script move (ràng buộc kỹ thuật)

1. **Đừng `sed -i` với `../` lặp** (double-shift). Dùng 1 pass Node: capture nguyên cụm `(?:\.\./)+` + phần còn lại, rồi quyết định theo bảng §5 (prototype: `link-class.js`, `bucket-links.js`).
2. Thứ tự: (a) `bucket.tsv` + 5 câu verify (§0 file `05`) → (b) `mkdir` 3 bucket → (c) **`git mv` theo từng slug** (không theo nhóm: 16/47 slug nằm cùng nhóm với slug khác bucket) → (d) rewrite 225 link nội bộ → (e) rewrite 47 link + 5 chỗ text từ ngoài → (f) link-check = **0 gãy** + **tạo 9 group README** → (g) đo `wc -l` (phải **bằng nguyên** baseline — chứng minh chưa sửa chữ).
3. ~~Repo có 1 link gãy từ trước (`09:57`)~~ ✅ đã sửa 2026-11-11 (`../copilot-extensions-ai-powered/README.md`) → repo **0 gãy**, gate (f) phải giữ nguyên 0.
4. Không tạo redirect/alias: repo không có build step, link hỏng là hỏng.
5. **Làm W2 trên branch riêng**, 1 commit "move + rewrite links", để revert sạch nếu tiêu chí bucket đổi.

## 7. Ngân sách dòng tầng commands

| | Hiện tại | Đích |
|---|---:|---:|
| README lệnh | 4.619 / 47 (TB **98**) | **55 slug** × ≤95 → **~5.225** |
| README nhóm | 4 file / ~230 | **9** group file × ≤65 → ~585 (xem §4: mỗi bucket cần index nhóm riêng) |
| README bucket + root | 1 file | **3** bucket + 1 root × ≤110 → ~300 |
| `examples/` | 77 file / 80 link (12 slug chỉ 2 file · `content-exclusion` toàn `.jsonc` · `mcp-add` 6 file) | giữ; QA **không giả định 4 file `.sh`** — đọc `examples/README.md` |
| **Tổng `commands/`** | **~4.909** | **~6.110 (+1.200)** |

Tầng lệnh **tăng ~1.200 dòng** (9 slug mới có nguồn + 5 index mới) trong khi tầng bài **giảm 2.160 dòng** (file `03`) → net toàn repo **−960 dòng**. Chủ đích: phần tra cứu phải đủ lệnh thật, phần văn xuôi mới là chỗ phải nén. Nếu muốn commands cũng giảm, bỏ P2 (5 slug) → commands +450, net −1.710.

## 8. Sửa vặt kèm theo (không thuộc move nhưng phải làm cùng PR)

- `commands/README.md:49` (thiếu Claude/Codex) · `model-agent/README.md:41,56-57` (`/policy`, `/customAgent`) · `code-actions/README.md:21,41,43` (`/fix`, `/pr`, `/commit`) · `system-knowledge/README.md:15` ("gh copilot CLI" → **Copilot CLI binary `copilot`**) · `chat-session/README.md` (phím Quick Chat).
- `fix/README.md:3` thiếu prefix **"Vấn đề:"** — lỗi khuôn duy nhất trong 47 file.
- Examples chứa claim sai: `premium-requests/examples/README.md:3` · `policy-approval/examples/README.md:5` (`.vscode/mcp.json`) · `agent-mode/examples/README.md:16` (`handoff: plan-file`) · `login/examples/1-login-diagnostic.sh:63` ("Bypass với `/status`").
