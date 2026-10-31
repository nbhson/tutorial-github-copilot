# /help — Bản đồ lệnh khả dụng ở máy bạn

> **Dành cho:** người mới cài, hoặc người đang nghi lệnh nào đó không tồn tại · **Vấn đề:** không biết ở máy mình có lệnh gì, plan/version nào · **Đọc xong:** mở được bản đồ lệnh và đối chiếu với list thực tế (~2 phút)

## 1 câu nôm na

Hỏi lễ tân "ở đây có những dịch vụ gì?" trước khi gọi món. `/help` liệt kê các slash command, participant và mode khả dụng đúng theo plan + version của máy bạn.

Điểm mấu chốt: danh sách này **khác nhau giữa các máy**, nên `/help` là cách phân biệt "lệnh không tồn tại ở đây" với "lệnh có mà bạn gọi sai cú pháp".

## Vì sao dùng /help?

Rất nhiều thắc mắc "sao lệnh này không chạy" thực ra là câu hỏi về **khả dụng**: plan nào, version extension nào. `/help` trả lời trực tiếp:

- **Biết mình có gì** — không đoán mò theo tài liệu của người khác.
- **Phân biệt hai loại lỗi** — "không có lệnh" khác hẳn "gọi sai cú pháp".
- **Onboard nhanh** — thành viên mới mở `/help` là có bản đồ.

**Nếu làm sai thì sao?** Ngộ nhận phổ biến: thấy `/help` máy đồng nghiệp có lệnh mà máy mình không có, liền kết luận "extension lỗi". Thực ra thường là khác plan/version. Xem ❌/✅.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** mới cài và chưa biết có lệnh gì; nghi một lệnh vắng mặt do plan/version; onboard thành viên mới.
- **ĐỪNG dùng khi:** bạn cần *cách dùng chi tiết* một lệnh — `/help` chỉ liệt kê, không dạy cú pháp; hãy mở README của lệnh đó.
- **Cho ai:** người mới onboard nhanh, và tech lead đối chiếu máy mình với máy đồng nghiệp.

## Cách gọi (copy-paste)

```bash
/help
# Kỳ vọng: list slash/participant/mode đúng plan + version máy bạn
```

> Kiểm tra lệnh có ở máy bạn không: gõ `/` trong ô Chat, tìm `/help`. Không thấy → đọc `/status` + plan trước khi kết luận lỗi công cụ.

## Ví dụ thật

Nghiệp vụ: bạn đọc tài liệu thấy có `/tests` để sinh test, nhưng gõ vào máy mình thì không thấy. Thay vì loay hoay, mở `/help` để xem thực tế máy mình có gì.

```bash
/help
# Doi chieu list voi tai lieu: may ban thieu /tests do plan
# -> mo /status xem plan + version, khong phai loi extension
# Verify: go / so list thuc te -> khop voi /help
```

**Kết quả mong đợi:** List slash/participant/mode khả dụng đúng plan + version máy bạn.

**✅ Verify:** Gõ `/` so list trong `/help` với list thực tế — khớp là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — thấy thiếu lệnh rồi kết luận ngay là extension hỏng:**

```bash
/help   # thay thieu /tests -> "extension loi roi" -> cai lai vo ich
```

**✅ ĐÚNG — đối chiếu `/help` với `/status` để tìm đúng nguyên nhân plan/version:**

```bash
/help
/status   # xem plan + version -> thieu lenh la do plan, khong phai loi
```

**Bài học:** "Không có lệnh" thường là chuyện plan/version, không phải lỗi cài đặt. `/help` + `/status` là cặp chẩn đoán.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| List trong `/help` khác máy đồng nghiệp | Khác plan/version | So `/status` 2 máy: plan + version extension |
| Đọc `/help` vẫn không hiểu lệnh nào | Thiếu ví dụ | Mở `commands/` tra folder chi tiết từng lệnh |
| Lệnh có trong `/help` mà gõ không ăn | Nhầm cú pháp (thiếu scope) | Đọc mục Cách gọi của lệnh đó |

## So sánh với Claude Code

| Việc | Copilot (`/help`) | Claude Code | Ghi chú |
|---|---|---|---|
| Xem bản đồ lệnh khả dụng | `/help` liệt kê theo plan/version | `/help` và `/` gợi ý lệnh | Cùng ý tưởng: liệt kê lệnh hiện có |
| Chẩn đoán thiếu lệnh | Đối chiếu `/status` (plan + version) | Kiểm tra version/plan | Cả hai đều bị ảnh hưởng bởi gói/phiên bản |
| Học cú pháp chi tiết | Phải mở README từng lệnh | Xem docs từng lệnh | `/help` không dạy cú pháp |

## Best practices (kèm "vì sao")

- **Mở `/help` ngay sau khi cài.** *Vì sao?* Biết chính xác máy mình có gì rẻ hơn nhiều so với đoán theo tài liệu chung.
- **Thiếu lệnh thì so `/status` trước khi báo lỗi.** *Vì sao?* Phần lớn "thiếu lệnh" là khác plan/version, không phải bug.
- **Đừng dùng `/help` thay tài liệu chi tiết.** *Vì sao?* Nó chỉ liệt kê; cú pháp và ví dụ phải đọc README lệnh đó.
- **Đối chiếu máy đồng nghiệp khi pair/onboard.** *Vì sao?* Hai máy khác plan sẽ khác list — biết trước để không mất thời gian.

## Bài tập nhỏ

1. **(2 phút)** Mở `/help` và `/status`, ghi lại plan + version + danh sách lệnh của máy bạn.
2. **(5 phút)** Chọn một lệnh có trong `/help`, mở README tương ứng trong `commands/` để học cú pháp.
3. **(5 phút)** Nhờ một đồng nghiệp mở `/help`, so list hai máy và tìm điểm khác biệt (plan/version).

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Chat Session.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Khi lệnh có mà gọi không ăn: [../attachments/README.md](../attachments/README.md) (thiếu scope) và [../shortcuts/README.md](../shortcuts/README.md) (phím tắt).

> `/help` trả lời câu "máy tôi có gì", không trả lời câu "dùng thế nào" — nhớ đường đi tiếp sau nó là README của từng lệnh.
