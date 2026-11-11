#!/usr/bin/env bash
# Bai 15 - muc 5 + 6: Rulesets cho auto code review va chan merge (mau thuc hanh).
# Docs GitHub dung RULESET de cau hinh auto-review ("Review new pushes" nam trong
# ruleset settings); schema duoi day la mau de dan - KIEM LAI bang `gh api`
# va doc trang About rulesets truoc khi ap dung that cho org.
# Chay tung khoi mot; thay ORG/REPO cua ban vao bien.

ORG="<org>"
REPO="<repo>"

# ---------------------------------------------------------------------------
# KHOI 1: pull_request_checks - PR phai qua gi truoc khi merge?
#   - >= 1 approve nguoi (payments/auth: nang len 2)
#   - dismiss khi co push sau approve (chong "duyet ban cu, merge ban moi")
#   - status checks bat buoc: CodeQL + tests (ten context lay tu tab Checks)
# ---------------------------------------------------------------------------
cat > /tmp/ruleset-pull-request-checks.json <<'JSON'
{
  "name": "security-stack-pull-request-checks",
  "target": "branch",
  "source_type": "Repository",
  "enforcement": "active",
  "conditions": {
    "ref_name": { "exclude": [], "include": ["~DEFAULT_BRANCH"] }
  },
  "rules": {
    "pull_request": {
      "required_approving_review_count": 1,
      "dismiss_stale_reviews_on_push": true,
      "require_code_owner_review": false,
      "require_last_push_approval": true,
      "required_status_checks": [
        { "context": "security/code-scanning", "integration_id": null },
        { "context": "ci/test", "integration_id": null }
      ],
      "required_check_rollup": []
    }
  },
  "node_id": null
}
JSON

gh api "repos/${ORG}/${REPO}/rulesets" \
  --method POST \
  --input /tmp/ruleset-pull-request-checks.json
# Verify: mo mot PR nho -> tab Checks lien ket (Required) phai liet ke du 2 context tren.

# ---------------------------------------------------------------------------
# KHOI 2: bypass_list - AI duoc di tat (va chi ho moi duoc)?
# Nguyen tac: cang ngan cang tot; moi dong phai co ten + ly do ghi trong
# tai lieu team. "Admins" da du - dung them app bot vao day neu bot
# khac da co quyen qua ruleset khac.
# ---------------------------------------------------------------------------
gh api "repos/${ORG}/${REPO}/rulesets" --method GET --jq '.[] | {id, name}'
# Lay id o tren, roi:
RULESET_ID="<id-tu-buoc-tren>"
gh api "repos/${ORG}/${REPO}/rulesets/${RULESET_ID}" --method PATCH \
  --field 'bypass_actors=[{"actor_type":"OrganizationAdmin","actor_id":1,"bypass_mode":"always"}]'
# actor_type thong dung: RepositoryAdmin, OrganizationAdmin, App, DeployBranch.
# Xuat khoi "bypass cho quen": actor_id 1 la hang so to chuc cho nhom admin.

# ---------------------------------------------------------------------------
# KHOI 3 (tuy chon): gan auto-review cho NHIEU repo cung luc o cap ORG.
# Org-level ruleset ap den toan org thay vi sua tung repo; muon re-review
# moi push thi chon "Review new pushes" trong phan ruleset settings khi tao
# ruleset tu dong yeu cau Copilot review.
# ---------------------------------------------------------------------------
gh api "orgs/${ORG}/rulesets" \
  --method POST \
  --field 'name=auto-review-all-repos' \
  --field 'target=branch' \
  --field 'enforcement=active' \
  --field 'conditions={ "ref_name": { "exclude": [], "include": [ "~ALL" ] } }'
# Sau do bat auto-review + dat default effort (Lite/Balanced/Max) tai man hinh
# Settings -> Copilot -> Code review cua org (URL o bai 15, muc 7).

# ---------------------------------------------------------------------------
# DOI CHIEU NHANH (bai 15):
#   pull_request_checks = "PR phai qua gi"   -> tang 3 + 4 (review + checks)
#   bypass_list         = "ai duoc di tat"  -> tang 5 (audit ghi ten nguoi tat)
# Quy tac: xoa/den rule ma khong co entry trong audit log = rule do chet am tham.
# ---------------------------------------------------------------------------
