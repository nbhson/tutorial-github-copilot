# 08 — MCP: Kết Nối Copilot Tới Thế Giới Ngoài (GitHub, DB, Browser...)

> **Dành cho:** người dùng Copilot Chat trong VS Code; tech lead/admin muốn chuẩn hóa MCP cho team.
> **Vấn đề:** Copilot giỏi trong repo, nhưng "mù" với mọi thứ ngoài repo (PR, issue, DB, web, ticket).
> **Đọc xong:** setup được server GitHub/Playwright/Postgres/Fetch/Linear qua `.vscode/mcp.json`, hiểu 3 thành phần Tools/Resources/Prompts, đặt approval đúng, và prune còn 3–6 servers. **Thời gian:** ~40 phút.

## Mục tiêu bài học

- Biết **khi nào cần / khi nào đừng** cài MCP — không phải cứ thêm server là mạnh.
- Phân biệt **3 thành phần** của 1 MCP server: Tools (tay làm) / Resources (mắt đọc) / Prompts (công thức nấu sẵn).
- Khai server trong `.vscode/mcp.json`, chọn đúng transport `stdio`/`http`/`sse`, secrets qua `${VAR}`.
- Đặt **approval** `deny > ask > allow` đúng chỗ và prune MCP gọn ≤6 servers.

> **Tóm gọn 1 câu:** Bài này dạy bạn cắm Copilot ra thế giới ngoài bằng MCP — cài đúng chỗ, khóa approval đúng mức, và giữ danh bạ gọn gàng.

---

## 1. MCP là gì — khi nào cần, khi nào đừng

Mục này trả lời câu hỏi đầu tiên bạn phải hỏi trước khi cài bất kỳ server nào: mình có thực sự cần MCP không?

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

> **Tóm gọn 1 câu:** MCP chỉ đáng cài khi dữ liệu nằm ngoài repo — dữ liệu trong repo thì `@workspace` đã đủ.

---

## 2. Một lời gọi MCP đi qua 4 nhân vật

Mục này mổ xẻ hành trình của một câu hỏi từ lúc bạn gõ tới lúc nhận kết quả. Biết rõ từng chặng sẽ giúp bạn đoán đúng chỗ hỏng khi tools không chạy.

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

> **Cách đọc bảng này:** Mỗi dòng là một nhân vật trong chuỗi — cột 2 nói nó là gì thật, cột 3 cho biết ai là người ra lệnh cho nó.

> **Tóm gọn 1 câu:** Câu hỏi của bạn đi qua 4 trạm: Chat → Client → Server → hệ ngoài, và token chỉ ở trạm Server.

---

## 3. File `.vscode/mcp.json` + 3 transports

Mục này chỉ chỗ khai báo server và các "đường dây" nối tới server. Khai đúng file + đúng transport là 2 điều kiện bắt buộc để tools hiện lên trong Chat.

`mcp.json` là "danh bạ bếp": mỗi bếp ở đâu, gọi bằng cách nào, secrets lấy từ đâu. Khai sai là nguyên nhân số 1 khiến tools không hiện.

**Vị trí khai server (2026):**

| Vị trí | Key JSON | Phạm vi | Commit? |
|---|---|---|---|
| `.vscode/mcp.json` | `servers` | Workspace/repo | Có — chỉ `${VAR}`, KHÔNG secrets |
| `mcp.json` / `.mcp.json` (root repo) | `mcpServers` | Portable, CLI đọc | Tùy |
| `~/.copilot/mcp-config.json` | `mcpServers` | User profile, mọi máy | Không |
| `~/.vscode/mcp.json` | — | Personal global (VS Code) | Không |

> **Cách đọc bảng này:** Mỗi dòng là một chỗ đặt file cấu hình — cột 2 là key JSON bắt buộc dùng ở đó, cột 4 cho biết file đó có được commit lên git không.

> Lưu ý: Copilot CLI đọc `~/.mcp-config.json` + `.mcp.json` ở repo — **từ CLI v1.0.39 CLI không còn đọc `.vscode/mcp.json`** (BREAKING). Cấu hình repo trên github.com (Settings → Copilot → MCP servers) dùng key `mcpServers`, bắt buộc mảng `tools`, secret prefix `COPILOT_MCP_`.

**Khung đầy đủ (copy-paste — chỉ thay env):**

> 📄 **Code ví dụ:** [`examples/01-3-file-vscode-mcp-json-3-transports.json`](examples/01-3-file-vscode-mcp-json-3-transports.json)

| Transport | Nôm na | Khi nào dùng | Lưu ý |
|---|---|---|---|
| `stdio` | Bếp nấu tại nhà bạn (spawn process local) | Server local (github, playwright, postgres, fetch) | Cần `npx`/node. Nhanh nhất. **Không theo lên coding agent cloud** |
| `http` | Gọi quán qua app (remote streamable HTTP) | Server remote mới (linear, internal API) | URL + headers auth qua env. **Khuyên dùng cho remote mới** |
| `sse` | Điện thoại bàn cũ (remote streaming cũ) | Server remote cũ (notion, vài SaaS) | Dần thay bằng `http` — giữ nếu docs yêu cầu |

