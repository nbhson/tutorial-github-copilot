# Cài nếu chưa có:
gh extension install github/gh-copilot

gh copilot suggest "tìm file >100MB trong git history"
# Kỳ vọng: 1–2 lệnh cụ thể + giải thích flag
# Verify: chạy lệnh được gợi ý ở chế độ an toàn (--dry-run) thành công
# Lưu ý: gh copilot ≠ copilot (gh copilot là extension CLI, không phải lệnh copilot riêng)
