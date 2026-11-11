# FAQ 08 — Lỗi Thường Gặp & Troubleshooting

> **Vấn đề:** Copilot "chết" theo đủ kiểu: status bar đỏ Offline, gõ mãi không ra gợi ý, chat báo `quota exhausted`, `gh copilot` command not found — bài này cho bạn thứ tự debug 7 bước, tự fix được ~90% ca.

## Bảng tổng hợp: lỗi nào đọc câu nào

| Triệu chứng | Câu | Fix 1 dòng |
|---|---|---|
| Status bar báo Offline | 1 | Check mạng + sign-in lại |
| Gõ không ra gợi ý xám | 2 | Check file type + exclusion + restart |
| Chat báo error / quota | 3 | Chat mới + check AI Credits |
| `gh copilot` fail | 4 | Update gh + extension |
| MCP tools mất | 5 | Xem bài 04 |
| Instructions không ăn | 6 | Xem bài 06 |
| Agent lặp / đơ | 7 | Dừng + chia task |
| Sau update IDE thì hỏng | 8 | Update extension theo |
| Nghi policy chặn | 9 | Hỏi admin Policies tab |
| Không rõ nguyên nhân | 10 | Thứ tự debug tổng |

> **Cách đọc bảng này:** đây là "quầy lễ tân" của bài — dọc cột **Triệu chứng** tìm đúng cái đang thấy trên máy, cột **Câu** chỉ bạn nhảy thẳng tới mục đó, cột **Fix 1 dòng** là cứu cánh nhanh khi đang gấp.

---

## 1. Copilot báo Offline — vì sao, fix sao?

**Trả lời 1 câu:** "Offline" = extension không nối được server GitHub — 4 nguyên nhân: mất mạng, proxy/firewall chặn, token hết hạn, GitHub incident.

Giống điện thoại mất sóng: có thể do bạn ở trong hầm (proxy/firewall), do sim hết hạn (token), hoặc do nhà mạng sập (incident) — lần lượt loại trừ, đừng đổ lỗi cho cái máy ngay.

> 📄 **Code ví dụ:** [`./examples/08-loi-thuong-gap-troubleshooting/copilot-bao-offline-vi-sao-fix-sao.sh`](./examples/08-loi-thuong-gap-troubleshooting/copilot-bao-offline-vi-sao-fix-sao.sh)

**Ví dụ:** máy công ty qua proxy → `api.github.com` timeout dù web vẫn mở → xin IT whitelist `*.github.com` + `*.githubcopilot.com`. Khi status bar Offline, cả 2 CLI + Copilot cloud agent vẫn hoạt động nếu có mạng — chỉ IDE bị ảnh hưởng.

## 2. No suggestions (gõ không ra gợi ý)?

**Trả lời 1 câu:** Checklist 6 bước: file type không hỗ trợ → nằm trong exclusion (repo + org) → completions bị tắt → token hết hạn → extension xung đột → code "quá lạ".

> 📄 **Code ví dụ:** [`./examples/08-loi-thuong-gap-troubleshooting/no-suggestions-go-khong-ra-goi-y.sh`](./examples/08-loi-thuong-gap-troubleshooting/no-suggestions-go-khong-ra-goi-y.sh)

> "Chỗ có chỗ không" → so file lỗi vs file test để khoanh vùng. Chỉ file `secrets/` không gợi ý → đúng ý exclusion, không phải lỗi.

## 3. Chat error / quota exhausted / model unavailable?

**Trả lời 1 câu:** Đọc kỹ message: `quota exhausted` = hết AI Credits (đổi model nhẹ / chờ reset), `model unavailable` = incident hoặc org tắt model, `500` = mở chat mới.

| Message | Nghĩa | Cách xử nhanh |
|---|---|---|
| `quota exhausted` | Hết AI Credits | Đổi model nhẹ, chờ reset (check `github.com/settings/copilot`) |
| `model unavailable` | Model incident hoặc org tắt | Đổi model khác trong picker |
| `something went wrong / 500` | Lỗi tạm phía server | Chat mới; còn lỗi thì chờ + xem githubstatus |

