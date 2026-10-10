# FAQ 03 — Modes & Permissions

> **Dành cho:** dev dùng Copilot Agent/Edit muốn không bị "chặt chém" bởi approval, hiểu đúng chế độ, chọn permission level cho đúng việc.
> **Vấn đề:** "Ask/Edit/Agent khác gì, sao Copilot cứ hỏi approve, content exclusion là gì" — 12 câu hỏi, mỗi câu có giải thích + lệnh copy-paste + ví dụ + khi nào áp dụng.
> **Đọc xong:** phân biệt được 3 mode + UI mới (Interactive/Plan/Autopilot, Manual/Assisted/Allow all, Session Target Copilot/Local/Cloud), hết bị approval chặn, biết exclusion. **Thời gian:** ~15 phút đọc.

File này trả lời mọi câu hỏi "Ask/Edit/Agent khác gì, sao Copilot cứ hỏi approve, content exclusion là gì". Mỗi câu có giải thích + lệnh copy-paste + ví dụ + khi nào áp dụng.

---

## Sơ đồ tư duy nhanh (đọc 30 giây)

Section này trả lời: 1 task đến → chọn mode nào, approval thế nào, không bị kẹt giữa chừng.

```mermaid
flowchart LR
    A[Task] --> B{Muc do sua?}
    B -->|Chi hoi| C[Ask mode]
    B -->|Sua file chi dinh| D[Edit mode]
    B -->|Mo, nhieu file| E[Agent mode]
    E --> F{Tool nguy hiem?}
    F -->|Yes| G[Approval Allow/Deny]
    F -->|No| H[Chay + review diff]
```

## Bảng tổng hợp: chọn mode nhanh

Section này trả lời: task của bạn thuộc loại nào, chọn mode nào, và copilot được phép làm gì trong mode đó.

| Mode | Copilot được làm gì | Khi nào dùng |
|---|---|---|
| Ask (hỏi đáp) | Chỉ trả lời, đọc file bạn cho phép | Hỏi, giải thích, lên plan |
| Edit (chỉnh sửa) | Sửa file trong scope bạn chỉ định | Sửa 1 vài file cụ thể |
| Agent (tự hành động) | Đọc + sửa nhiều file + chạy lệnh (có approval) | Task multi-file, refactor, feature |

> **UI mới (2026):** agent chia 3 persona **Interactive / Plan / Autopilot** (≈ Agent+ask / Plan-first / Agent+Allow all) và picker **Permissions: Manual / Assisted / Allow all**. Ánh xạ + cách bọc an toàn: [bài 10 mục 3.2, 5.3, 5.4](../../01-huong-dan-su-dung/10-modes-permissions-availability.md) và Q11 bên dưới.

---

## 1. Ask / Edit / Agent khác nhau gì?

Section này trả lời: 3 mode khác nhau ở quyền hành động, không phải ở thông minh.

> **Hỏi ngắn gọn:** _Ask / Edit / Agent khác nhau gì?_

**Trả lời 1 câu:** Ask là cố vấn chỉ nói, Edit là thợ sửa đúng file bạn chọn, Agent là cộng sự tự tìm file + chạy lệnh, và luôn dùng mode yếu nhất làm được việc.

**Giải thích chi tiết + ví dụ:** 3 mode là 3 mức "quyền hành động" tăng dần:

- **Ask:** Copilot là cố vấn — đọc code bạn attach, trả lời chữ. Không sửa file, không chạy lệnh. An toàn tuyệt đối.
- **Edit:** Copilot là thợ sửa — sửa trực tiếp file trong working set (file bạn mở/attach). Thường không chạy lệnh build/test trừ khi bạn bảo.
- **Agent:** Copilot là cộng sự — tự tìm file, sửa nhiều file, chạy terminal (lint/test/build), tạo file mới. Mỗi hành động nhạy cảm hiện **approval prompt** để bạn duyệt.

### Làm thế nào (steps copy-paste)

Copy từng bước theo thứ tự (dán vào terminal/IDE là chạy):

```bash
# Đổi mode trong VS Code: dropdown cạnh nút Send trong Chat view
# Ask -> Edit -> Agent (chọn trước khi gõ prompt)
# Verify: sau đổi, chat hiện đúng label mode mới + icon tương ứng
# Phím tắt mở chat: Ctrl+Alt+I (VS Code), tùy IDE
```

