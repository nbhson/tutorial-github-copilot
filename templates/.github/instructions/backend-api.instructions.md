---
applyTo: "apps/api/**/*"
description: Chuan backend API (NestJS/Express + Postgres). Tu dong ap khi sua file trong apps/api/.
---

# Backend API Instructions

Ap dung cho moi file khop `apps/api/**/*`.

## Error shape (bat buoc — copy pattern nay)

```ts
return res.status(400).json({ code: "BAD_INPUT", message, requestId });
```

- `code`: SNAKE_CASE, on dinh (`BAD_INPUT`, `NOT_FOUND`, `FORBIDDEN`, `CONFLICT`, `INTERNAL`).
- Moi handler phai co `try/catch`, log ke `requestId`.

## Cau truc

- Controller mong: validate input + goi service, KHONG chua logic nghiep vu.
- Logic nam o `service/`, types dung chung o `packages/domain/`.
- DB change → migration moi trong `db/migrations/`, KHONG sua file da merge.

## Test bat buoc

- Moi endpoint moi/sua: them `*.spec.ts` canh code.
- Chay focused truoc khi ket luan: `pnpm --filter @acme/api test -- <ten-module>`.
- Do khi test do? Sua code, KHONG sua test cho xanh.

## Bao mat

- Validate moi input o bien (zod/class-validator). Khong tin client.
- Secret chi qua `process.env.*`. KHONG hardcode connection string.
- Query doc dung read-replica. Endpoint `/admin/**` phai co guard role.

## KHONG duoc

- NEVER sua `db/migrations/**` da merge.
- NEVER tra stack trace chi tiet ve client (log server, tra `message` chung chung).
- NEVER `select *` bang raw SQL khong co `LIMIT` o endpoint public.
