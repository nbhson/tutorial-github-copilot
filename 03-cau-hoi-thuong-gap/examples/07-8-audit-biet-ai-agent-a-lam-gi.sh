git log --format='%h %an %s' -20 | grep -i "bot\|copilot"
gh api orgs/<ORG>/audit-log --jq '.[] | {action, actor, created_at}' | head -20
# Verify: list commit + hành động, actor = ai
