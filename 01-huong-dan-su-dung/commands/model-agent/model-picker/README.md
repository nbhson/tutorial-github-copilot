# /model — Đổi model giữa chat

> **Dành cho:** người muốn cân giữa chất lượng trả lời và AI Credits · **Đọc xong:** đổi model đúng lúc, biết khi nào thật sự cần model mạnh (~2 phút)

## 1 câu nôm na

Đang ăn giữa bữa mà món khó quá thì gọi bếp trưởng, món dễ để bếp phụ làm là đủ. `/model` mở danh sách model để bạn đổi ngay giữa cuộc chat: việc nhẹ chọn model nhẹ cho đỡ tốn AI Credits, việc khó mới gọi model mạnh.

So với gõ tay một prompt mới trong chat cũ: ở đây bạn đổi hẳn "bộ não" đang trả lời, không phải nhồi thêm ngữ cảnh. Đổi model rẻ cho việc rẻ, giữ model mạnh cho việc thật sự khó.

## Vì sao dùng /model?

Mặc định "để model mạnh cho chắc" là cách đốt AI Credits nhanh nhất — giá giữa model rẻ nhất và đắt nhất chênh nhau rất nhiều lần. Đổi model theo cỡ việc thường tiết kiệm hơn cả việc ngồi tối ưu prompt.

Ba lựa chọn trong danh sách, chọn theo độ khó task:

| Lựa chọn | Đặc điểm | Khi nào dùng |
|---|---|---|
| Model rẻ (nhẹ) | Trả lời nhanh, tốn ít AI Credits | Việc nhẹ: explain/doc, hỏi đáp, sửa nhỏ |
| Model mạnh | Chất lượng cao hơn, tốn nhiều AI Credits | Việc khó: agent, kiến trúc, debug lạ |
| Auto | Copilot tự chọn model theo độ khó task | Khi chưa chắc — để Copilot cân, khỏi phải nghĩ |

**Nếu làm sai thì sao?** Đổi model không cứu được một prompt thiếu scope. Nếu câu trả lời dở vì bạn không nói rõ file/ngữ cảnh, thì model mạnh nhất cũng chỉ đoán mò — chỉ tốn thêm tiền.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** việc nhẹ (explain/doc/ hỏi đáp) muốn dùng model rẻ cho đỡ tốn quota; việc khó (agent/kiến trúc/debug lạ) cần model mạnh; hoặc model đang chạy trả lời dở và bạn muốn thử "bộ não" khác.
- **ĐỪNG đổi model khi:** bạn chưa gắn scope. Gọn ngữ cảnh trước (`#file`/`@workspace`), rồi mới tính đổi model.
- **Cho ai:** mọi người dùng Chat — nhất là người tự trả tiền theo usage (AI Credits).

## Cách gọi (copy-paste)

```bash
/model
# chọn trong list: rẻ cho việc nhẹ, mạnh cho việc khó
# Kỳ vọng: câu trả lời khớp độ khó của task, quota không phí
# Verify: so 2 câu trả lời rẻ vs mạnh cho cùng prompt
```

> Không thấy `/model` trong danh sách khi gõ `/`? Xem `/status` và plan trước khi kết luận lỗi công cụ — Free/Student chỉ có Auto, không hiện picker tay.

## Ví dụ thật

Nghiệp vụ: bạn hỏi model rẻ cách tách module thanh toán thành event-driven, nhận câu trả lời chung chung, không đụng tới codebase thật.

```bash
# 1. Hỏi model rẻ -> câu trả lời generic
# 2. Đổi sang model mạnh cho đúng câu kiến trúc vừa fail
/model → chọn model mạnh
"#file:src/payments/router.ts + #file:src/events/bus.ts — đề xuất cách tách thanh toán
sang event-driven, giữ API hiện tại, chỉ ra 3 rủi ro migration"
# 3. Sau khi xong, đổi lại model rẻ cho các câu hỏi vụn tiếp theo
```

