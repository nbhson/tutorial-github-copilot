# FAQ 10 — CI, SDK, Review & Web

> Nhóm Tự động hóa & Nền tảng · 10 câu hỏi deep-dive · Đọc xong nối Actions + coding agent, dùng SDK, bật auto review, xài bản Web/Mobile

Khi đã quen Copilot trong IDE, câu hỏi tiếp theo là làm sao để nó chạy khi bạn không ngồi trước máy: nối Actions với coding agent, viết workflow review/triage, gọi Copilot từ code qua SDK, bật auto review, và xài bản Web/Mobile khi đi xa. Bài này trả lời 10 câu đó, kèm lệnh copy-paste + ví dụ + lúc nào nên áp dụng.

## Mục tiêu bài học

- Hiểu **luồng issue → agent → PR → CI → review → merge** và biết workflow của bạn chỉ cần gate CI, không cần gọi agent trực tiếp.
- Viết được **2 workflow mẫu** (`copilot-review.yml`, `copilot-ci-triage.yml`) với quyền tối thiểu, secrets qua env.
- Biết **khi nào dùng Copilot SDK** thay vì Chat, và khi nào bản Web/Mobile là đủ.
- Bật **code review tự động** và hiểu nó ở mức "reviewer đầu tiên", không thay người quyết merge.
- Biết **4 điều kiện auto-merge** và **4 metric/tháng** để biết automation có đáng tiền không.

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

**Trả lời 1 câu:** Luồng chuẩn là issue → assign `copilot` → agent code + mở PR → Actions CI gate → review → merge, trong đó workflow không gọi agent trực tiếp mà chỉ đảm bảo CI xanh/đỏ đúng để gate PR agent.

**Giải thích chi tiết + ví dụ:** Nôm na: Actions là người gác cổng, coding agent là thợ xây — thợ xong việc thì qua cổng để kiểm tra, cổng không gọi thợ. Luồng chuẩn: **Issue (mô tả + acceptance criteria) → assign `copilot` → agent code + mở PR → Actions CI (lint/test) chạy → review → merge.** Workflow của bạn không cần gọi agent trực tiếp; agent tự lắng nghe assignment. Workflow chỉ cần đảm bảo CI xanh/đỏ đúng để gate PR agent. 2026: giao việc bằng 2 CLI — `gh copilot assign` (CLI coding agent chuẩn) hoặc binary `copilot` (CLI standalone, 3 chế độ interactive/plan/autopilot, xem [bài 12](../01-huong-dan-su-dung/12-copilot-sdk-ci-cd-automation.md)).

### Làm thế nào (copy-paste)

```bash
# Giao viec cho coding agent tu CLI (tao issue + assign)
gh issue create --title "feat(auth): them rate-limit login" \
  --body "Phạm vi: src/auth/**. Xong khi: npm test -- auth xanh + test 429." \
  -l "copilot"
# Verify: issue da tao + duoc label copilot
# Roi assign copilot tren web (hoac: gh issue edit <N> --add-assignee "copilot" neu org cho phep)
gh pr list --author "app/copilot" --state open
```

**Ví dụ cụ thể:** sáng tạo 3 issues + label copilot → trưa có 3 PR → chiều review + merge 2, trả lại 1 (xem [bài 07](07-custom-agents-coding-agent-workflows.md) câu 5).

> **Khi nào áp dụng:** task rõ ràng, có test — batch 2-3 issues/lần, đừng giao 10 cái cùng lúc.

**Nếu vẫn lỗi thì...** (1) kiểm tra issue đã gắn label `copilot` + được assign chưa, (2) thử lại với 1 issue scope gọn hơn (1 file/selection), (3) tra "Vẫn lỗi thì sao?" cuối file này, (4) hỏi admin xem coding agent có được bật cho repo không.

---

## 2. Workflow `copilot-review.yml` mẫu làm gì?

> **Hỏi ngắn gọn:** _Workflow `copilot-review.yml` mẫu làm gì?_

**Trả lời 1 câu:** Workflow chạy khi PR mở/update: checkout code → chạy lint/test guardrailed → gọi Copilot CLI tóm tắt/review → post comment vào PR — secrets qua env, quyền tối thiểu, không flag bypass.

