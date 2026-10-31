# FAQ 04 — MCP FAQ

> **Vấn đề:** Copilot "mù" với PR, issue, database hay browser → gần như luôn là chuyện MCP: `mcp.json` viết sao, stdio/SSE chọn cái nào, auth thế nào, tools không hiện fix từ đâu. 10 câu dưới đây trả lời đủ.

## Bảng tổng hợp: chọn transport nhanh

| Transport | Khi nào dùng | Ví dụ |
|---|---|---|
| stdio (chạy lệnh local) | Server chạy trên máy bạn (npx, python, binary) | `npx -y @modelcontextprotocol/server-github` |
| SSE / HTTP (server xa) | Server chạy sẵn có URL (team/self-host) | `https://mcp.internal.company.com/sse` |
| Disabled / xóa entry | Tắt tạm server nguy hiểm | Postgres prod khi chưa cần |

Mỗi MCP server expose 3 loại thành phần (không phải 3 loại server): **Tools** = tay (hàm gọi được, VD `github.create_pr`), **Resources** = mắt (dữ liệu đọc qua URI), **Prompts** = công thức nấu ăn (template sẵn). Không phải server nào cũng có đủ 3 — Tools là bắt buộc, Resources/Prompts tùy server.

---

## 1. `mcp.json` nằm ở đâu, format chuẩn là gì?

**Trả lời 1 câu:** VS Code đọc ở repo-level `.vscode/mcp.json` (commit share cả team) và user-level User Settings (đè lên repo); key chuẩn là `servers` — nhầm `mcpServers` (của tool khác) thì im lặng không chạy.

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

> **Sai chỗ/sai key = lỗi âm thầm:** sửa đúng nội dung mà IDE đọc file khác hoặc bỏ qua key lạ — "chẳng có gì xảy ra" dù config trông đúng.

## 2. stdio vs SSE/HTTP khác nhau gì?

**Trả lời 1 câu:** stdio = IDE tự spawn process trên máy bạn (nhẹ, cần `npx`, tốn RAM, chết theo IDE); SSE/HTTP = nối tới URL server đang chạy (share team, cần mạng + auth).

```json
// stdio: chạy local
{ "command": "npx", "args": ["-y", "@modelcontextprotocol/server-playwright"] }

// SSE/HTTP: nối server xa
{ "type": "sse", "url": "https://mcp.internal.company.com/sse",
  "headers": { "Authorization": "Bearer ${input:mcp_token}" } }
```

```bash
# Test server xa còn sống trước khi đổ lỗi cho Copilot
curl -s -o /dev/null -w "%{http_code}\n" https://mcp.internal.company.com/health
# Verify: 200 = sống; 000/timeout = server chết hoặc URL sai
```

> **Chọn sai transport là lỗi âm thầm:** MCP panel báo `disconnected` mà chẳng rõ lý do. 1 mình vọc → stdio; team dùng chung / server nặng → SSE.

## 3. Auth cho MCP server thế nào?

**Trả lời 1 câu:** 3 cách: `${input:...}` (khuyên dùng, không lưu git), `${env:...}` (env var máy bạn), hardcode — **CẤM**: token vào git là lộ vĩnh viễn.

| Cách | An toàn | Khi nào dùng |
|---|---|---|
| `${input:...}` | Cao | Repo share cho team |
| `${env:...}` | Trung bình–cao | Token riêng mỗi dev |
| Hardcode trong `mcp.json` | CẤM | Không bao giờ |

```bash
# Cách đúng: token trong env, mcp.json chỉ tham chiếu
export GITHUB_MCP_TOKEN="ghp_xxxx"   # ~/.zshrc, mở IDE từ terminal để hứng env
# mcp.json: "env": { "GITHUB_PERSONAL_ACCESS_TOKEN": "${env:GITHUB_MCP_TOKEN}" }

# Quét repo xem có ai hardcode:
grep -rn "ghp_\|sk-\|xoxb-" .vscode/mcp.json .github/ 2>/dev/null
# Verify: rỗng = sạch; ra dòng thì sửa + rotate token
```

## 4. Tools không hiện trong Copilot — debug theo thứ tự nào?

**Trả lời 1 câu:** 5 bước đừng nhảy cóc: validate JSON → check key `servers` → test process → reload IDE → đọc log MCP panel.

```bash
# 1. Validate JSON (lỗi dấu phẩy = nguyên nhân #1)
python3 -c "import json; json.load(open('.vscode/mcp.json')); print('JSON OK')"

# 2. Test stdio server chạy tay được không
npx -y @modelcontextprotocol/server-github --help 2>&1 | head -5

# 3. Test SSE server
curl -s -m 10 -o /dev/null -w "%{http_code}\n" https://mcp.internal.company.com/health
```

Sau sửa `mcp.json` phải reload / restart MCP server trong MCP panel. Log: VS Code → View → Output → chọn MCP server đó.

## 5. Secrets trong MCP: placeholders viết sao?

**Trả lời 1 câu:** Quy tắc vàng: **`mcp.json` commit được = không chứa secret thật** — mọi secret đi qua `${input:...}` (IDE hỏi lúc start) hoặc `${env:...}` (shell profile).

