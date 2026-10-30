# Tips 01 — Context Hygiene: Giữ Copilot Sạch Để Không "Loạn"

> **Dành cho:** dev dùng Copilot hằng ngày nhưng thấy chất lượng trả lời đi xuống sau 30–60 phút chat dài.
> **Vấn đề:** chat đầy nhanh, model dở dần khi context đầy — quên rule, sửa chỗ A hỏng chỗ B, tốn AI Credits cho tokens rác.
> **Đọc xong:** áp được 4 thói quen (new chat mỗi task, attachments gọn, knowledge base thay paste, agent cô lập + checkpoints) và tự chẩn đoán chat bẩn trong 5 phút.
> **Thời gian:** ~15 phút đọc + ~30 phút làm bài tập cuối bài.

## 1. Vì sao context hygiene quyết định kết quả?

Cùng model, cùng repo — chỉ khác cách quản lý context là kết quả khác một trời một vực:

- 1 chat từ sáng: fix CSS → hỏi deploy → viết SQL → refactor auth. 90 phút sau Copilot quên rule, sửa A hỏng B.
- Đổi model mạnh hơn mà vẫn dở — vì gốc rễ là **chat đầy rác**, không phải model yếu.

Ba quy tắc vàng:

1. **Files persist, chat thì không.** Cái quan trọng thì lưu ra instructions / knowledge base.
2. **1 task = 1 chat sạch.** Đổi task là new chat.
3. **Việc ồn ào đẩy sang chỗ khác** (custom agent, chat phụ, file trung gian) — chat chính chỉ để ra quyết định.

| Con số cần ghim | Ý nghĩa | Hành động |
|---|---|---|
| `1 task` | 1 việc 1 chat | Xong → new chat ngay |
| `3–5 files` | Số files gắn mỗi câu hỏi | Quá thì thu hẹp hoặc tách chat |
| `2 lần sai` | Ngưỡng dừng cãi | Restore checkpoint, re-prompt hẹp |

## 2. Copilot nhét gì vào context?

Mỗi turn gửi đi (cộng dồn từ đầu phiên):

```text
[system + custom instructions + prompt files/skills khả dụng]
+ [open files / visible editors]
+ [#file / #selection / #codebase attachments bạn gắn]
+ [conversation history + tool results]
+ [prompt mới của bạn]
```

Nghĩa là **mọi thứ bạn mở đều bị tính thuế** (tính qua AI Credits):

- Mở 20 tabs để explore → 20 files nằm trong history.
- Gắn `#codebase` cả repo → hàng chục nghìn tokens mỗi turn.
- Paste log 800 dòng → 800 dòng đó gánh theo 20 turns sau.

Vì sao chat dài tự dở — 3 cơ chế:

1. **Attention dilution:** chat đầy rác thì rule quan trọng bị chìm — instructions "không đụng generated/" bị quên khi chat 100K tokens.
2. **Recency bias + lost-in-the-middle:** model nhớ rõ đầu/cuối chat, quên giữa — quyết định chốt ở turn 12 bị chôn dưới log ở turn 40. Fix: ghi quyết định ra `docs/decisions.md`.
3. **Không auto-compact:** Copilot Chat không tự tóm tắt chat cũ — chat 50 turns vẫn gánh cả 50 turns. Fix: **bạn phải chủ động new chat**. (Claude Code có auto-compact.)

> Lưu ý: thấy model quên rule mà viết instructions dài hơn là thêm rác — mọi vấn đề "chat dài" xử bằng new chat + ghi quyết định ra file.

## 3. Thói quen 1: new chat mỗi task

Nút New Chat (`Cmd/Ctrl+Shift+P → Chat: New Chat`) xóa toàn bộ history, giữ file trên đĩa + nạp lại instructions. Tokens về ~0 — đây là đòn bẩy rẻ nhất.

**Khi nào new chat:** xong 1 việc; paste log khổng lồ xong việc; chuẩn bị share màn hình; Copilot trả lời lạc đề.