**Ví dụ cụ thể:** hỏi "hàm này làm gì" → Ask. Sửa 1 hàm → Edit + attach file. Refactor auth 5 file + chạy test → Agent.

> **Khi nào áp dụng:** luôn chọn mode YẾU NHẤT làm được việc — đừng bật Agent cho việc Ask làm được (tốn quota + rủi ro).

> **Nếu vẫn lỗi thì...** thử theo thứ tự: (1) làm lại bước copy-paste với scope gọn hơn (1 file/selection), (2) đổi model (`/model`) rồi chạy lại, (3) tra "Vẫn lỗi thì sao?" cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue với log + ảnh chụp lỗi.
---

## 2. Tool approval là gì, sao Copilot cứ hỏi "Allow" hoài?

Section này trả lời: copilot xin phép mỗi tool call, và bạn quyết định nhớ hay không nhớ.

> **Hỏi ngắn gọn:** _Tool approval là gì, sao Copilot cứ hỏi "Allow" hoài?_

**Trả lời 1 câu:** Approval là copilot xin phép trước khi chạy tool nhạy cảm (terminal, mạng, MCP) — bạn chọn Allow once, Allow for workspace, hoặc Deny.

**Giải thích chi tiết + ví dụ:** Approval = Copilot xin phép trước khi làm việc nhạy cảm: chạy lệnh terminal, sửa file ngoài scope, truy cập mạng/MCP... Bạn có 3 lựa chọn: **Allow once** (1 lần), **Allow for session/workspace** (nhớ), **Deny** (cấm).

Hỏi hoài thường do: task agent rộng (nhiều tool calls), hoặc bạn chưa bật "allow for workspace" cho lệnh an toàn (VD `npm test`).

### Làm thế nào (steps copy-paste)

Copy từng bước theo thứ tự (dán vào terminal/IDE là chạy):

```bash
# Trong approval prompt: chọn "Allow for workspace" cho lệnh an toàn:
# npm test, npm run lint, git status, git diff
# Verify: lần chạy kế tiếp không hiện approval nữa
# KHÔNG bao giờ "allow always" cho: rm -rf, git push, kubectl delete, drop table
```

**Ví dụ cụ thể:** agent chạy `npm test` lần nào cũng hỏi → Allow for workspace 1 lần → các lần sau tự chạy.

> **Khi nào áp dụng:** đầu mỗi task agent — duyệt nhanh lệnh an toàn, giữ phê duyệt tay cho lệnh nguy hiểm.

> **Nếu vẫn lỗi thì...** thử theo thứ tự: (1) làm lại bước copy-paste với scope gọn hơn (1 file/selection), (2) đổi model (`/model`) rồi chạy lại, (3) tra "Vẫn lỗi thì sao?" cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue với log + ảnh chụp lỗi.
---

## 3. Content exclusion là gì, cấu hình ở đâu?

Section này trả lời: cách "cấm copilot đọc file" ở 2 mức, và cấu hình ở đâu.

> **Hỏi ngắn gọn:** _Content exclusion là gì, cấu hình ở đâu?_

**Trả lời 1 câu:** Content exclusion là danh sách path copilot không được đọc, có 2 mức: cá nhân (`.vscode/settings.json`) và org (admin), và mức org thắng mức cá nhân.

**Giải thích chi tiết + ví dụ:** Content exclusion = danh sách path Copilot **không được đọc/không gợi ý** (VD `*.pem`, `secrets/`, `contracts/`). Có 2 mức:

- **Cá nhân/IDE:** `settings.json` → `github.copilot.chat.exclude` hoặc content exclusion trong extension settings.
- **Org (admin, Business/Enterprise):** `Org Settings → Copilot → Content exclusion` — áp cho mọi member, thắng setting cá nhân.

### Làm thế nào (steps copy-paste)

Copy từng bước theo thứ tự (dán vào terminal/IDE là chạy):

```json
// .vscode/settings.json (mẫu repo, xem templates/)
{
  "github.copilot.chat.exclude": ["**/*.pem", "**/secrets/**", "**/.env*"]
}
```

```bash
# Admin org (web UI): Org Settings -> Copilot -> Content exclusion -> Add path
# VD: **/legal/**, **/*.key, **/credentials.json
# Verify: sau khi add, chat hỏi "#file secrets/stripe.key" -> copilot không trả được nội dung
```

