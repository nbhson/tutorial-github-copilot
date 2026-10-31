# Tạo (branch mới từ HEAD):
git worktree add ../myrepo-worktrees/feat-login -b feat/login
# Verify: git worktree list → thêm 1 dòng "feat-login [feat/login]"

# Tạo từ main mới nhất:
git fetch origin
git worktree add ../myrepo-worktrees/feat-pay -b feat/pay origin/main

# Mở session trong worktree (1 window = 1 branch):
code ../myrepo-worktrees/feat-login
# Verify: title window hiện "feat-login".

# Dọn sau merge:
git worktree remove ../myrepo-worktrees/feat-login          # worktree sạch
git worktree remove --force ../myrepo-worktrees/feat-login  # có changes chưa commit (cẩn thận!)
git worktree prune                                           # dọn metadata xóa tay
# Verify: git worktree list → mất dòng feat-login.
