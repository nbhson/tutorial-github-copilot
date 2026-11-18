# /status — Biết mình đang ở account nào, plan gì, model nào trong 30 giây

> **Harness:** Copilot · **Surface:** VS Code (status dashboard) / Copilot CLI / GitHub.com · **Đọc:** ~2 phút

**Nôm na:** Liếc đồng hồ xe trước khi lên đường: xăng còn không, đèn báo có sáng cái nào không — account, plan, model thấy hết trong một cái liếc. Hợp khi một lệnh biến mất và bạn sắp kết luận "Copilot hỏng".

## Vì sao dùng?

Phần lớn cảm giác "Copilot hỏng" thực ra là lỗi cấu hình: một lệnh vắng mặt vì plan không có — đó là **hành vi đúng, không phải bug** — hoặc bạn đang ở nhầm account. Kiểm trạng thái tốn 30 giây nhưng tiết kiệm hàng chục phút debug sai chỗ; đừng hỏi trạng thái bằng prompt thường vì model chỉ đoán từ những gì nó thấy, còn dashboard/CLI trả đúng cấu hình.

| Bạn ở đâu | Xem trạng thái bằng | Thấy được gì |
|---|---|---|
| VS Code (Copilot harness) | **Copilot status dashboard** — hover icon Copilot ở thanh dưới cùng | account, plan, trạng thái kích hoạt, gợi ý mở chat |
| Copilot CLI | `/user show` (account), `/version` (bản CLI), `/session info` (phiên), `/usage` (credits) | account/plan đang dùng, model của phiên |
| GitHub.com | `github.com/settings/copilot` | plan, AI credits đã dùng, seat của team — chuẩn cuối tháng |

**Nếu làm sai:** docs CLI **không có `/status`** (chỉ có `/statusline`, `/footer`) — ở CLI bạn đọc trạng thái bằng `/user show` + `/version`; số credits có độ trễ tổng hợp, lấy `github.com/settings/copilot` làm chuẩn; và icon Copilot chỉ hiện khi extension đã bật + bạn đã sign-in.

## Cách dùng

Hover icon Copilot (VS Code) để liếc dashboard; trong Copilot CLI:

```prompt
/user show
/version
```

- **Checklist 30s:** account → plan → quota → list lệnh `/` → update extension; trạng thái ok mà vẫn lỗi thì kiểm scope (`#file:`) hay policy org.
- **✅ Verify:** nói lại được thành một câu "plan X, model Y, login Z" là đạt — không nói được nghĩa là bạn chưa đọc hết kết quả.

## Liên quan

- Login/đăng xuất: [login](../login/README.md) · [logout](../logout/README.md) · Credits: [ai-credits](../../model-agent/ai-credits/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — Set up Copilot](https://code.visualstudio.com/docs/setup/copilot) · [GitHub Docs — CLI command reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference)
