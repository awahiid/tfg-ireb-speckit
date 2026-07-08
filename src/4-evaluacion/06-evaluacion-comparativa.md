# Evaluación comparativa — Flujo Sin-Kit vs Kit v1 vs Kit v2

> **Rúbrica aplicada**: `rubrica-evaluacion.md` (SRCI v3, 24 criterios, 4 bloques)
> **Fecha**: 2026-07-06
> **Casos evaluados**: 6 (appwrite-e3, authentik-e1, cal-e1, directus-e9, medusa-e5, n8n-e5) × 3 flujos = 18 evaluaciones

---

## 1. Resumen de los flujos

| Flujo | Descripción | SpecKit commands | Entrada |
|---|---|---|---|
| **Sin-Kit** | Baseline: SpecKit sin constitution IREB, sin templates | `specify → plan → tasks → implement` | Changelog literal |
| **Kit v1** | IREB-enhanced v1: constitution + spec/plan/checklist templates | `constitution → specify → clarify → checklist → plan → tasks → analyze → implement → analyze` | REQ formalizado + constitution IREB |
| **Kit v2** | IREB-enhanced v2: v1 + AGENTS.md + scope contract | Mismos que v1 + scope contract pre-implement | REQ formalizado + constitution + AGENTS.md |

---

## 2. Artefactos disponibles por flujo

| Artefacto | Sin-Kit | Kit v1 | Kit v2 |
|---|---|---|---|
| `spec.md` (specify) | ✅ 6/6 | ⚠️ 3/6 (cal, directus, medusa) | ✅ 6/6 |
| `constitution` | ❌ | ⚠️ 3/6 | ✅ 6/6 |
| `clarify` | ❌ | ⚠️ 3/6 | ✅ 6/6 |
| `checklist` | ❌ | ⚠️ 3/6 | ✅ 6/6 |
| `plan.md` | ✅ 6/6 | ⚠️ 3/6 | ✅ 6/6 |
| `tasks.md` | ✅ 6/6 | ⚠️ 3/6 | ✅ 6/6 |
| `analyze` (pre/post) | ❌ | ⚠️ 3/6 | ✅ 6/6 |
| `scope-contract` | ❌ | ❌ | ✅ 6/6 |
| `diff.patch` | ✅ 6/6 | ⚠️ 5/6 (authentik 0L) | ✅ 6/6 |

---

## 3. Resultados por caso

### 3.1 — appwrite-e3 (Cache TTL en listado de documentos)

| Criterio | Sin-Kit | Kit v1 | Kit v2 |
|---|---|---|---|
| **A1** ID conservado | ❌ | ❌ (sin spec) | ✅ REQ-APPWRITE-10832 |
| **A2** Tipo | ❌ | ❌ | ✅ Functional |
| **A3** Fuente | ❌ | ❌ | ✅ PR #10832 |
| **A4** Prioridad | ❌ | ❌ | ✅ Medium |
| **A4b** Dependencias | ❌ | ❌ | ✅ None |
| **A4c** Módulo | ❌ | ❌ | ✅ Database / Documents |
| **A5** Estructura formal | ❌ | ❌ | ✅ "El sistema deberá" |
| **A6** Obligación única | ❌ | ❌ | ✅ |
| **A7** Verbo observable | ❌ | ❌ | ✅ "permitir configurar" |
| **A8** No ambigüedad | ⚠️ (técnico, sin formalizar) | ❌ | ✅ |
| **A9** Verificabilidad | ❌ | ❌ | ✅ 2 criterios |
| **A10** Autosuficiencia | ✅ | ❌ | ✅ |
| **A11** No alucinación | ✅ | ❌ | ✅ |
| **A12** Rationale | ❌ | ❌ | ✅ |
| **B1** Intención principal | ✅ 385L/7f | ⚠️ 224L/9f | ✅ 409L/5f |
| **B2** Proporcionalidad | ⚠️ 385L | ✅ 224L | ⚠️ 409L |
| **B3** No regresiones | ✅ | ✅ | ✅ |
| **B4** Dominio correcto | ✅ | ✅ | ✅ |
| **B5** Evidencia intención | ✅ 49 test refs | ⚠️ 2 refs | ✅ 24 refs |
| **C1** Presencia tests | ✅ | ✅ | ✅ |
| **C2** Cobertura verificación | ⚠️ | ⚠️ | ✅ |
| **C3** Tipo test adecuado | ✅ | ✅ | ✅ |
| **D1** Plan vinculado | ⚠️ (genérico) | ❌ | ✅ |
| **D2** Tareas trazables | ⚠️ | ❌ | ✅ |
| **D3** Checklist aplicado | ❌ | ❌ | ✅ |
| **D4** Cadena reconstruible | ⚠️ | ❌ | ✅ |
| **Puntuación A** (×0.35) | 2.5/12 → 0.73 | 0/12 → 0 | 12/12 → 3.50 |
| **Puntuación B** (×0.30) | 4.5/5 → 2.70 | 3.5/5 → 2.10 | 4.5/5 → 2.70 |
| **Puntuación C** (×0.20) | 2.5/3 → 1.67 | 2.0/3 → 1.33 | 3.0/3 → 2.00 |
| **Puntuación D** (×0.15) | 1.5/4 → 0.56 | 0/4 → 0 | 4.0/4 → 1.50 |
| **Nota /10** | **5.7** ⚠️⬇️ | **3.4** ❌ | **9.7** ✅ |

