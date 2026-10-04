# FAQ 09 — Bảo Mật, Quyền & Riêng Tư

> Nhóm Security & Privacy · 10 câu hỏi deep-dive · Đọc xong trả lời được "code có bị train không, secret lộ thì sao, audit ở đâu"

File này trả lời mọi câu hỏi "training exclusion, duplication detection, secret scanning, audit logs, ZDR tương đương". Mỗi câu có giải thích + lệnh copy-paste + ví dụ + khi nào áp dụng.

---

## Bảng tổng hợp: lo gì → đọc câu nào

| Lo ngại | Câu trả lời ngắn | Câu |
|---|---|---|
| Code bị dùng train model? | Individual: có thể (trừ khi opt-out); Business/Enterprise: không | 1 |
| Copilot gợi ý trúng code người khác? | Bật duplication detection filter | 2 |
| Secret lỡ lộ? | Xoay key + secret scanning + push protection | 3, 4 |
| Ai đã làm gì? | Audit log org + git history | 5 |
| ZDR tương đương? | Enterprise + data residency/Azure routing | 6 |
| File nhạy cảm? | Content exclusion 2 mức | 7 |

---

## 1. Code của tôi có bị dùng để train model không?

**Giải thích.** Quy tắc 2026 (luôn verify lại ở `github.com/settings/copilot` vì policy có thể đổi):

- **Individual/Pro mặc định:** GitHub có thể dùng snippets để cải thiện model, TRỪ KHI bạn tắt "Allow GitHub to use my code snippets for product improvements".
- **Business/Enterprise:** snippets KHÔNG dùng để train (cam kết trong điều khoản thương mại).
- Dữ liệu truyền đi khi dùng vẫn qua TLS, giữ tạm để phục vụ request rồi xóa theo retention policy.

**Lệnh copy-paste:**

```bash
# Không có CLI; check + tắt trên web:
# https://github.com/settings/copilot
# -> Bỏ tick "Allow GitHub to use my code snippets..."
# -> Bật "Duplication detection filter" (câu 2)
```

**Ví dụ:** freelancer dùng Individual làm code client NDA → tắt snippet training ngay + bật duplication filter trước khi mở file NDA.

**Khi nào áp dụng:** setup máy mới (check 1 lần), và trước khi làm code NDA/compliance.

---

## 2. Duplication detection là gì, bật sao?

**Giải thích.** Filter chặn Copilot gợi ý đoạn code **trùng khớp dài** với public code (VD >150 ký tự quanh match) — giảm rủi ro dính license người khác. Bật ở `github.com/settings/copilot` (cá nhân) hoặc org policy (ép cả org).

Trade-off: bật → ít gợi ý dài "ngon ăn sẵn" hơn 1 chút; tắt → năng suất cao hơn nhưng tự chịu trách nhiệm license.

**Lệnh copy-paste:**

```bash
# Check nhanh repo có file LICENSE không (liên quan trách nhiệm license)
ls LICENSE* 2>/dev/null || echo "Chua co LICENSE - them di"
# Web: github.com/settings/copilot -> bật "Suggestions matching public code: Block"
```

**Ví dụ:** team enterprise làm sản phẩm closed-source → admin ép Block cho cả org → dev khỏi lo gợi ý dính GPL.

**Khi nào áp dụng:** bật mặc định mọi account; org closed-source thì ép bằng policy.

---

## 3. Lỡ commit secret thì xử lý sao (xoay + xóa)?

**Giải thích.** Thứ tự BẮT BUỘC: **xoay/revoke key TRƯỚC, dọn history SAU.** Xóa commit mà không xoay key = key vẫn sống trong tay kẻ đã clone. Secret đã push lên GitHub coi như đã lộ.

**Lệnh copy-paste:**

```bash
# 1. Revoke/rotate TRÊN DASHBOARD provider trước (Stripe/GitHub/AWS...) - làm bằng tay ngay

# 2. Xóa file khỏi tracking + commit mới
git rm --cached secrets/leaked.key
echo "secrets/" >> .gitignore
git commit -m "chore(security): remove leaked secret, rotated key"

# 3. Quét cả history xem còn sót không
gitleaks detect --verbose
gh api repos/<OWNER>/<REPO>/secret-scanning/alerts --jq '.[] | {secret_type, state}'
```

**Ví dụ:** push nhầm `sk-live_...` → vào Stripe dashboard roll key (2 phút) → rồi mới `git rm + commit + push` → key cũ vô hiệu dù ai đã thấy.

**Khi nào áp dụng:** ngay khi phát hiện — xoay key tính bằng phút, dọn history tính bằng giờ.

---

## 4. Secret scanning + push protection (nhắc lại, góc bảo mật)?

