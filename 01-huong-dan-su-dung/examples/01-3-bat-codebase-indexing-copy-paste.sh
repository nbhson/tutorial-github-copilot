# Repo settings tối ưu index (máy bạn):
# 1. .vscode/settings.json — files.exclude + search.exclude cho node_modules, dist, .next, coverage.
# 2. .gitignore sạch = index sạch (index theo git-tracked files):
git check-ignore -v dist/bundle.js node_modules/.package-lock.json   # phải ra "ignored"
# 3. Monorepo: chỉ mở package bạn làm (Add Folder to Workspace → apps/api) — index nhanh ~10x.
# VS Code: Chat → @workspace hiện "indexing..." là đang build lần đầu (repo lớn: 10–30 phút).
