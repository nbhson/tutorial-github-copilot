---
applyTo: "src/**/*.py,**/*.test.py"
excludeAgent: "code-review"   # tuy chon: rule ap cho moi agent TRU code-review
---

# Quy tắc Python — backend-api (bai 03 muc 4)

File nay dat tai `.github/instructions/python-api.instructions.md`, ten file
khong anh huong — `applyTo` moi la thu quyet dinh luc rule duoc nap.
Path tinh tu GOC REPO, khong tinh tu `.github/instructions/`.

## Architecture
- Route handler mem trong `src/api/`; schema pydantic trong `src/schemas/`; khong import nguoc (schemas -> api).
- Mot ham khong vuot 40 dong; nhieu hon thi tach va dat ten theo hanh dong.

## Lệnh (agent phai dung dung lenh nay, khong tu che)
- Test:      `python -m pytest <file>` — toi da 1 file test moi lan chay
- Lint:      `ruff check src/ tests/`
- Type:      `mypy src/ --ignore-missing-imports`

## Thoi quen code
- Reuse fixtures tu `tests/conftest.py`; KHONG tao fixture trung lap o file khac.
- Mock chi o bien (HTTP, DB), khong mock ham noi bo cua chinh module dang test.
- Env docs qua `os.environ` chi duoc goi trong `src/config.py`.

## Cam
- Khong them thu vien moi ma khong ghi ly do vao PR mo.
- Khong chay lenh migration that — sinh lenh `alembic revision` de nguoi dev tu chay.

<!-- Verify (2 phut): mo src/api/users.py, hoi "viet them endpoint tao user".
     -> References trong chat phai liet ke file nay; tra loi dung lenh pytest o tren.
     Mo src/main.ts hoi tuong tu -> file NAY khong xuat hien (applyTo khong khop). -->
