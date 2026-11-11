# Session History — Tìm và mở lại chat cũ

> **Dành cho:** dev muốn tìm lại chat cũ · **Vấn đề:** không nhớ đã nói gì hôm qua, cần so sánh 2 cách làm ở 2 phiên · **Đọc xong:** tìm và mở lại đúng phiên trong vài giây (~2 phút)
> **Harness:** Copilot · **Surface:** danh sách phiên ở Chat view / Agents window (không phải slash command)

## 1 câu nôm na

Mở sổ đầu bài cũ ra xem lại rồi viết tiếp từ chỗ hôm qua dừng. Lưu ý trước: **không có slash `/history`** — VS Code không dạy lệnh này. Lịch sử nằm ở **danh sách phiên (Session History)**: đầu Chat view (gom theo thời gian, theo workspace) hoặc sidebar Agents window (xuyên workspace).

Gõ `/` không thấy "history" là đúng thiết kế. Đây cũng là bước đệm cho việc mở lại phiên: chưa nhớ tên thì lướt list, đã biết tên thì tìm filter/Chronicle.

## Vì sao dùng Session History?

Trí nhớ của bạn không phải nơi lưu tốt nhất cho hàng chục phiên chat. Danh sách phiên cho bạn:

- **Tìm lại bối cảnh cũ** — không phải kể lại từ đầu.
- **So sánh hai phiên** — bạn đã thử cách A ở chat này, cách B ở chat kia; mở lại để đối chiếu.
- **Thu hoạch lại prompt hay** — những prompt hiệu quả nằm trong history, lôi ra làm template.

**Nếu làm sai thì sao?** Ngộ nhận lớn nhất là tin rằng mở lại chat cũ là model "nhớ hết". History giữ transcript hội thoại; các trạng thái tool (file đang mở, output terminal đang treo) có thể không còn nguyên. Mở lại nên nhắc lại vài dòng bối cảnh — xem ❌/✅.

> **Tóm gọn 1 câu:** Session History là sổ đầu bài của các phiên chat — tìm lại nhanh, nhưng mở lại thì vẫn phải nhắc bối cảnh trước khi giao việc.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** muốn tiếp tục việc hôm qua làm dở; so sánh hai cách giải quyết ở hai chat khác nhau; tìm lại prompt hay để lưu thành template.
- **ĐỪNG dùng khi:** bạn chỉ muốn một đầu bài sạch để bắt task mới — mở chat mới (`Ctrl+N`), lục history làm gì cho thêm nhiễu.
- **Cho ai:** người làm việc multi-day, hay so sánh solution giữa các phiên khác nhau.

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

> List ẩn trong Chat view? Chuột phải vùng chat trống → **Show Sessions**. Phiên đã xong bị ẩn? Đổi filter sang **Archived** (Chat view) / **Done** (Agents window). Tìm theo chủ đề/file thay vì lướt list: hỏi Chronicle (`/chronicle:search <từ khóa>`, docs session-history).

## Ví dụ thật

Nghiệp vụ: tuần trước bạn thử hai hướng fix bug timezone — một ở chat "tz-utc-offset", một ở chat "tz-library". Giờ cần mở lại chat dùng thư viện để so với hướng còn lại.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh)

**Kết quả mong đợi:** Thấy list phiên cũ theo thời gian; mở lại đúng phiên, tiếp tục không cần giải thích lại từ đầu.

**✅ Verify:** Nhắn 1 câu follow-up, model nhớ context cũ là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — gõ `/history`, `/resume` trong ô chat như thói quen cũ:**

> 📄 **Code ví dụ:** [`examples/03-neu-lam-sai-thi-sao-sai-ung.sh`](examples/03-neu-lam-sai-thi-sao-sai-ung.sh)

**✅ ĐÚNG — mở list phiên, chọn đúng chat, nhắc 3 dòng bối cảnh rồi hỏi tiếp:**

> 📄 **Code ví dụ:** [`examples/04-neu-lam-sai-thi-sao-sai-ung.sh`](examples/04-neu-lam-sai-thi-sao-sai-ung.sh)

**Bài học:** Cửa vào lịch sử là danh sách phiên (và Chronicle khi cần search), không phải slash. Mở lại thì nhắc lại bối cảnh bằng lời.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Không thấy chat hôm qua | Chat ở máy/profile khác, hoặc đã archive | Check đúng VS Code profile + máy; bật filter **Archived/Done** |
| Mở lại nhưng model quên chi tiết tool | Trạng thái tool không đi theo transcript | Tóm tắt lại 3 dòng rồi hỏi tiếp |
| List quá dài khó tìm | Đặt tên chat xấu + không tìm theo chủ đề | Đặt tên rõ; hỏi Chronicle theo file/chủ đề; export chat hay ra file |

## So sánh với Claude Code

| Việc | Copilot (Session History) | Claude Code | Ghi chú |
|---|---|---|---|
| Xem lại phiên cũ | Danh sách phiên (Chat view/Agents window) + filter Archived | `claude --resume` chọn session | Cùng ý tưởng: liệt kê phiên để mở lại |
| Tìm theo nội dung | `/chronicle:search <q>` (docs session-history) | Đọc lại từng session | Copilot có lớp search, Claude lướt list |
| So sánh hai phiên | Mở từng phiên trong list | Mở từng session | Không bên nào "diff" hai phiên tự động |

## Best practices (kèm "vì sao")

- **Đặt tên chat có nghĩa, đừng để mặc định.** *Vì sao?* List dài cỡ nào cũng tìm được nếu tên gợi đúng việc.
- **Export chat giá trị cao ngay khi xong.** *Vì sao?* History nằm theo profile/máy — file export thì cầm được, bàn giao được.
- **Mở lại chat cũ thì nhắc lại bối cảnh.** *Vì sao?* Transcript không đảm bảo còn nguyên trạng thái tool; nhắc lại giúp model bắt nhịp nhanh.
- **Dùng history để so sánh, không để gộp.** *Vì sao?* Gộp nhiều phiên vào một chỗ dễ làm lẫn context; giữ tách phiên rõ ràng dễ đối chiếu hơn.

## Bài tập nhỏ

1. **(3 phút)** Mở danh sách phiên ở đầu Chat view, đếm xem bạn có bao nhiêu phiên chưa đặt tên. Đặt lại tên cho 3 phiên quan trọng nhất.
2. **(5 phút)** Tìm một chat cũ, mở lại, nhắn follow-up mà **không** nhắc bối cảnh — ghi lại model quên gì; rồi nhắc bối cảnh và hỏi lại.
3. **(5 phút)** Lấy một prompt hay trong history, xuất chat ra file (palette: "Chat: Export Chat…") làm template dùng lại.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Chat Session.
- Docs: [Session history](https://code.visualstudio.com/docs/agents/run/sessions/session-history) · [Manage sessions](https://code.visualstudio.com/docs/agents/run/sessions/manage-sessions)
- Cheatsheet 1 trang: [../../../../../CHEATSHEET.md](../../../../../CHEATSHEET.md). Kẹt thì tra [FAQ troubleshooting](../../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Tiếp tục phiên đã lưu: [../resume/README.md](../resume/README.md). Lưu chat ra file: [export](../../../local/chat-session/export/README.md).

> Lịch sử chat không nằm sau một dấu `/` — nó nằm trong danh sách phiên, ngay đầu Chat view; biết chỗ nhìn thì "hôm qua nói gì" chỉ tốn ba giây.
