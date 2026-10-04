# /optimize — Tối ưu perf có đo đạc, không tối ưu mù

> Loại Slash · Code · Nhóm Nhóm Code Actions · Nguy hiểm Trung bình (đổi perf có thể đổi behavior — đo trước/sau)

`/optimize` `/optimize` phân tích và đề xuất tối ưu perf cho selection: độ phức tạp, N+1 query, re-render. Luôn benchmark trước/sau, không tối ưu mù. Dùng đúng lúc giúp gắn scope, model và tools ngay từ turn 1 — rẻ hơn 3–5 turns làm rõ bằng prompt tự nhiên.

---

## 1. Cú pháp & tham số

| Cú pháp | Tham số | Ý nghĩa |
|---|---|---|
| `/optimize` | _(không có)_ | Chạy với context hiện tại (selection/chat mở) |
| `/optimize <mô tả>` | text tự do sau lệnh | Chạy kèm yêu cầu cụ thể trong 1 bước |
| `/optimize --help` / gõ `/` trong input | _(tra cứu)_ | Xem lệnh có khả dụng ở plan/model của bạn không |

Ví dụ gọi từng dạng:

```bash
# Dạng 1: gọi trần với context hiện tại
/optimize
```

```bash
# Dạng 2: gọi kèm yêu cầu rõ ràng (khuyên dùng)
/optimize tối ưu vòng lặp này, đang O(n^2), mục tiêu O(n)
```

```bash
# Dạng 3: kiểm tra khả dụng trước khi dùng (plan gating)
# Gõ / trong Chat input -> tìm /optimize trong list
# Không thấy -> xem mục 4 (plan gating) thay vì kết luận bug
```

Không có flag `--size`, `--ratio` phức tạp. Tham số là text tự do — càng nêu file + mong đợi càng chính xác.

---

## 2. Cách nó hoạt động

### Cơ chế sâu: 5 bước khi bạn Enter `/optimize`

1. **Thu thập context:** Chat gom selection, file mở, instructions repo, history ngắn và (nếu có) MCP/tools đang bật.
2. **Đóng scope:** lệnh này khóa phạm vi xử lý (file/selection/session hiện tại) thay vì để model đoán mò toàn repo.
3. **Gọi model hiện tại:** prompt + context được gửi tới model bạn đã chọn trong `/model` (đổi bằng `/model` khi cần não to hơn).
4. **Trả diff/text có kiểm chứng:** kết quả hiện dưới dạng diff duyệt từng hunk hoặc text có cấu trúc — bạn luôn là người duyệt cuối.
5. **Giữ nguyên đĩa cho tới khi duyệt:** không file nào đổi cho tới khi bạn Accept/Apply; `git diff` luôn soi được trước/sau.

```text
[Chat input: /optimize + mô tả] --> [gom context + scope] --> [model xử lý]
        |                              |                        |
   selection/file                 instructions + MCP        diff/text chờ duyệt
```

### Khác gì với lệnh dễ nhầm?

| Lệnh | Kết quả | Mất gì / Đổi gì | Khi nào dùng |
|---|---|---|---|
| `/optimize` | Đề xuất tối ưu perf cho đoạn code đang chọn | Theo bảng rủi ro mục 4 | Task khớp mô tả 1 dòng ở trên |
| Lệnh anh em gần nhất trong nhóm | Scope/quyền khác 1 nấc | Đọc kỹ cột Ý nghĩa | Khi `/optimize` trả kết quả sai scope |
| Prompt tự nhiên không lệnh | Linh hoạt nhưng tốn turns | Tốn 3–5 turns làm rõ | Khi việc quá lạ, chưa có lệnh nào khớp |
| Agent mode tự hành | Tự tìm file + chạy lệnh | Tốn quota, rủi ro cao hơn | Khi task mở, chưa biết chạm file nào |

> Kinh nghiệm xương máu: _lệnh càng ngắn càng phải gắn scope rõ._ `/optimize` không scope = model đoán mò = sửa sai file.

---

## 3. Ví dụ thực tế

### Kịch bản 1: dùng chuẩn trong task hàng ngày

Bạn đang làm task thật trong repo, đã mở đúng file và bôi đen đúng đoạn cần xử lý.

```bash
# Bước 1: chuẩn bị scope (bôi đen code hoặc mở đúng file)
# Bước 2: gọi lệnh kèm yêu cầu rõ
/optimize tối ưu vòng lặp này, đang O(n^2), mục tiêu O(n)

# Bước 3: review diff từng hunk rồi mới Accept
# Bước 4: chạy kiểm chứng (test/build/lint) xác nhận
```

> Kết quả: xong việc trong 1–2 turns thay vì 5 turns hỏi-đáp lòng vòng, diff gọn dễ review.

### Kịch bản 2: kết hợp kiểm tra chéo (không tin 100%)

Bạn nghi kết quả `/optimize` có thể thiếu context (docs cũ, file chưa gắn, model rẻ quá).