> **Cách đọc bảng này:** dọc cột **Message** tìm đúng dòng chữ đỏ bạn vừa thấy trong chat, cột **Nghĩa** dịch error ra tiếng người, cột **Cách xử nhanh** là việc làm ngay.

> Đổi model + chat mới loại trừ 80% ca — đừng kết luận "Copilot sập" trước khi thử.

## 4. `gh copilot` CLI fail (command not found / auth)?

**Trả lời 1 câu:** 3 lỗi top: chưa cài extension `gh-copilot`, chưa `gh auth login`, account không có seat.

| Lỗi | Nghĩa | Fix |
|---|---|---|
| `unknown command "copilot"` | Chưa cài extension | `gh extension install github/gh-copilot` |
| `auth failed` | `gh` chưa login / token hết | `gh auth login --web` |
| `No seat` | Account không có seat | Xin admin assign (bài 01) |

> 📄 **Code ví dụ:** [`./examples/08-loi-thuong-gap-troubleshooting/gh-copilot-cli-fail-command-not-found.sh`](./examples/08-loi-thuong-gap-troubleshooting/gh-copilot-cli-fail-command-not-found.sh)

> CLI chết mà IDE sống (hoặc ngược lại) là 2 "thằng" có auth riêng — fix auth từng thằng. Ngoài `gh copilot` còn có binary `copilot` độc lập (3 chế độ interactive/plan/autopilot) — xem [bài 12](../01-huong-dan-su-dung/12-copilot-sdk-ci-cd-automation.md).

## 5. MCP tools đột nhiên mất — thứ tự check?

**Trả lời 1 câu:** Đừng sửa config vội — validate JSON → test transport (token/env) → reload IDE → đọc Output log. Chi tiết [bài 04](04-mcp-faq.md).

> 📄 **Code ví dụ:** [`./examples/04-mcp-faq/mcp-tools-ot-nhien-mat-thu-tu.sh`](./examples/04-mcp-faq/mcp-tools-ot-nhien-mat-thu-tu.sh)

**Ví dụ:** sau restart máy tools mất → `echo $TOKEN` rỗng (env mất cùng session) → export lại + mở IDE từ terminal.

> **Lưu ý 2026:** Copilot CLI **không đọc** `.vscode/mcp.json` — CLI dùng `~/.copilot/mcp-config.json` + `.mcp.json` (root repo).

## 6. Completions gợi ý sai chuẩn team dù đã có instructions?

**Trả lời 1 câu:** Completions đọc ít context hơn chat, dễ bỏ qua quy tắc dài — fix bằng rút quy tắc cho ngắn + đặt **ví dụ code mẫu** ngay trong `copilot-instructions.md` (model bắt chước pattern gần hơn là đọc quy tắc xa).

```markdown
<!-- Trong .github/copilot-instructions.md -->
## Chuẩn error (copy pattern này)
```ts
return res.status(400).json({ code: "BAD_INPUT", message, requestId });
```
```

```bash
# Verify: gõ thử "return res.status(400).json({" -> gợi ý ra đúng shape
```

> Chat đúng mà gõ tay sai → bổ sung ví dụ code, đừng viết thêm chữ.

## 7. Agent lặp vòng / đơ / chạy mãi không xong?

**Trả lời 1 câu:** Dấu hiệu cần can thiệp: lặp cùng lỗi 3 lần, task nhỏ chạy >20 phút, tool calls toàn retry — xử lý: **Cancel → đọc log vòng cuối → chia task nhỏ → chạy lại từng phần**, đừng để chạy tiếp "biết đâu được" (chỉ đốt AI Credits).

> 📄 **Code ví dụ:** [`./examples/08-loi-thuong-gap-troubleshooting/agent-lap-vong-o-chay-mai-khong.sh`](./examples/08-loi-thuong-gap-troubleshooting/agent-lap-vong-o-chay-mai-khong.sh)

