# Tối ưu hiệu năng — prompt trong inline chat cho đoạn code đã đo là chậm (docs không có slash `/optimize`)

> **Harness:** Copilot · **Surface:** editor inline chat (`Ctrl+I`, macOS `⌘I`); Chat reference **không** liệt kê slash `/optimize` · **Đọc:** ~2 phút

**Nôm na:** Khám xe, đo máy đàng hoàng rồi mới độ — không độ mù. Bạn bôi đen đoạn *đã biết là chậm*, mở inline chat và ra prompt tối ưu có ràng buộc; nó nêu đề xuất trước/sau để bạn phản biện. Hợp khi đã có số đo (profile/benchmark/EXPLAIN) chỉ đúng chỗ này chậm.

## Vì sao dùng?

Hai việc prompt tối ưu làm mà gõ tay khó bằng: nêu **trước/sau** (độ phức tạp, số query) thành lời, và giữ ràng buộc "output không đổi" — nghĩa là nó buộc bạn *chứng minh* nhanh hơn bằng benchmark thay vì nghe theo cảm giác. Trên path nóng, chỉ cần cắt một vòng lặp N+1 là thấy khác biệt rõ. Cái hay nhầm là đi tìm slash `/optimize`: docs cheat-sheet không có lệnh đó, cửa thật là prompt trong inline chat.

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Chờ mãi `/optimize` trong danh sách `/` | Docs không có slash này | Dùng prompt inline chat như dưới |
| Code phức tạp thêm mà không nhanh hơn | Chưa profile đã optimize | Đo trước (profile/EXPLAIN), optimize sau |
| Nhanh hơn nhưng sai edge case hiếm | Đổi logic ngầm | Bắt "giữ nguyên output mọi input" + chạy full test |
| Khó đọc hơn nhiều | Trade-off không đáng | Chỉ optimize path nóng đã đo |

**Nếu làm sai:** không có số đo thì "tối ưu" chỉ là sở thích cá nhân; nút thắt trải nhiều file/service thì đưa Agent mode **kèm số đo**, vì inline chat chỉ mạnh trong đoạn đã bôi đen.

## Cách dùng

Bôi đen đoạn code đã đo là chậm, mở inline chat (`Ctrl+I`, macOS `⌘I`) và ra ràng buộc:

```prompt
giảm N+1 bằng batch, giữ nguyên output mọi input — nêu complexity trước/sau và cách benchmark
```

- **Biến thể:** chưa có số đo thì prompt đầu tiên phải là "chỉ chỗ chậm nhất trong đoạn này và cách đo", chưa xin code.
- **✅ Verify:** chạy benchmark trước/sau + full test — nhanh hơn **và** đúng mới là đạt.

## Liên quan

- Dọn cấu trúc mà không đổi tốc độ/hành vi: [refactor](../refactor/README.md) · Sửa tính đúng/sai chứ không phải tốc độ: [fix](../fix/README.md) · Nút thắt nhiều file: [agent-mode](../../model-agent/agent-mode/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — Refactoring actions](https://code.visualstudio.com/docs/editing/refactoring#refactoring-actions) · [Choose a bounded plan](https://code.visualstudio.com/docs/agents/guides/refactor-safely#3-choose-a-bounded-plan)
