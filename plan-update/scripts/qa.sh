#!/usr/bin/env bash
# W7 QA — 8+ gate của plan-update/05 §3. Chạy từ thư mục tutorial-github-copilot:
#   bash plan-update/scripts/qa.sh
# Exit != 0 khi có gate FAIL. Gate 3 có danh sách MIỄN (dòng giải thích lỗi sai ❌ / tên cũ legacy).
set -uo pipefail
cd "$(dirname "$0")/../.." || exit 2
FAIL=0
say()  { printf '%s\n' "$*"; }
gate() { if [ "$2" = 0 ]; then say "PASS  $1"; else say "FAIL  $1 — $3"; FAIL=1; fi; }
EXCL=(-g '!plan-update/*' -g '!CHANGELOG.md' -g '!.git.bak/*')

# --- Gate 1: 18/18 bài có "## Mục tiêu bài học" ---
missing=$(find 01-huong-dan-su-dung -maxdepth 1 -name '[0-9]*.md' | sort | while read -r f; do
  grep -q '^## Mục tiêu bài học' "$f" || echo "$f"; done | wc -l | tr -d ' ')
gate "1. 18/18 bài có '## Mục tiêu bài học'" "$missing" "$missing bài thiếu"

# --- Gate 2: độ dài bài 150-210 (TB 150-200) ---
bad2=$(for f in 01-huong-dan-su-dung/[0-9]*.md; do n=$(wc -l < "$f"); [ "$n" -le 210 ] || echo "$f=$n"; done | tr '\n' ' ')
avg=$(awk '{s+=$1} END{printf "%d", s/NR}' <(for f in 01-huong-dan-su-dung/[0-9]*.md; do wc -l < "$f"; done))
gate "2. Mỗi bài <= 210 dòng (TB=$avg)" "$([ -z "$bad2" ] && echo 0 || echo 1)" "vượt cap: $bad2"

# --- Gate 3: từ vựng ma (dùng python vì BSD grep không có -g; miễn dòng ❌/legacy) ---
hits=$(python3 - <<'PY'
import re, pathlib
FORB = re.compile(r'premium[_ -]?requests?|Agent Customizations Hub|/summarize|/delegate|(^|[ `])/policy\b|/customAgent|Shift\+Alt\+I|Ctrl\+Shift\+I\b|128 tools|virtualTools|Waza|promptMigration|org-customizations', re.I)
FREE = re.compile(r'❌|tên cũ|legacy|ngày xưa|không còn|sai lầm|đã đổi|hôm nay|trước 0?6/2026|từ khóa cũ', re.I)
n = 0; samples = []
for f in pathlib.Path('.').rglob('*.md'):
    s = str(f)
    if s.startswith('plan-update') or s.startswith('./plan-update') or '.git' in s or s.endswith('CHANGELOG.md'): continue
    for i, line in enumerate(f.read_text(encoding='utf-8', errors='ignore').splitlines(), 1):
        # go URL khong anh huong: tu khoa ma chi tinh trong van ban, khong tinh duong dan tai lieu
        scan = re.sub(r'\]\([^)]+\)|https?://\S+', '', line)
        if FORB.search(scan) and not FREE.search(line):
            n += 1
            if len(samples) < 8: samples.append(f'{s}:{i}:{line[:70]}')
print(n, '|', ' ~ '.join(samples))
PY
)
gate "3. Không còn thuật ngữ ma" "${hits%% |*}" "$hits"

# --- Gate 4: .vscode/mcp.json không sống trong bucket copilot ---
n4=$(grep -rn '\.vscode/mcp\.json' 01-huong-dan-su-dung/commands/copilot --include='*.md' 2>/dev/null | grep -v 'vscode-mcp-json\|Local\|local/' | wc -l | tr -d ' ')
gate "4. commands/copilot không dạy .vscode/mcp.json" "$n4" "$n4 dòng (phải về local/)"

