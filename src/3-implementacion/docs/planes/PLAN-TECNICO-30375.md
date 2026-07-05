# Plan Técnico — REQ-N8N-30375

> **Versión**: 1.0 | **Fecha**: 2026-07-05 | **Spec**: `docs/req-n8n-30375.md`
> **Constitution**: IREB Requirements Engineering Constitution v1.0 (Artículos 0-IX)
> **Propósito**: Plan técnico con gates IREB: Verificabilidad, Trazabilidad, Anti-Ambigüedad, Clasificación

---

## Phase 0: Pre-Implementation Gates (IREB)

### Gate G1 — Verificabilidad (Artículo I)

Cada requisito debe tener un criterio de verificación observable.

| ID | Regla del spec | Criterio en spec | Observable | Método | Archivo de test |
|---|---|---|---|---|---|
| R1 | marcar como leídos solo correos procesados | Verificar en servidor IMAP que solo los que activaron el flujo tienen `\SEEN` | ✅ sí: `addFlags([875], '\\SEEN')` llamado; uid 870 skip | Test unitario (mocked IMAP + staticData) | `utils.test.ts:131-185` |
| R2 | omitir mensajes sin HEADER en modo simple | Verificar log `warn` y que el flujo no se desactiva | ✅ sí: `logger.warn` con "HEADER part missing" + `continue` | Test unitario (mocked IMAP sin HEADER) | `utils.test.ts:100-129` |
| R3 | actualizar `lastMessageUid` tras cada lote | Verificar que `lastMessageUid` se actualiza y no hay duplicados | ✅ sí: `staticData.lastMessageUid === 21` tras batch de 20+1 | Test unitario (batching 21 emails, 2 iteraciones) | `utils.test.ts:222-282` |

**Resultado**: ✅ PASA — Las 3 reglas tienen tests unitarios existentes que verifican comportamiento observable.

**Residual**: El spec describe verificación en "servidor IMAP real", pero los tests usan mocks. Esto es correcto para un test unitario (aisla la lógica del nodo del servidor real). Se documenta en §Complexity Tracking.

---

### Gate G2 — Anti-Ambigüedad (Artículo V)

Prohibición de términos subjetivos; uso de criterios cuantificables.

| Término en spec | Clasificación | Acción |
|---|---|---|
| `\SEEN` | Concreto — flag IMAP estándar RFC 3501 | ✅ |
| `lastMessageUid` | Concreto — entero, observable en staticData | ✅ |
| `umbral 20` | Concreto — entero, constante `EMAIL_BATCH_SIZE = 20` | ✅ |
| `procesados exitosamente` | ⚠️ Ambigüedad residual — ¿qué significa "éxito"? En implementación: el email pasa el filtro `searchCriteria`, es parseado sin error, y es emitido a `onEmailBatch`. | Documentado en Complexity Tracking |
| `fiabilidad` | ⚠️ Heredado del input original ("reliability"). El spec no lo usa; la formalización lo desambigua en 3 reglas concretas. | ✅ Resuelto por descomposición |

**Resultado**: ✅ PASA — Sin términos subjetivos en la especificación formal. La ambigüedad residual de "procesados exitosamente" se resuelve por implementación y se documenta.

---

### Gate G3 — Trazabilidad (Artículos III, VII)

Cada requisito debe tener Source y Rationale documentados.

| REQ-ID | Source | Rationale | ¿Completo? |
|---|---|---|---|
| REQ-N8N-30375 | PR #30375, Issue #28392, Community report (URLs completas) | 3 bugs documentados: pérdida de activaciones, detención silenciosa, duplicados | ✅ |

**Trazabilidad spec → plan → tasks → code → tests**:

```
REQ-N8N-30375
├── spec/req-n8n-30375.md
│   ├── R1 (marcado selectivo)
│   ├── R2 (omitir sin HEADER)
│   └── R3 (actualizar lastMessageUid)
├── plan/PLAN-N8N-30375.md
│   └── §2.2: tasks N8N-1 a N8N-7
├── tasks/TASK-DECOMPOSITION-N8N-30375.md
│   ├── N8N-1 → test R1 (utils.test.ts:131-185)
│   ├── N8N-2 → test R2 (utils.test.ts:100-129)
│   ├── N8N-3 → test R3 (utils.test.ts:222-282)
│   ├── N8N-4 → código R1 (utils.ts:256-258)
│   ├── N8N-5 → código R2 (utils.ts:196-201)
│   ├── N8N-6 → código R3 (utils.ts:262-264)
│   └── N8N-7 → ejecución de tests
├── code/utils.ts
│   ├── R1: línea 256 addFlags(processedUids, '\\SEEN')
│   ├── R2: línea 196 logger.warn + continue
│   └── R3: línea 262 staticData.lastMessageUid = maxUid
└── test/utils.test.ts
    ├── R1: test "should only mark processed emails as read"
    ├── R2: test "should skip emails with missing HEADER part"
    └── R3: test "should update lastMessageUid between batch iterations"
```

