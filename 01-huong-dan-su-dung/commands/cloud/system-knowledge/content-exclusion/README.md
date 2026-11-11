# Content exclusion — danh sách file Copilot bị cấm đọc

> **Dành cho:** người có secrets/keys trong repo và admin đặt policy · **Vấn đề:** không biết file nào bị cấm đọc, tưởng bug khi mất gợi ý · **Đọc xong:** đọc đúng danh sách + test hai chiều để xác nhận (~2 phút)
>
> **Surface:** Copilot in the cloud (GitHub.com) — bạn đặt ở Settings trên GitHub.com, nhưng nó áp cho mọi surface (IDE, CLI, cloud, code review)

## 1 câu nôm na

Content exclusion là **két sắt** của repo: bạn bỏ file nhạy cảm vào danh sách, Copilot không được mở. Gặp chỗ "tự nhiên không có gợi ý", câu hỏi đầu tiên nên là "file này có nằm trong exclusion không?" thay vì "Copilot bị lỗi". · 📄 [GitHub Docs: Customizations (concept)](https://docs.github.com/en/copilot/concepts/customizations)

## Vì sao dùng Content exclusion?

Vì secrets không được phép đi vào prompt, index hay transcript, và đây là đường biên GitHub **thực thi**: client gửi repo URL lên server để lấy đúng policy rồi loại file đó ra. Với dev, biết danh sách này giúp phân biệt "bị cấm đọc" (đúng ý đồ) với "bug" (sai); với admin, nó phải đặt **trước khi** bật indexing, nếu không secret đã lọt vào index. Docs nói rõ hệ quả khi một file bị exclude:

| Điều gì xảy ra với file bị exclude | Ảnh hưởng |
|---|---|
| Inline suggestions **không khả dụng trong chính file đó** | Gợi ý tắt ngay trong file — không phải lỗi |
| Nội dung không nuôi gợi ý ở file khác, cũng không vào câu trả lời chat/agent | Code bên cạnh không "học" từ file secrets; hỏi về nó sẽ không có nội dung |
| Không được soi trong Copilot code review | PR có đụng file đó vẫn "sạch" với review |

Cả ba hàng trên đều là **chủ ý** của policy — hàng đầu dễ bị hiểu nhầm nhất vì nó trông hệt một cú lỗi. · 📄 [GitHub Docs: Customizations (concept)](https://docs.github.com/en/copilot/concepts/customizations)

## Khi nào dùng / khi nào đừng

- **Dùng khi:** repo có `.env`, `*.pem`, `secrets/**`; gặp hiện tượng "chỗ có chỗ không gợi ý"; đang audit bảo mật.
- **ĐỪNG nhầm khi:** bạn muốn siết quyền chạy lệnh của agent (đó là tool permissions/sandbox, không phải exclusion); hoặc bạn chỉ muốn file biến khỏi tìm kiếm — đó là `.gitignore` / `files.exclude` / `search.exclude` của VS Code, **chỉ ảnh hưởng search/index, không chặn Copilot đọc**. · 📄 [GitHub Docs: Comparing customizations](https://docs.github.com/en/copilot/concepts/customizations/comparing-customizations)

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.jsonc`](examples/01-cach-goi-copy-paste.jsonc) · 📄 [GitHub Docs: Exclude content from Copilot](https://docs.github.com/en/copilot/how-tos/configure-content-exclusion/exclude-content-from-copilot)

Đường đặt: **Settings → Copilot → Content exclusion** ở repo/org/enterprise (chỉ **Copilot Business / Enterprise** — gói cá nhân không có org policy để set); mỗi dòng một path dạng `- "/PATH"` (fnmatch, không phân biệt hoa/thường, `#` để comment).

| Tầng | Ai set | Ghi chú |
|---|---|---|
| Repository | Repository administrator | Áp cho mọi user Copilot trong repo đó |
| Organization | Organization owner | Chỉ user được cấp seat qua org; repo thấy trong box xám, **không sửa được** |
| Enterprise | Enterprise owner | Kế thừa xuống các org trong enterprise |

## Ví dụ thật

`secrets/prod.json` chứa key thật; bạn để ý Copilot không gợi ý gì khi mở file đó và cần xác nhận đây là chủ ý chứ không phải lỗi.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh) · 📄 [GitHub Docs: Create custom agents](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/create-custom-agents)

**Kết quả mong đợi:** mở `src/utils/format.ts` vẫn có gợi ý; `secrets/prod.json` thì không, và chat hỏi về nó cũng không thấy nội dung.

**✅ Verify:** test **hai chiều** — một file thường phải CÓ gợi ý (chứng tỏ Copilot sống), file bị exclude phải KHÔNG (kể cả khi hỏi "explain this file"). Sau khi sửa policy, IDE có thể **cần tới 30 phút** để nhận (Settings đã load thì reload cửa sổ để chắc).

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — glob quá rộng, chặn nhầm cả code:**

> 📄 **Code ví dụ:** [`examples/03-neu-lam-sai-thi-sao-sai-ung.jsonc`](examples/03-neu-lam-sai-thi-sao-sai-ung.jsonc)

**✅ ĐÚNG — hẹp, đúng thứ cần chặn:**

> 📄 **Code ví dụ:** [`examples/04-neu-lam-sai-thi-sao-sai-ung.jsonc`](examples/04-neu-lam-sai-thi-sao-sai-ung.jsonc) · 📄 [GitHub Docs: Troubleshoot common issues](https://docs.github.com/en/copilot/how-tos/troubleshoot-copilot/troubleshoot-common-issues)

**Bài học:** chặn sai đắt theo hai hướng — quên chặn thì secret vào transcript, chặn rộng thì Copilot "đui" cả repo mà không ai hiểu vì sao.

## Lỗi thường gặp

📄 [GitHub Docs: Review exclusion changes](https://docs.github.com/en/copilot/how-tos/configure-content-exclusion/review-changes)

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| "Copilot không gợi ý ở một file" | File nằm trong exclusion (đúng chủ ý) | Kiểm danh sách repo/org/enterprise + test 2 chiều |
| Vừa sửa policy mà chưa hiệu lực | Cache policy phía IDE | Đợi tới 30 phút hoặc reload cửa sổ |
| Agent vẫn đọc file qua tool khác | Third-party MCP/CLI không bị ràng buộc | Coi exclusion là guardrail của tool GitHub, không phải ranh giới OS |
| Muốn ẩn file khỏi tìm kiếm | Nhầm với `.gitignore`/`files.exclude` | Đó là exclusion của VS Code, khác bản chất |
## So sánh với Claude Code

📄 [GitHub Docs: Comparing customizations](https://docs.github.com/en/copilot/concepts/customizations/comparing-customizations)

| Việc cần làm | Copilot in the cloud | Claude Code | Ghi chú |
|---|---|---|---|
| Cấm model đọc file | Content exclusion đặt trên GitHub.com, server gửi policy về client | Không có cơ chế server-side tương đương — chặn bằng `.claude/settings.json` (permissions) | Một bên là boundary GitHub thực thi, một bên là cấu hình máy bạn |
| Mất gợi ý inline | **Có**, ngay trong file bị exclude | Không áp (Claude Code không có inline completions) | Đừng diễn giải "mất gợi ý = hỏng" |
| Kiểm ai đổi policy | Audit log `copilot.content_exclusion_changed` | Lịch sử commit của file settings | Copilot có log riêng, không phụ thuộc git |
## Best practices (kèm "vì sao")

- **Đặt exclusion trước khi bật indexing.** *Vì sao?* Index đã chứa secret thì xóa/đặt lại muộn hơn và đắt hơn nhiều.
- **Viết path tuyệt đối theo repo (`- "/secrets/**"`) và hạn chế `**/*`.** *Vì sao?* Glob rộng là cách phổ biến nhất để vô hiệu hóa Copilot mà không ai hiểu vì sao.
- **Test hai chiều sau mỗi lần đổi.** *Vì sao?* Một chiều "không có gợi ý" không đủ để kết luận — phải thấy chiều "có gợi ý" vẫn hoạt động.
- **Chỉ cần ẩn khỏi một agent thì dùng `excludeAgent`.** *Vì sao?* `excludeAgent: "code-review"` / `"cloud-agent"` trong file instructions nhẹ hơn exclusion cứng; exclusion thật thì đổi xong nên soi audit log. · 📄 [GitHub Docs: Content exclusion (concept)](https://docs.github.com/en/copilot/concepts/security-governance-and-network-settings/content-exclusion)

## Bài tập nhỏ

1. **(5 phút)** Mở Settings → Copilot → Content exclusion của repo bạn, chép danh sách path ra và tự giải thích từng path chặn cái gì.
2. **(7 phút)** Test hai chiều: hỏi "explain this file" trên một file bị exclude và một file thường — so phản ứng; rồi thử `excludeAgent: "cloud-agent"` trong file instructions và so với exclusion ở Settings. · 📄 [GitHub Docs: Exclude content from Copilot](https://docs.github.com/en/copilot/how-tos/configure-content-exclusion/exclude-content-from-copilot)

## Tham khảo

- [Group index: System & kiến thức repo](../README.md) · [FAQ bảo mật](../../../../../03-cau-hoi-thuong-gap/09-bao-mat-quyen-rieng-tu.md) · [Bài 15 — security stack](../../../../15-security-stack-5-tang.md) · [Cheatsheet](../../../../../CHEATSHEET.md)
- docs: [Content exclusion (concept + limitations)](https://docs.github.com/en/copilot/concepts/security-governance-and-network-settings/content-exclusion) · [how-to exclude content](https://docs.github.com/en/copilot/how-tos/configure-content-exclusion/exclude-content-from-copilot) · [REST API quản lý exclusion](https://docs.github.com/en/copilot/how-tos/configure-content-exclusion/exclude-content-from-copilot)
- Muốn siết quyền tool của agent: [policy & approval](../../../copilot/model-agent/policy-approval/README.md)
