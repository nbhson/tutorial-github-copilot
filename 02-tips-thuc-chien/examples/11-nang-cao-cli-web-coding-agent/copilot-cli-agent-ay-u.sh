# Cài: npm install -g @github/copilot (yêu cầu Node 22+)
# Đăng nhập lần đầu: /login

copilot                        # Interactive: hỏi từng tool (Shift+Tab xoay chế độ)
copilot --plan "refactor auth" # Plan trước, duyệt rồi mới code
copilot -p "fix test đỏ ở packages/api, chỉ 2 files"   # Non-interactive, xong là exit
copilot --plan --mode autopilot "task có plan rõ"      # Plan-then-autopilot
