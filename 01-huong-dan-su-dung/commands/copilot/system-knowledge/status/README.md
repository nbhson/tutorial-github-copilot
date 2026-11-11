# Status — Xem trạng thái Copilot trong 30 giây

> **Dành cho:** mọi người, nhất là đầu session mới · **Vấn đề:** lệnh vắng mặt / báo lỗi, dễ đổ oan cho AI trong khi lỗi nằm ở plan hay scope · **Đọc xong:** đọc được account/plan/model đang chạy trong 30 giây (~2 phút)
> **Harness:** Copilot · **Surface:** VS Code Chat (Copilot harness) / Copilot CLI / GitHub.com

## 1 câu nôm na

Liếc đồng hồ xe trước khi lên đường: xăng còn không, đèn báo có sáng cái nào không. Ba chỗ để liếc, tùy bạn đang đứng ở surface nào: · 📄 [VS Code Docs: Customize AI agents (overview)](https://code.visualstudio.com/docs/agent-customization/overview)

| Bạn ở đâu | Xem trạng thái bằng | Thấy được gì |
|---|---|---|
| VS Code (Copilot harness) | **Copilot status dashboard** — hover icon Copilot ở thanh dưới cùng | account, plan, trạng thái kích hoạt, gợi ý mở chat |
| Copilot CLI | `/user show` (account), `/version` (bản CLI), `/diagnose` khi có vấn đề, `/status` nếu build của bạn có | account/plan đang dùng, model của phiên |
| GitHub.com | `github.com/settings/copilot` | plan, AI credits đã dùng, seat của team |

## Vì sao phải kiểm trạng thái?

Vì phần lớn cảm giác "Copilot hỏng" thực ra là lỗi cấu hình: một lệnh biến mất vì plan không có, hoặc bạn đang ở nhầm account. Kiểm trạng thái tốn 30 giây nhưng tiết kiệm hàng chục phút debug sai chỗ.

**Nếu làm sai thì sao?** Bỏ qua bước này, bạn dễ đổ lỗi cho AI trong khi vấn đề là plan, scope hay policy org. Ngược lại, đọc trạng thái xong mà vẫn không hiểu thì thường là thiếu checklist — xem mục lỗi thường gặp. · 📄 [VS Code Docs: Customize AI agents (overview)](https://code.visualstudio.com/docs/agent-customization/overview)

## Khi nào dùng / khi nào đừng

- **Dùng khi:** session đầu trên một repo; khi một lệnh không thấy xuất hiện; trước khi kết luận "Copilot hỏng".
- **ĐỪNG thay bằng:** hỏi trạng thái bằng prompt thường — dashboard/CLI trả đúng cấu hình, model thì chỉ đoán từ những gì nó thấy. · 📄 [VS Code Docs: Choose a customization scope](https://code.visualstudio.com/docs/agent-customization/overview#choose-a-customization-scope)

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

> Hover icon Copilot mà không thấy gì? Icon chỉ hiện khi extension đã bật và bạn đã sign-in — xem [../login/README.md](../login/README.md) trước khi nghi ngờ lỗi. · 📄 [VS Code Docs: GitHub Copilot Setup](https://code.visualstudio.com/docs/setup/copilot)

## Ví dụ thật

Nghiệp vụ: bạn mới clone repo, gõ `/fix` mà không thấy lệnh đâu — cần biết máy mình đang ở đâu.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh) · 📄 [VS Code Docs: Create project instructions](https://code.visualstudio.com/docs/agents/guides/customize-copilot-guide#step-1-create-project-instructions)

**Kết quả mong đợi:** thấy account/plan/model; bạn biết chính xác máy đang ở plan nào, account nào.

**✅ Verify:** nói lại được "plan X, model Y, login Z" là đạt. Không nói được nghĩa là bạn chưa đọc hết kết quả.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

❌ SAI: "`/fix` không có → Copilot hỏng." (chưa xem plan và cơ chế gating)

✅ ĐÚNG: kiểm trạng thái → thấy plan/model → nếu lệnh bị gate bởi plan thì đó chính là lý do, không phải bug.

**Bài học:** trạng thái là dữ kiện, đừng đoán. 30 giây kiểm tra thay cho cả buổi cãi nhau với AI. · 📄 [VS Code Docs: Troubleshoot customization issues](https://code.visualstudio.com/docs/agent-customization/overview#troubleshoot-customization-issues)

## Lỗi thường gặp

📄 [VS Code Docs: Copilot subscription FAQ](https://code.visualstudio.com/docs/agents/agent-troubleshooting/faq#github-copilot-subscription)

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Đọc trạng thái vẫn không hiểu | Thiếu checklist | Theo checklist 30s: account → plan → quota → list lệnh `/` → update extension |
| Trạng thái ok mà vẫn lỗi | Lỗi nằm ở scope hay policy | Kiểm scope (`#file:`) + policy org |
| Quên check đầu session | Vào là hỏi ngay | Kiểm trạng thái → [instructions](../instructions/README.md) → [MCP](../mcp/README.md) mỗi repo mới |
| Số credits khác với dashboard | Độ trễ tổng hợp | Lấy `github.com/settings/copilot` làm chuẩn cuối tháng |
## So sánh với Claude Code

📄 [GitHub Docs: Comparing customizations](https://docs.github.com/en/copilot/concepts/customizations/comparing-customizations)

| Việc | Copilot | Claude Code | Ghi chú |
|---|---|---|---|
| Xem trạng thái/plan/model | Status dashboard (VS Code) · `/user show`, `/version` (CLI) | `/status`, `/config`, biến môi trường | Cùng mục đích "biết mình đang ở đâu", khác cách gọi |
| Kiểm tra MCP | `MCP: List Servers` / Customizations editor | `/mcp` hoặc xem config | Copilot tách phần MCP khỏi status |
| Kiểm chứng | Bạn đọc và tự nói lại plan/model | Bạn tự kiểm | Không agent nào tự chịu trách nhiệm đúng/sai |
## Best practices (kèm "vì sao")

- **Kiểm trạng thái một lần mỗi repo mới.** *Vì sao?* Trạng thái có thể khác theo workspace (plan/model/MCP) — biết trước để không đoán sai.
- **Không thấy một lệnh nào đó thì kiểm trạng thái trước khi báo bug.** *Vì sao?* Nhiều lệnh bị gate bởi plan/model; đó là hành vi đúng, không phải lỗi.
- **Đọc kết quả thành một câu "plan X, model Y, login Z".** *Vì sao?* Nói lại được mới chứng minh bạn đã hiểu, không chỉ nhìn lướt. · 📄 [VS Code Docs: Start with basic checks](https://code.visualstudio.com/docs/agents/agent-troubleshooting/troubleshooting#start-with-basic-checks)

## Bài tập nhỏ

1. **(3 phút)** Hover icon Copilot, viết ra 3 dòng: plan – model – account.
2. **(10 phút)** Cố tình tìm một lệnh không có trong list gõ `/`, rồi dùng trạng thái để giải thích vì sao nó vắng mặt. · 📄 [VS Code Docs: GitHub Copilot Setup](https://code.visualstudio.com/docs/setup/copilot)

## Tham khảo

- Index nhóm: [../README.md](../README.md) · Đăng nhập/đăng xuất: [../login/README.md](../login/README.md) · [../logout/README.md](../logout/README.md) · Credits: [../../model-agent/ai-credits/README.md](../../model-agent/ai-credits/README.md).
- Verify tổng khi cài: [01-cai-dat-va-xac-thuc.md](../../../../01-cai-dat-va-xac-thuc.md) · Cheatsheet: [CHEATSHEET.md](../../../../../CHEATSHEET.md) · FAQ: [08-loi-thuong-gap-troubleshooting.md](../../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- VS Code — [Set up Copilot](https://code.visualstudio.com/docs/setup/copilot) · [Troubleshooting](https://code.visualstudio.com/docs/agents/agent-troubleshooting/troubleshooting) · GitHub — [CLI command reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference).

> Chốt: kiểm trạng thái không sửa được gì cả — và đó chính là điểm mạnh: 30 giây để biết mình đang đứng ở đâu trước khi đổ lỗi cho AI.
