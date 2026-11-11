#!/bin/bash
# Kiem tra tran loi cua moi URL trong bien SOUT. Ghi SOUT: "<code> <final_url> <orig>"
while IFS= read -r u; do
  out=$(curl -s -o /dev/null -L --max-time 30 -w '%{http_code} %{url_effective}' "$u")
  echo "$out  $u"
done | sort -u
