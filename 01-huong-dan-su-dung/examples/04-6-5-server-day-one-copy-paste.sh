# 1. Tạo token (fine-grained, chỉ repo cần) → env, KHÔNG paste vào file:
export GITHUB_TOKEN="$(gh auth token)"   # lấy từ gh CLI, không lưu plaintext
# 2. Đã có trong .vscode/mcp.json (mục 3, dùng ${GITHUB_TOKEN}).
# 3. Verify: "liệt kê 5 PRs mở gần nhất của repo này + tóm tắt mỗi PR 1 dòng"
# → Copilot tự gọi github MCP, trả 5 dòng. Không được → "MCP: List Servers" check status.
