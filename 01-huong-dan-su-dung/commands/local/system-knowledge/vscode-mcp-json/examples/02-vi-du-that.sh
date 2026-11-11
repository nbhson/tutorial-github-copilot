# Vi du that: server doc DB staging chay ngon o session Local; team chuyen sang
# Copilot harness thi "mat tool DB". Nguyen nhan: Copilot khong doc .vscode/mcp.json.

# Buoc 0 - xac nhan benh:
#   Mo session Copilot harness, hoi "liet ke MCP servers ban thay duoc"
#   -> my-db khong xuat hien, du no van trong .vscode/mcp.json

# Buoc 1 - tao .mcp.json o ROOT repo (luc nay Copilot moi doc):
#   {"mcpServers": {"my-db": {"command": "npx", "args": ["-y", "db-mcp"],
#     "env": {"DSN": "<DSN staging read-only>"}}}}

# Buoc 2 - bo ${input:dsn}: gia tri lay tu bien moi truong cua may/CI
#   (cu phap inputs cua Local KHONG port sang Copilot)

# Buoc 3 - don file cu de tranh server khai 2 noi:
mv .vscode/mcp.json .vscode/mcp.json.local-harness.bak

# Buoc 4 - Verify:
#   - Customizations editor -> card MCP Servers: my-db xuat hien (khong co nhan
#     "Connector:" vi no la server tu quan ly)
#   - Hoi cau can DB: "top 5 bang lon nhat trong staging" -> agent goi tool my-db

# Ky vong: tool DB tro lai trong session Copilot; session Local (neu con dung)
# thi restore file .bak - hai harness, hai nguon khai bao rieng.
