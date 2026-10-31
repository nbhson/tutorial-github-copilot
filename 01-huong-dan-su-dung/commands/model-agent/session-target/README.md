# Session Target — Chọn harness + nơi agent chạy (Local / Copilot / Cloud)

> **Dành cho:** người muốn agent chạy nền/nhiều phiên hoặc giao hẳn task lên cloud · **Đọc xong:** chọn đúng Local / Copilot / Cloud cho từng việc, biết handoff giữ context (~3 phút)

## 1 câu nôm na

Công tắc chọn "đội thợ + nhà xưởng". **Local** làm ngay trong VS Code, **Copilot** chạy nền trên Agent Host, **Cloud** giao cho "nhà máy ở xa" rồi nhận PR về. Ở đáy khung Chat → **Session Target** → chọn target (Local / Copilot / Cloud / Claude / Codex...).

Điểm hay nhầm nhất: đổi Session Target **không** phải đổi model. Model là "bộ não"; target là "nơi chạy + tay chân thực thi".

## Vì sao dùng Session Target?

Vì cùng một task, chỗ chạy quyết định bạn được gì và mất gì: Local dùng được tool của VS Code/extension, Copilot chạy nền nên mở được nhiều phiên song song, Cloud thì giao hẳn để nhận PR nhưng lại không thấy context local của bạn.

Chọn đúng nơi chạy theo việc:

- Việc tay chân cần tool VS Code / extension / model cấu hình trong VS Code → **Local**.
- Việc coding chạy nền, nhiều phiên song song, mở lại ở cửa sổ khác → **Copilot**.
- Task gọn, giao hẳn để nhận PR cho team review → **Cloud**.
- Đã quen workflow Claude/Codex → chọn harness provider tương ứng.

**Nếu làm sai thì sao?** Muốn chạy nền mà cứ dùng Local thì phải giữ cửa sổ mở; ngược lại, cần tool built-in của VS Code mà lại giao Cloud thì Cloud không thấy context local nên kết quả cụt.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** bạn muốn agent chạy nền, chạy nhiều phiên, hoặc giao hẳn task async để nhận PR; hoặc cần mang một phiên đang làm sang nơi khác (handoff).
- **ĐỪNG dùng khi:** bạn muốn đổi model — việc đó ở model picker, không phải ở thanh Session Target. Và nếu chỉ cần sửa ngay trong editor, cứ ở Local.
- **Cho ai:** người muốn chạy nhiều agent song song, hoặc giao task async nhận PR.

## Cách gọi (copy-paste)

```bash
# VS Code: đáy khung Chat → Session Target → chọn target
# Local / Copilot / Cloud / Claude / Codex... + "Learn about harnesses..."
# Copilot session → /delegate  (đẩy task sang Cloud, mở PR)
# Kỳ vọng: session hiện đúng ở Agent Sessions sidebar; Cloud trả về 1 PR
# Verify: Local sửa ngay trong editor; Cloud xong thì có PR mới trên GitHub
```

> Không thấy `Copilot`/`Cloud` trong list? Thường do chưa đăng nhập GitHub, thiếu extension, hoặc org policy chặn (`ChatEditorPreferCopilotHarness`) — kiểm tra `/status` trước khi kết luận lỗi. Chi tiết: [bài 10 mục 3.3](../../../10-modes-permissions-availability.md).

## Ví dụ thật

Nghiệp vụ: bạn có ba việc khác tính chất và muốn xếp đúng "nhà xưởng" cho từng việc.

```bash
# Local: sửa nhanh, cần test ngay trong editor
"sửa src/auth/login.ts, chạy npm test ngay trong editor"

# Copilot: refactor dài, muốn chạy nền và mở lại ở cửa sổ khác
"refactor module payments + chạy test"   (target: Copilot)

# Cloud: task gọn, giao hẳn để nhận PR cho team review
"thêm endpoint /healthz + test"          → chọn Cloud → agent mở PR
```

**Kết quả mong đợi:** Local sửa ngay trong workspace; Copilot chạy nền + xuất hiện ở Agent Sessions sidebar; Cloud trả về 1 PR trên GitHub.

