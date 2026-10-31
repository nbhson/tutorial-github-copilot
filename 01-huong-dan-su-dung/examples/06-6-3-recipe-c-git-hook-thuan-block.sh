# .husky/pre-push:
#!/bin/sh
BRANCH="$(git rev-parse --abbrev-ref HEAD)"
if [ "$BRANCH" = "main" ] || [ "$BRANCH" = "master" ]; then
  echo "BLOCKED: không push trực tiếp main/master. Mở PR từ branch feat/*."; exit 1
fi
exit 0
# An toàn tuyệt đối vẫn là lớp 5 (server) — hook local có thể bị --no-verify bỏ qua.
