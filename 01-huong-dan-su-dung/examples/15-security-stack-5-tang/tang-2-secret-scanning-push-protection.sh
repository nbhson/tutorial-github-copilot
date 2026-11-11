# Ca A — push bị chặn: KHÔNG bypass, fix đúng:
git diff --cached -- <file-bị-chặn>          # 1. đọc: loại secret, file, dòng
# 2. xóa secret khỏi code → chuyển sang env/secrets manager (process.env.STRIPE_KEY)
# 3. commit lại + push lại (protection pass là xong)

# Ca B — secret đã lọt (alert trong Security tab):
# 1. REVOKE key NGAY (Stripe/GitHub/AWS dashboard) — trước khi xóa code
# 2. xóa khỏi history nếu cần (BFG/filter-repo — admin), rồi push fix
# 3. đánh dấu alert resolved + ghi lý do (audit cần, mục 7)
