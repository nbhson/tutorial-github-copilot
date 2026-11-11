# Vi du that: nhanh feat/login-rate-limit vua them gioi han dang nhap + test, sap mo PR.

# B1 - Commit het viec cua nhanh (chi 1 muc dich: rate limit).
# B2 - Pull Requests view -> Create Pull Request (hoac Palette -> "GitHub Pull Requests: Create Pull Request").
# B3 - Bam ✨ canh o title: Copilot sinh nhap, vi du:
#      "feat(auth): gioi han 5 lan dang nhap sai trong 15 phut"
#      body: Doi gi (them limiter + test) / Vi sao (chong brute force)
# B4 - Tu them vao body:
#   Test: "npm test -- auth: 6/6 xanh; tay test: 5 sai -> khoa 15 phut, dung -> mo lai"
#   Rui ro: "limiter dem theo ip - chua review voi moi truong behind proxy/NAT"
#   (prompt bo sung, neu dung Chat de viet phan nay):
#      "giu nguyen phan doi gi, chi viet them muc Test va Rui ro cho PR nay"
# B5 - Doc lai toan bo body -> Create.

# Verify: dua body cho 1 teammate doc - ho KHONG phai hoi lai cau nao la dat.
