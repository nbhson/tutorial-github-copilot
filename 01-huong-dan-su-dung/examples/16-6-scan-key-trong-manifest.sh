#!/usr/bin/env bash
# Quet manifest TRUOC KHI PUBLISH plugin (bai 16 muc 6).
# DAY LA SCRIPT THUC HANH CUA KHOA HOC - khong phai lenh chinh thuc cua Copilot CLI.
# Dung: ./16-6-scan-key-trong-manifest.sh ./duong-dan-plugin
set -euo pipefail
PLUGIN_DIR="${1:?vd: ./16-6-scan-key-trong-manifest.sh ./my-plugin}"

# 1) Key dai loan nam trong file se bi commit cong khai? (token mau pho bien)
if grep -rnE 'ghp_[A-Za-z0-9]{36}|github_pat_[A-Za-z0-9_]{20,}|AKIA[0-9A-Z]{16}|-----BEGIN|(api[_-]?key|token|secret|password)["\x27]?\s*[:=]\s*["\x27][A-Za-z0-9/+._-]{12,}' \
     --include='*.json' --include='*.md' --include='*.sh' --include='*.cjs' --include='*.js' "$PLUGIN_DIR"; then
  echo "FAIL: phat hieu dang key trong manifest/hooks - chuyen sang env / \${PLUGIN_DATA}, roi scan lai"
  exit 1
fi

# 2) plugin.json co phai schema dong Agent Plugins 1.0 khong? (can jq)
if command -v jq >/dev/null; then
  ALLOWED='["$schema","name","version","description","author","homepage","repository","license","keywords","extensions"]'
  EXTRA=$(jq -r --argjson allowed "$ALLOWED" 'keys_unsorted - $allowed | join(", ")' "$PLUGIN_DIR/plugin.json" 2>/dev/null || true)
  if [ -n "${EXTRA:-}" ]; then
    echo "CANH BAO: field ngoai schema se bi 'reported and ignored': $EXTRA"
    echo "  (di dung component -> doi sang skills/, mcp.json, com.github.copilot/ - muc 3)"
  fi
fi

echo "PASS: khong thay key lo; kiem tra cuoi: van phai tay doc plugin.json + mcp.json + hooks (muc 5)."
