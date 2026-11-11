# Chuan bi issue NGON (agent chi gioi bang issue ban viet):
gh issue create --repo acme/api --title "feat: them rate-limit POST /login" --body "
## Muc tieu + Acceptance criteria
Them rate-limit 5 req/phut/IP cho POST /login.
- [ ] Qua 5 req/phut -> 429 + header Retry-After.
- [ ] Focused test pass: pnpm --filter @acme/api test rate-limit.

## Non-goals
- Khong doi co che auth, khong refactor module khac.
" --label "ready"

# Giao cho agent: mo issue -> sidebar Assign -> chon "Copilot" (hoac REST API assignees).
# KHONG co "gh copilot assign" - namespace "gh copilot" la extension cong dong, khong phai Copilot CLI.
# Theo doi: gh pr list --repo acme/api --author "app/copilot" --state open (PR draft copilot/issue-123-*)
