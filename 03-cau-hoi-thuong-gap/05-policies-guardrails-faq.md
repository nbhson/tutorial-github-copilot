# FAQ 05 — Policies & Guardrails FAQ

> **Vấn đề:** "instruction không ăn thì fix sao, chặn commit xấu và push main thế nào" — nguyên tắc chung: quy tắc nào chỉ nên *nhắc* thì để instructions; quy tắc nào *tuyệt đối không được phạm* thì khóa cứng ở server (policy / branch protection / secret scanning).

## Bảng tổng hợp: guardrail nào chặn ở đâu

| Muốn chặn | Công cụ | Chặn ở tầng |
|---|---|---|
| Copilot đọc file nhạy cảm | Content exclusion | IDE + org policy |
| Commit sai chuẩn / dính secret | Pre-commit hooks + secret scanning | Local + GitHub |
| Push thẳng main | Branch protection ruleset | GitHub server |
| Agent làm việc cấm | Instructions "KHÔNG" + approval | Prompt + IDE |
| PR chưa review đã merge | Required reviewers + status checks | GitHub server |

---

## 1. Instruction "không ăn" — vì sao Copilot vẫn làm điều cấm?

**Trả lời 1 câu:** 5 nguyên nhân theo thứ tự kiểm tra: file đặt sai chỗ → `applyTo` sai glob → câu cấm mơ hồ → prompt task đè instruction → context tràn.

1. `copilot-instructions.md` phải ở `.github/`; instructions con phải `*.instructions.md` trong `.github/instructions/`.
2. `applyTo` sai glob → file cần không khớp pattern (xem [bài 06](06-prompts-agents-instructions.md)).
3. "Cẩn thận với migrations" yếu hơn "KHÔNG sửa db/migrations/** dưới mọi hình thức".
4. User bảo "sửa luôn migration" → model nghe prompt gần hơn instruction.
5. Context tràn → instructions bị cắt khỏi window (xem [bài 02](02-model-context-premium.md)).

```bash
ls .github/copilot-instructions.md .github/instructions/
wc -l .github/copilot-instructions.md   # nên <200 dòng, dài quá bị cắt
# Test: "Liệt kê 3 quy tắc quan trọng nhất trong copilot-instructions.md"
# Verify: trả đúng 3 quy tắc, không bịa
```

> Đi tăng cường độ câu chữ ("KHÔNG, TUYỆT ĐỐI KHÔNG...") trong khi file nằm sai thư mục thì câu cấm có mạnh đến mấy cũng không được nạp.

## 2. Viết quy tắc "cấm" sao cho Copilot nghe lời?

**Trả lời 1 câu:** Công thức: **động từ mạnh (ALWAYS/NEVER) + phạm vi chính xác + hậu quả/hướng thay thế** — model chỉ tuân theo thứ nó kiểm chứng được.

