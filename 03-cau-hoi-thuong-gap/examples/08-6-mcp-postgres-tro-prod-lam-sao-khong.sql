-- Tạo user readonly cho MCP (chạy 1 lần trên DB)
CREATE USER mcp_reader WITH PASSWORD '${MCP_READER_PW}';
GRANT SELECT ON ALL TABLES IN SCHEMA public TO mcp_reader;
-- Verify: SELECT được, INSERT/DELETE bị từ chối
