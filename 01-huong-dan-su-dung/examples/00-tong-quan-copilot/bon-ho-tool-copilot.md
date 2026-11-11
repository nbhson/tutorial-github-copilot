# 00 — Mẫu 4 họ tool (mục 4): bảng kiểm + một phiên làm việc mẫu

> **Dành cho:** bài 00 mục 4. Copy bảng kiểm vào note của repo (hoặc paste vào đầu chat Agent) để biết agent sắp chạm vào gì — tool nào nhóm 1 thì thở phào, tool nào nhóm 2/4 thì soi diff.

## 1. Bảng kiểm 4 họ tool (dán vào `.github/copilot-instructions.md` hoặc chat đầu phiên)

```text
TOOL NHO (nhom 1 - doc & tim): khong can hoi, nhung bao "doc file X, Y truoc khi sua"
TOOL NANG (nhom 2 - sua & chay): moi lenh terminal co tac dong ghi -> hien lenh truoc khi chay
TAI SAN NGOAI (nhom 4 - MCP): goi lenh nao cua server nao -> liet ke cuoi turn
GIOI HAN: sua trong <thu-muc>, dung cham vao thu-muc khac; moi lan sua file -> tom tat 1 dong
```

## 2. Một phiên Agent mẫu — nhìn 4 họ tool chạy trên màn hình

Task: "Trong `src/auth`, thêm rate-limit cho `POST /login`, có test, chạy `npm test -- auth`."

```text
TURN 1  [N1 doc]   search("login") -> doc 2 file: routes/auth.ts, app.ts
TURN 2  [N1 doc]   doc package.json -> phat hien co express-rate-limit san
TURN 3  [N3 plan]  hien ke hoach 3 buoc, cho ban duyet        <- Add Context/plan
TURN 4  [N2 sua]   sua routes/auth.ts (diff hien ra, ban Accept)
TURN 5  [N2 sua]   them test login.rate-limit.test.ts
TURN 6  [N2 chay]  chay `npm test -- auth` -> FAIL (thieu await)
TURN 7  [N2 sua]   fix test -> chay lai -> PASS
TURN 8  [ket luan] bao cao diff + tai sao chon muc 5 req/phut
```

Nhận ra ngay: turn nào là **đọc** (vô hại), turn nào là **sửa/chạy** (phải duyệt), và model **tự vòng lại** bước 6→7 vì test fail — chính là vòng lặp 4 bước mục 3.

## 3. Tool nhóm 4 (MCP) trông khác gì

- Tool MCP hiện với tên `mcp__<server>__<tool>` (ví dụ `mcp__github__create_pr`) — thấy tên này là biết agent đang gọi **chương trình ngoài repo**.
- Lần đầu thấy tool MCP trong phiên: đọc mô tả tool + kết quả trả về, đừng Accept liên tục. Chi tiết cấu hình server: bài 08.

## 4. Biến thể theo Session Target

| Bạn chọn ở picker | Điều gì đổi với 4 họ tool |
|---|---|
| **Copilot** (mặc định của khoá) | tool chạy trong Agent Host; có sandbox + permission levels enforce được |
| **Local** | tool chạy trong extension host; đóng cửa sổ editor là agent dừng |
| **Cloud** | vẫn Copilot harness, chạy trên hạ tầng managed của GitHub — nhóm 2/4 càng phải gọn |
| **Claude / Codex** | harness của nhà cung cấp khác; họ tool tương tự nhưng màn hình duyệt quyền khác |

> **Tóm gọn 1 câu:** Bảng kiểm mục 1 + đọc tên tool trong tool activity = bạn biết chính xác agent đang "cầm dao" lúc nào để đứng dậy coi.
