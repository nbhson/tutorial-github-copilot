# Policy approval — Duyệt policy, cho phép lệnh nhạy cảm

> **Dành cho:** người thấy popup Allow/Deny, và admin set policy cho team · **Đọc xong:** set baseline allow/ask/deny đúng chỗ, không bấm Allow mù (~2 phút)

## 1 câu nôm na

Cổng bảo vệ trước máy bạn: lệnh lành cho qua, lệnh nguy hiểm phải "xuất trình". Khi agent xin chạy một lệnh (terminal/MCP), popup **Allow/Deny** hiện ra; còn team thì set baseline **allow/ask/deny** theo từng tool ở `settings → policies`.

Vì agent có quyền chạy lệnh thật, cái cổng này chính là ranh giới giữa "một gợi ý sai" và "một lệnh đã chạy trên máy bạn".

## Vì sao dùng policy approval?

Vì không phải lệnh nào cũng đáng để hỏi, và cũng không phải lệnh nào được phép chạy thẳng. Nếu bạn bấm Allow cho tất cả, lệnh nguy hiểm lọt qua; nếu bạn siết cả những thao tác đọc lặp lại, bạn sẽ mỏi tay rồi bấm mù — cũng nguy hiểm không kém.

Ba mức cần nắm:

| Mức | Ý nghĩa | Khi nào dùng |
|---|---|---|
| Allow | Cho chạy luôn, không hỏi lại | Tool chỉ-đọc (đọc file/grep/list) hoặc lệnh lành đã tin |
| Ask | Hỏi bạn trước mỗi lần chạy | Lệnh ghi/xóa/MCP chưa chắc — mặc định an toàn |
| Deny | Chặn hẳn, không cho chạy | Lệnh destructive: `rm`, force-push, migration prod |

**Nếu làm sai thì sao?** Allow hết để "cho nhanh" là cách mở toang cửa. Ngược lại, deny cả những lệnh đọc lặp lại khiến bạn bấm Allow đến mỏi tay rồi bấm cho xong — bạn vô hiệu hóa chính cái gate mình dựng công phu.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** agent xin Allow chạy lệnh (terminal/MCP tool); muốn set baseline allow/ask/deny cho team; nghi policy org đang chặn một việc bạn cần.
- **ĐỪNG dùng như chỗ "đổi cho xong":** đừng Allow một lệnh bạn chưa hiểu, chỉ để nó chạy tiếp. Cổng an toàn chỉ có giá trị khi bạn thật sự nhìn vào nó.
- **Cho ai:** người duyệt lệnh cho agent, admin/tech lead set policy cho team.

## Cách gọi (copy-paste)

```bash
Popup Allow/Deny khi agent xin
Team: settings → policies → allow/ask/deny theo tool
# Kỳ vọng: lệnh nguy hiểm bị hỏi/chặn, lệnh lành chạy trơn
# Verify: thử 1 lệnh nhạy cảm — bị hỏi/chặn đúng baseline
```

> Không thấy tab Policies? Có thể bạn đang ở plan Individual (thiếu org policy) hoặc org chưa cấu hình — hỏi admin trước khi kết luận lỗi.

## Ví dụ thật

Nghiệp vụ: agent đang làm task migration và xin chạy lệnh migration lên database.

```bash
# Agent xin: "chạy npm run migrate --up"
→ Chọn Deny
→ Trả lời: "chỉ chạy trên DB dev, đưa lệnh ra cho tôi xem trước đã"
# Verify: agent dừng lệnh đó, đưa lệnh để bạn tự quyết
```

**Kết quả mong đợi:** Lệnh nguy hiểm bị chặn và hiện ra để bạn xem trước; các lệnh lành (đọc file, chạy test đọc) vẫn chạy trơn.

**✅ Verify:** Thử một lệnh nhạy cảm và một lệnh lành — cái đầu bị hỏi/chặn, cái sau chạy thẳng, đúng theo baseline là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — bấm Allow mù cho một lệnh chưa đọc:**

```bash
# Popup: "chạy rm -rf node_modules && npm i" -> bấm Allow ngay
# Bạn không để ý lệnh còn gì phía sau
```

**✅ ĐÚNG — đọc lệnh, Deny mặc định cho thao tác ghi/xóa:**

```bash
# Popup hiện lệnh -> đọc hết -> nếu là ghi/xóa: Deny
# "Đưa lệnh ra trước, tôi tự chạy" hoặc đổi sang lệnh an toàn
```

**Bài học:** Deny là mặc định an toàn cho lệnh ghi/xóa. Chỉ Allow cho những tool đọc mà bạn thật sự tin.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Bấm Allow mù cho qua | Mỏi tay | Deny mặc định cho lệnh ghi/xóa; chỉ allow tools đọc |
| Không biết ai chặn | Nhầm policy vs bug | Hỏi admin tab Policies + xem audit log |
| Mỗi máy 1 kiểu approval | Thiếu baseline team | Commit baseline vào repo + viết docs |

## So sánh với Claude Code

| Việc | Copilot (policy approval) | Claude Code | Ghi chú |
|---|---|---|---|
| Duyệt lệnh trước khi chạy | Popup Allow/Deny; baseline allow/ask/deny theo tool | Permission prompt + allowlist trong `settings.json` | Cùng mô hình: đọc thì nới, ghi/xóa thì siết |
| Thứ tự ưu tiên | `deny > ask > allow`; org > team > personal | Allowlist + chế độ permission | Cùng tư tưởng deny-first |
| Nơi đặt luật | `.vscode/settings.json` + org policy | `settings.json` + quản lý của org | Khác tên file, cùng ý nghĩa |

## Best practices (kèm "vì sao")

- **Allow cho tool chỉ-đọc, `ask`/`deny` cho phần còn lại.** *Vì sao?* Việc đọc lặp lại rất nhiều; thao tác ghi/xóa mới là chỗ rủi ro.
- **Thuộc quy tắc `deny > ask > allow`.** *Vì sao?* Deny ở bất kỳ đâu cũng thắng — biết luật này bạn khỏi mất buổi tối "lách" bằng personal setting.
- **Commit baseline của team vào repo.** *Vì sao?* Mỗi máy một kiểu approval thì review chung sẽ loạn; baseline chung giúp hành xử thống nhất.
- **Thấy bị chặn thì xem audit/policy trước khi đoán bug.** *Vì sao?* Phần lớn ca "sao nó không cho chạy" là policy, không phải lỗi công cụ.

## Bài tập nhỏ

1. **(3 phút)** Chạy một lệnh chỉ-đọc qua agent (ví dụ `git diff --stat`), xem nó có hỏi bạn không — nếu không, đó là allow đang hoạt động.
2. **(5 phút)** Thử một lệnh nhạy cảm (ví dụ một lệnh có `rm`) và chủ động Deny; xác nhận agent dừng lại thay vì lách.
3. **(5 phút)** Viết một baseline allow/ask/deny cho repo của bạn (3–5 dòng) và bàn với team xem nên commit vào đâu.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Model & Agent.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Lý thuyết allow/ask/deny + permission level: [10-modes-permissions-availability.md mục 5](../../../10-modes-permissions-availability.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Approval tốt không phải để chặn cho oai — nó bảo đảm mọi lệnh nguy hiểm đều đi qua mắt người trước khi chạy.
