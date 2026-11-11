gh pr view <NUM> --json title,state,mergeable,statusCheckRollup && gh pr checks <NUM>

# Giai conflict don gian
gh pr checkout <NUM> && git fetch origin && git rebase origin/main && git push --force-with-lease
