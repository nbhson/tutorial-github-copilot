gh repo create acme/new-service --template acme/acme-copilot-template --private --clone
cd new-service && cat .vscode/extensions.json  # verify pack đi kèm
# Kỳ vọng: repo mới có đủ .github/ + .vscode/ + .husky/.
