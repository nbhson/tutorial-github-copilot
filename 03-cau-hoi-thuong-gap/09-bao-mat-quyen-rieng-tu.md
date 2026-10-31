# FAQ 09 — Bảo Mật, Quyền & Riêng Tư

> **Vấn đề:** "code có bị train không, gợi ý có dính license người khác không, secret lỡ lộ thì xử từ đâu, ai làm gì ghi ở đâu" — bảo mật Copilot là chuỗi quyết định, không phải một nút bật/tắt.

## Bảng tổng hợp: lo gì → đọc câu nào

| Lo ngại | Câu trả lời ngắn | Câu |
|---|---|---|
| Code bị dùng train model? | Individual: có thể (trừ khi opt-out); Business/Enterprise: không | 1 |
| Gợi ý trúng code người khác? | Bật duplication detection filter | 2 |
| Secret lỡ lộ? | Xoay key + secret scanning + push protection | 3, 4 |
| Ai đã làm gì? | Audit log org + git history | 5 |
| ZDR tương đương? | Enterprise + data residency/Azure routing | 6 |
| File nhạy cảm? | Content exclusion 2 mức | 7 |

---

## 1. Code của tôi có bị dùng để train model không?

**Trả lời 1 câu:** Individual/Pro mặc định **có thể** được dùng train (trừ khi opt-out), Business/Enterprise **không** dùng snippets để train — luôn verify lại ở `github.com/settings/copilot` vì policy đổi theo thời gian.

- **Individual/Pro:** tắt "Allow GitHub to use my code snippets for product improvements" nếu muốn.
- **Business/Enterprise:** snippets KHÔNG dùng để train (cam kết trong điều khoản thương mại).
- Dữ liệu truyền qua TLS, giữ tạm phục vụ request rồi xóa theo retention policy.

```bash
# Khong co CLI; check + tat tren web:
# https://github.com/settings/copilot
# -> Bo tick "Allow GitHub to use my code snippets..."
# -> Bat "Duplication detection filter" (cau 2)
```

> Setup máy mới check 1 lần; code NDA/compliance thì tắt training ngay trước khi mở file.

## 2. Duplication detection là gì, bật sao?

**Trả lời 1 câu:** Filter chặn gợi ý trùng khớp dài (>150 ký tự) với public code — giảm rủi ro dính license; bật ở `github.com/settings/copilot` (cá nhân) hoặc ép bằng org policy.

| Tiêu chí | Bật (Block) | Tắt (Allow) |
|---|---|---|
| Chặn gợi ý trùng public >150 ký tự | Có | Không |
| Rủi ro license | Thấp (giảm dính GPL) | Tự chịu trách nhiệm |
| Năng suất | Thấp hơn một chút | Cao hơn |

> Bật mặc định mọi account; org closed-source thì ép bằng policy; repo open-source có thể cân nhắc tắt.

## 3. Lỡ commit secret thì xử lý sao?

**Trả lời 1 câu:** Thứ tự BẮT BUỘC: **xoay/revoke key TRƯỚC, dọn history SAU** — secret đã push lên GitHub coi như đã lộ; xóa commit mà không xoay key thì key vẫn sống trong tay kẻ đã clone.

```bash
# 1. Revoke/rotate TREN DASHBOARD provider (Stripe/GitHub/AWS...) - lam ngay

# 2. Xoa file khoi tracking + commit moi
git rm --cached secrets/leaked.key
echo "secrets/" >> .gitignore
git commit -m "chore(security): remove leaked secret, rotated key"

# 3. Quet ca history xem con sot khong
gitleaks detect --verbose
gh api repos/<OWNER>/<REPO>/secret-scanning/alerts --jq '.[] | {secret_type, state}'
```

**Ví dụ:** push nhầm `sk-live_...` → Stripe dashboard roll key (2 phút) → rồi mới `git rm + commit` → key cũ vô hiệu dù ai đã thấy.

## 4. Secret scanning + push protection (góc bảo mật)?

**Trả lời 1 câu:** Push protection chặn secret lúc push (bypass có lý do, lưu audit log); xử lý alert `validity: active` trước, còn lại dọn sau.

```bash
# Uu tien alert con 'active'
gh api repos/<OWNER>/<REPO>/secret-scanning/alerts \
  --jq '.[] | select(.state=="open") | {number, secret_type, validity}'

# Dong alert sau khi da xoay key
gh api repos/<OWNER>/<REPO>/secret-scanning/alerts/<N> -X PATCH -f state='resolved'
```

> Review Security tab hàng tuần; alert `active` = xử lý trong ngày. Cấu hình chi tiết: [bài 05](05-policies-guardrails-faq.md) câu 5.

## 5. Audit logs xem ở đâu?

**Trả lời 1 câu:** 3 tầng log: org audit log (ai đổi policy, assign seat, bypass — giữ 180 ngày đến 7 năm tùy plan), repo events (merge/dismiss), git history (author từng commit, kể cả bot).

