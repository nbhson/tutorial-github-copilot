# Test push protection (secret giả, trên branch feat/*):
echo 'GITHUB_TOKEN="ghp_fake1234567890123456789012345678901234"' > leak-test.txt
git add leak-test.txt && git commit -m "test" && git push origin feat/test
# Kỳ vọng: push bị BLOCK với message "Push protection". Dọn: git reset HEAD~1 && rm leak-test.txt
