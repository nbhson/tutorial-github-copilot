# Tips 03 — Plan-First Workflow: Ask → Edit → Agent Leo Thang

> **Dành cho:** dev đã quen gõ prompt nhưng hay giao task lớn cho Copilot mà chưa có plan.
> **Vấn đề:** task >2 steps mà nhảy thẳng vào Agent → code sai spec, test đỏ, mất cả buổi revert.
> **Đọc xong:** leo thang đúng 5 nấc Ask → Plan → Edit → Agent → Coding Agent, có `plan.md` để chat nào cũng tiếp tục được.
> **Thời gian:** ~20 phút đọc + ~60 phút làm bài tập.

## 1. Vì sao phải plan-first?

Copilot code rất nhanh — nhanh tới mức nếu bạn đưa sai hướng, nó cũng "hoàn thành" sai hướng trong vài phút:

- Gõ `làm feature payments giúp tôi` → code 200 dòng sai spec, test đỏ, mất 1 giờ revert.
- Không biết nó sẽ sửa files nào → review diff như mò kim.
- Hỏi 3 lần, mỗi lần đi một hướng khác nhau.

Lợi ích đo được: 1 turn plan (vài AI Credits) tránh 10 turns code sai; plan lưu `plan.md` → chat nào, người nào, Coding Agent nào cũng tiếp tục được; bạn vẫn là người quyết định kiến trúc.

> Rule: **task >2 steps hoặc >1 file → bắt buộc plan trước.**

## 2. Cơ chế: 5 nấc thang Copilot

| Nấc | Mode | Quyền | Khi dùng |
|---|---|---|---|
| 1 | Ask | Chỉ trả lời, không sửa | Hỏi, giải thích, research |
| 2 | Plan (Ask + plan file) | Trình plan, chờ duyệt | Task >2 steps |
| 3 | Edit | Sửa files bạn chỉ định | Fix 1 chỗ, task nhỏ rõ ràng |
| 4 | Agent | Tự đọc/sửa/chạy lệnh | Task vừa, multi-files |
| 5 | Coding Agent | Làm bất đồng bộ trên GitHub issue | Task độc lập, có spec rõ |

Leo thang đúng: **luôn bắt đầu thấp nhất có thể** — Ask không xong → Plan → Edit → Agent → Coding Agent. Nấc thang chính là "mức độ tin tưởng" bạn cấp: nhảy thẳng Agent cho task mơ hồ là vừa tốn credits vừa mất kiểm soát; mãi kẹt ở Ask cho việc đáng giao Agent là tự làm chậm mình.

> Lưu ý 2026: ngoài 5 nấc trên, VS Code/CLI còn có persona **Plan** và **Autopilot** (xoay bằng `Shift+Tab` trong CLI, dropdown trong Chat) — Autopilot tự chạy tới xong, vẫn tốn AI Credits.

## 3. Nấc 1–2: Ask + Plan (không code)

Ask mode không sửa code, chỉ đọc + trả lời. Dùng để hiểu trước khi làm.

**Ví dụ 1 — Ask hiểu module (copy-paste):**

```text
@workspace Chế độ Ask, chỉ đọc không sửa.
Trong src/payments/*.ts, giải thích flow refund hiện tại:
5 bullet + file:line cho mỗi bước.
Cuối cùng liệt kê 2 rủi ro nếu đổi logic quá 30 ngày.
```

**Ví dụ 2 — Ép plan mode (copy-paste):**

```text
FEATURE: Thêm POST /api/payments/refund.

Trước khi code:
1. Đọc #file:docs/payment-spec.md + #file:src/payments/refund.ts.
2. Trình plan gồm: files sẽ đọc/sửa (đường dẫn đầy đủ),
   steps theo thứ tự, risks/edge cases, cái gì KHÔNG đụng,
   cách verify từng phase (lệnh test cụ thể).
3. Chờ tôi duyệt mới implement. Không code trong message này.
```

Điểm mấu chốt: câu `Chờ tôi duyệt` + `Không code trong message này` là bắt buộc; luôn giới hạn files đọc (2–5 files); luôn đòi verify từng phase.

**Ví dụ 3 — Phỏng vấn khi spec mờ (copy-paste):**

```text
Spec còn mờ. Trước khi lập plan, hỏi tôi tối đa 5 câu làm rõ:
- refund quá 30 ngày có cho không?
- ai được duyệt? limit bao nhiêu?
- test nào là bắt buộc xanh?
Hỏi từng câu một, khi đủ thì mới trình plan.
```

Pattern này cực hợp cho non-coder / BA: bạn chỉ trả lời, Copilot lo cấu trúc.

## 4. Nấc 3–4: Edit + Agent (code có kiểm soát)

**Edit — dao mổ cho việc nhỏ** (chỉ sửa vùng bạn chọn):

```text
# Bôi đen hàm validate() -> Ctrl/Cmd+I -> gõ:
Fix normalizeEmail crash khi email có dấu, giữ nguyên signature.
Thêm null-check đầu hàm. Không đụng code ngoài selection.
```

