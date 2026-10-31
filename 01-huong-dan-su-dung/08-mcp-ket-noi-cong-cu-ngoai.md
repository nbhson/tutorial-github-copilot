# 08 — MCP: Kết Nối Copilot Tới Thế Giới Ngoài (GitHub, DB, Browser...)

> **Dành cho:** người dùng Copilot Chat trong VS Code; tech lead/admin muốn chuẩn hóa MCP cho team.
> **Vấn đề:** Copilot giỏi trong repo, nhưng "mù" với mọi thứ ngoài repo (PR, issue, DB, web, ticket).
> **Đọc xong:** setup được server GitHub/Playwright/Postgres/Fetch/Linear qua `.vscode/mcp.json`, hiểu 3 thành phần Tools/Resources/Prompts, đặt approval đúng, và prune còn 3–6 servers. **Thời gian:** ~40 phút.

## Mục tiêu bài học

- Biết **khi nào cần / khi nào đừng** cài MCP — không phải cứ thêm server là mạnh.
- Phân biệt **3 thành phần** của 1 MCP server: Tools (tay làm) / Resources (mắt đọc) / Prompts (công thức nấu sẵn).
- Khai server trong `.vscode/mcp.json`, chọn đúng transport `stdio`/`http`/`sse`, secrets qua `${VAR}`.
- Đặt **approval** `deny > ask > allow` đúng chỗ và prune MCP gọn ≤6 servers.

---

## 1. MCP là gì — khi nào cần, khi nào đừng

**Định nghĩa 1 câu:** MCP (Model Context Protocol) là **chuẩn cắm chung** để Copilot gọi ra thế giới ngoài (GitHub, DB, browser, Linear...) — như USB-C: 1 chuẩn cắm cho mọi máy, không cần mỗi hãng viết 1 kiểu tích hợp.

**Nôm na (anh bồi bàn):** Bạn = khách. Copilot Chat = bồi bàn. MCP Server = bếp (bếp GitHub, bếp Postgres, bếp Browser). Bạn gọi "cho anh 5 PRs mới nhất" → bồi bàn viết phiếu (gọi Tool) → bếp làm → trả đĩa (JSON) → bồi bàn trình bày đẹp.

```text
 KHÔNG MCP: "PR #123 đang bàn gì?" → Copilot: "Em không thấy GitHub, anh paste diff vào đây."
 CÓ MCP:    "Tóm tắt PR #123 repo acme/api" → Copilot tự gọi github MCP → trả 5 dòng.
 # Verify: chạy cả 2 câu — trước và sau khi cài server github — đối chiếu.
```

**Khi nào đừng cài (quan trọng hơn "cài gì"):**

- Dữ liệu đã trong repo (`src/`, `docs/`) → `@workspace` + instructions, **KHÔNG cần MCP** — thêm chỉ tốn process nền, popup approval, bề mặt lộ secret.
- Hỏi việc **ngoài repo** (PRs, issues, DB, web, tickets) → cần MCP server tương ứng.
- **MCP = reach (vươn tay ra ngoài); instructions/skills = cách dùng reach đó cho đúng** (schema DB nào, format nào — bài 03/05).

---

## 2. Một lời gọi MCP đi qua 4 nhân vật

```text
 Bạn gõ → Copilot Chat (model suy luận "cần bếp nào?") → MCP Client (trong VS Code,
 JSON-RPC) → MCP Server (process riêng, giữ token) → hệ ngoài (github.com/DB/web).

 Vòng đời 1 câu "liệt kê 5 PRs mở gần nhất":
 1. tools/list   — Client hỏi từng server "mày có món gì?" → nhận menu + schema (không cần approval).
 2. Model chọn   — đọc menu + prompt → "cần github.list_prs(owner, repo, state, limit)".
 3. Approval     — đối chiếu rules allow/ask/deny (mục 5): allow → chạy luôn; ask → popup.
 4. tools/call   — Client gửi JSON-RPC kèm params → server gọi API thật (kèm token).
 5. Trình bày    — server trả JSON → model tóm tắt 5 dòng tiếng người.
 # Model KHÔNG BAO GIỜ cầm token GitHub — token nằm ở Server process.
```

