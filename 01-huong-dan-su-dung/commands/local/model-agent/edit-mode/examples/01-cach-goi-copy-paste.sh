# Cach goi Edit mode (harness Local, trong VS Code Chat)
# 1. Mo Chat view, chon mode "Edit" o dropdown tren o nhap
# 2. Nhap @file roi tick dung cac file can sua (working set)
Chat → mode Edit → tick 2 file

"đổi message lỗi sang tiếng Việt, chỉ đụng 2 file đã tick, không refactor chỗ khác"

# Ky vong: diff chi xuat hien trong 2 file da tick
# Verify: git diff --stat -> khong co file thu ba

# Khong thay mode Edit trong dropdown? (duong cua Hom nay)
# VS Code hien tai liet ke built-in agents: Ask / Agent / Plan.
# Muon sua co kiem soat theo kieu Edit:
#   1. Tao session Plan hoac Agent (harness Copilot)
#   2. Gat "Always allow" cho Edit/Write, de lai "Ask" cho Shell
#   3. Chi them @file vao working set, dung Keep/Undo cho tung luot
