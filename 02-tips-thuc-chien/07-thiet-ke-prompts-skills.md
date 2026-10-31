# Tips 07 — Thiết Kế Skills & Prompts Tái Dùng: Viết 1 Lần, Cả Team Hưởng

> **Dành cho:** team 2 người trở lên đang fix bug / review / release mỗi người một kiểu.
> **Vấn đề:** prompt gõ tay lặp lại mỗi lần, output không đồng nhất, đồng nghiệp hỏi "prompt hôm qua đâu?" mà bạn không nhớ.
> **Đọc xong:** đóng gói được Agent Skills, prompt files và instructions để cả team gọi ra cùng một format.
> **Thời gian:** ~20 phút đọc + ~35 phút làm walkthrough cuối bài.

> **Lưu ý 2026:** prompt files `.prompt.md` **deprecated cho Agent Host** (Cloud) — vẫn chạy Local/VS Code. Việc mới nên ưu tiên **Agent Skills** (`SKILL.md`, chuẩn mở, chạy cả Local + Cloud + CLI). Bài này dạy cả 2, khuyến nghị skill.

## 1. Vì sao phải tái dùng?

Dấu hiệu bạn đang nợ prompt: mỗi bug gõ lại từ đầu, mỗi lần một kiểu; đồng nghiệp hỏi "prompt hôm qua là gì?" → không nhớ; team 5 người 5 cách dặn Copilot; luật quan trọng phải nhắc miệng mỗi chat.

```text
Trước: gõ 10 dòng mỗi lần × 20 lần = 200 dòng + 20 kiểu khác nhau
Sau:  viết 1 file 30 dòng, gọi lại 20 lần, output đồng nhất
```

> Rule: **prompt dùng >2 lần thì đóng gói thành file. Luật áp mọi turn thì thành instructions.**

Nợ prompt không nằm ở việc gõ 10 dòng — nằm ở chỗ mỗi lần gõ bạn *sót một dòng khác nhau*. Đóng gói biến những dòng dễ sót thành một file cố định.

## 2. Cơ chế: 3 loại tài sản tái dùng

| Loại | File | Kích hoạt | Khi dùng |
|---|---|---|---|
| Prompt files (legacy, Local) | `.github/prompts/*.prompt.md` | Gọi tay `/tên-file` | Task lặp: bug, review, research |
| Instructions | `.github/copilot-instructions.md` + `*.instructions.md` | Tự áp mọi turn / theo glob | Luật, convention, cấm địa |
| Skills (chuẩn 2026) | `.github/skills/*/SKILL.md` | Copilot tự nhận diện theo description | Procedure nhiều bước: release, migrate |

```text
Prompt = bạn gọi khi cần (chủ động).
Instructions = tự chạy ngầm (bị động).
Skill = procedure dài, Copilot tự biết khi nào dùng.
```

Nơi đặt chuẩn:

```text
.github/
  copilot-instructions.md          # luật chung <200 dòng
  instructions/
    payments.instructions.md       # applyTo: src/payments/**
  prompts/                         # legacy, chỉ Local
    team-bug.prompt.md
  skills/
    team-bug/SKILL.md              # chuẩn 2026, chạy Local + Cloud
```

Phân biệt nhanh khi chọn: nhét luật 1 dòng vào prompt file → mỗi lần phải nhớ gọi; nhét quy trình 10 bước vào prompt file → phình, quên nửa sau; nhét task lặp vào instructions → nạp lại mỗi turn, tốn credit.

## 3. Prompt files (.prompt.md) — legacy, chỉ Local

Frontmatter chuẩn:

```markdown
---
mode: agent       # ask | edit | agent
tools: [search, read, edit, test]
description: Fix bug tối thiểu + regression test
---
```

**Ví dụ — team-bug.prompt.md (copy-paste):**

```markdown
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

Gọi: `/team-bug scope=src/payments bugDescription="refund quá 30 ngày bị 500"`

> Repo cũ đã có prompt file → giữ chạy Local, port dần sang skill.

## 4. Instructions: luật tự áp theo scope

**Root instructions (<200 dòng):**

```markdown
# .github/copilot-instructions.md

