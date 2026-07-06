# Implementation Plan — REQ-APPWRITE-10832: Cacheo de listados de documentos con TTL

> **Branch**: `appwrite-e3-document-cache-ttl`
> **Date**: 2026-07-05
> **Spec**: `docs/req-appwrite-10832.md`
> **Constitution**: IREB Requirements Engineering Constitution v1.0
> **MRS Input**: `mrs-inputs/REQ-APPWRITE-10832.txt`

---

## Phase 0: Pre-Implementation Gates (IREB)

### Verifiability Gate (Article I)

- [x] R1 (cache hit): criterio observable — verificar que tras 2 peticiones idénticas en < TTL, la segunda no ejecuta consulta a BD (log/métrica/header)
- [x] R2 (cache miss): criterio observable — tras esperar > TTL, la consulta se ejecuta contra BD y la respuesta contiene datos frescos
- [ ] ⚠️ **Residual**: el spec no define **cómo** se observa "sin consulta a BD" (log, header, métrica). Se documenta en Complexity Tracking.

### Anti-Ambiguity Gate (Article V)

- [x] No subjective terms (fast, efficient, robust, etc.)
- [x] TTL is numeric (segundos), observable como duración
- [ ] ⚠️ **Residual**: verbo "renovar" no está definido operacionalmente (¿invalidate + re-query? ¿TTL sliding?). Se documenta en Complexity Tracking.

### Traceability Gate (Articles III, VII)

- [x] Source: PR #10832
- [x] Rationale: "reducir latencia y carga sobre la base de datos en consultas de listado repetitivas"
- [ ] ⚠️ **Residual**: Fuente `PR #10832` sin URL completa. El MRS no la proporciona. El plan usa la fuente disponible.

### Classification Gate (Article IV)

- [x] Type: Functional — dos comportamientos observables (cache hit, cache miss/refresh)

### Minimality Gate (Article II)

- [x] Plan cubre solo archivos necesarios para el cacheo de listados con TTL
- [x] No architectural changes, no refactors, no dependency additions
- [x] No "while we're here" improvements

### Gate Decision

| Result | Action |
|--------|--------|
| ALL gates pass | ✅ Proceed to Phase 1 |
| 1-2 gates fail | ⚠️ Document exceptions in Complexity Tracking |
| ≥ 3 gates fail | BLOCK |

**Decisión**: ✅ PASA. 2 residuales no bloqueantes (Verificación, Ambigüedad) documentados en Complexity Tracking.

---

## Phase 1: Technical Design

### 1.1 Technology Stack

| Component | Technology | Justification |
|-----------|-----------|---------------|
| PHP runtime | PHP 8.x (Appwrite, Composer) | Ya existente en el proyecto |
| Caching layer | Appwrite internal cache (`$this->cache` via `\Utopia\Cache\Cache`) | Framework proporciona `get`, `set`, `delete` con TTL |
| Testing | PHPUnit (Appwrite `tests/`) | Patrón existente en el proyecto |
| Document listing | `\Appwrite\Database\Database::getCollection('documents')` | API nativa de Appwrite Database |

### 1.2 Architecture Overview

El flujo actual de listado de documentos en Appwrite (`src/Appwrite/Utopia/Response/Documents.php` o ruta equivalente) ejecuta:

1. Recibe petición `GET /v1/databases/{databaseId}/collections/{collectionId}/documents` con parámetros opcionales (filtros, límite, offset)
2. Construye query y ejecuta contra la base de datos
3. Devuelve resultados paginados

La modificación añade una capa de caché opcional antes de la consulta:

1. Si la petición incluye `cacheTtl` (segundos):
   - Generar key de caché a partir de los parámetros de la request (databaseId, collectionId, filtros normalizados)
   - Si `cache->get(key)` devuelve datos y no ha expirado → devolver datos cacheados directamente
   - Si no hay caché o expiró → ejecutar consulta a BD, guardar resultado en `cache->set(key, data, ttl)`, devolver resultado
2. Si la petición **no** incluye `cacheTtl` → comportamiento actual (sin caché)

La verificación de origen (cache vs BD) se implementa mediante un **header de respuesta** `X-Cache: HIT` o `X-Cache: MISS`.

### 1.3 Data Model

No se modifican entidades de base de datos. Se introduce una key de caché:

| Variable / Concepto | Propósito |
|--------------------|-----------|
| `cacheKey` | String: `documents:list:{databaseId}:{collectionId}:md5(query_params)` |
| `$app->getResponse()->addHeader('X-Cache', 'HIT|MISS')` | Header observable para verificación |

### 1.4 API Contracts

| Endpoint | Method | Change | Implements |
|----------|--------|--------|------------|
| `GET /v1/databases/{databaseId}/collections/{collectionId}/documents` | GET | Añadir `cacheTtl` query param opcional; respuesta incluye `X-Cache` header | REQ-APPWRITE-10832 |

