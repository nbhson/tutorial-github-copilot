gh api orgs/<ORG>/audit-log --jq '.[] | {action, actor, created_at}' | head -20
gh api "orgs/<ORG>/audit-log?phrase=action:copilot" --jq '.[] | {action, actor, created_at}'
gh api repos/<OWNER>/<REPO>/events --jq '.[] | {type, actor: .actor.login, created_at}' | head -20
