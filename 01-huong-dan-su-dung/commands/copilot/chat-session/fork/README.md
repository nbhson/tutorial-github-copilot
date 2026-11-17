# /fork — Rẽ nhánh cuộc hội thoại sang phiên mới, bản gốc giữ nguyên

> **Harness:** Copilot · **Surface:** VS Code Chat (Copilot harness) — cần session chạy qua Agent Host được hỗ trợ · **Đọc:** ~2 phút

**Nôm na:** `/fork` copy cả cuộc hội thoại (kèm history) sang session mới để bạn hỏi tiếp hướng khác, còn mạch chính không nhúc nhích — như save-game trước trận boss rồi nhân bản file save. Hợp khi muốn so hai phương án song song mà sợ câu hỏi risky làm hỏng mạch đang làm.

## Vì sao dùng?

Có lúc một chat phải chứa hai giả thuyết, mà để chung thì cả hai đều bẩn: model lẫn "cách A" với "cách B". Branch sinh ra đã "biết" 20 turns trước, không phải giải thích lại; thử sai thì bỏ, mạch chính vẫn chạy tiếp. Docs buộc một điều kiện: `/fork` cần **Agent Host session** được hỗ trợ — gõ `/` không thấy thì đó là chuyện cấu hình phiên, không phải tính năng mất.

| Cú pháp | Kết quả | Khi nào |
|---|---|---|
| `/fork` | branch không tên | thử nhanh rồi bỏ |
| `/fork <title>` | branch kèm tên | nên dùng — branch không tên lẫn nhanh trong Session History |
| `/fork prompt <…>` | branch rồi đi tiếp bằng câu hỏi đưa kèm | biết sẵn câu exploration |

**Nếu làm sai:** fork tách *cuộc chuyện*, checkpoint tách *file trên đĩa* — agent đã sửa file thật thì fork **không** trả lại chúng; muốn code lùi theo mốc cũ dùng [Restore checkpoint](../checkpoints/README.md), còn muốn "lưu" chat thì đó là export, không phải fork.

## Cách dùng

Gõ trong Chat view (Copilot harness), *trước* khi câu exploration kịp vào mạch chính; kiểm tra phiên qua [session-target](../../model-agent/session-target/README.md) nếu không thấy `/fork`.

```prompt
/fork tách-bảng-hay-thêm-cột
hay là tách bảng thay vì thêm cột cho user service?
```

- **Biến thể:** kết thúc branch thì chắt 2–3 dòng kết luận về mạch chính — mang cả branch về là mang cả nhiễu.
- **✅ Verify:** mở Session History thấy cả hai phiên; ở mạch chính hỏi "nãy giờ ta sửa file nào?" vẫn ra danh sách cũ.

## Liên quan

- Đừng nhầm với: [compact](../compact/README.md) (rút gọn, không nhân bản) · [new-chat](../new-chat/README.md) (trắng, không mang history)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — Fork a chat session](https://code.visualstudio.com/docs/agents/run/sessions/manage-sessions#fork-a-chat-session)
