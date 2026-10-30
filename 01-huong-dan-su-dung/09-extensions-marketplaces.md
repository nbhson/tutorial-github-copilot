# 09 — Extensions & Marketplaces (Đóng Gói Cho Team)

> **Dành cho:** tech lead / admin đóng gói chuẩn tooling cho team, kèm dev mới cài extension lần đầu (bài 09 của series).
> **Vấn đề:** mỗi dev cài lẻ, mỗi repo một kiểu setup prompts / MCP / extension → teammate mới mất cả buổi. Extension lạ thì chạy với quyền của bạn.
> **Đọc xong:** phân biệt Copilot Extensions vs VS Code extensions, cài + pin version copy-paste, set org policy allow/block + review extension lạ cho team.

## Mục tiêu bài học

- Phân biệt **2 loại extension**: Copilot Extensions (GitHub Apps gọi qua `@`) và VS Code extensions (đồ nghề editor).
- Biết **ngưỡng đóng gói**: khi nào commit `.github/` thẳng, khi nào dựng extension pack / repo template.
- Cài được extension pack, **pin version** và cập nhật có kiểm soát.
- Đặt **org policy allow/block** + checklist review extension lạ trước khi cho vào org.

---

## 1. Vì sao extensions? + ngưỡng đóng gói

**Định nghĩa 1 câu:** File `.github/` lẻ chỉ giải quyết 1 repo; extension/pack là **thùng combo đóng sẵn** — nhiều repos và người mới dùng chung 1 chuẩn, update 1 nơi là cả team sync.

```text
 Không extensions: teammate mới → clone 5 repos → mỗi repo setup MCP tay +
   hỏi "prompt review ở đâu?" + cài lẻ từng VS Code extension.
 Có extensions:   teammate mới → cài 1 extension pack org → 5 repos đều có
   @-mention participants, prompt files, MCP servers kèm.
 Update:          bump extension version 1 nơi → cả team sync.
 # Verify: đếm repos team bạn. ≥3 repos cùng checklist → đáng đóng extension (mục 5).
```

**Ngưỡng đóng gói:** cùng 1 bundle dùng ở **≥3 repos HOẶC** onboarding **≥1 người/tháng**. Dưới ngưỡng → commit `.github/` thẳng rẻ hơn (bài 05/06). Đóng gói quá sớm = tự tạo thêm artifact phải version + publish + sync; không đóng gói khi đã 10 repos = teammate cài tay 10 nơi, mỗi repo trôi một kiểu.

---

## 2. 2 loại extensions — đừng nhầm

Có 2 chợ khác nhau: **chợ GitHub** bán "người phục vụ biết gọi SaaS" (`@linear`, `@sentry`), **chợ VS Code** bán "đồ nghề cho editor" (lint, format, MCP local).

| Loại | Nôm na | Cài ở đâu | Ví dụ | Khi nào dùng |
|---|---|---|---|---|
| **Copilot Extensions** | GitHub App đăng ký quầy riêng trong Chat | github.com Marketplace → Installed Apps + Chat `@` | `@linear tạo task Y`, `@sentry list issues` | Cần gọi Linear/Jira/Sentry từ Chat |
| **VS Code extensions** | Đồ nghề gắn vào editor | VS Code Marketplace / `.vscode/extensions.json` | Copilot pack, ESLint, Prettier, GitLens | Cần lint/format/snippets/MCP local |

```text
 Quan hệ giữa 2 loại:
 - Copilot Extension (@linear) → gọi từ Chat bằng @-mention, chạy trên GitHub infra.
 - VS Code extension (pack) → cài local, có thể TỰ THÊM MCP servers + participants.
 - 1 VS Code extension có thể wrap 1 Copilot Extension (cài 1 được 2).

 Cây quyết định:
 Cần gọi SaaS (Linear/Jira/Sentry) từ Chat? → Copilot Extension @-mention.
 Cần tooling editor (lint, format, snippets, MCP local)? → VS Code extension.
 Share chuẩn team cross-repo? → cả 2 + org policy (mục 6).
 # Verify: gõ @ trong Chat → thấy @-mentions nào? Thiếu → chưa cài Copilot Extension.
```

> Copilot Extensions đã **GA từ 19/02/2025**, dùng auth native third-party tokens, có trên VS Code, github.com, Visual Studio, JetBrains và GitHub Mobile. Chi tiết đầy đủ: [`../../copilot-extensions-ai-powered/README.md`](../../copilot-extensions-ai-powered/README.md) (EN).

---

## 3. Copilot Extensions: cài + dùng

**Nôm na:** Copilot Extension là GitHub App đăng ký quầy riêng trong Chat — gõ `@tên-quầy` là gọi đúng nhân viên quầy đó.

