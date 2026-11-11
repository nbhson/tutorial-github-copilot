#!/usr/bin/env bash
# Incident: PR doi .github/workflows/release.yml merge luc 2:17 sang, khong ai nhan.
# Dieu tra 3 buoc bang audit log. (Thay ORG/REPO/NGAY cho phu hop.)
ORG="${1:-my-org}"
REPO="${2:-my-org/my-repo}"
FROM="${3:-$(date -v-1d +%Y-%m-%d 2>/dev/null || date -d yesterday +%Y-%m-%d)}"

# Buoc 1: moi hoat dong Copilot lien quan repo trong khung nghi van
echo "== events Copilot tren ${REPO} =="
gh api --paginate "/orgs/${ORG}/audit-log" \
  -X GET -f "query=actor:Copilot repo:${REPO} created:>${FROM}" \
  -q '.[] | [."@timestamp", .action, (.user // .actor)] | @tsv'

# Buoc 2: gom event cung mot phien agent (agent_session_id noi cac dong lai)
echo "== agent sessions =="
gh api --paginate "/orgs/${ORG}/audit-log" \
  -X GET -f "query=actor:Copilot created:>${FROM}" \
  -q '.[] | select(.agent_session_id) | [.agent_session_id, .["@timestamp"], .action, (.user // .actor)] | @tsv' | sort

# Buoc 3: doi chieu ai approve/merge trong repo (audit log cap repo)
echo "== merge/approve trong repo =="
gh api --paginate "/orgs/${ORG}/audit-log" \
  -X GET -f "query=repo:${REPO} created:>${FROM}" \
  -q '.[] | select(.action as $a | ($a|test("merge|approve|review"))) | [."@timestamp", .action, (.user // .actor)] | @tsv'

# Ghi chu:
# - Audit log ghi sieu du lieu (ai/luc/repo), KHONG ghi noi dung prompt.
# - Muon bang chung cho auditor: xuat /tmp CSV roi gan vao ticket.