**Giải thích.** Xem cấu hình ở [bài 05](05-policies-guardrails-faq.md) câu 5. Góc bảo mật bổ sung:

- **Push protection bypass:** khi bị chặn mà chắc là false positive (VD key test), GitHub cho bypass có lý do — lý do này vào audit log, admin thấy.
- **Validity check:** một số provider (Stripe, AWS...) GitHub tự check key còn sống không → alert `active` là ưu tiên xoay đầu tiên.

**Lệnh copy-paste:**

```bash
# Ưu tiên xử lý alert còn 'active' trước
gh api repos/<OWNER>/<REPO>/secret-scanning/alerts \
  --jq '.[] | select(.state=="open") | {number, secret_type, validity}'

# Đóng alert sau khi đã xoay key
gh api repos/<OWNER>/<REPO>/secret-scanning/alerts/<N> -X PATCH -f state='resolved'
```

**Ví dụ:** 5 alerts nhưng chỉ 1 `validity: active` → xoay cái active trước, còn lại dọn sau.

**Khi nào áp dụng:** review Security tab hàng tuần; alert `active` = xử lý trong ngày.

---

## 5. Audit logs xem ở đâu (ai bật/tắt gì, khi nào)?

**Giải thích.** 3 tầng log:

- **Org audit log:** ai đổi policy Copilot, assign seat, bypass push protection (`Org → Settings → Audit log`, giữ 180 ngày–7 năm tùy plan).
- **Repo events:** ai merge/dismiss review (`gh api repos/.../events`, PR timeline).
- **Git history:** ai/author từng commit (kể cả bot agent).

**Lệnh copy-paste:**

```bash
# Org audit log qua API (cần admin/org owner)
gh api orgs/<ORG>/audit-log --jq '.[] | {action, actor, created_at}' | head -20

# Lọc riêng sự kiện Copilot
gh api "orgs/<ORG>/audit-log?phrase=action:copilot" --jq '.[] | {action, actor, created_at}'

# Repo: ai dismiss review / force push gần đây
gh api repos/<OWNER>/<REPO>/events --jq '.[] | {type, actor: .actor.login, created_at}' | head -20
```

**Ví dụ:** có người bypass push protection → audit log hiện `secret_scanning.push_protection_bypass by @userX` → hỏi lý do + verify key đó đã xoay.

**Khi nào áp dụng:** postmortem, compliance audit định kỳ, và khi policy "tự đổi" không rõ ai đổi.

---

## 6. ZDR tương đương trên Copilot/Enterprise là gì?

**Giải thích.** ZDR (zero data retention — prompt không lưu lại) trên Claude tương đương với combo Enterprise: **no-training cam kết + data residency (EU/US region) + retention ngắn + (tùy cấu hình) Azure OpenAI routing giữ data trong tenant bạn.**

Cần thì hỏi admin 3 câu: (1) data residency region nào, (2) retention bao lâu, (3) có Azure routing không. Trả lời khách hàng bằng văn bản hợp đồng, không đoán.

**Lệnh copy-paste:**

```bash
# Dev không tự check được; hỏi admin và ghi vào hồ sơ compliance:
# 1. Org plan: Business hay Enterprise?
# 2. Data residency: EU / US / default?
# 3. Snippet training: org-level off? (Enterprise mặc định off)
```

**Ví dụ:** bid dự án bank yêu cầu "no training + EU data" → admin xác nhận Enterprise + EU residency bằng screenshot trước khi ký.

**Khi nào áp dụng:** presales/compliance questionnaire — trả lời sau khi có xác nhận admin, không hứa miệng.

---

## 7. Content exclusion cho file nhạy cảm (nhắc lại, góc bảo mật)?

**Giải thích.** Xem cấu hình ở [bài 03](03-modes-permissions.md) câu 3. Góc bảo mật bổ sung: exclusion là **lớp phòng thủ**, không thay thế `.gitignore` + secret manager. File đã vào git thì exclusion không cứu được (người khác vẫn đọc được trên GitHub).

Thứ tự đúng: secret vào **manager (Vault/1Password/AWS Secrets)** → `.gitignore` → exclusion → scanning.

**Lệnh copy-paste:**

```bash
# Kiểm tra file nhạy cảm có đang bị track không
git ls-files | grep -Ei "pem$|key$|\.env$|credentials|secrets" || echo "Khong co file nhay cam bi track"

# Nếu có -> gỡ ngay (rồi xoay key theo câu 3)
git rm --cached <file> && echo "<file>" >> .gitignore && git commit -m "chore(security): untrack sensitive file"
```

**Ví dụ:** `git ls-files | grep env` ra `.env.production` → gỡ + xoay toàn bộ key trong đó + thêm exclusion.

