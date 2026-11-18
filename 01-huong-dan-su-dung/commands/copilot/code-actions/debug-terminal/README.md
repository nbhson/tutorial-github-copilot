# Terminal Inline Chat (Ctrl+I) — biến khối log đỏ thành chẩn đoán + lệnh fix xếp theo rủi ro

> **Harness:** Copilot · **Surface:** panel terminal — inline chat (`Ctrl+I`); `@terminal` là participant cũ đã deprecated · **Đọc:** ~2 phút

**Nôm na:** Chụp ảnh màn hình lỗi đưa cho thợ: bôi đen khối log ngay trong terminal, `Ctrl+I` để hỏi *tại chỗ*, nhận giải thích + lệnh gợi ý xếp theo mức rủi ro, rồi bạn bấm Run hoặc chèn xuống terminal để tự sửa. Hợp khi test/build/deploy fail với stack trace dài mà chưa biết nguyên nhân nằm ở dòng nào.

## Vì sao dùng?

Log lỗi thường dài và nhiễu — dòng quan trọng nằm lẫn giữa hàng trăm dòng warning, nên copy sang cửa sổ chat khác là mô tả lại từ đầu. Inline chat trong terminal đọc output **ngay tại chỗ**, chỉ ra **nguyên nhân top-1** rồi gợi ý cách khắc phục **xếp theo mức rủi ro** để bạn chọn phương án ít nguy hiểm nhất; nó mạnh ở khâu *khoanh vùng*, không phải thi công. Điều hay nhầm: nó không tự đi sửa nhiều file và chạy vòng lặp — việc đó là của Agent mode.

| Bạn đưa vào | Chuyện xảy ra | Nên làm |
|---|---|---|
| Paste cả 500 dòng log | "chẩn đoán" thành đoán mò, model sót đúng dòng lỗi | Bôi 30–50 dòng quanh lỗi + nêu lệnh đã chạy |
| Chỉ log, không ngữ cảnh | Fix lan man vì một lỗi nhiều nguyên nhân | Kèm OS, branch, lệnh đã chạy trong prompt |
| Bấm Run theo lệnh `rm -rf`, `--force`, `reset --hard` | Mất code — chạy nhầm không undo được | Dặn "không đề xuất lệnh destructive", đọc trước khi Run |
| Tin câu "đã sửa xong" | Lỗi vẫn còn đó | Chạy lại đúng lệnh đã fail để xác nhận |

**Nếu làm sai:** mỗi lần Run là một thay đổi hệ thống thật — bạn vẫn là người chọn lệnh nào được phép chạy; đưa nguyên đống log thì nhận về nguyên đống phỏng đoán.

## Cách dùng

Focus vào panel terminal, bôi đen khối log quanh lỗi, bấm `Ctrl+I` rồi nói rõ yêu cầu:

```prompt
đây là 40 dòng cuối của npm test (đã chạy trên branch feat/x, macOS):
nguyên nhân top-1 + 2 cách fix xếp theo rủi ro, đừng đề xuất lệnh xóa/force
```

- **Biến thể:** không thấy inline chat thì mở Command Palette (`Ctrl+Shift+P`) gõ "Terminal: Start Terminal Chat"; muốn tự sửa lệnh trước thì chèn xuống terminal thay vì bấm Run.
- **✅ Verify:** chạy lại đúng lệnh đã fail — hết đỏ là đạt, không phải "cảm thấy hết".

## Liên quan

- Cần nó tự sửa nhiều file, chạy vòng lặp: [agent-mode](../../model-agent/agent-mode/README.md) · Inline chat trong editor: [inline-chat](../../chat-session/inline-chat/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — Fix terminal errors](https://code.visualstudio.com/docs/editing/copilot-smart-actions#fix-terminal-errors) · [Terminal inline chat](https://code.visualstudio.com/docs/chat/inline-chat#use-terminal-inline-chat)
