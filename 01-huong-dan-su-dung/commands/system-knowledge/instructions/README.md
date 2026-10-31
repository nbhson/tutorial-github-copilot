# /instructions — Xem và sửa bộ luật đang áp cho repo

> **Dành cho:** người mới onboard repo và tech lead giữ luật team · **Vấn đề:** nghi instructions không được nạp, hoặc sửa rule xong mà model vẫn làm theo cách cũ · **Đọc xong:** thấy đúng những rule đang có hiệu lực cho file bạn mở, sửa ngay tại chỗ (~2 phút)

## 1 câu nôm na

`/instructions` là bảng nội quy lớp đang dán trên tường: nó cho bạn xem **rule nào đang được nạp** — `copilot-instructions.md` đọc cho mọi chat, còn `*.instructions.md` chỉ đọc khi file bạn đang mở khớp `applyTo`. Khác thao tác tay ở chỗ bạn không phải tự mở từng file trong `.github/` rồi tự đoán cái nào đang ăn; gõ một lệnh là ra danh sách, sai thì sửa luôn.

## Vì sao dùng /instructions?

Gõ prompt tay, bạn không kiểm chứng được điều quan trọng nhất: **model đang thấy luật gì**. Bạn sửa `copilot-instructions.md`, nhưng rất có thể một file `.instructions.md` của thư mục khác đang ghi đè; hoặc rule viết đúng mà glob `applyTo` sai nên chưa từng được nạp. `/instructions` trả thẳng danh sách rule đang áp cho repo/file hiện tại, nên bạn biết chắc mình đang sửa đúng chỗ.

**Nếu bỏ qua bước này thì sao?** Bạn sẽ đoán già đoán non: sửa rule mà không hiểu vì sao model vẫn làm cũ, rồi kết luận “Copilot dở” trong khi lỗi nằm ở glob hoặc ở một file rule khác đè lên.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** nghi instructions không được nạp; muốn sửa luật team ngay; mới onboard và muốn biết repo này có quy tắc gì; đang debug ca “model làm trái hẳn quy ước”.
- **ĐỪNG dùng khi:** việc bạn cần là một **workflow lặp lại** (đóng thành prompt file hoặc skill thay vì nhồi rule — xem [../prompt-file/README.md](../prompt-file/README.md) và [../agent-skill/README.md](../agent-skill/README.md)), cần một **persona riêng** (custom agent), hay cần áp cho **cả tổ chức** (đó là org policy, không phải file trong repo).

## Cách gọi (copy-paste)

```bash
/instructions
# liệt kê rules đang áp cho repo/file hiện tại
# Kỳ vọng: thấy đúng rules (repo-wide + applyTo khớp file đang mở)
# Verify: sửa 1 rule → mở chat mới → hỏi lại → model làm theo rule mới
```

> Không thấy `/instructions` trong list khi gõ `/`? Kiểm tra `/status` và plan trước khi kết luận đây là lỗi công cụ — không phải plan nào cũng bật lệnh này.

## Ví dụ thật

Nghiệp vụ: team quy định “route không được query DB trực tiếp”, nhưng một bạn vừa thêm `db.query()` thẳng trong route. Bạn muốn xem luật này có đang được nạp cho file đó không.

```bash
# Trong apps/api/src/routes/login.ts, gọi:
/instructions "liệt kê quy tắc đang áp cho file apps/api/login.ts"

# Đọc kết quả:
#  - Thấy rule "route không query DB trực tiếp"
#    (từ .github/instructions/api.instructions.md, applyTo: apps/api/**)
#    → rule CÓ được nạp.
#  - Không thấy → glob applyTo sai, hoặc rule nằm nhầm file.
```

**Kết quả mong đợi:** danh sách rule đang áp, có cả repo-wide lẫn `*.instructions.md` khớp file đang mở; chỗ sai thì sửa được ngay.

**✅ Verify:** sửa một rule (hoặc thêm 1 dòng mới) → mở chat mới → hỏi lại đúng câu vừa rồi → model làm theo rule mới là đạt. Model vẫn làm cũ → thủ phạm là chat cũ còn context (xem mục ❌/✅ ngay dưới).

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — sửa rule rồi test trên chính chat cũ:**

