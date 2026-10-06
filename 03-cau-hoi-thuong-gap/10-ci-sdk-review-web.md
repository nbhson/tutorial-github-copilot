# FAQ 10 — CI, SDK, Review & Web

> Nhóm Tự động hóa & Nền tảng · 10 câu hỏi deep-dive · Đọc xong nối Actions + coding agent, dùng SDK, bật auto review, xài bản Web/Mobile

File này trả lời mọi câu hỏi "Actions + coding agent, SDK, code review auto, github.com/mobile". Mỗi câu có giải thích + lệnh copy-paste + ví dụ + khi nào áp dụng.

---

## Sơ đồ tư duy nhanh (đọc 30 giây)

```mermaid
flowchart LR
    A[Can gi?] --> B{Tu dong PR?}
    B -->|Yes| C[copilot-review.yml]
    A --> D{Triage issue?}
    D -->|Yes| E[copilot-ci-triage.yml]
    A --> F{SDK?}
    F -->|Yes| G[SDK thay chat tay]
```

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

> **Hỏi ngắn gọn:** _Actions + coding agent nối với nhau thế nào?_

**Trả lời 1 câu:** 

**Giải thích chi tiết + ví dụ:** Luồng chuẩn: **Issue (mô tả + acceptance criteria) → assign `copilot` → agent code + mở PR → Actions CI (lint/test) chạy → review → merge.** Workflow của bạn không cần gọi agent trực tiếp; agent tự lắng nghe assignment. Workflow chỉ cần đảm bảo CI xanh/đỏ đúng để gate PR agent.

### Làm thế nào (steps copy-paste)

Copy từng bước theo thứ tự (dán vào terminal/IDE là chạy):

```bash
# Giao việc cho coding agent từ CLI (tạo issue + assign)
gh issue create --title "feat(auth): thêm rate-limit login" \
  --body "Phạm vi: src/auth/**. Xong khi: npm test -- auth xanh + test 429." \
  -l "copilot"
# Rồi assign copilot trên web (hoặc: gh issue edit <N> --add-assignee "copilot" nếu org cho phép)
gh pr list --author "app/copilot" --state open
```

**Ví dụ cụ thể:** sáng tạo 3 issues + label copilot → trưa có 3 PR → chiều review + merge 2, trả lại 1 (xem [bài 07](07-custom-agents-coding-agent-workflows.md) câu 5).

> **Khi nào áp dụng:** task rõ ràng, có test — batch 2-3 issues/lần, đừng giao 10 cái cùng lúc.

> **Nếu vẫn lỗi thì...** thử theo thứ tự: (1) làm lại bước copy-paste với scope gọn hơn (1 file/selection), (2) đổi model (`/model`) rồi chạy lại, (3) tra “Vẫn lỗi thì sao?” cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue với log + ảnh chụp lỗi.
---

## 2. Workflow `copilot-review.yml` mẫu làm gì?

> **Hỏi ngắn gọn:** _Workflow `copilot-review.yml` mẫu làm gì?_

**Trả lời 1 câu:** 

**Giải thích chi tiết + ví dụ:** Workflow chạy khi PR mở/update: checkout code → chạy lint/test guardrailed → gọi Copilot CLI tóm tắt/review → post comment vào PR. Secrets qua env, quyền tối thiểu, KHÔNG flag bypass nào (xem file mẫu trong `templates/.github/workflows/copilot-review.yml`).

### Làm thế nào (steps copy-paste)

Copy từng bước theo thứ tự (dán vào terminal/IDE là chạy):

```yaml
# Kích hoạt + quyền tối thiểu (trích mẫu templates)
on:
  pull_request:
    types: [opened, synchronize]
permissions:
  contents: read
  pull-requests: write  # chỉ để comment review
```

```bash
# Copy mẫu vào repo
cp /path/to/tutorial-copilot/templates/.github/workflows/copilot-review.yml ./.github/workflows/
# Test: mở PR thử -> xem comment review tự động xuất hiện
```

**Ví dụ cụ thể:** PR agent mở → workflow chạy `npm run lint` đỏ → comment "lint fail ở file X" → agent đọc comment → push fix → workflow chạy lại xanh.

> **Khi nào áp dụng:** mọi repo dùng coding agent — review tự động là reviewer đầu tiên, người là reviewer cuối.

> **Nếu vẫn lỗi thì...** thử theo thứ tự: (1) làm lại bước copy-paste với scope gọn hơn (1 file/selection), (2) đổi model (`/model`) rồi chạy lại, (3) tra “Vẫn lỗi thì sao?” cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue với log + ảnh chụp lỗi.
---

## 3. Workflow `copilot-ci-triage.yml` mẫu làm gì?

> **Hỏi ngắn gọn:** _Workflow `copilot-ci-triage.yml` mẫu làm gì?_

