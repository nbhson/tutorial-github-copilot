# Viec: dung thu tu ky nhan "hang" tu agent
# Copilot in the cloud: CI xanh -> doc diff -> xu ly finding -> merge -> theo doi
# Claude Code: cung van la trinh tu do, chi khac nguon tao PR

# 1. CI do -> dung lai, comment yeu cau fix (hoac Fix with Copilot cho tung finding)
Comment: "test vuong nguong do - sua de pnpm --filter api test xanh truoc khi minh merge"
# 2. Agent push commit moi -> CI chay lai -> Xanh
# 3. Doc diff tung hunk; neu PR qua to -> tam dung, yeu cau tach 2-3 PR nho
# 4. Merge, roi kiem staging: go vuot nguong phai tra 429
# 5. Co su co -> revert commit cua PR (git revert -m 1 <merge-sha>)

# Ky vong: khong co finding High con mo, CI xanh, staging on dinh
# Verify: git log -1 sau revert cho thay duong lui sach
