# Vi du that: nang thu vien ngay-thang len major version moi (~20 file goi ham cu),
# repo da co test phu, git sach. Muon agent tu chay, sang ra co PR.

# 1. Mo issue tren GitHub.com, viet pham vi roi rang:
#    Muc tieu: nang <lib> len v4, sua het noi goi cu
#    Pham vi: chi duoc sua src/** va package.json; cam sua tests/**
#    Lenh verify: npm test

# 2. Assign issue cho Copilot -> khoi dong phien cloud, chinh 3 num:
#    Mode: Autopilot            (giao khoan toi da)
#    Tool permission: Assisted  (KHONG phai Allow all - van hoi buoc nhay cam)
#    Environment: Cloud sandbox (mac dinh, tranh tran 59 phut cua Actions minutes)

# 3. Ky vong: agent tu sua - chay test - tiep tuc sau loi, mo draft PR.

# 4. Verify:
#    - Mo session log: chuoi tool calls tu lien, khung "dang cho duyet" = 0 lan
#    - git diff tren PR: chi cham src/** va package.json
#    - npm test chay xanh tren PR

# Thi nghiem ngan (muc 2 cua bai tap):
#    Gui lai chinh issue voi Tool permission = Always ask -> phien dung cho
#    duyet tung buoc, chung to mode va permission la 2 num doc lap.
