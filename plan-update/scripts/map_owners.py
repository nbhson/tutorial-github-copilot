#!/usr/bin/env python3
"""Deplan: map moi file trong <series>/examples/ <- bai chu (file md link toi no).
In ra JSON: {old_rel: [owner_md, ...]} de duyet tay truoc khi migrate."""
import re, glob, os, json, collections

ROOT = os.getcwd()
LINK = re.compile(r'\]\(([^)#]*examples/[^)#]+\.(?:jsonc|json|sh|md|ts|yaml|yml|sql))\)')
CODEP = re.compile(r'`((?:\.\./[^`]*/)?examples/[^`]+\.(?:jsonc|json|sh|md|ts|yaml|yml|sql))`')

owners = collections.defaultdict(set)
mds = sorted(glob.glob('01-huong-dan-su-dung/[0-9][0-9]-*.md')
            + glob.glob('01-huong-dan-su-dung/commands/*/*/*/*/README.md')
            + glob.glob('02-tips-thuc-chien/[0-9]*.md')
            + glob.glob('03-cau-hoi-thuong-gap/[0-9]*.md'))
for md in mds:
    for m in LINK.findall(open(md, encoding='utf-8').read()):
        p = os.path.normpath(os.path.join(os.path.dirname(md), m))
        if 'examples/' in p and os.path.isfile(p):
            owners[p].add(md)
# index file duoi examples cua tung series
have = set()
for s in ['01-huong-dan-su-dung', '02-tips-thuc-chien', '03-cau-hoi-thuong-gap']:
    for p in glob.glob(f'{s}/examples/**/*', recursive=True):
        if os.path.isfile(p) and not p.endswith('README.md'):
            have.add(p)
noowner = sorted(have - set(owners))
print('=== SO HUU ===')
for p in sorted(owners):
    print(p, '  <-', ', '.join(sorted(owners[p])))
print(f'\n=== KHONG CO CHU ({len(noowner)}) ===')
for p in noowner: print(p)
print(f'\nTong file: {len(have)}, duoc link: {len(owners & have if False else set(owners) & have)}')
json.dump({p: sorted(o) for p, o in owners.items()}, open('/tmp/exowners.json', 'w'), ensure_ascii=False, indent=1)
