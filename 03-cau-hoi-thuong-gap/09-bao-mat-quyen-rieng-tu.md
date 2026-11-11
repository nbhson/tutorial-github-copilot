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

> **Cách đọc bảng này:** đây là bảng "điều hướng nỗi lo" — dọc cột **Lo ngại** tìm đúng cái đang làm bạn trăn trở, cột **Câu trả lời ngắn** là đáp án gọn, cột **Câu** là chỗ đọc chi tiết.

---

## 1. Code của tôi có bị dùng để train model không?

**Trả lời 1 câu:** Individual/Pro mặc định **có thể** được dùng train (trừ khi opt-out), Business/Enterprise **không** dùng snippets để train — luôn verify lại ở `github.com/settings/copilot` vì policy đổi theo thời gian.

- **Individual/Pro:** tắt "Allow GitHub to use my code snippets for product improvements" nếu muốn.
- **Business/Enterprise:** snippets KHÔNG dùng để train (cam kết trong điều khoản thương mại).
- Dữ liệu truyền qua TLS, giữ tạm phục vụ request rồi xóa theo retention policy.

> 📄 **Code ví dụ:** [`examples/01-1-code-cua-toi-co-bi-dung-e.sh`](examples/01-1-code-cua-toi-co-bi-dung-e.sh)

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

Ví von cho nhớ thứ tự: chìa khóa rơi giữa đám đông thì thay ổ khóa trước, dán thông báo "chìa cũ vô dụng" sau — cúi nhặt chìa (xóa history) mà chưa thay ổ (xoay key) là kẻ cầm bản chụp vẫn mở được cửa.

> 📄 **Code ví dụ:** [`examples/02-3-lo-commit-secret-thi-xu-ly-sao.sh`](examples/02-3-lo-commit-secret-thi-xu-ly-sao.sh)

**Ví dụ:** push nhầm `sk-live_...` → Stripe dashboard roll key (2 phút) → rồi mới `git rm + commit` → key cũ vô hiệu dù ai đã thấy.

## 4. Secret scanning + push protection (góc bảo mật)?

**Trả lời 1 câu:** Push protection chặn secret lúc push (bypass có lý do, lưu audit log); xử lý alert `validity: active` trước, còn lại dọn sau.

> 📄 **Code ví dụ:** [`examples/03-4-secret-scanning-push-protection-goc-bao-mat.sh`](examples/03-4-secret-scanning-push-protection-goc-bao-mat.sh)

> Review Security tab hàng tuần; alert `active` = xử lý trong ngày. Cấu hình chi tiết: [bài 05](05-policies-guardrails-faq.md) câu 5.

## 5. Audit logs xem ở đâu?

**Trả lời 1 câu:** 3 tầng log: org audit log (ai đổi policy, assign seat, bypass — giữ 180 ngày đến 7 năm tùy plan), repo events (merge/dismiss), git history (author từng commit, kể cả bot).

> 📄 **Code ví dụ:** [`examples/04-5-audit-logs-xem-o-au.sh`](examples/04-5-audit-logs-xem-o-au.sh)

**Ví dụ:** có người bypass push protection → audit log hiện `push_protection_bypass by @userX` → hỏi lý do + verify key đó đã xoay.

## 6. ZDR tương đương trên Copilot là gì?

**Trả lời 1 câu:** ZDR tương đương = combo Enterprise: no-training cam kết + data residency (EU/US) + retention ngắn + (tùy cấu hình) Azure OpenAI routing giữ data trong tenant — **không có trên Business**.

Hỏi admin 3 câu rồi ghi vào hồ sơ compliance, không hứa miệng với khách: (1) data residency region nào, (2) retention bao lâu, (3) có Azure routing không. Trả lời bằng văn bản hợp đồng, không đoán.

## 7. Content exclusion cho file nhạy cảm?

**Trả lời 1 câu:** Exclusion là **lớp phòng thủ phụ**, không thay `.gitignore` + secret manager — file đã vào git thì exclusion không cứu được (người khác vẫn đọc trên GitHub).

Thứ tự đúng: secret vào **manager (Vault/1Password/AWS Secrets)** → `.gitignore` → exclusion → scanning. Cấu hình 2 mức: xem [bài 03](03-modes-permissions.md) câu 3.

