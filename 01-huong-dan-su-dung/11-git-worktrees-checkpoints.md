# 11 — Git Worktrees & Checkpoints: Chạy Agent Song Song, Quay Lui Đúng Lúc (Chuẩn 2026)

> **Dành cho:** dev đã quen Copilot trong VS Code, muốn chạy nhiều agent song song không giẫm chân, và muốn "quay lại" khi agent đi sai.
> **Vấn đề:** 2 session cùng sửa 1 working dir → conflict, đè file, test flaky; hoặc agent sửa 15 turn vẫn sai, càng sửa càng nát mà bạn tiếc AI Credits đã đốt.
> **Đọc xong:** tạo worktree cho agent song song bằng 3 lệnh thuộc lòng, dùng đúng 4 cơ chế checkpoint của VS Code, giữ quy tắc branch `copilot/*`, có phản xạ rewind sớm. **Thời gian:** ~30 phút.
>
> **Lưu ý 2026:** checkpoints **bật mặc định** ở session được hỗ trợ (`chat.checkpoints.enabled` = on) — VS Code tự snapshot trước mỗi request, bạn khỏi tạo mốc tay (commit tay vẫn bền hơn).

## Mục tiêu bài học

Mục này cho bạn biết sau 30 phút sẽ mang được gì về — như checklist trước khi thuê thêm thợ về nhà.

- Tạo **worktree** cho 2 agent chạy song song trên 2 branch riêng bằng đúng 3 lệnh `git worktree` (add / list / remove).
- Dùng được **4 cơ chế checkpoint** của VS Code (automatic · restore checkpoint · restore conversation only · name a checkpoint) và biết giới hạn của chúng.
- **Phân vai ba lớp** — Git (sổ cái) · checkpoint (state của session) · worktree (chỗ làm riêng) — không lấy lớp này thay lớp kia.
- Có phản xạ **rewind sớm**: sai 2 lần thì restore + chat mới theo bảng 30 giây, thay vì argue 10 turn đốt AI Credits.

> **Tóm gọn 1 câu:** Giẫm chân thì worktree, đi sai đường thì checkpoint — và checkpoints không thay thế git: checkpoint là session state, git là code state.

---

## 1. Hai vấn đề, ba lớp công cụ

```text
Vấn đề 1 — Giẫm chân: 2 session cùng sửa 1 working dir → conflict, đè file, test flaky → vá bằng worktrees (mỗi session 1 checkout + branch riêng).
Vấn đề 2 — Đi sai đường: agent sửa 15 turn vẫn sai, càng sửa càng nát → vá bằng checkpoints (undo code + conversation về điểm trước khi nát).
```

| Lớp | Vai trò | Nôm na |
|---|---|---|
| **Git** (commit/PR) | Nguồn sự thật cuối cùng | Sổ cái kế toán |
| **Checkpoints** (VS Code) | Undo nhanh file + hội thoại của session, chưa cần commit | Ctrl+Z của cả phiên |
| **Worktrees** | Cách ly không gian làm việc | Mỗi thợ 1 phòng riêng |

> **Vì sao quan trọng?** Chọn sai lớp là hỏng kép: tin checkpoint thay commit thì mất mốc khi cache IDE bị dọn; tin worktree thay sandbox thì tưởng an toàn — docs VS Code ghi nguyên văn *"A Git worktree separates code changes, but is not a security boundary"* (chặn tool nguy hiểm là việc của sandbox + permissions, bài 10/16). Sai đường mà còn argue: 10 turn tốn 10+ lượt gọi model, `git restore` + chat mới gần như không mất thêm AI Credits.
> **Nếu làm sai?** Ba nhầm kinh điển: checkpoint = commit, restore = hoàn tác được deploy, worktree = clone tốn disk — bảng ❌/✅ cuối bài sửa hết.

