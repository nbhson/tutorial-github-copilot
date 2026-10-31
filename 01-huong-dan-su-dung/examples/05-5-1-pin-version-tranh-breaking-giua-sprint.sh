# Cài version cụ thể (không lấy latest mù):
code --install-extension github.copilot-chat@0.26.0
code --install-extension dbaeumer.vscode-eslint@3.0.0

# Xem versions đã cài:
code --list-extensions --show-versions | grep -i "copilot\|eslint"

# Update có kiểm soát (cuối sprint, không giữa sprint):
code --list-extensions | xargs -I{} code --install-extension {} --force
# → test 1 ngày trên repo thử trước khi announce team.
