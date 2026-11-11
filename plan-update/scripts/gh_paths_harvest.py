#!/usr/bin/env python3
"""Thu duong dan docs.github.com/en/copilot/* tu sidebar cua cac trang song (BFS gioi han).
In ra /tmp/gh-paths.txt (duong dan tu root repo cua GitHub docs) — dung de chon URL tuong thich.
So trang tai = lenh dau tien (mac dinh 6).
"""
import re, subprocess, sys, collections

MAXP = int(sys.argv[1]) if len(sys.argv) > 1 else 6
SEEDS = ['https://docs.github.com/en/copilot',
         'https://docs.github.com/en/copilot/concepts',
         'https://docs.github.com/en/copilot/how-tos',
         'https://docs.github.com/en/copilot/reference',
         'https://docs.github.com/en/copilot/get-started',
         'https://docs.github.com/en/copilot/concepts/customizations']
HREF = re.compile(r'href="(/en/copilot/[A-Za-z0-9._/-]+)"')
TITLES = re.compile(r'<a[^>]*href="(/en/copilot/[A-Za-z0-9./_-]+)"[^>]*>([^<]{4,90})</a>')

seen = collections.OrderedDict()
q = collections.deque(SEEDS)
fetched = 0
while q and fetched < MAXP * 6:
    u = q.popleft()
    if fetched >= MAXP * 6: break
    html = subprocess.run(['curl', '-sL', '--max-time', '40', u], capture_output=True, text=True).stdout
    fetched += 1
    for p, t in TITLES.findall(html):
        p = p.rstrip('/')
        if p not in seen and len(seen[p]) == 0 or p not in seen:
            seen[p] = re.sub(r'\s+', ' ', t).strip()
    for p in HREF.findall(html):
        p = p.rstrip('/')
        if p not in seen and len(seen) < MAXP * 400:
            pass
for p, t in sorted(seen.items()):
    print(f'{p.replace("/en/","/")}\t{t}')
open('/tmp/gh-paths.txt', 'w').write('\n'.join(f'{p}\t{t}' for p, t in sorted(seen.items())) + '\n')
print(f'\n# thu {len(seen)} duong dan tu {fetched} trang', file=sys.stderr)
