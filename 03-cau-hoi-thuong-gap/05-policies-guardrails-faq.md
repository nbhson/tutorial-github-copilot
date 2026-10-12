# FAQ 05 — Policies & Guardrails FAQ

> **Dành cho:** dev/admin muốn "ép buộc" được quy tắc — không chỉ khuyến nghị — khi Copilot không nghe instruction.
> **Vấn đề:** "instruction không ăn thì fix sao, dựng pre-commit + branch protection, guardrail lệnh nguy hiểm trong CI" — 10 câu hỏi, mỗi câu có giải thích + lệnh copy-paste + ví dụ + khi nào áp dụng.
> **Đọc xong:** biết instruction không ăn thì fix sao, dựng pre-commit + branch protection. **Thời gian:** ~15 phút đọc.

File này là "hooks + guardrails" của Copilot: instruction không ăn, Copilot hooks in-process (preview, Local — bài 17), pre-commit, branch protection. Điểm chung của các câu hỏi dưới đây gói trong một câu: quy tắc nào chỉ nên *nhắc*, và quy tắc nào phải *khóa cứng* ở server.

## Mục tiêu bài học

- Phân biệt **khuyến nghị** (instructions) và **luật cứng** (policy / branch protection / secret scanning) — biết khi nào phải nâng cấp.
- Viết câu cấm dạng ALWAYS/NEVER đủ cụ thể để Copilot không bỏ qua.
- Dựng được 3 lớp chặn commit xấu: pre-commit, secret scan, GitHub push protection.
- Biết hooks in-process 2026 mạnh tới đâu (**preview, Local-only, chưa phải security boundary**) để không ỉ lại vào nó.

## Sơ đồ tư duy nhanh (đọc 30 giây)

Quy tắc "cấm" của bạn nằm ở tầng nào — khuyến nghị (instructions) hay luật cứng (policy/protection) — và khi nào chuyển từ khuyến nghị sang luật.

```mermaid
flowchart LR
    A[Quy tac viet] --> B{Loai?}
    B -->|Goi y| C[instructions / prompts]
    B -->|Luat cung| D[policy / branch protection / secret scanning]
    C --> E[Miss 2 lan -> dua vao D]
    D --> F[CI + pre-commit chan]
```

## Bảng tổng hợp: guardrail nào chặn ở đâu

Muốn chặn hành vi nào → dùng công cụ nào, chặn ở tầng nào (IDE, local, GitHub server).

| Muốn chặn | Công cụ | Chặn ở tầng |
|---|---|---|
| Copilot đọc file nhạy cảm | Content exclusion | IDE + org policy |
| Commit sai chuẩn / dính secret | Pre-commit hooks + secret scanning | Local + GitHub |
| Push thẳng main | Branch protection ruleset | GitHub server |
| Agent làm việc cấm | Instructions "KHÔNG" + approval | Prompt + IDE |
| PR chưa review đã merge | Required reviewers + status checks | GitHub server |

---

## 1. Instruction "không ăn" — vì sao Copilot vẫn làm điều cấm?

> **Hỏi ngắn gọn:** _Instruction "không ăn" — vì sao Copilot vẫn làm điều cấm?_

**Trả lời 1 câu:** 5 nguyên nhân: file đặt sai chỗ, `applyTo` sai glob, câu cấm mơ hồ, prompt đè instruction, context tràn — check theo đúng thứ tự.

**Giải thích chi tiết + ví dụ:** 5 nguyên nhân theo thứ tự kiểm tra:

1. **File đặt sai chỗ/tên:** `copilot-instructions.md` phải ở `.github/`, instructions con phải `*.instructions.md` trong `.github/instructions/`.
2. **`applyTo` sai glob** → file cần không khớp pattern (xem [bài 06](06-prompts-agents-instructions.md)).
3. **Câu cấm viết mơ hồ:** "cẩn thận với migrations" yếu hơn "KHÔNG sửa db/migrations/** dưới mọi hình thức".
4. **Prompt task đè instruction:** user bảo "sửa luôn migration" → model nghe prompt gần hơn.
5. **Context tràn** → instructions bị cắt khỏi window (xem [bài 02](02-model-context-premium.md)).

