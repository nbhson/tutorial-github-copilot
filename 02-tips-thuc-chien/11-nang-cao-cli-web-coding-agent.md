# Tips 11 — Nâng Cao: Copilot CLI, Web, Coding Agent, Mobile & Voice

> **Dành cho:** dev muốn làm việc ngoài VS Code — terminal, web, điện thoại, khi đang đi đường.
> **Vấn đề:** chỉ biết mỗi VS Code nên rời máy là "tê liệt", hoặc nhầm `gh copilot` với `copilot`.
> **Đọc xong:** dùng được 5 mặt của Copilot, giao việc cho Coding Agent qua cloud, review/duyệt trên web + mobile.
> **Thời gian:** ~20 phút đọc + ~50 phút làm bài tập.

## 1. Vì sao phải ra khỏi VS Code?

- Đang đi đường, prod đỏ → cần xem issue + giao Coding Agent từ điện thoại.
- Review PR trên github.com → muốn hỏi `@copilot` ngay trong PR, không cần pull về.
- Sống trong terminal (ssh, server) → muốn CLI gợi ý lệnh + giải thích lỗi ngay.
- Họp, tay bận → muốn voice ra lệnh, Copilot tóm tắt + tạo issue.

> Rule: **nặng thì VS Code Agent, nhanh thì CLI/web, xa máy thì mobile + Coding Agent cloud.**

Cố code nặng (refactor, debug sâu) trên điện thoại là vừa chậm vừa dễ sai — việc đó thuộc về nơi có đủ công cụ verify.

## 2. Cơ chế: 5 mặt của Copilot

| Mặt | Ở đâu | Mạnh nhất | Yếu nhất |
|---|---|---|---|
| VS Code | Desktop IDE | Edit/Agent multi-files, debug sâu | Phải ngồi máy |
| CLI | Terminal (`gh copilot` + `copilot`) | `gh copilot`: suggest/explain lệnh shell; `copilot`: agent 3 chế độ | Không thay VS Code debug sâu |
| Web (github.com) | Repo/issues/PRs | Hỏi code, review PR, assign agent | Không chạy local |
| Coding Agent | Cloud sessions | Làm 1–2h bất đồng bộ, mở PR | Đắt, cần spec rõ |
| Mobile/dev/voice | App, github.dev, voice | Xem, giao việc, duyệt nhanh | Không code nặng |

```text
[Mobile: đọc issue, giao agent] → [Cloud: agent code + CI] → [Web: review PR]
→ [VS Code/CLI: fix nhỏ + verify local] → [Mobile: duyệt merge]
```

## 3. CLI trong terminal: 2 CLI khác nhau, đừng nhầm

> - **`gh copilot`** (gh extension) — trợ lý lệnh shell: `suggest`/`explain`, không sửa code.
> - **`copilot`** (Copilot CLI, binary riêng) — agent chạy cả task trong terminal, xoay 3 chế độ **standard → plan → autopilot** bằng `Shift+Tab`.

### 3.1. `gh copilot` — hỏi lệnh, giải thích lỗi

```bash
gh extension install github/gh-copilot
gh copilot --help
```

**Gợi ý lệnh:**

```bash
gh copilot suggest "tìm 5 files TS lớn nhất trong src, sắp xếp giảm dần"
# → gợi ý: find src -name "*.ts" -exec wc -l {} + | sort -rn | head -5
# Chọn: Run / Revise / Cancel
```

**Giải thích lỗi:**

```bash
npm test -- payments 2>&1 | tail -30
gh copilot explain "TypeError normalizeEmail ở src/auth/login.ts:42"
# → 3 bullet nguyên nhân + gợi ý fix 1 file
```

Mẹo CLI: mọi gợi ý nguy hiểm (`rm`, `reset --hard`, `push --force`) → Revise/Cancel, không Run mù. Alias hay dùng: `alias gcs='gh copilot suggest'` + `alias gce='gh copilot explain'`.

### 3.2. `copilot` — CLI agent đầy đủ

