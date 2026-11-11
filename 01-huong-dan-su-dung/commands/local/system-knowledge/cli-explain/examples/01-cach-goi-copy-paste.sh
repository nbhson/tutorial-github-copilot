# Viec: dich mot lenh shell truoc khi Enter
# Copilot Local (harness): gh copilot explain (extension terminal, khong phai harness Chat)
# Claude Code: hoi agent trong terminal, no giai thich roi chay (co the can duyet)

# Cai extension (neu may da co san gh CLI):
gh extension install github/gh-copilot

gh copilot explain "docker run -p 5432:5432 postgres"
# Ky vong: giai thich tung flag + chi ro rui ro truoc khi Enter
# Verify: noi lai duoc "lenh nay lam gi + rui ro gi"

# CANH BAO: github/gh-copilot da archived, README danh dau deprecated tu 25/10/2025.
# Van chay duoc nhung khong con phat trien; duong thay the la Copilot CLI:
copilot                                     # mo phien tuong tac (hoi lenh can dich)
copilot -p "giai thich lenh: docker run -p 5432:5432 postgres"   # chay mot lan, khong hoi them
# Copilot CLI co co che sandbox cho lenh shell: go /sandbox de xem che do hien tai
