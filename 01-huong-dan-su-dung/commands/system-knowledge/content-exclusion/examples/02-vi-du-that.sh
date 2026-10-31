# 1. Kiểm exclusion:
#    settings.json → github.copilot.chat.exclusion
#    (hoặc Org Settings nếu đây là policy)
#    → thấy "secrets/**" nằm trong danh sách.

# 2. Đối chứng 2 file:
#    - mở src/utils/format.ts  → Copilot CÓ gợi ý  (bình thường)
#    - mở secrets/prod.json    → Copilot KHÔNG gợi ý (đúng ý đồ)

# 3. Xác nhận thêm bằng một câu hỏi có scope:
"@workspace có thấy file secrets/prod.json không?"
# → trả "không thấy / excluded" nghĩa là exclusion đang sống.