**Ví dụ 1 — New chat chuẩn (copy-paste):**

```text
# Cuối task, chat đã dài — bước 1: lưu quyết định
Hãy tóm tắt 5 quyết định quan trọng của chat này dạng bullet để tôi lưu vào docs/decisions.md

# Bước 2: sau khi lưu → New Chat, mở đầu task mới:
Đọc docs/payment-spec.md và triển khai POST /api/payments theo spec.
Chỉ sửa trong src/payments/, không đụng tới CSS.
Done = npm test payments xanh + npm run lint 0 error.
```

**Ví dụ 2 — New chat an toàn không mất việc (copy-paste):**

```text
# Prompt cuối trước khi reset:
Tóm tắt trạng thái hiện tại: đã xong gì, đang dở gì, blocker gì.
Output 8 bullet + file:line để tôi paste sang chat mới.
```

Rồi paste summary sang chat mới kèm: `"Tiếp tục từ summary chat trước: [paste 8 bullet]. Đọc docs/decisions.md và chỉ làm bước 3 trong plan.md."`

> Sai lầm kinh điển: 1 chat đi từ bugfix → feature → refactor. Việc sau thừa hưởng toàn bộ rác của việc trước.

## 4. Thói quen 2: attachments gọn + @workspace scope hẹp

Copilot VS Code có nhiều cách gắn context: `#file` (1 file), `#selection` (đoạn bôi đen), `#codebase`/`@workspace` (cả repo — đắt nhất), `#terminalLastCommand`, `#testFailure` (lỗi vừa chạy).

Rule: **ưu tiên `#file` + `#selection`, hạn chế `@workspace`.**

**Ví dụ 1 — Gắn hẹp cho bug (copy-paste):**

```text
# Thay vì: @workspace fix login giúp tôi (quá rộng)
# Hãy bôi đen hàm validate() rồi gõ:
#selection Fix hàm này: login email có dấu bị 500.
Chỉ sửa trong file này, giữ nguyên export.
Trước khi sửa, liệt kê 3 test cases trong src/auth/__tests__/login.test.ts phải giữ xanh.
```

**Ví dụ 2 — @workspace có kỷ luật (copy-paste):**

```text
@workspace Chỉ trong src/payments/*.ts:
liệt kê flow refund hiện tại (5 bullet + file:line).
Không đọc src/legacy/, không đọc node_modules.
Nếu cần thêm file, hỏi tôi trước.
```

**Ví dụ 3 — Dùng #testFailure thay vì paste log (copy-paste):**

```text
/fix #testFailure chỉ fix test đỏ này, giải thích root cause 3 bullet trước khi sửa.
Không refactor file khác.
```

Chọn công cụ theo tình huống:

| Tình huống | Dùng gì | Vì sao |
|---|---|---|
| Fix 1 hàm cụ thể | `#selection` + `#file` test | Rẻ nhất, chính xác nhất |
| Hỏi flow 1 module | `#file` 3–5 files + prompt hẹp | Đủ context, không tràn |
| Explore repo lạ | `@workspace` 1 lần + ghi ra plan.md | Chỉ đắt 1 lần, sau đó new chat |
| Hỏi kiến trúc/chính sách | Knowledge base / docs | Không cần quét code raw |

> Mẹo: explore bằng `@workspace` xong → **ghi findings ra file → new chat** chỉ đọc file đó. Đừng mang chat explore nặng đi implement tiếp.

## 5. Thói quen 3: knowledge base + instructions thay vì paste

Mỗi lần paste spec là "trả thuế" cho mọi turn sau, và quên paste 1 lần là Copilot làm sai. Cái gì lặp lại thì đưa vào file một lần:

- **Custom instructions** — tạo `.github/copilot-instructions.md` (<200 dòng, luật hay sai nhất front-load lên đầu):