**Kết quả mong đợi:** Câu trả lời cấp kiến trúc có bám file thật, nêu rủi ro; các câu hỏi vặt sau đó vẫn đi model rẻ nên quota không bị đốt vô ích.

**✅ Verify:** So hai câu trả lời rẻ vs mạnh cho **cùng một prompt** — thấy được lúc nào cần mạnh là bạn dùng đúng.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — đổi model mạnh để "chữa" một prompt thiếu scope:**

```bash
# câu hỏi: "sửa bug login giúp tôi"
/model → model mạnh   # vẫn dở vì model không biết login nằm ở đâu
```

**✅ ĐÚNG — khóa scope trước, đổi model sau:**

```bash
"#file:src/auth/login.ts — login email có dấu bị trả 500, tìm nguyên nhân, giữ API shape"
/model → model mạnh   # model mạnh giờ có ngữ cảnh để làm việc
```

**Bài học:** Model là bộ não, scope là đề bài. Bộ não xịn mà đề bài trống thì vẫn ra đáp án trống.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Đổi model mà vẫn dở | Vấn đề ở scope, không phải model | Gọn scope (`#file`) trước, đổi model sau |
| Model cần không có trong list | Plan/BYOK gating | Hỏi admin plan + BYOK list |
| Dùng model mạnh cho mọi việc | Tốn quota | Rẻ mặc định; mạnh chỉ khi khó |

## So sánh với Claude Code

| Việc | Copilot (`/model`) | Claude Code | Ghi chú |
|---|---|---|---|
| Đổi model giữa phiên | Picker trong Chat: GPT / Claude / Gemini | `/model` xoay trong các model Anthropic | Copilot cho chọn "nhiều nhà"; Claude Code nhất quán một nhà |
| Tiêu chí chọn | Rẻ cho việc nhẹ, mạnh cho việc khó, hoặc Auto | Tùy model Anthropic bạn chọn | Cùng triết lý: đừng dùng model đắt cho việc rẻ |
| Ghi nhớ lựa chọn | Đặt default model trong settings team | Cấu hình trong `settings.json` | Cả hai đều cho team chốt model mặc định |

## Best practices (kèm "vì sao")

- **Rẻ làm mặc định, mạnh chỉ khi cần.** *Vì sao?* Giá chênh nhau nhiều lần; task giải thích code không cần model đắt nhất.
- **Đổi model *sau* khi đã gắn scope.** *Vì sao?* Model mạnh vẫn đoán mò nếu thiếu ngữ cảnh — scope trước, model sau.
- **Việc khó thì ghi lý do đổi model.** *Vì sao?* Cuối tuần nhìn dashboard bạn biết model mạnh tốn ở đâu, có chính đáng không.
- **Xem quota định kỳ để chỉnh thói quen.** *Vì sao?* Biết model nào ngốn nhiều nhất giúp bạn sửa hành vi, thay vì sửa bảng giá (bạn không sửa được).

## Bài tập nhỏ

1. **(5 phút)** Đặt cùng một câu hỏi kiến trúc cho model rẻ rồi model mạnh, dán hai câu trả lời cạnh nhau. Ghi lại khác biệt đáng giá thật sự là gì.
2. **(5 phút)** Trong một buổi làm việc, cố gắng giữ model rẻ cho mọi việc giải thích và chỉ đổi mạnh đúng 1 lần. Mở `github.com/settings/copilot` xem credits tiêu hao.
3. **(5 phút)** Thử để Auto chạy hết một task nhiều bước, xem Copilot chọn model ra sao so với cách bạn chọn tay.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Model & Agent.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Xem tiền đã tiêu: [../premium-requests/README.md](../premium-requests/README.md). Chọn "nơi chạy" (khác model): [../session-target/README.md](../session-target/README.md).

> Model chỉ là "bộ não" — đổi não không cứu được một đề bài thiếu scope. Gọn đề bài trước, đổi model sau.
