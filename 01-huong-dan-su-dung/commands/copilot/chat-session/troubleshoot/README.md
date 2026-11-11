# /troubleshoot — đọc debug logs để chẩn đoán session đang lỗi

> **Dành cho:** người vừa gặp chat "bỗng dưng dở" — tool lỗi, câu trả lời lạ, chạy chậm · **Vấn đề:** đoán bệnh từ triệu chứng rồi sửa sai chỗ · **Đọc xong:** dùng `/troubleshoot` để Copilot tự phân tích log thay vì bạn mò từng dòng (~2 phút)
> **Harness:** Local · Copilot CLI · **Surface:** VS Code Chat (Local harness) hoặc Copilot CLI session — docs không đặt lệnh này ở Copilot harness

## 1 câu nôm na

Thợ sửa xe đời mới không nghe tiếng đoán bệnh — họ cắm máy đọc mã lỗi. `/troubleshoot` là cái máy đọc đó: nó lấy debug logs của session và phân tích xem chuyện gì thật sự xảy ra, bạn khỏi copy-paste log đi tìm từng dòng.

## Vì sao dùng /troubleshoot?

Vì "chat lạ lạ" là lớp triệu chứng mà nguyên nhân nằm dưới log: MCP không start, permission bị chặn, config sai tên file. Đọc log tay thì mất 20 phút và dễ đọc nhầm dòng; docs mô tả `/troubleshoot` đúng một việc: **phân tích debug logs** — và nó làm ở cuối chuỗi triệu chứng, khi bạn đã biết chuyện gì *không* ổn chứ chưa biết *vì sao*.

- **Thay vì đoán**: kết luận dựa trên log, không dựa trên ấn tượng.
- **Thay vì tự mò**: khỏi mở Output panel, khỏi lọc timestamp.
- **Có chỗ để đưa tiếp**: chẩn đoán xong còn nghi ngờ, bạn có nguyên văn log để dán vào issue.

> **Tóm gọn 1 câu:** `/troubleshoot` chuyển câu "sao chat kỳ vậy?" thành "log dòng này nói nguyên nhân là đây" — hết đoán mò.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** tool call báo lỗi không rõ nguyên nhân; session có dấu hiệu bất thường sau khi đổi cấu hình (MCP, instructions, settings); cần bằng chứng trước khi nghi ngờ công cụ.
- **ĐỪNG dùng khi:** vấn đề là tài khoản/plan (tra [FAQ 01](../../../../../03-cau-hoi-thuong-gap/01-tai-khoan-pricing-cai-dat.md)); hay chỉ muốn liệt kê lệnh khả dụng (bên Local có `/help` — [../../../local/chat-session/help/README.md](../../../local/chat-session/help/README.md)). Đừng mong `/troubleshoot` ở session Copilot harness — docs chỉ gắn nó với local hoặc Copilot CLI.
- **Phân biệt với `/debug`:** `/debug` mở Chat Debug view (surface Chat view), còn `/troubleshoot` phân tích log — hai lệnh hai việc.

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

> Gõ `/troubleshoot` không thấy? Kiểm tra bạn đang ở local chat hay Copilot CLI (hai nơi docs hỗ trợ), rồi reproduce lỗi một lần nữa để log có dữ liệu mới.

## Ví dụ thật

Nghiệp vụ: sau khi bạn đổi cấu hình MCP, agent báo "tool not available" nhưng không nói vì sao. Ở local chat, bạn gõ `/troubleshoot`; nó đọc debug logs và chỉ ra server MCP không khởi động được vì thiếu biến môi trường — đúng dòng, đúng file config.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh)

**Kết quả mong đợi:** Một bản phân tích nêu nguyên nhân khả nghi kèm dẫn chứng từ log (dòng/file nào), không chỉ là "thử lại xem".

