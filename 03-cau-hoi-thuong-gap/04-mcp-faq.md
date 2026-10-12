# FAQ 04 — MCP FAQ

> **Dành cho:** dev muốn nối GitHub/DB/browser vào Copilot, đọc được `mcp.json`, và giữ secrets không lộ.
> **Vấn đề:** "mcp.json viết sao, stdio/sse khác gì, auth thế nào, tools không hiện thì fix sao" — 10 câu hỏi, mỗi câu có giải thích + lệnh copy-paste + ví dụ + khi nào áp dụng.
> **Đọc xong:** tự khai báo server, fix tools không hiện, giữ secrets an toàn. **Thời gian:** ~14 phút đọc.

Khi Copilot có vẻ "mù" với PR, issue, database hay browser, gần như lúc nào cũng là chuyện MCP. File này gom những câu hỏi hay gặp nhất khi nối Copilot ra ngoài repo — từ viết `mcp.json`, chọn transport, xác thực, tới gỡ ca tools biến mất.

## Mục tiêu bài học

- Đọc và sửa được `.vscode/mcp.json`: khai server, chọn transport, đặt secrets đúng chỗ.
- Phân biệt **Tools / Resources / Prompts** trong cùng một server — không nhầm thành 3 loại server.
- Tự debug ca "tools không hiện" theo đúng thứ tự thay vì đoán mò.
- Biết cách khóa MCP khỏi phá dữ liệu: read-replica, server chỉ query, và approval tay.

## Sơ đồ tư duy nhanh (đọc 30 giây)

Mỗi MCP server phơi ra 3 loại thành phần (tools/resources/prompts), và Copilot gọi chúng như tool built-in.

```mermaid
flowchart TD
    A[MCP Server] --> T[Tools - ham goi duoc]
    A --> R[Resources - du lieu doc]
    A --> P[Prompts - template san]
    T --> T1[github.create_pr]
    T --> T2[postgres.query]
    R --> R1[github://repos/.../issues/123]
    P --> P1[Review PR / Triage issue]
    T1 --> C[Copilot Chat goi nhu tool built-in]
    R1 --> C
    P1 --> C
```

---

## Bảng tổng hợp: chọn transport nhanh

Server của bạn chạy local hay ở xa quyết định transport bạn chọn.

| Transport | Khi nào dùng | Ví dụ |
|---|---|---|
| stdio (chạy lệnh local) | Server chạy trên máy bạn (npx, python, binary) | `npx -y @modelcontextprotocol/server-github` |
| SSE / HTTP (server xa) | Server chạy sẵn có URL (team/self-host) | `https://mcp.internal.company.com/sse` |
| Disabled / xóa entry | Tắt tạm server nguy hiểm | Postgres prod khi chưa cần |

---

## 0. MCP server gồm 3 thành phần nào (Tools / Resources / Prompts)? (đồng bộ bài 08)

> **Hỏi ngắn gọn:** _MCP server gồm 3 thành phần nào?_

**Trả lời 1 câu:** Mỗi MCP server expose 3 thứ — **Tools** (hàm gọi được), **Resources** (dữ liệu đọc qua URI), **Prompts** (template có sẵn) — đúng như bảng ở [bài 08](../01-huong-dan-su-dung/08-mcp-ket-noi-cong-cu-ngoai.md).

**Giải thích chi tiết + ví dụ:**

| Thành phần | Là gì (nôm na) | Ví dụ cụ thể | Copilot dùng khi nào |
|---|---|---|---|
| **Tools** | Hàm có input/output schema, Copilot _gọi_ để tạo tác động | `github.create_pr`, `github.list_issues`, `postgres.query`, `playwright.navigate` | Bạn bảo "mở PR", "query DB", "mở browser test" |
| **Resources** | Dữ liệu chỉ-đọc, định danh bằng URI, Copilot _đọc_ | `github://repos/acme/api/issues/123`, `postgres://schema/tables/users` | Bạn bảo "đọc issue 123", "xem schema bảng users" |
| **Prompts** | Template/kịch bản server đóng gói sẵn (tùy server) | `review-pr` (correctness/security/tests), `triage-issue` (label + hỏi thêm info) | Bạn gọi template thay vì viết prompt dài |

Nôm na: **Tools = tay (làm), Resources = mắt (đọc), Prompts = công thức nấu ăn (làm theo bước có sẵn).** Không phải server nào cũng có đủ 3 — hầu hết có Tools, một số có thêm Resources/Prompts.

