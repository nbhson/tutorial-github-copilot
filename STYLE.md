# STYLE.md — Khuôn viết "dễ hiểu" cho mọi file .md

Khuôn này thay cách viết template cũ. Mục tiêu: mỗi file đọc như **một người giải thích cho bạn**, không phải máy liệt kê. Lấy cảm hứng từ `tutorial-react/3_react-tutorial/0-react-explore/README.md` (khái niệm đi kèm "vì sao quan trọng" + "nếu làm sai thì sao").

## 1. Nguyên tắc vàng (áp cho MỌI file)

1. **Ba lớp cho mỗi khái niệm then chốt:**
   - **1 câu định nghĩa** (nói thẳng nó là gì).
   - **Nôm na** (so sánh đời thường: bàn làm việc, tủ lạnh, thợ điện...).
   - **Ví dụ copy-paste** (chạy được, cụ thể cho file đó).
2. **Vì sao quan trọng?** — sau khái niệm chính, trả lời "nếu không hiểu cái này thì hậu quả là gì".
3. **Nếu làm sai thì sao?** — nêu mặt trái + cách tránh, không chỉ nêu mặt tốt.
4. **So sánh với Claude Code** — mỗi file có ít nhất 1 bảng đối chiếu khi có "cái tương ứng" tự nhiên (chế độ, quyền, context, agent, MCP, skill...). Không có đối chiếu thật thì ghi rõ "Claude Code không có tương đương trực tiếp" — không bịa.
5. **Pitfall viết dạng ❌ SAI / ✅ ĐÚNG + "Bài học:"** — như react-explore.
6. **Best practices kèm chữ "Vì sao?"** — mỗi mẹo phải có lý do, không liệt kê suông.
7. **Bài tập ngắn** có thời gian từng bài, kiểm chứng được (chạy/sờ thấy kết quả).

## 2. Từ cấm / tuyệt đối tránh (đây là "mùi robot")

- ❌ "Section này trả lời: ...", "Phần này nói về ...", "Nội dung dưới đây gồm ...".
- ❌ "làm đúng theo khối dưới đây", "đổi phần tên file/task cho đúng việc của bạn", "Prompt mẫu cho `<X>` — ...".
- ❌ Một câu "Tham khảo" và "Mẹo 1 dòng" giống y hệt ở mọi file (copy-paste lặp). Mỗi file phải có câu chốt riêng, đúng nội dung file đó.
- ❌ Liệt kê gạch đầu dòng không có lý do ("Vì sao?").
- ❌ Bảng "Nguyên nhân/Fix" trùng nhau giữa các file.
- ❌ Câu dài không mang thông tin, nhét cho đủ số dòng (đừng đua số dòng).
- ❌ Dịch máy móc tiếng Anh word-by-word ("Best practices", "Pitfalls" cứ để tiếng Anh khi nó là thuật ngữ phổ biến — nhưng câu giải thích quanh nó phải tự nhiên).

## 3. Template — bài học (`01-huong-dan-su-dung/`, `02-tips-thuc-chien/`, `03-cau-hoi-thuong-gap/`)

```
# NN — Tên Bài (...)

> **Dành cho:** ai · **Vấn đề:** đang đau ở đâu · **Đọc xong:** làm được gì · **Thời gian:** ~N phút.

## Mục tiêu bài học
- ... (2–4 gạch: đọc xong hiểu/ làm được điều gì, mức độ kiểm chứng được)

## Mục lục
- link tới các mục (giữ anchor ổn định).

## Khái niệm cốt lõi
### 1. <khái niệm>
<nôm na + ví dụ copy-paste>
**Vì sao quan trọng?** ... **Nếu làm sai?** ...
### 2. ...

## Luồng hoạt động (Flow)
1. ... (đánh số từng bước, nêu cả lỗi hay gặp ở bước đó)

## Ví dụ chi tiết
<code chạy được, comment tiếng Việt không dấu trong code block>

## Giải thích từng phần
- Từng dòng/khối code quan trọng: nó làm gì, vì sao viết vậy, sai thì lỗi gì.

## So sánh với Claude Code
| Việc | Copilot | Claude Code | Ghi chú |

## Lỗi thường gặp (❌ SAI / ✅ ĐÚNG)
### 1. <triệu chứng>
❌ SAI: ... ✅ ĐÚNG: ... **Bài học:** ...

## Best practices (kèm "vì sao")
- Mẹo. **Vì sao?** ...

## Bài tập nhỏ
1. (N phút) ...

## Reference
- link nguồn chính thức.
```

## 4. Template — README lệnh (`01-huong-dan-su-dung/commands/<nhóm>/<slug>/README.md`)

```
# /<lệnh> — <mô tả 1 dòng>

> **Dành cho:** ... · **Đọc xong:** ... (~2 phút)

## 1 câu nôm na
<nó là gì, so với thao tác tay thì hơn ở đâu>

## Vì sao dùng <lệnh>?
<lợi ích thật + khi nào nó lợi hơn gõ prompt tay>

## Khi nào dùng / khi nào đừng
- Dùng khi: ...
- ĐỪNG dùng khi: ... (chỉ sang mode/lệnh khác)

## Cách gọi (copy-paste)
```...
```

## Ví dụ thật (lấy đúng nghiệp vụ của lệnh này)
```...
```
**Kết quả mong đợi:** ... **✅ Verify:** ...

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)
❌ ... ✅ ... **Bài học:** ...

## Lỗi thường gặp
| Triệu chứng | Nguyên nhân | Fix |

## So sánh với Claude Code
| Việc | Copilot (`/<lệnh>`) | Claude Code | Ghi chú |

## Best practices (kèm "vì sao")
- ...

## Bài tập nhỏ
1. (N phút) ...

## Tham khảo
- Index nhóm · Cheatsheet · FAQ liên quan · bài học liên quan.

> <câu chốt riêng của lệnh này — KHÔNG copy giữa các file>
```

## 5. Template — index / README nhóm

```
# <Nhóm> (N lệnh)

> **Dành cho:** ... · **Đọc xong:** ...

<một đoạn ngắn: nhóm này giải quyết việc gì, dùng chung thế nào>

| Lệnh | Nó làm gì | Khi nào dùng | Chi tiết |
|---|---|---|---|

## So sánh với Claude Code
| Việc | Copilot | Claude Code |

Quay về: [README.md](README.md) · Bài tổng: [...]
```

## 6. Giữ nguyên (không phá)

- Số hiệu bài, tên file, folder — giữ nguyên.
- **Anchor link** (`#...`) và mọi đường dẫn tương đối — nếu đổi heading thì phải cập nhật nơi trỏ tới; ưu tiên giữ heading cũ khi có link trỏ vào.
- Code block copy-paste được; secrets qua env.
- **Đầy đủ nội dung:** mọi thông tin/số liệu/bảng của bản cũ phải còn (không cần giữ đúng câu chữ, nhưng không được mất ý).

## 7. Checklist "hết robot" trước khi lưu

- [ ] Có "Vì sao quan trọng?" và "Nếu làm sai thì sao?" cho khái niệm chính.
- [ ] Có ít nhất 1 pitfall ❌/✅ + "Bài học:".
- [ ] Có bảng so sánh Claude Code (hoặc ghi rõ không có tương đương).
- [ ] Best practices đều có "Vì sao?".
- [ ] Không còn câu template trong danh sách "từ cấm".
- [ ] Câu chốt cuối file là câu riêng của file này.
- [ ] Không mất thông tin so với bản cũ (đối chiếu nhanh).
