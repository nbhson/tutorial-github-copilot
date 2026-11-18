# gh copilot suggest — Mô tả việc bằng lời, nhận về lệnh shell kèm giải thích từng flag

> **Harness:** Local · **Surface:** terminal — extension `gh copilot` chạy ở máy bạn, không phải harness Chat/agent nào · **Đọc:** ~2 phút

**Nôm na:** Như hỏi đường miệng: nói "tôi muốn xóa branch đã merge" thì nhận đúng câu lệnh kèm giải thích — nhưng bạn vẫn là người bấm Enter, và vẫn phải nhìn biển báo (flag) trước khi lái. Hợp khi quên cú pháp git/docker/kubectl và việc của bạn là lệnh một dòng.

## Vì sao dùng?

Trí nhớ con người kém đúng chỗ nguy hiểm nhất: flag. Bạn nhớ `git branch -d` nhưng quên `-D` là xóa **force** mất cả commit chưa merge; `--soft` giữ code còn `--hard` thì mất — một chữ cái, hai số phận. `suggest` biến ý định thành lệnh cụ thể, và giá trị thật nằm ở phần giải thích đi kèm: đọc flag rồi mới chạy, thay vì copy mù.

| Bạn nói | Nhận được | Flag phải đọc kỹ |
|---|---|---|
| "xóa branch đã merge, trừ main/develop" | `git branch --merged \| grep -v ... \| xargs git branch -d` | `-d` (an toàn) khác `-D` (force, mất commit) |
| "tìm file lớn hơn 100MB trong repo" | `find . -size +100M -type f` | có thêm `-delete` vào là thành xóa |
| "undo commit cuối nhưng giữ thay đổi" | `git reset --soft HEAD~1` | `--soft` giữ code, `--hard` thì mất |

**Nếu làm sai:** Enter luôn không đọc là đường ngắn nhất mất dữ liệu — `suggest` cho bạn lệnh chứ không cho bạn sự an toàn; và extension chỉ trả lệnh một dòng, không đọc–sửa repo, việc đa bước là chỗ của [agent-mode](../../../copilot/model-agent/agent-mode/README.md).

## Cách dùng

Gõ trong Terminal (extension `gh copilot`, cài bằng `gh extension install github/gh-copilot`):

```sh
gh copilot suggest "xóa branch đã merge, giữ main và develop"
gh copilot suggest "tìm file lớn hơn 100MB trong repo, trên macOS zsh"
```

- **Biến thể:** luôn nêu OS + shell trong prompt — nguồn lỗi số một là nhận cú pháp Linux khi đang dùng máy Mac.
- **Setting:** repo `github/gh-copilot` đã archived, deprecated từ 25/10/2025 — đường thay thế là Copilot CLI: `copilot -p "<mô tả việc>"`.
- **✅ Verify:** chạy bản thăm dò trước (chỉ in danh sách, ví dụ `git branch --merged`) — khớp đúng những thứ sẽ bị thay đổi rồi mới chạy lệnh thật.

## Liên quan

- Nhận lệnh rồi, muốn hiểu từng flag: [cli-explain](../cli-explain/README.md) · việc đa bước: [agent-mode](../../../copilot/model-agent/agent-mode/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [GitHub Docs — About Copilot CLI](https://docs.github.com/en/copilot/concepts/copilot-surfaces/copilot-cli)
