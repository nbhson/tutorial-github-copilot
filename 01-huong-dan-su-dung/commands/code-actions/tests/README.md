# /tests — Sinh tests theo mẫu repo

> **Dành cho:** dev vừa viết/sửa hàm cần test bao · **Vấn đề:** test sinh ra không khớp framework/mẫu của repo · **Đọc xong:** có file test chạy xanh, cover đúng nhánh vừa sửa (~2 phút)

## 1 câu nôm na

Bảo "viết bài kiểm tra cho bài này, theo đúng mẫu lớp mình". Bạn bôi đen hàm rồi gọi `/tests`; điểm mấu chốt là **nói rõ framework + file test mẫu + cần mock gì** — thiếu mấy thứ đó thì test khó chạy, và dễ trượt thành "test ảo" luôn xanh.

## Vì sao dùng /tests?

Viết test là việc nhàm chán nhưng bắt buộc, và tốn thời gian nhất ở đâu? Ở khâu khung xương: import, `describe/it`, setup mock, teardown. `/tests` đọc hàm bạn chọn rồi dựng sẵn khung đó theo mẫu repo, bạn chỉ còn review và chỉnh case. Lợi thật của nó là **cover đúng nhánh vừa sửa** — viết tay hay bỏ sót đúng nhánh biên (null, rỗng, lỗi mạng), mà bug lại hay nấp ở đó.

**Nếu làm sai thì sao?** Rủi ro lớn nhất là **test ảo**: chỉ `assert true`, hoặc mock tới mức không còn kiểm tra gì thật. Nó chạy xanh, CI báo đẹp, mà bug vẫn nguyên — tệ hơn là không có test, vì bạn tưởng mình đã được bảo vệ. Vì vậy mỗi test phải *fail được* nếu logic sai (xem mục ❌/✅).

## Khi nào dùng / khi nào đừng

- **Dùng khi:** bạn vừa viết/sửa một hàm và cần test bao lại, muốn tăng coverage cho module quan trọng, hoặc cần chuẩn hóa test mới theo mẫu repo.
- **ĐỪNG dùng khi:** bạn cần *sửa code* để test pass (đó là `/fix`), hoặc cần test cho cả một luồng nhiều module (dùng Agent mode có scope).
- **Cho ai:** dev tăng coverage, người cần test đúng mẫu repo trước khi mở PR.

## Cách gọi (copy-paste)

```bash
# Bôi đen hàm, rồi:
/tests

# Nói rõ framework + mẫu + mock:
/tests sinh test theo mẫu repo, mock DB
# Kỳ vọng: file test chạy xanh, cover đúng nhánh vừa sửa
```

> Gõ `/` trong Chat mà không thấy `/tests`? Chạy `/status` + xem plan trước khi cho rằng lệnh hỏng.

## Ví dụ thật

Nghiệp vụ: `src/pricing/applyDiscount.ts` vừa thêm nhánh giảm giá theo hạng khách (VIP), chưa có test.

```bash
# 1. Bôi đen hàm applyDiscount()
# 2. Gọi:
/tests "sinh 3 cases: hạng thường, hạng VIP, và order rỗng (null) — mock DB theo mẫu repo"
# Verify: chạy test mới — xanh, và cover đúng nhánh VIP + order rỗng vừa thêm
```

**Kết quả mong đợi:** file test theo đúng framework/mẫu repo, chạy xanh ngay hoặc chỉ cần sửa nhỏ.

**✅ Verify:** chạy `npm test -- pricing` xanh, và đúng nhánh vừa sửa đã được cover — chứ không phải test chỉ chạy qua cho có.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — mô tả quá chung, ra test ảo:**

```bash
/tests "viết test cho hàm này"
# -> sinh test chỉ gọi hàm rồi assert truthy; logic sai vẫn xanh
```

**✅ ĐÚNG — nêu framework + mẫu + bắt test fail được:**

```bash
/tests "sinh 3 cases (thường, biên, null) theo mẫu order.test.ts, mock DB; mỗi test phải fail nếu logic sai"
```

**Bài học:** một test không thể đỏ khi logic sai thì vô giá trị — hãy yêu cầu rõ điều đó và review tay.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Test sinh ra không chạy được | Sai import/framework so với repo | Nêu rõ framework + file mẫu trong prompt |
| Test ảo (assert true) | Mô tả quá chung | Bắt "mỗi test phải fail nếu logic sai" + review tay |
| Quên mock DB/API | Prompt thiếu | Thêm "mock DB/API theo mẫu X" |

## So sánh với Claude Code

| Việc | Copilot (`/tests`) | Claude Code | Ghi chú |
|---|---|---|---|
| Sinh test cho hàm đang chọn | Slash command có sẵn `/tests` | Không có lệnh riêng — yêu cầu bằng prompt hoặc tự tạo command | Cùng việc, Copilot có sẵn nút |
| Bám mẫu repo | Khớp hơn khi bạn đính kèm/nêu tên file mẫu | Agent tự đọc repo tìm mẫu | Cả hai đều xanh hơn khi bạn chỉ đúng file mẫu |
| Kiểm chứng | Bạn chạy test, đọc kết quả | Bạn vẫn là người chạy và đọc | Test xanh là bằng chứng, không phải lời "đã viết xong" |

## Best practices (kèm "vì sao")

- **Nêu framework + file test mẫu ngay trong prompt.** *Vì sao?* Repo nào cũng có kiểu test riêng (jest/vitest/pytest); chỉ đúng mẫu thì test mới chạy được ngay.
- **Yêu cầu "mỗi test phải fail nếu logic sai".** *Vì sao?* Đây là hàng rào chống test ảo — assert true thì chạy xanh mà chẳng bảo vệ gì.
- **Luôn có case biên: null, rỗng, lỗi.** *Vì sao?* Bug thật thường nấp ở nhánh không ai nghĩ tới, chứ không ở đường đi chính.
- **Sinh xong chạy test trước khi commit.** *Vì sao?* Test không chạy được thì không phải "test", chỉ là code trang trí.

## Bài tập nhỏ

1. **(5 phút)** Bôi 1 hàm rồi `/tests` mà không nêu mẫu, sau đó nêu đúng file mẫu và hỏi lại. So xem lần nào chạy được ngay.
2. **(10 phút)** Sinh test cho 1 hàm có nhánh null: tự tay kiểm tra nhánh đó đã có case chưa, thiếu thì bổ sung.
3. **(10 phút)** Cố tình sửa logic 1 dòng cho sai, chạy test vừa sinh — test phải đỏ. Nếu vẫn xanh thì đó là test ảo, viết lại.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Code Actions.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Cần sửa code cho test pass (không sửa test để pass ảo): `/fix` — [../fix/README.md](../fix/README.md).

> Chốt: `/tests` giỏi phần boilerplate, còn trách nhiệm của bạn là **đảm bảo test biết đỏ khi code sai** — test luôn xanh là dấu hiệu nguy hiểm, không phải thành tích.