```markdown
<!-- Mẫu block Rules trong .github/copilot-instructions.md -->
## Rules (bắt buộc)
- NEVER commit trực tiếp main. Luôn tạo branch `feat/<ten>`.
- NEVER sửa `db/migrations/**` đã merge. Tạo migration mới.
- NEVER hardcode secret. Secrets chỉ qua `process.env.*`.
- ALWAYS chạy focused test sau mỗi sửa, paste kết quả PASS/FAIL.
```

- Yếu: "Cẩn thận khi sửa migrations." — Mạnh: "NEVER sửa `db/migrations/**`. DB change → tạo file migration mới + chạy `npm run migrate:up`."
- Yếu: "Nhớ chạy test." — Mạnh: "ALWAYS chạy `npm test -- <file-lien-quan>` sau mỗi sửa."

> Rule quan trọng đặt lên top 20 dòng file — rule nằm cuối file dài dễ bị cắt khỏi context.

## 3. Pre-commit tương đương: chặn commit xấu thế nào?

**Trả lời 1 câu:** Dựng 3 lớp deterministic chạy *ngoài* model — pre-commit framework (lint/test), gitleaks (secret scan), GitHub push protection — không model nào tắt được.

> Copilot có hooks in-process (`.github/hooks/*.json`, `PreToolUse`/`PostToolUse`) nhưng **preview, chỉ chạy Local**, chưa phải security boundary — muốn "không thể tắt được" thì phải dựa vào git hook + server.

| Lớp | Công cụ | Chặn gì | Chặn ở đâu |
|---|---|---|---|
| Pre-commit framework | `pre-commit` | Lint/format/test nhanh | Local (git hook) |
| Secret scan | gitleaks/trufflehog | Secret trong staged files | Local (git hook) |
| Push protection | GitHub secret scanning | Secret đã biết lúc push | GitHub server |

```bash
pip install pre-commit gitleaks || brew install pre-commit gitleaks

cat > .pre-commit-config.yaml <<'YAML'
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v5.0.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-added-large-files
YAML
pre-commit install
# Verify: git commit thử -> hook chạy + chặn lỗi

gitleaks protect --staged --verbose
# Verify: "No leaks found" hoặc list đúng dòng dính secret
```

## 4. Branch protection: chặn push main + ép review thế nào?

**Trả lời 1 câu:** Tạo ruleset `protect-main` ở `Repo → Settings → Rules → Rulesets`: require PR + status checks + block force push — lớp "law" thật sự: dù agent hay người, vào `main` đều phải qua PR + CI xanh.

```bash
gh api repos/<OWNER>/<REPO>/rulesets -X POST -f name='protect-main' \
  -f enforcement='active' -f target='branch' \
  --raw-field 'conditions={ "ref_name": { "include": ["refs/heads/main"], "exclude": [] } }' \
  --raw-field 'rules=[{"type":"deletion"},{"type":"non_fast_forward"},{"type":"pull_request","parameters":{"required_approving_review_count":1,"dismiss_stale_reviews_on_push":true}}]'
# Verify: gh api repos/<OWNER>/<REPO>/rulesets ra list có protect-main
```

> Dựng **trước** khi onboarding Copilot coding agent — nó cũng phải tuân ruleset.

## 5. Secret scanning + push protection bật thế nào?

**Trả lời 1 câu:** Bật ở `Repo/Org → Settings → Code security → Secret scanning + Push protection`; lỡ commit secret thì **xoay key NGAY rồi mới xóa history** — xóa commit mà không xoay thì key vẫn sống trong tay kẻ đã clone.

- **Secret scanning:** quét repo tìm secret đã lộ → alert trong `Security → Secret scanning`.
- **Push protection:** chặn ngay lúc `git push`, bypass có lý do (lưu audit log).

```bash
gh api repos/<OWNER>/<REPO>/secret-scanning/alerts --jq '.[] | {number, secret_type, state}'
# Verify: state "open" = còn secret lộ

# Lỡ commit secret: 1. Revoke/rotate trên dashboard provider (trước!)  2. Xóa file
git rm --cached secrets/leaked.key && git commit -m "chore: remove leaked secret"
```

## 6. Ép conventional commits / lint trước khi agent commit?

**Trả lời 1 câu:** commitlint hook local (chặn ngay khi commit) + status check CI (PR không merge được nếu đỏ) — agent và người cùng bị ép một chuẩn.

```yaml
# .github/workflows/lint.yml (status check bắt buộc)
name: lint
on: [pull_request]
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm ci && npm run lint
```

**Ví dụ:** agent commit `fix stuff` → commitlint chặn → agent tự sửa thành `fix(auth): handle expired session`.

## 7. Giới hạn coding agent: chỉ cho nó đụng repo/branch nào?

**Trả lời 1 câu:** Admin (Enterprise) cấu hình ở org policy (coding agent bật cho repo nào); dev ghi rõ repo + branch + phạm vi file trong issue để agent không lan ra ngoài.

```bash
# Trong issue giao việc: "Repo: acme/api. Branch base: develop (KHÔNG main).
#  Chỉ sửa src/payments/**. Không đụng infra/."
# Verify: PR đúng repo + đúng branch, không lan ra ngoài
```

## 8. Audit: biết ai/agent đã làm gì?

**Trả lời 1 câu:** 3 nguồn log: git history (commit agent có `Co-authored-by: Copilot`), org audit log (ai đổi policy/assign seat), PR timeline (agent ghi comment từng bước).

```bash
git log --format='%h %an %s' -20 | grep -i "bot\|copilot"
gh api orgs/<ORG>/audit-log --jq '.[] | {action, actor, created_at}' | head -20
# Verify: list commit + hành động, actor = ai
```

## 9. Guardrail cho lệnh nguy hiểm trong CI?

**Trả lời 1 câu:** Secrets qua `${{ secrets.* }}` → `env`, KHÔNG `echo` secret, KHÔNG flag skip-verification/bypass; job đụng prod dùng `environment:` + required reviewers.

```yaml
jobs:
  review:
    runs-on: ubuntu-latest
    environment: review  # ép approval nếu đụng prod
    steps:
      - uses: actions/checkout@v4
      - env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: gh copilot suggest "summarize changes" --no-interactive || true
```

## 10. Checklist guardrails cho repo mới (5 phút)?

**Trả lời 1 câu:** 6 tick: exclusion paths, block Rules ALWAYS/NEVER, ruleset bảo vệ `main`, secret scanning + push protection, CI lint/test, `mcp.json` không hardcode.

```bash
ls .github/copilot-instructions.md .vscode/settings.json .vscode/mcp.json
grep -rn "ghp_\|sk-live\|xoxb-" .vscode/ .github/ 2>/dev/null && echo "CO SECRET HARDCODE!" || echo "secrets OK"
gh api repos/<OWNER>/<REPO>/rulesets --jq '.[].name'
# Verify: đủ 3 file + "secrets OK" + ruleset protect-main
```

> Đây là definition-of-done trước khi bật coding agent — thiếu 1 tick là mở một đường lách qua guardrail.

---

## Vẫn lỗi thì sao? (thứ tự debug chuẩn)

1. Instruction sai chỗ/sai glob? (`ls .github/`, xem [bài 06](06-prompts-agents-instructions.md)).
2. Quy tắc viết mơ hồ? → viết lại ALWAYS/NEVER + path cụ thể.
3. Hook local đã `pre-commit install` chưa.
4. Ruleset/push protection chặn? → đọc thông báo chặn (nó nói rõ lý do).
5. Vẫn lọt → nâng từ "khuyến nghị" lên "ép buộc server-side" (ruleset + required checks).

Tham khảo chéo: [bài 03](03-modes-permissions.md) (content exclusion) · [bài 09](09-bao-mat-quyen-rieng-tu.md) (secrets + audit sâu) · [bài 10](10-ci-sdk-review-web.md) (CI workflows) · [../templates/README.md](../templates/README.md).
