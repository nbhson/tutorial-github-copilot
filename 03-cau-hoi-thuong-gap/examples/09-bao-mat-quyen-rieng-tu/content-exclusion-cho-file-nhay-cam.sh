# Audit: file nhay cam nao dang bi git track?
git ls-files | grep -Ei "pem$|key$|\.env$|credentials|secrets" || echo "OK: khong co"

# Co -> go ngay (roi xoay key theo cau 3)
git rm --cached <file> && echo "<file>" >> .gitignore && git commit -m "chore(security): untrack sensitive file"
