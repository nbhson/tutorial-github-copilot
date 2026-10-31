# /refactor — Refactor gọn mà giữ behavior

> **Dành cho:** dev cấu trúc lại code mà không đổi hành vi · **Vấn đề:** refactor kèm bug vì không có test bao · **Đọc xong:** code gọn hơn mà test cũ vẫn xanh (~2 phút)

## 1 câu nôm na

Dọn nhà nhưng không vứt đồ — gọn hơn mà đồ đạc vẫn đủ. Bạn bôi đen rồi gọi `/refactor`; hai thứ không được quên: **chạy test trước và sau**, và ghi rõ "giữ nguyên behavior" trong prompt.

## Vì sao dùng /refactor?

Refactor là việc đúng nhưng dễ phá thứ đang chạy: đổi cấu trúc mà vô tình đổi hành vi thì bug len vào lặng lẽ. `/refactor` giúp bạn **tách hàm, gom code trùng, đặt tên rõ** nhanh hơn gõ tay, và điều quan trọng là nó buộc bạn khai báo ràng buộc "behavior không đổi". Điều kiện tiên quyết luôn là: **có test bao trước khi refactor** — không có lưới an toàn thì đừng leo.

**Nếu làm sai thì sao?** Hai mặt trái. Một là **refactor kèm đổi hành vi**: test đỏ mà bạn tưởng chỉ là "dọn dẹp", thực ra đã phá logic. Hai là **tách quá vụn**: chuỗi hàm 1 dòng nối nhau, đọc còn mệt hơn bản gốc. Và đừng bao giờ vừa refactor vừa thêm tính năng — trộn 2 việc thì không review nổi cái nào (xem mục ❌/✅).

## Khi nào dùng / khi nào đừng

- **Dùng khi:** hàm/file quá dài muốn tách nhỏ, code trùng ở 3 chỗ muốn gom 1, hoặc đổi tên/tách module nhưng giữ behavior.
- **ĐỪNG dùng khi:** bạn muốn *thêm tính năng* (làm riêng 1 commit), hoặc đoạn code chưa có test bao — viết test trước (`/tests`) rồi hãy refactor.
- **Cho ai:** dev dọn code định kỳ, người tách hàm/file quá dài.

## Cách gọi (copy-paste)

```bash
# Bôi đen, rồi:
/refactor

/refactor tách hàm này thành 3 hàm nhỏ, giữ nguyên behavior
# Kỳ vọng: code gọn hơn, tên rõ hơn, test cũ vẫn xanh
```

> Không thấy `/refactor` khi gõ `/` trong Chat? Kiểm tra `/status` + xem plan trước khi kết luận lệnh lỗi.

## Ví dụ thật

Nghiệp vụ: `processCheckout()` đã phình lên 100 dòng, khó đọc, nhưng đang chạy tốt.

```bash
# 1. Bôi đen hàm processCheckout()
# 2. Gọi:
/refactor "tách thành validate/process/save, giữ nguyên behavior + có test bao"
# Verify: chạy full test liên quan — xanh hết là đạt
```

**Kết quả mong đợi:** code gọn hơn, tên hàm rõ hơn; toàn bộ test cũ vẫn xanh (behavior giữ nguyên).

**✅ Verify:** chạy full test liên quan (`npm test -- checkout`) — xanh hết là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — refactor không test + gộp thêm tính năng:**

```bash
/refactor "dọn lại processCheckout cho gọn, tiện thêm voucher giảm giá luôn"
# -> vừa đổi cấu trúc vừa đổi hành vi, không biết bug đến từ đâu
```

**✅ ĐÚNG — có test bao + chỉ refactor:**

```bash
# (đã chạy test xanh trước) rồi:
/refactor "tách thành validate/process/save, giữ nguyên behavior, không thêm tính năng"
# chạy lại full test sau khi refactor
```

**Bài học:** refactor và thêm tính năng là 2 commit khác nhau; và test phải xanh **trước** lẫn **sau**.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Refactor đổi luôn behavior | Thiếu test bao + prompt thiếu "giữ nguyên" | Chạy test trước/sau; prompt ghi "giữ nguyên behavior" |
| Tách quá vụn khó đọc | Tham tách | Tách vừa đủ: mỗi hàm 1 việc, tên nói được việc |
| Refactor + thêm tính năng 1 lúc | Ôm 2 việc | Refactor riêng 1 commit, tính năng riêng 1 commit |

## So sánh với Claude Code

| Việc | Copilot (`/refactor`) | Claude Code | Ghi chú |
|---|---|---|---|
| Tách/gom code giữ behavior | Slash command có sẵn `/refactor` | Không có lệnh riêng — yêu cầu bằng prompt hoặc tự tạo command | Cùng việc, Copilot có sẵn nút |
| Ràng buộc "không đổi behavior" | Bạn phải nói trong prompt | Bạn cũng phải nói rõ | Không agent nào tự hiểu đây là refactor thuần |
| Kiểm chứng | Bạn chạy test trước/sau | Bạn vẫn là người chạy | Test xanh là lưới an toàn duy nhất |

## Best practices (kèm "vì sao")

- **Có test bao trước khi refactor.** *Vì sao?* Không có test thì bạn không có cách nào biết mình vừa phá gì.
- **Ghi rõ "giữ nguyên behavior" trong prompt.** *Vì sao?* Nếu không, model dễ "tiện tay" cải thiện logic — thứ bạn không hề yêu cầu.
- **Tách vừa đủ, mỗi hàm một việc.** *Vì sao?* Quá vụn làm khó đọc hơn; tiêu chí là tên hàm nói lên việc nó làm.
- **Refactor riêng 1 commit, tính năng riêng 1 commit.** *Vì sao?* Trộn 2 việc thì reviewer không thể tách "thay đổi cấu trúc" khỏi "thay đổi hành vi".

## Bài tập nhỏ

1. **(5 phút)** Chạy `/refactor` cho 1 hàm *chưa* có test bao, rồi chạy lại sau khi thêm test. Ghi lại mức độ tự tin mỗi lần.
2. **(10 phút)** Tách 1 hàm dài thành 3 hàm nhỏ, chạy full test trước/sau để chứng minh behavior không đổi.
3. **(10 phút)** Lấy 1 refactor bạn từng làm kèm "tiện tay thêm tính năng" — thử tách lại thành 2 commit.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Code Actions.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Viết test bao trước khi refactor: `/tests` — [../tests/README.md](../tests/README.md).

> Chốt: refactor giỏi không phải là đổi nhiều, mà là **đổi cấu trúc mà không ai phát hiện ra hành vi đã thay đổi** — test xanh trước và sau chính là bằng chứng đó.
