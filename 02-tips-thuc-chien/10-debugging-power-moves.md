# Tips 10 — Debugging Power Moves: /fix, Test Loop, Bisect, Log→Prompt

> **Dành cho:** dev đang kẹt với test đỏ / bug prod và muốn debug có hệ thống.
> **Vấn đề:** paste đống log vào chat rồi cầu nguyện, sửa 5 file càng sửa càng đỏ.
> **Đọc xong:** dùng thành thạo /fix có scope, loop test tới xanh, bisect thu hẹp, log→prompt và @terminal.
> **Thời gian:** ~20 phút đọc + ~55 phút làm bài tập.

## 1. Vì sao debug với AI hay lạc?

Ba kiểu debug đốt credits mà không ra: paste 1000 dòng log vào chat chính (Copilot ngợp, đoán bừa); bảo `fix giúp tôi` không scope (sửa 5 files, thêm 2 bug mới); cãi 5 turns `sai rồi, sửa lại` (mỗi turn gánh thêm rác).

Debug giỏi với Copilot là:

```text
Tái hiện 1 lệnh → lấy failure gọn → khoanh 1 file → /fix có scope → loop tới xanh.
Không tái hiện được thì chưa debug, mới đang đoán.
```

> Rule: **correct 2 lần vẫn sai → dừng cãi, thu hẹp scope hoặc restore checkpoint.**

## 2. Cơ chế: debug là thu hẹp search space

Mọi bug đều là 1 trong 3:

| Loại | Dấu hiệu | Cách thu hẹp |
|---|---|---|
| Biết chỗ (stack trace rõ) | Log chỉ file:line | Bôi đen hàm + /fix ngay |
| Biết vùng (test đỏ 1 module) | 3–5 files liên quan | Bisect: chia đôi, loại trừ |
| Không biết gì (flaky, prod) | Log dài, không tái hiện | Log→prompt: tóm tắt rồi mới fix |

```text
[Tái hiện] → [Failure gọn] → [Khoanh scope] → [/fix] → [Loop xanh] → [Regression test]
   ↑ nếu không tái hiện: thêm log/bisect, chưa cho fix
```

Luôn đòi root cause trước fix: `"Giải thích root cause 3 bullet + file:line trước khi sửa. Không đoán, thiếu evidence thì hỏi thêm thay vì fix bừa."` Chọn sai loại bug là mọi bước sau đi sai hướng — dùng bisect cho bug đã có stack trace là thừa, dùng /fix cho bug flaky là sửa mù.

## 3. Move 1: /fix + debug session

**/fix có scope (copy-paste):**

```text
/fix #testFailure chỉ fix test đỏ này.
Giải thích root cause 3 bullet + file:line trước khi sửa.
Fix tối thiểu, không refactor, không đổi API.
# Kỳ vọng: diff chỉ 5-10 dòng, focused test xanh, không lan.
```

**Debug session khi cần hỏi đáp (copy-paste):**

```text
Bắt đầu debug session cho bug: login email có dấu bị 500.
- Bước 1: đọc #file:src/auth/login.ts + test liên quan,
  liệt kê 3 giả thuyết (mỗi cái kèm cách kiểm chứng 1 lệnh).
- Bước 2: chờ tôi chọn 1 giả thuyết mới fix.
- Không sửa code trong turn này.
```

**Dặn không đoán (copy-paste):**

```text
Nếu stack trace thiếu, đừng đoán.
Hỏi tôi tối đa 3 câu để lấy thêm evidence:
- lệnh tái hiện? env? commit gần nhất đụng module này?
Khi đủ evidence mới đề xuất fix.
```

/fix không kèm scope và câu "không refactor" thì model tiện tay dọn chỗ không hỏng — diff phình, dễ mang bug mới vào.

## 4. Move 2: test failure loop tới xanh

**Loop focused test (copy-paste):**

```text
Chạy `npm test -- auth` và dán log pass/fail.
Nếu đỏ, đọc #testFailure, fix tiếp trong message này tới khi xanh
hoặc dừng sau 3 lần và báo blocker + file:line.
Không xóa test để xanh.
```

**Loop mở rộng V3 (copy-paste):**

```text
Sau khi focused xanh, chạy tiếp:
1. `npm test -- payments` (full scope)
2. `npm run lint`
3. `npm run build`
Dán cả 3 logs. Đỏ ở bước nào thì fix ở đó, chạy lại từ bước 1.
```

**Regression test bắt buộc (copy-paste):**

```text
Thêm 1 regression test cover đúng case vừa fix:
- Tên test chứa issue/bug id (vd "refund >30 ngay #101").
- Chạy riêng test mới, dán log xanh.
- Chạy full scope, đảm bảo không gãy test cũ.
```