**Resultado**: ✅ PASA — Cadena completa reconstruible para las 3 reglas. Sin requisitos huérfanos ni código sin trazar.

---

### Gate G4 — Clasificación (Artículo IV)

Cada requisito debe clasificarse como Functional, Quality, o Constraint.

| REQ-ID | Tipo en spec | Subtipo | Justificación |
|---|---|---|---|
| REQ-N8N-30375 | Functional | Comportamiento condicional (3 reglas) | Describe qué hace el sistema: aplicar flags, omitir mensajes, actualizar UID |
| C-30375-01 | Constraint | Technology | "Operar dentro del nodo Email Trigger (IMAP) sin modificar otros nodos" |

**Resultado**: ✅ PASA — Clasificación correcta. La constraint está documentada en §3 del spec.

---

### Gate Decision

| Gate | Resultado | Acción |
|---|---|---|
| G1 — Verificabilidad | ✅ PASA | Tests existentes cubren las 3 reglas |
| G2 — Anti-Ambigüedad | ✅ PASA | 1 residual documentado en Complexity Tracking |
| G3 — Trazabilidad | ✅ PASA | Cadena spec→plan→tasks→code→tests completa |
| G4 — Clasificación | ✅ PASA | Functional + 1 Constraint |

**Decisión**: ✅ **ALL gates pass** — Proceder a Phase 1.

---

## Phase 1: Technical Design

### 1.1 Technology Stack

| Componente | Tecnología | Trazabilidad |
|---|---|---|
| Runtime | Node.js (n8n monorepo, pnpm + Turbo) | Existente en el proyecto |
| IMAP protocol | `@n8n/imap` (ImapSimple) | REQ-N8N-30375 módulo Email Trigger |
| Testing | Jest (backend nodes-base) | Patrón existente: `packages/nodes-base/nodes/EmailReadImap/test/v2/` |
| IMAP flags | `ImapSimple.addFlags(uids[], '\\SEEN')` | API nativa del wrapper IMAP |
| Logger | `ITriggerFunctions.logger.warn()` | REQ-N8N-30375 R2 |

### 1.2 Architecture Overview

El nodo `EmailReadImapV2` implementa un bucle `do/while` en `getNewEmails()` (`utils.ts`). Por cada iteración:

1. Busca correos en el servidor IMAP con `searchCriteria` y límite `EMAIL_BATCH_SIZE` (20)
2. Para cada formato (`simple`, `resolved`, `raw`):
   - Filtra correos ya vistos vía `lastMessageUid`
   - Acumula UIDs en `processedUids` solo para correos emitidos exitosamente
   - En modo `simple`, si un mensaje carece de parte HEADER → `logger.warn()` + `continue`
3. Fin del lote:
   - Si `postProcessAction === 'read'` → `addFlags(processedUids, '\\SEEN')` (marca solo los procesados)
   - Si `maxUid > staticData.lastMessageUid` → actualiza `staticData.lastMessageUid = maxUid`

Las 3 reglas del requisito **ya están implementadas en el código actual** (`utils.ts`). Este plan verifica que el código existente cumple 1:1 con la especificación y que los tests existentes lo confirman.

### 1.3 Data Model

No se crean ni modifican entidades. Variables del flujo existente:

| Variable | Tipo | Propósito | Regla |
|---|---|---|---|
| `processedUids` | `number[]` | Acumula UIDs de correos emitidos en la iteración | R1 |
| `maxUid` | `number` | Máximo UID visto en la iteración actual | R3 |
| `staticData.lastMessageUid` | `number` | Persistido entre polls; evita reprocesar | R3 |
| `EMAIL_BATCH_SIZE` | `const 20` | Tamaño de lote para el bucle `do/while` | R3 |

### 1.4 API Contracts

No hay nuevos endpoints. La función `getNewEmails` expone esta interfaz:

```typescript
async function getNewEmails(
  this: ITriggerFunctions,
  { imapConnection, searchCriteria, postProcessAction, getText, getAttachment, onEmailBatch }
): Promise<void>
```

Donde:
- `postProcessAction`: `"read"` | `"nothing"` | (otras) — controla R1
- `searchCriteria`: filtro IMAP — define qué correos "activan el flujo" (R1 depende de esto)
- `onEmailBatch`: callback que recibe los correos emitidos (R1, R2, R3 dependen de esto)

