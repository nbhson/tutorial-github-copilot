# Model picker — Đổi model giữa chat

> **Dành cho:** người muốn cân giữa chất lượng trả lời và AI Credits · **Đọc xong:** đổi model đúng lúc, biết khi nào thật sự cần model mạnh (~2 phút)
> **Harness:** Copilot · **Surface:** VS Code Chat (Copilot harness) / Agents window / Copilot CLI

## 1 câu nôm na

Đang ăn giữa bữa mà món khó quá thì gọi bếp trưởng, món dễ để bếp phụ làm là đủ. Model picker mở danh sách model để bạn đổi ngay giữa cuộc chat: việc nhẹ chọn model nhẹ cho đỡ tốn AI Credits, việc khó mới gọi model mạnh. So với gõ prompt mới trong chat cũ, ở đây bạn đổi hẳn "bộ não" đang trả lời.

## Ba cách mở, ba surface khác nhau

| Cách gọi | Surface | Ghi chú |
|---|---|---|
| Dropdown model ở đáy Chat view / Agents window | VS Code Chat (Copilot harness) | đường chuẩn; danh sách model do plan + chính sách org quyết định |
| `/models` | VS Code Chat (Local harness) | docs VS Code gắn lệnh này cho local chat |
| `/model [MODEL\|auto TIER]` · `/models` | Copilot CLI | thêm `--session` / `--global` / `--repo` / `--local` để chọn phạm vi lưu |

## Vì sao dùng model picker?

Mặc định "để model mạnh cho chắc" là cách đốt AI Credits nhanh nhất — giá giữa model rẻ nhất và đắt nhất chênh nhau rất nhiều lần. Đổi model theo cỡ việc thường tiết kiệm hơn cả việc ngồi tối ưu prompt.

| Loại | Đặc điểm | Khi nào dùng |
|---|---|---|
| Model nhẹ | Trả lời nhanh, tốn ít AI Credits | Việc nhẹ: explain/doc, hỏi đáp, sửa nhỏ |
| Model mạnh | Chất lượng cao hơn, tốn nhiều AI Credits | Việc khó: agent, kiến trúc, debug lạ |
| Auto | Copilot tự chọn model theo độ khó task | Khi chưa chắc — để Copilot cân, khỏi phải nghĩ |

**Nếu làm sai thì sao?** Đổi model không cứu được một prompt thiếu scope. Nếu câu trả lời dở vì bạn không nói rõ file/ngữ cảnh, model mạnh nhất cũng chỉ đoán mò — chỉ tốn thêm tiền.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** việc nhẹ muốn model rẻ cho đỡ tốn credits; việc khó cần model mạnh; hoặc model đang chạy trả lời dở và bạn muốn thử "bộ não" khác.
- **ĐỪNG đổi model khi:** bạn chưa gắn scope — gọn ngữ cảnh trước (`#file:` / `#codebase`), rồi mới tính chuyện đổi model.

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

## Ví dụ thật

Nghiệp vụ: bạn hỏi model rẻ cách tách module thanh toán thành event-driven, nhận câu trả lời chung chung, không đụng tới codebase thật.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh)

**Kết quả mong đợi:** câu trả lời cấp kiến trúc có bám file thật, nêu rủi ro; các câu hỏi vặt sau đó vẫn đi model rẻ nên credits không bị đốt vô ích.

**✅ Verify:** so hai câu trả lời rẻ vs mạnh cho **cùng một prompt** — thấy được lúc nào cần mạnh là bạn dùng đúng.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — đổi model mạnh để "chữa" một prompt thiếu scope:**

> 📄 **Code ví dụ:** [`examples/03-neu-lam-sai-thi-sao-sai-ung.sh`](examples/03-neu-lam-sai-thi-sao-sai-ung.sh)

**✅ ĐÚNG — khóa scope trước, đổi model sau:**

> 📄 **Code ví dụ:** [`examples/04-neu-lam-sai-thi-sao-sai-ung.sh`](examples/04-neu-lam-sai-thi-sao-sai-ung.sh)

**Bài học:** Model là bộ não, scope là đề bài. Bộ não xịn mà đề bài trống thì vẫn ra đáp án trống.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Đổi model mà vẫn dở | Vấn đề ở scope, không phải model | Gọn scope (`#file:`) trước, đổi model sau |
| Model cần không có trong list | Plan / chính sách org / BYOK gating | Hỏi admin về plan + danh sách model được phép |
| Dùng model mạnh cho mọi việc | Tốn credits | Rẻ mặc định; mạnh chỉ khi khó |
| Gõ `/model` trong Chat view không có gì | Slash đó thuộc CLI; local chat dùng `/models` | Dùng dropdown model ở Copilot harness |
| Chỉ còn Auto, không có picker | Plan free / chính sách org thu hẹp danh sách model | Xem Copilot status dashboard ([../../system-knowledge/status/README.md](../../system-knowledge/status/README.md)) rồi hỏi admin plan |

## So sánh với Claude Code

| Việc | Copilot | Claude Code | Ghi chú |
|---|---|---|---|
| Đổi model giữa phiên | Dropdown trong Chat view; `/model` ở CLI | `/model` xoay trong các model của Anthropic | Copilot liệt kê nhiều nhà cung cấp; Claude Code một nhà |

## Best practices (kèm "vì sao")

- **Rẻ làm mặc định, mạnh chỉ khi cần.** *Vì sao?* Giá chênh nhau nhiều lần; task giải thích code không cần model đắt nhất.
- **Đổi model *sau* khi đã gắn scope.** *Vì sao?* Model mạnh vẫn đoán mò nếu thiếu ngữ cảnh — scope trước, model sau.
- **Xem credits định kỳ để chỉnh thói quen.** *Vì sao?* Biết model nào ngốn nhiều nhất giúp bạn sửa hành vi, thay vì sửa bảng giá (bạn không sửa được).

## Bài tập nhỏ

1. **(5 phút)** Đặt cùng một câu hỏi kiến trúc cho model rẻ rồi model mạnh, dán hai câu trả lời cạnh nhau. Ghi lại khác biệt đáng giá thật sự là gì.
2. **(5 phút)** Giữ model rẻ cho mọi việc giải thích trong một buổi, chỉ đổi mạnh đúng 1 lần. Mở `github.com/settings/copilot` xem credits tiêu hao.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Model & Agent.
- Chi phí & AI Credits: [../ai-credits/README.md](../ai-credits/README.md) · Chọn "nơi chạy" (khác model): [../session-target/README.md](../session-target/README.md).
- Cheatsheet 1 trang: [CHEATSHEET.md](../../../../../CHEATSHEET.md) · Kẹt thì tra [FAQ troubleshooting](../../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- VS Code — [Language models](https://code.visualstudio.com/docs/agent-customization/language-models) · GitHub — [Bring your own key](https://docs.github.com/en/copilot/concepts/models/bring-your-own-key) · [CLI command reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference).

> Model chỉ là "bộ não" — đổi não không cứu được một đề bài thiếu scope. Gọn đề bài trước, đổi model sau.