> 📄 **Code ví dụ:** [`examples/05-7-content-exclusion-cho-file-nhay-cam.sh`](examples/05-7-content-exclusion-cho-file-nhay-cam.sh)

## 8. Token/PAT quản lý sao cho an toàn?

**Trả lời 1 câu:** Mỗi mục đích 1 token, quyền tối thiểu, hết hạn ngắn (30-90 ngày), lưu trong secret manager; **không bao giờ paste token vào chat** (nó vào context server).

| Tiêu chí | PAT fine-grained (MCP local) | `GITHUB_TOKEN` ephemeral |
|---|---|---|
| Dùng cho | MCP local, CLI cá nhân | CI (Actions), Copilot cloud agent |
| Quyền | Tối thiểu, chỉ repo cần | Cấp tự động theo job |
| Hạn | 30-90 ngày, tự xoay | Hết khi job xong |

> **Cách đọc bảng này:** cột đầu so hai loại token như so hai loại thẻ: thẻ khách với thẻ nhân viên — mỗi loại có giới hạn quyền và thời hạn khác nhau, đọc kỹ để không dùng nhầm.

> 📄 **Code ví dụ:** [`examples/06-8-token-pat-quan-ly-sao-cho-an.sh`](examples/06-8-token-pat-quan-ly-sao-cho-an.sh)

> Đặt lịch 90 ngày rotate PAT MCP; offboard = revoke. Đặt tên token ghi rõ mục đích: `mcp-github-laptop-2026-10`.

## 9. Review PR của cloud agent về mặt bảo mật?

**Trả lời 1 câu:** PR agent qua cùng gate bảo mật như PR người — secret scan, required review, security-reviewer khi chạm auth/payment — cộng 2 check riêng: **scope lố không** (file ngoài issue?) và **dependency lạ không** (`package.json` thêm lib không rõ nguồn?).

> 📄 **Code ví dụ:** [`examples/07-9-review-pr-cua-coding-agent-ve-mat.sh`](examples/07-9-review-pr-cua-coding-agent-ve-mat.sh)

**Ví dụ:** PR agent thêm `super-helper-utils` 50 downloads/tuần → yêu cầu thay bằng lib chuẩn team.

## 10. Checklist bảo mật trước khi public / mở rộng repo?

**Trả lời 1 câu:** 5 item: gitleaks sạch, không file nhạy cảm bị track, exclusion + ruleset + required checks bật, token đã xoay nếu từng lộ, LICENSE + duplication filter phù hợp.

> 📄 **Code ví dụ:** [`examples/08-10-checklist-bao-mat-truoc-khi-public-mo.sh`](examples/08-10-checklist-bao-mat-truoc-khi-public-mo.sh)

> Thêm item (tùy repo): Agent Skills + hooks (VS Code: Preview) phải được review trước khi public — chúng là code chạy trên máy dev.

---

## Vẫn lỗi thì sao? (thứ tự xử lý sự cố)

1. Lộ secret → xoay key trước (phút), dọn history sau (giờ).
2. Check `Security → Secret scanning` + audit log để biết phạm vi.
3. Gỡ file khỏi tracking + `.gitignore` + exclusion.
4. Báo admin/security team nếu liên quan prod/customer data.
5. Postmortem: thêm gate (push protection/CI check) để không lặp.

Tham khảo chéo: [bài 03](03-modes-permissions.md) (exclusion cấu hình) · [bài 04](04-mcp-faq.md) (MCP secrets) · [bài 05](05-policies-guardrails-faq.md) (scanning + guardrails) · [bài 10](10-ci-sdk-review-web.md) (CI/review) · 📄 script quét key: [`16-6-scan-key-trong-manifest.sh`](../01-huong-dan-su-dung/examples/16-6-scan-key-trong-manifest.sh).

> **Tóm gọn 1 câu:** Bảo mật Copilot là một chuỗi xích: quyền riêng tư → content exclusion → secret hygiene → push protection — mỗi mắt xích là một lớp phòng thủ, thiếu mắt nào thì tải trọng dồn sang mắt khác.
