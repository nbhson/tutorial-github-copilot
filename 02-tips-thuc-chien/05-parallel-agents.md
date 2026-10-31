# Tips 05 — Parallel Agents: Chạy Song Song Multi-Chat, Coding Agent, Worktrees

> **Dành cho:** dev đã quen 1 chat 1 việc và đang chờ Copilot tuần tự từng module.
> **Vấn đề:** research 3 modules tuần tự mất 60 phút trong khi song song chỉ tốn 30 — nhưng song song sai cách vừa conflict vừa đốt AI Credits.
> **Đọc xong:** chọn đúng 1 trong 4 kiểu song song, biết khi nào không nên song song, có recipes copy-paste.
> **Thời gian:** ~20 phút đọc + ~60 phút làm bài tập.

## 1. Vì sao phải song song?

Làm tuần tự với Copilot rất phí: research auth 20p → payments 20p → cart 20p = 60 phút; fan-out 3 chats cùng lúc → 20 phút xong cả 3. Chờ Coding Agent xong issue A mới giao issue B là mất 2× thời gian chờ.

Lưu ý quan trọng: Copilot song song miễn phí về *thời gian của bạn*, nhưng **không** miễn phí về AI Credits — nhiều session = nhiều lượt gọi model cùng lúc. Kiểm tra usage trước khi fan-out (xem [Tips 08](./08-tiet-kiem-premium-requests.md)).

```text
Việc độc lập -> song song.
Việc phụ thuộc (B cần kết quả A) -> tuần tự.
Việc cùng files -> không song song (sẽ conflict).
```

> Rule: **song song theo module/files, không song song trên cùng 1 file.**

## 2. Cơ chế: 4 kiểu song song

| Kiểu | Cô lập gì | Tốn gì | Khi dùng |
|---|---|---|---|
| Multi-chat | Context mỗi chat | Thêm AI Credits | Research, plan 2 phương án |
| Coding Agent sessions | Branch + CI riêng | Thêm minutes + AI Credits | 2–3 issues độc lập |
| Worktrees | Thư mục + branch riêng | Disk + setup | Song song code local nặng |
| Custom agents | Vai (Planner/Reviewer/Tester) | Overhead nhỏ | Chia vai trong 1 task |

Mỗi kiểu cô lập một thứ khác nhau — chọn đúng kiểu là hết conflict mà không cần dọn dẹp. Dùng multi-chat cho việc sửa code local nặng → 2 chat cùng ghi 1 working tree, file đè nhau; dùng worktree chỉ để research → setup nặng mà chẳng được gì.

> Lưu ý 2026: ngoài 4 kiểu trên, Copilot SDK (public preview) cho phép dàn dựng dynamic workflows đa-agent bằng code — xem bài Copilot SDK trong nhóm 01.

Sơ đồ fan-out chuẩn:

```text
[Plan duyệt] --fan-out--> [Chat A: auth] [Chat B: payments] [Chat C: cart]
             --gộp-->     [Chat chính: gộp + verify + review]
```

## 3. Kiểu 1: multi-chat song song (nhanh nhất)

Không cần setup. Mở 2–3 chats VS Code (hoặc github.com + VS Code) cùng lúc.

**Ví dụ 1 — Research 3 modules (copy-paste):**

```text
Chat A: "@workspace Chỉ trong src/auth/*.ts: flow login 5 bullet + file:line. Không sửa. Ghi ra docs/research-auth.md"
Chat B: "@workspace Chỉ trong src/payments/*.ts: flow refund 5 bullet + file:line. Không sửa. Ghi ra docs/research-payments.md"
Chat C: "@workspace Chỉ trong src/cart/*.ts: flow voucher 5 bullet + file:line. Không sửa. Ghi ra docs/research-cart.md"
```

Rồi mở chat chính thứ 4:

```text
Đọc docs/research-auth.md + research-payments.md + research-cart.md.
Gộp thành plan 3 phases, mỗi phase 1 module, verify từng phase. Chờ duyệt.
```

**Ví dụ 2 — Thử 2 phương án:**

```text
Chat A (đơn giản): "Đề xuất fix bug voucher bằng if-guard tối thiểu, 3 steps, không đổi API."
Chat B (refactor): "Đề xuất tách voucher thành module riêng, 5 steps, giữ API, kèm risks."
Chat chính: "So 2 phương án trong 2 files, chọn 1 theo tiêu chí: ít rủi ro + test dễ xanh nhất."
```

**Ví dụ 3 — Hỏi phụ không block mạch chính:** đang implement mà thắc mắc → mở chat phụ Ask: `"Giải thích hàm retryWithBackoff trong #file:src/payments/retry.ts, 3 bullet. Không sửa."` Chat chính không bị bẩn.

## 4. Kiểu 2: multi Coding Agent sessions

