# 1. Hỏi model rẻ -> câu trả lời generic
# 2. Đổi sang model mạnh cho đúng câu kiến trúc vừa fail
/model → chọn model mạnh
"#file:src/payments/router.ts + #file:src/events/bus.ts — đề xuất cách tách thanh toán
sang event-driven, giữ API hiện tại, chỉ ra 3 rủi ro migration"
# 3. Sau khi xong, đổi lại model rẻ cho các câu hỏi vụn tiếp theo
