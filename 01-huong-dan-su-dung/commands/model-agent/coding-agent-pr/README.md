# Coding agent PR — Flow issue → branch → PR → review

> **Dành cho:** người review PR do coding agent mở · **Đọc xong:** đi đúng flow issue → branch → PR → review → merge/revert, không merge mù (~2 phút)

## 1 câu nôm na

Băng chuyền từ phiếu việc tới thùng hàng, mỗi chặng đều có người kiểm. PR do agent mở cũng đi qua đủ chặng: mở PR → đọc tóm tắt + CI → review diff → merge hoặc revert; PR quá to thì tách nhỏ.

Điểm cần nhớ: agent mở PR chứ không quyết định thay bạn. Tóm tắt của nó chỉ là gợi ý đọc nhanh, không phải bằng chứng đúng.

## Vì sao dùng flow này?

Vì một PR của agent vẫn là thay đổi thật sắp vào codebase. Bỏ qua chặng review vì "bot làm chắc đúng" là cách nhanh nhất để mang bug vào repo mà không ai biết.

Flow gọn gồm 4 chặng, mỗi chặng là một cơ hội bắt lỗi:

- **Mở PR:** kiểm branch, xem nó nhắm đúng base.
- **Đọc tóm tắt + CI:** CI đỏ thì chưa được merge, không có ngoại lệ.
- **Review diff:** đọc thay đổi thật, không chỉ đọc tóm tắt.
- **Merge / revert:** merge thì theo dõi staging; sai thì revert gọn.

**Nếu làm sai thì sao?** Merge mù theo tóm tắt, hoặc merge khi CI đỏ, đều dẫn tới cùng kết cục: sự cố trên môi trường thật. Có PR quá to không review nổi thì đừng cố — tách nhỏ rồi review.

## Khi nào dùng / khi nào đừng

- **Dùng khi:** review PR do coding agent mở; tóm tắt diff thành mô tả PR; quyết định merge/revert PR agent.
- **ĐỪNG dùng khi:** bạn đang cần *viết* code chứ không phải review — lúc đó giao issue ([coding agent assign](../coding-agent-assign/README.md)) hoặc dùng Agent mode.
- **Cho ai:** người phê duyệt PR, người nhận việc từ coding agent.

## Cách gọi (copy-paste)

```bash
Mở PR agent → đọc tóm tắt + CI → review diff → merge/revert
# Kỳ vọng: merge xong staging chạy ổn, không nợ review
# Verify: staging xanh sau merge; revert gọn nếu sai
```

> PR chưa có CI xanh? Đừng merge. Comment yêu cầu agent bổ sung/sửa rồi để CI chạy lại.

## Ví dụ thật

Nghiệp vụ: agent mở PR "rate-limit" từ issue #142. Bạn là người review nó.

```bash
# 1. Mở PR agent "rate-limit": kiểm branch + CI
# 2. Đọc diff, thấy thiếu case biên
Comment: "thiếu test cho nhánh IP vượt ngưỡng 5 lần/phút, bổ sung giúp"
# 3. Agent bổ sung -> CI xanh lại
# 4. Review lần cuối -> merge; theo dõi staging sau merge
```

**Kết quả mong đợi:** PR có tóm tắt rõ + CI xanh + một lượt review của người; merge sạch, hoặc revert gọn nếu có vấn đề.

**✅ Verify:** Sau merge, staging chạy ổn và không còn PR treo chờ review là đạt.

## Nếu làm sai thì sao (❌ SAI / ✅ ĐÚNG)

**❌ SAI — tin tóm tắt rồi merge khi CI còn đỏ:**

```bash
# "Bot ghi đã thêm rate-limit, CI đỏ chắc do flaky" -> merge
# -> bug lọt lên staging
```

**✅ ĐÚNG — CI xanh trước, đọc diff trước, rồi mới merge:**

```bash
# CI đỏ -> Comment yêu cầu agent sửa -> CI xanh lại
# Đọc diff -> thấy ổn -> merge -> theo dõi staging
```

**Bài học:** Tóm tắt của agent giúp bạn đọc nhanh, không thay bạn đọc diff. CI đỏ là cửa chặn, không phải phiền toái.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Merge mù PR agent | Tin 100% tóm tắt | Đọc diff + CI, chạy thử staging trước merge |
| CI đỏ vẫn merge | Bỏ qua CI | Đỏ → bắt agent fix, xanh mới merge |
| PR quá to khó review | Issue ôm đồm | Giữ PR nhỏ; to quá → tách |

## So sánh với Claude Code

| Việc | Copilot (coding agent PR) | Claude Code | Ghi chú |
|---|---|---|---|
| Tạo PR | Agent mở PR trên GitHub sau khi xong issue | Bạn/agent tạo PR qua `gh` sau phiên làm việc | Cả hai đều ra PR chuẩn để review |
| Nguồn thay đổi | Từ issue được assign | Từ phiên làm việc bạn chạy | Khác nguồn, cùng đích: PR cần người duyệt |
| Trách nhiệm đúng/sai | Người review + CI quyết định | Người review + CI quyết định | Không agent nào tự chịu trách nhiệm merge |

## Best practices (kèm "vì sao")

- **CI phải xanh trước khi merge.** *Vì sao?* Đây là bằng chứng khách quan duy nhất rằng thay đổi không phá gì.
- **Đọc diff, không chỉ đọc tóm tắt.** *Vì sao?* Tóm tắt do agent viết và luôn "có vẻ đúng" — diff mới là sự thật.
- **Giữ PR nhỏ.** *Vì sao?* PR nhỏ thì review kỹ được; PR lớn khiến người ta duyệt cho xong.
- **Biết đường revert trước khi merge.** *Vì sao?* Chuẩn bị sẵn cách lùi giúp bạn dám merge nhanh mà không lo sự cố kéo dài.

## Bài tập nhỏ

1. **(5 phút)** Mở một PR (bất kỳ) và tự trả lời 4 câu: branch đúng base chưa, CI xanh chưa, diff có gì, revert thế nào.
2. **(5 phút)** Thử viết một comment review cho agent yêu cầu bổ sung test cho một nhánh biên, rồi theo dõi nó phản hồi.
3. **(7 phút)** Lấy một PR quá to, thử thảo luận cách tách nó thành 2–3 PR nhỏ hơn và ghi lý do.

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh Model & Agent.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).
- Bước trước khi có PR: [../coding-agent-assign/README.md](../coding-agent-assign/README.md).

> PR của agent cũng là PR — đọc diff và CI trước khi bấm merge, đừng để phần tóm tắt quyết định thay bạn.
