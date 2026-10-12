# FAQ 08 — Lỗi Thường Gặp & Troubleshooting

> Nhóm Sửa lỗi · 10 câu hỏi deep-dive · Đọc xong tự fix 90% ca, biết thứ tự debug chuẩn

Copilot "chết" theo đủ kiểu: status bar đỏ Offline, gõ mãi không ra gợi ý xám, chat báo `quota exhausted`, `gh copilot` command not found. Bài này gom 10 ca hay gặp nhất — mỗi ca có cách chẩn đoán, lệnh copy-paste, ví dụ thật và lúc nào nên áp dụng.

## Mục tiêu bài học

- Tự fix được **~90% ca Copilot "chết"** ngay trên máy mình, không cần chờ ai.
- Phân biệt **10 nhóm triệu chứng**: offline, no suggestions, chat error/quota, CLI fail, MCP mất, instructions không ăn, agent lặp, hỏng sau update, policy chặn, và "không rõ nguyên nhân".
- Chạy đúng **thứ tự debug 7 bước** — không nhảy cóc, biết dừng ở đâu để chuyển lên admin/Support.
- Nhận ra khi nào **policy/seat** là thủ phạm thật, thay vì vọc tiếp config local cho mệt.

---

## Sơ đồ tư duy nhanh (đọc 30 giây)

```mermaid
flowchart TD
    A[Loi?] --> B{Mang + sign-in?}
    B -->|Hong| C[Fix mang/token truoc]
    B -->|OK| D{Scope/exclusion?}
    D -->|Sai| E[Gon scope, check exclusion]
    D -->|Dung| F{Quota/model?}
    F -->|Het| G[Doi model nhe / cho reset]
    F -->|Con| H[Update ext + hoi admin policy]
```

## Bảng tổng hợp: lỗi nào đọc câu nào

| Triệu chứng | Câu | Fix 1 dòng |
|---|---|---|
| Status bar báo Offline | 1 | Check mạng + sign-in lại |
| Gõ không ra gợi ý xám | 2 | Check file type + exclusion + restart |
| Chat báo error / quota | 3 | Chat mới + check quota |
| `gh copilot` fail | 4 | Update gh + extension |
| MCP tools mất | 5 | Xem bài 04 |
| Instructions không ăn | 6 | Xem bài 06 |
| Agent lặp / đơ | 7 | Dừng + chia task |
| Sau update IDE thì hỏng | 8 | Update extension theo |
| Nghi policy chặn | 9 | Hỏi admin Policies tab |
| Không rõ nguyên nhân | 10 | Thứ tự debug tổng |

---

## 1. Copilot báo Offline — vì sao, fix sao?

> **Hỏi ngắn gọn:** _Copilot báo Offline — vì sao, fix sao?_

**Trả lời 1 câu:** "Offline" nghĩa là extension không nối được server GitHub — nguyên nhân luôn rơi vào 1 trong 4: mất mạng, proxy/firewall chặn, token hết hạn, GitHub incident.

**Giải thích chi tiết + ví dụ:** Nôm na: đèn 4G yếu mà bạn trách app — trước hết phải kiểm tra sóng. "Offline" = extension không nối được server GitHub. 4 nguyên nhân: mất mạng, proxy/firewall chặn, token hết hạn, GitHub incident.

> **Khi nào áp dụng:** ngay khi status bar đỏ Offline — check mạng trước, config sau. Khi status bar Offline, cả 2 CLI (gh copilot + binary copilot) + coding agent cloud vẫn hoạt động nếu có mạng — chỉ IDE bị ảnh hưởng.

### Làm thế nào (copy-paste)

```bash
# 1. Mang toi GitHub con khong
curl -s -m 10 -o /dev/null -w "%{http_code}\n" https://api.github.com
# Verify: tra ve 200 / 401 (200 = mang OK)

# 2. Proxy/firewall (may cong ty hay dinh): check env proxy
env | grep -i proxy

# 3. GitHub co incident khong: https://www.githubstatus.com
curl -s https://www.githubstatus.com/api/v2/status.json | head -c 300; echo
```