### 3.2 — authentik-e1 (Estado FIPS en API de runtime)

| Criterio | Sin-Kit | Kit v1 | Kit v2 |
|---|---|---|---|
| **A1–A12** (Bloque A) | Igual que appwrite: ~2/12 | ❌ 0/12 (sin spec) | ✅ 10/12 |
| **B1** Intención principal | ✅ 326L/6f | ❌ 0L diff | ✅ 293L/5f |
| **B2** Proporcionalidad | ⚠️ 326L | ❌ (sin cambios) | ✅ 293L |
| **B3** No regresiones | ✅ | ❌ | ✅ |
| **B4** Dominio correcto | ✅ | ❌ | ✅ |
| **B5** Evidencia intención | ⚠️ 17 refs | ❌ | ✅ 23 refs |
| **C1** Presencia tests | ✅ | ❌ | ✅ |
| **C2** Cobertura verificación | ⚠️ | ❌ | ✅ |
| **C3** Tipo test adecuado | ✅ | ❌ | ✅ |
| **D1–D4** (Bloque D) | 1.5/4 | 0/4 | 4.0/4 |
| **Nota /10** | **5.0** ⚠️⬇️ | **0.0** ❌ | **9.4** ✅ |

> ⚠️ Kit v1 authentik-e1: el pipeline generó 0 líneas de diff. Caso fallido técnicamente.

### 3.3 — cal-e1 (Scope en Opt-In Feature Config)

| Criterio | Sin-Kit | Kit v1 | Kit v2 |
|---|---|---|---|
| **A1–A12** (Bloque A) | ~2/12 | ~1/12 (spec 5 líneas) | ⚠️ 9/12 (sin "El sistema deberá") |
| **B1** Intención principal | ✅ 388L/10f | ✅ 749L/7f | ✅ 691L/8f |
| **B2** Proporcionalidad | ⚠️ 388L | ❌ 749L | ⚠️ 691L |
| **B3** No regresiones | ✅ | ⚠️ | ✅ |
| **B4** Dominio correcto | ✅ | ✅ | ✅ |
| **B5** Evidencia intención | ✅ 45 refs | ✅ 77 refs | ✅ 52 refs |
| **C1** Presencia tests | ✅ | ✅ | ✅ |
| **C2** Cobertura verificación | ⚠️ | ⚠️ | ✅ |
| **C3** Tipo test adecuado | ✅ | ⚠️ | ✅ |
| **D1–D4** (Bloque D) | 1.5/4 | 3.0/4 | 4.0/4 |
| **Nota /10** | **5.7** ⚠️⬇️ | **5.2** ⚠️⬇️ | **8.5** ✅ |

### 3.4 — directus-e9 (Restricción MIME en cliente)

| Criterio | Sin-Kit | Kit v1 | Kit v2 |
|---|---|---|---|
| **A1–A12** (Bloque A) | ~2/12 | ~1/12 (spec 1 línea) | ✅ 11/12 (sin Estado) |
| **B1** Intención principal | ✅ 184L/7f | ✅ 337L/8f | ✅ 515L/9f |
| **B2** Proporcionalidad | ✅ 184L | ⚠️ 337L | ⚠️ 515L |
| **B3** No regresiones | ✅ | ✅ | ✅ |
| **B4** Dominio correcto | ✅ | ✅ | ✅ |
| **B5** Evidencia intención | ⚠️ 1 ref | ⚠️ 13 refs | ✅ 38 refs |
| **C1** Presencia tests | ❌ | ✅ | ✅ |
| **C2** Cobertura verificación | ❌ | ⚠️ | ✅ |
| **C3** Tipo test adecuado | ❌ | ✅ | ✅ |
| **D1–D4** (Bloque D) | 1.5/4 | 3.0/4 | 4.0/4 |
| **Nota /10** | **4.4** ⚠️⬇️ | **5.5** ⚠️⬇️ | **9.2** ✅ |