**Trả lời 1 câu:** 

**Giải thích chi tiết + ví dụ:** Workflow chạy khi issue mới: đọc tiêu đề + body → phân loại (bug/feature/question) → gắn label + comment gợi ý (thiếu log? thiếu acceptance criteria?) → maintainer chỉ việc confirm. Chỉ đọc + label, không sửa code (xem `templates/.github/workflows/copilot-ci-triage.yml`).

### Làm thế nào (steps copy-paste)

Copy từng bước theo thứ tự (dán vào terminal/IDE là chạy):

```yaml
# Kích hoạt (trích mẫu templates)
on:
  issues:
    types: [opened]
permissions:
  issues: write  # chỉ label + comment
  contents: read
```

```bash
cp /path/to/tutorial-copilot/templates/.github/workflows/copilot-ci-triage.yml ./.github/workflows/
# Test: tạo issue "Bug: login 500 khi..." -> xem label + comment tự gắn
```

**Ví dụ cụ thể:** issue thiếu log → bot comment "vui lòng bổ sung: version, steps, log" + label `needs-info` → issue đủ info mới tới tay maintainer.

> **Khi nào áp dụng:** repo public/đông issue — triage bot đỡ 50% việc phân loại tay.

> **Nếu vẫn lỗi thì...** thử theo thứ tự: (1) làm lại bước copy-paste với scope gọn hơn (1 file/selection), (2) đổi model (`/model`) rồi chạy lại, (3) tra “Vẫn lỗi thì sao?” cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue với log + ảnh chụp lỗi.
---

## 4. Secrets trong workflow truyền sao cho đúng (KHÔNG dangerously-skip)?

> **Hỏi ngắn gọn:** _Secrets trong workflow truyền sao cho đúng (KHÔNG dangerously-skip)?_

**Trả lời 1 câu:** 

**Giải thích chi tiết + ví dụ:** 3 quy tắc sắt:

1. Secrets chỉ qua `${{ secrets.TEN }}` → `env:`, KHÔNG `echo`/`print` ra log.
2. `permissions:` tối thiểu từng job (read mặc định, write chỉ chỗ cần).
3. KHÔNG dùng flag skip-verification/bypass để "cho chạy được" — fix root cause (scope token, ruleset) thay vì bỏ gate.

### Làm thế nào (steps copy-paste)

Copy từng bước theo thứ tự (dán vào terminal/IDE là chạy):

```yaml
# Đúng
jobs:
  review:
    permissions: { contents: read, pull-requests: write }
    steps:
      - env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: gh pr view "$PR" --json title  # không in token
```

```bash
# Quét workflow có lộ secret/skip nguy hiểm không
grep -rn "dangerously-skip\|skip-verification\|echo.*secrets\.\|print.*secrets\." .github/workflows/ || echo "Workflows sach"
```

**Ví dụ cụ thể:** workflow cần push comment nhưng fail permission → nâng đúng `pull-requests: write` thay vì cho `contents: write` toàn cục.

> **Khi nào áp dụng:** review mọi PR đụng `.github/workflows/` — grep trên là gate.

> **Nếu vẫn lỗi thì...** thử theo thứ tự: (1) làm lại bước copy-paste với scope gọn hơn (1 file/selection), (2) đổi model (`/model`) rồi chạy lại, (3) tra “Vẫn lỗi thì sao?” cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue với log + ảnh chụp lỗi.
---

## 5. Copilot SDK là gì, khi nào dùng thay vì chat?

> **Hỏi ngắn gọn:** _Copilot SDK là gì, khi nào dùng thay vì chat?_

**Trả lời 1 câu:** 

**Giải thích chi tiết + ví dụ:** SDK = thư viện để **app của bạn** gọi năng lực Copilot (completions/agent) từ code — VD bot Slack nội bộ, dashboard triage, tool migrate tự động. Dùng khi: logic lặp lại, cần nhúng vào hệ thống, không muốn người mở IDE.

Không dùng khi: task 1 lần, ad-hoc — mở chat nhanh hơn viết app.

### Làm thế nào (steps copy-paste)

Copy từng bước theo thứ tự (dán vào terminal/IDE là chạy):

```bash
# Tìm SDK mới nhất (tên/gói đổi nhanh 2025-2026, verify trước khi dùng)
# Docs: https://docs.github.com/en/copilot/building-copilot-extensions
# Nguyên tắc: token qua env, log request count để kiểm soát quota/bill
```

```bash
# Khung app gọi SDK (minh họa): token CHỈ từ env
export COPILOT_SDK_TOKEN="${COPILOT_SDK_TOKEN:?thieu token}"
# node app.js  (trong code: process.env.COPILOT_SDK_TOKEN, không hardcode)
```

