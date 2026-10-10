# Tips 02 — Prompt Engineering Cho Copilot: Viết Sao, Ra Vậy

> Copilot không đọc được ý nghĩ. Prompt tốt = mục tiêu 1 câu + scope files + cách verify + dòng đừng-đụng-X. Bài này mổ xẻ anatomy, 6 mẫu theo task, few-shot bằng prompt files, bảng sai→sửa và guide non-coder.

## Mục lục

- [1. Vì sao prompt quyết định output?](#1-vì-sao-prompt-quyết-định-output)
- [2. Giải phẫu prompt tốt: 4 thành phần](#2-giải-phẫu-prompt-tốt-4-thành-phần)
- [3. Ba gia vị nâng chất lượng 10x](#3-ba-gia-vị-nâng-chất-lượng-10x)
- [4. Sáu mẫu prompt theo task (copy-paste)](#4-sáu-mẫu-prompt-theo-task-copy-paste)
- [5. Few-shot với prompt files (.prompt.md)](#5-few-shot-với-prompt-files-promptmd)
- [6. Walkthrough: từ prompt tệ tới prompt tốt](#6-walkthrough-từ-prompt-tệ-tới-prompt-tốt)
- [7. Bảng sai→ sửa](#7-bảng-saisửa)
- [8. Non-coder guide](#8-non-coder-guide)
- [9. Checklist trước khi Enter](#9-checklist-trước-khi-enter)
- [10. Pitfalls + fix](#10-pitfalls--fix)
- [11. Bài tập](#11-bài-tập)
- [12. Tham khảo chéo](#12-tham-khảo-chéo)

---

## 0. Giải ngố thuật ngữ (1 câu + so sánh + ví dụ + verify)

Mỗi thuật ngữ đủ 3 lớp: **1 câu định nghĩa**, **so sánh đời thường**, **ví dụ copy-paste** — kèm 1 dòng `Verify`.

| Thuật ngữ | Hiểu nôm na (1 câu) | So sánh đời thường | Ví dụ copy-paste | Verify |
|---|---|---|---|---|
| **Scope** | Khoanh vùng: chỉ được đụng files này. | Khoanh đất xây nhà: ngoài vạch là đất hàng xóm, đụng là kiện. | `Scope src/payments/*.ts, đừng đụng src/legacy/`. | `git diff --stat` chỉ hiện files trong scope. |
| **End-state** | Trạng thái xong trông thế nào (không phải làm gì). | Đặt món: "1 phở bò tái" thay vì "nấu gì ngon ngon". | `Top 5 complaints: quote + count + segment, markdown table`. | Output khớp đúng format + số liệu, không chung chung. |
| **Success criteria / Verify** | Cách chứng minh xong thật (lệnh + log). | Biên lai: không hóa đơn là chưa trả tiền. | `Done = npm test -- payments xanh + dán log`. | Thấy log xanh paste trong chat/PR, không phải "should work". |
| **Ràng buộc phủ định (NEVER)** | Danh sách cấm địa: đừng đụng X. | Dặn trẻ: "đừng thò tay ổ điện, đừng mở cửa người lạ". | `Đừng đụng src/generated/, đừng commit main, đừng thêm dep`. | Diff không có file cấm; commit thẳng main bị chặn. |
| **Few-shot** | Cho 1 ví dụ đúng để Copilot bắt chước. | Cho văn mẫu trước khi viết: đọc mẫu là biết dàn bài. | Cuối `.prompt.md` có `Input: ... / Output đúng: ...`. | 3 lần gọi cùng prompt ra cùng format. |

```mermaid
flowchart LR
    A[Prompt dở] --> B[+ Scope files]
    B --> C[+ End-state]
    C --> D[+ Chi tiết + Format]
    D --> E[+ Verify + NEVER]
    E --> F[Prompt đạt chuẩn]
```

Giải thích: mỗi vòng thêm 1 thành phần là bớt 2–3 turns sửa. Thiếu scope thì lan files; thiếu end-state thì chung chung; thiếu verify thì "should work"; thiếu NEVER thì đụng cấm địa.

> ✅ **Kỳ vọng thấy gì:** prompt đủ 4 mảnh + verify + NEVER → Copilot trả đúng files + dán log xanh ngay turn 1–2, không hỏi vặn 5 turns.

---

## 1. Vì sao prompt quyết định output?

### 1.1. Model giỏi + prompt ẩu = output sprawling

Nguyên nhân số 1 của "Copilot sửa lan man, đọc 100 files, đổi API không hỏi":

- Không phải model lười, mà là bạn cho nó **quyền tự do quá rộng**.
- Prompt `"fix login"` không scope = model tự đoán scope, tự đoán done, tự đoán verify.
- Prompt `"@workspace investigate auth"` với repo 500 files = mời model đi lạc.

### 1.2. Cơ chế: prompt là hợp đồng giới hạn search space

Mỗi prompt tốt làm 3 việc:

1. **Thu hẹp search space:** từ 500 files → 5 files. Từ làm gì cũng được → chỉ làm X.
2. **Định nghĩa done check được:** từ cho sạch → `npm test payments` xanh.
3. **Gài vòng lặp tự sửa:** chạy X và iterate trong message này → Copilot tự retry thay vì xong rồi chắc vậy.

### 1.3. Đắt rẻ của prompt

- Viết prompt kỹ 2 phút → tiết kiệm 20 phút restore checkpoint + retry (tốn AI Credits).
- Prompt ẩu 10 giây → 5 turns cãi nhau, mỗi turn gánh thêm rác + credits.
- Plan-first ([Tips 03](./03-plan-first-workflow.md)) chính là prompt đắt cho task lớn: trả 1 turn plan để tránh 10 turns code sai.

---

## 2. Giải phẫu prompt tốt: 4 thành phần

Mọi prompt tốt đều có đủ 4 mảnh. Thiếu 1 mảnh là output lệch 1 hướng.

### Thành phần 1 — Scope files nào

Chỉ file/thư mục liên quan. Càng cụ thể càng rẻ.

```text
TỐT: "#file:src/auth/login.ts + #file:src/auth/__tests__/login.test.ts"
TỐT: "Scope src/payments/*.ts, đừng đụng src/legacy/"
TỆ:  "@workspace đọc cả repo rồi cho ý kiến"
```

Mẹo: bôi đen code dùng `#selection`. File >1000 dòng thì tóm tắt từng phần.
Non-code: thay files bằng nguồn — `docs/sprint-12.md`, `data/feedback-q3.csv`.

### Thành phần 2 — Mục tiêu gì (end-state, không phải activity)

Mô tả **trạng thái cuối**, không mô tả hoạt động.

```text
TỆ (activity):  "Xem giúp auth" / "Refactor cho sạch" / "Analyze data"
TỐT (end-state): "Top 5 complaints theo frequency, mỗi dòng: quote + count + segment, markdown table"
TỐT (end-state): "Tách src/auth.ts (>500 dòng) thành 3 modules, giữ public API, test xanh"
```

Công thức: **động từ + đối tượng + tiêu chuẩn chấp nhận**.

### Thành phần 3 — Chi tiết nào (độ phân giải)

Bạn muốn sâu tới đâu? Columns nào? Quotes? Counts? Edge cases?

```text
TỐT data: "Mỗi dòng: quote nguyên văn + count + segment. Đối chiếu totals ở summary vs raw, lệch thì fix trước khi show."
TỐT code: "Liệt kê files sẽ sửa (đường dẫn đầy đủ), hàm nào đổi signature, test nào phải giữ xanh."
TỆ: "Cho chi tiết vào" (chi tiết gì? bao nhiêu là đủ?)
```

### Thành phần 4 — Format output nào

Không chỉ định format = nhận format ngẫu nhiên.

```text
TỐT: "Output markdown table: | File | Việc | Verify |"
TỐT: "Trả về plan markdown gồm: steps + risks + verify từng phase, chờ duyệt."
TỐT: "Trả về JSON: {files: [...], risks: [...], verify: '...'}"
```

### Ví dụ tổng hợp 4 thành phần

```text
TỆ:
"Analyze this data"

TỐT (copy-paste):
"Đọc #file:data/feedback-q3.csv. Tìm top 5 complaints theo frequency.
Mỗi dòng: quote nguyên văn + count + segment. Output markdown table.
Xong đối chiếu totals ở summary vs raw, lệch thì fix trước khi show.
Không tạo file mới, chỉ trả lời trong chat."
```

Phân tích:

- Files: `data/feedback-q3.csv` (1).
- End-state: top 5 complaints theo frequency (2).
- Chi tiết: quote + count + segment + đối chiếu totals (3).
- Format: markdown table, chỉ chat (4).

---

## 3. Ba gia vị nâng chất lượng 10x

### Gia vị 1 — Mục tiêu + success criteria explicit

Done phải check được bằng lệnh, không bằng cảm giác.

```text
TỆ:  "làm cho sạch, đảm bảo không lỗi"
TỐT: "Done = `npm test -- payments` xanh + `npm run lint` 0 error"
```

Xem thêm [Tips 04](./04-verification-done-that.md).

### Gia vị 2 — Cách verify (bắt iterate trong message)

Thêm 1 câu này, Copilot tự chạy → đọc lỗi → sửa → chạy lại.

```text
"Sau khi sửa, chạy `npm test -- payments` và dán log pass/fail. Nếu đỏ, fix tiếp trong message này tới khi xanh hoặc dừng sau 3 lần và báo blocker."
```

### Gia vị 3 — Ràng buộc phủ định (đừng đụng X)

Model cần biết **cấm địa**. Không dặn là nó sẽ đụng.

```text
"Đừng đụng `src/generated/`, đừng đổi DB schema, đừng commit thẳng main, đừng thêm dependency mới."
"Chỉ sửa trong src/payments/. Không refactor file khác 'cho tiện'."
"Không tạo file mới nếu chưa hỏi. Không xóa test cũ để cho xanh."
```

Mẹo: gom ràng buộc chung vào `.github/copilot-instructions.md` (chuẩn 2026, <200 dòng), chỉ để ràng buộc riêng task trong prompt.

---

## 4. Sáu mẫu prompt theo task (copy-paste)

### Mẫu 1 — BUG (fix tối thiểu + regression test)

```text
BUG: Tái hiện lỗi [mô tả + steps + log paste kèm].

1. Tìm root cause trong #file:<module, vd src/auth/login.ts>, giải thích 3 bullet trước khi sửa.
2. Fix tối thiểu, không refactor lan man, không đổi public API.
3. Thêm 1 regression test cover case này.
4. Chạy focused test `npm test -- <scope>` và dán kết quả. Đỏ thì fix tiếp trong message này.
Ràng buộc: đừng đụng <liệt kê cấm địa>.
```

Ví dụ điền sẵn:

```text
BUG: Login email có dấu bị 500. Steps: nhập "ten@vidu.vn" -> bấm login -> 500.
Log: TypeError normalizeEmail ở #file:src/auth/login.ts:42.
Tìm root cause trong file đó, fix tối thiểu, thêm regression test,
chạy npm test -- auth và dán log. Đừng đổi API, đừng đụng generated/.
```

### Mẫu 2 — FEATURE (plan trước, code sau)

```text
FEATURE: Tôi muốn <mục tiêu 1 câu>.

Trước khi code:
1. Đọc <tối đa 3 files, ghi #file đường dẫn>.
2. Trình plan gồm: files sẽ đọc/sửa, steps theo thứ tự, risks/edge cases, cái gì KHÔNG đụng, cách verify từng phase.
3. Chờ tôi duyệt mới implement. Không code trong message này.
Output: markdown plan, chờ duyệt.
```

### Mẫu 3 — REFACTOR (giữ API + gate từng bước)

```text
REFACTOR: Tách file <X, vd src/auth.ts ~900 dòng> thành modules <login, session, types>.
- Giữ nguyên public API (export cũ vẫn import được).
- Làm từng bước nhỏ, chạy full test `npm test -- <scope>` sau mỗi bước.
- Dừng và báo ngay nếu test đỏ, không cố vá tiếp.
- Cuối cùng dán `git diff --stat` + log test xanh.
```

### Mẫu 4 — RESEARCH (scope hẹp + output chuẩn)

```text
RESEARCH: @workspace Chỉ trong <phạm vi hẹp, vd src/payments/refund*>:
- Không sửa code, chỉ đọc.
- Trả về: (1) files liên quan (đường dẫn + 1 dòng vai trò),
  (2) flow hiện tại (5-8 bullet),
  (3) 2 phương án thay đổi (pros/cons mỗi cái 3 bullet).
- Không dump log dài. Ghi findings ra plan.md rồi dừng.
```

### Mẫu 5 — REVIEW (adversarial, có severity)

```text
REVIEW: Review diff hiện tại với plan trong #file:plan.md.
- Finding = bug/correctness/security/test-gap thực sự. Bỏ qua style.
- Trả về: [SEVERITY: HIGH/MED/LOW] file:line — mô tả 1 dòng — gợi ý fix 1 dòng.
- Cuối cùng: verdict PASS / NEEDS-FIX + 3 gaps ưu tiên cao nhất.
```

Chi tiết calibration reviewer ở [Tips 04](./04-verification-done-that.md).

### Mẫu 6 — DATA / DOCS (cho non-coder + coder)

```text
DATA: Đọc #file:<csv/docs>. Tìm <câu hỏi cụ thể>.
Mỗi kết quả kèm evidence: quote/số dòng/file:line.
Output: table + 3 bullet insight + confidence 1 dòng.
```

---

## 5. Few-shot với prompt files (.prompt.md)

### 5.1. Vì sao cần prompt files?

- Viết mẫu 6 lần → lần 7 vẫn gõ lại. Lưu vào `.github/prompts/*.prompt.md`, gọi `/tên-file`, team dùng chung.
- **Lưu ý 2026:** prompt files `.prompt.md` đang deprecated trên Agent Host (Cloud) — vẫn chạy trên Local/VS Code. Khuyến nghị chuyển việc lặp lại sang **Agent Skills** (`SKILL.md`, chuẩn mở, portable mọi harness). Xem [Tips 07](./07-thiet-ke-prompts-skills.md).

### 5.2. Cấu trúc prompt file chuẩn

**Ví dụ 1 — File bug-fix.prompt.md (copy-paste):**

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
2. Fix tối thiểu, không đổi public API.
3. Thêm 1 regression test.
4. Chạy `npm test -- ${input:scope}` và dán log.

## Ràng buộc
- Đừng đụng src/generated/, đừng commit thẳng main.
- Đỏ sau 3 lần -> dừng và báo blocker.
```

Gọi:

```text
/bug-fix scope=src/payments bugDescription="refund quá 30 ngày bị 500"
```

**Ví dụ 2 — File research.prompt.md (copy-paste):**

```markdown
---
mode: ask
tools: [search, read]
description: Research module, chỉ đọc không sửa
---

## Phạm vi
Chỉ trong ${input:glob}, không đọc ngoài.

## Output bắt buộc
1. Table | File | Vai trò 1 dòng |
2. Flow hiện tại 5-8 bullet + file:line
3. 2 phương án (pros/cons 3 bullet mỗi cái)

## Ví dụ few-shot
Input: glob=src/auth/login*
Output mẫu:
| src/auth/login.ts | validate() + normalizeEmail |
...
```

Lợi ích few-shot: output đồng nhất, dễ review, Copilot ít sáng tạo bừa.
Chi tiết xem [Tips 07](./07-thiet-ke-prompts-skills.md).

---

## 6. Walkthrough: từ prompt tệ tới prompt tốt

**Tình huống:** bạn muốn refactor file `auth.ts` 800 dòng.

**Round 0 — Prompt tệ:**

```text
"Refactor auth cho sạch"
```

→ Copilot đọc 40 files, đổi luôn API, thêm dependency, test đỏ 5 chỗ. Bạn mất 45 phút restore checkpoint.

**Round 1 — Thêm scope + end-state:**

```text
"Refactor #file:src/auth.ts (800 dòng) thành 3 modules: login, session, types. Giữ public API."
```

→ Đỡ hơn, nhưng Copilot vẫn không chạy test, bạn phải nhắc thêm 2 turns.

**Round 2 — Thêm verify + ràng buộc (prompt đạt chuẩn):**

```text
"Refactor #file:src/auth.ts (~800 dòng) thành src/auth/login.ts, session.ts, types.ts.
Giữ nguyên public API (file cũ re-export để không gãy import).
Sau mỗi bước chạy `npm test -- auth` và dán log. Đỏ thì dừng và báo.
Đừng đụng src/generated/, đừng thêm dep mới, đừng commit.
Trước khi code, trình outline 5 bullet files/hàm sẽ di chuyển và chờ duyệt."
```

→ 1 turn plan + 3 turns implement sạch, test xanh, diff gọn. Tổng 15 phút.

Bài học:

- **Mỗi vòng thêm 1 thành phần (scope → end-state → verify → constraints → format) là bớt 2–3 turns sửa.**
- Đo thời gian: ghi lại phút 0 prompt tệ, phút 5 thêm scope, phút 10 thêm verify.

---

## 7. Bảng sai→ sửa

| Sai (prompt ẩu) | Hiểu nôm na | Ví dụ cụ thể | Vì sao hỏng | Sửa (copy ý này) |
|---|---|---|---|---|
| `"investigate auth"` không scope | Nhờ tìm kim mà đưa cả biển. | Repo 500 files, Copilot đọc 300 files. | Đọc 300 files, tốn requests | Khoanh module + câu hỏi + output format |
| Một prompt 5 việc không liên quan | 1 đơn gọi 5 món khác quán. | Bug + feature + refactor gộp 1 prompt → sửa A hỏng B. | Chat nhiễm, việc nọ lẫn việc kia | Tách 5 prompts/chats, mỗi cái 1 việc + new chat |
| Không cho cách verify | Xong mà không hóa đơn. | "Xong rồi (chắc vậy)" không log. | Xong rồi chắc vậy | Luôn kèm check: test/lint/log/diff + dán evidence |
| Mô tả solution thay vì problem | Ép thợ làm theo cách sai của bạn. | "Thêm if ở dòng 42" trong khi root ở dòng 80. | Ép model theo hướng sai | Mô tả problem + constraints, để Ask mode đề xuất solution |
| File >1000 dòng ném nguyên | Nhét cả cuốn từ điển vào cặp. | `auth.ts` 1500 dòng paste nguyên → quên đầu. | Tràn chat, quên đầu | Tách nhỏ, hoặc tóm tắt từng phần |
| `"làm cho nhanh"` | Bảo thợ ẩu cho kịp giờ. | Model xóa test để xanh cho nhanh. | Model cắt test, cắt verify | Đổi thành làm tối thiểu nhưng test phải xanh, dán log |
| Không ràng buộc phủ định | Không rào, bò ăn lúa hàng xóm. | Sửa luôn `generated/` + push thẳng main. | Sửa lan sang file cấm | Liệt kê NEVER: generated/, schema, main, dep mới |
| Không format output | Nhận thư tay dài 5 trang khó đọc. | Prose 100 dòng không table. | Nhận prose dài khó review | Ép format: table / checklist / file:line |
| Không dùng prompt files | Mỗi lần nấu 1 công thức mới. | 5 người 5 kiểu prompt bug. | Mỗi lần gõ một kiểu | Lưu vào `.github/prompts/*.prompt.md` (Local) hoặc chuyển sang Agent Skills (chuẩn 2026) |

### Before / After — prompt dở vs tốt (bắt buộc)

**Before (prompt dở):**

```text
Refactor auth cho sạch
```

> Kết quả dở: Copilot đọc 40 files, đổi API, thêm dep, test đỏ 5 chỗ. Bạn mất 45 phút restore. Không có log, không có diff-stat, không biết done chưa.

**After (prompt tốt — đủ 4 mảnh + verify + NEVER):**

```text
Refactor #file:src/auth.ts (~800 dòng) thành src/auth/login.ts, session.ts, types.ts.
Giữ nguyên public API (file cũ re-export để không gãy import).
Sau mỗi bước chạy `npm test -- auth` và dán log. Đỏ thì dừng và báo.
Đừng đụng src/generated/, đừng thêm dep mới, đừng commit.
Trước khi code, trình outline 5 bullet files/hàm sẽ di chuyển và chờ duyệt.
```

> Kết quả tốt: 1 turn plan + 3 turns implement sạch, test xanh, diff gọn 3 files. Tổng 15 phút. Verify: `npm test -- auth` xanh + `git diff --stat` chỉ 3 files.
> ✅ **Kỳ vọng thấy gì:** After cho outline 5 bullet trước, rồi từng bước 1 log xanh; Before cho code 200 dòng ngay + 5 chỗ đỏ.

---

## 8. Non-coder guide

Cùng công thức 4 thành phần, chỉ thay từ ngữ:

| Coder nói | Non-coder nói |
|---|---|
| Files | Nguồn: data folder, docs, sheet, email export |
| Test xanh | Đối chiếu số liệu (totals, wc -l, summary) |
| Diff | So sánh trước/sau (table cũ vs mới) |
| Lint | Checklist chính tả / format |

**Prompt khởi động cho người mới (copy-paste):**

```text
"Phỏng vấn tôi để hiểu project này, rồi tạo copilot-instructions.md.
Hỏi từng câu một: project làm gì, dữ liệu ở đâu, output muốn gì,
cái gì không được đụng. Khi đủ thì sinh file <100 dòng."
```

→ Bạn chỉ cần trả lời hội thoại, Copilot lo cấu trúc.

**Ví dụ non-coder hoàn chỉnh:**

```text
"Đọc thư mục data/feedback/. Tìm 3 lý do khách phàn nàn nhiều nhất tháng này.
Mỗi lý do kèm 2 quotes + số lượng. Output table.
Đối chiếu tổng với summary.xlsx, lệch thì báo. Không sửa file gốc."
```

---

## 9. Checklist trước khi Enter

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

> Nếu tick đủ 10 ô, prompt của bạn thuộc top 5%.

---

## 10. Pitfalls + fix

| Pitfall | Triệu chứng | Fix |
|---|---|---|
| Prompt 1 dòng cho task 5 bước | Output thiếu, hỏi vặn 5 turns | Task lớn → Ask plan trước + 6 mẫu mục 4 |
| Scope cả repo | Đọc hàng trăm files, chậm, tốn requests | Khoanh ≤5 files + @workspace chỉ khi explore |
| Không dặn verify | Should work | Luôn kèm lệnh test + dán log (xem Tips 04) |
| Dặn solution thay vì problem | Hướng sai khó cứu | Problem + constraints trước, solution để plan đề xuất |
| Gộp bug + feature + refactor 1 prompt | Sửa A hỏng B | Tách chats, new chat giữa (xem Tips 01) |
| Quên NEVER | Đụng generated/, push main | Mọi prompt code đều có 1 dòng NEVER |
| Output prose dài 100 dòng | Khó review, khó diff | Ép format: table / checklist / file:line |
| File khổng lồ ném nguyên | Quên rule, lan man | Tóm tắt, chat chính chỉ nhận outline |
| Hỏi lại cùng câu 3 lần | Model không hiểu ý | Viết lại bằng end-state + ví dụ input/output mẫu |
| Prompt files thiếu variables | Mỗi lần vẫn phải sửa tay | Dùng `${input:...}` + description rõ |

---

## 11. Bài tập

**Bài 1 (10 phút — mổ prompt cũ):**

- Lấy 3 prompts gần nhất bạn đã gõ.
- Chấm mỗi prompt theo 4 thành phần (scope / end-state / chi tiết / format): thiếu mảnh nào?
- Viết lại 1 prompt tệ nhất thành bản đủ 4 mảnh + verify + NEVER.

**Bài 2 (20 phút — dùng 6 mẫu):**

- Lấy 1 bug thật + 1 feature thật trong repo.
- Viết prompt bug theo Mẫu 1, prompt feature theo Mẫu 2 (plan trước).
- Chạy thử, đếm số turns tới done. Mục tiêu: bug ≤4 turns, feature có plan duyệt trước khi code.

**Bài 3 (15 phút — tạo prompt file đầu tiên):**

- Lấy prompt bạn dùng >2 lần/tuần, lưu thành `.github/prompts/team-bug.prompt.md`.
- Thêm frontmatter mode/tools/description + 1 ví dụ few-shot.
- Nhờ 1 đồng nghiệp gọi `/team-bug` và cho feedback: output có đồng nhất không?
- Nếu team dùng Agent Host/Cloud: chuyển bản mẫu thành Agent Skill (`SKILL.md`) theo [Tips 07](./07-thiet-ke-prompts-skills.md).

> Đạt: sau 1 tuần, ≥80% prompts của bạn có scope + verify + NEVER mà không cần cố nhớ.

---

## 12. Tham khảo chéo

- Bài tips liên quan:
  - [Tips 01](./01-context-hygiene.md) — scope gọn + chat sạch
  - [Tips 03](./03-plan-first-workflow.md) — Ask → Edit → Agent leo thang
  - [Tips 04](./04-verification-done-that.md) — done criteria + review gate
  - [Tips 07](./07-thiet-ke-prompts-skills.md) — thiết kế prompt files tái dùng + Agent Skills chuẩn 2026
  - [Tips 10](./10-debugging-power-moves.md) — log → prompt khi debug

> Mẹo 1 dòng: _mỗi prompt đều trả lời 4 câu: files nào, ra cái gì, chi tiết nào, format nào — thiếu 1 là lệch 1 hướng._
