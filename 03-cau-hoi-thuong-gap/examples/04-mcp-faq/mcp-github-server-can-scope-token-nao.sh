# github.com/settings/tokens -> Fine-grained -> chọn repo ->
# Contents: Read, Issues: Read, PRs: Read/Write
export GITHUB_MCP_TOKEN="github_pat_xxxx"
gh api --header "Authorization: token $GITHUB_MCP_TOKEN" user
# Verify: ra đúng account