**Vì sao quan trọng?** Nhầm 3 thành phần này thành "3 loại server khác nhau" sẽ khiến bạn đi tìm 3 server riêng để cài, hoặc tưởng server thiếu Resources là lỗi. Hiểu đúng thì bạn biết Tools là phần bắt buộc, còn Resources/Prompts là tùy chọn của từng server.

**Nếu làm sai?** Bạn mở issue "server này lỗi, không có Resources" trong khi server chỉ cố tình không expose Resources — mất thời gian debug sai chỗ.

### Làm thế nào (steps copy-paste)

```bash
# 1. Hỏi Copilot đang thấy gì (phân biệt tools vs resources)
# Mở Chat mới, gõ:
# "@workspace liệt kê MCP tools mày đang thấy (tên + server), và resources đọc được (URI)"
# Verify: list ra đúng tên tool + URI resource, không có thì server chưa expose loại đó
# 2. Test từng loại:
# - Tools: "dùng github tool liệt kê 5 PRs mới nhất repo này"
# - Resources: "đọc github://repos/<org>/<repo>/issues/1 tóm tắt giúp tôi"
# - Prompts: "chạy template review-pr cho diff hiện tại"
# 3. Nếu thiếu 1 loại -> check server docs (không phải server nào cũng expose cả 3)
```

> **Nếu vẫn lỗi thì...** mở `View → Output → MCP` để đọc log (câu 10). Thiếu Resources/Prompts thường là "server không expose loại đó", không phải bug Copilot — đừng đi xin 3 server riêng.

---

## 1. `mcp.json` nằm ở đâu, format chuẩn 2026 là gì?

> **Hỏi ngắn gọn:** _`mcp.json` nằm ở đâu, format chuẩn 2026 là gì?_

**Trả lời 1 câu:** VS Code đọc MCP config ở repo-level (`.vscode/mcp.json`) và user-level (User Settings), key `servers` là chuẩn VS Code — nhầm key `mcpServers` thì im lặng không chạy.

**Giải thích chi tiết + ví dụ:** VS Code đọc MCP config ở 2 chỗ (repo này dùng `.vscode/mcp.json` để share cả team):

- **Repo-level:** `.vscode/mcp.json` — commit vào git, cả team dùng chung (secrets qua `${input}` / env, KHÔNG hardcode).
- **User-level:** VS Code User Settings (`mcp.servers`) — cấu hình riêng máy bạn, đè lên repo.

Format chuẩn: key `servers` (VS Code) — một số tool cũ dùng `mcpServers`, nếu copy config mẫu mà không hiện thì đổi key cho khớp client.

| Vị trí | File/key | Commit vào git? | Đè nhau? | Khi nào dùng |
|---|---|---|---|---|
| Repo-level | `.vscode/mcp.json` (key `servers`) | Có — share cả team | Bị user-level đè | Setup server chung cho team |
| User-level | VS Code User Settings (`mcp.servers`) | Không | Đè lên repo | Config riêng cho máy bạn |

**Vì sao quan trọng?** Sai chỗ đặt hoặc sai key là lỗi âm thầm: bạn sửa file đúng nội dung nhưng IDE đọc file khác, hoặc đọc đúng file nhưng bỏ qua key lạ — nên "chẳng có gì xảy ra" dù config trông đúng.

**Nếu làm sai?** Bạn copy một config mẫu dùng key `mcpServers` vào `.vscode/mcp.json`, server không bao giờ lên mà cũng không báo lỗi rõ ràng — bạn đi nghi ngờ token trong khi lỗi chỉ là tên key.

### Làm thế nào (steps copy-paste)

```json
// .vscode/mcp.json — khung chuẩn (copy từ templates/.vscode/mcp.json)
{
  "servers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": { "GITHUB_PERSONAL_ACCESS_TOKEN": "${input:github_token}" }
    }
  },
  "inputs": [
    { "type": "promptString", "id": "github_token", "description": "GitHub PAT (repo scope)", "password": true }
  ]
}
```

**Ví dụ cụ thể:** copy `templates/.vscode/mcp.json` → sửa 3 servers (github/playwright/postgres) → reload IDE → check MCP panel.

> **Khi nào áp dụng:** setup repo mới, hoặc khi thêm server thứ 2, 3 vào repo đã có.

