# Templates — copy-paste dùng ngay

> Thư mục này chứa bộ khung `.github/` + `.vscode/` mẫu cho GitHub Copilot 2026.
> Copy vào project thật, sửa tên/lệnh/glob cho khớp repo là chạy được.
> Nguyên tắc: secrets CHỈ qua `${input}` / `${env}` / `${{ secrets.* }}` — KHÔNG hardcode.
> Chưa rõ MCP gồm những gì? Đọc mục 0 bài [FAQ 04](../../03-cau-hoi-thuong-gap/04-mcp-faq.md) (Tools = hàm gọi như `github.create_pr`, Resources = dữ liệu đọc như `github://repos/.../issues/123`, Prompts = template như review-pr) rồi quay lại copy mẫu dưới đây.

## Từng file/folder là gì

| Đường dẫn | Để làm gì | Khi nào đụng tới |
|---|---|---|
| `.github/muse-instructions.md` | Project instructions: stack, lệnh verified, rules ALWAYS/NEVER (<200 dòng) | Sửa đầu tiên khi copy sang repo mới |
| `.github/instructions/backend-api.instructions.md` | Chuẩn backend (`applyTo: apps/api/**`) | Khi có API backend |
| `.github/instructions/frontend-react.instructions.md` | Chuẩn React (`applyTo: apps/web/**`) | Khi có app web React |
| `.github/prompts/deploy.prompt.md` | Prompt deploy staging/prod (dry-run + smoke test) | Gọi `/deploy` khi deploy |
| `.github/prompts/review-pr.prompt.md` | Prompt review PR (correctness/security/tests) | Gọi `/review-pr` khi review |
| `.github/prompts/add-table.prompt.md` | Prompt tạo bảng Postgres (migration + RLS + test) | Gọi `/add-table <tên>` |
| `.github/agents/explorer.agent.md` | Agent trinh sát chỉ-đọc, vẽ bản đồ file | Đầu task multi-file |
| `.github/agents/tester.agent.md` | Agent chạy test focused, báo PASS/FAIL | Sau mỗi change |
| `.github/agents/security-reviewer.agent.md` | Agent review bảo mật (chỉ đọc) | Diff chạm auth/payment/crypto |
| `.github/skills/review-pr/SKILL.md` | Agent Skill 2026: model tự gọi khi user nhờ review | Tự động, không cần nhớ tên |
| `.vscode/mcp.json` | MCP servers (github + playwright + postgres, secrets qua `${input}`) | Sửa token/URL theo môi trường |
| `.vscode/settings.json` | Bật instruction files + content exclusion mẫu | Sửa exclusion theo repo |
| `.github/workflows/copilot-review.yml` | CI review PR: lint/test + comment (quyền tối thiểu) | Copy vào repo dùng Actions |
| `.github/workflows/copilot-ci-triage.yml` | CI triage issue: label + hỏi thêm info | Copy vào repo đông issue |

## Cách copy vào project (3 bước)

```bash
# 1. Copy cả khung sang repo thật (đứng ở root repo đích)
cp -r /path/to/tutorial-copilot/templates/.github ./
cp -r /path/to/tutorial-copilot/templates/.vscode ./

# 2. Sửa cho khớp repo (bắt buộc)
# - .github/muse-instructions.md: stack + 6 lệnh Dev/Build/Test/Lint/Full-check/Migrate (chỉ ghi lệnh đã chạy thử)
# - .github/instructions/*.instructions.md: sửa applyTo globs theo thư mục thật (ls để đối chiếu)
# - .vscode/mcp.json: nhập token của mình qua popup ${input} khi IDE hỏi (không hardcode)
# - .vscode/settings.json: thêm path nhạy cảm của repo vào exclusion

# 3. Kiểm tra Copilot nhận đủ config
# Mở repo đích trong IDE rồi:
# - Gõ thử 1 hàm xem suggestions có theo chuẩn team không
# - Mở chat mới hỏi: "liệt kê quy tắc đang áp dụng cho <1 file>" (test instructions load)
# - Gọi /review-pr, /deploy thử (test prompts load)
# - View -> Output -> MCP (test servers sống)
```

## Thứ tự setup khuyên dùng (15 phút)

1. **`muse-instructions.md` trước**: sửa stack + lệnh (chỉ lệnh đã chạy thử).
2. **Instructions theo path**: giữ file nào khớp repo (`backend-api` nếu có `apps/api/`, `frontend-react` nếu có `apps/web/`); sửa `applyTo`, xóa cái không dùng.
3. **Agents**: giữ `explorer` + `tester` (dùng mỗi ngày), giữ `security-reviewer` nếu có auth/payment.
4. **Prompts + Skill**: giữ `review-pr` luôn; giữ `deploy`/`add-table` nếu đúng quy trình Postgres + PR.
5. **MCP**: mở IDE → nhập token khi popup hỏi (github PAT + postgres replica URL). Postgres LUÔN trỏ read-replica + user readonly.
6. **Workflows**: copy 2 file `.yml` nếu repo dùng GitHub Actions; check `permissions:` tối thiểu trước khi merge.
7. **Verify cuối**: nhờ Copilot làm 1 task nhỏ end-to-end (sửa 1 handler + chạy test + review) để chắc mọi mảnh đều chạy.

## Lưu ý an toàn (đọc 1 lần)

- Secrets: `${input}` / `${env}` / `${{ secrets.* }}`. Thấy `ghp_/sk-/postgres://user:pass@` thật trong file commit được → xóa ngay.
- Postgres MCP trỏ read-replica, user chỉ `GRANT SELECT` (xem FAQ 04 câu 6).
- Workflows: `permissions:` tối thiểu, không `echo` secret, KHÔNG flag bypass/skip (xem FAQ 05 câu 9, FAQ 10 câu 4).
