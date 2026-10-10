# /optimize — Tối ưu perf có đo đạc

> **Dành cho:** dev đã đo (profile/benchmark) thấy đoạn code chậm · **Vấn đề:** optimize mù làm code khó đọc mà không nhanh hơn · **Đọc xong:** có đề xuất trước/sau kèm benchmark chứng minh (~2 phút)

## Lệnh làm gì (1 câu nôm na)

Nôm na: khám xe đo máy đàng hoàng rồi mới độ — không độ mù. Bôi đen đoạn chậm rồi `/optimize`; chưa profile thì chưa optimize.

## Khi nào dùng

Section này trả lời: điều kiện nào để optimize là chính đáng, và giữ sao cho output không đổi.

- **Cho ai:** dev giữ path nóng (API, query), người chuẩn bị scale trước khi lên production.
- Đã đo thấy chậm (profile/benchmark) đúng đoạn này.
- Review phát hiện vòng lặp/query thừa rõ ràng.
- Chuẩn bị scale cho path nóng.

## Cách gọi (copy-paste)

Cách gọi `/optimize` — làm đúng theo khối dưới đây, kèm câu kiểm tra lệnh có ở máy bạn hay không:

```bash
Bôi đen đoạn chậm → /optimize
/optimize giảm N+1 query, giữ nguyên output
# Kỳ vọng: đề xuất trước/sau + code mới, benchmark chứng minh
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/optimize`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

Prompt mẫu cho `/optimize` — đổi phần tên file/task cho đúng việc của bạn:

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
(bôi đen hàm query) /optimize “giảm N+1 bằng batch, giữ nguyên output — nêu trước/sau complexity”
# Verify: benchmark trước/sau + test vẫn xanh
```

**Kết quả mong đợi:** Đề xuất cụ thể (trước/sau) + code mới; benchmark cải thiện, test vẫn xanh.

**Cách verify:** Benchmark trước/sau + test xanh — nhanh hơn mà đúng là đạt.

## Lỗi thường gặp

Ba triệu chứng hay gặp nhất với lệnh này — kèm nhanh cách xử lý:

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Tối ưu mù khi chưa đo | Chưa profile đã optimize | Đo trước (profile/EXPLAIN), optimize sau |
| Nhanh hơn nhưng sai edge | Đổi logic ngầm | Bắt “giữ nguyên output mọi input” + chạy full test |
| Code khó đọc hơn nhiều | Trade-off không đáng | Chỉ optimize path nóng đã đo |

## Tham khảo

Liên quan — index nhóm, cheatsheet 1 trang và FAQ phòng khi kẹt:

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