> **Tóm gọn 1 câu:** Git là sổ cái, checkpoint là Ctrl+Z của phiên, worktree là phòng làm việc riêng — mỗi thứ một việc, đừng bắt nó đóng vai thứ khác. · 📄 [VS Code Docs: Source Control Overview](https://code.visualstudio.com/docs/sourcecontrol/overview)

## 2. Checkpoints: 4 cơ chế trong VS Code

Docs VS Code (Review & Revert Changes · Get an agent back on track) mô tả hệ checkpoint gồm đúng 4 cơ chế — và **truy cập** chúng bằng palette/CLI:

| Cơ chế | Docs nói gì | Thao tác | Khi nào dùng |
|---|---|---|---|
| **1. Automatic checkpoint** | VS Code snapshot các file liên quan **trước mỗi request**; mặc định bật (`chat.checkpoints.enabled`) | Không làm gì — gửi request là có mốc | Mọi phiên agent |
| **2. Restore checkpoint** | Đưa file bị ảnh hưởng về mốc **và xoá các turn sau đó** | Hover request cũ → **Restore Checkpoint** → xác nhận | Agent đi sai từ một mốc rõ |
| **3. Restore conversation only** | Đưa **hội thoại** về mốc mà giữ file hiện tại | Chọn phạm vi restore trong hội thoại | Code đã đúng, chỉ muốn nói lại prompt cũ cho sạch |
| **4. Name a checkpoint** | Đặt tên cho mốc để lần sau tìm đúng điểm | Gắn tên trước khi giao việc mạo hiểm | Session dài 20+ turn, nhiều mốc gần nhau |

- Command palette: **`Chat: Show Checkpoints`** · **`Reveal in Timeline`** · **`Take checkpoint before risky request`** — ba lệnh tra nhanh trước/sau khi agent chạy.
- **Copilot CLI có checkpoint riêng:** `copilot checkpoint restore` (docs GitHub — CLI command reference).
- **Fork tại checkpoint:** `/fork`, `/fork <title>`, `/fork prompt <...>` — rẽ nhánh hội thoại, giữ mạch gốc; cần Agent Host session → [commands/copilot/chat-session/fork](commands/copilot/chat-session/fork/README.md).
- **Giới hạn:** checkpoint **không** hoàn tác lệnh terminal đã chạy, network request, deploy hay thay đổi ở dịch vụ ngoài — mấy thứ đó dùng git hoặc controls của chính dịch vụ.

> **Tin tốt 2026:** (1) checkpoint **bật mặc định** — hết cảnh "quên bật rồi mất trắng"; (2) mốc tạo **trước từng request** nên luôn sát điểm hỏng; (3) restore chọn được **file + hội thoại** hoặc **chỉ hội thoại**; (4) fork ngay tại checkpoint để thử hướng khác mà không mất mạch cũ.

**Checkpoints ≠ thay thế git** — checkpoint là session state (mốc của phiên chat, trên máy bạn), git là code state (mốc bền, đẩy lên server, cả team thấy). Trước task dài: commit một cái rồi mới giao agent — đó là "checkpoint thủ công" không bao giờ bay theo cache IDE.

> 📄 **Code ví dụ (4 cơ chế, copy-paste):** [`./examples/11-git-worktrees-checkpoints/checkpoints-4-co-che.sh`](./examples/11-git-worktrees-checkpoints/checkpoints-4-co-che.sh) · Tra nhanh: [commands/copilot/chat-session/checkpoints](commands/copilot/chat-session/checkpoints/README.md)

> **Tóm gọn 1 câu:** Mốc tự động có sẵn cho mọi request — việc của bạn là biết mốc nào đáng về, và commit trước những việc mà mất là đau. · 📄 [VS Code Docs: Undo changes at the right scope](https://code.visualstudio.com/docs/agents/run/review-code-edits#undo-changes-at-the-right-scope)

## 3. Worktrees: 3 lệnh thuộc lòng

```bash
git worktree add ../myrepo-worktrees/feat-x -b feat/x  # tao phong: folder + branch moi
git worktree list                                      # kiem tra: moi dong = 1 phong dang mo
git worktree remove ../myrepo-worktrees/feat-x         # don sau merge (+ git worktree prune)
```

```text
Quy ước tên:
../<repo>-worktrees/<ten>  → đặt NGOÀI repo chính (git status sạch, không sửa .gitignore).
feat/<ten>                 → branch local, PR riêng; 1 window = 1 branch.
copilot/<issue>-<slug>     → prefix Copilot cloud agent dùng (mục 5) — đừng đặt tay trùng.
Dọn sau merge              → worktree tồn = branch tồn = nợ.
```

- **Rẻ hơn clone:** worktree share `.git` objects, chỉ thêm working files; `git clone` copy cả `.git` nên tốn gấp 5–10 lần (verify: `du -sh ../myrepo-worktrees/feat-x`). Xong việc phải dọn — worktree tồn là nợ.
- **Worktree đặt ngoài repo đang mở:** VS Code hỏi Workspace Trust lần đầu, session có thể báo permission error với folder lạ — approve đúng folder là xong, không phải hỏng.

> 📄 **Code ví dụ (add/list/remove + dọn dẹp):** [`./examples/11-git-worktrees-checkpoints/worktrees-deep-dive-lenh-thuoc-long.sh`](./examples/11-git-worktrees-checkpoints/worktrees-deep-dive-lenh-thuoc-long.sh) · 📄 [VS Code Docs: Create a worktree](https://code.visualstudio.com/docs/sourcecontrol/branches-worktrees#create-a-worktree)

## 4. Ba cách chạy song song

| Pattern | Nôm na | Khi nào dùng |
|---|---|---|
| **A — 2 features song song** | 2 thợ 2 phòng | 2 task độc lập làm cùng lúc, mỗi cái 1 worktree |
| **B — Thử 2 phương án (spike)** | Cắm 2 mầm, giữ cây khỏe hơn | Chưa biết hướng nào đúng — đo rồi bỏ 1 |
| **C — Bạn local + agent cloud fan-out** | Bạn giữ việc chính, "thuê robot" làm phụ | Vừa code tay vừa giao issue cho Copilot cloud agent |

**Khung C — lệnh ở ngoài agent:** bạn KHÔNG tạo worktree cho agent cloud (nó chạy trên hạ tầng GitHub, branch `copilot/*`) — phần worktree chỉ là chỗ ở *của bạn*:

```text
1. Giao 2 issue độc lập cho 2 Copilot cloud agent (web: Assign to Copilot).
2. Bạn code việc chính ở worktree local feat/main-work — không đụng lane của nó.
3. Agent mở PR draft → review từng PR (gh pr checkout, mục 5). Merge từng PR.
4. Dọn worktree local khi xong.
```

Fan-out chi tiết (nhiều agent/subagent một máy, chia scope, gộp kết quả) — bài 06 là chủ sở hữu:

- Bài 06 dạy tạo nhiều session/agent song song trên máy bạn; worktree ở đây cấp *chỗ ở* cho từng cái.
- Muốn 2 agent sửa 2 vùng code không đè nhau: 1 worktree/agent, scope ghi rõ trong prompt.
- Muốn 2 agent cùng bàn 1 vấn đề (thăm dò): shared session + `/fork` — không cần worktree.
- Tình huống "1 người + N robot qua đêm" (assign cloud): xem mục 5 và bài 12 §6.

> 📄 **Code ví dụ (A + B copy-paste):** [`./examples/11-git-worktrees-checkpoints/worktree-workflows-copy-paste.sh`](./examples/11-git-worktrees-checkpoints/worktree-workflows-copy-paste.sh) · 📄 [VS Code Docs: Arrange sessions in a grid](https://code.visualstudio.com/docs/agents/run/agents-window#arrange-sessions-in-a-grid)

## 5. Branch strategy: `copilot/*` + branch protection + auth check

**Quy tắc branch (dán vào CONTRIBUTING):** `copilot/*` → của Copilot cloud agent, bạn KHÔNG push tay vào (trừ hotfix, phải báo trước) · `feat/*` → của bạn, không đặt `feat/copilot-*` gây nhầm lane · `main` → protected, không ai push trực tiếp kể cả agent (bài 07).

Trước khi giao việc hoặc merge, check 2 thứ — **branch protection + auth check**: `gh auth status` phải sạch và `git push -u origin feat/x` lên được (auth hết hạn là mất cả buổi debug nhầm chỗ); `main` phải có branch protection với required checks CI + review đang ON — robot hay người muốn vào main đều phải qua PR.

**Copilot cloud agent — 3 gạch thuộc bài này (chủ sở hữu flow: bài 12):**

- Nhận issue được **assign** → tự tạo branch `copilot/issue-<n>-<slug>` từ default branch → code → push → mở **PR draft**.
- Review PR như PR của người: diff + Copilot code review + CI + 1 approve → merge → branch tự xoá (auto-delete ON).
- Modes / permissions / environment của session cloud, giới hạn phút, chỗ đọc instructions/skills → [commands/cloud/model-agent/cloud-agent-session](commands/cloud/model-agent/cloud-agent-session/README.md) và bài 12 §6.

> 📄 **Code ví dụ (theo dõi + checkout PR của agent về local test):** [`./examples/11-git-worktrees-checkpoints/branch-strategy-cua-coding-agent-copilot.sh`](./examples/11-git-worktrees-checkpoints/branch-strategy-cua-coding-agent-copilot.sh) · 📄 [VS Code Docs: Merge & publish branches](https://code.visualstudio.com/docs/sourcecontrol/branches-worktrees#merge-and-publish-branches)

## 6. Rewind: bảng quyết định 30 giây

| Tình huống | Ví dụ | Rewind? | Bằng gì |
|---|---|---|---|
| Cùng lỗi fail 2–3 lần | Test login đỏ 3 lần cùng `TypeError` | Có | `git restore` + chat mới: "Lần trước thử A, B, C đều fail. Đề xuất root cause KHÁC trước khi sửa." |
| Lan scope, diff phình | `--stat` hiện `auth/ + cart/ + legacy/` | Có | Restore checkpoint về mốc sạch + chat hẹp hơn |
| Hiểu nhầm yêu cầu từ đầu | "Thêm refund" quên giới hạn 30 ngày | Có | Restore + viết lại prompt đủ (mục tiêu + scope + verify + non-goals) |
| Sai 1 dòng, còn lại đúng | `user_id` thành `users_id` | Không | Sửa trực tiếp / Undo edit trong working set — rewind phí 9 step đúng |
| Thử hướng khác song song | A dùng JWT, B dùng session | Không | `/fork` tại checkpoint, hoặc worktree mới |
| Task đã commit/PR | PR #45 đã 2 người review | Không | `git revert` / PR mới — checkpoint là local only |
| Agent cloud sai trên `copilot/*` | làm trái spec | Không | Comment redirect trên PR / close + delete branch |

Cột "Rewind?" là chốt hạ: chưa commit thì rewind càng sớm càng rẻ; đã commit/push thì mọi "undo" đi đường git (`git revert` / PR mới) — checkpoint không với tới. · 📄 [VS Code Docs: Recover unwanted changes](https://code.visualstudio.com/docs/agents/guides/get-agent-back-on-track#recover-unwanted-changes)

## 7. 6 gotchas vận hành (ai cũng vấp ít nhất 1 lần)

| Pitfall | Fix |
|---|---|
| Quên dọn worktree → 10 worktrees tồn, disk phình | Merge xong `remove` ngay; cuối tuần `git worktree list` quét 1 lượt |
| Untracked files / WIP không theo worktree | `git stash` hoặc commit trước khi tạo worktree từ branch khác |
| Dependencies chưa cài trong phòng mới | Vào worktree là `pnpm install --frozen-lockfile` (venv/pip tương tự) |
| `.env` + port đụng nhau giữa 2 worktree | Copy tay `.env` (KHÔNG commit), chạy `PORT=3001` ở phòng thứ 2 |
| Mở 2 worktrees trong 1 cửa sổ editor | Mỗi worktree 1 window riêng; window title theo `${rootName}` khỏi nhầm phòng |
| Agent đi sai mà vẫn argue 10 turn | Sai 2 lần → restore + chat mới, rẻ hơn argue cả bằng AI Credits lẫn buổi làm việc |

> 📄 **Code ví dụ:** [`./examples/11-git-worktrees-checkpoints/gotchas-pitfalls.sh`](./examples/11-git-worktrees-checkpoints/gotchas-pitfalls.sh) · 📄 [VS Code Docs: Git troubleshooting](https://code.visualstudio.com/docs/sourcecontrol/troubleshooting)

## Lỗi thường gặp (❌ SAI / ✅ ĐÚNG)

| ❌ SAI | Hệ quả | ✅ ĐÚNG |
|---|---|---|
| Coi checkpoint = commit ("undo được là an toàn") | Tắt máy / dọn cache IDE là mất mốc, bay cả phần đúng | Trước task dài: `git commit` một mốc tay — checkpoint chỉ là lưới phụ |
| Restore checkpoint xong tưởng deploy cũng hoàn tác | Service ngoài vẫn ở bản xấu, DB đã `new` mà code về `old` | Docs: checkpoint không đụng terminal/network/deploy — dùng git + recovery của dịch vụ |
| Tin "worktree = clone tốn disk gấp đôi" rồi né worktree | 2 session đè file nhau, conflict mỗi chiều | Worktree share `.git`, nhẹ hơn clone 5–10× — cứ ở phòng riêng |
| Push tay vào `copilot/*` của agent | Xung đột không truy vết được, agent ghi đè lại | Muốn sửa: comment trên PR, hoặc checkout branch mở PR riêng |

**Bài học:** công cụ nào đúng lớp công cụ đó — checkpoint cứu phiên, git cứu code, worktree cứu không gian, PR cứu quyền. · 📄 [VS Code Docs: Undo changes at the right scope](https://code.visualstudio.com/docs/agents/run/review-code-edits#undo-changes-at-the-right-scope)

## Best practices

- **Commit trước mỗi request mạo hiểm.** *Vì sao:* checkpoint là session state trên máy bạn; commit là code state bền — mắc lưới kép rẻ hơn mất trắng.
- **Task song song = worktree riêng, không ngoại lệ.** *Vì sao:* tách hội thoại không tách file — hai chat cùng folder vẫn sửa đè nhau (docs nhấn mạnh).
- **Sai 2 lần → restore + chat mới.** *Vì sao:* prompt sạch + context ngắn rẻ hơn 10 turn argue cả về AI Credits lẫn độ chính xác.
- **Gắn tên / khoanh phạm vi mốc trước khi fork.** *Vì sao:* session dài có nhiều mốc gần nhau, restore nhầm là xóa oan phần tốt (mục 2 — name a checkpoint). · 📄 [VS Code Docs: Clean up session worktrees](https://code.visualstudio.com/docs/agents/run/sessions/manage-sessions#clean-up-session-worktrees)

## Bài tập

1. **(10 phút)** Tạo 2 worktrees theo pattern A, chạy 2 task nhỏ song song, merge + dọn; verify `git worktree list` còn đúng 1 dòng.
2. **(5 phút)** Commit tay → giao agent 1 task nhỏ → hover request cũ chọn **Restore Checkpoint** → xác nhận `git status` về đúng mốc và các turn sau biến mất khỏi chat.
3. **(10 phút)** Fork tại checkpoint để thử hướng thứ 2 cho cùng bài toán; so 2 nhánh và chọn cái đáng merge.

## Link qua

- Fan-out / đa agent một máy → **bài 06** · Branch protection + rulesets → **bài 07** · Sandbox + permission levels (biên giới an toàn thật) → **bài 10/16** · Copilot cloud agent: assign, modes, environment → **bài 12**.
- [commands/copilot/chat-session/checkpoints](commands/copilot/chat-session/checkpoints/README.md) · [commands/copilot/chat-session/fork](commands/copilot/chat-session/fork/README.md) · [commands/cloud/model-agent/cloud-agent-session](commands/cloud/model-agent/cloud-agent-session/README.md) · Chat mới sạch sau rewind: [commands/copilot/chat-session/new-chat](commands/copilot/chat-session/new-chat/README.md).

## Reference

- VS Code — [Review & Revert Changes](https://code.visualstudio.com/docs/agents/run/review-code-edits) (Restore Checkpoint + giới hạn) · [Get an agent back on track](https://code.visualstudio.com/docs/agents/guides/get-agent-back-on-track) (automatic checkpoint, chọn recovery) · [Fork a chat session](https://code.visualstudio.com/docs/agents/run/sessions/manage-sessions#fork-a-chat-session) · [Branches, Stashes & Worktrees](https://code.visualstudio.com/docs/sourcecontrol/branches-worktrees) · [AI features cheat sheet](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet) (worktree *is not a security boundary*)
- GitHub — [Copilot CLI command reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference) (`copilot checkpoint restore`)

**Chốt:** worktree và checkpoint là hai tay của cùng một phản xạ — *cách ly trước khi chạy, quay lui ngay khi sai*; mốc tự động đã bật sẵn, nhưng thứ duy nhất không bay theo cache IDE vẫn là commit bạn tự giăng.
