# 1. Validate JSON (lỗi dấu phẩy = nguyên nhân #1)
python3 -c "import json; json.load(open('.vscode/mcp.json')); print('JSON OK')"

# 2. Test stdio server chạy tay được không
npx -y @modelcontextprotocol/server-github --help 2>&1 | head -5

# 3. Test SSE server
curl -s -m 10 -o /dev/null -w "%{http_code}\n" https://mcp.internal.company.com/health
