# Admin: xem ai đang giữ seat
gh api orgs/<ORG>/copilot/billing/seats --jq '.seats[] | {login: .assignee.login, plan}'
# Assign seat cho 1 team
gh api -X POST orgs/<ORG>/copilot/billing/selected_teams -f selected_teams='["team-slug"]'
# Verify: list ra login + plan; dev trong team thấy Copilot chạy
