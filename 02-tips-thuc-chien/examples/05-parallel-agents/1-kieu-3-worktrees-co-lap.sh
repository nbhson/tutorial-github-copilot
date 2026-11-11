# Tạo 2 worktrees từ main
git worktree add ../proj-auth feature/auth-fix
git worktree add ../proj-cart feature/cart-fix

# Mở mỗi worktree 1 cửa sổ VS Code riêng
code ../proj-auth
code ../proj-cart
