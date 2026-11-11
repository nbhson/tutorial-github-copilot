# 08 — MCP: Kết Nối Copilot Tới Thế Giới Ngoài (GitHub, DB, Browser...)

> **Dành cho:** người dùng Copilot trong VS Code / Copilot CLI; tech lead muốn chuẩn hóa MCP cho team.
> **Vấn đề:** Copilot giỏi trong repo nhưng "mù" với mọi thứ ngoài repo (PR, issue, DB, web, ticket).
> **Đọc xong:** cắm được server vào đúng file cho Copilot harness, đọc hiểu 3 thành phần của một server, đặt approval đúng mức và prune còn 3–6 servers. **Thời gian:** ~40 phút.
>
> **Lưu ý 2026:** mặc định của khoá là **Copilot harness** — file khai server là **`.mcp.json` ở ROOT repo** (key `mcpServers`) và user file `~/.copilot/mcp-config.json`. `.vscode/mcp.json` (key `servers`) là format của **Local harness**: nhiều tutorial và bản cài VS Code cũ mặc định nó, nên hay bị nhầm là chuẩn chung — không phải.

## Mục tiêu bài học

Mục này cho biết hết bài bạn làm được gì — đọc xong biết ngay có đáng đầu tư 40 phút hay không.

- Biết **khi nào cần / khi nào đừng** cài MCP — thêm server không mặc định là mạnh thêm.
- Khai server **đúng file cho Copilot harness**, chọn đúng transport, secrets qua env `${TEN}`.
- Phân biệt **3 thành phần** của một server (Tools / Resources / Prompts) và biết **Copilot connectors** — đường GitHub-managed khỏi tự nuôi server.
- Đặt **approval** theo `deny > ask > allow` và prune còn 3–6 servers.

> **Tóm gọn 1 câu:** Bài này dạy bạn cắm Copilot ra thế giới ngoài bằng MCP — đúng file, đúng transport, khóa approval đúng mức, danh bạ gọn.

---

## 1. MCP là gì — khi nào cần, khi nào đừng

**Định nghĩa 1 câu:** MCP (Model Context Protocol) là **chuẩn cắm chung** để Copilot gọi ra thế giới ngoài (GitHub, DB, browser, Linear...) — như USB-C: một chuẩn cho mọi thiết bị, khỏi mỗi hãng một kiểu tích hợp.

**Nôm na (anh bồi bàn):** bạn = khách, Copilot = bồi bàn, MCP server = bếp (bếp GitHub, bếp Postgres). "Cho anh 5 PRs mới nhất" → bồi bàn viết phiếu (tool call) → bếp làm → trả đĩa (JSON) → bồi bàn bày biện.

```text
KHÔNG MCP: "PR #123 đang bàn gì?" → "em không thấy GitHub, anh paste diff vào đây."
CÓ MCP:    "tóm tắt PR #123 repo acme/api" → agent tự gọi github server → trả 5 dòng.
```

**Khi nào đừng cài (quan trọng hơn "cài gì"):** dữ liệu đã nằm trong repo (`src/`, `docs/`) → hỏi trực tiếp là đủ; server thừa chỉ thêm process nền, popup approval, bề mặt lộ secret. Dữ liệu **ngoài** repo (PRs, DB, web, tickets) → mới cần MCP. **MCP = reach vươn ra ngoài; instructions/skills = cách dùng reach cho đúng** (schema DB nào, output format nào — bài 03/05).

> **Vì sao quan trọng?** Đây là câu hỏi tiết kiệm mọi thứ còn lại của bài: mỗi server thừa là một process nền + một mồi làm model chọn nhầm tool + một nơi token có thể lộ.
> **Nếu làm sai?** Cài MCP cho việc trong repo → hai tuần sau không ai nhớ server đó để làm gì, và nó là thứ đầu tiên chết khi công ty đổi network policy.
> **Tóm gọn 1 câu:** MCP chỉ đáng cài khi dữ liệu nằm *ngoài* repo.

## 2. Một lời gọi MCP đi qua 4 nhân vật

```text
Vòng đời câu "liệt kê 5 PRs mở gần nhất":
1. tools/list  — client hỏi từng server "có món gì?" → nhận menu + schema (không cần approval).
2. Model chọn  — đọc menu + prompt → "cần github list_prs(owner, repo, state, limit)".
3. Approval    — đối chiếu rules allow/ask/deny (mục 5): allow → chạy; ask → popup.
4. tools/call  — JSON-RPC kèm params → server gọi API thật bằng token của chính nó.
5. Trình bày   — server trả JSON → model tóm tắt 5 dòng tiếng người.
```

