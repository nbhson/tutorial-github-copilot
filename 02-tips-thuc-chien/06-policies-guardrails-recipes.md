# Tips 06 — Policies & Guardrails: Recipes Chống Copilot Đi Lạc

> Copilot ngoan hay hư là do guardrails của bạn. Bài này cho bạn recipes tương đương hooks: instruction enforcement, pre-commit, branch protection, MCP/tool approval — copy-paste là dùng ngay.

## Mục lục

- [1. Vì sao cần guardrails?](#1-vì-sao-cần-guardrails)
- [2. Cơ chế: 4 lớp guardrails Copilot](#2-cơ-chế-4-lớp-guardrails-copilot)
- [3. Lớp 1: instruction enforcement (luật tự áp)](#3-lớp-1-instruction-enforcement-luật-tự-áp)
- [4. Lớp 2: pre-commit + local gates](#4-lớp-2-pre-commit--local-gates)
- [5. Lớp 3: branch protection + CI gates](#5-lớp-3-branch-protection--ci-gates)
- [6. Lớp 4: MCP / tool approval](#6-lớp-4-mcp--tool-approval)
- [7. Walkthrough theo phút: dựng guardrails 45 phút](#7-walkthrough-theo-phút-dựng-guardrails-45-phút)
- [8. Bảng tra nhanh: recipe nào cho lỗi nào?](#8-bảng-tra-nhanh-recipe-nào-cho-lỗi-nào)
- [9. Pitfalls + cách fix](#9-pitfalls--cách-fix)
- [10. Bài tập cuối bài](#10-bài-tập-cuối-bài)
- [11. Tham khảo chéo](#11-tham-khảo-chéo)

---

## 1. Vì sao cần guardrails?

Không guardrails, Copilot sẽ:

- Đụng `src/generated/`, đổi schema, commit thẳng main.
- Thêm dependency mới vì tiện, không hỏi.
- Chạy lệnh nguy hiểm (`rm -rf`, `git reset --hard`) khi bạn cho Agent full quyền.
- Gọi MCP/tool ngoài luồng, rò rỉ secret vào prompt.

Guardrails không phải để cấm Copilot, mà để:

```text
Việc nguy hiểm → chặn trước khi chạy.
Việc hay sai → bắt verify sau khi làm.
Việc quan trọng → bắt người duyệt.
```

> Rule: **luật nào bạn phải nhắc >2 lần thì viết thành guardrail, đừng nhắc miệng nữa.**

---

## 2. Cơ chế: 4 lớp guardrails Copilot

| Lớp | Chặn ở đâu | Ví dụ | Ai giữ |
|---|---|---|---|
| 1 | Instructions (tự áp mọi turn) | muse-instructions.md, .instructions.md | Dev / team |
| 2 | Local gates (máy bạn) | pre-commit, lint-staged, tool approval | Dev |
| 3 | Remote gates (GitHub) | Branch protection, required checks, codeowners | Org / maintainer |
| 4 | Tool/MCP approval | Hỏi trước khi chạy lệnh/MCP | Dev / org policy |

Phòng thủ sâu:

```text
Instructions dặn đừng → local gate chặn nếu vẫn làm → CI gate chặn nếu lọt → review người chốt.
Lọt 1 lớp không sao, còn 3 lớp sau.
```

---

## 3. Lớp 1: instruction enforcement (luật tự áp)

### Recipe 1 — muse-instructions.md cấm địa (copy-paste)

```markdown
# .github/muse-instructions.md

## Cấm địa (NEVER, áp mọi turn)
- Không sửa `src/generated/`, `dist/`, `*.lock`.
- Không đổi DB schema/migration nếu chưa hỏi.
- Không commit thẳng `main`, luôn tạo branch + PR.
- Không thêm dependency mới nếu chưa được duyệt.
- Không xóa/sửa test để cho xanh.

## Verify bắt buộc
- Mọi change code phải kèm lệnh test + log dán.
- Feature/refactor: `npm test` + `npm run lint` + `npm run build`.

## Khi không chắc
- Hỏi trước khi đoán. Thiếu spec thì trình 2 phương án + chờ duyệt.
```

### Recipe 2 — Path-scoped instructions (copy-paste)

Tạo `.github/instructions/payments.instructions.md`:

```markdown
---
applyTo: "src/payments/**"
---

## Riêng payments
- Mọi refund >30 ngày phải hỏi duyệt, không tự quyết.
- Mọi API mới phải có idempotency-key.
- Test bắt buộc: `npm test -- payments` xanh.
```

Tạo `.github/instructions/generated.instructions.md`:

```markdown
---
applyTo: "src/generated/**"
---

## Generated: chỉ đọc, không sửa
- Nếu cần đổi, sửa nguồn sinh ra nó, không sửa file này.
- Trả lời "đây là file generated, tôi không sửa" khi được nhờ.
```

### Recipe 3 — Prompt files có gate sẵn (copy-paste)

```markdown
---
mode: agent
description: Implement theo plan, có gate
---

## Gate trước khi code
- Đọc plan.md, liệt kê files sẽ sửa. File ngoài plan → hỏi trước.

## Gate sau khi code
- Chạy test/lint/build, dán 3 logs vào ## Evidence.
- `git diff --stat` phải chỉ chạm scope plan. Lệch → dừng + báo.
```

Lợi ích: bạn không cần nhớ dặn, file tự dặn Copilot mỗi lần gọi `/tên-file`.

Chi tiết thiết kế xem [Tips 07](./07-thiet-ke-prompts-skills.md).

---

## 4. Lớp 2: pre-commit + local gates

### Recipe 4 — pre-commit chặn rác (copy-paste)

`.pre-commit-config.yaml`:

```yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.6.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-added-large-files
        args: ['--maxkb=500']
      - id: check-merge-conflict
  - repo: local
    hooks:
      - id: no-generated
        name: Chặn sửa generated/
        entry: bash -c 'git diff --cached --name-only | grep -q "src/generated/" && echo "BLOCKED: đừng sửa generated/" && exit 1 || exit 0'
        language: system
        always_run: true
      - id: no-main-commit
        name: Chặn commit thẳng main
        entry: bash -c 'git rev-parse --abbrev-ref HEAD | grep -q "^main$" && echo "BLOCKED: không commit thẳng main" && exit 1 || exit 0'
        language: system
        always_run: true
```

Cài:

```bash
pip install pre-commit
pre-commit install
pre-commit run --all-files
```

### Recipe 5 — lint-staged + test nhanh (copy-paste)

`package.json`:

```json
{
  "lint-staged": {
    "src/**/*.ts": ["eslint --fix", "prettier --write"],
    "src/payments/**": ["npm test -- payments"]
  }
}
```

```bash
npm i -D lint-staged husky
npx husky init
echo "npx lint-staged" > .husky/pre-commit
```

Hiệu quả: Copilot sửa sai → commit bị chặn ngay, phải fix mới commit được.

### Recipe 6 — Tool approval trong VS Code (copy-paste setup)

```text
VS Code → Settings → Copilot → Agent:
- Confirm before running commands: ON
- Allowed commands: npm test*, npm run lint, npm run build
- Blocked: rm -rf *, git reset --hard, git push --force
```

Từ giờ Agent muốn chạy lệnh lạ → popup hỏi bạn. Lệnh trong allowlist → chạy luôn cho nhanh.

---

## 5. Lớp 3: branch protection + CI gates

### Recipe 7 — Branch protection chuẩn (copy-paste checklist)

```text
Repo → Settings → Branches → Add rule (main):
- [x] Require pull request before merging (1 review)
- [x] Require status checks: test / lint / build
- [x] Require Copilot code review
- [x] Dismiss stale reviews khi push mới
- [x] Block force push
- [x] Require CODEOWNERS review cho src/payments/**
```

### Recipe 8 — CI workflow gate (copy-paste)

`.github/workflows/verify.yml`:

```yaml
name: verify
on: [pull_request]
jobs:
  verify:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: 20 }
      - run: npm ci
      - run: npm test
      - run: npm run lint
      - run: npm run build
      - run: git diff --stat origin/main | grep -q "src/generated/" && echo "BLOCKED" && exit 1 || echo "diff OK"
```

### Recipe 9 — CODEOWNERS + org policy (copy-paste)

`CODEOWNERS`:

```text
/src/payments/** @team-payments
/src/auth/** @team-auth
/.github/muse-instructions.md @tech-leads
/.github/prompts/** @tech-leads
```

Org policy (GitHub Org → Copilot → Policies):

```text
- Coding Agent chỉ chạy trên repo có CI xanh mẫu.
- Chặn Copilot suggest cho file *.pem, .env, secrets/.
- Mọi thay đổi instructions/prompts phải qua PR + 1 review lead.
```

---

## 6. Lớp 4: MCP / tool approval

### Recipe 10 — Prune MCP/extensions (copy-paste audit)

```text
Mỗi tháng chạy 1 lần:
1. VS Code → Extensions → Copilot related: tắt cái 2 tuần không dùng.
2. Settings → MCP servers: giữ ≤6 servers thực dùng.
3. Hỏi: server nào không nhớ tác dụng → tắt, cần thì bật lại.
```

### Recipe 11 — MCP approval hỏi trước (copy-paste setup)

```text
Settings → MCP:
- Auto-approve: OFF cho servers có quyền write/remote.
- Allowlist: chỉ read docs, search code.
- Audit log: bật, monthly review tool nào gọi nhiều nhất.
```

Prompt dặn Copilot khi dùng tools (copy-paste):

```text
Chỉ dùng tools trong allowlist: đọc file, search, chạy test/lint/build.
Muốn gọi MCP ngoài (DB, deploy, web) → hỏi tôi trước, nêu lý do + lệnh cụ thể.
Không paste secret (.env, token) vào chat hay tool input.
```

### Recipe 12 — Secret hygiene (copy-paste)

```text
.gitignore bắt buộc:
.env
*.pem
*.key
secrets/

Instructions thêm:
- Không đọc file .env*, không in secret ra chat/log.
- Cần config mẫu → đọc .env.example, không đọc .env thật.
```

---

## 7. Walkthrough theo phút: dựng guardrails 45 phút

**Bối cảnh:** repo mới, Copilot hay sửa lan man, chưa có gate gì.

| Phút | Lớp | Việc (copy-paste) |
|---|---|---|
| 0–10 | Lớp 1 | Tạo `.github/muse-instructions.md` recipe 1 + 2 files `applyTo` recipe 2 |
| 10–20 | Lớp 2 | Thêm `.pre-commit-config.yaml` recipe 4, `pre-commit install`, test commit chặn generated/ |
| 20–25 | Lớp 2 | Bật tool approval: confirm commands ON, allowlist test/lint/build |
| 25–35 | Lớp 3 | Thêm `verify.yml` recipe 8, bật branch protection recipe 7 |
| 35–40 | Lớp 3 | Thêm CODEOWNERS recipe 9, tạo PR mẫu kiểm tra CI + review |
| 40–45 | Lớp 4 | Audit MCP/extensions, tắt server thừa, bật approval OFF auto |

Sau 45 phút: 4 lớp guardrails chạy. Copilot đi lạc → bị chặn ít nhất 1 lớp.

---

## 8. Bảng tra nhanh: recipe nào cho lỗi nào?

| Lỗi hay gặp | Recipe chặn | Lớp |
|---|---|---|
| Sửa generated/ | Recipe 1 + 2 + 4 (no-generated hook) | 1 + 2 |
| Commit thẳng main | Recipe 1 + 4 (no-main-commit) + 7 | 1 + 2 + 3 |
| Thêm dep bừa | Recipe 1 NEVER + review + CI | 1 + 3 |
| Xóa test để xanh | Recipe 3 gate + reviewer prompt | 1 |
| Chạy rm -rf nguy hiểm | Recipe 6 tool approval blocklist | 2 |
| Thiếu test/lint/build | Recipe 5 + 8 CI required | 2 + 3 |
| PR không ai review | Recipe 7 + 9 CODEOWNERS | 3 |
| MCP gọi bừa, rò secret | Recipe 10 + 11 + 12 | 4 |
| Instructions bị sửa bừa | Recipe 9 CODEOWNERS cho prompts | 3 |
| Diff chạm file cấm | Recipe 8 diff-check step | 3 |

> Quy tắc ngón tay: **lỗi lặp lại 2 lần → viết thành recipe, đừng nhắc miệng lần 3.**

---

## 9. Pitfalls + cách fix

| Pitfall | Triệu chứng | Fix |
|---|---|---|
| Instructions 600 dòng | Copilot quên đầu, chậm | <200 dòng + applyTo files riêng |
| Pre-commit quá nặng (10 phút) | Dev bypass --no-verify | Chỉ gate nhanh local, gate nặng để CI |
| Branch protection quá chặt | Team kêu không làm được | Bắt đầu nhẹ (1 review + CI), chặt dần |
| Tool approval hỏi mọi lệnh | Agent chậm, bạn bấm mỏi tay | Allowlist test/lint/build, chỉ hỏi lệnh lạ |
| MCP bật 12 servers | Chọn sai tool, tốn requests | ≤6 servers, tắt cái 2 tuần không dùng |
| CODEOWNERS không ai review | PR treo 3 ngày | Mỗi scope 1 owner + backup, SLA 24h |
| Guardrails chỉ trên máy bạn | Người khác vẫn đi lạc | Commit instructions/prompts/CI vào repo (xem Tips 09) |
| Quên audit định kỳ | Guardrails mục dần | Lịch monthly: audit MCP + instructions + CI |
| Secret lọt vào chat | Rò rỉ token | Recipe 12 + gitignore + review PR kiểm tra |

---

## 10. Bài tập cuối bài

**Bài 1 (20 phút — chặn 1 lỗi đau nhất):**

1. Viết ra 1 lỗi Copilot hay mắc nhất của bạn (vd sửa generated/).
2. Áp 1 recipe lớp 1 + 1 recipe lớp 2/3 cho lỗi đó.
3. Test: nhờ Copilot làm sai cố ý, xem gate có chặn không?

**Bài 2 (30 phút — CI gate):**

1. Thêm `verify.yml` recipe 8 vào repo, tạo PR test.
2. Bật branch protection recipe 7 (require checks + review).
3. Thử merge PR đỏ → phải bị chặn mới đạt.

**Bài 3 (15 phút — audit tools):**

1. Liệt kê MCP servers + extensions Copilot đang bật.
2. Tắt cái 2 tuần không dùng, bật approval cho write/remote.
3. Thêm dòng secret hygiene vào instructions.

> Đạt: sau 1 tháng, 0 incident sửa generated/commit thẳng main/rò secret từ Copilot.

---

## 11. Tham khảo chéo

- Bài tips liên quan:
  - [Tips 04](./04-verification-done-that.md) — verify + review gate
  - [Tips 07](./07-thiet-ke-prompts-skills.md) — thiết kế instructions/prompts tái dùng
  - [Tips 08](./08-tiet-kiem-premium-requests.md) — prune MCP/extensions tiết kiệm
  - [Tips 09](./09-teamwork-chuan-hoa.md) — chuẩn hóa guardrails cho cả team
  - [Tips 11](./11-nang-cao-cli-web-coding-agent.md) — policy cho Coding Agent cloud

> Mẹo 1 dòng: _luật nhắc 2 lần thì viết thành guardrail — chặn trước bằng instructions, khóa sau bằng CI._
