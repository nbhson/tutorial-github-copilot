# Tips 04 — Verification: Định Nghĩa Done Để Không "Xong Rồi (Chắc Vậy)"

> **Dành cho:** dev đã cho Copilot code nhưng từng bị "xong rồi" mà không có bằng chứng.
> **Vấn đề:** Copilot rất giỏi nói "đã xong"; nếu bạn tin lời, code đỏ lọt vào main.
> **Đọc xong:** có thang V1→V4, 4 checklist copy-paste, cách bắt iterate tới xanh và review gate adversarial.
> **Thời gian:** ~20 phút đọc + ~45 phút làm bài tập.

## 1. Vì sao phải định nghĩa done?

Agent không biết đúng/sai — nó chỉ *đọc* kết quả tool. Ba câu nói dối kinh điển: "Xong rồi (chắc vậy)", "Should work", "Tôi đã test kỹ rồi" (không log). Nếu bạn không tự định nghĩa "done" bằng một lệnh chạy thật, thì "done" chỉ là một câu nói — và câu nói không chặn được bug vào production.

Không có định nghĩa done: bạn merge code đỏ, mất 30 phút tự chạy lại, team không ai dám tin PR từ Copilot.

```text
Mọi prompt code đều kèm: lệnh chạy + log dán + diff kiểm tra.
Không log = chưa xong.
```

> Rule: **không evidence thì chưa done, dù code nhìn đúng.**

## 2. Thang verification 4 mức

| Mức | Tên | Evidence | Khi nào đủ |
|---|---|---|---|
| V1 | Nhìn đúng | Copilot giải thích + snippet | Hỏi, research, docs nháp |
| V2 | Chạy đúng chỗ | Focused test 1 file xanh + log | Bug nhỏ, edit 1 hàm |
| V3 | Không gãy chỗ khác | Full scope test + lint + build xanh | Feature, refactor multi-files |
| V4 | Người khác tin được | V3 + review PASS + diff gọn | Merge main, giao team, release |

```text
V2 (bug nhỏ): "Chạy `npm test -- auth` focused, dán log pass/fail. Đủ."
V3 (feature): "Chạy `npm test -- payments` + `npm run lint` + `npm run build`, dán cả 3 logs."
V4 (merge):   "V3 + review [SEVERITY] + git diff --stat chỉ chạm scope cho phép."
```

Mức V tỉ lệ thuận với độ gần main: merge mà chỉ có V2 là tuyên bố "không gãy chỗ khác" khi chưa chạy full scope; ngược lại bắt full CI cho câu hỏi "hàm này nghĩa gì" là đốt AI Credits vô ích.

## 3. Checklist done cho 4 loại task (copy-paste)

**A — BUG:**

```text
Done khi:
- [ ] Root cause giải thích 3 bullet trước khi sửa
- [ ] Fix tối thiểu, không đổi public API
- [ ] 1 regression test mới cover case này
- [ ] `npm test -- <scope>` xanh (dán log)
- [ ] `git diff --stat` chỉ chạm scope cho phép
```

**B — FEATURE:**

```text
Done khi:
- [ ] Đúng plan.md đã duyệt (không thêm scope lén)
- [ ] `npm test -- <scope>` xanh + `npm run lint` 0 error + `npm run build` pass (dán logs)
- [ ] API mới có test + docs cập nhật
- [ ] Ràng buộc NEVER giữ nguyên (generated/, schema, main)
```

**C — REFACTOR:**

```text
Done khi:
- [ ] Public API giữ nguyên (import cũ vẫn chạy)
- [ ] Full test scope xanh sau mỗi bước (dán log từng bước)
- [ ] `git diff --stat` gọn, không lẫn feature mới
- [ ] Không thêm dependency, không đổi config
- [ ] Reviewer fresh verdict PASS
```

**D — DOCS / DATA:**

