# /status — Xem trạng thái Copilot

> **Dành cho:** mọi người, nhất là đầu session mới · **Vấn đề:** lệnh vắng mặt / báo lỗi, dễ đổ oan cho AI trong khi lỗi nằm ở plan hay scope · **Đọc xong:** đọc được active/account/plan/model trong 30 giây (~2 phút)

## 1 câu nôm na

`/status` giống như liếc đồng hồ xe trước khi lên đường: xăng còn không, đèn báo có sáng cái nào không. Lệnh này cho bạn xem Copilot đang ở trạng thái nào — có active không, đang đăng nhập account nào, plan gì, model nào, và MCP overview ra sao. Mỗi repo mới chỉ cần chạy một lần là đủ.

## Vì sao dùng /status?

Vì phần lớn cảm giác "Copilot hỏng" thực ra là lỗi cấu hình: một lệnh `/...` biến mất vì plan không có, hoặc bạn đang ở nhầm account. Chạy `/status` tốn 30 giây nhưng tiết kiệm hàng chục phút debug sai chỗ.

**Nếu làm sai thì sao?** Bỏ qua bước này, bạn dễ đổ lỗi cho AI trong khi vấn đề là plan/scope/policy. Ngược lại, đọc `/status` xong mà vẫn không hiểu thì thường là do thiếu checklist — xem mục lỗi thường gặp bên dưới.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** session đầu trên một repo (làm 1 lần/repo); khi một lệnh `/...` không thấy xuất hiện; trước khi kết luận "Copilot hỏng".
- **Cho ai:** mọi người — đặc biệt người mới.
- **ĐỪNG thay bằng:** hỏi trạng thái qua prompt thường hay `@workspace` — `/status` sinh ra đúng cho việc này, trả lời nhanh và chuẩn hơn.

## Cách gọi (copy-paste)

```bash
/status
# Kỳ vọng: thấy active/account/plan/model/MCP overview trong 30 giây
# Verify: nói được "plan X, model Y, login Z"
```

> Gõ `/` trong ô Chat để kiểm tra `/status` có trong list không. Không thấy thì xem plan/model trước khi kết luận là bug công cụ.

## Ví dụ thật

Nghiệp vụ: bạn mới clone repo, gõ `/fix` mà không thấy lệnh đâu — cần biết máy mình đang ở đâu.

```bash
# 1. Chạy:
/status
# 2. Đọc kết quả, tự trả lời 3 câu:
#    "plan gì? model nào? login account nào?"
# 3. Nếu lệnh vắng mặt: đối chiếu plan + danh sách `/`
```

**Kết quả mong đợi:** Thấy active/account/plan/model và MCP overview; bạn biết chính xác máy đang ở plan/model/account nào.

**✅ Verify:** Nói lại được "plan X, model Y, login Z" là đạt. Không nói được nghĩa là bạn chưa đọc hết kết quả.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

❌ SAI: "`/fix` không có → Copilot hỏng." (chưa xem plan và cơ chế gating)

✅ ĐÚNG: Chạy `/status` → thấy plan/model → nếu lệnh bị gate bởi plan thì đó chính là lý do, không phải bug.

**Bài học:** trạng thái là dữ kiện, đừng đoán. 30 giây `/status` thay cho cả buổi cãi nhau với AI.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Đọc /status vẫn không hiểu | Thiếu checklist | Theo checklist 30s: plan → quota → list `/` → update extension |
| Status ok mà vẫn lỗi | Lỗi nằm ở scope/policy | Kiểm tra scope (`#file`) + policy org |
| Quên check đầu session | Vào là hỏi ngay | `/status` → `/instructions` → `/mcp` mỗi repo mới |

## So sánh với Claude Code

| Việc | Copilot (`/status`) | Claude Code | Ghi chú |
|---|---|---|---|
| Xem trạng thái/plan/model | Slash `/status` trong Chat | Không có slash tương đương; xem qua `/help`, `/config`, biến môi trường | Cùng mục đích "biết mình đang ở đâu", khác cách gọi |
| Kiểm tra MCP | `/status` hiện MCP overview | `/mcp` hoặc xem config MCP | Copilot gộp vào status, Claude tách riêng |
| Kiểm chứng | Bạn đọc và tự nói lại plan/model | Bạn tự kiểm | Không agent nào tự chịu trách nhiệm đúng/sai |

## Best practices (kèm "vì sao")

- **Chạy `/status` một lần mỗi repo mới.** *Vì sao?* Trạng thái có thể khác theo workspace (plan/model/MCP) — biết trước để không đoán sai.
- **Không thấy một lệnh nào đó thì chạy `/status` trước khi báo bug.** *Vì sao?* Nhiều lệnh bị gate bởi plan/model; đó là hành vi đúng, không phải lỗi.
- **Đọc kết quả thành một câu "plan X, model Y, login Z".** *Vì sao?* Nói lại được mới chứng minh bạn đã hiểu, không chỉ nhìn lướt.

## Bài tập nhỏ

1. **(3 phút)** Chạy `/status` trong repo hiện tại, viết ra 3 dòng: plan – model – account.
2. **(10 phút)** Cố tình chọn một lệnh `/` không có trong list, chạy `/status` để giải thích vì sao nó vắng mặt.

## Tham khảo

- Index nhóm: [../README.md](../README.md).
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Đăng nhập/đăng xuất liên quan: [../login/README.md](../login/README.md) và [../logout/README.md](../logout/README.md).

> Chốt: `/status` không sửa được gì cả — và đó chính là điểm mạnh: 30 giây để biết mình đang đứng ở đâu trước khi đổ lỗi cho AI.
