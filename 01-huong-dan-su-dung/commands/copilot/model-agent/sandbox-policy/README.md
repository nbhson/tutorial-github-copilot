# /sandbox policy — xem chính sách sandbox đang thực sự áp dụng

> **Dành cho:** dev muốn biết agent bị chặn ở ranh giới nào, và admin cần xác nhận chính sách đã ngấm xuống máy · **Vấn đề:** đoán "sandbox bật chưa / chặt tới đâu" bằng cảm giác · **Đọc xong:** tra chính sách hiệu lực bằng một lệnh, hiểu `[] = lockdown` và giao nhau giữa các nguồn (~2 phút)
> **Harness:** Copilot · **Surface:** VS Code Chat (Copilot harness) — Copilot CLI có họ lệnh `/sandbox` riêng (các subcommand: config, status, policy, enable, disable, ca)

## 1 câu nôm na

Nhà có hàng rào chơi cho trẻ — nhưng hàng rào *mà bạn tưởng* khác hàng rào *đang dựng*. `/sandbox policy` là tấm bản vẽ rào thật: cổng nào mở, sân nào cấm, đọc từ một lệnh thay vì đoán qua việc thử.

## Vì sao dùng /sandbox policy?

Vì sandbox là lớp enforce thật — khác lời hứa trong instructions: nó giới hạn nơi lệnh của agent được chạm vào (đường dẫn, mạng) trên chính máy bạn. docs cho phép đọc trạng thái thật của nó từ trong session:

- **`/sandbox policy`** (Copilot session): in ra **effective policy — kể cả khi sandbox đang tắt**. Sandbox `off` không có nghĩa là "không có chính sách", chỉ là chính sách chưa được thực thi.
- **Bật/tắt bằng setting**: `chat.agent.sandbox.enabled` = `off` (mặc định) / `on`.
- **Chính sách nhiều nguồn thì giao nhau (intersection)**: org + user + session cùng góp hàng rào; chỗ nào cũng phải mở mới là ô mở.
- **Mảng rỗng `[]` = lockdown**: danh sách để `[]` nghĩa là *không thứ gì được đi qua*, không phải "mặc định rộng lượng".

> **Tóm gọn 1 câu:** Đừng quản thứ mình không nhìn thấy — một lệnh `/sandbox policy` cho bạn bức rào thật, thay cho ba giả định về bức rào tưởng tượng.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** vừa migrate Local → Copilot (docs gợi ý verify bằng `Developer: Policy Diagnostics` + `/sandbox policy`); admin đẩy managed settings xuống và muốn xác nhận ngấm; trước khi cho agent chạy lệnh nhạy cảm một mình.
- **ĐỪNG dùng khi:** cần trả lời "lệnh này có được duyệt không" — đó là tầng approvals ([../policy-approval/README.md](../policy-approval/README.md)); sandbox quyết định *đi tới đâu*, approvals quyết định *ai được bấm* — hai tầng, đừng trộn.
- **Đừng lẫn sandbox máy bạn với cloud:** Copilot cloud agent chạy trên hạ tầng GitHub managed, không phải MXC sandbox trên máy bạn.

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

> Chạy trên VS Code (Copilot session): gõ `/sandbox policy`. Trên Copilot CLI: `/sandbox status`, `/sandbox config`, `/sandbox enable|disable`, `/sandbox ca`.

## Ví dụ thật

Nghiệp vụ: org bật managed settings `sandbox.enabled = on` kèm `sandbox.failIfUnavailable = true` (máy không hỗ trợ sandbox thì *từ chối chạy*, không im lặng chạy trần). Bạn mở Copilot session, gõ `/sandbox policy` và đọc bức rào hiệu lực: các đường dẫn ghi được, mạng, và vì org để `network = []` nên bản in ra mạng khoá hoàn toàn — đúng chính sách admin khai.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh)

**Kết quả mong đợi:** Bản policy in ra trong session, nêu rõ từng danh sách thành phần; thấy `[]` ở mục nào là mục đó lockdown.

**✅ Verify:** Tắt setting `chat.agent.sandbox.enabled` rồi chạy lại `/sandbox policy` — bản in **vẫn ra** (docs: effective policy kể cả khi sandbox tắt); khác với việc bạn tưởng "tắt là mất lệnh".

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI:** thấy policy in ra các mảng đầy đường dẫn rồi kết luận "sandbox bật sẵn, yên tâm" — có policy ≠ policy đang được thực thi; phải xem `chat.agent.sandbox.enabled` (hoặc managed `sandbox.enabled`) đang ở `on` hay `off`.
**✅ ĐÚNG:** đọc cả hai: *chính sách là gì* (`/sandbox policy`) và *chính sách có chạy không* (setting + `failIfUnavailable`). Thiếu một trong hai là hiểu nửa bức rào.

