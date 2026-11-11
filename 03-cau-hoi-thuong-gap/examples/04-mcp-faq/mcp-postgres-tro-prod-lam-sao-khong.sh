export PG_REPLICA_URL="postgres://mcp_reader:${MCP_READER_PW}@replica.internal:5432/app"
# Verify: echo $PG_REPLICA_URL ra host replica, không phải prod
