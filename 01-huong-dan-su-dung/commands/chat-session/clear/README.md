# /clear — Xóa turns hiện tại, giữ settings

> **Dành cho:** dev đang chat dồn 1 phiên dài · **Vấn đề:** model bắt đầu quên đầu bài nhưng bạn vẫn cần giữ instructions/MCP · **Đọc xong:** reset turns mà không mất cấu hình, kèm cách cứu việc đang dở (~2 phút)

## 1 câu nôm na

Lau bảng đen cho sạch, nhưng phấn, bảng và quy định lớp vẫn còn nguyên. `/clear` chỉ xóa các turns hiện tại; instructions trong repo và các MCP server đang kết nối vẫn giữ. Gắn scope gọn thì 1–2 turns là xong.

Khác `/new`: `/clear` là "lau bảng" trong khi vẫn đứng cùng lớp, còn `/new` là mở tờ giấy mới. Nếu bạn cần giữ nguyên phiên và chỉ muốn bớt context thì `/clear` là đúng lựa chọn.

## Vì sao dùng /clear?

Khi một phiên chat phình to, model bắt đầu quên đầu bài — nhưng reset kiểu gì cũng phải trả giá. `/new` cắt cả phiên; đôi khi bạn chỉ muốn **gột sạch turns** mà vẫn giữ nguyên bối cảnh đã setup (instructions, MCP). `/clear` cho bạn điều đó:

- **Bỏ turns cũ** đang làm nhiễu context.
- **Giữ cấu hình** — instructions nạp lại từ file, MCP vẫn connected.
- **Nhẹ quota** — không nạp lại N turns cũ ở mỗi câu hỏi sau đó.

**Nếu làm sai thì sao?** Có ba ngộ nhận hay gặp: (1) tưởng `/clear` xóa cả instructions; (2) clear xong vẫn lan man vì scope còn rộng; (3) mất việc dở vì quên export. Cả ba đều tránh được — xem mục ❌/✅ và bảng lỗi bên dưới.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** chat dài quá và model bắt đầu quên đầu bài; muốn giữ instructions/MCP nhưng bỏ turns cũ; chuẩn bị paste task mới vào cùng repo.
- **ĐỪNG dùng khi:** bạn muốn cắt hẳn sang phiên mới sạch cấu hình — đó là việc của `/new`. Và đừng clear khi việc dở chưa export.
- **Cho ai:** ai cũng dùng được — nhất là người mở một chat rồi hỏi dồn cả ngày.

## Cách gọi (copy-paste)

```bash
/clear
# Kỳ vọng: turns cũ biến mất, instructions + MCP vẫn còn
```

> Kiểm tra lệnh có ở máy bạn không: gõ `/` trong ô Chat, tìm `/clear`. Không thấy → đọc `/status` + plan trước khi kết luận lỗi công cụ.

## Ví dụ thật

Nghiệp vụ: bạn đang giữa phiên sửa `payment.ts` với MCP `github` đang kết nối, nhưng đã 30 turns và model bắt đầu nhắc lại chuyện cũ. Bạn muốn reset context nhưng **giữ** MCP và instructions.

```bash
# 1. Con dang do -> luu truoc
/export lưu chat đang sửa payment ra docs/chats/payment-wip.md

# 2. Lau bang, giu nguyen cau hinh
/clear
# Verify: hoi "liet ke quy tac dang ap dung" -> van tra loi duoc
```

**Kết quả mong đợi:** Turns cũ biến mất, instructions + MCP servers vẫn còn; chat nhẹ lại.

**✅ Verify:** Hỏi "liệt kê quy tắc đang áp dụng" — vẫn trả lời được là đạt (chứng tỏ instructions chưa mất).

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — `/clear` xong tưởng mất hết cấu hình, hoảng rồi setup lại từ đầu:**

```bash
/clear   # roi di cau hinh lai MCP / viet lai instructions -> mat thoi gian vo ich
```

**✅ ĐÚNG — biết `/clear` chỉ xóa turns, và luôn export trước khi clear việc dở:**

```bash
/export lưu chat này ra docs/chats/payment-wip.md
/clear
# Hoi lai 1 cau -> van thay instructions + MCP con nguyen
```

**Bài học:** `/clear` là lau bảng, không phải đổi lớp. Cái mất chỉ là mạch hội thoại — cấu hình nằm ở file, không nằm trong turns.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Tưởng `/clear` xóa cả instructions | Nhầm với `/new` hoặc reset settings | Yên tâm: instructions load lại từ file, chỉ turns mất |
| Clear xong vẫn trả lời lan man | Scope chưa gọn (vẫn attach cả repo) | Gắn lại `#file` gọn rồi hỏi lại |
| Mất việc dở không cứu được | Quên export trước | `/export` trước khi `/clear` nếu cần giữ |

## So sánh với Claude Code

| Việc | Copilot (`/clear`) | Claude Code | Ghi chú |
|---|---|---|---|
| Xóa context hội thoại | `/clear` bỏ turns, giữ instructions/MCP | `/clear` xóa conversation history | Gần như tương đương 1-1 về ý tưởng |
| Giữ cấu hình repo | Instructions + MCP nạp lại từ file | `CLAUDE.md` + `.claude/` vẫn còn | Cả hai đều không mất config khi clear |
| Phân biệt với cắt cả phiên | `/new` (chat mới) vs `/clear` (lau turns) | Không có tương đương `/new` trực tiếp — mở session mới | Copilot tách rõ hai mức: lau turns và mở phiên mới |

## Best practices (kèm "vì sao")

- **Export trước khi `/clear` nếu còn việc dở.** *Vì sao?* `/clear` không hoàn tác được turns đã xóa.
- **Clear khi bắt đầu một chủ đề mới trong cùng repo.** *Vì sao?* Giữ lại instructions/MCP đã setup, chỉ bỏ phần hội thoại không còn liên quan.
- **Sau clear, gắn scope lại từ đầu.** *Vì sao?* Clear mà vẫn `@workspace` cả repo thì context nhanh phình lại như cũ.
- **Đừng clear liên tục cho chat ngắn (<10 turns).** *Vì sao?* Chat ngắn chưa có vấn đề context; clear chỉ thêm một bước vô ích.

## Bài tập nhỏ

1. **(3 phút)** Trong một chat có MCP đang connected, gõ `/clear` rồi hỏi "liệt kê quy tắc đang áp dụng" — xác nhận instructions vẫn còn.
2. **(5 phút)** So sánh `/clear` và `/new` trên cùng một việc: ghi lại cái nào giữ MCP, cái nào không.
3. **(5 phút)** Thử `/clear` rồi hỏi lại **không** gắn scope, cảm nhận context phình lại; sau đó clear lại và hỏi có `#file` gọn.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Chat Session.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Lưu phần cũ: [../export/README.md](../export/README.md). Mở phiên sạch hoàn toàn: [../new-chat/README.md](../new-chat/README.md).

> `/clear` là mức "lau bảng": đủ để lấy lại sự tập trung của model mà không phải kết nối lại MCP hay nạp lại instructions.
