# 1. Revoke/rotate TREN DASHBOARD provider (Stripe/GitHub/AWS...) - lam ngay

# 2. Xoa file khoi tracking + commit moi
git rm --cached secrets/leaked.key
echo "secrets/" >> .gitignore
git commit -m "chore(security): remove leaked secret, rotated key"

# 3. Quet ca history xem con sot khong
gitleaks detect --verbose
gh api repos/<OWNER>/<REPO>/secret-scanning/alerts --jq '.[] | {secret_type, state}'