**Ví dụ cụ thể:** máy công ty qua proxy → `api.github.com` timeout dù web vẫn mở (proxy chỉ allow browser) → xin IT whitelist `*.github.com` + `*.githubcopilot.com`.

**Nếu vẫn lỗi thì...** (1) mở web GitHub bằng chính máy đó để loại trừ mạng, (2) đổi model (`/model`) hoặc mở chat mới rồi chạy lại, (3) tra "Vẫn lỗi thì sao?" cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue kèm log + ảnh chụp lỗi.

---

## 2. No suggestions (gõ không ra gợi ý xám)?

> **Hỏi ngắn gọn:** _No suggestions (gõ không ra gợi ý xám)?_

**Trả lời 1 câu:** Không ra gợi ý thường do 6 nguyên nhân có thứ tự — file type không hỗ trợ, bị exclusion, chưa bật completions, token hết hạn, extension xung đột, hoặc code "lạ" — chạy checklist 6 bước để khoanh vùng.

**Giải thích chi tiết + ví dụ:** Nôm na: gõ không ra gợi ý giống như gõ mà bàn phím tự tắt — lần lượt kiểm tra mỗi lớp. Checklist 6 bước theo thứ tự:

1. File có được hỗ trợ không (plaintext/log thì không gợi ý).
2. File có nằm trong exclusion không (`.vscode/settings.json`, org policy).
3. Copilot có bật cho file type đó không (check status bar: enable/disable).
4. Sign-in còn hạn không (token hết → silent fail).
5. Extension xung đột (2 plugin đè nhau).
6. Thử file mới hello-world để loại trừ "code quá lạ".

> **Khi nào áp dụng:** mọi ca "chỗ có chỗ không" — so sánh file lỗi vs file test để khoanh vùng. 2026: exclusion có 2 mức (file + content), xem [bài 03](03-modes-permissions.md) câu 3 — mức content chặn cả file nằm trong thư mục exclusion.

### Làm thế nào (copy-paste)

```bash
# Trong VS Code: Ctrl+Shift+P -> "Copilot: Check Status" / "Enable Completions"
# Test voi file moi:
printf 'def add(a, b):\n' > /tmp/copilot-test.py && code /tmp/copilot-test.py
# Verify: co goi y o file test ma file du an khong -> do exclusion/content file du an
```

**Ví dụ cụ thể:** chỉ file `secrets/` không gợi ý, chỗ khác có → đúng ý exclusion, không phải lỗi.

**Nếu vẫn lỗi thì...** (1) thử file hello-world ngoài repo để loại trừ context dự án, (2) restart IDE rồi sign-in lại, (3) tra "Vẫn lỗi thì sao?" cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue kèm log + ảnh chụp lỗi.

---

## 3. Chat error / quota exhausted / model unavailable?

> **Hỏi ngắn gọn:** _Chat error / quota exhausted / model unavailable?_

**Trả lời 1 câu:** Đọc kỹ message trước khi kết luận sập — `quota exhausted` là hết AI Credits (đổi model nhẹ/đợi reset), `model unavailable` là incident hoặc org tắt model, `500` thì mở chat mới.

**Giải thích chi tiết + ví dụ:** Nôm na: 3 loại báo lỗi khác nhau giống 3 mã lỗi khác nhau trên dashboard — đọc mã đúng mới xử đúng. 3 loại:

- `quota exhausted` → hết premium (xem [bài 02](02-model-context-premium.md)): đổi model nhẹ, chờ reset. 2026: quota đo bằng **AI Credits** (1 credit = $0.01), xem dashboard `github.com/settings/copilot`.
- `model unavailable` → model đang incident hoặc org tắt: đổi model khác.
- `something went wrong / 500` → thử chat mới; còn lỗi thì chờ + báo GitHub status.