---

## Phase 2: Implementation Strategy

### 2.1 File Creation Order (Test-First)

1. **Unit Tests** — `tests/unit/Cache/DocumentCacheTest.php` (nuevo): testear generación de cacheKey, cache hit (mock cache), cache miss (mock BD + cache set)
2. **Integration Tests** — `tests/e2e/DocumentCacheTest.php` (nuevo): verificar header `X-Cache` en respuestas con/sin cacheTtl
3. **Source** — modificar `src/Appwrite/Utopia/Response/Documents.php` (listado): añadir lógica de cache TTL con inyección de dependencia vía `$this->cache`
4. **No new contracts** — el API contract existente se extiende con params opcionales

### 2.2 Implementation Tasks by Requirement

| REQ-ID | Tasks |
|--------|-------|
| REQ-APPWRITE-10832 (cache hit) | 1. Generar `cacheKey` normalizado a partir de parámetros de request |
| REQ-APPWRITE-10832 (cache hit) | 2. Consultar `$this->cache->get(cacheKey)` antes de BD query |
| REQ-APPWRITE-10832 (cache hit) | 3. Si cache hit → devolver datos cacheados + `X-Cache: HIT` |
| REQ-APPWRITE-10832 (cache miss) | 4. Si cache miss → ejecutar BD query, guardar en `$this->cache->set(key, data, ttl)`, `X-Cache: MISS` |
| REQ-APPWRITE-10832 (cache hit) | 5. Test unitario: cacheKey se genera igual para request idénticas |
| REQ-APPWRITE-10832 (cache hit) | 6. Test unitario: cache hit devuelve datos mock sin tocar BD |
| REQ-APPWRITE-10832 (cache miss) | 7. Test unitario: cache miss ejecuta BD y guarda en cache |
| REQ-APPWRITE-10832 (cache hit+miss) | 8. Test e2e: `X-Cache: HIT` tras 2ª request en < TTL, `X-Cache: MISS` tras expirar |
| REQ-APPWRITE-10832 (TTL) | 9. Test unitario: cache expirada se comporta como cache miss |

---

## Phase 3: Verification Strategy

### 3.1 Verification by Requirement

| REQ-ID | Verification Method | Expected Result | Test File |
|--------|-------------------|----------------|-----------|
| REQ-APPWRITE-10832 (R1: cache hit) | Test unitario (mock cache) | `cache->get()` devuelve datos, BD query NO se ejecuta | `tests/unit/Cache/DocumentCacheTest.php` |
| REQ-APPWRITE-10832 (R2: cache miss) | Test unitario (mock BD) | `cache->get()` devuelve null, BD query se ejecuta, `cache->set()` llamado con datos + ttl | `tests/unit/Cache/DocumentCacheTest.php` |
| REQ-APPWRITE-10832 (R3: header) | Test e2e | Respuesta header `X-Cache: HIT` en 2ª request, `X-Cache: MISS` en 1ª o tras expirar | `tests/e2e/DocumentCacheTest.php` |
| REQ-APPWRITE-10832 (R4: TTL expirado) | Test unitario (mock time) | `cache->get()` devuelve null tras ttl, se comporta como miss | `tests/unit/Cache/DocumentCacheTest.php` |

### 3.2 Regression Gate

- [ ] All existing tests still pass (no regressions)
- [ ] All new tests pass
- [ ] Contract tests cover listado endpoint con/sin cacheTtl
- [ ] Traceability matrix complete: REQ → spec → plan → task → test → code
- [ ] Sin modificar archivos fuera del scope

---

## Complexity Tracking

| Decision | Violation | Justification | Approved |
|----------|-----------|---------------|----------|
| Header `X-Cache` como medio de verificación | Artículo I (Verificabilidad) — el spec no menciona header | El spec dice "sin consulta a la base de datos" sin definir el medio observable. El plan introduce `X-Cache: HIT\|MISS` como proxy verificable. Es una expansión de implementación permitida (Artículo 0 permite expandir detalles de implementación). | ✅ Documentado |
| Verbo "renovar" impreciso | Artículo V (No ambigüedad) — el verbo no tiene definición operacional | En el plan, "renovar" se traduce a: `cache->get()` devuelve null o dato expirado → ejecutar BD query → `cache->set(key, data, ttl)`. Operacionalmente definido. | ✅ Documentado |
| Fuente `PR #10832` sin URL | Artículo VII (Source) — referencia incompleta | El MRS input proporciona solo esa referencia. No hay URL adicional en el input original. Se usa tal cual. | ✅ Documentado |

---

## Post-Implementation Verification

- [ ] `/speckit.analyze` confirms spec ↔ plan ↔ tasks ↔ code consistency
- [ ] All verification tests pass
- [ ] Traceability chain complete: REQ → spec → plan → task → test → code
- [ ] No hallucinated context in any artifact
