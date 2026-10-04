# FAQ 07 — Custom Agents & Coding Agent Workflows

> Nhóm Agent nâng cao · 10 câu hỏi deep-dive · Đọc xong hết agent loạn, coding agent PR sạch, không conflict

File này trả lời mọi câu hỏi "custom agent chạy loạn, coding agent conflict/PR fail". Mỗi câu có giải thích + lệnh copy-paste + ví dụ + khi nào áp dụng.

---

## Bảng tổng hợp: agent nào việc nào

| Agent | Việc | Tools cho phép |
|---|---|---|
| explorer | Trinh sát chỉ-đọc, vẽ bản đồ file | search (đọc) |
| tester | Chạy test focused, báo PASS/FAIL | terminal test + đọc log |
| security-reviewer | Soi auth/input/crypto/secrets | search + đọc diff |
| coding agent (GitHub) | Làm task từ issue, mở PR | full trong sandbox + ruleset |

---

## 1. Custom agent "chạy loạn" — nguyên nhân và cách trị?

**Giải thích.** "Loạn" = sửa file ngoài scope, chạy lệnh cấm, lặp vòng không xong. 3 nguyên nhân:

1. **Thiếu `tools` giới hạn** trong frontmatter → agent có full quyền.
2. **Thiếu ranh giới trong body:** không ghi "CHỈ đọc / KHÔNG sửa".
3. **Task quá to** → agent tự mở rộng scope để "cho xong".

Trị: khóa `tools` + 3 dòng ranh giới đầu body + chia task nhỏ.

**Lệnh copy-paste:**

```markdown
---
description: Trinh sát chỉ-đọc
tools: [search]
---
# Explorer — RANH GIỚI (đọc trước khi làm)
- CHỈ đọc file. KHÔNG sửa, KHÔNG chạy lệnh ghi, KHÔNG commit.
- Quá 10 file liên quan -> dừng, hỏi user chọn tiếp.
```

**Ví dụ:** explorer không giới hạn tự sửa luôn code → thêm block trên → từ đó chỉ trả bản đồ file.

**Khi nào áp dụng:** ngay khi tạo/sửa mọi `*.agent.md` — ranh giới viết trước procedure.

---

## 2. Bộ 3 explorer → làm → tester: workflow chuẩn?

**Giải thích.** Workflow 3 pha cho task >30 phút:

1. **Explorer:** "vẽ bản đồ" — file nào liên quan, thứ tự đọc, rủi ro.
2. **Làm (Edit/Agent):** sửa theo bản đồ, scope khóa theo list explorer.
3. **Tester:** chạy test focused + lint, báo PASS/FAIL + guess 1 dòng nếu đỏ.

Mỗi pha 1 chat (hoặc 1 agent call) để context gọn.

**Lệnh copy-paste:**

```bash
# Pha 1 (chat 1, agent explorer): "Vẽ bản đồ refactor login trong src/auth/, chưa sửa."
# Pha 2 (chat 2, edit/agent): "Sửa theo list: <paste list explorer>. Chỉ các file này."
# Pha 3 (chat 3 hoặc tester): "Chạy npm test -- auth + npm run lint, báo PASS/FAIL."
```

**Ví dụ:** refactor auth 8 file → explorer trả list 8 file + thứ tự → pha 2 sửa đúng 8 file → tester chạy test xanh → commit.

**Khi nào áp dụng:** mọi task multi-file. Task 1-2 file thì gộp pha 1+2.

---

## 3. Security-reviewer gọi khi nào, check gì?

**Giải thích.** Gọi khi diff chạm: **auth/session, input validation, crypto, thanh toán, secrets, permissions, SQL**. Checklist: injection (SQL/command), XSS, auth bypass, IDOR, secret lộ, crypto yếu, rate-limit.

Gọi sau pha làm, trước khi mở PR — reviewer này chỉ đọc + comment, không sửa.

**Lệnh copy-paste:**

```bash
# Lấy diff cho reviewer (trong chat attach hoặc paste stat)
git diff main...HEAD --stat
git diff main...HEAD -- src/auth/ | head -100
# Prompt: "Review security diff trên. Chỉ báo Critical/Major + dòng cụ thể + cách fix."
```

**Ví dụ:** PR thêm endpoint `/admin/export` → security-reviewer phát hiện thiếu check role → thêm middleware trước khi merge.

