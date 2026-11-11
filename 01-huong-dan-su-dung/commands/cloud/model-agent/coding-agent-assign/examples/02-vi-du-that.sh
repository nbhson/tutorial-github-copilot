# Vi du that: issue #142 - them rate-limit cho POST /api/login
# Copilot in the cloud (GitHub.com): assign issue -> draft PR -> review

# 1. Dien noi dung issue theo 4 muc (day la "ban hop dong" agent doc duoc luc ban di ngu):
Issue #142: "thêm rate-limit cho POST /api/login.
  Mục tiêu: 5 lần/phút theo IP.
  Phạm vi: apps/api/** (không đụng web/).
  Xong khi: có test cho nhánh vượt ngưỡng, và 429 trả về đúng shape.
  Lệnh verify: pnpm --filter api test"

# 2. Assignees -> Copilot. Neu can ban duoi theo tung buoc: chon Mode = Interactive o hop thoai.
# 3. Theo doi: "Copilot started work" -> bam View session de doc log stream.

# Ky vong: draft PR mo ra linked toi issue, test xanh, diff trong apps/api/**
# Verify: git diff main...agent-branch --stat -> khong co file ngoai pham vi
# Sau khi review: commit tu agent mang dong "Co-authored-by: Copilot" (dau de biet nguoi dung thuoc ve AI)