Dùng khi có 2–3 issues độc lập, spec rõ, khác modules.

**Giao 2 issues song song:**

```text
Issue #101 (auth): fix normalizeEmail dau, scope src/auth/**, done = npm test -- auth xanh.
Issue #102 (cart): fix total voucher 0d, scope src/cart/**, done = npm test -- cart xanh.
```

Assign cả 2 cho Copilot cùng lúc — mỗi session tự tạo branch riêng (`copilot/fix-101`, `copilot/fix-102`), chạy CI riêng, mở PR draft riêng. Bạn chỉ việc review 2 PRs.

**Prompt giao để không conflict (câu này bắt buộc):**

```text
@copilot Implement issue #101.
TUYỆT ĐỐI chỉ sửa trong src/auth/**.
Không đụng src/cart/** (đang có session khác làm).
Mở PR draft, dán log test xanh vào mô tả.
```

**Checklist giám sát sessions:**

```text
- [ ] Mỗi session 1 issue + 1 scope không giao nhau?
- [ ] Mỗi PR có log xanh + diff --stat đúng scope?
- [ ] Session nào đỏ sau 3 lần -> dừng, comment blocker?
- [ ] Merge tuần tự, chạy full test sau mỗi merge?
```

> Lưu ý 2026: chạy được 2–3 sessions trong terminal bằng Copilot CLI (binary `copilot`, xoay Interactive/Plan/Autopilot bằng `Shift+Tab`, giới hạn credits bằng `/limits`). Xem [Tips 11](./11-nang-cao-cli-web-coding-agent.md).

## 5. Kiểu 3: worktrees cô lập

Khi muốn chạy 2 Agents local cùng lúc mà không conflict files:

```bash
# Tạo 2 worktrees từ main
git worktree add ../proj-auth feature/auth-fix
git worktree add ../proj-cart feature/cart-fix

# Mở mỗi worktree 1 cửa sổ VS Code riêng
code ../proj-auth
code ../proj-cart
```

Chạy song song: mỗi VS Code gắn prompt riêng — `"Đọc plan.md Phase auth. Chỉ làm trong worktree này. Chạy npm test -- auth, dán log."`

**Gộp sau khi cả 2 xanh (copy-paste lệnh):**

```bash
git checkout main
git merge feature/auth-fix --no-ff -m "merge: auth fix (verified)"
npm test -- auth
git merge feature/cart-fix --no-ff -m "merge: cart fix (verified)"
npm test
git worktree remove ../proj-auth
git worktree remove ../proj-cart
```

**Khi nào KHÔNG cần worktrees:** chỉ research/hỏi (multi-chat là đủ); task <30 phút (1 Agent nhanh hơn setup); máy yếu (dùng Coding Agent cloud thay).

## 6. Kiểu 4: custom agents fan-out

Chia 1 task thành vai: Planner lập plan, Tester viết test, Reviewer soi (tạo `.github/agents/*.md` — xem [Tips 09](./09-teamwork-chuan-hoa.md)):

```text
@Planner Đọc src/payments/ + docs/payment-spec.md, trình plan 3 phases, chờ duyệt.
# Duyệt xong:
@Tester Viết regression tests cho Phase 2 theo plan.md, chạy npm test -- payments, dán log.
# Code xong:
@Reviewer Review diff vs plan.md, [SEVERITY] file:line, verdict PASS/NEEDS-FIX.
```

**Output contract để gộp rẻ (quy định trước khi chạy):**

```text
Mỗi agent nhánh chỉ trả về:
1. Quyết định (3 bullet)
2. Evidence (file:line + log xanh)
3. Blocker (nếu có, 1 dòng)
Không dump log dài, không paste code nguyên file.
```

> Cấm: 2 Implementers cùng sửa 1 file. Luôn chia files không giao nhau.

## 7. Walkthrough: research 3 modules trong 30 phút

| Phút | Việc | Prompt |
|---|---|---|
| 0–2 | Mở 3 chats | Mỗi chat 1 module (ví dụ 1 mục 3) |
| 2–20 | Chạy song song | 3 chats research, mỗi chat ghi ra docs/research-*.md |
| 20–25 | Chat chính thứ 4 | `"Đọc 3 files research-*.md, gộp thành table Module / Flow / Risks."` |
| 25–30 | Lập plan | `"Từ table trên, trình plan 3 phases + verify từng phase, chờ duyệt."` |

Tuần tự mất 60 phút, song song mất 30 phút với chất lượng tương đương (modules độc lập). Nếu có 2 issues độc lập: phút 30 assign 2 Coding Agent sessions, quay lại review 2 PR drafts.

## 8. Bảng tra nhanh: chọn kiểu nào?

