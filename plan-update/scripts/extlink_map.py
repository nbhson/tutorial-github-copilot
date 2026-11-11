#!/usr/bin/env python3
"""Ke toan moi link ngoai (code.visualstudio.com, docs.github.com) theo section.
Tao /tmp/extlinks.json: [{file, line, heading_h2, heading_h3, url, host, text}]
va /tmp/exturls.txt: danh sach URL khac nhau (de curl status).
"""
import re, glob, json, collections, os

MD = re.compile(r'\[([^\]]*)\]\((https?://[^)\s]+)\)')
HEAD = re.compile(r'^(#{2,3})\s+(.*)$')
series_of = {'01-huong-dan-su-dung': 'lesson', '02-tips-thuc-chien': 'tips', '03-cau-hoi-thuong-gap': 'faq'}

rows = []
files = (sorted(glob.glob('01-huong-dan-su-dung/[0-9][0-9]-*.md'))
         + sorted(glob.glob('01-huong-dan-su-dung/commands/*/*/*/*/README.md'))
         + sorted(glob.glob('02-tips-thuc-chien/[0-9][0-9]-*.md'))
         + sorted(glob.glob('03-cau-hoi-thuong-gap/[0-9][0-9]-*.md')))
for f in files:
    h2 = h3 = ''
    for i, line in enumerate(open(f, encoding='utf-8'), 1):
        m = HEAD.match(line.rstrip())
        if m:
            if m.group(1) == '##': h2, h3 = m.group(2).strip(), ''
            else: h3 = m.group(2).strip()
        for mm in MD.finditer(line):
            url = mm.group(2)
            rows.append(dict(file=f, line=i, h2=h2, h3=h3, url=url,
                             host=url.split('/')[2], text=mm.group(1),
                             series=series_of[f.split('/')[0]]))
json.dump(rows, open('/tmp/extlinks.json', 'w'), ensure_ascii=False, indent=1)
urls = sorted({r['url'].split('#')[0] for r in rows})
open('/tmp/exturls.txt', 'w').write('\n'.join(urls) + '\n')
by_host = collections.Counter(r['host'] for r in rows)
print('rows', len(rows), dict(by_host))
print('unique urls', len(urls))
for h in by_host:
    u = sorted({r['url'].split('#')[0] for r in rows if r['host'] == h})
    print(f'--- {h}: {len(u)}')
    for x in u: print('   ', x)
