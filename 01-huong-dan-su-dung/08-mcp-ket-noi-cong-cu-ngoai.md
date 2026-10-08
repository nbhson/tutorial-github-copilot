# 08 — MCP: Kết Nối Copilot Tới Thế Giới Ngoài (GitHub, DB, Browser...)

> **Dành cho:** người mới dùng Copilot Chat trong VS Code; tech lead / admin muốn chuẩn hóa MCP cho team.
> **Vấn đề:** Copilot giỏi ở trong repo, nhưng "mù" với mọi thứ ngoài repo (PR, issue, DB, web, ticket).
> **Đọc xong:** bạn setup được từng server GitHub/Playwright/Postgres/Fetch/Linear
> qua `.vscode/mcp.json`, hiểu Tools/Resources/Prompts (3 thành phần của 1 MCP server),
> hiểu tools approval, và prune MCP gọn ≤6 servers.
> Bài 08 của series. Thời gian: ~50 phút (bản mở rộng, giải thích nôm na).

**Thuật ngữ nhanh (Glossary) — mỗi thuật ngữ 3 lớp: định nghĩa, ví dụ đời thường, ví dụ kỹ thuật.**

| Thuật ngữ | Định nghĩa 1 câu | Ví dụ đời thường | Ví dụ kỹ thuật |
|---|---|---|---|
| **MCP** (Model Context Protocol) | Chuẩn chung để AI gọi ra công cụ ngoài, khỏi mỗi hãng viết 1 kiểu | Ổ cắm USB: 1 chuẩn cho mọi máy | `npx -y @modelcontextprotocol/server-github` |
| **MCP Client** | Bộ phận trong IDE nói chuyện với các MCP server | Shipper chuyển đơn từ khách tới quán | code JSON-RPC trong VS Code Copilot extension |
| **MCP Server** | Chương trình dịch lời gọi của Copilot sang hệ ngoài | Từng bếp riêng (bếp GitHub, bếp DB) | process `npx ...` bạn khai trong `mcp.json` |
| **Tools** | Hàm Copilot gọi để **LÀM** việc, có params | Nút bấm trong menu bếp | `github.create_pr`, `postgres.query` |
| **Resources** | Tài liệu Copilot **XEM** qua địa chỉ URI, không sửa | Sách có mã số kệ | `github://repos/acme/api/issues/123` |
| **Prompts** | Câu lệnh mẫu soạn sẵn của tác giả server | Gói gia vị pha sẵn cho món phở | template `review-pr` |
| **Approval** | Cổng gác cho phép / hỏi / cấm mỗi lần gọi tool | Bố mẹ dặn con: xem TV được, ra đường phải hỏi | `"playwright": "ask"` |
| **Transport** | Cách client nói chuyện với server | Gặp trực tiếp hay gọi qua điện thoại | `stdio`, `http`, `sse` |
| **Allowlist / Denylist** | Danh sách server được phép dùng / bị cấm | Sách trắng (được mượn) và sách đen (cấm mượn) | `allowedMcpServers`, `deniedMcpServers` |
| **Sandbox** (2026) | Hộp cát cách ly lệnh agent khỏi máy thật | Phòng thí nghiệm có kính chắn | `chat.agent.sandbox.enabled` |
| **Telemetry OTEL** (2026) | Chuẩn xuất log theo dõi ra hệ thống riêng của bạn | Máy ghi hành trình xe, chủ xe tự giữ dữ liệu | `telemetry.endpoint` (OTLP) |

## Mục lục

