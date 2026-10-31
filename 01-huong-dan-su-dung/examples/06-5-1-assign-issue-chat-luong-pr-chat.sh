# Chuẩn bị issue NGON (agent chỉ giỏi bằng issue bạn viết):
gh issue create --repo acme/api --title "feat: thêm rate-limit POST /login" --body "
## Mục tiêu + Acceptance criteria
Thêm rate-limit 5 req/phút/IP cho POST /login.
- [ ] Quá 5 req/phút → 429 + header Retry-After.
- [ ] Focused test pass: pnpm --filter @acme/api test rate-limit.

## Non-goals
- Không đổi cơ chế auth, không refactor module khác.
" --label "ready"

# Giao cho agent (CLI hoặc web "Assign to Copilot"):
gh copilot assign 123 --repo acme/api
# Theo dõi: gh pr list --repo acme/api --author "app/copilot" --state open (PR draft copilot/issue-123-*)
