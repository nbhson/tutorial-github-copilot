# Bai tap 1 - skill dau tien cua ban (gen-test), ~5 phut.
# 1. Tao folder + file SKILL.md (repo root):
mkdir -p .github/skills/gen-test

cat > .github/skills/gen-test/SKILL.md <<'EOF'
---
name: gen-test
description: >
  Viet va chay unit test cho mot file source.
  Dung khi user noi viet test, tao test, them test coverage, "test cho <file>".
---
# Gen test
1. Doc file duoc chi dinh + tim test hien co cua no (test/, *.test.ts).
2. Chon framework DUNG theo repo: kiem tra package.json scripts.test truoc khi viet.
3. Viet test cho canh bien (edge case), khong chi test happy path.
4. Chay lenh test da verify trong .github/copilot-instructions.md (khong tu nghi ra lenh).
5. Bao cao: test nao pass/fail, phan nao chua duoc cover.
## Cam
- NEVER sua source code khi dang luoc sinh test.
- NEVER gia lenh chay test; dung lenh that cua repo.
EOF

# 2. Commit + push (skill dung chung cho ca team):
git add .github/skills/gen-test && git commit -m "add gen-test skill" && git push

# 3. Verify (3 buoc trong tai lieu VS Code), lam trong session MOI, dung harness muon dung:
#    a. Go  /  -> gen-test co trong menu? Khong -> sai name/ten thu muc hoac sai cho dat.
#    b. Go tay  /gen-test src/utils/date.ts  -> xem tool activity + ket qua co di dung 5 buoc.
#    c. Test tu nap: noi "viet test cho src/utils/date.ts" (KHONG go /)
#       -> agent phai tu load skill, viet test, chay test.
#       Khong tu load? Sua cau DAU cua description - them dung tu ban hay go.
