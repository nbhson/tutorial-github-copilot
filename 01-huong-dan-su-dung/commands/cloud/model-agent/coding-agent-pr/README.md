# Copilot trên PR — request review, đọc finding, quyết merge

> **Harness:** Copilot in the cloud · **Surface:** GitHub.com (sidebar Reviewers + comments trên PR) — cả Copilot code review lẫn cloud agent đều chạy trên hạ tầng GitHub · **Đọc:** ~2 phút

**Nôm na:** Copilot đứng ở hai chặng của một PR — nó **mở** PR khi bạn assign issue và **review** PR khi bạn bấm Request dưới "Reviewers" (như gọi một đồng nghiệp), nhưng chặng nào cũng cần người duyệt vì băng chuyền không tự ký nhận. Hợp khi cần một lượt soi diff tự động trước khi người đọc, đặc biệt cho PR do cloud agent mở.

## Vì sao dùng?

Vì code review soi diff ngay lúc PR mở, bắt bug/security/style và gắn nhãn severity **High/Medium/Low**, chỗ sửa được thì có suggestion hoặc nút **Fix with Copilot**. Cái hay nhầm to nhất: **mặc định Copilot để lại review loại "Comment"**, không Approve hay Request changes — finding của nó **không** đếm vào required approval, trừ khi org bật approvals.

| Chặng trên PR | Ai làm | Copilot có thay bạn quyết không |
|---|---|---|
| Mở PR từ issue | Copilot cloud agent | Không — PR ở chế độ **draft** |
| Soi diff, gắn nhãn lỗi | Copilot code review (severity High/Medium/Low) | Không — mặc định chỉ là "Comment" |
| Áp dụng fix | Bạn, hoặc **Fix with Copilot** | Một nửa — nó sửa, bạn duyệt commit |
| Merge / revert | Người có quyền | Không bao giờ |

**Nếu làm sai:** trả lời comment của Copilot rồi đợi nó sửa tiếp — comment của bạn **không** được chuyển lại cho Copilot, muốn sửa thì dùng **Fix with Copilot** hoặc push commit rồi re-request; và tóm tắt do agent viết nên luôn "có vẻ đúng", diff + CI mới là bằng chứng.

## Cách dùng

Trên PR, sidebar **Reviewers** → chọn Copilot → bấm **Request** (chọn review effort ngay tại đó trước khi request):

```prompt
Chọn review effort ngay tại ô Reviewers trước khi bấm Request:
  Lite     # bắt lỗi hiển nhiên
  Balanced # mặc định, sâu hơn
  Max      # nhiều model reasoning, cho PR cần soi kỹ
```

- **Biến thể:** muốn nó sửa từng finding thì dùng **Fix with Copilot** → nó mở draft comment → chọn commit vào cùng PR hoặc mở PR mới; rules của repo đặt trong `.github/copilot-instructions.md` (áp cho cả cloud agent lẫn code review).
- **Giới hạn:** Lite ~$0.25, Balanced ~$1.50, Max ~$10 (guideline, theo size PR) + Actions minutes; effort cao trên PR to tiêu nhiều AI credits.
- **✅ Verify:** mọi finding High đã resolve hoặc có lý do ghi rõ; CI xanh rồi mới merge; `git diff` đọc bằng mắt; staging chạy ổn sau merge (coi PR quá to là dấu hiệu phải tách 2–3 PR nhỏ).

## Liên quan

- Chưa có PR mà cần giao việc: [coding-agent-assign](../coding-agent-assign/README.md) · Theo dõi session: [cloud-agent-session](../cloud-agent-session/README.md) · Chặn cứng file Copilot không được đọc: [content-exclusion](../../system-knowledge/content-exclusion/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [GitHub Docs — Watch and fix pull requests](https://docs.github.com/en/copilot/how-tos/copilot-on-github/use-copilot-agents/watch-and-fix-pull-requests) · [GitHub Docs — Using Copilot code review](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/use-code-review)
