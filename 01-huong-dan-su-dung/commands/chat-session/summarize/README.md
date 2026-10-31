# /summarize — Nén chat dài thành tóm tắt

> **Dành cho:** dev đang chat dài (>20 turns) sắp mất dấu · **Vấn đề:** model quên đầu bài, khó bàn giao việc dở · **Đọc xong:** nén chat thành bản gọn vẫn giữ file + quyết định, chuyển chat mới trơn (~2 phút)

## 1 câu nôm na

Nhờ thư ký tóm tắt cuộc họp hai tiếng thành năm gạch đầu dòng. `/summarize` gom chat dài thành bản tóm tắt "đã làm / đã chốt / còn dở". Chat dưới 10 turns thì chưa cần dùng.

Khác với đọc lại toàn bộ lịch sử: bản tóm tắt là thứ bạn **paste sang chat mới** để giữ tinh túy mà không mang theo cả mớ hội thoại.

## Vì sao dùng /summarize?

Khi phiên chat dài, hai việc cùng lúc trở nên khó: model quên đầu bài, và bạn khó bàn giao. `/summarize` giải quyết cả hai:

- **Nén context** — biến 40 turns thành bản gọn giữ file + quyết định.
- **Bàn giao** — người/agent khác đọc tóm tắt là tiếp được.
- **Chuyển chat mới trơn** — paste tóm tắt vào `/new` thay vì restart từ số 0.

**Nếu làm sai thì sao?** Rủi ro lớn nhất là **nén ẩu mất chi tiết**: chat quá dài, model tóm tắt bỏ sót file/số liệu quan trọng. Và vì model có thể "ảo giác" trong bản tóm tắt, bạn phải đọc lại trước khi share. Xem ❌/✅.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** chat >20 turns và model bắt đầu quên; bàn giao việc dở cho người/agent khác; trước khi `/new` mà muốn giữ tinh túy chat cũ.
- **ĐỪNG dùng khi:** chat ngắn (<10 turns) — summarize chỉ tốn thêm một lượt gọi mà không lợi gì.
- **Cho ai:** người bàn giao việc dở, hoặc ai chuẩn bị `/new` mà vẫn muốn giữ lại phần cốt lõi.

## Cách gọi (copy-paste)

```bash
/summarize
/summarize nén chat này thành 5 gạch + việc còn dở
# Kỳ vọng: bản tóm tắt gọn: đã làm / đã chốt / còn dở
```

> Kiểm tra lệnh có ở máy bạn không: gõ `/` trong ô Chat, tìm `/summarize`. Không thấy → đọc `/status` + plan trước khi kết luận lỗi công cụ.

## Ví dụ thật

Nghiệp vụ: bạn đã debug một bug websocket suốt 35 turns, đã chốt dùng thư viện `ws` và sửa 2 file, còn dở phần reconnection. Bạn muốn nén lại để chuyển sang chat mới làm tiếp.

```bash
/summarize "nén chat nay: da lam gi, quyet dinh nao da chot, con do gi, va liet ke file lien quan"
# Doc lai ban tom tat -> sua tay neu sot
# Mo /new, paste tom tat, hoi tiep
# Verify: chat moi theo duoc mach cu
```

**Kết quả mong đợi:** Bản tóm tắt gọn: đã làm / đã chốt / còn dở + file liên quan; paste sang chat mới là tiếp tục được.

**✅ Verify:** Mở chat mới, paste tóm tắt, hỏi tiếp — model theo được là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — tin 100% bản tóm tắt rồi share luôn, không đọc lại:**

```bash
/summarize "tom tat giup"   # model nen au, hoac bao sai file -> share luon -> nguoi sau lam sai
```

**✅ ĐÚNG — nói rõ phải giữ gì, rồi tự đọc lại trước khi dùng:**

```bash
/summarize "nen lai: Giu file + quyet dinh + so lieu quan trong. Liet ke file da sua."
# Doc lai ban tom tat, sua tay -> roi moi sang chat moi
```

**Bài học:** Tóm tắt là bản *do model viết*, không phải chân lý. Đọc lại và sửa tay là bước bắt buộc.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Tóm tắt mất chi tiết quan trọng | Chat quá dài, model nén ẩu | Bảo nó giữ lại: file + quyết định + số liệu; check lại 1 lượt |
| Tóm tắt sai (ảo giác) | Tin 100% không đọc | Đọc lại tóm tắt, sửa tay trước khi share |
| Chat ngắn cũng summarize | Lãng phí 1 lượt gọi | Chat <10 turns thì khỏi cần |

## So sánh với Claude Code

| Việc | Copilot (`/summarize`) | Claude Code | Ghi chú |
|---|---|---|---|
| Nén hội thoại dài | `/summarize` thành bản gọn | Có `/compact` để nén context | Cùng mục đích: giữ tinh túy, cắt độ dài |
| Bàn giao việc dở | Paste bản tóm tắt sang chat/người khác | Chia sẻ/bàn giao qua context | Cùng ý tưởng |
| Kiểm chứng bản tóm tắt | Bạn đọc lại, sửa tay | Bạn đọc lại | Không công cụ nào nén mà bảo toàn 100% |

## Best practices (kèm "vì sao")

- **Nói rõ "giữ lại file + quyết định + số liệu".** *Vì sao?* Model nén theo mặc định dễ bỏ sót đúng những thứ cần giữ.
- **Đọc lại và sửa tay trước khi share.** *Vì sao?* Bản tóm tắt có thể sai/ảo giác; người đọc sau tin nó là bạn chịu trách nhiệm.
- **Dùng ngay trước `/new` để chuyển mạch.** *Vì sao?* Giữ được đà task mà vẫn có đầu bài sạch cho phiên mới.
- **Đừng tóm tắt chat ngắn.** *Vì sao?* Dưới 10 turns chưa có vấn đề context; chỉ tốn thêm một lượt gọi.

## Bài tập nhỏ

1. **(3 phút)** Lấy một chat 20+ turns, `/summarize` rồi kiểm tra xem nó có giữ đúng file + quyết định không.
2. **(5 phút)** Paste bản tóm tắt vào một `/new` và hỏi tiếp — xác nhận mạch task không đứt.
3. **(5 phút)** Cố tình `/summarize` một chat 5 turns và nhận xét lợi/hại — rút ra ngưỡng dùng cho bản thân.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Chat Session.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Chuyển sang chat mới: [../new-chat/README.md](../new-chat/README.md). Lưu ra file: [../export/README.md](../export/README.md).

> `/summarize` không giữ mọi thứ — nó giữ *thứ bạn bảo nó giữ*. Nên hãy nói rõ, rồi đọc lại: bản gọn tốt là bản bạn đã kiểm.
