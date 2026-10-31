---
name: review-pr
description: Dung khi user nho review PR, review diff, hoac kiem tra code truoc merge. Khong dung cho viec viet feature moi hay fix bug.
---

# Review PR Skill (Agent Skills 2026 format)

Skill nay model TU goi khi user noi "review PR", "xem giup diff", "kiem tra truoc merge".

## Khi nao goi (model tu quyet dinh)

- User nhac: review, PR, diff, "xem code giup", "on dinh chua de merge".
- KHONG goi khi: user muon viet feature, sua bug, deploy, tao table.

## Procedure

### 1. Thu thap diff

```bash
git diff main...HEAD --stat
git diff main...HEAD -- <file-nghi> | head -150
```

Neu la so PR cu the: `gh pr diff <NUM> --name-only` roi doc tung file.

### 2. Checklist 3 truc

**Correctness:**
- Logic dung? Edge cases (null/rong/het han/race)?
- Error shape `{ code, message, requestId }`? Co `catch {}` nuot loi?

**Security:**
- Validate input bien? SQL/command/XSS injection?
- Auth/role? Lo secret/PII? Dependency moi co tin duoc?

**Tests & style:**
- Co test y nghia? Conventional commits? File >300 dong? `any` khong ly do?

### 3. Dinh dang ket qua (bat buoc)

```text
CRITICAL (block merge):
- <file:dong> — <lo + fix>

MAJOR:
- ...

MINOR:
- ...

VERDICT: APPROVE | REQUEST CHANGES — <1 dong>
```

## Loi can tranh

- Dung review style khi co loi correctness/security (uu tien noi dung nghiem trong).
- Dung duyet PR cham `db/migrations/**` hoac `infra/**` ma khong canh bao rui ro.
- Qua 10 file doi → bao user chia nho thay vi review qua loa.
