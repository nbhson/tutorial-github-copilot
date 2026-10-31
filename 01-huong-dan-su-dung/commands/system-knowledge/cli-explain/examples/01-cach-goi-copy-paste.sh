# Cài nếu chưa có:
gh extension install github/gh-copilot

gh copilot explain "docker run -p 5432:5432 postgres"
# Kỳ vọng: giải thích từng flag + rủi ro trước khi Enter
# Verify: nói lại được "lệnh này làm gì + rủi ro gì"
# Lưu ý: gh copilot ≠ copilot (gh copilot là extension CLI, không phải lệnh copilot riêng)
