# Tips 09 — Teamwork Chuẩn Hóa: Cả Team Dùng Copilot Một Kiểu

> Copilot cá nhân nhanh, Copilot team mới mạnh. Bài này dạy bạn commit instructions/prompts/agents vào repo, org policy, review workflow, và onboarding 30 phút cho người mới.

## Mục lục

- [1. Vì sao phải chuẩn hóa?](#1-vì-sao-phải-chuẩn-hóa)
- [2. Cơ chế: 4 tài sản commit vào repo](#2-cơ-chế-4-tài-sản-commit-vào-repo)
- [3. Commit instructions/prompts/agents](#3-commit-instructionspromptsagents)
- [4. Org policy + branch protection](#4-org-policy--branch-protection)
- [5. Review workflow cho PR từ Copilot](#5-review-workflow-cho-pr-từ-copilot)
- [6. Onboarding 30 phút cho người mới](#6-onboarding-30-phút-cho-người-mới)
- [7. Walkthrough theo phút: chuẩn hóa 1 repo 60 phút](#7-walkthrough-theo-phút-chuẩn-hóa-1-repo-60-phút)
- [8. Bảng tra nhanh: ai giữ gì?](#8-bảng-tra-nhanh-ai-giữ-gì)
- [9. Pitfalls + cách fix](#9-pitfalls--cách-fix)
- [10. Bài tập cuối bài](#10-bài-tập-cuối-bài)
- [11. Tham khảo chéo](#11-tham-khảo-chéo)

---

## 0. Giải ngố thuật ngữ (1 câu + analogie + verify)

| Thuật ngữ | Hiểu nôm na | Analogie | Ví dụ kỹ thuật thật | Verify |
|---|---|---|---|---|
| **Chuẩn hóa team** | Cả đội đá 1 chiến thuật, không ai đá tự do. | Như quán phở: 5 chi nhánh cùng công thức, khách ăn đâu cũng giống. | `muse-instructions.md + prompts/ + agents/ + verify.yml` commit vào repo. | Người mới clone là có, không setup miệng. |
| **CODEOWNERS** | Bảng phân công: đất ai người đó duyệt. | Như tổ trưởng: việc payments phải qua tổ payments ký. | `/src/payments/** @team-payments`. | PR chạm payments tự tag đúng owner + SLA 24h. |
| **Review 3 lớp** | 3 cặp mắt: máy quét + bạn chấm + sếp chốt. | Như kiểm hàng: máy soi + nhân viên + quản lý. | Copilot review → `/team-review` fresh → người CODEOWNERS. | PR merge có 2 reviews + CI xanh + Evidence logs. |
| **Onboarding 30 phút** | Học việc cấp tốc: 30 phút là làm được việc. | Như hướng dẫn xe mới: 30 phút là lái ra đường. | `docs/copilot-onboarding.md`: Ask 10p + Fix 10p + Plan 10p. | Người mới tự xong PR đầu không cần hỏi. |

```mermaid
flowchart TD
    A[Repo mới] --> B[Viết instructions + 2 prompts]
    B --> C[Thêm verify.yml + CODEOWNERS]
    C --> D[Viết onboarding 30p]
    D --> E[Mở PR team setup]
    E --> F[Demo 30p cả team]
    F --> G[Người mới onboard 30p]
    G --> H[Monthly audit usage/incidents]
```

Giải thích: luật nằm trong repo (không nằm trong đầu ai). Mọi đổi qua PR + lead review. Bắt đầu nhẹ (1 review + CI), chặt dần theo incidents.

> ✅ **Kỳ vọng thấy gì:** sau 60 phút (mục 7), repo có `.github/` + `verify.yml` + `CODEOWNERS` + `copilot-onboarding.md`; PR mới có Evidence logs.

---

## 1. Vì sao phải chuẩn hóa?

Không chuẩn hóa, team bạn sẽ:

- 5 người 5 kiểu prompt, output 5 kiểu, review mệt.
- Luật quan trọng nằm trong đầu 1 người, người mới không biết.
- Guardrails chỉ trên máy bạn, máy khác vẫn đi lạc.
- Người mới mất 2 tuần mò, hỏi ai cũng bận.

Chuẩn hóa xong:

```text
Người mới vào → đọc 1 README + chạy 30 phút onboarding → dùng Copilot đúng kiểu team.
Mọi PR từ Copilot → cùng format evidence + review checklist.
Luật đổi → sửa 1 file trong repo, cả team hưởng.
```

> Rule: **cái gì team phải nhớ thì viết ra file và commit. Trí nhớ không phải hệ thống.**

---

## 2. Cơ chế: 4 tài sản commit vào repo

| Tài sản | Đường dẫn | Ai sửa | Review |
|---|---|---|---|
| Instructions | `.github/muse-instructions.md` + `instructions/*.md` | Tech leads | PR + 1 lead |
| Prompt files | `.github/prompts/*.prompt.md` | Cả team đề xuất | PR + 1 reviewer |
| Custom agents | `.github/agents/*.md` hoặc `skills/*` | Leads + contributors | PR + test thử |
| Gates | `verify.yml`, `CODEOWNERS`, `pre-commit` | Leads / DevOps | PR + CI xanh |

Cấu trúc repo chuẩn:

```text
.github/
  muse-instructions.md
  instructions/
    payments.instructions.md
    generated.instructions.md
  prompts/
    team-bug.prompt.md
    team-review.prompt.md
    research.prompt.md
    verify-feature.prompt.md
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

---

## 3. Commit instructions/prompts/agents

### Ví dụ 1 — muse-instructions.md team (copy-paste)

```markdown
# .github/muse-instructions.md (team, <200 dòng)

## Stack + lệnh (bắt buộc nhớ)
- Node 20, TS strict, pnpm. Test: `npm test -- <scope>`.

## Luật team (front-load)
- Không sửa src/generated/, không commit main, không thêm dep chưa duyệt.
- Mọi PR phải có Evidence: test/lint/build logs + diff --stat.
- Task >2 steps → plan.md duyệt trước khi code.

## Chi tiết
- Payments: .github/instructions/payments.instructions.md
- Prompts team: .github/prompts/ (gọi /team-bug, /team-review)
- Onboarding: docs/copilot-onboarding.md
```

### Ví dụ 2 — Quy ước prompt files (copy-paste README)

```markdown
# .github/prompts/README.md

| Prompt | Khi dùng | Gọi |
|---|---|---|
| /team-bug | Fix bug + regression | /team-bug scope=... bug=... |
| /team-review | Review trước merge | /team-review planFile=plan.md |
| /research | Hiểu module lạ | /research glob=... outFile=... |
| /verify-feature | Gate trước commit | /verify-feature scope=... |

## Thêm prompt mới
1. Copy mẫu gần nhất, thêm variables + 1 few-shot.
2. Test trên task thật + 1 reviewer thử.
3. PR với mô tả: khi nào dùng, ví dụ gọi, output mẫu.
```

### Ví dụ 3 — Custom agents team (copy-paste)

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

Versioning:

- Mọi thay đổi qua PR, mô tả lý do + ví dụ trước/sau.
- Tag `prompts-v1.2` khi release để rollback nhanh.

---

## 4. Org policy + branch protection

### Ví dụ 1 — Org Copilot policy (copy-paste checklist)

```text
GitHub Org → Settings → Copilot → Policies:
- [ ] Coding Agent chỉ trên repo có verify.yml mẫu
- [ ] Chặn suggest cho *.pem, .env, secrets/
- [ ] Knowledge bases dùng chung: org-docs (ADRs, API specs)
- [ ] Mọi thay đổi instructions/prompts phải qua PR + lead review
- [ ] Monthly audit: usage + MCP + incidents từ Copilot
```

### Ví dụ 2 — Branch protection team (copy-paste)

```text
Repo → Settings → Branches → main:
- Require PR + 1 review (CODEOWNERS cho scope nhạy cảm)
- Require checks: test / lint / build (verify.yml)
- Require Copilot code review PASS
- Block force push, dismiss stale reviews
```

### Ví dụ 3 — CODEOWNERS + CONTRIBUTING (copy-paste)

```text
# CODEOWNERS
/src/payments/** @team-payments
/src/auth/** @team-auth
/.github/muse-instructions.md @tech-leads
/.github/prompts/** @tech-leads
```

```markdown
<!-- CONTRIBUTING.md thêm mục -->
## Dùng Copilot (bắt buộc)
1. Task >2 steps → /research hoặc @Planner lập plan, duyệt mới code.
2. Mọi PR từ Copilot phải có Evidence (test/lint/build logs).
3. Review checklist: scope đúng? NEVER giữ? diff --stat gọn? Reviewer fresh PASS?
4. Không commit thẳng main, không sửa generated/.
```

---

## 5. Review workflow cho PR từ Copilot

### 3 lớp review

```text
Lớp 1 (tự động): Copilot code review quét mỗi PR → fix MED/LOW trước.
Lớp 2 (fresh): chat Reviewer với /team-review → verdict PASS mới nhờ người.
Lớp 3 (người): reviewer theo CODEOWNERS chốt, chịu trách nhiệm merge.
```

### Ví dụ 1 — Prompt nhờ review (copy-paste cho tác giả PR)

```text
PR #123 đã có Copilot review PASS + /team-review PASS.
Nhờ @teammate review lớp 3:
- Scope: src/payments/** (diff --stat trong mô tả)
- Evidence: test/lint/build logs trong mô tả
- Focus: logic refund >30 ngày, idempotency
- SLA: 24h, comment [SEVERITY] nếu finding
```

### Ví dụ 2 — Checklist reviewer (copy-paste)

```text
- [ ] Diff chỉ chạm scope issue? Không lọt generated/schema?
- [ ] Test/lint/build logs xanh thật (mở CI run kiểm tra)?
- [ ] Regression test cho bug? API mới có test?
- [ ] /team-review verdict PASS? Copilot review có HIGH chưa fix?
- [ ] Plan.md (nếu có) khớp implement?
- [ ] Sẵn sàng chịu trách nhiệm khi merge? (người merge là người chịu)
```

### Ví dụ 3 — PR mẫu từ Coding Agent (copy-paste mô tả)

```markdown
## Issue
Closes #101 — refund quá 30 ngày bị 500.

## Scope
- src/payments/refund.ts + test (diff --stat bên dưới).

## Evidence
- test: [paste 10 dòng cuối log xanh]
- lint: [paste log] / build: [paste log]
- CI run: [link]

## Reviews
- Copilot review: PASS (link)
- /team-review: PASS, 0 HIGH

## Checklist
- [ ] Không đụng generated/schema/main
- [ ] Người review lớp 3: @...
```

---

## 6. Onboarding 30 phút cho người mới

Tạo `docs/copilot-onboarding.md`:

**Ví dụ copy-paste lịch 30 phút:**

```markdown
# Onboarding Copilot 30 phút

## 0–5p: Setup
- Cài Copilot + Copilot Chat, login org, clone repo.
- Mở .github/muse-instructions.md, đọc 5 phút.

## 5–15p: Hỏi (Ask)
- Prompt: `@workspace Chỉ trong src/payments/*.ts: flow refund 5 bullet + file:line. Không sửa.`
- Mục tiêu: biết gắn scope hẹp, đọc output file:line.

## 15–25p: Fix (Edit + verify)
- Prompt: `/team-bug scope=src/cart bugDescription="test voucher 0đ"`
- Chạy test, dán log, tick checklist done.
- Mục tiêu: biết verify + NEVER.

## 25–30p: Plan + review
- Prompt: `/research glob=src/auth/* outFile=docs/research-auth.md`
- Prompt: `/team-review planFile=plan.md` trên PR mẫu.
- Mục tiêu: biết plan-first + review gate.

## Xong: checklist
- [ ] Biết gọi 4 prompts team
- [ ] Biết new chat mỗi task, #selection vs @workspace
- [ ] Biết Evidence + review 3 lớp trước khi nhờ merge
```

Buddy:

- Ngày 1: buddy review 2 PR đầu của người mới (so prompt + evidence).
- Tuần 1: người mới đề xuất 1 cải tiến prompts (tạo PR).

---

## 7. Walkthrough theo phút: chuẩn hóa 1 repo 60 phút

**Bối cảnh:** repo 5 người, mỗi người một kiểu, chưa có file team nào.

| Phút | Việc | Làm gì (copy-paste) |
|---|---|---|
| 0–10 | Instructions | Viết `.github/muse-instructions.md` <200 dòng (ví dụ 1 mục 3) |
| 10–20 | Scoped | Tách 2 `*.instructions.md` cho 2 modules hay sai nhất |
| 20–35 | Prompts | Lưu `/team-bug` + `/team-review` từ Tips 02/07, thêm README index |
| 35–45 | Gates | Thêm `verify.yml` + CODEOWNERS + branch protection (Tips 06) |
| 45–55 | Onboarding | Viết `docs/copilot-onboarding.md` 30 phút (mục 6) |
| 55–60 | Share | Mở PR `chore: copilot team setup`, tag cả team, hẹn 30p demo |

Sau 60 phút: repo có bộ khung team. Tuần sau đo: PR có evidence? review SLA? incidents?

---

## 8. Bảng tra nhanh: ai giữ gì?

| Việc | Hiểu nôm na | Ví dụ | Ai | Ở đâu | Khi nào sửa |
|---|---|---|---|---|---|
| Luật chung | Hiến pháp cả nước. | Cấm sửa `generated/` mọi lúc. | Tech leads | muse-instructions.md | Luật lặp lại >2 lần |
| Luật module | Luật làng. | Riêng `payments/` cần idempotency-key. | Owner module | *.instructions.md | Module đổi convention |
| Prompt team | Đơn mẫu cả xã dùng. | `/team-bug` fix + regression. | Cả team PR | .github/prompts/ | Prompt dùng >2 lần/tuần |
| Agents/skills | Tổ chuyên môn. | Skill `release` 4 bước. | Leads + contributors | agents/ skills/ | Procedure >5 bước |
| CI/gates | Cổng làng + camera. | `verify.yml` test/lint/build. | DevOps/leads | verify.yml, protection | Thêm check mới |
| Knowledge base | Thư viện làng. | `org-docs` ADRs + API specs. | Tech writers/leads | Org knowledge | Docs/spec đổi |
| Onboarding | Trường làng 30 phút. | `copilot-onboarding.md` Ask/Fix/Plan. | Buddy + leads | docs/copilot-onboarding.md | Người mới feedback |
| Usage/incidents | Sổ họp làng hàng tháng. | Report requests + retry + SLA. | Leads monthly | Wiki report | Monthly audit |

> Quy tắc ngón tay: **ai đau nhất vì thiếu luật thì người đó đề xuất PR, lead duyệt.**

### Before / After — mạnh ai nấy đá vs chuẩn hóa

**Before (mỗi người 1 kiểu):**
```text
An prompt: "fix giúp" — Bình prompt: "sửa code" — Chi không dùng prompt files.
Luật "đừng đụng generated/" nằm trong đầu An. Guardrails chỉ máy An có.
Người mới hỏi 2 tuần, PR 5 kiểu, review cãi nhau vì không có Evidence chuẩn.
```
> Kết quả: review mệt, incident 1 lần/tuần (sửa generated/commit main), onboard 2 tuần.

**After (chuẩn hóa 60 phút):**
```text
Mọi người gọi: /team-bug scope=... bug=... → cùng format + Evidence.
Luật trong .github/muse-instructions.md (<200 dòng). Gates: verify.yml + CODEOWNERS + protection.
Người mới đọc docs/copilot-onboarding.md 30 phút → PR đầu có log xanh.
```
> Kết quả: 100% PR có Evidence, onboard 30 phút, incident ~0. Verify: `git log -- .github/` thấy luật đổi qua PR + review.
> ✅ **Kỳ vọng thấy gì:** PR mẫu có `## Evidence` + 2 reviews (bot + người) + CI xanh.

---

## 9. Pitfalls + cách fix

| Pitfall | Triệu chứng | Fix |
|---|---|---|
| Chỉ 1 người giữ files | Người đó nghỉ là loạn | CODEOWNERS + backup, PR ai cũng đề xuất được |
| Instructions 600 dòng | Không ai đọc | <200 dòng + link chi tiết, onboarding 5p đọc xong |
| 10 prompts trùng nhau | Không biết dùng cái nào | Gộp, mỗi task 1 prompt + README index |
| Gates quá chặt ngày đầu | Team bypass --no-verify | Bắt đầu nhẹ, chặt dần, đo incidents |
| Không onboarding | Người mới hỏi vặt 2 tuần | docs 30 phút + buddy 2 PR đầu |
| Không đo usage | Không biết chuẩn hóa có ích không | Monthly: requests, retry, incidents, SLA review |
| Knowledge base cũ | Copilot trả lời theo spec cũ | Owner + ngày review mỗi quarter |
| Review qua loa | PR Copilot lọt bug | Checklist mục 5 + ai merge người chịu |
| Sửa prompts không PR | Mỗi máy một bản | Bắt buộc PR + CI + 1 review cho .github/** |

---

## 10. Bài tập cuối bài

**Bài 1 (20 phút — audit team):**

1. Hỏi 3 đồng nghiệp: prompt Copilot hay dùng nhất là gì? Luật nào hay quên nhất?
2. Ghi top 3 prompt + top 3 luật → đó là 6 files đầu tiên cần đóng gói.
3. So với cấu trúc mục 2: repo bạn thiếu gì nhất?

**Bài 2 (30 phút — PR team setup đầu tiên):**

1. Tạo PR với: muse-instructions.md gọn + 1 prompt file + verify.yml.
2. Nhờ 1 đồng nghiệp dùng thử + review.
3. Merge xong, thông báo team: từ nay dùng /tên-prompt + Evidence.

**Bài 3 (30 phút — chạy onboarding thử):**

1. Nhờ 1 người (mới hoặc khác team) chạy `docs/copilot-onboarding.md` 30 phút.
2. Quan sát: bước nào kẹt? Prompt nào khó hiểu?
3. Sửa docs + prompts theo feedback, ghi lại thời gian tới PR đầu tiên.

> Đạt: sau 1 tháng, 100% PR từ Copilot có Evidence, người mới tự onboard 30 phút không cần hỏi.

---

## 11. Tham khảo chéo

- Bài tips liên quan:
  - [Tips 06](./06-policies-guardrails-recipes.md) — guardrails recipes
  - [Tips 07](./07-thiet-ke-prompts-skills.md) — thiết kế prompts/skills
  - [Tips 04](./04-verification-done-that.md) — review gate + Evidence
  - [Tips 08](./08-tiet-kiem-premium-requests.md) — usage + routing cho team
  - [Tips 03](./03-plan-first-workflow.md) — plan-first cho mọi task lớn

> Mẹo 1 dòng: _team mạnh khi luật nằm trong repo, không nằm trong đầu ai — commit hết, onboarding 30 phút._
