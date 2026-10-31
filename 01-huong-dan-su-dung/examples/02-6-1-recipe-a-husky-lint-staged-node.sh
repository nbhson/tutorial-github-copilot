# Cài (1 lần):
pnpm add -D husky lint-staged prettier eslint
pnpm exec husky init   # → tạo .husky/pre-commit

# .husky/pre-commit (chmod +x, commit cho team):
#!/bin/sh
. "$(dirname "$0")/_/husky.sh"
pnpm exec lint-staged

# Test: commit file "const x=1" → phải auto-format hoặc fail nếu lint lỗi.
