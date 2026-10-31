gitleaks detect --verbose
git ls-files | grep -Ei "pem$|key$|\.env$|credentials|secrets" || echo "OK: khong track file nhay cam"
gh api repos/<OWNER>/<REPO>/secret-scanning/alerts --jq '[.[] | select(.state=="open")] | length'
# Verify: 0 alert open + "OK" mới public
