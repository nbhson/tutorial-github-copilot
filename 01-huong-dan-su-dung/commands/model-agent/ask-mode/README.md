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

**Nếu làm sai thì sao?** Hai sai lầm hay gặp: (1) nhầm đang ở Edit/Agent mà tưởng Ask → code bị đổi; (2) ở mãi Ask dù đã hiểu rồi → bạn ngồi tự sửa tay trong khi Edit/Agent làm nhanh hơn. Ask là chế độ rẻ nhất để khảo sát, không phải "chế độ an toàn để không bao giờ phải sửa".

## Khi nào dùng / khi nào đừng

- **Dùng khi:** tìm hiểu code/kiến trúc trước khi đụng; so sánh phương án chưa muốn sửa; review kiểu "đoạn này làm gì, rủi ro gì?".
- **ĐỪNG dùng khi:** bạn đã biết cần sửa file nào → chuyển **Edit mode**; hoặc task mở, chưa biết chạm file nào → chuyển **Agent mode**.
- **Cho ai:** người mới (hỏi cho an toàn), reviewer, người đang cân nhắc phương án.

## Cách gọi (copy-paste)

```bash
Chat → dropdown mode → Ask
"#file:src/cache.ts — so sánh 2 cách cache, chưa cần sửa code"
# Kỳ vọng: trả lời phân tích, không file nào bị đổi
# Verify: git status sạch sau khi hỏi
```

> Không thấy **Ask** trong dropdown? Xem `/status` và plan trước khi kết luận lỗi — trên IDE của bạn menu có thể gộp nhóm như Ask / Plan / Agent.

## Ví dụ thật

Nghiệp vụ: bạn được giao sửa module auth của một repo lạ, muốn hiểu luồng login trước khi động vào.

```bash
# Ở Ask mode, gắn scope để nó đọc đúng chỗ
(Ask) "@workspace đọc module auth trong src/auth/ và vẽ lại flow login bằng chữ,
chỉ ra 3 rủi ro bảo mật lớn nhất. Không sửa file nào."
# Verify: git status -> không có file nào thay đổi
```

**Kết quả mong đợi:** Một bản mô tả luồng login + danh sách rủi ro, đủ để bạn quyết bước tiếp theo; không file nào bị sửa.

**✅ Verify:** Chạy `git status` sau khi hỏi — cây làm việc sạch là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — hỏi trong Ask mà không gắn scope, rồi tưởng Ask "dở":**

```bash
(Ask) "module auth hoạt động thế nào?"   # không đọc file -> trả lời generic
```

**✅ ĐÚNG — gắn scope ngay cả khi chỉ hỏi:**

```bash
(Ask) "@workspace src/auth/ hoạt động thế nào? Chỉ đọc, không sửa."
```

**Bài học:** Ask không sửa file, nhưng vẫn cần bạn chỉ cho nó đọc ở đâu. Scope là thứ quyết định chất lượng câu trả lời ở mọi mode.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Hỏi trong Ask mà code vẫn đổi | Nhầm mode (đang Edit/Agent) | Nhìn lại dropdown mode trước khi Enter |
| Ask trả lời thiếu vì không đọc file | Quên gắn scope | Gắn `#file`/`@workspace` ngay cả trong Ask |
| Ở mãi Ask khi cần sửa | Sợ agent | Hiểu rồi → leo thang Edit/Agent |

## So sánh với Claude Code

| Việc | Copilot (Ask mode) | Claude Code | Ghi chú |
|---|---|---|---|
| Chế độ chỉ đọc | Có mode Ask riêng, chọn bằng dropdown | Không tách mode riêng — mặc định agentic, nhưng có plan mode để chỉ lập kế hoạch | Copilot tách "hỏi" thành mode; Claude Code coi "chỉ đọc" là một cách dùng |
| Không sửa file | Ask cam kết không đụng file | Cần nói rõ "đừng sửa" hoặc dùng plan mode | Cùng mục đích: khảo sát trước khi thay đổi |
| Lấy ngữ cảnh | Vẫn cần `#file`/`@workspace` | `@file` hoặc để agent tự đọc | Cả hai đều cần scope thì trả lời mới đúng |

## Best practices (kèm "vì sao")

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
