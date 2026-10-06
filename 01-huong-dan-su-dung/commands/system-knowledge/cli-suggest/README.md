# gh copilot suggest — Gợi ý lệnh CLI trong terminal

> Nôm na: hỏi đường cho dân terminal — “đi tới đó thì gõ gì?”.

## Lệnh làm gì (1 câu nôm na)

Nôm na: hỏi đường cho dân terminal — “đi tới đó thì gõ gì?”. Thuộc nhóm lệnh dùng hàng ngày — gắn scope gọn thì 1–2 turns là xong.

## Khi nào dùng

- Quên cú pháp git/docker/gh/kubectl.
- Muốn lệnh 1 dòng làm việc lạ.
- Học lệnh mới an toàn (hiểu rồi mới chạy).

## Cách gọi (copy-paste)

```bash
gh copilot suggest "tìm file >100MB trong git history"
```

> Kiểm tra lệnh có khả dụng ở máy bạn không: gõ `/` trong Chat input, tìm `gh copilot suggest`. Không thấy → đọc `/status` + plan trước khi kết luận bug.

## Ví dụ prompt thật + kết quả mong đợi

**Prompt thật (copy-paste, nhớ gắn scope trước):**

```bash
gh copilot suggest “xóa branch đã merge trừ main/develop”
```

**Kết quả mong đợi:** Được 1–2 lệnh cụ thể + giải thích flag; chạy thử với --dry-run trước.

**Cách verify:** Chạy lệnh được gợi ý (chế độ an toàn) thành công là đạt.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân | Fix |
|---|---|---|
| Chạy luôn lệnh nguy hiểm | Tin 100% | Hiểu từng flag + dry-run trước; cấm rm -rf/force mù |
| gh copilot not found | Chưa cài extension | gh extension install github/gh-copilot |
| Gợi ý sai OS | Lệnh Linux trên Mac/Win | Nêu OS trong prompt |

## Tham khảo

- Index nhóm: [../README.md](../README.md) — bảng tra 1 dòng mỗi lệnh.
- Cheatsheet 1 trang: [../../../../CHEATSHEET.md](../../../../CHEATSHEET.md).
- Kẹt thì tra [FAQ troubleshooting](../../../../03-cau-hoi-thuong-gap/08-loi-thuong-gap-troubleshooting.md).

> Mẹo 1 dòng: _gắn scope trước (`#file`/`@workspace`), review diff sau, đừng bao giờ Accept mù._
