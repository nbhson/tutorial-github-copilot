gh copilot suggest “xóa branch đã merge trừ main/develop”
# Đọc lệnh + giải thích flag → chạy thử bản an toàn trước:
#   git branch --merged | grep -v ... | xargs git branch -d   # -d (không -D) để không xóa branch chưa merge
