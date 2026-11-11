# Bai 04 muc 8 - git flow + lenh khi KHONG mo IDE (~5 phut).
# Chay tren branch test cua repo that; moi thao tac duoi day deu co trong index bai 04.

# 1. Commit message tu diff da stage (KHONG phai slash trong Chat):
#    Source Control view -> stage file -> bam nut ✨ canh o nhap commit message
#    -> Copilot sinh message tu diff (utility model), doc + sua truoc khi commit.
git add -A
git diff --cached --stat                     # kiem tra dung file duoi

# 2. PR title + body tu workspace changes:
#    GitHub Pull Requests view -> Create Pull Request -> bam ✨ canh o title.
git push -u origin HEAD

# 3. Loi trong terminal -> mo Terminal Inline Chat (Ctrl+I ngay trong terminal),
#    hoac chay lenh roi gan output vao Chat qua Attach / #selection:
#    (khong day dung @terminal - participant nay da deprecated)

# 4. Dung IDE van muon hoi tiep (CLI cua GitHub, KHONG phai gh copilot):
copilot --continue                            # mo lai phien gan nhat
copilot -p "tat ca test fail co phai do merge conflict bo sot khong" --mode plan
