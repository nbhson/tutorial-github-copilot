# /sandbox policy — in ra bức rào sandbox đang thực sự áp dụng trên máy bạn

> **Harness:** Copilot · **Surface:** VS Code Chat (Copilot session) / Copilot CLI (họ lệnh `/sandbox`) · **Đọc:** ~2 phút

**Nôm na:** Nhà có hàng rào chơi cho trẻ — nhưng hàng rào *bạn tưởng* khác hàng rào *đang dựng*: `/sandbox policy` in ra chính sách hiệu lực (đường dẫn nào agent được ghi, mạng mở hay khoá) bằng một lệnh thay vì đoán. Hợp khi từ trước tới giờ bạn vẫn đoán "sandbox bật chưa, chặt tới đâu" bằng cảm giác.

## Vì sao dùng?

Sandbox là lớp **enforce thật**: nó giới hạn nơi lệnh của agent được chạm trên chính máy bạn, khác lời hứa trong instructions. Điểm đáng giá nhất: lệnh này in ra chính sách hiệu lực **kể cả khi sandbox đang tắt** — `off` nghĩa là "chưa được thực thi", không phải "không có chính sách". Hai tầng đừng trộn: sandbox quyết định *đi tới đâu*, approvals quyết định *ai được bấm* ([policy-approval](../policy-approval/README.md)).

| Thấy trong bản in | Nghĩa thật |
|---|---|
| Mảng rỗng `[]` | **lockdown** — không phần tử nào đi qua, không phải "không ràng buộc" |
| Org + user + session cùng góp rào | **giao nhau** (intersection) — ô chỉ mở khi mọi nguồn đều mở |
| `chat.agent.sandbox.enabled` đang `off` | rào vẫn tồn tại, chỉ chưa chạy — tắt không làm mất lệnh `/sandbox policy` |
| Git worktree | phân tách code change, **không phải** security boundary — rào an toàn là sandbox + approvals |
| Session chạy ở Local harness | Local chỉ sandbox lệnh terminal, không enforce managed rules — về Copilot session |

**Nếu làm sai:** thấy bản in đầy đường dẫn rồi kết luận "sandbox bật sẵn, yên tâm" là đọc nửa bức rào — phải xem cả *chính sách là gì* lẫn *nó có đang chạy không* (setting).

## Cách dùng

Gõ trong Copilot session ở VS Code (`/sandbox policy` không có ở Local harness; CLI có họ lệnh riêng):

```prompt
/sandbox policy
# Copilot CLI: /sandbox status · config · policy · enable | disable · ca
```

- **Biến thể:** vừa migrate Local → Copilot? docs gợi ý verify bằng `Developer: Policy Diagnostics` + `/sandbox policy`; admin muốn fail-closed thì bật `sandbox.failIfUnavailable` (managed) — máy không hỗ trợ sẽ **từ chối chạy** thay vì im lặng chạy trần.
- **Setting:** `chat.agent.sandbox.enabled` = `off` (mặc định) / `on`; managed settings do admin đẩy xuống: `sandbox.enabled`, `sandbox.failIfUnavailable`.
- **✅ Verify:** tắt `chat.agent.sandbox.enabled` rồi chạy lại — bản in **vẫn ra**; thấy `[]` ở mục nào (ví dụ `network`) là mục đó đang khoá.

## Liên quan

- Tầng approvals bên cạnh: [policy-approval](../policy-approval/README.md) · nơi session chạy: [session-target](../session-target/README.md) · cloud agent chạy trên hạ tầng GitHub managed, không phải sandbox máy bạn: [coding-agent-assign](../../../cloud/model-agent/coding-agent-assign/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — Understand the sandbox boundary](https://code.visualstudio.com/docs/agents/run/agent-sandboxing#understand-the-sandbox-boundary) · [VS Code Docs — Inspect the effective sandbox policy](https://code.visualstudio.com/docs/agents/run/agent-sandboxing#inspect-the-effective-sandbox-policy)