**Giải thích chi tiết + ví dụ:** Nôm na: tự động chạy lint + gọi Copilot "đọc cho tôi" — comment review ngay trên PR, không cần người đọc trước. Workflow chạy khi PR mở/update: checkout code → chạy lint/test guardrailed → gọi Copilot CLI tóm tắt/review → post comment vào PR. Secrets qua env, quyền tối thiểu, KHÔNG flag bypass nào (xem file mẫu trong `templates/.github/workflows/copilot-review.yml`). 2026: Copilot code review (tích hợp PR, câu 6) chạy song song với workflow custom — 1 lớp đọc code, 1 lớp chạy lệnh, cùng gate PR.

### Làm thế nào (copy-paste)

```yaml
# Kích hoat + quyen toi thieu (trich mau templates)
on:
  pull_request:
    types: [opened, synchronize]
permissions:
  contents: read
  pull-requests: write  # chi de comment review
```

```bash
# Copy mau vao repo
cp /path/to/tutorial-copilot/templates/.github/workflows/copilot-review.yml ./.github/workflows/
# Verify: mo PR thu -> xem comment review tu dong xuat hien
```

**Ví dụ cụ thể:** PR agent mở → workflow chạy `npm run lint` đỏ → comment "lint fail ở file X" → agent đọc comment → push fix → workflow chạy lại xanh.

> **Khi nào áp dụng:** mọi repo dùng coding agent — review tự động là reviewer đầu tiên, người là reviewer cuối.

**Nếu vẫn lỗi thì...** (1) đọc log job đỏ đầu tiên trong Actions tab, (2) kiểm tra `permissions:` + secrets truyền đúng chưa, (3) tra "Vẫn lỗi thì sao?" cuối file này, (4) thử workflow trên 1 PR nhỏ (1 file/selection) trước khi đổ lỗi agent.

---

## 3. Workflow `copilot-ci-triage.yml` mẫu làm gì?

> **Hỏi ngắn gọn:** _Workflow `copilot-ci-triage.yml` mẫu làm gì?_

**Trả lời 1 câu:** Workflow chạy khi issue mới: đọc tiêu đề + body → phân loại (bug/feature/question) → gắn label + comment gợi ý (thiếu log? thiếu acceptance criteria?) → maintainer chỉ confirm; chỉ đọc + label, không sửa code.

**Giải thích chi tiết + ví dụ:** Nôm na: thư ký phòng khám — nhận bệnh nhân, phân loại, gọi tên, không kê đơn. Workflow chạy khi issue mới: đọc tiêu đề + body → phân loại (bug/feature/question) → gắn label + comment gợi ý (thiếu log? thiếu acceptance criteria?) → maintainer chỉ việc confirm. Chỉ đọc + label, không sửa code (xem `templates/.github/workflows/copilot-ci-triage.yml`). 2026: issue template chuẩn 5 phần (bài 07 câu 6) giúp triage bot ít phải comment "thiếu info".

### Làm thế nào (copy-paste)

```yaml
# Kích hoat (trich mau templates)
on:
  issues:
    types: [opened]
permissions:
  issues: write  # chi label + comment
  contents: read
```

```bash
cp /path/to/tutorial-copilot/templates/.github/workflows/copilot-ci-triage.yml ./.github/workflows/
# Verify: tao issue "Bug: login 500 khi..." -> xem label + comment tu gan
```

**Ví dụ cụ thể:** issue thiếu log → bot comment "vui lòng bổ sung: version, steps, log" + label `needs-info` → issue đủ info mới tới tay maintainer.

> **Khi nào áp dụng:** repo public/đông issue — triage bot đỡ 50% việc phân loại tay.

**Nếu vẫn lỗi thì...** (1) mở 1 issue thử để xem bot gắn label chưa, (2) kiểm tra `permissions: issues: write` đã đủ chưa, (3) tra "Vẫn lỗi thì sao?" cuối file này, (4) chuẩn hóa issue template để bot ít phải hỏi lại.

---

## 4. Secrets trong workflow truyền sao cho đúng (KHÔNG dangerously-skip)?

