# /new (code) — Sinh code mới từ mô tả

> **Dành cho:** dev cần sinh hàm/file/module mới · **Vấn đề:** gõ boilerplate tốn thời gian, code lệch style repo · **Đọc xong:** ra code đúng style, review diff rồi mới giữ (~2 phút)

## 1 câu nôm na

Đọc đề bài rồi viết bài giải nháp — bạn duyệt rồi mới nộp. Gõ `/new` kèm mô tả rõ ràng, và nếu đính kèm 1 file mẫu thì code sinh ra khớp style repo hơn hẳn.

## Vì sao dùng /new?

Phần tốn thời gian khi viết code mới không phải logic mà là khung xương: import, cấu trúc file, đặt tên, xử lý lỗi cơ bản. `/new` dựng sẵn khung đó theo mô tả, bạn chỉ sửa lại chỗ cần. Nó đặc biệt hợp để **spike nhanh một ý tưởng** — có bản nháp để bạn phản biện ngay, thay vì ngồi gõ từ trang trắng.

**Nếu làm sai thì sao?** Hai cái bẫy. Một là **lệch style**: không có file mẫu, code sinh ra đúng logic nhưng khác convention repo (naming, cách xử lý lỗi), review mất thời gian sửa. Hai là **ôm đồm**: tả cả module trong một lần thì ra khối code to, khó review và dễ sai — hãy chia nhỏ theo bước (xem mục ❌/✅).

## Khi nào dùng / khi nào đừng

- **Dùng khi:** sinh hàm/file/module mới từ mô tả đã rõ, tạo boilerplate theo mẫu repo, hoặc spike nhanh một ý tưởng.
- **ĐỪNG dùng khi:** bạn cần *sửa* code đang có (`/fix`, `/refactor`), hoặc task mở cần tìm file + chạy test nhiều bước (dùng Agent mode).
- **Cho ai:** dev viết code mới hằng ngày, người muốn spike nhanh 1 ý tưởng.

## Cách gọi (copy-paste)

```bash
/new

/new viết hàm retry fetch 3 lần, backoff 1s
# Kỳ vọng: code nháp đúng style repo, review rồi mới giữ
```

> Không thấy `/new (code)` khi gõ `/` trong Chat? Xem `/status` + plan trước khi kết luận lệnh hỏng. Lưu ý có `/new` để mở chat mới và `/new (code)` để sinh code — chọn đúng cái bạn cần.

## Ví dụ thật

Nghiệp vụ: cần một helper gọi API có retry cho tầng network.

```bash
/new "viết hàm fetchWithRetry(url): retry 3 lần, backoff 1s, throw lỗi cuối — theo style repo"
# Verify: chạy thử + viết 1 test nhanh cho hàm mới
```

**Kết quả mong đợi:** code mới đúng style repo + có xử lý lỗi cơ bản (timeout/lỗi mạng); bạn review diff rồi mới giữ.

**✅ Verify:** chạy thử hàm + viết 1 test nhanh cho nó — chạy được và xanh là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — tả cả module một lần, không có mẫu:**

```bash
/new "viết module xử lý payment đầy đủ: retry, webhook, refund, log, config"
# -> ra khối code to, lệch style, khó review
```

**✅ ĐÚNG — chia bước + đính file mẫu:**

```bash
/new "viết hàm fetchWithRetry(url): retry 3 lần, backoff 1s — theo đúng style file src/net/http.ts"
# bước tiếp: viết test, rồi mới ghép vào module
```

**Bài học:** code nháp đúng style + tả từng phần nhỏ thì review nhanh và ít bug hơn nhiều so với ôm cả module.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Code sinh ra không khớp style | Thiếu file mẫu | Attach 1 file mẫu + "theo đúng style file này" |
| Thiếu xử lý lỗi/edge | Mô tả thiếu | Thêm "xử lý null/timeout/lỗi mạng" vào đề |
| Sinh cả module quá to | Ôm đồm 1 lần | Chia: types → hàm → test, từng bước |

## So sánh với Claude Code

| Việc | Copilot (`/new`) | Claude Code | Ghi chú |
|---|---|---|---|
| Sinh code mới từ mô tả | Slash command có sẵn `/new` | Không có lệnh riêng — mô tả bằng prompt hoặc tự tạo command | Cùng việc, Copilot có sẵn nút |
| Khớp style repo | Khớp hơn khi bạn đính kèm file mẫu | Agent tự đọc repo tìm mẫu | Cả hai đều khớp hơn khi bạn chỉ đúng mẫu |
| Kiểm chứng | Bạn chạy thử + viết test nhanh | Bạn vẫn phải chạy thử/test | Code nháp chưa chạy được coi như chưa xong |

## Best practices (kèm "vì sao")

- **Đính kèm 1 file mẫu + "theo đúng style file này".** *Vì sao?* Style repo (naming, cách xử lý lỗi) khó tả bằng lời; một ví dụ cụ thể nhanh và chính xác hơn.
- **Tả rõ xử lý lỗi/edge ngay trong đề.** *Vì sao?* Mặc định model đi đường chính, còn null/timeout/lỗi mạng là phần hay bị bỏ và hay gây bug.
- **Chia nhỏ: types → hàm → test.** *Vì sao?* Mỗi mảnh nhỏ thì bạn dễ đọc diff, dễ sửa, và giữ được quyền kiểm soát từng bước.
- **Review diff trước khi giữ.** *Vì sao?* `/new` sinh nháp, không phải code đã duyệt — nháp không đọc là bug chờ sẵn.

## Bài tập nhỏ

1. **(5 phút)** Chạy `/new` không có file mẫu, rồi chạy lại có đính file mẫu. So sánh mức độ khớp style.
2. **(10 phút)** Sinh 1 hàm mới rồi tự viết 1 test nhanh cho nó, chạy thử.
3. **(10 phút)** Thử tả cả module trong 1 prompt, rồi chia nhỏ thành 3 bước — ghi lại cách nào review nhanh hơn.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Code Actions.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Task mở nhiều bước (tìm file + chạy test): Agent mode — [../../model-agent/agent-mode/README.md](../../model-agent/agent-mode/README.md).

> Chốt: `/new` cho bạn điểm khởi đầu, không cho bạn sản phẩm cuối — **đính file mẫu, chia nhỏ, và đọc diff** trước khi coi nó là code của mình.
