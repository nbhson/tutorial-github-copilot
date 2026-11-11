# 1. Untracked files không theo worktree — WIP chưa commit ở main KHÔNG sang:
git stash push -m "wip-main" && git worktree add ../myrepo-worktrees/feat-x -b feat/x

# 2. Dependencies phải cài lại mỗi worktree:
cd ../myrepo-worktrees/feat-x && pnpm install --frozen-lockfile
# (python: python -m venv .venv && pip install -r requirements.txt)

# 3. Env files + ports đụng nhau (.env thường untracked — copy tay, KHÔNG commit):
cp /path/to/main/.env ../myrepo-worktrees/feat-x/.env
PORT=3001 pnpm dev   # worktree A :3000, worktree B :3001

# 4. Đừng mở 2 worktrees trong 1 window — mỗi worktree 1 window riêng:
#    "window.title": "${rootName} — ${activeEditorShort}"
