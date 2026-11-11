# Participants @workspace / @terminal / @vscode - page "nhan dien dang CHET"
# Docs VS Code: chat participants da deprecated, KHONG ho tro o Copilot harness.
# Chi con chay o Local harness (legacy). Day la cac dang ❌ dung de nhan dien,
# KHONG phai cu phap de dung.

# ❌ PHAI TRANH (Copilot harness se bo qua participant, prompt van gui di lang le):
#   @workspace tom tat ca repo
#   @terminal git push bi loi nhu nay la sao
#   @vscode mo bang lenh

# ✅ CU PHAP SONG CUA CHAT HIEN TAI (theo docs cheat sheet):
#   /  -> chay lenh trong session
#   #  -> gan file / vung chon lam context
#   khong dung @ lam context nua - Agent tu gather

# Duong thay the tuong ung:
@workspace  -> hoi thang (Agent tu quet repo) hoac gan #file / nut Add Context
@terminal   -> inline chat trong terminal (Ctrl+I)
@vscode     -> Command Palette, hoac noi mong muon bang cau tien nhien

# Viec lap thanh quy tac repo -> dat vao instructions / AGENTS.md (nap tu dong),
# khong nhet vao prompt hang ngay nua.

# kiem tra kho prompt cu:
grep -rn "@workspace\|@terminal\|@vscode" . --include="*.md"
