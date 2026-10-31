# Phòng bệnh local: pre-commit hook khung (.git/hooks/pre-commit, chmod +x):
git diff --cached --name-only | xargs grep -n -i -E "sk-live|ghp_|AKIA|xoxb-|-----BEGIN .*PRIVATE KEY" && {
  echo "BLOCKED: nghi secret staged — doi sang env truoc khi commit"; exit 1; }
