gh pr merge <NUM> --auto --squash --delete-branch
gh pr checks <NUM>
gh pr diff <NUM> --name-only | grep -Ei "migrations|infra|terraform" && echo "KHONG auto-merge" || echo "OK auto"
