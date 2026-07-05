# Evaluación SRCI v2 — Resultados definitivos (MRS)

> **Fecha**: 2026-07-05 | **Rúbrica**: `rubrica-srci-v2.md` | **Input**: MRS de 2.5-prompts

---

## 1. Puntuaciones por caso

### appwrite-e3 — "Caché de listados con TTL"

| Bloque | Flow A | Flow B v2 | Diferencia |
|--------|--------|-----------|------------|
| A — Calidad requisito (7pt) | 4.0 | 1.5 | v2 es más estricto consigo mismo |
| B — Implementación (5pt) | 4.0 | 4.5 | v2 gana (REQ-ID en código) |
| C — Testing (3pt) | 3.0 | 3.0 | Empate |
| D — Documentación (5pt) | 0.0 | 5.0 | v2 gana (Flow A no genera docs) |
| **Total (20pt)** | **11.0** ⚠️ | **14.0** ⚠️ | **v2 +3.0** |

> v2 gana por documentación y trazabilidad. Flow A tiene mejor spec inicial pero sin estructura formal.

### authentik-e1 — "Exponer estado FIPS en API"

| Bloque | Flow A | Flow B v2 | Diferencia |
|--------|--------|-----------|------------|
| A — Calidad requisito (7pt) | 4.0 | 4.5 | v2 ligeramente mejor |
| B — Implementación (5pt) | 4.5 | 4.5 | Empate |
| C — Testing (3pt) | 3.0 | 2.0 | Flow A gana (tests más completos) |
| D — Documentación (5pt) | 0.0 | 5.0 | v2 gana |
| **Total (20pt)** | **11.5** ⚠️ | **16.0** ✅ | **v2 +4.5** |

> v2 alcanza categoría "Conforme". Flow A implementa bien pero sin trazabilidad documental.

### cal-e1 — "Ámbito para funcionalidades opt-in"

| Bloque | Flow A | Flow B v2 | Diferencia |
|--------|--------|-----------|------------|
| A — Calidad requisito (7pt) | 4.5 | 4.0 | Flow A ligeramente mejor |
| B — Implementación (5pt) | 4.0 | 3.5 | Flow A gana (menos scope creep) |
| C — Testing (3pt) | 3.0 | 3.0 | Empate |
| D — Documentación (5pt) | 0.0 | 5.0 | v2 gana |
| **Total (20pt)** | **11.5** ⚠️ | **15.5** ⚠️ | **v2 +4.0** |

> v2 gana por documentación pero Flow A tiene mejor implementación (más enfocada).

### directus-e9 — "Restricción MIME en UI de subida"

| Bloque | Flow A | Flow B v2 | Diferencia |
|--------|--------|-----------|------------|
| A — Calidad requisito (7pt) | 4.5 | 4.0 | Flow A mejor spec |
| B — Implementación (5pt) | 4.5 | 3.5 | Flow A gana (server-side, más enfocado) |
| C — Testing (3pt) | 2.5 | 2.5 | Empate |
| D — Documentación (5pt) | 0.0 | 5.0 | v2 gana |
| **Total (20pt)** | **11.5** ⚠️ | **15.0** ⚠️ | **v2 +3.5** |

> v2 compensa con documentación lo que pierde en implementación.

### medusa-e5 — "Búsqueda por SKU en API admin"

| Bloque | Flow A | Flow B v2 | Diferencia |
|--------|--------|-----------|------------|
| A — Calidad requisito (7pt) | 4.0 | 4.0 | Empate |
| B — Implementación (5pt) | 4.0 | 4.5 | v2 gana (más enfocado) |
| C — Testing (3pt) | 3.0 | 3.0 | Empate |
| D — Documentación (5pt) | 0.0 | 5.0 | v2 gana |
| **Total (20pt)** | **11.0** ⚠️ | **16.5** ✅ | **v2 +5.5** |

> v2 alcanza "Conforme". Mejor implementación + documentación completa.

### n8n-e5 — "Corrección trigger IMAP"

| Bloque | Flow A | Flow B v2 | Diferencia |
|--------|--------|-----------|------------|
| A — Calidad requisito (7pt) | 4.0 | 4.5 | v2 mejor |
| B — Implementación (5pt) | 4.5 | 5.0 | v2 gana (código mínimo, preciso) |
| C — Testing (3pt) | 3.0 | 1.0 | Flow A gana (v2 apenas tiene tests) |
| D — Documentación (5pt) | 0.0 | 5.0 | v2 gana |
| **Total (20pt)** | **11.5** ⚠️ | **15.5** ⚠️ | **v2 +4.0** |

