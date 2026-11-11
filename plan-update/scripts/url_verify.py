#!/usr/bin/env python3
"""Kiem tra TOAN BO URL VS Code + GitHub docs trong noi dung (khong tinh plan-update/).
Thanh 2 lop:
  - lop 1: HTTP status cua URL goc (khong theo redirect) -> bat 301/302/404/403
  - lop 2: neu co anchor -> tai trang va kiem tra id="<anchor>" (HTML) hoac TOC dump
In danh sach URL can sua. Cache ket qua tai TMP/url-verify.json.
"""
import re, os, sys, glob, json, subprocess, collections

TMP = '/private/var/folders/bl/8cp9kd_s0yx6q541cqdz3tpm0000gn/T/opencode'
SKIP = ('plan-update/',) if '--all' not in sys.argv else ()
URL = re.compile(r'https://(?:code\.visualstudio\.com|docs\.github\.com)[^)\s`"\'<>]+')
CACHE_P = f'{TMP}/url-verify.json'
cache = json.load(open(CACHE_P, encoding='utf-8')) if os.path.exists(CACHE_P) else {}

files = []
for g in ('*.md', '0?*/**/*.md', 'templates/**/*.md'):
    files += glob.glob(g, recursive=True)
urls = collections.Counter()
for f in sorted(set(files)):
    if any(f.startswith(s) for s in SKIP) or '/examples/' in f and f.endswith('.sh'):
        continue
    for u in URL.findall(open(f, encoding='utf-8').read()):
        urls[u.rstrip('.,;')] += 1

toc = collections.defaultdict(set)
if os.path.exists('/tmp/vsc-toc.txt'):
    for l in open('/tmp/vsc-toc.txt', encoding='utf-8'):
        p = l.rstrip('\n').split('\t')
        if len(p) == 3: toc[p[0]].add(p[1])

def probe(u):
    base = u.split('#')[0]
    if base in cache: return cache[base]
    out = subprocess.run(['curl', '-s', '-o', '/dev/null', '-w', '%{http_code} %{redirect_url}', base],
                         capture_output=True, text=True, timeout=40).stdout.split()
    r = [out[0] if out else '000', out[1] if len(out) > 1 else '']
    cache[base] = r
    return r

todo = [u for u in urls if u.split('#')[0] not in cache]
print(f'{len(urls)} URL doc ({len(todo)} can hoi moi)')
import concurrent.futures
def check(u):
    code, loc = probe(u)
    if code != '200':
        return f'HTTP {code}  {u}  -> {loc}  (x{urls[u]})'
    if '#' in u:
        path, anchor = u.split('#', 1)
        if 'code.visualstudio.com' in path:
            p = path.replace('https://code.visualstudio.com/', '')
            if toc[p] and anchor not in toc[p]:
                return f'ANCHOR VSC sai  {u}  (co: {sorted(toc[p])[:5]})'
        else:
            html = subprocess.run(['curl', '-sL', path], capture_output=True, text=True, timeout=40).stdout
            if f'id="{anchor}"' not in html and f'name="{anchor}"' not in html:
                return f'ANCHOR GH sai  {u}'
    return ''

with concurrent.futures.ThreadPoolExecutor(max_workers=12) as ex:
    bad = [x for x in ex.map(check, sorted(urls)) if x]
json.dump(cache, open(CACHE_P, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
print(f'URL co van de: {len(bad)}')
print('\n'.join(bad[:40]))
