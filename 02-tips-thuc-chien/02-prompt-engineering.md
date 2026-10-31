# Tips 02 — Prompt Engineering Cho Copilot: Viết Sao, Ra Vậy

> **Dành cho:** dev (và cả non-coder) đã biết gõ prompt cho Copilot nhưng kết quả hay lệch, phải sửa lại nhiều lượt.
> **Vấn đề:** prompt ẩu khiến Copilot đọc lan, sửa thừa, "xong rồi chắc vậy" — tốn turns và tốn AI Credits.
> **Đọc xong:** viết được prompt đủ 4 thành phần + verify + ràng buộc NEVER, dùng 6 mẫu theo task, và tự chấm prompt bằng checklist trước khi Enter.
> **Thời gian:** ~15 phút đọc + ~45 phút làm bài tập cuối bài.

## 1. Vì sao prompt quyết định output?

Copilot không đọc được ý nghĩ. Nguyên nhân số 1 của "sửa lan man, đọc 100 files, đổi API không hỏi" không phải model lười, mà là bạn cho nó **quyền tự do quá rộng**:

- `"fix login"` không scope → model tự đoán scope, tự đoán done, tự đoán verify.
- `"@workspace investigate auth"` với repo 500 files → mời model đi lạc.

Mỗi prompt tốt làm 3 việc:

1. **Thu hẹp search space:** từ 500 files → 5 files; từ "làm gì cũng được" → chỉ làm X.
2. **Định nghĩa done check được:** từ "cho sạch" → `npm test payments` xanh.
3. **Gài vòng lặp tự sửa:** "chạy X và iterate trong message này" → Copilot tự retry thay vì xong rồi chắc vậy.

Đắt rẻ: viết prompt kỹ 2 phút tiết kiệm 20 phút restore + retry. Plan-first ([Tips 03](./03-plan-first-workflow.md)) chính là "prompt đắt" cho task lớn — trả 1 turn plan để tránh 10 turns code sai.

## 2. Giải phẫu prompt tốt: 4 thành phần

**1 — Scope files nào** (càng cụ thể càng rẻ):

```text
TỐT: "#file:src/auth/login.ts + #file:src/auth/__tests__/login.test.ts"
TỐT: "Scope src/payments/*.ts, đừng đụng src/legacy/"
TỆ:  "@workspace đọc cả repo rồi cho ý kiến"
```

Mẹo: bôi đen code dùng `#selection`; file >1000 dòng thì tóm tắt từng phần. Non-code: thay files bằng nguồn — `docs/sprint-12.md`, `data/feedback-q3.csv`.

**2 — Mục tiêu end-state** (trạng thái cuối, không phải hoạt động):

```text
TỆ (activity):  "Xem giúp auth" / "Refactor cho sạch" / "Analyze data"
TỐT (end-state): "Top 5 complaints theo frequency, mỗi dòng: quote + count + segment, markdown table"
```

Công thức: **động từ + đối tượng + tiêu chuẩn chấp nhận**.

**3 — Độ phân giải:** columns nào, quotes, counts, edge cases?

```text
TỐT: "Mỗi dòng: quote nguyên văn + count + segment. Đối chiếu totals ở summary vs raw, lệch thì fix trước khi show."
TỆ:  "Cho chi tiết vào" (chi tiết gì? bao nhiêu là đủ?)
```

**4 — Format output:**

```text
TỐT: "Output markdown table: | File | Việc | Verify |"
TỐT: "Trả về JSON: {files: [...], risks: [...], verify: '...'}"
```

**Ví dụ tổng hợp (copy-paste):**

```text
Đọc #file:data/feedback-q3.csv. Tìm top 5 complaints theo frequency.
Mỗi dòng: quote nguyên văn + count + segment. Output markdown table.
Xong đối chiếu totals ở summary vs raw, lệch thì fix trước khi show.
Không tạo file mới, chỉ trả lời trong chat.
```

## 3. Ba gia vị nâng chất lượng

1. **Success criteria** — done phải check được bằng lệnh: `Done = npm test -- payments xanh + npm run lint 0 error` (xem [Tips 04](./04-verification-done-that.md)).
2. **Cách verify** — bắt Copilot tự iterate:

```text
"Sau khi sửa, chạy `npm test -- payments` và dán log pass/fail.
Nếu đỏ, fix tiếp trong message này tới khi xanh hoặc dừng sau 3 lần và báo blocker."
```

3. **Ràng buộc NEVER** — không dặn là nó sẽ đụng:

```text
"Đừng đụng `src/generated/`, đừng đổi DB schema, đừng commit thẳng main, đừng thêm dependency mới."
"Không tạo file mới nếu chưa hỏi. Không xóa test cũ để cho xanh."
```

Mẹo: gom ràng buộc chung vào `.github/copilot-instructions.md` (<200 dòng), chỉ để ràng buộc riêng task trong prompt.

