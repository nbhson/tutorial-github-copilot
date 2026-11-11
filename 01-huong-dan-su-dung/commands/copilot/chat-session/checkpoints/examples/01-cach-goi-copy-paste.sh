# Checkpoints BAT MAC DINH: chat.checkpoints.enabled = true.
# VS Code tu dong snapshot cac file lien quan TRUOC MOI request -> khong can tao moc tay.

# Cach restore:
#   Chat view -> dieu huong toi request cu -> hover -> "Restore Checkpoint" -> xac nhan
#   (hoac palette: "Chat: Open Checkpoints..." de liet ke moc trong session)

# 4 co che (docs Review & Revert Changes / Get back on track):
#   1. automatic checkpoint   - snapshot truoc moi request, mac dinh ON
#   2. restore checkpoint     - file ve moc + xoa cac turn sau
#   3. restore conversation   - chi hoi thoai ve moc, giu file hien tai
#   4. name a checkpoint      - dat ten moc de tim lai dung diem

# Gioi han: checkpoint KHONG hoan tac lenh terminal da chay, network request,
# deploy, hay thay doi o dich vu ngoai. Muon chac van la commit git.
# Verify: git status sach + test xanh sau restore