> v2 implementa con precisión quirúrgica pero sacrifica tests.

---

## 2. Tabla resumen

| Caso | Flow A | Flow B v2 | Ganador | Categoría v2 |
|------|--------|-----------|---------|-------------|
| appwrite-e3 | 11.0 ⚠️ | 14.0 ⚠️ | v2 | Parcialmente conforme |
| authentik-e1 | 11.5 ⚠️ | **16.0** ✅ | v2 | **Conforme** |
| cal-e1 | 11.5 ⚠️ | 15.5 ⚠️ | v2 | Parcialmente conforme |
| directus-e9 | 11.5 ⚠️ | 15.0 ⚠️ | v2 | Parcialmente conforme |
| medusa-e5 | 11.0 ⚠️ | **16.5** ✅ | v2 | **Conforme** |
| n8n-e5 | 11.5 ⚠️ | 15.5 ⚠️ | v2 | Parcialmente conforme |
| **Media** | **11.3** | **15.4** | **v2 6-0** | |

---

## 3. Fortalezas y debilidades por flujo

### Flow A (sin kit)

**Fortalezas**:
- Mejor calidad de spec inicial (A1-A7): 4.2/7 de media, más directo y menos autocritico
- Buena implementación funcional (B1-B3): consistente en todos los casos
- Buenos tests (C1-C3): 2.9/3 de media

**Debilidades**:
- ❌ Sin documentación formal (D1-D5 = 0 en todos los casos)
- ❌ Sin REQ-ID en el código (B4 = 0)
- ❌ Sin trazabilidad fuente→código (A4 = 0)

### Flow B v2 (kit IREB)

**Fortalezas**:
- ✅ Documentación completa (D1-D5 = 5.0 en todos los casos)
- ✅ Trazabilidad REQ-ID en código (B4 = 1.0)
- ✅ Mejor control de scope en requisitos complejos (n8n-e5: 6L vs 600L)
- ✅ Clarify detecta alucinaciones (A6 se autocorrige)

**Debilidades**:
- ⚠️ Spec inicial a veces peor que Flow A (A1-A3 más estricto = más fallos)
- ⚠️ A veces sacrifica tests por minimalidad (n8n-e5 C = 1.0)
- ⚠️ Constitution añade ~216L de overhead

---

## 4. Conclusiones definitorias

### C1. El kit v2 gana 6-0 en puntuación SRCI

Con una media de 15.4/20 vs 11.3/20, el kit v2 supera a Flow A en todos los casos. La diferencia (+4.1 puntos) proviene casi enteramente del Bloque D (documentación), donde Flow A obtiene 0 sistemáticamente.

### C2. La documentación no es cosmética — es evaluable

El Bloque D (5 puntos) mide artefactos que son requisitos explícitos de IREB e ISO 29148: especificación formal (D1), detección de defectos (D2), control de calidad (D3), trazabilidad (D4) y scope contract (D5). Flow A no genera ninguno. El kit v2 los genera todos. Esto no es "más líneas", es cumplimiento normativo.

### C3. Flow A es mejor en spec inicial, pero esa ventaja no se traduce en mejor código

Flow A obtiene mejor puntuación en A1-A7 (4.2 vs 3.8) porque es menos estricto consigo mismo. Pero esa ventaja no se materializa en el Bloque B (implementación), donde ambos flujos empatan (4.2 vs 4.3). La calidad del código generado es similar, pero v2 añade trazabilidad.

### C4. El clarify del kit v2 es un arma de doble filo

El clarify detecta problemas reales (alucinaciones, ambigüedades) y los documenta, lo que baja la puntuación A6 del kit. Pero esta "autocrítica" es valiosa: Flow A no detecta sus propios defectos porque no tiene mecanismo para hacerlo.

### C5. Dos casos alcanzan "Conforme" (≥16/20)

authentik-e1 (16.0) y medusa-e5 (16.5) superan el umbral IREB/ISO con el kit v2. Los otros 4 casos quedan en "Parcialmente conforme" (14.0-15.5), lastrados principalmente por el Bloque A (spec) y ocasionalmente por testing insuficiente.

### C6. Recomendación final

**Usar Flow B v2 (kit IREB) como flujo principal.** La documentación generada (D1-D5) es el diferenciador clave: sin ella, el resultado no es auditable según IREB/ISO 29148. Para proyectos donde la trazabilidad y auditoría son requisitos, Flow A es insuficiente. Para prototipado rápido sin requisitos de cumplimiento, Flow A puede ser aceptable.