```text
Done khi:
- [ ] Mỗi số liệu kèm evidence (quote/file:line/wc -l)
- [ ] Đối chiếu chéo totals vs raw, lệch thì báo
- [ ] Output đúng format yêu cầu (table/checklist/JSON)
- [ ] Confidence 1 dòng: cao/trung/thấp vì...
- [ ] Không sửa/xóa file gốc
```

Mẹo team: lưu 4 checklist vào `.github/prompts/verify-*.prompt.md` để gọi `/verify-bug`, `/verify-feature`; nếu chạy Agent Host thì gói thành Agent Skills (`SKILL.md`) — xem [Tips 07](./07-thiet-ke-prompts-skills.md).

## 4. Bắt Copilot iterate tới xanh

**Loop tới xanh (thêm vào mọi prompt code):**

```text
Sau khi sửa, chạy `npm test -- payments` và dán log pass/fail.
Nếu đỏ, fix tiếp trong message này tới khi xanh hoặc dừng sau 3 lần và báo blocker + file:line.
```

**Cấm xóa test để xanh (bắt buộc):**

```text
Tuyệt đối không xóa/sửa test cũ để cho xanh, không skip test,
không dùng --passWithNoTests để lách.
Nếu test cũ sai thật, báo lý do + file:line và chờ tôi quyết.
```

Vì sao cần câu này? Vì Copilot (và cả dev vội) rất hay lách bằng cách xóa test khó — bạn tưởng đã sửa xong, thực ra vừa giấu bug đi.

**Dặn dán evidence đúng chỗ:**

```text
Cuối message luôn có mục:
## Evidence
- test: [paste 10 dòng cuối log]
- lint: [paste log]
- diff: [paste git diff --stat]
Không có mục này = chưa xong, đừng nói done.
```

## 5. Copilot review gate: reviewer khó tính

Đừng để người viết tự review. Mở chat mới (chưa thấy reasoning cũ) với prompt adversarial:

```text
Review diff hiện tại với plan trong #file:plan.md.
- Finding = bug/correctness/security/test-gap thực sự. Bỏ qua style.
- Trả về: [SEVERITY: HIGH/MED/LOW] file:line — mô tả 1 dòng — gợi ý fix 1 dòng.
- Cuối cùng: verdict PASS / NEEDS-FIX + 3 gaps ưu tiên cao nhất.
```

**Calibration — reviewer không dễ dãi:**

```text
Bạn là reviewer khó tính. Không được nói LGTM nếu còn 1 trong:
- thiếu regression test cho bug vừa fix,
- public API đổi mà không báo,
- test chỉ chạy 1 file mà claim không gãy chỗ khác,
- diff chạm file ngoài scope.
Tìm ít nhất 1 HIGH hoặc giải thích vì sao chắc chắn không có HIGH.
```

**Bật Copilot code review (setup):**

```text
Repo -> Settings -> Code review -> Copilot review: bật cho mọi PR.
Rule: PR từ Copilot Coding Agent bắt buộc có 1 review người + Copilot review PASS mới merge.
Branch protection: require status checks (test/lint/build) + require review.
```

Kết hợp 3 nguồn: Copilot code review quét mỗi PR (rẻ, nhanh) → chat Reviewer fresh soi sâu trước merge → người review cuối chốt và chịu trách nhiệm.

> Lưu ý 2026: review Balanced (mặc định từ 28/09/2026) tốn AI Credits + GitHub Actions minutes.

## 6. Walkthrough: fix bug tới xanh trong 30 phút

Bối cảnh: login email có dấu bị 500, file `src/auth/login.ts:42`.

| Phút | Việc | Prompt / lệnh |
|---|---|---|
| 0–2 | Chat Edit, gắn hẹp | Bôi đen hàm → `"#selection Root cause 3 bullet trước khi sửa. Fix tối thiểu, giữ export."` |
| 2–10 | Fix + regression test | `"Thêm 1 regression test email có dấu. Chạy npm test -- auth, dán log."` |
| 10–15 | Loop tới xanh | Nếu đỏ → `"Fix tiếp trong message này, tối đa 3 lần, dán log mỗi lần."` |
| 15–20 | Mở rộng V3 | `"Chạy thêm npm run lint + npm run build. Diff --stat chỉ chạm src/auth/**?"` |
| 20–28 | Review gate | Chat Reviewer fresh → prompt mục 5 → PASS/NEEDS-FIX |
| 28–30 | Chốt done | Checklist BUG mục 3 tick đủ → commit `fix: normalizeEmail dau + regression test` |

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

