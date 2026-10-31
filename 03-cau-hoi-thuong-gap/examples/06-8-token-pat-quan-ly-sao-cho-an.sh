# Quét repo có ai hardcode token không
grep -rEn "ghp_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}|sk-live-[A-Za-z0-9]{10,}" --exclude-dir=node_modules --exclude-dir=.git . || echo "Sach"
