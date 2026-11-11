# 01-4: Cai Copilot o JetBrains / Visual Studio / Neovim (ghi nhanh, chi tiet IDE khac
# so sanh giua cac be mat: bai 02).

# JetBrains (IntelliJ, PyCharm, WebStorm...):
#   Ctrl+Alt+S -> Plugins -> Marketplace -> tim "GitHub Copilot" -> Install
#   -> Restart IDE -> Tools -> GitHub Copilot -> "Sign in to GitHub" -> OAuth -> Allow.
#   Verify: go mot ham -> ghost text hien -> Tab.
#   (Extension: https://plugins.jetbrains.com/plugin/17718-github-copilot)

# Visual Studio:
#   Extensions -> Manage Extensions -> tim "GitHub Copilot" -> Download
#   -> tho VS roi chay VSIX (Restart) -> Help -> "Sign in to GitHub".
#   Verify: ghost text + panel Copilot Chat ben phai.

# Neovim (plugin cong dong github/copilot.vim, khong phai extension chinh thuc):
git clone https://github.com/github/copilot.vim.git \
  ~/.config/nvim/pack/github/start/copilot.vim
#   Mo nvim -> :Copilot setup   (OAuth, paste code ve phia nvim)
#   Verify: :Copilot status      -> "Enabled"
#     "Not authenticated" -> chay lai :Copilot setup
#   Phim: Tab nhan goi y · :Copilot enable / :Copilot disable bat-tat tam.
#   Nang cap plugin:
git -C ~/.config/nvim/pack/github/start/copilot.vim pull

# Chot: loi "sao IDE nay khong co agent?" thuong la do be mat, not do login —
# kiem §6.2 truoc, roi doc bai 02 de chon be mat dung.
