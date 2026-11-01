# Ask mode — Chế độ chỉ hỏi, không sửa

> **Dành cho:** người muốn hiểu code/kiến trúc trước khi đụng vào · **Đọc xong:** hỏi thoải mái mà `git status` vẫn sạch (~2 phút)

## 1 câu nôm na

Chế độ "chỉ nhìn, không chạm": hỏi gì cũng được, code không mất một cọng. Vào Chat → dropdown mode → **Ask**, rồi hỏi như bình thường.

Nhưng đừng tưởng Ask tự biết file bạn đang nói tới — nó vẫn chỉ trả lời tốt khi bạn gắn `#file`/`@workspace`. Không gắn scope thì câu trả lời sẽ chung chung, dù đúng là nó chưa sửa gì.

## Vì sao dùng Ask mode?

Có những việc bạn muốn *hiểu* trước khi *sửa*: đọc một module lạ, so sánh hai phương án, review xem đoạn code này có rủi ro gì. Ở Ask, bạn hỏi thoải mái mà không sợ agent tiện tay sửa lung tung.

Ba chế độ của Chat khác nhau ở mức quyền, đây là bảng để bạn chọn nhanh:

| Mode | Đặc điểm | Khi nào dùng |
|---|---|---|
| Ask | Chỉ đọc, không sửa file | Hỏi/khảo sát/so sánh phương án trước khi đụng code |
| Edit | Sửa đúng files bạn tick, có kiểm soát | Đã biết sửa 1–5 file, muốn review từng hunk |
| Agent | Tự tìm file, sửa, chạy terminal | Task mở nhiều bước, chưa biết chạm file nào |

> **Cách đọc bảng này:** ba dòng xếp theo độ tự chủ tăng dần — Ask đứng đầu vì "rẻ" nhất; khi việc của bạn chỉ cần đọc thì đừng đi sâu xuống dưới.

**Nếu làm sai thì sao?** Hai sai lầm hay gặp: (1) nhầm đang ở Edit/Agent mà tưởng Ask → code bị đổi; (2) ở mãi Ask dù đã hiểu rồi → bạn ngồi tự sửa tay trong khi Edit/Agent làm nhanh hơn. Ask là chế độ rẻ nhất để khảo sát, không phải "chế độ an toàn để không bao giờ phải sửa".

> **Tóm gọn 1 câu:** Ask là kính cửa sổ chứ không phải cánh cửa — nhìn thoải mái nhưng muốn đi qua (sửa code) thì phải đổi mode, và dù chỉ nhìn cũng cần biết nhìn đâu (`#file`).

## Khi nào dùng / khi nào đừng

- **Dùng khi:** tìm hiểu code/kiến trúc trước khi đụng; so sánh phương án chưa muốn sửa; review kiểu "đoạn này làm gì, rủi ro gì?".
- **ĐỪNG dùng khi:** bạn đã biết cần sửa file nào → chuyển **Edit mode**; hoặc task mở, chưa biết chạm file nào → chuyển **Agent mode**.
- **Cho ai:** người mới (hỏi cho an toàn), reviewer, người đang cân nhắc phương án.

> **Tóm gọn 1 câu:** Muốn hiểu trước khi đụng thì Ask là bước rẻ nhất — hiểu xong leo thang ngay, đừng biến chỗ khảo sát thành chỗ trú ẩn.

## Cách gọi (copy-paste)

> 📄 **Code ví dụ:** [`examples/01-cach-goi-copy-paste.sh`](examples/01-cach-goi-copy-paste.sh)

> Không thấy **Ask** trong dropdown? Xem `/status` và plan trước khi kết luận lỗi — trên IDE của bạn menu có thể gộp nhóm như Ask / Plan / Agent.

## Ví dụ thật

Nghiệp vụ: bạn được giao sửa module auth của một repo lạ, muốn hiểu luồng login trước khi động vào.

> 📄 **Code ví dụ:** [`examples/02-vi-du-that.sh`](examples/02-vi-du-that.sh)

**Kết quả mong đợi:** Một bản mô tả luồng login + danh sách rủi ro, đủ để bạn quyết bước tiếp theo; không file nào bị sửa.

**✅ Verify:** Chạy `git status` sau khi hỏi — cây làm việc sạch là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — hỏi trong Ask mà không gắn scope, rồi tưởng Ask "dở":**

> 📄 **Code ví dụ:** [`examples/03-neu-lam-sai-thi-sao-sai-ung.sh`](examples/03-neu-lam-sai-thi-sao-sai-ung.sh)

