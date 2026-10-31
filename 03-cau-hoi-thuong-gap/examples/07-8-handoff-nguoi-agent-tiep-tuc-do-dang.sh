# Nguoi tiep quan PR agent
gh pr checkout <NUM> && git log --oneline -5
# ... sua tiep ... git push

# Giao lai cho agent
gh pr comment <NUM> --body "@copilot fix loi lint o src/auth/login.ts dong 42"
