# Ctrl+I (inline chat) — Hỏi/sửa ngay tại dòng code

> **Dành cho:** dev sửa đoạn nhỏ ngay tại dòng code · **Vấn đề:** mở Chat view riêng làm đứt mạch đọc code · **Đọc xong:** sửa 5–20 dòng tại chỗ, Accept từng hunk, không rời editor (~2 phút)

## 1 câu nôm na

Thì thầm hỏi ngay bên cạnh dòng code, khỏi mở cửa sổ chat riêng. Bạn bôi đen code → `Ctrl+I` (Win/Linux) / `Cmd+I` (Mac) → nhập yêu cầu → diff hiện ngay tại chỗ để Accept/Discard.

Khác với mở Chat view: inline chat giữ bạn **trong editor**, không nhảy tab, nên mạch đọc code không bị cắt.

## Vì sao dùng Ctrl+I?

Phần lớn thao tác sửa code hằng ngày rất nhỏ: thêm một null check, đổi tên biến, bọc một `try/catch`. Mở hẳn Chat view cho những việc này là thừa. Inline chat gọn hơn vì:

- **Không rời editor** — diff ngay tại dòng đang đứng.
- **Scope tự nhiên là selection** — bạn bôi đen cái gì thì nó sửa cái đó.
- **Duyệt từng hunk** — Accept/Discard tại chỗ, kiểm soát chặt.

**Nếu làm sai thì sao?** Hai lỗi hay gặp: (1) chưa bôi đen đã bấm nên không thấy gì; (2) yêu cầu quá to trong một lần khiến diff khó đọc. Cũng có trường hợp scope inline vẫn "ăn" ra ngoài vùng chọn nếu bạn không nói rõ. Xem ❌/✅.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** sửa một đoạn nhỏ 5–20 dòng ngay tại chỗ; đang đọc code và muốn hỏi nhanh về đoạn đó; muốn giữ dòng suy nghĩ, không chuyển tab.
- **ĐỪNG dùng khi:** việc cần context nhiều file hoặc tool ngoài — mở Chat view (Agent mode) sẽ phù hợp hơn.
- **Cho ai:** dev đang đọc/sửa code lẻ, muốn giữ mạch suy nghĩ không chuyển tab.

## Cách gọi (copy-paste)

```bash
Bôi đen code → Ctrl+I (Win/Linux) / Cmd+I (Mac)
Nhập: thêm null check, giữ nguyên API
# Kỳ vọng: diff hiện ngay tại chỗ để Accept/Discard
```

> Muốn chắc `Ctrl+I` hoạt động: mở chat inline từ dòng đang bôi đen, xem Copilot có phản hồi không. Không thấy gì → bôi đen lại, check status bar Copilot.

## Ví dụ thật

Nghiệp vụ: trong `src/utils/parse.ts`, hàm `parseConfig()` đọc `process.env.CONFIG` có thể `undefined` và ném lỗi khó hiểu. Bạn muốn chặn sớm ngay tại chỗ.

```bash
# Boi den than ham parseConfig()
# Ctrl+I -> nhap:
"thêm guard cho process.env.CONFIG: nếu undefined thì trả {} thay vì crash, giữ nguyên chữ ký hàm"
# Verify: chay test focused cho parseConfig -> xanh
```

**Kết quả mong đợi:** Diff hiện ngay tại chỗ; Accept từng hunk hoặc Discard; code chạy tiếp không gián đoạn.

**✅ Verify:** Chạy test focused cho hàm vừa sửa — xanh là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — bấm Ctrl+I khi chưa bôi đen, hoặc gom quá nhiều việc vào một lần:**

```bash
# (khong boi den) Ctrl+I -> "refactor ca file nay, doi ten het, them test" -> khong hien gi / diff roi loan
```

**✅ ĐÚNG — bôi hẹp đúng đoạn, nói rõ "chỉ sửa đoạn đã chọn":**

```bash
# Boi den dung than ham parseConfig()
# Ctrl+I -> "chi sua doan da chon: them guard cho process.env.CONFIG, giu nguyen chu ky"
```

**Bài học:** Mỗi lần `Ctrl+I` một việc, bôi hẹp. Diff nhỏ thì review dễ và chính xác.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Bấm `Ctrl+I` không hiện gì | Chưa bôi đen / extension chưa active | Bôi đen code trước; check Copilot status bar |
| Sửa lan sang chỗ khác | Scope inline vẫn ăn cả file | Bôi hẹp lại + ghi rõ "chỉ sửa đoạn đã chọn" |
| Diff khó đọc | Change quá to một lần | Chia nhỏ: mỗi `Ctrl+I` một việc |

## So sánh với Claude Code

| Việc | Copilot (`Ctrl+I`) | Claude Code | Ghi chú |
|---|---|---|---|
| Sửa tại chỗ trong editor | Inline chat ngay dòng code | Không có tương đương trực tiếp (terminal-first) | Copilot mạnh ở lớp editor |
| Scope từ selection | Tự dùng phần bôi đen | Đưa file/đoạn trong prompt | Cùng tư tưởng: đưa đúng chỗ đau |
| Duyệt diff tại chỗ | Accept/Discard từng hunk ngay inline | Duyệt diff trong terminal/IDE | Đều bắt bạn review trước khi nhận |

## Best practices (kèm "vì sao")

- **Bôi đen trước, luôn luôn.** *Vì sao?* Selection là scope — không bôi thì hoặc không có gì, hoặc model tự đoán rộng.
- **Một việc mỗi lần `Ctrl+I`.** *Vì sao?* Diff nhỏ dễ review; gom nhiều việc làm diff rối và dễ Accept nhầm.
- **Nói "giữ nguyên..." khi cần.** *Vì sao?* Model có xu hướng tiện tay dọn dẹp thứ không hỏng.
- **Sửa xong chạy test focused.** *Vì sao?* Inline chỉ sinh diff; tính đúng do test quyết định.

## Bài tập nhỏ

1. **(3 phút)** Bôi đen một hàm nhỏ, `Ctrl+I` sửa một chỗ (ví dụ thêm guard), Accept và quan sát diff nhỏ cỡ nào.
2. **(5 phút)** Thử gom 3 việc khác nhau vào một `Ctrl+I` — ghi lại diff rối thế nào; rồi tách thành 3 lần để so sánh.
3. **(5 phút)** Gọi `Ctrl+I` mà không bôi đen, xem phản ứng; rút ra thói quen bôi trước.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Chat Session.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Hỏi nhanh không cần sửa: [../quick-chat/README.md](../quick-chat/README.md). Việc dài nhiều file: [../help/README.md](../help/README.md) xem các chế độ.

> Inline chat là công cụ của những thay đổi nhỏ: càng bôi hẹp và càng nói rõ "giữ nguyên", diff của bạn càng sạch.
