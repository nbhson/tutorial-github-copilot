# /doc — Sinh docstring/JSDoc trong 1 nốt

> **Dành cho:** dev vừa viết xong hàm public · **Vấn đề:** docs thiếu params/example nên người khác không dám dùng · **Đọc xong:** ra docstring/JSDoc đủ @param/@returns/example chạy được (~2 phút)

## Lệnh làm gì (1 câu nôm na)

Nôm na: nhờ viết nhãn mác cho lọ thuốc — tên, công dụng, cách dùng, ví dụ. Bôi đen hàm rồi `/doc`; sau mỗi lần đổi signature hãy chạy lại để docs không sai.

## Khi nào dùng

Section này trả lời: hàm nào cần docs, và làm sao để docs không chung chung hay sai params.

- **Cho ai:** người giữ API/hàm public, team đang chuẩn hóa docs cho module cũ.
- Vừa viết hàm public, cần docs chuẩn.
- Chuẩn hóa docs cũ thiếu params/example.
- Onboard: đọc docs là hiểu module.

## Cách gọi (copy-paste)

Cách gọi `/doc` — làm đúng theo khối dưới đây, kèm câu kiểm tra lệnh có ở máy bạn hay không:

```bash
Bôi đen hàm → /doc
/doc viết JSDoc gồm params + example
# Kỳ vọng: docstring đủ @param/@returns + example chạy được
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/doc`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

Prompt mẫu cho `/doc` — đổi phần tên file/task cho đúng việc của bạn:

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
(bôi đen hàm parse) /doc “viết JSDoc: mô tả, @param, @returns, 1 example chạy được”
# Verify: copy example trong docs chạy thử — chạy được là đạt
```

**Kết quả mong đợi:** Docstring đúng chuẩn repo (params/returns/example); example copy chạy được.

**Cách verify:** Chạy thử example trong docs — chạy được là đạt.

## Lỗi thường gặp

Ba triệu chứng hay gặp nhất với lệnh này — kèm nhanh cách xử lý:

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Docs chung chung, thiếu example | Prompt thiếu yêu cầu example | Thêm “gồm 1 example chạy được” |
| Docs sai params | Hàm đổi mà docs cũ | Regen /doc sau mỗi lần đổi signature |
| Docs dài hơn code | Tham mọi thứ | Chỉ docs cho hàm public/phức tạp |

## Tham khảo

Liên quan — index nhóm, cheatsheet 1 trang và FAQ phòng khi kẹt:

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