**Khi nào áp dụng:** auto-trigger (quy ước team): diff chạm `auth|payment|crypto|admin` → bắt buộc qua security-reviewer. Mẫu agent trong `templates/.github/agents/security-reviewer.agent.md`.

---

## 4. Coding agent trên GitHub là gì, giao việc thế nào?

**Giải thích.** Coding agent = agent chạy trên cloud GitHub, nhận việc từ **issue** (assign cho `copilot`), tự code + chạy test + mở PR. Bạn review PR như review người.

Giao việc chuẩn: issue mô tả **mục tiêu + phạm vi file + tiêu chí xong (acceptance criteria) + lệnh test**.

**Lệnh copy-paste:**

```markdown
<!-- Mẫu issue giao cho coding agent -->
## Mục tiêu
Thêm rate-limit 100 req/phút cho /api/login.

## Phạm vi
- Chỉ sửa: src/auth/**, tests/auth/**
- KHÔNG đụng: infra/, db/migrations/

## Xong khi
- [ ] npm test -- auth xanh
- [ ] Có test cho case vượt limit (expect 429)
- [ ] Mở PR về develop
```

**Ví dụ:** tạo issue trên → assign Copilot → 10-20 phút sau có PR → bạn review diff + CI (xem [bài 10](10-ci-sdk-review-web.md)).

**Khi nào áp dụng:** task rõ ràng, có test, scope hẹp — agent làm tốt. Task mơ hồ thì làm rõ issue trước.

---

## 5. Coding agent conflict / PR fail — xử lý sao?

**Giải thích.** 3 ca phổ biến:

1. **Conflict với main:** base branch trôi trong lúc agent làm → `gh` update branch hoặc bảo agent rebase.
2. **CI đỏ:** đọc log check đầu tiên đỏ → comment vào PR bảo agent fix ("fix `lint` job: ...").
3. **PR sai scope:** agent sửa lố → request changes liệt kê file cần revert, hoặc checkout PR về sửa tay.

**Lệnh copy-paste:**

```bash
# Xem PR của agent + trạng thái checks
gh pr view <NUM> --json title,state,mergeable,statusCheckRollup
gh pr checks <NUM>

# Update branch cho PR (giải conflict đơn giản)
gh pr checkout <NUM>
git fetch origin && git rebase origin/main
git push --force-with-lease
```

**Ví dụ:** PR agent CI đỏ job `test` → đọc log thấy thiếu import → comment trong PR: "@copilot thiếu import X ở file Y" → agent push fix.

**Khi nào áp dụng:** mọi PR agent — review như review junior: check scope + CI + test trước khi merge.

---

## 6. Viết issue thế nào để coding agent làm đúng ngay lần 1?

**Giải thích.** Công thức issue 5 phần: **Bối cảnh (1-2 câu) + Mục tiêu + Phạm vi file + Acceptance criteria + Lệnh verify.** Thiếu phần nào agent tự đoán phần đó — và đoán sai.

- Tốt: "Thêm 429 khi vượt 100 req/phút, chỉ src/auth/**, test expect 429, verify `npm test -- auth`."
- Dở: "Làm rate limit đi." (agent tự chọn lib, scope, không test)

**Lệnh copy-paste:**

```markdown
## Bối cảnh
Login đang bị brute-force, cần rate-limit.

## Mục tiêu
... (như câu 4)

## Lệnh verify
npm test -- auth && npm run lint
```

**Ví dụ:** issue viết đủ 5 phần → agent ra PR xanh lần 1 (tỉ lệ cao gấp 3 lần issue 1 dòng, theo kinh nghiệm team).

**Khi nào áp dụng:** trước khi assign — 5 phút viết issue kỹ đỡ 30 phút sửa PR.

---

## 7. Nhiều agents cùng làm 1 repo — tránh giẫm chân sao?

**Giải thích.** Quy tắc: **1 agent = 1 branch + 1 scope file không giao nhau.** Giao 2 agents cùng file → conflict chắc chắn. Chia theo module (auth/payments) hoặc tầng (API/tests).

Theo dõi bằng PR list + branch prefix (`copilot/issue-<N>`).

**Lệnh copy-paste:**

```bash
# Xem agents đang làm gì (PR mở của bot)
gh pr list --author "app/copilot" --state open

# Chia scope trong 2 issues:
# Issue A: "Chỉ src/auth/**"  |  Issue B: "Chỉ src/payments/**"
```

