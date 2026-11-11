# Vi du that: form dang ky nhan email sai dinh dang
# Da biet pham vi: src/validators/email.ts + test cua no (2 file)

# Duong A - Edit mode (harness Local), neu dropdown van con "Edit":
#   1. Tick @file cua 2 file tren vao working set
#   2. Lenh co ranh gioi ro rang:
(Edit, tick 2 file)
"thêm validation email dùng regex chuẩn + test cho trường hợp thiếu @; chỉ đụng 2 file đã tick"

# Duong B - neu ban dang o harness Copilot (Ask/Agent/Plan, khong co Edit mode):
#   1. Mo session Plan, noi rang buoc pham vi
#   2. Gat "Always allow" cho Edit/Write, giu "Ask" cho Shell
(Plan) "Lập kế hoạch sửa validation email trong đúng 2 file: src/validators/email.ts và test của nó.
Ngoài 2 file này không thay đổi gì. Duyệt plan trước khi code."

# Ky vong: diff chi nam trong 2 file; ban duyet tung hunk roi Keep
# Verify: git diff --stat -> chi 2 file tren