**Ví dụ cụ thể:** repo có `secrets/stripe.key` → thêm vào exclusion cả 2 mức (repo settings + org policy) để Copilot không bao giờ đọc.

> **Khi nào áp dụng:** ngay khi repo có secret/key/hợp đồng — exclusion trước, code sau. Chi tiết [bài 09](09-bao-mat-quyen-rieng-tu.md).

> **Nếu vẫn lỗi thì...** thử theo thứ tự: (1) làm lại bước copy-paste với scope gọn hơn (1 file/selection), (2) đổi model (`/model`) rồi chạy lại, (3) tra "Vẫn lỗi thì sao?" cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue với log + ảnh chụp lỗi.
---

## 4. Agent sửa nhầm file thì xử lý sao (undo / checkpoint)?

Section này trả lời: 3 lớp cứu hộ khi agent phá, dùng theo thứ tự từ nhẹ đến nặng.

> **Hỏi ngắn gọn:** _Agent sửa nhầm file thì xử lý sao (undo / checkpoint)?_

**Trả lời 1 câu:** 3 lớp: undo trong chat, git checkout/stash, và checkpoint session — dùng theo thứ tự, cứ 1 file sai thì chưa cần đến lớp cuối.

**Giải thích chi tiết + ví dụ:** 3 lớp cứu hộ theo thứ tự:

1. **Undo trong chat:** Edit mode hiện diff → nút Undo/Discard để hoàn tác từng change.
2. **Git:** `git diff` xem, `git checkout -- <file>` hoàn tác file, `git stash` giữ lại tạm.
3. **Checkpoint/session restore:** Agent mode có timeline — quay về checkpoint trước khi nó sửa sai.

### Làm thế nào (steps copy-paste)

Copy từng bước theo thứ tự (dán vào terminal/IDE là chạy):

```bash
# Xem agent đã sửa gì
git status --short
git diff --stat
# Verify: chỉ ra file bạn mước, file khác = agent sửa lan

# Hoàn tác 1 file bị sửa nhầm
git checkout -- src/wrong-file.ts
# Verify: git diff --stat không còn file đó

# Hoàn tác tất cả (cẩn thận: mất cả change đúng)
git stash -u
```

**Ví dụ cụ thể:** agent sửa nhầm `migrations/` → `git checkout -- db/migrations/` → thu hẹp prompt → chạy lại chỉ trong `src/`.

> **Khi nào áp dụng:** sau mỗi task agent — `git diff --stat` trước khi commit là thói quen bắt buộc.

> **Nếu vẫn lỗi thì...** thử theo thứ tự: (1) làm lại bước copy-paste với scope gọn hơn (1 file/selection), (2) đổi model (`/model`) rồi chạy lại, (3) tra "Vẫn lỗi thì sao?" cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue với log + ảnh chụp lỗi.
---

## 5. Cho agent chạy lệnh terminal an toàn thế nào?

Section này trả lời: nguyên tắc allowlist/blocklist lệnh terminal, và câu mẫu ghi vào prompt.

> **Hỏi ngắn gọn:** _Cho agent chạy lệnh terminal an toàn thế nào?_

**Trả lời 1 câu:** Allowlist lệnh đọc + test, blocklist lệnh phá hoại, và ghi ranh giới ngay câu prompt mở đầu.

**Giải thích chi tiết + ví dụ:** Nguyên tắc: **allowlist lệnh đọc + test, blocklist lệnh phá hoại.**

- Luôn cho phép: `git status/diff/log`, `npm test`, `npm run lint`, `ls`, `cat`.
- Cân nhắc từng lần: `npm install`, `git commit`, `docker build`.
- Không bao giờ auto-allow: `rm -rf`, `git push --force`, `kubectl delete`, `drop/drop table`, `chmod 777`.

### Làm thế nào (steps copy-paste)

Copy từng bước theo thứ tự (dán vào terminal/IDE là chạy):

```bash
# Dặn agent ngay trong prompt đầu task:
# "Chỉ được chạy: npm test, npm run lint, git status, git diff.
#  Không chạy git push, rm, hay lệnh mạng khi chưa hỏi tôi."
# Verify: agent tự dừng khi muốn chạy lệnh ngoài danh sách + hỏi bạn
```

**Ví dụ cụ thể:** prompt chuẩn mở đầu task agent: `"Refactor X trong src/auth/. Chỉ chạy npm test + git diff. Không commit, không push."`

