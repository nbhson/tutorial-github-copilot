# Bucket `cloud/` — 6 thứ chạy trên hạ tầng GitHub, không phải máy bạn

> **Dành cho:** người giao task cho Copilot cloud agent / cần biết dữ liệu repo đi đâu · **Vấn đề:** các slug IDE quen thuộc không áp dụng khi agent chạy trên cloud · **Đọc xong:** tra đúng slug theo việc và nắm giới hạn bảo mật của từng lớp (~2 phút).

Bucket này là các tính năng **không gắn máy cá nhân**: assign issue cho Copilot cloud agent, review trên PR, chính sách sandbox của agent chạy trên cloud, content exclusion, knowledge base, audit log. Không có slash "gọi" chúng từ Chat view — thao tác qua **github.com, API, hoặc org settings**; Copilot harness chỉ là điểm xuất phát (hand off).

## Mục lục

| Nhóm | Slug | Việc |
|---|---|---|
| [Model & agent](./model-agent/README.md) | [cloud-agent-session](./model-agent/cloud-agent-session/README.md) | chọn mode × permission × environment cho session cloud |
| | [coding-agent-assign](./model-agent/coding-agent-assign/README.md) | giao issue → agent mở draft PR |
| | [coding-agent-pr](./model-agent/coding-agent-pr/README.md) | request review, đọc finding, quyết merge |
| [System & kiến thức repo](./system-knowledge/README.md) | [content-exclusion](./system-knowledge/content-exclusion/README.md) | khai báo file Copilot không được đọc |
| | [knowledge-base](./system-knowledge/knowledge-base/README.md) | hợp nhất tri thức team (docs/wiki/RAG) |
| | [audit-log](./system-knowledge/audit-log/README.md) | "Copilot làm gì, lúc nào, repo nào" — admin điều tra |

## Ba quy tắc sống ở cloud (khác hẳn IDE)

1. **Session bắt đầu từ repo của bạn nhưng chạy trên hạ tầng GitHub** — code đi qua cloud sandbox ephemeral; tool đã pre-approved nên hook phải chặn ở `preToolUse` (docs GitHub: "Hooks for Copilot in the cloud").
2. **Mọi thứ do agent tạo là PR/draft chờ người review** — không có "Accept" kiểu editor; merge vẫn là quyền người thật.
3. **Plan nào trả phí mới bật được các lớp cloud** — chính sách org mới là công tắc thật; tra [bài 16](../../16-extensions-mcp-bao-mat-validate.md) khi dev báo "tôi không assign được".

## Tra nhanh: tình huống hay gặp

| Tôi muốn… | Mở |
|---|---|
| Agent sửa hộ con bug đang nằm backlog | [coding-agent-assign](./model-agent/coding-agent-assign/README.md) |
| Chọn chế độ cho session cloud (ai approve gì) | [cloud-agent-session](./model-agent/cloud-agent-session/README.md) |
| Copilot đọc wiki/ADR của team khi review | [knowledge-base](./system-knowledge/knowledge-base/README.md) |
| Chặn model đọc file chưa merge của tôi | [content-exclusion](./system-knowledge/content-exclusion/README.md) |
| Điều tra "AI mở PR đổi workflow release" | [audit-log](./system-knowledge/audit-log/README.md) |

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — coi sandbox cloud là "môi trường dev thứ hai".** Sandbox là ephemeral: mất khi job xong, muốn giữ kết quả phải PR hoặc hook `type: "http"` gửi ra host được allow.

**✅ ĐÚNG — trước khi giao việc:** (1) scope gọn, reproduce được; (2) lệnh verify rõ (test/lint); (3) đọc 3 câu hỏi của [cloud-agent-session](./model-agent/cloud-agent-session/README.md) — có cần máy bạn không? chạy khi tắt máy không? ai duyệt tool?

**Bài học:** cloud không phải "Copilot từ xa" — là hệ thống job có điều kiện riêng; đừng import giả định của IDE sang.

## Tham khảo

- Bài học: [02 — Các bề mặt](../../02-cac-be-mat-vscode-ide-web-cli.md) (Session Target) · [07 — Policies](../../07-policies-guardrails-tu-dong-hoa.md) (hooks trên cloud) · [15 — Security stack](../../15-security-stack-5-tang.md) (exclusion + audit) · [16 — Admin](../../16-extensions-mcp-bao-mat-validate.md).
- Docs: [About Copilot cloud agent](https://docs.github.com/en/copilot/concepts/agents/cloud-agent/about-cloud-agent) · [local sandboxing](https://docs.github.com/en/copilot/concepts/security-governance-and-network-settings/understanding-local-sandboxing) · [audit logs](https://docs.github.com/en/copilot/reference/enterprise-administrators/agentic-audit-log-events).

> **Chốt:** 6 slug này là "vùng không có máy bạn" — việc gì chạy khi bạn tắt máy, hoặc cần bằng chứng cấp tổ chức, thì nằm ở đây; phần còn lại của kho lệnh thuộc [`../copilot/`](../copilot/README.md) và [`../local/`](../local/README.md).
