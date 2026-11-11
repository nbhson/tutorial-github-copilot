#!/usr/bin/env python3
"""Migrate examples/ sang folder per-bai + rewrite toan bo duong dan.
Mac dinh: DRY RUN (in 10 vi du rewrite). --apply: rewrite file + git mv + moves.json.
Scheme: 01-huong-dan-su-dung/examples/08-mcp-ket-noi-cong-cu-ngoai/5-approval-allow-ask-deny.jsonc
        01-huong-dan-su-dung/examples/commands/vscode-mcp-json/cach-goi-copy-paste.sh
        02-tips-thuc-chien/examples/06-policies-guardrails-recipes/4-lop-2-pre-commit-local-gates.yaml
        03-cau-hoi-thuong-gap/examples/04-mcp-faq/6-mcp-postgres-tro-prod-lam-sao-khong.sql
"""
import re, os, sys, glob, json, collections

APPLY = '--apply' in sys.argv
SERIES = ('01-huong-dan-su-dung', '02-tips-thuc-chien', '03-cau-hoi-thuong-gap')
NUMSEG = re.compile(r'^\d\d(?:-\d+(?:\.\d+)?)*-')
REF = re.compile(br'(?<![\w/.-])((?:\.{1,2}/[\w./-]*/)?examples/[0-9][^()\s`|]*?\.(?:jsonc|json|sh|md|ts|yaml|yml|sql|instructions\.md|agent\.md))(?![\w-])')
REF2 = re.compile(br'(?<![\w/.-])((?:\.{1,2}/[\w./-]*/)?examples/commands/[^()\s`|]+?\.(?:jsonc|json|sh|md|ts|yaml|yml|sql))(?![\w-])')
BARE = re.compile(br'`([0-9][\w.-]*?\.(?:jsonc|json|sh|yaml|yml|sql))`')

owners = {p: o for p, o in json.load(open('/tmp/exowners.json')).items()
          if re.match(r'(01-huong-dan-su-dung|02-tips-thuc-chien|03-cau-hoi-thuong-gap)/examples/[^/]+\.(jsonc|json|sh|md|ts|yaml|yml|sql)$', p)}
moves = {}
for path, olist in owners.items():
    series = path.split('/')[0]
    name = os.path.basename(path)
    newname = NUMSEG.sub('', name, count=1)
    if series == '01-huong-dan-su-dung':
        root_lessons = [x for x in olist if re.match(r'01-huong-dan-su-dung/\d\d-', x)]
        cmds = [x for x in olist if '/commands/' in x]
        cand = (cmds or root_lessons) if path.startswith('01-huong-dan-su-dung/commands/') else (root_lessons or olist)
    elif series == '02-tips-thuc-chien':
        cand = [x for x in olist if x.startswith('02-tips')] or olist
    else:
        cand = [x for x in olist if x.startswith('03-cau')] or olist
    own = sorted(cand)[0]
    bn = os.path.basename(own)
    if '/commands/' in own:
        slug = own.split('/commands/')[1].rsplit('/README.md')[0].split('/')[-1]
        sub = f'commands/{slug}'
    else:
        sub = bn[:-3]
    moves[path] = f'{series}/examples/{sub}/{newname}'

# giai va cham trong cung folder: danh so thu tu (1,2,3...) theo ten cu — day la cac buoc noi tiep cua recipe
conflicts = [k for k, v in collections.Counter(moves.values()).items() if v > 1]
for tgt in conflicts:
    olds = sorted(x for x, n in moves.items() if n == tgt)
    for i, o in enumerate(olds, 1):
        nm = tgt.rsplit('/', 1)[1]
        moves[o] = tgt.rsplit('/', 1)[0] + f'/{i}-{nm}'

tg = collections.Counter(moves.values())
coll = [k for k, v in tg.items() if v > 1]
by_folder = collections.Counter(os.path.dirname(v) for v in moves.values())
print(f'{len(moves)} file -> {len(by_folder)} folder; va cham: {len(coll)}')
if coll: sys.exit('COLLIDE ' + str(coll))

TEXT = ('.md', '.sh', '.json', '.jsonc', '.yaml', '.yml', '.ts')
corpus = [p for p in glob.glob('**/*', recursive=True)
          if os.path.isfile(p) and p.endswith(TEXT) and '/.git/' not in p]
BAREMAP = collections.defaultdict(list)
for old, new in moves.items():
    BAREMAP[os.path.basename(old).encode()].append(new)

state = {'n': 0, 'samples': []}
for src in corpus:
    d = os.path.dirname(src) or '.'
    data = open(src, 'rb').read()
    orig = data

    def fix(match, full=False):
        ref = match.group(1).decode()
        target = ref if full else os.path.normpath(os.path.join(d, ref))
        new = moves.get(target)
        if not new: return match.group(0)
        r = os.path.normpath(os.path.relpath(new, d))
        if not r.startswith('.'): r = './' + r
        state['n'] += 1
        if len(state['samples']) < 10 and r != ref:
            state['samples'].append(f'{src}: {ref} -> {r}')
        return r.encode()

    data = re.sub(REF2, lambda m: fix(m, full=True), data)
    data = re.sub(REF, lambda m: fix(m), data)
    if src.endswith('.md'):
        def bare(m):
            cands = BAREMAP.get(m.group(1))
            if not cands or len(set(cands)) != 1: return m.group(0)
            r = os.path.normpath(os.path.relpath(cands[0], d))
            if not r.startswith('.'): r = './' + r
            state['n'] += 1
            return ('`' + r + '`').encode()
        data = re.sub(BARE, bare, data)
    if data != orig and APPLY:
        open(src, 'wb').write(data)

print(f"total refs rewritten: {state['n']}")
for s in state['samples']: print('  ', s)
if APPLY:
    for old, new in sorted(moves.items()):
        os.makedirs(os.path.dirname(new), exist_ok=True)
        if os.system(f'git mv "{old}" "{new}"') != 0:
            sys.exit('git mv fail: ' + old)
    json.dump(moves, open('/tmp/exmoves.json', 'w'), ensure_ascii=False, indent=1)
    print('APPLIED', len(moves), 'moves')
else:
    json.dump(moves, open('/tmp/exmoves_plan.json', 'w'), ensure_ascii=False, indent=1)
    for k, v in list(sorted(moves.items()))[:6]:
        print(' ', k, '->', v)