| Nhân vật | Là gì thật | Ai gọi nó |
|---|---|---|
| Copilot Chat | Panel Chat + model | Bạn gõ prompt |
| MCP Client | Code JSON-RPC trong VS Code Copilot extension (VS Code tự có) | Copilot Chat |
| MCP Server | Process riêng (`npx ...`) khai trong `mcp.json` | MCP Client spawn (stdio) hoặc gọi HTTP/SSE |
| Hệ ngoài | github.com, Postgres, Chrome, Linear... | Chỉ MCP Server (giữ token) |

---

## 3. File `.vscode/mcp.json` + 3 transports

`mcp.json` là "danh bạ bếp": mỗi bếp ở đâu, gọi bằng cách nào, secrets lấy từ đâu. Khai sai là nguyên nhân số 1 khiến tools không hiện.

**Vị trí khai server (2026):**

| Vị trí | Key JSON | Phạm vi | Commit? |
|---|---|---|---|
| `.vscode/mcp.json` | `servers` | Workspace/repo | Có — chỉ `${VAR}`, KHÔNG secrets |
| `mcp.json` / `.mcp.json` (root repo) | `mcpServers` | Portable, CLI đọc | Tùy |
| `~/.copilot/mcp-config.json` | `mcpServers` | User profile, mọi máy | Không |
| `~/.vscode/mcp.json` | — | Personal global (VS Code) | Không |

> Lưu ý: Copilot CLI đọc `~/.mcp-config.json` + `.mcp.json` ở repo — **từ CLI v1.0.39 CLI không còn đọc `.vscode/mcp.json`** (BREAKING). Cấu hình repo trên github.com (Settings → Copilot → MCP servers) dùng key `mcpServers`, bắt buộc mảng `tools`, secret prefix `COPILOT_MCP_`.

**Khung đầy đủ (copy-paste — chỉ thay env):**

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
    }
  }
}
```

| Transport | Nôm na | Khi nào dùng | Lưu ý |
|---|---|---|---|
| `stdio` | Bếp nấu tại nhà bạn (spawn process local) | Server local (github, playwright, postgres, fetch) | Cần `npx`/node. Nhanh nhất. **Không theo lên coding agent cloud** |
| `http` | Gọi quán qua app (remote streamable HTTP) | Server remote mới (linear, internal API) | URL + headers auth qua env. **Khuyên dùng cho remote mới** |
| `sse` | Điện thoại bàn cũ (remote streaming cũ) | Server remote cũ (notion, vài SaaS) | Dần thay bằng `http` — giữ nếu docs yêu cầu |

```bash
# Verify sau khi sửa mcp.json:
# 1. Ctrl+Shift+P → "MCP: List Servers" → servers phải Connected.
# 2. Chat: "@workspace liệt kê MCP tools mày đang thấy" → đọc được list.
# 3. Audit secrets (phải TRỐNG):
grep -rniE "ghp_|gho_|sk-|xox-|password\s*[:=]" .vscode/mcp.json; echo "exit=$? (1 = sạch, 0 = CÓ LỘ!)"
```

---

## 4. 3 thành phần của 1 MCP server

Nhớ công thức: **Tools = tay (làm), Resources = mắt (đọc), Prompts = gói gia vị pha sẵn.** Cả 3 nằm trong cùng 1 server — tác giả server quyết định expose gì; Tools là bắt buộc, Resources/Prompts là tùy chọn (server thiếu Resources là bình thường, không phải lỗi).

**Tools** — hàm có params, Copilot gọi qua `tools/call`. Sau `tools/list`, mỗi tool trả về `name` + `description` (Copilot dựa vào đây chọn tool) + `inputSchema` (params gì, required gì — vd `github.create_pr` required `owner, repo, title, head, base`).

**Resources** — dữ liệu đọc qua URI, không side effects, gọi qua `resources/read`:

```text
 github://repos/acme/api/issues/123          → issue #123
 github://repos/acme/api/pulls/456/diff      → diff PR #456
 postgres://acme_dev/tables/orders/schema    → schema table orders (tùy server)