```text
# Mở chat Edit mới theo plan đã duyệt:
Đọc #file:plan.md. Chỉ làm Phase 1 (tách types, không đụng logic).
Sau khi sửa, chạy `npm test -- auth` và dán log.
Dừng sau Phase 1, không làm Phase 2.
```

**Agent — giao việc multi-files:**

```text
Chế độ Agent. Đọc #file:plan.md (đã duyệt).
Implement Phase 2 (thêm POST /api/payments/refund):
- Chỉ sửa files liệt kê trong plan, không thêm file ngoài.
- Cuối cùng chạy `npm test -- payments` + `npm run build`, dán cả 2 logs.
- Đỏ sau 3 lần -> dừng, báo blocker + file:line.
Ràng buộc: đừng đụng src/generated/, đừng commit.
```

Quy tắc an toàn cho Agent: luôn gắn `plan.md` đã duyệt; 1 phase / 1 chat; luôn dặn dừng sau N lần đỏ. Gate verify xem [Tips 04](./04-verification-done-that.md).

## 5. Nấc 5: Coding Agent giao issue (bất đồng bộ)

Khi plan đã rõ và việc độc lập, assign cho Copilot Coding Agent trên GitHub.

**Ví dụ 1 — Viết issue để giao (copy-paste):**

```markdown
## Mục tiêu
Thêm POST /api/payments/refund theo docs/payment-spec.md section 3.

## Scope
- Chỉ sửa src/payments/refund.ts + test liên quan.
- Không đụng src/generated/, không đổi schema.

## Plan đã duyệt
Xem plan.md trong branch `plan/refund` (paste link).

## Done
- [ ] `npm test -- payments` xanh (paste log vào PR)
- [ ] `npm run lint` 0 error
- [ ] PR chỉ chạm src/payments/** (kèm git diff --stat)
```

Assign: Issue → Assignees → Copilot → nó tự tạo branch + PR draft.

**Ví dụ 2 — Giao việc qua github.com chat (copy-paste):**

```text
@copilot Implement issue #123 theo plan trong mô tả.
Chỉ sửa trong src/payments/. Mở PR draft, dán log test xanh vào mô tả PR.
Nếu test đỏ sau 3 lần, dừng và comment blocker vào issue.
```

**Khi nào KHÔNG giao Coding Agent:** spec còn mờ / chưa có plan duyệt; task đụng nhiều team cần họp; task <15 phút tự làm nhanh hơn (Edit là xong).

> Lưu ý 2026: ngoài github.com, chạy được agent trong terminal bằng Copilot CLI (binary `copilot`, 3 chế độ Interactive/Plan/Autopilot, xoay `Shift+Tab`, `/permissions`, `/limits` giới hạn credits). Xem [Tips 11](./11-nang-cao-cli-web-coding-agent.md).

## 6. Mẫu plan.md chuẩn + prompt duyệt

```markdown
# Plan: POST /api/payments/refund

## 1. Mục tiêu (1 câu)
Thêm API refund theo spec section 3, giữ public API cũ.

## 2. Files đọc (tối đa 5)
- docs/payment-spec.md
- src/payments/refund.ts
- src/payments/__tests__/refund.test.ts

## 3. Files sửa
| File | Việc | Verify |
|---|---|---|
| src/payments/refund.ts | thêm issueRefund() | npm test -- payments |
| src/payments/__tests__/refund.test.ts | thêm 2 cases >30 ngày | npm test -- payments |

## 4. Steps
1. Phase 1: tách types (không đụng logic) -> test xanh.
2. Phase 2: thêm API + tests -> test + build xanh.
3. Phase 3: review + docs.

## 5. Risks / Edge cases
- Refund quá 30 ngày: reject hay duyệt tay?
- Idempotency khi retry 2 lần?

## 6. KHÔNG đụng
- src/generated/, DB schema, main branch.

## 7. Verify từng phase
- Phase 1: `npm test -- auth`
- Phase 2: `npm test -- payments` + `npm run build`
```

**Prompt duyệt plan (copy-paste):**

```text
Review plan trong #file:plan.md như reviewer khó tính:
- Thiếu file nào? Thừa file nào?
- Step nào chưa có verify cụ thể?
- Risk nào chưa có cách xử lý?
Trả về 3 gaps ưu tiên + gợi ý sửa 1 dòng mỗi cái.
Tôi duyệt xong mới cho implement.
```

Sau khi duyệt: `"Plan đã duyệt. Save plan.md, commit 'docs: approve refund plan'. Từ giờ mọi chat implement chỉ đọc plan.md này, không tự sáng tạo ngoài."`

## 7. Walkthrough: feature payments 60 phút

