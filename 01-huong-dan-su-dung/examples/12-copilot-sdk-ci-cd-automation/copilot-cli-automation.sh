# Copilot CLI - binary ten "copilot" (KHONG phai "gh-copilot"; "gh copilot suggest/explain"
# la extension cong dong cua GitHub CLI - nguon khac docs, khong phai Copilot CLI)
copilot --version

# 3 mode xoay bang Shift+Tab trong session: standard -> plan -> autopilot
copilot --plan "chia nho issue X"        # shorthand cua --mode=plan: lap ke hoach, chua doi file
# Autopilot KHONG dung o folder chua duoc trust (Workspace Trust bai 01).

# Non-interactive (CI/script): dung -p, KHONG goi slash lenh o ngoai session tuong tac:
copilot -p "giai thich src/auth/login.ts trong 5 dong" > out.md
# Slash lenh (/limits, /sandbox policy, /troubleshoot...) chi co trong session tuong tac.

# Cap tien: --max-ai-credits = soft cap cho LUOT tiep theo; ca phien dung --max-session-credits
copilot --mode autopilot --max-session-credits 20 "implement + test"
# /limits view|set|reset trong session de kiem/doi cap; resume theo docs GitHub.

# Guardrails hen trong CI: allowlist hep + deny duong dan/tools
copilot -p "review diff" --available-tools "read,grep" \
  --deny-tool terminal --deny-paths ".github/**" --allow-paths "src/**"
# --agent=TEN (theo TEN agent, khong phai duong dan file) - --model=auto
# --effort/--reasoning-effort - --output-format - --json-port - exit code 0/1/2 - buoc sau phai check $?

# Trong CI: KHONG bao gio eval output cua Copilot (prompt-injection -> RCE).
# Ghi ra file, nguoi duyet roi moi chay; moi step co timeout-minutes.
