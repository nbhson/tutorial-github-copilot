# Copilot cloud agent session — 3 núm vặn: mode × tool permission × environment

> **Dành cho:** người giao việc cho agent trên GitHub.com mà không muốn chiếm máy mình · **Vấn đề:** bật "tự lái" rồi phiên vẫn kẹt chờ duyệt, hoặc đi xa hơn ý định · **Đọc xong:** chỉnh đúng 3 núm vặn và hiểu vì sao Cloud không phải một harness (~2 phút)
> **Surface:** Copilot in the cloud (GitHub.com)

## 1 câu nôm na

Mỗi phiên Copilot cloud agent giống thuê một đội làm việc từ xa, và bạn vặn đúng 3 núm: **mode** (kèm sát hay giao khoán: Interactive/Autopilot), **tool permission** (ai duyệt hành động tool: Assisted/Always ask/Allow all), **environment** (chạy ở hạ tầng nào: Cloud sandbox/GitHub Actions/Remote). Ba núm độc lập — chọn nhầm một cái là kết quả khác hẳn. Câu hay bị bỏ quên: **Cloud không phải harness** — nó là *execution target* chạy **Copilot harness** trên hạ tầng managed của GitHub. · 📄 [GitHub Docs: About GitHub Copilot agents](https://docs.github.com/en/copilot/concepts/agent-capabilities/about-agents/about-github-copilot-agents)

## Vì sao phải chỉnh đủ 3 chiều?

4 bài cloud trong nhóm này dạy *việc* (giao issue, review PR…); bài này dạy *núm vặn* — thứ quyết định phiên đó an toàn tới đâu. Trên docs GitHub, mỗi chiều có giá trị mặc định riêng: Interactive, Assisted, Cloud sandbox. Người chỉ chỉnh mode rồi than "sao vẫn hỏi từng tool" (do tool permission còn ở Always ask), hoặc ngược lại "sao Autopilot làm bừa" (do Allow all + không có test) đều đang đọc nhầm 2 núm làm một. · 📄 [GitHub Docs: About GitHub Copilot agents](https://docs.github.com/en/copilot/concepts/agent-capabilities/about-agents/about-github-copilot-agents)

## Khi nào dùng / khi nào đừng

- **Dùng khi:** bạn bắt đầu một phiên cloud (assign issue, mở từ agents panel, hoặc hand-off từ picker ở editor — xem [../../../copilot/model-agent/session-target/README.md](../../../copilot/model-agent/session-target/README.md)).
- **ĐỪNG áp nhãn này cho editor:** trong VS Code, persona là Interactive/**Plan**/Autopilot và permission levels là **Manual**/Assisted/Allow all — tên khác, docs khác (bài 10). Bảng dưới chỉ đúng cho Copilot in the cloud.
- **ĐỪNG chọn GitHub Actions cho việc dài:** trần 59 phút/session chỉ áp cho phiên chạy bằng Actions minutes (không áp cho Cloud sandbox). · 📄 [GitHub Docs: Choosing & delegating agent work](https://docs.github.com/en/copilot/concepts/agent-capabilities/choosing-and-delegating-agent-work)

## Ba chiều, một bảng

📄 [GitHub Docs: Start Copilot sessions](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent/start-copilot-sessions)

| Núm vặn | Lựa chọn (docs) | Mặc định | Chọn khi nào |
|---|---|---|---|
| **Mode** | Interactive / Autopilot | Interactive ✅ | Interactive: việc cần trông từng bước, repo lạ; Autopilot: việc rõ scope, có test — tự chạy tới đích, tự tiếp tục sau lỗi |
| **Tool permission** | Assisted | ✅ | Duyệt gộp các bước ít rủi ro, vẫn hỏi bước nhạy cảm |
| | Always ask / Allow all | | Always ask: mọi quyền cần người bấm — chặt nhất; Allow all: gần như không dùng, chỉ khi đã cô lập kỹ |
| **Environment** | Cloud sandbox | ✅ | Mặc định an toàn, hạ tầng GitHub quản |
| | GitHub Actions | | Muốn dùng minutes của repo; **trần 59 phút áp từ đây** |
| | Remote | | docs chỉ liệt kê tên — môi trường ngoài hai lựa chọn managed trên, khả dụng tùy cấu hình; khoá học không dạy sâu |
## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh) · 📄 [GitHub Docs: Start Copilot sessions](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent/start-copilot-sessions)

Không có slash command — núm vặn nằm ở form khởi động phiên trên GitHub.com (và trong phiên đang chạy). Ghi nhớ: Autopilot **vẫn tiêu AI credits** như phiên thường; nó tiết kiệm công trông, không tiết kiệm tiền.

## Ví dụ thật

Nghiệp vụ: nâng thư viện ngày-tháng lên major version mới, ~20 file gọi hàm cũ, repo đã có test phủ.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh) · 📄 [GitHub Docs: Research, plan, iterate](https://docs.github.com/en/copilot/how-tos/copilot-on-github/use-copilot-agents/research-plan-iterate)

**Kết quả mong đợi:** agent tự sửa–chạy test–tiếp tục sau lỗi, mở draft PR; không có bước nào chờ bạn nếu Assisted thấy ổn.

**✅ Verify:** mở session log — thấy chuỗi tool calls tự liền (không dừng chờ duyệt); `git diff` trên PR không vượt phạm vi issue cho phép.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — tưởng bật Autopilot là tool tự được duyệt hết.** Chọn mode chỉ giao việc "tự lái"; nếu tool permission vẫn Always ask, phiên vẫn đứng chờ bạn duyệt từng hành động.
**✅ ĐÚNG — chỉnh từng núm theo ý:** muốn giao khoán trọn gói là mode Autopilot **và** tool permission nới phù hợp — kèm sandbox/commit an toàn đã bật.

**❌ SAI — gọi "GitHub Actions" là harness.** Đó là *environment* — nơi chạy; harness vẫn là Copilot.
**✅ ĐÚNG — nói đúng vai:** "phiên cloud chạy Copilot harness, environment là GitHub Actions".

**Bài học:** 3 chiều là 3 câu hỏi khác nhau — *ai lái*, *ai duyệt tool*, *chạy ở đâu* — trả lời tách bạch từng câu rồi mới bấm Start. · 📄 [GitHub Docs: Troubleshoot common issues](https://docs.github.com/en/copilot/how-tos/troubleshoot-copilot/troubleshoot-common-issues)

## Lỗi thường gặp

📄 [GitHub Docs: Troubleshoot cloud agent](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent/troubleshoot-cloud-agent)

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Autopilot nhưng phiên cứ dừng chờ duyệt | Tool permission để Always ask | Chỉnh núm permission riêng (thường Assisted là đủ) |
| Session bị cắt giữa đường | Environment GitHub Actions chạm trần 59 phút | Chuyển Cloud sandbox, hoặc tách issue ngắn |
| Agent làm ngoài ý muốn | Autopilot + Allow all trên repo chưa có test | Bớt một trong hai: hoặc Interactive, hoặc Assisted/Always ask |
| Không thấy đủ lựa chọn khi mở phiên | Plan/org chưa bật Copilot in the cloud cho repo | Kiểm tra settings Copilot của org/repo trước |
## So sánh với Claude Code

📄 [GitHub Docs: Third-party coding agents](https://docs.github.com/en/copilot/concepts/agent-capabilities/about-agents/about-third-party-coding-agents)

| Việc | Copilot (cloud agent session) | Claude Code | Ghi chú |
|---|---|---|---|
| Giao việc async, nhận PR | Assign issue → phiên cloud tự mở PR | Không có tương đương gắn sẵn vào issue/PR — phải tự dựng hạ tầng | Copilot mây nằm trong nền tảng GitHub |
| Mức tự chủ | Mode Interactive/Autopilot | Persona/permission modes trong session (khái niệm gần, tên khác) | Đừng lẫn persona của editor với mode của cloud |
| Duyệt tool | Assisted/Always ask/Allow all | Prompt duyệt tool + modes tự duyệt | Ý tưởng chung: nới dần theo độ tin |
## Best practices (kèm "vì sao")

- **Giao khoán Autopilot + Allow all là cặp dễ cháy.** *Vì sao?* Autopilot tự tiếp tục sau lỗi, Allow all tắt nốt lớp duyệt cuối — trên repo chưa có test thì bạn không còn gì để phanh.
- **Repo chưa có test → giữ Interactive + Assisted.** *Vì sao?* Không có lệnh verify thì bạn cũng chẳng biết Autopilot làm đúng hay sai.
- **Việc dài, giao khoán → Autopilot + Cloud sandbox.** *Vì sao?* Tránh trần 59 phút của phiên chạy bằng Actions minutes cho việc nhiều bước.
- **Ghi "được phép đụng / cấm đụng" vào issue.** *Vì sao?* Tool permission mở tới đâu thì agent vẫn chỉ đi trong phạm vi bạn viết rõ. · 📄 [GitHub Docs: Use cloud agent on GitHub](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent/use-cloud-agent-on-github)

## Bài tập nhỏ

1. **(5 phút)** Mở một phiên cloud demo với cả 3 núm mặc định; ghi lại từng chỗ bạn được hỏi khi duyệt tool (chứng minh Assisted ≠ Always ask).
2. **(4 phút)** Tắt/sửa một chữ: giữ Autopilot, đổi tool permission sang Always ask — quan sát phiên dừng chờ duyệt để xác nhận 2 núm độc lập.
3. **(3 phút)** Viết vào notes team câu "Cloud là execution target, không phải harness" kèm 1 ví dụ núm environment đổi mà harness không đổi. · 📄 [GitHub Docs: Start Copilot sessions](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent/start-copilot-sessions)

## Tham khảo

- Index nhóm: [../README.md](../README.md) · Hai bài "việc" của cùng nhóm: [../coding-agent-assign/README.md](../coding-agent-assign/README.md) (giao issue) · [../coding-agent-pr/README.md](../coding-agent-pr/README.md) (review PR)
- Chọn harness/target từ editor (hand-off session lên cloud): [../../../copilot/model-agent/session-target/README.md](../../../copilot/model-agent/session-target/README.md)
- Bài học: [02 — các bề mặt](../../../../02-cac-be-mat-vscode-ide-web-cli.md) · [10 — modes & permissions](../../../../10-modes-permissions-availability.md) · FAQ: [modes & permissions](../../../../../03-cau-hoi-thuong-gap/03-modes-permissions.md) · [workflows](../../../../../03-cau-hoi-thuong-gap/07-custom-agents-coding-agent-workflows.md) · Index lệnh: [../../../README.md](../../../README.md) · [CHEATSHEET](../../../../../CHEATSHEET.md)
- GitHub docs — về Copilot cloud agent (modes/permissions/environments): https://docs.github.com/en/copilot/concepts/copilot-surfaces/copilot-on-github · how-tos: https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent
- VS Code docs — harness & execution target: https://code.visualstudio.com/docs/agents/concepts/agent-harnesses · cloud sandbox sessions: https://code.visualstudio.com/docs/agents/run/cloud-sandbox-sessions

> Một phiên cloud an toàn là đáp án của ba câu hỏi rời nhau — ai lái, ai duyệt tool, chạy ở đâu — đừng để ý định "tự lái" tự trả lời thay hai câu còn lại.
