#!/usr/bin/env python3
"""Them dong trang quanh para-link '📄 [.. Docs: ..](..)' bi dinh sat dong truoc/sau.
Skip file da cham cap 210 dong (chi ap dung cho 01-huong-dan-su-dung/[0-9][0-9]-*.md).
"""
import re, glob, sys

APPLY = '--apply' in sys.argv
PARA = re.compile(r'^📄 \[(?:VS Code|GitHub) Docs:')
FENCE = re.compile(r'^\s*(```|~~~)')
CAP = re.compile(r'^01-huong-dan-su-dung/[0-9][0-9]-')

files = sorted(glob.glob('01-huong-dan-su-dung/*.md') + glob.glob('01-huong-dan-su-dung/commands/*/*/*/README.md')
               + glob.glob('02-tips-thuc-chien/[0-9][0-9]-*.md') + glob.glob('03-cau-hoi-thuong-gap/[0-9][0-9]-*.md'))
fixed = skipped = 0
for f in files:
    lines = open(f, encoding='utf-8').read().split('\n')
    idx = [i for i, l in enumerate(lines) if PARA.match(l)]
    if not idx: continue
    need = 0
    for i in idx:
        if i and lines[i - 1].strip(): need += 1
        if i + 1 < len(lines) and lines[i + 1].strip(): need += 1
    if CAP.match(f) and len([x for x in lines]) - 1 + need > 210:
        print(f'BO QUA (cap 210): {f} +{need} dong')
        skipped += 1
        continue
    out, inf = [], False
    for i, l in enumerate(lines):
        if FENCE.match(l): inf = not inf
        if not inf and PARA.match(l) and out and out[-1].strip():
            out.append('')
        out.append(l)
        if not inf and PARA.match(l) and i + 1 < len(lines) and lines[i + 1].strip():
            out.append('')
    if out != lines:
        fixed += 1
        if APPLY:
            open(f, 'w', encoding='utf-8').write('\n'.join(out))
print(f'{"da chen dong trang" if APPLY else "se chen dong trang"}: {fixed} file | bo qua vi cap: {skipped}')
