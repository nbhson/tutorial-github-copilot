#!/usr/bin/env python3
"""Go toan bo docs-link do apply_doclinks.py chen vao `01-huong-dan-su-dung/commands/**/README.md`
de chay lai voi map moi (khong anh huong lessons/tips/FAQ).

Cac dang da chen:
  - duoi toi: ' · 📄 [VS Code Docs: X](url)' / ' · 📄 [GitHub Docs: X](url)'
  - dong para rieng: '📄 [.. Docs: ..](..)' + dong trang chen truoc no
Sau khi go: nap <2 dong trang lien tiep thanh 1 (ngoai code fence).
"""
import re, glob, sys

TAIL = re.compile(r'\s*·\s*📄 \[(?:VS Code|GitHub) Docs: [^\]]+\]\((?:https://(code\.visualstudio\.com|docs\.github\.com)/[^)]+)\)\s*$')
PARA = re.compile(r'^📄 \[(?:VS Code|GitHub) Docs: [^\]]+\]\([^)]+\)$')
FENCE = re.compile(r'^\s*(```|~~~)')

files = sys.argv[1:] or glob.glob('01-huong-dan-su-dung/commands/*/*/*/README.md')
tot = 0
for f in files:
    src = open(f, encoding='utf-8').read()
    lines = src.split('\n')
    out, inf, n = [], False, 0
    for l in lines:
        if FENCE.match(l):
            inf = not inf
            out.append(l); continue
        if not inf and PARA.match(l.strip()):
            n += 1
            if out and out[-1].strip() == '':
                out.pop()            # bo dong trang chen vao truoc para-link
            continue
        if not inf:
            new = TAIL.sub('', l)
            if new != l: n += 1
            out.append(new)
        else:
            out.append(l)
    # nap dong trang kep (chi ngoai fence)
    fin, inf, prev_blank = [], False, False
    for l in out:
        if FENCE.match(l):
            inf = not inf; fin.append(l); prev_blank = False; continue
        if not inf and l.strip() == '':
            if prev_blank: continue
            prev_blank = True
        else:
            prev_blank = False
        fin.append(l)
    if n:
        open(f, 'w', encoding='utf-8').write('\n'.join(fin))
        tot += n
print(f'{tot} docs-link da go khoi {len(files)} README lenh')