> **Nếu vẫn lỗi thì...** kiểm tra bạn đang sửa đúng file (`.vscode/mcp.json` hay User Settings); đối chiếu key là `servers` chứ không phải `mcpServers`; rồi reload IDE và xem MCP panel trước khi kết luận.

---

## 2. stdio vs SSE/HTTP khác nhau gì, chọn sao?

> **Hỏi ngắn gọn:** _stdio vs SSE/HTTP khác nhau gì, chọn sao?_

**Trả lời 1 câu:** stdio = IDE tự spawn process trên máy bạn, SSE/HTTP = IDE nối tới URL server đang chạy — chọn theo server nhẹ (stdio) hay dùng chung team (SSE).

**Giải thích chi tiết + ví dụ:**

- **stdio:** IDE tự spawn process (`command` + `args`) trên máy bạn, nói chuyện qua stdin/stdout. Hợp server nhẹ (npx package, script python). Không cần mạng, nhưng tốn RAM máy bạn và chết theo IDE.
- **SSE/HTTP:** IDE kết nối tới URL server đang chạy (team host hoặc cloud). Hợp DB/tool dùng chung, server nặng (browser automation pool). Cần mạng + auth, nhưng share được cả team.

| Tiêu chí | stdio | SSE/HTTP |
|---|---|---|
| Chạy ở đâu | IDE tự spawn process trên máy bạn | Server chạy sẵn ở xa (team/cloud) |
| Cần mạng? | Không | Có |
| Tốn RAM máy bạn? | Có (chết theo IDE) | Không (server riêng) |
| Share team? | Không | Có |
| Hợp với | Server nhẹ (npx, script python) | DB/tool dùng chung, server nặng |
| Khi nào dùng | 1 mình vọc | Team dùng chung / server nặng |

**Vì sao quan trọng?** Chọn sai transport là lỗi âm thầm: `stdio` cần máy bạn có `npx`, còn `http`/`sse` cần server đang chạy ở xa. Chọn nhầm thì MCP panel báo `disconnected` mà chẳng rõ lý do.

### Làm thế nào (steps copy-paste)

```json
// stdio: chạy local
{ "command": "npx", "args": ["-y", "@modelcontextprotocol/server-playwright"] }

// SSE/HTTP: nối server xa
{ "type": "sse", "url": "https://mcp.internal.company.com/sse",
  "headers": { "Authorization": "Bearer ${input:mcp_token}" } }
```

```bash
# Test server xa còn sống không trước khi đổ lỗi cho Copilot
curl -s -o /dev/null -w "%{http_code}\n" https://mcp.internal.company.com/health
# Verify: ra 200 = server sống; 000/timeout = server chết hoặc URL sai
```

**Ví dụ cụ thể:** team 10 người cùng query docs nội bộ → host 1 SSE server chung thay vì mỗi máy spawn stdio riêng.

> **Khi nào áp dụng:** 1 mình vọc → stdio; team dùng chung / server nặng → SSE.

> **Nếu vẫn lỗi thì...** nhờ `curl` health check xác nhận server xa còn sống (mong đợi 200), hoặc chạy `npx ... --help` để biết thành phần stdio có hoạt động; cuối cùng tra mục "Vẫn lỗi thì sao?" cuối file.

---

## 3. Auth cho MCP server thế nào (token, headers, OAuth)?

> **Hỏi ngắn gọn:** _Auth cho MCP server thế nào (token, headers, OAuth)?_

**Trả lời 1 câu:** 3 cách: `${input:...}` (khuyên dùng, không lưu git), env var máy bạn, và hardcode (CẤM) — token vào git là lộ vĩnh viễn.

**Giải thích chi tiết + ví dụ:** 3 cách đưa credentials, xếp theo độ an toàn tăng dần:

1. **`${input:...}` prompt** (khuyên dùng cho repo share): IDE hỏi khi khởi động, không lưu vào git. Kèm `"password": true` để ẩn.
2. **Env var máy bạn:** `"env": { "TOKEN": "${env:MY_TOKEN}" }` — token nằm trong shell profile, không vào repo.
3. **Hardcode trong mcp.json — CẤM:** token vào git là lộ vĩnh viễn (kể cả xóa commit sau).