## 4. Sáu mẫu prompt theo task (copy-paste)

**Mẫu 1 — BUG:**

```text
BUG: Tái hiện lỗi [mô tả + steps + log kèm].
1. Tìm root cause trong #file:<module>, giải thích 3 bullet trước khi sửa.
2. Fix tối thiểu, không refactor, không đổi public API.
3. Thêm 1 regression test cover case này.
4. Chạy `npm test -- <scope>` và dán kết quả. Đỏ thì fix tiếp trong message này.
Ràng buộc: đừng đụng <cấm địa>.
```

**Mẫu 2 — FEATURE (plan trước, code sau):**

```text
FEATURE: Tôi muốn <mục tiêu 1 câu>.
Trước khi code:
1. Đọc <tối đa 3 files, ghi #file đường dẫn>.
2. Trình plan: files sẽ đọc/sửa, steps, risks/edge cases, cái gì KHÔNG đụng, verify từng phase.
3. Chờ tôi duyệt mới implement. Không code trong message này.
```

**Mẫu 3 — REFACTOR (giữ API + gate từng bước):**

```text
REFACTOR: Tách file <X ~900 dòng> thành modules <login, session, types>.
- Giữ nguyên public API (export cũ vẫn import được).
- Làm từng bước nhỏ, chạy full test sau mỗi bước, dán log.
- Dừng và báo ngay nếu test đỏ. Cuối cùng dán `git diff --stat` + log test xanh.
```

**Mẫu 4 — RESEARCH (scope hẹp + output chuẩn):**

```text
RESEARCH: @workspace Chỉ trong <glob hẹp, vd src/payments/refund*>:
- Không sửa code, chỉ đọc.
- Trả về: files liên quan + flow hiện tại (5-8 bullet) + 2 phương án (pros/cons).
- Ghi findings ra plan.md rồi dừng.
```

**Mẫu 5 — REVIEW (adversarial, có severity):**

```text
REVIEW: Review diff hiện tại với plan trong #file:plan.md.
- Finding = bug/correctness/security/test-gap thực sự. Bỏ qua style.
- Trả về: [SEVERITY: HIGH/MED/LOW] file:line — mô tả — gợi ý fix.
- Cuối cùng: verdict PASS / NEEDS-FIX + 3 gaps ưu tiên cao nhất.
```

**Mẫu 6 — DATA / DOCS (cho non-coder + coder):**

```text
DATA: Đọc #file:<csv/docs>. Tìm <câu hỏi cụ thể>.
Mỗi kết quả kèm evidence: quote/số dòng/file:line.
Output: table + 3 bullet insight + confidence 1 dòng.
```

## 5. Đóng gói prompt tái dùng

Viết mẫu 6 lần → lần 7 vẫn gõ lại. Lưu vào `.github/prompts/*.prompt.md`, gọi `/tên-file`, team dùng chung:

```markdown
---
mode: agent
tools: [search, read, edit, test]
description: Fix bug tối thiểu + regression test
---

## Nhiệm vụ
Fix bug mô tả trong ${input:bugDescription} tại ${input:scope}.

## Steps
1. Đọc ${input:scope} + test liên quan, giải thích root cause 3 bullet.
2. Fix tối thiểu, không đổi public API. 3. Thêm 1 regression test.
4. Chạy `npm test -- ${input:scope}` và dán log.

## Ràng buộc
- Đừng đụng src/generated/, đừng commit thẳng main.
- Đỏ sau 3 lần -> dừng và báo blocker.
```

Gọi: `/bug-fix scope=src/payments bugDescription="refund quá 30 ngày bị 500"`

> **Lưu ý 2026:** prompt files `.prompt.md` đã deprecated cho Agent Host (Cloud) — vẫn chạy Local/VS Code. Việc mới nên chuyển sang **Agent Skills** (`SKILL.md`, chuẩn mở, chạy mọi harness). Xem [Tips 07](./07-thiet-ke-prompts-skills.md).

## 6. Walkthrough: từ prompt tệ tới prompt tốt

Tình huống: refactor file `auth.ts` 800 dòng.

| Round | Prompt | Kết quả |
|---|---|---|
| 0 — tệ | `"Refactor auth cho sạch"` | Đọc 40 files, đổi API, thêm dep, test đỏ 5 chỗ, mất 45 phút restore |
| 1 — thêm scope + end-state | `"Refactor #file:src/auth.ts thành 3 modules login/session/types. Giữ public API."` | Đỡ hơn nhưng không tự chạy test, phải nhắc 2 turns |
| 2 — đạt chuẩn | Xem dưới | 1 turn plan + 3 turns implement sạch, tổng 15 phút |

