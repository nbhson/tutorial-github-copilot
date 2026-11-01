# 07 — Policies & Guardrails Tự Động Hóa (Hooks + 6 Lớp Ngoài Model)

> **Dành cho:** dev muốn "ép" Copilot tuân thủ quy tắc, và tech lead/admin dựng chuẩn cho team.
> **Vấn đề:** Copilot 2026 *có* hooks (`.github/hooks/*.json`, events `PreToolUse`/`PostToolUse`...) nhưng hooks là **preview, chỉ chạy Local, và model vẫn lách được khi config lơi**. Cấm tuyệt đối (push main, lộ secret) phải dựa vào lớp server.
> **Đọc xong:** dựng được 6 lớp guardrails — instructions, MCP allowlist, content exclusion, pre-commit, branch protection, secret scanning + Copilot review gate. Mỗi lớp có lệnh copy-paste và cách verify. **Thời gian:** ~40 phút.

## Mục tiêu bài học

- Phân biệt **advisory / semi-law (hook) / law** — vì sao instructions không thay được server guard.
- Dựng đủ **6 lớp guardrails** từ mềm tới cứng, mỗi lớp verify được.
- Biết chính xác **Copilot hooks 2026 mạnh tới đâu** (preview, Local-only) — và khi nào nâng lên lớp server.

> **Tóm gọn 1 câu:** Sau bài này bạn xếp được 6 lớp phòng thủ từ "lời dặn" tới "khóa cổng server" — và biết lớp nào Copilot lách được, lớp nào không.

---

## 1. Hooks mạnh tới đâu — enforce bằng gì?

Mục này phân định "ai cấm được ai": hooks chạy ở đâu, guardrail là gì, và vì sao không thể chỉ dựa vào một thứ duy nhất.

- **Hooks** = đoạn code chạy chen vào ngay trước/sau một thao tác. Nôm na: chuông khói tự ngắt cầu dao. **Copilot 2026 có hooks in-process (`.github/hooks/*.json`, `PreToolUse`/`PostToolUse`...) nhưng preview, chỉ chạy Local** — chi tiết bài 17.
- **Guardrail** = hàng rào cố định không phụ thuộc ai nhớ (branch protection, content exclusion).

| Cấp | Nôm na | Ví dụ | Override được? |
|---|---|---|---|
| **Advisory** | Dặn miệng | instructions trong prompt | Có (Copilot quên được khi context dài) |
| **Semi-law (hook)** | Chặn 1 thao tác cụ thể, config do dev giữ | Copilot hooks in-process (Local-only) | Gần như có |
| **Law** | Khóa cổng server | Branch protection, push protection | Không |

> **Cách đọc bảng này:** Ba cấp từ mềm tới cứng — cột "Override được?" là quan trọng nhất: đó chính là câu hỏi "Copilot có lách được không".

**Thứ tự nghĩ:** server-side (GitHub) > local deterministic (pre-commit, linter, exclusion) > advisory (instructions). Cách nhớ: lớp nào bạn gõ tay được thì dev sửa tay được; lớp nào nằm trên GitHub thì dev không sửa nổi. **Rule nào bị quên 2 lần → nâng lên lớp server, đừng dặn lại lần thứ ba.** Giống dạy con: nhắc miệng được vài lần, rồi phải khóa tủ kẹo luôn.

> **Tóm gọn 1 câu:** Đừng dặn mỏi miệng — quy tắc nào bị quên 2 lần thì đưa lên lớp server, nơi không ai sửa tay được.

---

## 2. Bản đồ 6 lớp guardrails

| # | Lớp | Nôm na | Chặn ở đâu | Copilot override được? |
|---|---|---|---|---|
| 1 | Instructions enforcement | Dặn miệng | Prompt (advisory) | Có (quên được) |
| 2 | MCP allowlist + tool approval | Giữ chìa khóa | Client / org policy | Khó |
| 3 | Content/language exclusion | Bịt mắt | Server (GitHub) | Không |
| 4 | Pre-commit + linter | Soi hành lý trước khi lên xe | Local git hook | Không (chạy ngoài model) |
| 5 | Branch protection + required checks | Khóa cổng làng | Server (GitHub) | Không |
| 6 | Secret scanning/push protection + review gate | Máy soi + kiểm định cuối | Server (GitHub) | Không |

> **Cách đọc bảng này:** Sáu lớp xếp từ mềm (dặn miệng) tới cứng (khóa cổng server) — cột "Copilot override được?" cho biết mỗi lớp có bị model qua mặt không; lớp 3 trở đi là "không".

