# gh copilot explain — Dịch từng flag của một lệnh shell và chỉ ra rủi ro trước khi bạn Enter

> **Harness:** Local · **Surface:** terminal — extension `gh copilot` chạy ở máy bạn, không phải harness Chat/agent nào · **Đọc:** ~2 phút

**Nôm na:** Nhờ một người hiểu Unix đọc cho bạn nghe từng chữ trong lệnh: "cái `-delete` kia là XÓA thật đấy" — dán lệnh vào, nó dịch từng flag, rồi bạn quyết định có Enter hay không. Hợp khi hay copy lệnh từ docs/script về mà chưa chắc nó làm gì với dữ liệu.

## Vì sao dùng?

Lệnh tải từ mạng về rất hay giấu hành vi phá hủy trong một flag ngắn — đọc lướt thấy vô hại, bấm Enter thì mất dữ liệu không hoàn tác được; `explain` cưỡng lại thói quen đó bằng cách bắt bạn đọc bản dịch trước. Extension chỉ dịch lệnh, không chạy và không sửa code — việc đa bước trên repo là chỗ của [agent-mode](../../../copilot/model-agent/agent-mode/README.md) hoặc Copilot CLI.

| Lệnh copy từ mạng | Flag "vô hại" | Thật ra làm gì |
|---|---|---|
| `find . -name '*.log' -delete` | `-delete` | xóa file tìm được, không hỏi lại |
| `git reset --hard HEAD~2` | `--hard` | bỏ thay đổi working tree, không undo dễ |
| `docker system prune -a` | `-a` | xóa ảnh/containers đang không chạy |

**Nếu làm sai:** chạy trước hỏi sau thì bản dịch chỉ là cáo trạng của dữ liệu đã mất — với lệnh phá hủy, thứ tự đúng là dịch → chạy bản liệt kê (bỏ `-delete`) trên thư mục test/copy → xác nhận khớp bản dịch rồi mới chạy nơi thật.

## Cách dùng

Gõ trong Terminal (extension `gh copilot`, cài bằng `gh extension install github/gh-copilot`):

```sh
gh copilot explain "find . -type f -name '*.log' -mtime +7 -delete"
gh copilot explain "git reset --hard HEAD~2"
```

- **Biến thể:** repo `github/gh-copilot` đã archived, deprecated từ 25/10/2025 — vẫn chạy, nhưng đường thay thế là Copilot CLI: `copilot -p "giải thích lệnh: docker run -p 5432:5432 postgres"`.
- **Setting:** `gh extension list` kiểm đã cài chưa; đừng lẫn `gh copilot` (tra lệnh) với `copilot` (agent) — gọi nhầm thì thấy "sao nó không làm việc".
- **✅ Verify:** nói lại được "lệnh này làm gì + rủi ro gì" — không nói lại được là chưa đủ hiểu để Enter.

## Liên quan

- Cùng đường tra lệnh, chiều "mô tả việc → nhận lệnh": [cli-suggest](../cli-suggest/README.md) · việc đa bước trên repo: [agent-mode](../../../copilot/model-agent/agent-mode/README.md)
- Tra nhanh cả nhóm: [../README.md](../README.md) · Chạy thử: [`examples/`](examples/)
- Nguồn: [GitHub Docs — About Copilot CLI](https://docs.github.com/en/copilot/concepts/copilot-surfaces/copilot-cli)