Vì sao loop trong 1 message? Mỗi message mới là 1 request + context mới — loop tại chỗ rẻ hơn bạn nhắc tay. Không giới hạn số lần đỏ thì agent cày 10 vòng vẫn đỏ mà context đã đầy rác.

## 5. Move 3: bisect + log→prompt

**Bisect bằng git (khi chưa biết file nào gây lỗi):**

```bash
git bisect start
git bisect bad HEAD
git bisect good v1.2.0
# Mỗi bước chạy: npm test -- <scope> → good/bad
git bisect reset
# Kỳ vọng: ~log2(số commit) lần chạy, khoanh được 1 commit gây lỗi.
```

Nhờ Copilot viết script bisect: `"Viết script bash: mỗi commit chạy npm test -- payments, in PASS/FAIL + 5 dòng cuối log. Tôi sẽ dùng với git bisect."` Bisect bằng comment code cũng được: `"Bug chỉ xảy ra khi bật voucher + refund cùng lúc. Đề xuất 3 điểm bisect (tắt từng cái) — mỗi điểm kèm file:line + lệnh verify."`

Lưu ý: bisect mà không tái hiện được lỗi một cách ổn định thì good/bad vô nghĩa — khoanh sai commit, sửa nhầm chỗ.

**Log→prompt — đừng paste log thô:**

```bash
# Bước 1: lưu log ra file
npm test -- payments > /tmp/test.log 2>&1
```

```text
# Bước 2: mở chat phụ, gắn file log:
"Đọc #file:/tmp/test.log, chỉ trả về:
1. 3 lỗi đầu tiên (file:line + message 1 dòng mỗi cái)
2. Test nào đỏ đầu tiên (tên + file)
3. Gợi ý 1 file nên đọc tiếp.
Không fix, chỉ tóm tắt."

# Bước 3: mang summary gọn sang chat chính để /fix.
```

Chat chính chỉ nhận 10 dòng summary thay vì 1000 dòng rác (xem [Tips 01](./01-context-hygiene.md)).

## 6. Move 4: @terminal + explain lỗi

**@terminalLastCommand — Copilot đọc lỗi trực tiếp:**

```text
# Sau khi chạy lệnh đỏ trong terminal, trong chat gõ:
@terminalLastCommand Giải thích lỗi này 3 bullet + gợi ý fix 1 file cụ thể.
Không chạy lệnh nguy hiểm (rm -rf, reset --hard) nếu chưa hỏi tôi.
```

**Explain + fix có gate:**

```text
@testFailure Giải thích vì sao test này đỏ (3 bullet, kèm file:line).
Sau đó đề xuất fix tối thiểu 5 dòng, chờ tôi duyệt mới sửa.
Không đụng file ngoài test + module này.
```

**Debug prod/flaky:**

```text
Bug flaky: 10 lần chạy đỏ 3 lần.
1. Liệt kê 3 nguyên nhân flaky phổ biến cho module này (race/timeout/order).
2. Mỗi cái kèm 1 lệnh kiểm chứng (retry 10 lần, seed, log timestamp).
3. Đề xuất thêm log ở 2 vị trí file:line để lần sau có evidence.
Không fix ngay, thu thập evidence trước.
```

@terminal cho model thấy đúng output thật thay vì bản bạn copy tay (dễ sai/sót) — copy thiếu dòng stack quan trọng là model chẩn đoán lệch, mất thêm vòng.

## 7. Walkthrough: bug 500 trong 30 phút

Bối cảnh: POST /api/payments/refund quá 30 ngày bị 500, log dài.

| Phút | Move | Việc |
|---|---|---|
| 0–3 | Tái hiện | `curl -X POST localhost:3000/api/payments/refund -d '{"order":123,"days":31}'` → xác nhận 500, lưu log /tmp/bug.log |
| 3–8 | Log→prompt | Chat phụ: `"Tóm tắt /tmp/bug.log: 3 lỗi đầu + file:line, không fix."` → biết lỗi ở refund.ts:42 |
| 8–12 | Khoanh scope | Bôi đen hàm issueRefund() → chat Edit: `"Root cause 3 bullet trước khi sửa, giữ export."` |
| 12–20 | /fix + loop | `"/fix #testFailure, fix tối thiểu, chạy npm test -- payments, dán log. Đỏ thì loop 3 lần."` |
| 20–25 | Mở rộng | `"Chạy thêm lint + build, dán 2 logs. Thêm 1 regression test days=31."` |
| 25–30 | Review | Chat Reviewer fresh: `"Review diff vs plan, [SEVERITY] file:line, PASS/NEEDS-FIX."` → commit |

Tổng 30 phút, 0 lần cãi nhau, có regression test + logs.

## 8. Bảng tra nhanh: lỗi nào move nào?