## 8. So sánh với Claude Code

| Việc | Copilot | Claude Code | Ghi chú |
|---|---|---|---|
| Ai chạy lệnh verify | Bạn dặn Copilot chạy test/lint/build | Bạn dặn Claude Code chạy lệnh | Không agent nào tự chịu trách nhiệm đúng/sai |
| Dán bằng chứng vào PR | `## Evidence` (logs + `diff --stat`) | Cùng cách — log vào mô tả PR | Thói quen của *bạn*, không phải tính năng |
| Review tự động trên PR | **Copilot code review** bật sẵn cho repo | CI + review người, không có bot review tương đương | Copilot có bot review tích hợp |
| Reviewer "fresh" | Chat mới (agent Reviewer) | Mở phiên mới để review | Cả hai đều cần phiên sạch |
| Chống xóa test để lách | Cấm trong prompt | Cấm trong prompt | Vấn đề nằm ở agent, không ở nhà cung cấp |

## 9. Pitfalls + cách fix

| Pitfall | Triệu chứng | Fix |
|---|---|---|
| Tin should work | Production gãy sau merge | Không log = chưa done, bắt dán log |
| Chỉ chạy 1 file rồi claim xong | Sửa A hỏng B | Feature/refactor phải full scope + build |
| Xóa test để xanh | Test xanh giả | Cấm xóa/sửa test trong prompt (mục 4) |
| Reviewer tự review | LGTM mù | Luôn chat Reviewer fresh + Copilot PR review |
| Diff lẫn 5 việc | Review không nổi | 1 task 1 branch/PR, diff --stat kiểm tra scope |
| Quên lint/build | CI đỏ sau push | Mọi prompt feature đều có 3 logs |
| Dán log cắt đầu cắt đuôi | Giấu lỗi | Dặn paste 10 dòng cuối + exit code |
| Verify bằng mắt | Quên edge case | Checklist A–D tick đủ mới commit |

## 10. Bài tập cuối bài

**Bài 1 (10 phút):** Lấy 1 prompt code gần nhất, thêm 1 lệnh verify + dặn dán log + 1 dòng NEVER + mục Evidence. Chạy lại, so số turns trước/sau.

**Bài 2 (20 phút):** Lấy 1 PR/diff gần nhất, mở chat Reviewer fresh với prompt mục 5. Ghi lại mấy HIGH/MED/LOW, có gap nào bạn bỏ sót không? Bật Copilot code review cho repo, so findings 2 nguồn.

**Bài 3 (15 phút):** Lưu 4 checklist mục 3 thành `.github/prompts/verify-*.prompt.md` (hoặc Agent Skills). Thêm vào CONTRIBUTING: mọi PR phải có Evidence. Bật branch protection require checks + review (xem Tips 06).

> Đạt: sau 2 tuần, 100% PR từ Copilot của bạn có log xanh dán kèm, 0 PR should work.

## Tham khảo chéo

- [Tips 02](./02-prompt-engineering.md) — viết verify + NEVER ngay trong prompt
- [Tips 03](./03-plan-first-workflow.md) — plan có verify từng phase
- [Tips 06](./06-policies-guardrails-recipes.md) — branch protection + pre-commit recipes
- [Tips 09](./09-teamwork-chuan-hoa.md) — chuẩn hóa review workflow cho team
- [Tips 10](./10-debugging-power-moves.md) — test failure loop khi đỏ

> **Chốt Tips 04:** một dòng log xanh đáng giá hơn mười câu "should work" — bắt Copilot chứng minh, đừng tin lời hứa.
