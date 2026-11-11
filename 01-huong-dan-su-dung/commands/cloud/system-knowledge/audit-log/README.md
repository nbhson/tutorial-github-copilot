# Audit log — "Copilot đã làm gì, lúc nào, trên repo nào" (trên GitHub)

> **Dành cho:** admin org/enterprise · **Vấn đề:** ai đó để agent mở PR đổi file nhạy cảm, cần bằng chứng để điều tra hoặc đối chiếu policy · **Đọc xong:** đọc được event audit log của Copilot bằng `gh api`, hiểu thời gian lưu và biết event nào quan trọng nhất (~2-3 phút)
> **Harness:** Cloud · **Surface:** github.com / REST API — không phải lệnh trong IDE; Copilot không có audit log cục bộ trên máy bạn

## 1 câu nôm na

Camera an ninh của tòa nhà: bạn không xem được từ trong phòng, mà phải ra phòng bảo vệ (org settings → **Logs → Audit log**) hoặc xin bản ghi qua API. Mỗi lần Copilot chạm tới hạ tầng — tạo PR, chạy code review, bật/tắt feature — một dòng được ghi lại với **ai, lúc nào, repo nào**. · 📄 [GitHub Docs: Customizations (concept)](https://docs.github.com/en/copilot/concepts/customizations)

## Vì sao dùng?

- **Điều tra sự cố** — PR này do agent tạo lúc 2h sáng — ai duyệt? Chỉ event log trả lời được.
- **Chứng minh compliance** — auditor hỏi "Copilot có chạy trên repo chứa dữ liệu khách không?" → export cửa sổ 180 ngày audit log.
- **Phát hiện lệch chính sách** — ví dụ thành viên ngoài org được thêm qua `Copilot access to paid features`.

**Nếu làm sai thì sao?** Nghĩ rằng audit log = log *nội dung prompt*: **không** — nó ghi *siêu dữ liệu hành động* (ai, event, repo, timestamp), không ghi nội dung chat. Muốn chặn nội dung nhạy cảm bị đọc: content exclusion ([bài 15](../../../../15-security-stack-5-tang.md)) — còn muốn xem *nội dung* chat: telemetry self-host (bài 13), mỗi thứ một việc.

> **Tóm gọn 1 câu:** Audit log = camera an ninh cấp tổ chức; đọc bằng API với trường `action`, export CSV khi cần bằng chứng. · 📄 [GitHub Docs: Customizations (concept)](https://docs.github.com/en/copilot/concepts/customizations)

## Khi nào dùng / khi nào đừng

📄 [GitHub Docs: Comparing customizations](https://docs.github.com/en/copilot/concepts/customizations/comparing-customizations)

| Tình huống | Dùng | Đừng |
|---|---|---|
| Điều tra PR/agent bất thường | ✅ lọc `actor:Copilot` | ❌ mong thấy nội dung prompt ở đây |
| Báo cáo định kỳ cho sếp/admin | ✅ export CSV 90 ngày | ❌ dùng làm real-time alerting (phải kéo API) |
| Kiểm soát ai đang dùng paid features | ✅ event `copilot_*` + seat | ❌ coi là license compliance tool (chỉ audit) |
| Cần dữ liệu theo thời gian thực | ❌ | ✅ dùng webhook/telemetry pipeline |
## Cách gọi (copy-paste)

```bash
# Hoạt động agentic của Copilot, 7 ngày gần nhất (schema theo docs 11/2026):
gh api /orgs/ORG/audit-log \
  -X GET -f query='actor:Copilot created:>2026-01-01' \
  --paginate -q '.[] | "\(.["@timestamp"] // .created_at)  \(.action)  repo=\(.repo // "-")  user=\(.user // .actor)"'
```

```bash
# Đếm theo loại action (xem pattern bất thường):
gh api /orgs/ORG/audit-log -X GET -f query='actor:Copilot' --paginate \
  -q '.[].action' | sort | uniq -c | sort -rn
```

Cần quyền: `admin:org` (enterprise cần scope quản trị); event Copilot xuất hiện trong audit log của org/enterprise nơi chạy. · 📄 [GitHub Docs: Agentic audit log events](https://docs.github.com/en/copilot/reference/enterprise-administrators/agentic-audit-log-events)

## Schema event agentic (nguyên văn docs 11/2026)

Lọc nhanh nhất: **`actor:Copilot`** trong audit log enterprise — docs gọi đây là "agentic activity", xem được 180 ngày gần nhất.

| Field | Ý nghĩa | Ví trị |
|---|---|---|
| `action` | Hành động agent gây ra | `pull_request.create` (các action chuẩn của audit log, không có namespace `copilot.*` riêng) |
| `actor_is_agent` | Có phải agent làm không | luôn `true` với event agentic |
| `agent_session_id` | Nối các event cùng một phiên agent | UUID — dùng gom nhiều `pull_request.*`/`check.*` của cùng một job |
| `user` | **Người khởi động** phiên agentic | octocat — chịu trách nhiệm giải trình |

Ngoài ra docs mô tả **streamed Copilot API usage records** (public preview, cho enterprise EMU / data-residency): mỗi record JSON có `type` (request/response), `user_id`, `enterprise_id`, `endpoint`, `body`, `@timestamp`, `truncated` (body bị cắt theo trần 1MB), `event_id`, `github_request_id`.

> **Các dòng event là mẫu để lọc, không phải danh sách đóng.** Kéo 1 trang sample bằng `gh api` rồi `jq '.[].action' | sort -u` là cách bắt pattern chắc chắn nhất cho org của bạn. · 📄 [GitHub Docs: Agentic audit log events](https://docs.github.com/en/copilot/reference/enterprise-administrators/agentic-audit-log-events)

## Ví dụ thật — "AI có mở PR lúc 2h sáng không?"

Incident: một PR đổi `.github/workflows/release.yml` được merge 2:17 sáng mà không ai nhớ làm. Điều tra 3 bước:

> 📄 **Script điều tra hoàn chỉnh:** [`examples/02-dieu-tra-pr-luc-2h-sang.sh`](examples/02-dieu-tra-pr-luc-2h-sang.sh) · 📄 [GitHub Docs: Create custom agents](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/create-custom-agents)

1. Lọc event `copilot.agent` quanh khung giờ: khớp actor + thời điểm.
2. Đối chiếu `copilot.session_start`/`copilot.session_stop` → session nào, repo nào.
3. Kéo thêm audit log của repo (`repo:ORG/REPO`) xem ai approve/merge — `user` vs `actor` chỉ ra tay người cuối.

**✅ Verify:** mỗi event có `@timestamp`, `action`, `actor` — export CSV và mở lại được trên sheet là đủ cho báo cáo.

## Lỗi thường gặp (❌ SAI / ✅ ĐÚNG)

📄 [GitHub Docs: Review audit logs](https://docs.github.com/en/copilot/how-tos/administer-copilot/manage-for-enterprise/review-audit-logs)

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| API trả rỗng mà UI vẫn thấy event | query filter sai key | thử `actor:Copilot` trước, thêm `operation_type`/`repo` sau |
| Gom event cùng một phiên agent bị rời rạc | mỗi hành động là một event thường (`pull_request.create`…) | nối bằng `agent_session_id` |
| Cần dữ liệu >180 ngày | docs 11/2026 ghi agentic activity xem được **180 ngày** | export CSV định kỳ; enterprise có streamed usage records (public preview, EMU/data-residency) |
| Muốn thấy nội dung prompt | audit log chỉ ghi siêu dữ liệu hành động | dùng content exclusion (chặn trước) + telemetry self-host (ghi log chủ động) |
## So sánh với Claude Code

| | GitHub Copilot | Claude Code |
|---|---|---|
| Audit log | ✅ org/enterprise, API + export (trang docs ghi rõ) | ❌ built-in ở terminal — team tự log qua OpenTelemetry wrapper |
| Telemetry push | ✅ OTel export (bài 13) | ✅ OTLP (docs Anthropic) |

Claude Code không có "camera tầng" của tổ chức — nếu team bạn cần bằng chứng pháp lý, Copilot audit log là điểm khác biệt thực tế. · 📄 [GitHub Docs: Comparing customizations](https://docs.github.com/en/copilot/concepts/customizations/comparing-customizations)

## Best practices (kèm "vì sao")

- **Săn event định kỳ hàng tuần bằng script (không phải khi có incident).** *Vì sao?* 90% sự cố AI dùng sai là lệch chính sách tích lũy âm thầm; phát hiện sớm đỡ mất tháng điều tra.
- **Export CSV mỗi 30 ngày.** *Vì sao?* Giới hạn lưu có hạn — muốn giữ dài phải tự giữ.
- **Đặt alert khi có `copilot_ip_allow_list.`.** *Vì sao?* Đổi allow-list là động tác "mở cửa" — hiếm nhưng nguy hiểm nhất. · 📄 [GitHub Docs: Monitor agentic activity](https://docs.github.com/en/copilot/how-tos/administer-copilot/manage-for-enterprise/manage-agents/monitor-agentic-activity)

## Bài tập nhỏ

1. **(3 phút)** Chạy `gh api /orgs/ORG/audit-log -X GET -f query='action:copilot*'` (ORG = org bạn có quyền) — đếm event trong 7 ngày.
2. **(5 phút)** Điều tra 1 PR "lạ" theo ví dụ trên: xác định actor + session liên quan. · 📄 [GitHub Docs: Agentic audit log events](https://docs.github.com/en/copilot/reference/enterprise-administrators/agentic-audit-log-events)

## Tham khảo

- Bài chủ: [15 — Security stack 5 tầng](../../../../15-security-stack-5-tang.md) (audit = tầng 5) · [13 — Telemetry](../../../../13-code-intelligence-indexing-telemetry.md).
- Index nhóm: [../README.md](../README.md) · Related: [content-exclusion](../content-exclusion/README.md).
- Docs: [Audit log events for agents](https://docs.github.com/en/copilot/reference/enterprise-administrators/agentic-audit-log-events) · [Review audit logs (how-to)](https://docs.github.com/en/copilot/how-tos/administer-copilot/manage-for-enterprise/review-audit-logs) · [Reviewing the audit log](https://docs.github.com/en/organizations/keeping-your-organization-secure/managing-security-settings-for-your-organization/reviewing-the-audit-log-for-your-organization).

> **Chốt:** audit log trả lời "ai, lúc nào, repo nào" — không trả lời "nội dung gì"; đừng hỏi camera câu hỏi của micro.
