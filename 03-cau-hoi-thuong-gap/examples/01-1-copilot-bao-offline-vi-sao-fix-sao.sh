curl -s -m 10 -o /dev/null -w "%{http_code}\n" https://api.github.com
# Verify: 200/401 = mạng OK

env | grep -i proxy    # máy công ty hay dính
curl -s https://www.githubstatus.com/api/v2/status.json | head -c 300; echo
