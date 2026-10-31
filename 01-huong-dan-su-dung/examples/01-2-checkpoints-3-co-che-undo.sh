# 3 cách xem "đã hỏng gì" trước khi quyết undo:
git diff HEAD -- src/auth/login.ts   # file này agent sửa gì chưa commit?
git diff --stat                      # scope phình chưa? (>5 files khi chỉ cần 2 = lan)
git log --oneline -5 -- src/auth/login.ts  # điểm restore nào an toàn?