**✅ ĐÚNG — gắn scope ngay cả khi chỉ hỏi:**

> 📄 **Code ví dụ:** [`examples/04-neu-lam-sai-thi-sao-sai-ung.sh`](examples/04-neu-lam-sai-thi-sao-sai-ung.sh)

**Bài học:** Ask không sửa file, nhưng vẫn cần bạn chỉ cho nó đọc ở đâu. Scope là thứ quyết định chất lượng câu trả lời ở mọi mode.

## Lỗi thường gặp

Câu trả lời "chắc mình bị hỏng gì đó" khi đang ở Ask? Ba ca dưới đây giải thích gần hết — tra theo Triệu chứng rồi áp Fix.

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Hỏi trong Ask mà code vẫn đổi | Nhầm mode (đang Edit/Agent) | Nhìn lại dropdown mode trước khi Enter |
| Ask trả lời thiếu vì không đọc file | Quên gắn scope | Gắn `#file`/`@workspace` ngay cả trong Ask |
| Ở mãi Ask khi cần sửa | Sợ agent | Hiểu rồi → leo thang Edit/Agent |

> **Cách đọc bảng này:** đọc theo hàng từ Triệu chứng → Fix; hàng giữa là ca phổ biến nhất — "Ask dở" thường thực ra là "thiếu scope", không phải lỗi mode.

## So sánh với Claude Code

Cũng dùng Claude Code? Bảng này đối chiếu tư duy "chỉ đọc" của hai công cụ — chỗ khác bản chất nằm ở cách mỗi bên tách (hoặc không tách) mode riêng.

| Việc | Copilot (Ask mode) | Claude Code | Ghi chú |
|---|---|---|---|
| Chế độ chỉ đọc | Có mode Ask riêng, chọn bằng dropdown | Không tách mode riêng — mặc định agentic, nhưng có plan mode để chỉ lập kế hoạch | Copilot tách "hỏi" thành mode; Claude Code coi "chỉ đọc" là một cách dùng |
| Không sửa file | Ask cam kết không đụng file | Cần nói rõ "đừng sửa" hoặc dùng plan mode | Cùng mục đích: khảo sát trước khi thay đổi |
| Lấy ngữ cảnh | Vẫn cần `#file`/`@workspace` | `@file` hoặc để agent tự đọc | Cả hai đều cần scope thì trả lời mới đúng |

> **Cách đọc bảng này:** đọc theo hàng so khớp tư duy; cột Ghi chú nói rõ khác biệt thật — một bên làm thành mode, một bên làm thành cách dùng, đích đến thì giống nhau.

## Best practices (kèm "vì sao")

Bốn thói quen dưới đây giúp Ask phát huy đúng vai "bước khảo sát rẻ nhất" — mỗi thói quen kèm lý do.

- **Ask là bước đầu của task lớn.** *Vì sao?* Hiểu luồng trước khi sửa giúp bạn viết prompt cho Edit/Agent trúng hơn nhiều.
- **Luôn gắn scope khi hỏi.** *Vì sao?* Ask không tự biết "module auth" của bạn ở đâu — không scope thì câu trả lời chung chung.
- **Xác nhận đang ở đúng mode trước khi Enter.** *Vì sao?* Câu hỏi "chỉ để hiểu" mà chạy ở Agent có thể kéo theo thay đổi bạn không ngờ.
- **Hiểu rồi thì leo thang, đừng nấn ná.** *Vì sao?* Ở Ask quá lâu với việc cần sửa = bạn tự làm chậm mình.

## Bài tập nhỏ

1. **(3 phút)** Ở Ask, hỏi một module bạn chưa từng đọc (có `#file`), sau đó chạy `git status` để tự thấy nó sạch.
2. **(5 phút)** Hỏi cùng một câu hai lần: một lần không gắn scope, một lần có `@workspace`. So sánh độ cụ thể của hai câu trả lời.
3. **(7 phút)** Dùng Ask để so sánh hai phương án (ví dụ: cache in-memory vs Redis), chọn ra phương án rồi mới sang Edit để sửa đúng phần bạn đã chốt.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Model & Agent.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Đã biết sửa file nào: [../edit-mode/README.md](../edit-mode/README.md). Task mở, nhiều bước: [../agent-mode/README.md](../agent-mode/README.md).

> Ask không phải bước "tốn thời gian" — đây là bước rẻ nhất để bạn khỏi phải sửa nhầm một thứ mình chưa hiểu.