## 8. Sau update IDE/extension thì hỏng?

**Trả lời 1 câu:** Lệch version IDE mới + extension cũ (hoặc ngược lại) → API không khớp → fix bằng update CẢ IDE + extension lên mới nhất, reload, sign-in lại.

> 📄 **Code ví dụ:** [`./examples/08-loi-thuong-gap-troubleshooting/sau-update-ide-extension-thi-hong.sh`](./examples/08-loi-thuong-gap-troubleshooting/sau-update-ide-extension-thi-hong.sh)

> Copilot chết ngay sau auto-update thì 99% do lệch version.

## 9. Nghi org policy chặn nhưng không chắc?

**Trả lời 1 câu:** Dấu hiệu: setting tự revert, model picker thiếu, chat báo "disabled by administrator", cloud agent "not enabled" → 99% là org policy; dev không xem được policy, phải hỏi admin chụp `Org Settings → Copilot → Policies` (gồm cả model allowlist, agent on/off, exclusions, Agent Skills/MCP/hooks).

**Ví dụ:** cloud agent báo not enabled ở repo A nhưng repo B chạy → policy chỉ bật 5 repo pilot. Mọi fix local vô hiệu thì chuyển sang kênh admin, đừng vọc tiếp.

## 10. Thứ tự debug tổng (không rõ nguyên nhân)?

**Trả lời 1 câu:** Chạy đúng 7 bước theo thứ tự, dừng khi khỏi, không nhảy cóc:

Ví von: đây là quy trình kiểm tra xe không nổ máy — xăng (auth) → nguồn (mạng) → phụ tùng (version) → chìa khóa (sign-in); cứ đi theo thứ tự, hết bệnh ở bước nào thì dừng ở đó.

1. `gh auth status` + status bar IDE (auth?).
2. Mạng: `curl api.github.com` + githubstatus.
3. Version: IDE + extension mới nhất.
4. Sign-out → sign-in lại.
5. Chat mới + file test hello-world (loại trừ context).
6. Tắt instructions/MCP/Agent Skills custom tạm (loại trừ config).
7. Hỏi admin (policy/seat) → báo GitHub Support kèm log.

> 📄 **Code ví dụ:** [`./examples/08-loi-thuong-gap-troubleshooting/thu-tu-debug-tong-khong-ro-nguyen.sh`](./examples/08-loi-thuong-gap-troubleshooting/thu-tu-debug-tong-khong-ro-nguyen.sh)

**Ví dụ:** chạy 1 lèo → thấy `api:000` (mất mạng) → khỏi cần check 6 bước còn lại.

---

## Vẫn lỗi thì sao? (báo admin/Support đúng cách)

1. Chạy script câu 10, ghi kết quả từng bước.
2. Thu thập: plan + IDE/extension version + Output log đoạn lỗi.
3. Hỏi admin (org) hoặc Discussions `github.com/community` (cá nhân).
4. Business/Enterprise → Support ticket kèm đủ 3 thứ ở bước 2.

Tham khảo chéo: [bài 01](01-tai-khoan-pricing-cai-dat.md) (auth/seat) · [bài 02](02-model-context-premium.md) (quota/model) · [bài 04](04-mcp-faq.md) (MCP) · [bài 06](06-prompts-agents-instructions.md) (instructions) · [bài 05](05-policies-guardrails-faq.md) (policy) · 📄 ma trận triệu chứng→nguyên nhân: [`./examples/08-loi-thuong-gap-troubleshooting/troubleshooting-ca-3-ma-tran-trieu-chung.sh`](./examples/08-loi-thuong-gap-troubleshooting/troubleshooting-ca-3-ma-tran-trieu-chung.sh).

> **Tóm gọn 1 câu:** Troubleshooting Copilot là trò loại trừ có kỷ luật: auth → mạng → version → phiên sạch → config → policy — đi đúng trật tự thì ~90% ca tự gãy lộ ra nguyên nhân.
