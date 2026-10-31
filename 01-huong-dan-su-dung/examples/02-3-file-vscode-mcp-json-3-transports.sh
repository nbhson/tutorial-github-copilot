# Verify sau khi sửa mcp.json:
# 1. Ctrl+Shift+P → "MCP: List Servers" → servers phải Connected.
# 2. Chat: "@workspace liệt kê MCP tools mày đang thấy" → đọc được list.
# 3. Audit secrets (phải TRỐNG):
grep -rniE "ghp_|gho_|sk-|xox-|password\s*[:=]" .vscode/mcp.json; echo "exit=$? (1 = sạch, 0 = CÓ LỘ!)"
