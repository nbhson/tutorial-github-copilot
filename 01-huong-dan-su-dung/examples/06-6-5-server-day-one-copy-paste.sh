export DATABASE_URL="postgresql://dev@localhost:5432/acme_dev"  # dev only!
# Verify: "liệt kê tables + đếm rows mỗi table, chỉ đọc" → list tables.
# Quy tắc: prod KHÔNG tạo server trong mcp.json team. Cần → personal + read-only + deny write.