---

## 3. Lớp 1–2: instructions + MCP allowlist

### 3.1. Lớp 1 — Instructions viết dạng LAW (advisory, nhưng khó quên)

Mục này dạy cách viết "nội quy" cho Copilot sao cho khó bỏ qua — không phải không bỏ qua được, nhưng khó quên nhất trong lớp advisory.

Cú pháp đầy đủ đã ở bài 03; ở đây chỉ nhớ công thức: **cấm rõ + hậu quả + việc đúng** — như biển "CẤM ĐỖ XE — sai phạt 2 triệu, đỗ ở bãi B" hiệu quả hơn "vui lòng không đỗ xe".

```markdown
<!-- .github/copilot-instructions.md — rules dạng LAW, testable -->
# Guardrails (Copilot PHẢI tuân thủ — nếu vi phạm, dừng và hỏi)

1. KHÔNG push trực tiếp `main`/`master`. Mọi change → branch `feat/*` + PR.
2. KHÔNG sửa files trong `db/migrations/` đã merge — viết migration MỚI.
3. KHÔNG đọc/gợi ý từ `.env*`, `*credentials*`, `*secret*`.
4. Sau mỗi edit `.ts`: chạy `npx prettier --write <file>` + `npx eslint <file>`.
5. Test: chạy focused (`pnpm --filter @acme/api test <path>`) trước, full chỉ khi yêu cầu rõ.
```

```text
 # Verify lớp 1: chat "push giúp anh lên main" → Copilot phải từ chối/gợi ý mở PR.
 # Nhớ: đây vẫn là advisory — muốn chặn thật phải có lớp 5.
```

### 3.2. Lớp 2 — MCP allowlist + tool approval

Allowlist = **danh sách được phép**; ngoài list → hỏi (ask) hoặc cấm (deny). Nôm na: Copilot cầm chìa phòng đọc (allow), chìa phòng máy phải hỏi (ask), chìa két sắt không đưa (deny). Giống phân quyền khách tới nhà: vào phòng khách tự do, vào bếp phải gõ cửa, phòng két thì không ai có chìa.

> 📄 **Code ví dụ:** [`examples/01-3-2-lop-2-mcp-allowlist-tool-approval.jsonc`](examples/01-3-2-lop-2-mcp-allowlist-tool-approval.jsonc)

```text
 Org-level (admin — Org Settings → Copilot → Policies): MCP allowlist chỉ github/fetch/linear,
 server lạ → block; tool approval default terminal = ask cho cả org (đè settings local).

 # Verify lớp 2: "liệt kê PRs" (allow) → chạy luôn, không popup;
 ' # "chạy rm -rf /tmp/x" (ask) → phải popup hỏi; gọi postgres-prod (deny) → "blocked by policy".
```

> **Tóm gọn 1 câu:** Lớp 2 là bảng phân chia chìa khóa: cho phép thì làm luôn, nguy hiểm thì bắt hỏi, tối mật thì cấm hẳn.

---

## 4. Enterprise policy: managed-settings.json + budgets (admin)

Khi settings local chưa đủ (mỗi dev sửa được file của mình), admin chốt policy ở **AI controls tab (enterprise)** và **org settings**. Hai điểm cần nhớ:

- **Copilot app và Copilot CLI chạy theo 2 policy client riêng, độc lập** — bật ở app không có nghĩa là bật ở CLI.
- Enterprise đặt policy trước, rồi chọn "let organizations decide" cho từng policy.

**`managed-settings.json`** = file cấu hình cấp enterprise, ép mọi client (Copilot CLI, VS Code, Copilot app, cloud agent, JetBrains) dùng chung một bộ luật — nội quy công ty dán ở lễ tân, không phải mỗi phòng tự viết:

| Key | Làm gì | Dùng khi nào |
|---|---|---|
| `model` | Ép model mặc định cho cả enterprise | Đưa mọi người về model đã duyệt |
| `autoTier` | Ép tier auto model selection (efficiency/balance/intelligence) | Chọn ưu tiên chi phí hay chất lượng |
| `permissions.deny` / `.ask` / `.allow` | Cấm / hỏi trước / cho qua từng thao tác | Ưu tiên: **deny > ask > allow** |
| `permissions.disableBypassPermissionsMode` | Tắt bypass (YOLO) mode | Tránh dev tắt permission cho nhanh |
| `allowedMcpServers` / `deniedMcpServers` | Allowlist MCP mức enterprise | Deny thắng allow; `[]` rỗng = lockdown |
| `sandbox` | Ép sandbox tối thiểu cho command/fs/network/credentials | Vd `sandbox.userPolicy.network.allowedHosts` |
| `telemetry` / `enabledPlugins` / `strictKnownMarketplaces` | Telemetry OTLP, kiểm soát plugin + marketplace | Chỉ marketplace công ty tin cậy |

> **Cách đọc bảng này:** Mỗi dòng là một "khoá cấu hình" enterprise — cột giữa nói nó kho cái gì, cột phải nói khi nào nên vặn khoá đó.

**Budgets (ngân sách AI credits):**

- **1 AI credit = $0.01.** Credit của org gộp chung ở mức billing-entity, không chia cứng từng seat.
- User hết credit → xin tăng budget; owner/billing manager duyệt hoặc từ chối trong settings.
- **Paid usage policy (cho phép chi vượt credit kèm sẵn) bật mặc định** — admin muốn cắt chi phí thì phải tắt đi. Code completions **không tính credit**.

**Audit log:** tìm bằng `action:copilot`, giữ **180 ngày**, nên stream sang SIEM. Ghi thay đổi policy/settings + agent activity — **không chứa prompt/session của client**.

**Network allowlist (admin mạng cần mở):** `https://*.githubcopilot.com/*` (mọi plan, gồm subdomain individual/business/enterprise) · `https://github.com/login/*` + `https://collector.github.com/*` · `https://copilot-telemetry.githubusercontent.com/telemetry` · `https://*.SUBDOMAIN.ghe.com` (data residency).

> **Tóm gọn 1 câu:** Enterprise policy là "bộ luật chung dán ở lễ tân" — mọi client cùng tuân theo, và admin phải nhớ 2 policy client độc lập cộng chuyện tắt paid usage nếu muốn cắt chi phí.

---

## 5. Lớp 3: content & language exclusion

Content exclusion = cấu hình **server-side** khiến file/path nhạy cảm **không bao giờ** được gửi lên model — kể cả khi bạn lỡ tay ask. Nôm na: két sắt có rèm, camera (Copilot) không nhìn được vào trong. **Khác `.gitignore`** — gitignore chỉ ignore git, model vẫn đọc được file.

```text
 Setup (admin — repo/org Settings → Copilot → Content exclusion → Add path):
   .env*   **/*credentials*   **/*secret*   certs/**   db/prod-dump/**
   .vscode/mcp.json        # nếu chứa secrets (nên chuyển sang env — bài 08)

 Verify: (1) mở .env trong VS Code → icon Copilot phải hiện "excluded";
 (2) chat "@workspace đọc file .env" → phải từ chối; (3) vẫn đọc được →
 chưa apply (đợi ~30 phút sync) hoặc path sai.
```

**Cần biết:** chỉ có ở **Copilot Business/Enterprise** · path kế thừa từ org cha · xem được qua REST API · role Maintain xem được nhưng không sửa được.

**Phòng thủ thêm ở máy dev (defense in depth):** tắt gợi ý cho file nhạy cảm trong `.vscode/settings.json` — `"github.copilot.enable": { "*": true, "plaintext": false, "env": false }`; giới hạn ngôn ngữ gợi ý bằng `github.copilot.chat.language.enabled`.

> **Duplication detection** (gợi ý trùng public code): Copilot Business **mặc định Blocked** — đổi được trong phần Privacy. Chi tiết bài 10.

> **Tóm gọn 1 câu:** Lớp 3 bịt mắt Copilot khỏi file nhạy cảm ngay từ phía server — khác `.gitignore` chỗ này: file không bao giờ được gửi lên model.

---

## 6. Lớp 4: pre-commit hooks + linter

Pre-commit là git hook local chạy **ngoài model** — Copilot gợi ý sai thì hook vẫn block. Nôm na: máy soi hành lý — Copilot gói vali ẩu cũng không "nói khéo" cho qua được. (Khác Copilot hooks: pre-commit chặn **lúc commit**; Copilot hooks chặn **tool call trong agent loop** — bổ trợ nhau.)

**Chọn 1 recipe làm chuẩn — đừng chạy A + B song song (lint 2 lần, chậm commit):**

| Recipe | Cần cài gì | Mạnh nhất ở đâu | Khi nào dùng |
|---|---|---|---|
| A — husky + lint-staged | `pnpm add -D husky lint-staged prettier eslint` | Auto-format + lint chỉ files staged (nhanh) | Team Node đơn ngôn ngữ |
| B — pre-commit framework | `pip install pre-commit` + `.pre-commit-config.yaml` | Đa ngôn ngữ + block secrets (gitleaks) | Team Node + Python + Go |
| C — git hook thuần | Không cần package | Block push main, không dependency | Muốn chặn mà không cài gì |

> **Cách đọc bảng này:** Ba "công thức nấu" cho cùng một món (chặn lúc commit) — chọn một công thức duy nhất theo cột "Khi nào dùng", đừng nấu cả ba.

### 6.1. Recipe A — husky + lint-staged (Node, phổ biến nhất)

> 📄 **Code ví dụ:** [`examples/02-6-1-recipe-a-husky-lint-staged-node.sh`](examples/02-6-1-recipe-a-husky-lint-staged-node.sh)

> 📄 **Code ví dụ:** [`examples/03-6-1-recipe-a-husky-lint-staged-node.json`](examples/03-6-1-recipe-a-husky-lint-staged-node.json)

### 6.2. Recipe B — pre-commit framework + secret scan (đa ngôn ngữ)

> 📄 **Code ví dụ:** [`examples/04-6-2-recipe-b-pre-commit-framework-secret.yaml`](examples/04-6-2-recipe-b-pre-commit-framework-secret.yaml)

> 📄 **Code ví dụ:** [`examples/05-6-2-recipe-b-pre-commit-framework-secret.sh`](examples/05-6-2-recipe-b-pre-commit-framework-secret.sh)

### 6.3. Recipe C — git hook thuần (block push main, không dependency)

> 📄 **Code ví dụ:** [`examples/06-6-3-recipe-c-git-hook-thuan-block.sh`](examples/06-6-3-recipe-c-git-hook-thuan-block.sh)

> **Tóm gọn 1 câu:** Lớp 4 là "máy soi hành lý" chạy ngoài model — Copilot gói vali ẩu thì hook vẫn chặn lúc commit, không nói khéo được.

---

## 7. Lớp 5–6: branch protection + secret scanning + review gate (server)

### 7.1. Lớp 5 — Branch protection + required checks

Muốn merge vào `main` phải có PR + CI xanh + 1 người duyệt — **kể cả admin**. Nôm na: khóa cổng làng + giấy thông hành, admin cũng không leo rào được.

> 📄 **Code ví dụ:** [`examples/07-7-1-lop-5-branch-protection-required-checks.sh`](examples/07-7-1-lop-5-branch-protection-required-checks.sh)

**Rulesets** (khuyên dùng 2026 — github.com → Settings → Rules → Rulesets, dễ review/dễ đổi hơn CLI 1 lần): target branch `main` (+ `release/*`); rules: Restrict deletions ✓, Block force pushes ✓, Require PR (1 approval + dismiss stale) ✓, Require status checks ✓, Require Copilot code review (mục 7.3) ✓.

### 7.2. Lớp 6a — Secret scanning + push protection

- **Secret scanning: ON** — quét lịch sử repo tìm key đã lọt.
- **Push protection: ON** — block push chứa secret **ngay lúc push**, kể cả Copilot là người tạo commit.
- **Validity checks: ON** — check secret còn sống không.

> 📄 **Code ví dụ:** [`examples/08-7-2-lop-6a-secret-scanning-push-protection.sh`](examples/08-7-2-lop-6a-secret-scanning-push-protection.sh)

### 7.3. Lớp 6b — Copilot code review as gate

Bắt mọi PR qua trạm kiểm định Copilot review trước khi merge. **4 fact trước khi cấu hình:**

- Review mặc định là **"Comment"** — không tính approval; muốn Copilot approve phải cấu hình riêng.
- **Effort mặc định "Balanced"** (từ 28/09/2026). `Lite` nhanh/rẻ, `Balanced` suy luận sâu cho logic phức tạp + security.
- Chi phí ước tính/review: Lite **$0.05–$1**, Balanced **$0.25–$5** AI credits (chưa tính phút Actions).
- Từ **02/10/2026 có API (REST + GraphQL)** để request review + set effort — chạy được từ CI.

Trước khi cấu hình, nhớ 4 fact ở trên như xem hợp đồng trước khi ký — review mặc định chỉ là ghi chú, không phải chữ ký duyệt.

```text
 Setup: Settings → Rules → Rulesets → Require Copilot code review: ON (auto-request cho mọi PR).
 Luồng PR chuẩn: push feat/* → PR → Copilot review tự chạy (critical/high phải fix)
 → CI xanh + 1 human approval + review pass → merge.
 Tune precision (reviewer quá khắt → dặn trong copilot-instructions.md):
 "Code review: chỉ flag lỗi thực sự (bug, security, perf regression).
  Đừng flag style đã có prettier lo, đừng over-engineer."
 # Verify: PR test cố ý có SQL injection → Copilot review phải flag [CRITICAL] đúng dòng.
```

Muốn cứng hơn "chỉ mong Copilot review" → dựng Actions check fail cả PR khi Copilot review có CRITICAL (đọc reviews của `github-copilot` bằng `gh pr view --json reviews`, grep "critical" → exit 1). Khung workflow chi tiết ở bài 12.

> **Tóm gọn 1 câu:** Lớp 5–6 là khóa cổng thật sự: branch protection, push protection và review gate nằm trên server — không ai lách được, kể cả admin.

---

## 8. Hiểu nhầm thường gặp

| Hiểu nhầm | Sự thật |
|---|---|
| "Viết instructions cấm là đủ" | Advisory — Copilot quên được khi context dài. Cấm tuyệt đối → branch protection + push protection |
| "Copilot có hooks rồi, bỏ pre-commit/branch protection" | Hooks = preview + Local-only + dev sửa được file hook → chưa phải security boundary |
| "Pre-commit chạy trong Copilot nên Copilot tắt được" | Pre-commit là git hook local, chạy ngoài model. Copilot không tắt được |
| "Content exclusion giống .gitignore" | `.gitignore` chỉ ignore git (model vẫn đọc). Exclusion chặn file gửi lên model (server) |
| "Bật push protection là hết lộ secret" | Chỉ block lúc push. Đã lọt lịch sử → secret scanning + rotate key |
| "Bật audit log là xem được mọi prompt" | Audit log (`action:copilot`) ghi policy/activity, 180 ngày. Không chứa prompt client |
| "Hết credit là Copilot tự dừng" | Chưa chắc — paid usage policy bật mặc định, admin phải tắt mới cắt được |

> **Cách đọc bảng này:** Mỗi dòng là một câu "nghe rất hợp lý nhưng sai" — cột phải đính chính sự thật; đọc kỹ trước khi tin bất kỳ câu lặp lại trong team.

---

## 9. Walkthrough + bài tập

```text
 Dựng 6 lớp từ 0 (~40 phút):
 1 (5'): instructions LAW (mục 3.1). Test: "push lên main" → phải từ chối.
 2 (5'): content exclusion .env* (mục 5). Test: "@workspace đọc .env" → phải từ chối.
 3 (10'): recipe A husky (mục 6.1). Test commit file lint lỗi → auto-fix/fail. Hook >5s → thu hẹp scope.
 4 (10'): branch protection gh CLI (mục 7.1). Test push main → server từ chối.
 5 (10'): push protection + review gate (mục 7.2–7.3). Test secret giả → push block.
 # Kỳ vọng cuối: push main bị chặn server-side, PR có review gate.
```

**Bài tập:**

1. **(15 phút)** Cài recipe A. Commit file cố ý sai lint, đo thời gian hook — >5s thì thu hẹp scope.
2. **(15 phút)** Bật content exclusion cho `.env*`, test `@workspace đọc .env` — ghi kết quả (từ chối hay lọt?).
3. **(20 phút)** Setup branch protection + test push protection bằng secret giả. Mở PR có bug (SQL injection), đếm findings Copilot review bắt được, tune instructions tới khi precision cao.

> **Tóm gọn 1 câu:** Dựng 6 lớp trong ~40 phút bằng walkthrough, rồi chốt 3 bài tập có đo đạc — mỗi lớp phải có bài "thử đột nhập" riêng.

## Link qua

- Advisory vs law, instructions cú pháp đầy đủ → bài 03. Khóa `tools` agent → bài 06.
- Secrets MCP qua env + prune servers → bài 08. Tool approval allow/ask/deny → bài 10.
- Branch `copilot/*` + PR flow → bài 11. Required checks trong Actions → bài 12.

> **Tóm gọn 1 câu:** Muốn đào sâu từng lớp — instructions, MCP, secrets, branch flow — xem bản đồ liên kết dưới đây tới bài tương ứng.

> **Chốt:** Instructions là lời dặn miệng, hook là còi báo cháy — chỉ lớp server (branch protection, push protection, review gate) mới là luật không ai lách được. Rule nào bị quên 2 lần thì nâng lên server, đừng dặn lại lần thứ ba.
