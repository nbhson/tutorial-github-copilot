ls .github/copilot-instructions.md .vscode/settings.json .vscode/mcp.json
grep -rn "ghp_\|sk-live\|xoxb-" .vscode/ .github/ 2>/dev/null && echo "CO SECRET HARDCODE!" || echo "secrets OK"
gh api repos/<OWNER>/<REPO>/rulesets --jq '.[].name'
# Verify: đủ 3 file + "secrets OK" + ruleset protect-main