```markdown
## Stack
- Node 20, TypeScript strict, pnpm.

## Luật hay sai nhất
- Luôn chạy `npm test -- payments` trước khi kết luận done.
- Không sửa `src/generated/`, không commit thẳng main.
- Mọi API mới phải có test trong `__tests__/`.

## Lệnh hay dùng
- test: `npm test -- <scope>` · lint: `npm run lint` · build: `npm run build`
```

- **Knowledge base trên GitHub** (Repo → Settings → Copilot → Knowledge bases → New; nguồn: docs/, wiki, ADRs). Hỏi: `@payments-docs Chính sách refund quá 30 ngày là gì? Kèm link file nguồn, 3 bullet, không suy đoán ngoài docs.`

| Tiêu chí | Knowledge base | Custom instructions |
|---|---|---|
| Đựng gì | Spec, chính sách, ADR, wiki dài | Luật code, stack, lệnh, cấm địa |
| Cách dùng | Gọi `@payments-docs <câu hỏi>` khi cần | Tự nạp mọi turn |
| Khi nào dùng | Cần tra cứu | Cần tự nhớ mọi turn |

> Lưu ý 2026: prompt files (`.prompt.md`) đã deprecated cho Agent Host — việc lặp nên chuyển sang **Agent Skills** (`SKILL.md`). Xem [Tips 07](./07-thiet-ke-prompts-skills.md).

## 6. Thói quen 4: custom agent cô lập + checkpoints

Tạo custom agents (chat modes) với vai hẹp: `Planner` (chỉ plan), `Reviewer` (chỉ review), `Tester` (chỉ test). Mỗi vai chỉ thấy một phần context → hết cảnh "LGTM mù" (model tự khen code mình vừa viết).

**Ví dụ 1 — Tạo Planner agent (copy-paste frontmatter):**

```markdown
---
name: Planner
description: Lập plan, không code. Dùng khi task >2 steps.
tools: [search, read]
---

Bạn chỉ lập plan, không sửa code.
Mọi task: đọc tối đa 5 files, trình plan gồm files sửa,
steps, risks, verify từng phase. Chờ duyệt mới dừng.
```

**Ví dụ 2 — Reviewer fresh (copy-paste vào chat mới):**

```text
Review diff hiện tại với plan trong plan.md.
Finding = bug/correctness/security/test-gap thực sự, bỏ qua style.
Trả về [SEVERITY] file:line — mô tả — gợi ý fix.
Cuối cùng: PASS / NEEDS-FIX + 3 gaps ưu tiên nhất.
```

**Ví dụ 3 — Checkpoints: undo khi đi sai (quy trình):**

```text
Turn 1: "Sửa hàm login, đừng đổi API." → Copilot đổi API + hỏng test.
Turn 2: "Tôi đã bảo đừng đổi API, sửa lại." → Vẫn đỏ.

STOP. Không gõ turn 3.
Timeline / Checkpoint → Restore điểm trước turn 1 → re-prompt sạch:
"Chỉ sửa src/auth/login.ts hàm validate(), giữ nguyên export.
Trước khi sửa, đọc src/auth/__tests__/login.test.ts và liệt kê 3 cases phải giữ xanh."
```

Rule: **correct 2 lần vẫn sai → dừng cãi, restore checkpoint.** Leo thang Ask → Edit → Agent xem [Tips 03](./03-plan-first-workflow.md).

## 7. Chẩn đoán chat bẩn — cứu ngay

| Dấu hiệu | Chẩn đoán | Cứu ngay |
|---|---|---|
| Trả lời dài, lan man, quên rule đầu chat | Attention dilution | New chat + nạp lại instructions + plan.md gọn |
| Sửa chỗ A hỏng chỗ B | Task quá lớn trong 1 chat | Chia phase, mỗi phase 1 chat fresh |
| Reviewer tự khen code mình viết | Định kiến người viết | Mở chat Reviewer fresh, chưa thấy reasoning cũ |
| Gắn @workspace mọi câu hỏi | Thuế context nặng | Đổi sang #file/#selection, @workspace chỉ khi explore |
| Paste log 1000 dòng vào chat chính | Rác kéo dài 20 turns | Paste vào file → chat phụ tóm tắt, chat chính chỉ nhận summary |
| Model hỏi lại file vừa đọc | Mất references sau new chat | Gắn lại #file + dặn đọc — chi phí bình thường |

