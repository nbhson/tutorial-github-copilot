# Viec: xac nhan "Copilot im lang o file nay" la chu y, khong phai loi
# Copilot in the cloud (GitHub.com): policy dat tren GitHub.com, ap cho moi surface
# Claude Code: khong co duong nay -> chan file bang permissions trong settings may ban

# Bo canh: secrets/prod.json chua key that; mo file nay Copilot khong goi y.

# 1. Doc danh sach exclusion (can quyen xem settings):
#    github.com -> repo -> Settings -> Copilot -> Content exclusion
#    -> thay "secrets/**" (hoac ke tu org trong box xam)

# 2. Test HAI CHIEU (mot chieu khong du ket luan):
#    - mo src/utils/format.ts  -> Copilot CO goi y   (chung to Copilot song)
#    - mo secrets/prod.json    -> Copilot KHONG goi y (inline suggestions bi tat trong file exclude)
#    - hoi trong chat: "explain this file" (file dang mo la secrets/prod.json)
#      -> tra loi khong co noi dung file = exclusion dang "song"

# 3. Ngu dung cach cu: hoi "@workspace co thay secrets/prod.json khong?"
#    -> @workspace la participant cua Local harness, KHONG phai phep thu exclusion.
#      Muon kiem exclusion thi kiem danh sach Settings + hanh vi tren, khong hoi participant.

# Ky vong: file bi exclude vang ca hai noi: inline suggestions va cau tra loi chat/code review
# Verify: sau khi doi policy, doi toi 30 phut (hoac reload cua so) roi chay lai buoc 2
