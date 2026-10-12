# /export — Lưu hội thoại ra file để share

> **Dành cho:** dev muốn lưu hoặc chia sẻ hội thoại · **Vấn đề:** kết quả hay nằm trong chat, không đưa được cho teammate/wiki · **Đọc xong:** export ra file markdown sạch, không lọt secrets (~2 phút)

## 1 câu nôm na

Chụp lại toàn bộ cuộc trò chuyện thành một file để lưu wiki hoặc gửi teammate. `/export` ghi đủ các turns + code blocks ra file markdown. Đây cũng là phao cứu sinh: trước khi `/new` hoặc `/clear` mà còn việc dở thì export trước.

Khác với copy-paste thủ công từng đoạn: export giữ nguyên thứ tự hội thoại và định dạng code, nên đọc lại không bị lộn xộn.

## Vì sao dùng /export?

Giá trị thật của một phiên chat thường nằm ở **đoạn giữa** — những lần thử sai, quyết định chốt, đoạn code cuối cùng. `/export` biến mạch hội thoại đó thành tài sản dùng lại được:

- **Bàn giao context** — người khác đọc file là nắm được bạn đã đi tới đâu.
- **Lưu vào wiki** — biến một lần debug thành tài liệu nội bộ.
- **Backup trước khi cắt** — `/new`/`/clear` không hoàn tác được, export là bảo hiểm.

**Nếu làm sai thì sao?** Rủi ro lớn nhất là **lọt secrets**: nếu bạn từng attach file chứa token rồi export nguyên, file markdown sẽ mang theo token đó. Ngoài ra chat 50+ turns export thẳng sẽ thành file khó đọc. Xem ❌/✅ và bảng lỗi.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** chat ra kết quả hay muốn lưu cho team; cần gửi context cho người khác tiếp tục; sắp `/new` hoặc `/clear` mà còn việc dở.
- **ĐỪNG dùng khi:** chat ngắn, không có gì đáng lưu — export chỉ tạo file rác trong repo.
- **Cho ai:** người cần bàn giao context, hoặc team muốn lưu chat hay vào wiki.

## Cách gọi (copy-paste)

```bash
/export
/export lưu chat này ra docs/chat-refactor-login.md
# Kỳ vọng: file markdown sạch, không lọt secrets
```

> Kiểm tra lệnh có ở máy bạn không: gõ `/` trong ô Chat, tìm `/export`. Không thấy → đọc `/status` + plan trước khi kết luận lỗi công cụ.

## Ví dụ thật

Nghiệp vụ: bạn vừa cùng Copilot chốt xong cách xử lý retry cho `apiClient`, muốn lưu vào wiki team để người sau khỏi mò lại.

```bash
# 1. Truoc khi export: soat xem chat co dinh token/key nao khong
# 2. Export ra file
/export lưu chat này ra docs/chats/retry-api-client.md
# Verify: mo file, doc lai 1 luot, da soat secrets
```

**Kết quả mong đợi:** File markdown chứa đủ turns + code blocks; share được, secrets đã soát.

**✅ Verify:** Mở file export, đọc lại 1 lượt thấy đủ ý là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — export nguyên xi một chat từng attach file có token, rồi đẩy lên wiki:**

```bash
/export lưu chat này ra docs/chats/retry-api-client.md
# File mang theo token da tung attach -> lo secret
```

**✅ ĐÚNG — soát secrets trước, xử lý phần dài, rồi mới export:**

```bash
# Chat dai 50+ turns -> nen /summarize truoc
/summarize nén chat này thành bản gọn để lưu
# Soat secrets: khong con token/key trong chat
/export lưu chat này ra docs/chats/retry-api-client.md
```

**Bài học:** Export là hành động *công khai hoá* — thứ gì trong chat cũng đi ra file. Soát secrets là bước không được bỏ.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| File export lọt secrets | Attach file chứa token rồi export nguyên | Soát secrets trước khi share; xóa token khỏi file |
| Export quá dài khó đọc | Chat 50+ turns | `/summarize` trước rồi export bản gọn |
| Không biết lưu đâu | Chưa quy ước chỗ lưu | Team chốt 1 folder `docs/chats/` |

## So sánh với Claude Code

| Việc | Copilot (`/export`) | Claude Code | Ghi chú |
|---|---|---|---|
| Lưu hội thoại ra file | `/export` ghi markdown đủ turns | Không có tương đương trực tiếp; tự copy hoặc dùng transcript session | Copilot có sẵn lệnh export |
| Lưu để bàn giao | File `.md` share được ngay | Tự ghi file thủ công | Cùng mục tiêu, khác mức tiện dụng |
| Soát secrets trước khi share | Bạn là người kiểm | Bạn là người kiểm | Không công cụ nào tự che secret |

## Best practices (kèm "vì sao")

- **Export ngay khi chat vừa ra kết quả hay.** *Vì sao?* Để lâu, bạn quên mất phiên nào đáng lưu và chat có thể bị xóa.
- **Chốt một folder chuẩn cho chat export.** *Vì sao?* Có quy ước thì team biết tìm ở đâu, không rải file khắp repo.
- **`/summarize` trước khi export chat dài.** *Vì sao?* Bản gọn dễ đọc hơn và vẫn giữ file + quyết định quan trọng.
- **Luôn soát secrets trước khi commit file export.** *Vì sao?* Một token lọt vào git history thì gỡ rất phiền.

## Bài tập nhỏ

1. **(3 phút)** `/export` một chat ngắn ra `docs/chats/`, mở file đọc lại xem có thiếu ý nào không.
2. **(5 phút)** Trước khi export, `/summarize` một chat dài 30+ turns rồi so sánh độ dễ đọc giữa hai bản.
3. **(5 phút)** Rà một chat cũ có attach file, đánh dấu xem có chỗ nào suýt lọt secret, rút ra checklist soát.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Chat Session.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Nén trước khi export: [../summarize/README.md](../summarize/README.md). Cắt context sau khi lưu: [../new-chat/README.md](../new-chat/README.md).

> Export là lúc biến một lần chat tốn kém thành tài liệu — nhưng nhớ: thứ gì trong chat cũng đi ra file, kể cả secret nếu bạn quên soát.
