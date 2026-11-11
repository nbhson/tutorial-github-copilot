# 4 co che checkpoint trong VS Code (docs: "Review & Revert Changes" + "Get back on track")
# Mac dinh BAT: VS Code tu snapshot cac file lien quan TRUOC khi xu ly MOI request.
#   Setting kiem soat: "chat.checkpoints.enabled" = true (mac dinh)

# 1) AUTOMATIC CHECKPOINT - khong phai lam gi: moi request tu tao one moc.
#    Thu thuat them truoc task mau hiem - moc git ben hon checkpoint:
git add -A && git commit -m "checkpoint tay truoc request mau hiem"

# 2) RESTORE CHECKPOINT - hover len request cu trong Chat view -> "Restore Checkpoint".
#    Tra file bi anh huong ve moc + xoa cac turn tro ve sau moc.
#    LUU Y: KHONG hoan tac lenh terminal da chay, network request, deploy,
#    hay thay doi da ghi vao dich vu ben ngoai - cai do dung git/revert.

# 3) RESTORE CONVERSATION ONLY - dua HOI THOAI ve moc nhung GIU file hien tai.
#    Dung khi: code da dung, chi muon noi lai tu cau hoi cu prompt tot hon.

# 4) NAME A CHECKPOINT - gan ten cho moc ("take checkpoint before risky request")
#    de session 20+ turn van tim lai dung diem, khong restore nhoan.

# Tro giup tim moc (Command Palette):
#   "Chat: Show Checkpoints"  - liet ke cac moc trong session
#   "Reveal in Timeline"      - nhay moc tren Timeline cua file

# Copilot CLI cung co checkpoint (docs GitHub - CLI command reference):
copilot checkpoint restore

# Verify: git status quay ve dung trang thai moc; turn sau moc sach khoi chat;
# checkpoint KHONG phai thay git - checkpoint la session state, git la code state.
