#!/usr/bin/env bash
# Audit dinh ky (moi quy) - bai 16 muc 5. Chay tren may dev + so voi bien ban quy truoc.
set -euo pipefail

# 1) Hien trang extensions: publisher la / version pin -> doi chieu 4 tang (muc 2).
code --list-extensions --show-versions | sort > "/tmp/ext-$(date +%F).txt"
#    So voi file quy truoc (doi duong dan cho khoi):
#    diff /tmp/ext-<QUY-TRUOC>.txt /tmp/ext-$(date +%F).txt
#    -> moi dong '+' phai co chu trong allowlist, khong co -> hoi owner ngay.

# 2) Hien trang plugins (cau lenh Copilot CLI - surface duoc docs document):
copilot plugin list            # ten, version, nguon, enabled?
#    Plugin nao "enabled" ma khong ai trong team nho cai khi nao -> audit lai tu dau.

# 3) Verify policy van con song (admin lam 1 lan/quy):
#    - chay 1 lenh thuoc permissions.deny -> phai bi "blocked by policy"
#    - dev sua settings local xin mo -> van bi chan = managed settings dang thang
#    - plugin bi enabledPlugins=false -> toggle local phai bi tu choi (badge Managed)

# 4) Ghi bien ban: pin SHA/version con hanh? tool nao leo quyen so voi quy truoc?
#    token service account -> quay vong 90 ngay (kinh nghiem thuc hanh).
