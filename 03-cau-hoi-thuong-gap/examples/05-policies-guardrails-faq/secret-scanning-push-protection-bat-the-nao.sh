gh api repos/<OWNER>/<REPO>/secret-scanning/alerts --jq '.[] | {number, secret_type, state}'
# Verify: state "open" = còn secret lộ

# Lỡ commit secret: 1. Revoke/rotate trên dashboard provider (trước!)  2. Xóa file
git rm --cached secrets/leaked.key && git commit -m "chore: remove leaked secret"
