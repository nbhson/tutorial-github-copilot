# FAQ 04 — MCP FAQ

> **Vấn đề:** Copilot "mù" với PR, issue, database hay browser → gần như luôn là chuyện MCP: `mcp.json` viết sao, stdio/SSE chọn cái nào, auth thế nào, tools không hiện fix từ đâu. 10 câu dưới đây trả lời đủ.

## Bảng tổng hợp: chọn transport nhanh

| Transport | Khi nào dùng | Ví dụ |
|---|---|---|
| stdio (chạy lệnh local) | Server chạy trên máy bạn (npx, python, binary) | `npx -y @modelcontextprotocol/server-github` |
| SSE / HTTP (server xa) | Server chạy sẵn có URL (team/self-host) | `https://mcp.internal.company.com/sse` |
| Disabled / xóa entry | Tắt tạm server nguy hiểm | Postgres prod khi chưa cần |

> **Cách đọc bảng này:** chọn transport giống chọn phương thức giao hàng — hàng nhẹ ở ngay máy mình thì stdio, hàng ở kho xa thì SSE/HTTP, hàng nguy hiểm thì chưa đặt mà tạm khóa (Disabled); cột Ví dụ là mẫu thật để so config.

Mỗi MCP server expose 3 loại thành phần (không phải 3 loại server): **Tools** = tay (hàm gọi được, VD `github.create_pr`), **Resources** = mắt (dữ liệu đọc qua URI), **Prompts** = công thức nấu ăn (template sẵn). Không phải server nào cũng có đủ 3 — Tools là bắt buộc, Resources/Prompts tùy server.

---

## 1. `mcp.json` nằm ở đâu, format chuẩn là gì?

**Trả lời 1 câu:** Hai format cho hai harness: Local harness (VS Code) đọc `.vscode/mcp.json` trong repo (commit share cả team) + User Settings (đè lên repo), key chuẩn là `servers`; Copilot harness (Copilot CLI, Copilot in the cloud) đọc `.mcp.json` ở **root repo** + `~/.copilot/mcp-config.json`, key là `mcpServers`.

Ví von: sai tên file hoặc sai key giống gửi thư ghi sai địa chỉ — bưu tá không trả lại thư, không báo lỗi, chỉ lặng lẽ không giao hàng.

> 📄 **Code ví dụ:** [`examples/01-1-mcp-json-nam-o-au-format-chuan.json`](examples/01-1-mcp-json-nam-o-au-format-chuan.json)

> **Sai chỗ/sai key = lỗi âm thầm:** sửa đúng nội dung mà IDE đọc file khác hoặc bỏ qua key lạ — "chẳng có gì xảy ra" dù config trông đúng.

## 2. stdio vs SSE/HTTP khác nhau gì?

**Trả lời 1 câu:** stdio = IDE tự spawn process trên máy bạn (nhẹ, cần `npx`, tốn RAM, chết theo IDE); SSE/HTTP = nối tới URL server đang chạy (share team, cần mạng + auth).

> 📄 **Code ví dụ:** [`examples/02-2-stdio-vs-sse-http-khac-nhau-gi.json`](examples/02-2-stdio-vs-sse-http-khac-nhau-gi.json)

> 📄 **Code ví dụ:** [`examples/03-2-stdio-vs-sse-http-khac-nhau-gi.sh`](examples/03-2-stdio-vs-sse-http-khac-nhau-gi.sh)

> **Chọn sai transport là lỗi âm thầm:** MCP panel báo `disconnected` mà chẳng rõ lý do. 1 mình vọc → stdio; team dùng chung / server nặng → SSE.

## 3. Auth cho MCP server thế nào?

**Trả lời 1 câu:** 2 cách theo harness: `${env:...}` (Copilot harness khuyên dùng — export trong shell profile), `${input:...}` (chỉ Local harness/VS Code, IDE hỏi lúc start, không lưu git); hardcode — **CẤM**: token vào git là lộ vĩnh viễn.

| Cách | An toàn | Khi nào dùng |
|---|---|---|
| `${env:...}` | Cao | `.mcp.json` (Copilot harness), mọi môi trường |
| `${input:...}` | Cao | `.vscode/mcp.json` (Local harness), repo share cho team |
| Hardcode trong file MCP | CẤM | Không bao giờ |

> **Cách đọc bảng này:** cột **An toàn** xếp từ chỗ được phép (cao) tới chỗ tuyệt đối không được (CẤM) — nguyên tắc chung: token không bao giờ nằm trong file được commit lên git.

> 📄 **Code ví dụ:** [`examples/04-3-auth-cho-mcp-server-the-nao.sh`](examples/04-3-auth-cho-mcp-server-the-nao.sh)

## 4. Tools không hiện trong Copilot — debug theo thứ tự nào?

**Trả lời 1 câu:** 5 bước đừng nhảy cóc: validate JSON → check key (`servers` cho `.vscode/mcp.json`, `mcpServers` cho `.mcp.json`) → test process → reload IDE → đọc log MCP panel.

> 📄 **Code ví dụ:** [`examples/05-4-tools-khong-hien-trong-copilot-debug-theo.sh`](examples/05-4-tools-khong-hien-trong-copilot-debug-theo.sh)

Sau sửa `mcp.json` phải reload / restart MCP server trong MCP panel. Log: VS Code → View → Output → chọn MCP server đó.

## 5. Secrets trong MCP: placeholders viết sao?

**Trả lời 1 câu:** Quy tắc vàng: **file MCP commit được = không chứa secret thật** — Copilot harness dùng `${env:...}` (biến đã export), Local harness (VS Code) dùng `${input:...}` (IDE hỏi lúc start).