| Nhân vật | Là gì thật | Ghi chú |
|---|---|---|
| Bạn + model | Session chat đang chạy | model chỉ thấy menu tool và kết quả JSON |
| MCP client | Do **chính harness spawn**: Copilot harness chạy trong **Agent Host**; Local harness trong extension host | nói JSON-RPC với server |
| MCP server | Process riêng (`npx ...`) hoặc endpoint HTTP, khai trong file config | giữ token, gọi API thật |
| Hệ ngoài | github.com, Postgres, Chrome, Linear... | chỉ server chạm vào; **token nằm ở server process (env)**, model không bao giờ cầm token |

Lỗi "không gọi được tool" thường ở trạm 3–4, không phải ở model.

## 3. Nơi khai server: `.mcp.json` + transports

**Vị trí — Copilot harness và Copilot CLI đọc trực tiếp:**

| Vị trí | Key | Phạm vi | Commit? |
|---|---|---|---|
| `.mcp.json` — **root repo** | `mcpServers` | team dùng chung qua Copilot harness + CLI (guided flow chỉ đề xuất destination này khi `chat.mcp.workspaceRootConfig.enabled` bật) | Có — chỉ `${TEN}`, không secrets |
| `.github/mcp.json` (project-level CLI) | `mcpServers` hoặc bare | share qua repo | Có |
| `~/.copilot/mcp-config.json` (`$COPILOT_HOME`) | `mcpServers` | user, mọi repo trên máy | Không |

Thứ tự nạp của docs CLI (cao → thấp): `--additional-mcp-config` → server do plugin cung cấp → workspace (`.mcp.json` + `.github/mcp.json`, đọc từ cwd ngược lên Git root, **chỉ khi folder được trust**) → `~/.copilot/mcp-config.json`; trùng tên thì nguồn cao hơn thắng. Tên tool gửi lên model bị sanitize theo khuôn `serverName-toolName`, tối đa 64 ký tự — viết allowlist thì lấy tên đó, đừng đoán theo khuôn của client khác.

> ⚠️ **Khác biệt Local harness** (đào sâu: [local/system-knowledge/vscode-mcp-json](commands/local/system-knowledge/vscode-mcp-json/README.md)): `.vscode/mcp.json` dùng key `servers` + biến môi trường `${env:NAME}`, và là nơi **duy nhất** có `${input:…}` (hỏi secret lúc chạy), `envFile`, `sandbox` per-server, dev mode. Guided flow dán nhãn các destination này là *deprecated (giữ cho tương thích)*: hãy chọn **Copilot Global** hoặc **Workspace-root `.mcp.json`** khi làm cho Copilot.
> Portable thì hẹp hơn: `.mcp.json` root **chỉ stdio + http**, `${NAME}` / `${NAME:-default}`; user file `~/.copilot/mcp-config.json` thêm `sse` và `cwd`. VS Code forward server "đủ điều kiện" từ `.vscode/mcp.json` sang session Copilot — **trừ** server cần input tương tác; Copilot CLI thì **không đọc** `.vscode/mcp.json`.

**Khung đầy đủ (`.mcp.json` — copy-paste, chỉ thay env):**

```jsonc
{
  // .mcp.json o ROOT repo. Key: mcpServers. Transport trong file nay: chi stdio va http.
  // Secrets lay tu env: ${TEN} hoac ${TEN:-gia-tri-mac-dinh}.
  "mcpServers": {
    "playwright": { "command": "npx", "args": ["-y", "@playwright/mcp@latest"] },
    "linear": {
      "type": "http",
      "url": "${LINEAR_MCP_URL}",
      "headers": { "Authorization": "Bearer ${LINEAR_API_KEY}" }
    }
  }
}
```

| Transport | Nôm na | Khi nào dùng |
|---|---|---|
| `stdio` | bếp nấu tại nhà bạn — harness spawn process local | server local (playwright, postgres); cần runtime trên máy **chạy harness** |
| `http` | gọi quán qua app — remote streamable | server remote; khuyến nghị cho server mới |
| `sse` | điện thoại bàn cũ | server legacy — có ở `.vscode/mcp.json` + user file, **không có ở `.mcp.json` root**; MCP spec đã deprecated nó |