| Message | Nghĩa | Cách xử nhanh |
|---|---|---|
| `quota exhausted` | Hết AI Credits/premium | Đổi model nhẹ, chờ reset (check `github.com/settings/copilot`) |
| `model unavailable` | Model đang incident hoặc org tắt | Đổi model khác trong picker |
| `something went wrong / 500` | Lỗi tạm phía server | Mở chat mới; còn lỗi thì chờ + xem githubstatus |
| Khi nào dùng | — | Đọc đúng message trước khi kết luận "Copilot sập" |

> **Khi nào áp dụng:** trước khi kết luận "Copilot sập" — đổi model + chat mới loại trừ 80% ca. Chat Agent mode (2026) tốn AI Credits theo turn — quota exhausted giữa task agent thì chuyển sang model nhẹ hơn thay vì đợi.

### Làm thế nào (copy-paste)

```bash
# Khong co CLI; thao tac:
# 1. Mo chat moi (Ctrl+Shift+P -> "Chat: New Chat")
# 2. Doi model trong picker sang model khac
# 3. Check quota: https://github.com/settings/copilot
# 4. Check incident: https://www.githubstatus.com
# Verify: chat moi + model khac chay duoc -> loi do model cu
```

**Ví dụ cụ thể:** chat báo `model unavailable` cho Claude → đổi sang GPT trong picker → chạy ngay → lỗi do model, không phải account.

**Nếu vẫn lỗi thì...** (1) mở chat mới với scope gọn hơn (1 file/selection), (2) đổi tiếp sang model khác (`/model`) rồi chạy lại, (3) tra "Vẫn lỗi thì sao?" cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue kèm log + ảnh chụp lỗi.

---

## 4. `gh copilot` CLI fail (command not found / auth)?

> **Hỏi ngắn gọn:** _`gh copilot` CLI fail (command not found / auth)?_

**Trả lời 1 câu:** 3 lỗi top là chưa cài extension `gh-copilot`, chưa `gh auth login`, hoặc account không có seat — chạy 4 lệnh bên dưới để bắt đúng loại.

**Giải thích chi tiết + ví dụ:** Nôm na: CLI chết mà IDE sống (hoặc ngược lại) là 2 "thằng" có auth riêng — fix auth từng thằng. 3 lỗi top:

| Lỗi | Nghĩa | Fix |
|---|---|---|
| `unknown command "copilot"` | Chưa cài extension | `gh extension install github/gh-copilot` |
| `auth failed` | `gh` chưa login / token hết | `gh auth login --web` |
| `No seat` | Account không có seat | Xin admin assign (bài 01) |

### Làm thế nào (copy-paste)

```bash
gh --version
gh extension list | grep -i copilot || gh extension install github/gh-copilot
gh auth status
# Verify: suggest chay duoc
gh copilot suggest "list files by size" --no-interactive 2>&1 | head -10
```

**Ví dụ cụ thể:** `gh copilot suggest` báo auth failed sau đổi pass GitHub → `gh auth login --web` lại → chạy. 2026: ngoài `gh copilot` (gh extension) còn có Copilot CLI binary độc lập (`copilot init`, 3 chế độ interactive/plan/autopilot) — 2 CLI, đọc lại [bài 12](../01-huong-dan-su-dung/12-copilot-sdk-ci-cd-automation.md) mục "Lưu ý 2026".

> **Khi nào áp dụng:** khi CLI chết mà IDE vẫn sống (hoặc ngược lại) — fix auth từng thằng riêng.

**Nếu vẫn lỗi thì...** (1) chạy lại `gh auth status` xem token còn hạn không, (2) cài lại extension `gh-copilot` rồi đổi model (`/model`) nếu vẫn lỗi, (3) tra "Vẫn lỗi thì sao?" cuối file này, (4) hỏi admin về seat hoặc mở issue kèm log + ảnh chụp lỗi.

---

## 5. MCP tools đột nhiên mất — thứ tự check?

> **Hỏi ngắn gọn:** _MCP tools đột nhiên mất — thứ tự check?_

**Trả lời 1 câu:** MCP tools mất luôn theo thứ tự: validate JSON config, test transport (token/env), reload IDE, đọc Output log — không sửa config vội.

