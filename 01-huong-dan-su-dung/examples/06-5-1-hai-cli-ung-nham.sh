# Cài Copilot CLI (agent GA 03/2026):
npm install -g @github/copilot
copilot --version
# Login đúng GitHub account có subscription Copilot trả phí.

# Cài gh + gh-copilot (extension suggest/explain):
brew install gh          # hoặc: sudo apt install -y gh; Windows: https://cli.github.com/
gh auth login            # chọn đúng account trước khi cài extension
gh extension install github/gh-copilot
gh extension upgrade github/gh-copilot   # update khi có bản mới
gh copilot --help        # kỳ vọng: hiện suggest/explain
