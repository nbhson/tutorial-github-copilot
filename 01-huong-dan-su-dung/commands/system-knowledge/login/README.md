# /login — Đăng nhập GitHub cho Copilot

> **Dành cho:** người mới cài, người đổi máy hoặc đổi account · **Vấn đề:** token hết hạn làm Copilot im lặng, không gợi ý gì · **Đọc xong:** đăng nhập đúng account và tự verify bằng `/status` (~2 phút)

## 1 câu nôm na

`/login` giống như xuất trình thẻ nhân viên để vào tòa nhà. Bạn gọi lệnh, làm theo popup đăng nhập GitHub, rồi kiểm tra lại bằng `/status`. Nếu máy có hai account (cá nhân + công ty), hãy logout trước rồi login lại đúng account bạn cần.

## Vì sao dùng /login?

Vì Copilot im lặng khi token hết hạn hoặc khi bạn login sai account — không có thông báo rõ ràng, chỉ là không thấy gợi ý nào. `/login` là cách nhanh nhất để cấp lại quyền, và verify bằng `/status` để chắc chắn đã vào đúng account/plan.

**Nếu làm sai thì sao?** Login xong vẫn không có gợi ý là chuyện thường, vì còn hai nguyên nhân khác: chưa được cấp seat, hoặc file bị content exclusion. Đừng vội kết luận "login hỏng" — kiểm tra tiếp seat + exclusion + `/status`.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** mới cài / đổi máy; token hết hạn (Copilot silent fail); đổi account cá nhân ↔ công ty.
- **ĐỪNG dùng như:** cách để chọn account khi bạn có hai account mà chưa logout — cache token cũ dễ khiến bạn đăng nhập nhầm. Hãy [`/logout`](../logout/README.md) trước rồi login lại.

## Cách gọi (copy-paste)

```bash
/login
# làm theo popup GitHub → verify bằng /status
# Kỳ vọng: /status hiện đúng login + plan, gợi ý chạy lại
# Verify: gõ thử 1 hàm thấy gợi ý
```

> Gõ `/` trong Chat để kiểm tra `/login` có trong list không. Không thấy thì xem plan/model trước.

## Ví dụ thật

Nghiệp vụ: sáng nay Copilot không gợi ý gì sau khi bạn đổi sang laptop công ty.

```bash
# 1. /login
# 2. Làm theo popup → sign in đúng account công ty
# 3. /status  → xác nhận login + plan
# 4. Mở 1 file TypeScript, gõ nửa hàm xem ghost text có hiện lại không
```

**Kết quả mong đợi:** Đăng nhập đúng account; `/status` hiện đúng login + plan; gợi ý ghost text chạy lại.

**✅ Verify:** Ghost text + Chat đều chạy sau login là đạt. Chỉ một cái chạy thì xem tiếp seat/exclusion.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

❌ SAI: Máy có 2 account, bạn `/login` luôn mà không logout → đăng nhập nhầm account, sai quota/policy.

✅ ĐÚNG: `/logout` trước → `/login` → làm theo popup đúng account cần dùng → `/status` xác nhận.

**Bài học:** hai account là cái bẫy hay gặp nhất. Thứ tự đúng là logout rồi login, không phải login chồng lên cache cũ.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Login nhầm account | Máy có 2 GitHub account | `/logout` rồi `/login` lại đúng account |
| Popup đăng nhập bị chặn | Browser/proxy chặn popup | Mở browser mặc định, tắt chặn popup tạm thời |
| Login xong vẫn không gợi ý | Chưa có seat / file bị exclusion | Kiểm tra seat + content exclusion + `/status` |

## So sánh với Claude Code

| Việc | Copilot (`/login`) | Claude Code | Ghi chú |
|---|---|---|---|
| Cách xác thực | OAuth qua tài khoản GitHub | Đăng nhập Anthropic hoặc dùng API key | Khác nhà cung cấp, cùng ý tưởng "1 login dùng nhiều bề mặt" |
| Đổi account | Logout rồi login lại | Đổi key/account trong config | Cả hai đều khuyên đổi sạch thay vì chồng |
| Kiểm chứng sau login | `/status` + thử ghost text | Chạy thử một prompt | Bạn vẫn là người verify |

## Best practices (kèm "vì sao")

- **Có 2 account thì logout trước khi login lại.** *Vì sao?* Token cũ còn cache dễ khiến bạn vào nhầm account mà không biết.
- **Login xong luôn chạy `/status`.** *Vì sao?* Đăng nhập "thành công" chưa chắc đúng account/plan — verify mới biết.
- **Popup bị chặn thì đổi browser mặc định.** *Vì sao?* OAuth cần mở đúng URL callback trong browser mặc định; proxy/chặn popup là nguyên nhân phổ biến.
- **Không có gợi ý thì kiểm tra seat + exclusion trước khi login lại.** *Vì sao?* Login đúng rồi mà thiếu seat thì vẫn im lặng — login lại vô ích.

## Bài tập nhỏ

1. **(5 phút)** Chạy `/login` rồi `/status`, ghi lại account/plan. Nếu có 2 account, thử logout rồi login lại account còn lại để thấy khác biệt.
2. **(10 phút)** Mô phỏng lỗi "login xong không gợi ý": kiểm tra seat + content exclusion rồi ghi lại phát hiện.

## Tham khảo

- Index nhóm: [../README.md](../README.md).
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Cài đặt + xác thực chi tiết: [../../../01-cai-dat-va-xac-thuc.md](../../../01-cai-dat-va-xac-thuc.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Chốt: `/login` chỉ là bước mở cửa — nếu đăng nhập đúng rồi mà Copilot vẫn im, vấn đề nằm ở seat hoặc exclusion, đừng quay lại đăng nhập tiếp.
