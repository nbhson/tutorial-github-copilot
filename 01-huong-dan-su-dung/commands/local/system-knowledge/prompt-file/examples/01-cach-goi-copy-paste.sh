# Viec: liet ke va goi prompt file tai dung trong repo
# Copilot Local (harness): /prompts chi chay o session Local trong Chat view
# Claude Code: tuong duong la .claude/commands/*.md (goi tay bang /ten)

/prompts
# -> mo Configure Prompt Files: liet ke prompt trong .github/prompts/ (vd /review-pr)

# Tao prompt file moi: Command Palette -> "Chat: New Prompt File"
# Xem todo bo customization: Command Palette -> "Chat: Open Customizations"

# Goi theo ten (prompt file cua team da commit):
/review-pr "review diff hien tai: 3 loi lon nhat + test con thieu"

# Ky vong: prompt chay dung form team, khong phai goi lai ca doan tieu chi
# Verify: chay 2 lan tren 2 diff khac nhau -> cung khung output

# NEU prompt khong hien trong danh sach:
# - Kiem session dang la Local hay Copilot (prompt file KHONG chay o Copilot harness)
# - File phai o .github/prompts/, duoi .prompt.md, co frontmatter "description"
# - Port sang skill de Copilot/GitHub.com/CLI dung duoc:
#   Chat: Open Customizations -> Migrations -> "Convert Prompt to Skills"
#   (skill sinh ra co disable-model-invocation: true -> van phai goi tay)
