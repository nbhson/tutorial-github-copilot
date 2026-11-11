# Session Target — Chọn harness + nơi agent chạy

> **Dành cho:** người muốn agent chạy nền/nhiều phiên hoặc giao hẳn task lên cloud · **Đọc xong:** chọn đúng harness + execution target cho từng việc, biết handoff giữ context (~3 phút)
> **Harness:** Copilot · **Surface:** VS Code Chat (Copilot harness) / Agents window / Copilot in the cloud

## 1 câu nôm na

Công tắc chọn "đội thợ + nhà xưởng". Ở đáy khung Chat → **Session Target**: **Local** làm ngay trong VS Code, **Copilot** chạy nền trên Agent Host, **Cloud** giao cho hạ tầng managed của GitHub rồi nhận PR về.

Điểm hay nhầm nhất: đổi Session Target **không** phải đổi model. Model là "bộ não"; target là "nơi chạy + tay chân thực thi". Và **Cloud không phải một harness** — nó là *execution target* chạy chính Copilot harness. · 📄 [VS Code Docs: Agents (concept)](https://code.visualstudio.com/docs/agents/concepts/agents)

## Vì sao dùng Session Target?

Vì cùng một task, chỗ chạy quyết định bạn được gì và mất gì: Local dùng được tool của VS Code/extension, Copilot chạy nền nên mở được nhiều phiên song song, Cloud thì giao hẳn để nhận PR nhưng không thấy context local của bạn.

| Lựa chọn trong picker | Nó là gì | Khi nào chọn |
|---|---|---|
| **Local** | Harness của VS Code, chạy trong cửa sổ của bạn | Cần tool/extension/model cấu hình trong VS Code |
| **Copilot** | Harness Copilot, chạy nền trên Agent Host | Coding chạy nền, nhiều phiên song song, mở lại ở cửa sổ khác |
| **Claude / Codex** | Harness thật của provider, hiện trong picker | Đã quen workflow của provider (bị chặn khi org bật managed settings) |
| **Cloud** | **Không phải harness** — execution target chạy Copilot harness, kết thúc bằng PR | Task gọn, độc lập, giao hẳn cho team review |

> **Chi tiết matrix modes × harness và 3 núm của cloud:** [10-modes-permissions-availability.md mục 3 & 7](../../../../10-modes-permissions-availability.md). · 📄 [VS Code Docs: Agents (concept)](https://code.visualstudio.com/docs/agents/concepts/agents)

**Nếu làm sai thì sao?** Muốn chạy nền mà cứ dùng Local thì phải giữ cửa sổ mở; ngược lại, cần tool built-in của VS Code mà lại giao Cloud thì Cloud không thấy context local nên kết quả cụt.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** muốn agent chạy nền, chạy nhiều phiên, hoặc giao task async để nhận PR; cần mang một phiên đang làm sang nơi khác (handoff).
- **ĐỪNG dùng khi:** bạn muốn đổi model — việc đó ở [model-picker](../model-picker/README.md); hoặc chỉ cần sửa ngay trong editor, cứ ở Local. · 📄 [VS Code Docs: Pick the right tool](https://code.visualstudio.com/docs/agents/best-practices#pick-the-right-tool-for-the-task)

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

> Không thấy `Copilot`/`Cloud` trong list? Thường do chưa đăng nhập GitHub, chưa bật Agent Host, hoặc org policy chặn harness — xem Copilot status dashboard ([../../system-knowledge/status/README.md](../../system-knowledge/status/README.md)) rồi hỏi admin, đừng kết luận lỗi công cụ. · 📄 [VS Code Docs: Choose an Agent Harness](https://code.visualstudio.com/docs/agents/run/agent-harnesses)

## Ví dụ thật

Nghiệp vụ: bạn có ba việc khác tính chất và muốn xếp đúng "nhà xưởng" cho từng việc.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh) · 📄 [VS Code Docs: Crafting effective prompts](https://code.visualstudio.com/docs/agents/guides/prompt-examples#tips-for-crafting-effective-prompts)

**Kết quả mong đợi:** Local sửa ngay trong workspace; Copilot chạy nền + xuất hiện ở Agent Sessions sidebar; Cloud trả về 1 PR trên GitHub.

**✅ Verify:** session hiện đúng ở Agent Sessions sidebar với đúng target; Cloud xong thì có PR mới là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — đổi target xong tưởng là "chat mới", mất hết ngữ cảnh:**

> 📄 **Code ví dụ:** [`examples/03-neu-lam-sai-thi-sao-sai-ung.sh`](examples/03-neu-lam-sai-thi-sao-sai-ung.sh)

**✅ ĐÚNG — dùng Handoff để mang context sang target mới:**

> 📄 **Code ví dụ:** [`examples/04-neu-lam-sai-thi-sao-sai-ung.sh`](examples/04-neu-lam-sai-thi-sao-sai-ung.sh) · 📄 [VS Code Docs: Choose a troubleshooting path](https://code.visualstudio.com/docs/agents/agent-troubleshooting/troubleshooting#choose-a-troubleshooting-path)

**Bài học:** Đổi target là đổi nơi chạy, không phải nút "chat mới". Cần giữ ngữ cảnh thì dùng **Handoff** (khởi tạo từ session Local); muốn giao việc cho **Copilot cloud agent** thì mở PR/issue trên GitHub.com.

## Lỗi thường gặp

📄 [VS Code Docs: Session not visible](https://code.visualstudio.com/docs/agents/agent-troubleshooting/faq#why-cant-i-see-a-copilot-session-i-already-started)

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Không thấy Copilot/Cloud trong list | Chưa đăng nhập / Agent Host chưa bật / policy org chặn | Đăng nhập đúng account, kiểm tra managed settings với admin |
| Đổi target xong mất ngữ cảnh | Tưởng là "new chat" | Dùng **Handoff** để mang history + context |
| Cloud không thấy tool quen dùng | Cloud chạy tool/model của service | Task cần tool VS Code → ở Local/Copilot; giao Cloud task gọn, độc lập |
| Tưởng đổi target = đổi model | Nhầm harness với model | Model đổi ở picker; target đổi "nơi chạy + tay chân" |
## So sánh với Claude Code

📄 [VS Code Docs: Agent Harnesses (concept)](https://code.visualstudio.com/docs/agents/concepts/agent-harnesses)

| Việc | Copilot (Session Target) | Claude Code | Ghi chú |
|---|---|---|---|
| Chạy nền / nhiều phiên | Target Copilot trên Agent Host, sidebar quản lý tập trung | Nhiều phiên terminal/IDE tự quản | Copilot có Agent Sessions sidebar |
| Giao hẳn lên cloud | Copilot cloud agent → nhận PR | Không có target cloud sẵn — tự dựng container/Actions | Copilot tích hợp cloud + PR thẳng |
| Mang ngữ cảnh khi đổi nơi chạy | Handoff từ session Local | Mở phiên mới, tự khôi phục context | Cả hai đều cần chủ động giữ context |
## Best practices (kèm "vì sao")

- **Chọn target theo "cần tay chân gì", không theo thói quen.** *Vì sao?* Việc cần tool extension mà giao Cloud thì kết quả cụt vì Cloud không thấy context local.
- **Dùng Handoff thay vì mở phiên trắng khi đổi nơi chạy.** *Vì sao?* Handoff mang theo history + context, giúp bạn không phải kể lại đầu bài.
- **Giao Cloud cho task gọn, độc lập.** *Vì sao?* Cloud hợp task khép kín; task phụ thuộc context local thì để Local/Copilot. · 📄 [VS Code Docs: Choose the right agent harness](https://code.visualstudio.com/docs/agents/best-practices#choose-the-right-agent-harness)

## Bài tập nhỏ

1. **(7 phút)** Chạy một task nhỏ ở Local, rồi Handoff sang một target khác và kiểm tra ngữ cảnh còn nguyên không.
2. **(7 phút)** Giao một task gọn (thêm endpoint + test) cho **Copilot cloud agent** từ issue trên GitHub.com, theo dõi tới khi có PR và tự review nó. · 📄 [VS Code Docs: Choose an Agent Harness](https://code.visualstudio.com/docs/agents/run/agent-harnesses)

## Tham khảo

- Index nhóm: [../README.md](../README.md) · Modes × harness × permission levels: [10-modes-permissions-availability.md](../../../../10-modes-permissions-availability.md).
- Phiên cloud (3 núm: modes/tools/environment): [../../../cloud/model-agent/cloud-agent-session/README.md](../../../cloud/model-agent/cloud-agent-session/README.md) · Đổi bộ não: [../model-picker/README.md](../model-picker/README.md).
- Cheatsheet 1 trang: [CHEATSHEET.md](../../../../../CHEATSHEET.md) · Kẹt thì tra [FAQ troubleshooting](../../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- VS Code — [Agent harnesses](https://code.visualstudio.com/docs/agents/concepts/agent-harnesses) · GitHub — [About Copilot cloud agent](https://docs.github.com/en/copilot/concepts/copilot-surfaces/copilot-on-github).

> Local để làm tay, Copilot để chạy nền, Cloud để giao hẳn — chọn đúng "nhà xưởng" quan trọng chẳng kém chọn đúng bộ não.
