# Traceability Matrix — Spec ↔ Plan ↔ Tasks

> **Date**: 2026-07-03 | **Constitution**: IREB Requirements Engineering Constitution v1.0
> **Scope**: REQ-AUTHENTIK-10110, REQ-DIRECTUS-26646, REQ-N8N-30375

---

## 1. Bidirectional Traceability

### 1.1 REQ → Plan → Tasks

| REQ-ID | Plan | Tasks (ID) | Cobertura |
|--------|------|------------|-----------|
| REQ-AUTHENTIK-10110 | `PLAN-AUTHENTIK-10110.md` §2.2 | AU-1, AU-2, AU-3, AU-4 | 4/4 tasks cubren la especificación |
| REQ-DIRECTUS-26646 (sub 1) | `PLAN-DIRECTUS-26646.md` §1.4 (#1, #2) | DI-1, DI-2, DI-3, DI-4 | 4/4 tasks |
| REQ-DIRECTUS-26646 (sub 2) | `PLAN-DIRECTUS-26646.md` §1.4 (#3, #4, #5) | DI-5, DI-6, DI-7, DI-8, DI-9 | 5/5 tasks |
| REQ-N8N-30375 | `PLAN-N8N-30375.md` §2.2 | N8N-1, N8N-2, N8N-3, N8N-4, N8N-5, N8N-6, N8N-7 | 7/7 tasks |

### 1.2 Tasks → Plan → REQ (inversa)

| Task | Plan § | REQ-ID | Archivo(s) |
|------|--------|--------|------------|
| AU-1 | PLAN-AUTHENTIK §2.1 (#1) | REQ-AUTHENTIK-10110 | `authentik/admin/tests/test_system.py` |
| AU-2 | PLAN-AUTHENTIK §2.1 (#2) | REQ-AUTHENTIK-10110 | `authentik/admin/api/system.py` |
| AU-3 | PLAN-AUTHENTIK §2.1 (#3) | REQ-AUTHENTIK-10110 | `schema.yml` |
| AU-4 | PLAN-AUTHENTIK §3.2 | REQ-AUTHENTIK-10110 | — |
| DI-1 | PLAN-DIRECTUS §1.4 (#1) | REQ-DIRECTUS-26646 (sub 1) | `api/src/services/server.ts` |
| DI-2 | PLAN-DIRECTUS §2.1 (#1) | REQ-DIRECTUS-26646 (sub 1) | `api/tests/server.test.ts` |
| DI-3 | PLAN-DIRECTUS §1.4 (#2) | REQ-DIRECTUS-26646 (sub 1) | `app/src/stores/server.ts` |
| DI-4 | PLAN-DIRECTUS §2.1 (#3) | REQ-DIRECTUS-26646 (sub 1) | `app/src/stores/server.test.ts` |
| DI-5 | PLAN-DIRECTUS §1.4 (#3) | REQ-DIRECTUS-26646 (sub 2) | `app/src/interfaces/file/file.vue` |
| DI-6 | PLAN-DIRECTUS §1.4 (#4) | REQ-DIRECTUS-26646 (sub 2) | `app/src/interfaces/files/files.vue` |
| DI-7 | PLAN-DIRECTUS §1.4 (#5) | REQ-DIRECTUS-26646 (sub 2) | `app/src/interfaces/file-image/file-image.vue` |
| DI-8 | PLAN-DIRECTUS §2.1 (#5) | REQ-DIRECTUS-26646 (sub 2) | `app/src/interfaces/__tests__/file.test.ts` |
| DI-9 | PLAN-DIRECTUS §3.2 | REQ-DIRECTUS-26646 (sub 1+2) | — |
| N8N-1 | PLAN-N8N-30375 §2.2 (#1) | REQ-N8N-30375 | `n8n-e5/packages/nodes-base/nodes/EmailReadImap/test/v2/utils.test.ts` |
| N8N-2 | PLAN-N8N-30375 §2.2 (#2) | REQ-N8N-30375 | `n8n-e5/packages/nodes-base/nodes/EmailReadImap/test/v2/utils.test.ts` |
| N8N-3 | PLAN-N8N-30375 §2.2 (#3) | REQ-N8N-30375 | `n8n-e5/packages/nodes-base/nodes/EmailReadImap/test/v2/utils.test.ts` |
| N8N-4 | PLAN-N8N-30375 §3.1 (R1) | REQ-N8N-30375 | `n8n-e5/packages/nodes-base/nodes/EmailReadImap/v2/utils.ts` |
| N8N-5 | PLAN-N8N-30375 §3.1 (R2) | REQ-N8N-30375 | `n8n-e5/packages/nodes-base/nodes/EmailReadImap/v2/utils.ts` |
| N8N-6 | PLAN-N8N-30375 §3.1 (R3) | REQ-N8N-30375 | `n8n-e5/packages/nodes-base/nodes/EmailReadImap/v2/utils.ts` |
| N8N-7 | PLAN-N8N-30375 §3.2 | REQ-N8N-30375 | — |

### 1.3 Files → Tasks → REQ

| Archivo | Task | REQ-ID |
|---------|------|--------|
| `authentik/admin/api/system.py` | AU-2 | REQ-AUTHENTIK-10110 |
| `authentik/admin/tests/test_system.py` | AU-1 | REQ-AUTHENTIK-10110 |
| `schema.yml` | AU-3 | REQ-AUTHENTIK-10110 |
| `api/src/services/server.ts` | DI-1 | REQ-DIRECTUS-26646 |
| `api/tests/server.test.ts` | DI-2 | REQ-DIRECTUS-26646 |
| `app/src/stores/server.ts` | DI-3 | REQ-DIRECTUS-26646 |
| `app/src/stores/server.test.ts` | DI-4 | REQ-DIRECTUS-26646 |
| `app/src/interfaces/file/file.vue` | DI-5 | REQ-DIRECTUS-26646 |
| `app/src/interfaces/files/files.vue` | DI-6 | REQ-DIRECTUS-26646 |
| `app/src/interfaces/file-image/file-image.vue` | DI-7 | REQ-DIRECTUS-26646 |
| `app/src/interfaces/__tests__/file.test.ts` | DI-8 | REQ-DIRECTUS-26646 |
| `n8n-e5/packages/nodes-base/nodes/EmailReadImap/v2/utils.ts` | N8N-4, N8N-5, N8N-6 | REQ-N8N-30375 |
| `n8n-e5/packages/nodes-base/nodes/EmailReadImap/test/v2/utils.test.ts` | N8N-1, N8N-2, N8N-3 | REQ-N8N-30375 |

---

## 2. Verification Mapping

| REQ-ID | Verification (spec) | Verification Method (plan) | Test File (plan) | Cubierto |
|--------|-------------------|--------------------------|------------------|----------|
| REQ-AUTHENTIK-10110 | Escenario 1: respuesta API | Test de API | `test_system.py` (AU-1) | ✅ |
| REQ-AUTHENTIK-10110 | Escenario 2: esquema OpenAPI | Inspección manual/Automated | `schema.yml` (AU-3) | ✅ |
| REQ-AUTHENTIK-10110 | Escenario 3: UI admin | No cubierto en plan | — | ⚠️ |
| REQ-DIRECTUS-26646 | Escenario 1: restricción activa | Test API | `api/tests/server.test.ts` (DI-2) | ✅ |
| REQ-DIRECTUS-26646 | Escenario 1: restricción activa | Test store | `app/src/stores/server.test.ts` (DI-4) | ✅ |
| REQ-DIRECTUS-26646 | Escenario 1: restricción activa | Test component | `app/src/interfaces/__tests__/file.test.ts` (DI-8) | ✅ |
| REQ-DIRECTUS-26646 | Escenario 2: sin restricción | Test component | `app/src/interfaces/__tests__/file.test.ts` (DI-8) | ✅ |
| REQ-N8N-30375 | R1: marcado selectivo | Test unitario (mocked IMAP) | `utils.test.ts` (N8N-1) | ✅ |
| REQ-N8N-30375 | R2: omitir sin HEADER | Test unitario (mocked IMAP) | `utils.test.ts` (N8N-2) | ✅ |
| REQ-N8N-30375 | R3: actualizar lastMessageUid | Test unitario (batching) | `utils.test.ts` (N8N-3) | ✅ |

---

## 3. Breach Report

### 🔴 Brecha 1: REQ-AUTHENTIK-10110 — Escenario 3 (UI admin) no cubierto

| Severidad | Baja |
|-----------|------|
| Especificación | Escenario 3: \"Acceder a la interfaz de administración y confirmar que el estado FIPS se muestra correctamente sin referencias a `opensfsl_fips_mode`.\" |
| Plan | No incluye test de UI. Solo test de API y esquema. |
| Impacto | Bajo — la UI consume el endpoint ya verificado por AU-1. Si el endpoint devuelve el campo correcto y el frontend usa el TypedDict, la UI se actualiza automáticamente. |
| Acción | Documentar la dependencia implícita: la UI no necesita test separado porque su fuente de datos (endpoint) ya está verificada. Añadir nota en el plan. |

### ⚠️ Brecha 2: REQ-DIRECTUS-26646 — Singularidad de obligación (Artículo VI)

| Severidad | Media |
|-----------|-------|
| Especificación | El spec dice \"Obligación única: ✅ — una sola obligación\" (línea 27 del spec). |
| Clarify | Detectó **2 obligaciones** en la descripción: (1) exponer `FILES_MIME_TYPE_ALLOW_LIST` al cliente, (2) aplicar `accept` en el navegador. |
| Plan | Documenta la violación en Complexity Tracking y la mantiene como 1 REQ-ID con 2 sub-obligaciones. |
| Tareas | DI-1/DI-2/DI-3/DI-4 para sub 1, DI-5/DI-6/DI-7/DI-8/DI-9 para sub 2. |
| Acción | **Corregir el spec** para que refleje las 2 obligaciones y documente que son causalmente dependientes. O dividir en REQ-DIRECTUS-26646-A y REQ-DIRECTUS-26646-B. |

### ✅ Brecha 3: REQ-AUTHENTIK-10110 — Dependencias (RESUELTA)

Estado: **Cerrada**. El spec ya incluye `RuntimeDict` y `GET /admin/system/` en Dependencies (línea 15). La acción correctiva fue aplicada antes de la implementación.

### ⚠️ Brecha 4: REQ-DIRECTUS-26646 — Source sin hash de commit

| Severidad | Baja |
|-----------|------|
| Especificación | Source: PR #26646 con URL + Issue CMS-1679 con URL de Linear. |
| Plan | No especifica un commit SHA fijo. Linear no es accesible públicamente. |
| Acción | Añadir commit SHA del PR #26646 como source adicional. |

### ✅ Brecha positiva: Autentik spec y plan están alineados

REQ-AUTHENTIK-10110 spec → plan → tasks tienen correspondencia 1:1. Sin alucinaciones, sin desviaciones. El plan respeta Artículo II (solo los archivos necesarios) y Artículo I (tests verificables).

---

## 4. Coverage Summary

| Métrica | Valor |
|---------|-------|
| REQ → Plan → Tasks (cobertura total) | 100% (20/20 tasks mapean a un REQ-ID) |
| Tasks → Archivos (cobertura) | 100% (13/13 archivos mapean a una task) |
| Spec → Plan (alineación de verificación) | 90% (9/10 escenarios cubiertos; 1 sin test directo) |
| Plan → Spec (fidelidad de fuente) | 100% (sin alucinaciones en planes) |
| Brechas abiertas | 3 (1 media, 2 baja) |

---

## 5. Action Items

| # | Acción | Responsable | Plazo |
|---|--------|-------------|-------|
| # | Acción | Estado |
|---|--------|--------|
| 1 | Añadir nota en PLAN-AUTHENTIK-10110: UI test no necesario (dependencia implícita del endpoint) | ⏳ Pendiente |
| 2 | Decidir: dividir REQ-DIRECTUS-26646 en A/B, o mantener sub-obligaciones | ⏳ Pendiente |
| 3 | Actualizar Dependencies en REQ-AUTHENTIK-10110 spec | ✅ Resuelta |
| 4 | Fijar commit SHA en REQ-DIRECTUS-26646 source | ⏳ Pendiente |
| 5 | Reclasificar REQ-AUTHENTIK-10110 Type (Functional → Constraint) | 🆚 Debate abierto |
| 6 | REQ-N8N-30375: añadir rationale del umbral 20 en spec (Complexity Tracking) | ⏳ Pendiente |
| 7 | REQ-N8N-30375: definir condición de activación en verificación 1 del spec | ⏳ Pendiente |
