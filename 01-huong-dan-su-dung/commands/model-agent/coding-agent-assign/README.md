# Coding agent assign — Giao issue cho agent cloud chạy async

> Loại Cloud · Agent · Nhóm Nhóm Model & Agent · Nguy hiểm Trung bình (agent tạo branch/PR tự động — review trước khi merge)

`Coding agent assign` `Coding agent assign` gán một GitHub issue cho coding agent chạy nền trên cloud: nó đọc repo, tạo branch, mở PR. Bạn review PR như review đồng nghiệp. Dùng đúng lúc giúp gắn scope, model và tools ngay từ turn 1 — rẻ hơn 3–5 turns làm rõ bằng prompt tự nhiên.

---

## 1. Cú pháp & tham số

| Cú pháp | Tham số | Ý nghĩa |
|---|---|---|
| `Coding agent assign` | _(không có)_ | Chạy với context hiện tại (selection/chat mở) |
| `Coding agent assign <mô tả>` | text tự do sau lệnh | Chạy kèm yêu cầu cụ thể trong 1 bước |
| `Coding agent assign --help` / gõ `/` trong input | _(tra cứu)_ | Xem lệnh có khả dụng ở plan/model của bạn không |

Ví dụ gọi từng dạng:

```bash
# Dạng 1: gọi trần với context hiện tại
Coding agent assign
```

```bash
# Dạng 2: gọi kèm yêu cầu rõ ràng (khuyên dùng)
Coding agent assign giao issue #123 cho coding agent xử lý
```

```bash
# Dạng 3: kiểm tra khả dụng trước khi dùng (plan gating)
# Gõ / trong Chat input -> tìm Coding agent assign trong list
# Không thấy -> xem mục 4 (plan gating) thay vì kết luận bug
```

Không có flag `--size`, `--ratio` phức tạp. Tham số là text tự do — càng nêu file + mong đợi càng chính xác.

---

## 2. Cách nó hoạt động

### Cơ chế sâu: 5 bước khi bạn Enter `Coding agent assign`

1. **Thu thập context:** Chat gom selection, file mở, instructions repo, history ngắn và (nếu có) MCP/tools đang bật.
2. **Đóng scope:** lệnh này khóa phạm vi xử lý (file/selection/session hiện tại) thay vì để model đoán mò toàn repo.
3. **Gọi model hiện tại:** prompt + context được gửi tới model bạn đã chọn trong `/model` (đổi bằng `/model` khi cần não to hơn).
4. **Trả diff/text có kiểm chứng:** kết quả hiện dưới dạng diff duyệt từng hunk hoặc text có cấu trúc — bạn luôn là người duyệt cuối.
5. **Giữ nguyên đĩa cho tới khi duyệt:** không file nào đổi cho tới khi bạn Accept/Apply; `git diff` luôn soi được trước/sau.

```text
[Chat input: Coding agent assign + mô tả] --> [gom context + scope] --> [model xử lý]
        |                              |                        |
   selection/file                 instructions + MCP        diff/text chờ duyệt
```

### Khác gì với lệnh dễ nhầm?

| Lệnh | Kết quả | Mất gì / Đổi gì | Khi nào dùng |
|---|---|---|---|
| `Coding agent assign` | Giao issue cho Copilot coding agent xử lý async | Theo bảng rủi ro mục 4 | Task khớp mô tả 1 dòng ở trên |
| Lệnh anh em gần nhất trong nhóm | Scope/quyền khác 1 nấc | Đọc kỹ cột Ý nghĩa | Khi `Coding agent assign` trả kết quả sai scope |
| Prompt tự nhiên không lệnh | Linh hoạt nhưng tốn turns | Tốn 3–5 turns làm rõ | Khi việc quá lạ, chưa có lệnh nào khớp |
| Agent mode tự hành | Tự tìm file + chạy lệnh | Tốn quota, rủi ro cao hơn | Khi task mở, chưa biết chạm file nào |

> Kinh nghiệm xương máu: _lệnh càng ngắn càng phải gắn scope rõ._ `Coding agent assign` không scope = model đoán mò = sửa sai file.

---

## 3. Ví dụ thực tế

### Kịch bản 1: dùng chuẩn trong task hàng ngày

Bạn đang làm task thật trong repo, đã mở đúng file và bôi đen đúng đoạn cần xử lý.