| Cách | An toàn | Lưu ở đâu | Khi nào dùng |
|---|---|---|---|
| `${input:...}` | Cao (khuyên dùng) | IDE hỏi lúc start, không vào git | Repo share cho team |
| `${env:...}` | Trung bình–cao | Shell profile máy bạn | Token riêng mỗi dev |
| Hardcode trong `mcp.json` | CẤM | Trong git → lộ vĩnh viễn | Không bao giờ |

**Vì sao quan trọng?** `mcp.json` thường được commit để chia sẻ cho team. Nếu token nằm thẳng trong đó, mọi người clone về là có token của bạn, và bot quét GitHub có thể tìm thấy trong vài phút.

### Làm thế nào (steps copy-paste)

```bash
# Cách đúng: token trong env, mcp.json chỉ tham chiếu
export GITHUB_MCP_TOKEN="ghp_xxxx"   # cho vào ~/.zshrc hoặc 1password shell plugin
# mcp.json: "env": { "GITHUB_PERSONAL_ACCESS_TOKEN": "${env:GITHUB_MCP_TOKEN}" }
# Verify: echo $GITHUB_MCP_TOKEN ra token thật, chưa commit mcp.json ra git

# Cách sai (đừng làm): "env": { "TOKEN": "ghp_xxxx_truc_tiep" }
# Quét repo xem có ai hardcode không:
grep -rn "ghp_\|sk-\|xoxb-" .vscode/mcp.json .github/ 2>/dev/null
# Verify: grep ra rỗng = sạch; ra dòng thì phải sửa + rotate token
```

**Ví dụ cụ thể:** onboarding member mới → họ tự tạo PAT + `export` trong máy → `mcp.json` chung không đổi 1 dòng.

> **Khi nào áp dụng:** mọi `mcp.json` commit vào git — grep check hardcode trước mỗi commit.

> **Nếu vẫn lỗi thì...** `echo $TOKEN` xem biến có thật trong môi trường của IDE không (mở IDE từ terminal để nó hứng env); nếu token sai scope thì xoay token mới; còn lại hỏi admin xem policy org có chặn MCP không.

---

## 4. Tools không hiện trong Copilot — debug theo thứ tự nào?

> **Hỏi ngắn gọn:** _Tools không hiện trong Copilot — debug theo thứ tự nào?_

**Trả lời 1 câu:** 5 bước: validate JSON → check key `servers` → test process → reload IDE → đọc log MCP panel.

**Giải thích chi tiết + ví dụ:** Thứ tự 5 bước (đừng nhảy cóc):

1. **JSON parse được không:** `python3 -c "import json; json.load(open('.vscode/mcp.json'))"` — lỗi dấu phẩy là nguyên nhân #1.
2. **Key đúng không:** `servers` (VS Code) vs `mcpServers` (tool khác) — sai key = im lặng luôn.
3. **Server process sống không:** stdio → `npx` có chạy tay được không; SSE → `curl` health check.
4. **IDE đã reload chưa:** sau sửa `mcp.json` phải reload / restart MCP server trong MCP panel.
5. **Log MCP panel:** VS Code → View → Output → chọn MCP server đó → đọc lỗi thật.

**Vì sao quan trọng?** Debug nhảy cóc (đọc log trước khi validate JSON) khiến bạn đi sửa những thứ không phải nguyên nhân, trong khi lỗi thường chỉ là một dấu phẩy thừa.

### Làm thế nào (steps copy-paste)

```bash
# 1. Validate JSON
python3 -c "import json; json.load(open('.vscode/mcp.json')); print('JSON OK')"
# Verify: ra "JSON OK", không ra exception

# 2. Test stdio server chạy tay được không
npx -y @modelcontextprotocol/server-github --help 2>&1 | head -5
# Verify: ra help, không treo

# 3. Test SSE server
curl -s -m 10 -o /dev/null -w "%{http_code}\n" https://mcp.internal.company.com/health
# Verify: ra 200
```

**Ví dụ cụ thể:** tools GitHub không hiện → chạy bước 1 thấy `JSON OK` → bước 3 thấy `npx` treo (mạng chặn registry) → fix mạng, không phải lỗi Copilot.

> **Khi nào áp dụng:** mọi ca "hôm qua còn thấy tools, hôm nay mất".

> **Nếu vẫn lỗi thì...** sau 5 bước vẫn đỏ, đừng đoán tiếp: dán log MCP panel + output 3 lệnh trên vào issue gửi admin; nếu nghi model chọn sai tool thì đổi model (`/model`) rồi thử lại.

---

