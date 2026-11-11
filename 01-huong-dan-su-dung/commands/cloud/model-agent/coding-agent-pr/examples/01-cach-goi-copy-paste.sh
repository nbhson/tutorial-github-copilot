# Viec: lay mot luot soi diff tu dong truoc khi nguoi doc
# Copilot in the cloud: PR -> sidebar "Reviewers" -> ben canh Copilot bam Request
# Claude Code: khong co tu dong review o cap PR tren GitHub (review trong may local)

# 1. Chon review effort ngay o cho Reviewers truoc khi request:
#    Lite (bat loi hien nhien) | Balanced (mac dinh, sau hon) | Max (nhieu model reasoning)
# 2. Request -> thuong <30 giay: comment gan nhan High/Medium/Low
# 3. Fix: accept suggestion, hoac bam "Fix with Copilot" tren comment

# Mac dinh Copilot de lai review loai "Comment" (khong Approve/Request changes),
# nen finding cua no khong dem vao required approval.

# Ky vong: loi duoc phan loai theo muc do, suggestion apply duoc bang vai click
# Verify: moi finding High da resolve hoac co ly do ghi ro; CI xanh roi moi merge
