# Templates — copy-paste dùng ngay

> **Dành cho:** ai đã biết Copilot là gì và muốn dựng cấu hình chuẩn cho repo thật (không muốn tự nghĩ từ đầu).
> **Vấn đề:** biết cần `copilot-instructions.md`, instructions theo path, agents, skills, MCP... nhưng file nào đặt ở đâu, viết gì, và cái nào nên xóa?
> **Đọc xong:** copy được cả khung `.github/` + `.vscode/` sang repo, biết sửa gì cho khớp, và biết thứ tự setup 15 phút.
> **Thời gian:** ~8 phút đọc + ~15 phút setup.

Thư mục này là bộ khung `.github/` + `.vscode/` mẫu cho Copilot 2026, như gói "bộ bàn ghế" lắp vào repo là chạy.
Copy sang project thật, sửa tên/lệnh/glob cho khớp repo là dùng được.

Nguyên tắc: secrets CHỈ đi qua `${input}` / `${env}` / `${{ secrets.* }}` — KHÔNG hardcode trong file.

> Nôm na: `copilot-instructions.md` = giấy dán đầu tủ lạnh (agent đọc mọi lần vào bếp), `*.instructions.md` = giấy dán riêng từng phòng (theo path), prompt file = công thức in sẵn (gọi khi cần, **legacy**), skill = sổ tay nghề chuẩn 2026 (agent tự biết khi nào đọc).

> Chưa rõ MCP gồm những gì? Đọc mục 0 bài [FAQ 04](../03-cau-hoi-thuong-gap/04-mcp-faq.md) (Tools = hàm gọi như `github.create_pr`, Resources = dữ liệu đọc như `github://repos/.../issues/123`, Prompts = template như review-pr) rồi quay lại copy mẫu dưới đây.

## Từng file/folder là gì

| Đường dẫn | Để làm gì | Khi nào đụng tới |
|---|---|---|
| `.github/copilot-instructions.md` | Giấy dán đầu tủ lạnh: stack, lệnh verified, rules ALWAYS/NEVER (giữ <200 dòng) | Sửa đầu tiên khi copy sang repo mới |
| `.github/instructions/backend-api.instructions.md` | Chuẩn backend (`applyTo: apps/api/**`) | Khi có API backend |
| `.github/instructions/frontend-react.instructions.md` | Chuẩn React (`applyTo: apps/web/**`) | Khi có app web React |
| `.github/prompts/deploy.prompt.md` | **Legacy** — prompt deploy (deprecated cho Agent Host; port sang skill `deploy-checklist`) | Repo cũ Local vẫn chạy |
| `.github/prompts/review-pr.prompt.md` | **Legacy** — prompt review PR (deprecated cho Agent Host; port sang skill `review-pr`) | Repo cũ Local vẫn chạy |
| `.github/prompts/add-table.prompt.md` | **Legacy** — prompt tạo bảng Postgres (port sang skill `add-table`) | Repo cũ Local vẫn chạy |
| `.github/agents/explorer.agent.md` | Thợ trinh sát chỉ-đọc, vẽ bản đồ file trước khi sửa | Đầu task multi-file |
| `.github/agents/tester.agent.md` | Thợ kiểm soát: chạy test focused, báo PASS/FAIL | Sau mỗi change |
| `.github/agents/security-reviewer.agent.md` | Thợ soi bảo mật (chỉ đọc) | Diff chạm auth/payment/crypto |
| `.github/skills/review-pr/SKILL.md` | **Agent Skill 2026 (khuyến nghị)** — sổ tay nghề chuẩn: model tự đọc khi user nhờ review, chạy Local + Cloud + CLI | Tự động, không cần nhớ tên |
| `.vscode/mcp.json` | MCP servers (github + playwright + postgres, secrets qua `${input}`) | Sửa token/URL theo môi trường |
| `.vscode/settings.json` | Bật instruction files + content exclusion mẫu | Sửa exclusion theo repo |
| `.github/workflows/copilot-review.yml` | CI review PR: lint/test + comment (quyền tối thiểu) | Copy vào repo dùng Actions |
| `.github/workflows/copilot-ci-triage.yml` | CI triage issue: label + hỏi thêm info | Copy vào repo đông issue |

> **Nhìn bảng này thế nào:** đừng copy hết. Một repo điển hình chỉ cần 3–5 file đầu tiên; phần `agents/`, `skills/`, `prompts/` giữ cái nào đúng việc repo bạn làm, còn lại xóa. Copy nguyên bộ rồi để đó còn tệ hơn là không có, vì mọi file đều được nạp vào context (mỗi file instructions nhỏ, nhưng vẫn tốn).

## Cách copy vào project (3 bước)

```bash
# 1. Copy cả khung sang repo thật (đứng ở root repo đích)
cp -r /path/to/tutorial-copilot/templates/.github ./
cp -r /path/to/tutorial-copilot/templates/.vscode ./

# 2. Sửa cho khớp repo (bắt buộc, bỏ qua là config chạy sai)
# - .github/copilot-instructions.md: stack + 6 lệnh Dev/Build/Test/Lint/Full-check/Migrate (chỉ ghi lệnh đã chạy thử thật)
# - .github/instructions/*.instructions.md: sửa applyTo globs theo thư mục thật (ls để đối chiếu)
# - .vscode/mcp.json: nhập token của mình qua popup ${input} khi IDE hỏi (KHÔNG hardcode vào file)
# - .vscode/settings.json: thêm path nhạy cảm của repo vào exclusion

# 3. Kiểm tra Copilot nhận đủ config
# Mở repo đích trong IDE rồi:
# - Gõ thử 1 hàm xem suggestions có theo chuẩn team không
# - Mở chat mới hỏi: "liệt kê quy tắc đang áp dụng cho <1 file>" (test instructions load)
# - Nói "review PR giúp" / "deploy staging" (test SKILLS tự load — chuẩn 2026)
# - (Legacy) Gọi /review-pr, /deploy thử (test prompt files load — chỉ Local, sắp deprecated cho Agent Host)
# - View -> Output -> MCP (test servers sống)
```

