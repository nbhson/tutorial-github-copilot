# Tips 06 — Policies & Guardrails: Recipes Chống Copilot Đi Lạc

> **Dành cho:** dev / tech lead mỏi miệng vì phải nhắc Copilot "đừng sửa cái này, đừng commit main nhé".
> **Vấn đề:** Copilot quên luật sau vài chục turns, sửa lan `generated/`, commit thẳng main, chạy lệnh nguy hiểm, gọi MCP bừa — không ai chặn giúp lúc 2h sáng.
> **Đọc xong:** dựng được 4 lớp guardrails tự chạy (instructions → local gate → CI → MCP approval) bằng 12 recipe copy-paste.
> **Thời gian:** ~20 phút đọc + ~45 phút dựng theo walkthrough.

Copilot **không có hooks native** như một số agent khác, nên bài này ghép các recipe **tương đương hooks**: instruction enforcement, pre-commit, branch protection, MCP/tool approval — copy-paste là dùng ngay.

## 1. Vì sao cần guardrails?

Không guardrails, Copilot sẽ: đụng `src/generated/`, đổi schema, commit thẳng main; thêm dependency vì tiện; chạy `rm -rf`/`git reset --hard` khi được full quyền; gọi MCP ngoài luồng, rò secret vào prompt.

> Rule: **luật nào bạn phải nhắc >2 lần thì viết thành guardrail, đừng nhắc miệng nữa.** · 📄 [VS Code Docs: Recommended security baseline](https://code.visualstudio.com/docs/agents/run/security#recommended-security-baseline)

## 2. Cơ chế: 4 lớp phòng thủ sâu

Mục này dựng thành phòng thủ nhiều tầng cho repo. Đọc bảng để hiểu mỗi lớp đứng ở đâu — ý tưởng giống cửa hàng có khóa tủ + camera + bảo vệ: lỡ một lớp vẫn còn lớp sau.

| Lớp | Chặn ở đâu | Ví dụ | Ai giữ |
|---|---|---|---|
| 1 | Instructions (tự áp mọi turn) | copilot-instructions.md, *.instructions.md | Dev / team |
| 2 | Local gates (máy bạn) — 📄 script dựng hook: [`../01-huong-dan-su-dung/examples/07-policies-guardrails-tu-dong-hoa/recipe-b-precommit-gitleaks.sh`](../01-huong-dan-su-dung/examples/07-policies-guardrails-tu-dong-hoa/recipe-b-precommit-gitleaks.sh) | pre-commit, lint-staged, tool approval | Dev |
| 3 | Remote gates (GitHub) — 📄 [`../01-huong-dan-su-dung/examples/15-security-stack-5-tang/auto-review-rulesets.sh`](../01-huong-dan-su-dung/examples/15-security-stack-5-tang/auto-review-rulesets.sh) | Branch protection, required checks, CODEOWNERS | Org / maintainer |
| 4 | Tool/MCP approval | Hỏi trước khi chạy lệnh/MCP | Dev / org policy |

> **Cách đọc bảng này:** đọc từ lớp 1 lên lớp 4 theo độ "cứng" tăng dần — càng xuống dưới càng chặn thật chứ không chỉ dặn miệng; cột **Ai giữ** cho biết ai phải có tay dựng lớp đó.

```text
Instructions dặn đừng → local gate chặn nếu vẫn làm → CI gate chặn nếu lọt → review người chốt.
Lọt 1 lớp không sao, còn 3 lớp sau.
```

Cảnh báo hay gặp nhất: viết "đừng chạy `rm -rf`" vào instructions rồi tin là chặn được — không, instructions chỉ *dặn miệng*, phải có **tool approval** mới chặn thật lúc lệnh sắp chạy.

> **Tóm gọn 1 câu:** Guardrails là thành trì nhiều tầng: chữ viết là cổng ngoài, git hook là tường, CI là hào, approval là ô cửa sổ cuối cùng — lọt tầng này còn tầng kia. · 📄 [VS Code Docs: Trust boundaries](https://code.visualstudio.com/docs/agents/run/security#trust-boundaries)

## 3. Lớp 1: instruction enforcement

Lớp rẻ nhất, mềm nhất — ví von cho dễ hình dung: nó là tấm biển "xin đừng bấm chuông", người lịch sự sẽ tuân nhưng không ai bắt buộc được. Nó chỉ "dặn", model vẫn có thể quên, đừng giao việc sống còn cho mỗi lớp này.

**Recipe 1 — copilot-instructions.md cấm địa (copy-paste):**

```markdown
# .github/copilot-instructions.md

## Cấm địa (NEVER, áp mọi turn)
- Không sửa `src/generated/`, `dist/`, `*.lock`.
- Không đổi DB schema/migration nếu chưa hỏi.
- Không commit thẳng `main`, luôn tạo branch + PR.
- Không thêm dependency mới nếu chưa được duyệt.
- Không xóa/sửa test để cho xanh.

## Verify bắt buộc
- Mọi change code phải kèm lệnh test + log dán.
- Feature/refactor: `npm test` + `npm run lint` + `npm run build`.

## Khi không chắc
- Hỏi trước khi đoán. Thiếu spec thì trình 2 phương án + chờ duyệt.
```

**Recipe 2 — Path-scoped instructions (copy-paste):**

```markdown
---
applyTo: "src/payments/**"
---

## Riêng payments
- Mọi refund >30 ngày phải hỏi duyệt, không tự quyết.
- Mọi API mới phải có idempotency-key.
- Test bắt buộc: `npm test -- payments` xanh.
```

**Recipe 3 — Prompt files có gate sẵn:** file `.prompt.md` (mode: agent) mở đầu bằng "Đọc plan.md, liệt kê files sẽ sửa — file ngoài plan → hỏi trước" và kết thúc bằng gate chạy test/lint/build + `git diff --stat` lệch scope thì dừng. Chi tiết xem [Tips 07](./07-thiet-ke-prompts-skills.md). · 📄 [VS Code Docs: How instructions apply](https://code.visualstudio.com/docs/agent-customization/custom-instructions#how-instructions-apply)

## 4. Lớp 2: pre-commit + local gates

Mục này dựng chốt chặn ngay trên máy bạn — nơi bắt lỗi sớm và rẻ nhất. Hãy hình dung như chỗ cân hành lý ở sân bay: soi ở quầy thì mở valy sửa 2 phút, để lên máy bay mới phát hiện thì khổ gấp mười.

Nguyên tắc: **gate nhanh để ở local, gate nặng để cho CI** — bắt local chờ 10 phút mỗi commit là dev sẽ lách bằng `--no-verify`.

**Recipe 4 — pre-commit chặn rác (copy-paste):**

> 📄 **Code ví dụ:** [`./examples/06-policies-guardrails-recipes/lop-2-pre-commit-local-gates.yaml`](./examples/06-policies-guardrails-recipes/lop-2-pre-commit-local-gates.yaml)

> 📄 **Code ví dụ:** [`./examples/06-policies-guardrails-recipes/1-lop-2-pre-commit-local-gates.sh`](./examples/06-policies-guardrails-recipes/1-lop-2-pre-commit-local-gates.sh)

**Recipe 5 — lint-staged + test nhanh:**

> 📄 **Code ví dụ:** [`./examples/06-policies-guardrails-recipes/lop-2-pre-commit-local-gates.json`](./examples/06-policies-guardrails-recipes/lop-2-pre-commit-local-gates.json)

> 📄 **Code ví dụ:** [`./examples/06-policies-guardrails-recipes/2-lop-2-pre-commit-local-gates.sh`](./examples/06-policies-guardrails-recipes/2-lop-2-pre-commit-local-gates.sh) · 📄 [VS Code Docs: Hook decisions & failures](https://code.visualstudio.com/docs/agent-customization/hooks#decisions-and-failures)

**Recipe 6 — Tool approval trong VS Code:**

```text
VS Code → Settings → Copilot → Agent:
- Confirm before running commands: ON
- Allowed commands: npm test*, npm run lint, npm run build
- Blocked: rm -rf *, git reset --hard, git push --force
```

## 5. Lớp 3: branch protection + CI gates

**Recipe 7 — Branch protection chuẩn (checklist):**

```text
Repo → Settings → Branches → Add rule (main):
- [x] Require pull request before merging (1 review)
- [x] Require status checks: test / lint / build
- [x] Require Copilot code review
- [x] Dismiss stale reviews khi push mới
- [x] Block force push
- [x] Require CODEOWNERS review cho src/payments/**
```

**Recipe 8 — CI workflow gate (copy-paste):**

> 📄 **Code ví dụ:** [`./examples/06-policies-guardrails-recipes/lop-3-branch-protection-ci-gates.yaml`](./examples/06-policies-guardrails-recipes/lop-3-branch-protection-ci-gates.yaml) — bài tập walkthrough dùng lại bộ file §3–4 + [`../01-huong-dan-su-dung/examples/07-policies-guardrails-tu-dong-hoa/guard-allow-deny.sh`](../01-huong-dan-su-dung/examples/07-policies-guardrails-tu-dong-hoa/guard-allow-deny.sh) (hook deny lệnh nguy hiểm). · 📄 [GitHub Docs: Copilot enterprise policies](https://docs.github.com/en/copilot/concepts/enterprise/policies)

**Recipe 9 — CODEOWNERS + org policy:**

```text
# CODEOWNERS
/src/payments/** @team-payments
/src/auth/** @team-auth
/.github/copilot-instructions.md @tech-leads
/.github/prompts/** @tech-leads
```

```text
GitHub Org → Copilot → Policies:
- cloud agent chỉ chạy trên repo có CI xanh mẫu.
- Chặn Copilot suggest cho file *.pem, .env, secrets/.
- Mọi thay đổi instructions/prompts phải qua PR + 1 review lead.
```

## 6. Lớp 4: MCP / tool approval

Mục này nói về cánh cửa cuối cùng trước thế giới ngoài: MCP và lệnh terminal. MCP mở đường ra DB, deploy, web — cũng là nơi dễ rò secret nhất. Nguyên tắc: **mặc định từ chối, chỉ mở đúng cái cần.**

> **Tóm gọn 1 câu:** MCP là cửa sau của ngôi nhà: chốt cửa mặc định, chỉ mở đúng người quen cần vào — cả nhà không cần chìa khóa mọi cánh cửa. 📄 Walkthrough dùng lại đúng 5 file ở §3–4 + [kịch bản allow/ask/deny](../01-huong-dan-su-dung/examples/08-mcp-ket-noi-cong-cu-ngoai/approval-allow-ask-deny.jsonc). · 📄 [VS Code Docs: Manage tool approvals](https://code.visualstudio.com/docs/agents/run/approvals#manage-tool-approvals)

**Recipe 10 — Prune MCP + approval hỏi trước (mỗi tháng 1 lần):**

```text
Prune:
1. Extensions → Copilot related: tắt cái 2 tuần không dùng.
2. Settings → MCP servers: giữ ≤6 servers thực dùng.
3. Server nào không nhớ tác dụng → tắt, cần thì bật lại.

Approval:
- Auto-approve: OFF cho servers có quyền write/remote.
- Allowlist: chỉ read docs, search code.
- Audit log: bật, monthly review tool nào gọi nhiều nhất.
```

**Recipe 11 — Secret hygiene:**

```text
.gitignore bắt buộc: .env, *.pem, *.key, secrets/

Instructions thêm:
- Không đọc file .env*, không in secret ra chat/log.
- Cần config mẫu → đọc .env.example, không đọc .env thật.
```

## 7. Walkthrough: dựng guardrails 45 phút

| Phút | Lớp | Việc |
|---|---|---|
| 0–10 | 1 | Tạo copilot-instructions.md (recipe 1) + 2 files applyTo (recipe 2) |
| 10–20 | 2 | Thêm pre-commit (recipe 4), install, test commit chặn generated/ |
| 20–25 | 2 | Bật tool approval: confirm ON, allowlist test/lint/build (recipe 6) |
| 25–35 | 3 | Thêm verify.yml (recipe 8) + branch protection (recipe 7) |
| 35–40 | 3 | CODEOWNERS (recipe 9), tạo PR mẫu kiểm tra CI + review |
| 40–45 | 4 | Audit MCP/extensions, tắt server thừa, auto-approve OFF (📄 kịch bản allow/ask/deny: [`../01-huong-dan-su-dung/examples/08-mcp-ket-noi-cong-cu-ngoai/approval-allow-ask-deny.jsonc`](../01-huong-dan-su-dung/examples/08-mcp-ket-noi-cong-cu-ngoai/approval-allow-ask-deny.jsonc)). Kiểm chứng: thử cố ý sai 3 kiểu (sửa `generated/`, commit main, chạy lệnh lạ) → phải bị chặn ≥1 lớp với log BLOCKED |

📄 [VS Code Docs: Scope & isolation](https://code.visualstudio.com/docs/agents/run/security#scope-and-isolation)

## 8. Pitfalls + cách fix

| Pitfall | Triệu chứng | Fix |
|---|---|---|
| Instructions 600 dòng | Copilot quên đầu, chậm | <200 dòng + applyTo files riêng |
| Branch protection quá chặt | Team kêu không làm được | Bắt đầu nhẹ (1 review + CI), chặt dần |
| Tool approval hỏi mọi lệnh | Bạn bấm mỏi tay | Allowlist test/lint/build, chỉ hỏi lệnh lạ |
| MCP bật 12 servers | Chọn sai tool, tốn requests | ≤6 servers, tắt cái 2 tuần không dùng |
| Guardrails chỉ trên máy bạn | Người khác vẫn đi lạc | Commit instructions/prompts/CI vào repo (xem Tips 09) |
| Secret lọt vào chat | Rò rỉ token | Recipe 11 + gitignore + review PR |

> **Cách đọc bảng này:** quét cột **Pitfall** xem bạn đang mắc ca nào, cột **Triệu chứng** giúp xác nhận đúng bệnh, cột **Fix** trỏ về recipe đúng để dựng lại chốt chặn. · 📄 [VS Code Docs: Hook decisions & failures](https://code.visualstudio.com/docs/agent-customization/hooks#decisions-and-failures)

Bài học lớn nhất: **guardrail bị bypass còn tệ hơn không có** — siết quá chặt ngay từ đầu khiến team lách bằng `--no-verify`, chọn độ chặt sao cho team chịu đi qua nó.

## 9. Bài tập cuối bài

**Bài 1 (20 phút):** Viết ra 1 lỗi Copilot hay mắc nhất của bạn, áp 1 recipe lớp 1 + 1 recipe lớp 2/3. Test: nhờ Copilot làm sai cố ý, xem gate có chặn không?

**Bài 2 (45 phút):** Thêm verify.yml (recipe 8) + branch protection (recipe 7) + CODEOWNERS (recipe 9). Tạo PR test, thử merge PR đỏ → phải bị chặn mới đạt. Tắt luôn MCP server 2 tuần không dùng, bật approval cho write/remote.

> Đạt: sau 1 tháng, 0 incident sửa generated/commit thẳng main/rò secret từ Copilot.

## Tham khảo chéo

- [Tips 04](./04-verification-done-that.md) — verify + review gate
- [Tips 07](./07-thiet-ke-prompts-skills.md) — thiết kế instructions/prompts tái dùng
- [Tips 08](./08-tiet-kiem-ai-credits.md) — prune MCP/extensions tiết kiệm
- [Tips 09](./09-teamwork-chuan-hoa.md) — chuẩn hóa guardrails cho cả team
- [Tips 11](./11-nang-cao-cli-web-coding-agent.md) — policy cho Copilot cloud agent

> **Chốt Tips 06:** guardrail không phải để bắt Copilot bớt thông minh, mà để bạn **không phải có mặt lúc 2h sáng** — luật nhắc 2 lần thì cài chốt, chặn trước bằng instructions, khóa sau bằng CI.