## 5. Secrets trong MCP: env placeholders viết sao cho đúng?

> **Hỏi ngắn gọn:** _Secrets trong MCP: env placeholders viết sao cho đúng?_

**Trả lời 1 câu:** `mcp.json` commit được = không chứa secret thật — mọi secret đi qua `${input:...}` hoặc `${env:...}`.

**Giải thích chi tiết + ví dụ:** Quy tắc vàng: **`mcp.json` commit được = không chứa secret thật.** Mọi secret đi qua `${input:...}` hoặc `${env:...}`.

- `${input:ten}` → IDE popup hỏi lúc start (định nghĩa trong block `"inputs"`).
- `${env:TEN}` → đọc từ môi trường shell của IDE (phải export trước khi mở IDE, hoặc trong `~/.zshrc`).

**Vì sao quan trọng?** Không có ngoại lệ "tạm paste rồi xóa sau": git history giữ mãi, và một khi đã push thì token nằm trong fork + clone của đồng nghiệp. Cách duy nhất an toàn là không để nó lọt vào file.

### Làm thế nào (steps copy-paste)

```json
// Mẫu đúng: 2 cách, chọn 1
{ "env": { "POSTGRES_URL": "${env:PG_REPLICA_URL}" } }
{ "env": { "POSTGRES_URL": "${input:pg_url}" } }
```

```bash
# .envrc hoặc shell profile (KHÔNG commit):
export PG_REPLICA_URL="postgres://readonly:xxxx@replica.internal:5432/app"
# Mở IDE từ terminal để nó hứng env:
code .
# Verify: echo $PG_REPLICA_URL ra đúng URL, không có "xxxx" là thật
```

**Ví dụ cụ thể:** `templates/.vscode/mcp.json` dùng `${input}` cho cả 3 servers → clone về chạy được ngay, mỗi người nhập token của mình.

> **Khi nào áp dụng:** review mọi PR đụng `mcp.json` — thấy string `ghp_/sk-/postgres://user:pass@` thật là block PR.

> **Nếu vẫn lỗi thì...** grep lại `.vscode/mcp.json` xem còn string thật không; nếu đã lỡ commit thì `git rm` + xoay (rotate) token ngay — xóa commit là chưa đủ.

---

## 6. MCP postgres trỏ prod — làm sao để không phá data?

> **Hỏi ngắn gọn:** _MCP postgres trỏ prod — làm sao để không phá data?_

**Trả lời 1 câu:** 3 lớp: trỏ read-replica, server chỉ expose query, và tool `exec` luôn approval tay — bật cả 3 thì không phá được data.

**Giải thích chi tiết + ví dụ:** 3 lớp bảo vệ (bật cả 3):

1. **Connection read-only:** trỏ MCP tới **read-replica**, hoặc user DB chỉ có `GRANT SELECT`.
2. **Server chỉ expose query tools:** cấu hình server MCP chỉ cho `query`, tắt `exec/migrate`.
3. **Approval tay:** tool `exec` luôn Deny/allow-once, không bao giờ allow-always.

**Vì sao quan trọng?** Đây là tấm chắn giữa "agent xem schema cho vui" và "agent vô tình UPDATE nhầm bảng thật". Một câu hỏi mơ hồ cộng với quyền write là hậu quả thật, không phải demo.

### Làm thế nào (steps copy-paste)

```sql
-- Tạo user readonly cho MCP (chạy 1 lần trên DB)
CREATE USER mcp_reader WITH PASSWORD '${MCP_READER_PW}';
GRANT CONNECT ON DATABASE app TO mcp_reader;
GRANT USAGE ON SCHEMA public TO mcp_reader;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO mcp_reader;
-- Verify: user này query được SELECT, INSERT/DELETE bị từ chối
```

```bash
# mcp.json trỏ replica + user readonly
export PG_REPLICA_URL="postgres://mcp_reader:${MCP_READER_PW}@replica.internal:5432/app"
# Verify: echo $PG_REPLICA_URL ra user readonly + host replica, không phải prod
```

**Ví dụ cụ thể:** agent cần "xem schema orders" → query replica thoải mái. Cần migrate → làm tay bằng migration tool, không qua MCP.

> **Khi nào áp dụng:** trước khi khai báo bất kỳ MCP DB nào trỏ môi trường có data thật.

