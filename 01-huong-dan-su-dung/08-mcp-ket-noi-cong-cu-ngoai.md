# 08 — MCP: Kết Nối Copilot Tới Thế Giới Ngoài (GitHub, DB, Browser...)

> Bài 08 của series. Đọc xong bạn setup được từng server GitHub/Playwright/Postgres/
> Fetch/Linear qua `.vscode/mcp.json`, hiểu tools approval, và prune MCP gọn ≤6 servers.
> Thời gian: ~40 phút.

## Mục lục

1. [MCP là gì — why](#1-mcp-là-gì--why)
2. [File `.vscode/mcp.json`: 3 transports](#2-file-vscode-mcpjson-3-transports)
3. [Tools approval (allow/ask/deny theo server)](#3-tools-approval-allowaskdeny-theo-server)
4. [Setup từng server day-one (copy-paste)](#4-setup-từng-server-day-one-copy-paste)
5. [Secrets qua env/input + Copilot MCP marketplace](#5-secrets-qua-envinput--copilot-mcp-marketplace)
6. [Prune guide + walkthrough + pitfalls + bài tập](#6-prune-guide--giữ-mcp-khỏe)
7. [Link chéo](#7-link-chéo)

---

## 1. MCP là gì — why

**Model Context Protocol** — chuẩn mở để AI tools gọi ra hệ ngoài theo cấu trúc
(files, APIs, DBs, docs, browser...). MCP server expose **tools**; Copilot Chat
discover và gọi như tools built-in.

Công thức: **MCP = reach (vươn ra ngoài), instructions/skills = cách dùng reach
đó cho đúng** (schema DB, message-format, quy ước repo...).

Khi nào KHÔNG cần MCP: dữ liệu đã nằm trong repo → Copilot đọc trực tiếp,
thêm MCP chỉ tốn maintenance + tools approval mệt.

| Khái niệm | Là gì | Ví dụ |
|---|---|---|
| **Tools** | Hàm Copilot gọi (có input/output schema) | `github.create_pr`, `postgres.query` |
| **Resources** | Dữ liệu đọc (URI-addressable, tùy server) | `github://repos/acme/api/issues/123` |
| **Prompts** | Templates server expose (tùy server) | Review PR, triage issue |

Transports Copilot hỗ trợ (2026): **stdio** (spawn process local — nhanh, cần
binary local), **sse** (remote streaming), **http** (remote, streamable HTTP —
khuyên dùng cho server remote mới).

---

## 2. File `.vscode/mcp.json`: 3 transports

Vị trí:

```text
.vscode/mcp.json          # repo-level, commit cho team (không secrets!)
~/.vscode/mcp.json        # personal global (tùy bản VS Code)
mcp.json (repo root)      # fallback 1 số bản cũ — ưu tiên .vscode/mcp.json
```

Khung đầy đủ (copy-paste rồi sửa):

```json
{
  "servers": {
    "github": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": { "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}" }
    },
    "playwright": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@playwright/mcp@latest"]
    },
    "postgres-dev": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres", "${DATABASE_URL}"],
      "env": {}
    },
    "fetch": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-fetch"]
    },
    "linear": {
      "type": "http",
      "url": "${LINEAR_MCP_URL}",
      "headers": { "Authorization": "Bearer ${LINEAR_API_KEY}" }
    },
    "notion": {
      "type": "sse",
      "url": "https://mcp.notion.com/sse",
      "headers": { "Authorization": "Bearer ${NOTION_API_KEY}" }
    }
  }
}
```

| Transport | Khi nào | Lưu ý |
|---|---|---|
| `stdio` | Server local (github, playwright, postgres, fetch) | Cần `npx`/`node` + binary cài được. Không theo lên coding agent cloud |
| `http` | Server remote mới (linear, internal API) | URL + headers auth qua env. Cloud-friendly |
| `sse` | Server remote cũ (notion, 1 số SaaS) | Dần thay bằng `http`. Giữ nếu docs server yêu cầu |

```bash
# Verify sau khi sửa mcp.json (copy-paste):
# 1. Reload: VS Code → Ctrl+Shift+P → "MCP: List Servers" → phải thấy 6 servers connected.
# 2. Chat test: "@workspace liệt kê MCP tools mày đang thấy" → đọc list.
# 3. Secrets audit: grep -ri "sk-\|ghp_\|password" .vscode/mcp.json → phải TRỐNG!
```

---

## 3. Tools approval (allow/ask/deny theo server)

MCP tools tuân tool approval của Copilot — đây là "permissions" của MCP-verse.

```jsonc
// .vscode/settings.json — approval theo server/tool (commit cho team)
{
  "github.copilot.chat.toolAutoRun": "ask",
  "github.copilot.chat.mcp.tools": {
    "github": "allow",            // GitHub MCP: cho qua (đọc PR/issues)
    "fetch": "allow",             // fetch web: cho qua
    "playwright": "ask",          // browser automation: hỏi trước (side effects)
    "postgres-dev": "ask",         // DB dev: hỏi trước
    "postgres-prod": "deny"       // DB prod: cấm hẳn (không tạo server prod nếu không cần)
  }
}
```

```text
Org-level (admin):
github.com → Org Settings → Copilot → Policies → MCP:
- Allowlist servers: github, fetch, linear. Server lạ → block ở client.
- Default tool approval: terminal/browser = ask cho cả org.
- Audit: xem logs MCP tool calls theo user/repo (Business/Enterprise).

Quy tắc team:
- Read-only tools (github read, fetch, linear read) → allow.
- Side-effect tools (browser click, DB write, post message) → ask.
- Prod/destructive (prod DB, deploy, xóa) → deny + không tạo server.
```

---

## 4. Setup từng server day-one (copy-paste)

### 4.1. GitHub (impact cao nhất — cài đầu tiên)

```bash
# Bước 1: tạo token (fine-grained, chỉ repo cần) → lưu vào env, KHÔNG paste vào file:
export GITHUB_TOKEN="ghp_..."   # đặt trong ~/.zshrc hoặc VS Code env, không commit
# Verify token:
gh auth status   # phải thấy Logged in (hoặc curl check token scope)

# Bước 2: thêm vào .vscode/mcp.json (mục 2, server "github"). Dùng ${GITHUB_TOKEN}.

# Bước 3: verify trong Chat:
# > "@workspace liệt kê 5 PRs mở gần nhất của repo này + tóm tắt mỗi PR 1 dòng"
# Kỳ vọng: Copilot gọi github MCP, trả 5 dòng. Không được → "MCP: List Servers" check status.
```

### 4.2. Playwright (browser automation — Copilot NHÌN UI)

```bash
# Bước 1: server đã có trong mcp.json (mục 2, "playwright"). Cài browsers 1 lần:
npx playwright install chromium

# Bước 2: boot app local rồi nhờ Copilot nhìn:
pnpm dev &
# Trong Chat (approval playwright = ask → bấm Allow khi hỏi):
# > "mở http://localhost:3000/login bằng browser, chụp màn hình, nhận xét UI có vấn đề gì"
```

> Playwright stdio KHÔNG theo lên coding agent cloud — cloud cần browser MCP
> remote hoặc nhờ agent chụp artifact CI (xem bài 12).

### 4.3. Postgres (đọc schema + query — KHÔNG commit password)

```bash
# Bước 1: secrets qua env, KHÔNG paste connection string vào file:
export DATABASE_URL="postgresql://dev@localhost:5432/acme_dev"  # dev only!
# Server dùng ${DATABASE_URL} (mục 2, "postgres-dev").

# Bước 2: verify (chỉ đọc, không viết):
# > "liệt kê tables trong DB + đếm rows mỗi table, chỉ đọc không viết"
```

```text
Quy tắc an toàn DB:
- Dev DB: cho read + (cân nhắc) write qua instructions giới hạn.
- Prod DB: KHÔNG tạo server prod trong mcp.json team. Cần thì personal + read-only + approval deny write.
- Không bao giờ paste connection string prod vào chat/mcp.json committed.
- Kèm instructions .github/instructions/db.instructions.md: "prod CHỈ SELECT + WHERE + LIMIT".
```

```markdown
<!-- .github/instructions/db.instructions.md — kèm postgres MCP -->
---
applyTo: "**/*.sql"
---
# DB Query rules
- Dev DB (`$DATABASE_URL` trỏ dev): SELECT thoải mái, limit 100 rows.
- Prod: CHỈ SELECT, bắt buộc WHERE + LIMIT, KHÔNG DELETE/DROP/UPDATE.
- Output: tối đa 20 rows trong chat, nhiều hơn → export file.
```

### 4.4. Fetch/Brave (web grounding live)

```bash
# Server "fetch" đã có trong mcp.json (stdio, không auth).
# Test:
# > "fetch docs https://docs.github.com/en/copilot tóm tắt 10 dòng về custom agents"
# Brave Search (cần API key qua env):
export BRAVE_API_KEY="..."   # https://brave.com/search/api/
# Thêm server tương tự linear (http + header Authorization: Bearer ${BRAVE_API_KEY}).
```

### 4.5. Linear/Notion (tickets, docs — remote http/sse + token riêng)

```bash
# Mỗi người token riêng → KHÔNG commit token. Dùng env:
export LINEAR_API_KEY="..."    # Linear → Settings → API
export NOTION_API_KEY="..."    # Notion → Integrations → New integration
# Servers dùng ${...} placeholders (mục 2). Scope personal nếu token cá nhân:
# → để servers này ở ~/.vscode/mcp.json thay vì .vscode/mcp.json team.
```

```text
Quy ước team: servers dùng chung không secrets (github, fetch, playwright)
→ .vscode/mcp.json (commit). Servers token cá nhân (linear, notion)
→ personal config (không commit). Ghi rõ trong README để teammate mới không hỏi lại.
```

---

## 5. Secrets qua env/input + Copilot MCP marketplace

### 5.1. Secrets matrix (thuộc lòng)

```text
ĐƯỢC (secrets qua env):
  "env": { "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}" }
  "args": ["...server-postgres", "${DATABASE_URL}"]
  "headers": { "Authorization": "Bearer ${LINEAR_API_KEY}" }

CẤM (paste trực tiếp):
  "env": { "TOKEN": "ghp_abc123..." }          → lộ khi commit
  "args": ["postgresql://user:PASS@host/db"]   → lộ khi commit
  "headers": { "Authorization": "Bearer sk-.." } → lộ khi commit

Audit 1 dòng (chạy trước mỗi PR):
  grep -rniE "ghp_|gho_|sk-|xox-|password\s*[:=]" .vscode/mcp.json; echo "exit=$? (1 = sạch)"
```

```bash
# Dùng VS Code input variables cho secrets máy local (không lưu file):
# .vscode/mcp.json:
#   "env": { "GITHUB_PERSONAL_ACCESS_TOKEN": "${input:githubToken}" }
# .vscode/inputs không tồn tại cho mcp — thay bằng env prompt:
export GITHUB_TOKEN="$(gh auth token)"  # lấy từ gh CLI, không lưu plaintext
```

### 5.2. Copilot MCP marketplace / registry (2026)

```text
VS Code → Ctrl+Shift+P → "MCP: Browse Servers" (marketplace/registry):
- Bước 1: Browse → chọn server (github, playwright, postgres...) → Install.
- Bước 2: VS Code tự chèn vào mcp.json → bạn thay secrets bằng ${ENV}.
- Bước 3: "MCP: List Servers" → connected? Chat test 1 prompt.
- Org: admin có thể allow/block từng server trong marketplace (Policies → MCP).

Khác extensions (bài 09): MCP server = 1 tool provider. Extension = có thể bundle
MCP + chat participants + commands. Cài extension Copilot-related có thể tự thêm MCP.
```

---

## 6. Prune guide — giữ MCP khỏe

### 6.1. Day-one servers (sweet spot 3–6, đừng quá ~10 tools visible)

| Server | Để làm gì | Khi thêm | Khi prune |
|---|---|---|---|
| GitHub | PRs, issues, code search | Gần như luôn — impact cao nhất | Không bao giờ (trừ repo không dùng GitHub) |
| Playwright | Browser automation — Copilot **nhìn** UI | Web app cần test UI | App không UI / đã có E2E khác |
| Postgres/MySQL | Đọc schema, chạy query dev | App có DB thật | Project docs-only, không DB |
| Fetch / Brave | Web grounding live | Tra docs ngoài | Ít tra web / đã có docs local |
| Linear / Notion / Jira / Slack | Tickets, docs, messages | Team sống trong đó | Team không dùng / đã migrate tool |

> Quá ~10 MCP tools visible → Copilot chọn tool sai/bỏ sót. Thêm cái dùng thật,
> prune cái không. Mỗi server sâu nên có 1 instructions file kèm (schema, format).

### 6.2. Prune flow định kỳ (2 tuần/lần, 10 phút)

```text
Bước 1: mở "MCP: List Servers" → server nào disconnected lâu? Ghi lại.
Bước 2: tự hỏi: 2 tuần rồi có gọi server X không? Không → disable 1 tuần.
  VS Code: mcp.json → xóa/comment server → reload. Không ai kêu → xóa hẳn.
Bước 3: audit tools: "@workspace liệt kê MCP tools mày đang thấy" → server nào thừa?
Bước 4: audit secrets: grep secrets (mục 5.1) → phải trống.
```

### 6.3. Checklist MCP khỏe

- [ ] `MCP: List Servers` all connected; OAuth/token xong.
- [ ] `.vscode/mcp.json` commit được, secrets chỉ qua env (grep trống).
- [ ] Mỗi server sâu có 1 instructions kèm (schema, conventions).
- [ ] Tools visible gọn, servers 3–6.
- [ ] Tool approval đúng: read → allow, side-effect → ask, prod → deny.
- [ ] Coding agent cloud: cấu hình lại MCP remote (stdio local không theo lên cloud).

### 6.4. Pitfalls + fix

| Pitfall | Vì sao | Fix |
|---|---|---|
| Paste password vào `mcp.json` rồi commit | Tiện tay | `${VAR}` + secrets ở env; `git rm` + rotate creds đã lọt |
| Cài 15 servers "cho chắc" | Sợ thiếu | 3–6, prune định kỳ |
| Local stdio lên cloud mất | Cloud không có binary local | Cloud dùng http/sse remotes (bài 12) |
| Token hết hạn → disconnected | Token ngắn hạn | Re-export env + reload; cron nhắc re-auth |
| Không instructions kèm → Copilot query sai schema | MCP không biết conventions | Viết `db.instructions.md` (mục 4.3) |
| Approval `allow` hết cho tiện | Lười bấm Allow | Side-effect giữ `ask`; chỉ read-only mới `allow` |

### 6.5. Bài tập thực hành

**Bài 1 (15 phút):** Cài GitHub server (mục 4.1). Test 3 prompts: list PRs,
đọc issue, search code. Ghi tools Copilot đã gọi.

**Bài 2 (15 phút):** Cài Postgres dev (mục 4.3, env placeholder). Viết
`db.instructions.md` kèm. Test SELECT + verify prod guard (hỏi prod → phải từ chối).

**Bài 3 (15 phút):** Cài Playwright (mục 4.2). Boot app local, nhờ Copilot mở +
screenshot + nhận xét UI.

**Bài 4 (10 phút):** Chạy prune flow (mục 6.2): tìm server 0 calls → disable.
Audit `mcp.json` secrets bằng grep (mục 5.1).

### 6.6. Walkthrough: thêm server đầu tiên (10 phút)

```text
Bước 1: copy khung mcp.json (mục 2) vào .vscode/mcp.json, giữ lại github + fetch.
Bước 2: export GITHUB_TOKEN (mục 4.1). Reload VS Code.
Bước 3: Ctrl+Shift+P → "MCP: List Servers" → github phải connected.
Bước 4: Chat test: "liệt kê 5 PRs mở gần nhất". Được → thêm servers tiếp theo.
Bước 5: Commit mcp.json (grep secrets trống) + settings approval (mục 3).
```

---

## 7. Link chéo

- **Bài 03 — Instructions:** instructions kèm MCP (schema DB, format Slack).
- **Bài 05 — Prompt files:** prompt tái dùng gọi MCP (review-pr, triage-issue).
- **Bài 06 — Custom agents:** agents gọi MCP tools — lock `tools` trong frontmatter.
- **Bài 07 — Guardrails:** MCP allowlist + content exclusion (defense in depth).
- **Bài 09 — Extensions:** extension bundle MCP + participants — cài 1 được 2.
- **Bài 10 — Permissions:** tool approval allow/ask/deny + plan differences.
- **Bài 12 — SDK & CI:** MCP trong Actions runners + coding agent cloud (remote only).

---
*(Hết bài 08 — tổng ~400 dòng. Tiếp theo: Bài 09 — Extensions & marketplaces.)*
