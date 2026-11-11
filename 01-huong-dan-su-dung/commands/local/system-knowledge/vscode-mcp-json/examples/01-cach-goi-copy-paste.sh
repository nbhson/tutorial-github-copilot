# .vscode/mcp.json - file MCP cua Local harness (Copilot harness KHONG doc file nay)

# 1. Vi tri: .vscode/mcp.json trong repo (Local harness - extension host doc)
#    Key goc la "servers" (KHONG phai "mcpServers")
{
  "servers": {
    "my-db": {
      "command": "npx",
      "args": ["-y", "db-mcp"],
      "env": { "DSN": "${input:dsn}" }
    }
  },
  "inputs": [
    { "id": "dsn", "type": "promptString", "password": true }
  ]
}

# 2. Ban Copilot harness - dat o ROOT repo, ten .mcp.json, key goc "mcpServers":
{
  "mcpServers": {
    "my-db": {
      "command": "npx",
      "args": ["-y", "db-mcp"],
      "env": { "DSN": "postgres://staging-reader:CHANGE_ME@db.example.com/stage" }
    }
  }
}
# LUU Y: ${input:...} va sandbox per-server cua Local KHONG port sang Copilot.
# Secret nen lay tu bien moi truong dat NGOAI file (shell/profile), dung commit.

# 3. Thu tu nap phia Copilot CLI (docs CLI, thap -> cao):
#    ~/.copilot/mcp-config.json  ->  plugin MCP  ->  --additional-mcp-config

# Verify: mo Customizations editor (Chat: Open Customizations), card MCP Servers
# -> server phai hien khi dang Chay session Copilot harness
