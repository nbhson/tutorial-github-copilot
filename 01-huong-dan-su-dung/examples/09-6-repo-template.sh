# Bai 09 muc 6 - repo template: tick "template" + kiem pack du khi tao repo tu template.
# (To chuc: Settings > Default org repository permissions dat role den template.)

# 1. Tao tu template tren GitHub: nut "Use this template"
#    hoac CLI:
gh repo create acme/new-service --template acme/acme-copilot-template --private --clone

# 2. Verify repo moi keo du dung noi dung chia se:
cd new-service
cat .vscode/extensions.json    # pack VS Code (bai 09 muc 3)
ls .github/instructions .github/workflows
# Ky vong: du .github/ + .vscode/ + hooks/; skill nam trong .github/skills/
# (dang `.prompt.md` la cu -> port sang skills/).

# 3. Repo khong co nut "Use this template"? Kiem tra lai tick Template repository
#    trong Settings > General cua repo me.
