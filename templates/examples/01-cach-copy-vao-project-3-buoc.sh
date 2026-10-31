# 1. Copy cả khung sang repo thật (đứng ở root repo đích)
cp -r /path/to/tutorial-copilot/templates/.github ./
cp -r /path/to/tutorial-copilot/templates/.vscode ./

# 2. Sửa cho khớp repo (bắt buộc, bỏ qua là config chạy sai)
# - .github/copilot-instructions.md: stack + 6 lệnh Dev/Build/Test/Lint/Full-check/Migrate (chỉ ghi lệnh đã chạy thử thật)
# - .github/instructions/*.instructions.md: sửa applyTo globs theo thư mục thật (ls để đối chiếu)
# - .vscode/mcp.json: nhập token của mình qua popup ${input} khi IDE hỏi (KHÔNG hardcode vào file)
# - .vscode/settings.json: thêm path nhạy cảm của repo vào exclusion

# 3. Kiểm tra Copilot nhận đủ config
# Mở repo đích trong IDE rồi:
# - Gõ thử 1 hàm xem suggestions có theo chuẩn team không
# - Mở chat mới hỏi: "liệt kê quy tắc đang áp dụng cho <1 file>" (test instructions load)
# - Nói "review PR giúp" / "deploy staging" (test SKILLS tự load — chuẩn 2026)
# - (Legacy) Gọi /review-pr, /deploy thử (test prompt files load — chỉ Local, sắp deprecated cho Agent Host)
# - View -> Output -> MCP (test servers sống)