> **Hỏi ngắn gọn:** _Secrets trong workflow truyền sao cho đúng (KHÔNG dangerously-skip)?_

**Trả lời 1 câu:** 3 quy tắc sắt: secrets chỉ qua `${{ secrets.TEN }}` → `env` (không in log), permissions tối thiểu từng job, không dùng flag bypass — fix root cause thay vì bỏ gate.

**Giải thích chi tiết + ví dụ:** Nôm na: chìa khóa (secret) đưa qua cửa sổ (env), không đưa qua miệng (log), và không phá khóa để vào (bypass). 3 quy tắc sắt:

1. Secrets chỉ qua `${{ secrets.TEN }}` → `env:`, KHÔNG `echo`/`print` ra log.
2. `permissions:` tối thiểu từng job (read mặc định, write chỉ chỗ cần).
3. KHÔNG dùng flag skip-verification/bypass để "cho chạy được" — fix root cause (scope token, ruleset) thay vì bỏ gate.

2026: ruleset + branch protection (bài 05) là lớp chặn ngoài, không thể bypass bằng flag trong workflow.

### Làm thế nào (copy-paste)

```yaml
# Dung
jobs:
  review:
    permissions: { contents: read, pull-requests: write }
    steps:
      - env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: gh pr view "$PR" --json title  # khong in token
```

```bash
# Quét workflow có lộ secret/skip nguy hiểm không
grep -rn "dangerously-skip\|skip-verification\|echo.*secrets\.\|print.*secrets\." .github/workflows/ || echo "Workflows sach"
# Verify: tra ve "Workflows sach"
```

**Ví dụ cụ thể:** workflow cần push comment nhưng fail permission → nâng đúng `pull-requests: write` thay vì cho `contents: write` toàn cục.

> **Khi nào áp dụng:** review mọi PR đụng `.github/workflows/` — grep trên là gate.

**Nếu vẫn lỗi thì...** (1) chạy lại grep để chắc không còn secret/skip nguy hiểm, (2) thu hẹp `permissions` về đúng mức từng job, (3) tra "Vẫn lỗi thì sao?" cuối file này, (4) hỏi admin (policy/seat) nếu token/ruleset bị chặn.

---

## 5. Copilot SDK là gì, khi nào dùng thay vì chat?

> **Hỏi ngắn gọn:** _Copilot SDK là gì, khi nào dùng thay vì chat?_

**Trả lời 1 câu:** SDK là thư viện để app của bạn gọi Copilot (completions/agent) từ code — dùng khi logic lặp lại, nhúng hệ thống, không cần mở IDE; không dùng cho task 1 lần ad-hoc.

**Giải thích chi tiết + ví dụ:** Nôm na: SDK là bộ động cơ + khung xe, bạn tự lắp robot Copilot riêng; chat là taxi — gọi khi cần, không cần bảo trì. SDK = thư viện để **app của bạn** gọi năng lực Copilot (completions/agent) từ code — VD bot Slack nội bộ, dashboard triage, tool migrate tự động. Dùng khi: logic lặp lại, cần nhúng vào hệ thống, không muốn người mở IDE.

Không dùng khi: task 1 lần, ad-hoc — mở chat nhanh hơn viết app. 2026: SDK bọc cả Copilot CLI và cung cấp sessions + permissions + custom tools + events; là nền của dynamic workflows (public preview 01/10/2026).

| Tiêu chí | Copilot SDK | Chat (trong IDE) |
|---|---|---|
| Ai gọi | App của bạn (code) | Bạn gõ tay |
| Nhúng vào hệ thống | Có (bot Slack, dashboard, tool migrate) | Không |
| Công setup | Cao (viết app + token + log quota) | Thấp (mở chat là chạy) |
| Khi nào dùng | Logic lặp lại, không muốn người mở IDE | Task 1 lần, ad-hoc |

### Làm thế nào (copy-paste)

