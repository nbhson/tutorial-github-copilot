# Bai 09 muc 3.2 - pin version VS Code extension, tranh breaking change giua sprint.
# Mac dinh: VS Code tu dong cap nhat moi extension -> "sang sprint thay lenh moi".

# 1. Tom automatic updates: settings.json
#    "extensions.autoUpdate": false

# 2. Cai dung version (khong lay latest mu):
code --install-extension github.copilot-chat@0.26.0
code --install-extension dbaeumer.vscode-eslint@3.0.0

# 3. Xem version dang chay tren may:
code --list-extensions --show-versions | grep -i "copilot\|eslint"

# 4. Update co kiem soat (cuoi sprint, khong giua sprint):
#    UI: Extensions > bieng > "Update" hoac "Install Another Version"
#    hoac chay lai lenh cai o tren voi version moi.
code --list-extensions | xargs -I{} code --install-extension {} --force
# => test 1 ngay tren repo thu truoc khi announce team.

# 5. Audit dinh ky (so voi allowlist wiki, moi thang):
code --list-extensions --show-versions > /tmp/exts.txt
