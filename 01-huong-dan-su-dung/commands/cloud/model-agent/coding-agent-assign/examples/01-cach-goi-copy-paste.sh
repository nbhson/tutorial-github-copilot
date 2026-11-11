# Ba cua vao docs liet ke (chon mot trong ba):
#   1) Tren issue -> sidebar "Assignees" -> chon Copilot
#   2) Tab "Agents" trong repo, hoac panel tai github.com/copilot/agents
#   3) Prompt tren github.com/copilot -> chon repo o "session context"
# Kiem tra truoc: can goi Copilot tra phi, va org/enterprise bat policy "Copilot in the cloud"

Issue: "thêm rate-limit cho POST /api/login.
  Mục tiêu: 5 lần/phút theo IP.
  Phạm vi: apps/api/** (không đụng web/).
  Xong khi: có test cho nhánh vượt ngưỡng.
  Lệnh verify: pnpm --filter api test"
-> Assignees -> Copilot

# Mode: Interactive (ban can thiep giua chung) | Autopilot (uy quyen chay het)
# Environment: Cloud (sandbox, resume duoc sang IDE/CLI) | Actions (chi xem tren website)
# Tool permissions: Assisted (mac dinh) | Always ask | Allow all

# Ky vong: Copilot tha phan ung "con mat" (eye) len issue, mo DRAFT PR linked toi issue
# Verify: mo "View session" xem log stream; PR co test xanh + diff dung pham vi
