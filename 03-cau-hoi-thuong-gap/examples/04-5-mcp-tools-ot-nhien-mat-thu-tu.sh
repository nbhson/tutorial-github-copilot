python3 -c "import json; json.load(open('.vscode/mcp.json')); print('JSON OK')"
echo ${GITHUB_MCP_TOKEN:+TOKEN_OK}
# Rồi: reload IDE -> View -> Output -> chon MCP server -> doc loi
