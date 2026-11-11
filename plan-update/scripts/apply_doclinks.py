#!/usr/bin/env python3
"""Chen link tail lieu chinh thuc (VS Code / GitHub docs) vao CUOI moi section theo map JSON.

Mac dinh DRY RUN. --apply de ghi file. --force de chen ca khi section da co link docs.
Map: plan-update/scripts/doclink_map_*.json  {m: [[<bai>, <heading prefix>, <url>, <label>], ...]}
Quy tac:
  - chi THEM text vao dong cuoc (khong them dong) -> khong phat cap 210 dong/bai
  - uu tien dong cuoi dang blockquote (> **Tóm gọn...**), khong thi dong van xuong cuoi
  - bo qua dong trong code fence, bang (|), heading
  - validate: VSC path phai co trong llms.txt; anchor phai co trong TOC (/tmp/vsc-toc.txt);
    GH path phai co trong pagelist (/tmp/gh-pagelist.txt) hoac tra ve 200
"""
import json, re, os, sys, glob, subprocess, collections

APPLY = '--apply' in sys.argv
FORCE = '--force' in sys.argv
HERE = os.path.dirname(os.path.abspath(__file__))
MAPS = [f for f in glob.glob(f'{HERE}/doclink_map_*.json')]
TMP = '/private/var/folders/bl/8cp9kd_s0yx6q541cqdz3tpm0000gn/T/opencode'
inv = json.load(open(f'{TMP}/vsc-inv.json', encoding='utf-8'))
toc = collections.defaultdict(set)
if os.path.exists('/tmp/vsc-toc.txt'):
    for l in open('/tmp/vsc-toc.txt', encoding='utf-8'):
        p = l.rstrip('\n').split('\t')
        if len(p) == 3: toc[p[0]].add(p[1])
GH_GLOBS = ('/tmp/gh-pagelist.txt',)
gh_paths = set()
for g in GH_GLOBS:
    if os.path.exists(g):
        gh_paths |= {l.strip().lstrip('/') for l in open(g) if l.strip()}

LIVE = {}
LIVE_CACHE = f'{TMP}/gh-live.json'
if os.path.exists(LIVE_CACHE):
    LIVE = json.load(open(LIVE_CACHE, encoding='utf-8'))