```bash
# Tim SDK moi nhat (ten/goi doi nhanh 2025-2026, verify truoc khi dung)
# Docs: https://docs.github.com/en/copilot/building-copilot-extensions
# Nguyen tac: token qua env, log request count de kiem soat quota/bill

# Khung app goi SDK (minh hoa): token CHI tu env
export COPILOT_SDK_TOKEN="${COPILOT_SDK_TOKEN:?thieu token}"
# Verify: in ra "thieu token" neu chua export
# node app.js  (trong code: process.env.COPILOT_SDK_TOKEN, khong hardcode)
```

**Ví dụ cụ thể:** bot Slack `#help-code`: dev hỏi → backend gọi SDK → trả lời trong Slack (quota tính chung, log theo user để tránh 1 người đốt hết AI Credits).

> **Khi nào áp dụng:** khi team muốn Copilot trong tool nội bộ — bắt đầu từ 1 endpoint thử nghiệm + quota log.

**Nếu vẫn lỗi thì...** (1) kiểm tra token env đã export chưa (`echo` ra "thieu token" là chưa), (2) đối chiếu docs mới nhất vì tên/goi SDK đổi nhanh, (3) tra "Vẫn lỗi thì sao?" cuối file này, (4) log request count để kiểm soát quota trước khi mở rộng.

---

## 6. Code review tự động: bật ở đâu, tin được bao nhiêu?

> **Hỏi ngắn gọn:** _Code review tự động: bật ở đâu, tin được bao nhiêu?_

**Trả lời 1 câu:** 2 lớp — (a) Copilot code review tích hợp PR (bật Repo Settings → Code security), (b) workflow custom `copilot-review.yml` — tin ở mức "reviewer đầu tiên" (bắt style/null/missing test), quyết định merge vẫn do người.

**Giải thích chi tiết + ví dụ:** Nôm na: bot là đồng nghiệp đọc draft trước, bạn là reviewer cuối cùng — bot bắt lỗi nhỏ, bạn bắt lỗi lớn. 2 lớp: **(a)** GitHub Copilot code review (tích hợp PR → review từng diff, setting ở repo/org), **(b)** workflow custom `copilot-review.yml` (linh hoạt checklist team). Tin ở mức **reviewer đầu tiên**: bắt lỗi style, null-check, thiếu test; quyết định merge vẫn do người. 2026: chi phí review tính bằng GitHub Actions minutes (ngoài AI Credits, xem [bài 01](01-tai-khoan-pricing-cai-dat.md)).

| Tiêu chí | Copilot code review (tích hợp PR) | Workflow custom `copilot-review.yml` |
|---|---|---|
| Bật ở đâu | Repo Settings → Code security | Thêm file vào `.github/workflows/` |
| Làm gì | Review từng diff, comment tự động | Chạy lint/test + gọi Copilot CLI review |
| Tùy biến | Thấp (theo GitHub) | Cao (checklist riêng của team) |
| Chi phí | Theo seat/plan | GitHub Actions minutes |
| Khi nào dùng | Bật mặc định mọi repo | Team có chuẩn review riêng |

### Làm thế nào (copy-paste)

```bash
# Bat review tu dong (web): Repo Settings -> Code security -> Copilot code review -> On
# Hoac ruleset: yeu cau review truoc merge (xem bai 05 cau 4)

# Verify: mo PR -> bot comment review tu dong
# Xem review cua bot tren PR
gh pr view <NUM> --comments | head -40
```

**Ví dụ cụ thể:** PR 200 dòng → bot comment 5 Minor (naming, null-check) → người chỉ cần soi 1 Major logic → review nhanh gấp đôi.

> **Khi nào áp dụng:** bật mặc định mọi repo team; custom checklist trong workflow khi team có chuẩn riêng (xem mẫu review-pr trong templates).

**Nếu vẫn lỗi thì...** (1) kiểm tra setting Code security đã On cho repo, (2) mở 1 PR nhỏ thử để xem bot có comment không, (3) tra "Vẫn lỗi thì sao?" cuối file này, (4) nếu team cần checklist riêng thì chuyển sang workflow custom.

---

## 7. github.com/copilot (bản Web) dùng khi nào?

> **Hỏi ngắn gọn:** _github.com/copilot (bản Web) dùng khi nào?_

**Trả lời 1 câu:** Web dùng khi máy khác không có IDE, review nhanh PR trên web, hỏi về repo public chưa clone — không sửa multi-file mượt như IDE, không có MCP local, quota chung account.