1. [MCP là gì — why (ổ USB + anh bồi bàn)](#1-mcp-là-gì--why-ổ-usb--anh-bồi-bàn)
2. [Sơ đồ: Copilot Chat → MCP Client → MCP Server → hệ ngoài](#2-sơ-đồ-copilot-chat--mcp-client--mcp-server--hệ-ngoài)
3. [Sequence: 1 request "liệt kê 5 PRs" đi qua các bước nào](#3-sequence-1-request-liệt-kê-5-prs-đi-qua-các-bước-nào)
4. [File `.vscode/mcp.json`: 3 transports](#4-file-vscode-mcpjson-3-transports)
5. [Một MCP server gồm 3 thành phần nào](#5-một-mcp-server-gồm-3-thành-phần-nào)
6. [Tools approval (allow/ask/deny theo server)](#6-tools-approval-allowaskdeny-theo-server)
7. [Setup từng server day-one (copy-paste)](#7-setup-từng-server-day-one-copy-paste)
8. [Secrets qua env/input + Copilot MCP marketplace](#8-secrets-qua-envinput--copilot-mcp-marketplace)
9. [Prune guide — giữ MCP khỏe](#9-prune-guide--giữ-mcp-khỏe)
10. [Hiểu nhầm thường gặp](#10-hiểu-nhầm-thường-gặp)
11. [Link chéo](#11-link-chéo)

---

## 1. MCP là gì — why (ổ USB + anh bồi bàn)

*Section này trả lời: MCP là gì, khi nào PHẢI cài, và khi nào KHÔNG nên cài.*

**Nôm na 1 câu:** MCP (Model Context Protocol) là **chuẩn cắm chung** để Copilot (AI ngồi trong VS Code) gọi ra thế giới ngoài (GitHub, database, browser, Linear...) mà không cần mỗi hãng viết 1 kiểu tích hợp riêng.

Nói cách khác: không có MCP thì mỗi tích hợp là 1 lối đi riêng. Có MCP thì mọi AI cùng nói 1 ngôn ngữ với mọi công cụ.

**Analogie đời thường — 2 analogie:**

1. **Ổ cắm USB:** Trước đây mỗi điện thoại 1 loại sạc (Nokia, Samsung, iPhone cũ...). USB-C ra đời → 1 chuẩn cắm cho mọi máy. MCP cũng vậy: trước đây mỗi AI phải viết plugin riêng cho GitHub/DB/browser. Giờ MCP Server viết 1 lần theo chuẩn MCP → Copilot, Claude, Cursor... đều cắm vào dùng được.
2. **Anh bồi bàn (waiter) gọi bếp:** Bạn (user) = khách. Copilot Chat = bồi bàn. MCP Server = bếp (bếp GitHub, bếp Postgres, bếp Browser). Bạn không vào bếp tự nấu — bạn gọi bồi bàn: "cho anh 5 PRs mới nhất". Bồi bàn (Copilot) viết phiếu (gọi Tool), đưa xuống bếp (MCP Server), bếp làm xong đưa đĩa lên (trả JSON), bồi bàn bưng ra + trình bày đẹp cho bạn.

**Ví dụ kỹ thuật copy-paste (nhìn 1 lần là hiểu MCP để làm gì):**

```text
KHÔNG MCP:
Bạn: "PR #123 đang bàn gì?"
Copilot: "Em không thấy GitHub, anh paste diff vào đây đi." → bạn copy-paste tay.

CÓ MCP (server github):
Bạn: "Tóm tắt PR #123 repo acme/api, mỗi thay đổi 1 dòng"
Copilot (tự gọi github MCP): đọc PR thật trên github.com → trả lời 5 dòng.
→ Bạn KHÔNG paste gì cả.
```

**Ai dùng lúc nào:**

- Bạn hỏi việc **nằm ngoài repo local** (PRs, issues, DB, web, tickets) → cần MCP.
- Dữ liệu đã nằm trong repo (`src/`, `docs/`) → Copilot đọc trực tiếp, **KHÔNG cần MCP** (thêm MCP chỉ tốn maintenance + popup approval mệt).
- Copilot hỗ trợ MCP ở VS Code, Visual Studio, JetBrains, Eclipse, Xcode. Neovim thì **không** (bảng feature matrix của GitHub).
- Công thức nhớ: **MCP = reach (vươn tay ra ngoài), instructions/skills = cách dùng reach đó cho đúng** (schema DB nào, message-format nào, quy ước repo nào).

```text
# Verify bạn đã hiểu MCP (tự check 30 giây):
# Hỏi: "Task này dữ liệu ở đâu?"
# - Trong repo → không MCP, dùng @workspace + instructions.
# - Ngoài repo (GitHub/DB/browser/SaaS) → cần MCP server tương ứng.
# Kỳ vọng: phân biệt được 2 trường hợp trên, không cài MCP "cho oai".
```

```mermaid
flowchart LR
  User[Bạn gõ prompt] --> Chat[Copilot Chat<br/>anh bồi bàn]
  Chat --> Client[MCP Client<br/>trong VS Code<br/>phiếu gọi món]
  Client --> GH[MCP Server: github<br/>bếp GitHub]
  Client --> PG[MCP Server: postgres-dev<br/>bếp Database]
  Client --> PW[MCP Server: playwright<br/>bếp Browser]
  GH --> Ext1[(github.com<br/>PRs/issues/code)]
  PG --> Ext2[(PostgreSQL dev<br/>tables/rows)]
  PW --> Ext3[(Chrome headless<br/>web app local)]
```

---

## 2. Sơ đồ: Copilot Chat → MCP Client → MCP Server → hệ ngoài

*Section này trả lời: trong 1 lời gọi MCP có 4 nhân vật, và ai làm việc gì thật trên máy.*

**Nôm na 1 câu:** Có 4 nhân vật: bạn gõ → Copilot Chat nghĩ ("cần gọi bếp nào?") → MCP Client (shipper trong VS Code) chuyển lời → MCP Server (bếp) làm thật với hệ ngoài rồi trả kết quả về.

**Analogie:** Như gọi GrabFood: bạn (user) bấm app → tổng đài Grab (Copilot Chat) điều tài → tài xế (MCP Client) chạy tới quán → quán (MCP Server) nấu + đưa món từ kho (hệ ngoài: GitHub/DB/web).

| Nhân vật | Là file/process gì thật | Ai tạo ra nó | Ai gọi nó |
|---|---|---|---|
| **Copilot Chat** | Panel Chat trong VS Code + model (GPT/Claude) | Microsoft/GitHub (built-in) | Bạn gõ prompt |
| **MCP Client** | Đoạn code trong VS Code Copilot extension, nói JSON-RPC | VS Code tự có (bạn không cần cài) | Copilot Chat gọi khi cần tool ngoài |
| **MCP Server** | Process riêng (vd `npx server-github`), bạn khai trong `mcp.json` | Cộng đồng/hãng viết (npm package, binary, URL remote) | MCP Client spawn (stdio) hoặc gọi HTTP/SSE |
| **Hệ ngoài** | github.com, Postgres, Chrome, Linear... | Đã tồn tại sẵn | Chỉ MCP Server nói chuyện trực tiếp (giữ token, connection) |

**Ví dụ kỹ thuật copy-paste — nhìn process thật:**

```bash
# Khi VS Code khởi động, với mcp.json mục 4, nó spawn:
# - npx -y @modelcontextprotocol/server-github   (PID riêng, giữ GITHUB_TOKEN)
# - npx -y @playwright/mcp@latest                (giữ Chrome headless)
# - npx -y @modelcontextprotocol/server-postgres postgresql://... (giữ DB conn)
# Bạn kiểm chứng:
ps aux | grep -i "modelcontextprotocol\|playwright/mcp" | grep -v grep
# Kỳ vọng: thấy 2-3 dòng process MCP đang chạy. Không thấy → "MCP: List Servers" báo disconnected.
```

**Ai dùng lúc nào:**

- Người mới: chỉ cần biết "khai server trong mcp.json → Chat tự thấy tools". Không cần code MCP Server.
- Người debug sâu / viết server nội bộ: mới cần biết Client↔Server nói JSON-RPC qua stdio/http/sse.

```mermaid
flowchart TB
  U[User: liệt kê 5 PRs] --> C[Copilot Chat<br/>model suy luận]
  C --> MC[MCP Client trong VS Code]
  MC -- stdio: spawn npx --> GHS[Server github]
  MC -- stdio: spawn npx --> PGS[Server postgres-dev]
  MC -- stdio: spawn npx --> PWS[Server playwright]
  MC -- http + Bearer --> LNS[Server linear remote]
  GHS --> GHAPI[(api.github.com)]
  PGS --> DB[(PostgreSQL dev)]
  PWS --> CHR[(Chromium headless)]
  LNS --> LIN[(linear.app API)]
```

---

## 3. Sequence: 1 request "liệt kê 5 PRs" đi qua các bước nào

*Section này trả lời: từ lúc bạn gõ prompt đến lúc Copilot trả lời có những bước nào, và bước nào cần bạn bấm Allow.*

**Nôm na 1 câu:** 1 câu hỏi của bạn được Copilot tách thành 6 bước: hiểu ý → hỏi danh sách tools → chọn đúng tool → xin phép bạn (approval) → gọi bếp làm → nhận JSON rồi kể lại bằng tiếng người.

**Ví dụ end-to-end thật (copy-paste để test):**

```text
Bạn gõ trong Chat:
> @workspace liệt kê 5 PRs mở gần nhất của repo này + tóm tắt mỗi PR 1 dòng
```

```mermaid
sequenceDiagram
  participant U as Bạn (User)
  participant Chat as Copilot Chat (model)
  participant Client as MCP Client (VS Code)
  participant GH as MCP Server: github
  participant API as github.com API
  U->>Chat: liệt kê 5 PRs mở gần nhất?
  Chat->>Client: tools/list — cho tao xem có bếp nào?
  Client->>GH: JSON-RPC tools/list
  GH-->>Client: [list_prs, get_pr, search_code...] + schema
  Client-->>Chat: có tool github.list_prs(owner, repo, state, limit)
  Chat->>U: Approval: cho gọi github.list_prs? [Allow/Ask]
  U->>Chat: Allow
  Chat->>Client: tools/call list_prs {owner:acme, repo:api, state:open, limit:5}
  Client->>GH: JSON-RPC tools/call
  GH->>API: GET /repos/acme/api/pulls?state=open&per_page=5 (kèm token)
  API-->>GH: JSON 5 PRs (number, title, author...)
  GH-->>Client: JSON result (structuredContent)
  Client-->>Chat: JSON 5 PRs
  Chat->>U: Trình bày 5 dòng tiếng Việt gọn (không dump JSON thô)
```

**Giải thích từng bước (ai làm gì):**

1. **Bạn gõ:** ý định tiếng Việt.
2. **`tools/list`:** khi Chat khởi động (và mỗi lần mcp.json reload), MCP Client hỏi từng Server "mày có món gì?" → Server trả danh sách tools + input schema (xem mục 5.1 ví dụ JSON thật). Bước này **không cần approval**, chỉ khám phá menu.
3. **Model chọn tool:** model đọc menu + prompt của bạn → quyết định "cần `list_prs` của server github, params owner/repo/limit".
4. **Approval:** VS Code đối chiếu rules allow/ask/deny (mục 6). `github read → allow` thì chạy luôn; `playwright click / postgres write → ask` thì hiện popup cho bạn bấm.
5. **`tools/call`:** Client gửi JSON-RPC `tools/call` kèm params → Server gọi API/DB thật (giữ secrets, bạn không lộ token cho model).
6. **Trình bày:** Server trả JSON thô → model tóm tắt thành 5 dòng tiếng người. **Model không bao giờ cầm token GitHub** — token nằm ở Server process.

```text
# Verify sequence này (copy-paste):
# 1. VS Code → Ctrl+Shift+P → "MCP: List Servers" → github phải Connected.
# 2. Chat: "@workspace liệt kê MCP tools mày đang thấy" → phải kể ra list_prs, get_pr...
# 3. Chat: "liệt kê 5 PRs mở gần nhất của repo này" → quan sát popup approval + kết quả 5 dòng.
# Kỳ vọng: bước 1 Connected, bước 2 kể đúng tools, bước 3 ra 5 PRs thật.
# Không được → server disconnected (token hết hạn) hoặc approval deny (mục 6).
```

---

## 4. File `.vscode/mcp.json`: 3 transports

*Section này trả lời: khai server ở file nào, và 3 cách kết nối (transport) khác nhau dùng khi nào.*

**Nôm na 1 câu:** `mcp.json` là **danh bạ bếp** — khai mỗi bếp ở đâu, gọi bằng cách nào (spawn local hay gọi URL remote), secrets lấy từ đâu.

**Analogie:** Như danh bạ GrabFood lưu quán yêu thích: quán gần nhà (stdio — nấu tại bếp local), quán ở xa giao qua app (http/sse — gọi qua mạng).

**Vị trí file khai server (theo docs 2026 — mỗi bề mặt đọc 1 chỗ, chưa có format chung duy nhất):**

```text
.vscode/mcp.json           # workspace/repo-level, key "servers", commit cho team (KHÔNG secrets! Chỉ ${VAR})
mcp.json / .mcp.json (root repo) # portable, key "mcpServers"; 1 số bản cũ fallback — ưu tiên .vscode/mcp.json
~/.copilot/mcp-config.json # portable user profile, key "mcpServers" (viết tắt $COPILOT_HOME/mcp-config.json)
~/.vscode/mcp.json        # personal global (tùy bản VS Code, cho token cá nhân)
```

**Lưu ý thêm về vị trí:**

- Copilot CLI đọc `~/.mcp-config.json` + `.mcp.json` ở repo. Từ CLI v1.0.39, CLI **không còn đọc** `.vscode/mcp.json` (đổi BREAKING).
- Cấu hình repo trên github.com: Settings → Copilot → MCP servers. JSON dùng key `mcpServers`, **bắt buộc** có mảng `tools` (hoặc `"*"`), kiểu server `local|stdio|http|sse`, secret để sẵn prefix `COPILOT_MCP_`.
- Bạn không cần nhớ hết: người mới chỉ cần `.vscode/mcp.json` cho VS Code.

**Ai dùng lúc nào:**

- Servers dùng chung không secrets riêng (github team token, fetch, playwright) → `.vscode/mcp.json` (commit).
- Servers token cá nhân (linear/notion của mỗi người) → personal config (không commit). Ghi rõ trong README để teammate mới không hỏi lại.
- Coding agent cloud & code review: chỉ gọi được MCP **tools** (không có resources/prompts), và chưa hỗ trợ remote MCP dùng OAuth.

**Ví dụ kỹ thuật copy-paste — khung đầy đủ (giữ nguyên toàn bộ, chỉ thêm comment giải thích):**

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

| Transport | Nôm na | Khi nào dùng | Lưu ý (ai dùng lúc nào) |
|---|---|---|---|
| `stdio` | Bếp nấu tại nhà bạn (spawn process local) | Server local (github, playwright, postgres, fetch) | Cần `npx`/`node` + binary cài được. Nhanh nhất. **Không theo lên coding agent cloud** (cloud không có máy bạn) |
| `http` | Gọi quán qua app giao đồ (remote, streamable HTTP) | Server remote mới (linear, internal API) | URL + headers auth qua env. Cloud-friendly. **Khuyên dùng cho server remote mới** |
| `sse` | Gọi quán qua điện thoại bàn cũ (remote streaming cũ) | Server remote cũ (notion, 1 số SaaS) | Dần thay bằng `http`. Giữ nếu docs server yêu cầu `sse` |

```bash
# Verify sau khi sửa mcp.json (copy-paste):
# 1. Reload: VS Code → Ctrl+Shift+P → "MCP: List Servers" → phải thấy servers Connected.
# 2. Chat test: "@workspace liệt kê MCP tools mày đang thấy" → đọc list.
# 3. Secrets audit: grep secrets, phải TRỐNG!
grep -rniE "ghp_|gho_|sk-|xox-|password\s*[:=]" .vscode/mcp.json; echo "exit=$? (1 = sạch, 0 = CÓ LỘ!)"
# Kỳ vọng: (1) Connected, (2) kể được tools, (3) exit=1.
```

---

## 5. Một MCP server gồm 3 thành phần nào

*Section này trả lời: 1 MCP server gồm những gì, và tại sao nhớ được công thức "Tools = tay, Resources = mắt, Prompts = công thức".*

> **Đây là phần user phàn nàn — giải thích lại từ đầu, mỗi thành phần 1 tiểu mục riêng.**
> Nhớ công thức: **Tools = tay (làm), Resources = mắt (đọc), Prompts = công thức nấu sẵn.**

```mermaid
flowchart LR
  S[MCP Server<br/>vd github] --> T[Tools<br/>hàm gọi có params]
  S --> R[Resources<br/>dữ liệu đọc qua URI]
  S --> P[Prompts<br/>template câu lệnh mẫu]
  T -->|Copilot gọi khi cần LÀM| A[github.create_pr<br/>postgres.query]
  R -->|Copilot đọc khi cần XEM| B[github://repos/.../issues/123]
  P -->|Copilot gợi ý khi cần MẪU| C[review-pr template]
```

- **Ai tạo:** Tác giả MCP Server (người viết npm package / host remote) quyết định expose Tools nào, Resources nào, Prompts nào. Bạn (người dùng) **không tạo**, chỉ **khai server trong mcp.json + gọi qua Chat**.
- **Ai gọi:** Copilot Chat (qua MCP Client) là người duy nhất gọi. Bạn không gọi JSON-RPC tay — bạn gõ tiếng Việt, Copilot dịch thành `tools/call`.

### 5.1. Tools — hàm Copilot gọi (tay để LÀM)

*Tiểu mục này trả lời: tool là gì, và Copilot dùng tool khi nào.*

**Nôm na 1 câu:** Tools là **các nút bấm / hàm** mà Copilot được phép bấm, mỗi nút có tờ hướng dẫn (input schema: cần params gì, kiểu gì).

**Analogie:** Như menu bếp có nút "Tạo PR", "Chạy SQL", "Click nút web". Bồi bàn (Copilot) đọc menu rồi bấm đúng nút + điền phiếu (params).

**Ví dụ kỹ thuật copy-paste — JSON schema thật (rút gọn từ server github thật):**

```json
// Copilot thấy cái này sau tools/list (bạn không gõ tay, nhưng HIỂU để debug):
{
  "name": "github.create_pr",
  "description": "Tạo pull request mới. Dùng khi user nói tạo PR / mở PR.",
  "inputSchema": {
    "type": "object",
    "properties": {
      "owner": { "type": "string", "description": "vd acme" },
      "repo": { "type": "string", "description": "vd api" },
      "title": { "type": "string" },
      "head": { "type": "string", "description": "branch nguồn vd feat/login" },
      "base": { "type": "string", "description": "branch đích vd main" },
      "body": { "type": "string" }
    },
    "required": ["owner", "repo", "title", "head", "base"]
  }
}
```

```json
// Ví dụ thứ 2 — postgres.query (bếp DB):
{
  "name": "postgres.query",
  "description": "Chạy SELECT read-only lên DB dev. Dùng khi user hỏi dữ liệu trong DB.",
  "inputSchema": {
    "type": "object",
    "properties": {
      "sql": { "type": "string", "description": "Chỉ SELECT + WHERE + LIMIT 100" }
    },
    "required": ["sql"]
  }
}
```

**Ví dụ JSON-RPC `tools/list` rút gọn (để bạn hình dung server expose gì):**

```json
// MCP Client gửi:
{ "jsonrpc": "2.0", "id": 1, "method": "tools/list", "params": {} }
// MCP Server github trả về (rút gọn):
{
  "jsonrpc": "2.0", "id": 1,
  "result": {
    "tools": [
      { "name": "list_prs", "description": "Liệt kê PRs", "inputSchema": { "type": "object", "properties": { "owner": {"type":"string"}, "repo": {"type":"string"}, "state": {"type":"string"}, "limit": {"type":"number"} } } },
      { "name": "get_pr", "description": "Đọc 1 PR chi tiết", "inputSchema": { "type": "object", "properties": { "owner": {"type":"string"}, "repo": {"type":"string"}, "pr": {"type":"number"} } } },
      { "name": "create_pr", "description": "Tạo PR mới", "inputSchema": { "type": "object", "properties": { "owner": {"type":"string"}, "repo": {"type":"string"}, "title": {"type":"string"} } } }
    ]
  }
}
```

**Copilot dùng khi nào:**

- Bạn nói "liệt kê / tạo / tìm / query / mở browser..." → Copilot tra menu tools → chọn tool khớp nhất → xin approval → gọi `tools/call` kèm params.
- Tools **có side effects** (tạo PR, chạy query write, click browser) luôn đi qua approval ask/deny (mục 6).

```text
# Verify Tools (copy-paste):
# Chat: "@workspace server github đang expose tools gì? Kể tên + 1 câu mỗi tool."
# Kỳ vọng: kể ra list_prs, get_pr, create_pr... kèm mô tả.
# Không kể được → server disconnected hoặc chưa reload sau sửa mcp.json.
```

### 5.2. Resources — dữ liệu đọc (mắt để XEM, địa chỉ bằng URI)

*Tiểu mục này trả lời: resource là gì, và nó khác tool ở điểm nào.*

**Nôm na 1 câu:** Resources là **tài liệu/mắt đọc** mà server cho Copilot xem, mỗi tài liệu có địa chỉ URI (như link) để Copilot mở ra đọc, **không có side effects** (chỉ đọc, không sửa).

**Analogie:** Như thư viện: mỗi cuốn sách có mã số kệ (`github://repos/acme/api/issues/123`). Bồi bàn không vào kho lục — đưa mã số cho thủ thư (Server), thủ thư mang sách ra.

**Ví dụ kỹ thuật copy-paste — URI thật + cách Copilot đọc:**

```text
URI thật (mỗi server quy ước riêng, docs của server liệt kê):
github://repos/acme/api/issues/123          → issue #123 repo acme/api
github://repos/acme/api/pulls/456/diff      → diff PR #456
postgres://acme_dev/tables/orders/schema    → schema table orders (tùy server)
docs://runbook/deploy-staging               → runbook nội bộ (server docs riêng)
```

```json
// JSON-RPC resources/list rút gọn (server báo có tài liệu gì):
{ "jsonrpc": "2.0", "id": 2, "method": "resources/list", "params": {} }
// Trả về:
{ "jsonrpc": "2.0", "id": 2, "result": { "resources": [
  { "uri": "github://repos/acme/api/issues/123", "name": "Issue 123", "mimeType": "application/json" }
]}}
// Đọc 1 resource:
{ "jsonrpc": "2.0", "id": 3, "method": "resources/read", "params": { "uri": "github://repos/acme/api/issues/123" } }
```

**Copilot dùng khi nào:**

- Bạn nói "đọc issue #123 / xem schema table orders / mở runbook deploy..." → Copilot gọi `resources/read` (không cần approval gắt như Tools vì read-only).
- Khác Tools ở chỗ: Tools = **hàm có params** (làm gì đó), Resources = **địa chỉ URI** (xem cái gì đó). Nhiều server chỉ expose Tools (không có Resources) — vẫn chạy tốt.

```text
# Verify Resources (copy-paste):
# Chat: "@workspace server github có resources gì? Liệt kê URI mẫu."
# Kỳ vọng: kể URI dạng github://... Nếu server không expose resources → trả lời "chỉ có tools".
# Đây là bình thường — không phải lỗi. Tools mới là bắt buộc, Resources/Prompts là tùy chọn.
```

### 5.3. Prompts — templates server expose (công thức nấu sẵn)

*Tiểu mục này trả lời: prompt của server là gì, và khi nào nên dùng nó thay prompt file của team.*

**Nôm na 1 câu:** Prompts là **câu lệnh mẫu / công thức** mà tác giả server soạn sẵn ("review PR theo 4 bước này", "triage issue theo format kia"), để bạn/Copilot gọi 1 phát là chạy đúng chuẩn, khỏi nghĩ.

**Analogie:** Như gói gia vị pha sẵn cho món phở: thay vì tự nêm từng thìa, bạn xé 1 gói là đúng vị. Server đưa gói gia vị (prompt template), Copilot pha theo.

**Ví dụ kỹ thuật copy-paste — prompt template thật:**

```text
// Server expose prompt tên "review-pr" (tùy server, không phải server nào cũng có):
// prompts/list trả về:
{ "name": "review-pr", "description": "Review PR tìm bug + security", "arguments": ["owner","repo","pr"] }

// prompts/get review-pr với {owner:acme, repo:api, pr:123} trả về template:
"Bạn là reviewer. Đọc PR {owner}/{repo}#{pr} rồi trả lời theo format:
1. Tóm tắt 3 dòng. 2. Findings [CRITICAL|HIGH|MED|LOW] file:line — mô tả — fix.
3. Kết luận APPROVE / REQUEST_CHANGES. KHÔNG nitpick style."
// Copilot lấy template này + điền params thật → chạy như 1 prompt file động.
```

**Copilot dùng khi nào:**

- Bạn gõ `/` trong Chat → ngoài prompt files repo (bài 05), còn thấy prompts từ MCP servers (namespaced, vd `/github:review-pr` tùy bản).
- Khi nào dùng Prompts vs prompt files repo? Prompt files repo = **chuẩn team bạn** (commit git, chỉnh được). Prompts của server = **chuẩn tác giả server** (dùng ngay, không chỉnh). Team nghiêm túc → copy ý từ server prompt vào `.github/prompts/` của mình để chỉnh theo team.

```text
# Verify Prompts (copy-paste):
# Chat: "gõ / xem có prompts nào từ MCP servers không? Liệt kê."
# Kỳ vọng: thấy prompt files repo (.github/prompts/) + (nếu server có) prompts server.
# Không thấy prompts server → bình thường (nhiều server không expose prompts).
```

```mermaid
flowchart TD
  A[Bạn cần gì?] --> B{Làm - Xem - Mẫu?}
  B -->|LÀM gì đó| T[Tools<br/>tools/call + params<br/>vd tạo PR, chạy SQL]
  B -->|XEM cái gì| R[Resources<br/>resources/read + URI<br/>vd đọc issue 123]
  B -->|MẪU làm theo| P[Prompts<br/>prompts/get + args<br/>vd template review-pr]
```

---

## 6. Tools approval (allow/ask/deny theo server)

*Section này trả lời: khi nào Copilot tự chạy, khi nào phải hỏi bạn, khi nào bị cấm — và admin chốt bằng gì.*

**Nôm na 1 câu:** Approval là **người gác cổng**: mỗi lần Copilot muốn bấm nút (Tool), gác cổng tra sổ (rules) → cho qua luôn (allow) / hỏi bạn 1 click (ask) / cấm hẳn (deny).

**Analogie:** Như bố mẹ dặn con: "xem TV (read) cứ xem, ra đường (browser/terminal) phải hỏi, sờ ổ điện (prod DB/deploy) thì cấm".

**Ví dụ kỹ thuật copy-paste (giữ nguyên, thêm giải thích ai dùng lúc nào):**

```jsonc
// .vscode/settings.json — approval theo server/tool (commit cho team)
{
  "github.copilot.chat.toolAutoRun": "ask",
  "github.copilot.chat.mcp.tools": {
    "github": "allow",            // GitHub MCP: cho qua (đọc PR/issues) — read-only, an toàn
    "fetch": "allow",             // fetch web: cho qua — đọc docs, an toàn
    "playwright": "ask",          // browser automation: hỏi trước (click có side effects)
    "postgres-dev": "ask",         // DB dev: hỏi trước (query sai tốn tiền, write nguy hiểm)
    "postgres-prod": "deny"       // DB prod: cấm hẳn (không tạo server prod nếu không cần)
  }
}
```

```text
Org-level (admin, ai dùng lúc nào: team Business+ cần chuẩn chung):
github.com → Org Settings → Copilot → Policies → MCP:
- Allowlist servers: chỉ github, fetch, linear được dùng. Server lạ → block ở client.
- Default tool approval: terminal/browser = ask cho cả org.
- Audit: xem logs MCP tool calls theo user/repo (Business/Enterprise).

Quy tắc team (thuộc lòng):
- Read-only tools (github read, fetch, linear read) → allow.
- Side-effect tools (browser click, DB write, post message) → ask.
- Prod/destructive (prod DB, deploy, xóa) → deny + không tạo server.
```

**Thứ tự ưu tiên — thuộc lòng: `deny` > `ask` > `allow`.** Đây là luật của enterprise managed settings (`managed-settings.json`):

- `permissions.deny`, `permissions.ask`, `permissions.allow` khai ở admin. **Cấm (deny) luôn thắng.** Hỏi (ask) thắng cho qua (allow).
- Nếu xuất hiện bất kỳ rule/allowlist nào mà lệnh của bạn chưa khớp → mặc định chuyển sang **hỏi lại**.
- `ask` không thể bị "lách" bằng bypass/YOLO mode, cũng không lưu được approve mãi mãi.
- Allowlist hiệu lực cuối cùng = **giao (intersection)** của mọi nguồn cấu hình.
- Muốn chặn luôn bypass: `permissions.disableBypassPermissionsMode`.

**Allowlist / denylist MCP (dành cho admin/org owner):**

- `allowedMcpServers` / `deniedMcpServers` trong enterprise managed settings: **deny thắng allow**; cũng tính theo giao các nguồn; khai `[]` rỗng = **lockdown** (cấm hết).
- Org/enterprise phải bật policy **"MCP servers in Copilot"** trước (Business/Enterprise).
- Repo level: "Allow Copilot to use MCP tools when reviewing pull requests" — **bật sẵn mặc định**.
- Server bật sẵn mặc định: **GitHub MCP server** + **Playwright MCP server**.

**Network allowlist (dành cho admin — firewall của máy bạn):**

- `https://*.githubcopilot.com/*` (mọi plan); `https://*.individual.githubcopilot.com`; `https://*.business.githubcopilot.com`; `https://*.enterprise.githubcopilot.com` (theo plan, routing theo subscription).
- `https://github.com/login/*`, `https://collector.github.com/*`, `https://copilot-telemetry.githubusercontent.com/telemetry`, `https://default.exp-tas.com`, `https://origin-tracker.githubusercontent.com` (dò public code).
- GHE.com data-residency: `https://*.SUBDOMAIN.ghe.com`.

**Mới năm 2026 — sandbox local + telemetry OTEL:**

- **Sandbox (hộp cát):** `sandbox` trong managed_settings đặt mức tối thiểu cho command/fs/network/credentials/local MCP+LSP. Mạng khai qua `sandbox.userPolicy.network.allowOutbound`, `allowLocalNetwork`, `allowedHosts`, `blockedHosts`. Ở VS Code: `chat.agent.sandbox.enabled` + bật/tắt từng phiên (v1.141, chạy trên Windows/macOS/Linux).
- **Telemetry OTEL (OpenTelemetry):** khóa `telemetry` trong managed_settings — `enabled`, `endpoint` (OTLP), `protocol` (`http/json` hoặc `http/protobuf`), `captureContent`, `lockCaptureContent`, `serviceName`, `resourceAttributes`, `headers`. Dùng khi công ty bạn muốn Copilot tự gửi log về hệ thống quan sát (observability) của mình.

```text
# Verify approval (copy-paste, 2 phút):
# 1. Chat read-only: "liệt kê 5 PRs" → phải chạy luôn (allow, không popup).
# 2. Chat side-effect: "mở http://localhost:3000 bằng browser" → phải popup Ask.
# 3. Chat deny: gọi tool postgres-prod (nếu có) → phải báo "blocked by policy".
# Kỳ vọng: 1 chạy luôn, 2 hỏi, 3 cấm. Sai → check .vscode/settings.json + org policy đè.
```

---

## 7. Setup từng server day-one (copy-paste)

*Section này trả lời: 5 server đầu tiên cài theo thứ tự nào, lệnh nào copy-paste, và ai thì nên bỏ qua server đó.*

> Giữ nguyên toàn bộ steps, chỉ thêm nôm na + ai dùng lúc nào + verify cho mỗi server.

### 7.1. GitHub (impact cao nhất — cài đầu tiên)

**Nôm na:** Bếp GitHub cho Copilot đọc/tạo PRs, issues, search code mà không cần bạn paste link.

**Ai dùng lúc nào:** Gần như mọi team dùng GitHub → cài đầu tiên. Repo không dùng GitHub (GitLab thuần) thì bỏ qua.

```bash
# Bước 1: tạo token (fine-grained, chỉ repo cần) → lưu vào env, KHÔNG paste vào file:
export GITHUB_TOKEN="ghp_..."   # đặt trong ~/.zshrc hoặc VS Code env, không commit
# Verify token:
gh auth status   # phải thấy Logged in (hoặc curl check token scope)

# Bước 2: thêm vào .vscode/mcp.json (mục 4, server "github"). Dùng ${GITHUB_TOKEN}.

# Bước 3: verify trong Chat:
# > "@workspace liệt kê 5 PRs mở gần nhất của repo này + tóm tắt mỗi PR 1 dòng"
# Kỳ vọng: Copilot gọi github MCP, trả 5 dòng. Không được → "MCP: List Servers" check status.
```

### 7.2. Playwright (browser automation — Copilot NHÌN UI)

**Nôm na:** Bếp browser mở Chrome thật, chụp màn hình web bạn đang code, rồi nhận xét "nút này lệch, form này lỗi".

**Analogie:** Như nhờ bạn ngồi cạnh nhìn màn hình giúp: "ê xem trang login tao vừa code có ổn không?".

**Ai dùng lúc nào:** Team có web app cần test UI. App không UI (API thuần, docs-only) → prune (bỏ).

```bash
# Bước 1: server đã có trong mcp.json (mục 4, "playwright"). Cài browsers 1 lần:
npx playwright install chromium

# Bước 2: boot app local rồi nhờ Copilot nhìn:
pnpm dev &
# Trong Chat (approval playwright = ask → bấm Allow khi hỏi):
# > "mở http://localhost:3000/login bằng browser, chụp màn hình, nhận xét UI có vấn đề gì"
# Kỳ vọng: Copilot mở browser thật + ảnh screenshot + 3-5 nhận xét UI.
```

> Playwright stdio KHÔNG theo lên coding agent cloud — cloud cần browser MCP
> remote hoặc nhờ agent chụp artifact CI (xem bài 12).

### 7.3. Postgres (đọc schema + query — KHÔNG commit password)

**Nôm na:** Bếp DB cho Copilot nhìn vào database dev ("có tables gì, mỗi table bao nhiêu rows") mà không cần bạn dump SQL paste vào chat.

**Ai dùng lúc nào:** App có DB thật. Project docs-only, không DB → không cài.

```bash
# Bước 1: secrets qua env, KHÔNG paste connection string vào file:
export DATABASE_URL="postgresql://dev@localhost:5432/acme_dev"  # dev only!
# Server dùng ${DATABASE_URL} (mục 4, "postgres-dev").

# Bước 2: verify (chỉ đọc, không viết):
# > "liệt kê tables trong DB + đếm rows mỗi table, chỉ đọc không viết"
# Kỳ vọng: list tables + counts. Hỏi prod → phải từ chối (guard dưới).
```

```text
Quy tắc an toàn DB (thuộc lòng):
- Dev DB: cho read + (cân nhắc) write qua instructions giới hạn.
- Prod DB: KHÔNG tạo server prod trong mcp.json team. Cần thì personal + read-only + approval deny write.
- Không bao giờ paste connection string prod vào chat/mcp.json committed.
- Kèm instructions .github/instructions/db.instructions.md: "prod CHỈ SELECT + WHERE + LIMIT".
```

```markdown
<!-- .github/instructions/db.instructions.md — kèm postgres MCP (copy-paste) -->
---
applyTo: "**/*.sql"
---
# DB Query rules
- Dev DB (`$DATABASE_URL` trỏ dev): SELECT thoải mái, limit 100 rows.
- Prod: CHỈ SELECT, bắt buộc WHERE + LIMIT, KHÔNG DELETE/DROP/UPDATE.
- Output: tối đa 20 rows trong chat, nhiều hơn → export file.
```

### 7.4. Fetch/Brave (web grounding live)

**Nôm na:** Bếp web cho Copilot fetch tài liệu mới nhất trên mạng (docs GitHub, changelog) thay vì trả lời bằng kiến thức cũ.

**Ai dùng lúc nào:** Hay tra docs ngoài, cần thông tin live. Đã có docs local đầy đủ / offline → không cần.

```bash
# Server "fetch" đã có trong mcp.json (stdio, không auth).
# Test (copy-paste prompt):
# > "fetch docs https://docs.github.com/en/copilot tóm tắt 10 dòng về custom agents"
# Kỳ vọng: tóm tắt 10 dòng từ trang thật, không bịa.
# Brave Search (cần API key qua env):
export BRAVE_API_KEY="..."   # https://brave.com/search/api/
# Thêm server tương tự linear (http + header Authorization: Bearer ${BRAVE_API_KEY}).
```

### 7.5. Linear/Notion (tickets, docs — remote http/sse + token riêng)

**Nôm na:** Bếp tickets/docs cho Copilot đọc task Linear, docs Notion ("task AUTH-123 yêu cầu gì?").

**Ai dùng lúc nào:** Team sống trong Linear/Notion/Jira/Slack. Team không dùng / đã migrate tool → prune.

```bash
# Mỗi người token riêng → KHÔNG commit token. Dùng env:
export LINEAR_API_KEY="..."    # Linear → Settings → API
export NOTION_API_KEY="..."    # Notion → Integrations → New integration
# Servers dùng ${...} placeholders (mục 4). Scope personal nếu token cá nhân:
# → để servers này ở ~/.vscode/mcp.json thay vì .vscode/mcp.json team.
# Verify: Chat "@workspace liệt kê tasks Linear của tao" → ra tasks thật.
```

```text
Quy ước team (dán vào README):
servers dùng chung không secrets (github, fetch, playwright) → .vscode/mcp.json (commit).
servers token cá nhân (linear, notion) → personal config (không commit).
```

---

## 8. Secrets qua env/input + Copilot MCP marketplace

*Section này trả lời: giấu token ở đâu cho khỏi lộ, và đi tìm server mới từ đâu.*

### 8.1. Secrets matrix (thuộc lòng)

**Nôm na 1 câu:** Secrets (token, password) **luôn đi qua biến môi trường `${VAR}`**, không bao giờ gõ chữ thật vào file commit.

**Analogie:** Như không khắc mật khẩu két lên cửa két — mật khẩu để trong đầu (env), cửa chỉ ghi "hỏi chủ nhà".

```text
ĐƯỢC (secrets qua env — commit an toàn):
  "env": { "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}" }
  "args": ["...server-postgres", "${DATABASE_URL}"]
  "headers": { "Authorization": "Bearer ${LINEAR_API_KEY}" }

CẤM (paste trực tiếp — lộ khi commit, phải rotate ngay):
  "env": { "TOKEN": "ghp_abc123..." }          → lộ khi commit
  "args": ["postgresql://user:PASS@host/db"]   → lộ khi commit
  "headers": { "Authorization": "Bearer sk-.." } → lộ khi commit

Audit 1 dòng (chạy trước mỗi PR — copy-paste):
  grep -rniE "ghp_|gho_|sk-|xox-|password\s*[:=]" .vscode/mcp.json; echo "exit=$? (1 = sạch)"
# Kỳ vọng: exit=1 (sạch). exit=0 → CÓ LỘ, git rm + rotate creds ngay (bài 07).
```

```bash
# Dùng env từ gh CLI thay vì lưu plaintext (copy-paste):
export GITHUB_TOKEN="$(gh auth token)"  # lấy từ gh CLI, không lưu plaintext
# Verify: echo ${GITHUB_TOKEN:0:4}... → phải ra ghp_/gho_..., không rỗng.
```

**Ai dùng lúc nào:** Mọi server cần auth đều dùng pattern này. Không có ngoại lệ "tạm paste rồi xóa sau" — git history giữ mãi.

### 8.2. Copilot MCP marketplace / registry (2026)

**Nôm na:** Chợ (marketplace) để browse + cài server 1 click, khỏi gõ JSON tay.

**Ai dùng lúc nào:** Người mới (cài nhanh), hoặc tìm server chuẩn thay vì copy JSON trôi nổi trên mạng.

```text
VS Code → Ctrl+Shift+P → "MCP: Browse Servers" (marketplace/registry):
- Bước 1: Browse → chọn server (github, playwright, postgres...) → Install.
- Bước 2: VS Code tự chèn vào mcp.json → bạn thay secrets bằng ${ENV} (mục 8.1).
- Bước 3: "MCP: List Servers" → connected? Chat test 1 prompt.
- Org: admin có thể allow/block từng server trong marketplace (Policies → MCP).
- Verify: sau Install, mcp.json có thêm block server mới + grep secrets vẫn sạch.

Khác extensions (bài 09): MCP server = 1 tool provider (1 bếp).
Extension = có thể bundle MCP + chat participants + commands (1 combo).
Cài extension Copilot-related có thể tự thêm MCP (cài 1 được 2 — review URL/secrets).
```

**Ngoài chợ trong VS Code, còn 2 chỗ lấy server chuẩn:**

- **GitHub MCP Registry** ở docs.github.com (MCP Registry) — danh sách server do GitHub chuẩn hóa.
- **Cấu hình ngay trên github.com:** Settings → Copilot → MCP servers (JSON `mcpServers`, bắt buộc mảng `tools`, kiểu `local|stdio|http|sse`, secret prefix `COPILOT_MCP_`).
- GitHub MCP server có 2 dạng: remote hosted `https://api.githubcopilot.com/mcp/`, hoặc local qua docker `ghcr.io/github/github-mcp-server`. Chọn toolset bằng URL path `/x/{toolset}` hoặc header `X-MCP-Toolsets`; đọc-thuần qua `/readonly` hoặc `X-MCP-Readonly: true`.

---

## 9. Prune guide — giữ MCP khỏe

*Section này trả lời: giữ bao nhiêu server là vừa, và cắt cái nào sau mỗi 2 tuần.*

### 9.1. Day-one servers (sweet spot 3–6, đừng quá ~10 tools visible)

**Nôm na:** Chỉ giữ bếp nào tuần nào cũng gọi. Bếp 2 tuần không gọi → đóng (disable), không ai kêu → dẹp luôn.

| Server | Nôm na để làm gì | Khi thêm (ai dùng lúc nào) | Khi prune (bỏ khi nào) |
|---|---|---|---|
| GitHub | Đọc/tạo PRs, issues, search code | Gần như luôn — impact cao nhất | Không bao giờ (trừ repo không dùng GitHub) |
| Playwright | Copilot **nhìn** UI qua browser thật | Web app cần test UI | App không UI / đã có E2E khác |
| Postgres/MySQL | Đọc schema, chạy query dev | App có DB thật | Project docs-only, không DB |
| Fetch / Brave | Tra docs/web live | Hay tra docs ngoài | Ít tra web / đã có docs local |
| Linear / Notion / Jira / Slack | Đọc tickets, docs, messages | Team sống trong đó | Team không dùng / đã migrate tool |

> Quá ~10 MCP tools visible → Copilot chọn tool sai/bỏ sót (giống menu 100 món, bồi bàn loạn). Thêm cái dùng thật, prune cái không. Mỗi server sâu nên có 1 instructions file kèm (schema, format — bài 03).

### 9.2. Prune flow định kỳ (2 tuần/lần, 10 phút — copy-paste)

```text
Bước 1: mở "MCP: List Servers" → server nào disconnected lâu? Ghi lại.
Bước 2: tự hỏi: 2 tuần rồi có gọi server X không? Không → disable 1 tuần.
  VS Code: mcp.json → xóa/comment server → reload. Không ai kêu → xóa hẳn.
Bước 3: audit tools: "@workspace liệt kê MCP tools mày đang thấy" → server nào thừa?
Bước 4: audit secrets: grep secrets (mục 8.1) → phải trống (exit=1).
# Kỳ vọng: còn 3-6 servers connected, tools gọn, secrets sạch.
```

### 9.3. Checklist MCP khỏe

- [ ] `MCP: List Servers` all connected; OAuth/token xong.
- [ ] `.vscode/mcp.json` commit được, secrets chỉ qua env (grep trống).
- [ ] Mỗi server sâu có 1 instructions kèm (schema, conventions — bài 03).
- [ ] Tools visible gọn, servers 3–6.
- [ ] Tool approval đúng: read → allow, side-effect → ask, prod → deny.
- [ ] Coding agent cloud: cấu hình lại MCP remote (stdio local không theo lên cloud — bài 12).

### 9.4. Pitfalls + fix (giữ nguyên + thêm giải thích)

| Pitfall | Vì sao | Fix |
|---|---|---|
| Paste password vào `mcp.json` rồi commit | Tiện tay "tạm rồi xóa" | `${VAR}` + secrets ở env; đã lọt → `git rm` + rotate creds ngay (git history giữ mãi) |
| Cài 15 servers "cho chắc" | Sợ thiếu | 3–6, prune định kỳ (mục 9.2). Nhiều tools → Copilot chọn sai |
| Local stdio lên cloud mất | Cloud không có binary local | Cloud dùng http/sse remotes (bài 12) |
| Token hết hạn → disconnected | Token ngắn hạn / đổi pass | Re-export env + reload; cron nhắc re-auth |
| Không instructions kèm → Copilot query sai schema | MCP không biết conventions team | Viết `db.instructions.md` (mục 7.3) |
| Approval `allow` hết cho tiện | Lười bấm Allow | Side-effect giữ `ask`; chỉ read-only mới `allow` (mục 6) |

### 9.5. Bài tập thực hành (giữ nguyên)

**Bài 1 (15 phút):** Cài GitHub server (mục 7.1). Test 3 prompts: list PRs,
đọc issue, search code. Ghi tools Copilot đã gọi (list_prs? get_pr? search_code?).

**Bài 2 (15 phút):** Cài Postgres dev (mục 7.3, env placeholder). Viết
`db.instructions.md` kèm. Test SELECT + verify prod guard (hỏi prod → phải từ chối).

**Bài 3 (15 phút):** Cài Playwright (mục 7.2). Boot app local, nhờ Copilot mở +
screenshot + nhận xét UI.

**Bài 4 (10 phút):** Chạy prune flow (mục 9.2): tìm server 0 calls → disable.
Audit `mcp.json` secrets bằng grep (mục 8.1). Ghi exit code (phải =1).

### 9.6. Walkthrough: thêm server đầu tiên (10 phút — giữ nguyên)

```text
Bước 1: copy khung mcp.json (mục 4) vào .vscode/mcp.json, giữ lại github + fetch.
Bước 2: export GITHUB_TOKEN (mục 7.1). Reload VS Code.
Bước 3: Ctrl+Shift+P → "MCP: List Servers" → github phải Connected.
Bước 4: Chat test: "liệt kê 5 PRs mở gần nhất". Được → thêm servers tiếp theo.
Bước 5: Commit mcp.json (grep secrets trống, exit=1) + settings approval (mục 6).
# Kỳ vọng cuối: 2 servers connected, Chat liệt kê được PRs thật, grep sạch.
```

---

## 10. Hiểu nhầm thường gặp

*Section này trả lời: 7 hiểu nhầm về MCP hay gặp nhất, và sự thật tương ứng. Tra cứu nhanh, không cần đọc từ đầu.*

| Hiểu nhầm | Sự thật |
|---|---|
| "MCP server = 1 tool" | Sai. 1 server expose **nhiều tools + (tùy) resources + (tùy) prompts**. Vd server github expose list_prs, get_pr, create_pr... (xem tools/list mục 5.1) |
| "Tools / Resources / Prompts là 3 loại server khác nhau" | Sai. Là **3 thành phần trong cùng 1 server**. Tools = hàm làm, Resources = dữ liệu xem qua URI, Prompts = template mẫu (mục 5 + sơ đồ mermaid) |
| "Copilot cầm token GitHub của mình" | Sai. Token nằm ở **MCP Server process** (env). Model chỉ thấy params + JSON kết quả, không thấy token |
| "Cài càng nhiều servers càng mạnh" | Sai. Quá ~10 tools → Copilot chọn sai/bỏ sót. Giữ 3–6, prune định kỳ |
| "stdio local theo lên cloud" | Sai. Coding agent cloud không có máy bạn → chỉ dùng http/sse remote (bài 12) |
| "Paste secrets vào mcp.json rồi xóa sau là an toàn" | Sai. Git history giữ mãi. Luôn `${VAR}` + rotate nếu đã lọt |
| "MCP thay instructions/skills" | Sai. MCP = tay vươn ra ngoài, instructions/skills = cách dùng tay đó (schema, format). Cần cả 2 |

---

## 11. Link chéo

*Section này trả lời: bài nào trong series liên quan trực tiếp tới MCP, đọc tiếp theo hướng nào.*

- **Bài 03 — Instructions:** instructions kèm MCP (schema DB, format Slack).
- **Bài 05 — Prompt files:** prompt tái dùng gọi MCP (review-pr, triage-issue).
- **Bài 06 — Custom agents:** agents gọi MCP tools — lock `tools` trong frontmatter.
- **Bài 07 — Guardrails:** MCP allowlist + content exclusion (defense in depth).
- **Bài 09 — Extensions:** extension bundle MCP — cài 1 được 2, review URL/secrets.
- **Bài 10 — Permissions:** tool approval allow/ask/deny + plan differences.
- **Bài 12 — SDK & CI:** MCP trong Actions runners + coding agent cloud (remote only).

---
*(Hết bài 08 — bản mở rộng giải thích Tools/Resources/Prompts + sequence. Tiếp theo: Bài 09 — Extensions & marketplaces.)*
