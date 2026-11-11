# 14-2 · Plan nào được bao nhiêu AI Credits?

> Đồng hành với [bài 14 §4](../../14-models-chon-model-dung.md#4-ai-credits--bản-đồ-chi-phí).
> Bảng này chuyển ra từ bài 14 cũ để phần đọc liền mạch ngắn lại — mọi con số
> kiểm tra lại theo đường dẫn ở cuối file, GitHub đổi thường xuyên.

## Bảng plan — hạn mức — hết hạn mức thì sao

| Plan | Hạn mức / tháng | Hết hạn mức thì còn gì | Ghi chú |
|---|---|---|---|
| Free | hạn mức requests miễn phí (GitHub không công bố con số credits cố định) | model `auto` (loại request được hỗ trợ) | + 2.000 inline completions/tháng |
| Pro | 1.500 credits (1.000 + 500 flex) | `auto` vẫn chạy, hoặc bật pay-per-use | completions không trừ credits |
| Pro+ | 7.000 credits | như Pro | quyền model cao cấp hơn Pro |
| Max | 20.000 credits | như Pro | hạn mức cá nhân cao nhất |
| Business | 1.900 credits / seat | org bật budget hoặc admin tăng limit | seat tự nâng cấp, tính theo ngày |
| Enterprise | 3.900 credits / seat | như Business | qua Azure Entra / SAML |

Ba điều đọc bảng này hay nhầm:

- **Inline completions không bị tính** bằng credits — gõ code suggestion
  thoải mái, chỉ chat/agent request mới trừ (docs: *"not billed against AI
  credits"*).
- **Hết credits ≠ mất Copilot.** `auto` vẫn phục vụ; cái bạn mất là quyền
  chọn model cụ thể.
- **1 credit = $0,01.** Thấy con số credits lớn thì chia 100 cho dễ hình
  dung: 1.500 credits ≈ $15 tiền model, trên giá gói $10.

## Bài 14 §2 dùng bảng này lúc nào

Bạn đang cân nhắc lên Pro+ hay mua thêm budget cho team → quy đổi job thực
tế của bạn ra credits bằng công thức bài 14 §4, đối chiếu cột hạn mức. Ví dụ
team 5 người hay refactor: 5 × 1.900 (Business) = 9.500 credits/tháng, trong
khi 1 refactor ≈ 350 credits (ước lượng) → cân được khoảng 27 refactor trước
khi chạm hạn mức. Con số giả định — chạy thử một tuần với
[`/model` chọn Auto](../../commands/copilot/model-agent/model-picker/README.md)
rồi đọc số liệu thật ở portal (link bên dưới).

## Reference

- [Plans and pricing for GitHub Copilot](https://github.com/features/copilot/plans)
- [Usage-based billing for individuals](https://docs.github.com/en/copilot/concepts/billing-and-usage/individuals/billing)
- [About individual plans and allowances](https://docs.github.com/en/copilot/concepts/billing-and-usage/individuals/usage-limits)
- [Copilot settings](https://github.com/copilot/settings) — xem số credits
  đã tiêu thụ của bạn
