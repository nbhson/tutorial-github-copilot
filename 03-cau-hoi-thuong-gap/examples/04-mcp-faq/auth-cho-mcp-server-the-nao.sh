# Cách đúng: token trong env, mcp.json chỉ tham chiếu
export GITHUB_MCP_TOKEN="ghp_xxxx"   # ~/.zshrc, mở IDE từ terminal để hứng env
# mcp.json: "env": { "GITHUB_PERSONAL_ACCESS_TOKEN": "${env:GITHUB_MCP_TOKEN}" }

# Quét repo xem có ai hardcode:
grep -rn "ghp_\|sk-\|xoxb-" .vscode/mcp.json .github/ 2>/dev/null
# Verify: rỗng = sạch; ra dòng thì sửa + rotate token
