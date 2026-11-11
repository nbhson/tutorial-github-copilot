# .husky/pre-push (Recipe C, bai 07 muc 4): chan push thang branch goc.
#!/bin/sh
BRANCH="$(git rev-parse --abbrev-ref HEAD)"
if [ "$BRANCH" = "main" ] || [ "$BRANCH" = "master" ]; then
  echo "BLOCKED: khong push truc tiep main/master. Mo PR tu branch feat/*."
  exit 1
fi
exit 0
# Luu y: day la git hook LOCAL - van bi bo qua khi `git push --no-verify` hoac
# `git config core.hooksPath`. an toan tuyet doi van o Server (bai 14).