```text
Sửa .github/copilot-instructions.md → hỏi lại trong CHÍNH chat đang mở
→ model vẫn làm theo rule cũ → tưởng file không có tác dụng.
```

**✅ ĐÚNG — mở chat mới để rule được nạp lại:**

```text
Sửa rule → /new (chat mới) → hỏi lại → model làm theo rule mới.
```

**Bài học:** rule trong repo chỉ có hiệu lực **ở lượt nạp kế tiếp**; chat cũ vẫn ôm context cũ. Test rule mới thì phải test trên chat mới.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Rule không ăn | `applyTo` sai hoặc file quá dài | Kiểm tra glob `applyTo`; giữ file <200 dòng |
| Nhiều rule mâu thuẫn | Thứ tự ưu tiên không rõ | Gom luật chung lên repo-wide, chi tiết đẩy xuống `applyTo` theo thư mục |
| Sửa rồi model vẫn làm cũ | Chat cũ còn ngữ cảnh | `/new` rồi test lại |

## So sánh với Claude Code

| Việc | Copilot (`/instructions`) | Claude Code | Ghi chú |
|---|---|---|---|
| Xem luật đang nạp | Có lệnh `/instructions` liệt kê rule đang áp | Không có lệnh tương đương — mở `CLAUDE.md` / `.claude/` để đọc | Copilot có cách *hỏi* luật; Claude Code đọc file trực tiếp |
| File luật trong repo | `.github/copilot-instructions.md` + `.github/instructions/*.instructions.md` (`applyTo`) | `CLAUDE.md` + `.claude/` | Cùng tư tưởng “file trong repo là luật” |
| Luật theo thư mục | `applyTo` glob trong `*.instructions.md` | Chia nhỏ trong `.claude/` | Cùng mục tiêu, khác cơ chế khai báo |

## Best practices (kèm "vì sao")

- **Kiểm `/instructions` trước khi tin “rule đã nạp”.** *Vì sao?* Nạp rule là chuyện của glob + vị trí file, không phải chuyện bạn *đã viết* rule đó ra.
- **Giữ mỗi file rule <200 dòng.** *Vì sao?* Rule dài bị nạp lại mỗi lượt, vừa tốn credits vừa loãng trọng tâm — phần dài dòng nên tách sang skill.
- **Một luật chỉ nằm một nơi.** *Vì sao?* Hai bản cùng luật sẽ lệch nhau; không rõ bản nào thắng thì mọi lần sửa đều là đoán.
- **Test rule mới bằng chat mới.** *Vì sao?* Cách duy nhất để chắc rule được nạp lại là bắt đầu một lượt hội thoại sạch.
- **Luật chung để repo-wide, luật hẹp dùng `applyTo`.** *Vì sao?* Luật hẹp mà nạp cho mọi chat là lãng phí; luật chung nhét vào một thư mục thì chỗ khác không thấy.

## Bài tập nhỏ

1. **(5 phút)** Chạy `/instructions` trên repo đang làm; ghi lại có bao nhiêu rule repo-wide và bao nhiêu file `*.instructions.md`.
2. **(10 phút)** Thêm 1 rule nhỏ (ví dụ “log luôn dùng `logger`, không `console.log`”), rồi test bằng **chat mới** xem model có tuân không.
3. **(10 phút)** Cố tình đổi `applyTo` sang sai thư mục, chạy `/instructions` xem rule còn hiện cho file cũ không — rồi sửa lại. Ghi 2 dòng vì sao glob quan trọng.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh System & Knowledge.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Viết luật cho đúng, và tách checklist dài sang skill: [bài 05 — Agent Skills & Custom Instructions](../../../05-prompt-files-custom-instructions.md).

> **Chốt:** đừng tin “rule đã có” chỉ vì bạn đã viết — gõ `/instructions` để xem model thật sự đang bị ràng buộc bởi gì, rồi mới test trên chat mới.