```

**Prompts** — template câu lệnh soạn sẵn của tác giả server (vd `review-pr`: "tóm tắt 3 dòng + findings [CRITICAL|HIGH|MED|LOW] file:line + kết luận"). Gõ `/` trong Chat sẽ thấy prompts từ servers (namespaced, vd `/github:review-pr`). Prompt files repo = chuẩn team bạn (chỉnh được); prompts server = chuẩn tác giả (dùng ngay) — team nghiêm túc thì copy ý về `.github/` của mình. Nhiều server không expose prompts → bình thường.

```text
 # Verify 3 thành phần: chat "@workspace server github expose tools gì? resources gì?"
 # → kể được list_prs, get_pr, create_pr... Nếu trả "chỉ có tools" → bình thường.
```

---

## 5. Tools approval (allow/ask/deny)

Approval là **gác cổng**: mỗi lần Copilot muốn bấm nút (Tool), gác cổng tra sổ → cho qua (allow) / hỏi bạn (ask) / cấm (deny). Nôm na: "xem TV (read) cứ xem, ra đường (browser/terminal) phải hỏi, sờ ổ điện (prod DB) thì cấm".

```jsonc
// .vscode/settings.json — approval theo server (commit cho team)
{
  "github.copilot.chat.toolAutoRun": "ask",
  "github.copilot.chat.mcp.tools": {
    "github": "allow",            // đọc PR/issues — read-only, an toàn
    "fetch": "allow",             // đọc docs web — an toàn
    "playwright": "ask",          // browser click có side effects
    "postgres-dev": "ask",        // query sai tốn thời gian, write nguy hiểm
    "postgres-prod": "deny"       // DB prod: cấm hẳn (đừng tạo server prod nếu không cần)
  }
}
```

**Thứ tự ưu tiên — thuộc lòng: `deny > ask > allow`** (luật của enterprise `managed-settings.json`, chi tiết bài 07):

- **Cấm (deny) luôn thắng.** Rule nào chưa khớp → mặc định **hỏi lại**. `ask` không lách được bằng bypass/YOLO mode.
- Allowlist hiệu lực cuối = **giao (intersection)** của mọi nguồn; khai `[]` = lockdown (cấm hết).
- Org policy (Business+): bật "MCP servers in Copilot" trước, rồi allowlist servers; audit logs MCP tool calls theo user/repo.

```text
 # Verify approval: 1. "liệt kê 5 PRs" (allow) → chạy luôn, không popup.
 # 2. "mở http://localhost:3000 bằng browser" (ask) → phải popup.
 # 3. gọi postgres-prod (deny) → "blocked by policy". Sai → check settings + org policy đè.
