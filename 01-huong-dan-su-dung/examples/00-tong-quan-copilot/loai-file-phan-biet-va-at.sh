# Copy-paste: tạo đủ 3 loại file trong 1 phút
mkdir -p .github/instructions
touch .github/copilot-instructions.md AGENTS.md .github/instructions/api.instructions.md
ls -la .github/copilot-instructions.md .github/instructions/ AGENTS.md 2>&1
# Kỳ vọng: ls hiện đủ 3 paths. Sau đó paste mẫu mục 3 + 4.

# Kiểm tra độ phình:
wc -l .github/copilot-instructions.md .github/instructions/*.instructions.md 2>/dev/null
# Mục tiêu: repo-wide file <200 dòng.
