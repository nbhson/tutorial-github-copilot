# @terminal — Biến log đỏ thành task fix

> **Dành cho:** dev kẹt với lỗi đỏ trong terminal/build/test · **Vấn đề:** log dài, chưa biết nguyên nhân top-1 nằm ở đâu · **Đọc xong:** biến log thành task fix có thứ tự ưu tiên (~2 phút)

## 1 câu nôm na

Chụp ảnh màn hình lỗi đưa cho thợ — "xe kêu thế này, sửa giúp". Bạn gọi `@terminal` kèm yêu cầu đọc log; mẹo là **chỉ đưa 30–50 dòng quanh lỗi + lệnh bạn đã chạy**, chứ paste cả 500 dòng thì nó đọc sót.

## Vì sao dùng @terminal?

Log lỗi thường dài và nhiễu — dòng quan trọng nằm lẫn giữa hàng trăm dòng warning. `@terminal` đọc output terminal ngay trong ngữ cảnh phiên làm việc, chỉ ra **nguyên nhân top-1** rồi gợi ý fix **xếp theo mức rủi ro**, để bạn chọn cách ít nguy hiểm nhất. Nó đặc biệt hữu ích khi bạn còn chưa biết lỗi nằm ở đâu — giúp *khoanh vùng* trước khi tự tay sửa.

**Nếu làm sai thì sao?** Nguy hiểm nhất là **tin vào fix mạo hiểm**: model gợi ý `rm -rf`, `git reset --hard`, `--force` — chạy theo là mất code. Và nếu thiếu ngữ cảnh (lệnh đã chạy, OS, branch) thì "fix" chỉ là đoán mò. Vì vậy hãy đọc kỹ, cấm lệnh phá hủy, và review trước khi chạy (xem mục ❌/✅).

## Khi nào dùng / khi nào đừng

- **Dùng khi:** terminal báo lỗi đỏ chưa hiểu, test fail với stack trace dài, hoặc lệnh build/deploy fail.
- **ĐỪNG dùng khi:** bạn cần nó tự đi sửa nhiều file và chạy vòng lặp (đó là Agent mode); `@terminal` giỏi *chẩn đoán*, không phải thi công.
- **Cho ai:** dev đang kẹt ở build/test fail, kể cả người chưa biết lỗi nằm ở đâu.

## Cách gọi (copy-paste)

```bash
@terminal

@terminal giải thích lỗi vừa rồi + gợi ý 2 cách fix
# Kỳ vọng: nguyên nhân top-1 + fix xếp theo rủi ro
```

> Gõ `@` trong Chat mà không thấy `@terminal`? Xem `/status` + plan trước khi kết luận nó không khả dụng.

## Ví dụ thật

Nghiệp vụ: `npm test` vừa fail với stack trace dài, bạn không biết lỗi thật nằm ở đâu.

```bash
@terminal "đọc 30 dòng log cuối, nói nguyên nhân top-1 + gợi ý fix ít rủi ro nhất"
# Verify: áp fix, chạy lại lệnh — hết đỏ là đạt
```

**Kết quả mong đợi:** nguyên nhân top-1 đúng + 1–2 cách fix xếp theo rủi ro; bạn chọn 1 cách rồi làm tiếp.

**✅ Verify:** áp fix xong chạy lại đúng lệnh đã fail — hết đỏ là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — paste cả log rồi chạy theo fix mạo hiểm:**

```bash
# (paste 500 dòng) @terminal "sửa lỗi này"
# -> gợi ý mơ hồ, có thể kèm "git reset --hard" — mất code
```

**✅ ĐÚNG — đưa log gọn + ngữ cảnh, cấm lệnh phá hủy:**

```bash
@terminal "đây là 30 dòng cuối của `npm test` (đã chạy trên branch feat/x, macOS): nói nguyên nhân top-1 + fix ít rủi ro nhất, đừng đề xuất lệnh xóa/force"
```

**Bài học:** log gọn + ngữ cảnh = chẩn đoán đúng; và luôn từ chối fix mang tính phá hủy để bảo vệ code của bạn.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Log quá dài, model đọc sót | Paste cả 500 dòng | Chỉ lấy 30–50 dòng quanh lỗi + lệnh đã chạy |
| Fix đoán mò | Thiếu context lệnh/môi trường | Nêu lệnh đã chạy + OS + branch |
| Fix mạo hiểm (xóa/force) | Tin luôn không review | Cấm lệnh destructive; review trước khi chạy |

## So sánh với Claude Code

| Việc | Copilot (`@terminal`) | Claude Code | Ghi chú |
|---|---|---|---|
| Đọc output terminal đang có | Participant `@terminal` tường minh | Agent tự đọc output lệnh nó vừa chạy | Copilot có kênh `@` để trỏ vào log; Claude Code gắn với phiên chạy của chính nó |
| Chẩn đoán nguyên nhân | Nguyên nhân top-1 + fix theo rủi ro | Agent tự phân tích output khi được yêu cầu | Cùng tư tưởng: log là dữ liệu, không phải lời kết tội |
| Kiểm chứng | Bạn chạy lại lệnh, xác nhận hết đỏ | Bạn vẫn là người chạy lại | "Hết đỏ" do lệnh quyết định, không do lời gợi ý |

## Best practices (kèm "vì sao")

- **Chỉ đưa 30–50 dòng quanh lỗi + lệnh đã chạy.** *Vì sao?* Log dài làm loãng tín hiệu; đúng khung quanh lỗi cho chẩn đoán sắc hơn.
- **Nêu ngữ cảnh: OS, branch, lệnh đã chạy.** *Vì sao?* Cùng một lỗi có nhiều nguyên nhân tùy môi trường; thiếu context là đoán.
- **Cấm lệnh destructive (`rm -rf`, `--force`, `reset --hard`).** *Vì sao?* Fix sai thì sửa lại được, chạy nhầm lệnh phá hủy thì mất code.
- **Áp fix rồi chạy lại đúng lệnh đã fail.** *Vì sao?* Đây là cách duy nhất xác nhận đã hết lỗi, thay vì chỉ tin vào gợi ý.

## Bài tập nhỏ

1. **(5 phút)** Cố tình paste cả log dài rồi `@terminal`, sau đó làm lại với 30 dòng quanh lỗi. So sánh độ chính xác.
2. **(10 phút)** Lấy 1 lỗi build thật: hỏi nguyên nhân top-1 + 2 cách fix, áp cách ít rủi ro nhất rồi chạy lại lệnh.
3. **(10 phút)** Nhận diện 1 gợi ý "fix mạo hiểm" (xóa/force) và viết lại yêu cầu có dòng "đừng đề xuất lệnh destructive".

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Code Actions.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Cần nó tự đi sửa nhiều bước: Agent mode — [../../model-agent/agent-mode/README.md](../../model-agent/agent-mode/README.md).

> Chốt: `@terminal` biến một đống log đỏ thành **danh sách việc có thứ tự** — nhưng bạn vẫn là người chọn lệnh nào được phép chạy, nhất là khi nó gợi ý lệnh phá hủy.