```

---

## 6. 5 server day-one (copy-paste)

**GitHub — impact cao nhất, cài đầu tiên:**

```bash
# 1. Tạo token (fine-grained, chỉ repo cần) → env, KHÔNG paste vào file:
export GITHUB_TOKEN="$(gh auth token)"   # lấy từ gh CLI, không lưu plaintext
# 2. Đã có trong .vscode/mcp.json (mục 3, dùng ${GITHUB_TOKEN}).
# 3. Verify: "liệt kê 5 PRs mở gần nhất của repo này + tóm tắt mỗi PR 1 dòng"
# → Copilot tự gọi github MCP, trả 5 dòng. Không được → "MCP: List Servers" check status.
```

**Playwright — Copilot NHÌN UI qua browser thật:**

```bash
npx playwright install chromium   # cài browsers 1 lần
pnpm dev &   # boot app local
# Chat (playwright = ask → bấm Allow khi hỏi):
# "mở http://localhost:3000/login bằng browser, chụp màn hình, nhận xét UI"
# Kỳ vọng: browser thật + screenshot + 3-5 nhận xét UI.
# Lưu ý: playwright stdio KHÔNG theo lên coding agent cloud (bài 12).
```

**Postgres — đọc schema + query dev (KHÔNG commit password):**

```bash
export DATABASE_URL="postgresql://dev@localhost:5432/acme_dev"  # dev only!
# Verify: "liệt kê tables + đếm rows mỗi table, chỉ đọc" → list tables.
# Quy tắc: prod KHÔNG tạo server trong mcp.json team. Cần → personal + read-only + deny write.
```

```markdown
<!-- .github/instructions/db.instructions.md — kèm postgres MCP -->
---
applyTo: "**/*.sql"
---
# DB Query rules
- Dev DB: SELECT thoải mái, limit 100 rows.
- Prod: CHỈ SELECT, bắt buộc WHERE + LIMIT, KHÔNG DELETE/DROP/UPDATE.
- Output: tối đa 20 rows trong chat, nhiều hơn → export file.
```

**Fetch/Brave — web grounding live:**

```bash
# Server "fetch" đã có trong mcp.json (stdio, không auth). Test:
# "fetch docs https://docs.github.com/en/copilot tóm tắt 10 dòng về custom agents"
# Kỳ vọng: tóm tắt từ trang thật, không bịa. Brave Search: cần BRAVE_API_KEY qua env.
```

**Linear/Notion — tickets, docs (remote, token cá nhân):**

```bash
export LINEAR_API_KEY="..."    # Linear → Settings → API
export NOTION_API_KEY="..."    # Notion → Integrations
# Token cá nhân → để servers này ở ~/.vscode/mcp.json, KHÔNG commit.
# Verify: "@workspace liệt kê tasks Linear của tao" → tasks thật.
```

---

## 7. Secrets + marketplace

### 7.1. Secrets matrix (thuộc lòng)

Secrets **luôn đi qua biến môi trường `${VAR}`** — không khắc mật khẩu két lên cửa két; cửa chỉ ghi "hỏi chủ nhà".

```text
 ĐƯỢC (commit an toàn):                            CẤM (lộ khi commit → rotate ngay):
   "env": { "TOKEN": "${GITHUB_TOKEN}" }             "env": { "TOKEN": "ghp_abc123..." }
   "args": ["...postgres", "${DATABASE_URL}"]        "args": ["postgresql://user:PASS@host/db"]
   "headers": { "Authorization": "Bearer ${KEY}" }   "headers": { "...": "Bearer sk-.." }

 Audit 1 dòng (chạy trước mỗi PR):
   grep -rniE "ghp_|gho_|sk-|xox-|password\s*[:=]" .vscode/mcp.json; echo "exit=$? (1 = sạch)"
 # exit=0 → CÓ LỘ: git rm + rotate creds ngay — git history giữ mãi, xóa dòng không đủ
 # (token nằm trong `git log -p`, trong fork/clone; bot quét GitHub tìm thấy trong vài phút).
```

### 7.2. Marketplace + registry (2026)

```text
 VS Code → Ctrl+Shift+P → "MCP: Browse Servers": browse → Install → VS Code tự chèn
 vào mcp.json → thay secrets bằng ${ENV} → "MCP: List Servers" → connected.
 Org: admin allow/block từng server (Policies → MCP). Nguồn chuẩn khác:
 GitHub MCP Registry (docs.github.com) + cấu hình trên github.com (Settings → Copilot).
```

GitHub MCP server có 2 dạng:

| | Remote hosted | Local (Docker) |
|---|---|---|
| Endpoint | `https://api.githubcopilot.com/mcp/` | `ghcr.io/github/github-mcp-server` |
| Cần gì | Chỉ URL + auth | Docker chạy trên máy |
| Chọn toolset / read-only | Path `/x/{toolset}`, `/readonly`; header `X-MCP-Toolsets`, `X-MCP-Readonly: true` | Cùng cơ chế |
| Khi nào dùng | Dùng ngay, cloud/không có Docker | Tự host/offline |

---

## 8. Prune — giữ MCP khỏe

