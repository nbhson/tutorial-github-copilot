# /doc — Sinh docstring/JSDoc trong 1 nốt

> **Dành cho:** dev vừa viết xong hàm public · **Vấn đề:** docs thiếu params/example nên người khác không dám dùng · **Đọc xong:** ra docstring/JSDoc đủ @param/@returns/example chạy được (~2 phút)

## 1 câu nôm na

Nhờ viết "nhãn mác cho lọ thuốc" — tên, công dụng, cách dùng, ví dụ. Bạn bôi đen hàm rồi gọi `/doc`, nó viết docstring theo chuẩn repo; việc bạn phải nhớ là **chạy lại mỗi khi đổi signature**, không thì docs sẽ dần nói sai params.

## Vì sao dùng /doc?

Docs viết tay hay bị bỏ qua, mà khi có thì thường thiếu đúng phần người khác cần nhất: ví dụ chạy được. `/doc` không chỉ điền `@param`/`@returns` mà còn sinh một example copy-paste chạy thử được — chính phần đó biến docs từ "trang trí" thành "hướng dẫn". Hàm public càng nhiều người dùng, docs rõ càng đỡ tốn thời gian trả lời hỏi han.

**Nếu làm sai thì sao?** Mặt trái nguy hiểm là **docs cũ nhưng nghe rất chắc**: bạn đổi tham số, docs vẫn mô tả tham số cũ, người sau làm theo rồi dính bug. Một example trong docs mà chạy không được còn tệ hơn không có example, vì nó tạo niềm tin sai. Vì vậy sau mỗi lần đổi signature phải regen `/doc` (xem mục ❌/✅).

## Khi nào dùng / khi nào đừng

- **Dùng khi:** bạn vừa viết hàm public cần docs chuẩn, cần chuẩn hóa docs cũ thiếu params/example, hoặc muốn onboard dễ (đọc docs là hiểu module).
- **ĐỪNG dùng khi:** hàm private/đơn giản mà tên đã nói hết (`getUserId()` thì khỏi), hoặc bạn cần *hiểu* code chứ không phải *viết docs* (đó là `/explain`).
- **Cho ai:** người giữ API/hàm public, team đang chuẩn hóa docs cho module cũ.

## Cách gọi (copy-paste)

```bash
# Bôi đen hàm, rồi:
/doc

# Hoặc nói rõ cần gì:
/doc viết JSDoc gồm params + example
# Kỳ vọng: docstring đủ @param/@returns + example chạy được
```

> `/doc` không xuất hiện khi gõ `/` trong Chat? Kiểm tra `/status` + xem plan trước khi kết luận lệnh lỗi.

## Ví dụ thật

Nghiệp vụ: `parseInvoiceNumber()` trong `src/billing/` vừa được refactor, người khác muốn dùng lại nhưng docs cũ đã lệch.

```bash
# 1. Bôi đen hàm parseInvoiceNumber()
# 2. Gọi:
/doc "viết JSDoc: mô tả, @param, @returns, @throws + 1 example chạy được"
# Verify: copy example trong docs chạy thử — chạy được là đạt
```

**Kết quả mong đợi:** docstring đúng chuẩn repo (params/returns/example), và example trong docs copy ra chạy được.

**✅ Verify:** copy nguyên example trong docs vào một snippet chạy thử — chạy được và ra kết quả đúng là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — sinh docs một lần rồi quên; đổi signature mà không regen:**

```bash
/doc "viết mô tả cho hàm"
# -> @param invoiceNumber {string}  trong khi code đã nhận {number}; không có example
```

**✅ ĐÚNG — nêu chuẩn rõ + regen sau mỗi lần đổi signature:**

```bash
/doc "viết JSDoc: mô tả + @param + @returns + @throws + 1 example chạy được, theo style module billing"
```

**Bài học:** docs sai params nguy hiểm hơn không có docs — regen `/doc` ngay sau khi hàm thay đổi.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Docs chung chung, thiếu example | Prompt thiếu yêu cầu example | Thêm "gồm 1 example chạy được" |
| Docs sai params | Hàm đổi mà docs cũ | Regen `/doc` sau mỗi lần đổi signature |
| Docs dài hơn code | Cố docs mọi thứ | Chỉ docs cho hàm public/phức tạp |

## So sánh với Claude Code

| Việc | Copilot (`/doc`) | Claude Code | Ghi chú |
|---|---|---|---|
| Sinh docstring/JSDoc | Slash command có sẵn `/doc` | Không có lệnh riêng — yêu cầu bằng prompt hoặc tự tạo command | Cùng kết quả, Copilot có sẵn nút |
| Bám chuẩn docs của repo | Khớp hơn khi bạn nêu file/module mẫu | Agent tự tìm file mẫu trong repo | Cả hai đều cần bạn chỉ chuẩn nếu repo có style đặc thù |
| Kiểm chứng | Bạn chạy thử example trong docs | Bạn vẫn phải chạy thử | Example chạy được mới là docs đáng tin |

## Best practices (kèm "vì sao")

- **Yêu cầu 1 example chạy được, không chỉ mô tả suông.** *Vì sao?* Example là thứ người dùng thật copy ra chạy — nó buộc docs phải khớp code.
- **Regen `/doc` ngay sau khi đổi signature.** *Vì sao?* Docs cũ nói sai params sẽ dẫn người sau vào bug, mà họ lại tin vì "đã có docs".
- **Ghi rõ `@throws` / lỗi có thể xảy ra.** *Vì sao?* Người gọi cần biết khi nào hàm ném lỗi để xử lý, thay vì tự đoán từ code.
- **Chỉ docs hàm public/phức tạp.** *Vì sao?* Docs dài hơn code làm loãng; hàm tự-giải-thích bằng tên thì không cần.

## Bài tập nhỏ

1. **(5 phút)** Chạy `/doc` không yêu cầu example, rồi chạy lại có yêu cầu. So xem lần nào docs dùng được ngay.
2. **(10 phút)** Chọn 1 hàm public: `/doc` rồi copy example trong docs ra chạy thật. Example sai thì sửa lại docs.
3. **(10 phút)** Đổi tên 1 tham số của hàm rồi *không* regen docs — chạy thử example cũ để thấy nó lệch thế nào.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Code Actions.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Cần hiểu code trước khi viết docs: `/explain` — [../explain/README.md](../explain/README.md).

> Chốt: docs của `/doc` chỉ đáng tin khi **example trong đó chạy được** — hãy biến việc copy example ra chạy thành phản xạ sau mỗi lần regen.
