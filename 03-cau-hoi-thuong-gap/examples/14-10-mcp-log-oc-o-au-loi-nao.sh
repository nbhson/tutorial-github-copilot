# Kiểm nhanh 3 thứ trước khi đọc log sâu
node --version; npx --version
echo ${GITHUB_MCP_TOKEN:+TOKEN_OK}
python3 -c "import json; json.load(open('.vscode/mcp.json')); print('JSON OK')"