**Giải thích chi tiết + ví dụ:** Nôm na: ki-ốt (MCP server) ngoài siêu thị bị mất — lần lượt kiểm tra: hợp đồng (JSON), mạng (env/token), cửa hàng (IDE reload), rồi mới đọc nhật ký (log). Xem chi tiết [bài 04](04-mcp-faq.md). Tóm tắt 30 giây: validate JSON → test transport → check token → reload IDE → đọc Output log. 2026: Copilot CLI từ v1.0.39 **không còn đọc** `.vscode/mcp.json` (breaking) — CLI dùng `~/.mcp-config.json` + `.mcp.json`.

### Làm thế nào (copy-paste)

```bash
python3 -c "import json; json.load(open('.vscode/mcp.json')); print('JSON OK')"
# Verify: JSON OK roi moi sang buoi tiep
echo ${GITHUB_MCP_TOKEN:+TOKEN_OK}
node --version
# Roi: reload IDE -> View -> Output -> chon MCP server -> doc loi
```

**Ví dụ cụ thể:** sau restart máy tools mất → `echo $TOKEN` rỗng (env export trong session cũ mất) → export lại + mở IDE từ terminal.

> **Khi nào áp dụng:** mọi ca MCP đỏ — đừng sửa config vội, check env + JSON trước.

**Nếu vẫn lỗi thì...** (1) validate lại JSON rồi reload IDE lần nữa, (2) check token/env còn hợp lệ rồi đổi model (`/model`) thử, (3) tra "Vẫn lỗi thì sao?" cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue kèm log Output của MCP server.

---

## 6. Completions gợi ý sai chuẩn team dù đã có instructions?

> **Hỏi ngắn gọn:** _Completions gợi ý sai chuẩn team dù đã có instructions?_

**Trả lời 1 câu:** Completions đọc ít context hơn chat nên dễ bỏ qua instructions dài — fix bằng cách rút ngắn quy tắc và đặt ví dụ code mẫu ngay trong `.github/copilot-instructions.md`.

**Giải thích chi tiết + ví dụ:** Nôm na: autocomplete là thợ tay nghề — nó học theo mẫu (pattern gần) chứ không đọc nội quy (quy tắc xa). Completions (gõ tay) đọc ít context hơn chat — nó có thể bỏ qua instructions dài. Fix: giữ quy tắc quan trọng NGẮN + đặt ví dụ code mẫu ngay trong instructions (model bắt chước pattern gần hơn là đọc quy tắc xa).

> **Khi nào áp dụng:** khi chat đúng mà gõ tay sai — bổ sung ví dụ code, đừng viết thêm chữ. 2026: không nhét ví dụ vào prompt files (legacy, deprecated cho Agent Host) — đặt trong `copilot-instructions.md` hoặc Agent Skill (chuẩn 2026) để chạy mọi harness (xem [bài 05](../01-huong-dan-su-dung/05-prompt-files-custom-instructions.md)).

### Làm thế nào (copy-paste)

```markdown
<!-- Trong .github/copilot-instructions.md (chuẩn 2026, read moi chat)
     Vi cu the thuan Quy tac chung -->
## Chuẩn error (copy pattern này)
```ts
return res.status(400).json({ code: "BAD_INPUT", message, requestId });
```
```

```bash
# Verify: goi y xam da ra theo shape tren
# Gõ thử: return res.status(400).json({
```

**Ví dụ cụ thể:** quy tắc "dùng error shape chuẩn" không ăn ở completions → thêm đoạn code mẫu 3 dòng → gợi ý xám bắt đầu ra đúng shape.

**Nếu vẫn lỗi thì...** (1) thu hẹp ví dụ mẫu còn 1 pattern ngắn gọn hơn (1 file/selection), (2) đổi model (`/model`) rồi gõ thử lại, (3) tra "Vẫn lỗi thì sao?" cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue kèm log + ảnh chụp lỗi.

---

## 7. Agent lặp vòng / đơ / chạy mãi không xong?

> **Hỏi ngắn gọn:** _Agent lặp vòng / đơ / chạy mãi không xong?_

