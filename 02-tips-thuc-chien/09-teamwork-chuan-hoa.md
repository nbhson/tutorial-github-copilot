# Tips 09 — Teamwork Chuẩn Hóa: Cả Team Dùng Copilot Một Kiểu

> **Dành cho:** tech lead / dev muốn cả team dùng Copilot giống nhau.
> **Vấn đề:** 5 người 5 kiểu prompt, luật nằm trong đầu 1 người, người mới mò 2 tuần.
> **Đọc xong:** commit instructions/skills/prompts/agents vào repo, dựng org policy + review workflow, viết được onboarding 30 phút cho người mới.
> **Thời gian:** ~20 phút đọc + ~60 phút chuẩn hóa 1 repo.

## 1. Vì sao phải chuẩn hóa?

Không chuẩn hóa, team bạn sẽ: 5 người 5 kiểu prompt, output 5 kiểu, review mệt; luật quan trọng nằm trong đầu 1 người; guardrails chỉ trên máy bạn; người mới mất 2 tuần mò.

```text
Người mới vào → đọc 1 README + chạy 30 phút onboarding → dùng Copilot đúng kiểu team.
Mọi PR từ Copilot → cùng format evidence + review checklist.
Luật đổi → sửa 1 file trong repo, cả team hưởng.
```

> Rule: **cái gì team phải nhớ thì viết ra file và commit. Trí nhớ không phải hệ thống.**

## 2. Cơ chế: 4 tài sản commit vào repo

| Tài sản | Đường dẫn | Ai sửa | Review |
|---|---|---|---|
| Instructions | `.github/copilot-instructions.md` + `instructions/*.md` | Tech leads | PR + 1 lead |
| Agent Skills (2026) | `.github/skills/<ten>/SKILL.md` | Cả team đề xuất | PR + 1 reviewer |
| Prompt files (legacy) | `.github/prompts/*.prompt.md` | Cả team đề xuất | PR + 1 reviewer (Local only) |
| Custom agents | `.github/agents/*.md` | Leads + contributors | PR + test thử |
| Gates | `verify.yml`, `CODEOWNERS`, `pre-commit` | Leads / DevOps | PR + CI xanh |

Cấu trúc repo chuẩn:

```text
.github/
  copilot-instructions.md
  instructions/
    payments.instructions.md
  skills/
    team-bug/SKILL.md        # chuẩn 2026, chạy Local + Cloud
    team-review/SKILL.md
  prompts/                   # legacy, chỉ Local
    team-bug.prompt.md
  agents/
    planner.md
    reviewer.md
  workflows/
    verify.yml
CODEOWNERS
CONTRIBUTING.md (có mục Copilot)
docs/
  copilot-onboarding.md (30 phút)
```

Tất cả commit vào git → clone repo là có, không cần setup miệng.

## 3. Commit instructions/skills/agents

**Ví dụ 1 — copilot-instructions.md team (copy-paste):**

```markdown
# .github/copilot-instructions.md (team, <200 dòng)

## Stack + lệnh (bắt buộc nhớ)
- Node 20, TS strict, pnpm. Test: `npm test -- <scope>`.

## Luật team (front-load)
- Không sửa src/generated/, không commit main, không thêm dep chưa duyệt.
- Mọi PR phải có Evidence: test/lint/build logs + diff --stat.
- Task >2 steps → plan.md duyệt trước khi code.

## Chi tiết
- Payments: .github/instructions/payments.instructions.md
- Skills team: .github/skills/ (nói "fix bug" / "review" tự load)
- Onboarding: docs/copilot-onboarding.md
```

**Ví dụ 2 — README index cho skills:** tạo `.github/skills/README.md` liệt kê bảng Skill / Khi dùng / Cách gọi (vd `team-bug` — fix bug + regression — nói "fix bug" là tự load); quy định thêm skill mới: tạo `SKILL.md` → test trên task thật (local + cloud) → PR kèm ví dụ gọi + output mẫu. Prompt files legacy giữ làm fallback, tag rõ "legacy".

**Ví dụ 3 — Custom agents team (copy-paste):**

```markdown
---
# .github/agents/planner.md
name: Planner
description: Lập plan, không code. Dùng khi task >2 steps.
tools: [search, read]
---
Bạn chỉ lập plan, không sửa code.
Output: files sửa/steps/risks/KHÔNG đụng/verify từng phase. Chờ duyệt.
```