```bash
# Cài: npm install -g @github/copilot (yêu cầu Node 22+)
# Đăng nhập lần đầu: /login

copilot                        # Interactive: hỏi từng tool (Shift+Tab xoay chế độ)
copilot --plan "refactor auth" # Plan trước, duyệt rồi mới code
copilot -p "fix test đỏ ở packages/api, chỉ 2 files"   # Non-interactive, xong là exit
copilot --plan --mode autopilot "task có plan rõ"      # Plan-then-autopilot
```

Trong phiên: `Shift+Tab` xoay standard → plan → autopilot; `/permissions` cấu hình quyền; `/limits` xem/đổi giới hạn AI credits; `@file` gắn file vào prompt. Autopilot tự chạy tới xong — vẫn tốn AI Credits.

| Việc | Dùng |
|---|---|
| Quên lệnh shell, explain lỗi tức thì | `gh copilot suggest/explain` |
| Task 1–2h, agent tự chạy cả đoạn | `copilot --plan` / autopilot |
| Chỉ Edit 1–2 files, muốn duyệt từng tool | `copilot` (Interactive) |

Nhầm 2 CLI là lỗi phổ biến nhất: muốn agent làm cả task lại gõ `gh copilot` (chỉ suggest/explain), muốn hỏi lệnh nhanh lại mở `copilot` (khởi động agent cả đoạn) — vừa chậm vừa tốn.

## 4. github.com chat + Coding Agent

**Hỏi ngay trên web** — bấm Copilot chat hoặc gõ `@copilot` trong comment trên repo/issue/PR:

```text
@copilot Trong PR này, flow refund thay đổi gì so với main?
Trả về 5 bullet + file:line + 2 rủi ro lớn nhất.
```

```text
@copilot Review diff PR này với issue #101.
Finding = bug/correctness/security/test-gap, bỏ qua style.
[SEVERITY] file:line — mô tả — gợi ý fix. Verdict PASS/NEEDS-FIX.
```

**Assign Coding Agent cho issue (copy-paste):**

```markdown
## Mục tiêu
Thêm POST /api/payments/refund theo docs/payment-spec.md section 3.

## Scope
- Chỉ src/payments/refund.ts + test.
- Không đụng src/generated/, schema.

## Done
- [ ] npm test -- payments xanh (log trong PR)
- [ ] lint + build xanh
- [ ] PR draft + diff --stat chỉ chạm scope
```

Assign: Issue → Assignees → Copilot → nó tự tạo branch `copilot/issue-123` + PR draft + CI. Theo dõi: agent comment tiến độ vào issue; test đỏ 3 lần → dừng + comment blocker; bạn review PR draft trên web, comment `@copilot sửa finding HIGH ở file X` → nó push tiếp.

```text
GIAO:         spec rõ + scope 1 module + done checklist + việc 1–2h độc lập.
KHÔNG GIAO:   spec mờ, đụng nhiều team, task 15 phút Edit xong.
```

Giao issue một dòng "fix refund" là agent tự đoán mọi thứ — PR về sai hướng, mất thêm thời gian gỡ. Plan-first xem [Tips 03](./03-plan-first-workflow.md), gates xem [Tips 06](./06-policies-guardrails-recipes.md).

## 5. Mobile, github.dev & voice

**Mobile (GitHub app):** đọc issue/PR, xem CI, duyệt merge, assign Copilot, comment `@copilot` hỏi/sửa nhỏ.

```text
# Giao việc từ quán cà phê (comment):
@copilot Implement issue này theo mô tả + plan.md trong branch plan/refund.
Chỉ sửa src/payments/. Mở PR draft, dán log test xanh vào mô tả.
```

**github.dev (VS Code trên trình duyệt):** mở `github.dev/<org>/<repo>` → sửa nhỏ, review, commit khi mượn máy: `"Sửa chính tả, giữ format. Không đụng logic."` → commit + PR, CI chạy cloud.

