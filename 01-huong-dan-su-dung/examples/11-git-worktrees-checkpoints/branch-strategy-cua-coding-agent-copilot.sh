# Theo dõi + review coding agent:
git fetch origin
git branch -r | grep "copilot/"                     # agent đang làm branches nào?
gh pr list --repo acme/api --author "app/copilot" --state open
gh pr view 45 --json title,headRefName,reviews,state --jq .

# Checkout PR về local để test (KHÔNG sửa trên branch của nó):
gh pr checkout 45 --branch review-45
pnpm install --frozen-lockfile && pnpm test

# Dọn sau merge:
git branch -d feat/my-done-task
git worktree remove ../api-worktrees/feat-my-done-task
git worktree prune && git worktree list             # Verify: sạch
