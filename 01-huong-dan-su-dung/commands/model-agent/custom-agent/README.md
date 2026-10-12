# Custom agent — Gọi agent riêng của repo

> **Dành cho:** người đã có agent riêng trong `.github/agents/` (explorer, tester, security-reviewer) · **Đọc xong:** gọi đúng chuyên gia và đẩy việc ồn ào sang sub-agent (~2 phút)

## 1 câu nôm na

Gọi đúng người trong danh bạ: explorer đi trinh sát, tester đi kiểm tra, security-reviewer soi diff. Bạn gọi agent trong `.github/agents/` và nói rõ phạm vi ngay trong lời gọi — chỉ-đọc hay được phép sửa, file nào được đụng.

Ý tưởng giống "thợ chuyên việc": thay vì bắt một agent tổng quát ôm hết, bạn tách mỗi việc cho một persona hẹp, có tool và quyền giới hạn.

## Vì sao dùng Custom agent?

Chat chính nếu ôm cả việc trinh sát multi-file sẽ rất ồn: nó đọc mười mấy file, kết quả lẫn lộn, bạn khó theo dõi quyết định nào là chính. Đẩy việc ồn sang sub-agent thì chat chính chỉ còn lại các quyết định gọn gàng.

Ba việc điển hình nên giao cho chuyên gia:

- **Explorer** — trinh sát multi-file: "file nào chạm tới auth, ai gọi ai".
- **Tester** — sau mỗi thay đổi, chạy test focused và báo PASS/FAIL.
- **Security-reviewer** — khi diff chạm auth/payment, soi rủi ro trước khi merge.

**Nếu làm sai thì sao?** Hai lỗi hay gặp: (1) mô tả agent thiếu phạm vi → nó "chạy loạn" ngoài vùng được phép; (2) gọi sai chuyên gia cho việc, ví dụ nhờ tester đi trinh sát → kết quả không đúng thứ bạn cần.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** việc ồn ào cần cô lập (trinh sát multi-file); muốn chạy test focused sau mỗi change; diff chạm auth/payment cần soi bảo mật.
- **ĐỪNG dùng khi:** việc quá nhỏ hoặc bạn chưa cần tách vai — gọi agent tổng quát trong chat chính là đủ. Custom agent đáng dùng khi việc có "tính chuyên môn" rõ ràng.
- **Cho ai:** người đã tạo custom agent cho team, người cần chạy trinh sát/test song song.

## Cách gọi (copy-paste)

```bash
Gọi agent trong .github/agents/
"nhờ explorer vẽ bản đồ file chạm tới auth"
# Kỳ vọng: sub-agent trả kết quả gọn, chat chính không bị ồn
# Verify: kết quả paste được vào PR/wiki
```

> Không thấy agent trong danh sách? Kiểm tra `.github/agents/` có file `.agent.md` tương ứng chưa — danh bạ trống thì không có gì để gọi.

## Ví dụ thật

Nghiệp vụ: bạn sắp refactor module auth, cần biết có những file nào dính tới nó trước khi sửa.

```bash
# Gọi explorer (chỉ-đọc) để trinh sát, không đụng code
"nhờ explorer (chỉ-đọc): vẽ bản đồ 5 file chạm tới auth + ai gọi ai,
kèm file nào có test và file nào không"
# Verify: sub-agent chỉ đọc; kết quả dán được vào mô tả PR hoặc wiki team
```

**Kết quả mong đợi:** Một bản đồ gọn (danh sách file + quan hệ gọi nhau + test có/không); chat chính chỉ giữ lại quyết định refactor.

**✅ Verify:** Kết quả của sub-agent dán thẳng được vào PR/wiki là đạt — nếu phải viết lại từ đầu thì nó chưa trả đúng thứ cần.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — gọi explorer mà không nói nó chỉ-đọc:**

```bash
"nhờ explorer dọn lại code auth"
# -> bạn giao việc sửa cho một agent vốn sinh ra để trinh sát
```

**✅ ĐÚNG — nêu rõ vai + phạm vi ngay trong lời gọi:**

```bash
"nhờ explorer (chỉ-đọc): liệt kê file chạm tới auth và quan hệ gọi nhau, không sửa gì"
```

**Bài học:** Custom agent mạnh vì quyền hẹp. Nêu rõ phạm vi trong lời gọi để nó làm đúng vai — sai vai thì chuyên gia thành rủi ro.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Agent "chạy loạn" ngoài phạm vi | Mô tả agent thiếu phạm vi | Ghi rõ chỉ-đọc + files được đụng trong `.agent.md` |
| Gọi sai agent cho việc | Chưa thuộc danh bạ | Đọc `templates/.github/agents/` 1 lần, ghi nhớ 3 con core |
| Chat chính vẫn ồn | Ôm việc trong chat chính | Đẩy việc ồn sang sub-agent ngay |

## So sánh với Claude Code

| Việc | Copilot (Custom agent) | Claude Code | Ghi chú |
|---|---|---|---|
| Agent riêng của repo | `.github/agents/<tên>.agent.md` | Subagent trong `.claude/agents/` | Cùng ý tưởng: persona + tool giới hạn |
| Giới hạn công cụ/quyền | Khai trong frontmatter agent | Khai trong định nghĩa subagent | Cả hai đều cho phép thu hẹp quyền theo vai |
| Đẩy việc ồn sang nhánh phụ | Gọi sub-agent theo tên | Gọi subagent | Cùng mục đích: giữ mạch chính sạch |

## Best practices (kèm "vì sao")

- **Ghi rõ phạm vi trong chính file `.agent.md`.** *Vì sao?* Phạm vi nằm ở định nghĩa thì mọi lời gọi đều được bảo vệ, không phụ thuộc bạn nhớ nhắc.
- **Thuộc 3 agent core trước khi tạo thêm.** *Vì sao?* Danh bạ quá dài thì chính bạn cũng gọi sai — ít mà đúng vai hơn nhiều mà mơ hồ.
- **Đẩy việc ồn sang sub-agent ngay từ đầu.** *Vì sao?* Để nó chạy trong chat chính thì kết quả trinh sát sẽ loãng mất các quyết định bạn cần giữ.
- **Dùng explorer cho chỉ-đọc, tester cho PASS/FAIL.** *Vì sao?* Đúng vai thì kết quả đồng nhất và dán được thẳng vào PR/wiki.

## Bài tập nhỏ

1. **(5 phút)** Gọi explorer vẽ bản đồ file của một module bạn chưa quen, rồi thử dán kết quả vào phần mô tả một PR nháp.
2. **(5 phút)** Gọi tester chạy test focused sau một thay đổi nhỏ; ghi lại số test PASS/FAIL và so với việc bạn tự chạy.
3. **(7 phút)** Cố tình gọi explorer với một việc sửa (không nói chỉ-đọc) và quan sát phản ứng; rồi gọi lại đúng vai để thấy khác biệt.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Model & Agent.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Tạo agent riêng: [../../../06-custom-agents-parallel.md](../../../06-custom-agents-parallel.md). Task mở cần agent tự do: [../agent-mode/README.md](../agent-mode/README.md).

> Đẩy việc ồn ào sang sub-agent là cách giữ chat chính sạch — chuyên gia trả kết quả, còn bạn giữ quyết định.
