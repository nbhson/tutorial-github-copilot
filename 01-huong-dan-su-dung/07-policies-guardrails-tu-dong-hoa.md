# 07 — Policies & Guardrails Tự Động Hóa (Copilot Không Có Hooks In-Process)

> **Dành cho:** dev đã dùng Copilot muốn "ép" Copilot tuân thủ quy tắc, cộng tech lead/admin dựng chuẩn cho team.
> **Vấn đề:** Copilot 2026 không có hooks in-process như Claude Code. Bạn không chặn Copilot được "tại cửa". Vậy cấm push main, chặn lộ secret, bắt review bằng cách nào?
> **Đọc xong:** dựng được 6 lớp guardrails — instructions, MCP allowlist, content exclusion, pre-commit, branch protection, secret scanning + Copilot review gate. Lớp nào cũng có lệnh copy-paste và cách verify.
> **Thời gian:** ~50 phút (bản mở rộng)

## Mục lục

1. [Copilot không có hooks — vậy enforce bằng gì? (why)](#1-copilot-không-có-hooks--vậy-enforce-bằng-gì-why)
2. [Bản đồ 6 lớp guardrails](#2-bản-đồ-6-lớp-guardrails)
3. [Sơ đồ: 1 commit đi qua 6 cổng gác](#3-sơ-đồ-1-commit-đi-qua-6-cổng-gác)
4. [Lớp 1–2: instructions enforcement + MCP allowlist](#4-lớp-1--2-instructions-enforcement--mcp-allowlist)
5. [Lớp 3: content & language exclusion](#5-lớp-3-content--language-exclusion)
6. [Lớp 4: pre-commit hooks + linter (copy-paste)](#6-lớp-4-pre-commit-hooks--linter-copy-paste)
7. [Lớp 5–6: branch protection + secret scanning + review gate](#7-lớp-5--6-branch-protection--secret-scanning--review-gate)
8. [Hiểu nhầm thường gặp](#8-hiểu-nhầm-thường-gặp)
9. [Walkthrough + pitfalls + bài tập](#9-walkthrough--pitfalls--bài-tập)
10. [Link chéo](#10-link-chéo)

---

## 1. Copilot không có hooks — vậy enforce bằng gì? (why)

Section này trả lời 2 câu. Thứ nhất: vì sao chỉ viết instructions là chưa đủ. Thứ hai: nên xếp lớp bảo vệ nào lên trước.

**2 thuật ngữ mở bài (gặp lại suốt bài):**

- **Hooks** = đoạn code chạy chen vào giữa một thao tác, ngay trước khi thao tác đó được chạy. Đời thường: chuông khói tự ngắt cầu dao. Kỹ thuật: Claude Code có hooks in-process — chặn lệnh nguy hiểm trước khi lệnh chạy.
- **Guardrail** = hàng rào an toàn. Đời thường: lan can cầu thang, aptomat chống giật. Kỹ thuật: branch protection trên GitHub, content exclusion.

**Nôm na 1 câu:** Claude Code có bảo vệ đứng chặn ngay cửa (hooks: "cấm chạy lệnh này!"). Copilot 2026 chưa có bảo vệ cửa như vậy. Bạn phải dựng 6 chốt chặn ở vòng ngoài — từ nhắc nhở miệng tới khóa cổng server.

**Analogie đời thường:** Như dạy con không nghịch ổ điện. Lớp 1 là dặn miệng ("đừng sờ!") — con có thể quên. Lớp 5-6 là bịt ổ điện + aptomat chống giật — con quên cũng không sao vì điện đã ngắt. Rule nào con quên 2 lần → nâng lên bịt ổ (thành law).

**Advisory vs law (cặp từ dùng cả bài):**

- **Advisory** = lời khuyên. Người nghe có quyền bỏ qua. Ví dụ: instructions trong prompt.
- **Law** = luật. Không ai override được. Ví dụ: branch protection trên server.

> Triết lý: instructions là advisory (Copilot có thể quên). Guardrails ngoài
> model là law (Copilot không override được). Rule nào miss 2 lần → nâng thành law.

Claude Code có hooks in-process (block tool call trước khi chạy). Copilot 2026
**không có** hooks in-process tương đương. Bạn enforce bằng 6 lớp ngoài model:

```text
So sánh enforce (copy-paste để demo cho team):
- muse-instructions.md "NEVER push main" → Copilot đọc, gật gù, đôi khi vẫn
  gợi ý push (quên/misread khi context dài).
- Branch protection "require PR + block force-push main" → chặn 100% ở server,
  kể cả khi Copilot gợi ý sai.
→ Cái nào cần chắc chắn? Guardrail ngoài model. Cái nào cần linh hoạt? Instructions.
# Ai dùng lúc nào: chuẩn linh hoạt (style, format) → instructions. Cấm tuyệt đối
# (push main, leak secret) → server guard.
```

Thứ tự nghĩ: **server-side (GitHub) > local deterministic (pre-commit, linter,
content exclusion) > advisory (instructions, prompt files)**. Càng gần server,
càng khó lách.

Cách nhớ: lớp nào bạn gõ tay được thì dev sửa tay được. Lớp nào nằm trên GitHub thì dev không sửa nổi.

```text
# Verify bạn đã hiểu (tự check):
# Hỏi: "nếu Copilot gợi ý push main thì sao?"
# - Chỉ có instructions → có thể lọt (Copilot quên).
# - Có branch protection → server từ chối 100%.
# Kỳ vọng: phân biệt advisory vs law, không tin instructions thay server guard.
```

---

## 2. Bản đồ 6 lớp guardrails

Section này cho bạn bản đồ 1 trang. Cột "Chặn ở đâu" nói lên mức độ chắc chắn. Cột "Ai dùng lúc nào" nói ai là người cấu hình lớp đó.

| # | Lớp | Nôm na | Chặn ở đâu | Copilot override được? | Dùng cho (ai dùng lúc nào) |
|---|---|---|---|---|---|
| 1 | Instructions enforcement | Dặn miệng | Prompt (advisory) | Có (quên được) | Chuẩn code, non-goals |
| 2 | MCP allowlist + tool approval | Giữ chìa khóa | Client (VS Code/org policy) | Khó | Giới hạn tools agents được gọi |
| 3 | Content/language exclusion | Bịt mắt (không cho xem) | Server (GitHub) | Không | File nhạy cảm không vào model |
| 4 | Pre-commit + linter | Soi hành lý trước khi lên xe | Local git hook | Không (chạy ngoài model) | Format, lint, block secrets trước commit |
| 5 | Branch protection + required checks | Khóa cổng làng | Server (GitHub) | Không | Block push main, bắt CI xanh + review |
| 6 | Secret scanning/push protection + review gate | Máy soi + kiểm định cuối | Server (GitHub) | Không | Block leak secrets + bắt Copilot review pass |

Đọc bảng theo cách này: lớp 1–2 là **advisory + client** (mềm, dễ đổi). Lớp 3–6 là **server** (cứng, dev không lách được). Việc cần chắc chắn thì để lớp 3–6. Việc cần linh hoạt thì để lớp 1–2.

```text
Luồng 1 commit đi qua:
Bạn/Copilot sửa → [3] exclusion (file nhạy cảm không gửi model) →
[4] pre-commit (lint + secret scan local, fail → commit dừng) →
[5] push → branch protection (push main? từ chối) →
[6] PR → required checks + Copilot review (fail → không merge).
```

---

## 3. Sơ đồ: 1 commit đi qua 6 cổng gác

Section này show đường đi thật. Đọc để biết: commit gặp lớp nào trước, lớp nào fail thì dừng ở đâu. Ai cũng nên đọc (dev biết bị chặn ở đâu, admin biết cấu hình chỗ nào).

```mermaid
flowchart LR
  Edit[Bạn/Copilot sửa code] --> L3{L3: file nhạy cảm?}
  L3 -->|có .env/secret| Block1[Chặn gửi model<br/>content exclusion]
  L3 -->|không| L4[L4: pre-commit<br/>lint + gitleaks]
  L4 -->|fail| Stop1[Dừng commit<br/>sửa rồi commit lại]
  L4 -->|pass| Push[git push]
  Push --> L5{L5: push main?}
  L5 -->|có| Block2[Server từ chối<br/>branch protection]
  L5 -->|không, branch feat| PR[Mở PR]
  PR --> L6[L6: CI + secret scan<br/>+ Copilot review]
  L6 -->|fail| Fix[Sửa + push lại]
  L6 -->|pass + approval| Merge[Merge]
```

Sơ đồ trên là **không gian** (6 cổng xếp song song). Sơ đồ dưới là **thời gian** (thứ tự chạy thật, ai chặn ai):

```mermaid
sequenceDiagram
  participant C as Copilot/Bạn
  participant H as pre-commit hook
  participant G as GitHub server
  C->>H: git commit
  H->>H: lint-staged + gitleaks + block migration edit
  alt hook fail
    H-->>C: FAIL — sửa rồi commit lại
  else hook pass
    H-->>C: OK — tạo commit
    C->>G: git push
    G->>G: branch protection? push protection?
    alt push main / có secret
      G-->>C: BLOCKED 100%
    else PR checks
      G-->>C: cần CI xanh + review pass mới merge
    end
  end
```

---

## 4. Lớp 1 – 2: instructions enforcement + MCP allowlist

Section này đi vào 2 lớp mềm. 4.1 viết instructions cho Copilot khó quên. 4.2 khóa tools bằng allowlist. 4.3 dành cho admin: policy cấp org/enterprise (`managed-settings.json`, model allowlist, budgets).

### 4.1. Lớp 1 — Instructions enforcement (advisory, nhưng viết cho khó quên)

Section này trả lời: viết rules thế nào để Copilot ít quên, và test bằng prompt nào.

**Nôm na 1 câu:** Lớp 1 là **bảng nội quy dán tường** — viết dạng cấm rõ + hậu quả + việc đúng thì Copilot nhớ lâu hơn.

**Analogie:** Như biển "CẤM ĐỖ XE — sai phạt 2 triệu, đỗ ở bãi B" tuân thủ tốt hơn biển "vui lòng không đỗ xe".

```markdown
<!-- .github/muse-instructions.md — viết rules dạng LAW, testable (copy-paste) -->
# Guardrails (Copilot PHẢI tuân thủ — nếu vi phạm, dừng và hỏi)

1. KHÔNG push trực tiếp `main`/`master`. Mọi change → branch `feat/*` + PR.
2. KHÔNG sửa files trong `db/migrations/` đã merge — viết migration MỚI.
3. KHÔNG đọc/gợi ý từ `.env*`, `*credentials*`, `*secret*`.
4. Sau mỗi edit `.ts`: chạy `npx prettier --write <file>` + `npx eslint <file>`.
5. Test: chạy focused (`pnpm --filter @acme/api test <path>`) trước, full chỉ khi yêu cầu rõ.

<!-- Mẹo: rules dạng "KHÔNG + hậu quả + việc đúng" tuân thủ tốt hơn "nên". -->
<!-- Review: rule nào miss 2 lần → nâng thành lớp 4/5 (pre-commit/branch protection). -->
```

Mẫu thứ hai: rules **chỉ áp đúng chỗ** (path-scoped) thay vì dán khắp repo.

```markdown
<!-- .github/instructions/backend.instructions.md — path-scoped, ví dụ -->
---
applyTo: "src/server/**/*.ts"
---
# Backend rules
- Mọi query prod: bắt buộc WHERE + LIMIT 100.
- Không dùng crypto tự chế — dùng `jose`/`node:crypto`.
- API mới phải có test trong `__tests__/` + docs OpenAPI.
```

```text
# Verify lớp 1 (copy-paste):
# Chat: "push giúp anh lên main" → Copilot phải từ chối/gợi ý mở PR.
# Kỳ vọng: từ chối. Nếu gợi ý push luôn → rule viết chưa rõ, sửa lại dạng KHÔNG + việc đúng.
# Nhớ: đây vẫn là advisory — check lớp 5 để chặn thật.
```

**Ai dùng lúc nào:** Mọi team đều viết lớp 1 đầu tiên (rẻ nhất). Rule nào miss 2 lần → nâng thành lớp 4/5.

### 4.2. Lớp 2 — MCP allowlist + tool approval

Section này trả lời: cách nào chặn Copilot gọi tool sai. Trả lời: **allowlist** — danh sách những gì được phép, còn lại hỏi hoặc cấm.

**Allowlist là gì?** Danh sách cho phép. Đời thường: danh sách khách mời — người không có tên phải đứng ở cửa. Kỹ thuật: set `postgres-prod` thành `deny` trong `github.copilot.chat.tools` như bên dưới.

**Nôm na 1 câu:** Lớp 2 là **giữ chìa khóa** — Copilot chỉ được cầm chìa phòng đọc (allow), chìa phòng máy phải hỏi (ask), chìa két sắt thì không đưa (deny).

```jsonc
// .vscode/settings.json — giới hạn tools Copilot được gợi ý/auto-run (commit cho team)
{
  "github.copilot.chat.toolAutoRun": "ask",      // auto-run tools: ask | allow | deny
  "github.copilot.chat.tools": {
    "terminal": "ask",                           // chạy shell → hỏi trước
    "github-mcp": "allow",                       // GitHub MCP → cho qua
    "postgres-prod": "deny"                      // DB prod → cấm hẳn
  }
}
```

```text
Org-level (admin, github.com → Org Settings → Copilot → Policies):
- MCP servers allowlist: chỉ github, fetch, linear được dùng. Server lạ → block.
- Tool approval default: terminal = ask cho cả org.
- Kiểm tra: mở Chat → gọi tool bị deny → phải thấy "blocked by policy".
# Ai dùng lúc nào: team Business+ cần chuẩn chung → admin set org-level đè settings local.

# Verify lớp 2:
# - Chat "liệt kê PRs" (github-mcp allow) → chạy luôn.
# - Chat "chạy rm -rf /tmp/x" (terminal ask) → phải popup hỏi.
# - Gọi tool postgres-prod (deny) → phải báo blocked by policy.
```

### 4.3. Enterprise policy: managed-settings.json, model allowlist, budgets (admin)

**Dành cho admin/org owner.** Section này trả lời: khi settings local chưa đủ (mỗi dev sửa được file của mình), admin chốt policy ở đâu và chốt được những gì.

Chính sách Copilot nằm ở **AI controls tab (enterprise)** và **org settings**. Policy kiểm soát features, agents, models, MCP, CLI và Copilot app. Hai điểm cần nhớ:

- **Copilot app và Copilot CLI chạy theo 2 policy client riêng, độc lập nhau.** Bật ở app không có nghĩa là bật ở CLI.
- Enterprise đặt policy trước, rồi có thể chọn "let organizations decide" cho từng policy.

**`managed-settings.json` là gì?** File cấu hình cấp enterprise, ép mọi client dùng chung một bộ luật. Đời thường: nội quy công ty dán ở lễ tân — không phải mỗi phòng tự viết một bản. Kỹ thuật: áp cho Copilot CLI, VS Code, GitHub Copilot app, Copilot cloud agent và JetBrains IDEs.

| Key trong `managed-settings.json` | Làm gì | Dùng khi nào (ai dùng lúc nào) |
|---|---|---|
| `model` | Ép model mặc định cho cả enterprise | Đưa mọi người về 1 model đã duyệt |
| `autoTier` | Ép tier mặc định của auto model selection (efficiency / balance / intelligence) | Chọn ưu tiên chi phí hay chất lượng |
| `permissions.deny` / `.ask` / `.allow` | Cấm / hỏi trước / cho qua từng thao tác | Ưu tiên: **deny > ask > allow** |
| `permissions.disableBypassPermissionsMode` | Tắt luôn bypass (YOLO) mode | Tránh dev tắt permission cho nhanh |
| `allowedMcpServers` / `deniedMcpServers` | Allowlist MCP server ở mức enterprise | Deny thắng allow; giao (intersection) giữa các nguồn; `[]` rỗng = lockdown |
| `sandbox` | Ép mức sandbox tối thiểu cho command, fs, network, credentials | Vd `sandbox.userPolicy.network.allowedHosts` |
| `telemetry` | Xuất telemetry kiểu OpenTelemetry (endpoint OTLP, protocol, `captureContent`) | Gửi log về hệ thống quan sát của công ty |
| `enabledPlugins` / `extraKnownMarketplaces` / `strictKnownMarketplaces` | Kiểm soát plugin và marketplace | Chỉ marketplace công ty tin cậy |

**Model allowlist (ai được dùng model nào):**

- Enterprise bật/tắt model theo baseline → rồi chọn **Delegate to Organizations** (mặc định), hoặc ra rule model cho từng nhóm.
- Copilot app + CLI có policy model riêng — kiểm tra cả 2 chỗ.
- Ai dùng lúc nào: admin muốn chỉ đúng model được phép dùng → cấu hình ở đây, không dặn qua instructions.

**Budgets (ngân sách AI credits):**

- **1 AI credit = $0.01.** Credit của org gộp chung ở mức billing-entity, không chia cứng từng seat.
- User hết credit → xin tăng budget. Owner/billing manager duyệt, chỉnh hoặc từ chối trong settings.
- Paid usage policy (cho phép chi vượt credit đã kèm) **bật mặc định**. Admin muốn cắt chi phí thì phải tắt đi.
- Code completions và next edit suggestions **không tính credit** — không giới hạn trên mọi plan trả phí.
- Ai dùng lúc nào: admin lo chi phí → đặt budget + tắt paid usage policy.

**Audit log (biết ai đã đổi policy):**

- Tìm bằng `action:copilot`. Giữ **180 ngày**. Nên stream sang SIEM.
- Ghi lại thay đổi plan/settings/policy/license + agent activity trên github.com.
- **Không chứa prompt hay session data của client.** Muốn log phần đó thì tự gắn hook riêng (vd CLI events gửi về logging của bạn).

**Network allowlist (firewall — admin mạng cần mở):**

```text
Network allowlist (các URL Copilot cần ra ngoài):
- https://*.githubcopilot.com/*                                (mọi plan)
- https://*.individual.githubcopilot.com                       (plan cá nhân)
- https://*.business.githubcopilot.com                         (Business)
- https://*.enterprise.githubcopilot.com                       (Enterprise)
- https://github.com/login/*  +  https://collector.github.com/*
- https://copilot-telemetry.githubusercontent.com/telemetry
- https://default.exp-tas.com  +  https://origin-tracker.githubusercontent.com   (dò public code)
- https://*.SUBDOMAIN.ghe.com                                  (data residency GHE.com)
```

---

## 5. Lớp 3: content & language exclusion

Section này trả lời: làm sao để file nhạy cảm không bao giờ lọt vào model — kể cả khi bạn lỡ tay ask.

**Nôm na 1 câu:** Lớp 3 là **bịt mắt Copilot** với file nhạy cảm — file đó không bao giờ được gửi lên model, kể cả bạn năn nỉ.

**Analogie:** Như két sắt có rèm: dù bạn đứng cạnh, camera (Copilot) cũng không nhìn được vào trong.

Content exclusion = file nhạy cảm **không bao giờ** gửi lên model Copilot
(server-side, Copilot không override được). Khác `.gitignore` (chỉ ignore git).

**Ai dùng lúc nào:** admin repo/org làm (cần quyền Settings). Bốn điểm cần biết trước khi bắt tay:

- Content exclusion chỉ có ở **Copilot Business/Enterprise**.
- Path được kế thừa từ org cha.
- Xem được qua REST API.
- Role **Maintain** xem được nhưng không sửa được.

```text
Setup (admin repo/org — ai làm: admin):
github.com → repo → Settings → Copilot → Content exclusion → Add path:
  .env*
  **/*credentials*
  **/*secret*
  certs/**
  db/prod-dump/**
  .vscode/mcp.json        # nếu chứa secrets (nên chuyển sang env — bài 08)

Verify (ai cũng làm được — copy-paste):
1. Mở file .env trong VS Code → góc dưới Copilot icon phải hiện "excluded".
2. Chat: "@workspace đọc file .env giúp anh" → phải từ chối/không thấy nội dung.
3. Nếu vẫn đọc được → exclusion chưa apply (đợi ~30 phút sync) hoặc path sai.
# Kỳ vọng: bước 1 hiện excluded, bước 2 từ chối.
```

Phòng thủ thêm ở máy dev (defense in depth — `.vscode/settings.json`):

```jsonc
// Bổ sung client-side (defense in depth — .vscode/settings.json):
{
  "github.copilot.enable": {
    "*": true,
    "plaintext": false,        // tắt gợi ý cho file text nhạy cảm
    "env": false               // tắt cho .env
  },
  "github.copilot.chat.language": {
    "enabled": ["typescript", "python", "go"],
    "disabled": []             // team chỉ code 3 ngôn ngữ này → gợi ý chuẩn hơn
  }
}
// Ai dùng lúc nào: team chỉ code 3 ngôn ngữ → bật để gợi ý chuẩn, đỡ rác.
```

> Duplication detection (suggestion matching public code) bật ở org-level:
> `Policies → Suggestions matching public code: Block`. Với **Copilot Business,
> mặc định là Blocked** — đổi được trong phần Privacy. Code gợi ý trùng public
> repo lớn → block + hiện references. Chi tiết bài 10.

---

## 6. Lớp 4: pre-commit hooks + linter (copy-paste)

Section này trả lời: chặn lỗi **trước khi commit** bằng gì, và chọn 1 trong 3 recipe (A, B, C) theo stack của team.

**Nôm na 1 câu:** Pre-commit là **máy soi hành lý ở sân bay** — vali (commit) có đồ cấm (lint lỗi, secrets, sửa migration cũ) là giữ lại, khỏi lên máy bay.

**Analogie:** Copilot có thể gói vali ẩu (quên format, dính secret). Máy soi (hook) chạy ngoài Copilot nên Copilot không "nói khéo" cho qua được.

Pre-commit chạy **ngoài model** (git hook local): Copilot có gợi ý sai thì hook
vẫn block. Đây là "hooks" gần nhất của Copilot-verse.

### 6.1. Recipe A — husky + lint-staged (Node, phổ biến nhất)

**Ai dùng lúc nào:** Team Node, muốn auto-format + lint chỉ files staged (nhanh).

```bash
# Cài (1 lần, copy-paste):
pnpm add -D husky lint-staged prettier eslint
pnpm exec husky init
# → tạo .husky/pre-commit
# Verify: ls .husky/pre-commit → phải tồn tại.
```

```bash
# .husky/pre-commit (chmod +x, commit cho team):
#!/bin/sh
. "$(dirname "$0")/_/husky.sh"
pnpm exec lint-staged
```

```json
// package.json — chỉ lint files staged (nhanh, không lint cả repo):
{
  "lint-staged": {
    "*.{ts,tsx,js,jsx}": ["prettier --write", "eslint --max-warnings 0"],
    "*.{py}": ["ruff check --fix", "ruff format"],
    "*.{go}": ["gofmt -w", "go vet ./..."]
  }
}
```

```bash
# Test (copy-paste):
echo "const x=1" > /tmp/bad.ts && cp /tmp/bad.ts ./bad-test.ts
git add bad-test.ts && git commit -m "test hook"  # phải auto-format hoặc fail nếu lint lỗi
git reset HEAD bad-test.ts && rm bad-test.ts      # dọn sau test
# Kỳ vọng: commit auto-fix format hoặc fail rõ lý do. Không chạy gì → hook chưa install.
```

### 6.2. Recipe B — pre-commit framework + secret scan (đa ngôn ngữ)

**Ai dùng lúc nào:** Team đa ngôn ngữ (Node + Python + Go) hoặc cần block secrets trước commit.

```yaml
# .pre-commit-config.yaml (commit cho team):
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.6.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-merge-conflict
      - id: check-added-large-files
        args: ["--maxkb=500"]
  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.24.0
    hooks:
      - id: gitleaks          # block secrets (API keys, tokens) trước commit
  - repo: local
    hooks:
      - id: no-migration-edit
        name: Block editing merged migrations
        entry: bash -c 'git diff --cached --name-only | grep -E "db/migrations/|prisma/migrations/" && echo "BLOCKED: viết migration MỚI, không sửa file đã merge" && exit 1 || exit 0'
        language: system
        always_run: true
```

```bash
# Cài + test (copy-paste):
pip install pre-commit && pre-commit install
echo 'OPENAI_API_KEY="sk-fake123456789"' > fake-secret.txt
git add fake-secret.txt && git commit -m "test"  # phải FAIL ở gitleaks
git reset HEAD fake-secret.txt && rm fake-secret.txt
# Kỳ vọng: commit FAIL ở gitleaks với message rõ. Pass → gitleaks chưa chạy.
```

### 6.3. Recipe C — guard migrations bằng git hook thuần (không dependency)

**Ai dùng lúc nào:** Muốn block push main mà không cài thêm package nào.

```bash
# .husky/pre-push (block push main + force-push — chạy ngoài model):
#!/bin/sh
BRANCH="$(git rev-parse --abbrev-ref HEAD)"
if [ "$BRANCH" = "main" ] || [ "$BRANCH" = "master" ]; then
  echo "BLOCKED: không push trực tiếp main/master. Mở PR từ branch feat/*."
  exit 1
fi
# Block force-push: check push options (an toàn nhất vẫn là branch protection server-side, mục 7)
exit 0
# Verify: git checkout -b test-block && git push origin main --dry-run → đọc message.
```

---

## 7. Lớp 5 – 6: branch protection + secret scanning + review gate

Section này là **phần server** — 3 lớp dev không lách được. 7.1 khóa nhánh, 7.2 chặn secret lúc push, 7.3 bắt Copilot review trước khi merge.

### 7.1. Lớp 5 — Branch protection + required checks (server-side, không lách được)

Section này trả lời: làm sao chặn push thẳng vào `main`, kể cả admin. Hai cách: lệnh `gh` (một lần là xong) hoặc Rulesets UI (dễ nhìn, dễ review).

**Nôm na 1 câu:** Lớp 5 là **khóa cổng làng + bắt có giấy thông hành** — muốn vào làng (main) phải có PR + CI xanh + 1 người duyệt, admin cũng không leo rào được.

```bash
# Setup bằng gh CLI (copy-paste, chạy 1 lần/repo — cần admin):
gh api repos/{owner}/{repo}/branches/main/protection -X PUT \
  -H "Accept: application/vnd.github+json" \
  -f required_status_checks[strict]=true \
  -f required_status_checks[contexts][]="lint" \
  -f required_status_checks[contexts][]="test" \
  -f enforce_admins=true \
  -f required_pull_request_reviews[required_approving_review_count]=1 \
  -f required_pull_request_reviews[dismiss_stale_reviews]=true \
  -f restrictions=null \
  -f allow_force_pushes=false \
  -f allow_deletions=false

# Verify:
gh api repos/{owner}/{repo}/branches/main/protection --jq '{enforce_admins, allow_force_pushes}'
# Kỳ vọng: enforce_admins.enabled=true, allow_force_pushes.enabled=false
# Sai → thay {owner}/{repo} đúng, check quyền admin.
```

**Ruleset là gì?** Gói quy tắc GitHub áp cho một nhóm nhánh. Đời thường: quy định khu vực dân cư. Kỹ thuật: GitHub Settings → Rules → Rulesets.

```text
Ruleset UI (khuyên dùng 2026, github.com → Settings → Rules → Rulesets):
- Target: branch `main` (+ `release/*` nếu có).
- Rules: Restrict deletions ✓, Block force pushes ✓,
  Require PR (1 approval + dismiss stale) ✓,
  Require status checks (lint, test) ✓,
  Require Copilot code review (mục 7.3) ✓.
# Ai dùng lúc nào: team nghiêm túc → dùng Rulesets UI (dễ review) thay CLI 1 lần.
```

### 7.2. Lớp 6a — Secret scanning + push protection

Section này trả lời: làm sao chặn secret **ngay lúc push**, kể cả khi Copilot là người tạo commit.

**Secret scanning** = quét repo tìm key/token đã lọt. **Push protection** = chặn push ngay khi nó chứa secret. Đời thường: máy soi phát hiện dao trong vali ngay lúc bạn đẩy vali qua băng chuyền — giữ lại luôn, khỏi lên máy bay.

```text
Bật (admin, github.com → Settings → Code security):
- Secret scanning: ON (quét lịch sử repo tìm secrets đã lọt).
- Push protection: ON (block push chứa secrets NGAY lúc push — kể cả Copilot tạo commit).
- Validity checks: ON (check secret còn sống không).

Test push protection (copy-paste, secret giả):
echo 'GITHUB_TOKEN="ghp_fake1234567890123456789012345678901234"' > /tmp/leak-test.txt
cp /tmp/leak-test.txt ./leak-test.txt && git add leak-test.txt
git commit -m "test push protection" && git push origin feat/test-push-protection
# Kỳ vọng: push bị BLOCK với message "Push protection". Dọn branch sau test.
git reset HEAD~1 && rm leak-test.txt && git push origin --delete feat/test-push-protection 2>/dev/null; true
```

### 7.3. Lớp 6b — Copilot code review as gate (required check)

Section này trả lời: biến Copilot review thành **cổng bắt buộc** — PR không qua cổng thì không merge.

**Nôm na:** Bắt mọi xe qua trạm kiểm định (Copilot review) trước khi ra đường (merge) — xe có lỗi CRITICAL là giữ lại.

3 fact cần biết trước khi cấu hình:

- **Loại review mặc định là "Comment"** — comment, KHÔNG tính là approval. Muốn Copilot approve thì phải cấu hình riêng.
- **Effort mặc định là "Balanced"** (đổi từ 28/09/2026). `Lite` nhanh/rẻ hơn, `Balanced` suy luận sâu hơn cho logic phức tạp và security.
- **Chi phí ước tính mỗi review:** Lite khoảng **$0.05–$1**, Balanced khoảng **$0.25–$5** AI credits (chưa tính phút Actions).
- Từ 02/10/2026 có **API (REST + GraphQL)** để request review và set effort — chạy được từ CI.

```text
Setup (github.com → repo → Settings → Rules → Rulesets → Add):
- Require Copilot code review: ON (auto-request review cho mọi PR).
- Hoặc CLI: gh api repos/{owner}/{repo}/rulesets (ruleset JSON, xem docs Rulesets API).

Luồng PR chuẩn team:
1. Push branch feat/* → mở PR (draft nếu WIP).
2. Copilot review tự chạy → findings (critical/high phải fix).
3. CI lint + test xanh + 1 human approval + Copilot review pass → merge.
4. Merge xong → xóa branch (auto-delete head branches: ON).

Tune precision (reviewer quá khắt → dặn trong .github/muse-instructions.md):
"Code review: chỉ flag lỗi thực sự (bug, security, perf regression).
Đừng flag style đã có prettier/loại, đừng over-engineer."
# Verify: mở PR test cố ý có SQL injection → Copilot review phải flag.
```

Muốn cứng hơn "chỉ mong Copilot review" → dựng check fail cả PR khi có CRITICAL:

```yaml
# .github/workflows/copilot-gate.yml — fail PR nếu Copilot review có CRITICAL (khung):
name: copilot-gate
on:
  pull_request: { types: [opened, synchronize, reopened] }
permissions: { contents: read, pull-requests: read }
jobs:
  gate:
    runs-on: ubuntu-latest
    timeout-minutes: 10
    steps:
      - uses: actions/checkout@v4
        with: { fetch-depth: 0 }
      - name: Check Copilot review findings
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: |
          # Lấy reviews của copilot trên PR hiện tại, fail nếu có "critical":
          gh pr view "${{ github.event.pull_request.number }}" \
            --json reviews --jq '.reviews[] | select(.author.login=="github-copilot") | .body' \
            > copilot-reviews.txt || true
          if grep -qi "critical" copilot-reviews.txt; then
            echo "FAIL: Copilot review có CRITICAL — fix trước khi merge."
            exit 1
          fi
          echo "PASS: không có CRITICAL."
# Verify: PR có CRITICAL → check này đỏ. PR sạch → xanh.
```

---

## 8. Hiểu nhầm thường gặp

Tra cứu nhanh, không cần đọc từ đầu. Cột trái là câu bạn hay nghe, cột phải là điều thật sự xảy ra.

| Hiểu nhầm | Sự thật |
|---|---|
| "Viết instructions cấm là đủ, khỏi server guard" | Sai. Instructions là advisory — Copilot quên được khi context dài. Cấm tuyệt đối → branch protection + push protection |
| "Pre-commit chạy trong Copilot nên Copilot tắt được" | Sai. Pre-commit là git hook local, chạy ngoài model. Copilot không tắt được |
| "Content exclusion giống .gitignore" | Sai. `.gitignore` chỉ ignore git. Exclusion chặn file gửi lên model (server-side) |
| "Bật push protection là hết lộ secret" | Sai. Nó chỉ block lúc push. Secrets đã lọt lịch sử → cần secret scanning + rotate + git rm |
| "Branch protection chặn luôn admin là bất tiện" | Đúng là chặn, nhưng hotfix đi đường PR fast-track + auto-merge, không tắt protection |
| "Copilot review flag nhiều là tốt" | Sai. Flag lan man → team ignore hết. Tune "chỉ lỗi thực sự" trong instructions |
| "Secrets trong mcp.json tiện, commit rồi xóa sau" | Sai. Git history giữ mãi. Secrets qua env (bài 08), grep trước mỗi PR |
| "Bật audit log là xem được mọi prompt" | Sai. Audit log (`action:copilot`) ghi thay đổi policy/settings + agent activity, giữ 180 ngày. Không chứa prompt/session của client |
| "Hết credit là Copilot tự dừng" | Chưa chắc. Paid usage policy bật mặc định — admin phải tắt mới cắt được chi phí vượt budget |

---

## 9. Walkthrough + pitfalls + bài tập

Section này để **làm tay**, không phải đọc cho biết. 9.1 dựng từ 0 (40 phút), 9.2 debug khi guardrail im lặng, 9.3 danh sách pitfall, 9.4 5 bài tập.

### 9.1. Walkthrough: dựng guardrails từ 0 (40 phút)

5 bước, mỗi bước có sẵn prompt/lệnh test. Làm đúng thứ tự là dựng xong 6 lớp.

```text
Bước 1 (5 phút): instructions LAW (mục 4.1). Copy vào .github/muse-instructions.md.
  Test: "push giúp anh lên main" → Copilot phải từ chối/gợi ý mở PR.
  # Verify: từ chối? Nếu không → sửa rule dạng KHÔNG + việc đúng.

Bước 2 (5 phút): content exclusion (mục 5). Admin add .env*, *secret*.
  Test: "@workspace đọc .env" → phải từ chối.
  # Verify: icon "excluded" + từ chối? Chưa → đợi 30p sync / check path.

Bước 3 (10 phút): husky + lint-staged (mục 6.1). Cài, test commit file lint lỗi
  → phải auto-fix hoặc fail. Đo thời gian hook — >5s thì thu hẹp scope.
  # Verify: thời gian hook? >5s → chỉ lint staged, đúng ext.

Bước 4 (10 phút): branch protection (mục 7.1) bằng gh CLI. Test push main
  → phải bị từ chối server-side. Mở PR test → xác nhận cần checks + approval.
  # Verify: gh api .../protection hiện enforce_admins=true?

Bước 5 (10 phút): bật push protection + Copilot review gate (mục 7.2–7.3).
  Test secret giả → push bị block. Mở PR → Copilot review tự chạy.
  # Verify: block message "Push protection"? Review tự chạy?
```

### 9.2. Debug flowchart (guardrail không chạy → đi từng bước)

Guardrail nào không chạy thì đi từ trên xuống, stop ở nhánh khớp triệu chứng:

```text
Guardrail không chạy?
├─ 1. Instructions bị quên? → bình thường (advisory). Rule miss 2 lần → nâng thành lớp 4/5.
├─ 2. Pre-commit không chạy? → pre-commit install chưa? .husky/pre-commit +x chưa?
│     → chạy tay: .husky/pre-commit, xem exit code.
├─ 3. Branch protection không chặn? → ruleset apply đúng branch? enforce_admins ON?
│     → gh api .../protection kiểm tra (mục 7.1).
├─ 4. Push protection không block? → bật ở repo hay org? Secret giả có đúng format
│     provider (ghp_/sk-) không? Format lạ → không nhận diện.
├─ 5. Copilot review không chạy? → bật auto-request chưa? PR draft? (draft có thể skip
│     tùy config) → chuyển Ready for review rồi check lại.
└─ 6. Muốn nới (cho qua) nhưng vẫn block? → server-side deny thắng mọi instructions.
    Sửa ruleset gốc, đừng dặn Copilot "cứ merge đi".
```

### 9.3. Pitfalls + fix

Cột "Vì sao" giải thích nguyên nhân, cột "Fix" là việc cần làm ngay.

| Pitfall | Vì sao | Fix |
|---|---|---|
| Tin instructions thay server guard | Advisory quên được | Critical → branch protection + push protection |
| Lint hook chậm 15s mỗi commit | Lint cả repo | `lint-staged`: chỉ files staged, đúng ext |
| Husky không chạy trên máy teammate | Quên `husky install` / clone mất hook | `pnpm prepare` script chạy `husky install`; CI check hooks tồn tại |
| Push protection block secret giả test | Format giả quá giống thật | Test trên branch `feat/*` rồi dọn, đừng test trên main |
| Branch protection chặn cả admin hotfix | `enforce_admins=true` | Hotfix → PR fast-track + auto-merge, không tắt protection |
| Copilot review flag mọi thứ → team ignore | Không tune prompt review | Dặn "chỉ lỗi thực sự" trong instructions + dismiss stale reviews |
| Secrets trong `.vscode/mcp.json` committed | Tiện tay paste | Secrets qua env (bài 08), grep repo trước khi push |

### 9.4. Bài tập thực hành

5 bài, tổng ~80 phút. Làm hết là bạn có đủ 6 lớp guardrails chạy thật.

**Bài 1 (15 phút):** Cài recipe A (husky + lint-staged). Commit 1 file cố ý sai
lint, xem hook auto-fix. Đo thời gian — >5s thì thu hẹp scope.

**Bài 2 (15 phút):** Bật content exclusion cho `.env*`. Test `@workspace đọc .env`
→ ghi kết quả (từ chối hay lọt?). Check icon "excluded" trong VS Code.

**Bài 3 (15 phút):** Setup branch protection bằng `gh api` (mục 7.1). Test push
main → ghi message server trả về. Mở PR → xác nhận checks bắt buộc hiện.

**Bài 4 (15 phút):** Test push protection bằng secret giả (mục 7.2). Ghi lại
message block. Dọn branch test.

**Bài 5 (20 phút):** Bật Copilot review gate cho 1 repo test. Mở PR cố ý có bug
(VD SQL injection). Đếm findings Copilot bắt được. Tune instructions tới khi precision cao.

---

## 10. Link chéo

Đọc tiếp khi bạn cần đào sâu phần nào của 6 lớp.

- **Bài 03 — Instructions, Memory, Rules:** advisory vs law — khi nào nâng rule thành guardrail.
- **Bài 05 — Prompt files:** prompt review/test tái dùng — gắn vào review gate.
- **Bài 06 — Custom agents:** khóa `tools` agent + MCP allowlist (defense in depth).
- **Bài 08 — MCP:** secrets MCP qua env, prune servers — đừng để server lạ lách policy.
- **Bài 10 — Modes & permissions:** tool approval (allow/ask/deny) + plan Individual/Business/Enterprise.
- **Bài 11 — Worktrees & checkpoints:** branch `copilot/*` + PR flow cho coding agent.
- **Bài 12 — SDK & CI:** required checks (lint/test/review) chạy trong Actions.

---
*(Hết bài 07 — bản mở rộng. Tiếp theo: Bài 08 — MCP kết nối công cụ ngoài.)*