```bash
gh api orgs/<ORG>/audit-log --jq '.[] | {action, actor, created_at}' | head -20
gh api "orgs/<ORG>/audit-log?phrase=action:copilot" --jq '.[] | {action, actor, created_at}'
gh api repos/<OWNER>/<REPO>/events --jq '.[] | {type, actor: .actor.login, created_at}' | head -20
```

**Ví dụ:** có người bypass push protection → audit log hiện `push_protection_bypass by @userX` → hỏi lý do + verify key đó đã xoay.

## 6. ZDR tương đương trên Copilot là gì?

**Trả lời 1 câu:** ZDR tương đương = combo Enterprise: no-training cam kết + data residency (EU/US) + retention ngắn + (tùy cấu hình) Azure OpenAI routing giữ data trong tenant — **không có trên Business**.

Hỏi admin 3 câu rồi ghi vào hồ sơ compliance, không hứa miệng với khách: (1) data residency region nào, (2) retention bao lâu, (3) có Azure routing không. Trả lời bằng văn bản hợp đồng, không đoán.

## 7. Content exclusion cho file nhạy cảm?

**Trả lời 1 câu:** Exclusion là **lớp phòng thủ phụ**, không thay `.gitignore` + secret manager — file đã vào git thì exclusion không cứu được (người khác vẫn đọc trên GitHub).

Thứ tự đúng: secret vào **manager (Vault/1Password/AWS Secrets)** → `.gitignore` → exclusion → scanning. Cấu hình 2 mức: xem [bài 03](03-modes-permissions.md) câu 3.

```bash
# Audit: file nhay cam nao dang bi git track?
git ls-files | grep -Ei "pem$|key$|\.env$|credentials|secrets" || echo "OK: khong co"

# Co -> go ngay (roi xoay key theo cau 3)
git rm --cached <file> && echo "<file>" >> .gitignore && git commit -m "chore(security): untrack sensitive file"
```

## 8. Token/PAT quản lý sao cho an toàn?

**Trả lời 1 câu:** Mỗi mục đích 1 token, quyền tối thiểu, hết hạn ngắn (30-90 ngày), lưu trong secret manager; **không bao giờ paste token vào chat** (nó vào context server).

| Tiêu chí | PAT fine-grained (MCP local) | `GITHUB_TOKEN` ephemeral |
|---|---|---|
| Dùng cho | MCP local, CLI cá nhân | CI (Actions), coding agent cloud |
| Quyền | Tối thiểu, chỉ repo cần | Cấp tự động theo job |
| Hạn | 30-90 ngày, tự xoay | Hết khi job xong |

```bash
# Quét repo có ai hardcode token không
grep -rEn "ghp_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}|sk-live-[A-Za-z0-9]{10,}" --exclude-dir=node_modules --exclude-dir=.git . || echo "Sach"
```

> Đặt lịch 90 ngày rotate PAT MCP; offboard = revoke. Đặt tên token ghi rõ mục đích: `mcp-github-laptop-2026-10`.

## 9. Review PR của coding agent về mặt bảo mật?

**Trả lời 1 câu:** PR agent qua cùng gate bảo mật như PR người — secret scan, required review, security-reviewer khi chạm auth/payment — cộng 2 check riêng: **scope lố không** (file ngoài issue?) và **dependency lạ không** (`package.json` thêm lib không rõ nguồn?).

```bash
gh pr diff <NUM> --name-only | head -30
git diff main...copilot/issue-N -- package.json pnpm-lock.yaml
# Thay lib moi -> check: npm view <lib> + doc diff code dung lib do
```

**Ví dụ:** PR agent thêm `super-helper-utils` 50 downloads/tuần → yêu cầu thay bằng lib chuẩn team.

## 10. Checklist bảo mật trước khi public / mở rộng repo?

**Trả lời 1 câu:** 5 item: gitleaks sạch, không file nhạy cảm bị track, exclusion + ruleset + required checks bật, token đã xoay nếu từng lộ, LICENSE + duplication filter phù hợp.

```bash
gitleaks detect --verbose
git ls-files | grep -Ei "pem$|key$|\.env$|credentials|secrets" || echo "OK: khong track file nhay cam"
gh api repos/<OWNER>/<REPO>/secret-scanning/alerts --jq '[.[] | select(.state=="open")] | length'
# Verify: 0 alert open + "OK" mới public
```

> Thêm item (tùy repo): Agent Skills + hooks preview (nếu có) phải được review trước khi public — chúng là code chạy trên máy dev.

---

## Vẫn lỗi thì sao? (thứ tự xử lý sự cố)

1. Lộ secret → xoay key trước (phút), dọn history sau (giờ).
2. Check `Security → Secret scanning` + audit log để biết phạm vi.
3. Gỡ file khỏi tracking + `.gitignore` + exclusion.
4. Báo admin/security team nếu liên quan prod/customer data.
5. Postmortem: thêm gate (push protection/CI check) để không lặp.

Tham khảo chéo: [bài 03](03-modes-permissions.md) (exclusion cấu hình) · [bài 04](04-mcp-faq.md) (MCP secrets) · [bài 05](05-policies-guardrails-faq.md) (scanning + guardrails) · [bài 10](10-ci-sdk-review-web.md) (CI/review).
