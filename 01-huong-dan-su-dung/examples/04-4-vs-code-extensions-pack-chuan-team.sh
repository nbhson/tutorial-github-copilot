# Cài pack từ CLI (onboarding máy mới):
cat .vscode/extensions.json | jq -r '.recommendations[]' | while read -r ext; do
  code --install-extension "$ext"
done
code --list-extensions | grep -i "copilot\|eslint\|prettier"  # verify
# Kỳ vọng: list hiện đủ copilot + eslint + prettier. Thiếu → cài tay ID đó.
