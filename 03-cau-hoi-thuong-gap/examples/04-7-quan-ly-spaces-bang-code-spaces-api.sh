curl -s -X POST -H "Authorization: Bearer <TOKEN>" \
  -H "Accept: application/vnd.github+json" \
  https://api.github.com/copilot/spaces \
  -d '{"title":"Dự án billing","description":"Context cho team billing"}'

# Chi tiết đầy đủ: docs.github.com -> REST API -> Copilot -> Spaces
