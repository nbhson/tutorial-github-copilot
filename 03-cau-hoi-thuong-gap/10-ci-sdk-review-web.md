# FAQ 10 — CI, SDK, Review & Web

> **Vấn đề:** làm sao Copilot chạy khi bạn không ngồi trước máy — nối Actions với coding agent, viết workflow review/triage, gọi Copilot từ code qua SDK, bật auto review, xài bản Web/Mobile. 10 câu dưới đây trả lời đủ.

## Bảng tổng hợp: automation nào dùng gì

| Muốn | Công cụ | Trigger |
|---|---|---|
| Review PR tự động | Copilot code review / workflow `copilot-review.yml` | PR opened/synchronize |
| Triage issue tự động | Workflow `copilot-ci-triage.yml` + label | Issue opened |
| Agent làm task từ issue | Coding agent (assign `copilot`) | Tay hoặc workflow |
| Gọi Copilot từ code | Copilot SDK / API | App của bạn |
| Dùng ngoài IDE | github.com/copilot, Mobile | Browser/app |

---

## 1. Actions + coding agent nối với nhau thế nào?

**Trả lời 1 câu:** Luồng chuẩn: **Issue (mô tả + acceptance criteria) → assign `copilot` → agent code + mở PR → Actions CI (lint/test) gate → review → merge** — workflow không gọi agent trực tiếp; agent tự lắng nghe assignment, workflow chỉ cần đảm bảo CI xanh/đỏ đúng.

```bash
gh issue create --title "feat(auth): them rate-limit login" \
  --body "Phạm vi: src/auth/**. Xong khi: npm test -- auth xanh + test 429." \
  -l "copilot"
gh pr list --author "app/copilot" --state open
```

> Batch 2-3 issues/lần, đừng giao 10 cùng lúc — review không kịp, PR tồn đọng, CI nghẽn.

## 2. Workflow `copilot-review.yml` mẫu làm gì?

**Trả lời 1 câu:** Chạy khi PR mở/update: checkout → lint/test → gọi Copilot CLI tóm tắt/review → post comment vào PR — secrets qua env, quyền tối thiểu, không flag bypass.

```yaml
on:
  pull_request:
    types: [opened, synchronize]
permissions:
  contents: read
  pull-requests: write  # chi de comment review
```

```bash
cp /path/to/tutorial-copilot/templates/.github/workflows/copilot-review.yml ./.github/workflows/
# Verify: mo PR thu -> comment review tu dong xuat hien
```

**Ví dụ:** PR agent mở → workflow lint đỏ → comment "lint fail ở file X" → agent đọc → push fix → xanh.

## 3. Workflow `copilot-ci-triage.yml` mẫu làm gì?

**Trả lời 1 câu:** Chạy khi issue mới: đọc tiêu đề + body → phân loại (bug/feature/question) → gắn label + comment gợi ý (thiếu log? thiếu acceptance criteria?) — chỉ đọc + label, không sửa code.

```yaml
on:
  issues:
    types: [opened]
permissions:
  issues: write  # chi label + comment
  contents: read
```

**Ví dụ:** issue thiếu log → bot comment "vui lòng bổ sung: version, steps, log" + label `needs-info`. Đỡ ~50% việc phân loại tay cho repo đông issue.

## 4. Secrets trong workflow truyền sao cho đúng?

**Trả lời 1 câu:** 3 quy tắc sắt: secrets chỉ qua `${{ secrets.TEN }}` → `env` (không in log), `permissions:` tối thiểu từng job, KHÔNG dùng flag skip-verification/bypass — fix root cause thay vì bỏ gate.

```yaml
jobs:
  review:
    permissions: { contents: read, pull-requests: write }
    steps:
      - env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: gh pr view "$PR" --json title   # khong in token
```

```bash
# Quét workflow có lộ secret/skip nguy hiểm không
grep -rn "dangerously-skip\|skip-verification\|echo.*secrets\.\|print.*secrets\." .github/workflows/ || echo "Workflows sach"
```

## 5. Copilot SDK là gì, khi nào dùng thay vì chat?

**Trả lời 1 câu:** SDK = thư viện để **app của bạn** gọi năng lực Copilot (completions/agent) từ code — dùng khi logic lặp lại, nhúng hệ thống (bot Slack, dashboard triage), không cần người mở IDE; task 1 lần ad-hoc thì chat nhanh hơn viết app.

SDK bọc Copilot CLI + cung cấp sessions, permissions, custom tools, events. Token qua env, log request count để kiểm soát quota.

```bash
# Docs: https://docs.github.com/en/copilot/building-copilot-extensions
export COPILOT_SDK_TOKEN="${COPILOT_SDK_TOKEN:?thieu token}"
# Trong code: process.env.COPILOT_SDK_TOKEN, khong hardcode
```

