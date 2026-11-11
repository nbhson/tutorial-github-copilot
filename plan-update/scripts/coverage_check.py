#!/usr/bin/env python3
"""Kiem tra bao phu docs-link theo section: section nao day khai niem/lenh ma khong co link
code.visualstudio.com hoac docs.github.com thi in ra (de bo sung vao doclink_map_*.json).
Bo qua cac section van dong (Muc tieu, Bai tap, Link qua, ...) hoac khi --all.
Loai: --series 01|02|03|cmd
"""
import re, sys, glob, os

ARGS = sys.argv[1:]
series = ARGS[ARGS.index('--series') + 1] if '--series' in ARGS else '01'
show_all = '--all' in ARGS
GLOBS = {'01': '01-huong-dan-su-dung/[0-9][0-9]-*.md', '02': '02-tips-thuc-chien/[0-9][0-9]-*.md',
         '03': '03-cau-hoi-thuong-gap/[0-9][0-9]-*.md', 'cmd': '01-huong-dan-su-dung/commands/*/*/*/README.md'}
SKIP_WORDS = ('mục tiêu', 'bài tập', 'link qua', 'tham khảo chéo', 'kiểm tra', 'ôn tập', 'tóm tắt',
              'mở đầu', 'still', 'vẫn lỗi', 'trạng thái nhanh')
DOCS = re.compile(r'https://(code\.visualstudio\.com|docs\.github\.com)/')
HEAD = re.compile(r'^(#{2,3})\s+(.*)$')
FENCE = re.compile(r'^\s*(```|~~~)')

tot = miss = 0
for f in sorted(glob.glob(GLOBS[series])):
    lines = open(f, encoding='utf-8').read().split('\n')
    heads = []
    inf = False
    for i, l in enumerate(lines):
        if FENCE.match(l): inf = not inf; continue
        m = HEAD.match(l)
        if m and not inf: heads.append((i, len(m.group(1)), m.group(2).strip()))
    for k, (i, lvl, title) in enumerate(h for h in heads if h[1] == 2):
        end = next((h[0] for h in heads if h[0] > i and h[1] <= 2), len(lines))
        body = '\n'.join(lines[i + 1:end])
        if not DOCS.search(body):
            tot += 1
            if not any(w in title.lower() for w in SKIP_WORDS) or show_all:
                miss += 1
                print(f'{os.path.basename(f):55s} L{i+1} ## {title[:70]}')
print(f'\n## heading thieu docs-link: {miss} (trong {tot} section khong dem)')
