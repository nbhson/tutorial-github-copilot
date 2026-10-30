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

---

## 1. Copilot báo Offline — vì sao, fix sao?

**Trả lời 1 câu:** "Offline" = extension không nối được server GitHub — 4 nguyên nhân: mất mạng, proxy/firewall chặn, token hết hạn, GitHub incident.

```bash
curl -s -m 10 -o /dev/null -w "%{http_code}\n" https://api.github.com
# Verify: 200/401 = mạng OK

env | grep -i proxy    # máy công ty hay dính
curl -s https://www.githubstatus.com/api/v2/status.json | head -c 300; echo
```

**Ví dụ:** máy công ty qua proxy → `api.github.com` timeout dù web vẫn mở → xin IT whitelist `*.github.com` + `*.githubcopilot.com`. Khi status bar Offline, cả 2 CLI + coding agent cloud vẫn hoạt động nếu có mạng — chỉ IDE bị ảnh hưởng.

## 2. No suggestions (gõ không ra gợi ý)?

**Trả lời 1 câu:** Checklist 6 bước: file type không hỗ trợ → nằm trong exclusion (repo + org) → completions bị tắt → token hết hạn → extension xung đột → code "quá lạ".

```bash
# Ctrl+Shift+P -> "Copilot: Check Status" / "Enable Completions"
printf 'def add(a, b):\n' > /tmp/copilot-test.py && code /tmp/copilot-test.py
# Verify: file test có gợi ý mà file dự án không -> do exclusion
```

> "Chỗ có chỗ không" → so file lỗi vs file test để khoanh vùng. Chỉ file `secrets/` không gợi ý → đúng ý exclusion, không phải lỗi.

## 3. Chat error / quota exhausted / model unavailable?

**Trả lời 1 câu:** Đọc kỹ message: `quota exhausted` = hết AI Credits (đổi model nhẹ / chờ reset), `model unavailable` = incident hoặc org tắt model, `500` = mở chat mới.

| Message | Nghĩa | Cách xử nhanh |
|---|---|---|
| `quota exhausted` | Hết AI Credits | Đổi model nhẹ, chờ reset (check `github.com/settings/copilot`) |
| `model unavailable` | Model incident hoặc org tắt | Đổi model khác trong picker |
| `something went wrong / 500` | Lỗi tạm phía server | Chat mới; còn lỗi thì chờ + xem githubstatus |

> Đổi model + chat mới loại trừ 80% ca — đừng kết luận "Copilot sập" trước khi thử.

## 4. `gh copilot` CLI fail (command not found / auth)?

**Trả lời 1 câu:** 3 lỗi top: chưa cài extension `gh-copilot`, chưa `gh auth login`, account không có seat.

| Lỗi | Nghĩa | Fix |
|---|---|---|
| `unknown command "copilot"` | Chưa cài extension | `gh extension install github/gh-copilot` |
| `auth failed` | `gh` chưa login / token hết | `gh auth login --web` |
| `No seat` | Account không có seat | Xin admin assign (bài 01) |

```bash
gh --version && gh extension list | grep -i copilot || gh extension install github/gh-copilot
gh auth status && gh copilot suggest "list files by size" --no-interactive
```

> CLI chết mà IDE sống (hoặc ngược lại) là 2 "thằng" có auth riêng — fix auth từng thằng. Ngoài `gh copilot` còn có binary `copilot` độc lập (3 chế độ interactive/plan/autopilot) — xem [bài 12](../01-huong-dan-su-dung/12-copilot-sdk-ci-cd-automation.md).

## 5. MCP tools đột nhiên mất — thứ tự check?

**Trả lời 1 câu:** Đừng sửa config vội — validate JSON → test transport (token/env) → reload IDE → đọc Output log. Chi tiết [bài 04](04-mcp-faq.md).

```bash
python3 -c "import json; json.load(open('.vscode/mcp.json')); print('JSON OK')"
echo ${GITHUB_MCP_TOKEN:+TOKEN_OK}
# Rồi: reload IDE -> View -> Output -> chon MCP server -> doc loi
```

**Ví dụ:** sau restart máy tools mất → `echo $TOKEN` rỗng (env mất cùng session) → export lại + mở IDE từ terminal.

> **Lưu ý 2026:** Copilot CLI **không đọc** `.vscode/mcp.json` — CLI dùng `~/.mcp-config.json` + `.mcp.json`.

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

```bash
git status --short && git diff --stat   # xem no da sua gi truoc khi lap
# Giu phan dung (git stash phan do), roi chat moi voi task da chia nho
```

## 8. Sau update IDE/extension thì hỏng?

**Trả lời 1 câu:** Lệch version IDE mới + extension cũ (hoặc ngược lại) → API không khớp → fix bằng update CẢ IDE + extension lên mới nhất, reload, sign-in lại.

```bash
code --version && code --list-extensions --show-versions | grep -i copilot
# Update: VS Code (Help -> Check for Updates) + Extensions view -> Update All
# Rồi: Ctrl+Shift+P -> "Reload Window", sign-in lại nếu cần
```

> Copilot chết ngay sau auto-update thì 99% do lệch version.

## 9. Nghi org policy chặn nhưng không chắc?

**Trả lời 1 câu:** Dấu hiệu: setting tự revert, model picker thiếu, chat báo "disabled by administrator", coding agent "not enabled" → 99% là org policy; dev không xem được policy, phải hỏi admin chụp `Org Settings → Copilot → Policies` (gồm cả model allowlist, agent on/off, exclusions, Agent Skills/MCP/hooks).

**Ví dụ:** coding agent báo not enabled ở repo A nhưng repo B chạy → policy chỉ bật 5 repo pilot. Mọi fix local vô hiệu thì chuyển sang kênh admin, đừng vọc tiếp.

## 10. Thứ tự debug tổng (không rõ nguyên nhân)?

**Trả lời 1 câu:** Chạy đúng 7 bước theo thứ tự, dừng khi khỏi, không nhảy cóc:

1. `gh auth status` + status bar IDE (auth?).
2. Mạng: `curl api.github.com` + githubstatus.
3. Version: IDE + extension mới nhất.
4. Sign-out → sign-in lại.
5. Chat mới + file test hello-world (loại trừ context).
6. Tắt instructions/MCP/Agent Skills custom tạm (loại trừ config).
7. Hỏi admin (policy/seat) → báo GitHub Support kèm log.

```bash
gh auth status
curl -s -m 10 -o /dev/null -w "api:%{http_code}\n" https://api.github.com
gh --version; code --version && code --list-extensions --show-versions | grep -i copilot
```

**Ví dụ:** chạy 1 lèo → thấy `api:000` (mất mạng) → khỏi cần check 6 bước còn lại.

---

## Vẫn lỗi thì sao? (báo admin/Support đúng cách)

1. Chạy script câu 10, ghi kết quả từng bước.
2. Thu thập: plan + IDE/extension version + Output log đoạn lỗi.
3. Hỏi admin (org) hoặc Discussions `github.com/community` (cá nhân).
4. Business/Enterprise → Support ticket kèm đủ 3 thứ ở bước 2.

Tham khảo chéo: [bài 01](01-tai-khoan-pricing-cai-dat.md) (auth/seat) · [bài 02](02-model-context-premium.md) (quota/model) · [bài 04](04-mcp-faq.md) (MCP) · [bài 06](06-prompts-agents-instructions.md) (instructions) · [bài 05](05-policies-guardrails-faq.md) (policy).
