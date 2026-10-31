# Audit log (giữ 180 ngày, KHÔNG chứa prompt/session data của client):
# action:copilot         → umbrella: plan/settings/policy/license + agent activity
# action:copilot_policy  → ai đổi exclusion/model policy
# action:secret_scanning → ai dismiss alert (dismiss bừa = red flag)
# action:code_scanning   → ai dismiss CodeQL
gh api /orgs/<ORG>/audit-log --paginate -f per_page=100 \
  -f phrase="action:copilot_policy OR action:secret_scanning" \
  --jq '.[] | [.actor, .action, .created_at] | @tsv' > /tmp/sec-audit.tsv
# → pivot: ai dismiss nhiều nhất? policy đổi lúc nửa đêm? (hỏi 1 câu là ra chuyện)