> 📄 **Code ví dụ:** [`examples/06-5-secrets-trong-mcp-placeholders-viet-sao.json`](examples/06-5-secrets-trong-mcp-placeholders-viet-sao.json)

> 📄 **Code ví dụ:** [`examples/07-5-secrets-trong-mcp-placeholders-viet-sao.sh`](examples/07-5-secrets-trong-mcp-placeholders-viet-sao.sh)

> Không có ngoại lệ "tạm paste rồi xóa sau": git history giữ mãi, bot quét GitHub tìm thấy trong vài phút. Đã lỡ commit → `git rm` + **xoay token ngay**.

## 6. MCP postgres trỏ prod — làm sao không phá data?

**Trả lời 1 câu:** 3 lớp bảo vệ, bật cả 3: trỏ **read-replica** (hoặc user DB chỉ `GRANT SELECT`), server chỉ expose query tools (tắt `exec/migrate`), tool `exec` luôn Deny/allow-once.

> 📄 **Code ví dụ:** [`examples/08-6-mcp-postgres-tro-prod-lam-sao-khong.sql`](examples/08-6-mcp-postgres-tro-prod-lam-sao-khong.sql)

> 📄 **Code ví dụ:** [`examples/09-6-mcp-postgres-tro-prod-lam-sao-khong.sh`](examples/09-6-mcp-postgres-tro-prod-lam-sao-khong.sh)

> Cần migrate → làm tay bằng migration tool, không qua MCP.

## 7. MCP GitHub server cần scope token nào?

**Trả lời 1 câu:** Token tối thiểu làm được việc — fine-grained PAT chỉ repo cần (read-only nếu chỉ đọc), tạo PAT riêng cho MCP, đừng reuse PAT deploy.

> 📄 **Code ví dụ:** [`examples/10-7-mcp-github-server-can-scope-token-nao.sh`](examples/10-7-mcp-github-server-can-scope-token-nao.sh)

## 8. MCP Playwright (browser) dùng khi nào?

**Trả lời 1 câu:** Cho agent mở trang, click, chụp screenshot, đọc console errors — nặng (Chromium ~300-500MB RAM) nhưng cần khi verify UI/E2E thật; chỉ check API thì dùng `curl` nhanh hơn.

> 📄 **Code ví dụ:** [`examples/11-8-mcp-playwright-browser-dung-khi-nao.json`](examples/11-8-mcp-playwright-browser-dung-khi-nao.json)

> 📄 **Code ví dụ:** [`examples/12-8-mcp-playwright-browser-dung-khi-nao.sh`](examples/12-8-mcp-playwright-browser-dung-khi-nao.sh)

> Thiếu browser → `npx playwright install chromium`; boot app local trước; làm backend thuần thì tắt server cho nhẹ máy.

## 9. Nhiều MCP servers cùng lúc — quản lý sao cho nhẹ?

**Trả lời 1 câu:** Mỗi server stdio = 1 process + RAM, và menu tools dài làm model chọn sai/bỏ sót — chỉ bật server task đang cần, server nặng để SSE chung team.

> 📄 **Code ví dụ:** [`examples/13-9-nhieu-mcp-servers-cung-luc-quan-ly.sh`](examples/13-9-nhieu-mcp-servers-cung-luc-quan-ly.sh)

> Ngày làm backend → `github + postgres`; ngày làm UI → thêm `playwright`. Không bật cả 3 trừ khi cần.

## 10. MCP log đọc ở đâu, lỗi nào hay gặp?

**Trả lời 1 câu:** Log ở `View → Output → [MCP server name]`; 4 lỗi top:

| Lỗi trong log | Nghĩa | Fix |
|---|---|---|
| `ENOENT npx` | Máy thiếu node/npx | Cài node LTS |
| `401/403` | Token sai/hết hạn | Tạo token mới, update env |
| `ECONNREFUSED` | SSE server chưa chạy | Start server / check URL |
| `JSON parse error` | `mcp.json` sai cú pháp | Validate JSON (câu 4) |

> 📄 **Code ví dụ:** [`examples/14-10-mcp-log-oc-o-au-loi-nao.sh`](examples/14-10-mcp-log-oc-o-au-loi-nao.sh)

---

## Vẫn lỗi thì sao? (thứ tự debug chuẩn)

Đi đủ 5 bước theo thứ tự — MCP lỗi im lặng nên bước nào nhảy cóc là đoán mò:

1. `python3 -c "import json;..."` validate `mcp.json`.
2. Check key `servers` + entry server đúng format.
3. Test transport tay: `npx ... --help` (stdio) / `curl` health (SSE).
4. Check token: env có, chưa hết hạn, đủ scope.
5. Reload IDE → đọc Output panel log server đó.

📄 Debug sâu khi tools biến mất giữa chừng: [`examples/04-5-mcp-tools-ot-nhien-mat-thu-tu.sh`](examples/04-5-mcp-tools-ot-nhien-mat-thu-tu.sh).

Tham khảo chéo: [bài 03](03-modes-permissions.md) (tool approval) · [bài 08](08-loi-thuong-gap-troubleshooting.md) (lỗi tổng hợp) · [bài 09](09-bao-mat-quyen-rieng-tu.md) (secrets + audit) · [../templates/.mcp.json](../templates/.mcp.json) (mẫu Copilot harness) · [../templates/.vscode/mcp.json](../templates/.vscode/mcp.json) (mẫu Local harness, copy ngay).

> **Tóm gọn 1 câu:** MCP là hệ dây điện nối Copilot với thế giới ngoài — `mcp.json` là bản vẽ, token là thẻ từ, log Output là đồng hồ đo điện; hỏng chỗ nào tra đúng chỗ đó theo thứ tự 5 bước.
