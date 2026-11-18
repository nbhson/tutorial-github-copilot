# /new — scaffold workspace/file/notebook mới từ mô tả (KHÔNG phải "chat mới")

> **Harness:** Copilot · **Surface:** Chat view (`/new`, `/newNotebook` trong bảng slash commands — "scaffold a workspace, file, or notebook") · **Đọc:** ~2 phút

**Nôm na:** Đặt bàn ăn thay vì nấu cả mâm — `/new <mô tả>` dựng sẵn *khung*: cấu trúc thư mục, file entry, README, notebook kèm cell mẫu; bạn là người nếm và quyết định giữ gì. Hợp khi cần một điểm khởi chạy được để phản biện thay vì trang trắng, cho một việc hẹp và có tech stack rõ.

## Vì sao dùng?

Viết tay một dự án/notebook mới tốn toàn thời gian cho phần không sáng tạo: tạo file, cài dependencies, cấu hình khởi động. `/new` dựng khung đó theo đúng đề để bạn vào thẳng phần logic của mình, không cần lần mò Command Palette. Bẫy lớn nhất là **mô tả ôm đồm**: đòi "app quản lý đủ chức năng web + mobile + API" trong một câu thì scaffold sinh ra cả "thành phố" chạy không nổi, dọn còn mệt hơn tự viết. Bẫy thứ hai chính là nhầm nó với chat mới.

| Lệnh / phím | Làm gì | Context chat | File |
|---|---|---|---|
| `/new <mô tả>` | scaffold workspace/file mới | giữ nguyên | tạo file mới |
| `/newNotebook <mô tả>` | scaffold notebook `.ipynb` | giữ nguyên | tạo `.ipynb` |
| `Ctrl+N` | **chat mới** — phiên trắng, không history | sạch | không tạo file |

**Nếu làm sai:** gõ `/new` trong ô chat rồi tưởng được trang trắng — nó vẫn giữ history và bắt đầu tạo file; scaffold chưa từng được test, nên coi nó là nháp và **mở ra chạy thử ngay**, đừng commit nguyên trạng.

## Cách dùng

Gõ trong Chat view, mô tả hẹp + có tech stack + nêu luôn cách chạy:

```prompt
/new ứng dụng "todo-cli" bằng Node + TypeScript: một file src/index.ts export main(), thêm/xóa/liệt kê todo qua argv, kèm README hướng dẫn chạy
/newNotebook phân tích sales.csv bằng pandas: đọc dữ liệu, thống kê số bán theo tháng, vẽ biểu đồ
```

- **Biến thể:** gõ một mình `/new` rồi trả lời câu hỏi tiếp theo của Copilot; cần thêm chức năng thì hỏi tiếp trong cùng phiên bằng câu "giữ nguyên file đang có, thêm ...".
- **✅ Verify:** chạy `npm run dev` hoặc Run All notebook ngay — mở được + chạy được + sửa được số liệu là đạt.

## Liên quan

- Nhầm với chat mới: [new-chat](../../chat-session/new-chat/README.md) · Sửa code đang có chứ không tạo mới: [fix](../fix/README.md), [refactor](../refactor/README.md) · Việc mở nhiều bước: [agent-mode](../../model-agent/agent-mode/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — AI features cheat sheet](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet#choose-a-feature) · [Code generation & editing](https://code.visualstudio.com/docs/agents/guides/prompt-examples#code-generation-and-editing)