```bash
# Bước 1: chuẩn bị scope (bôi đen code hoặc mở đúng file)
# Bước 2: gọi lệnh kèm yêu cầu rõ
Coding agent assign giao issue #123 cho coding agent xử lý

# Bước 3: review diff từng hunk rồi mới Accept
# Bước 4: chạy kiểm chứng (test/build/lint) xác nhận
```

> Kết quả: xong việc trong 1–2 turns thay vì 5 turns hỏi-đáp lòng vòng, diff gọn dễ review.

### Kịch bản 2: kết hợp kiểm tra chéo (không tin 100%)

Bạn nghi kết quả `Coding agent assign` có thể thiếu context (docs cũ, file chưa gắn, model rẻ quá).

```bash
# Bước 1: chạy lệnh lần 1 với model hiện tại
Coding agent assign coding agent đang làm những issues nào

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

- `Coding agent assign` tốn 1 lượt gọi model với context hiện tại. Gắn scope gọn (1 file/selection) rẻ hơn gắn cả repo 10–50 lần.
- Bài toán hòa vốn: gắn scope đúng từ turn 1 = tiết kiệm 3–5 turns làm rõ (~vài nghìn tokens mỗi turn).
- Model rẻ cho việc nhẹ (`/explain`, `/doc`, review), model mạnh chỉ cho agent/kiến trúc khó.

### Plan / model gating (vì sao lệnh vắng mặt?)

- Không thấy `Coding agent assign` trong list `/` → check `/status` + plan trước khi kết luận lệnh không tồn tại.
- Individual < Business < Enterprise (mở dần). Coding agent + một số participants có thể vắng ở plan thấp.
- BYOK (Enterprise): list model khác Individual. Hỏi admin khi model bạn cần không hiện.
- Checklist 30 giây: `/status` → `github.com/settings/copilot` (plan + quota) → gõ `/` xem list thực tế → `/update` nếu extension cũ.

---

## 5. Kết hợp trong workflow

| Combo | Cách dùng |
|---|---|
| `/status` → `Coding agent assign` | Biết account/model trước khi làm gì khác |
| `Coding agent assign` + `#file` / `#selection` | Mọi prompt code phải có scope gắn kèm |
| `Coding agent assign` → review diff → test | Không Accept mù, luôn chạy kiểm chứng |
| `Coding agent assign` → `/model` đổi + chạy lại | So sánh chất lượng rẻ vs mạnh |
| `Coding agent assign` → `/export` | Lưu lại case hay cho team wiki |

Anti-pattern:

```bash
# SAI: gọi lệnh không scope, mô tả chung chung
Coding agent assign
# -> model đoán mò, sửa sai file, tốn turns sửa lại

# ĐÚNG: scope + yêu cầu + tiêu chí xong
# (bôi đen code trước, rồi:)
Coding agent assign giao issue #123 cho coding agent xử lý
```

---

## 6. Lỗi hay gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Gõ `Coding agent assign` không có gì xảy ra | Chưa có scope (chưa chọn code/mở file) hoặc lệnh bị gating | Bôi đen code trước; gõ `/` kiểm tra lệnh có trong list không |
| Kết quả chung chung, sai file | Thiếu `#file`/`@workspace`, model đoán scope | Gắn scope rõ rồi chạy lại |
| Lệnh vắng mặt trong list `/` | Plan/model gating hoặc extension cũ | `/status` → check plan → `/update` |
| Kết quả tốt nhưng diff khó duyệt | Change quá to 1 lần | Chia nhỏ yêu cầu, duyệt từng hunk |
| Model mạnh tốn quota nhanh | Dùng model đắt cho việc nhẹ | Việc nhẹ dùng model rẻ; mạnh để dành agent/kiến trúc |
| Tin 100% không review | Lười đọc diff/message | Luôn đọc + sửa tay trước khi commit/push/merge |

---

## 7. Tham khảo

- Lệnh liên quan (cùng nhóm `model-agent`):
  - Xem index nhóm: [../README.md](../README.md) — bảng tra cứu 1 dòng mỗi lệnh
  - Bài tổng quan: [../../../04-chat-commands-toan-tap.md](../../../04-chat-commands-toan-tap.md) — index ~70 lệnh 4 nhóm
- Session đầu chuẩn (làm 1 lần/repo): `/status` → `/instructions` → `/mcp` → custom agent → `/policy`
- Khi lệnh vắng mặt: `/status` → check plan tại `github.com/settings/copilot` → gõ `/` xem list thực tế

> Mẹo 1 dòng: _giao issue cho Copilot coding agent xử lý async — gắn scope trước, review diff sau, đừng bao giờ Accept mù._