**Voice:** nói → thành prompt text (mobile / VS Code). Hợp khi họp, tay bận, accessibility: `"Tạo issue fix bug refund quá 30 ngày bị 500, scope payments, done là test xanh."` Mẹo: nói ngắn, 1 việc 1 lệnh, kiểm tra text trước khi gửi (voice hay nghe nhầm tên file).

Hai bẫy khi rời máy chính: voice nghe nhầm tên file → sửa nhầm chỗ; github.dev trên máy mượn mà mở `.env` → rò secret.

## 6. Recipes leo thang đa mặt trận

**A — Prod đỏ khi đang đi đường:**

```text
1. Mobile: đọc issue prod + CI log đỏ (5 phút).
2. Mobile: comment @copilot tóm tắt giả thuyết root cause 3 bullet (không fix vội nếu chưa rõ).
3. Rõ + scope nhỏ: assign Coding Agent, nó mở PR draft.
4. Về máy: VS Code pull branch agent, full test local, review fresh.
5. Web: merge khi CI xanh + review PASS.
```

**B — Review PR khi không có máy:**

```text
1. Web: đọc diff + Copilot review tự động.
2. Comment: `@copilot Review diff vs issue #X, [SEVERITY] file:line, PASS/NEEDS-FIX.`
3. NEEDS-FIX: `@copilot sửa 2 HIGH ở file A, B, push tiếp, dán log.`
4. Mobile duyệt merge khi CI xanh (branch protection đã bật).
```

**C — Terminal-first cho devops:**

```bash
# Trên server/ssh, không có VS Code:
gh copilot suggest "backup DB trước migrate, ghi log ra /tmp/backup.log"
gh copilot explain "lỗi migrate ở step 3 trong /tmp/migrate.log"
# Migrate xong: gh pr create --draft, về VS Code review kỹ.
```

## 7. Walkthrough: từ issue tới PR khi đang đi đường

Bối cảnh: 8h sáng trên xe, issue #123 bug refund, 10h tới công ty.

| Phút | Ở đâu | Việc |
|---|---|---|
| 0–5 | Mobile | Đọc issue + spec, xác nhận scope + done checklist rõ chưa? Mờ → hỏi spec trước, chưa giao |
| 5–8 | Mobile | Assign Copilot: `"Implement theo mô tả, chỉ src/payments/, PR draft + log xanh."` |
| 8–40 | Cloud | Agent tự code + CI (nhận notification tiến độ) |
| 40–50 | Web | Đọc PR draft: diff --stat đúng scope? log xanh? Comment `@copilot sửa HIGH` nếu có |
| 50–70 | VS Code | Pull branch, chạy `npm test -- payments` + lint + build local, Reviewer fresh `/team-review` |
| 70–75 | Web | Merge khi V4 đủ (CI xanh + 2 reviews), đóng issue |

Tổng bạn thao tác ~25 phút rải rác; agent làm 30 phút cloud; merge có đủ V4.

## 8. Bảng tra nhanh: ở đâu làm gì?

| Bạn đang ở | Dùng | Làm được | Không nên |
|---|---|---|---|
| VS Code (ngồi máy) | Agent/Edit | Code nặng, debug, test local | — |
| Terminal/ssh | gh copilot | Gợi ý lệnh, explain, script | Sửa multi-files phức tạp |
| Terminal (agent) | copilot CLI | Task 1–2h, duyệt plan | Debug sâu hơn VS Code |
| github.com | Chat/@copilot | Hỏi code, review PR, giao agent | Chạy local, test nặng |
| Cloud | Coding Agent | Việc 1–2h độc lập, PR draft | Spec mờ, task 15 phút |
| Mobile | App | Đọc, giao, duyệt nhanh | Code, review sâu |
| Máy mượn | github.dev | Fix nhỏ, review | Setup nặng, secrets |
| Họp/tay bận | Voice | Tóm tắt, tạo issue | Prompt dài, tên file khó |

> Quy tắc ngón tay: **xa máy thì giao + duyệt, ngồi máy thì code + verify. Không cố code nặng trên điện thoại.**

### Before / After

**Before (ôm laptop + spec mờ):** issue viết 1 dòng "fix refund", assign agent ngay → 2h sau PR sai hướng, conflict scope, CI đỏ, mất thêm 1h sửa + revert.

**After:** mobile xác nhận scope + done checklist mới assign → cloud code + CI → web đọc diff-stat + log → về máy `gh pr checkout 123 && npm test -- payments && npm run lint && npm run build` → merge khi V4 đủ.

## 9. Pitfalls + cách fix

| Pitfall | Triệu chứng | Fix |
|---|---|---|
| Giao agent khi spec mờ | PR sai hướng, mất 2h cloud | Chỉ giao khi có plan duyệt + done checklist |
| Review PR trên điện thoại qua loa | Lọt HIGH bug | Mobile chỉ duyệt khi Copilot + /team-review PASS; merge lớn để về máy |
| Chạy lệnh CLI mù | Mất data (rm, reset) | Revise trước khi Run, blocklist lệnh nguy hiểm |
| Nhầm `gh copilot` vs `copilot` | Chậm + tốn | Mục 3.1 = gh ext (suggest/explain), 3.2 = copilot CLI (agent 3 chế độ) |
| Voice nghe nhầm tên file | Sửa nhầm file | Kiểm tra text sau voice, file quan trọng gõ tay |
| github.dev commit secret | Rò token máy mượn | Không mở .env máy lạ, dùng .env.example |
| 3 sessions cloud cùng scope | PRs conflict | Mỗi session 1 scope không giao (Tips 05) |
| Quên bật protection | Agent merge bừa | Require PR + checks + review (Tips 06) |
| Không theo dõi agent | Agent kẹt 2h không biết | Bật notification issue, check ~30p/lần, dừng khi blocker |

## 10. Bài tập cuối bài

**Bài 1 (15 phút):** Cài `gh copilot`, chạy 3 lệnh (suggest 1 lệnh find, explain 1 lỗi cũ, suggest 1 script). Tạo alias gcs/gce. Thử `copilot --help` + chạy 1 task `copilot --plan`. Thử Revise 1 gợi ý nguy hiểm → Cancel thay vì Run.

**Bài 2 (20 phút):** Viết 1 issue theo mẫu mục 4, hỏi `@copilot` 1 câu review trên PR cũ (so với review người), assign agent cho issue nhỏ và quan sát branch + PR draft + CI.

**Bài 3 (15 phút):** Trên điện thoại đọc 1 issue + PR draft, comment `@copilot` 1 câu. Mở github.dev sửa 1 typo. Thử 1 lệnh voice, kiểm tra text trước khi gửi.

> Đạt: làm được cả vòng issue → PR → merge không cần ngồi máy liên tục, guardrails vẫn giữ; phân biệt được `gh copilot` và `copilot`.

## Tham khảo chéo

- [Tips 03](./03-plan-first-workflow.md) — plan duyệt mới giao Coding Agent
- [Tips 05](./05-parallel-agents.md) — multi Coding Agent sessions
- [Tips 06](./06-policies-guardrails-recipes.md) — protection + approval cho cloud
- [Tips 09](./09-teamwork-chuan-hoa.md) — review workflow + mobile duyệt
- [Tips 10](./10-debugging-power-moves.md) — explain lỗi trên CLI/web
- [02 — Các bề mặt (CLI)](../01-huong-dan-su-dung/02-cac-be-mat-vscode-ide-web-cli.md) — cài đặt gh copilot
- [12 — Copilot SDK/CI](../01-huong-dan-su-dung/12-copilot-sdk-ci-cd-automation.md) — assign issue tự động

> **Chốt Tips 11:** Copilot không phải một app mà là một vòng tròn 5 mặt — xa máy thì giao cloud + duyệt nhẹ, ngồi máy thì code sâu + verify nặng. `gh copilot` chỉ đường, `copilot` lái cả chuyến, và spec rõ mới giao.
