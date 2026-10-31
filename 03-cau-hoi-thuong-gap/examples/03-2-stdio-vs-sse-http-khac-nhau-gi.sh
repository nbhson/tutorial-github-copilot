# Test server xa còn sống trước khi đổ lỗi cho Copilot
curl -s -o /dev/null -w "%{http_code}\n" https://mcp.internal.company.com/health
# Verify: 200 = sống; 000/timeout = server chết hoặc URL sai
