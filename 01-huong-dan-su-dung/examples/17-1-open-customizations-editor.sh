#!/usr/bin/env bash
# Bai 17 - Mo Agent Customizations editor va kiem tra editor hien theo harness.
# VS Code khong co lenh terminal de mo editor - cac buoc 1-4 chay trong
# Command Palette (Cmd+Shift+P / Ctrl+Shift+P); shell o buoc 5 de VERIFY.

# Buoc 1 - Command Palette: "Chat: Open Customizations"

# Buoc 2 - Nom duoi Chat view: Session Target = Copilot harness (mac dinh cua khoa).

# Buoc 3 - Lan luot mo card Instructions / Skills / Agents / MCP / Hooks / Tools /
# Plugins. Ghi lai: cung mot card, doi harness Local <-> Copilot thi danh sach
# vi tri + dinh dang file doi theo - editor hien theo harness dang chon.

# Buoc 4 - O "Customize Your Agent": nhap mo ta "commit ngan, review ky, code co test"
# -> agent hoi lam ro -> draft -> DOC VA SUA TRUOC KHI SAVE (draft la ban nhap).

# Buoc 5 - Verify bang shell: file editor vua tao phai nam o dung vi tri cua harness:
ls .github/copilot-instructions.md .github/instructions 2>/dev/null
ls -d .github/skills/*/ .github/agents/ .github/hooks/ 2>/dev/null
ls .mcp.json ~/.copilot/mcp-config.json 2>/dev/null
# Ket vong doi: file trong .github/ va ~/.copilot/ xuat hien. Danh sach rong
# => da tao nham harness (sai Session Target), quay lai buoc 2.

# Luc Local harness (legacy): editor cuyen thu .vscode/mcp.json va
# .github/prompts/*.prompt.md - Copilot harness doc .mcp.json o goc repo.