```bash
# Bước 1: chạy lệnh lần 1 với model hiện tại
/optimize giảm N+1 query ở hàm listOrders, đo trước/sau

# Bước 2: đổi chiến thuật khi kết quả chưa đạt
# - Việc khó hơn dự kiến -> /model đổi model mạnh + chạy lại
# - Thiếu file -> gắn thêm #file rồi chạy lại
# - Task mở rộng -> chuyển sang Agent mode làm tiếp
```

> Kết quả: có baseline để so sánh, biết chính xác thiếu gì (model/scope/mode) thay vì kết luận "AI dở".

---

## 4. Rủi ro & lưu ý

### Mất gì? Có cứu được không?

| Mất gì | Cứu được không? | Ghi chú |
|---|---|---|
| History chat khi dùng lệnh session | Không (trong phiên) | `/export` trước khi `/clear` hoặc `/new` nếu cần giữ |
| Edit sai file khi scope lệch | Được (Undo/checkpoint) | Luôn review diff, dùng checkpoints khi sửa nhiều file |
| Secrets lọt vào prompt/export | Khó (đã gửi đi là khó thu hồi) | Soát file trước khi attach/export/share |
| Code trên đĩa, git history | Không mất | `git diff` + `git checkout -- <file>` luôn cứu được |

> **Ảo giác nguy hiểm nhất:** model nói tự tin như thể đã hiểu cả repo, nhưng thực ra chỉ đọc scope bạn gắn. Hãy bắt nó "liệt kê file đã đọc" khi cần chính xác.

### Tốn token?

- `/optimize` tốn 1 lượt gọi model với context hiện tại. Gắn scope gọn (1 file/selection) rẻ hơn gắn cả repo 10–50 lần.
- Bài toán hòa vốn: gắn scope đúng từ turn 1 = tiết kiệm 3–5 turns làm rõ (~vài nghìn tokens mỗi turn).
- Model rẻ cho việc nhẹ (`/explain`, `/doc`, review), model mạnh chỉ cho agent/kiến trúc khó.

### Plan / model gating (vì sao lệnh vắng mặt?)

- Không thấy `/optimize` trong list `/` → check `/status` + plan trước khi kết luận lệnh không tồn tại.
- Individual < Business < Enterprise (mở dần). Coding agent + một số participants có thể vắng ở plan thấp.
- BYOK (Enterprise): list model khác Individual. Hỏi admin khi model bạn cần không hiện.
- Checklist 30 giây: `/status` → `github.com/settings/copilot` (plan + quota) → gõ `/` xem list thực tế → `/update` nếu extension cũ.

---

## 5. Kết hợp trong workflow

| Combo | Cách dùng |
|---|---|
| `/status` → `/optimize` | Biết account/model trước khi làm gì khác |
| `/optimize` + `#file` / `#selection` | Mọi prompt code phải có scope gắn kèm |
| `/optimize` → review diff → test | Không Accept mù, luôn chạy kiểm chứng |
| `/optimize` → `/model` đổi + chạy lại | So sánh chất lượng rẻ vs mạnh |
| `/optimize` → `/export` | Lưu lại case hay cho team wiki |

Anti-pattern:

```bash
# SAI: gọi lệnh không scope, mô tả chung chung
/optimize
# -> model đoán mò, sửa sai file, tốn turns sửa lại

# ĐÚNG: scope + yêu cầu + tiêu chí xong
# (bôi đen code trước, rồi:)
/optimize tối ưu vòng lặp này, đang O(n^2), mục tiêu O(n)
```

---

## 6. Lỗi hay gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Gõ `/optimize` không có gì xảy ra | Chưa có scope (chưa chọn code/mở file) hoặc lệnh bị gating | Bôi đen code trước; gõ `/` kiểm tra lệnh có trong list không |
| Kết quả chung chung, sai file | Thiếu `#file`/`@workspace`, model đoán scope | Gắn scope rõ rồi chạy lại |
| Lệnh vắng mặt trong list `/` | Plan/model gating hoặc extension cũ | `/status` → check plan → `/update` |
| Kết quả tốt nhưng diff khó duyệt | Change quá to 1 lần | Chia nhỏ yêu cầu, duyệt từng hunk |
| Model mạnh tốn quota nhanh | Dùng model đắt cho việc nhẹ | Việc nhẹ dùng model rẻ; mạnh để dành agent/kiến trúc |
| Tin 100% không review | Lười đọc diff/message | Luôn đọc + sửa tay trước khi commit/push/merge |

---

## 7. Tham khảo

- Lệnh liên quan (cùng nhóm `code-actions`):
  - Xem index nhóm: [../README.md](../README.md) — bảng tra cứu 1 dòng mỗi lệnh
  - Bài tổng quan: [../../../04-chat-commands-toan-tap.md](../../../04-chat-commands-toan-tap.md) — index ~70 lệnh 4 nhóm
- Session đầu chuẩn (làm 1 lần/repo): `/status` → `/instructions` → `/mcp` → custom agent → `/policy`
- Khi lệnh vắng mặt: `/status` → check plan tại `github.com/settings/copilot` → gõ `/` xem list thực tế

> Mẹo 1 dòng: _đề xuất tối ưu perf cho đoạn code đang chọn — gắn scope trước, review diff sau, đừng bao giờ Accept mù._