**Ví dụ:** 2 features song song → 2 issues scope rời nhau → 2 PR riêng → merge từng cái, không conflict.

**Khi nào áp dụng:** khi team chạy >1 coding agent cùng lúc — chia scope trong issue là bắt buộc.

---

## 8. Handoff người ↔ agent: tiếp tục dở dang thế nào?

**Giải thích.** 2 chiều:

- **Người tiếp quản agent:** `gh pr checkout <NUM>` → sửa tiếp → push (giữ branch agent).
- **Agent tiếp quản người:** comment `@copilot` trong PR/issue với yêu cầu cụ thể ("fix lint ở file X") → agent push thêm commit.

Luôn đọc PR timeline trước khi tiếp quản để biết agent đã làm tới đâu.

**Lệnh copy-paste:**

```bash
# Người tiếp quản PR agent
gh pr checkout <NUM>
git log --oneline -5   # xem agent đã làm gì
# ... sửa tiếp ...
git push

# Giao lại cho agent: comment trong PR (web hoặc CLI)
gh pr comment <NUM> --body "@copilot fix lỗi lint ở src/auth/login.ts dòng 42"
```

**Ví dụ:** agent làm 80% nhưng kẹt test khó → bạn checkout, fix 20% còn lại, merge — nhanh hơn chờ agent lặp.

**Khi nào áp dụng:** khi agent lặp lần 3 không xong — người vào là hiệu quả nhất.

---

## 9. Đo chất lượng agent: khi nào tin, khi nào không?

**Giải thích.** Tin khi: scope hẹp + có test xanh + diff nhỏ (<300 dòng) + không chạm auth/infra. Không tin (review kỹ từng dòng) khi: diff to, chạm migration/infra, không có test, agent tự "sáng tạo" thêm scope.

Thước đo team: tỉ lệ PR agent merge không sửa (target >60% sau 1 tháng fine-tune issue template).

**Lệnh copy-paste:**

```bash
# Đánh giá nhanh PR agent trước khi review sâu
gh pr view <NUM> --json additions,deletions,files
git diff main...copilot/issue-N --stat
# additions >500 hoặc files >10 -> review kỹ từng file
```

**Ví dụ:** PR agent 40 dòng + test xanh → review 5 phút merge. PR 800 dòng chạm migrations → checkout review từng hunk.

**Khi nào áp dụng:** mỗi PR agent — 30 giây xem stat trước khi đọc diff.

---

## 10. Dọn dẹp sau agent: branch, comment, log?

**Giải thích.** Sau merge: xóa branch agent (`gh pr merge --delete-branch`), resolve comments, giữ lại issue + PR timeline làm tài liệu. Đừng xóa issue — đó là spec gốc.

**Lệnh copy-paste:**

```bash
# Merge + xóa branch 1 lệnh
gh pr merge <NUM> --squash --delete-branch

# Liệt kê branch agent còn sót để dọn
git branch -r | grep "copilot/issue-"
gh pr list --author "app/copilot" --state closed --limit 20
```

**Ví dụ:** cuối tuần dọn: merge 3 PR agent xanh → `--delete-branch` → repo còn mỗi `main/develop` sạch.

**Khi nào áp dụng:** sau mỗi PR agent merge, và dọn định kỳ hàng tuần.

---

## Vẫn lỗi thì sao? (thứ tự debug chuẩn)

1. Agent loạn → check `tools` + ranh giới trong `*.agent.md`.
2. Scope lố → thu hẹp issue/prompt, chia task nhỏ.
3. PR fail → `gh pr checks` đọc log job đỏ đầu tiên.
4. Conflict → rebase lên base mới nhất.
5. Lặp 3 lần không xong → người checkout làm tiếp, đừng đốt quota.

```bash
gh pr checks <NUM> && git diff main...HEAD --stat
```

---

## Tham khảo chéo

- Viết agent đúng: [bài 06](06-prompts-agents-instructions.md). CI + review PR agent: [bài 10](10-ci-sdk-review-web.md).
- Permissions + approval: [bài 03](03-modes-permissions.md). Guardrails repo: [bài 05](05-policies-guardrails-faq.md).

> Mẹo 1 dòng: _1 agent 1 branch 1 scope, issue đủ 5 phần, và người vào ngay khi agent lặp lần 3._