> **Khi nào áp dụng:** mọi task agent — 1 dòng giới hạn lệnh trong prompt đầu tiết kiệm 10 lần approve sau.

> **Nếu vẫn lỗi thì...** thử theo thứ tự: (1) làm lại bước copy-paste với scope gọn hơn (1 file/selection), (2) đổi model (`/model`) rồi chạy lại, (3) tra "Vẫn lỗi thì sao?" cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue với log + ảnh chụp lỗi.
---

## 6. Edit mode sửa lan sang file khác — chặn thế nào?

Section này trả lời: vì sao edit lan, và cách ép nó chỉ sửa đúng file bạn chọn.

> **Hỏi ngắn gọn:** _Edit mode sửa lan sang file khác — chặn thế nào?_

**Trả lời 1 câu:** Edit mode chỉ sửa file bạn attach — lan ra ngoài là do bạn attach folder hoặc prompt chung chung, fix bằng cách ghi rõ file được/không được đụng.

**Giải thích chi tiết + ví dụ:** Edit mode sửa trong **working set** = file đang mở + file attach. Nó lan ra ngoài khi: bạn attach cả folder, hoặc prompt viết chung chung ("refactor auth" mà attach cả `src/`).

Chặn bằng: attach đúng file cần sửa, nêu rõ file được/không được đụng trong prompt.

### Làm thế nào (steps copy-paste)

Copy từng bước theo thứ tự (dán vào terminal/IDE là chạy):

```bash
# Prompt Edit chuẩn (chỉ rõ phạm vi):
# "Chỉ sửa src/auth/login.ts (hàm login):
#  - chuyển sang async/await
#  - KHÔNG đụng session.ts, types.ts, tests"
# Verify: git diff --stat chỉ ra 1 file, không có file nào khác
```

**Ví dụ cụ thể:** muốn sửa 1 hàm mà Copilot sửa thêm 3 file → Undo → attach lại đúng 1 file → prompt ghi rõ "chỉ file này".

> **Khi nào áp dụng:** mỗi khi dùng Edit — scope hẹp = diff gọn = review nhanh.

> **Nếu vẫn lỗi thì...** thử theo thứ tự: (1) làm lại bước copy-paste với scope gọn hơn (1 file/selection), (2) đổi model (`/model`) rồi chạy lại, (3) tra "Vẫn lỗi thì sao?" cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue với log + ảnh chụp lỗi.
---

## 7. Ask mode đọc được gì, có sợ lộ file nhạy cảm không?

Section này trả lời: ask chỉ đọc thứ bạn attach, không tự quét repo — nhưng attach nhầm secret là lộ.

> **Hỏi ngắn gọn:** _Ask mode đọc được gì, có sợ lộ file nhạy cảm không?_

**Trả lời 1 câu:** Ask chỉ đọc file bạn attach + instructions, không tự quét repo — nhưng `#file` secret vào chat là nội dung đó lên server.

**Giải thích chi tiết + ví dụ:** Ask chỉ đọc: file bạn attach (`#file`, `#selection`, working set) + instructions. Nó KHÔNG tự quét cả repo. Nhưng nếu bạn attach nhầm file secret, nội dung đó vào context chat (gửi lên server model).

Vì vậy: đừng bao giờ `#file` secret vào chat, dù là Ask.

### Làm thế nào (steps copy-paste)

Copy từng bước theo thứ tự (dán vào terminal/IDE là chạy):

```bash
# Trước khi attach file vào chat, check nhanh:
git check-ignore secrets/stripe.key && echo "IGNORED" || echo "COI CHUNG: file nay dang track!"
# Verify: ra IGNORED thì an toàn; ra "COI CHUNG" thì file track trong git — 2 lớp rủi ro
# File secret track trong git + attach vào chat = 2 lớp rủi ro
```

**Ví dụ cụ thể:** debug lỗi Stripe → paste **đoạn code gọi API** (đã xóa key) thay vì `#file:secrets/stripe.ts` nguyên file.

> **Khi nào áp dụng:** mỗi lần attach file — 3 giây check tên file có chứa `secret/key/token/pem` không.

> **Nếu vẫn lỗi thì...** thử theo thứ tự: (1) làm lại bước copy-paste với scope gọn hơn (1 file/selection), (2) đổi model (`/model`) rồi chạy lại, (3) tra "Vẫn lỗi thì sao?" cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue với log + ảnh chụp lỗi.
---

