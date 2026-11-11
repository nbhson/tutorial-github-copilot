# Viec: cung mot task nhung issue la ban dac ta day du
# Copilot in the cloud: assign xong mo "View session" doc log, khong cho ket qua moi xem
# Claude Code: tuong duong la prompt da dan + permission allowlist (van la nguoi duyet)

Issue: "thêm rate-limit cho POST /api/login.
  Mục tiêu: 5 lần/phút theo IP, trả 429 kèm header Retry-After.
  Phạm vi: chỉ apps/api/**, không đụng web/ và không thêm thư viện mới.
  Xong khi: có test cho nhánh vượt ngưỡng và nhánh dưới ngưỡng.
  Lệnh verify: pnpm --filter api test"
-> Assignees -> Copilot (Mode: Interactive neu ban muon duyet giua chung)

# Ky vong: draft PR + session log, CI xanh, diff trong apps/api/**
# Verify: doc log xem no chon file nao -> doi chieu diff -> roi moi merge
