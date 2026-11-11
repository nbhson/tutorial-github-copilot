# Bucket `copilot/` — 43 lệnh của Copilot harness

> **Dành cho:** người dùng mặc định của khoá học · **Vấn đề:** không chắc lệnh này thuộc harness nào · **Đọc xong:** hiểu bucket này là gì và tra nhanh sang đúng nhóm (~1 phút).

Bucket này chứa các lệnh **chạy được ở Copilot harness** — Copilot in VS Code (Chat view, chế độ agent mặc định), Copilot CLI, và các điểm tương ứng trên GitHub.com. Khuôn chi tiết: `copilot/<nhóm>/<slug>/README.md`; nguồn sự thật bucket: [`../bucket.tsv`](../bucket.tsv).

> **Chú ý:** một số dòng ở đây là **feature của Chat view / editor** (Session History, checkpoint, Customizations editor) chứ không phải slash command — README từng slug ghi đúng hình thức gọi. Ngược lại, thứ có dấu `/` nhưng chỉ Local chạy (`/export`, `/help`) nằm ở [`../local/`](../local/README.md).

## Bốn nhóm

| Nhóm | Lệnh | Tra khi |
|---|---|---|
| [Chat & phiên](./chat-session/README.md) | 12 | mở đầu phiên, gắn scope, nén, tìm lại, fork, phím tắt |
| [Model & agent](./model-agent/README.md) | 8 | chọn Ask/Plan/Agent, model, Session Target, credits, approval, sandbox |
| [Code actions](./code-actions/README.md) | 11 | `/explain` `/fix` `/tests` `/doc` `/commit` `/pr` `/plan`… |
| [System & kiến thức repo](./system-knowledge/README.md) | 12 | `/status` `/login` `/mcp` `/instructions` `/skills` `/plugin` `/hooks`… |

## Ba slug nên mở đầu tiên

- [new-chat](./chat-session/new-chat/README.md) — thói quen "mỗi task một phiên sạch" (`Ctrl+N`).
- [agent-mode](./model-agent/agent-mode/README.md) — khung 6 bước giao việc cho agent.
- [status](./system-knowledge/status/README.md) — 30 giây chẩn đoán trước khi hỏi "sao Copilot không chạy".

## Khuôn README trong bucket

1. **Dòng `> **Harness:** Copilot · **Surface:** …`** — surface chính xác (Chat view / CLI / Copilot app…).
2. 1 câu nôm na · vì sao dùng · khi nào đừng.
3. Cách gọi copy-paste + ví dụ thật + ✅ Verify.
4. ❌ SAI / ✅ ĐÚNG · bảng so Claude Code · best practices kèm "vì sao" · bài tập · nguồn docs.

## Lỗi tra cứu thường gặp

**❌ SAI — thấy một slash nằm ở `copilot/` là tưởng mọi client Copilot đều có.** *Vì sao sai:* CLI, Chat view và cloud surface mỗi bên một subset — đọc dòng **Surface** trong README slug.

**✅ ĐÚNG — tra 3 bước:** bucket nào (harness của bạn) → nhóm nào (loại việc) → README slug (dòng Surface + cách gọi).

**Bài học:** harness trước, nhóm lệnh sau — tránh tra lệnh của môi trường bạn không dùng.

## Tham khảo

- [../README.md](../README.md) — index toàn cây · [Bucket `local/`](../local/README.md) — legacy VS Code · [Bucket `cloud/`](../cloud/README.md) — việc chạy ngoài máy bạn.

> **Chốt:** `copilot/` là nơi bạn sống hằng ngày — 43 lệnh này cover 90% tương tác với Copilot harness; hai bucket kia tồn tại để trả lời "sao lệnh cũ không chạy" và "AI làm gì khi tôi tắt máy".
