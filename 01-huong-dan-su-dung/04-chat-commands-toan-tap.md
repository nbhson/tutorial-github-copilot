# 04 — Chat Commands Toàn Tập (Slash, Participants, Variables)

> **Dành cho:** người mới lẫn dev đã dùng Copilot — dùng làm index tra cứu chat commands Copilot 2026.
> **Vấn đề:** gõ prompt tự nhiên dài dòng, tốn turns làm rõ, không biết lệnh nào đang có sẵn.
> **Đọc xong:** biết chọn đúng nhóm lệnh, chạy được công thức 5 lệnh session đầu, và tự debug khi lệnh "bị mất".
> **Cách dùng:** tìm nhóm → đọc mô tả 1 dòng → click link sang folder chi tiết. Mỗi lệnh có 1 folder riêng trong `commands/` (vd `commands/chat-session/new-chat/`) chứa README chi tiết. **Thời gian:** ~20 phút đọc + tra cứu dần.

## Mục tiêu bài học

Mục này cho bạn biết đọc xong bài bạn có được gì, để đo xem có đạt hay không.

- Tra đúng nhóm ký hiệu: `/` (chạy workflow), `@` (chọn nguồn tri thức), `#` (gắn file/vùng chọn).
- Chạy được **công thức 5 lệnh session đầu** trên 1 repo thật.
- Tự debug khi một lệnh "biến mất" — phân biệt plan/model gating với extension cũ.

---

## 1. Cách đọc index này

Mục này giải thích bài được tổ chức thế nào, để bạn tra cứu nhanh thay vì đọc lướt hết.

- **Là gì (1 câu):** chat commands là 3 ký hiệu — `/` (lệnh), `@` (gọi đúng người), `#` (đưa đúng tài liệu) — giúp gắn scope ngay từ turn 1.
- **Nôm na:** `/` như gọi món theo số (nhanh, chuẩn), `@` như gọi đúng nhân viên (thu ngân / bếp), `#` như đưa đúng hóa đơn cho họ xem.
- **Ví dụ:** gõ `/fix #selection thêm null check` nhanh và rẻ hơn gõ "bạn ơi sửa giúp mình đoạn code này với..." 3 turns làm rõ.

```text
Công thức gắn scope đủ 3 ký hiệu (dán thẳng vào Chat):
"@workspace tìm mọi nơi gọi POST /orders. #file:src/routes/orders.ts fix crash khi
thiếu customerId, thêm regression test, chạy npm test xác nhận."
# Kỳ vọng: turn 1 agent đã đọc đúng file, không hỏi lại "file nào?".
```

> **Kỳ vọng / Verify:** gõ `/` trong Chat input phải thấy list lệnh; gõ `@` thấy participants; gõ `#` thấy variables. Không thấy = extension cũ hoặc plan gating (mục 5).

> **Tóm gọn 1 câu:** index này là bảng tra cứu 3 ký hiệu `/` `@` `#` — nhớ "gọi món, gọi người, đưa giấy" là dùng đúng ngay lần đầu.

**Vì sao học commands?** Mục này trả lời câu hỏi "học cho uổng không". Prompt tự nhiên linh hoạt nhưng tốn tokens + thiếu determinism (nghĩa là cùng một yêu cầu, mỗi lần model hiểu một kiểu). Commands là "đường tắt có kiểm chứng": gắn đúng scope, đúng model, đúng tools ngay từ turn 1 — rẻ hơn 3–5 turns làm rõ. Prompt code nên có `#file`/`#selection` hoặc `@workspace` ngay turn 1.

---

## 2. Nhóm 1 — Chat session (12)

Mục này liệt kê các lệnh quản lý vòng đời một phiên chat — mở, xóa, lưu, quay lui. Quản lý phiên chat giống quản lý giấy tờ trên bàn: biết mở tờ mới, cất tờ cũ, tìm lại tờ đã cất.

Quản lý vòng đời 1 phiên chat: mở mới, xóa, lưu, quay checkpoint. Ví dụ `/new` → chat trắng, history cũ biến mất, instructions vẫn load.

