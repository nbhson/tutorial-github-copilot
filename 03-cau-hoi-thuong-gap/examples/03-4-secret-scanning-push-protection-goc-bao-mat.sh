# Uu tien alert con 'active'
gh api repos/<OWNER>/<REPO>/secret-scanning/alerts \
  --jq '.[] | select(.state=="open") | {number, secret_type, validity}'

# Dong alert sau khi da xoay key
gh api repos/<OWNER>/<REPO>/secret-scanning/alerts/<N> -X PATCH -f state='resolved'
