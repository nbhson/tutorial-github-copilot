# Xem plan hiện tại (cần gh CLI đã login)
gh api user --jq '{login, plan: .plan.name}'
gh api /user/copilot_seat_details --jq . 2>/dev/null || echo "Chua co seat"
# Verify: ra login + tên plan, không phải 404
