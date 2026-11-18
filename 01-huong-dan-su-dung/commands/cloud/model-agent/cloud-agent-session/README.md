# Copilot cloud agent session — 3 núm vặn độc lập: mode × tool permission × environment

> **Harness:** Copilot in the cloud · **Surface:** GitHub.com — form khởi động phiên (agents panel / assign issue), không có slash command · **Đọc:** ~2 phút

**Nôm na:** Mỗi phiên cloud có đúng 3 núm vặn độc lập — **mode** (Interactive/Autopilot), **tool permission** (Assisted/Always ask/Allow all), **environment** (Cloud sandbox/GitHub Actions/Remote) — và Cloud **không phải harness**, nó là *execution target* chạy **Copilot harness** trên hạ tầng managed của GitHub. Hợp khi muốn giao khoán việc trên GitHub.com mà vẫn kiểm soát được "ai lái, ai duyệt tool, chạy ở đâu".

## Vì sao dùng?

Docs GitHub đặt mặc định cho từng chiều (Interactive · Assisted · Cloud sandbox), nhưng người dùng hay đọc nhầm 2 núm làm một: bật Autopilot rồi than "sao vẫn hỏi từng tool" (do permission còn Always ask), hoặc ngược lại "sao Autopilot làm bừa" (do Allow all + repo chưa có test). Ba chiều là ba câu hỏi rời — ai lái, ai duyệt tool, chạy ở đâu — trả lời tách bạch rồi mới bấm Start.

| Núm vặn | Lựa chọn | Mặc định | Chọn khi nào |
|---|---|---|---|
| **Mode** | Interactive / Autopilot | Interactive | Interactive: repo lạ, cần trông từng bước; Autopilot: scope rõ + có test phủ — vẫn tiêu AI credits như phiên thường |
| **Tool permission** | Assisted / Always ask / Allow all | Assisted | Assisted: duyệt gộp bước ít rủi ro, vẫn hỏi bước nhạy cảm; Allow all gần như không dùng, chỉ khi đã cô lập kỹ |
| **Environment** | Cloud sandbox / GitHub Actions / Remote | Cloud sandbox | **Trần 59 phút/session** chỉ áp khi chạy bằng Actions minutes, không áp cho Cloud sandbox |

**Nếu làm sai:** gọi GitHub Actions là harness là lẫn hai khái niệm — harness vẫn là Copilot, Actions chỉ là *nơi chạy*; editor lại dùng tên khác (persona Interactive/**Plan**/Autopilot, permission **Manual**/Assisted/Allow all) — bảng trên chỉ đúng cho Copilot in the cloud.

## Cách dùng

Mở form khởi động phiên trên GitHub.com (agents panel, hoặc assign issue → Copilot), vặn từng núm theo task:

```prompt
→ Issue body:   nâng thư viện ngày-tháng lên major version mới (~20 file gọi hàm cũ, repo đã có test phủ)
→ Mode:         Autopilot            (scope rõ, repo đã có test phủ)
→ Tool perm.:   Assisted             (KHÔNG phải Allow all — vẫn hỏi bước nhạy cảm)
→ Environment:  Cloud sandbox        (mặc định, né trần 59 phút của Actions minutes)
```

- **Biến thể:** repo chưa có test → giữ Interactive + Assisted; việc dài + giao khoán → Autopilot + Cloud sandbox để tránh trần Actions minutes.
- **Giới hạn:** Autopilot **vẫn tiêu AI credits** như phiên thường — nó tiết kiệm công trông, không tiết kiệm tiền.
- **✅ Verify:** mở session log — chuỗi tool calls tự liền, không có khung "đang chờ duyệt"; `git diff` trên PR không vượt phạm vi issue cho phép.

## Liên quan

- Hand-off từ editor (chọn Local/Copilot/Cloud): [session-target](../../../copilot/model-agent/session-target/README.md) · Hai bài "việc" cùng nhóm: [coding-agent-assign](../coding-agent-assign/README.md) · [coding-agent-pr](../coding-agent-pr/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [GitHub Docs — About GitHub Copilot agents](https://docs.github.com/en/copilot/concepts/agent-capabilities/about-agents/about-github-copilot-agents) · [GitHub Docs — Start Copilot sessions](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent/start-copilot-sessions)
