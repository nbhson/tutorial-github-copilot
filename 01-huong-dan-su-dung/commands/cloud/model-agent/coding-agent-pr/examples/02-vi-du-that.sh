# Viec: review PR "rate-limit" do cloud agent mo, co Copilot soi dung
# Copilot in the cloud: Request review tu Copilot -> doc finding -> Fix with Copilot
# Claude Code: khong co tuong duong o cap PR; o day moi thu van qua diff + CI

# 1. PR tu agent dang o che do DRAFT: doi thanh ready khi ban bat dau doc
# 2. Reviewers -> Copilot -> Request (effort Balanced de du sau)
# 3. Doc comment cua Copilot: tim nhan High/Medium. O day Medium: "thieu test nhan vuong nguong"
Comment tren finding: "bo sung test cho nhom IP vuot nguong 5 lan/phut"
# 4. Bam "Fix with Copilot" tren finding -> no mo draft comment, chon "commit cung PR"
# 5. Agent push -> CI chay lai -> xanh -> doc diff lan cuoi -> merge

# Ky vong: finding High het, CI xanh, diff nam trong apps/api/**
# Verify: sau merge, staging go /api/login vuot nguong tra 429 + Retry-After