**Ví dụ cụ thể:** bot Slack `#help-code`: dev hỏi → backend gọi SDK → trả lời trong Slack (quota tính chung, log theo user để tránh 1 người đốt hết).

> **Khi nào áp dụng:** khi team muốn Copilot trong tool nội bộ — bắt đầu từ 1 endpoint thử nghiệm + quota log.

> **Nếu vẫn lỗi thì...** thử theo thứ tự: (1) làm lại bước copy-paste với scope gọn hơn (1 file/selection), (2) đổi model (`/model`) rồi chạy lại, (3) tra “Vẫn lỗi thì sao?” cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue với log + ảnh chụp lỗi.
---

## 6. Code review tự động: bật ở đâu, tin được bao nhiêu?

> **Hỏi ngắn gọn:** _Code review tự động: bật ở đâu, tin được bao nhiêu?_

**Trả lời 1 câu:** 

**Giải thích chi tiết + ví dụ:** 2 lớp: **(a)** GitHub Copilot code review (tích hợp PR → review từng diff, setting ở repo/org), **(b)** workflow custom `copilot-review.yml` (linh hoạt checklist team). Tin ở mức **reviewer đầu tiên**: bắt lỗi style, null-check, thiếu test; quyết định merge vẫn do người.

### Làm thế nào (steps copy-paste)

Copy từng bước theo thứ tự (dán vào terminal/IDE là chạy):

```bash
# Bật review tự động (web): Repo Settings -> Code security -> Copilot code review -> On
# Hoặc ruleset: yêu cầu review trước merge (xem bài 05 câu 4)

# Xem review của bot trên PR
gh pr view <NUM> --comments | head -40
```

**Ví dụ cụ thể:** PR 200 dòng → bot comment 5 Minor (naming, null-check) → người chỉ cần soi 1 Major logic → review nhanh gấp đôi.

> **Khi nào áp dụng:** bật mặc định mọi repo team; custom checklist trong workflow khi team có chuẩn riêng (xem mẫu review-pr trong templates).

> **Nếu vẫn lỗi thì...** thử theo thứ tự: (1) làm lại bước copy-paste với scope gọn hơn (1 file/selection), (2) đổi model (`/model`) rồi chạy lại, (3) tra “Vẫn lỗi thì sao?” cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue với log + ảnh chụp lỗi.
---

## 7. github.com/copilot (bản Web) dùng khi nào?

> **Hỏi ngắn gọn:** _github.com/copilot (bản Web) dùng khi nào?_

**Trả lời 1 câu:** 

**Giải thích chi tiết + ví dụ:** Web = chat Copilot trên browser, gắn với repo GitHub (đọc code trực tiếp, tạo PR từ chat). Dùng khi: máy khác không có IDE, review nhanh PR trên web, hỏi về repo public mà không muốn clone.

Giới hạn: không sửa multi-file mượt như IDE, không có MCP local, quota chung với account.

### Làm thế nào (steps copy-paste)

Copy từng bước theo thứ tự (dán vào terminal/IDE là chạy):

```bash
# Không cần cài gì: mở https://github.com/copilot
# Chọn repo context (gõ tên repo) rồi hỏi:
# "Tóm tắt PR #123 trong acme/api: đổi gì, rủi ro gì?"
```

**Ví dụ cụ thể:** đang onsite bằng laptop mượn → mở `github.com/copilot` → hỏi + review PR → về máy chính mới code tiếp.

> **Khi nào áp dụng:** ngoài IDE, hoặc khi cần hỏi nhanh về repo chưa clone.

> **Nếu vẫn lỗi thì...** thử theo thứ tự: (1) làm lại bước copy-paste với scope gọn hơn (1 file/selection), (2) đổi model (`/model`) rồi chạy lại, (3) tra “Vẫn lỗi thì sao?” cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue với log + ảnh chụp lỗi.
---

## 8. Copilot trên Mobile dùng được gì?

> **Hỏi ngắn gọn:** _Copilot trên Mobile dùng được gì?_

**Trả lời 1 câu:** 

**Giải thích chi tiết + ví dụ:** GitHub Mobile app tích hợp Copilot Chat: đọc issue/PR, hỏi về code, approve workflow runs. Dùng để **review + quyết định** (đọc PR agent, merge khi CI xanh), không để code (màn hình nhỏ, không IDE).

### Làm thế nào (steps copy-paste)

Copy từng bước theo thứ tự (dán vào terminal/IDE là chạy):

```bash
# Không có lệnh; thao tác trên app:
# GitHub Mobile -> Copilot tab -> chọn repo -> hỏi hoặc review PR
# Merge từ mobile khi: CI xanh + đã đọc diff summary của bot
```

**Ví dụ cụ thể:** agent mở PR lúc bạn đang di chuyển → mobile đọc summary + checks xanh → approve → về nhà merge hoặc auto-merge đã lo.