> **Cách đọc bảng này:** Mỗi dòng là một kiểu "đường dây" nối Copilot với server — cột 3 là tình huống nên chọn kiểu đó, cột 4 là cái bẫy cần nhớ.

> 📄 **Code ví dụ:** [`examples/02-3-file-vscode-mcp-json-3-transports.sh`](examples/02-3-file-vscode-mcp-json-3-transports.sh)

> **Tóm gọn 1 câu:** Khai server trong `mcp.json` với key đúng theo vị trí file, và chọn transport: local dùng `stdio`, remote mới dùng `http`, remote cũ dùng `sse`.

---

## 4. 3 thành phần của 1 MCP server

Mục này giải phẫu một server: bên trong nó có gì, và Copilot dùng từng bộ phận đó thế nào. Hiểu được điều này, bạn đọc docs của server mới mà không bỡ ngỡ.

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

> **Tóm gọn 1 câu:** Một server = Tools (tay làm) + Resources (mắt đọc) + Prompts (công thức sẵn) — Tools bắt buộc, hai cái còn lại tùy tác giả.

---

## 5. Tools approval (allow/ask/deny)

Mục này là phần an toàn quan trọng nhất của bài: cho Copilot làm gì được, làm gì phải xin phép, và làm gì cấm hẳn.

Approval là **gác cổng**: mỗi lần Copilot muốn bấm nút (Tool), gác cổng tra sổ → cho qua (allow) / hỏi bạn (ask) / cấm (deny). Nôm na: "xem TV (read) cứ xem, ra đường (browser/terminal) phải hỏi, sờ ổ điện (prod DB) thì cấm".

> 📄 **Code ví dụ:** [`examples/03-5-tools-approval-allow-ask-deny.jsonc`](examples/03-5-tools-approval-allow-ask-deny.jsonc)

**Thứ tự ưu tiên — thuộc lòng: `deny > ask > allow`** (luật của enterprise `managed-settings.json`, chi tiết bài 07):

- **Cấm (deny) luôn thắng.** Rule nào chưa khớp → mặc định **hỏi lại**. `ask` không lách được bằng bypass/YOLO mode.
- Allowlist hiệu lực cuối = **giao (intersection)** của mọi nguồn; khai `[]` = lockdown (cấm hết).
- Org policy (Business+): bật "MCP servers in Copilot" trước, rồi allowlist servers; audit logs MCP tool calls theo user/repo.

```text
 # Verify approval: 1. "liệt kê 5 PRs" (allow) → chạy luôn, không popup.
 # 2. "mở http://localhost:3000 bằng browser" (ask) → phải popup.
 # 3. gọi postgres-prod (deny) → "blocked by policy". Sai → check settings + org policy đè.
```

> **Tóm gọn 1 câu:** Gác cổng approval theo luật `deny > ask > allow`: đọc thì cho qua, ghi thì phải hỏi, prod thì cấm hẳn.

---

## 6. 5 server day-one (copy-paste)

Mục này là phần thực hành: 5 server đáng cài ngay ngày đầu, kèm file cấu hình chép vào là chạy. Mỗi server giải một nhu cầu khác nhau.

**GitHub — impact cao nhất, cài đầu tiên:**

> 📄 **Code ví dụ:** [`examples/04-6-5-server-day-one-copy-paste.sh`](examples/04-6-5-server-day-one-copy-paste.sh)

**Playwright — Copilot NHÌN UI qua browser thật:**

> 📄 **Code ví dụ:** [`examples/05-6-5-server-day-one-copy-paste.sh`](examples/05-6-5-server-day-one-copy-paste.sh)

**Postgres — đọc schema + query dev (KHÔNG commit password):**

> 📄 **Code ví dụ:** [`examples/06-6-5-server-day-one-copy-paste.sh`](examples/06-6-5-server-day-one-copy-paste.sh)

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

> 📄 **Code ví dụ:** [`examples/07-6-5-server-day-one-copy-paste.sh`](examples/07-6-5-server-day-one-copy-paste.sh)

**Linear/Notion — tickets, docs (remote, token cá nhân):**

> 📄 **Code ví dụ:** [`examples/08-6-5-server-day-one-copy-paste.sh`](examples/08-6-5-server-day-one-copy-paste.sh)

> **Tóm gọn 1 câu:** Bộ khởi động 5 server: GitHub (PR/issue), Playwright (nhìn UI), Postgres (đọc DB), Fetch/Brave (tra web), Linear/Notion (tickets).

---

## 7. Secrets + marketplace

### 7.1. Secrets matrix (thuộc lòng)

Mục này trả lời câu hỏi sống còn: làm sao dùng token mà không bao giờ lộ token vào git.

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

> **Tóm gọn 1 câu:** Secrets chỉ đi qua `${VAR}` — dính token thật vào file thì git history giữ mãi, phải rotate ngay.