> **Nếu vẫn lỗi thì...** thử INSERT một lần xem user MCP có thật sự bị từ chối không, và in `$PG_REPLICA_URL` để chắc host đang là replica chứ không phải prod.

---

## 7. MCP GitHub server dùng để làm gì, cần scope token nào?

> **Hỏi ngắn gọn:** _MCP GitHub server dùng để làm gì, cần scope token nào?_

**Trả lời 1 câu:** MCP GitHub cho agent đọc issue/PR/diff, comment, tạo branch — token tối thiểu là fine-grained PAT scope `repo` (read-only nếu chỉ đọc).

**Giải thích chi tiết + ví dụ:** MCP GitHub cho agent: đọc issue/PR, xem diff, comment, tạo branch... (tùy cấu hình). Token tối thiểu: PAT classic `repo` scope, hoặc fine-grained PAT chỉ repo cần thiết.

Nguyên tắc: **token MCP GitHub = quyền yếu nhất làm được việc** (read-only nếu chỉ cần đọc).

**Vì sao quan trọng?** Reuse PAT deploy cho MCP là mở một đường quyền rộng không cần thiết — agent chỉ cần đọc PR mà cầm token có quyền push/release là thừa nguy hiểm.

### Làm thế nào (steps copy-paste)

```bash
# Tạo fine-grained PAT: github.com/settings/tokens -> Fine-grained ->
# Only select repositories -> chọn repo -> Contents: Read, Issues: Read, PRs: Read/Write
export GITHUB_MCP_TOKEN="github_pat_xxxx"
# Verify: gh api --header "Authorization: token $GITHUB_MCP_TOKEN" user ra đúng account
```

**Ví dụ cụ thể:** agent chỉ cần đọc issue + diff → PAT read-only. Khi nào cần nó tạo PR mới nâng scope.

> **Khi nào áp dụng:** khi thêm server `github` vào `mcp.json` — tạo PAT riêng cho MCP, đừng reuse PAT deploy.

> **Nếu vẫn lỗi thì...** chạy `gh api .../user` để chắc token đúng account, kiểm lại scope fine-grained (Contents/Issues/PRs), và dùng PAT riêng cho MCP thay vì PAT deploy.

---

## 8. MCP Playwright (browser) dùng khi nào, nặng không?

> **Hỏi ngắn gọn:** _MCP Playwright (browser) dùng khi nào, nặng không?_

**Trả lời 1 câu:** Playwright MCP cho agent mở trang, click, chụp screenshot — nặng (RAM ~300–500MB) nhưng cần khi verify UI/E2E thật.

**Giải thích chi tiết + ví dụ:** Playwright MCP cho agent: mở trang, click, chụp màn hình, đọc console errors — để verify UI/E2E thật. Nặng: spawn browser Chromium (~300-500MB RAM), chạy chậm hơn query DB nhiều.

Dùng khi: verify flow UI sau sửa, đọc lỗi console trang staging. Không dùng khi: chỉ cần check API (dùng `curl`/test nhanh hơn).

**Vì sao quan trọng?** Đây là server "nhìn thấy" UI — thứ mà đọc code không thay được. Nhưng vì nặng, bật nó cả ngày cho task backend thuần chỉ làm máy ì và lãng phí.

### Làm thế nào (steps copy-paste)

```json
// mcp.json: playwright stdio (không cần auth)
{ "command": "npx", "args": ["-y", "@modelcontextprotocol/server-playwright"] }
```

```bash
# Prompt cho agent dùng browser hiệu quả:
# "Mở http://localhost:3000/login, login user test@example.com,
#  chụp màn hình + đọc console errors. Không click nút thanh toán."
# Verify: agent trả screenshot + list console errors, không tự click nút prod
```

**Ví dụ cụ thể:** sửa form login → agent mở browser → login thử → báo console có lỗi `401` → bạn fix tiếp. Đỡ phải tự mở browser F12.

> **Khi nào áp dụng:** task UI cần verify thật; tắt server khi làm backend thuần để nhẹ máy.

> **Nếu vẫn lỗi thì...** chạy `npx playwright install chromium` nếu thiếu browser, và boot app local trước khi nhờ agent mở trang; nếu máy hết RAM thì tắt server khi không cần.

---

## 9. Nhiều MCP servers cùng lúc — quản lý sao cho nhẹ?

> **Hỏi ngắn gọn:** _Nhiều MCP servers cùng lúc — quản lý sao cho nhẹ?_

