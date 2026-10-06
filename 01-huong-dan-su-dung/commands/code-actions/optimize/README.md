# /optimize — Tối ưu perf có đo đạc

> Nôm na: khám xe đo máy đàng hoàng rồi mới độ — không độ mù.

## Lệnh làm gì (1 câu nôm na)

Nôm na: khám xe đo máy đàng hoàng rồi mới độ — không độ mù. Thuộc nhóm lệnh dùng hàng ngày — gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

- Đã đo thấy chậm (profile/benchmark) đúng đoạn này.
- Review phát hiện vòng lặp/query thừa rõ ràng.
- Chuẩn bị scale cho path nóng.

## Cách gọi (copy-paste)

```bash
Bôi đen đoạn chậm → /optimize
/optimize giảm N+1 query, giữ nguyên output
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `/optimize`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
(bôi đen hàm query) /optimize “giảm N+1 bằng batch, giữ nguyên output — nêu trước/sau complexity”
```

**Kết quả mong đợi:** Đề xuất cụ thể (trước/sau) + code mới; benchmark cải thiện, test vẫn xanh.

**Cách verify:** Benchmark trước/sau + test xanh — nhanh hơn mà đúng là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Tối ưu mù khi chưa đo | Chưa profile đã optimize | Đo trước (profile/EXPLAIN), optimize sau |
| Nhanh hơn nhưng sai edge | Đổi logic ngầm | Bắt “giữ nguyên output mọi input” + chạy full test |
| Code khó đọc hơn nhiều | Trade-off không đáng | Chỉ optimize path nóng đã đo |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
