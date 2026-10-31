# Quét workflow có lộ secret/skip nguy hiểm không
grep -rn "dangerously-skip\|skip-verification\|echo.*secrets\.\|print.*secrets\." .github/workflows/ || echo "Workflows sach"
