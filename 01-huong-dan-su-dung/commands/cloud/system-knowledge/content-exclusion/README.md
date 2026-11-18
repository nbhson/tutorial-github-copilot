# Content exclusion — danh sách file Copilot bị cấm đọc

> **Harness:** Copilot in the cloud · **Surface:** GitHub.com (Settings → Copilot → Content exclusion ở repo/org/enterprise) — bạn đặt trên web, policy áp cho **mọi** surface (IDE, CLI, cloud, code review) · **Đọc:** ~2 phút

**Nôm na:** Két sắt của repo: file nằm trong danh sách thì Copilot không được mở — tắt inline suggestion ngay trong file đó, không cho nội dung "ngấm" sang file khác hay câu trả lời chat/agent. Hợp khi repo có `.env`, `*.pem`, `secrets/**` và bạn gặp hiện tượng "chỗ có chỗ không gợi ý" — cần biết đó là chủ ý chứ không phải bug.

## Vì sao dùng?

Secrets không được phép đi vào prompt, index hay transcript, và exclusion là đường biên GitHub **thực thi server-side**: client gửi repo URL lên, nhận đúng policy rồi loại file đó ra. Docs nói rõ ba hệ quả khi một file bị exclude, và cả ba đều là **chủ ý** — hàng đầu dễ bị đọc nhầm thành bug:

| Điều gì xảy ra với file bị exclude | Ảnh hưởng |
|---|---|
| Inline suggestions **không khả dụng trong chính file đó** | Gợi ý tắt ngay trong file — không phải lỗi |
| Không nuôi gợi ý ở file khác, không vào câu trả lời chat/agent | Code bên cạnh không "học" từ file secrets |
| Không được soi trong Copilot code review | PR có đụng file đó vẫn "sạch" với review |

**Nếu làm sai:** hai hướng đều đắt — quên chặn thì secret lọt vào transcript, glob quá rộng (`**/*`, `/src/**`) thì Copilot "đui" cả repo mà không ai hiểu vì sao; và đừng nhầm với `.gitignore` / `files.exclude` / `search.exclude` của VS Code, mấy thứ đó chỉ ảnh hưởng search/index, **không chặn Copilot đọc**.

## Cách dùng

Repo/Org/Enterprise → **Settings → Copilot → Content exclusion**, mỗi dòng một path ở ô "Paths to exclude":

```yaml
# fnmatch, không phân biệt hoa/thường; # để comment
- "/.env"              # file ở gốc repo — nằm trong nhóm secret điển hình
- "/secrets/**"        # cả thư mục + mọi file bên dưới
- "*.pem"              # chỉ key material, không chặn cả src
```

- **Biến thể:** đặt ở **Repository** (repo admin) / **Organization** (org owner — repo con thấy trong box xám, không sửa được) / **Enterprise** (kế thừa xuống các org); cần ẩn mềm khỏi một agent thì dùng `excludeAgent: "code-review"` / `"cloud-agent"` trong file instructions.
- **Giới hạn:** chỉ **Copilot Business / Enterprise** có org policy (gói cá nhân không có); sau khi đổi, IDE có thể **cần tới 30 phút** để nhận — Settings đã load thì reload cửa sổ.
- **✅ Verify:** test **hai chiều** — một file thường phải CÓ gợi ý (chứng tỏ Copilot sống), file bị exclude phải KHÔNG (kể cả khi hỏi "explain this file"); soi audit event `copilot.content_exclusion_changed` để biết ai đổi.

## Liên quan

- Muốn siết quyền chạy lệnh của agent (khác bài này): [policy-approval](../../../copilot/model-agent/policy-approval/README.md) · Ai đổi policy: [audit-log](../audit-log/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [GitHub Docs — Exclude content from Copilot](https://docs.github.com/en/copilot/how-tos/configure-content-exclusion/exclude-content-from-copilot) · [GitHub Docs — Content exclusion (concept)](https://docs.github.com/en/copilot/concepts/security-governance-and-network-settings/content-exclusion)
