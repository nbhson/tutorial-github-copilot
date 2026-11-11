#!/usr/bin/env bash
# Baseline đo thật trước/sau khi sửa: 18 bài + README lệnh + examples. Chạy từ repo:
#   bash plan-update/scripts/baseline.sh > plan-update/scripts/baseline-$(date +%F).txt
cd "$(dirname "$0")/../.." || exit 2
echo "== 18 bai (duong dan: so dong) =="; for f in 01-huong-dan-su-dung/[0-9]*.md; do printf '%5d  %s\n' "$(wc -l < "$f")" "$f"; done
printf '%5d  TOTAL bai\n' "$(cat 01-huong-dan-su-dung/[0-9]*.md | wc -l)"
echo "== README lenh theo bucket =="
for b in copilot local cloud; do
  n=$(find "01-huong-dan-su-dung/commands/$b" -mindepth 3 -maxdepth 3 -name README.md 2>/dev/null | wc -l | tr -d ' ')
  s=$(cat $(find "01-huong-dan-su-dung/commands/$b" -mindepth 3 -maxdepth 3 -name README.md 2>/dev/null) 2>/dev/null | wc -l | tr -d ' ')
  printf '%-8s %2s slug  %5s dong  TB %s\n' "$b" "$n" "$s" "$([ "$n" -gt 0 ] && echo $((s/n)) || echo 0)"
done
echo "== group README =="; find 01-huong-dan-su-dung/commands -mindepth 3 -maxdepth 3 -name README.md | xargs wc -l | tail -1
echo "== commands/README.md =="; wc -l 01-huong-dan-su-dung/commands/README.md
echo "== examples =="
printf '01/examples: %s file, %s dong\n' "$(find 01-huong-dan-su-dung/examples -type f | wc -l | tr -d ' ')" "$(cat $(find 01-huong-dan-su-dung/examples -type f) | wc -l | tr -d ' ')"
printf 'commands/*/examples: %s file, %s dong\n' "$(find 01-huong-dan-su-dung/commands -path '*/examples/*' -type f | wc -l | tr -d ' ')" "$(cat $(find 01-huong-dan-su-dung/commands -path '*/examples/*' -type f) | wc -l | tr -d ' ')"
echo "== tong repo (trii plan-update) =="
find . -name '*.md' -not -path './plan-update/*' -not -path './.git/*' | xargs wc -l | tail -1
