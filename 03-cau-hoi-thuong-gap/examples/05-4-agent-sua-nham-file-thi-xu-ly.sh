# Xem agent đã sửa gì
git status --short && git diff --stat
# Verify: chỉ ra file bạn muốn, file khác = agent sửa lan

# Hoàn tác 1 file / tất cả (cẩn thận: stash mất cả change đúng)
git checkout -- src/wrong-file.ts
git stash -u
