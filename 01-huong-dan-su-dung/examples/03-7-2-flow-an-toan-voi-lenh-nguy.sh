# NGUYÊN TẮC: explain trước, chạy sau. Đặc biệt với rm/find/docker prune.
gh copilot explain "find . -type f -name '*.log' -mtime +7 -delete"
# Đọc kỹ: đúng folder không? có -delete nhầm không?
find . -type f -name '*.log' -mtime +7 | head   # chạy khô trước
# Đúng mới chạy thật (bỏ | head, thêm -delete).