**Trả lời 1 câu:** Agent lặp vòng khi cùng 1 lỗi lặp 3 lần hoặc task nhỏ chạy >20 phút — xử lý bằng cách Cancel → đọc log vòng cuối → chia task nhỏ → chạy lại từng phần, không để chạy tiếp.

**Giải thích chi tiết + ví dụ:** Nôm na: thợ cứ lặp 1 thao tác sai 3 lần là bạn đứng ra — không để thợ tự "biết đâu được". Dấu hiệu cần can thiệp: lặp cùng lỗi 3 lần, chạy >20 phút task nhỏ, tool calls toàn retry. Xử lý: **Dừng (Cancel) → đọc log vòng cuối → chia task → chạy lại từng phần.** Đừng để chạy tiếp "biết đâu được" — chỉ đốt AI Credits (2026: quota đo bằng credits, xem [bài 02](02-model-context-premium.md)).

### Làm thế nào (copy-paste)

```bash
# Sau khi Cancel agent:
git status --short   # xem no da sua gi truoc khi lap
git diff --stat      # danh gia: giu phan dung, bo phan loan
# Verify: giu duoc phan dung roi moi chia task
# Roi mo chat moi voi task da chia nho + scope khóa
```

**Ví dụ cụ thể:** agent migrate 10 file lặp ở file 7 → Cancel → giữ 6 file xong (`git stash` phần dở) → chat mới chỉ làm 4 file còn lại.

> **Khi nào áp dụng:** quy tắc "lặp 3 lần thì dừng" cho mọi agent (local lẫn coding agent).

**Nếu vẫn lỗi thì...** (1) chia task nhỏ hơn nữa (1 file/selection) rồi chạy lại, (2) đổi model (`/model`) rồi thử lại, (3) tra "Vẫn lỗi thì sao?" cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue kèm log vòng lặp + ảnh chụp lỗi.

---

## 8. Sau update IDE/extension thì hỏng?

> **Hỏi ngắn gọn:** _Sau update IDE/extension thì hỏng?_

**Trả lời 1 câu:** Hỏng sau update là do lệch version giữa IDE mới và extension cũ (hoặc ngược lại) — fix bằng cách update cả IDE + extension lên mới nhất, reload, sign-in lại.

**Giải thích chi tiết + ví dụ:** Nôm na: đổi motor mới mà gắn vào khung xe cũ — không khớp. Update lệch phiên bản: IDE mới + extension cũ (hoặc ngược lại) → API không khớp → suggestions/chat chết. Fix: update CẢ IDE + extension lên mới nhất, reload, sign-in lại.

### Làm thế nào (copy-paste)

```bash
code --version
code --list-extensions --show-versions | grep -i copilot
# Verify: 2 version dong khung noi dung voi IDE
# Update: VS Code (Help -> Check for Updates) + Extensions view -> Update All
# Roi: Ctrl+Shift+P -> "Reload Window", sign-in lai neu can
```

**Ví dụ cụ thể:** VS Code auto-update lên bản mới, Copilot Chat cũ không tương thích → chat trắng tinh → Update All extensions → chạy lại.

> **Khi nào áp dụng:** sau mọi đợt auto-update — nếu Copilot chết ngay sau update thì 99% do lệch version.

**Nếu vẫn lỗi thì...** (1) gỡ rồi cài lại extension Copilot, (2) đổi model (`/model`) rồi chạy lại, (3) tra "Vẫn lỗi thì sao?" cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue kèm version IDE + extension.

---

## 9. Nghi org policy chặn nhưng không chắc?

> **Hỏi ngắn gọn:** _Nghi org policy chặn nhưng không chắc?_

**Trả lời 1 câu:** Khi setting tự revert, model picker thiếu, chat báo "disabled by administrator" thì 99% là org policy chặn — dev không xem được policy, phải hỏi admin chụp Policies tab.

