#!/usr/bin/env python3
"""Doi chieu URL code.visualstudio.com trong repo voi cay tai lieu chinh thuc (llms.txt).

STALE  = duong dan khong con trong cay docs hien tai (can thay bang trang tuong ung)
ANCHOR = duong dan hop le nhung anchor co ve sai (kiem tra thu cong bang cach tai trang)
--refresh: tai lai llms.txt; --all: quet ca plan-update/ + templates/ (mac dinh bo plan-update).
"""
import re, os, sys, glob, json, collections, subprocess

TMP = '/private/var/folders/bl/8cp9kd_s0yx6q541cqdz3tpm0000gn/T/opencode'
INV_P = f'{TMP}/vsc-inv.json'
URL = re.compile(r'https://code\.visualstudio\.com(/docs/[^)\s`"\'<>#]+)(#[A-Za-z0-9_.,()-]+)?')
SKIP = () if '--all' in sys.argv else ('plan-update/',)

if '--refresh' in sys.argv or not os.path.exists(INV_P):
    subprocess.run(['curl', '-sL', 'https://code.visualstudio.com/llms.txt', '-o', f'{TMP}/vsc-llms.txt'], check=True)
    inv, sec = {}, ''
    for l in open(f'{TMP}/vsc-llms.txt', encoding='utf-8'):
        s = l.strip()
        if s.startswith('### '): sec = s[4:]
        m = re.match(r'^- \[([^\]]+)\]\(https://code\.visualstudio\.com/(docs/[^)]+?)\.md\)(?::\s*(.*))?$', s)
        if m: inv[m.group(2)] = (m.group(1), sec, m.group(3) or '')
    json.dump(inv, open(INV_P, 'w'), ensure_ascii=False)
inv = json.load(open(INV_P, encoding='utf-8'))
titles = {p: v[0] for p, v in inv.items()}

used = collections.defaultdict(list)
files = [f for f in sorted(glob.glob('**/*.md', recursive=True)) if not any(f.startswith(s) for s in SKIP)]
for md in files:
    for i, line in enumerate(open(md, encoding='utf-8'), 1):
        for m in URL.finditer(line):
            used[m.group(1).lstrip('/')].append((md, i, m.group(2) or '', line.strip()[:110]))

stale = {p: v for p, v in used.items() if p not in inv}
ok = {p: v for p, v in used.items() if p in inv}
print(f'URL code.visualstudio.com: {len(used)} duong dan, {sum(len(v) for v in used.values())} luot dung, {len(ok)} hop le')
print(f'\n### STALE ({len(stale)})')
for p, v in sorted(stale.items()):
    print(f'* {p}  ({len(v)} luot)')
    for f, l, a, src in v:
        print(f'    {f}:{l}  {a}')
print(f'\n### HOP LE nhung chua duoc bai nao dung ({len(set(inv) - set(used))} trang) — loc theo tu khoa AI')
KEY = ('agent', 'chat', 'copilot', 'language-model', 'mcp', 'skill', 'plugin', 'hook',
       'instruction', 'memory', 'terminal', 'settings', 'enterprise', 'worktree', 'extension')
unused = [p for p in sorted(set(inv) - set(used)) if any(k in p for k in KEY)]
for p in unused:
    print(f'    {p}  :: {titles[p]}')