def gh_live_check(url):
    '''URL GH khong nam trong pagelist (harvest thieu) -> kiem tra that qua HTTP.'''
    if url not in LIVE:
        try:
            out = subprocess.run(['curl', '-s', '-o', '/dev/null', '-w', '%{http_code} %{redirect_url}', url],
                                 capture_output=True, text=True, timeout=30).stdout.split()
            LIVE[url] = [out[0] if out else '000', out[1] if len(out) > 1 else '']
        except Exception:
            LIVE[url] = ['000', '']
        json.dump(LIVE, open(LIVE_CACHE, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    code, loc = LIVE[url]
    if code == '200': return ''
    if code in ('301', '302', '307', '308') and loc: return f'URL chuyen huong -> {loc}'
    return f'GH HTTP {code}: {url}'

def validate(url):
    host = url.split('/')[2]
    parts = url.split('#', 1)
    path, anchor = parts[0], (parts[1] if len(parts) > 1 else '')
    if host == 'code.visualstudio.com':
        p = path.replace('https://code.visualstudio.com/', '')
        if p not in inv: return f'VSC path khong co trong llms.txt: {p}'
        if anchor and toc[p] and anchor not in toc[p]:
            return f'anchor "{anchor}" khong co trong {p} (TOC: {sorted(toc[p])[:6]}...)'
    elif host == 'docs.github.com':
        p = path.replace('https://docs.github.com/', '').lstrip('/')
        if gh_paths and p not in gh_paths:
            return gh_live_check(path)      # pagelist thieu -> hoi that (co cache)
    else:
        return f'host ngoai danh muc: {host}'
    return ''

def find_file(stem):
    for pat in (f'01-huong-dan-su-dung/{stem}.md', f'02-tips-thuc-chien/{stem}.md', f'03-cau-hoi-thuong-gap/{stem}.md'):
        if os.path.isfile(pat): return pat
    for pat in (stem, f'{stem}.md', f'{stem}/README.md'):   # stem la duong dan day du (README lenh)
        if os.path.isfile(pat): return pat
    return None

HEAD = re.compile(r'^(#{2,4})\s+(.*)$')
SKIP_START = ('|', '#', '>', '```')

def _kind(s):
    if not s: return 'edge'
    if s.startswith('```'): return 'fence'
    if HEAD.match(s): return 'head'
    if s.startswith('|'): return 'table'
    if s.startswith('>'): return 'quote'
    return 'text'

def _scan(lines, start, end):
    """Tra ve (prose_lines, blank_lines) trong [start, end), bo qua code fence.
    blank chi duoc dung khi no la bien block (dau/cuoi heading, fence) va kh gop 2 doan van."""
    prose, blanks, in_f = [], [], False
    for j in range(start, end):
        l = lines[j]
        if l.strip().startswith('```'):
            in_f = not in_f; continue
        if in_f:
            continue
        if not l.strip():
            prev = next((lines[k].strip() for k in range(j - 1, start - 1, -1) if lines[k].strip()), '')
            nxt = next((lines[k].strip() for k in range(j + 1, min(len(lines), end + 1)) if lines[k].strip()), '')
            if _kind(prev) in ('head', 'fence', 'edge') or _kind(nxt) in ('head', 'fence', 'edge'):
                blanks.append(j)
            continue
        if HEAD.match(l): continue
        if not l.startswith('|'):
            prose.append((j, l))
    return prose, blanks

def plan_for(path, entries):
    lines = open(path, encoding='utf-8').read().split('\n')
    heads = []
    open_fence = False
    for i, l in enumerate(lines):
        if l.strip().startswith('```'):
            open_fence = not open_fence; continue
        m = HEAD.match(l)
        if m and not open_fence:
            heads.append((i, len(m.group(1)), m.group(2).strip()))
    used = set()
    out = []
    for hp, url, label in sorted(entries, key=lambda e: next((h[0] for h in heads if h[2].startswith(e[0].split(' ', 1)[1])), 9999)):
        lvl_txt = hp.split(' ', 1)[1] if hp.startswith('#') else hp
        lvl = len(hp.split(' ')[0]) if hp.startswith('#') else 2
        hit = next(((i, l, t) for i, l, t in heads if l == lvl and t.startswith(lvl_txt)), None)
        if not hit:
            out.append(dict(hp=hp, line=None, note=f'KHONG THAY heading {hp!r}')); continue
        i, _, title = hit
        tight = next((h[0] for h in heads if h[0] > i), len(lines))
        wide = next((h[0] for h in heads if h[0] > i and h[1] <= lvl), len(lines))
        here = url.split('#', 1)[0]
        if any(here in l for l in lines[i + 1:wide]):
            out.append(dict(hp=hp, line=None, note=f'section da co link cung trang ({here.split("/docs/")[-1] or here.split("/copilot/")[-1]})'))
            continue
        err = validate(url)
        if err:
            out.append(dict(hp=hp, line=None, note=err)); continue
        src = 'VS Code Docs' if 'code.visualstudio.com' in url else 'GitHub Docs'
        cand = [c for c in _scan(lines, i + 1, tight)[0] if c[0] not in used]
        mode = 'inline'
        if not cand:
            cand = [c for c in _scan(lines, i + 1, wide)[0] if c[0] not in used]
        if not cand:
            blanks = [j for j in _scan(lines, i + 1, tight)[1] if j not in used]
            mode = 'para'
            if not blanks:
                blanks = [j for j in _scan(lines, i + 1, wide)[1] if j not in used]
            cand = [(j, '') for j in blanks]
        if not cand:
            out.append(dict(hp=hp, line=None, note=f'khong con dong an toan trong {title}')); continue
        pref = [c for c in cand if c[1].startswith('> ') and 'Code ví dụ' not in c[1]]
        if not pref:
            pref = [c for c in cand if c[1].startswith('> ')]
        if not pref:
            pref = [c for c in cand if 'Code ví dụ' not in c[1]]
        j, target = (pref or cand)[-1]
        add = f' · 📄 [{src}: {label}]({url})' if mode == 'inline' else f'📄 [{src}: {label}]({url})'
        used.add(j)
        out.append(dict(hp=hp, line=j, add=add, mode=mode, ctx=(target[:78] or '(dong trang)')))
    return lines, out

changed_files = 0
for mf in MAPS:
    data = json.load(open(mf, encoding='utf-8'))['m']
    by_file = collections.defaultdict(list)
    for stem, hp, url, label in data:
        by_file[stem].append((hp, url, label))
    print(f'\n===== {os.path.basename(mf)} ({sum(len(v) for v in by_file.values())}) entry)')
    for stem, entries in sorted(by_file.items()):
        path = find_file(stem)
        if not path:
            print(f'  KHONG TIM BAI: {stem}'); continue
        lines, plan = plan_for(path, entries)
        done, skip = 0, 0
        for e in plan:
            if e.get('line') is None:
                print(f'  - {os.path.basename(path)} {e["hp"]}: {e["note"]}'); skip += 1
            else:
                done += 1
                print(f'  + {os.path.basename(path)}:{e["line"] + 1} [{e["mode"]}] {e["hp"]}')
                print(f'      @ {e["ctx"]}')
                print(f'      -> {e["add"][:130]}')
                if APPLY: lines[e['line']] = lines[e['line']] + e['add']
        if done and APPLY:
            open(path, 'w', encoding='utf-8').write('\n'.join(lines))
        changed_files += 1 if done else 0
        if done or skip:
            print(f'    => {os.path.basename(path)}: chen {done}, bo qua {skip}')
print(f'\n{"APPLIED" if APPLY else "DRY RUN"} — {changed_files} file')
