# Task Decomposition — Sprint 1

> **Date**: 2026-07-03 | **Constitution**: IREB Requirements Engineering Constitution v1.0
> **Source plans**: `PLAN-AUTHENTIK-10110.md`, `PLAN-DIRECTUS-26646.md`

---

## REQ-AUTHENTIK-10110 — Corrección de esquema FIPS en API de sistema

| ID | Prioridad | Descripción | Archivos | Dependencias | P |
|----|-----------|-------------|----------|-------------|---|
| AU-1 | Alta | Escribir test: endpoint devuelve `openssl_fips_enabled` y no `openssl_fips_mode` | `authentik/admin/tests/test_system.py` | Ninguna | ✅ |
| AU-2 | Alta | Renombrar `openssl_fips_mode` → `openssl_fips_enabled` en TypedDict `RuntimeDict` | `authentik/admin/api/system.py` | Ninguna | ✅ |
| AU-3 | Baja | Regenerar `schema.yml` | `schema.yml` | AU-2 | |
| AU-4 | Alta | Ejecutar tests existentes + nuevos = sin regresiones | — | AU-1, AU-2 | |

### DAG

```
AU-1 [P] ──→ AU-4
AU-2 [P] ──→ AU-3 → AU-4
```

---

## REQ-DIRECTUS-26646 — Restricción de tipos MIME en subida de sistema

| ID | Prioridad | Descripción | Archivos | Dependencias | P |
|----|-----------|-------------|----------|-------------|---|
| DI-1 | Alta | Añadir `mimeTypeAllowList` al bloque `uploads` en `serverInfo()` | `api/src/services/server.ts` | Ninguna | ✅ |
| DI-2 | Alta | Escribir test API: `GET /server/info` incluye `mimeTypeAllowList` | `api/tests/server.test.ts` | Ninguna | ✅ |
| DI-3 | Alta | Añadir `mimeTypeAllowList` al tipo `Info` en store (y cargarlo) | `app/src/stores/server.ts` | DI-1 | |
| DI-4 | Alta | Escribir test store: `mimeTypeAllowList` se hidrata correctamente | `app/src/stores/server.test.ts` | DI-3 | |
| DI-5 | Alta | Pasar `:accept` desde store en `file.vue` | `app/src/interfaces/file/file.vue` | DI-3 | |
| DI-6 | Alta | Pasar `:accept` desde store en `files.vue` | `app/src/interfaces/files/files.vue` | DI-3 | ✅ |
| DI-7 | Alta | Reemplazar `accept="image/*"` por prop dinámico en `file-image.vue` | `app/src/interfaces/file-image/file-image.vue` | DI-3 | ✅ |
| DI-8 | Alta | Escribir test component: VUpload recibe `accept` dinámico | `app/src/interfaces/__tests__/file.test.ts` | DI-5, DI-6, DI-7 | |
| DI-9 | Alta | Ejecutar tests existentes + nuevos = sin regresiones | — | DI-2, DI-4, DI-8 | |

### DAG

```
DI-1 [P] ──→ DI-3 ──→ DI-4
DI-2 [P]                      DI-5 ──┐
                         DI-3 ──→ DI-6 [P] ──→ DI-8 ──→ DI-9
                                 DI-7 [P] ──┘
```

> **Nota**: DI-6 y DI-7 no dependen de DI-3 para redactarse (son independientes), pero sí para ejecutarse. Si se usa test-first, DI-6 y DI-7 pueden escribirse en paralelo con DI-3.

---

## Resumen

| Concepto | Valor |
|----------|-------|
| Total tareas | 13 |
| Tareas independientes [P] | 4 (AU-1, AU-2, DI-1, DI-2) |
| Tareas paralelizables en 2a ronda | 2 (DI-6, DI-7) |
| Profundidad máxima del DAG | 4 niveles (AU/DI) |
| Ruta crítica | DI-1 → DI-3 → DI-5/DI-6/DI-7 → DI-8 → DI-9 (5 pasos) |
