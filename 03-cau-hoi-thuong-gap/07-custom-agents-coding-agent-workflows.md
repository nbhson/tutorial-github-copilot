# FAQ 07 — Custom Agents & Coding Agent Workflows

> **Vấn đề:** custom agent sửa lố scope, coding agent mở PR xong để lại conflict, CI đỏ không biết bắt đầu từ đâu — 10 câu dưới đây trị bằng `tools` + ranh giới + issue đủ spec, không phải bằng niềm tin.

## Bảng tổng hợp: agent nào việc nào

| Agent | Việc | Tools cho phép |
|---|---|---|
| explorer | Trinh sát chỉ-đọc, vẽ bản đồ file | search (đọc) |
| tester | Chạy test focused, báo PASS/FAIL | terminal test + đọc log |
| security-reviewer | Soi auth/input/crypto/secrets | search + đọc diff |
| coding agent (GitHub) | Làm task từ issue, mở PR | full trong sandbox + ruleset |

---

## 1. Custom agent "chạy loạn" — nguyên nhân và cách trị?

**Trả lời 1 câu:** 3 nguyên nhân: thiếu `tools` khóa quyền (agent có full quyền), thiếu ranh giới trong body, task quá to — trị bằng khóa tools + 3 dòng ranh giới + chia nhỏ task.

```markdown
<!-- .github/agents/explorer.agent.md — trinh sat chi doc -->
---
description: Trinh sat chi doc, ve ban do file
tools: [search]
---
# Explorer — RANH GIỚI (đọc trước khi làm)
- CHỈ đọc file. KHÔNG sửa, KHÔNG chạy lệnh ghi, KHÔNG commit.
- Quá 10 file liên quan -> dừng, hỏi user chọn tiếp.
```

> `tools` + ranh giới là gate thật; hooks (preview, chỉ Local) chưa phải security boundary. **Vẫn loạn:** rút `tools` còn 1 tool, thêm "quá 10 file thì dừng", chia task nhỏ hơn.

## 2. Workflow 3 pha explorer → làm → tester?

**Trả lời 1 câu:** Workflow chuẩn cho task >30 phút: mỗi pha một chat — explorer vẽ bản đồ, pha làm sửa đúng list file đó, tester chạy test và báo PASS/FAIL (khảo sát → thi công → nghiệm thu).

```bash
# Pha 1 (chat 1, agent explorer): "Ve ban do refactor login trong src/auth/, chua sua."
# Pha 2 (chat 2, edit/agent): "Sua theo list: <paste list explorer>. Chi cac file nay."
# Pha 3 (chat 3, tester): "Chay npm test -- auth + npm run lint, bao PASS/FAIL."
```

> Task 1-2 file thì gộp pha 1+2. Dán sai list của explorer là scope trôi ngay.

## 3. Security-reviewer gọi khi nào, check gì?

**Trả lời 1 câu:** Gọi khi diff chạm auth/session, input validation, crypto, thanh toán, secrets, permissions hoặc SQL — reviewer chỉ đọc + comment, không sửa.

Checklist: injection (SQL/command), XSS, auth bypass, IDOR, secret lộ, crypto yếu, rate-limit.

```bash
git diff main...HEAD --stat
git diff main...HEAD -- src/auth/ | head -100
# Prompt: "Review security diff tren. Chi bao Critical/Major + dong cu the + cach fix."
```

> Quy ước team: diff chạm `auth|payment|crypto|admin` → bắt buộc qua security-reviewer. Mẫu: `templates/.github/agents/security-reviewer.agent.md`.

## 4. Coding agent trên GitHub là gì, giao việc thế nào?

**Trả lời 1 câu:** Coding agent là bot chạy trên cloud GitHub nhận việc từ issue (assign cho `copilot`), tự code + chạy test + mở PR, bạn review như review người thật — khởi động nhanh hơn 50% từ changelog 03/2026.

Giao việc chuẩn: issue mô tả **mục tiêu + phạm vi file + acceptance criteria + lệnh test**. Task to tốn nhiều AI Credits hơn → luôn ghi lệnh verify trong issue.

```markdown
<!-- Mau issue giao cho coding agent -->
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

```bash
gh copilot assign 123 --repo acme/api
gh pr list --author "app/copilot" --state open
```

> Task rõ ràng, có test, scope hẹp → agent làm tốt. Task mơ hồ thì làm rõ issue trước, đừng assign đi assign lại.

## 5. Coding agent conflict / PR fail — xử lý sao?

**Trả lời 1 câu:** 3 ca: conflict → rebase lên base mới; CI đỏ → đọc log job đỏ đầu tiên rồi comment `@copilot` bảo fix; PR sai scope → request changes hoặc checkout về sửa tay.

| Ca | Triệu chứng | Cách xử |
|---|---|---|
| Conflict với main | Base branch trôi trong lúc agent làm | Rebase lên `origin/main` → `git push --force-with-lease` |
| CI đỏ | Check/job đỏ trên PR | Đọc log job đỏ đầu tiên, comment `@copilot` fix cụ thể |
| PR sai scope | Agent sửa file ngoài issue | Request changes liệt kê file cần revert, hoặc checkout sửa tay |

```bash
gh pr view <NUM> --json title,state,mergeable,statusCheckRollup && gh pr checks <NUM>

