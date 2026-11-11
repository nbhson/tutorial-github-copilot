code --list-extensions | grep -i copilot
# Verify: ra đúng 2 dòng (GitHub.copilot + GitHub.copilot-chat), thêm = conflict
code --uninstall-extension <ten-la>   # gỡ bản lạ

gh --version && gh extension list | grep copilot
# Verify: gh ra số version, extension list có "github/gh-copilot"
