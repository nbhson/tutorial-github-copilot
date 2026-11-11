# FAQ 10 — CI, SDK, Review & Web

> **Vấn đề:** làm sao Copilot chạy khi bạn không ngồi trước máy — nối Actions với cloud agent, viết workflow review/triage, gọi Copilot từ code qua SDK, bật auto review, xài bản Web/Mobile. 10 câu dưới đây trả lời đủ.

## Bảng tổng hợp: automation nào dùng gì

| Muốn | Công cụ | Trigger |
|---|---|---|
| Review PR tự động | Copilot code review / workflow `copilot-review.yml` | PR opened/synchronize |
| Triage issue tự động | Workflow `copilot-ci-triage.yml` + label | Issue opened |
| Agent làm task từ issue | Cloud agent (assign `copilot`) | Tay hoặc workflow |
| Gọi Copilot từ code | Copilot SDK / API | App của bạn |
| Dùng ngoài IDE | github.com/copilot, Mobile | Browser/app |

> **Cách đọc bảng này:** dọc cột **Muốn** tìm việc bạn đang định tự động hóa, cột **Công cụ** là tên gọi để kiếm trên GitHub Actions marketplace, cột **Trigger** là sự kiện khởi động công cụ đó — đọc đủ ba cột là có kịch bản workflow hoàn chỉnh — 📄 2 workflow mẫu sẵn trong repo: [`../templates/.github/workflows/`](../templates/.github/workflows/). · 📄 [GitHub Docs: About automations](https://docs.github.com/en/copilot/concepts/agent-capabilities/agent-powered-workflows-and-operations/about-automations)

---

## 1. Actions + cloud agent nối với nhau thế nào?

**Trả lời 1 câu:** Luồng chuẩn: **Issue (mô tả + acceptance criteria) → assign `copilot` → agent code + mở PR → Actions CI (lint/test) gate → review → merge** — workflow không gọi agent trực tiếp; agent tự lắng nghe assignment, workflow chỉ cần đảm bảo CI xanh/đỏ đúng.

Hãy hình dung đây như dây chuyền lắp ráp: nhân viên (agent) nhận đơn hàng từ issue, tự lắp, rồi gửi qua check chất lượng tự động (CI) — dây chuyền không đẩy việc cho nhân viên mà nhân viên tự nhận việc từ kho.

> 📄 **Code ví dụ:** [`./examples/10-ci-sdk-review-web/actions-coding-agent-noi-voi-nhau-the.sh`](./examples/10-ci-sdk-review-web/actions-coding-agent-noi-voi-nhau-the.sh)

> Batch 2-3 issues/lần, đừng giao 10 cùng lúc — review không kịp, PR tồn đọng, CI nghẽn. · 📄 [GitHub Docs: Copilot CLI in GitHub Actions](https://docs.github.com/en/copilot/concepts/agent-capabilities/agent-powered-workflows-and-operations/copilot-cli-in-github-actions)

## 2. Workflow `copilot-review.yml` mẫu làm gì?

**Trả lời 1 câu:** Chạy khi PR mở/update: checkout → lint/test → gọi Copilot CLI tóm tắt/review → post comment vào PR — secrets qua env, quyền tối thiểu, không flag bypass.

> 📄 **Code ví dụ:** [`./examples/10-ci-sdk-review-web/workflow-copilot-review-yml-mau-lam-gi.yaml`](./examples/10-ci-sdk-review-web/workflow-copilot-review-yml-mau-lam-gi.yaml)

> 📄 **Code ví dụ:** [`./examples/10-ci-sdk-review-web/workflow-copilot-review-yml-mau-lam-gi.sh`](./examples/10-ci-sdk-review-web/workflow-copilot-review-yml-mau-lam-gi.sh) · 📄 [GitHub Docs: Use Copilot code review](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/use-code-review)

**Ví dụ:** PR agent mở → workflow lint đỏ → comment "lint fail ở file X" → agent đọc → push fix → xanh.

## 3. Workflow `copilot-ci-triage.yml` mẫu làm gì?

**Trả lời 1 câu:** Chạy khi issue mới: đọc tiêu đề + body → phân loại (bug/feature/question) → gắn label + comment gợi ý (thiếu log? thiếu acceptance criteria?) — chỉ đọc + label, không sửa code.

> 📄 **Code ví dụ:** [`./examples/10-ci-sdk-review-web/workflow-copilot-ci-triage-yml-mau-lam.yaml`](./examples/10-ci-sdk-review-web/workflow-copilot-ci-triage-yml-mau-lam.yaml) · 📄 [GitHub Docs: Use dynamic workflows](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/use-dynamic-workflows)

**Ví dụ:** issue thiếu log → bot comment "vui lòng bổ sung: version, steps, log" + label `needs-info`. Đỡ ~50% việc phân loại tay cho repo đông issue.

## 4. Secrets trong workflow truyền sao cho đúng?

**Trả lời 1 câu:** 3 quy tắc sắt: secrets chỉ qua `${{ secrets.TEN }}` → `env` (không in log), `permissions:` tối thiểu từng job, KHÔNG dùng flag skip-verification/bypass — fix root cause thay vì bỏ gate.

> 📄 **Code ví dụ:** [`./examples/10-ci-sdk-review-web/secrets-trong-workflow-truyen-sao-cho-ung.yaml`](./examples/10-ci-sdk-review-web/secrets-trong-workflow-truyen-sao-cho-ung.yaml)

> 📄 **Code ví dụ:** [`./examples/10-ci-sdk-review-web/secrets-trong-workflow-truyen-sao-cho-ung.sh`](./examples/10-ci-sdk-review-web/secrets-trong-workflow-truyen-sao-cho-ung.sh) · 📄 [GitHub Docs: Configure secrets & variables](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/configure-secrets-and-variables)

## 5. Copilot SDK là gì, khi nào dùng thay vì chat?

**Trả lời 1 câu:** SDK = thư viện để **app của bạn** gọi năng lực Copilot (completions/agent) từ code — dùng khi logic lặp lại, nhúng hệ thống (bot Slack, dashboard triage), không cần người mở IDE; task 1 lần ad-hoc thì chat nhanh hơn viết app.

SDK bọc Copilot CLI + cung cấp sessions, permissions, custom tools, events. Token qua env, log request count để kiểm soát quota.

> 📄 **Code ví dụ:** [`./examples/10-ci-sdk-review-web/copilot-sdk-la-gi-khi-nao-dung.sh`](./examples/10-ci-sdk-review-web/copilot-sdk-la-gi-khi-nao-dung.sh)

> Tên/gói SDK đổi nhanh — đối chiếu docs mới nhất trước khi dùng. · 📄 [GitHub Docs: Copilot SDK how-to](https://docs.github.com/en/copilot/how-tos/copilot-sdk)

## 6. Code review tự động: bật ở đâu, tin được bao nhiêu?

**Trả lời 1 câu:** 2 lớp — (a) Copilot code review tích hợp PR (Repo Settings → Code security), (b) workflow custom `copilot-review.yml` — tin ở mức **"reviewer đầu tiên"** (bắt style/null-check/thiếu test); quyết định merge vẫn do người.

| Tiêu chí | Copilot code review (tích hợp) | Workflow custom |
|---|---|---|
| Bật ở đâu | Repo Settings → Code security | Thêm file vào `.github/workflows/` |
| Tùy biến | Thấp (theo GitHub) | Cao (checklist riêng team) |
| Chi phí | Theo seat/plan | GitHub Actions minutes (ngoài AI Credits) |
| Khi nào dùng | Bật mặc định mọi repo | Team có chuẩn review riêng |

> **Cách đọc bảng này:** so hai lớp review như so hai người gác cổng: Copilot review là bảo vệ tự động ai cũng có, workflow custom là thuê người gác riêng theo chuẩn nhà mình — cột **Chi phí** cho biết ai trả tiền.

> 📄 **Code ví dụ:** [`./examples/10-ci-sdk-review-web/code-review-tu-ong-bat-o-au.sh`](./examples/10-ci-sdk-review-web/code-review-tu-ong-bat-o-au.sh) · 📄 [GitHub Docs: Configure code review](https://docs.github.com/en/copilot/how-tos/copilot-on-github/set-up-copilot/configure-code-review)

**Ví dụ:** PR 200 dòng → bot comment 5 Minor → người chỉ soi 1 Major logic → review nhanh gấp đôi.

## 7. github.com/copilot (bản Web) dùng khi nào?

**Trả lời 1 câu:** Khi máy khác không có IDE, review nhanh PR trên web, hỏi về repo public chưa clone — giới hạn: không sửa multi-file mượt như IDE, không có MCP local.

> 📄 **Code ví dụ:** [`./examples/10-ci-sdk-review-web/github-com-copilot-ban-web-dung-khi.sh`](./examples/10-ci-sdk-review-web/github-com-copilot-ban-web-dung-khi.sh)

> Web còn assign cloud agent + xem cloud agent status (xem [bài 07](07-custom-agents-coding-agent-workflows.md)). · 📄 [GitHub Docs: Chat with Copilot on GitHub](https://docs.github.com/en/copilot/how-tos/copilot-on-github/chat-with-copilot/chat-in-github)

## 8. Copilot trên Mobile dùng được gì?

**Trả lời 1 câu:** Dùng để **review + quyết định** (đọc issue/PR, hỏi về code, approve workflow runs) — không dùng để code; hợp on-call/di chuyển.

> 📄 **Code ví dụ:** [`./examples/10-ci-sdk-review-web/copilot-tren-mobile-dung-uoc-gi.sh`](./examples/10-ci-sdk-review-web/copilot-tren-mobile-dung-uoc-gi.sh)

> Combo "giao việc khi làm việc (cloud agent), duyệt khi di chuyển (mobile)". · 📄 [GitHub Docs: GitHub Copilot app](https://docs.github.com/en/copilot/concepts/copilot-surfaces/github-copilot-app)

## 9. Auto-merge PR agent an toàn thế nào?

**Trả lời 1 câu:** Chỉ auto-merge khi đủ 4 điều kiện: **scope trong issue + CI xanh hết + review bot không có Critical + không chạm migrations/infra** — cấu hình bằng branch protection (required checks) + `gh pr merge --auto`.

> 📄 **Code ví dụ:** [`./examples/10-ci-sdk-review-web/auto-merge-pr-agent-an-toan-the.sh`](./examples/10-ci-sdk-review-web/auto-merge-pr-agent-an-toan-the.sh)

> Agent đã tốn AI Credits — auto-merge sai = trả tiền cho merge sai. Repo chưa có CI → không auto-merge bất kỳ PR nào. · 📄 [GitHub Docs: Automatically merging a pull request](https://docs.github.com/en/pull-requests/how-tos/merge-and-close-pull-requests/automatically-merging-a-pull-request)

## 10. Đo hiệu quả automation: metric nào đáng theo dõi?

**Trả lời 1 câu:** 4 metric/tháng: **tỉ lệ PR agent merge không sửa**, **thời gian issue→merge**, **số comment bot có ích vs nhiễu**, **AI Credits tiêu thụ** (dashboard `github.com/settings/copilot`) — metric đỏ thì tune issue template + checklist review.

> 📄 **Code ví dụ:** [`./examples/10-ci-sdk-review-web/o-hieu-qua-automation-metric-nao-ang.sh`](./examples/10-ci-sdk-review-web/o-hieu-qua-automation-metric-nao-ang.sh) · 📄 [GitHub Docs: Copilot usage metrics](https://docs.github.com/en/copilot/concepts/billing-and-usage/copilot-usage-metrics)

**Ví dụ:** tháng 1: 20 PR agent, merge 8 (40%) → tune issue template → tháng 2: merge 13 (65%) → automation đáng tiền.

---

## Vẫn lỗi thì sao? (thứ tự debug chuẩn)

1. Workflow fail → đọc log job đỏ đầu tiên (Actions tab).
2. Check `permissions:` + secrets (`grep` câu 4).
3. Test workflow trên PR nhỏ trước khi đổ lỗi agent.
4. PR agent fail → `gh pr checks` + comment `@copilot` hướng fix.
5. SDK lỗi → check token env + docs mới nhất.

Tham khảo chéo: [bài 07](07-custom-agents-coding-agent-workflows.md) (viết issue cho agent) · [bài 05](05-policies-guardrails-faq.md) (guardrails CI) · [bài 02](02-model-context-premium.md) (quota) · [../templates/.github/workflows/](../templates/.github/workflows/) (mẫu workflows) · 📄 script debug conflict/PR agent fail: [`./examples/07-custom-agents-coding-agent-workflows/coding-agent-conflict-pr-fail-xu-ly.sh`](./examples/07-custom-agents-coding-agent-workflows/coding-agent-conflict-pr-fail-xu-ly.sh).

> **Tóm gọn 1 câu:** Automation (CI + agent + review) là băng chuyền tự động trong nhà máy — workflow là bản vẽ máy móc, agent là robot chạy trên băng chuyền đó, và CI là cảm biến báo đỏ khi sản phẩm lỗi. · 📄 [GitHub Docs: Troubleshoot cloud agent](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent/troubleshoot-cloud-agent)
