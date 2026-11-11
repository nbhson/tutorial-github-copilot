# Bai 09 muc 3.1 - pack VS Code cua team: commit + cai + verify (~3 phut).
set -e

# 1. COMMIT pack (file mau: examples/09-3-1-vs-code-pack-settings.jsonc)
#    Mo folder chua file nay lan dau -> VS Code prompt cai recommended extensions
mkdir -p .vscode && cat .vscode/extensions.json

# 2. Cai bang CLI (ID = publisher.name, lay tu trang Marketplace cua extension;
#    co the chay trong Codespaces de set-up hang loat):
code --install-extension github.copilot-chat
code --install-extension github.copilot

# 3. Verify: ID phai xuat hien
code --list-extensions | grep -i "github.copilot"

# 4. Mo folder co .vscode/extensions.json lan dau -> VS Code prompt
#    "install the recommended extensions" (docs: prompt chi bat lan dau mo workspace).
#    Ai bo luot prompt: Extensions view, tim filter @recommended -> thay toan bo pack.
#    Reload window (Cmd+Shift+P > "Developer: Reload Window") neu danh sach le.
