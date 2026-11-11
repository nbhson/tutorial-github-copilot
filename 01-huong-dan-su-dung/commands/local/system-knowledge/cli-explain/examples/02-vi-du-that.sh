# Viec: hieu mot lenh don log tai trong script tu mang ve, TRUOC khi Enter
# Copilot Local (harness): gh copilot explain giai thich tung flag + rui ro
# Claude Code: hoi agent trong terminal, no giai thich va co the chay luon

gh copilot explain "find . -type f -name '*.log' -mtime +7 -delete"
# -> ban dich cho biet: tim file .log lau hon 7 ngay roi XOA (-delete), khong hoi lai

# Thu tu bat buoc: dich -> thu tren ban copy -> roi moi chay noi that
mkdir -p /tmp/logtest && cd /tmp/logtest
touch -t 202001010000 old.log; touch new.log
find . -type f -name '*.log' -mtime +7              # buoc 1: CHI liet ke (bo -delete)
find . -type f -name '*.log' -mtime +7 -delete      # buoc 2: xoa o thu muc test

# Ky vong: ban doc duoc "-delete = xoa that" truoc khi chay vao repo/dung luong that
# Verify: noi lai duoc "lenh nay lam gi + rui ro gi"; khong noi lai duoc -> chua du hieu de Enter
