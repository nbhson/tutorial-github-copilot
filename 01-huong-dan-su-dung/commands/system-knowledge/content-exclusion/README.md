# Content exclusion — Xem files Copilot không được đọc

> **Dành cho:** người có secrets/keys trong repo và admin đặt policy · **Vấn đề:** không biết file nào bị cấm đọc, tưởng bug khi mất gợi ý · **Đọc xong:** xem và kiểm tra đúng danh sách exclusion (~2 phút)

## 1 câu nôm na

Content exclusion là **két sắt** của repo: bạn bỏ file nhạy cảm vào, Copilot không được mở. Khi một chỗ “tự nhiên không có gợi ý”, câu hỏi đầu tiên nên là “file này có nằm trong exclusion không?” — thay vì “Copilot bị lỗi”.

## Content exclusion làm gì (và vì sao bạn cần biết)?

Nó là danh sách path mà Copilot bị cấm đọc/index — thường là `.env`, `*.pem`, `secrets/**`. Với dev, biết danh sách này giúp phân biệt “bị cấm đọc” (đúng ý đồ) với “bug” (sai). Với admin, đây là tầng bảo vệ đầu tiên: phải đặt trước khi bật indexing, nếu không secret sẽ lọt vào index.

**Nếu làm sai thì sao?** Sai theo hai chiều: (1) quên cấu hình → agent đọc `.env` lúc debug, secret vào transcript; (2) glob quá rộng → cả `src/` bị chặn, retrieval rỗng mà không ai hiểu vì sao.

## Khi nào dùng / khi nào đừng

- **Dùng (kiểm tra) khi:** repo có secrets/keys; gặp hiện tượng “chỗ có chỗ không gợi ý”; đang làm audit bảo mật.
- **ĐỪNG nhầm khi:** bạn muốn siết quyền chạy lệnh (đó là policy/tool approval chứ không phải exclusion); hay chỉ tò mò vì sao một file không gợi ý nhưng file đó thực ra chẳng nhạy cảm gì.

> Hai mức cấu hình exclusion:

| Mức | Đặt ở đâu | Khi nào dùng |
|---|---|---|
| Local (máy bạn) | `settings.json` → `github.copilot.chat.exclusion` | Chỉnh nhanh cho repo cá nhân, org chưa set policy |
| Org policy (admin) | Org settings → Content exclusion | Chuẩn chung cả org; đè setting local |

## Cách gọi (copy-paste)

```jsonc
// settings.json — mức local
{
  "github.copilot.chat.exclusion": ["**/.env*", "**/*.pem", "secrets/**"]
}
```

```text
# Hoặc (admin): github.com → Org/Repo Settings → Copilot → Content exclusion → Add
# Kỳ vọng: file nhạy cảm bị loại khỏi context, chỗ khác vẫn gợi ý bình thường
# Verify: test file thường CÓ gợi ý + file secrets KHÔNG — đúng cả hai
```

> Không thấy mục Content exclusion trong settings? Có thể bạn đang ở plan Individual — khi đó không có org policy để set.

## Ví dụ thật

Nghiệp vụ: `secrets/prod.json` chứa key thật, và bạn để ý Copilot không gợi ý gì khi mở file đó — cần xác nhận đó là chủ ý chứ không phải lỗi.

```bash
# 1. Kiểm exclusion:
#    settings.json → github.copilot.chat.exclusion
#    (hoặc Org Settings nếu đây là policy)
#    → thấy "secrets/**" nằm trong danh sách.

# 2. Đối chứng 2 file:
#    - mở src/utils/format.ts  → Copilot CÓ gợi ý  (bình thường)
#    - mở secrets/prod.json    → Copilot KHÔNG gợi ý (đúng ý đồ)

# 3. Xác nhận thêm bằng một câu hỏi có scope:
"@workspace có thấy file secrets/prod.json không?"
# → trả "không thấy / excluded" nghĩa là exclusion đang sống.
```

**Kết quả mong đợi:** file nhạy cảm bị loại khỏi context; chỗ khác vẫn gợi ý bình thường.

**✅ Verify:** test file thường có gợi ý + file secrets không — đúng cả hai là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — glob quá rộng, chặn nhầm cả code:**

```jsonc
"secrets": ["**/*"]   // chặn hết → Copilot gần như không hoạt động, tưởng hỏng.
```

**✅ ĐÚNG — glob hẹp, đúng thứ cần chặn:**

```jsonc
["**/.env*", "**/*.pem", "secrets/**"]   // chỉ chặn file nhạy cảm
```

**Bài học:** exclusion chặn **nhầm chỗ** cũng tệ như bỏ sót — glob phải hẹp và được test bằng cả file có lẫn không nhạy cảm.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Tưởng bug khi mất gợi ý 1 chỗ | Không biết exclusion | So file lỗi vs file test để khoanh vùng |
| Exclusion sai glob | Pattern quá rộng | Thu hẹp glob, test lại từng path |
| Policy org đè local | Sửa local không ăn | Hỏi admin policy org |

## So sánh với Claude Code

| Việc | Copilot (Content exclusion) | Claude Code | Ghi chú |
|---|---|---|---|
| Chặn file nhạy cảm khỏi AI | Có — cấu hình server-side (org/repo, Business/Enterprise) + setting local | Không có tương đương cấp org; giới hạn qua quyền/ignore trong repo | Copilot chặn *trước khi index*; Claude Code chặn ở phía truy cập |
| Cấu hình ở đâu | `settings.json` (local) hoặc Org Settings (admin) | Quyền/ignore trong repo | Khác mô hình quản trị |

## Best practices (kèm "vì sao")

- **Cấu hình exclusion TRƯỚC khi bật index.** *Vì sao?* Index là một ảnh chụp; để `.env`/private key lọt vào rồi mới nghĩ tới exclusion là đã quá muộn.
- **Glob hẹp, test bằng cả file có/không nhạy cảm.** *Vì sao?* Tránh chặn nhầm code — chặn nhầm gây hậu quả y như bỏ sót.
- **Ghi exclusion vào tài liệu team.** *Vì sao?* Để không ai tưởng “mất gợi ý” là bug rồi mất thời gian debug oan.
- **Khi mất gợi ý ở một chỗ, nghi exclusion trước.** *Vì sao?* Đây là nguyên nhân cục bộ phổ biến nhất, kiểm nhanh hơn điều tra model.
- **Đã có policy org thì đừng tự sửa local.** *Vì sao?* Policy org đè local, sửa local chỉ tốn công mà không đổi được gì.

## Bài tập nhỏ

1. **(5 phút)** Mở `settings.json` và kiểm xem có `github.copilot.chat.exclusion` chưa; ghi lại danh sách hiện có.
2. **(10 phút)** Thêm `**/*.pem` vào exclusion, rồi test 1 file `.pem` (không gợi ý) và 1 file `.ts` (vẫn gợi ý).
3. **(10 phút)** Hỏi `@workspace` về một chuỗi nằm trong file bị exclude để tự xác nhận nó thật sự không đọc được.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh System & Knowledge.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Exclusion là tầng 1 của phòng thủ nhiều lớp: [bài 15 — Security stack 5 tầng](../../../15-security-stack-5-tang.md).

> **Chốt:** content exclusion không phải để “giấu cho vui” — nó là két sắt bạn khoá *trước* khi bật index; nhớ test cả hai chiều để biết nó đang chặn đúng chỗ.