**Trả lời 1 câu:** Mỗi server stdio = 1 process + RAM — bật đúng server task đang làm, server nặng để SSE chung team.

**Giải thích chi tiết + ví dụ:** Mỗi server stdio = 1 process + RAM. Bật 6-7 servers npx cùng lúc → máy yếu đi rõ. Cách gọn:

- Chỉ bật server task hiện tại cần (tắt rest bằng cách comment entry).
- Server nặng (playwright, DB) → để SSE chung team thay vì mỗi máy spawn.
- Đặt `timeout`/`cwd` hợp lý để server không treo IDE lúc start.

**Vì sao quan trọng?** Nhiều server không đồng nghĩa mạnh hơn: mỗi process ăn RAM, và một menu tool dài làm model chọn sai/bỏ sót — đúng kiểu bồi bàn nhìn menu 100 món rồi gọi nhầm.

### Làm thế nào (steps copy-paste)

```bash
# Xem process MCP nào đang ngốn RAM
ps aux | grep -i "mcp\|modelcontextprotocol" | grep -v grep
# Verify: list process + RAM, server nào >500MB thì cân nhắc chuyển SSE

# Tắt tạm server: thêm "_" prefix vào key (VS Code bỏ qua key lạ)
# "_playwright-disabled": { ... }  -> bật lại thì xóa prefix
```

**Ví dụ cụ thể:** ngày làm backend → chỉ bật `github + postgres`. Ngày làm UI → bật `github + playwright`. Không bật cả 3 trừ khi cần.

> **Khi nào áp dụng:** khi IDE khởi động chậm / quạt quay mạnh sau khi thêm MCP.

> **Nếu vẫn lỗi thì...** `ps aux | grep mcp` xem server nào ngốn RAM rồi tắt bớt, và chuyển server nặng (playwright/DB) sang SSE dùng chung team.

---

## 10. MCP log đọc ở đâu, lỗi nào hay gặp nhất?

> **Hỏi ngắn gọn:** _MCP log đọc ở đâu, lỗi nào hay gặp nhất?_

**Trả lời 1 câu:** Log ở `View → Output → [MCP server name]`; 4 lỗi top: `ENOENT npx`, `401/403`, `ECONNREFUSED`, `JSON parse error`.

**Giải thích chi tiết + ví dụ:** Log ở: VS Code → View → Output → dropdown chọn tên MCP server. 4 lỗi top:

| Lỗi trong log | Nghĩa | Fix |
|---|---|---|
| `ENOENT npx` | Máy thiếu node/npx | Cài node LTS |
| `401/403` | Token sai/hết hạn | Tạo token mới, update env |
| `ECONNREFUSED` | SSE server chưa chạy | Start server / check URL |
| `JSON parse error` | `mcp.json` sai cú pháp | Validate JSON (câu 4) |

**Vì sao quan trọng?** Log là nơi nói thật. Đọc log trước khi đoán giúp bạn phân biệt "server chết" với "config sai" — hai hướng fix hoàn toàn khác nhau.

### Làm thế nào (steps copy-paste)

```bash
# Kiểm tra nhanh 3 thứ trước khi đọc log sâu
node --version; npx --version
echo ${GITHUB_MCP_TOKEN:+TOKEN_OK}  # ra TOKEN_OK là env có
python3 -c "import json; json.load(open('.vscode/mcp.json')); print('JSON OK')"
# Verify: node version + TOKEN_OK + JSON OK đủ 3 mới đọc log tiếp
```

**Ví dụ cụ thể:** log báo `401` server github → `echo ${GITHUB_MCP_TOKEN}` ra rỗng → quên export sau restart → export lại + reload IDE.

> **Khi nào áp dụng:** mọi ca MCP đỏ — đọc log Output panel trước, đoán sau.

> **Nếu vẫn lỗi thì...** chạy 3 lệnh kiểm nhanh (node/npx, token, JSON) trước khi đọc log sâu, rồi dán log + các lệnh bạn đã chạy khi mở issue.

---

## Vẫn lỗi thì sao? (thứ tự debug chuẩn)

5 bước check khi mọi cách trên không ăn:

1. `python3 -c "import json;..."` validate `mcp.json`.
2. Check key `servers` + entry server đúng format.
3. Test transport tay: `npx ... --help` (stdio) / `curl` health (SSE).
4. Check token: env có, chưa hết hạn, đủ scope.
5. Reload IDE → đọc Output panel log server đó.

