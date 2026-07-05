# Implementation Plan — REQ-N8N-30375: Corrección del procesamiento de correos IMAP

> **Branch**: `n8n-30375-imap-email-trigger-fix`
> **Date**: 2026-07-03
> **Spec**: `docs/req-n8n-30375.md`
> **Constitution**: IREB Requirements Engineering Constitution v1.0

---

## Phase 0: Pre-Implementation Gates (IREB)

### Verifiability Gate (Article I)

- [x] R1: `marcar como leídos únicamente los correos procesados exitosamente` — criterio: verificar en servidor IMAP que solo los correos que activaron el flujo tienen `\SEEN`
- [x] R2: `omitir mensajes sin HEADER` — criterio: verificar log `warn` y que el flujo no se desactiva
- [x] R3: `actualizar lastMessageUid tras cada lote` — criterio: verificar que `lastMessageUid` se actualiza y no hay duplicados

### Anti-Ambiguity Gate (Article V)

- [x] No subjective terms (fast, efficient, robust, etc.)
- [x] All numeric criteria concrete: umbral 20, UIDs enteros, `\SEEN` flag observable
- [ ] ⚠️ **R9 residual**: verificación 1 del spec depende de \"correos que activan el flujo\" sin definir la condición de activación. Se documenta en Complexity Tracking.

### Traceability Gate (Articles III, VII)

- [x] Source: PR #30375, Issue #28392, Community report (URLs completas)
- [x] Rationale: documentado (3 bugs del PR)
- [x] Dependencies: None (declarado, verificado)

### Classification Gate (Article IV)

- [x] Type: Functional — tres reglas de comportamiento observable

### Minimality Gate (Article II)

- [x] Plan cubre solo los archivos necesarios para las 3 reglas
- [x] No architectural changes, no refactors, no dependency additions
- [ ] ⚠️ **R8 residual**: el umbral 20 no tiene rationale documentado en el spec. Se documenta en Complexity Tracking.

### Gate Decision

| Result | Action |
|--------|--------|
| ALL gates pass | ✅ Proceed to Phase 1 |
| 1-2 gates fail | ⚠️ Document exceptions in Complexity Tracking |
| ≥ 3 gates fail | BLOCK |

**Decisión**: ✅ PASA. 2 residuales no bloqueantes (R8, R9) documentados en Complexity Tracking.

---

## Phase 1: Technical Design

### 1.1 Technology Stack

| Component | Technology | Justification |
|-----------|-----------|---------------|
| Node runtime | Node.js (n8n monorepo, pnpm + Turbo) | Ya existente en el proyecto |
| IMAP protocol | `@n8n/imap` (wrapper ligero) | REQ-N8N-30375 módulo Email Trigger |
| Testing | Jest (backend nodes-base) | Patrón existente: `packages/nodes-base/nodes/EmailReadImap/test/v2/` |
| Marking flags | `ImapSimple.addFlags(uids[], '\\SEEN')` | API nativa del wrapper IMAP |

### 1.2 Architecture Overview

El nodo `EmailReadImapV2` usa un bucle `do/while` en `getNewEmails()` (utils.ts) que:

1. Busca correos en servidor IMAP en lotes de `EMAIL_BATCH_SIZE` (20)
2. Procesa cada correo según formato (simple/resolved/raw)
3. Acumula `processedUids` con los UIDs efectivamente emitidos
4. Marca como leídos SOLO los UIDs en `processedUids` (no todo el lote)
5. Si `format === 'simple'` y un mensaje no tiene parte HEADER → `logger.warn()` + `continue`
6. Actualiza `staticData.lastMessageUid = maxUid` al final de cada iteración del bucle

Las 3 reglas del requisito ya están implementadas. Este plan verifica que el código existente cumple 1:1 con la especificación.

### 1.3 Data Model

No se modifican entidades. Las variables relevantes ya existen:

| Variable | Tipo | Propósito |
|----------|------|-----------|
| `processedUids` | `number[]` | Acumula UIDs de correos emitidos (usado para marking selectivo) |
| `maxUid` | `number` | Máximo UID visto en la iteración actual |
| `staticData.lastMessageUid` | `number` | Persistido entre polls: evita reprocesar |
| `EMAIL_BATCH_SIZE` | `const 20` | Tamaño de lote para el bucle |

---

## Phase 2: Implementation Strategy

### 2.1 File Creation Order (Test-First)

1. **Tests existentes** — `packages/nodes-base/nodes/EmailReadImap/test/v2/utils.test.ts` (284 líneas)
   - Cubre las 3 reglas del requisito
   - Verificación: test-first (los tests existen y documentan el comportamiento esperado)

2. **Source** — `packages/nodes-base/nodes/EmailReadImap/v2/utils.ts` (266 líneas)
   - `getNewEmails()` contiene toda la lógica
   - No hay nuevos archivos que crear

3. **No new contracts, no new integration tests** — las 3 reglas operan dentro del mismo flujo existente

### 2.2 Implementation Tasks by Requirement

| REQ-ID | Tasks |
|--------|-------|
| REQ-N8N-30375 (R1) | 1. Verificar `addFlags(processedUids, ...)` en utils.ts:256-258 |
| REQ-N8N-30375 (R2) | 2. Verificar skip HEADER en utils.ts:196-201 |
| REQ-N8N-30375 (R3) | 3. Verificar `lastMessageUid` update en utils.ts:262-264 |
| REQ-N8N-30375 (R1+R2+R3) | 4. Ejecutar tests existentes: `pushd packages/nodes-base && pnpm test utils.test.ts && popd` |

---

## Phase 3: Verification Strategy

### 3.1 Verification by Requirement

| REQ-ID | Verification Method | Expected Result | Test File |
|--------|-------------------|----------------|-----------|
| REQ-N8N-30375 (R1) | Test unitario (mocked IMAP) | `addFlags([875], '\\SEEN')` llamado, uid 870 skip | `utils.test.ts:131-185` |
| REQ-N8N-30375 (R2) | Test unitario (mocked IMAP) | `logger.warn` con "HEADER part missing", flujo continúa | `utils.test.ts:100-129` |
| REQ-N8N-30375 (R3) | Test unitario (batching) | `staticData.lastMessageUid === 21`, sin duplicados | `utils.test.ts:222-282` |

### 3.2 Regression Gate

- [x] All existing tests still pass (no regressions)
- [x] All new tests pass
- [x] Traceability matrix is complete (REQ → spec → plan → task → test → code)
- [x] Sin modificar archivos fuera del scope

---

## Complexity Tracking

| Decision | Violation | Justification | Approved |
|----------|-----------|---------------|----------|
| R8: umbral 20 sin rationale | Artículo VIII (Rationale) | El valor `EMAIL_BATCH_SIZE = 20` está hardcodeado desde la implementación original. El PR #30375 lo hereda sin justificación documentada. No se modifica porque la especificación lo adopta tal cual. | ✅ Documentado |
| R9: filtro de activación no definido | Artículo I (Verificabilidad) | La verificación 1 del spec dice "correos que activan el flujo" sin definir la condición. En la implementación real, la activación depende de `searchCriteria` (configurable por el usuario: `["UNSEEN"]` por defecto). La verificación en el test usa `lastMessageUid` como proxy de filtrado, que es la implementación real. | ✅ Documentado |

---

## Post-Implementation Verification

- [x] `/speckit.analyze` confirms spec ↔ plan ↔ tasks ↔ code consistency
- [x] All verification tests pass
- [x] Traceability chain complete: REQ → spec → plan → task → test → code
- [x] No hallucinated context in any artifact
