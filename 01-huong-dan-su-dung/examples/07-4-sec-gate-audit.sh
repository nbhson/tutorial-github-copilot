#!/usr/bin/env bash
# Kiem tra lop guardrail ngoai le: secret scanning, push protection, audit log review cua Copilot, allowlist extension toan org.
# Chay (can gh da login + jq): bash examples/07-4-sec-gate-audit.sh [owner/repo]
# Test push protection o cuoi la thu cong (co xuong branch that) - script in lenh, khong tu push.
set -euo pipefail

REPO="${1:-$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null || true)}"
if [[ -z "$REPO" ]]; then
  echo "Chay: bash examples/07-4-sec-gate-audit.sh <owner/repo> (sau khi gh auth login)"; exit 1
fi

echo "== 1. Secret scanning + push protection bat chua? =="
gh api "repos/$REPO" -q '{
  secret_scanning: .security_and_analysis.secret_scanning.status,
  push_protection: .security_and_analysis.secret_scanning_push_protection.status,
  private_vuln_reporting: .security_and_analysis.private_vulnerability_reporting.status
}'

echo
echo "== 2. Branch protection: copilot-review co phai blocking check? =="
gh api "repos/$REPO/branch-protection" --fail 2>/dev/null \
  | jq '{required_status_checks: .required_status_checks.contexts,
         required_approvals: .required_pull_request.required_approvals_on_creation}' \
  || echo "Chua bat branch protection - khoi dong tu Settings > Branches."

echo
echo "== 3. Policy hooks toan org (chi admin doc duoc) =="
gh api /settings/managed-settings -q '.new_copy | fromjson | keys' 2>/dev/null \
  || echo "Can quyen org admin de doc managed-settings.json."

echo
echo "== 4. Allowlist extension tren may ban (moi thang) =="
code --list-extensions --show-versions > /tmp/exts.txt
echo "Da ghi /tmp/exts.txt. So voi allowlist wiki team; ngoai list + khong ai nhan -> code --uninstall-extension <id>"

echo
echo "== 5. Test push protection TU THONG (chay tung dong tren branch test) =="
cat <<'EOF'
  echo 'GITHUB_TOKEN="ghp_fake1234567890123456789012345678901234"' > leak-test.txt
  git add leak-test.txt && git commit -m "test push protection" && git push origin HEAD
  # Ky vong: push bi chan voi message "Push protection". Don:
  # git reset HEAD~1 && rm leak-test.txt
EOF