# Giai conflict don gian
gh pr checkout <NUM> && git fetch origin && git rebase origin/main && git push --force-with-lease
```

**Ví dụ:** CI đỏ job `test` thiếu import → comment trong PR: "@copilot thiếu import X ở file Y" → agent push fix.

## 6. Viết issue thế nào để agent làm đúng ngay lần 1?

**Trả lời 1 câu:** Issue đủ 5 phần — **bối cảnh, mục tiêu, phạm vi file, acceptance criteria, lệnh verify** — thiếu phần nào agent tự đoán phần đó (và đoán sai).

- Tốt: "Thêm 429 khi vượt 100 req/phút, chỉ src/auth/**, test expect 429, verify `npm test -- auth`."
- Dở: "Làm rate limit đi."

```bash
# Chay thu lenh verify tren may truoc khi giao issue
npm test -- auth
```

> 5 phút viết issue kỹ đỡ 30 phút sửa PR; lệnh verify nên trùng lệnh đã ghi trong `copilot-instructions.md`.

## 7. Nhiều agents cùng làm 1 repo — tránh giẫm chân?

**Trả lời 1 câu:** Quy tắc: **1 agent = 1 branch + 1 scope file không giao nhau** — chia theo module (auth/payments) hoặc tầng (API/tests); giao 2 agents cùng file là conflict chắc chắn.

```bash
gh pr list --author "app/copilot" --state open
# Verify: 2 PR không động file nào chung
# Issue A: "Chi src/auth/**"  |  Issue B: "Chi src/payments/**"
```

## 8. Handoff người ↔ agent: tiếp tục dở dang thế nào?

**Trả lời 1 câu:** 2 chiều: người tiếp quản bằng `gh pr checkout` + sửa + push; agent tiếp quản bằng comment `@copilot` với yêu cầu cụ thể — luôn đọc PR timeline trước khi tiếp quản.

```bash
# Nguoi tiep quan PR agent
gh pr checkout <NUM> && git log --oneline -5
# ... sua tiep ... git push

# Giao lai cho agent
gh pr comment <NUM> --body "@copilot fix loi lint o src/auth/login.ts dong 42"
```

> Agent lặp lần 3 không xong → người vào là hiệu quả nhất: làm 80% của nó + fix 20% còn lại, nhanh hơn chờ vòng lặp thứ 4 đốt Credits.

## 9. Đo chất lượng agent: khi nào tin, khi nào không?

**Trả lời 1 câu:** Tin (review nhanh) khi scope hẹp + test xanh + diff <300 dòng + không chạm auth/infra; review từng dòng khi diff to, chạm migration/infra, không test, hoặc agent tự "sáng tạo" thêm scope.

| Tiêu chí | Tin (review nhanh) | Không tin (review từng dòng) |
|---|---|---|
| Scope | Hẹp, đúng trong issue | Lố, tự mở rộng |
| Test | Có test xanh | Không có test |
| Diff | Nhỏ (<300 dòng) | To (>500 dòng / >10 file) |
| Vùng chạm | Không chạm auth/infra | Chạm migration/infra/auth |

```bash
gh pr view <NUM> --json additions,deletions,files
git diff main...copilot/issue-N --stat
# Verify: additions >500 hoac files >10 -> review ky tung file
```

> Thước đo team: tỉ lệ PR agent merge không sửa (target >60% sau 1 tháng fine-tune issue template); track chi phí bằng dashboard AI Credits ở `github.com/settings/copilot`.

## 10. Dọn dẹp sau agent?

**Trả lời 1 câu:** Sau merge: xóa branch agent (`--delete-branch`), resolve comments, **giữ nguyên issue + PR timeline** làm tài liệu và bằng chứng chi phí AI Credits đã trả — đừng xóa issue vì đó là spec gốc.

```bash
gh pr merge <NUM> --squash --delete-branch
git branch -r | grep "copilot/issue-"   # Verify: branch da thanh ly
```

---

## Vẫn lỗi thì sao? (thứ tự debug chuẩn)

1. Agent loạn → check `tools` + ranh giới trong `*.agent.md`.
2. Scope lố → thu hẹp issue/prompt, chia task nhỏ.
3. PR fail → `gh pr checks` đọc log job đỏ đầu tiên.
4. Conflict → rebase lên base mới nhất.
5. Lặp 3 lần không xong → người checkout làm tiếp, đừng đốt AI Credits.

Tham khảo chéo: [bài 06](06-prompts-agents-instructions.md) (viết agent đúng) · [bài 10](10-ci-sdk-review-web.md) (CI + review PR agent) · [bài 03](03-modes-permissions.md) (permissions) · [bài 05](05-policies-guardrails-faq.md) (guardrails repo).
