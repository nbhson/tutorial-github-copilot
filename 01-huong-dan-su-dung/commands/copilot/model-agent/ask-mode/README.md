# Ask — Chế độ chỉ hỏi, không sửa

> **Dành cho:** người muốn hiểu code/kiến trúc trước khi đụng vào · **Đọc xong:** hỏi thoải mái mà `git status` vẫn sạch (~2 phút)
> **Harness:** Copilot · **Surface:** VS Code Chat (Copilot harness) / Agents window

## 1 câu nôm na

Chế độ "chỉ nhìn, không chạm": hỏi gì cũng được, code không mất một cọng. Trong Chat → chọn agent **Ask**, rồi hỏi như bình thường.

Nhưng đừng tưởng Ask tự biết file bạn đang nói tới — nó trả lời tốt khi bạn gắn scope bằng `#file:` hay `#codebase`. Không gắn scope thì câu trả lời chung chung, dù đúng là nó chưa sửa gì.

> **Built-in agents:** Copilot harness có ba agent dựng sẵn — **Ask** (chỉ đọc, trả lời), **Plan** (lập kế hoạch, chưa code), **Agent** (sửa + chạy terminal). **Edit** là mode của Local harness, không có trong Copilot. Chi tiết: [10-modes-permissions-availability.md mục 3.2](../../../../10-modes-permissions-availability.md).

## Vì sao dùng Ask?

Có những việc bạn muốn *hiểu* trước khi *sửa*: đọc một module lạ, so sánh hai phương án, xem đoạn code này có rủi ro gì. Ở Ask, bạn hỏi thoải mái mà không sợ agent tiện tay sửa lung tung.

| Built-in agent | Đặc điểm | Khi nào dùng |
|---|---|---|
| Ask | Chỉ đọc, không sửa file | Hỏi/khảo sát/so sánh phương án trước khi đụng code |
| Plan | Nghiên cứu + lập plan, chưa thực thi | Task đủ lớn để cần xem hình hài trước khi chạy ([plan](../../code-actions/plan/README.md)) |
| Agent | Tự tìm file, sửa, chạy terminal | Task mở nhiều bước, chưa biết chạm file nào |

> **Cách đọc bảng này:** xếp theo độ tự chủ tăng dần — Ask đứng đầu vì "rẻ" nhất; việc của bạn chỉ cần đọc thì đừng đi sâu xuống dưới. Muốn review từng file được sửa theo kiểu tick chọn: đó là **Edit** của Local harness ([edit-mode](../../../local/model-agent/edit-mode/README.md)).

**Nếu làm sai thì sao?** Hai sai lầm hay gặp: (1) nhầm đang ở Agent mà tưởng Ask → code bị đổi; (2) ở mãi Ask dù đã hiểu rồi → bạn ngồi tự sửa tay trong khi Agent làm nhanh hơn. Ask là chế độ rẻ nhất để khảo sát, không phải "chỗ trú ẩn vĩnh viễn".

## Khi nào dùng / khi nào đừng

- **Dùng khi:** tìm hiểu code/kiến trúc trước khi đụng; so sánh phương án chưa muốn sửa; review kiểu "đoạn này làm gì, rủi ro gì?".
- **ĐỪNG dùng khi:** đã biết cần sửa file nào → Ask không sửa, chuyển sang [agent-mode](../agent-mode/README.md); task mở nhiều bước cũng cần agent sửa.

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

> Không thấy **Ask** trong picker? Mở Copilot status dashboard (hover icon Copilot ở dưới cùng VS Code) kiểm plan + account, hoặc xem [../../system-knowledge/status/README.md](../../system-knowledge/status/README.md) — trên IDE của bạn menu có thể gộp nhóm Ask / Plan / Agent.

## Ví dụ thật

Nghiệp vụ: bạn được giao sửa module auth của một repo lạ, muốn hiểu luồng login trước khi động vào.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh)

