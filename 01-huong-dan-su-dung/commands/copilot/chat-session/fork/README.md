# /fork — rẽ nhánh cuộc hội thoại, giữ nguyên history

> **Dành cho:** dev muốn thử phương án B mà không phá mạch phương án A · **Vấn đề:** hỏi rẽ nhánh trong cùng chat khiến hai luồng lộn xộn, model lẫn lộn · **Đọc xong:** dùng `/fork` để tách branch hội thoại kèm lịch sử (~2 phút)
> **Harness:** Copilot · **Surface:** VS Code Chat (Copilot harness) — cần session chạy qua Agent Host được hỗ trợ

## 1 câu nôm na

Save game trước trận boss: bản gốc giữ nguyên, bạn copy file save ra hai bản — bản A đánh bằng lửa, bản B đánh bằng băng. `/fork` copy cả cuộc hội thoại (kèm history) sang một session mới để bạn hỏi tiếp hướng khác, còn mạch chính không nhúc nhích. · 📄 [VS Code Docs: Sessions (concept)](https://code.visualstudio.com/docs/agents/concepts/sessions)

## Vì sao dùng /fork?

Vì có những lúc một chat phải chứa hai giả thuyết, mà để chung thì cả hai đều bẩn: model bắt đầu lẫn "cách A" với "cách B", và bạn không dám hỏi câu risky vì sợ hỏng mạch đang làm. `/fork` giải quyết bằng tách phiên thay vì gộp prompt:

- **Giữ nguyên bản gốc** — history của mạch chính không bị pha câu hỏi thử nghiệm.
- **Mang theo ngữ cảnh** — branch sinh ra đã "biết" 20 turns trước, không phải giải thích lại từ đầu.
- **Thử sai không tốn** — branch hỏng thì bỏ, mạch chính vẫn chạy tiếp.

docs buộc một điều kiện: `/fork` (và `/fork <title>`, `/fork prompt <…>`) cần **Agent Host session** được hỗ trợ — Agent Host là process riêng chạy harness và quản lý session, không phải mọi phiên đều đi qua nó.

> **Tóm gọn 1 câu:** `/fork` là save-game cho hội thoại: nhân bản cả mạch chuyện sang branch mới để thử hướng khác mà không động vào bản gốc. · 📄 [VS Code Docs: Sessions (concept)](https://code.visualstudio.com/docs/agents/concepts/sessions)

## Khi nào dùng / khi nào đừng

- **Dùng khi:** muốn so sánh 2 phương án song song; định hỏi câu exploration dài mà đang dở task chính; muốn "làm thử" một hướng risky trên bản sao của cuộc nói chuyện.
- **ĐỪNG dùng khi:** muốn hoàn tác **file** agent đã sửa — đó là checkpoint/`Restore checkpoint` ([bài 11](../../../../11-git-worktrees-checkpoints.md)); muốn mở phiên sạch không ngữ cảnh — đó là [../new-chat/README.md](../new-chat/README.md); muốn chat ngắn lại — đó là [../compact/README.md](../compact/README.md).
- **Cho ai:** người hay "hay là thử cách kia?" giữa chừng một phiên dài. · 📄 [VS Code Docs: Pick the right tool](https://code.visualstudio.com/docs/agents/best-practices#pick-the-right-tool-for-the-task)

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

> Ba dạng docs liệt kê: `/fork` (branch không tên), `/fork <title>` (branch kèm tên), `/fork prompt <…>` (branch rồi đi tiếp bằng câu hỏi đưa kèm). Không thấy `/fork` khi gõ `/` → kiểm tra [session-target](../../model-agent/session-target/README.md) xem phiên có chạy qua Agent Host không. · 📄 [VS Code Docs: Fork a chat session](https://code.visualstudio.com/docs/agents/run/sessions/manage-sessions#fork-a-chat-session)

## Ví dụ thật

Nghiệp vụ: bạn đang refactor service `user` được 20 turns, phát sinh nghi vấn "hay là tách bảng thay vì thêm cột?" — mà hỏi luôn thì mạch đang làm bị loãng. Bạn gõ `/fork tách-bảng-hay-thêm-cột` rồi hỏi tiếp giả thuyết tách bảng trong branch; branch kết luận "không, đắt hơn". Quay về mạch chính, nó vẫn dừng đúng chỗ đang sửa `user.ts`.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh) · 📄 [VS Code Docs: Prompt examples](https://code.visualstudio.com/docs/agents/guides/prompt-examples)

**Kết quả mong đợi:** Xuất hiện session mới mang nội dung hội thoại cũ; hai bên tiếp tục độc lập, không lẫn turns.

**✅ Verify:** Mở Session History — thấy cả hai phiên; ở mạch chính hỏi "nãy giờ ta sửa file nào?" và nhận được danh sách cũ (chứng tỏ branch không nuốt hội thoại gốc).

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI:** fork xong tưởng code cũng được rẽ nhánh — agent đã sửa file thật thì fork **không** trả lại chúng; nó chỉ phân nhánh hội thoại.
**✅ ĐÚNG:** muốn code lùi theo mốc cũ thì dùng Restore checkpoint; muốn hội thoại rẽ nhánh mới dùng `/fork`.

**Bài học:** fork tách *cuộc chuyện*, checkpoint tách *file trên đĩa*. Nhầm hai cái là mất trắng một bên: hoặc giữ code sai trong câu chuyện đúng, hoặc mất file mà tưởng đã an toàn. · 📄 [VS Code Docs: Choose a troubleshooting path](https://code.visualstudio.com/docs/agents/agent-troubleshooting/troubleshooting#choose-a-troubleshooting-path)

## Lỗi thường gặp

📄 [VS Code Docs: Fork the conversation](https://code.visualstudio.com/docs/agents/guides/get-agent-back-on-track#fork-the-conversation)

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Gõ `/` không có `/fork` | Session không chạy qua Agent Host được hỗ trợ | Kiểm tra Session Target; xem bài 02 về các bề mặt |
| Fork xong model vẫn lẫn hai luồng | Tiếp tục hỏi tới lui giữa hai branch | Chọn một branch làm mạch chính, branch kia dùng xong bỏ |
| Muốn "quay lại trước khi agent sửa file" | Nhầm fork với checkpoint | Dùng Restore checkpoint — [../checkpoints/README.md](../checkpoints/README.md) |
## So sánh với Claude Code

📄 [VS Code Docs: Agent Harnesses](https://code.visualstudio.com/docs/agents/concepts/agent-harnesses)

| Việc | Copilot (`/fork`) | Claude Code | Ghi chú |
|---|---|---|---|
| Phân nhánh hội thoại kèm history | `/fork`, `/fork <title>`, `/fork prompt <…>` | Không có tương đương trực tiếp trong tài liệu đối chiếu | Fork cần Agent Host session, ràng buộc phía VS Code |
| Quay lui *file* về mốc cũ | `Restore checkpoint` | Không có tương đương trực tiếp | Đây là hàng xóm của fork, không phải bản sao của nó |
## Best practices (kèm "vì sao")

- **Đặt tên branch ngay khi fork (`/fork <title>`).** *Vì sao?* Vài branch không tên lẫn nhanh trong Session History, và bạn quên cái nào kết luận gì.
- **Fork *trước* câu hỏi exploration, không phải sau khi nó đã vào mạch chính.** *Vì sao?* Đã pha rồi thì history gốc vẫn bẩn — fork chỉ sạch nếu tách trước.
- **Kết thúc branch thì chắt kết luận 2–3 dòng về mạch chính.** *Vì sao?* Branch là chỗ thử, còn chỗ làm là mạch chính; mang cả branch về là mang cả nhiễu.
- **Đừng fork để "lưu" chat — muốn lưu thì export.** *Vì sao?* Fork tạo phiên mới để hỏi tiếp, không tạo file nào cả. · 📄 [VS Code Docs: Fork conversations](https://code.visualstudio.com/docs/agents/guides/optimize-usage#fork-conversations)

## Bài tập nhỏ

1. **(3 phút)** Ở một chat Copilot harness đang có ≥5 turns, gõ `/fork` — xác nhận session branch xuất hiện kèm nội dung cũ.
2. **(5 phút)** Fork một branch tên `thu-huong-b`, thử phương án khác rồi chắt kết luận 3 dòng paste về mạch chính.
3. **(5 phút)** So sánh fork với Restore checkpoint: ghi lại một câu mỗi thứ — cái nào tách hội thoại, cái nào tách file. · 📄 [VS Code Docs: Fork a chat session](https://code.visualstudio.com/docs/agents/run/sessions/manage-sessions#fork-a-chat-session)

## Tham khảo

- Index nhóm: [../README.md](../README.md) · [Commands index](../../../README.md)
- Nguồn docs: [VS Code — AI features cheat sheet](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet) · [VS Code — Agent Host](https://code.visualstudio.com/docs/agents/concepts/agent-host)
- Bài liên quan: [bài 11 — Git worktrees & Checkpoints](../../../../11-git-worktrees-checkpoints.md) · [bài 02 — Các bề mặt VS Code/IDE/Web/CLI](../../../../02-cac-be-mat-vscode-ide-web-cli.md)
- Anh em cùng nhóm: [../checkpoints/README.md](../checkpoints/README.md) · [../new-chat/README.md](../new-chat/README.md) · [../compact/README.md](../compact/README.md)

> Hội thoại cũng cần nhánh thử: `/fork` cho bạn quyền "hỏi thử cho biết" mà không bắt cả mạch chính trả giá vì một giả thuyết chưa chắc.
