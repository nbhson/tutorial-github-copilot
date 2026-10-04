# 15 — Security Stack 5 Tầng Cho Copilot (Defense-in-Depth, Không Tin 1 Lớp Nào)

> Bài 15 series 01. Đọc xong bạn dựng được 5 tầng phòng thủ cho Copilot: content
> exclusion + duplication detection, secret scanning + push protection, code
> scanning (CodeQL), Copilot code review gate, và policy/audit. Thời gian: ~45 phút.

## Mục lục

1. [Vì sao 5 tầng? (why)](#1-vì-sao-5-tầng-why)
2. [Bản đồ 5 tầng (nhìn 1 phút hiểu hết)](#2-bản-đồ-5-tầng-nhìn-1-phút-hiểu-hết)
3. [Tầng 1 — Exclusion + duplication detection (copy-paste)](#3-tầng-1--exclusion--duplication-detection-copy-paste)
4. [Tầng 2 — Secret scanning + push protection](#4-tầng-2--secret-scanning--push-protection)
5. [Tầng 3 — Code scanning + CodeQL](#5-tầng-3--code-scanning--codeql)
6. [Tầng 4 — Copilot code review gate](#6-tầng-4--copilot-code-review-gate)
7. [Tầng 5 — Policy + audit (khóa cửa)](#7-tầng-5--policy--audit-khóa-cửa)
8. [Walkthrough end-to-end (20 phút)](#8-walkthrough-end-to-end-20-phút)
9. [Pitfalls + fix](#9-pitfalls--fix)
10. [Bài tập](#10-bài-tập)
11. [Link chéo](#11-link-chéo)

---

## 1. Vì sao 5 tầng? (why)

1 lớp bảo mật luôn có lỗ: exclusion cấu hình sai 1 path là secret lọt vào index;
secret scanning bỏ sót format lạ; CodeQL không bắt logic sai; review người thì
mệt bỏ qua; policy không audit thì trang trí. Defense-in-depth = lớp này trượt thì
lớp sau đỡ:

```text
Không stack:  Copilot đọc .env → gợi ý key vào code → push lên GitHub → lộ 6 tháng mới biết
Có stack:    T1 chặn .env khỏi index → trượt? T2 push protection chặn push →
             trượt? T3 CodeQL gắn flag → trượt? T4 reviewer thấy → trượt? T5 audit truy ra
```

> Quy tắc: **không tin bất kỳ 1 tầng nào. Mỗi incident phải trả lời "tầng nào
> trượt + tầng nào đỡ + vá tầng trượt thế nào".**

---

## 2. Bản đồ 5 tầng (nhìn 1 phút hiểu hết)

| Tầng | Chặn gì | Ở đâu | Ai sở hữu |
|---|---|---|---|
| **1. Exclusion + duplication** | Copilot đọc file nhạy cảm; gợi ý copy code có license | Copilot settings (org/repo) | Admin + team lead |
| **2. Secret scanning + push protection** | Key/token lọt vào repo | GitHub Advanced Security | Admin (bật), dev (fix alert) |
| **3. Code scanning (CodeQL)** | Lỗ hổng (SQLi, XSS, path traversal...) | PR checks + `github/codeql` | Team (fix), CI (chặn) |
| **4. Copilot code review gate** | Bug/logic mà máy + mắt người sót | PR review + required checks | Reviewer + maintainer |
| **5. Policy + audit** | Ai đổi 4 tầng trên, ai dùng gì | Org policy + audit log | Admin |

```text
# Dòng chảy 1 PR an toàn (5 tầng đi qua):
# T1: Copilot không đọc secrets khi gợi ý → T2: push không mang key →
# T3: CodeQL quét xong xanh → T4: review (người + Copilot) approve →
# T5: mọi bước ghi audit log. Thiếu 1 tầng là mù 1 mắt.
```

---

## 3. Tầng 1 — Exclusion + duplication detection (copy-paste)

### 3.1. Content exclusion: Copilot không được thấy gì

```text
# Checklist admin (github.com → Org Settings → Copilot → Content exclusion):
[ ] **/.env* (mọi biến thể: .env.local, .env.prod...)
[ ] **/secrets/**, **/*.pem, **/*.key, **/*credentials*
[ ] **/migrations/*seed* (data thật), dumps/*.sql
[ ] vendor/, dist/, *.min.js (nhiễu, không phải secret nhưng loại cho sạch index)
[ ] Repo payments/auth: exclude cả thư mục chứa HSM/cert configs
```

```bash
# Verify exclusion sống (dev làm 1 lần, 2 phút):
# Chat: "@workspace tìm chuỗi STRIPE_KEY trong repo?"
# → kỳ vọng: "không thấy / excluded". Thấy được key thật → báo admin NGAY.
git check-ignore -v .env .env.prod secrets/ 2>/dev/null
# → phải ignored (exclusion + gitignore song kiếm, thiếu 1 là hở 1 đường)
```

```bash
# .gitignore tối thiểu song hành exclusion (repo, commit — copy-paste khung):
# .env*
# secrets/
# *.pem
# *.key
# dumps/
git status --porcelain | grep -E "env|pem|key|secrets" || echo "sach: khong file nhay cam staged"
# → có hit là dừng lại, unstage trước khi commit
```

### 3.2. Duplication detection: không copy code người ta vào repo bạn

```text
# Bật: Org Settings → Copilot → Policies → Suggestions matching public code:
#   - Block (khuyến nghị team closed-source): chặn gợi ý trùng public code
#   - Allow: cho phép nhưng gắn cảnh báo (team open-source ok)
# Hỏi admin team bạn đang để Block hay Allow — đừng đoán.
```

```bash
# Khi Copilot báo "matching public code" (đừng click accept mù):
# 1. Đọc reference URL nó đưa (code gốc license gì? GPL → cân nhắc kỹ).
# 2. Viết lại theo style repo bạn (đừng paste y nguyên).
# 3. Thêm comment nguồn nếu giữ ý tưởng: "# adapted from <url> (MIT)".
```

---

## 4. Tầng 2 — Secret scanning + push protection

### 4.1. Bật 2 công tắc (admin, 5 phút)

```text
# github.com → Org/Repo Settings → Code security → bật cả 2:
[ ] Secret scanning: quét repo (quá khứ + tương lai), alerts về Security tab
[ ] Push protection: chặn NGAY lúc push nếu phát hiện secret (đỡ hơn fix sau)
# Thứ tự ưu tiên: push protection trước (chặn mới), secret scanning sau (quét cũ).
```

### 4.2. Dev workflow khi bị chặn/fix alert (copy-paste)

```bash
# Ca A — push bị chặn (push protection): ĐỪNG bypass, fix đúng:
# 1. Đọc thông báo: loại secret gì, file nào, dòng nào
git diff --cached -- <file-bi-chan>
# 2. Xoá secret khỏi code → chuyển sang env/secrets manager:
#    code đọc process.env.STRIPE_KEY (không hardcode "sk-live-...")
# 3. Commit lại + push lại (protection pass là xong)

# Ca B — secret đã lọt (alert trong Security tab):
# 1. REVOKE key đó NGAY (Stripe/GitHub/AWS dashboard) — trước khi xoá code
# 2. Xoá khỏi history nếu cần (BFG/trợ giúp admin), rồi push fix
# 3. Đánh dấu alert resolved + ghi lý do (audit cần, mục 7)
```

```bash
# Phòng bệnh local: quét trước khi push (pre-commit hook khung):
# .git/hooks/pre-commit (chmod +x):
#!/bin/sh
git diff --cached --name-only | xargs grep -n -i -E "sk-live|ghp_|AKIA|xoxb-|-----BEGIN .*PRIVATE KEY" && {
  echo "BLOCKED: nghi secret staged — doi sang env truoc khi commit"; exit 1; }
echo "pre-commit secrets: sach"
```

---

## 5. Tầng 3 — Code scanning + CodeQL

### 5.1. Bật CodeQL default setup (5 phút, hiệu quả/giờ cao nhất)

```text
# github.com → Repo Settings → Code security → Code scanning → Set up →
#   Default setup → chọn query suite Extended (team payments/auth) hoặc
#   Default (team khác) → Create. PR sau tự có check "CodeQL".
```

```yaml
# Nâng cao: variant custom khi default chưa đủ (team payments — khung):
# .github/workflows/codeql.yml (codeql-action init + analyze cho js/ts + python):
# jobs.analyze.strategy.matrix.language: ['javascript-typescript', 'python']
# on: [pull_request, push (main), schedule: weekly] — weekly bắt debt cũ
```

### 5.2. Đọc + fix alert đúng cách (dev, copy-paste prompt)

```text
# Prompt fix CodeQL alert (paste alert message vào chat):
"CodeQL báo <dán alert: vd 'SQL query built from user input'> tại file X dòng Y.
Giải thích lỗ hổng 3 dòng, sửa bằng parameterized query, giữ behavior cũ,
không đổi signature hàm public."

# Quy tắc fix:
# - Fix ROOT (validate/escape/parameterize), không suppress alert cho qua.
# - Suppress (dismiss) chỉ khi: false positive CHỨNG MINH được + ghi lý do + reviewer đồng ý.
# - Alert severity high/critical: fix trước khi merge, không "để sprint sau".
```

```bash
# Verify fix local trước khi đẩy PR (đừng chờ CI 10 phút mới biết):
npm run lint && npm run typecheck 2>/dev/null || npx tsc --noEmit
# → xanh local rồi mới push (CodeQL CI là lưới cuối, không phải lưới đầu)
```

---

## 6. Tầng 4 — Copilot code review gate

### 6.1. Gắn review vào PR (2 lớp: máy + người)

```text
# Lớp máy — Copilot code review (github.com PR → Copilot review):
# - Bật: Repo Settings → Copilot code review → auto review mỗi PR (team mới nên bật)
# - Đọc review như junior nhiệt tình: đúng 70%, bịa 30% → verify từng comment.

# Lớp người — required reviewers + checks (Repo Settings → Branch protection):
[ ] Require pull request review (≥1 approve, team payments ≥2)
[ ] Require status checks: CodeQL + tests + secret scanning đều pass
[ ] Dismiss stale approvals khi push mới (đừng approve bản cũ, merge bản mới)
```

### 6.2. Prompt review sâu cho PR nhạy cảm (copy-paste 3 mẫu)

```text
# Mẫu 1 — review bảo mật (route payments/auth):
"Review PR này theo góc bảo mật: input validation, auth checks, secrets handling,
SQL/NoSQL injection, XSS, IDOR. Mỗi finding: severity + file:dòng + fix gợi ý."

# Mẫu 2 — review logic (mọi PR multi-file):
"Review logic PR này: edge cases nào thiếu? error paths nào nuốt lỗi?
Behavior change nào không có trong PR description?"

# Mẫu 3 — đối chiếu Copilot review:
"Copilot review báo <dán comments>. Cái nào đúng/sai/false-positive?
Với cái đúng, sửa theo fix gợi ý; sai thì ghi lý do bác."
```

```bash
# Gate cuối trước merge (reviewer chạy 1 phút):
git diff --stat main...HEAD
# → files đổi có chạm secrets/payments/auth không? (có → review kỹ gấp đôi)
# Checks: CodeQL xanh? tests xanh? Copilot review đã đọc hết? (thiếu 1 → chưa merge)
```

---

## 7. Tầng 5 — Policy + audit (khóa cửa)

### 7.1. Policy checklist (admin, rà hàng quý)

```text
# github.com → Org/Enterprise Settings → Copilot + Code security:
[ ] Content exclusion còn đúng paths? (repo mới thêm có được cover?)
[ ] Model allowlist còn hợp lý? (bài 14 — flagship ai được dùng)
[ ] Duplication detection: Block hay Allow? (đúng ý legal chưa?)
[ ] Push protection + secret scanning: ON cho MỌI repo (không sót repo mới)
[ ] CodeQL: default setup cho MỌI repo (repo nào đỏ mãn tính → tech debt ticket)
[ ] Branch protection main: reviews + checks bắt buộc (không repo nào merge thẳng)
```

### 7.2. Audit log: ai đổi gì (truy incident + rà định kỳ)

```bash
# Xem: github.com → Org/Enterprise Settings → Audit log. Filters dùng nhiều:
# action:copilot_policy   → ai đổi exclusion/model policy
# action:secret_scanning  → ai dismiss alert (dismiss bừa là red flag)
# action:code_scanning    → ai dismiss CodeQL
# action:repo.policy      → ai nới branch protection

# Export rà quý (admin):
gh api /orgs/<ORG>/audit-log --paginate -f per_page=100 \
  -f phrase="action:copilot_policy OR action:secret_scanning" \
  --jq '.[] | [.actor, .action, .created_at] | @tsv' > /tmp/sec-audit.tsv
# → pivot: ai dismiss nhiều nhất? policy đổi lúc nửa đêm? (hỏi 1 câu là ra chuyện)
```

```text
# Vòng lặp quý (calendar block 30 phút, admin + tech lead):
# 1. Audit dismiss: secret/CodeQL dismiss nào thiếu lý do? (10 phút)
# 2. Exclusion drift: repo mới/thư mục mới chưa cover? (10 phút)
# 3. Vá 1 tầng yếu nhất quý này (10 phút — ghi team log, bài 13 mục 7.3 cùng nhịp)
```

---

## 8. Walkthrough end-to-end (20 phút)

**Phút 0–5 (tầng 1 — verify exclusion sống):**

```bash
git status --porcelain | grep -E "env|pem|key|secrets" || echo "sach"
# Chat: "@workspace tìm STRIPE_KEY trong repo?" → phải không thấy
# Hỏi admin: duplication detection team đang Block hay Allow?
```

**Phút 5–10 (tầng 2 — push protection thử lửa):**

```bash
# Thử an toàn: tạo file tạm chứa fake key, stage, commit → protection phải chặn/báo
echo 'STRIPE_KEY=sk-live-FAKEKEY123' > /tmp/fake.env && cp /tmp/fake.env ./fake-test.env
git add fake-test.env && git commit -m "test push protection" || echo "chan la DUNG"
git reset HEAD fake-test.env; rm fake-test.env /tmp/fake.env
# → bị chặn = tầng 2 sống. Không chặn → báo admin kiểm tra config
```

**Phút 10–15 (tầng 3+4 — 1 PR mẫu):**

```text
# Mở 1 PR nhỏ → xem: CodeQL check chạy? Copilot review comment?
# Paste 1 alert (hoặc giả định) vào prompt mẫu 5.2/6.2 → đánh giá fix gợi ý.
# Reviewer check: branch protection có đòi đủ checks? (mục 6.1)
```

**Phút 15–20 (tầng 5 — audit 1 dòng):**

```bash
# Mở audit log filter action:copilot_policy → ai đổi lần cuối, khi nào?
# Ghi team log 1 dòng: "5 tầng: T1 ok / T2 ok / T3 _ / T4 _ / T5 _" (điền _ sau khi check)
```

---

## 9. Pitfalls + fix

| Pitfall | Vì sao | Fix |
|---|---|---|
| Exclude cả `src/` nhầm | Retrieve/index rỗng, team tắt luôn exclusion | Paths tối thiểu (mục 3.1), verify bằng câu hỏi `.env` |
| Bypass push protection cho nhanh | Secret lọt, revoke + xoá history tốn 10x | Không bypass; chuyển env rồi push lại (mục 4.2) |
| Dismiss secret/CodeQL bừa | Lỗ hổng sống trong main, audit đỏ | Dismiss cần lý do + reviewer đồng ý, rà quý (mục 7.2) |
| Tin Copilot review 100% | Nó bịa 30%, merge bug tưởng đã review | Đối chiếu mẫu 6.2: đúng thì sửa, sai ghi lý do bác |
| CodeQL default rồi quên | Debt cũ tích, alert mới chìm trong cũ | Schedule weekly + ticket debt, high/critical fix trước merge |
| Repo mới không cover policy | Exclusion/CodeQL sót, hở từ ngày đầu | Checklist new-repo: 5 tầng on trước commit đầu (bài tập 3) |
| Audit log không ai đọc | Incident không truy được, dismiss bừa không ai biết | Rà quý 30 phút + vòng 15 phút/tuần cùng nhịp bài 13 |

---

## 10. Bài tập

**Bài 1 (15 phút — tầng 1+2):**

1. Chạy verify exclusion (mục 3.1) + pre-commit hook mẫu (mục 4.2) trên repo bạn.
2. Thử lửa push protection bằng fake key (mục 8) — ghi pass/block.
3. Hỏi admin duplication mode team (Block/Allow) — có đúng ý legal không?

**Bài 2 (20 phút — tầng 3+4):**

1. Mở Security tab repo bạn: còn alerts secret/CodeQL nào unresolved? Liệt kê theo severity.
2. Lấy 1 alert → fix bằng prompt mẫu 5.2 → verify lint/typecheck local.
3. Mở 1 PR → Copilot review có comment? Dùng mẫu 6.2 phân loại đúng/sai.

**Bài 3 (15 phút — tầng 5 + new-repo checklist):**

1. Audit log filter 3 actions (mục 7.2): policy đổi/dismiss lần cuối khi nào, ai?
2. Viết new-repo checklist 5 tầng cho team (dán wiki): repo mới phải on gì trước commit đầu?
3. Đặt calendar rà quý 30 phút (mục 7.3) + owner từng tầng.

> Đạt: chỉ ra được tầng nào của team đang yếu nhất bằng evidence (alerts/audit/
> thử lửa), và có new-repo checklist + lịch rà quý bằng văn bản.

---

## 11. Link chéo

- **Bài 03 — Instructions/Memory/Rules**: quy ước secrets (`chỉ đọc env`) viết vào
  instructions để Copilot không bao giờ hardcode key.
- **Bài 07 — Policies/guardrails**: content exclusion cấu hình chi tiết + ai được đổi.
- **Bài 10 — Modes/Permissions**: approval ask/deny cho terminal/MCP (gate lúc agent chạy).
- **Bài 11 — Git/worktrees/checkpoints**: review diff + undo trước khi accept agent edits.
- **Bài 12 — SDK/CI**: CodeQL + secret scan + tests làm required checks trong pipeline.
- **Bài 13 — Indexing & Telemetry**: exclusion ảnh hưởng index; dashboard theo dõi blocks.
- **Bài 14 — Models**: model allowlist là 1 phần policy tầng 5.
- **Bài 16 — Extensions/MCP validate**: tools ngoài có tuân thủ 5 tầng không?
