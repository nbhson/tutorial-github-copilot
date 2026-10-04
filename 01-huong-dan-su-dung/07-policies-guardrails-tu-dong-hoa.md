# 07 — Policies & Guardrails Tự Động Hóa (Copilot Không Có Hooks In-Process)

> Bài 07 của series. Đọc xong bạn dựng được 6 lớp guardrails tương đương hooks:
> instructions enforcement, MCP allowlist, content exclusion, pre-commit, branch
> protection, secret scanning + Copilot review gate. Thời gian: ~45 phút.

## Mục lục

1. [Copilot không có hooks — vậy enforce bằng gì? (why)](#1-copilot-không-có-hooks--vậy-enforce-bằng-gì-why)
2. [Bản đồ 6 lớp guardrails](#2-bản-đồ-6-lớp-guardrails)
3. [Lớp 1–2: instructions enforcement + MCP allowlist](#3-lớp-1--2-instructions-enforcement--mcp-allowlist)
4. [Lớp 3: content & language exclusion](#4-lớp-3-content--language-exclusion)
5. [Lớp 4: pre-commit hooks + linter (copy-paste)](#5-lớp-4-pre-commit-hooks--linter-copy-paste)
6. [Lớp 5–6: branch protection + secret scanning + review gate](#6-lớp-5--6-branch-protection--secret-scanning--review-gate)
7. [Walkthrough + pitfalls + bài tập](#7-walkthrough--pitfalls--bài-tập)
8. [Link chéo](#8-link-chéo)

---

## 1. Copilot không có hooks — vậy enforce bằng gì? (why)

> Triết lý: instructions là advisory (Copilot có thể quên). Guardrails ngoài
> model là law (Copilot không override được). Rule nào miss 2 lần → nâng thành law.

Claude Code có hooks in-process (block tool call trước khi chạy). Copilot 2026
**không có** hooks in-process tương đương. Bạn enforce bằng 6 lớp ngoài model:

```text
So sánh enforce:
- muse-instructions.md "NEVER push main" → Copilot đọc, gật gù, đôi khi vẫn
  gợi ý push (quên/misread khi context dài).
- Branch protection "require PR + block force-push main" → chặn 100% ở server,
  kể cả khi Copilot gợi ý sai.
→ Cái nào cần chắc chắn? Guardrail ngoài model. Cái nào cần linh hoạt? Instructions.
```

Thứ tự nghĩ: **server-side (GitHub) > local deterministic (pre-commit, linter,
content exclusion) > advisory (instructions, prompt files)**. Càng gần server,
càng khó lách.

---

## 2. Bản đồ 6 lớp guardrails

| # | Lớp | Chặn ở đâu | Copilot override được? | Dùng cho |
|---|---|---|---|---|
| 1 | Instructions enforcement | Prompt (advisory) | Có (quên được) | Chuẩn code, non-goals |
| 2 | MCP allowlist + tool approval | Client (VS Code/org policy) | Khó | Giới hạn tools agents được gọi |
| 3 | Content/language exclusion | Server (GitHub) | Không | File nhạy cảm không vào model |
| 4 | Pre-commit + linter | Local git hook | Không (chạy ngoài model) | Format, lint, block secrets trước commit |
| 5 | Branch protection + required checks | Server (GitHub) | Không | Block push main, bắt CI xanh + review |
| 6 | Secret scanning/push protection + review gate | Server (GitHub) | Không | Block leak secrets + bắt Copilot review pass |

```text
Luồng 1 commit đi qua:
Bạn/Copilot sửa → [3] exclusion (file nhạy cảm không gửi model) →
[4] pre-commit (lint + secret scan local, fail → commit dừng) →
[5] push → branch protection (push main? từ chối) →
[6] PR → required checks + Copilot review (fail → không merge).
```

---

## 3. Lớp 1 – 2: instructions enforcement + MCP allowlist

### 3.1. Lớp 1 — Instructions enforcement (advisory, nhưng viết cho khó quên)

```markdown
<!-- .github/muse-instructions.md — viết rules dạng LAW, testable -->
# Guardrails (Copilot PHẢI tuân thủ — nếu vi phạm, dừng và hỏi)

1. KHÔNG push trực tiếp `main`/`master`. Mọi change → branch `feat/*` + PR.
2. KHÔNG sửa files trong `db/migrations/` đã merge — viết migration MỚI.
3. KHÔNG đọc/gợi ý từ `.env*`, `*credentials*`, `*secret*`.
4. Sau mỗi edit `.ts`: chạy `npx prettier --write <file>` + `npx eslint <file>`.
5. Test: chạy focused (`pnpm --filter @acme/api test <path>`) trước, full chỉ khi yêu cầu rõ.

<!-- Mẹo: rules dạng "KHÔNG + hậu quả + việc đúng" tuân thủ tốt hơn "nên". -->
<!-- Review: rule nào miss 2 lần → nâng thành lớp 4/5 (pre-commit/branch protection). -->
```

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

### 3.2. Lớp 2 — MCP allowlist + tool approval

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
```

---

## 4. Lớp 3: content & language exclusion

Content exclusion = file nhạy cảm **không bao giờ** gửi lên model Copilot
(server-side, Copilot không override được). Khác `.gitignore` (chỉ ignore git).

```text
Setup (admin repo/org):
github.com → repo → Settings → Copilot → Content exclusion → Add path:
  .env*
  **/*credentials*
  **/*secret*
  certs/**
  db/prod-dump/**
  .vscode/mcp.json        # nếu chứa secrets (nên chuyển sang env — bài 08)

Verify (ai cũng làm được):
1. Mở file .env trong VS Code → góc dưới Copilot icon phải hiện "excluded".
2. Chat: "@workspace đọc file .env giúp anh" → phải từ chối/không thấy nội dung.
3. Nếu vẫn đọc được → exclusion chưa apply (đợi ~30 phút sync) hoặc path sai.
```

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
```

> Duplication detection (suggestion matching public code) bật ở org-level:
> `Policies → Suggestions matching public code: Block`. Code gợi ý trùng public
> repo lớn → block + hiện references. Chi tiết bài 10.

---

## 5. Lớp 4: pre-commit hooks + linter (copy-paste)

Pre-commit chạy **ngoài model** (git hook local): Copilot có gợi ý sai thì hook
vẫn block. Đây là "hooks" gần nhất của Copilot-verse.

### 5.1. Recipe A — husky + lint-staged (Node, phổ biến nhất)

```bash
# Cài (1 lần, copy-paste):
pnpm add -D husky lint-staged prettier eslint
pnpm exec husky init
# → tạo .husky/pre-commit
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
```

### 5.2. Recipe B — pre-commit framework + secret scan (đa ngôn ngữ)

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
```

### 5.3. Recipe C — guard migrations bằng git hook thuần (không dependency)

```bash
# .husky/pre-push (block push main + force-push — chạy ngoài model):
#!/bin/sh
BRANCH="$(git rev-parse --abbrev-ref HEAD)"
if [ "$BRANCH" = "main" ] || [ "$BRANCH" = "master" ]; then
  echo "BLOCKED: không push trực tiếp main/master. Mở PR từ branch feat/*."
  exit 1
fi
# Block force-push: check push options (an toàn nhất vẫn là branch protection server-side, mục 6)
exit 0
```

---

## 6. Lớp 5 – 6: branch protection + secret scanning + review gate

### 6.1. Lớp 5 — Branch protection + required checks (server-side, không lách được)

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
```

```text
Ruleset UI (khuyên dùng 2026, github.com → Settings → Rules → Rulesets):
- Target: branch `main` (+ `release/*` nếu có).
- Rules: Restrict deletions ✓, Block force pushes ✓,
  Require PR (1 approval + dismiss stale) ✓,
  Require status checks (lint, test) ✓,
  Require Copilot code review (mục 6.3) ✓.
```

### 6.2. Lớp 6a — Secret scanning + push protection

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

### 6.3. Lớp 6b — Copilot code review as gate (required check)

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
```

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
```

---

## 7. Walkthrough + pitfalls + bài tập

### 7.1. Walkthrough: dựng guardrails từ 0 (40 phút)

```text
Bước 1 (5 phút): instructions LAW (mục 3.1). Copy vào .github/muse-instructions.md.
  Test: "push giúp anh lên main" → Copilot phải từ chối/gợi ý mở PR.

Bước 2 (5 phút): content exclusion (mục 4). Admin add .env*, *secret*.
  Test: "@workspace đọc .env" → phải từ chối.

Bước 3 (10 phút): husky + lint-staged (mục 5.1). Cài, test commit file lint lỗi
  → phải auto-fix hoặc fail. Đo thời gian hook — >5s thì thu hẹp scope.

Bước 4 (10 phút): branch protection (mục 6.1) bằng gh CLI. Test push main
  → phải bị từ chối server-side. Mở PR test → xác nhận cần checks + approval.

Bước 5 (10 phút): bật push protection + Copilot review gate (mục 6.2–6.3).
  Test secret giả → push bị block. Mở PR → Copilot review tự chạy.
```

### 7.2. Debug flowchart (guardrail không chạy → đi từng bước)

```text
Guardrail không chạy?
├─ 1. Instructions bị quên? → bình thường (advisory). Rule miss 2 lần → nâng thành lớp 4/5.
├─ 2. Pre-commit không chạy? → pre-commit install chưa? .husky/pre-commit +x chưa?
│     → chạy tay: .husky/pre-commit, xem exit code.
├─ 3. Branch protection không chặn? → ruleset apply đúng branch? enforce_admins ON?
│     → gh api .../protection kiểm tra (mục 6.1).
├─ 4. Push protection không block? → bật ở repo hay org? Secret giả có đúng format
│     provider (ghp_/sk-) không? Format lạ → không nhận diện.
├─ 5. Copilot review không chạy? → bật auto-request chưa? PR draft? (draft có thể skip
│     tùy config) → chuyển Ready for review rồi check lại.
└─ 6. Muốn nới (cho qua) nhưng vẫn block? → server-side deny thắng mọi instructions.
    Sửa ruleset gốc, đừng dặn Copilot "cứ merge đi".
```

### 7.3. Pitfalls + fix

| Pitfall | Vì sao | Fix |
|---|---|---|
| Tin instructions thay server guard | Advisory quên được | Critical → branch protection + push protection |
| Lint hook chậm 15s mỗi commit | Lint cả repo | `lint-staged`: chỉ files staged, đúng ext |
| Husky không chạy trên máy teammate | Quên `husky install` / clone mất hook | `pnpm prepare` script chạy `husky install`; CI check hooks tồn tại |
| Push protection block secret giả test | Format giả quá giống thật | Test trên branch `feat/*` rồi dọn, đừng test trên main |
| Branch protection chặn cả admin hotfix | `enforce_admins=true` | Hotfix → PR fast-track + auto-merge, không tắt protection |
| Copilot review flag mọi thứ → team ignore | Không tune prompt review | Dặn "chỉ lỗi thực sự" trong instructions + dismiss stale reviews |
| Secrets trong `.vscode/mcp.json` committed | Tiện tay paste | Secrets qua env (bài 08), grep repo trước khi push |

### 7.4. Bài tập thực hành

**Bài 1 (15 phút):** Cài recipe A (husky + lint-staged). Commit 1 file cố ý sai
lint, xem hook auto-fix. Đo thời gian — >5s thì thu hẹp scope.

**Bài 2 (15 phút):** Bật content exclusion cho `.env*`. Test `@workspace đọc .env`
→ ghi kết quả (từ chối hay lọt?). Check icon "excluded" trong VS Code.

**Bài 3 (15 phút):** Setup branch protection bằng `gh api` (mục 6.1). Test push
main → ghi message server trả về. Mở PR → xác nhận checks bắt buộc hiện.

**Bài 4 (15 phút):** Test push protection bằng secret giả (mục 6.2). Ghi lại
message block. Dọn branch test.

**Bài 5 (20 phút):** Bật Copilot review gate cho 1 repo test. Mở PR cố ý có bug
(VD SQL injection). Đếm findings Copilot bắt được. Tune instructions tới khi precision cao.

---

## 8. Link chéo

- **Bài 03 — Instructions, Memory, Rules:** advisory vs law — khi nào nâng rule thành guardrail.
- **Bài 05 — Prompt files:** prompt review/test tái dùng — gắn vào review gate.
- **Bài 06 — Custom agents:** khóa `tools` agent + MCP allowlist (defense in depth).
- **Bài 08 — MCP:** secrets MCP qua env, prune servers — đừng để server lạ lách policy.
- **Bài 10 — Modes & permissions:** tool approval (allow/ask/deny) + plan Individual/Business/Enterprise.
- **Bài 11 — Worktrees & checkpoints:** branch `copilot/*` + PR flow cho coding agent.
- **Bài 12 — SDK & CI:** required checks (lint/test/review) chạy trong Actions.

---
*(Hết bài 07 — tổng ~400 dòng. Tiếp theo: Bài 08 — MCP kết nối công cụ ngoài.)*