| Phút | Nấc | Việc |
|---|---|---|
| 0–10 | Ask | `"@workspace Chỉ trong src/payments/*.ts: flow refund 5 bullet + file:line. Không sửa."` → ghi findings ra plan.md |
| 10–25 | Plan | `"Đọc docs/payment-spec.md + refund.ts. Trình plan files sửa/steps/risks/KHÔNG đụng/verify. Chờ duyệt, không code."` |
| 25–30 | Duyệt | Bạn đọc plan, hỏi 2 câu rủi ro, sửa scope, commit plan.md |
| 30–45 | Edit/Agent | Chat mới: `"Đọc plan.md, chỉ làm Phase 1. Chạy npm test -- payments, dán log, dừng."` |
| 45–55 | Agent | Chat mới: `"Đọc plan.md, làm Phase 2. Chạy test + build, dán 2 logs."` |
| 55–60 | Review | Chat Reviewer fresh: `"Review diff vs plan.md, [SEVERITY] file:line, verdict PASS/NEEDS-FIX."` |

Tổng: 5 chats gọn, 1 plan duyệt, 0 lần revert lớn. Nếu giao Coding Agent: phút 30 assign issue kèm plan.md link, 2 giờ sau kiểm tra PR draft.

## 8. Bảng tra nhanh: chọn nấc nào?

| Dấu hiệu task | Nấc đúng | Prompt mẫu 1 dòng |
|---|---|---|
| Hỏi, giải thích, research | Ask | `@workspace giải thích flow X, 5 bullet, không sửa` |
| Task >2 steps / >1 file | Plan trước | `Trình plan + chờ duyệt, không code` |
| Spec mờ | Ask phỏng vấn | `Hỏi tôi tối đa 5 câu rồi mới plan` |
| Fix 1 hàm rõ ràng | Edit | `Bôi đen -> fix trong selection, giữ signature` |
| Multi-files + chạy test | Agent + plan duyệt | `Đọc plan.md, làm Phase N, dán log` |
| Việc độc lập, spec rõ, 1–2 giờ | Coding Agent | `Assign issue #X, mở PR draft + log xanh` |
| Muốn thử 2 hướng | 2 chats Plan song song | Mỗi chat 1 phương án, so pros/cons |

> Quy tắc ngón tay: **chưa có plan duyệt thì chưa cho code. Chưa rõ thì hỏi. Rõ rồi mới leo nấc.**

## 9. Pitfalls + cách fix

| Pitfall | Triệu chứng | Fix |
|---|---|---|
| Nhảy thẳng Agent cho task lớn | Code 200 dòng sai spec | Bắt buộc Ask → Plan → duyệt mới Agent |
| Plan chung chung không verify | Không biết done chưa | Mỗi phase 1 lệnh test/build cụ thể |
| Plan không ghi KHÔNG đụng | Sửa lan sang file cấm | Mọi plan đều có mục KHÔNG đụng |
| 1 chat làm cả 3 phases | Phase sau hỏng phase trước | 1 phase 1 chat fresh, đều đọc plan.md |
| Duyệt plan qua loa | Agent đi sai vẫn xanh test | Dùng prompt duyệt reviewer khó tính mục 6 |
| Giao Coding Agent khi spec mờ | PR draft sai hướng | Chỉ giao khi có plan duyệt + done checklist |
| Không save plan.md | Chat mới quên hết | Save + commit plan.md ngay sau duyệt |
| Edit cho task multi-files | Sửa chỗ này quên chỗ kia | Edit chỉ cho 1 vùng; multi-files dùng Agent |
| Quên dặn dừng khi đỏ | Agent vá 10 lần càng hỏng | Luôn dặn đỏ sau 3 lần → dừng + báo blocker |

## 10. Bài tập cuối bài

**Bài 1 (15 phút):** Liệt kê 5 tasks tuần này, gắn mỗi task 1 nấc (Ask/Plan/Edit/Agent/Coding Agent) + lý do 1 dòng. Task nào từng làm sai nấc → viết lại prompt đúng nấc.

**Bài 2 (30 phút):** Lấy 1 feature thật >2 steps, chạy đúng flow: Ask 10p → Plan 15p → duyệt 5p. Save plan.md theo mẫu mục 6, commit. Implement Phase 1 bằng chat Edit fresh, dán log xanh.

**Bài 3 (20 phút):** Viết 1 issue theo mẫu mục 5 (mục tiêu + scope + done checklist), assign Copilot, quan sát branch + PR draft. Review PR như reviewer: plan khớp không? log xanh không?

> Đạt: sau 2 tuần, 100% task >2 steps của bạn có plan.md duyệt trước khi code.

## Tham khảo chéo

- [Tips 01](./01-context-hygiene.md) — 1 task 1 chat sạch
- [Tips 02](./02-prompt-engineering.md) — 6 mẫu prompt + prompt files
- [Tips 04](./04-verification-done-that.md) — định nghĩa done + review gate
- [Tips 05](./05-parallel-agents.md) — song song hóa sau khi có plan
- [Tips 11](./11-nang-cao-cli-web-coding-agent.md) — Coding Agent + Copilot CLI + web

> **Chốt Tips 03:** vẽ bản đồ trước khi đổ bê tông — chưa có plan duyệt thì chưa cho Copilot viết dòng code nào.