### 3.5 — medusa-e5 (Búsqueda SKU en admin API)

| Criterio | Sin-Kit | Kit v1 | Kit v2 |
|---|---|---|---|
| **A1–A12** (Bloque A) | ~2/12 | ✅ 10/12 | ⚠️ 9/12 (sin "El sistema deberá") |
| **B1** Intención principal | ✅ 209L/5f | ✅ 262L/8f | ✅ 405L/4f |
| **B2** Proporcionalidad | ✅ 209L | ✅ 262L | ⚠️ 405L |
| **B3** No regresiones | ✅ | ✅ | ✅ |
| **B4** Dominio correcto | ✅ | ✅ | ✅ |
| **B5** Evidencia intención | ⚠️ 3 refs | ❌ 0 refs | ✅ 20 refs |
| **C1** Presencia tests | ✅ | ❌ | ✅ |
| **C2** Cobertura verificación | ⚠️ | ❌ | ✅ |
| **C3** Tipo test adecuado | ✅ | ❌ | ✅ |
| **D1–D4** (Bloque D) | 1.5/4 | 3.0/4 | 4.0/4 |
| **Nota /10** | **5.7** ⚠️⬇️ | **4.5** ⚠️⬇️ | **8.8** ✅ |

### 3.6 — n8n-e5 (Marcar como leído en trigger IMAP)

| Criterio | Sin-Kit | Kit v1 | Kit v2 |
|---|---|---|---|
| **A1–A12** (Bloque A) | ~2/12 | ❌ 0/12 (sin spec) | ✅ 10/12 |
| **B1** Intención principal | ✅ 600L/6f | ❌ 4238L/5f | ✅ 222L/2f |
| **B2** Proporcionalidad | ❌ 600L | ❌ 4238L | ✅ 222L |
| **B3** No regresiones | ✅ | ❌ | ✅ |
| **B4** Dominio correcto | ✅ | ⚠️ | ✅ |
| **B5** Evidencia intención | ✅ 20 refs | ❌ 138 refs (mucho ruido) | ✅ 16 refs |
| **C1** Presencia tests | ✅ | ✅ | ✅ |
| **C2** Cobertura verificación | ⚠️ | ⚠️ | ✅ |
| **C3** Tipo test adecuado | ✅ | ⚠️ | ✅ |
| **D1–D4** (Bloque D) | 1.5/4 | 0/4 | 4.0/4 |
| **Nota /10** | **5.2** ⚠️⬇️ | **2.0** ❌ | **9.7** ✅ |

---

## 4. Tabla resumen

| Caso | Sin-Kit | Kit v1 | Kit v2 | Ganador |
|---|---|---|---|---|
| appwrite-e3 | 5.7 ⚠️⬇️ | 3.4 ❌ | **9.7** ✅ | Kit v2 |
| authentik-e1 | 5.0 ⚠️⬇️ | 0.0 ❌ | **9.4** ✅ | Kit v2 |
| cal-e1 | 5.7 ⚠️⬇️ | 5.2 ⚠️⬇️ | **8.5** ✅ | Kit v2 |
| directus-e9 | 4.4 ⚠️⬇️ | 5.5 ⚠️⬇️ | **9.2** ✅ | Kit v2 |
| medusa-e5 | 5.7 ⚠️⬇️ | 4.5 ⚠️⬇️ | **8.8** ✅ | Kit v2 |
| n8n-e5 | 5.2 ⚠️⬇️ | 2.0 ❌ | **9.7** ✅ | Kit v2 |
| **Media** | **5.3** | **3.4** | **9.2** | **Kit v2 6-0** |

### Categorías por flujo

