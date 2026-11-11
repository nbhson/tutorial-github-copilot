# Verify qua API (token cần quyền Copilot thích hợp):
curl -s -H "Authorization: Bearer <TOKEN>" https://api.github.com/copilot/spaces | head -20
# 401/403 -> token sai scope / không có license / org chặn
