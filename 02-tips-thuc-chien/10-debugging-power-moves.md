# Tips 10 — Debugging Power Moves: /fix, Test Loop, Bisect, Log→Prompt

> Debug với Copilot không phải paste đống log rồi cầu nguyện. Bài này dạy bạn /fix + debug session, test failure loop, bisect thu hẹp, log→prompt gọn, và @terminal để Copilot đọc lỗi trực tiếp.

## Mục lục

- [1. Vì sao debug với AI hay lạc?](#1-vì-sao-debug-với-ai-hay-lạc)
- [2. Cơ chế: debug là thu hẹp search space](#2-cơ-chế-debug-là-thu-hẹp-search-space)
- [3. Move 1: /fix + debug session](#3-move-1-fix--debug-session)
- [4. Move 2: test failure loop tới xanh](#4-move-2-test-failure-loop-tới-xanh)
- [5. Move 3: bisect + log→prompt](#5-move-3-bisect--logprompt)
- [6. Move 4: @terminal + explain lỗi](#6-move-4-terminal--explain-lỗi)
- [7. Walkthrough theo phút: bug 500 trong 30 phút](#7-walkthrough-theo-phút-bug-500-trong-30-phút)
- [8. Bảng tra nhanh: lỗi nào move nào?](#8-bảng-tra-nhanh-lỗi-nào-move-nào)
- [9. Pitfalls + cách fix](#9-pitfalls--cách-fix)
- [10. Bài tập cuối bài](#10-bài-tập-cuối-bài)
- [11. Tham khảo chéo](#11-tham-khảo-chéo)

---

## 0. Giải ngố thuật ngữ (1 câu + analogie + verify)

| Thuật ngữ | Hiểu nôm na | Analogie | Ví dụ kỹ thuật thật | Verify |
|---|---|---|---|---|
| **`/fix + #testFailure`** | Nút sửa tự động cho test đỏ, kèm scope. | Như thợ sửa ống nước: chỉ vá chỗ vỡ, không đục cả nhà. | `/fix #testFailure chỉ fix test này, root cause 3 bullet`. | `# Verify:` fix 5 dòng + focused xanh, diff không lan. |
| **Test failure loop** | Bắt robot chạy → đỏ → sửa → chạy lại tới xanh. | Như bắt học sinh làm tới đúng thì thôi, max 3 lần. | `Chạy npm test -- auth, đỏ thì fix trong message tới xanh/dừng sau 3`. | `# Verify:` thấy 2–3 logs đỏ → xanh trong cùng message. |
| **Bisect** | Chia đôi để loại trừ, tìm commit/file gây lỗi. | Như tìm bóng đèn cháy trong dãy: tắt nửa này, sáng thì lỗi nửa kia. | `git bisect start/bad/good` + script `npm test` mỗi commit. | `# Verify:` khoanh được 1 commit/file sau ~log2(n) bước. |
| **Log→prompt** | Tóm log 1000 dòng thành 10 dòng rồi mới fix. | Như tóm tắt bệnh án trước khi mổ, không ôm cả tủ hồ sơ vào phòng mổ. | Log → `/tmp/test.log` → chat phụ tóm 3 lỗi đầu → chat chính `/fix`. | `# Verify:` chat chính chỉ nhận 10 dòng summary, không ngợp. |
| **`@terminal / @testFailure`** | Cho Copilot đọc lỗi trực tiếp, khỏi copy tay. | Như bác sĩ nhìn X-quang trực tiếp thay vì nghe kể. | `@terminalLastCommand giải thích 3 bullet + fix 1 file`. | `# Verify:` không paste tay mà vẫn đúng file:dòng. |

```mermaid
flowchart TD
    A[Tái hiện 1 lệnh] --> B{Failure gọn?}
    B -->|Chưa| C[Bisect / Log→prompt]
    C --> A
    B -->|Rồi| D[Khoanh 1 file]
    D --> E[/fix scope hẹp + root cause]
    E --> F{Loop xanh?}
    F -->|Đỏ <3| E
    F -->|Đỏ >=2 cãi| G[Restore checkpoint + re-prompt hẹp]
    F -->|Xanh| H[+ Regression test + mở rộng lint/build]
    H --> I[Reviewer fresh PASS]
```

Giải thích: chưa tái hiện thì chưa debug (mới đoán). Rõ file:line thì `/fix` ngay; mờ thì bisect/log trước; cãi 2 lần thì restore. Mọi bug có 1 regression test chứa issue id.

> ✅ **Kỳ vọng thấy gì:** sau `/fix`, focused test xanh trong ≤4 turns + 1 regression test mới + `diff --stat` 2 files.

---

## 1. Vì sao debug với AI hay lạc?

Ba kiểu debug đốt credits mà không ra:

- Paste 1000 dòng log vào chat chính → Copilot ngợp, đoán bừa.
- Bảo `fix giúp tôi` không scope → sửa 5 files, bug cũ chưa hết, thêm 2 bug mới.
- Cãi 5 turns (`sai rồi, sửa lại`) → mỗi turn gánh thêm rác, càng sửa càng đỏ.

Debug giỏi với Copilot là:

```text
Tai hien 1 lenh → lay failure gon → khoanh 1 file → /fix co scope → loop toi xanh.
Khong tai hien duoc thi chua debug, moi dang doan.
# Ky vong: 5 buoc nay luon tu tren xuong, chi bat dau khi co 1 lenh tai hien.
```

> Rule: **correct 2 lần vẫn sai → dừng cãi, thu hẹp scope hoặc restore checkpoint.**

---

## 2. Cơ chế: debug là thu hẹp search space

Mọi bug đều là 1 trong 3:

| Loại | Dấu hiệu | Cách thu hẹp |
|---|---|---|
| Biết chỗ (stack trace rõ) | Log chỉ file:line | Bôi đen hàm + /fix ngay |
| Biết vùng (test đỏ 1 module) | 3–5 files liên quan | Bisect: chia đôi, loại trừ |
| Không biết gì (flaky, prod) | Log dài, không tái hiện | Log→prompt: tóm tắt rồi mới fix |

Sơ đồ:

```text
[Tái hiện] → [Failure gọn] → [Khoanh scope] → [/fix] → [Loop xanh] → [Regression test]
   ↑ nếu không tái hiện: thêm log/bisect, chưa cho fix
# Ky vong: moi lan de bug vao 1 loai tron o tren, co bien duong rieng.
```

Luôn đòi root cause trước fix:

```text
"Giai thich root cause 3 bullet + file:line truoc khi sua.
Khong doan, thieu evidence thi hoi them thay vi fix bira.
# Ky vong: co du 3 bullet truoc khi bat tay sua, tranh sua man.
```

---

## 3. Move 1: /fix + debug session

### /fix nhanh cho lỗi rõ

Trong VS Code: bôi đen code đỏ → bóng đèn → Fix with Copilot, hoặc chat `/fix`.

**Ví dụ 1 — /fix có scope (copy-paste):**

```text
/fix #testFailure chỉ fix test đỏ này.
Giai thich root cause 3 bullet + file:line truoc khi sua.
Fix tou tieu, khong refactor, khong doi API.
# Ky vong: diff chi 5-10 dong, chay focused test xuan, khong lo.
```

**Ví dụ 2 — Debug session khi cần hỏi đáp (copy-paste):**

```text
Bat dau debug session cho bug: login email co dau bi 500.
- Buoc 1: doc #file:src/auth/login.ts + test lien quan, liet ke 3 gia thuyet (moi cai kem cach kiem cheng 1 lenh).
- Buoc 2: choi toi chon 1 gia thuyet moi fix.
- Khong sua code trong turn nay.
# Ky vong: 3 gia thuyet co lenh kiem cheng, doi khi chi co 1 cai dung.
```

Lợi ích: Copilot phải nêu giả thuyết + cách kiểm chứng, không fix mù.

**Ví dụ 3 — Dặn không đoán (copy-paste):**

```text
Neu stack trace thieu, dung doan.
Hoi toi toi da 3 cau de lay them evidence:
- lenh tai hien? env? commit gan nhat dung module nay?
Khi du evidence moi de xuat fix.
# Ky vong: 3 cau hoi du, co evidence, moi sua, khong sua man.
```

---

## 4. Move 2: test failure loop tới xanh

### Công thức loop

**Ví dụ 1 — Loop focused test (copy-paste):**

```text
Chay `npm test -- auth` va dan log pass/fail.
Neu do, doc #testFailure, fix tiep trong message nay toi khi xuan
hoac dung sau 3 lan va bao blocker + file:line.
Khong xoa test de xuan.
# Ky vong: 3 lan do thi dung, co blocker rang, khong cay tiep.
```

**Ví dụ 2 — Loop mở rộng V3 (copy-paste):**

```text
Sau khi focused xanh, chạy tiếp:
1. `npm test -- payments` (full scope)
2. `npm run lint`
3. `npm run build`
Dan ca 3 logs. Do o buoc nao thi fix o do, chay lai tu buoc 1.
# Ky vong: 3 logs xanh lien hop, co thay den (den 1 den ca), khong an.
```

**Ví dụ 3 — Regression test bắt buộc (copy-paste):**

```text
Them 1 regression test cover dung case vua fix:
- Ten test chua issue/bug id (vd "refund >30 ngay #101").
- Chay rieng test moi, dan log xuan.
- Chay full scope, dam bao khong ghe test cu.
# Ky vong: moi bug co 1 test moi danh rieng, bug roi khong bao.
```

Vì sao loop trong 1 message? Vì mỗi message mới là 1 request mới + context mới. Loop trong 1 message để Copilot tự retry rẻ hơn bạn nhắc tay.

---

## 5. Move 3: bisect + log→prompt

### Bisect: chia đôi để loại trừ

Khi chưa biết file nào gây lỗi, đừng bảo Copilot đọc cả repo.

**Ví dụ 1 — Bisect bằng git (copy-paste lệnh + prompt):**

```bash
# Tim commit gay loi
git bisect start
git bisect bad HEAD
git bisect good v1.2.0
# Moi buoc chay: npm test -- <scope> → good/bad
git bisect reset
# Ky vong: ~log2(so commit) lan chay test, co commit gay loi duy nhat.
```

```text
# Nho Copilot viet script bisect:
"Viet script bash: moi commit chay `npm test -- payments`,
in PASS/FAIL + 5 dong cuoi log. Toi se dung voi git bisect."
# Ky vong: script chay duoc, co du PASS/FAIL, khong lai tay.
```

**Ví dụ 2 — Bisect bằng comment code (copy-paste):**

```text
"Bug chi xay ra khi bat voucher + refund cung luc.
De xuat 3 diem bisect (tat tung cai) de xac dinh module gay loi.
Moi diem kem file:line + cach tat 1 dong + lenh verify."
# Ky vong: 3 diem tat ra, chay tung diem, khoan duoc 1 module.
```

### Log→prompt: đừng paste log thô

**Ví dụ 3 — Tóm tắt log trước khi fix (copy-paste):**

```text
# Dung paste 1000 dong vao chat chinh.
# Buoc 1: luu log ra file
npm test -- payments > /tmp/test.log 2>&1
# Ky vong: /tmp/test.log ~200-1000 dong, lenh exit != 0.

# Buoc 2: mo chat phu, gan file log:
"Doc #file:/tmp/test.log, chi tra ve:
1. 3 loi dau tien (file:line + message 1 dong moi cai)
2. Test nao do dau tien (ten + file)
3. Goi y 1 file nen doc tiep.
Khong fix, chi tom tat."
# Buoc 3: mang summary gon sang chat chinh de /fix.
# Ky vong: chat chinh chi nhan 10 dong, co dien chi doc tiep.
```

Lợi ích: chat chính chỉ nhận 10 dòng summary, không gánh 1000 dòng rác (xem [Tips 01](./01-context-hygiene.md)).

---

## 6. Move 4: @terminal + explain lỗi

### @terminal: để Copilot đọc lỗi trực tiếp

Thay vì copy paste tay, gắn terminal vào chat.

**Ví dụ 1 — @terminalLastCommand (copy-paste):**

```text
# Sau khi chay lenh do trong terminal, trong chat go:
@terminalLastCommand Giai thich loi nay 3 bullet + gori fix 1 file cu the.
Khong chay lenh nguy hiem (rm -rf, reset --hard) neu chua hoi toi.
# Ky vong: 3 bullet co file:line, fix 1 file, khong lay den file khac.
```

**Ví dụ 2 — Explain + fix có gate (copy-paste):**

```text
@testFailure Giai thich vi sao test nay do (3 bullet, kem file:line).
Sau do de xuat fix tou tieu 5 dong, choi toi duyet moi sua.
Khong dung file ngoai test + module nay.
# Ky vong: co fix de xuat, chi sua 5 dong, chaoi duyet moi tiep.
```

**Ví dụ 3 — Debug prod/flaky (copy-paste):**

```text
Bug flaky: 10 lan chay do 3 lan.
1. Liet ke 3 nguyen nhan flaky pho bien nhat cho module nay (race/timeout/order).
2. Moi cai kem 1 lenh/cach kiem cheng (retry 10 lan, seed, log timestamp).
3. De xuat them log o 2 vi tri file:line de lan sau co evidence.
Khong fix ngay, thu thap evidence truoc.
# Ky vong: co 3 nguyen nhan + 2 noi them log, lan sau co so lieu.
```

---

## 7. Walkthrough theo phút: bug 500 trong 30 phút

**Bối cảnh:** POST /api/payments/refund quá 30 ngày bị 500, log dài.

| Phút | Move | Prompt / lệnh (copy-paste) |
|---|---|---|
| 0–3 | Tái hiện | `curl -X POST localhost:3000/api/payments/refund -d '{"order":123,"days":31}'` → xác nhận 500, lưu log ra /tmp/bug.log |
| 3–8 | Log→prompt | Chat phụ: `"Tóm tắt /tmp/bug.log: 3 lỗi đầu + file:line, không fix."` → biết lỗi ở refund.ts:42 |
| 8–12 | Khoanh scope | Bôi đen hàm issueRefund() → chat Edit: `"Root cause 3 bullet trước khi sửa, giữ export."` |
| 12–20 | /fix + loop | `"/fix #testFailure, fix tối thiểu, chạy npm test -- payments, dán log. Đỏ thì loop 3 lần."` |
| 20–25 | Mở rộng | `"Chạy thêm lint + build, dán 2 logs. Thêm 1 regression test days=31."` |
| 25–30 | Review | Chat Reviewer fresh: `"Review diff vs plan, [SEVERITY] file:line, PASS/NEEDS-FIX."` → commit |

> ✅ **Kỳ vọng thấy gì:** 30 phút có bug fixed + regression test + review PASS, không cãi nhau.

Tổng 30 phút, 0 lần cãi nhau, có regression test + logs.

---

## 8. Bảng tra nhanh: lỗi nào move nào?

| Dấu hiệu | Hiểu nôm na | Ví dụ | Move đầu tiên | Prompt 1 dòng | Khi nào dừng |
|---|---|---|---|---|---|
| Stack trace rõ file:line | Có địa chỉ nhà trộm. | `TypeError` tại `login.ts:42`. | /fix scope hẹp | `/fix #testFailure, root cause 3 bullet` | Xanh focused + regression |
| Test đỏ 1 module | Biết xóm, chưa biết nhà. | 3 tests đỏ trong `payments/`. | Test loop | `Chạy focused, đỏ thì loop 3 lần` | Full scope + lint/build xanh |
| Không biết file nào | Mất dấu hoàn toàn. | Prod 500 không stack trace. | Bisect | `Đề xuất 3 điểm bisect + verify` | Khoanh được 1 file |
| Log 1000 dòng | Bệnh án dày 100 trang. | `npm test` log 1000 dòng. | Log→prompt | `Tóm tắt 3 lỗi đầu, không fix` | Có summary 10 dòng |
| Lệnh terminal đỏ | Xe chết máy giữa đường. | `npm test` exit 1 + stack 30 dòng. | @terminal | `@terminalLastCommand giải thích 3 bullet` | Hiểu lỗi + fix 1 file |
| Flaky 3/10 lần | Ma trêu: lúc đỏ lúc xanh. | 10 lần chạy đỏ 3. | Thu thập evidence | `Liệt kê 3 nguyên nhân + cách kiểm chứng` | Có log/timestamp, chưa fix vội |
| Cãi 2 lần vẫn sai | Quay vòng. | `sai rồi` ×2 không tiến. | Restore checkpoint | `Restore trước turn 1, re-prompt sạch` | Prompt mới hẹp hơn |
| Sửa A hỏng B | Lan man. | Fix 1 test gãy 5 test khác. | Thu hẹp scope | `Chỉ sửa file X, diff --stat kiểm tra` | Diff gọn + full test xanh |

### Before / After — paste mù vs thu hẹp

**Before (paste 1000 dòng + cãi):**
```text
(paste 1000 dòng log vào chat chính) "fix giúp tôi"
→ "sai rồi, sửa lại" × 5 turns
```
> Kết quả: Copilot ngợp đoán bừa, sửa 5 files lan man, càng sửa càng đỏ. 5 turns × 80K rác = 400K tokens đốt.

**After (thu hẹp 30 phút):**
```bash
npm test -- payments > /tmp/test.log 2>&1
# Ky vong: /tmp/test.log ~200-1000 dong, lenh exit != 0, co du lieu de tom.
```

```text
Chat phu: "Doc #file:/tmp/test.log, chi tra 3 loi dau (file:line + message), khong fix."
Chat chinh: "/fix #testFailure, root cause 3 bullet, fix toi thieu, chay npm test -- payments dan log, loop 3 lan."
# Ky vong: 10 dong summary → khoanh refund.ts:42 → fix 5 dong + regression → xuan.
```
> Kết quả: summary 10 dòng → khoanh `refund.ts:42` → fix 5 dòng + regression → xanh focused → lint/build xanh. Tổng ≤4 turns. Verify: `npm test -- payments` xanh + regression `days=31`.
> ✅ **Kỳ vọng thấy gì:** chat chính chỉ 10 dòng summary; `git diff --stat` 2 files.

> Quy tắc ngón tay: **rõ thì /fix ngay, mờ thì bisect/log trước, cãi 2 lần thì restore.**

---

## 9. Pitfalls + cách fix

| Pitfall | Triệu chứng | Fix |
|---|---|---|
| Paste log 1000 dòng vào chat chính | Ngợp, đoán bừa | Log→file + chat phụ tóm tắt (ví dụ 3 mục 5) |
| Fix không root cause | Hết bug này lòi bug khác | Bắt 3 bullet root cause + file:line trước khi sửa |
| Scope cả repo | Sửa lan 5 files | Bôi đen/#file 1 chỗ, NEVER file ngoài |
| Cãi 5 turns | Càng sửa càng đỏ | 2 lần sai → restore checkpoint, re-prompt hẹp |
| Xóa test để xanh | Xanh giả | Cấm xóa/sửa test trong prompt |
| Không tái hiện được mà vẫn fix | Fix mù | Thêm log/bisect, chưa tái hiện thì chưa fix |
| Chạy lệnh nguy hiểm | Mất code/data | Tool approval blocklist rm/reset --hard |
| Quên regression test | Bug quay lại tháng sau | Mọi bug đều 1 test mới chứa issue id |
| Chỉ chạy 1 file | Sửa A hỏng B | Focused xanh → full scope + build |
| Debug 1 chat 100 turns | Context bẩn, quên đầu | Tóm tắt → new chat, findings ra file |

---

## 10. Bài tập cuối bài

**Bài 1 (15 phút — /fix chuẩn):**

1. Lấy 1 test đỏ thật, bôi đen hàm lỗi.
2. Chạy prompt ví dụ 1 mục 3 (root cause + fix tối thiểu + loop).
3. Đếm turns tới xanh. Mục tiêu ≤4 turns.

**Bài 2 (20 phút — log→prompt):**

1. Lấy 1 log dài >200 dòng, lưu ra file.
2. Dùng chat phụ tóm tắt 10 dòng (ví dụ 3 mục 5).
3. Mang summary sang chat chính /fix. So tokens + chất lượng vs paste thô.

**Bài 3 (20 phút — bisect thử):**

1. Lấy 1 bug chưa biết file nào, nhờ Copilot đề xuất 3 điểm bisect.
2. Chạy bisect (git hoặc tắt từng flag), khoanh được 1 file.
3. Viết regression test + loop tới xanh, commit kèm issue id.

> ✅ **Kỳ vọng đạt:** sau 2 tuần, 80% bug của bạn có root cause 3 bullet + regression test + log xanh.

---

## 11. Tham khảo chéo

- Bài tips liên quan:
  - [Tips 01](./01-context-hygiene.md) — chat phụ tóm tắt, chat chính gọn
  - [Tips 02](./02-prompt-engineering.md) — Mẫu 1 BUG + verify + NEVER
  - [Tips 04](./04-verification-done-that.md) — loop tới xanh + review gate
  - [Tips 03](./03-plan-first-workflow.md) — debug xong thì plan fix lớn
  - [Tips 11](./11-nang-cao-cli-web-coding-agent.md) — debug trên CLI/web khi xa máy

> Mẹo 1 dòng: _debug là thu hẹp — tái hiện 1 lệnh, khoanh 1 file, /fix có scope, loop tới xanh._
