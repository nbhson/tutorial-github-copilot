# Viec: review PR theo dung tieu chi team, khong nho lai tung buoc
# Copilot Local (harness): prompt file .github/prompts/*.prompt.md -> goi /review-pr
# Claude Code: .claude/commands/review-pr.md (goi tay tuong tu)

# Team da commit .github/prompts/review-pr.prompt.md voi checklist co dinh:
#   - 3 loi lon nhat theo muc do
#   - test con thieu
#   - migration co an toan khong

# Chay trong session Local:
/review-pr "review diff hien tai: neu 3 loi lon nhat + goi y test con thieu"

# So sanh 2 lan chay tren 2 diff khac nhau:
#   Lan 1: PR feat/refund
#   Lan 2: PR fix/login-email
# -> ca 2 phai ra CUNG khung output (3 loi + phan test thieu), chi khac noi dung

# Ky vong: form on dinh, ban khong goi lai tieu chi
# Verify: so 2 output keo lenh -> trung khung, du noi dung khac
