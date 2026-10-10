# Tips 01 — Context Hygiene: Giữ Copilot Sạch Để Không "Loạn"

> **Dành cho:** dev đã dùng Copilot ở mức chat hằng ngày (có chat dài, có paste log) nhưng thấy chất lượng trả lời đi xuống sau 30–60 phút.
> **Vấn đề:** chat đầy nhanh, model dở dần khi context đầy — bạn quên rule, sửa chỗ A hỏng chỗ B, và tốn AI Credits cho tokens rác.
> **Đọc xong:** áp được 4 thói quen (new chat mỗi task, attachments gọn, knowledge base thay paste, agent cô lập + checkpoints), tự chẩn đoán được chat bẩn và cứu được trong 5 phút.
> **Thời gian:** ~15 phút đọc + ~30 phút làm bài tập cuối bài.

Bài này deep-dive đúng 1 constraint của mọi best practice Copilot: **chat đầy rất nhanh, model dở dần khi context đầy.** Bạn sẽ đi qua new chat mỗi task, attachments gọn, @workspace hẹp, knowledge base, custom agent và checkpoints.

## Mục lục

- [1. Vì sao context hygiene quyết định 80%?](#1-vì-sao-context-hygiene-quyết-định-80)
- [2. Cơ chế: Copilot nhét gì vào context?](#2-cơ-chế-copilot-nhét-gì-vào-context)
- [3. Thói quen 1: new chat mỗi task](#3-thói-quen-1-new-chat-mỗi-task)
- [4. Thói quen 2: attachments gọn + @workspace scope hẹp](#4-thói-quen-2-attachments-gọn--workspace-scope-hẹp)
- [5. Thói quen 3: knowledge base + instructions thay vì paste](#5-thói-quen-3-knowledge-base--instructions-thay-vì-paste)
- [6. Thói quen 4: custom agent cô lập + checkpoints](#6-thói-quen-4-custom-agent-cô-lập--checkpoints)
- [7. Dấu hiệu chat bẩn và cách cứu](#7-dấu-hiệu-chat-bẩn-và-cách-cứu)
- [8. Walkthrough theo phút: buổi sáng 3 tasks](#8-walkthrough-theo-phút-buổi-sáng-3-tasks)
- [9. Bảng tra nhanh: công cụ dọn context Copilot](#9-bảng-tra-nhanh-công-cụ-dọn-context-copilot)
- [10. Pitfalls + cách fix (Hiểu nhầm thường gặp)](#10-pitfalls--cách-fix)
- [11. Bài tập cuối bài](#11-bài-tập-cuối-bài)
- [12. Tham khảo chéo](#12-tham-khảo-chéo)

---

## 0. Giải ngố thuật ngữ (1 câu + so sánh + ví dụ + verify)

Mỗi thuật ngữ dưới đây đủ 3 lớp: **1 câu định nghĩa**, **so sánh đời thường**, **ví dụ copy-paste** — và 1 dòng `Verify` để bạn tự kiểm chứng.

| Thuật ngữ | Hiểu nôm na (1 câu) | So sánh đời thường | Ví dụ copy-paste | Verify |
|---|---|---|---|---|
| **Context hygiene** | Giữ chat sạch để model không loạn vì rác. | Bàn làm việc: gọn thì tìm đồ 5 giây, rác thì mất 30 phút. | `#file:src/auth/login.ts` + `#selection` thay vì mở 20 tabs + paste log 800 dòng. | `git diff --stat` sau task gọn đúng scope; không phải restore. |
| **Attention dilution** | Chat đầy rác thì rule quan trọng bị chìm. | Như hét trong chợ ồn: nói nhỏ (rule) không ai nghe. | Instructions "không đụng generated/" bị quên khi chat đã 100K tokens. | New chat gọn → Copilot nhớ lại rule ngay turn 1. |
| **`#file / #selection / @workspace`** | Cách gắn đồ vào chat: 1 file / 1 đoạn / cả repo. | Đưa sách: 1 trang (#selection), 1 cuốn (#file), cả thư viện (@workspace). | `#selection` fix 1 hàm; `@workspace` explore repo lạ 1 lần rồi ghi file. | `#selection` tốn ít tokens nhất, `@workspace` đắt nhất. |
| **Knowledge base** | Tủ docs team để hỏi spec không cần paste. | Sổ tay thay vì photo 200 trang mỗi lần hỏi. | `@payments-docs refund quá 30 ngày?` kèm link nguồn trong chat. | Không paste spec mà vẫn trả đúng + có link file nguồn. |
| **Checkpoint / Timeline** | Nút Undo quay về trước khi sai. | Save game: chết thì load lại, không chơi từ đầu. | Restore `login.ts` về trước turn agent phá → re-prompt sạch. | `git diff --stat` gọn lại sau restore, không cãi turn 3. |

```mermaid
flowchart TD
    A[Task mới] --> B{Đúng task cũ?}
    B -->|Khác task| C[New chat sạch]
    B -->|Cùng task| D{Scope rộng?}
    D -->|1 hàm/file| E[#selection + #file hẹp]
    D -->|Cả module| F[@workspace 1 lần + ghi file]
    E --> G[Chat chính gọn]
    F --> G
    G --> H{Sai hướng 2 lần?}
    H -->|Có| I[Restore checkpoint + re-prompt]
    H -->|Không| J[Done -> save decisions -> New chat]
    I --> G
```

Giải thích từng bước: 1) Khác task là new chat ngay (đừng tiếc). 2) Scope hẹp thì `#selection`, rộng thì `@workspace` 1 lần rồi ghi `plan.md`. 3) Chat chính chỉ nhận summary 5 bullet, không nhận log 1000 dòng. 4) Sai 2 lần thì restore, không cãi turn 3. 5) Xong thì save `docs/decisions.md` rồi mới reset.

> ✅ **Kỳ vọng thấy gì:** sau new chat + gắn 3–5 files, chat trả đúng rule instructions ngay turn 1 (không hỏi lại files). `git diff --stat` gọn đúng scope.

---

## 1. Vì sao context hygiene quyết định 80%?

Bạn gặp cảnh này chưa:

- Bạn mở 1 chat Copilot từ sáng, nhờ fix CSS, rồi hỏi deploy, rồi nhờ viết SQL, rồi refactor auth.
- 90 phút sau Copilot quên rule trong instructions, sửa chỗ A hỏng chỗ B, trả lời lan man, gợi ý code không biên dịch được.
- Bạn đổi sang model mạnh hơn mà vẫn dở.

Cùng một model, cùng một repo, chỉ khác cách quản lý context → kết quả khác một trời một vực.

> Quy tắc vàng của bài này:
>
> - **Files persist, chat thì không.** Cái quan trọng thì lưu ra file instructions / knowledge base.
> - **1 task = 1 chat sạch.** Đổi task là new chat.
> - **Việc ồn ào đẩy sang chỗ khác** (custom agent, chat phụ, file trung gian), giữ chat chính gọn để ra quyết định.

Ba con số bạn cần ghim — mỗi con số đi kèm 1 hành động:

| Con số | Ý nghĩa | Ví dụ | Hành động |
|---|---|---|---|
| `1 task` | 1 việc 1 chat. | Bug giỏ hàng 1 chat, docs API chat khác. | Xong → new chat ngay |
| `3–5 files` | Bàn chỉ để 5 tờ giấy. | Fix login chỉ gắn `login.ts + login.test.ts`. | Quá thì thu hẹp hoặc tách chat |
| `10 phút` | Chu kỳ kiểm tra chat: còn gọn không? | Lan man → reset thay vì kéo lê | Reset trước khi trễ |

---

## 2. Cơ chế: Copilot nhét gì vào context?

### 2.1. Mỗi prompt Copilot gửi đi gồm gì?

Đây là thành phần của 1 turn chat — cộng dồn từ đầu phiên tới giờ:

```text
[system + custom instructions + prompt files khả dụng]
+ [open files / visible editors]
+ [#file / #selection / #codebase attachments bạn gắn]
+ [conversation history + tool results]
+ [prompt mới của bạn]
→ model trả lời
```

Nghĩa là **mọi thứ bạn mở đều bị tính thuế** (tính qua AI Credits):

- Mở 20 tabs để explore → 20 files nằm trong history.
- Gắn `#codebase` cả repo → hàng chục nghìn tokens mỗi turn.
- Paste log 800 dòng → 800 dòng đó gánh theo 20 turns sau.
- Kéo ảnh chụp màn hình vào chat → tokens ảnh cũng gánh theo.

### 2.2. Vì sao đầy thì dở? (3 cơ chế)

Ba cơ chế giải thích vì sao chat dài tự dở — nhớ 3 tên này là bạn chẩn đoán được mọi triệu chứng.

**1. Attention dilution (loãng sự chú ý).**

- 1 câu: chat đầy rác thì model "nghe" rule quan trọng yếu dần.
- So sánh: như nghe giảng mà xung quanh 50 người nói chuyện — nội dung chính chìm.
- Ví dụ: instructions "không đụng generated/" bị quên khi chat 100K tokens. Triệu chứng: quên convention, đổi API không xin phép, gợi ý chung chung.

**2. Recency bias + lost-in-the-middle.**

- 1 câu: model nhớ rõ đầu và cuối chat, quên đoạn giữa.
- So sánh: như đọc báo: nhớ đầu đề và kết luận, quên phần giữa.
- Ví dụ: quyết định kiến trúc bạn chốt ở turn 12 rất dễ bị chôn khi turn 40 toàn log test.
- Fix: quyết định quan trọng **ghi ra `docs/decisions.md`**, đừng tin trí nhớ hội thoại.

**3. Không có auto-compact cứu bạn.**

- 1 câu: Copilot Chat không tự tóm tắt chat cũ cho gọn.
- So sánh: như ai đó giữ nguyên đống báo cũ — chỉ phình thêm, không có ai dọn.
- Ví dụ: chat 50 turns vẫn gánh toàn bộ 50 turns đó mỗi lần bạn gõ mới.
- Fix: **bạn phải chủ động new chat**, không ai làm thay. (Khác Claude Code có auto-compact.)

### 2.3. Sơ đồ vòng đời chat

Mốc thời gian dưới đây là "đèn báo" — thấy vàng là cân nhắc reset:

```text
[Chat 0%] --làm việc--> [50%: đèn vàng, cân nhắc new chat] --> [80%: chắc chắn reset]
```

> Không vệ sinh: 10 turns × 80K rác = 800K tokens lãng phí (xóa 80.000 AI Credits theo giá per-token — xem [bài 00 mục 4](../01-huong-dan-su-dung/00-tong-quan-copilot.md)).
> Vệ sinh (new chat 1 lần, gắn lại 5K): 10 × 5K = 50K → rẻ hơn ~90%.
> Xem thêm [Tips 08](./08-tiet-kiem-premium-requests.md).

---

## 3. Thói quen 1: new chat mỗi task

Đây là thói quen ROI cao nhất trong Copilot 2026.

**Cơ chế:** nút New Chat (hoặc `Cmd/Ctrl+Shift+P → Chat: New Chat`) drop toàn bộ history, giữ file trên đĩa + nạp lại instructions. Tokens về ~0.

**Khi nào new chat:**

- Xong bug nhỏ → chuyển feature lớn.
- Paste log khổng lồ xong việc → new chat thay vì kéo lê.
- Chuẩn bị share màn hình / demo, hoặc Copilot trả lời lạc đề.

**Ví dụ 1 — New chat chuẩn (copy-paste):**

```text
# Đang ở cuối task CSS vặt, chat đã dài
# Bước 1: lưu quyết định nếu cần
Hãy tóm tắt 5 quyết định quan trọng của chat này dạng bullet để tôi lưu vào docs/decisions.md

# Bước 2: sau khi lưu -> bấm New Chat, mở đầu task mới sạch:
Đọc docs/payment-spec.md và triển khai POST /api/payments theo spec.
Chỉ sửa trong src/payments/, không đụng tới CSS.
Done = npm test payments xanh + npm run lint 0 error.
```

**Ví dụ 2 — New chat an toàn không mất việc (copy-paste):**

```text
# Task dài 2 tiếng, có quyết định quan trọng
# Prompt cuối trước khi reset:
Tóm tắt trạng thái hiện tại: đã xong gì, đang dở gì, blocker gì.
Output 8 bullet + file:line để tôi paste sang chat mới.
```

Sau đó bạn paste summary sang chat mới kèm:

```text
Tiếp tục từ summary chat trước:
[paste 8 bullet]
Đọc docs/decisions.md và chỉ làm bước 3 trong plan.md.
```

**Ví dụ 3 — Lịch new chat trong ngày (checklist):**

```text
Sáng: bug giỏ hàng -> 1 chat riêng, xong -> New Chat
Trưa: viết docs API -> 1 chat riêng, xong -> New Chat
Chiều: feature payments -> 1 chat riêng theo plan mode
Tối: review -> 1 chat fresh, chưa thấy reasoning cũ
```

> Sai lầm kinh điển: 1 chat đi từ bugfix → feature → refactor. Đừng.

---

## 4. Thói quen 2: attachments gọn + @workspace scope hẹp

### 4.1. Nguyên tắc: gắn ít mà trúng

Copilot VS Code 2026 cho bạn nhiều cách gắn context:

- `#file` — gắn 1 file cụ thể.
- `#selection` — chỉ gắn đoạn đang bôi đen.
- `#codebase` / `@workspace` — gắn cả workspace (đắt nhất).
- `#terminalLastCommand`, `#testFailure` — gắn lỗi vừa chạy.

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

Điểm hay:

- Bạn giới hạn glob ngay trong prompt.
- Bạn cấm vùng không liên quan.
- Bạn bắt output gọn (5 bullet + file:line).

**Ví dụ 3 — Dùng #testFailure thay vì paste log (copy-paste):**

```text
# Sau khi chạy test đỏ, đừng paste 500 dòng log
# Trong chat gõ:
/fix #testFailure chỉ fix test đỏ này, giải thích root cause 3 bullet trước khi sửa.
Không refactor file khác.
```

Lợi ích:

- Copilot tự lấy failure gọn, không mang cả log rác.
- Bạn không tốn tokens paste tay.
- Xem thêm [Tips 10](./10-debugging-power-moves.md).

### 4.2. Khi nào dùng @workspace?

Bảng dưới đây chọn giúp bạn công cụ theo tình huống:

| Tình huống | So sánh nôm na | Ví dụ | Dùng gì | Vì sao |
|---|---|---|---|---|
| Fix 1 hàm cụ thể | Đưa đúng 1 trang sách. | Fix `validate()` email có dấu. | `#selection` + `#file` test | Rẻ nhất, chính xác nhất |
| Hỏi flow 1 module | Đưa 1 chương sách. | Flow refund trong `src/payments/*.ts`. | `#file` 3–5 files + prompt hẹp | Đủ context, không tràn |
| Explore repo lạ | Nhờ thủ thư tìm 1 lần rồi ghi giấy. | Repo mới 500 files, chưa biết gì. | `@workspace` 1 lần + ghi ra plan.md | Chỉ đắt 1 lần, sau đó new chat |
| Hỏi kiến trúc tổng | Hỏi sổ tay, không lục kệ. | Quy ước refund 30 ngày ở đâu? | Knowledge base / docs | Không cần quét code raw |

> Mẹo: explore bằng `@workspace` xong → **ghi findings ra file → new chat** chỉ đọc file đó.
> Đừng mang chat explore nặng đi implement tiếp.

---

## 5. Thói quen 3: knowledge base + instructions thay vì paste

### 5.1. Vì sao paste lại là nợ?

- 1 câu: mỗi lần bạn paste spec là bạn "tiền trả trước" cho 1 lần hỏi — nhưng spec ở đó gánh mọi turn sau.
- So sánh: như photo 200 trang hợp đồng rồi quẳng vào túi — mỗi lần mở túi đều nặng.
- Ví dụ: paste spec 200 dòng vào mỗi chat → mỗi turn trả thuế 200 dòng; quên paste 1 lần → Copilot làm sai.
- Fix: đưa spec vào **knowledge base** (GitHub) hoặc **`.github/copilot-instructions.md`** (VS Code, chuẩn 2026).

### 5.2. Custom instructions trong VS Code

Tạo file `.github/copilot-instructions.md` (tên chuẩn 2026):

**Ví dụ 1 — Instructions gọn (copy-paste):**

```markdown
# copilot-instructions.md — <200 dòng

## Stack
- Node 20, TypeScript strict, pnpm.

## Luật hay sai nhất (front-load lên đầu)
- Luôn chạy `npm test -- payments` trước khi kết luận done.
- Không sửa `src/generated/`, không commit thẳng main.
- Mọi API mới phải có test trong `__tests__/`.

## Lệnh hay dùng
- test: `npm test -- <scope>`
- lint: `npm run lint`
- build: `npm run build`

## Chi tiết xem thêm
- Kiến trúc: docs/architecture.md
- DB: docs/db-conventions.md
```

Lợi ích:

- Nạp mọi turn nhưng chỉ 1 lần viết.
- Không cần paste lại mỗi chat.
- Chi tiết xem [Tips 07](./07-thiet-ke-prompts-skills.md).

**Ví dụ 2 — Knowledge base trên GitHub (copy-paste setup):**

```text
Repo -> Settings -> Copilot -> Knowledge bases -> New
Nguồn: docs/, wiki, ADRs
Đặt tên: payments-docs
Dùng trong chat: @payments-docs flow refund hiện tại là gì?
```

Khi hỏi:

```text
@payments-docs Chính sách refund quá 30 ngày là gì?
Trả lời kèm link file nguồn + 3 bullet.
Không suy đoán ngoài docs.
```

**Ví dụ 3 — Đừng paste, hãy dẫn đường (copy-paste):**

```text
TỆ: paste 300 dòng schema vào chat
TỐT: "Đọc docs/db-conventions.md + src/db/schema.ts,
chỉ lấy bảng orders và payments, tóm tắt 5 bullet quan hệ chính."
```

> Lưu ý 2026: prompt files (`.prompt.md`) đang deprecated trên Agent Host — việc lặp nên chuyển sang **Agent Skills** (`SKILL.md`, chuẩn mở). Xem [Tips 07](./07-thiet-ke-prompts-skills.md).

---

## 6. Thói quen 4: custom agent cô lập + checkpoints

### 6.1. Custom agent = chat có vai hẹp

VS Code Copilot cho bạn tạo custom agents (chat modes):

- `Planner` — chỉ lập plan, không code.
- `Reviewer` — chỉ review, không sửa.
- `Tester` — chỉ viết/chạy test.

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

Dùng:

```text
@Planner Đọc src/auth/ và lập plan tách file auth.ts 900 dòng.
Không code trong turn này.
```

**Ví dụ 2 — Reviewer fresh (copy-paste):**

```text
# Mở chat mới, chọn agent Reviewer
Review diff hiện tại với plan trong plan.md.
Finding = bug/correctness/security/test-gap thực sự, bỏ qua style.
Trả về [SEVERITY] file:line — mô tả — gợi ý fix.
Cuối cùng: PASS / NEEDS-FIX + 3 gaps ưu tiên nhất.
```

Vì là chat mới + agent khác → không bị định kiến người viết.

**Ví dụ 3 — Checkpoints: undo khi đi sai (quy trình):**

```text
Turn 1: "Sửa hàm login, đừng đổi API."
→ Copilot đổi API + hỏng test.

Turn 2: "Tôi đã bảo đừng đổi API, sửa lại."
→ Vẫn đỏ.

STOP. Không gõ turn 3.
Vào Timeline / Checkpoint -> Restore điểm trước turn 1 -> re-prompt sạch:

"Chỉ sửa src/auth/login.ts hàm validate(), giữ nguyên export.
Trước khi sửa, đọc src/auth/__tests__/login.test.ts và liệt kê 3 cases phải giữ xanh."
```

Rule: **correct 2 lần vẫn sai → dừng cãi, restore checkpoint.**

Xem thêm leo thang Ask → Edit → Agent ở [Tips 03](./03-plan-first-workflow.md).

---

## 7. Dấu hiệu chat bẩn và cách cứu

Bảng dưới đây là bảng chẩn đoán — tìm cột "Dấu hiệu" giống cảnh bạn đang gặp, rồi lấy nguyên câu ở cột "Cứu ngay".

| Dấu hiệu | Chẩn đoán | Cứu ngay (copy-paste) |
|---|---|---|
| Copilot đọc hàng trăm file sau chữ "investigate" | Scope quá rộng | `"Chỉ explore src/auth/login*, trả 5 files liên quan nhất"` |
| Trả lời dài, lan man, quên rule đầu chat | Attention dilution | New chat + nạp lại instructions + plan.md gọn |
| Sửa chỗ A hỏng chỗ B | Task quá lớn trong 1 chat | Chia phase, mỗi phase 1 chat fresh |
| Reviewer tự khen code mình viết | Định kiến người viết | Mở chat Reviewer fresh, chưa thấy reasoning cũ |
| Gắn @workspace mọi câu hỏi | Thuế context nặng | Đổi sang #file/#selection, @workspace chỉ khi explore |
| Paste log 1000 dòng vào chat chính | Rác kéo dài 20 turns | Paste vào file → nhờ chat phụ tóm tắt, chat chính chỉ nhận summary |
| Model hỏi lại file vừa đọc | Vừa new chat mất references | Gắn lại #file + dặn đọc, đây là chi phí bình thường |

---

## 8. Walkthrough theo phút: buổi sáng 3 tasks

**Bối cảnh:** bạn có 3 việc: bug giỏ hàng, viết docs API, plan feature payments.

| Phút | Chat | Prompt mở đầu (copy-paste) |
|---|---|---|
| 0–5 | Chat 1 fresh | `"#selection Fix bug total giỏ hàng sai khi voucher 0đ. Chỉ sửa file này, giữ export. Chạy npm test -- cart rồi dán log."` |
| 5–25 | Chat 1 | Iterate fix, chạy test, dán log xanh → lưu decisions nếu cần → New Chat |
| 25–30 | Chat 2 fresh | `"Đọc src/api/ (tối đa 5 files), viết docs/api.md gồm 3 endpoints + ví dụ curl. Không sửa code."` |
| 30–50 | Chat 2 | Duyệt docs, sửa chính tả → New Chat |
| 50–70 | Chat 3 fresh + @Planner | `"@Planner Đọc docs/sprint-12.md + src/payments/. Trình plan P1: files sửa, steps, risks, verify. Chờ duyệt, không code."` |
| 70–75 | Checkpoint | Duyệt plan, save plan.md, commit. Chiều implement bằng chat Edit fresh khác |

Kết quả: 3 chats gọn (<50% rác mỗi cái) thay vì 1 chat 3 tiếng đầy rác.

---

## 9. Bảng tra nhanh: công cụ dọn context Copilot

| Công cụ | Giữ context cũ? | Giữ code? | Tốn AI Credits? | Dùng khi nào? |
|---|---|---|---|---|
| New Chat | Không (xóa 100%) | Có (file giữ) | 0 + đọc lại vài K | Đổi task hoàn toàn |
| #file / #selection | Chỉ lấy đúng chỗ | Có | Rẻ nhất | Fix 1 hàm, hỏi 1 file |
| @workspace / #codebase | Lấy rộng | Có | Đắt, 1 lần | Explore repo lạ, hỏi tổng |
| Custom agent (Planner/Reviewer) | Cô lập theo vai | Tùy | Overhead nhỏ | Plan, review fresh |
| Knowledge base (@docs) | Lấy docs gọn | Có | Rẻ | Hỏi spec, chính sách |
| Checkpoint / Timeline restore | Quay về điểm cũ | Có thể revert | Rẻ | Đi sai hướng, muốn quay lại |
| Mở chat phụ hỏi lẻ | Không bẩn chat chính | Có | 1 turn | Hỏi phụ nhanh |

> Quy tắc ngón tay: **khác task → new chat; fix 1 chỗ → #selection; explore rộng → @workspace 1 lần rồi ghi file; hỏi spec → knowledge base; sai hướng → restore checkpoint.**

---

## 10. Pitfalls + cách fix (Hiểu nhầm thường gặp)

| Pitfall | Vì sao dính | Fix |
|---|---|---|
| Nuôi 1 chat 200 turns cho 5 việc | Tiện, ngại new chat | 1 việc 1 chat, new chat giữa việc |
| `@workspace fix giúp tôi` không scope | Prompt quá rộng | Khoanh glob + câu hỏi + output format |
| Reviewer tự review bài mình → LGTM mù | Định kiến writer | Luôn chat Reviewer fresh |
| Paste log 1000 dòng vào chat chính | Nhanh | Paste vào file → chat phụ tóm tắt |
| Mở 20 tabs rồi hỏi | Copilot ngốn open files | Đóng tabs thừa, chỉ giữ 3–5 files cần |
| Instructions 600 dòng | Sợ quên nên nhét hết | <200 dòng + dẫn link docs |
| Cài 15 extensions MCP lung tung | Sợ thiếu tool | Prune 2 tuần không dùng (xem Tips 08) |
| New chat xong tiếc decisions | Quên save | Tóm tắt ra docs/decisions.md trước khi reset |
| Tin "should work" | Mệt, muốn xong | Đòi log/diff/test xanh (xem Tips 04) |
| Gắn ảnh chụp code thay vì file | Lười copy path | Gắn #file để Copilot đọc text thật |

### Before / After — prompt dở vs tốt (kết quả khác nhau)

Hai prompt dưới đây cùng 1 việc (fix login) — so kết quả để nhớ vì sao scope quan trọng.

**Before (prompt dở — chat bẩn):**

```text
@workspace fix login giúp tôi
```

> Kết quả dở: Copilot đọc 40 files, sửa 3 chỗ không liên quan, quên rule "không đụng generated/", test đỏ 2 chỗ mới. Bạn mất 45 phút restore + 5 turns cãi. Tokens ~80K/turn vì gánh cả repo.

**After (prompt tốt — chat sạch):**

```text
#selection Fix hàm validate() login email có dấu bị 500.
Chỉ sửa trong file này, giữ nguyên export.
Trước khi sửa, liệt kê 3 test cases trong src/auth/__tests__/login.test.ts phải giữ xanh.
```

> Kết quả tốt: Copilot chỉ đọc 2 files, fix 5 dòng + 1 regression test, dán log `npm test -- auth` xanh. Tổng 2 turns, ~5K tokens/turn. Verify: `git diff --stat` chỉ 2 files.
> ✅ **Kỳ vọng thấy gì:** After cho diff gọn + log xanh ngay; Before cho diff phình + phải restore.

---

## 11. Bài tập cuối bài

**Bài 1 (15 phút — đo chat hiện tại):**

1. Mở repo bạn hay làm nhất, đếm: bao nhiêu tabs đang mở, chat hiện tại bao nhiêu turns.
2. Ghi ra: top 2 kẻ ngốn context (tabs thừa, @workspace, log paste).
3. Rút gọn instructions xuống <200 dòng, đóng tabs chỉ giữ 5 files.

**Bài 2 (30 phút — tách 1 chat bẩn thành 3 sạch):**

1. Lấy 1 chat >50 turns, tách thành research → plan → implement.
2. Mỗi phase 1 chat mới với prompt mở đầu riêng.
3. So số retry trước/sau, số lần sửa A hỏng B.

**Bài 3 (20 phút — hẹp vs rộng):**

1. Cùng 1 câu hỏi, thử 2 cách: (a) `@workspace` rộng, (b) `#file` 3 files hẹp.
2. Đo tokens, số files đọc, câu trả lời nào trúng hơn?

> Chấm điểm: sau 1 tuần, số lần new chat tăng gấp đôi và sửa A hỏng B giảm một nửa → đạt.

---

## 12. Tham khảo chéo

- Bài tips liên quan:
  - [Tips 02](./02-prompt-engineering.md) — viết prompt gọn để đỡ rác từ đầu
  - [Tips 03](./03-plan-first-workflow.md) — Ask → Edit → Agent leo thang
  - [Tips 05](./05-parallel-agents.md) — fan-out multi-chat đúng cách
  - [Tips 08](./08-tiet-kiem-premium-requests.md) — model routing + tiết kiệm AI Credits
  - [Tips 10](./10-debugging-power-moves.md) — debug không bẩn chat chính

> Mẹo 1 dòng: _files persist, chat thì không — cái gì quan trọng thì save ra file trước khi new chat._
