# Rúbrica de Evaluación SRCI v2 — IREB + ISO 29148 + INCOSE

> **Versión**: 2.0 | **Basada en**: IREB CPRE Foundation Level, ISO/IEC/IEEE 29148:2018, INCOSE Guide for Writing Requirements (2012)

---

## Bloque A — Calidad del requisito generado (Specify)
> *Evalúa el artefacto `02-specify.md` o equivalente*

| ID | Criterio | Fuente | Evaluación |
|----|----------|--------|------------|
| **A1** | **Verbo observable**. La descripción formal usa un verbo INCOSE (validar, rechazar, devolver, notificar, impedir). No usa verbos débiles (gestionar, manejar, soportar). | INCOSE §Structure [3] | ✅ Sí / ❌ No |
| **A2** | **Singularidad**. El requisito describe UNA sola capacidad. No mezcla obligaciones independientes. | ISO 29148 §6.2.2, INCOSE §Singular | ✅ Sí / ❌ No |
| **A3** | **No ambigüedad**. Sin términos subjetivos (rápido, eficiente, robusto, intuitivo, fácil). Los criterios usan valores concretos. | ISO 29148 §6.2.2, IREB §Requirements Documentation | ✅ Sí / ❌ No |
| **A4** | **Fuente trazable**. El campo Source referencia el PR/changelog original con identificador verificable. | IREB Glossary, ISO 29148 §6.3.1 | ✅ Sí / ❌ No |
| **A5** | **Rationale documentado**. El Rationale deriva del input original, no es inventado. | IREB §Requirements Documentation | ✅ Sí / ❌ No |
| **A6** | **No alucinación de contexto**. No se inventan stakeholders, objetivos de negocio, issues, o métricas no presentes en el MRS de entrada. | Article 0 (Constitution) | ✅ Sí / ❌ No |
| **A7** | **Criterio de verificación**. Existe al menos un criterio de verificación observable y concreto. | IREB §Verification, ISO 29148 §6.2.2 | ✅ Sí / ❌ No |

---

## Bloque B — Calidad de la implementación (Implement)
> *Evalúa el diff generado y el artefacto `08-implement.md`*

| ID | Criterio | Fuente | Evaluación |
|----|----------|--------|------------|
| **B1** | **Corrección funcional**. El código implementa el comportamiento descrito en el MRS. No implementa features no solicitados. | IREB §Validation | ✅ / ⚠️ Parcial / ❌ No |
| **B2** | **Scope control**. Solo se modifican archivos directamente relacionados con el requisito. No se tocan configuraciones globales, .env, AGENTS.md, ni constantes del sistema salvo que sean estrictamente necesarias. | Article II (Minimality) | ✅ / ⚠️ Parcial / ❌ No |
| **B3** | **No regresiones**. El código no borra ni reescribe funcionalidad existente no relacionada. No hay eliminaciones masivas de código previo. | IREB §Validation, ISO 25010 §Maintainability | ✅ / ⚠️ Parcial / ❌ No |
| **B4** | **Comentarios con REQ-ID**. Cada archivo modificado incluye una referencia al requisito (REQ-ID o PR) en su cabecera o comentarios. | Article III (Traceability) | ✅ / ⚠️ Parcial / ❌ No |
| **B5** | **No alucinación en código**. Los comentarios en el código no inventan stakeholders, objetivos ni fuentes falsas. | Article 0 | ✅ Sí / ❌ No |

---

## Bloque C — Verificación y testing
> *Evalúa la presencia y calidad de tests*

| ID | Criterio | Fuente | Evaluación |
|----|----------|--------|------------|
| **C1** | **Presencia de tests**. Existe al menos un test que verifica el comportamiento descrito en el requisito. | IREB §Verification, ISO 29148 §6.2.2 | ✅ Sí / ❌ No |
| **C2** | **Cobertura del criterio de verificación**. El test cubre el criterio de verificación definido en el requisito. | ISO 29148 §6.3.1 | ✅ / ⚠️ Parcial / ❌ No |
| **C3** | **Tests unitarios vs integración**. Los tests son apropiados para el tipo de cambio (unitarios para lógica, integración para APIs). | ISO 25010 §Testability | ✅ / ⚠️ Parcial / ❌ No |

---

## Bloque D — Documentación generada
> *Evalúa los artefactos documentales producidos*

| ID | Criterio | Fuente | Evaluación |
|----|----------|--------|------------|
| **D1** | **Especificación formal**. El requisito está documentado con estructura IREB (atributos: ID, Type, Source, Rationale, Verification...). | IREB §Requirements Documentation | ✅ / ⚠️ Parcial / ❌ No |
| **D2** | **Detección de defectos**. El clarify identifica ambigüedades, alucinaciones o problemas de calidad. | IREB §Validation | ✅ / ⚠️ Parcial / ❌ No |
| **D3** | **Control de calidad**. El checklist evalúa el requisito contra criterios ISO 29148. | ISO 29148 §6.2.2 | ✅ / ⚠️ Parcial / ❌ No |
| **D4** | **Matriz de trazabilidad**. El analyze conecta REQ → spec → tasks → code → tests. | IREB §Traceability, ISO 29148 §6.3.1 | ✅ / ⚠️ Parcial / ❌ No |
| **D5** | **Scope contract**. Existe un documento que acota explícitamente los archivos a modificar. | Article II (Minimality) | ✅ Sí / ❌ No |

---

## Puntuación

Cada ✅ = 1 punto, ⚠️ = 0.5 puntos, ❌ = 0 puntos.

| Bloque | Máximo | Peso |
|--------|--------|------|
| A — Calidad del requisito | 7 | 25% |
| B — Calidad de implementación | 5 | 30% |
| C — Verificación y testing | 3 | 25% |
| D — Documentación | 5 | 20% |
| **Total** | **20** | **100%** |

---

## Categorías finales

| Puntuación | Categoría | Significado |
|-----------|-----------|-------------|
| ≥ 16 | **Conforme** ✅ | Supera los criterios IREB/ISO. Apto para revisión formal. |
| 10-15 | **Parcialmente conforme** ⚠️ | Aceptable con deficiencias subsanables. |
| < 10 | **No conforme** ❌ | No supera los criterios mínimos. Requiere re-trabajo significativo. |
