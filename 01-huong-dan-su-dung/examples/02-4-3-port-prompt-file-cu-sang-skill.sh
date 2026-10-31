# Bước 1: tạo folder skill mới:
mkdir -p .github/skills/deploy-checklist/{scripts,references,examples}
touch .github/skills/deploy-checklist/SKILL.md

# Bước 2: copy body .github/prompts/deploy.prompt.md vào SKILL.md,
# giữ `description` (đây là trigger). Đổi name theo tên folder.

# Bước 3: tách steps dài >50 dòng vào references/ (nếu có).

# Bước 4: xóa prompt file cũ sau khi skill pass test:
rm .github/prompts/deploy.prompt.md

# Verify: chat "deploy staging" (KHÔNG gõ /) → skill tự load.
