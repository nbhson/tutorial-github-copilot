# Assign issue cho Copilot cloud agent — giao việc async, nhận draft PR

> **Harness:** Copilot in the cloud · **Surface:** GitHub.com (issue, tab Agents, `github.com/copilot`) — agent chạy trên hạ tầng GitHub, máy bạn tắt vẫn chạy · **Đọc:** ~2 phút

**Nôm na:** Gắn Copilot vào Assignees của một issue đã rõ, nó tự làm trên hạ tầng GitHub (máy bạn tắt vẫn chạy) rồi mở **draft PR** + session log — như thuê "ca đêm"; docs gọi là **Copilot cloud agent**, tên cũ "coding agent" hay bị gọi lẫn khi tra docs. Hợp khi có vài issue độc lập muốn chạy song song, việc không cần quyết liên tục.

## Vì sao dùng?

Vì phiên cloud không cần máy bạn bật, và nó chọn được hai núm: **Environment** — Cloud sandbox (mặc định, session resume được across clients), **Actions** (chỉ xem trên website), Environments/remote — và **Mode**: Interactive (làm từng bước với bạn, mặc định) hay Autopilot (ủy quyền chạy từ đầu đến cuối). Ràng buộc thật nằm ở issue: agent không hỏi lại giữa chừng, nên chất lượng issue là thứ quyết định kết quả.

| Bạn định làm | Chọn gì | Vì sao |
|---|---|---|
| Giao một issue, về xem kết quả | Assignees → Copilot | Có draft PR + session log, không cần ngồi máy |
| Việc cần quyết từng bước ngay bây giờ | Mode **Interactive** | Bạn steer giữa chừng bằng follow-up prompt |
| Muốn chạy tiếp trên IDE/CLI/mobile | Environment **Cloud** (sandbox) | Sandbox resume được across clients; **Actions** chỉ xem trên website |
| Repo có secrets chưa xử lý | Kiểm content exclusion trước | Repo bị loại thì không xuất hiện trong danh sách chọn |

**Nếu làm sai:** issue một dòng kiểu "làm login ngon hơn" thì agent đoán sai hướng, PR lệch hết và phải bỏ — viết issue thành bản đặc tả 4 mục (Mục tiêu / Phạm vi / Xong khi / Lệnh verify) thì mới giao được; muốn can thiệp giữa chừng thì giữ [agent-mode](../../../copilot/model-agent/agent-mode/README.md) trong IDE, đừng assign.

## Cách dùng

Trên issue: sidebar **Assignees** → chọn Copilot (hoặc tab **Agents** trong repo / `github.com/copilot/agents`, hoặc prompt trên `github.com/copilot` kèm chọn repo ở session context):

```prompt
Issue #142: thêm rate-limit cho POST /api/login
  Mục tiêu:    <việc cần đạt — 1 câu>
  Phạm vi:     apps/api/**
  Xong khi:    <điều kiện để coi là xong>
  Lệnh verify: pnpm --filter api test
→ sidebar Assignees → chọn Copilot (Mode: Interactive nếu muốn duyệt giữa chừng)
```

- **Biến thể:** mỗi agent một vùng, một branch — hai agent cùng chạm một vùng thì conflict gần như chắc chắn.
- **Giới hạn:** cần gói Copilot trả phí và org/enterprise bật policy **Copilot in the cloud**; Enterprise Managed Users **không** dùng được ở repo cá nhân (GitHub-hosted runner không khả dụng).
- **✅ Verify:** Copilot gắn reaction "con mắt" lên issue rồi trạng thái chuyển "Copilot started work" → bấm **View session** đọc log stream; draft PR mở ra linked tới issue, test xanh, diff nằm trong phạm vi issue — nếu nó chạm file ngoài phạm vi, comment yêu cầu thu hẹp rồi re-assign.

## Liên quan

- Theo dõi session + 3 núm vặn: [cloud-agent-session](../cloud-agent-session/README.md) · Nhận PR về review: [coding-agent-pr](../coding-agent-pr/README.md) · Việc cần duyệt từng bước: [agent-mode](../../../copilot/model-agent/agent-mode/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [GitHub Docs — Kick off a task](https://docs.github.com/en/copilot/how-tos/copilot-on-github/use-copilot-agents/kick-off-a-task) · [GitHub Docs — About GitHub Copilot agents](https://docs.github.com/en/copilot/concepts/agent-capabilities/about-agents/about-github-copilot-agents)