**Giải thích chi tiết + ví dụ:** Nôm na: văn phòng mini trong browser — đọc được repo, tạo được PR, nhưng không cầm búa được (multi-file, MCP local). Web = chat Copilot trên browser, gắn với repo GitHub (đọc code trực tiếp, tạo PR từ chat). Dùng khi: máy khác không có IDE, review nhanh PR trên web, hỏi về repo public mà không muốn clone.

Giới hạn: không sửa multi-file mượt như IDE, không có MCP local, quota chung với account. 2026: Web có thể assign coding agent + xem coding agent status (xem [bài 07](07-custom-agents-coding-agent-workflows.md) câu 4).

| Tiêu chí | Web (`github.com/copilot`) | IDE (VS Code...) |
|---|---|---|
| Sửa multi-file | Không mượt | Có |
| MCP local | Không | Có |
| Repo public chưa clone | Hỏi được ngay | Phải clone |
| Khi nào dùng | Ngoài IDE, review/hỏi nhanh trên web | Làm việc nặng, refactor nhiều file |

### Làm thế nào (copy-paste)

```bash
# Khong can cai gi: mo https://github.com/copilot
# Chon repo context (go ten repo) roi ho:
# "Tom tat PR #123 trong acme/api: doei gi, rui ro gi?"
# Verify: PR #123 duoc tom tat, khong can clone
```

**Ví dụ cụ thể:** đang onsite bằng laptop mượn → mở `github.com/copilot` → hỏi + review PR → về máy chính mới code tiếp.

> **Khi nào áp dụng:** ngoài IDE, hoặc khi cần hỏi nhanh về repo chưa clone.

**Nếu vẫn lỗi thì...** (1) xác nhận đã chọn đúng repo context, (2) thử hỏi 1 câu scope gọn hơn (1 file/selection) rồi mở rộng, (3) tra "Vẫn lỗi thì sao?" cuối file này, (4) chuyển sang IDE khi cần sửa multi-file.

---

## 8. Copilot trên Mobile dùng được gì?

> **Hỏi ngắn gọn:** _Copilot trên Mobile dùng được gì?_

**Trả lời 1 câu:** Mobile dùng để **review + quyết định** (đọc issue/PR, hỏi về code, approve workflow runs) — không dùng để code (màn hình nhỏ, không IDE); hợp on-call/di chuyển.

**Giải thích chi tiết + ví dụ:** Nôm na: điện thoại là trạm giám sát công trường, không phải trạm thi công. GitHub Mobile app tích hợp Copilot Chat: đọc issue/PR, hỏi về code, approve workflow runs. Dùng để **review + quyết định** (đọc PR agent, merge khi CI xanh), không để code (màn hình nhỏ, không IDE). 2026: coding agent trên cloud (bài 07) + mobile approve = combo "giao việc khi làm việc, duyệt khi di chuyển".

### Làm thế nào (copy-paste)

```bash
# Khong co lenh; thao tac tren app:
# GitHub Mobile -> Copilot tab -> chon repo -> hoac ho hoac review PR
# Verify: PR agent duoc tom tat + checks xanh -> approve
# Merge tu mobile khi: CI xanh + da doc diff summary cua bot
```

**Ví dụ cụ thể:** agent mở PR lúc bạn đang di chuyển → mobile đọc summary + checks xanh → approve → về nhà merge hoặc auto-merge đã lo.

> **Khi nào áp dụng:** on-call / di chuyển — mobile để giám sát agent, IDE để làm việc nặng.

**Nếu vẫn lỗi thì...** (1) kiểm tra CI đã xanh trước khi approve trên mobile, (2) mở diff summary của bot để chắc hiểu thay đổi, (3) tra "Vẫn lỗi thì sao?" cuối file này, (4) chuyển về IDE khi cần soi kỹ multi-file.

---

## 9. Auto-merge PR agent an toàn thế nào?

> **Hỏi ngắn gọn:** _Auto-merge PR agent an toàn thế nào?_