```text
 Bước 1: github.com → Marketplace → tìm extension (vd "Sentry", "Linear").
 Bước 2: Install → chọn Org/Repos được phép (đừng chọn All repos nếu chưa tin).
 Bước 3: VS Code Chat → gõ "@" → phải thấy @sentry/@linear mới.
 Bước 4: Test: "@sentry list unresolved issues của project X" / "@linear tạo task Y".
 Bước 5: Không hợp → github.com → Settings → Applications → Uninstall/Restrict.
 # Verify: bước 3 phải thấy @-mention mới. Không thấy → reload window + check repo được phép.
```

```bash
# Kiểm tra extensions đã cài cho org (cần admin):
gh api orgs/{org}/installations --jq '.installations[] | {app: .app.slug, repo_selection}'
gh api orgs/{org}/installations/{id}/repositories --jq '.repositories[] | .full_name'
# Verify: app.slug có tên extension? repo_selection gồm repo bạn? Không → admin chưa cấp.
```

**5 extensions team hay dùng (2026):**

| Extension | `@-mention` | Để làm gì | Khi prune |
|---|---|---|---|
| GitHub (built-in) | `@workspace` | Hỏi code, PR, issues trong repo | Không bao giờ |
| Linear/Jira | `@linear` | Tạo/xem tasks từ Chat | Team không dùng tracker đó |
| Sentry/Datadog | `@sentry` | Tra lỗi prod + stack trace | Không có observability SaaS |
| LaunchDarkly/PostHog | `@flags` | Check feature flags | Không dùng flags |
| Notion/Confluence | `@docs` | Tra docs team | Docs đã local hết |

```text
 Quy tắc: ≤5 Copilot Extensions. Quá → "@" list dài, Copilot chọn sai participant.
 Mỗi extension sâu nên có 1 prompt file kèm (vd .github/prompts/triage-sentry.prompt.md
 dạy format "lỗi → root cause → fix" để output đồng đều — bài 05).
 # Verify: đếm @-mentions team đang có. >5 → prune 1 cái ít dùng nhất.
```

**Khi nào tự viết Copilot Extension riêng:** chỉ khi nhà bạn có món độc quyền (internal API/runbook) mà chợ chưa bán, và ≥3 teams dùng. Dưới ngưỡng → prompt file + MCP http server là đủ (bài 05/08) — viết extension là GitHub App (manifest, OAuth, hosting), overhead lớn. Khung high-level: tạo GitHub App → enable Copilot permission → định nghĩa skills → host endpoint → install org test → publish private marketplace. Secrets (APP_PRIVATE_KEY, WEBHOOK_SECRET) qua hosting env, KHÔNG commit.

---

## 4. VS Code extensions: pack chuẩn team

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
  "editor.codeActionsOnSave": { "source.fixAll.eslint": "explicit" },
  "github.copilot.enable": { "*": true },
  "github.copilot.chat.toolAutoRun": "ask"
}
```

```bash
# Cài pack từ CLI (onboarding máy mới):
cat .vscode/extensions.json | jq -r '.recommendations[]' | while read -r ext; do
  code --install-extension "$ext"
done
code --list-extensions | grep -i "copilot\|eslint\|prettier"  # verify
# Kỳ vọng: list hiện đủ copilot + eslint + prettier. Thiếu → cài tay ID đó.
```

**Khi nào extension vs dotfiles:** 1–2 prompt files, 1 repo → commit `.github/` thẳng. Tooling editor (lint/format/git) → VS Code pack. Gọi SaaS từ Chat → `@-mention`. Chuẩn cross-repo → org template repo + pack (mục 5.2). Preferences cá nhân (theme, keymap) → không commit.

---

## 5. Cài + pin version + repo template

### 5.1. Pin version (tránh breaking giữa sprint)

```bash
# Cài version cụ thể (không lấy latest mù):
code --install-extension github.copilot-chat@0.26.0
code --install-extension dbaeumer.vscode-eslint@3.0.0

# Xem versions đã cài:
code --list-extensions --show-versions | grep -i "copilot\|eslint"

# Update có kiểm soát (cuối sprint, không giữa sprint):
code --list-extensions | xargs -I{} code --install-extension {} --force
# → test 1 ngày trên repo thử trước khi announce team.
```

```text
 Quy ước team (wiki — ai giữ: tech lead):
 - Pin versions trong wiki table (extension → version → ngày verify).
 - Update cuối sprint. Breaking change → giữ version cũ cho repos production, note lý do.
 - Teammate mới: cài theo table, không cài latest mù.
 # Verify: version local khớp table?
