git bisect start
git bisect bad HEAD
git bisect good v1.2.0
# Mỗi bước chạy: npm test -- <scope> → good/bad
git bisect reset
# Kỳ vọng: ~log2(số commit) lần chạy, khoanh được 1 commit gây lỗi.