**Trả lời 1 câu:** Chỉ auto-merge khi đủ 4 điều kiện — scope trong issue + CI xanh hết + review bot không có Critical + không chạm migrations/infra — cấu hình bằng branch protection + `gh pr merge --auto`.

**Giải thích chi tiết + ví dụ:** Nôm na: 4 chốt cửa đều phải khóa thì mới cho xe tự chạy — thiếu 1 là dừng. Chỉ auto-merge khi đủ 4 điều kiện: **scope trong issue + CI xanh hết + review bot không có Critical + không chạm migrations/infra.** Cấu hình: branch protection (required checks) + `gh pr merge --auto --squash`. 2026: AI Credits của agent đã trả — auto-merge sai = trả tiền cho merge sai, vì vậy 4 điều kiện là gate cứng.

### Làm thế nào (copy-paste)

```bash
# Bat auto-merge cho PR du dieu kien
gh pr merge <NUM> --auto --squash --delete-branch

# Verify: kiem tra dieu kien truoc khi bat auto
gh pr checks <NUM>
gh pr diff <NUM> --name-only | grep -Ei "migrations|infra|terraform" && echo "KHONG auto-merge" || echo "OK auto"
```

**Ví dụ cụ thể:** PR agent docs/tests + CI xanh → `--auto` → merge khi đủ checks. PR chạm migrations → review tay, cấm auto.

> **Khi nào áp dụng:** repo có CI đầy đủ (lint+test+scan). Chưa có CI → không auto-merge bất kỳ PR nào.

**Nếu vẫn lỗi thì...** (1) chạy `gh pr checks` để chắc mọi check xanh, (2) grep file chạm `migrations|infra` và tắt auto nếu có, (3) tra "Vẫn lỗi thì sao?" cuối file này, (4) kiểm tra branch protection có bật required checks không.

---

## 10. Đo hiệu quả automation: metric nào đáng theo dõi?

> **Hỏi ngắn gọn:** _Đo hiệu quả automation: metric nào đáng theo dõi?_

**Trả lời 1 câu:** 4 metric/tháng — tỉ lệ PR agent merge không sửa, thời gian issue→merge, số comment bot có ích vs nhiễu, quota premium (AI Credits) tiêu thụ; metric đỏ thì tune issue template + checklist review.

**Giải thích chi tiết + ví dụ:** Nôm na: 4 kim chỉ nam đo hiệu quả "hệ thống agent" — bao nhiêu việc xong, bao lâu, bot nói có ích, tốn bao nhiêu. 4 metric/tháng: **tỉ lệ PR agent merge không sửa**, **thời gian issue→merge**, **số comment bot có ích vs nhiễu**, **quota premium tiêu thụ**. Metric đỏ → tune issue template + checklist review (xem [bài 07](07-custom-agents-coding-agent-workflows.md) câu 9). 2026: quota đo bằng **AI Credits** (1 credit = $0.01, xem [bài 01](01-tai-khoan-pricing-cai-dat.md)) — dashboard `github.com/settings/copilot`.

### Làm thế nào (copy-paste)

```bash
# Thong ke PR agent thang nay
gh pr list --author "app/copilot" --state merged --limit 50 --json number,title,mergedAt | wc -l
# Verify: so PR agent da merge
gh pr list --author "app/copilot" --state all --limit 50 --json number > /tmp/agent-prs.json
# + Check quota: https://github.com/settings/copilot -> so voi thang truoc
```

**Ví dụ cụ thể:** tháng 1: 20 PR agent, merge 8 (40%) → tune issue template → tháng 2: 20 PR, merge 13 (65%) → automation đáng tiền.

> **Khi nào áp dụng:** review hàng tháng cùng team — số liệu quyết định mở rộng hay thu hẹp agent.

**Nếu vẫn lỗi thì...** (1) thu hẹp về 1 metric dễ đo nhất (số PR agent merge), (2) so quota tháng này với tháng trước, (3) tra "Vẫn lỗi thì sao?" cuối file này, (4) tune issue template + checklist review rồi đo lại.

---

## Vẫn lỗi thì sao? (thứ tự debug chuẩn)