### 7.2. Marketplace + registry (2026)

Mục này chỉ chỗ mua "bếp làm sẵn" thay vì tự khai từng dòng cấu hình.

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

> **Cách đọc bảng này:** Mỗi cột là một cách chạy GitHub MCP server — so hàng "Cần gì" và "Khi nào dùng" để chọn: muốn dùng ngay thì remote, muốn tự host thì Docker.

> **Tóm gọn 1 câu:** Cài nhanh thì dùng marketplace "MCP: Browse Servers", và GitHub server chạy được 2 kiểu: remote hosted (dùng ngay) hoặc Docker (tự host).

---

## 8. Prune — giữ MCP khỏe

Mục này dạy thói quen bảo dưỡng: định kỳ vứt server không dùng, giữ bộ tools gọn để Copilot không bị "ngợp".

**Sweet spot 3–6 servers, đừng quá ~10 tools visible** — menu 100 món thì bồi bàn loạn: quá nhiều tools → Copilot chọn sai/bỏ sót, IDE chậm, bề mặt lộ secret to.

| Server | Khi thêm | Khi prune (bỏ) |
|---|---|---|
| GitHub | Gần như luôn — impact cao nhất | Không bao giờ (trừ repo không dùng GitHub) |
| Playwright | Web app cần test UI | App không UI / đã có E2E khác |
| Postgres/MySQL | App có DB thật | Project docs-only |
| Fetch / Brave | Hay tra docs ngoài | Ít tra web / đã có docs local |
| Linear / Notion / Jira / Slack | Team sống trong đó | Team không dùng / đã migrate |

> **Cách đọc bảng này:** Mỗi dòng là một server phổ biến — cột 2 là lý do đáng cài, cột 3 là dấu hiệu cho biết nên tháo nó ra.

```text
 Prune flow (2 tuần/lần, 10 phút):
 1. "MCP: List Servers" → server nào disconnected lâu? 2 tuần rồi có gọi không?
    Không → disable 1 tuần; không ai kêu → xóa hẳn.
 2. Audit tools: "@workspace liệt kê MCP tools mày đang thấy" → server nào thừa?
 3. Audit secrets: grep (mục 7.1) → phải exit=1.
 # Kỳ vọng: còn 3-6 servers connected, tools gọn, secrets sạch.
```

> **Tóm gọn 1 câu:** Giữ 3–6 servers là đủ — mỗi 2 tuần prune một lần, server nào 0 calls thì disable rồi xóa.

---

## 9. Pitfalls + hiểu nhầm

Mục này là danh sách cái bẫy thực tế — mỗi hàng là một điều nhiều người tin nhầm kèm sự thật đằng sau.

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

> **Cách đọc bảng này:** Cột trái là câu bạn hay nghe ai đó nói, cột phải là sự thật hoặc cách xử lý đúng — đọc theo cặp là ra ngay.

> **Tóm gọn 1 câu:** Đừng cài MCP cho việc trong repo, đừng tích trữ servers, đừng paste token vào file — ba lỗi này chiếm gần hết mọi sự cố.

---

## Bài tập

1. **(15 phút)** Cài GitHub server (mục 6). Test 3 prompts: list PRs, đọc issue, search code — ghi lại Copilot đã gọi tools nào.
2. **(15 phút)** Cài Postgres dev + viết `db.instructions.md`. Test SELECT, verify prod guard (hỏi prod → phải từ chối).
3. **(10 phút)** Chạy prune flow (mục 8): tìm server 0 calls → disable; audit secrets bằng grep — exit code phải = 1.

> **Tóm gọn 1 câu:** Cài GitHub server, khóa DB bằng instructions, rồi prune — ba việc này là bài tập về nhà bắt buộc của bài.

## Link qua

- Instructions kèm MCP (schema DB, format) → bài 03. Skill gọi MCP theo quy trình → bài 05.
- Agents lock `tools` khi gọi MCP → bài 06. MCP allowlist + exclusion (defense in depth) → bài 07.
- Tool approval chi tiết → bài 10. MCP trong Actions + coding agent cloud (remote only) → bài 12.

> **Tóm gọn 1 câu:** Muốn đào sâu thì đi tiếp: bài 03/05 (cách dùng tay), bài 07/10 (khóa tay), bài 12 (tay trên cloud).

## Reference

- GitHub Copilot docs: https://docs.github.com/copilot
- VS Code Copilot docs: https://code.visualstudio.com/docs/copilot
- Model Context Protocol (chuẩn chung): https://modelcontextprotocol.io

> **Tóm gọn 1 câu:** Ba nguồn chính thức đáng bookmark: docs Copilot của GitHub, docs Copilot của VS Code, và spec của MCP.

> **Chốt:** MCP chỉ đáng cài khi dữ liệu nằm *ngoài* repo — và khi đã cài, giữ reach có kỷ luật: secrets qua env, read cho qua, write phải hỏi, prod thì cấm.
