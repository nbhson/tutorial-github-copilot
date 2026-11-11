# Viec: don branch local da merge, giu main/develop, khong mat commit chua merge
# Copilot Local (harness): gh copilot suggest cho lenh + giai thich flag (terminal)
# Claude Code: cung y dinh -> agent soan va co the chay luon (them buoc duyet quyen)

gh copilot suggest "xoa branch da merge, giu main va develop"
# -> lenh thuong tra ve:
#    git branch --merged | grep -v -E 'main|develop' | xargs git branch -d

# Hieu flag xong moi chay: -d (an toan) KHAC -D (force, co the mat branch chua merge)
git branch --merged                                                   # buoc 1: xem danh sach
git branch --merged | grep -v -E 'main|develop' | xargs git branch -d  # buoc 2: xoa kieu an toan

# Ky vong: chi branch da merge bi xoa; branch chua merge van con nguyen
# Verify: git log main --oneline | head -> van du cac commit da merge

# Neu may khong con "gh copilot" (github/gh-copilot da archived, deprecated 25/10/2025):
copilot -p "liet ke branch da merge o local, cho toi lenh xoa an toan, chua xoa gi ca"
