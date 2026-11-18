# Instructions (`.github/copilot-instructions.md`) — Xem và sửa đúng bộ luật đang áp cho repo

> **Harness:** Copilot · **Surface:** VS Code Chat (Copilot harness) / Copilot CLI / GitHub.com · **Đọc:** ~2 phút

**Nôm na:** Bảng nội quy lớp dán trên tường: `copilot-instructions.md` (hoặc `AGENTS.md`) áp mọi chat, `.github/instructions/*.instructions.md` chỉ áp khi file bạn đang mở khớp glob `applyTo`. Hợp khi bạn sửa rule xong mà model vẫn làm theo cách cũ — cần thấy đúng luật nào đang được nạp.

## Vì sao dùng?

Gõ prompt tay không kiểm chứng được điều quan trọng nhất: model **đang thấy luật gì**. Docs GitHub nói Personal > Repository > Org, **nhưng** nguyên văn là *"all sets of relevant instructions are provided to Copilot"* — cả ba nguồn đều vào context cùng lúc, thứ tự chỉ dùng để **phân xử khi mâu thuẫn**; VS Code ghi thêm "combination rules differ by harness" nên không có bảng "file cao nhất thắng" universal.

| Nguồn luật | Đặt ở đâu | Phạm vi |
|---|---|---|
| Repo-wide | `.github/copilot-instructions.md` hoặc `AGENTS.md` (đặt bất kỳ đâu, nearest wins) | mọi chat trong repo |
| Theo file/thư mục | `.github/instructions/*.instructions.md` + glob `applyTo` | chỉ khi file đang mở khớp glob |
| Cá nhân | `~/.copilot/instructions` | mọi repo trên máy bạn |
| Tổ chức | instructions trên GitHub.com + org policy | cả tổ chức — không chỉ file trong repo |

**Nếu làm sai:** rule chỉ có hiệu lực **ở lượt nạp kế tiếp** — sửa xong hỏi lại trong chat đang mở thì model vẫn ôm luật cũ, test rule mới phải mở chat mới (`Ctrl+N`); code review đọc instructions **từ head branch** — chưa commit + push là chưa ăn; glob `applyTo` sai thì rule chưa từng được nạp.

## Cách dùng

VS Code: `Chat: Open Customizations` → tab **Instructions**; Copilot CLI có slash để xem và bật/tắt từng file:

```prompt
/instructions
```

- **Biến thể:** ngoài phiên, `copilot instruction` dò sources cho thư mục hiện tại; rule không muốn áp cho agent nào thì thêm `excludeAgent: "code-review"` hoặc `"cloud-agent"`.
- **Đừng nhầm:** `/init` (local agent session) lo *khởi tạo* bộ luật cho repo — khác mục đích *xem/sửa* ở đây; checklist dài đẩy sang [skill](../agent-skill/README.md) — instructions nạp mọi lượt, skill chỉ khi khớp.
- **✅ Verify:** sửa 1 rule → `Ctrl+N` → hỏi lại đúng câu vừa rồi → model làm theo rule mới là đạt.

## Liên quan

- Bài chủ về luật & memory: [03-instructions-memory-rules.md](../../../../03-instructions-memory-rules.md) · Khi nào đóng skill thay vì rule: [agent-skill](../agent-skill/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [VS Code Docs — Custom instructions](https://code.visualstudio.com/docs/agent-customization/custom-instructions) · [GitHub Docs — Adding repository instructions](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/add-custom-instructions/add-repository-instructions)
