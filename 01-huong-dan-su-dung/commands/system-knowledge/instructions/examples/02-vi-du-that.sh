# Trong apps/api/src/routes/login.ts, gọi:
/instructions "liệt kê quy tắc đang áp cho file apps/api/login.ts"

# Đọc kết quả:
#  - Thấy rule "route không query DB trực tiếp"
#    (từ .github/instructions/api.instructions.md, applyTo: apps/api/**)
#    → rule CÓ được nạp.
#  - Không thấy → glob applyTo sai, hoặc rule nằm nhầm file.
