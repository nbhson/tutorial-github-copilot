# 04 — Chat Commands Toàn Tập (Slash, Participants, Variables)

> Bài 04 là INDEX tra cứu 46 chat commands Copilot 2026. Mỗi lệnh có 1 folder riêng
> trong `commands/` (vd `commands/chat-session/new-chat/`), chứa README chi tiết: cú pháp,
> ví dụ, pitfalls, plan/model gating. Cách dùng: tìm nhóm → đọc mô tả 1 dòng →
> click link sang folder chi tiết. Thời gian: ~30 phút đọc + tra cứu dần.

## Mục lục

1. [Cách đọc index này + why phải học commands](#1-cách-đọc-index-này--why-phải-học-commands)
2. [Nhóm 1 — Chat session (18)](#nhóm-1--chat-session-18)
3. [Nhóm 2 — Model & Mode + Code (18)](#nhóm-2--model--mode--code-18)
4. [Nhóm 3 — Tri thức & Hệ thống (17)](#nhóm-3--tri-thức--hệ-thống-17)
5. [Nhóm 4 — Auth & Settings (17)](#nhóm-4--auth--settings-17)
6. [Công thức 5 lệnh session đầu](#6-công-thức-5-lệnh-session-đầu-giữ-nguyên-làm-1-lầnrepo)
7. [Lưu ý plan/model gating](#7-lưu-ý-planmodel-gating-premium-requests-byok)
8. [Walkthrough + ví dụ copy-paste](#8-walkthrough--ví-dụ-copy-paste)
9. [Pitfalls + bài tập](#9-pitfalls--bài-tập)
10. [Link chéo](#10-link-chéo)

---

## 1. Cách đọc index này + why phải học commands

- Mỗi dòng = 1 lệnh: `/lệnh` hoặc `@participant` hoặc `#variable` — 1 dòng mô tả — link tới `./commands/<slug>/README.md`.
- Tổng 46 mục, chia 4 nhóm: Chat session (12) · Model & Agent (9) · Code actions (10) · System & Knowledge (15).
- Gõ `/` (slash), `@` (participant), `#` (variable) trong Chat input để xem list
  khả dụng **ở môi trường của bạn** (khác plan/model/version sẽ khác).
- Nếu link nào 404 ở máy bạn (lệnh vắng mặt) → xem mục 7 (plan/model gating).

Vì sao học commands thay vì gõ tự nhiên mãi? Prompt tự nhiên linh hoạt nhưng tốn
tokens + thiếu determinism. Commands (`/`, `@`, `#`) là "đường tắt có kiểm chứng":
gắn đúng scope, đúng model, đúng tools ngay từ turn 1 — rẻ hơn 3–5 turns làm rõ.

---

## Nhóm 1 — Chat session (12)

| Lệnh | Mô tả 1 dòng | Chi tiết |
|---|---|---|
| `/new` | Mở chat mới, xóa history (thói quen #1 mỗi task) | [./commands/chat-session/new-chat/README.md](./commands/chat-session/new-chat/README.md) |
| `/clear` | Xóa context trong chat hiện tại, giữ instructions | [./commands/chat-session/clear/README.md](./commands/chat-session/clear/README.md) |
| `/history` | Xem lại lịch sử chats, quay lại chat cũ | [./commands/chat-session/history/README.md](./commands/chat-session/history/README.md) |
| `/export` | Export conversation ra file để lưu/share | [./commands/chat-session/export/README.md](./commands/chat-session/export/README.md) |
| `/resume` | Mở lại / tiếp tục phiên chat đã lưu | [./commands/chat-session/resume/README.md](./commands/chat-session/resume/README.md) |
| `Ctrl+I` inline | Chat inline ngay trong editor, sửa tại chỗ | [./commands/chat-session/inline-chat/README.md](./commands/chat-session/inline-chat/README.md) |
| `Quick Chat` | Mở Quick Chat hỏi nhanh không rời editor | [./commands/chat-session/quick-chat/README.md](./commands/chat-session/quick-chat/README.md) |
| `Checkpoint` | Quay về checkpoint trước khi agent sửa sai | [./commands/chat-session/checkpoints/README.md](./commands/chat-session/checkpoints/README.md) |
| `Attach` | Đính kèm file/folder/ảnh vào prompt | [./commands/chat-session/attachments/README.md](./commands/chat-session/attachments/README.md) |
| `/help` | Xem help + nhóm lệnh khả dụng | [./commands/chat-session/help/README.md](./commands/chat-session/help/README.md) |
| `Shortcuts` | Liệt kê phím tắt Chat trong IDE này | [./commands/chat-session/shortcuts/README.md](./commands/chat-session/shortcuts/README.md) |
| `/summarize` | Tóm tắt hội thoại dài thành bản gọn giữ đà task | [./commands/chat-session/summarize/README.md](./commands/chat-session/summarize/README.md) |

## Nhóm 2 — Model & Agent (9)

| Lệnh | Mô tả 1 dòng | Chi tiết |
|---|---|---|
| `/model` | Đổi model giữa chat (mạnh/rẻ tùy task) | [./commands/model-agent/model-picker/README.md](./commands/model-agent/model-picker/README.md) |
| `Ask mode` | Về Ask read-only: chỉ hỏi, không sửa | [./commands/model-agent/ask-mode/README.md](./commands/model-agent/ask-mode/README.md) |
| `Edit mode` | Vào Edit với files bạn chọn, sửa có kiểm soát | [./commands/model-agent/edit-mode/README.md](./commands/model-agent/edit-mode/README.md) |
| `Agent mode` | Tự tìm file, sửa, chạy terminal | [./commands/model-agent/agent-mode/README.md](./commands/model-agent/agent-mode/README.md) |
| `Custom agent` | Gọi custom agent trong `.github/agents/` | [./commands/model-agent/custom-agent/README.md](./commands/model-agent/custom-agent/README.md) |
| `/usage` | Xem premium requests đã dùng (link dashboard) | [./commands/model-agent/premium-requests/README.md](./commands/model-agent/premium-requests/README.md) |
| `Coding agent` | Giao issue cho Copilot coding agent xử lý async | [./commands/model-agent/coding-agent-assign/README.md](./commands/model-agent/coding-agent-assign/README.md) |
| `Coding agent PR` | Tóm tắt diff thành PR, review flow issue→PR | [./commands/model-agent/coding-agent-pr/README.md](./commands/model-agent/coding-agent-pr/README.md) |
| `Policy approval` | Xem/duyệt policy, approve lệnh nhạy cảm | [./commands/model-agent/policy-approval/README.md](./commands/model-agent/policy-approval/README.md) |

## Nhóm 3 — Code actions (10)

| Lệnh | Mô tả 1 dòng | Chi tiết |
|---|---|---|
| `/explain` | Giải thích code đang chọn bằng model hiện tại | [./commands/code-actions/explain/README.md](./commands/code-actions/explain/README.md) |
| `/fix` | Fix lỗi/selection đang chọn (nhanh hơn prompt tay) | [./commands/code-actions/fix/README.md](./commands/code-actions/fix/README.md) |
| `/tests` | Sinh unit tests theo mẫu repo cho code đang chọn | [./commands/code-actions/tests/README.md](./commands/code-actions/tests/README.md) |
| `/doc` | Sinh docstring/JSDoc cho hàm đang chọn | [./commands/code-actions/doc/README.md](./commands/code-actions/doc/README.md) |
| `/new` | Sinh code mới từ mô tả: hàm/file/module | [./commands/code-actions/new/README.md](./commands/code-actions/new/README.md) |
| `/optimize` | Đề xuất tối ưu perf cho đoạn code đang chọn | [./commands/code-actions/optimize/README.md](./commands/code-actions/optimize/README.md) |
| `/commit` | Gợi ý commit message từ staged diff | [./commands/code-actions/commit-message/README.md](./commands/code-actions/commit-message/README.md) |
| `/pr` | Tóm tắt diff thành PR title + body | [./commands/code-actions/pr-desc/README.md](./commands/code-actions/pr-desc/README.md) |
| `/refactor` | Refactor giữ nguyên behavior, tách hàm/file | [./commands/code-actions/refactor/README.md](./commands/code-actions/refactor/README.md) |
| `@terminal` | Biến lỗi terminal thành task fix cho agent | [./commands/code-actions/debug-terminal/README.md](./commands/code-actions/debug-terminal/README.md) |

## Nhóm 4 — System & Knowledge (15)

| Lệnh | Mô tả 1 dòng | Chi tiết |
|---|---|---|
| `/instructions` | Xem/sửa instructions đang load cho repo này | [./commands/system-knowledge/instructions/README.md](./commands/system-knowledge/instructions/README.md) |
| `/prompts` | Liệt kê prompt files `.github/prompts/` khả dụng | [./commands/system-knowledge/prompt-file/README.md](./commands/system-knowledge/prompt-file/README.md) |
| `/skills` | Liệt kê Agent Skills `.github/skills/` khả dụng | [./commands/system-knowledge/agent-skill/README.md](./commands/system-knowledge/agent-skill/README.md) |
| `/mcp` | Xem MCP servers/tools đang bật, reconnect khi rớt | [./commands/system-knowledge/mcp/README.md](./commands/system-knowledge/mcp/README.md) |
| `MCP add` | Thêm MCP server mới vào cấu hình | [./commands/system-knowledge/mcp-add/README.md](./commands/system-knowledge/mcp-add/README.md) |
| `/extensions` | Quản lý Copilot Extensions đã cài | [./commands/system-knowledge/extensions/README.md](./commands/system-knowledge/extensions/README.md) |
| `Content exclusion` | Xem files Copilot không được đọc | [./commands/system-knowledge/content-exclusion/README.md](./commands/system-knowledge/content-exclusion/README.md) |
| `Telemetry` | Xem/sửa code-telemetry consent | [./commands/system-knowledge/telemetry/README.md](./commands/system-knowledge/telemetry/README.md) |
| `/status` | Xem trạng thái Copilot: active, account, model | [./commands/system-knowledge/status/README.md](./commands/system-knowledge/status/README.md) |
| `/login` | Đăng nhập GitHub account cho Copilot | [./commands/system-knowledge/login/README.md](./commands/system-knowledge/login/README.md) |
| `/logout` | Đăng xuất, xóa credentials local | [./commands/system-knowledge/logout/README.md](./commands/system-knowledge/logout/README.md) |
| `/feedback` | Gửi feedback/bug về câu trả lời cho GitHub | [./commands/system-knowledge/bug-feedback/README.md](./commands/system-knowledge/bug-feedback/README.md) |
| `Knowledge base` | Hỏi tri thức team (docs nội bộ, wiki, RAG) | [./commands/system-knowledge/knowledge-base/README.md](./commands/system-knowledge/knowledge-base/README.md) |
| `gh suggest` | Gợi ý lệnh CLI trong terminal (`gh copilot suggest`) | [./commands/system-knowledge/cli-suggest/README.md](./commands/system-knowledge/cli-suggest/README.md) |
| `gh explain` | Giải thích lệnh CLI vừa chạy (`gh copilot explain`) | [./commands/system-knowledge/cli-explain/README.md](./commands/system-knowledge/cli-explain/README.md) |

---

## 6. Công thức 5 lệnh session đầu (giữ nguyên, làm 1 lần/repo)

```text
 /status → /instructions → /mcp → /customAgent → /policy
```

- Bước 1 `/status` — Copilot active? đúng account? đúng model? Sai account =
  sai quota/policy cả buổi ([./commands/system-knowledge/status/README.md](./commands/system-knowledge/status/README.md)).
- Bước 2 `/instructions` — xem instructions đang load, bật `useInstructionFiles`
  nếu chưa, cắt file <200 dòng (chi tiết [./commands/system-knowledge/instructions/README.md](./commands/system-knowledge/instructions/README.md)).
- Bước 3 `/mcp` — thêm GitHub (+ DB nếu có), test "liệt kê 5 PRs mở gần nhất"
  ([./commands/system-knowledge/mcp/README.md](./commands/system-knowledge/mcp/README.md)).
- Bước 4 `/customAgent` — tạo 2 agents: `explorer` (read-only) và `reviewer`
  (chỉ comment), duyệt bằng custom agent panel ([./commands/model-agent/custom-agent/README.md](./commands/model-agent/custom-agent/README.md)).
- Bước 5 `/policy` — xem org policy + `content-exclusion` (files nào Copilot không được đọc),
  test 1 task nhỏ end-to-end ([./commands/model-agent/policy-approval/README.md](./commands/model-agent/policy-approval/README.md)).

---

## 7. Lưu ý plan/model gating (premium requests, BYOK)

- Không thấy lệnh nào → check `/status` + plan trước khi kết luận lệnh không tồn tại.
- Premium requests: model mạnh (Claude/GPT-5-class) tốn multiplier cao hơn model
  rẻ. Hết quota model mạnh → `/model` đổi sang model rẻ thay vì dừng việc.
- BYOK (Enterprise): org dùng key/model riêng → list model trong `/model` khác
  Individual. Hỏi admin khi model bạn cần không hiện.
- Model availability theo plan: Individual < Business < Enterprise (mở dần).
  Coding agent + một số participants (`@github` full) có thể vắng mặt ở plan thấp.
- Checklist khi "lệnh không tồn tại": `/status` → check plan tại
  `github.com/settings/copilot` → đối chiếu bài này → gõ `/` xem list thực tế.

```text
# Flow debug 30 giay khi lenh vang mat (copy-paste tu duy):
# 1. /status -> account + model hien tai la gi?
# 2. github.com/settings/copilot -> plan + quota con khong?
# 3. Go / trong input -> list thuc te o may ban co lenh do khong?
# 4. Khong co -> co the bi plan gating hoac version extension cu -> /update.
```

---

## 8. Walkthrough + ví dụ copy-paste

### 8.1. Flow Ask → Edit → Agent bằng commands (10 phút)

```text
# Buoc 1 — Ask (hieu truoc, khong sua):
@workspace @file:package.json repo nay chay dev/test/lint bang lenh nao?
# Thay @file:package.json bang file that cua repo ban (#file + @workspace).

# Buoc 2 — /explain + /fix tren selection (sua nho):
# Chon 1 ham -> /explain -> doc -> /fix "them null check cho params".

# Buoc 3 — /tests (viec nha):
# Chon file source -> /tests "viet theo mau login.test.ts" -> chay test verify.

# Buoc 4 — /agent (task mo):
/agent Trong apps/api, POST /orders crash khi thieu customerId.
Tim root cause, fix, them regression test, chay npm test xac nhan.
```

### 8.2. Công thức gắn scope đúng (tiết kiệm 3–5 turns)

```text
# TE (khong scope — agent doan mo, ton turns):
"sua loi login dum tao"

# TOT (scope bang # + @ — turn 1 da dung):
#selection Them null check cho customerId, giu nguyen API shape.
@workspace Tim moi noi goi POST /orders, liet ke file + dong truoc khi sua.
#file:src/routes/login.ts #file:src/middleware/auth.ts Them rate-limit 5 req/phut.
```

### 8.3. Git flow bằng commands (copy-paste)

```text
# Sau khi code xong:
# 1. Xem diff: /diff (duyet tung hunk)
/diff
# 2. Review: /review "tim bug + security, chi bao loi that, khong nitpick style"
/review
# 3. Commit: stage files -> /commit (duyet message truoc khi commit)
/commit
# 4. PR: push branch -> /pr (tao title + body + checklist test da chay)
/pr
```

```bash
# Tuong duong terminal khi khong mo IDE:
git diff --staged --stat
gh copilot suggest "viet commit message conventional commits cho diff hien tai"
```

### 8.4. Thêm ví dụ copy-paste theo nhóm (dán thẳng vào Chat)

```text
# Nhom session — mo dau task moi (2 dong, tiet kiem quota ca buoi):
/new
/status
# Ky vong: chat sach + biet model/account truoc khi hoi gi khac.
```

```text
# Nhom model/mode — doi chien thuat giua chung (khong can mo settings):
/model
# Chon: model re cho /explain + /review nhe; model manh cho /agent kho.
# Sau doi model, chay lai prompt cu bang /retry de so sanh chat luong.
```

```text
# Nhom tri thuc — gan dung scope truoc khi hoi (pattern 3 bien):
@workspace Liet ke moi file dinh nghia type Order + noi import no.
#file:src/db/schema.ts Kieu Order con thieu truong nao so voi API response?
#selection Giai thich doan nay cho junior dev moi vao team (5 cau, tieng Viet).
```

```text
# Nhom tri thuc — sua @github truc tiep tu Chat (khoi mo browser):
@github Tom tat issue #123 (mo ta + comments moi nhat + ai dang lam).
@github Liet ke review comments chua resolve trong PR #456.
# Copy output vao mo ta task cho /agent chay tiep.
```

```text
# Nhom auth/settings — debug 1 phut khi Chat do (chay theo thu tu):
/status
/network
/diagnostics
# Doc: account dung khong? mang toi API thong khong? loi ghi gi?
# Mang corp chan -> /proxy (hoi IT lay host/port) truoc khi ket luan bug.
```

```text
# Ket hop @terminal — bien loi terminal thanh task cho agent (pattern hay):
# Buoc 1: chay test trong VS Code terminal, copy loi.
# Buoc 2: trong Chat:
@terminal Giai thich 3 loi dau bang tieng Viet, moi loi 2 cau.
/agent Fix 3 loi tren, chay lai test xac nhan, khong sua gi ngoai scope.
```

```text
# Ket hop /fetch — dua docs moi nhat vao context (chong hallucinate API):
/fetch https://docs.github.com/en/copilot/reference
# Sau do hoi: "Theo docs vua doc, lenh nao thay the /X cu? Cho vi du moi."
```

---

## 9. Pitfalls + bài tập

| Pitfall | Vì sao xảy ra | Fix |
|---|---|---|
| Gõ tự nhiên dài mà không dùng `@`/`#` | Không biết gắn scope | Mọi prompt code phải có `#file`/`#selection` hoặc `@workspace` |
| Dùng `/agent` cho việc 1 dòng | Nghĩ agent luôn tốt hơn | Việc nhỏ → `/fix`/`/explain` rẻ hơn, agent để task mở |
| Dùng Ask rồi trách "không sửa file" | Ask là read-only | Muốn sửa → `/edit` hoặc `/agent` |
| Không `/new` giữa các tasks | Lười mở chat mới | Chat mới mỗi task, instructions giữ context chung |
| Dùng model mạnh nhất cho mọi lệnh | Mặc định không đổi | Giải thích/review nhẹ → model rẻ; agent khó → model mạnh |
| Tin `/commit`/`/pr` 100% không đọc | Lười review message | Luôn đọc + sửa message trước khi commit/push |
| Lệnh vắng mặt mà kết luận "bug" | Plan/model gating | Check `/status` + plan + gõ `/` xem list thực tế trước |
| Quên `/policy`/`/exclusion` ở corp | Không biết org cấm gì | Session đầu luôn chạy `/policy` → `/exclusion` |

### Bài tập thực hành

**Bài 1 (15 phút) — Scope drill:**
Cùng 1 task, chạy 2 lần: lần 1 không `@`/`#`, lần 2 có `@workspace` + `#file`.
So sánh số turns + độ đúng. Ghi lại chênh lệch vào team wiki.

**Bài 2 (15 phút) — Commands tour:**
Chạy tuần tự `/status → /instructions → /mcp → /agents → /policy → /usage`
trên repo thật. Chụp (che secrets) + giải thích mỗi output 1 câu.

**Bài 3 (20 phút) — Git flow:**
Trên branch test, chạy `/diff → /review → /commit → /pr`. Liệt kê: lệnh nào
đúng ngay, lệnh nào bạn phải sửa tay, sửa gì.

**Bài 4 (15 phút) — Gating check:**
Mở `/model` liệt kê models khả dụng ở plan bạn. So với đồng nghiệp plan khác
(nếu có). Ghi bảng: model nào tốn premium multiplier cao (ước lượng từ dashboard).

---

## 10. Link chéo

- **Bài 00 — Tổng quan**: 4 họ tools đằng sau mỗi command (`@`/`#` gọi tool nào).
- **Bài 01 — Cài đặt**: `/login`, `/status`, `/network`, `/proxy` khi setup báo đỏ.
- **Bài 02 — Surfaces**: commands nào dùng được trên surface nào (local vs cloud).
- **Bài 03 — Instructions**: `/instructions` + `applyTo` — file đằng sau commands.
- **Bài 05 — Prompt files**: prompt files + Agent Skills — commands gọi workflow tái dùng.
- **Bài 10 — Modes & Permissions**: `policy-approval`, `content-exclusion`, model gating chi tiết.
- **Bài 11 — Worktrees & Checkpoints**: coding agent assign/PR trong flow issue → PR.
