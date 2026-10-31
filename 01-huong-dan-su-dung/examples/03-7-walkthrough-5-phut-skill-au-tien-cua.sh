# 1. Tạo folder + file (repo root):
mkdir -p .github/skills/gen-test && echo "" > .github/skills/gen-test/SKILL.md
# 2. Paste nội dung bên dưới vào SKILL.md (sửa theo repo của bạn)
# 3. Commit + push (skill dùng chung cho cả team):
git add .github/skills/gen-test && git commit -m "add gen-test skill" && git push
# 4. Verify: chat "viet test cho src/utils/date.ts" (KHÔNG gõ /)
#    → agent phải tự load skill, viết test, chạy test.
#    Không tự load? Sửa câu ĐẦU của description — thêm đúng từ bạn hay gõ.