| Lệnh | Là gì (nôm na) | Chi tiết |
|---|---|---|
| `/new` | Mở chat mới, xóa history (thói quen #1 mỗi task) | [new-chat](./commands/chat-session/new-chat/README.md) |
| `/clear` | Xóa context trong chat hiện tại, giữ instructions | [clear](./commands/chat-session/clear/README.md) |
| `/history` | Xem lại lịch sử chats, quay lại chat cũ | [history](./commands/chat-session/history/README.md) |
| `/export` | Export conversation ra file để lưu/share | [export](./commands/chat-session/export/README.md) |
| `/resume` | Mở lại phiên chat đã lưu | [resume](./commands/chat-session/resume/README.md) |
| `Ctrl+I` inline | Chat inline ngay trong editor, sửa tại chỗ | [inline-chat](./commands/chat-session/inline-chat/README.md) |
| `Quick Chat` | Hỏi nhanh không rời editor | [quick-chat](./commands/chat-session/quick-chat/README.md) |
| `Checkpoint` | Quay về checkpoint trước khi agent sửa sai | [checkpoints](./commands/chat-session/checkpoints/README.md) |
| `Attach` | Đính kèm file/folder/ảnh vào prompt | [attachments](./commands/chat-session/attachments/README.md) |
| `/help` | Xem help + nhóm lệnh khả dụng | [help](./commands/chat-session/help/README.md) |
| `Shortcuts` | Liệt kê phím tắt Chat trong IDE này | [shortcuts](./commands/chat-session/shortcuts/README.md) |
| `/summarize` | Tóm tắt hội thoại dài thành bản gọn giữ đà task | [summarize](./commands/chat-session/summarize/README.md) |

> **Cách đọc bảng này:** cột 1 là lệnh để gõ, cột 2 giải thích lệnh đó làm gì bằng lời đời thường, cột 3 là link sang trang chi tiết nếu cần đọc sâu.

> **Tóm gọn 1 câu:** nhóm lệnh session giúp bạn mở/xóa/lưu/quay-lui phiên chat — việc dọn dẹp cơ bản của một cuộc trò chuyện với Copilot.

## 3. Nhóm 2 — Model & Agent (10)

Mục này về việc chọn "động cơ" và "chế độ lái" — tương tự chọn xe và chọn ai cầm lái.

Đổi "động cơ" (model), "chế độ lái" (Ask/Edit/Agent) và "nơi chạy" (Session Target: Local/Copilot/Cloud). Model là bộ não trả lời — mạnh thì nhanh thông minh nhưng đắt; mode là mức quyền bạn giao — chỉ hỏi, được sửa, hay tự lo toàn bộ.

| Lệnh | Là gì (nôm na) | Chi tiết |
|---|---|---|
| `/model` | Đổi model giữa chat (mạnh/rẻ tùy task) | [model-picker](./commands/model-agent/model-picker/README.md) |
| `Ask mode` | Về Ask read-only: chỉ hỏi, không sửa | [ask-mode](./commands/model-agent/ask-mode/README.md) |
| `Edit mode` | Vào Edit với files bạn chọn | [edit-mode](./commands/model-agent/edit-mode/README.md) |
| `Agent mode` | Tự tìm file, sửa, chạy terminal | [agent-mode](./commands/model-agent/agent-mode/README.md) |
| `Custom agent` | Gọi custom agent trong `.github/agents/` | [custom-agent](./commands/model-agent/custom-agent/README.md) |
| `/usage` | Xem **AI Credits** đã dùng (link dashboard) | [premium-requests](./commands/model-agent/premium-requests/README.md) |
| `Coding agent` | Giao issue cho Copilot coding agent xử lý async | [coding-agent-assign](./commands/model-agent/coding-agent-assign/README.md) |
| `Coding agent PR` | Tóm tắt diff thành PR, review flow issue→PR | [coding-agent-pr](./commands/model-agent/coding-agent-pr/README.md) |
| `Policy approval` | Xem/duyệt policy, approve lệnh nhạy cảm | [policy-approval](./commands/model-agent/policy-approval/README.md) |
| `Session Target` | Chọn harness + nơi agent chạy: Local/Copilot/Cloud | [session-target](./commands/model-agent/session-target/README.md) |

> **Cách đọc bảng này:** cột 1 là lệnh để gõ/click, cột 2 nói nôm na lệnh đó làm gì, cột 3 dẫn tới trang chi tiết. Đọc cột 2 trước để chọn đúng lệnh.

> **Tóm gọn 1 câu:** nhóm này cho bạn đổi model (bộ não), đổi mode (mức quyền) và chọn nơi chạy — ba cái cần chốt trước khi giao việc lớn.

## 4. Nhóm 3 — Code actions (10)

Mục này là bộ lệnh làm việc nhanh trên một đoạn code đang chọn — như dao rọc giấy cho từng vết cắt nhỏ.

Các việc code ngắn gọn trên đoạn đang chọn: giải thích, sửa, sinh test, viết docs. Bôi đen code rồi gọi lệnh là xong, khỏi mô tả dài dòng.

| Lệnh | Là gì (nôm na) | Chi tiết |
|---|---|---|
| `/explain` | Giải thích code đang chọn | [explain](./commands/code-actions/explain/README.md) |
| `/fix` | Fix lỗi/selection đang chọn | [fix](./commands/code-actions/fix/README.md) |
| `/tests` | Sinh unit tests theo mẫu repo | [tests](./commands/code-actions/tests/README.md) |
| `/doc` | Sinh docstring/JSDoc cho hàm | [doc](./commands/code-actions/doc/README.md) |
| `/new` | Sinh code mới từ mô tả | [new](./commands/code-actions/new/README.md) |
| `/optimize` | Đề xuất tối ưu perf | [optimize](./commands/code-actions/optimize/README.md) |
| `/commit` | Gợi ý commit message từ staged diff | [commit-message](./commands/code-actions/commit-message/README.md) |
| `/pr` | Tóm tắt diff thành PR title + body | [pr-desc](./commands/code-actions/pr-desc/README.md) |
| `/refactor` | Refactor giữ nguyên behavior | [refactor](./commands/code-actions/refactor/README.md) |
| `@terminal` | Biến lỗi terminal thành task fix cho agent | [debug-terminal](./commands/code-actions/debug-terminal/README.md) |

> **Cách đọc bảng này:** mỗi dòng là một lệnh một việc — cột 1 để gõ, cột 2 là việc nó làm trên code đang chọn. Chọn đúng lệnh theo việc, đừng dùng `/agent` cho việc 1 dòng.

> **Tóm gọn 1 câu:** nhóm code actions là các lệnh nhỏ một việc trên code đang chọn — giải thích, fix, sinh test, viết docs, gợi ý commit.

## 5. Nhóm 4 — System & Knowledge (15)

Mục này về các lệnh xem/sửa "hậu trường" — thứ bạn ít dùng mỗi ngày nhưng cần khi Debug.

Lệnh xem/sửa "hậu trường": instructions đang load gì, MCP nào bật, account nào login. MCP nôm na là "ổ cắm" cho phép Copilot nối thêm công cụ bên ngoài — như cắm sạc vào ổ điện. Đi từ trên xuống: cấu hình tài khoản, cấu hình lệnh, đến nơi chặn truy cập.

| Lệnh | Là gì (nôm na) | Chi tiết |
|---|---|---|
| `/instructions` | Xem/sửa instructions đang load cho repo này | [instructions](./commands/system-knowledge/instructions/README.md) |
| `/prompts` | Liệt kê prompt files `.github/prompts/` (**legacy** — deprecated cho Agent Host; ưu tiên `/skills`, bài 05) | [prompt-file](./commands/system-knowledge/prompt-file/README.md) |
| `/skills` | Liệt kê Agent Skills `.github/skills/` khả dụng | [agent-skill](./commands/system-knowledge/agent-skill/README.md) |
| `/mcp` | Xem MCP servers/tools đang bật, reconnect khi rớt | [mcp](./commands/system-knowledge/mcp/README.md) |
| `MCP add` | Thêm MCP server mới vào cấu hình | [mcp-add](./commands/system-knowledge/mcp-add/README.md) |
| `/extensions` | Quản lý Copilot Extensions đã cài | [extensions](./commands/system-knowledge/extensions/README.md) |
| `Content exclusion` | Xem files Copilot không được đọc | [content-exclusion](./commands/system-knowledge/content-exclusion/README.md) |
| `Telemetry` | Xem/sửa code-telemetry consent | [telemetry](./commands/system-knowledge/telemetry/README.md) |
| `/status` | Xem trạng thái Copilot: active, account, model | [status](./commands/system-knowledge/status/README.md) |
| `/login` / `/logout` | Đăng nhập / đăng xuất GitHub account | [login](./commands/system-knowledge/login/README.md) |
| `/feedback` | Gửi feedback/bug về câu trả lời cho GitHub | [bug-feedback](./commands/system-knowledge/bug-feedback/README.md) |
| `Knowledge base` | Hỏi tri thức team (docs nội bộ, wiki, RAG) | [knowledge-base](./commands/system-knowledge/knowledge-base/README.md) |
| `gh suggest` / `gh explain` | Gợi ý / giải thích lệnh shell (`gh copilot suggest/explain`) | [cli-suggest](./commands/system-knowledge/cli-suggest/README.md) |

> **Cách đọc bảng này:** cột 1 là lệnh, cột 2 là việc nó làm. Nhóm này để kiểm tra "sao Copilot không như mình nghĩ" — xem account, cấu hình, hay chặn truy cập.

> **Tóm gọn 1 câu:** nhóm System & Knowledge là tủ điện của Copilot — xem cấu hình đang nạp gì, cắm thêm công cụ gì, và chặn gì không cho đọc.

---

## 6. Công thức 5 lệnh session đầu (làm 1 lần/repo)

Mục này là "nghi thức khai trương" cho mỗi repo mới — làm một lần để mọi buổi làm việc sau suôn sẻ. Giống kiểm tra máy trước khi lái xe đường dài.

```text
 /status → /instructions → /mcp → /customAgent → /policy
```

- `/status` — Copilot active? đúng account? đúng model? Sai account = sai quota/policy cả buổi. Như bật nhầm SIM roam thì cả cuộc gọi đều tốn tiền nhầm.
- `/instructions` — xem instructions đang load, bật `useInstructionFiles` nếu chưa, cắt file <200 dòng (bài 03).
- `/mcp` — thêm GitHub (+ DB nếu có), test "liệt kê 5 PRs mở gần nhất".
- `/customAgent` — tạo 2 agents: `explorer` (read-only) và `reviewer` (chỉ comment), bài 06.
- `/policy` — xem org policy + `content-exclusion` (files Copilot không được đọc), test 1 task nhỏ end-to-end.

> **Tóm gọn 1 câu:** mở repo mới thì chạy đủ 5 lệnh `/status → /instructions → /mcp → /customAgent → /policy` một lần để mọi buổi sau khỏi bắt lỗi từ đầu.

---

## 7. Lưu ý plan/model gating (AI Credits)

Mục này giúp bạn tự xử lý khi lệnh hay model "biến mất" — thay vì kết luận vội Copilot hỏng. Gating nghĩa là một số lệnh bị "khoá theo gói" — giống gói cước điện thoại: tính năng này gói cao mới có.

Lệnh hoặc model không hiện trong list thì kiểm tra dưới đây trước khi kết luận "Copilot hỏng":

- Billing hiện tại là **AI Credits** (usage-based từ 01/06/2026, 1 credit = $0.01, trừ theo model × số token). Thuật ngữ cũ "premium requests" là **legacy** — tài liệu nào còn dạy theo premium requests là tài liệu cũ. Code completions không trừ credits.
- Không thấy lệnh nào → check `/status` + plan trước khi kết luận lệnh không tồn tại.
- Model mạnh (GPT-5.2-Codex, Claude) tốn nhiều credits hơn model rẻ. Hết credits → `/model` đổi sang model rẻ thay vì dừng việc.
- BYOK (Enterprise): org dùng key/model riêng → list model trong `/model` khác Individual.
- Model availability theo plan: Individual < Business < Enterprise (mở dần). Coding agent + một số participants (`@github` full) có thể vắng mặt ở plan thấp.

```text
# Flow debug 30 giay khi lenh vang mat:
# 1. /status -> account + model hien tai la gi?
# 2. github.com/settings/copilot -> plan + quota con khong?
# 3. Go / trong input -> list thuc te o may ban co lenh do khong?
# 4. Khong co -> plan gating hoac extension cu -> /update.
```

---

## 8. Walkthrough + ví dụ copy-paste

Mục này là bài thực hành có sẵn kịch bản — đọc theo đúng thứ tự bước là chạy được luôn, khỏi tự nghĩ prompt.

### 8.1. Flow Ask → Edit → Agent bằng commands (10 phút)

```text
# Buoc 1 — Ask (hieu truoc, khong sua):
@workspace @file:package.json repo nay chay dev/test/lint bang lenh nao?

# Buoc 2 — /explain + /fix tren selection (sua nho):
# Chon 1 ham -> /explain -> doc -> /fix "them null check cho params".

# Buoc 3 — /tests (viec nha):
# Chon file source -> /tests "viet theo mau login.test.ts" -> chay test verify.

# Buoc 4 — /agent (task mo):
/agent Trong apps/api, POST /orders crash khi thieu customerId.
Tim root cause, fix, them regression test, chay npm test xac nhan.
```

### 8.2. Git flow bằng commands

```text
/diff       # xem diff, duyet tung hunk
/review     # "tim bug + security, chi bao loi that, khong nitpick style"
/commit     # stage files -> duyet message truoc khi commit
/pr         # push branch -> tao title + body + checklist test da chay
```

```text
# Ket hop @terminal — bien loi terminal thanh task cho agent:
# Buoc 1: chay test trong VS Code terminal, copy loi.
# Buoc 2: trong Chat:
@terminal Giai thich 3 loi dau bang tieng Viet, moi loi 2 cau.
/agent Fix 3 loi tren, chay lai test xac nhan, khong sua gi ngoai scope.

# Ket hop /fetch — dua docs moi nhat vao context (chong hallucinate API):
/fetch https://docs.github.com/en/copilot/reference
# Sau do hoi: "Theo docs vua doc, lenh nao thay the /X cu?"
```

> Tương đương terminal khi không mở IDE: `gh copilot suggest "viet commit message conventional commits cho diff hien tai"`.

> Tương đương terminal khi không mở IDE: `gh copilot suggest "viet commit message conventional commits cho diff hien tai"`.

> **Tóm gọn 1 câu:** phần walkthrough là kịch bản copy-paste chạy được — làm đúng thứ tự Ask → Edit → Agent và cả flow git là nắm hết các lệnh chính.

---

## 9. Hiểu nhầm thường gặp + pitfalls

Mục này "tiêm phòng trước" — liệt kê những cách hiểu sai phổ biến để bạn đỡ mất tiền học qua lần sai của mình.

| Hiểu nhầm | Sự thật | Ví dụ |
|---|---|---|
| "`/` `@` `#` là 1, dùng cái nào cũng được" | `/` chạy workflow, `@` chọn nguồn tri thức, `#` gắn file cụ thể | `/fix` + `#selection` + `@workspace` là 3 việc khác nhau, hay đi cùng nhau |
| "Gõ tự nhiên dài là tốt nhất" | Prompt dài không scope tốn 3–5 turns làm rõ | Thêm `#file`/`@workspace` ngay turn 1 rẻ hơn nhiều |
| "Ask không sửa được là bug" | Ask cố tình read-only để hỏi an toàn | Muốn sửa → `/edit` hoặc Agent mode |
| "Lệnh vắng mặt là Copilot hỏng" | Thường do plan gating hoặc extension cũ | Check `/status` + plan + gõ `/` xem list thực tế |
| "Dùng `/agent` cho việc 1 dòng" | Agent đi đọc cả chục file — đốt credits vô ích | Việc nhỏ → `/fix`/`/explain` rẻ hơn |
| "Tin `/commit`/`/pr` 100% không đọc" | Nó chỉ sinh nháp | Luôn đọc + sửa message trước khi commit/push |

> **Cách đọc bảng này:** cột 1 là điều nhiều người tin (nhưng sai), cột 2 là sự thật, cột 3 là ví dụ cụ thể. Dò cột 1 xem bạn đang tin nhầm điều nào.

```text
❌ SAI: "sua loi login dum tao" → agent tự đoán file, tốn 3–5 turns hỏi lại
✅ ĐÚNG: #file:src/routes/login.ts #selection Them null check cho customerId, giu nguyen API shape

❌ SAI: (Ask mode) "Sửa bug login giúp" → chỉ trả lời chữ, không đụng file
✅ ĐÚNG: chuyển /edit (hoặc /agent) rồi mới giao việc sửa

❌ SAI: chạy /commit rồi commit luôn message nó gợi ý
✅ ĐÚNG: đọc + sửa message trước khi commit/push — bạn vẫn là người duyệt cuối
```

**Best practices:** gắn scope ngay turn 1 · chọn lệnh theo cỡ việc (1 dòng → `/fix`, việc mở → `/agent`) · `/new` mỗi task · model rẻ cho `/explain`/`/review`, model mạnh cho `/agent` khó · session đầu chạy `/status → /instructions → /mcp` (corp thêm `/policy` → `/exclusion`).

> **Tóm gọn 1 câu:** hầu hết "Copilot dở" thực ra là hiểu nhầm về ký hiệu, mode và gói dịch vụ — tra bảng này trước khi đổ lỗi cho công cụ.

---

## 10. So sánh với Claude Code

Mục này cho ai dùng cả hai công cụ: biết lệnh bên này tương ứng bên kia cái nào, khỏi học lại từ đầu.

| Việc | Copilot | Claude Code | Ghi chú |
|---|---|---|---|
| Gọi lệnh có sẵn | Slash command built-in (`/fix`, `/tests`, `/explain`...) | Slash command built-in + tự tạo trong `.claude/commands/` | Cùng ý tưởng `/`; tên và số lệnh khác nhau |
| Chọn nguồn tri thức | `@workspace`, `@terminal`, `@github` | Không có `@participant` — agent tự quét repo | Copilot có kênh `@` tường minh |
| Gắn file/vùng chọn | `#file`, `#selection`, `#editor` | `@file` mention; không có `#selection` | Copilot gắn được vùng đang bôi đen |
| Quản lý phiên | `/new`, `/clear`, `/history`, `/export`, `/resume` | `/clear` + `--resume`/`--continue` | Cả hai đều có mở/xóa/resume phiên |
| Đổi model giữa phiên | `/model` (GPT/Claude/Gemini) | `/model` (gói Anthropic) | Cùng tên lệnh, khác tập model |
| Kiểm tra hệ thống | `/status`, `/mcp`, `/instructions` | `/status`, `/mcp`, `/doctor` | Cùng mục đích debug |

> **Cách đọc bảng này:** mỗi hàng là một việc cần làm; đọc cột Copilot và Claude Code để thấy lệnh tương ứng, cột Ghi chú nêu điểm khác tinh tế đừng bỏ sót.

---

## Bài tập nhỏ

Bốn bài dưới đây dùng repo thật — làm tay một lần thì nhớ lâu hơn đọc mười lần.

1. **(15 phút) Scope drill:** cùng 1 task, chạy 2 lần: không `@`/`#` vs có `@workspace` + `#file`. So sánh số turns + độ đúng, ghi vào team wiki.
2. **(15 phút) Commands tour:** chạy tuần tự `/status → /instructions → /mcp → /agents → /policy → /usage` trên repo thật. Chụp (che secrets) + giải thích mỗi output 1 câu.
3. **(20 phút) Git flow:** trên branch test, chạy `/diff → /review → /commit → /pr`. Liệt kê lệnh nào đúng ngay, lệnh nào phải sửa tay.
4. **(15 phút) Gating check:** mở `/model` liệt kê models khả dụng ở plan bạn. Ghi bảng: model nào tốn AI Credits cao nhất (ước lượng từ dashboard `github.com/settings/copilot`).

> **Tóm gọn 1 câu:** làm đủ 4 bài trên repo thật để scope, lệnh hệ thống, git flow và kiểm tra gói dịch vụ thành tay nghề.

---

## Link chéo

Mục này nối sang các bài cùng chuỗi — đọc theo nhu cầu, không cần theo thứ tự.

- **Bài 00 — Tổng quan**: 4 họ tools đằng sau mỗi command.
- **Bài 01 — Cài đặt**: `/login`, `/status` khi setup báo đỏ.
- **Bài 03 — Instructions**: `/instructions` + `applyTo` — file đằng sau commands.
- **Bài 05 — Agent Skills**: `SKILL.md` (chuẩn 2026) + port prompt files legacy.
- **Bài 07 — Policies**: `policy-approval`, `content-exclusion`, model gating chi tiết.

## Reference

Tài liệu gốc chính thống — tra tại đây khi bài viết và bản mới nhất của GitHub lệch nhau.

- GitHub Copilot docs: https://docs.github.com/copilot
- VS Code Copilot docs: https://code.visualstudio.com/docs/copilot
- Billing / AI Credits: https://github.com/settings/copilot

> **Chốt bài 04:** ba ký hiệu `/`, `@`, `#` là ngữ pháp của Copilot Chat — nắm ngữ pháp này thì prompt đầu tiên đã đúng scope, và bạn thôi trả tiền cho những turn "file nào nhỉ?".
