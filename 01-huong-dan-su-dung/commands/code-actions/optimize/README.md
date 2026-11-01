# /optimize — Tối ưu perf có đo đạc

> **Dành cho:** dev đã đo (profile/benchmark) thấy đoạn code chậm · **Vấn đề:** optimize mù làm code khó đọc mà không nhanh hơn · **Đọc xong:** có đề xuất trước/sau kèm benchmark chứng minh (~2 phút)

## 1 câu nôm na

Khám xe, đo máy đàng hoàng rồi mới độ — không độ mù. Bạn bôi đen đoạn *đã biết là chậm* rồi gọi `/optimize`; **chưa profile thì chưa optimize**, vì đoán chỗ chậm hầu như luôn đoán sai.

## Vì sao dùng /optimize?

Hai việc `/optimize` làm mà gõ tay khó bằng: nó nêu **trước/sau** (độ phức tạp, số query) thành lời để bạn phản biện, và giữ ràng buộc "output không đổi". Lợi ích thật là nó buộc bạn *chứng minh* nhanh hơn bằng benchmark, thay vì nghe theo cảm giác. Trên path nóng (API, query) chỉ cần cắt một vòng lặp N+1 là thấy khác biệt rõ.

**Nếu làm sai thì sao?** Optimize mù là cái bẫy tốn kém nhất: code phức tạp hơn, khó đọc hơn, mà chẳng nhanh hơn vì nút thắt nằm ở chỗ khác. Nguy hiểm hơn là **nhanh nhưng sai** — đổi logic ngầm ở một edge case hiếm. Vì vậy phải đo trước, và bắt buộc "giữ nguyên output mọi input" + chạy full test (xem mục ❌/✅).

> **Tóm gọn 1 câu:** `/optimize` là bác sĩ "có kết quả xét nghiệm mới kê thuốc" — số đo trước, thuốc sau, và dặn kỹ là không đổi chứng bệnh chỉ để chạy nhanh hơn.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** bạn đã đo (profile/benchmark) thấy đúng đoạn này chậm, review phát hiện vòng lặp/query thừa rõ ràng, hoặc chuẩn bị scale cho path nóng.
- **ĐỪNG dùng khi:** bạn chỉ *đoán* là chậm mà chưa profile (hãy đo trước), hoặc cần sửa tính đúng/sai chứ không phải tốc độ (đó là `/fix`).
- **Cho ai:** dev giữ path nóng (API, query), người chuẩn bị scale trước khi lên production.

> **Tóm gọn 1 câu:** Chạy nhanh hơn là kết quả phải đo được, không phải cảm giác — chưa có benchmark thì chưa tính tới chuyện optimize.

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

> Gõ `/` trong Chat mà không thấy `/optimize`? Chạy `/status` + xem plan trước khi kết luận lệnh lỗi.

## Ví dụ thật

Nghiệp vụ: `loadOrdersWithItems()` gọi DB trong vòng lặp — trang order list chậm hẳn khi có nhiều đơn.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh)

**Kết quả mong đợi:** đề xuất cụ thể (trước/sau) + code mới; benchmark cải thiện và test vẫn xanh.

**✅ Verify:** chạy benchmark trước/sau + full test — nhanh hơn *và* đúng mới là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — optimize khi chưa đo, không ràng buộc output:**

> 📄 **Code ví dụ:** [`examples/03-neu-lam-sai-thi-sao-sai-ung.sh`](examples/03-neu-lam-sai-thi-sao-sai-ung.sh)

**✅ ĐÚNG — profile trước, ràng buộc output:**

> 📄 **Code ví dụ:** [`examples/04-neu-lam-sai-thi-sao-sai-ung.sh`](examples/04-neu-lam-sai-thi-sao-sai-ung.sh)

**Bài học:** không có số đo thì "tối ưu" chỉ là sở thích cá nhân; và luôn khóa "giữ nguyên output" để không đánh đổi tính đúng lấy tốc độ.

## Lỗi thường gặp

Đề xuất optimize chưa thuyết phục hoặc còn nghi ngại? Ba ca dưới đây phủ gần hết các tình huống — tra theo Triệu chứng rồi áp Fix.

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Tối ưu mù khi chưa đo | Chưa profile đã optimize | Đo trước (profile/EXPLAIN), optimize sau |
| Nhanh hơn nhưng sai edge | Đổi logic ngầm | Bắt "giữ nguyên output mọi input" + chạy full test |
| Code khó đọc hơn nhiều | Trade-off không đáng | Chỉ optimize path nóng đã đo |

> **Cách đọc bảng này:** đọc theo hàng từ Triệu chứng → Fix; hàng giữa là ca nguy hiểm nhất vì test cũng có thể không bắt được — đó là lý do phải khóa "giữ nguyên output" ngay từ prompt.

## So sánh với Claude Code

Cũng dùng Claude Code? Bảng này cho biết `/optimize` ánh xạ sang bên kia ra sao và khác nhau thật sự ở khâu nào.

| Việc | Copilot (`/optimize`) | Claude Code | Ghi chú |
|---|---|---|---|
| Đề xuất tối ưu perf | Slash command có sẵn `/optimize` | Không có lệnh riêng — yêu cầu bằng prompt hoặc tự tạo command | Cùng việc, Copilot có sẵn nút |
| Nêu trước/sau | Đưa ra đề xuất để bạn phản biện | Agent tự đề xuất khi được hỏi | Cả hai đều là đề xuất, không phải bằng chứng |
| Kiểm chứng | Bạn chạy benchmark + test | Bạn vẫn là người đo | Không agent nào tự đo hộ tốc độ thật |

> **Cách đọc bảng này:** mỗi dòng một việc; nhớ cả hai công cụ đều chỉ đưa "đề xuất" — bằng chứng duy nhất là benchmark của bạn, không phải lời của agent.

## Best practices (kèm "vì sao")

Bốn quy tắc dưới đây giữ cho `/optimize` không thành "độ xe mù" — mỗi quy tắc kèm lý do để bạn biết khi nào được ngoại lệ.

- **Profile/EXPLAIN trước khi optimize.** *Vì sao?* Trực giác về "chỗ chậm" thường sai; chỉ số đo mới chỉ đúng nút thắt.
- **Luôn viết "giữ nguyên output mọi input".** *Vì sao?* Đây là ràng buộc buộc bạn phải chứng minh tính đúng không bị đánh đổi lấy tốc độ.
- **Chỉ optimize path nóng đã đo.** *Vì sao?* Tối ưu chỗ ít chạy chỉ làm code khó đọc mà không ai thấy lợi.
- **Chạy full test sau khi tối ưu.** *Vì sao?* Cải thiện tốc độ mà làm đỏ test thì bạn vừa phá thứ đang chạy tốt.

## Bài tập nhỏ

1. **(5 phút)** Chạy `/optimize` cho 1 hàm *chưa* profile, rồi profile rồi chạy lại. So xem lần nào có căn cứ.
2. **(10 phút)** Đo 1 hàm bằng benchmark trước/sau khi optimize, ghi lại chênh lệch %.
3. **(10 phút)** Cố tình nhận một đề xuất tối ưu "nhanh hơn nhưng đổi output" — chạy test để thấy nó đỏ ở đâu.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Code Actions.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Cải thiện cấu trúc không đổi behavior (khác với tối ưu tốc độ): `/refactor` — [../refactor/README.md](../refactor/README.md).

> Chốt: tốc độ là thứ phải **đo**, không phải thứ để tranh luận — profile trước, ràng buộc output, rồi để benchmark và test phán quyết.
