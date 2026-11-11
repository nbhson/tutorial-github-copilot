# @workspace, @terminal, @vscode — vì sao lệnh cũ của bạn không còn chạy

> **Dành cho:** người học Copilot từ 2024–2025, tay đầy prompt gõ `@` · **Vấn đề:** prompt copy từ bài cũ bị im lặng hoặc model trả lời lơ lửng · **Đọc xong:** giải thích được vì sao participants dừng chạy và đổi sang đường nào (~2 phút)
> **Harness:** Local — chat participants chỉ còn chạy ở đây, và cũng đang bị deprecated

## 1 câu nôm na

Participants là kiểu "gọi đúng chuyên viên trong chat": `@workspace` phụ trách ngữ cảnh repo, `@terminal` phụ trách lỗi shell, `@vscode` chạy lệnh của editor. Kiến trúc mới gộp tất cả vào **một harness với tools**: model tự quét repo, tool activity tự hiện — không cần ai để gọi nữa. Docs VS Code đánh dấu **chat participants deprecated** và nguyên văn: **không được hỗ trợ ở Copilot harness**. Vì Local harness vẫn còn chạy chúng, các file prompt cũ "còn sống" trong một cửa sổ — đó là nguồn cơn mọi hiểu lầm.

## Vì sao bài này tồn tại?

Vì một nửa internet vẫn dạy `@workspace` là "cách gắn ngữ cảnh repo". Không hiểu bài này, bạn sẽ: (1) tưởng công cụ hỏng khi prompt bị bỏ qua ở phiên mới; (2) sửa sai hướng — đi cài đặt lung tung thay vì đổi cú pháp; (3) tiếp tục dạy lại cái đã chết cho người mới. Đây là trang "vì sao không còn chạy", không phải trang hướng dẫn dùng.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** prompt cũ của bạn/team chứa `@…`; migrate kho prompt sang Copilot harness; người mới hỏi "mạng bảo gõ `@workspace`".
- **ĐỪNG dùng khi:** bạn chỉ dùng Copilot harness từ đầu — đường đúng là `#`-mentions, nút **Add Context**, instructions và skills (các link cuối bài); bài này không phải lệnh để gọi mà là trang giải thích "vì sao không còn chạy".

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

KHÔNG có đường nào để gọi participants ở Copilot harness. Ba dạng cũ và số phận của chúng:

| Cú pháp cũ (chỉ Local) | Ở Copilot harness | Thay bằng |
|---|---|---|
| `@workspace + câu hỏi` | participant không chạy; model chỉ thấy text | Cứ hỏi — Agent tự quét repo; cần chính xác thì `#file`/selection hoặc **Add Context** |
| `@terminal + mô tả lỗi` | không có participant terminal | Inline chat **trong terminal** (`Ctrl+I`) — xem [../../../copilot/code-actions/debug-terminal/README.md](../../../copilot/code-actions/debug-terminal/README.md) |
| `@vscode + tên lệnh` | không chạy | Command Palette, hoặc nói mong muốn bằng tiếng người |

Ngữ pháp sống của chat hiện tại: `/` để chạy lệnh, `#` để gắn file/vùng chọn, `@` không còn là ký hiệu ngữ cảnh.

## Ví dụ thật

Nghiệp vụ: file prompt của team từ 2024 có dòng "`@workspace liệt kê các endpoint API`"; sau khi team chuyển sang Copilot harness, kết quả chỉ liệt kê file đang mở.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh)

**Kết quả mong đợi:** bản bỏ `@workspace` (hoặc đổi sang gắn `#`/thêm folder qua Add Context) cho Agent tự chạy tool quét repo — thấy tool activity tìm file, không còn cảnh trả lời theo mỗi file đang mở.

**✅ Verify:** gửi cùng một prompt ở phiên Local và phiên Copilot — Local hiện bước `@workspace` thực thi; Copilot không có bước đó nhưng Agent vẫn tự gather bằng tools. Khác biệt này chính là bằng chứng "deprecated, không support ở Copilot harness".

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — gõ `@workspace tổng hợp repo` trong session Copilot harness và tưởng nó hiểu.** Không có participant nào chạy; model thấy đúng câu chữ, phần "chuyên viên repo" im lặng — có khi vẫn trả lời được, nhưng là ăn may từ file đang mở.
**✅ ĐÚNG — bỏ `@…`, hỏi thẳng mong muốn:** "tổng hợp cấu trúc repo, liệt kê package và vai trò" — Agent với tools sẽ tự quét; gắn `#file` khi cần hẹp và chính xác.