**Verify (bắt buộc):** thêm config chưa phải là bằng chứng agent dùng được server. Mở session mới **đúng harness** → prompt gọi tên server + một hành động ít tác dụng phụ ("Use the Playwright MCP server to open `<URL>` and report the page title. Use its tools, not the built-in browser tools. Do not change files.") → **expand tool call**: đúng server, đúng output, câu trả lời phản ánh output. Trả lời "nghe hợp lý" không phải là verify — docs ghi rõ vậy. (Việc browser thường ngày đã có **built-in browser tools**, khỏi cần server.)

> **Tóm gọn 1 câu:** `.mcp.json` root cho team, `~/.copilot/mcp-config.json` cho riêng mình; `.vscode/mcp.json` là chuyện của Local harness.

## 4. 3 thành phần của một MCP server

**Tools = tay (làm), Resources = mắt (đọc), Prompts = công thức pha sẵn** — cả 3 trong cùng một server, tác giả server quyết định expose gì. **Tools bắt buộc**; thiếu Resources/Prompts là bình thường, không phải lỗi.

- **Tools** — hàm có params gọi qua `tools/call`; mỗi tool có `name` + `description` (model dựa vào đây chọn tool) + `inputSchema` (vd `create_pr` bắt buộc `owner, repo, title, head, base`).
- **Resources** — dữ liệu đọc qua URI, không side effects; attach từ **Add Context → MCP Resources** hoặc lệnh **MCP: Browse Resources**.
- **Prompts** — template của tác giả server, gõ `/<server>.<prompt>` trong chat. Muốn chuẩn *team bạn* thay vì chuẩn tác giả thì copy ý về skill trong repo (bài 05). Lưu ý: Copilot cloud agent + code review chỉ nhận **tools**, không nhận resources/prompts (bài 12).

> **Nếu làm sai?** Tự viết server mà `description` lôm côm → tool "biến mất" dù server connected, vì model không biết khi nào gọi nó.

## 5. Approval — 3 dòng

- **`deny > ask > allow`**: deny thắng mọi thứ; rule chưa khớp → mặc định **hỏi**; `[]` = lockdown; allowlist hiệu lực = **giao (intersection)** của mọi nguồn. **Trust server** (được chạy chưa) và **duyệt từng tool call** là hai lớp riêng — đọc publisher trước khi trust, đừng approve máy móc. Ma trận permission levels (Manual / Assisted / Allow all) + sandbox là việc của **bài 10**; org policy "MCP servers in Copilot" (Business/Enterprise, mặc định **tắt**) → bài 07/16.

> 📄 **Code ví dụ (settings.json — allow/ask/deny):** [`./examples/08-mcp-ket-noi-cong-cu-ngoai/approval-allow-ask-deny.jsonc`](./examples/08-mcp-ket-noi-cong-cu-ngoai/approval-allow-ask-deny.jsonc) — `chat.tools.terminal.autoApprove` · `chat.tools.urls.autoApprove` · `chat.tools.eligibleForAutoApproval` · sandbox; tra cứu: [policy-approval](commands/copilot/model-agent/policy-approval/README.md)

## 6. 5 servers day-one

**File cấu hình hoàn chỉnh: [`./examples/08-mcp-ket-noi-cong-cu-ngoai/mcp-servers-day-one.jsonc`](./examples/08-mcp-ket-noi-cong-cu-ngoai/mcp-servers-day-one.jsonc)** (dạng `.mcp.json`, chỉ thay env). Mỗi hàng là một nhu cầu khác nhau:

| Server | Giải quyết việc gì | Dạng trong file |
|---|---|---|
| **GitHub** | PR/issue/code search ngoài repo — impact cao nhất, cài đầu | `http` remote, hoặc tự host Docker |
| **Playwright** | Copilot NHÌN UI qua browser thật (`npx`, cần Node ≥ 18) | `stdio` |
| **Postgres dev** | đọc schema + query môi trường dev — **không commit password** | `stdio` + `${DATABASE_URL}` |
| **Context7 / Fetch** | tra tài liệu framework bản mới nhất | `http` / `stdio` |
| **Linear / Notion** | tickets, docs team sống trong đó — token cá nhân nên để user file | `http` + env |

GitHub MCP server có 2 dạng: **remote hosted** `https://api.githubcopilot.com/mcp/` (chỉ cần URL + auth, có thêm toolset riêng cho remote) hoặc **self-host** `ghcr.io/github/github-mcp-server` (cần Docker); trong Copilot CLI nó đã **built-in**, khỏi khai. Quy tắc DB đi kèm (SELECT/limit khi hỏi prod) là instructions với `applyTo` — xem **bài 03**.

