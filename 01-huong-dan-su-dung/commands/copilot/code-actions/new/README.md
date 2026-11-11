# /new — Scaffold workspace/file/notebook mới từ mô tả

> **Dành cho:** dev cần khởi tạo dự án/file/notebook mới · **Vấn đề:** gõ khung xương boilerplate tốn thời gian, dễ thiếu bước khởi động · **Đọc xong:** sinh scaffold chạy được ngay, biết biên dạng mô tả nào an toàn (~2 phút)
> **Harness:** Copilot · **Surface:** Chat view — `/new`, `/newNotebook` thuộc bảng slash commands trong docs cheat sheet ("scaffold a workspace, file, or notebook")

## Nôm na là

Đặt bàn ăn thay vì nấu cả mâm — `/new` dựng sẵn *khung*: cấu trúc thư mục, file entry, README, notebook kèm cell mẫu; bạn mô tả rõ món chính, nó bày biện, bạn là người nếm và quyết định giữ gì.

## Vì sao dùng /new?

Viết tay một dự án/notebook mới tốn toàn thời gian cho phần không sáng tạo: tạo file, cài dependencies, cấu hình khởi động. `/new <mô tả>` dựng khung đó theo đúng đề, `Ctrl+Shift+P` không cần đụng tới — bạn vào thẳng phần logic của mình. Nó đặc biệt hợp khi bạn cần **một điểm khởi chạy được** để phản biện, thay vì trang trắng.

**Nếu làm sai thì sao?** Bẫy lớn nhất là **mô tả ôm đồm**: đòi "app quản lý đủ chức năng web + mobile + API" một câu thì scaffold sinh ra cả "thành phố" chạy không nổi, dọn còn mệt hơn tự viết. Bẫy thứ hai: tưởng scaffold là code đã duyệt — nó chưa từng được test (xem ❌/✅).

> **Tóm gọn 1 câu:** `/new` mạnh nhất khi đề bài *hẹp và có tech stack rõ* — phạm vi càng hẹp, scaffold càng chạy được ngay.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** khởi tạo dự án nhỏ, file độc lập có cấu trúc, notebook phân tích dữ liệu; spike nhanh một ý tưởng.
- **ĐỪNG dùng khi:** bạn cần *sửa* code đang có (dùng code actions **Fix/Refactor** — xem [../fix/README.md](../fix/README.md), [../refactor/README.md](../refactor/README.md)); task mở nhiều bước (dùng Agent mode); hoặc **lầm với chat mới** — mở phiên chat mới là `Ctrl+N` ([../../chat-session/new-chat/README.md](../../chat-session/new-chat/README.md)).
- **Cho ai:** dev hay khởi tạo project/notebook mới, người cần khung chạy được trong 1 phút.

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

> Hai biến thể trong docs: `/new <mô tả>` (workspace/file) và `/newNotebook <mô tả>` (notebook `.ipynb`). Gõ một mình `/new` rồi trả lời câu hỏi tiếp theo của Copilot cũng được.

## Ví dụ thật

Nghiệp vụ: cần bảng doanh thu theo tháng cho cuộc họp, dữ liệu nằm trong `sales.csv`.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh)

**Kết quả mong đợi:** notebook `.ipynb` mở ra có sẵn cell đọc dữ liệu → thống kê → vẽ biểu đồ; bạn Run All xem chạy được không rồi sửa số liệu.

**✅ Verify:** mở scaffold và **chạy thử ngay** (npm run dev / Run All) — chạy được + tự mở sửa được là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — mô tả cả hệ thống trong một câu, không tech stack:**

> 📄 **Code ví dụ:** [`examples/03-neu-lam-sai-thi-sao-sai-ung.sh`](examples/03-neu-lam-sai-thi-sao-sai-ung.sh)

**✅ ĐÚNG — phạm vi hẹp, có tech stack + cách chạy:**

> 📄 **Code ví dụ:** [`examples/04-neu-lam-sai-thi-sao-sai-ung.sh`](examples/04-neu-lam-sai-thi-sao-sai-ung.sh)

**Bài học:** scaffold chỉ đáng tin khi đề bài hẹp và cụ thể; mở ra chạy thử ngay — phần từ "chạy được" tới "đúng ý" luôn là việc của bạn.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Scaffold nhiều file lạ, chạy không lên | Mô tả ôm đồm, thiếu ràng buộc | Chia đề: 1 file / 1 notebook / 1 project nhỏ |
| Không đúng tech mong muốn | Không nêu stack trong mô tả | Thêm "bằng Node + TypeScript, không framework" vào đề |
| Nhầm `/new` với chat mới | Docs định nghĩa `/new` là scaffold, không phải new chat | Chat mới: `Ctrl+N`; `/new` là bài này |

## So sánh với Claude Code

| Việc | Copilot (`/new`) | Claude Code | Ghi chú |
|---|---|---|---|
| Scaffold project/file mới | Slash command có sẵn `/new`, `/newNotebook` | Không có lệnh riêng — mô tả bằng prompt, agent tự tạo file | Cùng việc, Copilot có lệnh chốt sẵn luồng |
| Chất lượng khung | Phụ thuộc mô tả + style repo | Phụ thuộc prompt + file mẫu bạn đưa | Bên nào cũng vậy: đề càng hẹp kết quả càng gọn |
| Kiểm chứng | Bạn mở + chạy thử ngay | Bạn vẫn phải chạy thử | Scaffold chưa chạy được coi như chưa xong |

## Best practices (kèm "vì sao")

- **Nêu tech stack + phạm vi 1 việc trong mô tả.** *Vì sao?* Không có ràng buộc, model tự "nâng cấp" đề bài thành app hoàn chỉnh không chạy nổi.
- **Chưa ưng thì hỏi tiếp trong cùng phiên** ("giữ nguyên file, thêm lệnh done"). *Vì sao?* Scaffold lần hai dễ mất những chỉnh sửa bạn đã áp vào bản đầu.
- **Mở ra là chạy thử, không đọc từng file một.** *Vì sao?* Lỗi cấu hình/khởi động lộ ra ngay khi chạy; đọc mò chậm hơn nhiều.
- **Coi scaffold là nháp: review diff trước khi commit.** *Vì sao?* Nó sinh dependency và script bạn có thể không cần tới.

## Bài tập nhỏ

1. **(5 phút)** Gõ `/newNotebook` với mô tả phân tích một file CSV thật của bạn; Run All thử bản sinh ra.
2. **(10 phút)** Scaffold "todo-cli" phạm vi hẹp, sau đó mô tả "app todo full-stack" — so sánh thời gian dọn của hai bản.
3. **(10 phút)** Thêm một tính năng vào scaffold cũ bằng câu "giữ nguyên những gì đang có, thêm ...", nhận xét diff.

## Tham khảo

- Docs: [AI features cheat sheet (bảng slash commands)](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet)
- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Code Actions.
- Cheatsheet 1 trang: [../../../../../CHEATSHEET.md](../../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Phân biệt với chat mới (`Ctrl+N`): [../../chat-session/new-chat/README.md](../../chat-session/new-chat/README.md).

> Chốt: `/new` là nút "dựng khung", không phải nút "viết hộ sản phẩm" — đề hẹp, có stack, chạy thử ngay, và đừng nhầm với chat mới.