**Sweet spot 3–6 servers, đừng quá ~10 tools visible** — menu 100 món thì bồi bàn loạn: quá nhiều tools → Copilot chọn sai/bỏ sót, IDE chậm, bề mặt lộ secret to.

| Server | Khi thêm | Khi prune (bỏ) |
|---|---|---|
| GitHub | Gần như luôn — impact cao nhất | Không bao giờ (trừ repo không dùng GitHub) |
| Playwright | Web app cần test UI | App không UI / đã có E2E khác |
| Postgres/MySQL | App có DB thật | Project docs-only |
| Fetch / Brave | Hay tra docs ngoài | Ít tra web / đã có docs local |
| Linear / Notion / Jira / Slack | Team sống trong đó | Team không dùng / đã migrate |

```text
 Prune flow (2 tuần/lần, 10 phút):
 1. "MCP: List Servers" → server nào disconnected lâu? 2 tuần rồi có gọi không?
    Không → disable 1 tuần; không ai kêu → xóa hẳn.
 2. Audit tools: "@workspace liệt kê MCP tools mày đang thấy" → server nào thừa?
 3. Audit secrets: grep (mục 7.1) → phải exit=1.
 # Kỳ vọng: còn 3-6 servers connected, tools gọn, secrets sạch.
```

---

## 9. Pitfalls + hiểu nhầm

| Hiểu nhầm / pitfall | Sự thật / Fix |
|---|---|
| "Cài MCP cho dữ liệu trong repo" | `@workspace` làm được rồi — MCP chỉ cho thứ NGOÀI repo, thêm chỉ tốn maintenance + popup |
| "MCP server = 1 tool" | 1 server expose **nhiều tools + (tùy) resources/prompts** (xem `tools/list`, mục 4) |
| "Copilot cầm token GitHub của mình" | Token nằm ở **MCP Server process** (env). Model chỉ thấy params + JSON kết quả |
| "Cài càng nhiều servers càng mạnh" | Quá ~10 tools → chọn sai/bỏ sót. Giữ 3–6, prune định kỳ (mục 8) |
| Paste password vào `mcp.json` rồi commit | Git history giữ mãi — `${VAR}` + đã lọt thì rotate ngay (mục 7.1) |
| "stdio local theo lên cloud" | Coding agent cloud chỉ gọi remote MCP (http/sse) — bài 12 |
| "MCP thay instructions/skills" | MCP = tay vươn ra ngoài; instructions = cách dùng tay đó. Cần cả 2 |
| Approval `allow` hết cho tiện | Side-effect giữ `ask`; chỉ read-only mới `allow`. `deny` luôn thắng `allow` (mục 5) |

---

## Bài tập

1. **(15 phút)** Cài GitHub server (mục 6). Test 3 prompts: list PRs, đọc issue, search code — ghi lại Copilot đã gọi tools nào.
2. **(15 phút)** Cài Postgres dev + viết `db.instructions.md`. Test SELECT, verify prod guard (hỏi prod → phải từ chối).
3. **(10 phút)** Chạy prune flow (mục 8): tìm server 0 calls → disable; audit secrets bằng grep — exit code phải = 1.

## Link qua

- Instructions kèm MCP (schema DB, format) → bài 03. Skill gọi MCP theo quy trình → bài 05.
- Agents lock `tools` khi gọi MCP → bài 06. MCP allowlist + exclusion (defense in depth) → bài 07.
- Tool approval chi tiết → bài 10. MCP trong Actions + coding agent cloud (remote only) → bài 12.

## Reference

- GitHub Copilot docs: https://docs.github.com/copilot
- VS Code Copilot docs: https://code.visualstudio.com/docs/copilot
- Model Context Protocol (chuẩn chung): https://modelcontextprotocol.io

> **Chốt:** MCP chỉ đáng cài khi dữ liệu nằm *ngoài* repo — và khi đã cài, giữ reach có kỷ luật: secrets qua env, read cho qua, write phải hỏi, prod thì cấm.
