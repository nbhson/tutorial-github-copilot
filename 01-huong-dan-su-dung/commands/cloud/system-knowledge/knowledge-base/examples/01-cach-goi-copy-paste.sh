# Viec: hoi tai lieu noi bo va nhan cau tra loi co nguon
# Copilot in the cloud: Copilot Spaces (dat tai github.com/copilot/spaces)
# Claude Code: tuong duong la doc file trong repo hoac MCP tro toi docs noi bo

# 1. Tao space:
#    github.com/copilot/spaces -> Create space -> dat ten -> chon so huu (ca nhan | organization)
# 2. Them Instructions (Copilot tap trung gi, tranh gi):
Instructions: "Ban la nguoi tra loi ve quy trinh backend team. Dua tren runbook + docs trong space.
  Neu tai lieu khong noi ro, tra loi 'khong co trong tai lieu', dung suy dien."
# 3. Them Sources (kich thuoc khac nhau cho hai kieu):
#    - Attach file: docs/runbook/deploy-staging.md   -> nap TOAN BO noi dung
#    - Attach repository: org/platform-docs          -> CHI tim va lay phan lien quan
#    - Link issue/PR: dan URL

# 4. Hoi trong Copilot Chat tren GitHub.com (hoac mo session Copilot va chon Space o Attach):
"Theo cac tai lieu trong space 'Team Runbook', deploy staging gom may buoc?
 Trich nguon cu the (file/section). Neu khong co trong tai lieu thi noi ro khong co."

# Ky vong: cau tra loi dan ve file/issue cu the trong space
# Verify: mo dung nguon duoc trich va doi chieu; khong mo duoc = chua co cau tra loi