**Kết quả mong đợi:** một bản mô tả luồng login + danh sách rủi ro, đủ để quyết bước tiếp theo; không file nào bị sửa.

**✅ Verify:** chạy `git status` sau khi hỏi — cây làm việc sạch là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — hỏi trong Ask mà không gắn scope, rồi tưởng Ask "dở":**

> 📄 **Code ví dụ:** [`examples/03-neu-lam-sai-thi-sao-sai-ung.sh`](examples/03-neu-lam-sai-thi-sao-sai-ung.sh)

**✅ ĐÚNG — gắn scope ngay cả khi chỉ hỏi:**

> 📄 **Code ví dụ:** [`examples/04-neu-lam-sai-thi-sao-sai-ung.sh`](examples/04-neu-lam-sai-thi-sao-sai-ung.sh)

**Bài học:** Ask không sửa file, nhưng vẫn cần bạn chỉ cho nó đọc ở đâu. Scope quyết định chất lượng câu trả lời ở mọi mode.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Hỏi "chỉ để hiểu" mà code vẫn đổi | Picker đang để Agent | Nhìn lại agent đang chọn trước khi Enter |
| Ask trả lời thiếu vì không đọc file | Quên gắn scope | Gắn `#file:` / `#codebase` ngay cả trong Ask |
| Ở mãi Ask khi cần sửa | Sợ agent | Hiểu rồi → leo thang sang Agent |

## So sánh với Claude Code

| Việc | Copilot (Ask) | Claude Code | Ghi chú |
|---|---|---|---|
| Chế độ chỉ đọc | Built-in agent Ask riêng, chọn bằng picker | Không tách mode "chỉ hỏi" — mặc định agentic, có plan mode để lập kế hoạch | Copilot tách "hỏi" thành agent; Claude Code coi "chỉ đọc" là một cách dùng |
| Không sửa file | Ask không được cấp tool sửa file | Cần nói rõ "đừng sửa" hoặc ở plan mode | Cùng mục đích: khảo sát trước khi thay đổi |
| Lấy ngữ cảnh | `#file:` / `#codebase` | `@file` hoặc để agent tự đọc | Cả hai đều cần scope thì trả lời mới đúng |

## Best practices (kèm "vì sao")

- **Ask là bước đầu của task lớn.** *Vì sao?* Hiểu luồng trước khi sửa giúp prompt cho Agent trúng hơn nhiều.
- **Luôn gắn scope khi hỏi.** *Vì sao?* Ask không tự biết "module auth" của bạn ở đâu — không scope thì câu trả lời chung chung.
- **Xác nhận đúng agent trước khi Enter.** *Vì sao?* Câu hỏi "chỉ để hiểu" chạy ở Agent có thể kéo theo thay đổi bạn không ngờ.

## Bài tập nhỏ

1. **(3 phút)** Ở Ask, hỏi một module bạn chưa từng đọc (có `#file:`), sau đó chạy `git status` để tự thấy nó sạch.
2. **(5 phút)** Hỏi cùng một câu hai lần: một lần không gắn scope, một lần gắn `#codebase`. So sánh độ cụ thể của hai câu trả lời.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Model & Agent.
- Cheatsheet 1 trang: [CHEATSHEET.md](../../../../../CHEATSHEET.md) · Kẹt thì tra [FAQ troubleshooting](../../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md) · Modes & permission levels: [10-modes-permissions-availability.md](../../../../10-modes-permissions-availability.md).
- Đã biết file cần sửa: [agent-mode](../agent-mode/README.md) · cần plan trước: [plan](../../code-actions/plan/README.md).
- VS Code — [Agents (harness & built-in agents)](https://code.visualstudio.com/docs/agents/concepts/agent-harnesses) · [Chat view](https://code.visualstudio.com/docs/agents/run/chat-view).

> Ask là kính cửa sổ chứ không phải cánh cửa — nhìn thoải mái, nhưng muốn đi qua thì phải đổi agent, và dù chỉ nhìn cũng cần biết nhìn đâu.
