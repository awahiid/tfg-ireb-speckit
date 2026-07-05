# Task Decomposition — REQ-ADMIN-SKU-SEARCH-001

> **Date**: 2026-07-05 | **Constitution**: IREB Requirements Engineering Constitution v1.0
> **Source plan**: `PLAN-ADMIN-SKU-SEARCH-001.md` | **Estado**: BLOCK (Pre-Implementation Gates)

---

## REQ-ADMIN-SKU-SEARCH-001 — Búsqueda de productos por SKU de variante via query param `q`

| ID | Prioridad | Descripción | Archivos | Dependencias | P |
|----|-----------|-------------|----------|-------------|---|
| SK-0 | **Alta** | Reescribir requisito: source→"No documentado", rationale→"No documentado", algoritmo búsqueda definido (ILIKE %q%), verificación con 9 casos | `docs/02-specify/REQ-ADMIN-SKU-SEARCH-001.md` | Ninguna | ✅ |
| SK-1 | Alta | Añadir test: coincidencia exacta SKU de variante via `q` | `integration-tests/http/__tests__/product/admin/product.spec.ts` | SK-0 | ✅ |
| SK-2 | Alta | Añadir test: coincidencia parcial SKU de variante via `q` | `product.spec.ts` | SK-0 | ✅ |
| SK-3 | Alta | Añadir test: SKU inexistente devuelve lista vacía | `product.spec.ts` | SK-0 | ✅ |
| SK-4 | Alta | Añadir test: `q` vacío = sin cambios en resultados | `product.spec.ts` | SK-0 | ✅ |
| SK-5 | Alta | Añadir test: case-insensitive en SKU via `q` | `product.spec.ts` | SK-0 | ✅ |
| SK-6 | Alta | Añadir test: coincidencia por barcode/EAN/UPC de variante via `q` | `product.spec.ts` | SK-0 | ✅ |
| SK-7 | Alta | Añadir test: paginación + `q` con SKU parcial | `product.spec.ts` | SK-0 | ✅ |
| SK-8 | Alta | Marcar `Product.variants` como `.searchable()` en modelo | `packages/modules/product/src/models/product.ts` | SK-1 | |
| SK-9 | Alta | Ejecutar tests existentes + nuevos = sin regresiones | — | SK-1..SK-8 | |

### DAG

```
SK-0 [P] ──→ SK-1 [P] ──┐
              SK-2 [P] ──┤
              SK-3 [P] ──┤
              SK-4 [P] ──┤
              SK-5 [P] ──┤
              SK-6 [P] ──┤
              SK-7 [P] ──┤
                          ├──→ SK-8 ──→ SK-9
```

> **Nota**: SK-1 a SK-7 son [P] (paralelizables) entre sí y con SK-0. Se escriben contra el requisito reescrito, pero no requieren que el modelo esté modificado para redactarse. SK-8 (cambio real) se ejecuta después para validar que los tests pasan.

---

## Resumen

| Concepto | Valor |
|----------|-------|
| Total tareas | 10 |
| Tareas independientes [P] | 7 (SK-1..SK-7) |
| Profundidad máxima del DAG | 3 niveles (SK-0 → SK-[1-7] → SK-8 → SK-9) |
| Ruta crítica | SK-0 → cualquiera SK-[1-7] → SK-8 → SK-9 (3 pasos) |
| Bloqueante externo | SK-0: requiere reescritura del requisito (Art. 0, V, I) |