## 8. Permissions của MCP tools quản lý thế nào?

Section này trả lời: tool MCP cũng có approval, và cách tắt server nguy hiểm.

> **Hỏi ngắn gọn:** _Permissions của MCP tools quản lý thế nào?_

**Trả lời 1 câu:** Tool MCP cũng xin approval khi gọi lần đầu — bạn chọn allow once/workspace, hoặc tắt hẳn server trong `mcp.json`.

**Giải thích chi tiết + ví dụ:** MCP server cung cấp tools ngoài (query DB, tạo ticket...) cho Copilot. Mỗi tool MCP khi agent gọi lần đầu đều hiện approval. Bạn có thể: allow once, allow workspace, hoặc tắt hẳn server trong `mcp.json` (xóa entry hoặc `disabled: true`).

Tool MCP nguy hiểm (VD `db.exec("DROP...")`, `github.merge_pr`) → không bao giờ allow always.

### Làm thế nào (steps copy-paste)

Copy từng bước theo thứ tự (dán vào terminal/IDE là chạy):

```json
// .vscode/mcp.json: tắt tạm 1 server nguy hiểm
{
  "servers": {
    "postgres-prod": { "command": "echo", "args": ["disabled - dung replicas"] }
  }
}
// Verify: reload IDE -> list MCP tools không còn server đó
// Thực tế: xóa entry hoặc đổi env pointing sang read-replica
```

**Ví dụ cụ thể:** MCP postgres trỏ prod → đổi connection string sang **read-replica** (xem `templates/.vscode/mcp.json`), agent query thoải mái không sợ ghi nhầm.

> **Khi nào áp dụng:** khi thêm MCP server mới — luôn trỏ read-only/replica trước, mở write sau. Chi tiết [bài 04](04-mcp-faq.md).

> **Nếu vẫn lỗi thì...** thử theo thứ tự: (1) làm lại bước copy-paste với scope gọn hơn (1 file/selection), (2) đổi model (`/model`) rồi chạy lại, (3) tra "Vẫn lỗi thì sao?" cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue với log + ảnh chụp lỗi.
---

## 9. Team thống nhất permissions baseline thế nào?

Section này trả lời: 3 lớp baseline permissions trong repo để mọi dev giống nhau.

> **Hỏi ngắn gọn:** _Team thống nhất permissions baseline thế nào?_

**Trả lời 1 câu:** Baseline team = 3 file trong repo (settings.json, copilot-instructions.md, org policy) — commit 1 lần, mọi dev hưởng từ phút 1.

**Giải thích chi tiết + ví dụ:** Team nên có 1 baseline chung, đặt trong repo để mọi người giống nhau:

1. `.vscode/settings.json` — exclusion paths chuẩn team.
2. `.github/copilot-instructions.md` — dòng "agent chỉ chạy lệnh X, không làm Y".
3. Org policy (admin) — model allowlist, coding agent bật/tắt.

### Làm thế nào (steps copy-paste)

Copy từng bước theo thứ tự (dán vào terminal/IDE là chạy):

```markdown
<!-- Đoạn mẫu trong .github/copilot-instructions.md -->
## Permissions baseline (team)
- Agent được chạy: npm test, npm run lint, git status/diff.
- Agent KHÔNG: commit, push, sửa db/migrations, gọi API prod.
- File cấm đọc: **/*.pem, secrets/**, .env*.
```

**Ví dụ cụ thể:** member mới clone repo → mở IDE → settings + instructions tự áp → permissions giống cả team từ phút 1.

> **Khi nào áp dụng:** khi team >3 người dùng Copilot — baseline trong repo đỡ cãi nhau về "sao máy em nó tự push".

> **Nếu vẫn lỗi thì...** thử theo thứ tự: (1) làm lại bước copy-paste với scope gọn hơn (1 file/selection), (2) đổi model (`/model`) rồi chạy lại, (3) tra "Vẫn lỗi thì sao?" cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue với log + ảnh chụp lỗi.
---

## 10. Khi nào KHÔNG nên dùng Agent mode?

Section này trả lời: 5 trường hợp agent không hợp, dùng Ask/Edit hoặc làm tay thay.

> **Hỏi ngắn gọn:** _Khi nào KHÔNG nên dùng Agent mode?_

**Trả lời 1 câu:** 5 lúc: hotfix prod, migration DB, code legal, repo không có test, quota đỏ — nên dùng Ask/Edit hoặc làm tay.

