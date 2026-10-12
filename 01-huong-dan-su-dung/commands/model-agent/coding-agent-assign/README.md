# Coding agent assign — Giao issue cho agent làm async

> **Dành cho:** người có issue đã rõ (mục tiêu + phạm vi + lệnh verify) · **Đọc xong:** giao issue async, sáng ra có PR chờ review (~2 phút)

## 1 câu nôm na

Giao việc cho "ca đêm": sáng ngủ dậy đã có PR chờ bạn review. Trên GitHub issue → **Assign** → Copilot, kèm rõ **Mục tiêu / Phạm vi / Lệnh verify**; và để mỗi agent làm một vùng/branch riêng cho khỏi conflict.

Vì agent chạy trên cloud, bạn không ngồi trông từng bước — nên chất lượng issue chính là thứ quyết định kết quả.

## Vì sao dùng coding-agent assign?

Đây là cách chạy song song nhiều việc mà không cần bạn ở máy: giao vài issue độc lập, tối về có vài PR draft. Nhưng vì bạn không can thiệp giữa chừng, issue càng mơ hồ thì agent càng dễ làm sai.

Một mẫu issue 4 dòng để không bị làm sai:

```text
Mục tiêu: thêm rate-limit 5 lần/phút theo IP cho POST /api/login
Phạm vi: apps/api/** (không đụng web/)
Xong khi: rate-limit hoạt động + có test cho nhánh vượt ngưỡng
Lệnh verify: pnpm --filter api test
```

**Nếu làm sai thì sao?** Hai rủi ro lớn: (1) issue mơ hồ → agent làm sai hướng và PR phải bỏ; (2) hai agent cùng đụng một vùng → conflict khó gỡ. Viết issue rõ và chia vùng là hai việc bắt buộc, không phải "làm cho đẹp".

## Khi nào dùng / khi nào đừng

- **Dùng khi:** issue đã rõ (mục tiêu + phạm vi + lệnh verify); việc độc lập, không cần quyết liên tục; muốn song song nhiều issue.
- **ĐỪNG dùng khi:** việc cần bạn quyết từng bước, hoặc scope còn mơ hồ chưa rõ — làm rõ issue trước, hoặc giao cho Agent mode trong IDE để trông trực tiếp.
- **Cho ai:** tech lead chia việc, người muốn song song nhiều issue.

## Cách gọi (copy-paste)

```bash
GitHub issue → Assign → Copilot
Kèm: mục tiêu / phạm vi / lệnh verify
# Kỳ vọng: sáng ra có PR chờ review, diff đúng phạm vi, test xanh
# Verify: PR mở từ branch agent, CI xanh, không đụng file ngoài phạm vi
```

> Muốn giới hạn agent chạy vào vùng nào? Ghi thẳng trong issue (mục "Phạm vi"); không ghi thì nó tự đoán.

## Ví dụ thật

Nghiệp vụ: bạn có issue #142 cần thêm rate-limit cho endpoint login, muốn giao qua đêm.

```bash
# Nội dung issue #142 rồi assign cho Copilot:
Issue #142: "thêm rate-limit cho POST /api/login.
  Mục tiêu: 5 lần/phút theo IP.
  Phạm vi: apps/api/** (không đụng web/).
  Xong khi: có test cho nhánh vượt ngưỡng.
  Lệnh verify: pnpm --filter api test."
→ Assign → Copilot
# Sáng hôm sau: mở PR, đọc tóm tắt + CI
```

**Kết quả mong đợi:** Agent tự tạo branch + PR kèm log và test; bạn chỉ còn việc review và merge.

**✅ Verify:** PR có test xanh + diff chỉ nằm trong phạm vi issue là đạt; nếu nó chạm file ngoài phạm vi, để lại comment yêu cầu thu hẹp.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — issue một dòng, không scope, không lệnh verify:**

```bash
Issue: "làm login ngon hơn" → Assign Copilot
# -> agent đoán sai hướng, PR lệch hẳn
```

**✅ ĐÚNG — issue có mục tiêu, phạm vi, tiêu chí xong, lệnh verify:**

```bash
Issue: "thêm rate-limit cho POST /api/login.
  Phạm vi: apps/api/**. Xong khi: có test nhánh vượt ngưỡng.
  Lệnh verify: pnpm --filter api test." → Assign Copilot
```

**Bài học:** Với coding agent, issue chính là bản đặc tả. Viết càng rõ thì PR sáng mai càng dễ merge.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Agent làm sai vì issue mơ hồ | Thiếu mục tiêu/phạm vi/verify | Viết issue theo mẫu: Mục tiêu/Phạm vi/Xong khi/Lệnh verify |
| Conflict với PR người khác | 2 người đụng 1 vùng | Mỗi agent 1 vùng/branch; rebase trước merge |
| Giao việc quá to | Issue ôm cả epic | Tách issue nhỏ, mỗi issue 1 PR |

## So sánh với Claude Code

| Việc | Copilot (coding agent assign) | Claude Code | Ghi chú |
|---|---|---|---|
| Giao việc async trên cloud | Assign issue cho bot, sinh PR | Không có tương đương trực tiếp — muốn async phải tự dựng Actions/cloud session | Copilot gắn thẳng vào issue/PR trên GitHub |
| Nơi chạy | Hạ tầng cloud của GitHub | Máy bạn hoặc CI tự cấu hình | Copilot không cần máy bạn bật |
| Ràng buộc phạm vi | Ghi trong issue (Mục tiêu/Phạm vi) | Ghi trong prompt/Actions | Cả hai đều cần spec rõ trước khi giao |

## Best practices (kèm "vì sao")

- **Dùng mẫu issue 4 dòng.** *Vì sao?* Agent không hỏi lại được giữa chừng; mục tiêu/phạm vi/verify phải nằm sẵn trong issue.
- **Mỗi agent một vùng và một branch.** *Vì sao?* Hai agent cùng chạm một vùng thì conflict gần như chắc chắn xảy ra.
- **Tách issue lớn thành nhiều issue nhỏ.** *Vì sao?* Issue nhỏ cho PR nhỏ, dễ review và dễ merge; issue ôm epic thì PR to không ai đọc hết.
- **Luôn ghi lệnh verify.** *Vì sao?* Đây là thứ duy nhất chứng minh agent làm đúng, thay vì chỉ "tự thấy ổn".

## Bài tập nhỏ

1. **(5 phút)** Viết một issue theo mẫu 4 dòng cho một việc nhỏ trong repo bạn, rồi đối chiếu xem đã đủ Mục tiêu/Phạm vi/Xong khi/Verify chưa.
2. **(7 phút)** Giao 2 issue độc lập cho Copilot với hai vùng khác nhau; quan sát chúng có conflict không khi cả hai mở PR.
3. **(5 phút)** Lấy một issue cũ viết mơ hồ, thử viết lại theo mẫu rồi tự đánh giá xem agent sẽ làm sai ở đâu với bản cũ.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Model & Agent.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Bước tiếp theo sau khi có PR: [../coding-agent-pr/README.md](../coding-agent-pr/README.md). Chạy agent trong IDE: [../agent-mode/README.md](../agent-mode/README.md).

> Giao issue cho agent cũng là một cách viết spec: mục tiêu càng rõ, PR sáng mai càng dễ merge.
