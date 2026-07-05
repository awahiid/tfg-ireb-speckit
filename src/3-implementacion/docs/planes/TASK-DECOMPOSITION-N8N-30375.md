# Task Decomposition — REQ-N8N-30375

> **Date**: 2026-07-03 | **Constitution**: IREB Requirements Engineering Constitution v1.0
> **Source plan**: `PLAN-N8N-30375.md`

---

## REQ-N8N-30375 — Corrección del procesamiento de correos IMAP

### Tasks

| ID | Prioridad | Descripción | Archivos | Dependencias | P |
|----|-----------|-------------|----------|-------------|---|
| N8N-1 | Alta | Verificar R1: test unitario de marcado selectivo (`addFlags` solo para correos emitidos) | `n8n-e5/packages/nodes-base/nodes/EmailReadImap/test/v2/utils.test.ts` | Ninguna | ✅ |
| N8N-2 | Alta | Verificar R2: test unitario de omisión de mensajes sin HEADER en modo simple | `n8n-e5/packages/nodes-base/nodes/EmailReadImap/test/v2/utils.test.ts` | Ninguna | ✅ |
| N8N-3 | Alta | Verificar R3: test unitario de actualización de `lastMessageUid` entre lotes | `n8n-e5/packages/nodes-base/nodes/EmailReadImap/test/v2/utils.test.ts` | Ninguna | ✅ |
| N8N-4 | Alta | Confirmar que `addFlags` recibe `processedUids` (no todos los resultados) | `n8n-e5/packages/nodes-base/nodes/EmailReadImap/v2/utils.ts` | N8N-1 | |
| N8N-5 | Alta | Confirmar skip de mensajes sin HEADER con `logger.warn` + `continue` | `n8n-e5/packages/nodes-base/nodes/EmailReadImap/v2/utils.ts` | N8N-2 | |
| N8N-6 | Alta | Confirmar actualización de `staticData.lastMessageUid` tras cada lote | `n8n-e5/packages/nodes-base/nodes/EmailReadImap/v2/utils.ts` | N8N-3 | |
| N8N-7 | Alta | Ejecutar tests: `pnpm test utils.test.ts` sin regresiones | — | N8N-4, N8N-5, N8N-6 | |

### DAG

```
N8N-1 [P] ──→ N8N-4 ──┐
N8N-2 [P] ──→ N8N-5 ──→ N8N-7
N8N-3 [P] ──→ N8N-6 ──┘
```

---

## Mapeo REQ → Reglas → Tests

| Regla del spec | Código (utils.ts) | Test (utils.test.ts) |
|----------------|-------------------|---------------------|
| R1: marcar solo procesados | Línea 256-258: `addFlags(processedUids, '\\SEEN')` | Línea 131-185: "should only mark processed emails as read, not filtered-out ones" |
| R2: omitir sin HEADER | Línea 196-201: `logger.warn` + `continue` | Línea 100-129: "should skip emails with missing HEADER part in simple format" |
| R3: actualizar lastMessageUid | Línea 262-264: `staticData.lastMessageUid = maxUid` | Línea 222-282: "should update lastMessageUid between batch iterations to prevent duplicates" |

---

## Resumen

| Concepto | Valor |
|----------|-------|
| Total tareas | 7 |
| Tareas independientes [P] | 3 (N8N-1, N8N-2, N8N-3) |
| Profundidad máxima del DAG | 3 niveles |
| Ruta crítica | N8N-1 → N8N-4 → N8N-7 (3 pasos) |
| Archivos a tocar | 2 (utils.ts, utils.test.ts) |
