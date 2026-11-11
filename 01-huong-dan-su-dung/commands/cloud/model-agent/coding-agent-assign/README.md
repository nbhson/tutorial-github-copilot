# Giao việc cho Copilot cloud agent — assign issue, nhận draft PR

> **Dành cho:** người có issue đã rõ (mục tiêu + phạm vi + lệnh verify) · **Đọc xong:** giao việc async, mở session log theo dõi, nhận draft PR để review (~2 phút)
>
> **Surface:** Copilot in the cloud (GitHub.com) — agent chạy trên hạ tầng GitHub, máy bạn có tắt vẫn chạy

## 1 câu nôm na

Giao việc cho "ca đêm": assign issue cho Copilot, sáng dậy đã có **draft PR** chờ review. Bạn không ngồi trông từng bước, nên chất lượng issue chính là thứ quyết định kết quả. Docs gọi agent này là **Copilot cloud agent** (trong trải nghiệm **Copilot in the cloud** trên GitHub.com) — tên cũ hay bị gọi lẫn là "coding agent", khi tra docs hãy tìm theo tên mới. · 📄 [GitHub Docs: About GitHub Copilot agents](https://docs.github.com/en/copilot/concepts/agent-capabilities/about-agents/about-github-copilot-agents)

## Vì sao dùng Copilot cloud agent?

Vì nó chạy song song mà không chiếm máy bạn: giao vài issue độc lập, tối về vài PR draft. Ở cloud bạn còn chọn được **Environment** — **Cloud** (sandbox, mặc định), **Actions** (GitHub Actions), hoặc **Environments** (remote) — và **Mode**: **Interactive** (làm từng bước với bạn, mặc định) hay **Autopilot** (ủy quyền chạy từ đầu đến cuối).

| Bạn định làm | Chọn gì | Vì sao |
|---|---|---|
| Giao một issue, về xem kết quả | Assign issue cho Copilot | Có draft PR + session log, không cần ngồi máy |
| Việc cần quyết từng bước ngay bây giờ | **Interactive** mode | Bạn steer giữa chừng bằng follow-up prompt |
| Cần chạy tiếp trên IDE/CLI/mobile | Environment **Cloud** (sandbox) | Sandbox thì session resume được across clients; **Actions** chỉ xem trên website |

> **Cách đọc bảng này:** chọn theo câu hỏi "bạn có cần can thiệp giữa chừng không"; hai hàng dưới nói thẳng sự đánh đổi giữa tốc độ và quyền duyệt. · 📄 [GitHub Docs: About GitHub Copilot agents](https://docs.github.com/en/copilot/concepts/agent-capabilities/about-agents/about-github-copilot-agents)

## Khi nào dùng / khi nào đừng

- **Dùng khi:** issue rõ mục tiêu + phạm vi + lệnh verify; việc độc lập không cần quyết liên tục; muốn song song nhiều issue.
- **ĐỪNG dùng khi:** việc cần bạn duyệt từng bước (giữ lại [Agent mode](../../../copilot/model-agent/agent-mode/README.md) trong IDE); scope còn mơ hồ; repo bị loại khỏi Copilot bởi content exclusion — khi đó repo không xuất hiện trong danh sách chọn.
- **Điều kiện:** cần gói Copilot trả phí; org/enterprise phải bật policy **Copilot in the cloud**; Enterprise Managed Users **không** dùng được ở repo cá nhân (GitHub-hosted runner không khả dụng). · 📄 [GitHub Docs: Choosing & delegating agent work](https://docs.github.com/en/copilot/concepts/agent-capabilities/choosing-and-delegating-agent-work)

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh) · 📄 [GitHub Docs: Kick off a task](https://docs.github.com/en/copilot/how-tos/copilot-on-github/use-copilot-agents/kick-off-a-task)

Ba cửa vào docs liệt kê: **Assignees → Copilot** trên issue; tab **Agents** trong repo (hoặc `github.com/copilot/agents`); và prompt trên `github.com/copilot` kèm chọn repo ở **session context**.

## Ví dụ thật

Issue #142: thêm rate-limit cho `POST /api/login`, phạm vi `apps/api/**`, verify bằng `pnpm --filter api test`.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh) · 📄 [GitHub Docs: Research, plan, iterate](https://docs.github.com/en/copilot/how-tos/copilot-on-github/use-copilot-agents/research-plan-iterate)

**Kết quả mong đợi:** Copilot thả 👀 lên issue, mở **draft PR** linked tới issue, log stream xem được qua **View session**; bạn chỉ việc review.

**✅ Verify:** PR có test xanh + diff nằm trong phạm vi issue; nếu nó chạm file ngoài phạm vi, comment yêu cầu thu hẹp rồi re-assign.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — issue một dòng, không scope, không verify:**

> 📄 **Code ví dụ:** [`examples/03-neu-lam-sai-thi-sao-sai-ung.sh`](examples/03-neu-lam-sai-thi-sao-sai-ung.sh)

**✅ ĐÚNG — issue là bản đặc tả 4 mục:**

> 📄 **Code ví dụ:** [`examples/04-neu-lam-sai-thi-sao-sai-ung.sh`](examples/04-neu-lam-sai-thi-sao-sai-ung.sh) · 📄 [GitHub Docs: Troubleshoot common issues](https://docs.github.com/en/copilot/how-tos/troubleshoot-copilot/troubleshoot-common-issues)

**Bài học:** agent không hỏi lại được giữa chừng — issue rõ là hợp đồng, issue mơ hồ là PR bỏ.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Không thấy Copilot trong Assignees | Chưa có gói trả phí, hoặc policy org/repo tắt | Kiểm [features](https://github.com/settings/copilot/features) + ask owner bật Copilot in the cloud |
| Assign rồi im lặng | Chưa refresh / agent đang chuẩn bị | Đợi rồi refresh: 👀 → "Copilot started work" → **View session** |
| Agent dùng tool không hỏi | MCP đã cấu hình cho repo thì Copilot tự chạy tool, không xin phép | Giới hạn tool trong `.github/copilot-instructions.md` + cân nhắc permissions |
| `@copilot` không trả lời | Comment từ người không có write access, hoặc PR không assign cho Copilot | Comment từ tài khoản có write, trên PR đang assign |

> **Cách đọc bảng này:** hai hàng đầu là "nó có chạy không", hai hàng sau là "nó chạy rồi thì kiểm soát thế nào" — hàng MCP đáng nhớ nhất vì quyền đã trao là tự động. · 📄 [GitHub Docs: Troubleshoot cloud agent](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent/troubleshoot-cloud-agent)

## So sánh với Claude Code

📄 [GitHub Docs: Third-party coding agents](https://docs.github.com/en/copilot/concepts/agent-capabilities/about-agents/about-third-party-coding-agents)

| Việc cần làm | Copilot in the cloud | Claude Code | Ghi chú |
|---|---|---|---|
| Giao việc async, nhận PR | Assign issue → draft PR + session log trên GitHub | Không có tương đương trực tiếp — muốn async phải tự dựng CI/session | Khác biệt lớn nhất: hạ tầng của GitHub, không cần máy bạn bật |
| Nơi chạy | Cloud sandbox / Actions / remote environment | Máy bạn (hoặc CI bạn tự cấu hình) | Copilot session trên sandbox resume được across clients |
| Ràng buộc phạm vi | Viết trong issue + custom instructions + tool permissions | Prompt + permission allowlist | Cả hai đều cần spec rõ; chỗ khác là ràng buộc của Copilot nằm ở nhiều lớp hơn |
## Best practices (kèm "vì sao")

- **Viết issue theo 4 mục: Mục tiêu / Phạm vi / Xong khi / Lệnh verify.** *Vì sao?* Đó là toàn bộ thông tin agent có khi bạn đã đi ngủ.
- **Mỗi agent một vùng, một branch.** *Vì sao?* Hai agent cùng chạm một vùng thì conflict gần như chắc chắn.
- **Để Assisted cho việc lạ, chỉ Allow all cho việc đã quen.** *Vì sao?* Allow all đổi kiểm soát lấy tốc độ — chỉ đáng khi bạn đã tin quy trình.
- **Đọc session log trước khi đọc diff.** *Vì sao?* Log giải thích *vì sao* nó sửa thế; diff chỉ cho biết nó sửa gì. · 📄 [GitHub Docs: Research, plan, iterate](https://docs.github.com/en/copilot/how-tos/copilot-on-github/use-copilot-agents/research-plan-iterate)

## Bài tập nhỏ

1. **(5 phút)** Viết một issue theo mẫu 4 mục cho một việc nhỏ trong repo bạn, kiểm đã đủ Mục tiêu/Phạm vi/Xong khi/Verify chưa.
2. **(7 phút)** Assign 2 issue độc lập ở 2 vùng khác nhau; quan sát PR và cách chúng không đụng nhau.
3. **(5 phút)** Mở session log của một PR đang chạy, ghi lại 2 thời điểm bạn muốn can thiệp — đó là lúc nên dùng Interactive. · 📄 [GitHub Docs: Kick off a task](https://docs.github.com/en/copilot/how-tos/copilot-on-github/use-copilot-agents/kick-off-a-task)

## Tham khảo

- [Group index: Model & Agent](../README.md) · [Tiếp theo: review PR](../coding-agent-pr/README.md) · [Theo dõi session](../cloud-agent-session/README.md) · [Cheatsheet](../../../../../CHEATSHEET.md)
- [GitHub — Using Copilot in the cloud on GitHub](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent/use-cloud-agent-on-github)
- [GitHub — About Copilot in the cloud / cloud agent](https://docs.github.com/en/copilot/concepts/copilot-surfaces/copilot-on-github)
- [GitHub — Troubleshoot Copilot cloud agent](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent/troubleshoot-cloud-agent)
- [GitHub — Configure MCP servers for your repository](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/configure-mcp-servers)
