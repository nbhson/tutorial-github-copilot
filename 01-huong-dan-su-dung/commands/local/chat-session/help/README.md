# /help — Bản đồ lệnh của riêng máy bạn: ở harness này có gì

> **Harness:** Local · **Surface:** VS Code Chat — docs đặt `/help` ở **local Ask chat**, không có trong session Copilot harness · **Đọc:** ~2 phút

**Nôm na:** Hỏi lễ tân "ở đây có dịch vụ gì?" trước khi gọi món — `/help` liệt kê slash command, agent và mode khả dụng đúng theo harness/plan/version máy bạn. Hợp khi mới cài, hoặc nghi một lệnh "biến mất" và muốn biết là nó không tồn tại ở đây hay bạn gọi sai cú pháp.

## Vì sao dùng?

Phần lớn thắc mắc "sao lệnh này không chạy" thực ra là câu hỏi về **khả dụng**: docs nói thẳng khả dụng của một lệnh phụ thuộc chat surface, harness, role và các tính năng đang bật — nên cùng một lệnh có trên máy đồng nghiệp mà không có trên máy bạn là chuyện bình thường. `/help` phân biệt "không có lệnh" với "có lệnh mà gọi sai cú pháp"; nhưng nó chỉ *liệt kê*, không dạy cú pháp — chi tiết nằm ở README của lệnh đó.

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| List `/help` khác máy đồng nghiệp | khác harness/plan/version | so dashboard trạng thái 2 máy — bấm icon Copilot trên Status Bar |
| Lệnh có trong `/help` mà gõ không ăn | thiếu argument — nhiều lệnh dạng `/tên <nội dung>` | mở README của lệnh đó, xem mục Cách dùng |
| Gõ `/help` trong session Copilot không ra | docs đặt `/help` ở local Ask chat | dùng menu `/` + `Chat: Open Customizations` |
| Đọc `/help` vẫn không hiểu cách dùng | `/help` chỉ liệt kê | đọc README của lệnh trong `commands/` |

**Nếu làm sai:** thấy thiếu lệnh rồi kết luận "extension hỏng" đi cài lại là ngộ nhận phổ biến nhất — nguyên nhân thường là khác harness/plan/version; hãy đổi sang đúng harness rồi đối chiếu plan + version ở dashboard trước khi báo lỗi.

## Cách dùng

Gõ trong Chat khi Session Target đang ở **Local**:

```prompt
/help
# không thấy lệnh đọc được chỗ khác? gõ `/` để so list thực tế, rồi kiểm đang ở harness nào
```

- **Biến thể:** `/help` phủ lệnh + agent + mode; muốn xem customization trong harness Copilot thì dùng `Chat: Open Customizations`.
- **Setting:** Session Target (Local) là điều kiện tiên quyết — docs chỉ đặt `/help` ở local Ask chat; plan + version xem bằng icon Copilot trên Status Bar.
- **✅ Verify:** gõ `/` trong ô Chat — list thực tế khớp với list trong `/help`.

## Liên quan

- Chẩn đoán trước khi kết luận "công cụ hỏng": [troubleshoot](../../../copilot/chat-session/troubleshoot/README.md) · trạng thái máy: [status](../../../copilot/system-knowledge/status/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — AI features cheat sheet](https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet)
