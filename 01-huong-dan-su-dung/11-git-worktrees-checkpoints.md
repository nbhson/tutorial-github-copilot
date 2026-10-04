# 11 — Git Worktrees & Checkpoints (Song Song Không Giẫm + Undo)

> Bài 11 của series. Đọc xong bạn chạy được worktree workflows cho parallel
> coding agents, dùng VS Code checkpoints/timeline undo đúng lúc, và theo đúng
> branch strategy `copilot/*`. Thời gian: ~30 phút.

## Mục lục

1. [Vì sao worktrees + checkpoints? (why)](#1-vì-sao-worktrees--checkpoints-why)
2. [VS Code checkpoints: timeline + chat session restore](#2-vs-code-checkpoints-timeline--chat-session-restore)
3. [Worktrees deep-dive (lệnh thuộc lòng)](#3-worktrees-deep-dive-lệnh-thuộc-lòng)
4. [Branch strategy của coding agent (`copilot/*`)](#4-branch-strategy-của-coding-agent-copilot)
5. [3 worktree workflows (copy-paste)](#5-3-worktree-workflows-copy-paste)
6. [Rewind = git restore + new chat (bảng quyết định)](#6-rewind--git-restore--new-chat-bảng-quyết-định)
7. [Walkthrough + pitfalls + bài tập](#7-walkthrough--pitfalls--bài-tập)
8. [Link chéo](#8-link-chéo)

---

## 1. Vì sao worktrees + checkpoints? (why)

2 vấn đề song song của agent work:

```text
Vấn đề 1 — Giẫm chân: 2 sessions cùng sửa 1 working dir → conflict, đè file, test flaky.
  → Giải pháp: worktrees (mỗi session 1 checkout riêng, branch riêng).

Vấn đề 2 — Đi sai đường: agent sửa 15 turns vẫn sai, càng sửa càng nát.
  → Giải pháp: checkpoints (undo cả code + conversation về điểm trước khi nát).
```

Git là source of truth cuối (commit/PR), checkpoints là undo local nhanh,
worktrees là cách ly không gian. 3 lớp phối hợp (không thay nhau).

---

## 2. VS Code checkpoints: timeline + chat session restore

Copilot không có `/rewind` như Claude Code. Bạn undo bằng 3 cơ chế VS Code:

| Cơ chế | Làm gì | Khi nào |
|---|---|---|
| **Timeline** (file history) | Restore 1 file về bản trước đó | Sai 1–2 files, còn lại đúng |
| **Chat session restore** | Mở lại chat cũ / fork từ điểm cũ | Muốn thử hướng khác giữ mạch chính |
| **Git restore + new chat** | `git restore/checkout` code + mở chat mới sạch | Agent nát 10+ turns (rewind thật) |

```text
Timeline (nhanh nhất):
VS Code → Explorer →右键 file → Timeline → chọn điểm trước khi agent sửa → Restore.
→ chỉ restore 1 file, chat giữ nguyên (khác rewind cả conversation).

Chat session restore:
Chat view → History (đồng hồ) → chọn session cũ → Restore/Fork.
→ thử hướng khác mà không mất mạch đang đúng 50% (tương đương /branch).

Nguyên tắc: sửa 2 lần vẫn sai → đừng argue tiếp, git restore + new chat sạch
(rẻ hơn 10 turns cãi nhau + premium requests).
```

```bash
# Xem timeline từ CLI (khi cần diff nhanh trước khi restore):
git diff HEAD -- <file>              # agent đã sửa gì chưa commit?
git diff --stat                      # scope có phình không? (>5 files khi chỉ cần 2 → lan)
git log --oneline -5 -- <file>       # lịch sử file (điểm restore nào an toàn?)
```

---

## 3. Worktrees deep-dive (lệnh thuộc lòng)

Mỗi session 1 git checkout riêng → 2 agents sửa cùng repo không conflict file.

```bash
git worktree add ../myfeature-worktrees/feat-x -b feat/x
# mở session trong worktree (VS Code: File → Open Folder → ../myfeature-worktrees/feat-x)
# xong việc:
git worktree remove ../myfeature-worktrees/feat-x
```

Quy ước team: thư mục `../<repo>-worktrees/<ten>`, branch `feat/<ten>`
(local) hoặc `copilot/<issue>-<slug>` (coding agent cloud, mục 4). Dọn worktree sau merge.

### 3.1. Lệnh căn bản (thuộc lòng)

```bash
# Tạo (branch mới từ HEAD hiện tại):
git worktree add ../myrepo-worktrees/feat-login -b feat/login

# Tạo từ main mới nhất:
git fetch origin
git worktree add ../myrepo-worktrees/feat-pay -b feat/pay origin/main

# Liệt kê + kiểm tra:
git worktree list
git worktree list --porcelain

# Mở session trong worktree:
cd ../myrepo-worktrees/feat-login && code .
# Hoặc mở thêm folder trong cùng window (đa-root) — nhưng khuyên 1 window/worktree cho sạch.

# Dọn (sau merge):
git worktree remove ../myrepo-worktrees/feat-login        # worktree sạch
git worktree remove --force ../myrepo-worktrees/feat-login # có changes chưa commit (cẩn thận!)
git worktree prune    # dọn metadata worktree đã xóa tay
```

### 3.2. Vì sao quy ước folder/branch? (why)

```text
../<repo>-worktrees/<ten>  → ngoài repo chính (không pollute git status, .gitignore không cần sửa).
feat/<ten> (local)         → branch tách main, PR riêng từng worktree.
copilot/* (cloud)          → prefix coding agent dùng (mục 4) — đừng đặt tay trùng.
dọn sau merge              → worktree tồn tại = branch tồn tại = nợ. Merge xong xóa cả 2.
```

---

## 4. Branch strategy của coding agent (`copilot/*`)

Coding agent (github.com, assign issue → agent làm → ra PR) dùng branch prefix
riêng. Bạn cần biết để không giẫm + review đúng.

```text
Luồng coding agent chuẩn:
1. Bạn: mở issue (mô tả + acceptance criteria + labels "ready") → Assign to Copilot.
2. Agent (cloud): tạo branch copilot/issue-123-<slug> từ main → implement → push →
   mở PR draft (linked issue, checklist tests, session log).
3. Bạn: review PR (diff + Copilot review + CI) → request changes (comment → agent iterate)
   hoặc approve → merge → branch tự xóa (auto-delete head branches: ON).

Quy tắc branch:
- copilot/* → của agent, BẠN KHÔNG push tay vào (trừ hotfix, phải báo agent).
- feat/* → của bạn local (worktrees). Không đặt feat/copilot-* gây nhầm.
- main → protected (bài 07): không ai push trực tiếp, kể cả agent.
```

```bash
# Theo dõi + review coding agent branches (copy-paste):
git fetch origin
git branch -r | grep "copilot/"              # agent đang làm branches nào?
gh pr list --repo acme/api --author "app/copilot" --state open
gh pr view 45 --json title,headRefName,reviews,state --jq .
# Checkout PR agent về local để test (không sửa trên branch nó):
gh pr checkout 45 --branch review-45   # hoặc: git fetch origin copilot/issue-123-x
pnpm install --frozen-lockfile && pnpm test
```

```bash
# Dọn sau merge (copy-paste):
git branch -d feat/my-done-task                    # local đã merge
git worktree remove ../api-worktrees/feat-my-done-task
git worktree prune && git worktree list            # xác nhận sạch
# Branch copilot/* merged → GitHub tự xóa nếu bật auto-delete (Settings → General).
```

---

## 5. 3 worktree workflows (copy-paste)

### Pattern A — Solo 2 features song song (phổ biến nhất)

```bash
# Setup (5 phút, 1 lần):
git fetch origin
git worktree add ../myrepo-worktrees/feat-a -b feat/a origin/main
git worktree add ../myrepo-worktrees/feat-b -b feat/b origin/main
git worktree list   # xác nhận 3 entries (main + 2 worktrees)

# Window 1 (feature A): mở ../myrepo-worktrees/feat-a → Agent mode:
# > "implement login rate-limit theo plan plans/xxx.md, chạy focused test"

# Window 2 (feature B): mở ../myrepo-worktrees/feat-b → Agent mode:
# > "migrate users table thêm last_login_at, test local"

# Xong mỗi bên: review diff → commit → push → gh pr create → merge → dọn:
git worktree remove ../myrepo-worktrees/feat-a
git branch -d feat/a
```

### Pattern B — Thử 2 phương án, giữ cái thắng (spike)

```bash
git worktree add ../myrepo-worktrees/spike-1 -b spike/option-1 origin/main
git worktree add ../myrepo-worktrees/spike-2 -b spike/option-2 origin/main

# Window 1: thử JWT-blacklist. Window 2: thử server-sessions.
# Mỗi bên implement + test + đo (perf/complexity). So sánh:

# Giữ spike-2, bỏ spike-1:
git worktree remove --force ../myrepo-worktrees/spike-1
git branch -D spike/option-1
# Đổi tên spike-2 thành feat/: git branch -m spike/option-2 feat/sessions
```

### Pattern C — Local + coding agent fan-out (bạn code, agent làm task độc lập)

```text
# Bạn KHÔNG tạo worktree cho agent cloud — nó chạy trên GitHub infra, branch copilot/*.
# Bạn làm:
# 1. Giao 2 issues độc lập cho 2 coding agents (gh copilot assign / web Assign).
# 2. Bạn code task chính ở worktree local feat/main-work.
# 3. Agent mở PR drafts → bạn review từng PR (checkout về local test như mục 4).
# 4. Merge từng PR → dọn worktree local khi xong.
# Kill khi agent đi sai: comment "stop, wrong direction — see [hướng đúng]" hoặc
# close PR + delete branch copilot/*. Đừng để agent iterate quá 3 rounds không tiến.
```

---

## 6. Rewind = git restore + new chat (bảng quyết định)

### Scenario 1 — Agent sửa 3 turns vẫn fail cùng 1 test

```text
Dấu hiệu: cùng 1 lỗi, 3 fixes khác nhau đều fail.
Quyết định: REWIND (restore về trước fix 1 + chat mới) + re-prompt với thông tin mới.
  git restore <files> (hoặc Timeline → Restore) → new chat:
  "Test X fail với [paste lỗi đầy đủ]. Lần trước thử A, B, C đều fail.
   Hãy đọc [file] lại từ đầu, đề xuất root cause KHÁC trước khi sửa."
```

### Scenario 2 — Agent refactor lan man ngoài scope (đụng 10 files khi chỉ cần 2)

```text
Dấu hiệu: git diff --stat phình, files ngoài scope xuất hiện.
Quyết định: REWIND + giao lại scope hẹp:
  git restore <8 files ngoài scope> → new chat:
  "Chỉ sửa [2 files]. KHÔNG đụng [8 files kia]. Xong chạy focused test."
```

### Scenario 3 — Prompt ban đầu thiếu thông tin (agent đoán sai hướng)

```text
Dấu hiệu: agent làm "đúng" theo prompt nhưng sai ý bạn.
Quyết định: REWIND + viết lại prompt đầy đủ (mục tiêu + scope + verify + non-goals).
  git restore . (hoặc checkout lại worktree sạch) → new chat với prompt đủ.
  Đừng "sửa dần" từ code sai hướng — rẻ hơn làm lại sạch.
```

### Scenario 4 — Chỉ sai 1 bước nhỏ, còn lại đúng

```text
Dấu hiệu: 9/10 steps đúng, 1 step sai (vd sai tên column).
Quyết định: KHÔNG rewind — sửa trực tiếp (Edit 1 dòng) hoặc bảo agent "sửa dòng X thành Y".
  Rewind ở đây phí (mất 9 steps đúng + premium).
```

### Bảng quyết định 30 giây

| Tình huống | Rewind? | Bằng gì? |
|---|---|---|
| Cùng lỗi fail 2–3 lần | Có | `git restore` + new chat (scenario 1) |
| Lan scope, diff phình | Có | Restore files ngoài scope + chat mới hẹp |
| Hiểu nhầm yêu cầu từ đầu | Có | Restore hết + viết lại prompt đủ |
| Sai 1 dòng, còn lại đúng | Không | Edit trực tiếp / Timeline 1 file |
| Muốn thử hướng khác song song | Không (dùng worktree mới) | Worktree + branch mới, giữ mạch chính |
| Task đã commit PR rồi | Không (dùng git/PR) | `git revert` / PR mới — checkpoints là local |
| Coding agent đi sai trên cloud | Không (dùng PR flow) | Comment redirect / close PR + delete `copilot/*` |

---

## 7. Walkthrough + pitfalls + bài tập

### 7.1. Walkthrough kết hợp (20 phút)

```bash
# Bước 1: tạo 2 worktrees (pattern A):
git fetch origin
git worktree add ../myrepo-worktrees/opt-1 -b feat/opt-1 origin/main
git worktree add ../myrepo-worktrees/opt-2 -b feat/opt-2 origin/main

# Bước 2: window 1 (opt-1) Agent mode research phương án 1, window 2 bạn thử phương án 2.
# Bước 3: so sánh (focused test + review diff). Chọn thắng.
# Bước 4: merge + dọn:
# PR thắng → merge → git worktree remove <thua> + git branch -D <thua>
git worktree list   # xác nhận sạch
```

### 7.2. Worktree gotchas (4 cái ai cũng vấp 1 lần)

**1. Untracked files không theo worktree:**

```bash
# Worktree mới chỉ có tracked files từ branch base. File chưa commit ở main KHÔNG sang.
# → Trước khi tạo worktree: commit WIP hoặc stash:
git stash push -m "wip-main" && git worktree add ../myrepo-worktrees/feat-x -b feat/x
```

**2. Dependencies phải cài lại mỗi worktree:**

```bash
cd ../myrepo-worktrees/feat-x
pnpm install --frozen-lockfile   # Node
# hoặc: python -m venv .venv && pip install -r requirements.txt
# Mẹo: pnpm store shared + Docker layer cache để đỡ tải lại nặng.
```

**3. Env files + ports đụng nhau:**

```bash
# .env thường untracked → copy tay sang worktree mới (KHÔNG commit .env!):
cp /path/to/main/.env ../myrepo-worktrees/feat-x/.env
# Ports: 2 sessions cùng chạy :3000 → đụng. Đổi PORT mỗi worktree:
PORT=3001 pnpm dev   # worktree A :3000, worktree B :3001
```

**4. Đừng mở 2 worktrees cùng VS Code window rồi nhầm:**

```text
Mỗi worktree 1 window riêng (màu/window title khác nhau). Đặt:
settings: "window.title": "${rootName} — ${activeEditorShort}"
→ nhìn title biết đang ở worktree nào, không commit nhầm branch.
```

### 7.3. Pitfalls + fix

| Pitfall | Vì sao | Fix |
|---|---|---|
| Quên dọn worktree → 10 worktrees tồn | Không quy ước dọn | Merge xong remove ngay; `git worktree list` cuối tuần |
| 2 sessions cùng dir (không worktree) → conflict | Lười tạo worktree | Task song song = worktree riêng, không ngoại lệ |
| Restore sau khi đã push | Local only | Đã push → `git revert`/PR mới, không restore mù |
| Push tay vào `copilot/*` của agent | Không biết quy ước | `copilot/*` là của agent — review qua PR, không push trực tiếp |
| Xóa worktree đang có window mở | Window mất folder | Đóng window trước, hoặc `cd` ra rồi thử lại |
| Agent lan scope mà vẫn argue 10 turns | Tiếc turns đã tốn | Sai 2 lần → restore + new chat (rẻ hơn argue) |

### 7.4. Bài tập thực hành

**Bài 1 (15 phút):** Tạo 2 worktrees (pattern A). Mở 2 windows, mỗi bên 1 task nhỏ.
`git worktree list` + merge + dọn. Ghi thời gian so với làm tuần tự.

**Bài 2 (15 phút):** Cố ý giao task sai hướng, để agent làm 5 turns, rồi restore +
new chat sạch (scenario 3). So sánh premium/turns rewind-sớm vs argue-tiếp.

**Bài 3 (10 phút):** Thử Timeline restore 1 file + Chat history fork. Khi nào
Timeline đủ, khi nào cần `git restore` + new chat?

**Bài 4 (15 phút):** Giao 1 issue test cho coding agent (repo thử). Review branch
`copilot/*` + PR draft: checkout về local test, comment 1 request changes, merge, verify auto-delete.

---

## 8. Link chéo

- **Bài 06 — Custom agents:** parallel sessions (local multi-chat + cloud multi-agent) — worktrees là cách ly.
- **Bài 07 — Guardrails:** branch protection + auto-delete + push protection cho `copilot/*`.
- **Bài 10 — Modes & permissions:** scope Agent mode (1 worktree/branch) + approval.
- **Bài 12 — SDK & CI:** coding agent assign, auto-fix CI, review workflow trên PR.
- **Bài 04 — Chat commands:** Chat history, model picker khi mở chat mới sau rewind.

---
*(Hết bài 11 — tổng ~400 dòng. Tiếp theo: Bài 12 — Copilot SDK & CI/CD automation.)*
