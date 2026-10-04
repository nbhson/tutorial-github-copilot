# FAQ 04 — MCP FAQ

> Nhóm MCP (Model Context Protocol) · 10 câu hỏi deep-dive · Đọc xong tự khai báo server, fix tools không hiện, giữ secrets an toàn

File này trả lời mọi câu hỏi "mcp.json viết sao, stdio/sse khác gì, auth thế nào, tools không hiện thì fix sao". Mỗi câu có giải thích + lệnh copy-paste + ví dụ + khi nào áp dụng.

---

## Bảng tổng hợp: chọn transport nhanh

| Transport | Khi nào dùng | Ví dụ |
|---|---|---|
| stdio (chạy lệnh local) | Server chạy trên máy bạn (npx, python, binary) | `npx -y @modelcontextprotocol/server-github` |
| SSE / HTTP (server xa) | Server chạy sẵn có URL (team/self-host) | `https://mcp.internal.company.com/sse` |
| Disabled / xóa entry | Tắt tạm server nguy hiểm | Postgres prod khi chưa cần |

---

## 1. `mcp.json` nằm ở đâu, format chuẩn 2026 là gì?

**Giải thích.** VS Code đọc MCP config ở 2 chỗ (repo này dùng `.vscode/mcp.json` để share cả team):

- **Repo-level:** `.vscode/mcp.json` — commit vào git, cả team dùng chung (secrets qua `${input}` / env, KHÔNG hardcode).
- **User-level:** VS Code User Settings (`mcp.servers`) — cấu hình riêng máy bạn, đè lên repo.

Format chuẩn: key `servers` (VS Code) — một số tool cũ dùng `mcpServers`, nếu copy config mẫu mà không hiện thì đổi key cho khớp client.

**Lệnh copy-paste:**

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

**Ví dụ:** copy `templates/.vscode/mcp.json` → sửa 3 servers (github/playwright/postgres) → reload IDE → check MCP panel.

**Khi nào áp dụng:** setup repo mới, hoặc khi thêm server thứ 2, 3 vào repo đã có.

---

## 2. stdio vs SSE/HTTP khác nhau gì, chọn sao?

**Giải thích.**

- **stdio:** IDE tự spawn process (`command` + `args`) trên máy bạn, nói chuyện qua stdin/stdout. Hợp server nhẹ (npx package, script python). Không cần mạng, nhưng tốn RAM máy bạn và chết theo IDE.
- **SSE/HTTP:** IDE kết nối tới URL server đang chạy (team host hoặc cloud). Hợp DB/tool dùng chung, server nặng (browser automation pool). Cần mạng + auth, nhưng share được cả team.

**Lệnh copy-paste:**

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
```

**Ví dụ:** team 10 người cùng query docs nội bộ → host 1 SSE server chung thay vì mỗi máy spawn stdio riêng.

**Khi nào áp dụng:** 1 mình vọc → stdio; team dùng chung / server nặng → SSE.

---

## 3. Auth cho MCP server thế nào (token, headers, OAuth)?

**Giải thích.** 3 cách đưa credentials, xếp theo độ an toàn tăng dần:

1. **`${input:...}` prompt** (khuyên dùng cho repo share): IDE hỏi khi khởi động, không lưu vào git. Kèm `"password": true` để ẩn.
2. **Env var máy bạn:** `"env": { "TOKEN": "${env:MY_TOKEN}" }` — token nằm trong shell profile, không vào repo.
3. **Hardcode trong mcp.json — CẤM:** token vào git là lộ vĩnh viễn (kể cả xóa commit sau).

**Lệnh copy-paste:**

```bash
# Cách đúng: token trong env, mcp.json chỉ tham chiếu
export GITHUB_MCP_TOKEN="ghp_xxxx"   # cho vào ~/.zshrc hoặc 1password shell plugin
# mcp.json: "env": { "GITHUB_PERSONAL_ACCESS_TOKEN": "${env:GITHUB_MCP_TOKEN}" }

