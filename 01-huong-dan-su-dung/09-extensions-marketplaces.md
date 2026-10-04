# 09 — Extensions & Marketplaces (Đóng Gói Cho Team)

> Bài 09 của series. Đọc xong bạn phân biệt được Copilot Extensions vs VS Code
> extensions, cài đúng cách, set org policy allow/block + version pin cho team.
> Thời gian: ~35 phút.

## Mục lục

1. [Vì sao extensions? (why)](#1-vì-sao-extensions-why)
2. [2 loại extensions — đừng nhầm](#2-2-loại-extensions--đừng-nhầm)
3. [Copilot Extensions: GitHub Apps expose skills cho @-mention](#3-copilot-extensions-github-apps-expose-skills-cho--mention)
4. [VS Code extensions: Copilot-related packs](#4-vs-code-extensions-copilot-related-packs)
5. [Cài + pin version (copy-paste)](#5-cài--pin-version-copy-paste)
6. [Org-level extension policy: allow/block](#6-org-level-extension-policy-allowblock)
7. [Walkthrough + pitfalls + bài tập](#7-walkthrough--pitfalls--bài-tập)
8. [Link chéo](#8-link-chéo)

---

## 1. Vì sao extensions? (why)

`.github/` commit theo repo giải quyết 1 repo. Team 10 repos + onboarding người
mới mỗi tháng → mỗi repo setup lại instructions/agents/MCP = drift. Extensions
giải quyết cross-repo:

```text
Không extensions: teammate mới → clone 5 repos → mỗi repo setup MCP tay +
  hỏi "prompt review ở đâu?" + cài lẻ từng VS Code extension.
Có extensions:   teammate mới → cài 1 extension pack org → 5 repos đều có
  @-mention participants, prompt files, MCP servers kèm.
Update:          bump extension version 1 nơi → cả team sync.
```

Ngưỡng đóng gói extension: cùng 1 bundle dùng ở ≥3 repos HOẶC onboarding
≥1 người/tháng. Dưới ngưỡng → commit `.github/` thẳng rẻ hơn.

---

## 2. 2 loại extensions — đừng nhầm

| Loại | Là gì | Cài ở đâu | Ví dụ |
|---|---|---|---|
| **Copilot Extensions** | GitHub Apps expose skills/tools cho Copilot Chat qua `@-mention` | github.com → Org/Repo → Installed Apps + VS Code Chat `@` | `@linear`, `@sentry`, `@launchdarkly` |
| **VS Code extensions** | Plugins VS Code (có thể bundle Copilot participants, MCP, snippets) | VS Code Marketplace / `.vscode/extensions.json` | Copilot pack, ESLint, Prettier, GitLens |

```text
Quan hệ:
- Copilot Extension (@linear) → gọi từ Chat bằng @-mention, chạy trên GitHub infra.
- VS Code extension (pack) → cài local, có thể TỰ THÊM MCP servers + participants.
- 1 VS Code extension có thể wrap 1 Copilot Extension (cài 1 được 2).

Cây quyết định:
Cần gọi SaaS (Linear/Jira/Sentry) từ Chat? → Copilot Extension @-mention.
Cần tooling editor (lint, format, snippets, MCP local)? → VS Code extension.
Share chuẩn team cross-repo? → cả 2 + org policy (mục 6).
```

---

## 3. Copilot Extensions: GitHub Apps expose skills cho @-mention

Copilot Extension = GitHub App đăng ký với Copilot → hiện thành `@-mention`
trong Chat (VS Code, github.com, mobile).

### 3.1. Cài + dùng (copy-paste flow)

```text
Bước 1: github.com → Marketplace → tìm extension (vd "Sentry", "Linear").
Bước 2: Install → chọn Org/Repos được phép (đừng chọn All repos nếu chưa tin).
Bước 3: VS Code Chat → gõ "@" → phải thấy @sentry/@linear mới.
Bước 4: Test: "@sentry list unresolved issues của project X" / "@linear tạo task Y".
Bước 5: Không hợp → github.com → Settings → Applications → Uninstall/Restrict.
```

```bash
# Kiểm tra extensions đã cài cho org (cần admin, copy-paste):
gh api orgs/{org}/installations --jq '.installations[] | {app: .app.slug, repo_selection}'
# Liệt kê repos được phép:
gh api orgs/{org}/installations/{id}/repositories --jq '.repositories[] | .full_name'
```

### 3.2. 5 extensions team hay dùng (2026)

| Extension | `@-mention` | Để làm gì | Khi prune |
|---|---|---|---|
| GitHub (built-in) | `@workspace` | Code search, PR, issues | Không bao giờ |
| Linear/Jira | `@linear` | Tạo/xem tasks từ Chat | Team không dùng tracker đó |
| Sentry/Datadog | `@sentry` | Tra lỗi prod, stack trace | Không có observability SaaS |
| LaunchDarkly/PostHog | `@flags` | Check feature flags | Không dùng flags |
| Notion/Confluence | `@docs` | Tra docs team | Docs đã local |

```text
Quy tắc: ≤5 Copilot Extensions. Quá → "@" list dài, Copilot chọn sai participant.
Mỗi extension sâu nên có 1 prompt file kèm (vd .github/prompts/triage-sentry.prompt.md
dạy format "lỗi → root cause → fix" để output đồng đều).
```

### 3.3. Viết Copilot Extension đơn giản (khi nào + khung)

```text
Khi nào viết extension riêng (thay vì dùng sẵn)?
- Internal API/docs chỉ org bạn có (vd tra runbook nội bộ, deploy staging riêng).
- Dưới ngưỡng → prompt file + MCP http server là đủ (bài 05/08). Viết extension
  là GitHub App (manifest, OAuth, hosting) — overhead lớn, chỉ đáng khi ≥3 teams dùng.

Khung (high-level, chi tiết xem docs GitHub "Building Copilot Extensions"):
1. Tạo GitHub App → enable "Copilot Chat" permission → định nghĩa skills (name,
   description, input schema — giống agent frontmatter bài 06).
2. Host endpoint (vd https://copilot-ext.acme.example) nhận Chat requests.
3. Install vào org test → "@acme ..." → verify → publish private marketplace org.
4. Secrets (APP_PRIVATE_KEY, WEBHOOK_SECRET) qua hosting env, KHÔNG commit.
```

---

## 4. VS Code extensions: Copilot-related packs

### 4.1. Pack chuẩn team (copy-paste)

```json
// .vscode/extensions.json — VS Code tự gợi ý cài khi mở repo (commit cho team):
{
  "recommendations": [
    "github.copilot",
    "github.copilot-chat",
    "dbaeumer.vscode-eslint",
    "esbenp.prettier-vscode",
    "eamodio.gitlens",
    "ms-playwright.playwright-vscode",
    "github.vscode-github-actions"
  ],
  "unwantedRecommendations": [
    "some.noisy-theme",
    "some.conflicting-formatter"
  ]
}
```

```jsonc
// .vscode/settings.json — settings đi kèm pack (format/lint on save):
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": "explicit"
  },
  "github.copilot.enable": { "*": true },
  "github.copilot.chat.toolAutoRun": "ask"
}
```

```bash
# Cài pack từ CLI (copy-paste, onboarding máy mới):
cat .vscode/extensions.json | jq -r '.recommendations[]' | while read -r ext; do
  code --install-extension "$ext"
done
code --list-extensions | grep -i "copilot\|eslint\|prettier"  # verify
```

### 4.2. Khi nào extension vs dotfiles?

| Tình huống | Chọn | Ví dụ |
|---|---|---|
| 1–2 prompt files, 1 repo | `.github/prompts/` commit thẳng | Prompt review của 1 project |
| Tooling editor (lint/format/git) | VS Code extension pack | ESLint + Prettier + GitLens |
| Gọi SaaS từ Chat | Copilot Extension `@-mention` | `@sentry`, `@linear` |
| Chuẩn cross-repo (instructions+agents+MCP) | Extension pack + repo template | Org template repo + pack |
| Preferences cá nhân | Personal extensions (không commit) | Theme, keymap riêng bạn |

---

## 5. Cài + pin version (copy-paste)

### 5.1. Pin version (tránh breaking giữa sprint)

```bash
# Cài version cụ thể (không lấy latest mù):
code --install-extension github.copilot-chat@0.26.0
code --install-extension dbaeumer.vscode-eslint@3.0.0

# Xem versions có sẵn:
code --list-extensions --show-versions | grep -i "copilot\|eslint"

# Update có kiểm soát (cuối sprint, không giữa sprint):
code --list-extensions | xargs -I{} code --install-extension {} --force
# → test 1 ngày trên repo thử trước khi announce team.
```

```text
Quy ước team (dán vào wiki):
- Pin versions trong wiki table (extension → version → ngày verify).
- Update cuối sprint. Breaking change (hooks/behavior đổi) → giữ version cũ
  cho repos production, note lý do.
- Teammate mới: cài theo table, không cài latest mù.
```

### 5.2. Repo template (share chuẩn team — thực tế hơn viết extension mới)

```text
acme-copilot-template/           # repo template org (Template repository: ON)
  .github/muse-instructions.md
  .github/instructions/*.instructions.md
  .github/agents/*.agent.md
  .github/prompts/*.prompt.md
  .vscode/{mcp.json,settings.json,extensions.json}
  .husky/pre-commit
  README.md (onboarding 10 phút)

Teammate: New repo → "Use template" → có ngay chuẩn team.
Update chuẩn: PR vào template → announce → các repos cherry-pick (hoặc script sync).
```

```bash
# Tạo repo từ template (copy-paste):
gh repo create acme/new-service --template acme/acme-copilot-template --private --clone
cd new-service && cat .vscode/extensions.json  # verify pack đi kèm
```

---

## 6. Org-level extension policy: allow/block

```text
Admin (github.com → Org Settings → Copilot → Policies → Extensions):
- Allowed extensions: github, linear, sentry (list rõ, còn lại block).
- VS Code marketplace: restrict (chỉ extensions đã review) — Enterprise.
- Audit log: ai cài extension nào, khi nào (review hàng tháng).

Admin (VS Code marketplace org):
- Private marketplace/allowlist: chỉ pack org + extensions đã vet.
- Block categories: themes lạ không sao, block extensions chạy shell/network chưa vet.
```

```bash
# Audit extensions team đang dùng (mỗi tháng, copy-paste):
code --list-extensions --show-versions > /tmp/exts.txt
cat /tmp/exts.txt
# So với allowlist wiki: cái nào ngoài list? Hỏi owner: còn dùng không?
# Ngoài list + không ai nhận → uninstall: code --uninstall-extension <id>
```

| Checklist review extension lạ (trước khi cài) | Vì sao |
|---|---|
| Đọc permissions (chạy shell? đọc files? gọi mạng?) | Extension chạy với quyền bạn |
| Nguồn: official / org / cá nhân lạ? | Lạ → test repo thử trước |
| MCP servers kèm: URL lạ? secrets qua env? | Tránh exfiltrate (bài 08) |
| Version pinned? CHANGELOG có breaking? | Tránh gãy giữa sprint |
| 2 extensions cùng chức năng? | Chọn 1, gỡ kia (đỡ conflict) |

---

## 7. Walkthrough + pitfalls + bài tập

### 7.1. Walkthrough: setup extensions chuẩn (25 phút)

```text
Bước 1 (5 phút): commit .vscode/extensions.json + settings.json (mục 4.1).
  Teammate mở repo → VS Code gợi ý cài → bấm Install All.

Bước 2 (10 phút): cài 1 Copilot Extension (@linear hoặc @sentry, mục 3.1).
  Test @-mention 2 prompts. Ghi output có đúng format team?

Bước 3 (5 phút): pin versions (mục 5.1). Ghi table wiki: extension → version.

Bước 4 (5 phút): admin set allowlist org (mục 6). Verify extension lạ bị block.
```

### 7.2. Pitfalls + fix

| Pitfall | Vì sao | Fix |
|---|---|---|
| Cài extension lạ, nó đọc `.env` | Không review permissions | Checklist mục 6; content exclusion vẫn lưng (bài 07) |
| 2 formatters conflict (Prettier vs Beautify) | Cài pack + extension lạ | `unwantedRecommendations` + `defaultFormatter` rõ ràng |
| Update extension giữa sprint gãy workflow | Latest mù | Pin version, update cuối sprint |
| 10 `@-mentions` → Copilot chọn sai | Tham extensions | ≤5, prune định kỳ |
| Extension pack phình (30 extensions) → VS Code chậm | Bundle quá nhiều | Tách pack core (7–10) + optional theo role (frontend/backend) |
| Repo template lỗi thời (6 tháng không sync) | Không lịch sync | Cuối sprint: PR sync template → repos (hoặc script) |

### 7.3. Bài tập thực hành

**Bài 1 (15 phút):** Commit `.vscode/extensions.json` (mục 4.1) vào 1 repo.
Clone fresh trên máy khác (hoặc profile mới) → verify VS Code gợi ý cài.

**Bài 2 (20 phút):** Cài 1 Copilot Extension (`@linear`/`@sentry`/tương đương).
Test 3 prompts. Viết 1 prompt file kèm để output đúng format team.

**Bài 3 (15 phút):** Pin versions (mục 5.1). Lập table wiki. Thử update 1 extension
lên latest trên repo thử → có breaking không? Ghi lại.

**Bài 4 (15 phút):** Audit extensions team (`code --list-extensions`).
So với allowlist — cái nào thừa? Gỡ 1 cái và ghi khác biệt startup time.

**Bài 5 (20 phút):** Tạo repo từ template (mục 5.2) hoặc dựng template tối thiểu
(instructions + agents + mcp.json + extensions.json). Onboard 1 teammate thử.

---

## 8. Link chéo

- **Bài 03 — Instructions:** instructions đi kèm extensions (format output `@sentry`).
- **Bài 05 — Prompt files:** prompt kèm extension (review/triage) cho output đồng đều.
- **Bài 06 — Custom agents:** agents gọi `@-mention` extensions trong quy trình.
- **Bài 07 — Guardrails:** allowlist MCP/extensions + content exclusion (defense in depth).
- **Bài 08 — MCP:** extension bundle MCP — cài 1 được 2, review URL/secrets.
- **Bài 10 — Modes & permissions:** tool approval cho extension tools + plan differences.
- **Bài 12 — SDK & CI:** extensions trong Actions runners (cài CLI extensions cho CI).

---
*(Hết bài 09 — tổng ~400 dòng. Tiếp theo: Bài 10 — Modes, permissions & availability.)*
