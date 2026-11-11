#!/usr/bin/env bash
# Loc event Copilot trong audit log cua org (can quyen admin:org).
ORG="${1:-my-org}"
NGAY="${2:-$(date -v-7d +%Y-%m-%d 2>/dev/null || date -d '7 days ago' +%Y-%m-%d)}"

# 1) Kiem quyen truoc:
gh auth status || { echo "Chua login gh CLI"; exit 1; }

# 2) Event Copilot 7 ngay gan nhat, tat machine-readable (khong co dong banner):
gh api --paginate "/orgs/${ORG}/audit-log" \
  -X GET -f "query=actor:Copilot created:>${NGAY}" \
  -q '.[] | "\(.["@timestamp"] // .created_at)  \(.action)  user=\(.user // .actor)  repo=\(.repo // "-")"' \
  > /tmp/copilot_audit.tsv
echo "Da xuat $(wc -l < /tmp/copilot_audit.tsv) dong -> /tmp/copilot_audit.tsv"

# 3) Dem theo loai event (san sang thanh chu thuat):
cut -f2 /tmp/copilot_audit.tsv | sort | uniq -c | sort -rn

# 4) Export day du CSV cho bao cao (thieu file: dung jq + flat hoa):
gh api --paginate "/orgs/${ORG}/audit-log" \
  -X GET -f "query=actor:Copilot" \
  -q '.[] | [@timestamp, .action, (.user // .actor), .repo, .agent_session_id] | @csv' > /tmp/copilot_audit.csv