# --- Gate 5: mọi README lệnh có nhãn Harness/Surface (+ báo thiếu 13 mục) ---
n5=0; no5=()
while read -r f; do
  grep -qE '^> \*\*(Harness|Surface):|^\*\*Harness:' "$f" || { n5=$((n5+1)); no5+=("$f"); }
done < <(find 01-huong-dan-su-dung/commands -mindepth 4 -maxdepth 4 -name README.md | sort)
n5total=$(find 01-huong-dan-su-dung/commands -mindepth 4 -maxdepth 4 -name README.md | wc -l | tr -d ' ')
gate "5. $n5total slug có dòng Harness:/Surface:" "$n5" "${no5[*]:-}"
soft5=$(for f in $(find 01-huong-dan-su-dung/commands -mindepth 4 -maxdepth 4 -name README.md); do
  h=$(grep -c '^## ' "$f"); [ "$h" -ge 8 ] || echo "$(basename $(dirname $f))=$h"; done | tr '\n' ' ')
[ -n "$soft5" ] && say "note  5b. slug có <8 heading (13 mục STYLE §4): $soft5"

# --- Gate 6: linkcheck ---
node plan-update/scripts/linkcheck.js --quiet; rc=$?
gate "6. 0 link gãy (linkcheck.js)" "$rc" "xem output ở trên"
node plan-update/scripts/linkcheck.js --anchors --quiet 2>/dev/null | tail -1 | sed 's/^/note  6b. anchor: /'

# --- Gate 7: bucket.tsv khớp cây thư mục ---
fromTsv=$(awk -F'\t' 'FNR>1 && $3!="REMOVE"{print "01-huong-dan-su-dung/commands/"$3"/"$2"/"$1"/README.md"}' 01-huong-dan-su-dung/commands/bucket.tsv | sort)
fromTree=$(find 01-huong-dan-su-dung/commands -mindepth 4 -maxdepth 4 -name README.md | sort)
d7=$(diff <(echo "$fromTsv") <(echo "$fromTree") | grep -c '^[<>]')
gate "7. bucket.tsv khớp cây commands ($(echo "$fromTree" | wc -l | tr -d ' ') slug)" "$d7" "$(diff <(echo "$fromTsv") <(echo "$fromTree") | head -10 | tr '\n' '|')"

# --- Gate 8: mỗi bài có >=1 link vào examples/ + URL docs ở Reference ---
n8=0; l8=()
for f in 01-huong-dan-su-dung/[0-9]*.md; do
  grep -q 'examples/' "$f" || { n8=$((n8+1)); l8+=("$f:examples"); }
  grep -qE 'code\.visualstudio\.com/docs|docs\.github\.com' "$f" || { n8=$((n8+1)); l8+=("$f:docs-url"); }
done
gate "8. Mỗi bài: >=1 link examples/ + URL docs" "$n8" "${l8[*]:-}"

# --- Gate 9 (them): khong CJK, khong "## Muc luc" (python vi BSD grep khong co -P) ---
n9=$(python3 - <<'PY'
import re, pathlib
cjk = re.compile(r'[\u4e00-\u9fff\u3040-\u30ff\uac00-\ud7af]')
bad = []
for f in pathlib.Path('.').rglob('*.md'):
    s = str(f)
    if 'plan-update' in s or '/.git' in s: continue
    t = f.read_text(encoding='utf-8', errors='ignore')
    if cjk.search(t): bad.append(f'{s}:CJK')
    if '01-huong-dan-su-dung' in s and re.match(r'^[0-9]', f.name) and re.search(r'^## Mục lục', t, re.M):
        bad.append(f'{s}:TOC')
print(len(bad), bad[:6])
PY
)
gate "9. 0 file CJK + 0 bai co '## Muc luc'" "${n9%% *}" "$n9"

say ""; [ $FAIL = 0 ] && say "QA: tất cả gate XANH" || say "QA: CÒN ĐỎ — sửa rồi chạy lại"
exit $FAIL
