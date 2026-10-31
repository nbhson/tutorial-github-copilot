# Phút 0–5 (T1): git status --porcelain | grep -E "env|pem|key|secrets" || echo "sạch"
#   Chat: "@workspace tìm STRIPE_KEY?" → phải không thấy.
# Phút 5–10 (T2 — thử lửa an toàn):
echo 'STRIPE_KEY=sk-live-FAKEKEY123' > fake-test.env
git add fake-test.env && git commit -m "test push protection" || echo "chặn là ĐÚNG"
git reset HEAD fake-test.env; rm fake-test.env
#   → bị chặn = tầng 2 sống. Không chặn → báo admin kiểm tra config.
# Phút 10–15 (T3+T4): mở 1 PR nhỏ → CodeQL check chạy? Copilot review comment?
# Phút 15–20 (T5): audit log filter action:copilot_policy → ai đổi lần cuối, khi nào?
# Ghi team log 1 dòng: "5 tầng: T1 ok / T2 ok / T3 _ / T4 _ / T5 _".
