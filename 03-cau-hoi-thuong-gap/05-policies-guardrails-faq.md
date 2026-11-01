# FAQ 05 — Policies & Guardrails FAQ

> **Vấn đề:** "instruction không ăn thì fix sao, chặn commit xấu và push main thế nào" — nguyên tắc chung: quy tắc nào chỉ nên *nhắc* thì để instructions; quy tắc nào *tuyệt đối không được phạm* thì khóa cứng ở server (policy / branch protection / secret scanning).

## Bảng tổng hợp: guardrail nào chặn ở đâu

| Muốn chặn | Công cụ | Chặn ở tầng |
|---|---|---|
| Copilot đọc file nhạy cảm | Content exclusion | IDE + org policy |
| Commit sai chuẩn / dính secret | Pre-commit hooks + secret scanning | Local + GitHub |
| Push thẳng main | Branch protection ruleset | GitHub server |
| Agent làm việc cấm | Instructions "KHÔNG" + approval | Prompt + IDE |
| PR chưa review đã merge | Required reviewers + status checks | GitHub server |

> **Cách đọc bảng này:** dọc cột **Muốn chặn** tìm đúng điều bạn sợ xảy ra, cột **Công cụ** là thiết bị cần lắp, cột **Chặn ở tầng** cho biết nó nằm ở máy bạn hay trên server GitHub — càng về server càng không ai tắt được.

---

## 1. Instruction "không ăn" — vì sao Copilot vẫn làm điều cấm?

**Trả lời 1 câu:** 5 nguyên nhân theo thứ tự kiểm tra: file đặt sai chỗ → `applyTo` sai glob → câu cấm mơ hồ → prompt task đè instruction → context tràn.

Coi đây như checklist "vì sao thư không tới tay người nhận": sai địa chỉ, sai tem, viết chữ khó đọc, có người khác nói to hơn trong phòng, hoặc hộp thư đầy — đi từng nguyên nhân một, đừng ngồi viết lại lá thư to tiếng hơn.

1. `copilot-instructions.md` phải ở `.github/`; instructions con phải `*.instructions.md` trong `.github/instructions/`.
2. `applyTo` sai glob → file cần không khớp pattern (xem [bài 06](06-prompts-agents-instructions.md)).
3. "Cẩn thận với migrations" yếu hơn "KHÔNG sửa db/migrations/** dưới mọi hình thức".
4. User bảo "sửa luôn migration" → model nghe prompt gần hơn instruction.
5. Context tràn → instructions bị cắt khỏi window (xem [bài 02](02-model-context-premium.md)).

> 📄 **Code ví dụ:** [`examples/01-1-instruction-khong-an-vi-sao-copilot-van.sh`](examples/01-1-instruction-khong-an-vi-sao-copilot-van.sh)

> Đi tăng cường độ câu chữ ("KHÔNG, TUYỆT ĐỐI KHÔNG...") trong khi file nằm sai thư mục thì câu cấm có mạnh đến mấy cũng không được nạp.

## 2. Viết quy tắc "cấm" sao cho Copilot nghe lời?

**Trả lời 1 câu:** Công thức: **động từ mạnh (ALWAYS/NEVER) + phạm vi chính xác + hậu quả/hướng thay thế** — model chỉ tuân theo thứ nó kiểm chứng được.