```text
Refactor #file:src/auth.ts (~800 dòng) thành src/auth/login.ts, session.ts, types.ts.
Giữ nguyên public API (file cũ re-export để không gãy import).
Sau mỗi bước chạy `npm test -- auth` và dán log. Đỏ thì dừng và báo.
Đừng đụng src/generated/, đừng thêm dep mới, đừng commit.
Trước khi code, trình outline 5 bullet files/hàm sẽ di chuyển và chờ duyệt.
```

Bài học: **mỗi vòng thêm 1 thành phần (scope → end-state → verify → constraints → format) là bớt 2–3 turns sửa.**

## 7. Bảng sai → sửa

| Sai (prompt ẩu) | Vì sao hỏng | Sửa |
|---|---|---|
| `"investigate auth"` không scope | Đọc 300 files, tốn credits | Khoanh module + câu hỏi + output format |
| 1 prompt 5 việc | Sửa A hỏng B | Tách prompts/chats, mỗi cái 1 việc |
| Không cho cách verify | "Xong rồi (chắc vậy)" | Luôn kèm lệnh test/lint/log/diff + dán evidence |
| Mô tả solution thay vì problem | Ép model theo hướng sai | Mô tả problem + constraints, để Ask đề xuất solution |
| Không format output | Nhận prose 100 dòng khó review | Ép format: table / checklist / file:line |
| Không dùng prompt files/skills | 5 người 5 kiểu prompt | Đóng gói theo [Tips 07](./07-thiet-ke-prompts-skills.md) |

### Non-coder guide

Cùng công thức 4 thành phần, chỉ thay từ ngữ: files → nguồn (data folder, docs, sheet); test xanh → đối chiếu số liệu (totals, wc -l); diff → so sánh trước/sau.

```text
"Đọc thư mục data/feedback/. Tìm 3 lý do khách phàn nàn nhiều nhất tháng này.
Mỗi lý do kèm 2 quotes + số lượng. Output table.
Đối chiếu tổng với summary.xlsx, lệch thì báo. Không sửa file gốc."
```

Prompt khởi động: `"Phỏng vấn tôi để hiểu project này, hỏi từng câu một: project làm gì, dữ liệu ở đâu, output muốn gì, cái gì không được đụng. Khi đủ thì tạo copilot-instructions.md <100 dòng."`

## 8. Checklist trước khi Enter

- [ ] Có **scope** cụ thể (#file/#selection/glob)?
- [ ] Có **mục tiêu end-state** (xong thì trông thế nào)?
- [ ] Có **độ phân giải** (columns, counts, edge cases)?
- [ ] Có **format output** (table, plan, JSON, bullet + file:line)?
- [ ] Có **success criteria** check được bằng lệnh/số?
- [ ] Có **cách verify** + dặn iterate trong message?
- [ ] Có **ràng buộc NEVER** (cấm địa, không commit, không đổi API)?
- [ ] Task >1 file hoặc >2 steps → đã thêm **trình plan, chờ duyệt**?
- [ ] File >1000 dòng → đã tách hoặc tóm tắt?
- [ ] 1 prompt 1 việc (không gộp 5 việc)?

> Tick đủ 10 ô → prompt của bạn thuộc top 5%.

## 9. Bài tập cuối bài

**Bài 1 (10 phút):** Lấy 3 prompts gần nhất, chấm theo 4 thành phần — thiếu mảnh nào? Viết lại prompt tệ nhất thành bản đủ 4 mảnh + verify + NEVER.

**Bài 2 (20 phút):** Lấy 1 bug thật + 1 feature thật: prompt bug theo Mẫu 1, feature theo Mẫu 2 (plan trước). Mục tiêu: bug ≤4 turns tới done.

**Bài 3 (15 phút):** Lấy prompt dùng >2 lần/tuần, lưu thành `.github/prompts/team-bug.prompt.md` (frontmatter + variables + 1 few-shot). Nhờ 1 đồng nghiệp gọi `/team-bug` và cho feedback về tính đồng nhất.

> Đạt: sau 1 tuần, ≥80% prompts của bạn có scope + verify + NEVER mà không cần cố nhớ.

## Tham khảo chéo

- [Tips 01](./01-context-hygiene.md) — scope gọn + chat sạch
- [Tips 03](./03-plan-first-workflow.md) — Ask → Edit → Agent leo thang
- [Tips 04](./04-verification-done-that.md) — done criteria + review gate
- [Tips 07](./07-thiet-ke-prompts-skills.md) — thiết kế prompt files + Agent Skills chuẩn 2026
- [Tips 10](./10-debugging-power-moves.md) — log → prompt khi debug

> **Chốt Tips 02:** prompt tốt không phải câu thần chú dài dòng, mà là bản mô tả công việc đủ 4 mảnh + một lệnh verify + một dòng NEVER — model có đủ ba thứ đó mới làm đúng ngay từ lần gõ đầu.
