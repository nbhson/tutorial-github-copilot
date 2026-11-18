# /explain — giải thích code đang chọn: từng bước làm gì, input/output, edge case

> **Harness:** Copilot · **Surface:** Chat view (`/explain`, nhóm "editor" trong chat reference) · **Đọc:** ~2 phút

**Nôm na:** Chỉ vào đoạn code lạ rồi hỏi "đoạn này làm gì vậy?" — bạn bôi đen 10–40 dòng trọng tâm, gọi `/explain`, nó giảng từng bước ngay trong khung Chat. Hợp khi vừa mở code người khác viết hoặc code legacy và cần hiểu trước khi review/sửa; bôi cả file thì câu trả lời chung chung, đọc xong chẳng đọng lại gì.

## Vì sao dùng?

Tự đọc thì bạn phải nhảy qua lại giữa hàm, caller, type... 15 phút sau vẫn chưa chắc mình hiểu đúng. `/explain` trả lời ngay ba thứ bạn cần — **từng bước làm gì → input/output → edge case** — và đòi được đúng độ sâu bạn muốn ("giải thích như cho intern mới"). Vì nó chỉ *đọc*, không sửa file, đây là cách rẻ nhất để làm quen một đoạn code trước khi quyết định có nên đụng vào hay không. Cạm bẫy lớn nhất không phải câu trả lời dở mà là **tin mù**: model đọc code chứ không chạy code.

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Giải thích chung chung | Bôi quá ít hoặc quá nhiều (cả file) | Bôi 10–40 dòng trọng tâm + nêu tên file |
| Kể sai logic "mẹo" (đệ quy, side-effect ẩn, macro) | Model đọc chứ không chạy code | Gắn `#file` của caller + hỏi "check lại dòng X" |
| Hiểu mà không verify | Tin luôn lời giải thích | Đặt breakpoint/log, chạy thử 1 case để đối chiếu |
| Cần truy vết "ai gọi hàm này" | `/explain` chỉ nhìn selection | Gắn symbol/`#file` context rồi hỏi trong session lớn |

**Nếu làm sai:** đọc xong phải tự diễn giải lại bằng lời mình và chỉ ra được một edge case — kể không nổi nghĩa là chưa hiểu thật; đừng lấy bản giải thích chưa kiểm chứng làm căn cứ để sửa code.

## Cách dùng

Bôi đen code trong editor, gõ trong Chat view (gõ `/` để thấy lệnh khả dụng thật cho phiên hiện tại):

```prompt
/explain
/explain "verifySignedRequest.ts: giải thích từng bước + vẽ flow bằng chữ, nêu edge case khi header thiếu"
```

- **Biến thể:** logic phụ thuộc chỗ gọi thì gắn thêm `#file` của caller; đổi độ sâu bằng câu "như cho intern mới" / "như senior".
- **✅ Verify:** đặt breakpoint/log rồi chạy thử 1 case — diễn giải khớp hành vi thật mới là hiểu.

## Liên quan

- Hiểu xong muốn chữa: [fix](../fix/README.md) · Muốn dọn mà giữ hành vi: [refactor](../refactor/README.md) · Ask mode cho câu hỏi không sửa: [ask-mode](../../model-agent/ask-mode/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — Explain code](https://code.visualstudio.com/docs/editing/copilot-smart-actions#explain-code) · [Check the explanation against tests](https://code.visualstudio.com/docs/agents/guides/explore-a-codebase#4-check-the-explanation-against-tests)
