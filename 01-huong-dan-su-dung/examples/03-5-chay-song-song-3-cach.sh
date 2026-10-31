# Quy ước branch cho parallel (tránh giẫm — chi tiết bài 11):
git worktree add ../api-wt/feat-billing -b feat/billing origin/main  # session 2
git worktree list   # xác nhận mỗi session 1 checkout riêng
# Chung branch → conflict chắc chắn, không phải "có thể".
