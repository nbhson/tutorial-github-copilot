#!/usr/bin/env bash
# Kiem tra moi URL trong doclink_map_*.json: ma tra ve (khong theo redirect) + redirect URL.
# In cac URL bi 404/301/302 de sua map.
cd "$(dirname "$0")/../.." || exit 1
python3 - <<'PY' > /tmp/mapurls.txt
import json, glob
us = set()
for f in glob.glob('plan-update/scripts/doclink_map_*.json'):
    for s, h, u, l in json.load(open(f, encoding='utf-8'))['m']:
        us.add(u.split('#')[0])
print('\n'.join(sorted(us)))
PY
echo "URL can check: $(wc -l < /tmp/mapurls.txt)"
cat /tmp/mapurls.txt | xargs -P 10 -I{} sh -c '
  r=$(curl -s -o /dev/null -w "%{http_code} %{redirect_url}" "{}")
  code=${r%% *}; red=${r#* }
  if [ "${code}" != "200" ]; then echo "$code {} -> $red"; fi' 2>/dev/null | sort -u | head -40
echo "=== xong ==="
