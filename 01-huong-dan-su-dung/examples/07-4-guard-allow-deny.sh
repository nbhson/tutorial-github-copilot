#!/usr/bin/env bash
# Lop bao ve khi agent dung tool: allowlist lenh + tool MCP ghi, exit 2 = chan.
# Chay demo (can jq): bash examples/07-4-guard-allow-deny.sh
# Script tao 2 file: hooks/guard.sh (logic) va .github/hooks/guard.json (dang ky hook).
set -euo pipefail

mkdir -p hooks .github/hooks

cat > hooks/guard.sh <<'HOOK'
#!/usr/bin/env bash
# preToolUse: allowlist lenh + tool; exit 2 = chan, ly do gui ve agent.
input="$(cat -)"

# Matcher ap dung Bash/Shell, moi tool MCP, lenh chay lenh cua CLI khac.
command="$(printf '%s' "$input" | jq -r '.tool_input.command // .command // empty')"
case "$command" in
  *rm\ -rf*|*sudo*|*curl*'|'*sh)
    printf 'Lenh nguy hiem bi chan boi allowlist cua team.\n' >&2
    exit 2
    ;;
esac

# Tool MCP ghi ra ben ngoai (ticket, deploy): deny che do ask o day (cloud khong ho tro ask).
toolName="$(printf '%s' "$input" | jq -r '.toolName // .tool_name // empty')"
if [[ "$toolName" == mcp__* ]]; then
  case "$toolName" in
    *_create_*|*_update_*|*_delete_*)
      printf 'Tool MCP ghi duoc phep khi nguoi dung duyet, khong tu dong.\n' >&2
      exit 2
      ;;
  esac
fi

# Khong in gi ra stdout: them dieu kien khong chan them.
exit 0
HOOK
chmod +x hooks/guard.sh

# Hook config cho copilot CLI va Copilot trong cloud (chi JSON duoc Cloud doc).
mkdir -p .github/hooks
cat > .github/hooks/guard.json <<'JSON'
{
  "version": 1,
  "hooks": {
    "preToolUse": [
      {
        "matcher": "^(?:Bash|Shell|mcp__.*)$",
        "hooks": [
          { "type": "command", "command": "./hooks/guard.sh", "timeout": 10 }
        ]
      }
    ]
  }
}
JSON

echo "== Kiem thu: pipe payload qua hook =="
for payload in \
  '{"toolName":"Bash","tool_input":{"command":"rm -rf /"}}' \
  '{"toolName":"Bash","tool_input":{"command":"npm test"}}' \
  '{"toolName":"mcp__jira__create_issue","tool_input":{}}'; do
  if printf '%s' "$payload" | ./hooks/guard.sh; then
    echo "OK   : ${payload}"
  else
    echo "DENY : ${payload}"
  fi
done

echo
echo "== Cat hook trong phien: /hooks (CLI) hoac xem .github/hooks/ (repo) =="
