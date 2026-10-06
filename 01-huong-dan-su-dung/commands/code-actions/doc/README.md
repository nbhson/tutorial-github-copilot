# /doc — Sinh docstring/JSDoc trong 1 nốt

> Nôm na: nhờ viết nhãn mác cho lọ thuốc — tên, công dụng, cách dùng, ví dụ.

## Lệnh làm gì (1 câu nôm na)

Nôm na: nhờ viết nhãn mác cho lọ thuốc — tên, công dụng, cách dùng, ví dụ. Thuộc nhóm lệnh dùng hàng ngày — gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

- Vừa viết hàm public, cần docs chuẩn.
- Chuẩn hóa docs cũ thiếu params/example.
- Onboard: đọc docs là hiểu module.

## Cách gọi (copy-paste)

```bash
Bôi đen hàm → /doc
/doc viết JSDoc gồm params + example
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/doc`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
(bôi đen hàm parse) /doc “viết JSDoc: mô tả, @param, @returns, 1 example chạy được”
```

**Kết quả mong đợi:** Docstring đúng chuẩn repo (params/returns/example); example copy chạy được.

**Cách verify:** Chạy thử example trong docs — chạy được là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Docs chung chung, thiếu example | Prompt thiếu yêu cầu example | Thêm “gồm 1 example chạy được” |
| Docs sai params | Hàm đổi mà docs cũ | Regen /doc sau mỗi lần đổi signature |
| Docs dài hơn code | Tham mọi thứ | Chỉ docs cho hàm public/phức tạp |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
