# 01-6 (muc 6.2): Verify tong — 3 lenh, theo dung thu tu nay.

gh auth status
#   Ky vong: "Logged in to github.com as <ten-cua-ban>".
#   Kiem DAU TIEN: sai account thi moi loi o ben duoi trong giong "tool hong".

copilot --version
#   Copilot CLI = binary "copilot" (docs GitHub: install-copilot-cli).
#   "command not found" -> brew install --cask copilot-cli   (hoac: npm i -g @github/copilot)
#   Chua login -> chay `copilot` roi go /login (automation: COPILOT_GITHUB_TOKEN).

gh extension list
#   Thay gh-copilot? Chi khi do "gh copilot suggest/explain" moi ton tai.
#   DO LA EXTENSION CONG DONG cua GitHub CLI, KHONG phai Copilot CLI.
#   Chua co ma van muon dung suggest/explain thi moi chay:
#     gh extension install github/gh-copilot

# Update ( chay tay khi can ):
#   copilot update                          # Copilot CLI
#   gh extension upgrade github/gh-copilot  # extension cong dong (neu dung)
# Sau moi lan update: chay lai 3 lenh tren, roi mo VS Code -> hover icon Copilot
# -> Copilot status dashboard (ten plan + % allowance AI credits thang da dung).

# --- BANG LOI HAY GAP (copy dong "Fix" chay luon) ---

# 1) Status bar bao "Sign in" mai sau OAuth  -> login sai account / token het han
#    Fix: Accounts menu -> Sign out -> sign in lai;  gh auth login
#         (KHONG go extension cai lai)

# 2) Ghost text khong hien  -> tat cho ngon ngu / file qua lon / 2 ban chong nhau
#    Fix: kiem "github.copilot.enable" trong settings.json,
#         kiem ban cai:  code --list-extensions | grep -i copilot

# 3) Chat tra loi sai ve repo  -> index chua xong / mo sai folder
#    Fix: mo dung root:  code .   tai root repo, doi index, hoi lai

# 4) "gh copilot: command not found"  -> chua cai extension cong dong
#    Fix: gh extension install github/gh-copilot

# 5) "no Copilot subscription" trong Copilot CLI -> CLI login sai account / het han mo
#    Fix: go /login trong `copilot`; mo https://github.com/settings/copilot kiem plan

# 6) Neovim :Copilot status = Not authenticated  -> Fix: chay :Copilot setup, OAuth lai

# 7) Chat panel trang sau update -> version lech extension vs editor
#    Fix: "Developer: Reload Window"; update VS Code ban Stable moi nhat