## Stack
- Node 20, TypeScript strict, pnpm.

## Luật hay sai nhất (front-load lên đầu)
- Luôn chạy `npm test -- <scope>` trước khi kết luận done.
- Không sửa `src/generated/`, không commit thẳng main.
- Mọi API mới phải có test trong `__tests__/`.

## Lệnh hay dùng
- test: `npm test -- <scope>` · lint: `npm run lint` · build: `npm run build`
```

**Scoped instructions theo glob:**

```markdown
---
applyTo: "src/payments/**"
---

## Riêng payments
- Refund >30 ngày phải hỏi duyệt, không tự quyết.
- Mọi API mới phải có idempotency-key header.
- Không gọi trực tiếp DB, qua repository layer.
```

Kiểm tra chất lượng: glob càng hẹp càng tốt (`src/payments/**` tốt hơn `src/**`); mỗi file <50 dòng chỉ luật riêng scope đó; luật chung để root, không lặp lại ở files con.

## 5. Skills (SKILL.md): procedure nhiều bước

Khi procedure >5 bước, prompt file quá dài → tách thành skill.

**Ví dụ — skills/release/SKILL.md (copy-paste):**

```markdown
---
name: release
description: Dùng khi cần release version mới: bump, changelog, tag, verify CI.
allowed-tools: [shell, edit]
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

Gọi tự nhiên: `"Dùng skill release để release patch tuần này."` — Copilot tự nhận diện description khớp → load procedure.

**Khi nào tách skill:** procedure >5 bước và dùng >1 lần/tháng; cần variables + checks + rollback; muốn Copilot tự trigger. Không tách khi chỉ 2–3 bước (prompt file đủ) hoặc luật 1 dòng (instructions đủ).

> Bảo mật: skill tải từ repo ngoài có thể chứa prompt injection / script độc hại — luôn đọc kỹ SKILL.md và script tham chiếu trước khi cài, chỉ pre-approve `shell`/`bash` cho skill bạn hoàn toàn tin.

## 6. Few-shot + variables chuẩn

| Cú pháp | Ý nghĩa | Ví dụ |
|---|---|---|
| `${input:tên}` | Hỏi khi gọi | `${input:scope}` |
| `${input:tên:default}` | Có default | `${input:planFile:plan.md}` |
| `${selection}` | Đoạn đang bôi | Dùng cho edit |
| `${file}` | File đang mở | Dùng cho review |

Mọi prompt file/skill nên có **1 ví dụ input → output đúng** ở cuối để Copilot bắt chước:

```markdown
## Ví dụ đúng
Input: scope=src/payments, bug="refund 10k order #123 bị 500"
Output đúng:
- Root cause 3 bullet + file:line
- Fix 5 dòng trong refund.ts:42, giữ export
- Regression test 1 case, `npm test -- payments` xanh
- Evidence: log + diff --stat chỉ chạm src/payments/**
```

Lợi ích: output đồng nhất, dễ review, Copilot ít sáng tạo bừa, người mới đọc ví dụ là hiểu cách dùng.

## 7. Walkthrough: đóng gói 1 prompt team — 35 phút

| Phút | Việc | Làm gì |
|---|---|---|
| 0–5 | Chọn mẫu | Lấy prompt bug bạn ưng nhất (Tips 02 Mẫu 1) |
| 5–15 | Viết file | Tạo `.github/skills/team-bug/SKILL.md` + variables + few-shot (Local-only: `.github/prompts/team-bug.prompt.md` legacy) |
| 15–20 | Test | Nói "fix bug scope=src/auth" trên bug thật (skill tự load), sửa output chưa chuẩn |
| 20–25 | Tách luật | Chuyển dòng NEVER chung vào copilot-instructions.md, chỉ giữ luật riêng bug trong skill |
| 25–30 | Share | Commit + PR, nhờ 1 đồng nghiệp trigger thử, ghi feedback 3 dòng |
| 30–35 | Version | Thêm vào README team: khi nào dùng skill, khi nào review |

## 8. Bảng tra nhanh: dùng loại nào?

| Nhu cầu | Dùng gì | Gọi thế nào |
|---|---|---|
| Task lặp (bug/review/research) | **Skill** (chuẩn 2026) | Tự trigger khi khớp description (Local + Cloud) |
| Task lặp trong repo cũ chạy Local | Prompt file (legacy) | `/tên-file var=...` |
| Luật áp mọi turn | Root instructions | Tự áp, không cần gọi |
| Luật riêng 1 module | Scoped instructions + applyTo | Tự áp khi chạm glob |
| Procedure >5 bước | **Skill** | Tự trigger / gọi tên skill |
| Hỏi 1 lần, không tái dùng | Chat thường | Gõ tay + new chat |

> Quy tắc ngón tay: **1 dòng → instructions, 1 task lặp → skill (2026) / prompt file (legacy Local), 1 quy trình dài → skill.**

## 9. Pitfalls + cách fix

| Pitfall | Triệu chứng | Fix |
|---|---|---|
| Prompt file 200 dòng | Copilot quên nửa sau | <60 dòng + variables + 1 ví dụ |
| Thiếu mode/tools | Research lại sửa code | Ask cho research, agent cho implement + giới hạn tools |
| Không có variables | Mỗi lần vẫn sửa tay | `${input:...}` + default cho mọi chỗ đổi |
| Không có few-shot | Output mỗi lần một kiểu | Thêm 1 ví dụ input → output đúng |
| Instructions 600 dòng | Quên, chậm | Root <200 dòng, riêng tách applyTo files |
| Glob quá rộng | Luật payments áp cả auth | Thu hẹp applyTo, 1 file 1 scope |
| Skill description chung chung | Không bao giờ trigger | 1–2 câu use-case + trigger keywords |
| Không version/commit | Mỗi máy một bản | Commit `.github/` + skills/ vào repo (xem Tips 09) |

Ba lỗi khó chịu nhất:

```text
❌ SAI: tạo .github/prompts/release.prompt.md cho quy trình 8 bước (chỉ chạy Local)
✅ ĐÚNG: tạo .github/skills/release/SKILL.md (chuẩn chung, chạy cả Cloud)

❌ SAI: lặp "không commit main" trong cả 5 file *.instructions.md
✅ ĐÚNG: luật chung ở copilot-instructions.md, file con chỉ giữ luật riêng scope
```

## 10. Bài tập cuối bài

**Bài 1 (15 phút):** Lấy prompt dùng >2 lần/tuần, lưu thành `.github/prompts/my-first.prompt.md` (frontmatter + variables + few-shot). Gọi lại `/my-first` trên task thật, so output trước/sau.

**Bài 2 (20 phút):** Rút gọn copilot-instructions.md <200 dòng, tách 2 files applyTo cho 2 modules hay sai nhất. Test: nhờ Copilot sửa file trong scope, xem luật riêng có áp không?

**Bài 3 (30 phút):** Chọn 1 procedure >5 bước (release/migrate/onboarding), viết `skills/<tên>/SKILL.md` theo mẫu mục 5. Nhờ Copilot dùng cho task thật, ghi lại bước nào còn thiếu.

> Đạt: sau 1 tháng, team bạn có ≥3 skills/prompts + instructions gọn + 1 skill dài, mọi output đồng format.

## Tham khảo chéo

- [Tips 02](./02-prompt-engineering.md) — 6 mẫu prompt để đóng gói
- [Tips 04](./04-verification-done-that.md) — verify prompt files
- [Tips 06](./06-policies-guardrails-recipes.md) — guardrails bằng instructions
- [Tips 09](./09-teamwork-chuan-hoa.md) — commit + share cho team
- [Tips 03](./03-plan-first-workflow.md) — plan prompt file

> **Chốt Tips 07:** prompt gõ 2 lần là đã thành nợ — 1 dòng thì để instructions, 1 task lặp thì đóng gói thành file, quy trình dài thì viết `SKILL.md` theo chuẩn chung để dùng lại ở mọi harness.
