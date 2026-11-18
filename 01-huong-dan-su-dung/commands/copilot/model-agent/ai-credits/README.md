# AI Credits — công-tơ trên GitHub.com: đã tiêu bao nhiêu, còn lại bao nhiêu, ngày nào reset

> **Harness:** Copilot · **Surface:** GitHub.com (dashboard) / Copilot CLI / VS Code Chat (Copilot harness) · **Đọc:** ~2 phút

**Nôm na:** Từ 01/06/2026 Copilot tính tiền bằng AI Credits — 1 credit = $0.01, trừ per-token theo bảng giá từng model — và trang **Plan & usage** trên GitHub.com cho bạn thấy đã dùng, còn lại và ngày reset. Hợp khi sắp fan-out nhiều task agent, hoặc hay gặp báo lỗi quota mà không rõ "hết tiền hay model hỏng".

## Vì sao dùng?

Hết credit giữa tháng thường không phải "xui" — nó là hệ quả của nhiều ngày dùng model mạnh cho việc nhẹ; nhìn công-tơ đầu tuần thì kịp chỉnh thói quen trước khi bị cúp. Tin cần nhớ: code completion và next edit suggestions **không** trừ credit, không giới hạn trên các plan trả phí.

| Nơi xem / siết | Surface | Cho bạn gì |
|---|---|---|
| `github.com/settings/copilot` → Plan & usage | GitHub.com | đã dùng / còn lại / ngày reset, budget tổ chức |
| Bảng tổng kết phiên theo model | Copilot CLI | model nào đang ngốn credit trong phiên này |
| `/limits` · `--max-ai-credits` | Copilot CLI | cap mềm cho lượt trả lời tiếp theo |
| `/usage` | VS Code Chat (Copilot harness) | trả link tới dashboard |

**Nếu làm sai:** coi mọi báo lỗi là bug thì bạn mở ticket sai — công-tơ giúp tách hai ca na ná nhau: *quota exhausted* (đổi model rẻ hoặc chờ reset) và *model unavailable* (đổi model khác, vẫn lỗi thì báo admin); đọc message mất 10 giây, mở ticket sai mất cả buổi.

## Cách dùng

Dashboard trên GitHub.com là đường ngắn nhất; CLI vừa báo mức tiêu vừa đặt cap mềm:

```sh
github.com/settings/copilot → Plan & usage   # đã dùng / còn lại / ngày reset
/limits set max-ai-credits 150               # CLI: cap lượt trả lời tiếp theo
```

- **Biến thể:** plan cá nhân Free / Pro / Pro+ / **Max**; enterprise dùng **Bundled AI credits budget** kèm *"Stop usage when budget limit is reached"*; code review tính theo **review effort** (Lite / Balanced / Max).
- **Setting:** `--max-session-credits` — cap cho **cả phiên** (khác `/limits` chỉ cap lượt tiếp theo).
- **✅ Verify:** nói được một câu "còn X credit, đủ/không đủ tới ngày reset" — không phải "ừ chắc ổn"; nhớ dashboard có độ trễ so với phiên vừa chạy.

## Liên quan

- Việc nhẹ thì đổi model rẻ cho đỡ đốt credits: [model-picker](../model-picker/README.md) · tài khoản/plan: [status](../../system-knowledge/status/README.md) · bài giá chi tiết: [14-models-chon-model-dung.md](../../../../14-models-chon-model-dung.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [GitHub Docs — Models and pricing](https://docs.github.com/en/copilot/reference/copilot-billing/models-and-pricing) · [VS Code Docs — Monitor your usage](https://code.visualstudio.com/docs/agents/guides/optimize-usage#monitor-your-usage)
