# Implementation Plan — REQ-AUTHENTIK-10110

> **Branch**: `fix/fips-schema-system-api` | **Date**: 2026-07-03
> **Spec**: `docs/requisitos/REQ-AUTHENTIK-10110.md`

---

## Phase 0: Pre-Implementation Gates (IREB)

### Verifiability Gate (Article I)
- [x] Every requirement has a verification criterion with observable behavior
- [x] Verification criteria include expected outputs (API response, OpenAPI schema, UI)
- [x] No verification criterion is circular

### Anti-Ambiguity Gate (Article V)
- [x] No subjective terms detected
- [x] All criteria use concrete field names (`openssl_fips_enabled`, `openssl_fips_mode`)
- [x] Remaining ambiguities: none

### Traceability Gate (Articles III, VII)
- [x] Source field present: PR #10110 with URL
- [x] Rationale field: consistency of system data contract
- [x] Dependencies: none documented

### Classification Gate (Article IV)
- [x] Type: Constraint — corrige el esquema de respuesta de la API (cambio estructural del contrato de datos)

### Minimality Gate (Article II)
- [x] Plan covers ONLY the files needed: `system.py` (TypedDict + serializer), `schema.yml` (auto-regenerado)
- [x] No architectural changes, refactors, or dependency additions
- [x] No feature additions beyond the requirement scope
- [ ] Each planned file maps to exactly one REQ-ID
- [x] No "while we're here" improvements

### Gate Decision
| Result | Action |
|--------|--------|
| ALL gates pass (1 note) | Proceed to Phase 1 |

> **Nota**: El escenario 3 de verificación (UI admin) no tiene test directo. No es necesario porque la UI consume el endpoint verificado por AU-1. Dependencia implícita documentada en `TRACEABILITY-MATRIX.md` §3 Brecha 1.

---

## Phase 1: Technical Design

### 1.1 Technology Stack

| Component | Technology | Justification |
|-----------|-----------|---------------|
| Framework | Django REST Framework + drf-spectacular | Existing in authentik |
| Serializer | `PassiveSerializer` + `TypedDict` | Existing in `system.py` |
| Test framework | pytest + DRF test client | Existing in authentik |

### 1.2 Architecture Overview

**Problema**: El TypedDict `RuntimeDict` (línea 36 de `system.py`) declara el campo como `openssl_fips_mode`, pero el método `get_runtime()` (línea 75) devuelve la clave `openssl_fips_enabled`. `drf-spectacular` genera el esquema OpenAPI desde el TypedDict, produciendo `openssl_fips_mode` en la documentación, mientras que la respuesta real contiene `openssl_fips_enabled`. Esto causa inconsistencia entre backend ↔ OpenAPI schema ↔ frontend.

**Solución**: Cambiar el TypedDict `RuntimeDict` para que declare `openssl_fips_enabled` en lugar de `openssl_fips_mode`. El esquema OpenAPI se regenerará automáticamente al coincidir el TypedDict con la respuesta real. No se toca `get_runtime()` porque ya devuelve el nombre correcto.

### 1.3 Data Model

Sin cambios en el modelo de datos. Solo cambio de nombre de campo en un TypedDict.

### 1.4 API Contracts

| Endpoint | Method | Cambio | Implementa |
|----------|--------|--------|------------|
| `GET /admin/system/` | GET | Response.runtime.openssl_fips_mode → openssl_fips_enabled | REQ-AUTHENTIK-10110 |

---

## Phase 2: Implementation Strategy

### 2.1 File Creation Order (Test-First)

1. **Test**: Verificar que el endpoint devuelve `openssl_fips_enabled` y no `openssl_fips_mode`
2. **Source**: Cambiar el TypedDict en `system.py`
3. **Schema**: Regenerar `schema.yml` (no se modifica manualmente)

### 2.2 Implementation Tasks by Requirement

| REQ-ID | Tasks |
|--------|-------|
| REQ-AUTHENTIK-10110 | 1. Escribir test que verifique el campo renombrado en la respuesta 2. Renombrar `openssl_fips_mode` a `openssl_fips_enabled` en `RuntimeDict` 3. Regenerar esquema OpenAPI 4. Ejecutar tests existentes para confirmar no regresión |

---

## Phase 3: Verification Strategy

### 3.1 Verification by Requirement

| REQ-ID | Verification Method | Expected Result | Test File |
|--------|--------------------|----------------|-----------|
| REQ-AUTHENTIK-10110 | Test de API | `GET /admin/system/` devuelve `runtime.openssl_fips_enabled` (bool o null) y NO incluye `runtime.openssl_fips_mode` | `authentik/admin/tests/test_system.py` (nuevo) |
| REQ-AUTHENTIK-10110 | Inspección de esquema | `schema.yml` contiene `openssl_fips_enabled` en `SystemInfo.runtime.properties` | `schema.yml` (generado) |

### 3.2 Regression Gate

- [x] All existing tests still pass (no regressions)
- [x] All new tests pass
- [x] Contract tests cover all API endpoints
- [x] Traceability matrix is complete (REQ → test → implementation)

---

## Complexity Tracking

| Decision | Violation | Justification | Approved |
|----------|-----------|---------------|----------|
| Ninguna | — | — | N/A |

---

## Post-Implementation Verification

- [x] Analyze confirma spec ↔ plan ↔ tasks ↔ code consistency
- [x] All verification tests pass
- [x] Traceability chain: REQ-AUTHENTIK-10110 → spec → plan → test → code
- [x] No alucinaciones de contexto en el código generado
