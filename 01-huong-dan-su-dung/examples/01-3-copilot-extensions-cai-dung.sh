# Kiểm tra extensions đã cài cho org (cần admin):
gh api orgs/{org}/installations --jq '.installations[] | {app: .app.slug, repo_selection}'
gh api orgs/{org}/installations/{id}/repositories --jq '.repositories[] | .full_name'
# Verify: app.slug có tên extension? repo_selection gồm repo bạn? Không → admin chưa cấp.
