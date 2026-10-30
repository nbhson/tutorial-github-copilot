# FAQ 03 — Modes & Permissions

> **Vấn đề:** "Ask/Edit/Agent khác gì, sao Copilot cứ hỏi approve hoài, content exclusion là gì" — bật Agent cho việc Ask làm được thì vừa tốn AI Credits vừa tăng rủi ro; allow-always cho lệnh phá hoại thì một lần `rm -rf` là đủ mất cả buổi.

| Mode | Copilot được làm gì | Khi nào dùng |
|---|---|---|
| Ask (hỏi đáp) | Chỉ trả lời, đọc file bạn cho phép | Hỏi, giải thích, lên plan |
| Edit (chỉnh sửa) | Sửa file trong scope bạn chỉ định | Sửa 1 vài file cụ thể |
| Agent (tự hành động) | Đọc + sửa nhiều file + chạy lệnh (có approval) | Task multi-file, refactor, feature |

---

## 1. Ask / Edit / Agent khác nhau gì?

**Trả lời 1 câu:** 3 mode là 3 mức "quyền hành động" tăng dần — Ask là cố vấn chỉ nói, Edit là thợ sửa đúng file bạn chọn, Agent là cộng sự tự tìm file + chạy lệnh; luôn dùng mode yếu nhất làm được việc.

- **Ask:** đọc code bạn attach, trả lời chữ. Không sửa file, không chạy lệnh. An toàn tuyệt đối.
- **Edit:** sửa trực tiếp file trong working set (file bạn mở/attach). Thường không chạy lệnh build/test trừ khi bạn bảo.
- **Agent:** tự tìm file, sửa nhiều file, chạy terminal (lint/test/build), tạo file mới. Mỗi hành động nhạy cảm hiện **approval prompt**.

```bash
# Đổi mode trong VS Code: dropdown cạnh nút Send trong Chat view
# Ask -> Edit -> Agent (chọn trước khi gõ prompt)
# Verify: chat hiện đúng label mode mới
```

**Ví dụ:** hỏi "hàm này làm gì" → Ask. Sửa 1 hàm → Edit + attach file. Refactor auth 5 file + chạy test → Agent.

## 2. Tool approval là gì, sao cứ hỏi "Allow" hoài?

**Trả lời 1 câu:** Approval = Copilot xin phép trước khi chạy tool nhạy cảm (terminal, mạng, MCP) — Allow once / Allow for workspace / Deny.

| Lựa chọn | Nghĩa | Nhớ cho lần sau? | Khi nào dùng |
|---|---|---|---|
| Allow once | Cho chạy 1 lần | Không | Lệnh hiếm gặp, chưa chắc an toàn |
| Allow for session/workspace | Nhớ cho phiên/workspace | Có | Lệnh an toàn lặp lại (`npm test`, `git diff`) |
| Deny | Cấm chạy | Có | Lệnh nguy hiểm (`rm -rf`, `git push --force`) |

```bash
# Allow for workspace cho lệnh an toàn: npm test, npm run lint, git status, git diff
# KHÔNG bao giờ "allow always" cho: rm -rf, git push, kubectl delete, drop table
```

> **Hỏi hoài:** thường do task agent rộng (nhiều tool calls) hoặc chưa allow-for-workspace lệnh an toàn. Workspace mới → bộ nhớ approval reset.

## 3. Content exclusion là gì, cấu hình ở đâu?

**Trả lời 1 câu:** Content exclusion = danh sách path Copilot **không được đọc/không gợi ý** (VD `*.pem`, `secrets/`), có 2 mức: cá nhân (`.vscode/settings.json`) và org (admin) — mức org thắng.

```json
// .vscode/settings.json (mẫu repo, xem templates/)
{
  "github.copilot.chat.exclude": ["**/*.pem", "**/secrets/**", "**/.env*"]
}
```

```bash
# Admin org (web UI): Org Settings -> Copilot -> Content exclusion -> Add path
# Verify: chat hỏi "#file secrets/stripe.key" -> Copilot không trả được nội dung
```

> **Khi nào áp dụng:** ngay khi repo có secret/key/hợp đồng — exclusion trước, code sau. Chi tiết [bài 09](09-bao-mat-quyen-rieng-tu.md). Lưu ý: file đã vào git thì exclusion không cứu được — phải xử lý ở tầng secret.