1. Workflow fail → đọc log job đỏ đầu tiên (Actions tab).
2. Check `permissions:` + secrets (`grep` câu 4).
3. Test workflow trên PR thử trước khi đổ lỗi agent.
4. PR agent fail → `gh pr checks` + comment `@copilot` hướng fix.
5. SDK lỗi → check token env + docs mới nhất (gói đổi nhanh).

```bash
# Verify: log chu chay cuoi
gh run list --limit 5 && gh run view --log-failed 2>/dev/null | head -30
```

---

## So sánh với Claude Code

| Việc | GitHub Copilot | Claude Code | Ghi chú |
|---|---|---|---|
| Automation trên PR/issue | Coding agent + workflow `copilot-review.yml` / `copilot-ci-triage.yml` | `anthropics/claude-code-action@v1`, gọi `@claude` trong comment | Cùng chạy trên GitHub Actions, khác cách gọi |
| Code review tích hợp | Copilot code review (Repo Settings → Code security) | Anthropic Code Review (tự động mỗi PR, không cần viết workflow) | Cả hai đều ở mức "reviewer đầu tiên" |
| Gọi từ code | Copilot SDK / API | Claude Agent SDK (nền của claude-code-action) | Cùng ý tưởng: bọc agent thành thư viện |
| Chạy trên cloud | Coding agent trên github.com | Claude Code on the web (phiên trên cloud) | Đều cho phép làm việc không cần máy local |
| Secrets trong workflow | `${{ secrets.GITHUB_TOKEN }}` → env | `${{ secrets.ANTHROPIC_API_KEY }}` → env | Cùng quy tắc Actions: qua env, không in log |
| Luật repo | `.github/copilot-instructions.md` / `AGENTS.md` | `CLAUDE.md` | Cùng tư tưởng: file trong repo là "luật" |
| Auto-merge | `gh pr merge --auto` + branch protection | Cùng cơ chế GitHub | Không khác — đây là tính năng nền tảng |

> **Đọc bảng này thế nào:** phần "nền tảng" (Actions, secrets, auto-merge, branch protection) giống hệt nhau vì cùng là GitHub. Khác biệt nằm ở lớp trên: Copilot gắn sẵn vào UI GitHub (code review, coding agent, bản web) và có SDK riêng; Claude Code đi qua `claude-code-action` + Claude Agent SDK. Cả hai đều nhấn: bot là reviewer đầu tiên, người vẫn quyết merge.

## Best practices (kèm "vì sao")

- **Mỗi workflow một trách nhiệm (review ≠ triage).** *Vì sao?* Gộp lại thì log rối, khó biết job nào fail và khó cấp quyền tối thiểu cho từng việc.
- **Secrets qua env, permissions tối thiểu từng job.** *Vì sao?* Ít quyền = bán kính thiệt hại nhỏ nếu token lộ hoặc workflow bị lợi dụng.
- **Không dùng flag bypass để "cho chạy được".** *Vì sao?* Bỏ gate chỉ giấu vấn đề; phải fix root cause (scope token, ruleset).
- **Auto-merge chỉ khi đủ 4 điều kiện.** *Vì sao?* Agent đã tốn AI Credits — merge sai nghĩa là trả tiền cho một lỗi đã vào main.
- **Đo 4 metric/tháng, không đoán cảm tính.** *Vì sao?* Chỉ số tỉ lệ merge/thời gian/độ nhiễu/quota mới cho biết nên mở rộng hay thu hẹp agent.
- **Batch 2-3 issues/lần, đừng giao 10 cùng lúc.** *Vì sao?* Giao dồn thì review không kịp, PR agent tồn đọng và CI nghẽn.

---

## Tham khảo chéo

- Viết issue cho agent: [bài 07](07-custom-agents-coding-agent-workflows.md). Guardrails CI: [bài 05](05-policies-guardrails-faq.md).
- Quota automation: [bài 02](02-model-context-premium.md). Mẫu workflows: [../templates/.github/workflows/](../templates/.github/workflows/).

> **Chốt FAQ 10:** automation Copilot chỉ đáng tiền khi có đủ 4 thứ — agent làm, CI gate, bot review trước, người review sau — và auto-merge chỉ bật khi đủ 4 điều kiện. Đo bằng số, đừng đo bằng cảm giác.
