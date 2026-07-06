# Task Decomposition — REQ-APPWRITE-10832: Cacheo de listados de documentos con TTL

> **Constitution**: IREB Requirements Engineering Constitution v1.0
> **Regla IREB**: Cada tarea traza a exactamente un REQ-ID. Tareas sin trazabilidad no existen.

---

## 1. Setup y preparación

- [ ] [T1] [REQ-APPWRITE-10832] Identificar archivo de controlador de listado de documentos en Appwrite (`src/Appwrite/Utopia/Response/Documents.php` o ruta equivalente) | Alta | `src/Appwrite/Utopia/Response/Documents.php` | Ninguna

---

## 2. Tests (primero)

### Unit tests

- [ ] [T2] [REQ-APPWRITE-10832] Test: cacheKey se genera igual para requests idénticas (databaseId, collectionId, filtros normalizados) | Alta | `tests/unit/Cache/DocumentCacheTest.php` | T1 [P]
- [ ] [T3] [REQ-APPWRITE-10832] Test: cache hit devuelve datos mock sin ejecutar BD query | Alta | `tests/unit/Cache/DocumentCacheTest.php` | T1 [P]
- [ ] [T4] [REQ-APPWRITE-10832] Test: cache miss ejecuta BD query y llama a `cache->set()` con datos + ttl | Alta | `tests/unit/Cache/DocumentCacheTest.php` | T1 [P]
- [ ] [T5] [REQ-APPWRITE-10832] Test: cache expirada (TTL vencido) se comporta como cache miss | Alta | `tests/unit/Cache/DocumentCacheTest.php` | T1 [P]
- [ ] [T6] [REQ-APPWRITE-10832] Test: sin `cacheTtl` en request → comportamiento actual (sin caché) | Alta | `tests/unit/Cache/DocumentCacheTest.php` | T1 [P]

### Integration / e2e tests

- [ ] [T7] [REQ-APPWRITE-10832] Test e2e: respuesta header `X-Cache: MISS` en primera request con cacheTtl | Media | `tests/e2e/DocumentCacheTest.php` | T3, T4
- [ ] [T8] [REQ-APPWRITE-10832] Test e2e: respuesta header `X-Cache: HIT` en segunda request idéntica (mismo TTL) | Media | `tests/e2e/DocumentCacheTest.php` | T7
- [ ] [T9] [REQ-APPWRITE-10832] Test e2e: respuesta header `X-Cache: MISS` tras expirar TTL | Media | `tests/e2e/DocumentCacheTest.php` | T8

---

## 3. Implementación

- [ ] [T10] [REQ-APPWRITE-10832] Añadir función `buildCacheKey()` que normaliza parámetros de request a string única (md5) | Alta | `src/Appwrite/Utopia/Response/Documents.php` | T2
- [ ] [T11] [REQ-APPWRITE-10832] Añadir lógica de cache hit: antes de BD query, `$this->cache->get(cacheKey)` — si hay datos no expirados, devolverlos + header `X-Cache: HIT` | Alta | `src/Appwrite/Utopia/Response/Documents.php` | T3
- [ ] [T12] [REQ-APPWRITE-10832] Añadir lógica de cache miss: si cacheKey no existe o expiró, ejecutar BD query, guardar en `$this->cache->set(cacheKey, data, ttl)`, header `X-Cache: MISS` | Alta | `src/Appwrite/Utopia/Response/Documents.php` | T4, T5
- [ ] [T13] [REQ-APPWRITE-10832] Mantener flujo original cuando no hay `cacheTtl` (sin cambios) | Alta | `src/Appwrite/Utopia/Response/Documents.php` | T6

---

## 4. Integración y limpieza

- [ ] [T14] [REQ-APPWRITE-10832] Ejecutar suite completa de tests existentes para verificar no regresiones | Alta | — | T10, T11, T12, T13
- [ ] [T15] [REQ-APPWRITE-10832] Documentar nuevo parámetro `cacheTtl` y header `X-Cache` en changelog | Baja | `CHANGELOG.md` | T14

---

## Verificación pre-implementación

- [x] Todos los REQ-ID del spec tienen al menos una tarea
- [x] No hay tareas sin REQ-ID (huérfanas)
- [x] Las tareas [P] no tienen dependencias
- [x] Los tests (T2-T9) preceden a la implementación (T10-T13)
