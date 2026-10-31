---
mode: agent
description: Review PR/diff theo checklist correctness, security, tests
tools: [search]
---

# Review PR

Review diff duoi day theo checklist. Giong nhu reviewer kho tinh nhung cong bang.

## Buoc 1 — Lay diff

```bash
git diff main...HEAD --stat
git diff main...HEAD -- <file-nghi-ngo> | head -150
```

## Buoc 2 — Checklist (tra ve theo 3 muc)

### Correctness
- Logic dung khong? Edge case (null, rong, qua han, race) duoc xu ly?
- Error shape co dung `{ code, message, requestId }`? Co nuot exception im lang (`catch {}`)?

### Security
- Input ngoai co validate o bien? Co SQL injection / command injection / XSS?
- Auth/role check du? Co lo secret, token, PII trong diff? (`grep -i "sk-\|ghp_\|password\s*="`)
- Dependency moi: lib gi, co tin cay (downloads, maintainer)?

### Tests & Style
- Co test cho code moi? Test co assert y nghia hay chi cho co?
- Commit message conventional commits? File >300 dong? Co `any` khong ly do?

## Buoc 3 — Tra ve

- **Critical** (block merge) / **Major** (nen sua) / **Minor** (nit) — moi muc ghi file:dong cu the + cach fix.
- Cuoi: verdict `APPROVE` / `REQUEST CHANGES` + 1 dong ly do.
