#!/usr/bin/env python3
"""Audit link ví du — tieu chi that:
CAN: (fenced code >=12 dong HOAC >=2 ten file cau hinh) VA section day tinh "artifact"
     (co mo ta file/config lenh ma khong block nao du dai de copy)
DU:  co link ](...examples/...) hoac block >=12 dong (ban than no la ví du copy-duoc)
BO QUA: Muc tieu / Link qua / Reference / Tham khao / So sanh
"""
import re, sys, glob

FENCE = re.compile(r'^```')
FNAME = re.compile(r'[\w.\-]+\.(jsonc|json|ya?ml|sh|ts|md)\b')
SKIP_H = re.compile(r'^(Mục tiêu|Link qua|Reference|Tham khảo|So sánh|Cấu trúc|Lộ trình|Phiên bản|Đóng góp|Non-coder|Bài học)')

def sections(path):
    lines = open(path, encoding='utf-8').read().split('\n')
    secs, cur, fence = [], None, False
    for i, l in enumerate(lines, 1):
        if FENCE.match(l): fence = not fence
        if not fence and re.match(r'^#{2,3} ', l):
            if cur: secs.append(cur)
            cur = {'h': l.lstrip('# ').strip(), 'ln': i, 'body': []}
            continue
        if cur is not None: cur['body'].append(l)
    if cur: secs.append(cur)
    out = []
    for s in secs:
        body = '\n'.join(s['body'])
        blocks = [b for b in re.findall(r'```[^\n]*\n(.*?)```', body, re.S)]
        s['maxblock'] = max((b.count('\n') for b in blocks), default=0)
        s['nblock'] = len(blocks)
        s['files'] = len(set(m.group(0) for m in FNAME.finditer(body)))
        s['ex'] = len(re.findall(r'\]\([^)]*(examples/|templates/|commands/)[^)]*\)', body))
        s['cmd'] = len(re.findall(r'`(copilot |gh |code |npx |git |MCP: |Chat: |Developer: |/[\w-]+)', body))
        out.append(s)
    return out

targets = sorted(glob.glob('01-huong-dan-su-dung/[0-9]*.md')) + sorted(glob.glob('02-tips-thuc-chien/[0-9]*.md')) + sorted(glob.glob('03-cau-hoi-thuong-gap/[0-9]*.md'))
if len(sys.argv) > 1: targets = [t for t in targets if any(a in t for a in sys.argv[1:])]
rows = []
for t in targets:
    for s in sections(t):
        if SKIP_H.match(s['h']) or s['ex']: continue
        if s['maxblock'] >= 12: continue           # da co block copy-paste ngay trong section
        if s['files'] >= 2 or (s['maxblock'] >= 4 and s['cmd'] >= 2):
            rows.append((t, s))
cur = None
for t, s in rows:
    if t != cur: cur = t; print(f"\n=== {t} ===")
    print(f"  L{s['ln']:>3} [block={s['maxblock']}, file={s['files']}, lenh={s['cmd']}] ## {s['h'][:62]}")
print(f"\nTONG: {len(rows)} section that su thieu link ví du")
