#!/usr/bin/env bash
# Vi du that: hook chan lenh rm -rf truoc khi tool bash chay (preToolUse).
# Dat 2 file trong repo: .github/hooks/guard.json + .github/hooks/guard.sh

mkdir -p .github/hooks
cat > .github/hooks/guard.json <<'JSON'
{
  "version": 1,
  "hooks": {
    "preToolUse": [
      {
        "type": "command",
        "command": "./.github/hooks/guard.sh",
        "matcher": "Bash",
        "timeoutSec": 5
      }
    ]
  }
}
JSON

cat > .github/hooks/guard.sh <<'SH'
#!/usr/bin/env bash
# Doc payload JSON tu stdin, tim truong lenh
payload="$(cat)"
if printf '%s' "$payload" | grep -Eq 'rm[[:space:]]+-[rf]+[[:space:]]+/'; then
  # exit 2 = deny (quy tac docs cho preToolUse/permissionRequest)
  echo "Blocked by guard hook: destructive rm command" >&2
  exit 2
fi
exit 0   # exit 0 = cho qua
SH
chmod +x .github/hooks/guard.sh

# Test tay, khong can mo agent:
echo '{"tool":"Bash","command":"rm -rf /tmp/whatever"}' | ./.github/hooks/guard.sh
echo "exit=$? (ky vong 2 = chan)"
echo '{"tool":"Bash","command":"ls -la"}' | ./.github/hooks/guard.sh
echo "exit=$? (ky vong 0 = cho qua)"
# Sau do mo Chat view, go /hooks: guard phai xuat hien trong danh sach nap.