```markdown
<!-- Mẫu block Rules trong .github/copilot-instructions.md -->
## Rules (bắt buộc)
- NEVER commit trực tiếp main. Luôn tạo branch `feat/<ten>`.
- NEVER sửa `db/migrations/**` đã merge. Tạo migration mới.
- NEVER hardcode secret. Secrets chỉ qua `process.env.*`.
- ALWAYS chạy focused test sau mỗi sửa, paste kết quả PASS/FAIL.
```

- Yếu: "Cẩn thận khi sửa migrations." — Mạnh: "NEVER sửa `db/migrations/**`. DB change → tạo file migration mới + chạy `npm run migrate:up`."
- Yếu: "Nhớ chạy test." — Mạnh: "ALWAYS chạy `npm test -- <file-lien-quan>` sau mỗi sửa."

> Rule quan trọng đặt lên top 20 dòng file — rule nằm cuối file dài dễ bị cắt khỏi context.

## 3. Pre-commit tương đương: chặn commit xấu thế nào?

**Trả lời 1 câu:** Dựng 3 lớp deterministic chạy *ngoài* model — pre-commit framework (lint/test), gitleaks (secret scan), GitHub push protection — không model nào tắt được.

Ví von: đây là cửa ra vào có khóa cơ và camera — không phụ thuộc lời hứa của người ở trong nhà.

> Copilot có hooks in-process (`.github/hooks/*.json`, `PreToolUse`/`PostToolUse`) nhưng **preview, chỉ chạy Local**, chưa phải security boundary — muốn "không thể tắt được" thì phải dựa vào git hook + server.

| Lớp | Công cụ | Chặn gì | Chặn ở đâu |
|---|---|---|---|
| Pre-commit framework | `pre-commit` | Lint/format/test nhanh | Local (git hook) |
| Secret scan | gitleaks/trufflehog | Secret trong staged files | Local (git hook) |
| Push protection | GitHub secret scanning | Secret đã biết lúc push | GitHub server |

> **Cách đọc bảng này:** ba dòng là ba lớp rào xếp từ trong nhà ra tới cổng — lint/test bắt lỗi tại chỗ, gitleaks bắt secret trước khi commit, push protection là cánh cổng cuối của GitHub.

> 📄 **Code ví dụ:** [`examples/02-3-pre-commit-tuong-uong-chan-commit-xau.sh`](examples/02-3-pre-commit-tuong-uong-chan-commit-xau.sh)

## 4. Branch protection: chặn push main + ép review thế nào?

**Trả lời 1 câu:** Tạo ruleset `protect-main` ở `Repo → Settings → Rules → Rulesets`: require PR + status checks + block force push — lớp "law" thật sự: dù agent hay người, vào `main` đều phải qua PR + CI xanh.

> 📄 **Code ví dụ:** [`examples/03-4-branch-protection-chan-push-main-ep-review.sh`](examples/03-4-branch-protection-chan-push-main-ep-review.sh)

> Dựng **trước** khi onboarding Copilot coding agent — nó cũng phải tuân ruleset.

## 5. Secret scanning + push protection bật thế nào?

**Trả lời 1 câu:** Bật ở `Repo/Org → Settings → Code security → Secret scanning + Push protection`; lỡ commit secret thì **xoay key NGAY rồi mới xóa history** — xóa commit mà không xoay thì key vẫn sống trong tay kẻ đã clone.

- **Secret scanning:** quét repo tìm secret đã lộ → alert trong `Security → Secret scanning`.
- **Push protection:** chặn ngay lúc `git push`, bypass có lý do (lưu audit log).

> 📄 **Code ví dụ:** [`examples/04-5-secret-scanning-push-protection-bat-the-nao.sh`](examples/04-5-secret-scanning-push-protection-bat-the-nao.sh)

## 6. Ép conventional commits / lint trước khi agent commit?

**Trả lời 1 câu:** commitlint hook local (chặn ngay khi commit) + status check CI (PR không merge được nếu đỏ) — agent và người cùng bị ép một chuẩn.

> 📄 **Code ví dụ:** [`examples/05-6-ep-conventional-commits-lint-truoc-khi-agent.yaml`](examples/05-6-ep-conventional-commits-lint-truoc-khi-agent.yaml)

**Ví dụ:** agent commit `fix stuff` → commitlint chặn → agent tự sửa thành `fix(auth): handle expired session`.

## 7. Giới hạn coding agent: chỉ cho nó đụng repo/branch nào?

**Trả lời 1 câu:** Admin (Enterprise) cấu hình ở org policy (coding agent bật cho repo nào); dev ghi rõ repo + branch + phạm vi file trong issue để agent không lan ra ngoài.

> 📄 **Code ví dụ:** [`examples/06-7-gioi-han-coding-agent-chi-cho-no.sh`](examples/06-7-gioi-han-coding-agent-chi-cho-no.sh)

## 8. Audit: biết ai/agent đã làm gì?

**Trả lời 1 câu:** 3 nguồn log: git history (commit agent có `Co-authored-by: Copilot`), org audit log (ai đổi policy/assign seat), PR timeline (agent ghi comment từng bước).

> 📄 **Code ví dụ:** [`examples/07-8-audit-biet-ai-agent-a-lam-gi.sh`](examples/07-8-audit-biet-ai-agent-a-lam-gi.sh)

## 9. Guardrail cho lệnh nguy hiểm trong CI?

**Trả lời 1 câu:** Secrets qua `${{ secrets.* }}` → `env`, KHÔNG `echo` secret, KHÔNG flag skip-verification/bypass; job đụng prod dùng `environment:` + required reviewers.

> 📄 **Code ví dụ:** [`examples/08-9-guardrail-cho-lenh-nguy-hiem-trong-ci.yaml`](examples/08-9-guardrail-cho-lenh-nguy-hiem-trong-ci.yaml)

## 10. Checklist guardrails cho repo mới (5 phút)?

**Trả lời 1 câu:** 6 tick: exclusion paths, block Rules ALWAYS/NEVER, ruleset bảo vệ `main`, secret scanning + push protection, CI lint/test, `mcp.json` không hardcode.

> 📄 **Code ví dụ:** [`examples/09-10-checklist-guardrails-cho-repo-moi-5-phut.sh`](examples/09-10-checklist-guardrails-cho-repo-moi-5-phut.sh)

> Đây là definition-of-done trước khi bật coding agent — thiếu 1 tick là mở một đường lách qua guardrail.

---

## Vẫn lỗi thì sao? (thứ tự debug chuẩn)

1. Instruction sai chỗ/sai glob? (`ls .github/`, xem [bài 06](06-prompts-agents-instructions.md)).
2. Quy tắc viết mơ hồ? → viết lại ALWAYS/NEVER + path cụ thể.
3. Hook local đã `pre-commit install` chưa.
4. Ruleset/push protection chặn? → đọc thông báo chặn (nó nói rõ lý do).
5. Vẫn lọt → nâng từ "khuyến nghị" lên "ép buộc server-side" (ruleset + required checks).

Tham khảo chéo: [bài 03](03-modes-permissions.md) (content exclusion) · [bài 09](09-bao-mat-quyen-rieng-tu.md) (secrets + audit sâu) · [bài 10](10-ci-sdk-review-web.md) (CI workflows) · [../templates/README.md](../templates/README.md).

> **Tóm gọn 1 câu:** Quy tắc nhắc miệng là lời khuyên, quy tắc khóa ở server là luật — cái nào phạm vào là mất tài sản thì phải đưa từ "lời khuyên" lên thành "luật".
