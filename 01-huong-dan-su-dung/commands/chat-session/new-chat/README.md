# /new — Mở chat mới sạch sẽ, nhẹ quota

> **Dành cho:** dev bắt đầu task mới trong VS Code · **Vấn đề:** chat cũ dài khiến model lẫn context, trả lời lan man · **Đọc xong:** biết chính xác lúc nào gõ `/new`, có prompt mẫu copy-paste và cách kiểm tra (~2 phút)

## 1 câu nôm na

Đóng chat cũ đang rối, mở tờ giấy trắng để bắt đầu task mới. `/new` dựng một chat trắng tinh — history cũ không lẫn vào — nhưng instructions vẫn được nạp lại từ file trong repo. Gắn scope gọn thì thường 1–2 turns là xong.

Khác với gõ tay một prompt mới trong chat cũ: ở đây bạn **chủ động cắt** toàn bộ mạch hội thoại trước đó, nên model không còn "nhớ dai" chuyện task cũ.

## Vì sao dùng /new?

Chat càng dài thì hai thứ xấu đi cùng lúc: model bị **loãng trọng tâm** (attention dilution) và mỗi turn lại **nạp lại toàn bộ history cũ** vào context. Hệ quả là bạn vừa nhận câu trả lời lan man, vừa đốt token vô ích.

`/new` giải quyết cả hai:

- **Đầu bài sạch** — model chỉ thấy task mới, không bị ám bởi quyết định của task cũ.
- **Nhẹ quota** — không nạp lại N turns cũ mỗi lần hỏi.
- **Chốt scope từ turn 1** — thay vì sửa dần từ một mớ context hỗn độn.

**Nếu làm sai thì sao?** Lỗi hay gặp nhất là gõ `/new` khi việc đang dở còn dang dở mà chưa lưu gì — coi như mất luôn mạch. Cách tránh: `/export` trước khi `/new` nếu bạn còn cần phần cũ.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** bắt đầu task mới khác hẳn task cũ; chat hiện tại đã dài và model bắt đầu lan man; muốn chốt scope + model ngay từ turn 1.
- **ĐỪNG dùng khi:** chỉ muốn hỏi tiếp việc đang dở — lúc đó dùng `/resume`. Và đừng `/new` khi chưa export nếu phần cũ còn giá trị.
- **Cho ai:** mọi người mở task mới hằng ngày — người mới nên xem đây là thói quen #1 mỗi task.

## Cách gọi (copy-paste)

```bash
/new
/new bắt đầu task refactor login, cho checklist 5 bước
# Kỳ vọng: chat trắng sạch, history cũ không lẫn
```

> Kiểm tra lệnh có ở máy bạn không: gõ `/` trong ô Chat, tìm `/new`. Không thấy → đọc `/status` + plan trước khi kết luận lỗi công cụ.

## Ví dụ thật

Nghiệp vụ: bạn vừa debug xong bug login trong chat cũ, giờ sang task mới là thêm rate-limit. Trước khi đổi task, lưu lại phần debug.

```bash
# 1. Luu lai viec dang do truoc khi cat context
/export lưu chat debug login này ra docs/chats/debug-login.md

# 2. Mo chat moi + chot scope ngay turn 1
/new bắt đầu task thêm rate-limit cho POST /login: cho tôi checklist 5 bước và danh sách file cần đọc
# Verify: hoi tiep 1 cau, model khong nhac chuyen debug login cu
```

**Kết quả mong đợi:** Chat trắng + checklist 5 bước đúng scope; history cũ (phần debug login) không lẫn vào.

**✅ Verify:** Hỏi tiếp 1 câu follow-up — nếu model không nhắc chuyện chat cũ là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — `/new` ngay giữa việc dở, chưa lưu gì:**

```bash
/new   # context debug login chua export -> mat mach, phai ke lai tu dau
```

**✅ ĐÚNG — export trước, rồi mới mở chat trắng kèm scope:**

```bash
/export lưu chat này ra docs/chats/debug-login.md
/new bắt đầu task thêm rate-limit cho POST /login, cho checklist 5 bước
```

**Bài học:** `/new` là cắt cầu, không phải dọn nhà. Muốn giữ cái gì thì `/export` trước.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Gõ `/new` mất hết context đang cần | Xóa cả phần còn dở | `/export` trước khi `/new` nếu còn việc dở |
| Kết quả chung chung | Không kèm mô tả sau `/new` | Gọi lại kèm file + mong đợi rõ |
| Không thấy `/new` trong list `/` | Extension cũ / plan gating | `/status` → xem plan → update extension |

## So sánh với Claude Code

| Việc | Copilot (`/new`) | Claude Code | Ghi chú |
|---|---|---|---|
| Bắt đầu mạch hội thoại sạch | `/new` dựng chat trắng | `/clear` xóa context phiên, hoặc mở phiên `claude` mới | Cùng mục đích: cắt context cũ trước task mới |
| Giữ lại config repo | Instructions + MCP vẫn nạp lại từ file | `CLAUDE.md` + `.claude/` vẫn còn | Không bên nào mất "luật" khi cắt hội thoại |
| Lưu phần cũ trước khi cắt | `/export` ra file markdown | Không có tương đương trực tiếp (tự copy/ghi file) | Copilot có sẵn lệnh export |

## Best practices (kèm "vì sao")

- **Một task = một `/new`.** *Vì sao?* Chat dài làm rule loãng và model quên đầu bài; mỗi task sạch đầu bài thì trả lời trúng hơn.
- **`/export` trước khi `/new` nếu còn việc dở.** *Vì sao?* `/new` không có undo — cắt rồi không lấy lại context cũ.
- **Gắn scope ngay trong câu gọi `/new`.** *Vì sao?* Turn 1 đã có scope thì bạn bớt được 1–2 turns chỉnh hướng.
- **Đổi model ngay ở chat mới khi cần.** *Vì sao?* Task khó cần model mạnh, task dễ dùng model rẻ — chat mới là lúc chọn lại "bộ não".

## Bài tập nhỏ

1. **(3 phút)** Mở một chat đã có ≥10 turns, rồi `/new` và hỏi lại câu hỏi đầu tiên. So sánh độ tập trung của câu trả lời giữa hai chat.
2. **(5 phút)** Thực hành cặp lệnh: `/export` chat cũ → `/new` kèm mô tả task mới, kiểm tra model không nhắc chuyện cũ.
3. **(5 phút)** Gõ `/new` **không** kèm mô tả, xem kết quả chung chung thế nào; gọi lại có scope để thấy khác biệt.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Chat Session.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Lưu phần cũ trước khi cắt: [../export/README.md](../export/README.md). Quay lại việc dở: [../resume/README.md](../resume/README.md).

> `/new` không làm model thông minh hơn — nó chỉ trả model về đúng một đầu bài. Đó thường là thứ quyết định chất lượng câu trả lời.