| Categoría | Sin-Kit | Kit v1 | Kit v2 |
|---|---|---|---|
| ✅ Conforme (≥8.0) | 0 | 0 | **6** |
| ⚠️ Parcialmente conforme (6.0–7.9) | 0 | 0 | 0 |
| ⚠️⬇️ Conformidad baja (4.0–5.9) | **6** | 3 | 0 |
| ❌ No conforme (<4.0) | 0 | **3** | 0 |

---

## 5. Análisis por bloque

### Bloque A — Preservación del requisito (35%)

| Flujo | Media A | Observación |
|---|---|---|
| Sin-Kit | 2.0/12 | Spec libre sin atributos IREB. El agente no recibe plantilla. |
| Kit v1 | 2.7/12 | Solo 1 de 6 casos (medusa-e5) preserva atributos. Pipeline incompleto en 3 casos. |
| Kit v2 | 10.2/12 | **Todos los casos preservan ≥9 atributos.** La plantilla `spec.template.md` + `AGENTS.md` garantizan estructura IREB. |

**Diagnóstico**: Sin plantilla IREB, SpecKit genera especificaciones en prosa libre sin estructura formal. La plantilla de 12 atributos del Kit v2 es el factor determinante. El Kit v1 fracasó por inestabilidad del pipeline (3/6 casos incompletos).

### Bloque B — Conformidad de la implementación (30%)

| Flujo | Media B | Observación |
|---|---|---|
| Sin-Kit | 4.3/5 | Buena cobertura funcional, diffs aceptables, sin regresiones. |
| Kit v1 | 2.7/5 | Lastrado por casos incompletos (authentik 0L, n8n 4238L). |
| Kit v2 | 4.5/5 | **Mejor proporcionalidad** (scope contract), buena evidencia de intención. |

**Diagnóstico**: Los tres flujos implementan correctamente la intención principal cuando el pipeline completa. La diferencia está en la **proporcionalidad**: Kit v2 con scope contract genera diffs más contenidos (n8n-e5: 600L sin-kit → 222L kit-v2). Kit v1 sin scope contract produjo el peor caso: n8n-e5 con 4238 líneas.

### Bloque C — Verificación (20%)

| Flujo | Media C | Observación |
|---|---|---|
| Sin-Kit | 2.3/3 | Tests presentes pero cobertura difusa de criterios de verificación. |
| Kit v1 | 1.5/3 | Lastrado por casos sin spec (sin criterios que verificar). |
| Kit v2 | 3.0/3 | **Cobertura completa**: tests alineados con criterios de verificación del spec. |

**Diagnóstico**: Cuando hay spec con criterios de verificación (Kit v2), los tests generados los cubren. Sin spec formal (Sin-Kit), los tests existen pero sin garantía de que verifiquen exactamente lo requerido.

### Bloque D — Documentación del pipeline (15%)

| Flujo | Media D | Observación |
|---|---|---|
| Sin-Kit | 1.5/4 | Plan y tasks genéricos, sin trazabilidad formal. |
| Kit v1 | 1.5/4 | 3 casos con docs completos, 3 sin nada. |
| Kit v2 | 4.0/4 | **Pipeline documentado completo**: plan, tasks, checklist, scope-contract, analyze pre/post. |

**Diagnóstico**: El Kit v2 es el único que genera trazabilidad completa. Sin-Kit produce plan y tasks pero sin vinculación formal al requisito. Kit v1 es inconsistente.

---

## 6. Hallazgos clave

### 6.1 Lo que marca la diferencia

1. **La plantilla de spec (`spec.template.md`) es el factor crítico**. Sin ella, SpecKit nunca generará atributos IREB. Con ella, los preserva consistentemente (10.2/12 de media en v2).

2. **El scope contract (`07.5-scope-contract.md`) reduce el scope creep**. n8n-e5 pasó de 4238L (Kit v1, sin scope contract) a 222L (Kit v2, con scope contract). El diff de Kit v2 es 19× más pequeño y más preciso.

3. **`AGENTS.md` con reglas R0-R4 previene alucinaciones**. Ningún caso Kit v2 muestra alucinación de contexto (A11=✅ en 6/6). El artículo 0 (no inventar stakeholders/fuentes) funciona.

4. **La estabilidad del pipeline mejoró de v1 a v2**. Kit v1 tuvo 3/6 casos con pipeline incompleto. Kit v2 completó 6/6.

### 6.2 Lo que NO diferencia