> **Khi nào áp dụng:** on-call / di chuyển — mobile để giám sát agent, IDE để làm việc nặng.

> **Nếu vẫn lỗi thì...** thử theo thứ tự: (1) làm lại bước copy-paste với scope gọn hơn (1 file/selection), (2) đổi model (`/model`) rồi chạy lại, (3) tra “Vẫn lỗi thì sao?” cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue với log + ảnh chụp lỗi.
---

## 9. Auto-merge PR agent an toàn thế nào?

> **Hỏi ngắn gọn:** _Auto-merge PR agent an toàn thế nào?_

**Trả lời 1 câu:** 

**Giải thích chi tiết + ví dụ:** Chỉ auto-merge khi đủ 4 điều kiện: **scope trong issue + CI xanh hết + review bot không có Critical + không chạm migrations/infra.** Cấu hình: branch protection (required checks) + `gh pr merge --auto --squash`.

### Làm thế nào (steps copy-paste)

Copy từng bước theo thứ tự (dán vào terminal/IDE là chạy):

```bash
# Bật auto-merge cho PR đủ điều kiện
gh pr merge <NUM> --auto --squash --delete-branch

# Kiểm tra điều kiện trước khi bật auto
gh pr checks <NUM>
gh pr diff <NUM> --name-only | grep -Ei "migrations|infra|terraform" && echo "KHONG auto-merge" || echo "OK auto"
```

**Ví dụ cụ thể:** PR agent docs/tests + CI xanh → `--auto` → merge khi đủ checks. PR chạm migrations → review tay, cấm auto.

> **Khi nào áp dụng:** repo có CI đầy đủ (lint+test+scan). Chưa có CI → không auto-merge bất kỳ PR nào.

> **Nếu vẫn lỗi thì...** thử theo thứ tự: (1) làm lại bước copy-paste với scope gọn hơn (1 file/selection), (2) đổi model (`/model`) rồi chạy lại, (3) tra “Vẫn lỗi thì sao?” cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue với log + ảnh chụp lỗi.
---

## 10. Đo hiệu quả automation: metric nào đáng theo dõi?

> **Hỏi ngắn gọn:** _Đo hiệu quả automation: metric nào đáng theo dõi?_

**Trả lời 1 câu:** 

**Giải thích chi tiết + ví dụ:** 4 metric/tháng: **tỉ lệ PR agent merge không sửa**, **thời gian issue→merge**, **số comment bot có ích vs nhiễu**, **quota premium tiêu thụ**. Metric đỏ → tune issue template + checklist review (xem [bài 07](07-custom-agents-coding-agent-workflows.md) câu 9).

### Làm thế nào (steps copy-paste)

Copy từng bước theo thứ tự (dán vào terminal/IDE là chạy):

```bash
# Thống kê PR agent tháng này
gh pr list --author "app/copilot" --state merged --limit 50 --json number,title,mergedAt | wc -l
gh pr list --author "app/copilot" --state all --limit 50 --json number > /tmp/agent-prs.json
# + Check quota: https://github.com/settings/copilot -> so với tháng trước
```

**Ví dụ cụ thể:** tháng 1: 20 PR agent, merge 8 (40%) → tune issue template → tháng 2: 20 PR, merge 13 (65%) → automation đáng tiền.

> **Khi nào áp dụng:** review hàng tháng cùng team — số liệu quyết định mở rộng hay thu hẹp agent.

> **Nếu vẫn lỗi thì...** thử theo thứ tự: (1) làm lại bước copy-paste với scope gọn hơn (1 file/selection), (2) đổi model (`/model`) rồi chạy lại, (3) tra “Vẫn lỗi thì sao?” cuối file này, (4) hỏi admin (policy/seat) hoặc mở issue với log + ảnh chụp lỗi.
---

## Vẫn lỗi thì sao? (thứ tự debug chuẩn)

1. Workflow fail → đọc log job đỏ đầu tiên (Actions tab).
2. Check `permissions:` + secrets (`grep` câu 4).
3. Test workflow trên PR thử trước khi đổ lỗi agent.
4. PR agent fail → `gh pr checks` + comment `@copilot` hướng fix.
5. SDK lỗi → check token env + docs mới nhất (gói đổi nhanh).

```bash
gh run list --limit 5 && gh run view --log-failed 2>/dev/null | head -30
```

---

## Tham khảo chéo

- Viết issue cho agent: [bài 07](07-custom-agents-coding-agent-workflows.md). Guardrails CI: [bài 05](05-policies-guardrails-faq.md).
- Quota automation: [bài 02](02-model-context-premium.md). Mẫu workflows: [../templates/.github/workflows/](../templates/.github/workflows/).

> Mẹo 1 dòng: _agent làm, CI gate, bot review trước người review sau, và auto-merge chỉ khi đủ 4 điều kiện._
