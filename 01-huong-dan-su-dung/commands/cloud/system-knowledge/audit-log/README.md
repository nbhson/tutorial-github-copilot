# Audit log — "Copilot đã làm gì, lúc nào, trên repo nào" (GitHub org/enterprise)

> **Harness:** Copilot in the cloud · **Surface:** github.com / REST API (`gh api`) — không phải lệnh trong IDE; Copilot không có audit log cục bộ trên máy bạn · **Đọc:** ~2 phút

**Nôm na:** Camera an ninh cấp tổ chức: mỗi lần Copilot chạm hạ tầng — tạo PR, chạy code review, bật/tắt feature — một dòng được ghi với **ai, lúc nào, repo nào**; bạn đọc ở org settings → **Logs → Audit log** hoặc kéo qua API. Hợp khi cần bằng chứng để điều tra sự cố, đối chiếu policy, hoặc báo cáo cho auditor.

## Vì sao dùng?

Audit log trả lời được câu "PR đổi `.github/workflows/release.yml` merge lúc 2:17 sáng — ai duyệt?", thứ mà diff và commit message không trả lời nổi. Cái hay nhầm: audit log ghi **siêu dữ liệu hành động**, không ghi **nội dung prompt** — muốn chặn nội dung nhạy cảm bị đọc là content exclusion, muốn chủ động ghi nội dung chat là telemetry self-host, mỗi thứ một việc.

| Trường (docs 11/2026) | Ý nghĩa | Vai trò |
|---|---|---|
| `action` | Hành động agent gây ra | Action chuẩn của audit log (`pull_request.create`…) — **không** có namespace `copilot.*` riêng |
| `actor_is_agent` | Có phải agent làm không | Luôn `true` với event agentic |
| `agent_session_id` | Nối các event cùng một phiên | UUID — gom nhiều `pull_request.*`/`check.*` của cùng một job |
| `user` | **Người khởi động** phiên agentic | octocat — đầu mối chịu trách nhiệm giải trình |

**Nếu làm sai:** coi audit log là license compliance tool hay real-time alerting — nó chỉ là sổ ghi; muốn thấy nội dung prompt thì phải đi đường khác, và dữ liệu cũ hơn 180 ngày chỉ còn nếu bạn tự export.

## Cách dùng

Kéo từ terminal bằng `gh api` (cần quyền `admin:org`; enterprise cần scope quản trị):

```sh
gh api /orgs/ORG/audit-log \
  -X GET -f query='actor:Copilot created:>2026-01-01' \
  --paginate -q '.[] | "\(.["@timestamp"] // .created_at)  \(.action)  repo=\(.repo // "-")  user=\(.user // .actor)"'
```

- **Biến thể:** lọc `actor:Copilot` trước, thêm `operation_type` / `repo:ORG/REPO` sau; điều tra một phiên thì gom bằng `agent_session_id`, đối chiếu `user` vs `actor` để tìm tay người cuối.
- **Giới hạn:** agentic activity xem được **180 ngày** gần nhất; enterprise EMU / data-residency có thêm **streamed usage records** (public preview), mỗi record có `body` bị cắt theo trần **1MB**.
- **✅ Verify:** mỗi event kéo về có `@timestamp`, `action`, `actor` — export CSV và mở lại được trên sheet là đủ cho báo cáo; đặt alert riêng khi thấy event `copilot_ip_allow_list.` vì đổi allow-list là động tác "mở cửa", hiếm nhưng nguy hiểm nhất.

## Liên quan

- Chặn nội dung bị đọc (bước trước khi điều tra): [content-exclusion](../content-exclusion/README.md) · Lý thuyết 5 tầng bảo mật: [15-security-stack-5-tang.md](../../../../15-security-stack-5-tang.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [GitHub Docs — Agentic audit log events](https://docs.github.com/en/copilot/reference/enterprise-administrators/agentic-audit-log-events) · [GitHub Docs — Review audit logs](https://docs.github.com/en/copilot/how-tos/administer-copilot/manage-for-enterprise/review-audit-logs)
