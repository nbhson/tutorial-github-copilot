#!/usr/bin/env python3
"""Tom tat moi file: heading ##/### + 2 dong dau tien cua body (cat ngan) + gia tri cua tung section.
Dung cho buoc chon trang VS Code docs phu hop cho tung section. --limit N de xem N bai."""
import re, glob, sys

LIM = int(sys.argv[sys.argv.index('--limit') + 1]) if '--limit' in sys.argv else 99
only = sys.argv[1] if len(sys.argv) > 1 and not sys.argv[1].startswith('--') else None
files = [only] if only else sorted(glob.glob('01-huong-dan-su-dung/[0-9][0-9]-*.md'))
HEAD = re.compile(r'^(#{2,3})\s+(.*)$')
for f in files[:LIM]:
    lines = open(f, encoding='utf-8').read().split('\n')
    print(f'\n@@@ {f}')
    for i, l in enumerate(lines, 1):
        m = HEAD.match(l)
        if m:
            print(f'  L{i} {m.group(1)} {m.group(2)}')
            n = 0
            for j in range(i, min(i + 9, len(lines))):
                s = lines[j].strip()
                if not s or HEAD.match(lines[j]) or s.startswith('```'): continue
                if s.startswith('|') and n >= 1: break
                print(f'        {s[:170]}')
                n += 1
                if n >= 2: break