**Vì sao quan trọng?** Hầu hết "Copilot không nghe lời" thật ra nằm ở khâu cấu hình chứ không phải model cố tình cãi. Kiểm đúng thứ tự này giúp bạn sửa gốc thay vì viết lại câu cấm nhiều lần.

**Nếu làm sai?** Bạn đi tăng cường độ câu chữ ("KHÔNG, TUYỆT ĐỐI KHÔNG...") trong khi lỗi thật là file nằm sai thư mục hoặc `applyTo` không khớp — câu cấm có mạnh đến mấy cũng không bao giờ được nạp.

### Làm thế nào (steps copy-paste)

```bash
# Checklist file có đúng chỗ không
ls .github/copilot-instructions.md .github/instructions/
wc -l .github/copilot-instructions.md  # nên <200 dòng, dài quá bị cắt
# Verify: file tồn tại + số dòng <200

# Test instruction có ăn không: hỏi thẳng trong chat
# "Liệt kê 3 quy tắc quan trọng nhất trong copilot-instructions.md"
# Verify: copilot trả đúng 3 quy tắc, không bịa
```

**Ví dụ cụ thể:** cấm "không push main" mà agent vẫn push → kiểm tra thấy câu cấm nằm ở dòng 250/300 → model ít đọc tới → chuyển lên top 20 dòng + đổi thành "NEVER git push --force...".

> **Khi nào áp dụng:** mọi ca "em đã ghi rồi mà nó không nghe" — check vị trí + độ cụ thể trước.

> **Nếu vẫn lỗi thì...** (1) hỏi lại Copilot để chắc nó load đúng file; (2) đổi model (`/model`) rồi thử lại; (3) nếu context dài làm file bị cắt thì rút instructions ngắn lại; (4) hỏi admin vì org policy có thể đang đè lên cấu hình của bạn.

---

## 2. Viết quy tắc "cấm" sao cho Copilot nghe lời?

> **Hỏi ngắn gọn:** _Viết quy tắc "cấm" sao cho Copilot nghe lời?_

**Trả lời 1 câu:** Công thức: **động từ mạnh (ALWAYS/NEVER) + phạm vi chính xác + hậu quả/hướng thay thế** — câu mơ hồ copilot sẽ bỏ qua.

**Giải thích chi tiết + ví dụ:** Công thức: **động từ mạnh + phạm vi chính xác + hậu quả/hướng thay thế.**

- Yếu: "Cẩn thận khi sửa migrations."
- Mạnh: "NEVER sửa `db/migrations/**`. DB change → tạo file migration mới + chạy `npm run migrate:up`."
- Yếu: "Nhớ chạy test."
- Mạnh: "ALWAYS chạy `npm test -- <file-lien-quan>` sau mỗi sửa. Không báo PASS thì không kết luận xong."

**Vì sao quan trọng?** Model chỉ tuân theo thứ nó *kiểm chứng được*. "Cẩn thận" là lời khuyên không đo được; "NEVER sửa path X" là mệnh lệnh có ranh giới rõ, và kèm hướng thay thế thì nó biết phải làm gì thay vì tự đoán.

### Làm thế nào (steps copy-paste)