# Cách sai (đừng làm): "env": { "TOKEN": "ghp_xxxx_truc_tiep" }
# Quét repo xem có ai hardcode không:
grep -rn "ghp_\|sk-\|xoxb-" .vscode/mcp.json .github/ 2>/dev/null
```

**Ví dụ:** onboarding member mới → họ tự tạo PAT + `export` trong máy → `mcp.json` chung không đổi 1 dòng.

**Khi nào áp dụng:** mọi `mcp.json` commit vào git — grep check hardcode trước mỗi commit.

---

## 4. Tools không hiện trong Copilot — debug theo thứ tự nào?

**Giải thích.** Thứ tự 5 bước (đừng nhảy cóc):

1. **JSON parse được không:** `python3 -c "import json; json.load(open('.vscode/mcp.json'))"` — lỗi dấu phẩy là nguyên nhân #1.
2. **Key đúng không:** `servers` (VS Code) vs `mcpServers` (tool khác) — sai key = im lặng luôn.
3. **Server process sống không:** stdio → `npx` có chạy tay được không; SSE → `curl` health check.
4. **IDE đã reload chưa:** sau sửa `mcp.json` phải reload / restart MCP server trong MCP panel.
5. **Log MCP panel:** VS Code → View → Output → chọn MCP server đó → đọc lỗi thật.

**Lệnh copy-paste:**

```bash
# 1. Validate JSON
python3 -c "import json; json.load(open('.vscode/mcp.json')); print('JSON OK')"

# 2. Test stdio server chạy tay được không
npx -y @modelcontextprotocol/server-github --help 2>&1 | head -5

# 3. Test SSE server
curl -s -m 10 -o /dev/null -w "%{http_code}\n" https://mcp.internal.company.com/health
```

**Ví dụ:** tools GitHub không hiện → chạy bước 1 thấy `JSON OK` → bước 3 thấy `npx` treo (mạng chặn registry) → fix mạng, không phải lỗi Copilot.

**Khi nào áp dụng:** mọi ca "hôm qua còn thấy tools, hôm nay mất".

---

## 5. Secrets trong MCP: env placeholders viết sao cho đúng?

**Giải thích.** Quy tắc vàng: **`mcp.json` commit được = không chứa secret thật.** Mọi secret đi qua `${input:...}` hoặc `${env:...}`.

- `${input:ten}` → IDE popup hỏi lúc start (định nghĩa trong block `"inputs"`).
- `${env:TEN}` → đọc từ môi trường shell của IDE (phải export trước khi mở IDE, hoặc trong `~/.zshrc`).

**Lệnh copy-paste:**

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
```

**Ví dụ:** `templates/.vscode/mcp.json` dùng `${input}` cho cả 3 servers → clone về chạy được ngay, mỗi người nhập token của mình.

**Khi nào áp dụng:** review mọi PR đụng `mcp.json` — thấy string `ghp_/sk-/postgres://user:pass@` thật là block PR.

---

## 6. MCP postgres trỏ prod — làm sao để không phá data?

**Giải thích.** 3 lớp bảo vệ (bật cả 3):

1. **Connection read-only:** trỏ MCP tới **read-replica**, hoặc user DB chỉ có `GRANT SELECT`.
2. **Server chỉ expose query tools:** cấu hình server MCP chỉ cho `query`, tắt `exec/migrate`.
3. **Approval tay:** tool `exec` luôn Deny/allow-once, không bao giờ allow-always.

**Lệnh copy-paste:**

```sql
-- Tạo user readonly cho MCP (chạy 1 lần trên DB)
CREATE USER mcp_reader WITH PASSWORD '${MCP_READER_PW}';
GRANT CONNECT ON DATABASE app TO mcp_reader;
GRANT USAGE ON SCHEMA public TO mcp_reader;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO mcp_reader;
```

```bash
# mcp.json trỏ replica + user readonly
export PG_REPLICA_URL="postgres://mcp_reader:${MCP_READER_PW}@replica.internal:5432/app"
```

**Ví dụ:** agent cần "xem schema orders" → query replica thoải mái. Cần migrate → làm tay bằng migration tool, không qua MCP.

**Khi nào áp dụng:** trước khi khai báo bất kỳ MCP DB nào trỏ môi trường có data thật.

---

## 7. MCP GitHub server dùng để làm gì, cần scope token nào?

**Giải thích.** MCP GitHub cho agent: đọc issue/PR, xem diff, comment, tạo branch... (tùy cấu hình). Token tối thiểu: PAT classic `repo` scope, hoặc fine-grained PAT chỉ repo cần thiết.

Nguyên tắc: **token MCP GitHub = quyền yếu nhất làm được việc** (read-only nếu chỉ cần đọc).

**Lệnh copy-paste:**

```bash
# Tạo fine-grained PAT: github.com/settings/tokens -> Fine-grained ->
# Only select repositories -> chọn repo -> Contents: Read, Issues: Read, PRs: Read/Write
export GITHUB_MCP_TOKEN="github_pat_xxxx"
```

**Ví dụ:** agent chỉ cần đọc issue + diff → PAT read-only. Khi nào cần nó tạo PR mới nâng scope.

**Khi nào áp dụng:** khi thêm server `github` vào `mcp.json` — tạo PAT riêng cho MCP, đừng reuse PAT deploy.

---

## 8. MCP Playwright (browser) dùng khi nào, nặng không?