```markdown
---
# .github/agents/reviewer.md
name: Reviewer
description: Review adversarial, verdict PASS/NEEDS-FIX.
tools: [search, read]
---
Finding = bug/correctness/security/test-gap. Bỏ qua style.
Output: [SEVERITY] file:line + verdict + 3 gaps ưu tiên.
```

Versioning: mọi thay đổi qua PR (mô tả lý do + ví dụ trước/sau); tag `skills-v1.2` khi release để rollback nhanh. Sửa trực tiếp không qua PR → mỗi máy một bản, không có mốc rollback.

## 4. Org policy + branch protection

**Org Copilot policy (checklist):**

```text
GitHub Org → Settings → Copilot → Policies:
- [ ] Coding Agent chỉ trên repo có verify.yml mẫu
- [ ] Chặn suggest cho *.pem, .env, secrets/
- [ ] Knowledge bases dùng chung: org-docs (ADRs, API specs)
- [ ] Mọi thay đổi instructions/skills/prompts phải qua PR + lead review
- [ ] Monthly audit: usage + MCP + incidents từ Copilot
```

**Branch protection team:**

```text
Repo → Settings → Branches → main:
- Require PR + 1 review (CODEOWNERS cho scope nhạy cảm)
- Require checks: test / lint / build (verify.yml)
- Require Copilot code review PASS
- Block force push, dismiss stale reviews
```

**CODEOWNERS + CONTRIBUTING:**

```text
# CODEOWNERS
/src/payments/** @team-payments
/src/auth/** @team-auth
/.github/copilot-instructions.md @tech-leads
/.github/skills/** @tech-leads
```

```markdown
<!-- CONTRIBUTING.md thêm mục -->
## Dùng Copilot (bắt buộc)
1. Task >2 steps → research/@Planner lập plan, duyệt mới code.
2. Mọi PR từ Copilot phải có Evidence (test/lint/build logs).
3. Review checklist: scope đúng? NEVER giữ? diff --stat gọn? Reviewer fresh PASS?
4. Không commit thẳng main, không sửa generated/.
```

Cảnh báo: bật protection quá sớm với 3 reviewers cho mọi PR nhỏ → team thấy chậm và lách thay vì tuân theo.

## 5. Review workflow cho PR từ Copilot

**3 lớp review:**

```text
Lớp 1 (tự động): Copilot code review quét mỗi PR → fix MED/LOW trước.
Lớp 2 (fresh):   chat Reviewer /team-review → verdict PASS mới nhờ người.
Lớp 3 (người):   reviewer theo CODEOWNERS chốt, chịu trách nhiệm merge.
```

Bỏ 1 lớp (vd merge luôn sau lớp 1) thì bug tốn kém nhất rơi xuống prod — nơi sửa đắt nhất.

**Checklist reviewer (copy-paste):**

```text
- [ ] Diff chỉ chạm scope issue? Không lọt generated/schema?
- [ ] Test/lint/build logs xanh thật (mở CI run kiểm tra)?
- [ ] Regression test cho bug? API mới có test?
- [ ] /team-review verdict PASS? Copilot review có HIGH chưa fix?
- [ ] Plan.md (nếu có) khớp implement?
- [ ] Sẵn sàng chịu trách nhiệm khi merge? (người merge là người chịu)
```