**Giải thích chi tiết + ví dụ:** 5 trường hợp nên tránh Agent, dùng Ask/Edit hoặc làm tay:

1. **Sửa hotfix prod gấp** — agent chậm + khó kiểm soát, làm tay nhanh hơn.
2. **Migration DB / infra** — 1 lệnh sai mất data; review tay từng dòng.
3. **Code legal/compliance** — cần người chịu trách nhiệm, không ủy thác.
4. **Repo chưa có test** — agent không có lưới an toàn, dễ "sửa xong hỏng ngầm".
5. **Quota đỏ cuối tháng** — agent đốt premium nhanh nhất.

### Làm thế nào (steps copy-paste)

Copy từng bước theo thứ tự (dán vào terminal/IDE là chạy):

```bash
# Checklist trước khi bật Agent:
# [ ] Có test chạy được? (npm test xanh)
# [ ] Git sạch? (git status --short trống để dễ diff)
# [ ] Scope <10 file?
# Verify: đủ 3 tick thì bật Agent; thiếu 1 -> dùng Edit hoặc làm tay
# Thiếu 1 trong 3 -> dùng Edit/tay thay vì Agent
```

**Ví dụ cụ thể:** hotfix thanh toán lỗi giữa đêm → Edit 1 file + chạy test tay, đừng bật agent quét cả repo.

> **Khi nào áp dụng:** trước nút bật Agent — 10 giây checklist tránh 1 giờ dọn hậu quả.

> **Nếu vẫn lỗi thì...** thử theo thứ tự: (1) làm lại bước copy-paste với scope gọn hơn (1 file/selection), (2) đổi model (`/model`) rồi chạy lại, (3) tra "Vẫn lỗi thì sao?" cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue với log + ảnh chụp lỗi.
---

## 11. UI mới: Interactive/Plan/Autopilot + Manual/Assisted/Allow all khác gì?

Section này trả lời: UI mới đặt tên lại 2 nhóm (persona + permission level), không phải 2 tính năng mới.

> **Hỏi ngắn gọn:** _UI mới có Interactive/Plan/Autopilot với Manual/Assisted/Allow all — khác gì Ask/Edit/Agent và allow/ask/deny cũ?_

**Trả lời 1 câu:** UI mới chỉ đặt tên lại 2 nhóm: persona (agent tự chủ tới đâu) và permission level (tự duyệt tool tới đâu) — không thay đổi hành vi thực tế.

**Giải thích chi tiết + ví dụ:** 2 picker khác nhau trong khung Chat:

- **Persona (dropdown agent):** **Interactive** (dừng hỏi mỗi thay đổi) — **Plan** (chỉ lập kế hoạch, không sửa code) — **Autopilot** (tự chạy tới xong, tự trả lời câu hỏi làm rõ). Tương đương: Interactive ≈ Agent + `ask`; Autopilot ≈ Agent + `Allow all`.
- **Permission level (picker Permissions):** **Manual permissions** (mặc định, hỏi theo cấu hình) — **Assisted permissions** (Experimental: LLM judge chấm rủi ro từng tool call) — **Allow all** (tự duyệt hết). Manual vẫn tôn trọng bộ `allow/ask/deny`; Assisted và Allow all thì override.

### Làm thế nào (steps copy-paste)

Copy từng bước theo thứ tự (dán vào terminal/IDE là chạy):

```bash
# VS Code: dropdown agent (Interactive/Plan/Autopilot) + picker Permissions (Manual/Assisted/Allow all)
# CLI: Shift+Tab xoay standard → plan → autopilot
copilot --mode=plan            # bắt đầu ở Plan
/permissions assisted          # đổi permission level (default|assisted|allow-all|show)
# Verify: CLI hiện mode + permission level hiện tại bằng /permissions show
```

```jsonc
// Bọc an toàn trước khi dùng Autopilot / Allow all:
{
  "chat.agent.sandbox.enabled": "on",                 // nhốt terminal, lệnh trong chuồng auto-approve
  "chat.editing.autoAcceptDelay": 0                   // tắt auto-accept edit khi review kỹ
}
```

**Ví dụ cụ thể:** task dài refactor 8 file → chọn **Plan** để duyệt kế hoạch, rồi chuyển **Interactive** để code có kiểm soát. Chỉ dùng **Autopilot** trong worktree riêng + sandbox bật.

