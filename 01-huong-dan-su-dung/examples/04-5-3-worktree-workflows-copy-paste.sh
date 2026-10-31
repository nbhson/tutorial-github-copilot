# Pattern A — 2 features song song:
git fetch origin
git worktree add ../myrepo-worktrees/feat-a -b feat/a origin/main
git worktree add ../myrepo-worktrees/feat-b -b feat/b origin/main
# Window 1 (feat-a) Agent mode: "implement login rate-limit theo plan, chạy focused test"
# Window 2 (feat-b) Agent mode: "migrate users table thêm last_login_at, test local"
# Xong: review diff → commit → push → gh pr create → merge → dọn:
git worktree remove ../myrepo-worktrees/feat-a && git branch -d feat/a

# Pattern B — spike 2 phương án:
git worktree add ../myrepo-worktrees/spike-1 -b spike/option-1 origin/main
git worktree add ../myrepo-worktrees/spike-2 -b spike/option-2 origin/main
# Mỗi bên: implement + test + đo → giữ spike-2, bỏ spike-1:
git worktree remove --force ../myrepo-worktrees/spike-1
git branch -D spike/option-1 && git branch -m spike/option-2 feat/sessions