## 4. Agent sửa nhầm file thì xử lý sao?

**Trả lời 1 câu:** 3 lớp cứu hộ: undo trong chat → git checkout/stash → checkpoint session; cứ 1 file sai thì chưa cần đến lớp cuối.

```bash
# Xem agent đã sửa gì
git status --short && git diff --stat
# Verify: chỉ ra file bạn muốn, file khác = agent sửa lan

# Hoàn tác 1 file / tất cả (cẩn thận: stash mất cả change đúng)
git checkout -- src/wrong-file.ts
git stash -u
```

> **Thói quen bắt buộc:** `git diff --stat` trước khi commit sau mỗi task agent. Agent mode còn có timeline checkpoint — quay về checkpoint trước khi nó sửa sai.

## 5. Cho agent chạy lệnh terminal an toàn thế nào?

**Trả lời 1 câu:** Allowlist lệnh đọc + test, blocklist lệnh phá hoại, và ghi ranh giới ngay câu prompt mở đầu.

- Luôn cho phép: `git status/diff/log`, `npm test`, `npm run lint`, `ls`, `cat`.
- Cân nhắc từng lần: `npm install`, `git commit`, `docker build`.
- Không bao giờ auto-allow: `rm -rf`, `git push --force`, `kubectl delete`, `drop table`, `chmod 777`.

```bash
# Prompt đầu task: "Chỉ được chạy: npm test, npm run lint, git status, git diff.
#  Không chạy git push, rm, hay lệnh mạng khi chưa hỏi tôi."
```

## 6. Edit mode sửa lan sang file khác — chặn thế nào?

**Trả lời 1 câu:** Edit mode chỉ sửa working set (file mở + file attach) — lan ra ngoài là do bạn attach folder hoặc prompt chung chung; fix bằng ghi rõ file được/không được đụng.

```bash
# Prompt Edit chuẩn:
# "Chỉ sửa src/auth/login.ts (hàm login): chuyển sang async/await.
#  KHÔNG đụng session.ts, types.ts, tests"
# Verify: git diff --stat chỉ ra 1 file
```

> **Đã ghi rõ mà vẫn lan:** đóng tab file không liên quan, Undo rồi thử lại với `#selection` đúng đoạn.

## 7. Ask mode có sợ lộ file nhạy cảm không?

**Trả lời 1 câu:** Ask chỉ đọc file bạn attach + instructions, không tự quét repo — nhưng `#file` secret vào chat là nội dung đó lên server model.

```bash
# Check 3 giây trước khi attach:
git check-ignore secrets/stripe.key && echo "IGNORED" || echo "COI CHUNG: file nay dang track!"
```

**Ví dụ:** debug lỗi Stripe → paste **đoạn code gọi API** (đã xóa key) thay vì `#file:secrets/stripe.ts` nguyên file. **Lỡ attach secret rồi:** coi như đã lộ, **xoay key ngay**, thêm path vào content exclusion.

## 8. UI 2026: Interactive/Plan/Autopilot + Manual/Assisted/Allow all khác gì cũ?

**Trả lời 1 câu:** UI mới chỉ đặt tên lại 2 nhóm — persona (agent tự chủ tới đâu) và permission level (tự duyệt tool tới đâu) — không đổi hành vi thực tế.

| Nhóm | Lựa chọn | Tương đương | Hành vi | Khi nào dùng |
|---|---|---|---|---|
| Persona | Interactive | Agent + `ask` | Dừng hỏi mỗi thay đổi | Mặc định an toàn |
| Persona | Plan | Plan-first | Chỉ lập kế hoạch, không sửa code | Task lớn cần duyệt trước |
| Persona | Autopilot | Agent + `Allow all` | Tự chạy tới xong | Chỉ khi sandbox bật + git sạch |
| Permission | Manual | Bộ `allow/ask/deny` | Hỏi theo cấu hình | Mặc định |
| Permission | Assisted (Experimental) | — | LLM judge chấm rủi ro từng tool call | Muốn tự duyệt nhưng chấm rủi ro |
| Permission | Allow all | — | Tự duyệt hết | Sandbox bật + git sạch |

```bash
# VS Code: dropdown agent + picker Permissions ở khung Chat
# CLI: Shift+Tab xoay standard -> plan -> autopilot; /permissions show để xem hiện tại
```