**Khi nào áp dụng:** audit nhanh mỗi sprint; gate trong CI càng tốt (fail nếu phát hiện file nhạy cảm bị track).

---

## 8. Token/PAT dùng cho Copilot/MCP quản lý sao cho an toàn?

**Giải thích.** Quy tắc: **mỗi mục đích 1 token, quyền tối thiểu, hết hạn ngắn, lưu trong manager.**

- PAT MCP GitHub: fine-grained, chỉ repo cần, hết hạn 30-90 ngày.
- Token CI: dùng `GITHUB_TOKEN` ephemeral của Actions, không dùng PAT cá nhân.
- Không bao giờ paste token vào chat (nó vào context server).

**Lệnh copy-paste:**

```bash
# Liệt kê token của bạn để dọn cái thừa/hết hạn
# Web: github.com/settings/tokens -> review + Revoke cái không dùng
# Nguyên tắc: tên token ghi rõ mục đích + ngày, VD: mcp-github-laptop-2026-10

# Check repo có ai hardcode token không
grep -rEn "ghp_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}|sk-live-[A-Za-z0-9]{10,}" --exclude-dir=node_modules --exclude-dir=.git . || echo "Sach"
```

**Ví dụ:** đặt lịch 90 ngày rotate PAT MCP 1 lần; CI chỉ dùng `GITHUB_TOKEN` tự cấp.

**Khi nào áp dụng:** onboarding (cấp token đúng), offboarding (revoke), và định kỳ 90 ngày.

---

## 9. Review PR của coding agent về mặt bảo mật?

**Giải thích.** PR agent phải qua cùng gate bảo mật như người: secret scan, required review, security-reviewer khi chạm auth/payment (xem [bài 07](07-custom-agents-coding-agent-workflows.md) câu 3). Thêm 2 check riêng cho agent: **scope có lố không** (file ngoài issue?) và **dependency mới có lạ không** (`package.json` thêm lib không rõ nguồn?).

**Lệnh copy-paste:**

```bash
# Check PR agent có thêm dependency/file lạ không
gh pr diff <NUM> --name-only | head -30
git diff main...copilot/issue-N -- package.json pnpm-lock.yaml
# Thấy lib mới -> check: npm view <lib> + đọc diff code dùng lib đó
```

**Ví dụ:** PR agent thêm `super-helper-utils` không ai biết → `npm view` thấy 50 downloads/tuần → yêu cầu thay bằng lib chuẩn team.

**Khi nào áp dụng:** mọi PR agent — check dependency là bước riêng, đừng chỉ đọc code.

---

## 10. Checklist bảo mật trước khi public / mở rộng repo?

**Giải thích.** Trước khi public repo hoặc mở coding agent cho repo nội bộ:

1. [ ] `gitleaks detect` sạch + secret alerts resolved.
2. [ ] Không file nhạy cảm bị track (`git ls-files` check).
3. [ ] Exclusion + ruleset + required checks bật.
4. [ ] Token/keys trong code đã xoay nếu từng lộ.
5. [ ] LICENSE + duplication filter phù hợp (public → cân nhắc license gợi ý).

**Lệnh copy-paste:**

```bash
gitleaks detect --verbose
git ls-files | grep -Ei "pem$|key$|\.env$|credentials|secrets" || echo "OK: khong track file nhay cam"
gh api repos/<OWNER>/<REPO>/secret-scanning/alerts --jq '[.[] | select(.state=="open")] | length'
```

**Ví dụ:** repo nội bộ mở public → chạy 3 lệnh trên → phát hiện 1 alert open → resolve xong mới public.

**Khi nào áp dụng:** trước public, trước M&A due-diligence, và trước khi bật agent cho repo chứa data nhạy cảm.

---

## Vẫn lỗi thì sao? (thứ tự debug chuẩn)

1. Lộ secret → xoay key trước (phút), dọn sau (giờ).
2. Check `Security → Secret scanning` + audit log để biết phạm vi.
3. Gỡ file khỏi tracking + `.gitignore` + exclusion.
4. Báo admin/security team nếu liên quan prod/customer data.
5. Postmortem: thêm gate (push protection/CI check) để không lặp.

---

## Tham khảo chéo

- Exclusion cấu hình: [bài 03](03-modes-permissions.md). Guardrails + scanning: [bài 05](05-policies-guardrails-faq.md).
- MCP secrets: [bài 04](04-mcp-faq.md). CI/review: [bài 10](10-ci-sdk-review-web.md).

> Mẹo 1 dòng: _xoay key trước dọn sau, secret vào manager chứ không vào git, và exclusion là lớp phụ sau gitignore._
