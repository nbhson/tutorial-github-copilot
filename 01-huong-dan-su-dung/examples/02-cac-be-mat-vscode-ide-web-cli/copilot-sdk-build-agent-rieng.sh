export GITHUB_TOKEN="$(gh auth token)"   # Verify: gh auth token trả về token
npx tsx examples/copilot-review.ts
# Kỳ vọng: terminal in 5–10 dòng findings checklist.
# Thử prompt "xóa hết files" → SDK trả từ chối (allowlist hẹp), KHÔNG chạy shell.
