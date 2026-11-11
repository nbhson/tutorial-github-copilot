#!/usr/bin/env bash
# Mo card Hooks trong Chat view (VS Code) va kiem hook duoc nap tu file.
# /hooks   # go vao o Chat - Copilot harness cung Local deu co
#
# Mot file hook toi thieu (dat tai .github/hooks/demo.json):
cat > /tmp/demo-hook.json <<'JSON'
{
  "version": 1,
  "hooks": {
    "preToolUse": [
      {
        "type": "command",
        "command": "./.github/hooks/demo.sh",
        "matcher": "Bash",
        "timeoutSec": 10
      }
    ]
  }
}
JSON
# Kiem cu phap JSON truoc khi dat vao repo:
jq . /tmp/demo-hook.json
# Hook phai thi hanh duoc, neu khong Copilot bo qua:
# chmod +x .github/hooks/demo.sh
# Khoi dong CLI in "! Invalid hook configuration in FILE: REASON" neu file sai schema.
