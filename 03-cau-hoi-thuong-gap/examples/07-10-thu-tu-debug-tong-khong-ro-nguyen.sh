gh auth status
curl -s -m 10 -o /dev/null -w "api:%{http_code}\n" https://api.github.com
gh --version; code --version && code --list-extensions --show-versions | grep -i copilot