## 7. Copilot connectors + tìm server có sẵn

**Copilot connectors** (GitHub-managed MCP — [lệnh liên quan](commands/copilot/system-knowledge/connector/README.md)):

```text
Ket noi mot dich vu (Slack, Notion, Microsoft Learn...) KHONG phai tu lap server:
- Connectors cap tool cho **Copilot harness**, KHONG cap cho Local harness session.
- Cai: Chat: Open Customizations → Browse → nguon "Copilot Connectors" → Connect
  → authorize trong browser; ngat cung tu cho do (bam "Disconnect", khong phai sua file).
- Server da connect hien o tab MCP Servers voi nhan "Connector: <ten>"; GitHub giu
  config + auth, authorize mot lan, dung lai tren moi Copilot surface cung account.
- Business/Enterprise: admin bat policy "Editor preview features"; vai service con can
  service admin duyet (vd Slack MCP); org MCP allowlist van ap dung.
```

**Tìm server tự cài:** Customizations editor → **Browse** → **GitHub Feed** (search `@type:mcp`; chỉ Copilot harness — Local không có nguồn này); lệnh **`MCP: Add Server`** trong Command Palette cho luồng guided; catalog chuẩn là **[GitHub MCP Registry](https://github.com/mcp)**. Ranh giới đáng nhớ: tool do **VS Code extension** cung cấp chỉ chạy khi cửa sổ editor còn kết nối — muốn chạy nền độc lập thì đi MCP server hoặc connector.

> **Tóm gọn 1 câu:** Service có connector thì connect một lần xài mọi surface; hết connector mới tới MCP server tự nuôi.

## 8. Secrets — chỉ đi qua env

```text
ĐƯỢC (commit an toàn):                          CẤM (lộ là rotate ngay):
  "env": { "TOKEN": "${GITHUB_TOKEN}" }           "env": { "TOKEN": "ghp_abc123..." }
  "args": ["...postgres", "${DATABASE_URL}"]      "args": ["postgresql://user:PASS@host/db"]
  "headers": { "Authorization": "Bearer ${KEY}" } "headers": { "...": "Bearer sk-..." }

Audit truoc moi PR:
  grep -rniE "ghp_|gho_|sk-|xox-|password\s*[:=]" .mcp.json ~/.copilot/mcp-config.json; echo $?
# exit=1 = sach. exit=0 = CO LO: token van trong git history - xoa dong khong du, rotate ngay.
```

Docs chốt: **file cấu hình cá nhân không phải secret store**. Secret thật nằm trong env của máy chạy harness; trên github.com (settings MCP cho cloud agent), secret cá nhân mang prefix `COPILOT_MCP_` — chi tiết ở bài 12/16. Kịch bản "đã lỡ commit token" (❌→✅): 📄 [`05-neu-lam-sai…jsonc`](commands/copilot/system-knowledge/mcp-add/examples/05-neu-lam-sai-thi-sao-sai-ung.jsonc) · [`06-neu-lam-sai…jsonc`](commands/copilot/system-knowledge/mcp-add/examples/06-neu-lam-sai-thi-sao-sai-ung.jsonc).

## 9. Prune — giữ MCP khỏe

**Sweet spot 3–6 servers** — menu 100 món thì bồi bàn loạn: quá nhiều tools → model chọn sai/bỏ sót, context nặng, bề mặt lộ secret to.

```text
Prune flow (2 tuan/lan, 10 phut):
1. copilot mcp list (CLI) hoac "MCP: List Servers" (Command Palette) → server nao disconnected?
2. Hoi agent "liet ke MCP tools may dang thay" → server 2 tuan khong duoc goi → disable 1 tuan, chua ai keu thi xoa han.
3. grep audit secrets (muc 8) → exit phai = 1.
```

## Lỗi thường gặp (❌ SAI / ✅ ĐÚNG)

| ❌ SAI | Hệ quả | ✅ ĐÚNG |
|---|---|---|
| Paste token vào `.mcp.json` rồi commit | git history giữ mãi, bot quét thấy trong vài phút | `${TEN}` + env; đã lộ thì **rotate**, không chỉ xóa dòng |
| Tin "server connected = Copilot dùng được" | model chưa từng gọi nó mà bạn không biết | expand tool call — đủ check ở cuối mục 3 |
| Dùng `${input:…}` trong `.mcp.json` | portable format không nhận; server không được forward sang Copilot | env vars; `${input:…}` chỉ dành cho `.vscode/mcp.json` |
| Copy nguyên file `.vscode/mcp.json` sang `.mcp.json` | sai key (`servers` vs `mcpServers`), mất luôn tính năng `sse`/`envFile` | đối chiếu [format reference](https://code.visualstudio.com/docs/agents/reference/mcp-configuration) trước khi copy |
| Approval `allow` hết cho tiện | write/delete ngoài prod chạy không ai giữ | đọc → `true` trong `autoApprove`, side-effect → `false`/mặc định hỏi, prod → `eligibleForAutoApproval: false` + sandbox (mục 5) |

**Bài học:** đa số sự cố MCP không phải "server hỏng" mà là **khai sai file / sai key** — docs tách hai format và chúng không tương thích nhau. 📄 Hai format đúng, copy được: [`./examples/08-mcp-ket-noi-cong-cu-ngoai/mcp-servers-day-one.jsonc`](./examples/08-mcp-ket-noi-cong-cu-ngoai/mcp-servers-day-one.jsonc) (`.mcp.json`) vs [`commands/local/system-knowledge/vscode-mcp-json/examples/01-cach-goi-copy-paste.sh`](commands/local/system-knowledge/vscode-mcp-json/examples/01-cach-goi-copy-paste.sh) (`.vscode/mcp.json`).

## Best practices

- **Khai team server trong `.mcp.json` root — 📄 [`templates/.mcp.json`](../templates/.mcp.json); secret để trong env của máy/dev box; siết `tools` khi khai (CLI mặc định `*`).** *Vì sao?* File này Copilot harness + CLI cùng đọc — một khai báo chạy trên mọi surface của team; docs GitHub ghi fewer tools → chọn đúng hơn, ít lỗi, đỡ tốn context.
- **Server cá nhân để `~/.copilot/mcp-config.json`, đừng commit.** *Vì sao?* Token personal commit vào repo biến repo thành nơi lộ credentials của riêng bạn.
- **Có connector thì dùng connector, tự nuôi server là phương án cuối.** *Vì sao?* Connector được GitHub maintain + auth một lần; self-host là bạn nhận phần upgrade vào mình.

## Bài tập

1. **(15 phút)** Copy [`./examples/08-mcp-ket-noi-cong-cu-ngoai/mcp-servers-day-one.jsonc`](./examples/08-mcp-ket-noi-cong-cu-ngoai/mcp-servers-day-one.jsonc) vào `.mcp.json` root một repo thật, bỏ server không cần, verify GitHub bằng câu "liệt kê 5 PRs mở" + expand tool call.
2. **(10 phút)** Connect một connector qua Customizations editor; xác nhận nó hiện nhãn `Connector: <tên>` ở tab MCP Servers.
3. **(10 phút)** Chạy prune flow mục 9 + grep audit mục 8 trên repo đang làm — exit code phải = 1.

## Link qua

- Cách dùng MCP theo quy trình team (schema, output format) → bài 03/05 · Agent khóa `tools` khi gọi MCP → bài 06 · Approval matrix + permission levels → bài 10.
- Org policy MCP + validate server → bài 07/16 · MCP cho cloud agent → bài 12 · Plugin bundle `mcp.json` → bài 17 · Tra cứu nhanh: [xem server](commands/copilot/system-knowledge/mcp/README.md) · [thêm server](commands/copilot/system-knowledge/mcp-add/README.md).

## Reference

- VS Code — [Add MCP servers](https://code.visualstudio.com/docs/agent-customization/mcp-servers) · [MCP configuration reference](https://code.visualstudio.com/docs/agents/reference/mcp-configuration) (hai format, env vars, `${input}`) · [Manage MCP servers](https://code.visualstudio.com/docs/agents/run/manage-mcp-servers) · [Copilot connectors](https://code.visualstudio.com/docs/agent-customization/copilot-connectors)
- GitHub — [MCP concept](https://docs.github.com/en/copilot/concepts/context/mcp) · [Add MCP servers cho CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-mcp-servers) · [Connectors](https://docs.github.com/en/copilot/concepts/customizations/copilot-connectors) · [GitHub MCP Registry](https://github.com/mcp) · Chuẩn mở: [modelcontextprotocol.io](https://modelcontextprotocol.io)

**Chốt:** đáng cài MCP khi dữ liệu nằm *ngoài* repo — và khi đã cài thì giữ ba kỷ luật: khai đúng file của harness mình chạy, secrets chỉ đi env, mỗi server phải tự chứng minh nó mở ra thứ mà 3–6 cái kia không với tới.