**Bài học:** dấu `@` mất đi không khiến prompt báo lỗi — nó khiến prompt **mất người thực hiện** mà bạn không hay; vì thế phải soát kho prompt cũ bằng grep, không bằng mắt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Prompt chạy ở cửa sổ này, im lặng ở cửa sổ khác | Hai harness khác nhau (Local vs Copilot) | Kiểm harness ở picker trước khi gửi; sửa prompt về cú pháp chung |
| Không tìm lại được phiên Local nữa | Local là harness legacy, không có trong Agents window | Đọc [../edit-mode/README.md](../edit-mode/README.md) để hiểu phạm vi Local; đường dài hạn là migrate |
| Người mới hỏi "script cũ bảo gõ @ mà không chạy" | Tài liệu/bài blog cũ chưa cập nhật sau deprecated | Dẫn họ đúng trang này + bảng cú pháp `/` `#` ở trên |
| Xóa cả `@` rồi quên gắn context | Thay sai một cú pháp bằng cách bỏ trống | Thay `@workspace` bằng Add Context/`#file`/instructions, không bỏ trắng |

## So sánh với Claude Code

| Việc | Copilot (hôm nay) | Claude Code | Ghi chú |
|---|---|---|---|
| Gắn ngữ cảnh repo | `#`-mentions, Add Context, Agent tự quét | File mentions + `CLAUDE.md`, tự quét | Claude Code chưa từng qua tầng "gọi @chuyên viên" |
| Nhờ xử lý terminal | Inline chat trong terminal | Tool chạy shell built-in trong session | Cả hai đều bỏ lớp "nhân vật trung gian" |
| Lệnh của editor/UI | Nói mong muốn để Agent dùng tools | Không có kênh gọi lệnh editor tương đương | Hướng hội tụ: 1 agent + tools, không nhiều persona |

## Best practices (kèm "vì sao")

- **grep kho prompt/docs nội bộ lấy `@workspace`, `@terminal`, `@vscode` rồi viết lại.** *Vì sao?* Prompt không báo lỗi khi participant chết — hỏng êm, chỉ có soát mới thấy.
- **Đổi `@workspace` thành `#file`/Add Context, đừng thành "bỏ trống".** *Vì sao?* Bỏ cú pháp mà không bỏ luôn giả định "sẽ có người lo ngữ cảnh" thì chất lượng câu trả lời giảm âm thầm.
- **Việc lặp lại thành quy tắc repo → instructions/`AGENTS.md`.** *Vì sao?* Câu từng nhét vào `@workspace` hằng ngày nên nằm ở file nạp tự động, không phải gõ lại.
- **Đừng dạy `@…` cho người mới.** *Vì sao?* Họ sẽ mất nửa ngày debug một cú pháp đã chết.

## Bài tập nhỏ

1. **(5 phút)** Grep repo tài liệu của bạn ba chuỗi trên; ghi số kết quả — đó là số "bệnh nhân" của bài này.
2. **(4 phút)** Chạy phép so sánh Local vs Copilot harness như mục Verify ở trên, chụp lại tool activity difference.
3. **(3 phút)** Viết lại 1 prompt `@workspace` cũ thành 1 phiên bản `#file` + 1 phiên bản để Agent tự quét; so độ dài câu trả lời.

## Tham khảo

- Index nhóm: [../README.md](../README.md) · Phạm vi Local: [../edit-mode/README.md](../edit-mode/README.md) · Gắn file/selection (`#`): [../../../copilot/chat-session/attachments/README.md](../../../copilot/chat-session/attachments/README.md) · Terminal: [../../../copilot/code-actions/debug-terminal/README.md](../../../copilot/code-actions/debug-terminal/README.md)
- Đường thay thế lâu dài: instructions [../../../copilot/system-knowledge/instructions/README.md](../../../copilot/system-knowledge/instructions/README.md) · skills [../../../copilot/system-knowledge/agent-skill/README.md](../../../copilot/system-knowledge/agent-skill/README.md)
- Bài học: [04 — tổng tập lệnh chat](../../../../04-chat-commands-toan-tap.md) · [13 — code intelligence & ngữ cảnh repo](../../../../13-code-intelligence-indexing-telemetry.md) · FAQ: [prompts/agents/instructions](../../../../../03-cau-hoi-thuong-gap/06-prompts-agents-instructions.md) · Index lệnh: [../../../README.md](../../../README.md) · [CHEATSHEET](../../../../../CHEATSHEET.md)
- VS Code docs — migrate customizations (participants deprecated): https://code.visualstudio.com/docs/agent-customization/migrate-customizations · Move Local → Copilot: https://code.visualstudio.com/docs/agents/run/move-to-copilot · Cheat sheet slash/ký hiệu: https://code.visualstudio.com/docs/agents/reference/ai-features-cheat-sheet

> Participants chết trong im lặng — prompt vẫn chạy, chỉ mất người thực hiện; nên thứ cần sửa không phải cú pháp `@`, mà giả định "ngữ cảnh sẽ tự có người lo".
