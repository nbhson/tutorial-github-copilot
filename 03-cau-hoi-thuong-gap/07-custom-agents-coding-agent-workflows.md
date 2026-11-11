# FAQ 07 — Custom Agents & Cloud Agent Workflows

> **Vấn đề:** custom agent sửa lố scope, cloud agent mở PR xong để lại conflict, CI đỏ không biết bắt đầu từ đâu — 10 câu dưới đây trị bằng `tools` + ranh giới + issue đủ spec, không phải bằng niềm tin.

## Bảng tổng hợp: agent nào việc nào

| Agent | Việc | Tools cho phép |
|---|---|---|
| explorer | Trinh sát chỉ-đọc, vẽ bản đồ file | search (đọc) |
| tester | Chạy test focused, báo PASS/FAIL | terminal test + đọc log |
| security-reviewer | Soi auth/input/crypto/secrets | search + đọc diff |
| cloud agent (GitHub) | Làm task từ issue, mở PR | full trong sandbox + ruleset |

> **Cách đọc bảng này:** mỗi dòng là một "nhân viên" trong đội — cột **Việc** là chuyên môn, cột **Tools cho phép** là chùm chìa khóa bạn trao; trao càng ít chìa, nhân viên càng khó gây hoang phế. · 📄 [VS Code Docs: When to use a custom agent](https://code.visualstudio.com/docs/agent-customization/custom-agents#when-to-use-a-custom-agent)

---

## 1. Custom agent "chạy loạn" — nguyên nhân và cách trị?

**Trả lời 1 câu:** 3 nguyên nhân: thiếu `tools` khóa quyền (agent có full quyền), thiếu ranh giới trong body, task quá to — trị bằng khóa tools + 3 dòng ranh giới + chia nhỏ task.

Hãy hình dung custom agent như nhân viên mới: không giao quyển sổ tay (tools) rõ ràng, không viết bản mô tả công việc (ranh giới), lại còn giao cả tấn việc — thì chớ trách nó "chạy loạn".

```markdown
<!-- .github/agents/explorer.agent.md — trinh sat chi doc -->
---
description: Trinh sat chi doc, ve ban do file
tools: [search]
---
# Explorer — RANH GIỚI (đọc trước khi làm)
- CHỈ đọc file. KHÔNG sửa, KHÔNG chạy lệnh ghi, KHÔNG commit.
- Quá 10 file liên quan -> dừng, hỏi user chọn tiếp.
```

> `tools` + ranh giới là gate thật; hooks (chạy ở Copilot CLI + Copilot in the cloud, VS Code còn Preview) chưa phải security boundary. **Vẫn loạn:** rút `tools` còn 1 tool, thêm "quá 10 file thì dừng", chia task nhỏ hơn. · 📄 [VS Code Docs: Troubleshoot custom agents](https://code.visualstudio.com/docs/agent-customization/custom-agents#troubleshoot-custom-agents)

## 2. Workflow 3 pha explorer → làm → tester?

**Trả lời 1 câu:** Workflow chuẩn cho task >30 phút: mỗi pha một chat — explorer vẽ bản đồ, pha làm sửa đúng list file đó, tester chạy test và báo PASS/FAIL (khảo sát → thi công → nghiệm thu).

> 📄 **Code ví dụ:** [`./examples/07-custom-agents-coding-agent-workflows/workflow-3-pha-explorer-lam-tester.sh`](./examples/07-custom-agents-coding-agent-workflows/workflow-3-pha-explorer-lam-tester.sh)

> Task 1-2 file thì gộp pha 1+2. Dán sai list của explorer là scope trôi ngay. · 📄 [VS Code Docs: Orchestration patterns](https://code.visualstudio.com/docs/agents/run/subagents#orchestration-patterns)

## 3. Security-reviewer gọi khi nào, check gì?

**Trả lời 1 câu:** Gọi khi diff chạm auth/session, input validation, crypto, thanh toán, secrets, permissions hoặc SQL — reviewer chỉ đọc + comment, không sửa.

Checklist: injection (SQL/command), XSS, auth bypass, IDOR, secret lộ, crypto yếu, rate-limit.

> 📄 **Code ví dụ:** [`./examples/07-custom-agents-coding-agent-workflows/security-reviewer-goi-khi-nao-check-gi.sh`](./examples/07-custom-agents-coding-agent-workflows/security-reviewer-goi-khi-nao-check-gi.sh)

> Quy ước team: diff chạm `auth|payment|crypto|admin` → bắt buộc qua security-reviewer. Mẫu: `templates/.github/agents/security-reviewer.agent.md`. · 📄 [VS Code Docs: Use a custom agent](https://code.visualstudio.com/docs/agent-customization/custom-agents#use-a-custom-agent)

## 4. Cloud agent trên GitHub là gì, giao việc thế nào?

**Trả lời 1 câu:** Cloud agent là bot chạy trên cloud GitHub nhận việc từ issue (assign cho `copilot`), tự code + chạy test + mở PR, bạn review như review người thật.

Giao việc chuẩn: issue mô tả **mục tiêu + phạm vi file + acceptance criteria + lệnh test**. Task to tốn nhiều AI Credits hơn → luôn ghi lệnh verify trong issue.

```markdown
<!-- Mau issue giao cho cloud agent -->
## Mục tiêu
Thêm rate-limit 100 req/phút cho /api/login.

## Phạm vi
- Chỉ sửa: src/auth/**, tests/auth/**
- KHÔNG đụng: infra/, db/migrations/

## Xong khi
- [ ] npm test -- auth xanh
- [ ] Có test cho case vượt limit (expect 429)
- [ ] Mở PR về develop
```

> 📄 **Code ví dụ:** [`./examples/07-custom-agents-coding-agent-workflows/coding-agent-tren-github-la-gi-giao.sh`](./examples/07-custom-agents-coding-agent-workflows/coding-agent-tren-github-la-gi-giao.sh)

> Task rõ ràng, có test, scope hẹp → agent làm tốt. Task mơ hồ thì làm rõ issue trước, đừng assign đi assign lại. · 📄 [GitHub Docs: Start Copilot sessions](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent/start-copilot-sessions)

## 5. Cloud agent conflict / PR fail — xử lý sao?

**Trả lời 1 câu:** 3 ca: conflict → rebase lên base mới; CI đỏ → đọc log job đỏ đầu tiên rồi comment `@copilot` bảo fix; PR sai scope → request changes hoặc checkout về sửa tay.

| Ca | Triệu chứng | Cách xử |
|---|---|---|
| Conflict với main | Base branch trôi trong lúc agent làm | Rebase lên `origin/main` → `git push --force-with-lease` |
| CI đỏ | Check/job đỏ trên PR | Đọc log job đỏ đầu tiên, comment `@copilot` fix cụ thể |
| PR sai scope | Agent sửa file ngoài issue | Request changes liệt kê file cần revert, hoặc checkout sửa tay |

> **Cách đọc bảng này:** cột **Ca** là ba bệnh hay gặp nhất của PR từ agent, cột **Triệu chứng** giúp xác nhận đúng bệnh, cột **Cách xử** là lệnh/thao tác chữa — nhìn 10 giây là ra hướng xử.

> 📄 **Code ví dụ:** [`./examples/07-custom-agents-coding-agent-workflows/coding-agent-conflict-pr-fail-xu-ly.sh`](./examples/07-custom-agents-coding-agent-workflows/coding-agent-conflict-pr-fail-xu-ly.sh) · 📄 [GitHub Docs: Troubleshoot cloud agent](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent/troubleshoot-cloud-agent)

**Ví dụ:** CI đỏ job `test` thiếu import → comment trong PR: "@copilot thiếu import X ở file Y" → agent push fix.

## 6. Viết issue thế nào để agent làm đúng ngay lần 1?

**Trả lời 1 câu:** Issue đủ 5 phần — **bối cảnh, mục tiêu, phạm vi file, acceptance criteria, lệnh verify** — thiếu phần nào agent tự đoán phần đó (và đoán sai).

Ví von: giao việc cho agent cũng như giao việc cho thợ mới hoàn toàn — bản vẽ càng chi tiết, ngôi nhà càng đúng ý; chỉ nói "xây nhà đẹp" là đón nhận bất kỳ cái nhà nào.

- Tốt: "Thêm 429 khi vượt 100 req/phút, chỉ src/auth/**, test expect 429, verify `npm test -- auth`."
- Dở: "Làm rate limit đi."

> 📄 **Code ví dụ:** [`./examples/07-custom-agents-coding-agent-workflows/viet-issue-the-nao-e-agent-lam.sh`](./examples/07-custom-agents-coding-agent-workflows/viet-issue-the-nao-e-agent-lam.sh)

> 5 phút viết issue kỹ đỡ 30 phút sửa PR; lệnh verify nên trùng lệnh đã ghi trong `copilot-instructions.md`. · 📄 [GitHub Docs: Kick off a task](https://docs.github.com/en/copilot/how-tos/copilot-on-github/use-copilot-agents/kick-off-a-task)

## 7. Nhiều agents cùng làm 1 repo — tránh giẫm chân?

**Trả lời 1 câu:** Quy tắc: **1 agent = 1 branch + 1 scope file không giao nhau** — chia theo module (auth/payments) hoặc tầng (API/tests); giao 2 agents cùng file là conflict chắc chắn.

> 📄 **Code ví dụ:** [`./examples/07-custom-agents-coding-agent-workflows/nhieu-agents-cung-lam-1-repo-tranh.sh`](./examples/07-custom-agents-coding-agent-workflows/nhieu-agents-cung-lam-1-repo-tranh.sh) · 📄 [GitHub Docs: Delegating & parallelizing agent work](https://docs.github.com/en/copilot/concepts/agent-capabilities/choosing-and-delegating-agent-work/delegating-and-parallelizing-work-with-agents)

## 8. Handoff người ↔ agent: tiếp tục dở dang thế nào?

**Trả lời 1 câu:** 2 chiều: người tiếp quản bằng `gh pr checkout` + sửa + push; agent tiếp quản bằng comment `@copilot` với yêu cầu cụ thể — luôn đọc PR timeline trước khi tiếp quản.

> 📄 **Code ví dụ:** [`./examples/07-custom-agents-coding-agent-workflows/handoff-nguoi-agent-tiep-tuc-do-dang.sh`](./examples/07-custom-agents-coding-agent-workflows/handoff-nguoi-agent-tiep-tuc-do-dang.sh)

> Agent lặp lần 3 không xong → người vào là hiệu quả nhất: làm 80% của nó + fix 20% còn lại, nhanh hơn chờ vòng lặp thứ 4 đốt Credits. · 📄 [VS Code Docs: Hand off a session](https://code.visualstudio.com/docs/agents/concepts/sessions#hand-off-a-session)

## 9. Đo chất lượng agent: khi nào tin, khi nào không?

**Trả lời 1 câu:** Tin (review nhanh) khi scope hẹp + test xanh + diff <300 dòng + không chạm auth/infra; review từng dòng khi diff to, chạm migration/infra, không test, hoặc agent tự "sáng tạo" thêm scope.

| Tiêu chí | Tin (review nhanh) | Không tin (review từng dòng) |
|---|---|---|
| Scope | Hẹp, đúng trong issue | Lố, tự mở rộng |
| Test | Có test xanh | Không có test |
| Diff | Nhỏ (<300 dòng) | To (>500 dòng / >10 file) |
| Vùng chạm | Không chạm auth/infra | Chạm migration/infra/auth |

> **Cách đọc bảng này:** đây là "đồng hồ đo độ tin" — dọc từng tiêu chí xem PR agent rơi vào cột nào; chỉ cần 1 dòng rơi sang cột phải là chuyển sang review từng dòng.

> 📄 **Code ví dụ:** [`./examples/07-custom-agents-coding-agent-workflows/o-chat-luong-agent-khi-nao-tin.sh`](./examples/07-custom-agents-coding-agent-workflows/o-chat-luong-agent-khi-nao-tin.sh)

> Thước đo team: tỉ lệ PR agent merge không sửa (target >60% sau 1 tháng fine-tune issue template); track chi phí bằng dashboard AI Credits ở `github.com/settings/copilot`. · 📄 [GitHub Docs: Interpret Copilot metrics](https://docs.github.com/en/copilot/reference/copilot-usage-metrics/interpret-copilot-metrics)

## 10. Dọn dẹp sau agent?

**Trả lời 1 câu:** Sau merge: xóa branch agent (`--delete-branch`), resolve comments, **giữ nguyên issue + PR timeline** làm tài liệu và bằng chứng chi phí AI Credits đã trả — đừng xóa issue vì đó là spec gốc.

> 📄 **Code ví dụ:** [`./examples/07-custom-agents-coding-agent-workflows/don-dep-sau-agent.sh`](./examples/07-custom-agents-coding-agent-workflows/don-dep-sau-agent.sh) · 📄 [VS Code Docs: Clean up session worktrees](https://code.visualstudio.com/docs/agents/run/sessions/manage-sessions#clean-up-session-worktrees)

---

## Vẫn lỗi thì sao? (thứ tự debug chuẩn)

1. Agent loạn → check `tools` + ranh giới trong `*.agent.md`.
2. Scope lố → thu hẹp issue/prompt, chia task nhỏ.
3. PR fail → `gh pr checks` đọc log job đỏ đầu tiên.
4. Conflict → rebase lên base mới nhất.
5. Lặp 3 lần không xong → người checkout làm tiếp, đừng đốt AI Credits.

Tham khảo chéo: [bài 06](06-prompts-agents-instructions.md) (viết agent đúng) · [bài 10](10-ci-sdk-review-web.md) (CI + review PR agent) · [bài 03](03-modes-permissions.md) (permissions) · [bài 05](05-policies-guardrails-faq.md) (guardrails repo) · 📄 3 agent mẫu: [`../templates/.github/agents/`](../templates/.github/agents/).

> **Tóm gọn 1 câu:** Custom agent là nhân viên cần bản mô tả công việc rõ (tools + ranh giới + issue đủ 5 phần) — làm khó nó thì lỗi là do bản giao việc, còn lặp 3 lần không xong thì đổi người (bạn) vào làm. · 📄 [VS Code Docs: Prevent the agent from drifting](https://code.visualstudio.com/docs/agents/guides/get-agent-back-on-track#prevent-the-agent-from-drifting)