**Giải thích chi tiết + ví dụ:** Nôm na: bạn nghi công ty khóa ổ điện nhưng không thấy khóa — phải gọi điện hỏi điện. Dấu hiệu policy chặn: setting tự revert, model picker thiếu, chat báo "disabled by administrator", coding agent "not enabled". Dev không xem được policy — phải hỏi admin chụp `Org Settings → Copilot → Policies`. 2026: policy có thể khóa cả Agent Skills, MCP, hooks preview — hỏi admin đủ cả 3 (xem [bài 05](05-policies-guardrails-faq.md)).

### Làm thế nào (copy-paste)

```bash
# Dev tu check gian tiep:
gh api user --jq .login
# Roi no admin check + chup:
# Org Settings -> Copilot -> Policies (model allowlist, agent on/off, exclusions)
# Ho: "Seat cua em con khong? Em thuoc team nao duoc bat agent?"
# Verify: co chup Policies thi moi ket luan
```

**Ví dụ cụ thể:** coding agent báo not enabled ở repo A nhưng repo B chạy → admin check thấy policy chỉ bật 5 repo pilot gồm B không gồm A.

> **Khi nào áp dụng:** khi mọi fix local đều vô hiệu — chuyển sang kênh admin, đừng vọc tiếp.

**Nếu vẫn lỗi thì...** (1) thử lại ở 1 repo/selection khác để loại trừ scope, (2) đổi model (`/model`) xem có bị chặn luôn không, (3) tra "Vẫn lỗi thì sao?" cuối file này, (4) hỏi admin (policy/seat) — đây là kênh đúng cho ca này.

---

## 10. Thứ tự debug tổng (không rõ nguyên nhân)?

> **Hỏi ngắn gọn:** _Thứ tự debug tổng (không rõ nguyên nhân)?_

**Trả lời 1 câu:** Chạy đúng 7 bước theo thứ tự — auth, mạng, version, sign-in, chat mới + file test, tắt custom, hỏi admin — dừng khi khỏi, không nhảy cóc.

**Giải thích chi tiết + ví dụ:** Nôm na: đi khám tổng quát theo trình tự — mạch nào hỏng thì dừng ở đó, không đo mạch khác vô nghĩa. Chạy đúng 7 bước, dừng khi khỏi:

1. `gh auth status` + status bar IDE (auth?).
2. Mạng: `curl api.github.com` + githubstatus.
3. Version: IDE + extension mới nhất.
4. Sign-out → sign-in lại.
5. Chat mới + file test hello-world (loại trừ context).
6. Tắt instructions/MCP custom tạm (loại trừ config — 2026: tạm tắt cả Agent Skills + hooks).
7. Hỏi admin (policy/seat) → báo GitHub Support kèm log.

### Làm thế nào (copy-paste)

```bash
gh auth status
curl -s -m 10 -o /dev/null -w "api:%{http_code}\n" https://api.github.com
# Verify: tra ve 200/401
gh --version; code --version
code --list-extensions --show-versions | grep -i copilot
python3 -c "import json; json.load(open('.vscode/mcp.json')); print('MCP JSON OK')"
```

**Ví dụ cụ thể:** chạy 1 lèo script trên → thấy `api:000` (mất mạng) → khỏi cần check 6 bước còn lại.

> **Khi nào áp dụng:** mọi ca "lỗi lạ" — chạy từ trên xuống, không nhảy cóc, ghi lại kết quả từng bước để báo admin/Support.

**Nếu vẫn lỗi thì...** (1) chạy lại script với scope gọn hơn (1 file/selection) và ghi lại từng dòng, (2) đổi model (`/model`) rồi chạy lại, (3) tra "Vẫn lỗi thì sao?" ngay dưới đây, (4) hỏi admin (policy/seat) hoặc mở issue kèm log + ảnh chụp.

---

## Vẫn lỗi thì sao? (thứ tự debug chuẩn)

1. Chạy script câu 10, ghi kết quả từng dòng.
2. Thu thập: plan + IDE/extension version + Output log đoạn lỗi.
3. Hỏi admin (org) hoặc Discussions `github.com/community` (cá nhân).
4. Business/Enterprise → Support ticket kèm 3 thứ ở bước 2.