## Thứ tự setup khuyên dùng (15 phút)

1. **`copilot-instructions.md` trước**: sửa stack + lệnh (chỉ lệnh đã chạy thử).
2. **Instructions theo path**: giữ file nào khớp repo (`backend-api` nếu có `apps/api/`, `frontend-react` nếu có `apps/web/`); sửa `applyTo`, xóa cái không dùng.
3. **Agents**: giữ `explorer` + `tester` (dùng mỗi ngày), giữ `security-reviewer` nếu có auth/payment.
4. **Skills (chuẩn 2026, khuyến nghị)**: giữ `review-pr` (skill) luôn; port `deploy`/`add-table` (prompt legacy) sang skill nếu cần chạy Cloud (bài 05 mục 3.3). Việc mới → tạo skill, không tạo prompt file.
5. **MCP**: mở IDE → nhập token khi popup hỏi (github PAT + postgres replica URL). Postgres LUÔN trỏ read-replica + user readonly.
6. **Workflows**: copy 2 file `.yml` nếu repo dùng GitHub Actions; check `permissions:` tối thiểu trước khi merge.
7. **Verify cuối**: nhờ Copilot làm 1 task nhỏ end-to-end (sửa 1 handler + chạy test + review) để chắc mọi mảnh đều chạy.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**1. Copy nguyên khung rồi commit, không sửa**

```text
❌ SAI: giữ nguyên applyTo: apps/api/** trong repo không có apps/api/ → instructions không bao giờ áp dụng
✅ ĐÚNG: ls thư mục thật rồi sửa/xóa từng file instructions cho khớp
```
**Bài học:** template là điểm bắt đầu, không phải bản chạy được luôn. Bước 2 trong hướng dẫn copy là bắt buộc.

**2. Hardcode token vào `mcp.json` cho nhanh**

```text
❌ SAI: "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_xxxxxxxx" trong file commit được
✅ ĐÚNG: "GITHUB_PERSONAL_ACCESS_TOKEN": "${input:github_token}" → IDE hỏi token lúc chạy, không lưu vào git
```
**Bài học:** token nằm trong git là token đã lộ, kể cả repo private. Nó ở lại trong history mãi.

**3. Postgres MCP trỏ thẳng vào DB prod**

```text
❌ SAI: postgres://app_user:pass@prod-db:5432/app → agent chạy được cả UPDATE/DELETE trên prod
✅ ĐÚNG: trỏ read-replica + user chỉ GRANT SELECT (xem FAQ 04 câu 6)
```
**Bài học:** MCP cho agent quyền đọc/ghi thật; hạ quyền ở phía DB chắc chắn hơn là tin vào prompt.

## Lưu ý an toàn (đọc 1 lần)

- Secrets: `${input}` / `${env}` / `${{ secrets.* }}`. Thấy `ghp_/sk-/postgres://user:pass@` thật trong file commit được → xóa ngay.
- Postgres MCP trỏ read-replica, user chỉ `GRANT SELECT` (xem FAQ 04 câu 6).
- Workflows: `permissions:` tối thiểu, không `echo` secret, KHÔNG flag bypass/skip (xem FAQ 05 câu 9, FAQ 10 câu 4).

## So sánh với Claude Code

Bộ khung này chuyển sang Claude Code gần như 1-1 — chỉ khác *tên file* và *chỗ đặt*:

| Việc | Copilot (`templates/`) | Claude Code | Ghi chú |
|---|---|---|---|
| Luật chung cho mọi chat | `.github/copilot-instructions.md` | `CLAUDE.md` | Cùng tư tưởng "file trong repo là luật" |
| Luật theo từng thư mục | `instructions/*.instructions.md` + `applyTo` glob | `CLAUDE.md` lồng theo cây thư mục | Copilot dùng 1 file + glob; Claude Code dùng file theo vị trí |
| Persona / subagent | `.github/agents/*.agent.md` | `.claude/agents/` | Cùng ý tưởng: persona + giới hạn tool |
| Quy trình gọi khi cần | `prompts/*.prompt.md` (legacy) / `skills/` | `.claude/commands/` | Tương đương về ý tưởng |
| Tool/dữ liệu ngoài | `.vscode/mcp.json` | `.mcp.json` | Cùng chuẩn MCP |
| Secrets trong config | `${input}` / `${env}` / `${{ secrets.* }}` | biến môi trường + config user | Cùng nguyên tắc: không hardcode |

> **Đọc bảng này thế nào:** nếu bạn đã dựng `CLAUDE.md` + `.claude/`, thì chuyển sang Copilot chủ yếu là đổi đường dẫn file. Riêng phần **Skill (`SKILL.md`)** là thứ chuẩn 2026 mà repo này khuyến nghị — nếu công cụ bạn dùng chưa có khái niệm tương đương, cứ giữ prompt file legacy và port sau.

Quay về: [../README.md](../README.md) · Bài liên quan: [01 — bài 03 Instructions](../01-huong-dan-su-dung/03-instructions-memory-rules.md) · [01 — bài 05 Skills & prompts](../01-huong-dan-su-dung/05-prompt-files-custom-instructions.md)

> **Chốt thư mục templates:** copy là việc của 30 giây, sửa cho khớp repo là việc của 15 phút — và 15 phút đó quyết định Copilot hiểu đúng repo bạn hay chạy loạn. Dựng `copilot-instructions.md` trước, verify bằng một task nhỏ, rồi mới mở rộng sang agents/skills/MCP.
