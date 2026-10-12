# Attach / #file — Gắn đúng scope vào prompt

> **Dành cho:** mọi người prompt về code, nhất là người mới · **Vấn đề:** không gắn scope thì model đoán mò, sửa sai file · **Đọc xong:** gắn đúng 1–3 file mỗi prompt, trả lời trúng hơn với ít token hơn (~2 phút)

## 1 câu nôm na

Kẹp tài liệu vào câu hỏi — hỏi về file nào thì kẹp file đó vào. Dùng `#file` để chọn một file cụ thể, `@workspace` để hỏi quan hệ xuyên file, hoặc kéo-thả file/ảnh vào ô Chat input.

Khác với gõ tên file bằng chữ ("hàm trong login.ts"): attach đưa **nội dung thật** vào context, model không phải đoán và bạn không phải mô tả lại.

## Vì sao dùng Attach / #file?

Đây có lẽ là kỹ năng quan trọng nhất với người mới: model không tự "nhìn thấy" repo của bạn. Không gắn scope thì nó đoán mò. Attach giúp:

- **Trả lời trúng** — model đọc đúng file bạn quan tâm.
- **Ít token hơn** — đưa 1–3 file thay vì cả repo.
- **Ít sửa sai hơn** — scope càng hẹp, diff càng đúng chỗ.

**Nếu làm sai thì sao?** Hai cực đều hại: (1) quên attach nên model đoán mò; (2) attach cả repo nên chậm và tốn token. Thêm rủi ro âm thầm: attach file chứa token mà không soát. Xem ❌/✅ và bảng chọn cách gắn scope.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** mọi prompt về code (bắt buộc gắn scope); muốn model đọc đúng file thay vì đoán; cần đính kèm ảnh lỗi UI hoặc log terminal.
- **ĐỪNG dùng khi:** câu hỏi hoàn toàn ngoài code (định nghĩa chung, cú pháp ngôn ngữ) — attach chỉ thêm nhiễu.
- **Cho ai:** mọi mức độ kinh nghiệm — đây là kỹ năng quan trọng nhất với người mới dùng Copilot.

> Chọn nhanh cách gắn scope:

| Cách | Hỏi được gì | Khi nào dùng |
|---|---|---|
| `#file` | Đúng 1 file cụ thể | Sửa/hỏi trong phạm vi 1 file, cần chính xác cao |
| `@workspace` | Quan hệ xuyên file trong repo | "Hàm này ai gọi", tìm định nghĩa rải nhiều file |
| Kéo-thả file/ảnh | File/ảnh ngoài editor (log, ảnh UI) | Cần đưa bằng chứng log/screenshot cho model |

## Cách gọi (copy-paste)

```bash
#file → chọn file
@workspace → hỏi cross-file
Kéo-thả file/ảnh vào Chat input
# Verify: model nhắc được tên file đã đọc trong câu trả lời
```

> Kiểm tra: gõ `#` trong ô Chat xem có gợi ý file không; gõ `@` xem có `@workspace` không. Thiếu → kiểm tra extension Copilot Chat đã bật.

## Ví dụ thật

Nghiệp vụ: bạn cần biết field `customerId` được đọc/ghi ở đâu trong repo trước khi đổi kiểu dữ liệu của nó, và muốn model xác nhận đã đọc đúng file trung tâm.

```bash
@workspace "customerId duoc doc/ghi o nhung file nao? ham nao tao ra no?" + attach #file src/models/customer.ts
# Verify: bat model "liet ke file may da doc" -> khop file ban gan
```

**Kết quả mong đợi:** Model liệt kê đúng file đã đọc + trả lời trúng scope; không sửa sai file.

**✅ Verify:** Bắt model "liệt kê file mày đã đọc" — khớp file bạn gắn là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — quên attach, hoặc attach cả repo cho một câu hỏi nhỏ:**

```bash
# (khong attach) "sua loi o ham login giup toi"        -> model doan mo
# @workspace ca repo cho cau hoi 1 file              -> cham + ton token
```

**✅ ĐÚNG — gắn đúng 1–3 file liên quan nhất, chỉ rõ muốn model đọc gì:**

```bash
#file src/auth/login.ts "giai thich nhanh if trong ham nay, chi doc file nay"
```

**Bài học:** Scope vừa đủ là 1–3 file liên quan nhất. Rộng quá tốn token, hẹp quá thì model thiếu dữ liệu — cân theo câu hỏi.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Attach cả repo → chậm + tốn token | Scope quá rộng | Chỉ gắn 1–3 file liên quan nhất |
| Quên attach → model đoán mò | Tưởng model tự đọc cả repo | Luôn gắn `#file` hoặc `@workspace` |
| Attach file chứa secret | Soát không kỹ | Kiểm tra file trước khi attach/share/export |

## So sánh với Claude Code

| Việc | Copilot (`Attach / #file`) | Claude Code | Ghi chú |
|---|---|---|---|
| Đưa file vào context | `#file`, `@workspace`, kéo-thả | `@file` hoặc để agent tự đọc | Cùng tư tưởng: đưa đúng file, đừng cả repo |
| Hỏi quan hệ xuyên file | `@workspace` | Agent tự search trong repo | Copilot cần bạn chỉ; Claude Code agentic hơn |
| Đính kèm ảnh/log | Kéo-thả file/ảnh vào Chat | Đưa qua prompt/file | Copilot có kéo-thả trong IDE |

## Best practices (kèm "vì sao")

- **Mỗi prompt code đều phải có scope.** *Vì sao?* Model không tự thấy repo; thiếu scope là nguyên nhân số 1 của "sửa sai file".
- **Giữ 1–3 file, không attach cả repo.** *Vì sao?* Context rộng làm chậm và loãng trọng tâm.
- **Soát secret trước khi attach.** *Vì sao?* File attach có thể đi vào export/share; kiểm trước rẻ hơn gỡ sau.
- **Dùng `@workspace` khi câu hỏi là "ở đâu / ai gọi".** *Vì sao?* Câu hỏi quan hệ xuyên file cần tìm trong cả repo, không nằm trong một file.

## Bài tập nhỏ

1. **(3 phút)** Hỏi cùng một câu về `src/auth/login.ts` hai lần: một lần không attach, một lần `#file` — so sánh độ trúng.
2. **(5 phút)** Dùng `@workspace` hỏi "hàm X được gọi ở đâu", rồi bắt model liệt kê file đã đọc để kiểm chứng.
3. **(5 phút)** Attach cả repo cho một câu hỏi nhỏ, đo thời gian phản hồi; rồi làm lại với 1–3 file để thấy chênh lệch.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Chat Session.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Sửa tại chỗ sau khi gắn scope: [../inline-chat/README.md](../inline-chat/README.md). Lưu ý secret: [../export/README.md](../export/README.md).

> Gắn scope không phải thao tác phụ — nó là phần lớn của một prompt tốt. Hỏi về file nào, kẹp file đó; đừng để model đoán.
