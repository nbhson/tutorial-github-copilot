#!/usr/bin/env python3
"""In baang section -> URL docs trong tung section cua loai bai (01/02/03).
Dung de doi chieu noi dung section voi trang VS Code/GitHub duoc link.
Loc: --file <path> (chi 1 bai), --host code (chi URL code.visualstudio.com).
"""
import re, sys, glob, os, collections

ARGS = sys.argv[1:]
def arg(name):
    return ARGS[ARGS.index(name) + 1] if name in ARGS else None
only = arg('--file')
host_filter = arg('--host')
HOSTS = {'code': 'code.visualstudio.com', 'gh': 'docs.github.com'}
skip_no_docs = '--missing' in ARGS

files = ([only] if only else
         sorted(glob.glob('01-huong-dan-su-dung/[0-9][0-9]-*.md'))
         + sorted(glob.glob('02-tips-thuc-chien/[0-9][0-9]-*.md'))
         + sorted(glob.glob('03-cau-hoi-thuong-gap/[0-9][0-9]-*.md')))
LINK = re.compile(r'\[([^\]]*)\]\((https?://[^)\s]+)\)')
HEAD = re.compile(r'^(#{2,3})\s+(.*)$')

for f in files:
    lines = open(f, encoding='utf-8').read().split('\n')
    cur = None
    sections = []
    for i, l in enumerate(lines, 1):
        m = HEAD.match(l)
        if m and m.group(1) == '##':
            cur = dict(h2=m.group(2).strip(), urls=[], n=0, start=i)
            sections.append(cur)
        if not cur: continue
        cur['n'] += 1
        for t, u in LINK.findall(l):
            if host_filter and HOSTS[host_filter] not in u: continue
            cur['urls'].append((i, u, t))
    print(f'\n########## {f} ({len(lines)} dong)')
    for s in sections:
        if s['h2'].lower().startswith(('muc tieu', 'kiem tra', 'luyen tap', 'on tap', 'tom tat', 'link qua', 'mo dau', 'guong mat')):
            pass
        paths = ' '.join(u.split('#')[0].replace('https://code.visualstudio.com/docs/', 'VSC:')
                          .replace('https://docs.github.com/en/copilot/', 'GH:') for _, u, _ in s['urls'])
        print(f"  [{s['start']}] ## {s['h2']}  ({len(s['urls'])} link)")
        for i, u, t in s['urls']:
            print(f"        L{i} {u}   «{t}»")
        if not s['urls'] and not skip_no_docs:
            print('        (khong co link ngoai)')
