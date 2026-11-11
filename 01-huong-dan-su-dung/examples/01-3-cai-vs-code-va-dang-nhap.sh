# 01-3: Cai + dang nhap Copilot trong VS Code (session mac dinh = Copilot harness).

# VS Code 2026 tich hop san AI features. Khong thay icon Copilot o status bar?
code --list-extensions | grep -i copilot
#    - Khong co dong nao -> Ctrl+Shift+X -> tim "GitHub Copilot" -> Install
#      -> "Developer: Reload Window".
#    - Co 2 ban (stable + nightly) -> go 1 ban, ghost text se ong hon.
#    - Van khong thay -> kiem "chat.disableAIFeatures" (phai la false).

# Dang nhap (docs VS Code: Set up GitHub Copilot):
#    Hover icon Copilot o status bar -> "Use AI Features" -> chon kieu dang nhap
#    -> browser mo github.com/login/oauth -> Allow.
#    Hoac Command Palette (Ctrl+Shift+P) -> "GitHub Copilot: Sign in".

# Co 2 tai khoan (ca nhan + cong ty)? Chon account rieng cho workspace/profile:
#    Accounts menu -> "Manage Extension Account Preferences" -> GitHub Copilot Chat
#    -> chon tai khoan dung.
#    GitHub Enterprise (GHE.com): chon "Continue with GHE.com" + dien URL instance.

# Login sai roi? Sign out roi login lai, KHONG go extension cai lai:
#    Accounts menu (hoac icon Copilot) -> Sign out -> "Use AI Features" -> Allow.

# Kiem tra tong duoi terminal:
gh auth status
