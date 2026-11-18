# Ask mode — built-in agent chỉ-đọc: hỏi thoải mái, không một dòng code bị sửa

> **Harness:** Copilot · **Surface:** VS Code Chat (Copilot harness) / Agents window · **Đọc:** ~2 phút

**Nôm na:** Chế độ "chỉ nhìn, không chạm" — chọn **Ask** trong trình chọn chế độ ở Chat view, nó đọc và trả lời chứ không được cấp tool sửa file; nhưng đừng tưởng Ask tự biết file bạn đang nói tới, hãy gắn scope bằng `#file:` / `#codebase`. Hợp khi muốn hiểu module lạ hoặc so sánh phương án trước khi động vào code.

## Vì sao dùng?

Có những việc bạn muốn *hiểu* trước khi *sửa*: đọc module lạ, so hai phương án, xem đoạn code có rủi ro gì. Ask là mắt xích đầu tiên trên thang độ tự chủ Ask → Plan → Agent — rẻ nhất và không có chuyện sửa kèm. Bù lại, chất lượng câu trả lời do scope quyết định: không gắn `#file:` / `#codebase` thì trả lời chung chung, dù đúng là nó chưa đụng gì.

| Việc | Copilot (Ask) | Claude Code |
|---|---|---|
| Chế độ chỉ đọc | built-in agent Ask riêng, chọn bằng picker | không tách mode "chỉ hỏi" — mặc định agentic |
| Bảo đảm không sửa file | Ask không được cấp tool sửa | phải nói rõ "đừng sửa" hoặc ở plan mode |
| Lấy ngữ cảnh | `#file:` / `#codebase` | `@file` hoặc để agent tự đọc |

**Nếu làm sai:** hai lỗi kinh điển — đang ở Agent mà tưởng Ask nên code bị đổi lúc nào không hay, và hiểu rồi vẫn ngồi Ask mãi để tự gõ tay từng file. Ask là kính cửa sổ, không phải cánh cửa: nhìn thoải mái, muốn đi qua thì đổi agent.

## Cách dùng

Chọn **Ask** trong Chat view (Copilot harness; Agents window cũng có), luôn gắn scope ngay cả khi chỉ hỏi:

```prompt
#codebase đọc module trong src/auth/, vẽ lại flow login bằng chữ và chỉ ra
3 rủi ro bảo mật lớn nhất — không sửa file nào.
```

- **Biến thể:** hỏi về vài file cụ thể thì gắn từng file: `#file:src/auth/login.ts #file:src/auth/middleware.ts`; đã biết file cần sửa thì chuyển [agent-mode](../agent-mode/README.md) — Ask không sửa.
- **✅ Verify:** chạy `git status` ngay sau khi hỏi — cây làm việc sạch là đạt.

## Liên quan

- Cần plan trước khi code: [plan](../../code-actions/plan/README.md) · đã tới lúc sửa: [agent-mode](../agent-mode/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — Agents (concept)](https://code.visualstudio.com/docs/agents/concepts/agents) · [VS Code Docs — Send a chat request](https://code.visualstudio.com/docs/chat/chat-overview#send-a-chat-request)