```bash
# Verify: da thu du 3 thu (plan + version + log) roi moi bao
gh auth status && code --version && code --list-extensions --show-versions | grep -i copilot
```

---

## So sánh với Claude Code

| Việc | GitHub Copilot | Claude Code | Ghi chú |
|---|---|---|---|
| Số bề mặt có thể "chết" | VS Code / JetBrains / Neovim / web / 2 CLI (`gh copilot` + `copilot`) | Terminal-first (+ extension IDE) | Copilot nhiều "cửa" nên lỗi rải nhiều nơi — nhớ đang debug thằng nào |
| Đổi model để loại trừ lỗi | `/model` trong Chat, đổi ngay giữa phiên | Gắn model Anthropic, đổi qua cấu hình | Đổi model là cách nhanh nhất để biết "lỗi do model hay không" |
| Trạng thái kết nối | Status bar báo Offline + `/status` | Lỗi hiện ngay trong phiên terminal | Copilot có chỉ báo trực quan; Claude Code đọc log terminal |
| Auth IDE vs CLI | IDE và CLI (`gh`) có auth riêng | Một `claude` auth; Actions dùng secret riêng | Copilot hay bị "IDE sống, CLI chết" — fix auth từng thằng |
| File cấu hình MCP | `.vscode/mcp.json` (CLI 2026: `~/.mcp-config.json` + `.mcp.json`) | `.mcp.json` + cấu hình user | Cùng chuẩn MCP, khác đường dẫn — đừng copy path máy này sang máy kia |
| Kiểm soát doanh nghiệp | Org policy (Business/Enterprise) — dev không tự xem | Cấu hình enterprise/console Anthropic | Cả hai: dev thường phải hỏi admin mới thấy policy thật |

> **Đọc bảng này thế nào:** thứ tự debug gần như giống hệt nhau (auth → mạng → version → phiên mới → cấu hình → admin). Khác biệt lớn nhất: Copilot có nhiều bề mặt + thanh trạng thái nên bạn phải xác định đang lỗi ở "cửa" nào; Claude Code terminal-first nên lỗi hiện ngay tại nơi bạn gõ lệnh.

## Best practices (kèm "vì sao")

- **Check auth + mạng trước khi vọc config.** *Vì sao?* Hai lớp này gây phần lớn ca "Copilot chết"; sửa config khi mạng hỏng chỉ làm rối thêm.
- **Ghi lại kết quả từng bước debug.** *Vì sao?* Khi phải leo lên admin/Support, log + version + ảnh chụp là thứ duy nhất giúp họ khoanh vùng thay vì hỏi lại.
- **Lỗi lạ thì tái hiện bằng file hello-world sạch.** *Vì sao?* Loại trừ context dự án trước khi kết luận extension hỏng.
- **Sau mỗi lần auto-update, để mắt Copilot.** *Vì sao?* Lệch version IDE/extension là nguyên nhân số 1 của "tự nhiên hỏng".
- **MCP đỏ thì check JSON + env trước khi sửa config.** *Vì sao?* JSON hỏng hoặc token rỗng chiếm phần lớn ca; sửa config "cho chắc" dễ làm hỏng thêm.
- **Agent lặp 3 lần thì Cancel, không chạy tiếp.** *Vì sao?* Chạy tiếp chỉ đốt AI Credits, phần dở còn lại cũng phải làm lại từ đầu.

---

## Tham khảo chéo

- Auth/seat: [bài 01](01-tai-khoan-pricing-cai-dat.md). Quota/model: [bài 02](02-model-context-premium.md).
- MCP: [bài 04](04-mcp-faq.md). Instructions: [bài 06](06-prompts-agents-instructions.md). Policy: [bài 05](05-policies-guardrails-faq.md).

> **Chốt FAQ 08:** Copilot "chết" hiếm khi do model — 90% nằm ở auth, mạng, version, scope hoặc policy. Chạy đúng thứ tự debug, ghi lại từng bước, và chỉ leo lên admin/Support khi đã có log + version + ảnh chụp trong tay.
