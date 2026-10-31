# Setup bằng gh CLI (chạy 1 lần/repo — cần admin):
gh api repos/{owner}/{repo}/branches/main/protection -X PUT \
  -H "Accept: application/vnd.github+json" \
  -f required_status_checks[strict]=true \
  -f required_status_checks[contexts][]="lint" \
  -f required_status_checks[contexts][]="test" \
  -f enforce_admins=true \
  -f required_pull_request_reviews[required_approving_review_count]=1 \
  -f required_pull_request_reviews[dismiss_stale_reviews]=true \
  -f restrictions=null \
  -f allow_force_pushes=false \
  -f allow_deletions=false

# Verify:
gh api repos/{owner}/{repo}/branches/main/protection --jq '{enforce_admins, allow_force_pushes}'
# Kỳ vọng: enforce_admins.enabled=true, allow_force_pushes.enabled=false