| Tình huống | Kiểu đúng | Giới hạn gợi ý |
|---|---|---|
| Research 2–4 modules độc lập | Multi-chat | 3 chats + 1 chat gộp |
| Thử 2 hướng fix | 2 chats plan | Chat chính chọn 1 |
| 2–3 issues độc lập, khác scope | Multi Coding Agent | 2–3 sessions, scope không giao |
| Code local nặng, sợ conflict | Worktrees | 2 worktrees, merge tuần tự |
| 1 task cần plan/test/review | Custom agents | 3 vai: Planner/Tester/Reviewer |
| Hỏi phụ khi đang implement | Chat phụ Ask | 1 chat phụ, không block chính |
| Cùng 1 file, cùng hàm | **KHÔNG song song** | Tuần tự, 1 agent 1 lúc |

> Quy tắc ngón tay: **độc lập + khác files → song song. Phụ thuộc hoặc cùng file → tuần tự.**

### Before / After

**Before (song song ẩu — cùng file):** Chat A "Fix login" + Chat B "Thêm tính năng login" → 2 PRs conflict, mất code, merge conflict 20 chỗ.

**After (chuẩn — khác scope + gộp):** Chat A sửa `src/auth/**`, Chat B sửa `src/payments/**`, mỗi bên ghi research-*.md → chat chính gộp thành plan. 20 phút xong cả 2, 0 conflict.

## 9. Pitfalls + cách fix

| Pitfall | Triệu chứng | Fix |
|---|---|---|
| 2 agents cùng sửa 1 file | Conflict, mất code | Chia scope không giao nhau ngay trong prompt |
| Fan-out 5 chats không gộp | 5 findings rời rạc | Luôn có chat chính gộp + plan duyệt |
| Nhánh dump log 200 dòng | Chat chính phình | Output contract: 3 bullet + evidence |
| Giao 2 Coding Agents cùng scope | 2 PRs conflict nhau | Mỗi issue 1 scope, dặn KHÔNG đụng scope kia |
| Merge 2 nhánh cùng lúc | Main đỏ không biết do ai | Merge tuần tự, full test sau mỗi merge |
| Worktrees quên cleanup | Disk đầy, branch rác | Remove worktree + xóa branch sau merge |
| Song song task phụ thuộc | B làm sai vì A chưa xong | Vẽ dependency trước: B cần A → tuần tự |
| Quá nhiều sessions | Tốn credits, review không xuể | Tối đa 2–3 song song, review xong mới fan-out tiếp |
| Không save findings ra file | Chat gộp quên hết | Mỗi nhánh ghi ra docs/research-*.md |

## 10. So sánh với Claude Code

| Việc | Copilot | Claude Code | Ghi chú |
|---|---|---|---|
| Nhiều phiên song song | Nhiều chat VS Code / github.com | Nhiều terminal/phiên | Cùng tư tưởng: mỗi phiên 1 việc |
| Cô lập nhánh local | Worktrees | `git worktree` tương tự | Đều là thủ thuật git chung |
| Giao việc async cloud | Coding Agent assign issue → PR draft | Async qua GitHub Actions/cloud | Mô hình async khác nhau |
| Chia vai | Custom agents (`.github/agents/*.md`) | Subagents `.claude/agents/` | Cùng ý tưởng chia vai |
| Workflow đa-agent bằng code | Copilot SDK (public preview) | Agent SDK / orchestration ngoài | Cả hai cho lập trình hoá fan-out |

## 11. Bài tập cuối bài

**Bài 1 (15 phút):** Chọn 2 modules độc lập trong repo, mở 2 chats research hẹp + ghi ra file, mở chat thứ 3 gộp thành table + plan. So thời gian vs tuần tự.

**Bài 2 (30 phút):** Tạo 2 worktrees cho 2 branch fix khác scope, chạy 2 Agents song song mỗi bên dán log xanh, merge tuần tự về main, full test, cleanup worktrees.

**Bài 3 (20 phút):** Tạo 1 Planner + 1 Reviewer theo mục 6. Cho Planner lập plan 1 feature thật (bạn duyệt), cho Reviewer soi diff cũ và so findings với review người.

> Đạt: sau 1 tháng, mọi research >2 modules của bạn đều fan-out, không còn research tuần tự.

## Tham khảo chéo

- [Tips 01](./01-context-hygiene.md) — chat chính gọn, nhánh chỉ trả summary
- [Tips 03](./03-plan-first-workflow.md) — có plan duyệt mới fan-out implement
- [Tips 04](./04-verification-done-that.md) — mỗi nhánh đều phải dán log xanh
- [Tips 08](./08-tiet-kiem-premium-requests.md) — fan-out tốn AI Credits, khi nào đáng?
- [Tips 11](./11-nang-cao-cli-web-coding-agent.md) — Coding Agent sessions + Copilot CLI

> **Chốt Tips 05:** fan-out chỉ đáng khi có fan-in — chia việc theo files tách rời, rồi luôn có một chat chính gộp lại.
