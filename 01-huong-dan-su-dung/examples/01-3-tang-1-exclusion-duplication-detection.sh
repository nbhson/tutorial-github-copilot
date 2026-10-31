# Verify exclusion sống (dev làm 1 lần, 2 phút):
# Chat: "@workspace tìm chuỗi STRIPE_KEY trong repo?" → phải "không thấy / excluded".
git check-ignore -v .env .env.prod secrets/ 2>/dev/null
# → phải ignored (exclusion + gitignore song kiêm, thiếu 1 là hở 1 đường).
git status --porcelain | grep -E "env|pem|key|secrets" || echo "sạch: không file nhạy cảm staged"