> **Khi nào áp dụng:** Plan cho task mở/lớn; Interactive là mặc định an toàn; Autopilot/Allow all chỉ khi đã bật sandbox + git sạch. Chi tiết [bài 10 mục 3.2, 5.3, 5.4](../../01-huong-dan-su-dung/10-modes-permissions-availability.md).

> **Nếu vẫn lỗi thì...** thử theo thứ tự: (1) làm lại bước copy-paste với scope gọn hơn (1 file/selection), (2) đổi model (`/model`) rồi chạy lại, (3) tra "Vẫn lỗi thì sao?" cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue với log + ảnh chụp lỗi.
---

## 12. Session Target (Copilot/Local/Cloud) và harness là gì?

Section này trả lời: model là "não", Session Target là "nơi chạy" — 2 thứ khác nhau.

> **Hỏi ngắn gọn:** _Session Target Copilot/Local/Cloud khác gì model picker?_

**Trả lời 1 câu:** Model là "não" (ai suy nghĩ); Session Target là "harness + nơi chạy" (ai thực thi tool và chạy ở đâu) — chọn target không đổi model, chỉ đổi nơi chạy.

**Giải thích chi tiết + ví dụ:** 4 target hay gặp:

- **Local** — chạy trong extension host VS Code, làm trên workspace hiện tại; dùng tool built-in/extension + model cấu hình trong VS Code (gồm BYOK). Chỉ trong cửa sổ VS Code.
- **Copilot** — chạy trên **Agent Host** (Copilot SDK), chạy nền, nhiều session song song, mở lại từ cửa sổ/browser khác. Vì ở Agent Host nên **Autopilot là agent mode**.
- **Cloud** — chạy trên hạ tầng remote, làm 1 GitHub repo rồi mở PR; KHÔNG thấy tool/context local.
- **Claude / Codex** — harness của provider (nếu cài).

Handoff đổi target giữa phiên và mang theo context (chỉ khởi tạo được từ session Local). Trong session Copilot gõ `/delegate` để đẩy sang Cloud.

### Làm thế nào (steps copy-paste)

Copy từng bước theo thứ tự (dán vào terminal/IDE là chạy):

```bash
# VS Code: đáy khung Chat → Session Target → chọn Local / Copilot / Cloud / Claude / Codex
# Verify: label target đổi + list tools khả dụng đổi theo target
# Copilot session → /delegate để đẩy task sang Cloud (mở PR)
```

**Ví dụ cụ thể:** việc tay cần sửa + chạy test trong editor → **Local**. Muốn chạy nền nhiều task song song → **Copilot**. Task gọn giao hẳn để nhận PR → **Cloud**.

> **Khi nào áp dụng:** mặc định Local; Copilot khi muốn background/nhiều phiên; Cloud khi giao hẳn. Chi tiết [bài 10 mục 3.3](../../01-huong-dan-su-dung/10-modes-permissions-availability.md).

> **Nếu vẫn lỗi thì...** thử theo thứ tự: (1) làm lại bước copy-paste với scope gọn hơn (1 file/selection), (2) đổi model (`/model`) rồi chạy lại, (3) tra "Vẫn lỗi thì sao?" cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue với log + ảnh chụp lỗi.
---

## Vẫn lỗi thì sao? (thứ tự debug chuẩn)

Section này trả lời: 5 bước check khi copilot "bướng" về permission/mode.

1. Check đang ở mode nào (Ask/Edit/Agent) — đúng mode chưa.
2. Xem approval history: có Deny nhầm lệnh cần thiết không.
3. Check org policy có đè setting không (hỏi admin).
4. Check content exclusion có chặn file bạn cần không.
5. Vẫn kẹt → chat mới + prompt ghi rõ phạm vi file + lệnh được chạy.

---

## Tham khảo chéo

Section này trả lời: đọc tiếp bài nào về tool approval, scope, hay exclusion.

- MCP tools approval: [bài 04](04-mcp-faq.md). Prompt/instructions scope: [bài 06](06-prompts-agents-instructions.md).
- Agent workflows: [bài 07](07-custom-agents-coding-agent-workflows.md). Bảo mật exclusion: [bài 09](09-bao-mat-quyen-rieng-tu.md).
- Templates: [../templates/README.md](../templates/README.md).

> Mẹo 1 dòng: _mode yếu nhất làm được việc + prompt ghi rõ file được đụng và lệnh được chạy._
