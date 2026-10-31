---
applyTo: "apps/web/**/*.{ts,tsx}"
description: Chuan frontend React + TypeScript. Tu dong ap khi sua file trong apps/web/.
---

# Frontend React Instructions

Ap dung cho moi file khop `apps/web/**/*.{ts,tsx}`.

## Stack & pattern

- React 18 + TypeScript strict, data-fetching bang <thu-vien-team-dung: React Query/SWR>.
- Component: function component + hooks. KHONG class component moi.
- State server (API) va state UI (form/modal) tach rieng, khong tron vao 1 store.

## Goi API (bat buoc — copy pattern nay)

```tsx
const { data, isLoading, error } = useQuery({
  queryKey: ["orders", page],
  queryFn: () => api.getOrders(page),
});
// Hien thi: isLoading -> Skeleton, error -> ErrorBox voi nut thu lai, KHONG trang trang.
```

- Moi call API phai co loading + error state. KHONG `await` tran trong render.
- Loi API hien `message` than thien, log `code + requestId` ra console de debug.

## Style & hieu nang

- File >300 dong thi tach. Component >100 dong can nhac tach con.
- List dai dung virtualize/pagination, KHONG render 1000 row 1 luc.
- Anh co `alt`, form co `label` (a11y co ban).

## Test

- Logic phuc tap (utils/hooks) co `*.test.tsx`. Chay `pnpm --filter @acme/web test -- <ten>`.
- Sua UI flow quan trong (login/checkout) → nho agent mo browser verify (neu co Playwright MCP).

## KHONG duoc

- NEVER goi API truc tiep trong `useEffect` khong co cleanup/abort.
- NEVER hardcode URL/token trong code. Qua `import.meta.env.*`.
- NEVER `any` cho props. Dinh nghia `Props` type ro rang.