```json
{ "env": { "POSTGRES_URL": "${env:PG_REPLICA_URL}" } }
```

```bash
# .envrc hoặc shell profile (KHÔNG commit):
export PG_REPLICA_URL="postgres://readonly:xxxx@replica.internal:5432/app"
code .   # mở IDE từ terminal để hứng env
```

> Không có ngoại lệ "tạm paste rồi xóa sau": git history giữ mãi, bot quét GitHub tìm thấy trong vài phút. Đã lỡ commit → `git rm` + **xoay token ngay**.

## 6. MCP postgres trỏ prod — làm sao không phá data?

**Trả lời 1 câu:** 3 lớp bảo vệ, bật cả 3: trỏ **read-replica** (hoặc user DB chỉ `GRANT SELECT`), server chỉ expose query tools (tắt `exec/migrate`), tool `exec` luôn Deny/allow-once.

```sql
-- Tạo user readonly cho MCP (chạy 1 lần trên DB)
CREATE USER mcp_reader WITH PASSWORD '${MCP_READER_PW}';
GRANT SELECT ON ALL TABLES IN SCHEMA public TO mcp_reader;
-- Verify: SELECT được, INSERT/DELETE bị từ chối
```

```bash
export PG_REPLICA_URL="postgres://mcp_reader:${MCP_READER_PW}@replica.internal:5432/app"
# Verify: echo $PG_REPLICA_URL ra host replica, không phải prod
```

> Cần migrate → làm tay bằng migration tool, không qua MCP.

## 7. MCP GitHub server cần scope token nào?

**Trả lời 1 câu:** Token tối thiểu làm được việc — fine-grained PAT chỉ repo cần (read-only nếu chỉ đọc), tạo PAT riêng cho MCP, đừng reuse PAT deploy.

```bash
# github.com/settings/tokens -> Fine-grained -> chọn repo ->
# Contents: Read, Issues: Read, PRs: Read/Write
export GITHUB_MCP_TOKEN="github_pat_xxxx"
gh api --header "Authorization: token $GITHUB_MCP_TOKEN" user
# Verify: ra đúng account
```

## 8. MCP Playwright (browser) dùng khi nào?

**Trả lời 1 câu:** Cho agent mở trang, click, chụp screenshot, đọc console errors — nặng (Chromium ~300-500MB RAM) nhưng cần khi verify UI/E2E thật; chỉ check API thì dùng `curl` nhanh hơn.

```json
{ "command": "npx", "args": ["-y", "@modelcontextprotocol/server-playwright"] }
```

```bash
# Prompt hiệu quả: "Mở http://localhost:3000/login, login test@example.com,
#  chụp màn hình + đọc console errors. Không click nút thanh toán."
```

> Thiếu browser → `npx playwright install chromium`; boot app local trước; làm backend thuần thì tắt server cho nhẹ máy.

## 9. Nhiều MCP servers cùng lúc — quản lý sao cho nhẹ?

**Trả lời 1 câu:** Mỗi server stdio = 1 process + RAM, và menu tools dài làm model chọn sai/bỏ sót — chỉ bật server task đang cần, server nặng để SSE chung team.

```bash
ps aux | grep -i "mcp\|modelcontextprotocol" | grep -v grep
# Verify: server nào >500MB thì cân nhắc chuyển SSE

# Tắt tạm: thêm "_" prefix vào key ("_playwright-disabled") -> bật lại thì xóa
```

> Ngày làm backend → `github + postgres`; ngày làm UI → thêm `playwright`. Không bật cả 3 trừ khi cần.

## 10. MCP log đọc ở đâu, lỗi nào hay gặp?

**Trả lời 1 câu:** Log ở `View → Output → [MCP server name]`; 4 lỗi top:

| Lỗi trong log | Nghĩa | Fix |
|---|---|---|
| `ENOENT npx` | Máy thiếu node/npx | Cài node LTS |
| `401/403` | Token sai/hết hạn | Tạo token mới, update env |
| `ECONNREFUSED` | SSE server chưa chạy | Start server / check URL |
| `JSON parse error` | `mcp.json` sai cú pháp | Validate JSON (câu 4) |

```bash
# Kiểm nhanh 3 thứ trước khi đọc log sâu
node --version; npx --version
echo ${GITHUB_MCP_TOKEN:+TOKEN_OK}
python3 -c "import json; json.load(open('.vscode/mcp.json')); print('JSON OK')"
```

---

## Vẫn lỗi thì sao? (thứ tự debug chuẩn)

1. `python3 -c "import json;..."` validate `mcp.json`.
2. Check key `servers` + entry server đúng format.
3. Test transport tay: `npx ... --help` (stdio) / `curl` health (SSE).
4. Check token: env có, chưa hết hạn, đủ scope.
5. Reload IDE → đọc Output panel log server đó.

Tham khảo chéo: [bài 03](03-modes-permissions.md) (tool approval) · [bài 08](08-loi-thuong-gap-troubleshooting.md) (lỗi tổng hợp) · [bài 09](09-bao-mat-quyen-rieng-tu.md) (secrets + audit) · [../templates/.vscode/mcp.json](../templates/.vscode/mcp.json) (mẫu copy ngay).
