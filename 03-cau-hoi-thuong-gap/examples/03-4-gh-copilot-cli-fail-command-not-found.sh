gh --version && gh extension list | grep -i copilot || gh extension install github/gh-copilot
gh auth status && gh copilot suggest "list files by size" --no-interactive