**Giải thích.** Playwright MCP cho agent: mở trang, click, chụp màn hình, đọc console errors — để verify UI/E2E thật. Nặng: spawn browser Chromium (~300-500MB RAM), chạy chậm hơn query DB nhiều.

Dùng khi: verify flow UI sau sửa, đọc lỗi console trang staging. Không dùng khi: chỉ cần check API (dùng `curl`/test nhanh hơn).

**Lệnh copy-paste:**

```json
// mcp.json: playwright stdio (không cần auth)
{ "command": "npx", "args": ["-y", "@modelcontextprotocol/server-playwright"] }
```

```bash
# Prompt mẫu cho agent dùng browser hiệu quả:
# "Mở http://localhost:3000/login, login user test@example.com,
#  chụp màn hình + đọc console errors. Không click nút thanh toán."
```

**Ví dụ:** sửa form login → agent mở browser → login thử → báo console có lỗi `401` → bạn fix tiếp. Đỡ phải tự mở browser F12.

**Khi nào áp dụng:** task UI cần verify thật; tắt server khi làm backend thuần để nhẹ máy.

---

## 9. Nhiều MCP servers cùng lúc — quản lý sao cho nhẹ?

**Giải thích.** Mỗi server stdio = 1 process + RAM. Bật 6-7 servers npx cùng lúc → máy yếu đi rõ. Cách gọn:

- Chỉ bật server task hiện tại cần (tắt rest bằng cách comment entry).
- Server nặng (playwright, DB) → để SSE chung team thay vì mỗi máy spawn.
- Đặt `timeout`/`cwd` hợp lý để server không treo IDE lúc start.

**Lệnh copy-paste:**

```bash
# Xem process MCP nào đang ngốn RAM
ps aux | grep -i "mcp\|modelcontextprotocol" | grep -v grep

# Tắt tạm server: thêm "_" prefix vào key (VS Code bỏ qua key lạ)
# "_playwright-disabled": { ... }  -> bật lại thì xóa prefix
```

**Ví dụ:** ngày làm backend → chỉ bật `github + postgres`. Ngày làm UI → bật `github + playwright`. Không bật cả 3 trừ khi cần.

**Khi nào áp dụng:** khi IDE khởi động chậm / quạt quay mạnh sau khi thêm MCP.

---

## 10. MCP log đọc ở đâu, lỗi nào hay gặp nhất?

**Giải thích.** Log ở: VS Code → View → Output → dropdown chọn tên MCP server. 4 lỗi top:

| Lỗi trong log | Nghĩa | Fix |
|---|---|---|
| `ENOENT npx` | Máy thiếu node/npx | Cài node LTS |
| `401/403` | Token sai/hết hạn | Tạo token mới, update env |
| `ECONNREFUSED` | SSE server chưa chạy | Start server / check URL |
| `JSON parse error` | `mcp.json` sai cú pháp | Validate JSON (câu 4) |

**Lệnh copy-paste:**

```bash
# Kiểm tra nhanh 3 thứ trước khi đọc log sâu
node --version; npx --version
echo ${GITHUB_MCP_TOKEN:+TOKEN_OK}  # ra TOKEN_OK là env có
python3 -c "import json; json.load(open('.vscode/mcp.json')); print('JSON OK')"
```

**Ví dụ:** log báo `401` server github → `echo ${GITHUB_MCP_TOKEN}` ra rỗng → quên export sau restart → export lại + reload IDE.

**Khi nào áp dụng:** mọi ca MCP đỏ — đọc log Output panel trước, đoán sau.

---

## Vẫn lỗi thì sao? (thứ tự debug chuẩn)

1. `python3 -c "import json;..."` validate `mcp.json`.
2. Check key `servers` + entry server đúng format.
3. Test transport tay: `npx ... --help` (stdio) / `curl` health (SSE).
4. Check token: env có, chưa hết hạn, đủ scope.
5. Reload IDE → đọc Output panel log server đó.

```bash
python3 -c "import json; json.load(open('.vscode/mcp.json')); print('JSON OK')" && node --version && curl -s -m 10 -o /dev/null -w "%{http_code}\n" https://mcp.internal.company.com/health
```

---

## Tham khảo chéo

- Tool approval cho MCP: [bài 03](03-modes-permissions.md). Secrets + audit: [bài 09](09-bao-mat-quyen-rieng-tu.md).
- Mẫu copy ngay: [../templates/.vscode/mcp.json](../templates/.vscode/mcp.json), [../templates/README.md](../templates/README.md).
- Lỗi tổng hợp: [bài 08](08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _validate JSON trước, test transport bằng tay, và secrets chỉ qua ${input}/${env} — không bao giờ hardcode._