**Bài học:** Sandbox không phải hộp đen — nhưng chỉ khi bạn chịu đọc bản in của nó. Một ô `[]` bạn không đọc hôm nay là một cánh cửa không ai canh ngày mai.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Mảng rỗng tưởng "không ràng buộc" | Hiểu ngược `[]` | `[]` = lockdown: không phần tử nào được qua |
| Máy không hỗ trợ mà vẫn chạy lệnh | `failIfUnavailable` để off → không fail-closed | Bật `sandbox.failIfUnavailable` (managed) nếu cần chặt |
| Local harness "không enforce" chính sách managed | docs: Local chỉ sandbox lệnh terminal, không enforce managed rules | Chuyển session về Copilot harness để policy máy trung ương ngấm |
| Chạy `/sandbox policy` không thấy gì | Surface sai / version chưa có | Xác nhận Copilot session; bên CLI dùng họ `/sandbox` |
| Nghĩ worktree là "vùng an toàn" | docs: worktree phân tách code change, **không phải security boundary** | Rào an toàn là sandbox + approvals, không phải git worktree |

## So sánh với Claude Code

| Việc | Copilot (`/sandbox policy`) | Claude Code | Ghi chú |
|---|---|---|---|
| Xem ranh giới hệ thống agent được chạm | `/sandbox policy` (Copilot session) | Không có tương đương trong tài liệu đối chiếu | Copilot có cả managed `sandbox.enabled` do admin đẩy xuống |
| Duyệt từng lệnh trước khi chạy | Manual/Assisted/Allow all (approvals) | Permission prompt | Tầng khác nhau: approvals hỏi — sandbox chặn |

## Best practices (kèm "vì sao")

- **Chạy `/sandbox policy` ngay sau khi migrate sang Copilot harness.** *Vì sao?* docs đặt nó vào bước verify migrate; file gốc và file migrate không sync nhau, policy cũ có thể đã mất hiệu lực.
- **Đọc policy như đọc hàng rào: tìm chỗ `[]` và chỗ hở, không tìm "cảm giác an toàn".** *Vì sao?* Intersection nhiều nguồn dễ cho kết quả chặt hơn bạn tưởng — hoặc ngược lại.
- **Admin: bật `sandbox.failIfUnavailable` khi sandbox là yêu cầu compliance.** *Vì sao?* Máy chưa hỗ trợ sẽ fail thay vì âm thầm chạy không rào.
- **Đừng dùng sandbox để thay luôn approvals.** *Vì sao?* Sandbox giới hạn *phạm vi*, còn lệnh destructive thì bạn vẫn muốn được hỏi — hai tầng bảo vệ khác mục đích.

## Bài tập nhỏ

1. **(3 phút)** Trong Copilot session, gõ `/sandbox policy` khi `chat.agent.sandbox.enabled` đang `off`, rồi bật `on` và chạy lại: khác nhau điều gì?
2. **(5 phút)** Chỉ ra trong bản in: mảng nào đang `[]`? Ô đó đang khoá cái gì?
3. **(5 phút)** Đọc lại mục sandbox của [bài 10](../../../../10-modes-permissions-availability.md) và đối chiếu đúng 1 dòng policy với điều bài dạy.

## Tham khảo

- Index nhóm: [../README.md](../README.md) · [Commands index](../../../README.md)
- Nguồn docs: [VS Code — Agent sandboxing](https://code.visualstudio.com/docs/agents/run/agent-sandboxing) · [VS Code — move to Copilot](https://code.visualstudio.com/docs/agents/run/move-to-copilot) · [GitHub — About local sandboxing](https://docs.github.com/en/copilot/concepts/security-governance-and-network-settings/understanding-local-sandboxing)
- Bài liên quan: [bài 10 — Modes, permissions & availability](../../../../10-modes-permissions-availability.md) · [bài 16 — Extensions, MCP, bảo mật & validate](../../../../16-extensions-mcp-bao-mat-validate.md) · FAQ: [policies & guardrails](../../../../../03-cau-hoi-thuong-gap/05-policies-guardrails-faq.md)
- Tầng bên cạnh: [../policy-approval/README.md](../policy-approval/README.md) (approvals) · Cloud: [../../../cloud/model-agent/coding-agent-assign/README.md](../../../cloud/model-agent/coding-agent-assign/README.md)

> Hàng rào chỉ bảo vệ bạn khi bạn biết nó cao bao nhiêu — `/sandbox policy` là thước đo, và thước đo rẻ hơn nhiều một lần "chạy trần".