> Tên/gói SDK đổi nhanh — đối chiếu docs mới nhất trước khi dùng.

## 6. Code review tự động: bật ở đâu, tin được bao nhiêu?

**Trả lời 1 câu:** 2 lớp — (a) Copilot code review tích hợp PR (Repo Settings → Code security), (b) workflow custom `copilot-review.yml` — tin ở mức **"reviewer đầu tiên"** (bắt style/null-check/thiếu test); quyết định merge vẫn do người.

| Tiêu chí | Copilot code review (tích hợp) | Workflow custom |
|---|---|---|
| Bật ở đâu | Repo Settings → Code security | Thêm file vào `.github/workflows/` |
| Tùy biến | Thấp (theo GitHub) | Cao (checklist riêng team) |
| Chi phí | Theo seat/plan | GitHub Actions minutes (ngoài AI Credits) |
| Khi nào dùng | Bật mặc định mọi repo | Team có chuẩn review riêng |

```bash
# Web: Repo Settings -> Code security -> Copilot code review -> On
gh pr view <NUM> --comments | head -40
```

**Ví dụ:** PR 200 dòng → bot comment 5 Minor → người chỉ soi 1 Major logic → review nhanh gấp đôi.

## 7. github.com/copilot (bản Web) dùng khi nào?

**Trả lời 1 câu:** Khi máy khác không có IDE, review nhanh PR trên web, hỏi về repo public chưa clone — giới hạn: không sửa multi-file mượt như IDE, không có MCP local.

```bash
# Mo https://github.com/copilot -> chon repo context -> hoi:
# "Tom tat PR #123 trong acme/api: doi gi, rui ro gi?"
# Verify: được tóm tắt PR không cần clone
```

> Web còn assign coding agent + xem coding agent status (xem [bài 07](07-custom-agents-coding-agent-workflows.md)).

## 8. Copilot trên Mobile dùng được gì?

**Trả lời 1 câu:** Dùng để **review + quyết định** (đọc issue/PR, hỏi về code, approve workflow runs) — không dùng để code; hợp on-call/di chuyển.

```bash
# GitHub Mobile -> Copilot tab -> chon repo -> hoi / review PR
# Merge tu mobile khi: CI xanh + da doc diff summary cua bot
```

> Combo "giao việc khi làm việc (cloud agent), duyệt khi di chuyển (mobile)".

## 9. Auto-merge PR agent an toàn thế nào?

**Trả lời 1 câu:** Chỉ auto-merge khi đủ 4 điều kiện: **scope trong issue + CI xanh hết + review bot không có Critical + không chạm migrations/infra** — cấu hình bằng branch protection (required checks) + `gh pr merge --auto`.

```bash
gh pr merge <NUM> --auto --squash --delete-branch
gh pr checks <NUM>
gh pr diff <NUM> --name-only | grep -Ei "migrations|infra|terraform" && echo "KHONG auto-merge" || echo "OK auto"
```

> Agent đã tốn AI Credits — auto-merge sai = trả tiền cho merge sai. Repo chưa có CI → không auto-merge bất kỳ PR nào.

## 10. Đo hiệu quả automation: metric nào đáng theo dõi?

**Trả lời 1 câu:** 4 metric/tháng: **tỉ lệ PR agent merge không sửa**, **thời gian issue→merge**, **số comment bot có ích vs nhiễu**, **AI Credits tiêu thụ** (dashboard `github.com/settings/copilot`) — metric đỏ thì tune issue template + checklist review.

```bash
gh pr list --author "app/copilot" --state merged --limit 50 --json number,title,mergedAt | wc -l
```

**Ví dụ:** tháng 1: 20 PR agent, merge 8 (40%) → tune issue template → tháng 2: merge 13 (65%) → automation đáng tiền.

---

## Vẫn lỗi thì sao? (thứ tự debug chuẩn)

1. Workflow fail → đọc log job đỏ đầu tiên (Actions tab).
2. Check `permissions:` + secrets (`grep` câu 4).
3. Test workflow trên PR nhỏ trước khi đổ lỗi agent.
4. PR agent fail → `gh pr checks` + comment `@copilot` hướng fix.
5. SDK lỗi → check token env + docs mới nhất.

Tham khảo chéo: [bài 07](07-custom-agents-coding-agent-workflows.md) (viết issue cho agent) · [bài 05](05-policies-guardrails-faq.md) (guardrails CI) · [bài 02](02-model-context-premium.md) (quota) · [../templates/.github/workflows/](../templates/.github/workflows/) (mẫu workflows).