```

### 5.2. Repo template (thực tế hơn viết extension mới)

```text
 acme-copilot-template/           # repo template org (Template repository: ON)
   .github/copilot-instructions.md
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
gh repo create acme/new-service --template acme/acme-copilot-template --private --clone
cd new-service && cat .vscode/extensions.json  # verify pack đi kèm
# Kỳ vọng: repo mới có đủ .github/ + .vscode/ + .husky/.
```

---

## 6. Org policy allow/block + checklist review

Dành cho admin/org owner (Business/Enterprise); dev thường chỉ xem + request.

```text
 Admin (github.com → Org Settings → Copilot → Policies → Extensions):
 - Allowed extensions: github, linear, sentry (list rõ, còn lại block).
 - VS Code marketplace: restrict (chỉ extensions đã review) — Enterprise.
 - Audit log: ai cài extension nào, khi nào (review hàng tháng).

 Admin (VS Code marketplace org):
 - Private marketplace/allowlist: chỉ pack org + extensions đã vet.
 - Block categories: themes lạ không sao; block extensions chạy shell/network chưa vet.
```

```bash
# Audit extensions team đang dùng (mỗi tháng):
code --list-extensions --show-versions > /tmp/exts.txt
# So với allowlist wiki: ngoài list + không ai nhận → code --uninstall-extension <id>
```

**Checklist review extension lạ (trước khi cho vào org):**

| Kiểm tra gì | Vì sao |
|---|---|
| Đọc permissions (chạy shell? đọc files? gọi mạng?) | Extension chạy với quyền bạn — đọc `.env` được nếu bạn cho |
| Nguồn: official / org / cá nhân lạ? | Lạ → test repo thử trước |
| MCP servers kèm: URL lạ? secrets qua env? | Tránh exfiltrate (bài 08) |
| Version pinned? CHANGELOG có breaking? | Tránh gãy giữa sprint |
| 2 extensions cùng chức năng? | Chọn 1, gỡ kia (đỡ conflict) |

---

## 7. Hiểu nhầm + pitfalls

| Hiểu nhầm / pitfall | Sự thật / fix |
|---|---|
| "Copilot Extension và VS Code extension là 1" | Sai. Một cái là GitHub App gọi qua `@`; một cái là plugin editor (có thể bundle MCP) |
| "Cài càng nhiều càng mạnh" | Sai. >5 `@-mentions` → Copilot chọn sai; pack 30 extensions → VS Code chậm. Giữ pack core 7–10 + optional theo role |
| "Extension lạ cài thử, sao đâu" | Sai. Nó chạy với quyền bạn (đọc files, chạy shell, gọi mạng). Review permissions + test repo thử |
| "Update latest luôn cho mới" | Sai. Update giữa sprint dễ gãy. Pin version, update cuối sprint + test 1 ngày |
| "Repo template dựng 1 lần là xong" | Sai. 6 tháng không sync → lỗi thời. Cuối sprint sync PR template → repos |
| Cài extension lạ, nó đọc `.env` | Không review permissions → checklist mục 6; content exclusion vẫn làm lưng (bài 07) |
| 2 formatters conflict | `unwantedRecommendations` + `defaultFormatter` rõ ràng |

---

## 8. So sánh với Claude Code + bài tập + link chéo

| Việc | Copilot | Claude Code |
|---|---|---|
| Đóng gói chuẩn team | Copilot Extensions (GitHub App) + VS Code pack | Plugins (`.claude-plugin/`, marketplace) gói command/agent/skill/MCP |
| Gọi SaaS trong Chat | `@-mention` (`@linear`, `@sentry`) | MCP server + slash command |
| Tooling editor | VS Code extension pack | Không có tương đương (terminal-first) |
| Pin version | `code --install-extension name@version` | Pin qua commit/revision của plugin |
| Org policy allow/block | Org Settings → Copilot → Policies | Managed settings org-wide |

**Bài tập nhỏ:**

1. Commit `.vscode/extensions.json` vào 1 repo → clone fresh trên profile mới → verify VS Code gợi ý cài.
2. Cài 1 Copilot Extension (`@linear`/`@sentry`). Test 3 prompts + viết 1 prompt file kèm để output đúng format team.
3. Pin versions + lập table wiki. Update 1 extension lên latest trên repo thử → có breaking không?
4. Audit extensions team (`code --list-extensions`) so với allowlist — gỡ 1 cái thừa.
5. Tạo repo từ template (hoặc dựng template tối thiểu) → onboard 1 teammate thử.

**Link chéo:** Bài 03 (instructions format output `@sentry`) · Bài 05 (prompt files kèm extension) · Bài 07 (allowlist + content exclusion) · Bài 08 (extension bundle MCP — review URL/secrets) · Bài 10 (tool approval cho extension tools) · Bài 12 (extensions trong Actions runners) · Bài 16 (validate extension/MCP 5 bước).

## Reference

- GitHub Copilot docs: https://docs.github.com/copilot
- VS Code Copilot docs: https://code.visualstudio.com/docs/copilot
- VS Code Marketplace: https://marketplace.visualstudio.com/vscode

> **Chốt bài 09:** extension chỉ đáng đóng gói khi bạn đã vượt ngưỡng — và khi đã đóng gói, hãy pin version, giữ pack gọn, review quyền từng extension lạ, vì tất cả chúng chạy bằng quyền của bạn.
