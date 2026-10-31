code --install-extension GitHub.copilot
code --install-extension GitHub.copilot-chat
# Verify: code --list-extensions | grep -i copilot ra đúng 2 dòng

gh extension install github/gh-copilot && gh copilot --help
# Verify: ra help, không phải "command not found"
