# 14-6 · Năm mẹo kiềm AI Credits — mỗi mẹo là một hành động

> Đồng hành với [bài 14 §4](../../14-models-chon-model-dung.md#4-ai-credits--bản-đồ-chi-phí).
> Chuyển ra từ phần "mẹo" của bài 14 cũ. Thứ tự = độ hiệu quả giảm dần, theo
> công thức chi phí: **tiền = tokens × giá per-token**, nên mọi mẹo dưới đây
> chỉ cắt một trong hai thừa số — không mẹo nào cần đổi gói.

## 1. Reset session mỗi khi đổi việc (cắt context — thừa số ăn nhiều nhất)

Context là phí "mồ côi" lớn nhất: mỗi request gửi lại toàn bộ lịch sử. Session
30 phút debug A, rồi hỏi sang B → bạn trả tiền cho A trong từng request của B.

```text
Xong mot viec -> /clear (CLI) hoac New Chat (VS Code) roi hoi tiep
```

Tiết kiệm bao nhiêu? Nếu lịch sử chiếm ~10k tokens và bạn chạy 20 request,
đó là 200k tokens "mồ côi" — thường nhiều hơn cả phần việc mới.

## 2. Effort medium cho phần lớn việc — chỉ nâng khi thấy model "trả lời hờ"

Nâng 1 bậc effort thường tốn kém hơn đổi sang model cùng bậc giá (bài 14 §3,
định luật 1). Dấu hiệu nên nâng: model trả lời đúng hướng nhưng thiếu bước
trung gian. Dấu hiệu KHÔNG nên nâng: bạn chỉ đang thiếu ngữ cảnh trong prompt.

## 3. Gắn file, đừng dán cả repo

Attach đúng file liên quan (`@file`, `#code`) thay vì thêm thư mục lớn vào
context. Mỗi file thừa trong context là tiền trả mỗi lượt, không phải một lần.

## 4. Chạy `auto` trước, chỉnh sau

Auto chọn theo ba tầng (Efficiency / Balance / Intelligence) và mang giá ưu
đãi so với đích danh model cùng hàng (docs ghi ~10%). Quy trình rẻ nhất:
auto → đọc kết quả → nếu chưa đạt mới nâng đúng một bậc (model hoặc effort),
không nâng cả hai cùng lúc.

## 5. BYOK cho lúc thử nghiệm model lạ

Thử 5 model mới để chọn công cụ? Dùng API key BYOK: request đi thẳng provider,
**0 credits của gói** — bạn chỉ trả provider theo bảng giá của họ. Việc sản xuất
chính vẫn chạy model trong gói để hóa đơn gọn một chỗ (bài 14 §6).

## Một dòng để nhớ

> Credits chỉ giảm khi bạn cắt **tokens** hoặc **giá per-token**; mọi mẹo trên
> đều làm đúng một trong hai chuyện đó — thứ gì không đụng hai thừa số này
> (đổi giao diện, đổi surface, đổi prompt lịch sự hơn) không phải mẹo tiết kiệm.

## Reference

- [Auto model selection](https://docs.github.com/en/copilot/concepts/models/auto-model-selection)
- [Bring your own model key](https://docs.github.com/en/copilot/concepts/models/bring-your-own-key)