**Mô tả PR mẫu từ Coding Agent (copy-paste khung):** `## Issue` (Closes #101 + mô tả 1 dòng) → `## Scope` (files đụng + diff --stat) → `## Evidence` (10 dòng cuối log test/lint/build + link CI run) → `## Reviews` (Copilot review PASS + /team-review PASS, 0 HIGH).

## 6. Onboarding 30 phút cho người mới

Tạo `docs/copilot-onboarding.md`:

```markdown
# Onboarding Copilot 30 phút

## 0–5p: Setup
- Cài Copilot + Copilot Chat, login org, clone repo.
- Đọc .github/copilot-instructions.md (5 phút).

## 5–15p: Hỏi (Ask)
- Prompt: `@workspace Chỉ trong src/payments/*.ts: flow refund 5 bullet + file:line. Không sửa.`
- Mục tiêu: biết gắn scope hẹp, đọc output file:line.

## 15–25p: Fix (Edit + verify)
- Nói "fix bug" (skill team-bug tự load) với scope=src/cart, bug=test voucher 0đ.
- Chạy test, dán log, tick checklist done.
- Mục tiêu: biết verify + NEVER.

## 25–30p: Plan + review
- Chạy skill research: /research glob=src/auth/* outFile=docs/research-auth.md
- /team-review planFile=plan.md trên PR mẫu.
- Mục tiêu: biết plan-first + review gate.

## Xong: checklist
- [ ] Biết gọi 4 skills/prompts team
- [ ] Biết new chat mỗi task, #selection vs @workspace
- [ ] Biết Evidence + review 3 lớp trước khi nhờ merge
```

Buddy: ngày 1 review 2 PR đầu của người mới; tuần 1 người mới đề xuất 1 cải tiến skills (tạo PR).

## 7. Walkthrough: chuẩn hóa 1 repo 60 phút

| Phút | Việc | Làm gì |
|---|---|---|
| 0–10 | Instructions | Viết copilot-instructions.md <200 dòng (ví dụ 1 mục 3) |
| 10–20 | Scoped | Tách 2 *.instructions.md cho 2 modules hay sai nhất |
| 20–35 | Skills | Lưu team-bug + team-review theo chuẩn 2026 + README index |
| 35–45 | Gates | Thêm verify.yml + CODEOWNERS + branch protection (Tips 06) |
| 45–55 | Onboarding | Viết docs/copilot-onboarding.md 30 phút (mục 6) |
| 55–60 | Share | Mở PR `chore: copilot team setup`, tag cả team, hẹn 30p demo |

## 8. Pitfalls + cách fix

| Pitfall | Triệu chứng | Fix |
|---|---|---|
| Chỉ 1 người giữ files | Người đó nghỉ là loạn | CODEOWNERS + backup, ai cũng đề xuất PR được |
| 10 prompts trùng nhau | Không biết dùng cái nào | Gộp, mỗi task 1 skill + README index |
| Gates quá chặt ngày đầu | Team bypass --no-verify | Bắt đầu nhẹ, chặt dần, đo incidents |
| Không onboarding | Người mới hỏi vặt 2 tuần | docs 30 phút + buddy 2 PR đầu |
| Không đo usage | Không biết chuẩn hóa có ích không | Monthly: credits, retry, incidents, SLA review |
| Knowledge base cũ | Copilot trả lời theo spec cũ | Owner + ngày review mỗi quarter |
| Review qua loa | PR Copilot lọt bug | Checklist mục 5 + ai merge người chịu |

## 9. Bài tập cuối bài

**Bài 1 (20 phút):** Hỏi 3 đồng nghiệp: prompt/skill hay dùng nhất? Luật nào hay quên nhất? Ghi top 3 prompt + top 3 luật → 6 files đầu tiên cần đóng gói. So với cấu trúc mục 2: repo thiếu gì nhất?

**Bài 2 (30 phút):** Tạo PR với: copilot-instructions.md gọn + 1 skill + verify.yml. Nhờ 1 đồng nghiệp dùng thử + review. Merge xong thông báo team.

**Bài 3 (30 phút):** Nhờ 1 người chạy docs/copilot-onboarding.md 30 phút. Quan sát bước nào kẹt, sửa docs + skills theo feedback, ghi thời gian tới PR đầu tiên.

> Đạt: sau 1 tháng, 100% PR từ Copilot có Evidence, người mới tự onboard 30 phút không cần hỏi.

## Tham khảo chéo

- [Tips 06](./06-policies-guardrails-recipes.md) — guardrails recipes
- [Tips 07](./07-thiet-ke-prompts-skills.md) — thiết kế skills chuẩn 2026
- [Tips 04](./04-verification-done-that.md) — review gate + Evidence
- [Tips 08](./08-tiet-kiem-premium-requests.md) — usage + routing cho team
- [Tips 03](./03-plan-first-workflow.md) — plan-first cho mọi task lớn
- [03 — Instructions + memory + rules](../01-huong-dan-su-dung/03-instructions-memory-rules.md) — viết instructions
- [17 — Agent Customizations Hub](../01-huong-dan-su-dung/17-agent-customizations-hub.md) — hub skill/agent/MCP 2026

> **Chốt Tips 09:** team mạnh không phải vì mỗi người giỏi, mà vì luật nằm trong repo chứ không nằm trong đầu ai. Commit 4 tài sản, bắt đầu gates nhẹ, để onboarding 30 phút chứng minh hệ thống tự chạy.
