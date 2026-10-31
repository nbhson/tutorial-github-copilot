gh issue create --title "feat(auth): them rate-limit login" \
  --body "Phạm vi: src/auth/**. Xong khi: npm test -- auth xanh + test 429." \
  -l "copilot"
gh pr list --author "app/copilot" --state open
