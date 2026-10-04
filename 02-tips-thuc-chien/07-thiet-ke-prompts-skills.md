# Tips 07 — Thiết Kế Prompts & Skills Tái Dùng: Viết 1 Lần, Cả Team Hưởng

> Prompt gõ tay mỗi lần là nợ. Bài này dạy bạn thiết kế prompt files (`.prompt.md`), instructions (`applyTo` globs) và skills (`SKILL.md`) tái dùng: frontmatter mode/tools, variables, few-shot, versioning.

## Mục lục

- [1. Vì sao phải tái dùng?](#1-vì-sao-phải-tái-dùng)
- [2. Cơ chế: 3 loại tài sản tái dùng](#2-cơ-chế-3-loại-tài-sản-tái-dùng)
- [3. Prompt files (.prompt.md): mẫu gọi nhanh](#3-prompt-files-promptmd-mẫu-gọi-nhanh)
- [4. Instructions: luật tự áp theo scope](#4-instructions-luật-tự-áp-theo-scope)
- [5. Skills (SKILL.md): procedure nhiều bước](#5-skills-skillmd-procedure-nhiều-bước)
- [6. Few-shot + variables chuẩn](#6-few-shot--variables-chuẩn)
- [7. Walkthrough theo phút: đóng gói 1 prompt team](#7-walkthrough-theo-phút-đóng-gói-1-prompt-team)
- [8. Bảng tra nhanh: dùng loại nào?](#8-bảng-tra-nhanh-dùng-loại-nào)
- [9. Pitfalls + cách fix](#9-pitfalls--cách-fix)
- [10. Bài tập cuối bài](#10-bài-tập-cuối-bài)
- [11. Tham khảo chéo](#11-tham-khảo-chéo)

---

## 1. Vì sao phải tái dùng?

Dấu hiệu bạn đang nợ prompt:

- Mỗi bug bạn gõ lại từ đầu, mỗi lần một kiểu, output khác nhau.
- Đồng nghiệp hỏi "prompt hôm qua bạn dùng là gì?" → bạn không nhớ.
- Team 5 người, 5 cách dặn Copilot, review không đồng nhất.
- Luật quan trọng (đừng đụng generated/) phải nhắc miệng mỗi chat.

Đóng gói thành files:

```text
Trước: gõ 10 dòng mỗi lần × 20 lần = 200 dòng + 20 kiểu khác nhau
Sau: viết 1 file 30 dòng, gọi `/team-bug` 20 lần, output đồng nhất
```

> Rule: **prompt dùng >2 lần thì đóng gói thành file. Luật áp mọi turn thì thành instructions.**

---

## 2. Cơ chế: 3 loại tài sản tái dùng

| Loại | File | Kích hoạt | Khi dùng |
|---|---|---|---|
| Prompt files | `.github/prompts/*.prompt.md` | Gọi tay `/tên-file` | Task lặp lại: bug, review, research |
| Instructions | `.github/muse-instructions.md` + `*.instructions.md` | Tự áp mọi turn / theo glob | Luật, convention, cấm địa |
| Skills | `skills/*/SKILL.md` | Copilot tự nhận diện theo mô tả | Procedure nhiều bước: release, migrate |

Phân biệt nhanh:

```text
Prompt = bạn gọi khi cần (chủ động).
Instructions = tự chạy ngầm (bị động).
Skill = procedure dài, Copilot tự biết khi nào dùng.
```

Nơi đặt chuẩn Copilot 2026:

```text
.github/
  muse-instructions.md        # luật chung <200 dòng
  instructions/
    payments.instructions.md  # applyTo: src/payments/**
    generated.instructions.md # applyTo: src/generated/**
  prompts/
    team-bug.prompt.md
    team-review.prompt.md
    research.prompt.md
skills/
  release/SKILL.md
  migrate-db/SKILL.md
```

---

## 3. Prompt files (.prompt.md): mẫu gọi nhanh

### Cấu trúc frontmatter chuẩn

```markdown
---
mode: agent       # ask | edit | agent
tools: [search, read, edit, test]
description: Fix bug tối thiểu + regression test
---
```

- `mode`: quyền của prompt này (bug nên agent, research nên ask).
- `tools`: giới hạn tools được dùng (research không cần edit).
- `description`: 1 dòng để Copilot gợi ý + team tìm.

### Ví dụ 1 — team-bug.prompt.md (copy-paste)

```markdown
---
mode: agent
tools: [search, read, edit, test]
description: Fix bug tối thiểu + regression test, không đổi API
---

## Nhiệm vụ
Fix bug mô tả trong ${input:bugDescription} tại ${input:scope}.

## Steps
1. Đọc ${input:scope} + test liên quan, giải thích root cause 3 bullet.
2. Fix tối thiểu, không đổi public API, không refactor lan man.
3. Thêm 1 regression test cover case này.
4. Chạy `npm test -- ${input:scope}` và dán log pass/fail.
   Đỏ thì fix tiếp trong message này (tối đa 3 lần).

## Ràng buộc
- Đừng đụng src/generated/, đừng commit thẳng main.
- Không xóa/sửa test cũ để cho xanh.

## Output
- ## Evidence: log test + git diff --stat
```

Gọi:

```text
/team-bug scope=src/payments bugDescription="refund quá 30 ngày bị 500"
```

### Ví dụ 2 — team-review.prompt.md (copy-paste)

```markdown
---
mode: ask
tools: [search, read]
description: Review adversarial, verdict PASS/NEEDS-FIX
---

## Input
Review diff hiện tại với plan trong ${input:planFile:plan.md}.

## Tiêu chí finding
Chỉ bug/correctness/security/test-gap. Bỏ qua style.

## Output bắt buộc
- [SEVERITY: HIGH/MED/LOW] file:line — mô tả 1 dòng — gợi ý fix 1 dòng
- Verdict: PASS / NEEDS-FIX + 3 gaps ưu tiên nhất
- Không được LGTM nếu thiếu regression test hoặc diff chạm ngoài scope.
```

Gọi:

```text
/team-review planFile=plan.md
```

### Ví dụ 3 — research.prompt.md (copy-paste)

```markdown
---
mode: ask
tools: [search, read]
description: Research module, chỉ đọc không sửa
---

## Phạm vi
Chỉ trong ${input:glob}. Không đọc ngoài, không sửa code.

## Output bắt buộc
1. Table | File | Vai trò 1 dòng |
2. Flow hiện tại 5-8 bullet + file:line
3. 2 phương án (pros/cons 3 bullet mỗi cái)

## Ghi file
Ghi findings ra ${input:outFile:docs/research.md} rồi dừng.
```

---

## 4. Instructions: luật tự áp theo scope

### Nguyên tắc: chung ở root, riêng theo glob

`.github/muse-instructions.md` (<200 dòng):

**Ví dụ 1 — Instructions gốc (copy-paste):**

```markdown
# muse-instructions.md

## Stack
- Node 20, TypeScript strict, pnpm.

## Luật hay sai nhất (front-load lên đầu)
- Luôn chạy `npm test -- <scope>` trước khi kết luận done.
- Không sửa `src/generated/`, không commit thẳng main.
- Mọi API mới phải có test trong `__tests__/`.

## Lệnh hay dùng
- test: `npm test -- <scope>`
- lint: `npm run lint`
- build: `npm run build`
```

### applyTo globs

**Ví dụ 2 — payments.instructions.md (copy-paste):**

```markdown
---
applyTo: "src/payments/**"
---

## Riêng payments
- Refund >30 ngày phải hỏi duyệt, không tự quyết.
- Mọi API mới phải có idempotency-key header.
- Test bắt buộc: `npm test -- payments` xanh.
- Không gọi trực tiếp DB, qua repository layer.
```

**Ví dụ 3 — docs.instructions.md (copy-paste):**

```markdown
---
applyTo: "docs/**"
---

## Riêng docs
- Mọi số liệu phải kèm nguồn (file:line hoặc link).
- Output table + 3 bullet insight + confidence 1 dòng.
- Không sửa file gốc khi research.
```

Kiểm tra:

- Glob càng hẹp càng tốt (`src/payments/**` tốt hơn `src/**`).
- Mỗi file <50 dòng, chỉ luật riêng scope đó.
- Luật chung để root, không lặp lại ở files con.

---

## 5. Skills (SKILL.md): procedure nhiều bước

Khi procedure >5 bước, prompt file quá dài → tách thành skill.

Cấu trúc:

```text
skills/release/SKILL.md
skills/migrate-db/SKILL.md
```

**Ví dụ 1 — skills/release/SKILL.md (copy-paste):**

```markdown
---
name: release
description: Dùng khi cần release version mới: bump, changelog, tag, verify CI.
---

# Release procedure

## 1. Kiểm tra
- `git status` sạch, đang ở main, pull mới nhất.
- `npm test` + `npm run build` xanh mới tiếp tục.

## 2. Bump + changelog
- Bump version trong package.json (patch/minor/major theo ${input:type}).
- Thêm mục CHANGELOG.md: ngày + 3 bullet thay đổi từ git log.

## 3. Tag + push
- Commit `chore: release vX.Y.Z`, tag `vX.Y.Z`, push + tag.
- Chờ CI xanh trên tag, dán link run.

## 4. Không làm
- Không release khi CI đỏ, không force push tag.
```

Gọi tự nhiên:

```text
Dùng skill release để release patch tuần này.
```

Copilot tự nhận diện `description` khớp → load procedure.

**Ví dụ 2 — skills/migrate-db/SKILL.md (copy-paste):**

```markdown
---
name: migrate-db
description: Dùng khi cần tạo/sửa DB migration an toàn, có backup.
---

# Steps
1. Đọc docs/db-conventions.md trước.
2. Backup: `pg_dump` hoặc snapshot, ghi đường dẫn backup.
3. Tạo migration 1 bảng 1 lần, không gộp 5 bảng.
4. Chạy migrate trên staging, dán log, chờ duyệt mới chạy prod.
5. Rollback plan: lệnh down + thời gian dự kiến.
```

**Ví dụ 3 — Khi nào tách skill mới:**

```text
Tách khi:
- Procedure >5 bước và dùng >1 lần/tháng.
- Cần variables + checks + rollback.
- Muốn Copilot tự trigger (không cần gọi /tên-file tay).

Không tách khi:
- Chỉ 2–3 bước → prompt file đủ.
- Luật 1 dòng → instructions đủ.
```

---

## 6. Few-shot + variables chuẩn

### Variables

| Cú pháp | Ý nghĩa | Ví dụ |
|---|---|---|
| `${input:tên}` | Hỏi khi gọi | `${input:scope}` |
| `${input:tên:default}` | Có default | `${input:planFile:plan.md}` |
| `${selection}` | Đoạn đang bôi | Dùng cho edit |
| `${file}` | File đang mở | Dùng cho review |

### Few-shot: 1 ví dụ đúng

Mọi prompt file/skill nên có 1 ví dụ input → output đúng để Copilot bắt chước.

**Ví dụ copy-paste vào cuối prompt file:**

```markdown
## Ví dụ đúng
Input: scope=src/payments, bug="refund 10k order #123 bị 500"
Output đúng:
- Root cause 3 bullet + file:line
- Fix 5 dòng trong refund.ts:42, giữ export
- Regression test 1 case, `npm test -- payments` xanh
- Evidence: log + diff --stat chỉ chạm src/payments/**
- NEVER giữ nguyên, không commit
```

Lợi ích:

- Output đồng nhất, dễ review.
- Copilot ít sáng tạo bừa.
- Người mới đọc ví dụ là hiểu cách dùng.

---

## 7. Walkthrough theo phút: đóng gói 1 prompt team

**Bối cảnh:** team bạn fix bug mỗi người một kiểu, review mệt.

| Phút | Việc | Làm gì (copy-paste) |
|---|---|---|
| 0–5 | Chọn mẫu | Lấy prompt bug bạn ưng nhất (Tips 02 Mẫu 1) |
| 5–15 | Viết file | Tạo `.github/prompts/team-bug.prompt.md` theo ví dụ 1 mục 3, thêm variables + few-shot |
| 15–20 | Test | Gọi `/team-bug scope=src/auth bugDescription="test"` trên bug thật, sửa output chưa chuẩn |
| 20–25 | Tách luật | Chuyển dòng NEVER chung vào `muse-instructions.md`, chỉ giữ luật riêng bug trong prompt file |
| 25–30 | Share | Commit + PR, nhờ 1 đồng nghiệp gọi thử, ghi feedback 3 dòng |
| 30–35 | Version | Thêm vào README team: khi nào dùng /team-bug, khi nào dùng /team-review |

Sau 35 phút: team có 1 prompt chuẩn, mọi bug output cùng format.

---

## 8. Bảng tra nhanh: dùng loại nào?

| Nhu cầu | Dùng gì | File | Gọi thế nào |
|---|---|---|---|
| Task lặp lại (bug/review/research) | Prompt file | `.github/prompts/*.prompt.md` | `/tên-file var=...` |
| Luật áp mọi turn | Root instructions | `muse-instructions.md` | Tự áp, không cần gọi |
| Luật riêng 1 module | Scoped instructions | `*.instructions.md` + applyTo | Tự áp khi chạm glob |
| Procedure >5 bước | Skill | `skills/*/SKILL.md` | Tự trigger / gọi tên skill |
| Hỏi 1 lần, không tái dùng | Chat thường | Không file | Gõ tay + new chat |
| Gate verify/report | Prompt file verify | `verify-*.prompt.md` | `/verify-feature` trước commit |

> Quy tắc ngón tay: **1 dòng → instructions, 1 task lặp → prompt file, 1 quy trình dài → skill.**

---

## 9. Pitfalls + cách fix

| Pitfall | Triệu chứng | Fix |
|---|---|---|
| Prompt file 200 dòng | Copilot quên nửa sau | <60 dòng + variables + 1 ví dụ |
| Thiếu mode/tools | Research lại sửa code | Ask cho research, agent cho implement + tools giới hạn |
| Không có variables | Mỗi lần vẫn sửa tay | ${input:...} + default cho mọi chỗ đổi |
| Không có few-shot | Output mỗi lần một kiểu | Thêm 1 ví dụ input → output đúng |
| Instructions 600 dòng | Quên, chậm | Root <200 dòng, riêng tách applyTo files |
| Glob quá rộng | Luật payments áp cả auth | Thu hẹp applyTo, 1 file 1 scope |
| Skill description chung chung | Không bao giờ trigger | 1–2 câu use-case + trigger keywords |
| Không version/commit | Mỗi máy một bản | Commit .github/ + skills/ vào repo (xem Tips 09) |
| Viết xong không test | Team gọi bị lỗi | Test trên task thật + 1 đồng nghiệp thử trước khi share |
| 10 prompt files trùng nhau | Không biết dùng cái nào | Gộp trùng, mỗi task 1 file, README index |

---

## 10. Bài tập cuối bài

**Bài 1 (15 phút — đóng gói prompt đầu tiên):**

1. Lấy prompt bạn dùng >2 lần/tuần.
2. Lưu thành `.github/prompts/my-first.prompt.md` (frontmatter + variables + few-shot).
3. Gọi lại `/my-first` trên task thật, so output trước/sau.

**Bài 2 (20 phút — tách instructions):**

1. Rút gọn `muse-instructions.md` xuống <200 dòng.
2. Tách 2 files `applyTo` cho 2 modules bạn hay sai nhất.
3. Test: nhờ Copilot sửa file trong scope, xem luật riêng có áp không?

**Bài 3 (30 phút — skill đầu tiên):**

1. Chọn 1 procedure >5 bước (release/migrate/onboarding).
2. Viết `skills/<tên>/SKILL.md` theo mẫu mục 5.
3. Nhờ Copilot dùng skill đó cho task thật, ghi lại bước nào còn thiếu.

> Đạt: sau 1 tháng, team bạn có ≥3 prompt files + instructions gọn + 1 skill, mọi output đồng format.

---

## 11. Tham khảo chéo

- Bài tips liên quan:
  - [Tips 02](./02-prompt-engineering.md) — 6 mẫu prompt để đóng gói
  - [Tips 04](./04-verification-done-that.md) — verify prompt files
  - [Tips 06](./06-policies-guardrails-recipes.md) — guardrails bằng instructions
  - [Tips 09](./09-teamwork-chuan-hoa.md) — commit + share cho team
  - [Tips 03](./03-plan-first-workflow.md) — plan prompt file

> Mẹo 1 dòng: _prompt dùng 2 lần thì đóng gói — 1 dòng thành instructions, 1 task thành prompt file, 1 quy trình thành skill._
