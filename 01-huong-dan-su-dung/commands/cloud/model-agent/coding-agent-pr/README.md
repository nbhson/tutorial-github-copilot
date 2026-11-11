# Copilot trên PR — request review, đọc finding, quyết merge

> **Dành cho:** người review PR do cloud agent mở hoặc muốn Copilot soi diff · **Vấn đề:** tin tóm tắt của agent rồi merge mù · **Đọc xong:** đi đúng flow request review → đọc finding → fix → merge/revert (~2 phút)
>
> **Surface:** Copilot in the cloud (GitHub.com) — cả Copilot code review lẫn cloud agent đều chạy trên hạ tầng GitHub

## 1 câu nôm na

Copilot đứng ở hai chặng của một PR: nó **mở** PR (khi bạn assign issue) và nó **review** PR (khi bạn bấm Request dưới "Reviewers", như gọi một đồng nghiệp). Chặng nào cũng cần người duyệt — băng chuyền không tự ký nhận. · 📄 [GitHub Docs: About GitHub Copilot agents](https://docs.github.com/en/copilot/concepts/agent-capabilities/about-agents/about-github-copilot-agents)

## Vì sao dùng Copilot code review?

Vì nó soi diff ngay lúc PR mở, bắt lỗi hiển nhiên (bug, security, style) trước khi người đọc, và gợi ý thay đổi bạn apply được bằng vài cú click. Quan trọng: **mặc định Copilot để lại review loại "Comment"**, không Approve hay Request changes — nghĩa là finding của nó không đếm vào required approval, trừ khi org bật approvals. · 📄 [GitHub Docs: About GitHub Copilot agents](https://docs.github.com/en/copilot/concepts/agent-capabilities/about-agents/about-github-copilot-agents)

| Chặng trên PR | Ai làm | Copilot có thay bạn quyết không |
|---|---|---|
| Mở PR từ issue | Copilot cloud agent | Không — PR ở chế độ **draft** |
| Soi diff, gắn nhãn lỗi | Copilot code review (severity High/Medium/Low) | Không — mặc định chỉ là "Comment" |
| Áp dụng fix | Bạn, hoặc **Fix with Copilot** | Một nửa — nó sửa, bạn duyệt commit |
| Merge / revert | Người có quyền | Không bao giờ |

## Khi nào dùng / khi nào đừng

- **Dùng khi:** review PR do cloud agent mở; muốn lấy một lượt soi diff tự động trước khi người đọc; cần phân loại finding theo mức nghiêm trọng.
- **ĐỪNG dùng khi:** PR chưa có mô tả/phạm vi rõ (soạn lại trước); bạn đang cần *viết* code chứ không phải duyệt (xem [coding-agent-assign](../coding-agent-assign/README.md)); bạn định coi review của Copilot là approval thay người.
- **Cho ai:** người phê duyệt PR, người nhận việc từ cloud agent. · 📄 [GitHub Docs: Choosing & delegating agent work](https://docs.github.com/en/copilot/concepts/agent-capabilities/choosing-and-delegating-agent-work)

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh) · 📄 [GitHub Docs: Watch and fix pull requests](https://docs.github.com/en/copilot/how-tos/copilot-on-github/use-copilot-agents/watch-and-fix-pull-requests)

Chọn **review effort** ngay chỗ **Reviewers** trước khi request: **Lite** (bắt lỗi hiển nhiên), **Balanced** (sâu hơn, mặc định), **Max** (nhiều model reasoning cho PR cần soi kỹ).

## Ví dụ thật

Agent mở PR "rate-limit" từ issue #142. Bạn là người review và muốn Copilot soi trước.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh) · 📄 [GitHub Docs: Research, plan, iterate](https://docs.github.com/en/copilot/how-tos/copilot-on-github/use-copilot-agents/research-plan-iterate)

**Kết quả mong đợi:** Copilot trả lời thường trong vòng <30 giây, comment gắn nhãn High/Medium/Low, chỗ nào sửa được thì có suggestion hoặc nút **Fix with Copilot**; CI xanh rồi bạn mới merge.

**✅ Verify:** Mọi finding High đã resolve hoặc có lý do ghi rõ; `git diff` bạn đọc bằng mắt; staging chạy ổn sau merge.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — merge theo tóm tắt khi CI còn đỏ:**

> 📄 **Code ví dụ:** [`examples/03-neu-lam-sai-thi-sao-sai-ung.sh`](examples/03-neu-lam-sai-thi-sao-sai-ung.sh)

**✅ ĐÚNG — CI xanh + đọc diff + xử lý finding:**

> 📄 **Code ví dụ:** [`examples/04-neu-lam-sai-thi-sao-sai-ung.sh`](examples/04-neu-lam-sai-thi-sao-sai-ung.sh) · 📄 [GitHub Docs: Troubleshoot common issues](https://docs.github.com/en/copilot/how-tos/troubleshoot-copilot/troubleshoot-common-issues)

**Bài học:** tóm tắt do agent viết nên luôn "có vẻ đúng"; diff và CI mới là bằng chứng.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Trả lời comment của Copilot mà nó không phản hồi | Comment bạn viết **không** được chuyển lại cho Copilot | Muốn nó sửa: dùng **Fix with Copilot** hoặc push commit rồi re-request |
| Re-review lặp lại comment cũ | Copilot có thể nhắc lại finding đã Resolve/downvote | Gắn lý do vào commit; coi re-review là lượt mới |
| Merge khi CI đỏ | Bỏ qua cửa chặn duy nhất tự động | Đỏ → bắt fix, xanh mới merge |
| Review tốn hơn dự kiến | Effort cao tiêu nhiều AI credits | Lite ~$0.25, Balanced ~$1.50, Max ~$10 (guideline, theo size PR) + Actions minutes |

> **Cách đọc bảng này:** hàng 1 và 2 là hiểu lầm "Copilot như đồng nghiệp" — nó gần một công đoạn chạy lại từ đầu hơn là một cuộc hội thoại trên PR. · 📄 [GitHub Docs: Troubleshoot cloud agent](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent/troubleshoot-cloud-agent)

## So sánh với Claude Code

📄 [GitHub Docs: Third-party coding agents](https://docs.github.com/en/copilot/concepts/agent-capabilities/about-agents/about-third-party-coding-agents)

| Việc cần làm | Copilot in the cloud | Claude Code | Ghi chú |
|---|---|---|---|
| Soi PR | Request Copilot review trên GitHub, có effort levels | Không có tương đương ở cấp PR — review trong phiên local | Copilot gắn vào flow review sẵn có |
| Sửa theo finding | **Fix with Copilot** → draft comment → commit/PR mới | Bạn/agent sửa trong phiên rồi push | Copilot giữ dấu vết trên PR; Claude Code giữ ở máy bạn |
| Dạy nó rules của repo | `.github/copilot-instructions.md` + `*.instructions.md` (`applyTo`) | `CLAUDE.md` / skills | Cùng ý: rules nằm trong repo và được review như code |
## Best practices (kèm "vì sao")

- **Đặt rules review trong `.github/copilot-instructions.md`.** *Vì sao?* Repo-level instructions áp dụng cho cả cloud agent lẫn code review, và nằm trong git nên đổi là có PR review.
- **Dùng `applyTo` cho rules theo đường dẫn, `excludeAgent` khi muốn ẩn file.** *Vì sao?* `applyTo: "**/*.ts"` giới hạn phạm vi; `excludeAgent: "code-review"` (hoặc `"cloud-agent"`) chặn một agent đọc file đó. Cần **exclusion cứng** (Copilot không được đọc) thì đó là content exclusion, xem [content-exclusion](../../system-knowledge/content-exclusion/README.md).
- **Giữ PR nhỏ.** *Vì sao?* PR to khiến người ta duyệt cho xong, và effort cao trên PR to thì tốn credits.
- **Biết đường revert trước khi merge.** *Vì sao?* Chuẩn bị lùi giúp bạn dám merge nhanh mà không lo sự cố kéo dài. · 📄 [GitHub Docs: Review Copilot output](https://docs.github.com/en/copilot/how-tos/copilot-on-github/use-copilot-agents/review-copilot-output)

## Bài tập nhỏ

1. **(5 phút)** Mở một PR bất kỳ, request Copilot review ở effort Lite, rồi phân loại finding: cái nào thật sự nên sửa trước merge?
2. **(5 phút)** Trả lời một comment của Copilot, xác nhận nó **không** phản hồi; sau đó thử **Fix with Copilot** và so hai trải nghiệm.
3. **(7 phút)** Viết `.github/instructions/ts.instructions.md` với `applyTo: "**/*.ts"` yêu cầu kiểm tra input, rồi request review để xem nó áp dụng không. · 📄 [GitHub Docs: Watch and fix pull requests](https://docs.github.com/en/copilot/how-tos/copilot-on-github/use-copilot-agents/watch-and-fix-pull-requests)

## Tham khảo

- [Group index: Model & Agent](../README.md) · [Trước khi có PR](../coding-agent-assign/README.md) · [Theo dõi session](../cloud-agent-session/README.md) · [Cheatsheet](../../../../../CHEATSHEET.md)
- [GitHub — Using Copilot code review](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/use-code-review)
- [GitHub — Copilot code review (concept, effort levels)](https://docs.github.com/en/copilot/concepts/agent-capabilities/agent-powered-workflows-and-operations/code-review)
- [GitHub — Add repository custom instructions (`applyTo`, `excludeAgent`)](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/add-custom-instructions/add-repository-instructions)
- [GitHub — Copilot billing: models and pricing (AI credits)](https://docs.github.com/en/copilot/reference/copilot-billing/models-and-pricing)