---

## Phase 2: Implementation Strategy

### 2.1 Orden Test-First

Este caso es una **verificación de conformidad**: el código y tests ya existen. No hay nuevo código que escribir. El orden es:

1. **Leer tests existentes** — entender el contrato especificado por `utils.test.ts`
2. **Leer código fuente** — confirmar que `utils.ts` implementa ese contrato
3. **Ejecutar tests** — confirmar que pasan (ver Phase 3)

No se crean archivos nuevos. No se modifican archivos existentes.

### 2.2 Tasks por Requisito

| REQ-ID | Tasks | Archivo | Línea(s) |
|---|---|---|---|
| R1 | Verificar que `addFlags` recibe solo `processedUids` | `utils.ts` | 256-258 |
| R1 | Ejecutar test de marcado selectivo | `utils.test.ts` | 131-185 |
| R2 | Verificar skip de mensajes sin HEADER con `logger.warn` + `continue` | `utils.ts` | 196-201 |
| R2 | Ejecutar test de omisión sin HEADER | `utils.test.ts` | 100-129 |
| R3 | Verificar actualización de `staticData.lastMessageUid` tras cada lote | `utils.ts` | 262-264 |
| R3 | Ejecutar test de batching | `utils.test.ts` | 222-282 |
| R1+R2+R3 | Ejecutar suite completa de tests del nodo IMAP | — | — |

### 2.3 Scope Contract

| Acción | Permitido |
|---|---|
| Archivos a crear | 0 |
| Archivos a modificar | 0 |
| Archivos a leer para verificación | 2 (`utils.ts`, `utils.test.ts`) |
| Nuevas dependencias | 0 |
| Refactorización | 0 |
| Cambios arquitectónicos | 0 |

---

## Phase 3: Verification Strategy

### 3.1 Verificación por Requisito

| REQ-ID | Método | Resultado esperado | Test file |
|---|---|---|---|
| R1 | Test unitario (mocked IMAP + staticData `lastMessageUid: 873`) | `addFlags([875], '\\SEEN')` llamado una vez; uid 870 skip | `utils.test.ts:131-185` |
| R1 (edge) | Test unitario (todos filtrados por `lastMessageUid`) | `addFlags` NO llamado; `onEmailBatch` con `[]` | `utils.test.ts:187-220` |
| R2 | Test unitario (mensaje sin parte HEADER, modo simple) | `logger.warn` con "HEADER part missing"; flujo continúa | `utils.test.ts:100-129` |
| R3 | Test unitario (2 batches: 20 + 1 correos) | `onEmailBatch` 2 veces; `lastMessageUid === 21`; sin duplicados | `utils.test.ts:222-282` |

### 3.2 Comando de ejecución

```bash
pushd packages/nodes-base && pnpm test utils.test.ts && popd
```

### 3.3 Regression Gate

- [ ] Todos los tests existentes pasan (sin regresiones)
- [ ] La cadena de trazabilidad se mantiene completa
- [ ] Sin archivos modificados fuera del scope contract

---

## Complexity Tracking

| Decisión | Violación | Justificación | Aprobado |
|---|---|---|---|
| R1: filtro de activación no definido en verificación | Artículo I (Verificabilidad) | El spec dice "correos que activan el flujo" sin definir la condición de activación. En la implementación real, la activación depende de `searchCriteria` y `lastMessageUid`. Los tests usan `lastMessageUid` como proxy, que es la implementación real documentada en el código. | ✅ Documentado |
| R3: umbral 20 sin rationale | Artículo VIII (Rationale) | `EMAIL_BATCH_SIZE = 20` está hardcodeado desde la implementación original. El PR #30375 lo hereda sin justificación. El spec lo adopta tal cual. No se modifica. | ✅ Documentado |
| "procesados exitosamente" en verificación 1 del spec | Artículo V (Ambigüedad) | El spec no define "éxito". En la implementación: un correo se considera procesado si pasa el filtro `searchCriteria` + `lastMessageUid`, es parseado sin error, y es emitido a `onEmailBatch`. Esto queda implícito en la implementación. | ✅ Documentado |

---

## Post-Implementation Verification

- [ ] `/speckit.analyze` confirma consistencia spec ↔ plan ↔ code ↔ tests
- [ ] Todos los tests de verificación pasan
- [ ] Cadena de trazabilidad completa: REQ → spec → plan → tasks → code → tests
- [ ] Sin alucinaciones de contexto en ningún artefacto (Artículo 0)
- [ ] Scope contract respetado (0 archivos creados, 0 modificados)