**✅ Verify:** Làm đúng chỉ dẫn trong bản phân tích (vd bổ sung env var), lặp lại thao tác cũ — lỗi hết là chẩn đoán trúng.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI:** gọi `/troubleshoot` khi vừa restart, chưa hề reproduce lỗi — log chẳng có gì mới, nhận về một bản "không phát hiện bất thường".
**✅ ĐÚNG:** để lỗi xảy ra lại một lần, rồi mới `/troubleshoot`, kèm mô tả chuyện gì vừa diễn ra để việc phân tích log đúng hướng.

**Bài học:** Lệnh này ăn input là log. Không có log của sự cố thì không có chẩn đoán — "sửa xong rồi mới tra" là tra không khí.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Không thấy `/troubleshoot` trong chat Copilot harness | Docs gắn lệnh cho local session hoặc Copilot CLI | Chẩn đoán ở đúng surface, hoặc mở Copilot CLI để chạy |
| Kết luận chung chung, không có dẫn chứng | Chưa reproduce lỗi, log rỗng dữ liệu mới | Gây lại lỗi → chạy lại lệnh, mô tả thêm triệu chứng |
| Nghi ngờ nhầm tính năng vì hết hạn log | Debug logs không bật / bị ghi đè trước khi xem | Bật log rồi mới gây lại lỗi, chạy lệnh ngay sau đó |

## So sánh với Claude Code

| Việc | Copilot (`/troubleshoot`) | Claude Code | Ghi chú |
|---|---|---|---|
| Phân tích debug logs để chẩn đoán | `/troubleshoot` (local chat hoặc Copilot CLI) | Không có tương đương trực tiếp trong tài liệu đối chiếu | Phía CLI của Copilot, lệnh gắn nhãn Copilot CLI — nguồn docs GitHub |
| Mở view debug để soi log sống | `/debug` (Chat view) | Đọc log thủ công trong terminal | Khác nhau: một cái hiển thị, một cái phân tích |

## Best practices (kèm "vì sao")

- **Gây lại lỗi trước, troubleshoot sau.** *Vì sao?* Lệnh phân tích log của *vừa xảy ra*; log cũ dễ dẫn tới kết luận cũ.
- **Mô tả triệu chứng kèm lệnh** ("call tool X fail lúc 14:32"). *Vì sao?* Giúp khoanh vùng dòng log liên quan giữa một đống log vô hướng.
- **Lưu bản chẩn đoán vào file khi cần escalate.** *Vì sao?* Đưa cho maintainer/FAQ cả chẩn đoán + log còn giá trị hơn mỗi câu "nó hỏng".
- **Thử xong một fix thì chạy lại lệnh.** *Vì sao?* Xong việc thật sự là khi log im — không phải khi bạn "đoán là ổn".

## Bài tập nhỏ

1. **(3 phút)** Mở một local chat, gõ `/` và xác nhận `/troubleshoot` có trong danh sách trên máy bạn.
2. **(10 phút)** Gây một lỗi nhỏ có chủ đích (vd khai báo MCP server sai tên lệnh), chạy `/troubleshoot`, xem nó có chỉ đúng file config không.
3. **(5 phút)** So kết luận của `/troubleshoot` với việc bạn tự mở log đọc: khác nhau ở đâu, mất bao lâu mỗi cách.

## Tham khảo

- Index nhóm: [../README.md](../README.md) · [Commands index](../../../README.md)
- Nguồn docs: [VS Code — AI features cheat sheet](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet) · [GitHub — Copilot CLI command reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference)
- Bài liên quan: [bài 04 — Chat commands toàn tập](../../../../04-chat-commands-toan-tap.md) · [bài 08 — MCP kết nối công cụ ngoài](../../../../08-mcp-ket-noi-cong-cu-ngoai.md)
- Kẹt nặng: [FAQ troubleshooting](../../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md) · Anh em: [../history/README.md](../history/README.md)

> Trước khi nghi Copilot dốt, hãy để log lên tiếng — `/troubleshoot` là cái loa rẻ nhất để biết bệnh thật nằm ở đâu.