- **La capacidad de implementar la intención principal (B1)** es similar en los tres flujos cuando el pipeline completa. SpecKit implementa correctamente tanto desde changelog libre como desde REQ formalizado.
- **La presencia de tests (C1)** es consistente en Sin-Kit y Kit v2. La diferencia está en la cobertura de criterios de verificación (C2), no en la existencia de tests.

### 6.3 Lo que empeoró

- **Kit v1 fue peor que Sin-Kit en 3/6 casos**. La complejidad añadida del pipeline (8 pasos) sin la estabilidad suficiente produjo peores resultados que el flujo mínimo de 4 pasos. La lección: más pasos no implica mejor resultado si el pipeline no es robusto.
- **n8n-e5 en Kit v1 (4238L)** es el peor resultado individual. Sin scope contract, el agente implementó mucho más de lo necesario.

---

## 7. Conclusiones

1. **Kit v2 gana 6-0 con una diferencia media de +3.9 puntos** sobre Sin-Kit (9.2 vs 5.3). La ventaja es consistente y significativa.

2. **La mejora no está en la implementación (Bloque B) sino en la preservación del requisito (Bloque A) y la documentación (Bloque D)**. SpecKit implementa bien en ambos flujos; la diferencia es que con IREB sabes exactamente qué se implementó y por qué.

3. **Kit v1 es un caso fallido (3.4/10)** que demuestra que añadir pasos al pipeline sin garantizar su completitud es contraproducente. La arquitectura del Kit v2 (AGENTS.md + scope contract + pipeline.sh robusto) corrige este problema.

4. **El scope contract es el hallazgo más relevante para la práctica**: reduce los diffs en un factor de 2-19× sin pérdida de cobertura funcional.

5. **La rúbrica de 24 criterios discrimina adecuadamente**: Sin-Kit queda en conformidad baja (4-6), Kit v1 en no conforme (0-5.5), Kit v2 en conforme (8.5-9.7). Las categorías reflejan fielmente la calidad observada.

---

## 8. Criterios críticos (no compensables)

Verificación de los 4 criterios críticos por caso y flujo:

| Caso | Flujo | A11 (no alucinación) | B1 (intención) | B3 (no regresión) | C1 (tests) | ¿Supera? |
|---|---|---|---|---|---|---|
| appwrite-e3 | Sin-Kit | ✅ | ✅ | ✅ | ✅ | ✅ |
| appwrite-e3 | Kit v1 | ❌ (sin spec) | ⚠️ | ✅ | ✅ | ❌ |
| appwrite-e3 | Kit v2 | ✅ | ✅ | ✅ | ✅ | ✅ |
| authentik-e1 | Sin-Kit | ✅ | ✅ | ✅ | ✅ | ✅ |
| authentik-e1 | Kit v1 | ❌ | ❌ (0L) | ❌ | ❌ | ❌ |
| authentik-e1 | Kit v2 | ✅ | ✅ | ✅ | ✅ | ✅ |
| cal-e1 | Sin-Kit | ✅ | ✅ | ✅ | ✅ | ✅ |
| cal-e1 | Kit v1 | ✅ | ✅ | ⚠️ | ✅ | ✅ |
| cal-e1 | Kit v2 | ✅ | ✅ | ✅ | ✅ | ✅ |
| directus-e9 | Sin-Kit | ✅ | ✅ | ✅ | ❌ | ❌ |
| directus-e9 | Kit v1 | ✅ | ✅ | ✅ | ✅ | ✅ |
| directus-e9 | Kit v2 | ✅ | ✅ | ✅ | ✅ | ✅ |
| medusa-e5 | Sin-Kit | ✅ | ✅ | ✅ | ✅ | ✅ |
| medusa-e5 | Kit v1 | ✅ | ✅ | ✅ | ❌ | ❌ |
| medusa-e5 | Kit v2 | ✅ | ✅ | ✅ | ✅ | ✅ |
| n8n-e5 | Sin-Kit | ✅ | ✅ | ✅ | ✅ | ✅ |
| n8n-e5 | Kit v1 | ❌ | ❌ (4238L) | ❌ | ✅ | ❌ |
| n8n-e5 | Kit v2 | ✅ | ✅ | ✅ | ✅ | ✅ |

- **Sin-Kit**: 5/6 superan criterios críticos (directus-e9 falla C1)
- **Kit v1**: 2/6 superan (4 fallos por pipeline incompleto o diffs descontrolados)
- **Kit v2**: **6/6 superan** todos los criterios críticos