```jsonc
// Bọc an toàn trước khi dùng Autopilot / Allow all:
{
  "chat.agent.sandbox.enabled": "on",   // nhốt terminal + lệnh trong sandbox
  "chat.editing.autoAcceptDelay": 0     // tắt auto-accept khi review kỹ
}
```

**Ví dụ:** task refactor 8 file → **Plan** duyệt kế hoạch → **Interactive** code có kiểm soát. **Autopilot** chỉ trong worktree riêng + sandbox bật. Chi tiết [bài 10 mục 3.2, 5.3, 5.4](../01-huong-dan-su-dung/10-modes-permissions-availability.md).

## 9. Team thống nhất permissions baseline thế nào?

**Trả lời 1 câu:** Baseline team = 3 file trong repo: `.vscode/settings.json` (exclusion chuẩn), `copilot-instructions.md` (dòng "agent chỉ chạy X, không làm Y"), org policy (admin) — commit 1 lần, mọi dev giống nhau từ phút 1.

```markdown
<!-- Đoạn mẫu trong .github/copilot-instructions.md -->
## Permissions baseline (team)
- Agent được chạy: npm test, npm run lint, git status/diff.
- Agent KHÔNG: commit, push, sửa db/migrations, gọi API prod.
- File cấm đọc: **/*.pem, secrets/**, .env*.
```

## 10. Khi nào KHÔNG nên dùng Agent mode?

**Trả lời 1 câu:** 5 lúc: hotfix prod gấp, migration DB/infra, code legal/compliance, repo chưa có test, quota đỏ cuối tháng — dùng Ask/Edit hoặc làm tay.

```bash
# Checklist trước khi bật Agent:
# [ ] Có test chạy được? (npm test xanh)
# [ ] Git sạch? (git status --short trống)
# [ ] Scope <10 file?
# Thiếu 1 trong 3 -> dùng Edit hoặc làm tay
```

**Ví dụ:** hotfix thanh toán lỗi giữa đêm → Edit 1 file + chạy test tay, đừng bật agent quét cả repo. **Đã bật rồi mới nhận ra không nên:** Cancel ngay → `git diff --stat` → checkout hoàn tác file ngoài ý muốn.

## 11. Session Target (Copilot/Local/Cloud) là gì?

**Trả lời 1 câu:** Model là "não" (ai suy nghĩ); Session Target là "harness + nơi chạy" (ai thực thi tool, chạy ở đâu) — đổi target không đổi model.

| Target | Chạy ở đâu | Thấy context local? | Song song? | Khi nào dùng |
|---|---|---|---|---|
| Local | Extension host VS Code | Có | Không | Việc tay cần sửa + chạy test trong editor |
| Copilot | Agent Host (SDK), chạy nền | — | Có | Background / nhiều phiên song song |
| Cloud | Hạ tầng remote → mở PR | Không | — | Giao hẳn task để nhận PR |
| Claude / Codex | Harness của provider (nếu cài) | Tùy harness | Tùy | Khi cài harness provider |

```bash
# VS Code: đáy khung Chat -> Session Target -> chọn target
# Copilot session: /delegate để đẩy task sang Cloud (mở PR)
# Handoff chỉ khởi tạo được từ session Local
```

> **Lỗi hay gặp:** Cloud không thấy tool/context local — đừng giao việc cần file local cho Cloud. Chi tiết [bài 10 mục 3.3](../01-huong-dan-su-dung/10-modes-permissions-availability.md).

---

## Vẫn lỗi thì sao? (thứ tự debug chuẩn)

1. Check đang ở mode nào (Ask/Edit/Agent) — đúng mode chưa.
2. Xem approval history: có Deny nhầm lệnh cần thiết không.
3. Check org policy có đè setting không (hỏi admin).
4. Check content exclusion có chặn file bạn cần không.
5. Vẫn kẹt → chat mới + prompt ghi rõ phạm vi file + lệnh được chạy.

Tham khảo chéo: [bài 04](04-mcp-faq.md) (MCP approval) · [bài 06](06-prompts-agents-instructions.md) (instructions) · [bài 07](07-custom-agents-coding-agent-workflows.md) (agent workflows) · [bài 09](09-bao-mat-quyen-rieng-tu.md) (exclusion).
