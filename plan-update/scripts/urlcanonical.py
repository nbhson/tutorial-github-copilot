#!/usr/bin/env python3
"""In bang "URL trong repo -> URL CHUAN (200 khong qua redirect)" cho moi URL bi redirect.
Moi URL thu 2 luot; khac nhau -> thu 6 luot va lay phan tu xuat hien nhieu nhat.
Ghi /tmp/urlmap.tsv (orig<TAB>canonical) va in ra stdout.
"""
import subprocess, sys, collections

def head(u):
    r = subprocess.run(['curl', '-s', '-o', '/dev/null', '-D-', '--max-time', '25', u],
                       capture_output=True, text=True).stdout
    code, loc = '', ''
    for l in r.split('\n'):
        if l.lower().startswith('http/'): code = l.split()[1]
        elif l.lower().startswith('location:'): loc = l.split()[1].strip()
    return code, loc

def is200(u):
    return head(u)[0] == '200'

def canonical(u, hops=6):
    cur, seen = u, set()
    for _ in range(hops):
        code, loc = head(cur)
        if code.startswith('2'):
            return cur
        if code.startswith('3') and loc:
            nxt = loc if loc.startswith('http') else cur.split('//')[0] + '//' + cur.split('//')[1].split('/')[0] + loc
            if nxt in seen: return cur
            seen.add(nxt); cur = nxt; continue
        return cur
    return cur

urls = [l.strip() for l in open(sys.argv[1] if len(sys.argv) > 1 else '/tmp/urls.txt') if l.strip()]
rows = []
for u in urls:
    fin = canonical(u)
    votes = collections.Counter(fin for _ in range(1 if fin == u else 2))
    if fin != u:
        cands = {fin}
        for _ in range(5):
            cands.add(canonical(u))
        live = sorted(c for c in cands if is200(c))
        pick = max(live, key=lambda x: (len(x.split('/')), len(x))) if live else fin
        rows.append((u, pick))
        flag = '  ⚠ nhieu muc tieu: ' + ' | '.join(live) if len(live) > 1 else ''
        print(f'{u}\n  -> {pick}{flag}')
with open('/tmp/urlmap.tsv', 'w') as f:
    for a, b in rows:
        f.write(f'{a}\t{b}\n')
print(f'\n{len(rows)}/{len(urls)} URL can thay → /tmp/urlmap.tsv')
