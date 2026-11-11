git checkout main
git merge feature/auth-fix --no-ff -m "merge: auth fix (verified)"
npm test -- auth
git merge feature/cart-fix --no-ff -m "merge: cart fix (verified)"
npm test
git worktree remove ../proj-auth
git worktree remove ../proj-cart
