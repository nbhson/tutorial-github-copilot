# Tips 04 — Verification: Định Nghĩa Done Để Không "Xong Rồi (Chắc Vậy)"

> Copilot rất giỏi nói "đã xong". Việc của bạn là bắt nó chứng minh: test/lint/build xanh, verification checklist, Copilot review gate. Bài này cho bạn thang done, 4 checklist copy-paste, cách bắt iterate và review adversarial.

## Mục lục

- [1. Vì sao phải định nghĩa done?](#1-vì-sao-phải-định-nghĩa-done)
- [2. Thang verification 4 mức](#2-thang-verification-4-mức)
- [3. Checklist done cho 4 loại task](#3-checklist-done-cho-4-loại-task)
- [4. Bắt Copilot iterate tới xanh](#4-bắt-copilot-iterate-tới-xanh)
- [5. Copilot review gate: reviewer khó tính](#5-copilot-review-gate-reviewer-khó-tính)
- [6. Walkthrough theo phút: fix bug tới xanh](#6-walkthrough-theo-phút-fix-bug-tới-xanh)
- [7. Bảng tra nhanh: evidence nào cho task nào?](#7-bảng-tra-nhanh-evidence-nào-cho-task-nào)
- [8. Pitfalls + cách fix](#8-pitfalls--cách-fix)
- [9. Bài tập cuối bài](#9-bài-tập-cuối-bài)
- [10. Tham khảo chéo](#10-tham-khảo-chéo)

---

## 1. Vì sao phải định nghĩa done?

Ba câu nói dối kinh điển của AI (và của cả con người):

- "Xong rồi (chắc vậy)."
- "Should work."
- "Tôi đã test kỹ rồi" (nhưng không có log).

Không có định nghĩa done:

- Bạn merge code đỏ, production gãy.
- Bạn mất 30 phút tự chạy lại những gì Copilot lẽ ra phải chạy.
- Team không ai dám tin PR từ Copilot.

Có định nghĩa done:

```text
Mọi prompt code đều kèm: lệnh chạy + log dán + diff kiểm tra.
Không log = chưa xong.
```

> Rule: **không evidence thì chưa done, dù code nhìn đúng.**

---

## 2. Thang verification 4 mức

| Mức | Tên | Evidence | Khi nào đủ |
|---|---|---|---|
| V1 | Nhìn đúng | Copilot giải thích + snippet | Chỉ cho hỏi, research, docs nháp |
| V2 | Chạy đúng chỗ | Focused test 1 file xanh + log | Bug nhỏ, edit 1 hàm |
| V3 | Không gãy chỗ khác | Full scope test + lint + build xanh | Feature, refactor multi-files |
| V4 | Người khác tin được | V3 + review PASS + diff gọn | Merge main, giao team, release |

Leo thang:

- Fix 1 hàm → ít nhất V2.
- Thêm API, refactor → ít nhất V3.
- Merge, release, giao khách → V4.

**Ví dụ phân biệt (copy-paste để dặn Copilot):**

```text
V2 (bug nhỏ): "Chạy `npm test -- auth` focused, dán log pass/fail. Đủ."
V3 (feature): "Chạy `npm test -- payments` + `npm run lint` + `npm run build`, dán cả 3 logs."
V4 (merge): "V3 + review [SEVERITY] + git diff --stat chỉ chạm scope cho phép."
```

---

## 3. Checklist done cho 4 loại task

### Checklist A — BUG (copy-paste vào prompt)

```text
Done khi:
- [ ] Root cause giải thích 3 bullet trước khi sửa
- [ ] Fix tối thiểu, không đổi public API
- [ ] 1 regression test mới cover case này
- [ ] `npm test -- <scope>` xanh (dán log)
- [ ] `git diff --stat` chỉ chạm scope cho phép
```

### Checklist B — FEATURE (copy-paste)

```text
Done khi:
- [ ] Đúng plan.md đã duyệt (không thêm scope lén)
- [ ] `npm test -- <scope>` xanh (dán log)
- [ ] `npm run lint` 0 error (dán log)
- [ ] `npm run build` pass (dán log)
- [ ] API mới có test + docs cập nhật
- [ ] Ràng buộc NEVER giữ nguyên (generated/, schema, main)
```

### Checklist C — REFACTOR (copy-paste)

```text
Done khi:
- [ ] Public API giữ nguyên (import cũ vẫn chạy)
- [ ] Full test scope xanh sau mỗi bước (dán log từng bước)
- [ ] `git diff --stat` gọn, không lẫn feature mới
- [ ] Không thêm dependency, không đổi config
- [ ] Reviewer fresh verdict PASS
```

### Checklist D — DOCS / DATA (copy-paste)

```text
Done khi:
- [ ] Mỗi số liệu kèm evidence (quote/file:line/wc -l)
- [ ] Đối chiếu chéo totals vs raw, lệch thì báo
- [ ] Output đúng format yêu cầu (table/checklist/JSON)
- [ ] Confidence 1 dòng: cao/trung/thấp vì...
- [ ] Không sửa/xóa file gốc
```

Mẹo team: lưu 4 checklist này vào `.github/prompts/verify-*.prompt.md` để gọi `/verify-bug`, `/verify-feature` (xem [Tips 07](./07-thiet-ke-prompts-skills.md)).

---

## 4. Bắt Copilot iterate tới xanh

### Công thức 1 câu quyền lực

Thêm câu này vào mọi prompt code, Copilot tự chạy → đọc lỗi → sửa → chạy lại:

**Ví dụ 1 — Loop tới xanh (copy-paste):**

```text
Sau khi sửa, chạy `npm test -- payments` và dán log pass/fail.
Nếu đỏ, fix tiếp trong message này tới khi xanh hoặc dừng sau 3 lần và báo blocker + file:line.
```

**Ví dụ 2 — Loop 3 lệnh (copy-paste):**

```text
Verify 3 bước, dán cả 3 logs ở cuối:
1. `npm test -- payments`
2. `npm run lint`
3. `npm run build`
Bước nào đỏ thì fix ngay trong message này (tối đa 3 lần), rồi chạy lại từ bước 1.
```

**Ví dụ 3 — Cấm xóa test để xanh (copy-paste):**

```text
Tuyệt đối không xóa/sửa test cũ để cho xanh, không skip test,
không dùng --passWithNoTests để lách.
Nếu test cũ sai thật, báo lý do + file:line và chờ tôi quyết.
```

Vì sao cần câu 3? Vì Copilot (và cả dev vội) rất hay lách bằng cách xóa test khó. Bạn phải cấm trước.

### Dặn dán evidence đúng chỗ

```text
Cuối message luôn có mục:
## Evidence
- test: [paste 10 dòng cuối log]
- lint: [paste log]
- diff: [paste git diff --stat]
Không có mục này = chưa xong, đừng nói done.
```

### Checklist nhanh trước khi commit (copy-paste)

```text
- [ ] Lệnh test đúng scope? Log xanh thật?
- [ ] Lint + build đã chạy (nếu feature/refactor)?
- [ ] Diff --stat chỉ chạm scope cho phép?
- [ ] Regression test cho bug? API mới có test?
- [ ] Reviewer fresh PASS (nếu merge)?
- [ ] Evidence đã paste vào PR mô tả?
```

---

## 5. Copilot review gate: reviewer khó tính

Đừng để người viết tự review. Mở chat mới (agent Reviewer hoặc github.com review) với prompt adversarial.

**Ví dụ 1 — Reviewer fresh (copy-paste):**

```text
# Mở chat mới, chưa thấy reasoning cũ
Review diff hiện tại với plan trong #file:plan.md.
- Finding = bug/correctness/security/test-gap thực sự. Bỏ qua style.
- Trả về: [SEVERITY: HIGH/MED/LOW] file:line — mô tả 1 dòng — gợi ý fix 1 dòng.
- Cuối cùng: verdict PASS / NEEDS-FIX + 3 gaps ưu tiên cao nhất.
```

**Ví dụ 2 — Calibration: reviewer không dễ dãi (copy-paste):**

```text
Bạn là reviewer khó tính. Không được nói LGTM nếu còn 1 trong:
- thiếu regression test cho bug vừa fix,
- public API đổi mà không báo,
- test chỉ chạy 1 file mà claim không gãy chỗ khác,
- diff chạm file ngoài scope.
Tìm ít nhất 1 HIGH hoặc giải thích vì sao chắc chắn không có HIGH.
```

**Ví dụ 3 — Dùng GitHub Copilot code review (copy-paste setup):**

```text
Repo → Settings → Code review → Copilot review: bật cho mọi PR.
Rule: PR từ Copilot Coding Agent bắt buộc có 1 review người + Copilot review PASS mới merge.
Branch protection: require status checks (test/lint/build) + require review.
```

Kết hợp:

- Copilot review tự động quét mỗi PR (rẻ, nhanh).
- Chat Reviewer fresh soi sâu trước merge (kỹ).
- Người review cuối chốt (chịu trách nhiệm).

---

## 6. Walkthrough theo phút: fix bug tới xanh

**Bối cảnh:** login email có dấu bị 500, file `src/auth/login.ts:42`.

| Phút | Việc | Prompt / lệnh (copy-paste) |
|---|---|---|
| 0–2 | Mở chat Edit, gắn hẹp | Bôi đen hàm → `"#selection Root cause 3 bullet trước khi sửa. Fix tối thiểu, giữ export."` |
| 2–10 | Fix + regression test | `"Thêm 1 regression test email có dấu. Chạy npm test -- auth, dán log."` |
| 10–15 | Loop tới xanh | Nếu đỏ → `"Fix tiếp trong message này, tối đa 3 lần, dán log mỗi lần."` |
| 15–20 | Mở rộng V3 | `"Chạy thêm npm run lint + npm run build, dán 2 logs. Diff --stat chỉ chạm src/auth/**?"` |
| 20–28 | Review gate | Mở chat Reviewer fresh → prompt mục 5 → verdict PASS/NEEDS-FIX |
| 28–30 | Chốt done | Checklist BUG mục 3 tick đủ → commit `fix: normalizeEmail dấu + regression test` |

Tổng 30 phút, có log xanh + review PASS. Không còn should work.

---

## 7. Bảng tra nhanh: evidence nào cho task nào?

| Task | Test | Lint/Build | Diff | Review | Dòng dặn 1 câu |
|---|---|---|---|---|---|
| Hỏi / research | Không | Không | Không | Không | `Chỉ trả lời, không sửa` |
| Fix 1 hàm | Focused 1 file | Không bắt buộc | --stat | Không bắt buộc | `Chạy focused test + dán log` |
| Bug + regression | Focused + case mới | Lint file | --stat scope | Nên có | `Thêm regression + test xanh` |
| Feature multi-files | Full scope | Lint + build | --stat scope | Bắt buộc fresh | `3 logs + review PASS` |
| Refactor | Full scope từng bước | Lint + build | --stat gọn | Bắt buộc fresh | `Mỗi bước 1 log xanh` |
| Merge main | Full CI xanh | Full CI | PR diff | Người + Copilot | `CI xanh + 2 reviews` |

> Quy tắc ngón tay: **càng gần main càng cần evidence nặng. Hỏi thì V1 đủ, merge thì phải V4.**

---

## 8. Pitfalls + cách fix

| Pitfall | Triệu chứng | Fix |
|---|---|---|
| Tin should work | Production gãy sau merge | Không log = chưa done, bắt dán log |
| Chỉ chạy 1 file rồi claim xong | Sửa A hỏng B | Feature/refactor phải full scope + build |
| Xóa test để xanh | Test xanh giả | Cấm xóa/sửa test trong prompt (ví dụ 3 mục 4) |
| Reviewer tự review | LGTM mù | Luôn chat Reviewer fresh + Copilot PR review |
| Diff lẫn 5 việc | Review không nổi | 1 task 1 branch/PR, diff --stat kiểm tra scope |
| Quên lint/build | CI đỏ sau push | Mọi prompt feature đều có 3 logs |
| Dán log cắt đầu cắt đuôi | Giấu lỗi | Dặn paste 10 dòng cuối + exit code |
| Không lưu evidence vào PR | Người sau không tin | Paste logs vào mô tả PR, link CI run |
| Verify bằng mắt | Quên edge case | Checklist A–D mục 3 tick đủ mới commit |

---

## 9. Bài tập cuối bài

**Bài 1 (10 phút — gắn done vào prompt cũ):**

1. Lấy 1 prompt code gần nhất của bạn.
2. Thêm: 1 lệnh verify + dặn dán log + 1 dòng NEVER + mục Evidence.
3. Chạy lại, so số turns trước/sau.

**Bài 2 (20 phút — review gate thật):**

1. Lấy 1 PR/diff gần nhất, mở chat Reviewer fresh với prompt mục 5.
2. Ghi lại: mấy HIGH/MED/LOW? Có gap nào bạn bỏ sót không?
3. Bật Copilot code review cho repo, so findings 2 nguồn.

**Bài 3 (15 phút — chuẩn hóa team):**

1. Lưu 4 checklist mục 3 thành `.github/prompts/verify-*.prompt.md`.
2. Thêm vào CONTRIBUTING: mọi PR phải có Evidence (test/lint/build logs).
3. Bật branch protection: require checks + review (xem Tips 06).

> Đạt: sau 2 tuần, 100% PR từ Copilot của bạn có log xanh dán kèm, 0 PR should work.

---

## 10. Tham khảo chéo

- Bài tips liên quan:
  - [Tips 02](./02-prompt-engineering.md) — viết verify + NEVER ngay trong prompt
  - [Tips 03](./03-plan-first-workflow.md) — plan có verify từng phase
  - [Tips 06](./06-policies-guardrails-recipes.md) — branch protection + pre-commit recipes
  - [Tips 09](./09-teamwork-chuan-hoa.md) — chuẩn hóa review workflow cho team
  - [Tips 10](./10-debugging-power-moves.md) — test failure loop khi đỏ

> Mẹo 1 dòng: _không log thì chưa done — bắt Copilot dán test/lint/build xanh trước khi nói xong._