| Dấu hiệu | Move đầu tiên | Prompt 1 dòng | Dừng khi |
|---|---|---|---|
| Stack trace rõ file:line | /fix scope hẹp | `/fix #testFailure, root cause 3 bullet` | Xanh focused + regression |
| Test đỏ 1 module | Test loop | `Chạy focused, đỏ thì loop 3 lần` | Full scope + lint/build xanh |
| Không biết file nào | Bisect | `Đề xuất 3 điểm bisect + verify` | Khoanh được 1 file |
| Log 1000 dòng | Log→prompt | `Tóm tắt 3 lỗi đầu, không fix` | Có summary 10 dòng |
| Lệnh terminal đỏ | @terminal | `@terminalLastCommand giải thích 3 bullet` | Hiểu lỗi + fix 1 file |
| Flaky 3/10 lần | Thu thập evidence | `Liệt kê 3 nguyên nhân + cách kiểm chứng` | Có log/timestamp, chưa fix vội |
| Cãi 2 lần vẫn sai | Restore checkpoint | `Restore trước turn 1, re-prompt sạch` | Prompt mới hẹp hơn |
| Sửa A hỏng B | Thu hẹp scope | `Chỉ sửa file X, diff --stat kiểm tra` | Diff gọn + full test xanh |

> Quy tắc ngón tay: **rõ thì /fix ngay, mờ thì bisect/log trước, cãi 2 lần thì restore.**

## 9. Pitfalls + cách fix

| Pitfall | Triệu chứng | Fix |
|---|---|---|
| Paste log 1000 dòng vào chat chính | Ngợp, đoán bừa | Log→file + chat phụ tóm tắt (mục 5) |
| Fix không root cause | Hết bug này lòi bug khác | Bắt 3 bullet root cause + file:line trước khi sửa |
| Scope cả repo | Sửa lan 5 files | Bôi đen/#file 1 chỗ, NEVER file ngoài |
| Cãi 5 turns | Càng sửa càng đỏ | 2 lần sai → restore checkpoint, re-prompt hẹp |
| Xóa test để xanh | Xanh giả | Cấm xóa/sửa test trong prompt |
| Không tái hiện mà vẫn fix | Fix mù | Thêm log/bisect, chưa tái hiện thì chưa fix |
| Chạy lệnh nguy hiểm | Mất code/data | Tool approval blocklist rm/reset --hard (Tips 06) |
| Quên regression test | Bug quay lại tháng sau | Mọi bug đều 1 test mới chứa issue id |
| Chỉ chạy 1 file | Sửa A hỏng B | Focused xanh → full scope + build |

Ba lỗi nhìn là nhớ:

```text
❌ SAI: "nghe nói prod 500, fix giúp" → agent sửa mù, không biết đúng không.
✅ ĐÚNG: tái hiện bằng 1 lệnh (curl...) → có log → khoanh scope → /fix.

❌ SAI: "sai rồi, sửa lại" ×5 → mỗi turn gánh thêm rác, càng sửa càng đỏ.
✅ ĐÚNG: 2 lần sai → restore checkpoint, re-prompt hẹp hơn (1 file + root cause + NEVER).

❌ SAI: comment/delete test đỏ → CI xanh nhưng bug vẫn còn.
✅ ĐÚNG: cấm xóa test trong prompt; sửa source + thêm regression test cho đúng case.
```

## 10. Bài tập cuối bài

**Bài 1 (15 phút):** Lấy 1 test đỏ thật, bôi đen hàm lỗi, chạy prompt /fix chuẩn (mục 3). Đếm turns tới xanh — mục tiêu ≤4.

**Bài 2 (20 phút):** Lấy 1 log dài >200 dòng, lưu ra file, chat phụ tóm tắt 10 dòng, mang sang chat chính /fix. So tokens + chất lượng vs paste thô.

**Bài 3 (20 phút):** Lấy 1 bug chưa biết file nào, nhờ Copilot đề xuất 3 điểm bisect. Chạy bisect (git hoặc tắt từng flag), khoanh 1 file, viết regression test + loop tới xanh, commit kèm issue id.

> Đạt: sau 2 tuần, 80% bug của bạn có root cause 3 bullet + regression test + log xanh.

## Tham khảo chéo

- [Tips 01](./01-context-hygiene.md) — chat phụ tóm tắt, chat chính gọn
- [Tips 02](./02-prompt-engineering.md) — Mẫu 1 BUG + verify + NEVER
- [Tips 04](./04-verification-done-that.md) — loop tới xanh + review gate
- [Tips 03](./03-plan-first-workflow.md) — debug xong thì plan fix lớn
- [Tips 11](./11-nang-cao-cli-web-coding-agent.md) — debug trên CLI/web khi xa máy

> **Chốt Tips 10:** debug giỏi không phải sửa nhanh mà là *thu hẹp giỏi* — tái hiện 1 lệnh, khoanh 1 file, `/fix` có scope, loop tới xanh, khóa lại bằng 1 regression test. Cãi 2 lần thì dừng, restore, làm lại hẹp hơn.