```bash
python3 -c "import json; json.load(open('.vscode/mcp.json')); print('JSON OK')" && node --version && curl -s -m 10 -o /dev/null -w "%{http_code}\n" https://mcp.internal.company.com/health
# Verify: JSON OK + node version + HTTP code (200 = server sống)
```

---

## So sánh với Claude Code

MCP là **chuẩn chung** (cùng spec Model Context Protocol), nên hai bên dùng chung khái niệm Tools/Resources/Prompts và cùng các kiểu transport. Khác nhau chủ yếu ở *file cấu hình* và *nơi chạy*.

| Việc | Copilot | Claude Code | Ghi chú |
|---|---|---|---|
| File khai server | `.vscode/mcp.json` (key `servers`) | `.mcp.json` ở gốc project (key `mcpServers`) hoặc `claude mcp add` | Cùng tư tưởng "1 file trong repo"; khác tên file + key |
| Phạm vi cấu hình | `.vscode/mcp.json` (repo) + user profile | `.mcp.json` (project) + scope user/local | Cả hai đều tách scope chia sẻ và scope cá nhân |
| Transport | `stdio`, `http`, `sse` | `stdio`, `sse`, `http` | Cùng chuẩn |
| 3 thành phần | Tools / Resources / Prompts | Tools / Resources / Prompts | Cùng spec |
| Approval tool | `toolAutoRun` + allow/ask/deny theo server + org policy | Prompt permission theo tool + settings | Cùng gate side-effect tools; khác cú pháp |
| Secrets | `${input:...}` / `${env:...}` | `${VAR}` trong `.mcp.json` (env) | Cùng nguyên tắc "không hardcode" |
| Đọc PR/issue | Có (server github) | Có (server github) | Cùng MCP server chạy được ở cả hai |
| Cloud/remote | Coding agent cloud chỉ dùng **remote** MCP | Phụ thuộc môi trường chạy | stdio local không đi lên cloud ở cả hai |

> **Đọc bảng này thế nào:** nếu bạn đã cài MCP cho Claude Code, chuyển sang Copilot gần như chỉ là đổi tên file (`.mcp.json` → `.vscode/mcp.json`) và đổi key (`mcpServers` → `servers`). Phần khó — chọn transport, khóa secrets, đặt approval — giống hệt nhau.

---

## Best practices (kèm "Vì sao?")

- **Validate JSON trước khi nghi ngờ Copilot.** *Vì sao?* Lỗi dấu phẩy là nguyên nhân #1 khiến tools không hiện — sửa vài ký tự nhanh hơn ngồi đọc log 10 phút.
- **Secrets chỉ qua `${input}` / `${env}`, grep trước mỗi commit.** *Vì sao?* Token lọt vào git history là lộ vĩnh viễn; rotate là cách duy nhất để xử lý, nên đừng để nó lọt.
- **Read → `allow`, side-effect → `ask`, prod → `deny`.** *Vì sao?* Giữ được tốc độ cho việc đọc mà vẫn chặn mọi tác động thật lên dữ liệu.
- **Giữ 3–6 server, tắt server task chưa cần.** *Vì sao?* Mỗi stdio là 1 process + RAM, và menu tools dài làm model chọn sai/bỏ sót.
- **Mỗi server sâu kèm 1 instructions file.** *Vì sao?* MCP biết gọi tool nhưng không biết convention của team (schema, format) — instructions dạy nó dùng reach cho đúng.
- **Test transport bằng tay (`--help`, `curl`) trước khi đổ lỗi cho Copilot.** *Vì sao?* Cách này tách bạch "server hỏng" khỏi "config Copilot sai" — hai hướng fix khác nhau.

---

## Tham khảo chéo

- Tool approval cho MCP: [bài 03](03-modes-permissions.md). Secrets + audit: [bài 09](09-bao-mat-quyen-rieng-tu.md).
- Mẫu copy ngay: [../templates/.vscode/mcp.json](../templates/.vscode/mcp.json), [../templates/README.md](../templates/README.md).
- Lỗi tổng hợp: [bài 08](08-loi-thuong-gap-troubleshooting.md).

> MCP chỉ đáng thêm khi dữ liệu nằm *ngoài* repo — và khi đã thêm thì giữ kỷ luật: JSON đúng, transport khớp, secrets qua env, và chỉ mở đúng server mà task đang cần.