```markdown
<!-- Mẫu block Rules trong .github/copilot-instructions.md -->
## Rules (bắt buộc)
- NEVER commit trực tiếp main. Luôn tạo branch `feat/<ten>`.
- NEVER sửa `db/migrations/**` đã merge. Tạo migration mới.
- NEVER hardcode secret. Secrets chỉ qua `process.env.*`.
- ALWAYS chạy focused test sau mỗi sửa, paste kết quả PASS/FAIL.
```

**Ví dụ cụ thể:** copy block trên vào `templates/.github/copilot-instructions.md` → sửa lệnh test cho khớp repo → quy tắc "ăn" ngay vì cụ thể + check được.

> **Khi nào áp dụng:** khi viết/sửa mọi instruction — mỗi quy tắc phải có động từ ALWAYS/NEVER + path/lệnh cụ thể.

> **Nếu vẫn lỗi thì...** (1) đối chiếu câu bạn viết với mẫu ALWAYS/NEVER; (2) hỏi Copilot "liệt kê 3 quy tắc bắt buộc trong instructions" xem nó có đọc tới; (3) dời rule quan trọng lên top file; (4) vẫn lọt thì nâng nó lên guardrail server (câu 4–5).

---

## 3. Pre-commit tương đương: chặn commit xấu thế nào?

> **Hỏi ngắn gọn:** _Pre-commit tương đương: chặn commit xấu thế nào?_

**Trả lời 1 câu:** Dựng 3 lớp deterministic: pre-commit framework (lint/test), gitleaks (secret scan), GitHub push protection (chặn secret khi push) — không model nào tắt được.

**Giải thích chi tiết + ví dụ:** Copilot 2026 có hooks in-process (`.github/hooks/*.json`, events `PreToolUse`/`PostToolUse`...) nhưng **preview + Local-only**, chưa phải security boundary (bài 07/17). Pre-commit ở đây = **git hooks local + GitHub push protection** — lớp deterministic không model tắt được. Dựng 3 lớp:

1. **pre-commit framework:** lint/format/test nhanh trước commit.
2. **gitleaks/trufflehog:** quét secret trong staged files.
3. **GitHub push protection:** chặn push chứa secret đã biết (secret scanning).

| Lớp | Công cụ | Chặn gì | Chặn ở đâu | Khi nào dùng |
|---|---|---|---|---|
| Pre-commit framework | `pre-commit` | Lint/format/test nhanh | Local (git hook) | Mọi commit |
| Secret scan | gitleaks/trufflehog | Secret trong staged files | Local (git hook) | Repo có secret/thanh toán |
| Push protection | GitHub secret scanning | Secret đã biết lúc push | GitHub server | Bật mặc định mọi repo |

**Vì sao quan trọng?** Hooks in-process của Copilot chặn được *một tool call*, nhưng config do dev giữ và mới ở mức preview — không phải hàng rào cứng. Muốn "không thể tắt được" thì phải dựa vào git hook + server, là những thứ chạy *ngoài* model.

**Nếu làm sai?** Tin "Copilot có PreToolUse rồi thì khỏi cần pre-commit" → khi model (hoặc một plugin) xin chạy ngoài hook, không có lớp nào chặn commit xấu — secret và lint lỗi vào thẳng repo.

### Làm thế nào (steps copy-paste)

```bash
# Cài pre-commit + hook secret scan
pip install pre-commit gitleaks || brew install pre-commit gitleaks

# .pre-commit-config.yaml tối thiểu
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
# Verify: git commit thử -> hook chạy + chặn file có trailing whitespace
```

```bash
# Quét secret trước commit (chạy tay khi chưa có hook)
gitleaks protect --staged --verbose
# Verify: ra "No leaks found" hoặc list đúng dòng dính secret
```

**Ví dụ cụ thể:** dev vô tình `export STRIPE_KEY=sk-live...` vào `.env.example` → `gitleaks protect --staged` chặn commit + chỉ đúng dòng.

> **Khi nào áp dụng:** setup repo mới (cùng đợt copy `templates/`), và bắt buộc cho repo có secret/thanh toán.

> **Nếu vẫn lỗi thì...** (1) kiểm `pre-commit install` đã chạy chưa; (2) chạy tay `gitleaks protect --staged --verbose` xem hook có bắt; (3) nếu hook local đã pass mà vẫn muốn chặn tuyệt đối thì bật push protection (câu 5); (4) dán log hook khi nhờ admin.

---

## 4. Branch protection: chặn push main + ép review thế nào?

> **Hỏi ngắn gọn:** _Branch protection: chặn push main + ép review thế nào?_

**Trả lời 1 câu:** Tạo ruleset `protect-main` ở `Repo → Settings → Rules → Rulesets` — require PR + status checks + block force push.

**Giải thích chi tiết + ví dụ:** Vào `Repo → Settings → Rules → Rulesets → New ruleset`: target `main`, bật:

- **Require pull request:** ít nhất 1 reviewer, dismiss stale approvals.
- **Require status checks:** CI xanh mới merge được.
- **Block force pushes + deletions:** chống mất history.
- (Nâng cao) **Require Copilot code review** (xem [bài 10](10-ci-sdk-review-web.md)).

**Vì sao quan trọng?** Đây là lớp "law" thật sự: dù agent hay người, muốn vào `main` đều phải qua PR + CI xanh. Nó không phụ thuộc model có "nhớ" luật hay không.

### Làm thế nào (steps copy-paste)

```bash
# Tạo ruleset bằng gh CLI (thay <OWNER>/<REPO>)
gh api repos/<OWNER>/<REPO>/rulesets -X POST -f name='protect-main' \
  -f enforcement='active' -f target='branch' \
  --raw-field 'conditions={ "ref_name": { "include": ["refs/heads/main"], "exclude": [] } }' \
  --raw-field 'rules=[{"type":"deletion"},{"type":"non_fast_forward"},{"type":"pull_request","parameters":{"required_approving_review_count":1,"dismiss_stale_reviews_on_push":true}}]'
# Verify: gh api repos/<OWNER>/<REPO>/rulesets ra list có protect-main

# Kiểm tra ruleset hiện có
gh api repos/<OWNER>/<REPO>/rulesets --jq '.[].name'
```

**Ví dụ cụ thể:** ruleset `protect-main` + required check `ci` → agent hay người đều không push/merge bừa được; muốn merge phải qua PR xanh.

> **Khi nào áp dụng:** mọi repo team >1 người — dựng trước khi onboarding Copilot coding agent (nó cũng phải tuân ruleset).

> **Nếu vẫn lỗi thì...** (1) kiểm bạn có quyền admin trên repo; (2) đọc lại payload `rules` xem `target`/`conditions` có đúng branch; (3) nếu API trả lỗi, dán response khi mở issue; (4) hỏi org owner vì ruleset org-level có thể đè.

---

## 5. Secret scanning + push protection bật thế nào?

> **Hỏi ngắn gọn:** _Secret scanning + push protection bật thế nào?_

**Trả lời 1 câu:** Bật ở `Repo/Org → Settings → Code security → Secret scanning + Push protection`; khi lỡ commit secret thì xoay key NGAY rồi mới xóa.

**Giải thích chi tiết + ví dụ:** 2 tính năng GitHub (Business/Enterprise có full):

- **Secret scanning:** quét repo tìm secret đã lộ → báo alert trong `Security → Secret scanning`.
- **Push protection:** chặn ngay lúc `git push` nếu phát hiện secret (hiện thông báo + link bypass có lý do).

Bật ở `Repo/Org → Settings → Code security → Secret scanning + Push protection`.

| Tính năng | Phát hiện/chặn khi nào | Chặn ở đâu | Khi nào dùng |
|---|---|---|---|
| Secret scanning | Quét repo tìm secret đã lộ | GitHub server (alert) | Bật mặc định mọi repo |
| Push protection | Chặn ngay lúc `git push` | GitHub server | Bật cùng secret scanning |

**Vì sao quan trọng?** Secret lộ một lần là phải rotate; chặn ngay ở cổng push rẻ hơn nhiều so với dọn hậu quả sau khi nó đã nằm trong history và các bản clone.

### Làm thế nào (steps copy-paste)

```bash
# Kiểm tra alerts secret đã lộ
gh api repos/<OWNER>/<REPO>/secret-scanning/alerts --jq '.[] | {number, secret_type, state}'
# Verify: list alert, state "open" = còn secret lộ

# Test push protection (trong repo thử nghiệm, KHÔNG làm ở prod):
echo "fake" | git commit --allow-empty -m test -q  # không liên quan; push protection tự chạy khi push
```

```bash
# Nếu lỡ commit secret: xoay key NGAY rồi mới xóa history
# 1. Revoke/rotate key trên dashboard provider
# 2. Xóa file + push (history vẫn còn -> cần rotate là chính)
git rm --cached secrets/leaked.key && git commit -m "chore: remove leaked secret"
# Verify: git log -p -- secrets/leaked.key không còn (đã xóa khỏi HEAD, history cũ vẫn còn -> rotate là chính)
```

**Ví dụ cụ thể:** push dính `ghp_...` → GitHub chặn + báo "Push blocked" → xóa key khỏi code → `git commit --amend` → push lại.

> **Khi nào áp dụng:** bật mặc định mọi repo; khi bị chặn push thì đọc kỹ thông báo (nó chỉ đúng file:dòng).

> **Nếu vẫn lỗi thì...** (1) xác nhận tính năng có trên plan (Business/Enterprise full); (2) đọc kỹ thông báo block — nó chỉ đúng file:dòng; (3) rotate key trước khi xóa; (4) hỏi admin nếu repo/org đã tắt tính năng.

---

## 6. Ép conventional commits / lint trước khi agent commit?

> **Hỏi ngắn gọn:** _Ép conventional commits / lint trước khi agent commit?_

**Trả lời 1 câu:** Kết hợp commitlint hook local + status check CI — commit sai thì hook chặn ngay, lọt qua thì PR không merge được.

**Giải thích chi tiết + ví dụ:** Kết hợp: **commitlint hook local** + **status check CI**. Agent tạo commit message sai → hook local sửa/báo ngay; lọt qua local → CI check đỏ, PR không merge được.

| Cơ chế | Chặn ở đâu | Tốc độ báo | Khi nào dùng |
|---|---|---|---|
| commitlint hook local | Local | Ngay khi commit | Mọi repo dùng conventional commits |
| Status check CI | GitHub server (PR) | Sau khi push/PR | Ép cả người lẫn agent trước merge |

**Vì sao quan trọng?** Agent và người thường commit theo thói quen khác nhau; nếu không có một chuẩn chung được ép tự động, git log sẽ loạn và việc sinh changelog/release trở nên khó.

### Làm thế nào (steps copy-paste)

```bash
# Thêm commitlint vào pre-commit (đoạn thêm vào .pre-commit-config.yaml)
cat >> .pre-commit-config.yaml <<'YAML'
  - repo: https://github.com/alorents/commitlint
    rev: v1.0.0
    hooks:
      - id: commitlint
        stages: [commit-msg]
YAML
```

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

**Ví dụ cụ thể:** agent commit `fix stuff` → commitlint chặn → agent tự sửa thành `fix(auth): handle expired session` → commit qua.

> **Khi nào áp dụng:** khi log git của team loạn do agent + người commit kiểu khác nhau.

> **Nếu vẫn lỗi thì...** (1) chạy `git commit` thử xem commitlint có bắt; (2) kiểm `stages: [commit-msg]`; (3) nếu local pass mà CI đỏ thì xem status check đã được bắt buộc trong ruleset chưa; (4) đọc log CI khi nhờ admin.

---

## 7. Giới hạn coding agent: chỉ cho nó đụng repo/branch nào?

> **Hỏi ngắn gọn:** _Giới hạn coding agent: chỉ cho nó đụng repo/branch nào?_

**Trả lời 1 câu:** Admin (Enterprise) cấu hình ở org policy; dev tôn trọng bằng cách ghi rõ repo + branch trong prompt/issue.

**Giải thích chi tiết + ví dụ:** Admin (Enterprise) cấu hình ở org policy: coding agent bật cho repo nào, chạy trên branch nào, có tự tạo PR không. Dev thường: tôn trọng bằng cách assign task đúng repo + ghi rõ branch trong prompt/issue.

**Vì sao quan trọng?** Coding agent chạy trên cloud, ngoài tầm mắt bạn. Giới hạn phạm vi ở org policy (admin) và ghi rõ scope trong issue (dev) là hai lớp giữ cho nó chỉ động vào đúng chỗ.

### Làm thế nào (steps copy-paste)

```bash
# Khi giao việc cho coding agent (trong issue), ghi rõ phạm vi:
# "Repo: acme/api. Branch base: develop (KHÔNG phải main).
#  Chỉ sửa src/payments/**. Không đụng infra/."
# Verify: agent tạo PR đúng repo + đúng branch, không lan ra ngoài
```

**Ví dụ cụ thể:** org có 50 repo, chỉ bật agent cho 5 repo pilot → member repo khác assign task cho agent sẽ báo "not enabled" → đúng ý admin.

> **Khi nào áp dụng:** khi mở rộng coding agent từ pilot ra toàn org — mở từng đợt + ruleset đi kèm.

> **Nếu vẫn lỗi thì...** (1) ghi rõ repo + branch base trong issue; (2) kiểm agent có được bật cho repo đó không; (3) nếu báo "not enabled" thì hỏi admin mở pilot; (4) đọc PR của agent xem nó có lan ra ngoài scope.

---

## 8. Audit: biết ai/agent đã làm gì?

> **Hỏi ngắn gọn:** _Audit: biết ai/agent đã làm gì?_

**Trả lời 1 câu:** 3 nguồn: `git log` (commit agent có `Co-authored-by`), `Org audit log` (ai bật/tắt policy), PR timeline (agent ghi comment từng bước).

**Giải thích chi tiết + ví dụ:** 3 nguồn log:

- **Git history:** `git log` — commit của agent thường có `Co-authored-by: Copilot` hoặc author bot.
- **GitHub audit log (org):** `Org → Settings → Audit log` — ai bật/tắt policy, ai assign seat.
- **PR timeline:** coding agent ghi comment từng bước (plan → changes → test results).

| Nguồn | Xem ở đâu | Trả lời câu hỏi gì | Khi nào dùng |
|---|---|---|---|
| Git history | `git log` | Ai/agent commit gì | Truy vết thay đổi code |
| GitHub audit log (org) | `Org → Settings → Audit log` | Ai bật/tắt policy, assign seat | Compliance org |
| PR timeline | PR comments | Agent đã làm gì theo bước | Review PR agent |

**Vì sao quan trọng?** Khi có sự cố, "thay đổi này từ đâu ra" phải trả lời được bằng log chứ không bằng phỏng đoán — nhất là khi thủ phạm có thể là một agent không ngồi cạnh bạn.

### Làm thế nào (steps copy-paste)

```bash
# Tìm commit do agent tạo
git log --oneline --grep -i "copilot" -20
git log --format='%h %an %s' -20 | grep -i "bot\|copilot"
# Verify: list commit + author, "bot/copilot" = do agent tạo

# Audit log org qua API (cần admin)
gh api orgs/<ORG>/audit-log --jq '.[] | {action, actor, created_at}' | head -20
# Verify: list hành động, actor = ai + action = việc gì
```

**Ví dụ cụ thể:** PR lỗi không rõ ai sửa → `git log` thấy 3 commit `Co-authored-by: Copilot` → đọc PR timeline comment tương ứng để biết agent đã làm gì.

> **Khi nào áp dụng:** postmortem, review PR agent, và khi compliance hỏi "thay đổi này từ đâu ra".

> **Nếu vẫn lỗi thì...** (1) thử lọc theo path/file; (2) kiểm tên actor của bot; (3) nếu audit log trống thì có thể bạn thiếu quyền admin/org; (4) hỏi admin xuất log.

---

## 9. Guardrail cho lệnh nguy hiểm trong CI (không dangerously-skip)?

> **Hỏi ngắn gọn:** _Guardrail cho lệnh nguy hiểm trong CI (không dangerously-skip)?_

**Trả lời 1 câu:** Secrets qua `${{ secrets.* }}` → env, KHÔNG `echo` secret, KHÔNG skip-verification flag; job đụng prod dùng `environment:` + required reviewers.

**Giải thích chi tiết + ví dụ:** Workflow gọi Copilot CLI phải: secrets qua `${{ secrets }}` (cụ thể `${{ secrets.* }}`) → env, KHÔNG `echo` secret, KHÔNG dùng flag skip-verification/bypass. Dùng `environment:` + required reviewers cho job đụng prod (xem mẫu `templates/.github/workflows/`).

**Vì sao quan trọng?** CI là nơi có sẵn token/quyền, nên một dòng `echo` secret hay một flag bypass là đủ để lộ credential hoặc bỏ qua toàn bộ cổng kiểm. Đây là nơi guardrail phải chặt nhất.

### Làm thế nào (steps copy-paste)

```yaml
# Mẫu đúng (trích templates/.github/workflows/copilot-review.yml)
jobs:
  review:
    runs-on: ubuntu-latest
    environment: review  # ép approval nếu đụng prod
    steps:
      - uses: actions/checkout@v4
      - env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}  # nếu CLI cần
        run: gh copilot suggest "summarize changes" --no-interactive || true
```

**Ví dụ cụ thể:** workflow triage issue → chỉ đọc issue + comment gợi ý, không có quyền push (dùng `GITHUB_TOKEN` read-only + không checkout write).

> **Khi nào áp dụng:** mọi workflow có Copilot CLI — review quyền `permissions:` tối thiểu trước khi merge workflow.

> **Nếu vẫn lỗi thì...** (1) rà lại `permissions:` tối thiểu; (2) xác nhận secrets đi qua `${{ secrets.* }}` chứ không bị echo; (3) job prod phải có `environment:` + required reviewers; (4) dán log workflow khi nhờ review.

---

## 10. Checklist guardrails cho repo mới (5 phút)?

> **Hỏi ngắn gọn:** _Checklist guardrails cho repo mới (5 phút)?_

**Trả lời 1 câu:** 6 tick: exclusion paths, Rules block, ruleset bảo vệ `main`, secret scanning bật, CI lint/test, `mcp.json` không hardcode.

**Giải thích chi tiết + ví dụ:** Chạy checklist này sau khi copy `templates/`:

1. [ ] `.vscode/settings.json` có exclusion paths.
2. [ ] `copilot-instructions.md` có block Rules ALWAYS/NEVER.
3. [ ] Ruleset bảo vệ `main` (block force push + require PR).
4. [ ] Secret scanning + push protection bật.
5. [ ] CI lint/test chạy trên PR (status check).
6. [ ] `mcp.json` không hardcode secret.

**Vì sao quan trọng?** Đây là definition-of-done trước khi bật coding agent: thiếu một tick nào là mở một đường cho agent (hoặc người) lách qua guardrail.

### Làm thế nào (steps copy-paste)

```bash
# Script check nhanh (đứng ở root repo)
ls .github/copilot-instructions.md .vscode/settings.json .vscode/mcp.json
grep -rn "ghp_\|sk-live\|xoxb-" .vscode/ .github/ 2>/dev/null && echo "CO SECRET HARDCODE!" || echo "secrets OK"
gh api repos/<OWNER>/<REPO>/rulesets --jq '.[].name'
# Verify: đủ 3 file + "secrets OK" + list ruleset có protect-main
```

**Ví dụ cụ thể:** chạy script trên cho repo mới → thấy thiếu ruleset → tạo theo câu 4 → đủ 6 tick mới onboarding team.

> **Khi nào áp dụng:** definition-of-done cho mọi repo mới trước khi bật coding agent.

> **Nếu vẫn lỗi thì...** (1) chạy lại script check; (2) đối chiếu 6 tick còn thiếu; (3) mỗi tick thiếu trỏ về câu tương ứng ở trên; (4) hoàn tất đủ 6 mới onboarding team.

---

## Vẫn lỗi thì sao? (thứ tự debug chuẩn)

5 bước check khi mọi layer guardrail không ăn:

1. Instruction sai chỗ/sai glob? (`ls .github/`, xem [bài 06](06-prompts-agents-instructions.md)).
2. Quy tắc viết mơ hồ? → viết lại ALWAYS/NEVER + path cụ thể.
3. Hook local đã `pre-commit install` chưa.
4. Ruleset/push protection chặn? → đọc thông báo chặn (nó nói rõ lý do).
5. Vẫn lọt → nâng từ "khuyến nghị" lên "ép buộc server-side" (ruleset + required checks).

---

## So sánh với Claude Code

Cả hai đều cho chèn hook vào giữa vòng chạy tool, nhưng độ "cứng" và nơi đặt guardrail khác nhau. Bảng này chỉ so những điểm chắc chắn.

| Việc | Copilot | Claude Code | Ghi chú |
|---|---|---|---|
| Hook chặn tool call in-process | `.github/hooks/*.json`, events `PreToolUse`/`PostToolUse`... | Hooks in-process (PreToolUse/PostToolUse) | Cùng ý tưởng: chen vào giữa tool call |
| Độ chín của hook | **Preview, chỉ chạy Local**, tôn trọng allow/ask/deny, dev sửa được file hook | Hook đã có trong tài liệu chính thức | Copilot semi-law vì config dev giữ; **chưa phải security boundary** |
| Pre-commit / linter | Git hook local, chạy ngoài model | Cũng là git hook local, chạy ngoài model | Giống nhau: hook không phụ thuộc model |
| Instructions kiểu cấm | `copilot-instructions.md` + `*.instructions.md` | `CLAUDE.md` + `.claude/` | Cả hai: file trong repo là "luật mềm" |
| Lớp server (branch protection, push protection, required reviewers) | Có sẵn trên GitHub | Không có tầng tương đương trực tiếp — phải mượn platform của bạn | Đây là cách Copilot biến rule thành "law" |

> **Đọc bảng này thế nào:** phần "hooks" gần như tương đương về ý tưởng, nhưng Copilot hooks vẫn ở chế độ **preview + Local-only** nên đừng coi nó là security boundary. Lợi thế lớn của Copilot là có **lớp server GitHub** (branch protection, push protection, review gate) để biến rule thành law — Claude Code không có tầng đó, phải mượn platform của bạn.

---

## Best practices (kèm "Vì sao?")

- **Cái gì chỉ nên nhắc thì để instructions, cái gì tuyệt đối không được phạm thì khóa ở server.** *Vì sao?* Instructions có thể bị cắt khi context dài; chỉ ruleset/push protection mới là thứ không ai override được.
- **Viết câu cấm kèm path/lệnh cụ thể.** *Vì sao?* "Cẩn thận" không kiểm chứng được; "NEVER sửa `db/migrations/**`" mới có ranh giới để tuân.
- **Đừng coi hooks in-process là security boundary.** *Vì sao?* Nó mới ở preview, chỉ chạy Local, dev sửa được file hook, và model còn xin chạy ngoài được.
- **Pre-commit chỉ lint staged files, đúng ext.** *Vì sao?* Lint cả repo làm mỗi commit chậm hơn 5 giây — dev sẽ tìm cách tắt hook và bạn mất luôn lớp bảo vệ.
- **Bật push protection + secret scanning mặc định mọi repo.** *Vì sao?* Secret lộ một lần là phải rotate; chặn ngay ở cổng push rẻ hơn dọn hậu quả.
- **Lỡ commit secret thì rotate trước, xóa history sau.** *Vì sao?* Xóa commit không rút token khỏi fork/clone đã có — token vẫn còn sống ở nơi khác.
- **Dựng ruleset bảo vệ `main` trước khi onboarding coding agent.** *Vì sao?* Agent cũng phải tuân ruleset; dựng sau nghĩa là lúc đầu nó có thể đẩy thẳng main.

---

## Tham khảo chéo

- Instructions viết đúng: [bài 06](06-prompts-agents-instructions.md). Content exclusion: [bài 03](03-modes-permissions.md).
- Secrets + audit sâu: [bài 09](09-bao-mat-quyen-rieng-tu.md). CI workflows mẫu: [bài 10](10-ci-sdk-review-web.md) + [../templates/README.md](../templates/README.md).

> Cái gì chỉ nên là lời nhắc thì để trong instructions; cái gì tuyệt đối không được phạm thì phải khóa ở server — bạn không thể mặc cả với một lớp server bằng một câu prompt.