**✅ Verify:** Session hiện đúng ở Agent Sessions sidebar với đúng target; Cloud xong thì có PR mới là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — đổi target xong tưởng là "chat mới", mất hết ngữ cảnh:**

```bash
# Đang làm ở Local, đổi sang Cloud rồi hỏi lại từ đầu
# -> mất history + context của phiên cũ
```

**✅ ĐÚNG — dùng Handoff để mang context sang target mới:**

```bash
# Từ session Local: Handoff sang target khác -> mang theo history + context
# Hoặc trong session Copilot: /delegate để tiếp tục trên Cloud
```

**Bài học:** Đổi target là đổi nơi chạy, không phải nút "chat mới". Cần giữ ngữ cảnh thì dùng Handoff (chỉ khởi tạo được từ session Local).

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Không thấy Copilot/Cloud trong list | Chưa đăng nhập / thiếu extension / policy | Đăng nhập GitHub, cài extension, hỏi admin xem policy `ChatEditorPreferCopilotHarness` |
| Đổi target xong mất ngữ cảnh | Tưởng là "new chat" | Dùng **Handoff** (chỉ khởi tạo từ session Local) để mang history + context |
| Cloud không thấy tool quen dùng | Cloud dùng tool/model của service | Task cần tool VS Code/extension → ở lại Local/Copilot; giao Cloud task gọn, độc lập |
| Tưởng đổi target = đổi model | Nhầm harness với model | Model đổi ở model picker; target đổi "nơi chạy + tay chân" |

## So sánh với Claude Code

| Việc | Copilot (Session Target) | Claude Code | Ghi chú |
|---|---|---|---|
| Chạy nền / nhiều phiên | Target Copilot trên Agent Host, nhiều phiên song song | Chạy nhiều phiên terminal/IDE | Copilot có sidebar quản lý session tập trung |
| Giao hẳn lên cloud | Target Cloud → nhận PR | Không có target Cloud sẵn — tự dựng container/Actions | Copilot tích hợp cloud + PR thẳng |
| Mang ngữ cảnh khi đổi nơi chạy | Handoff + `/delegate` | Mở phiên mới, tự khôi phục context | Cả hai đều cần chủ động giữ context |

## Best practices (kèm "vì sao")

- **Chọn target theo "cần tay chân gì", không theo thói quen.** *Vì sao?* Việc cần tool extension mà giao Cloud thì kết quả cụt vì Cloud không thấy context local.
- **Dùng Handoff thay vì mở phiên trắng khi đổi nơi chạy.** *Vì sao?* Handoff mang theo history + context, giúp bạn không phải kể lại đầu bài.
- **Giao Cloud cho task gọn, độc lập.** *Vì sao?* Cloud dùng tool/model của service nên hợp task khép kín; task phụ thuộc context local thì để Local/Copilot.
- **Phân biệt rõ model và harness.** *Vì sao?* Đổi model ở picker, đổi nơi chạy ở Session Target — gộp hai thứ này là nguồn của nhiều hiểu nhầm.

## Bài tập nhỏ

1. **(3 phút)** Mở Session Target và liệt kê những target đang khả dụng ở cửa sổ của bạn; note lại cái nào chưa thấy.
2. **(7 phút)** Chạy một task nhỏ ở Local, rồi Handoff sang một target khác và kiểm tra ngữ cảnh còn nguyên không.
3. **(7 phút)** Giao một task gọn (ví dụ thêm endpoint + test) cho Cloud bằng `/delegate`, theo dõi tới khi có PR và tự review nó.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Model & Agent.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Lý thuyết + so sánh harness: [10-modes-permissions-availability.md mục 3.3](../../../10-modes-permissions-availability.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Đổi "bộ não" (khác đổi nơi chạy): [../model-picker/README.md](../model-picker/README.md).

> Local để làm tay, Copilot để chạy nền, Cloud để giao hẳn — chọn đúng "nhà xưởng" quan trọng chẳng kém chọn đúng mô hình.