## 8. Bảng tra nhanh: công cụ dọn context

| Công cụ | Giữ context cũ? | Tốn AI Credits? | Dùng khi nào? |
|---|---|---|---|
| New Chat | Không (xóa 100%) | 0 + đọc lại vài K | Đổi task hoàn toàn |
| #file / #selection | Chỉ lấy đúng chỗ | Rẻ nhất | Fix 1 hàm, hỏi 1 file |
| @workspace / #codebase | Lấy rộng | Đắt, 1 lần | Explore repo lạ, hỏi tổng |
| Custom agent | Cô lập theo vai | Overhead nhỏ | Plan, review fresh |
| Knowledge base | Lấy docs gọn | Rẻ | Hỏi spec, chính sách |
| Checkpoint / Timeline | Quay về điểm cũ | Rẻ | Đi sai hướng, muốn quay lại |

> Quy tắc ngón tay: **khác task → new chat; fix 1 chỗ → #selection; explore rộng → @workspace 1 lần rồi ghi file; hỏi spec → knowledge base; sai hướng → restore checkpoint.**

## 9. Pitfalls + cách fix

| Pitfall | Fix |
|---|---|
| Nuôi 1 chat 200 turns cho 5 việc | 1 việc 1 chat, new chat giữa việc |
| `@workspace fix giúp tôi` không scope | Khoanh glob + câu hỏi + output format |
| Reviewer tự review bài mình | Luôn chat Reviewer fresh |
| Paste log 1000 dòng vào chat chính | Paste vào file → chat phụ tóm tắt |
| Mở 20 tabs rồi hỏi | Đóng tabs thừa, chỉ giữ 3–5 files cần |
| New chat xong tiếc decisions | Tóm tắt ra docs/decisions.md trước khi reset |
| Gắn ảnh chụp code thay vì file | Gắn #file để Copilot đọc text thật |

## 10. Bài tập cuối bài

**Bài 1 (15 phút):** Mở repo hay làm nhất — đếm tabs + turns chat hiện tại, ghi top 2 kẻ ngốn context. Rút gọn instructions <200 dòng, đóng tabs chỉ giữ 5 files.

**Bài 2 (30 phút):** Lấy 1 chat >50 turns, tách thành research → plan → implement, mỗi phase 1 chat mới với prompt mở đầu riêng. So số retry trước/sau.

**Bài 3 (20 phút):** Cùng 1 câu hỏi, thử (a) `@workspace` rộng, (b) `#file` 3 files hẹp. So tokens, số files đọc, câu trả lời nào trúng hơn?

> Chấm điểm: sau 1 tuần, số lần new chat tăng gấp đôi và sửa A hỏng B giảm một nửa → đạt.

## Tham khảo chéo

- [Tips 02](./02-prompt-engineering.md) — viết prompt gọn để đỡ rác từ đầu
- [Tips 03](./03-plan-first-workflow.md) — Ask → Edit → Agent leo thang
- [Tips 05](./05-parallel-agents.md) — fan-out multi-chat đúng cách
- [Tips 08](./08-tiet-kiem-premium-requests.md) — model routing + tiết kiệm AI Credits
- [Tips 10](./10-debugging-power-moves.md) — debug không bẩn chat chính

> **Chốt Tips 01:** cái gì đáng nhớ thì đưa ra khỏi chat và để vào file — file sống qua mọi phiên, chat chỉ sống tới lần bạn gõ thêm một việc lạ. Làm chủ được "đổi việc là new chat" là bạn đã thắng 80% cuộc chơi context.
