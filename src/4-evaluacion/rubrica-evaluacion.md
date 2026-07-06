# Rúbrica de Evaluación SRCI v3 — IREB + ISO 29148 + INCOSE

> **Versión**: 3.0 | **Basada en**: IREB CPRE Foundation Level, ISO/IEC/IEEE 29148:2018, INCOSE Guide for Writing Requirements (2012)
>
> **Propósito**: evaluar la calidad de los artefactos generados por el pipeline SpecKit cuando recibe un requisito formalizado según IREB (Flow B). La rúbrica opera en dos niveles: (1) verificando que el `spec.md` generado por `/speckit.specify` preserva la calidad del requisito de entrada, aplicando la misma rúbrica de formalización de la Fase 2; y (2) evaluando la implementación resultante contra criterios pragmáticos de conformidad y trazabilidad.

---

## Contexto de aplicación

Esta rúbrica evalúa la salida completa del pipeline IREB-enhanced de SpecKit (Flow B). No evalúa el requisito de entrada (eso ya lo hizo la rúbrica de la Fase 2), sino **lo que SpecKit produce a partir de él**. El objetivo es determinar si el pipeline SDD, cuando recibe un requisito formalizado con atributos IREB, es capaz de:

1. **Preservar** la calidad del requisito en el artefacto `spec.md` generado por `/speckit.specify`.
2. **Traducir** ese requisito en una implementación conforme, verificable y trazable.

La evaluación es pragmática por diseño: reconoce que SpecKit es un agente LLM operando sobre un repositorio real, no una herramienta CASE formal. Los criterios se han calibrado para ser reproducibles (mayoritariamente binarios) pero no bloqueantes en exceso: un caso con deficiencias menores en un bloque puede compensarse en otros. El objetivo no es aprobar o suspender, sino **caracterizar** el grado de alineación del pipeline con las prácticas normativas de ingeniería de requisitos.

### Principios de diseño de la rúbrica

| Principio | Implicación |
|---|---|
| **Reproducibilidad** | Criterios binarios siempre que sea posible. Escala de tres niveles (✅/⚠️/❌) solo donde la evaluación binaria forzaría decisiones artificiales. |
| **Pragmatismo** | Los umbrales de aceptación reconocen que el pipeline opera sobre repositorios reales con restricciones técnicas. No se exige perfección normativa. |
| **Trazabilidad normativa** | Cada criterio referencia explícitamente la norma o estándar que lo justifica (IREB, ISO 29148, INCOSE). |
| **Evaluabilidad** | Todo criterio debe poder evaluarse con los artefactos disponibles: `spec.md`, `diff.patch`, tests generados y documentación del pipeline. |
| **Utilidad diagnóstica** | La puntuación por bloques permite identificar dónde falla el pipeline (especificación, implementación, verificación, documentación), no solo dar una nota global. |

---

## Bloques de evaluación

La rúbrica organiza sus criterios en cuatro bloques que siguen el flujo del pipeline SpecKit:

| Bloque | Artefacto evaluado | Origen en el pipeline | Propósito |
|---|---|---|---|
| **A — Preservación del requisito** | `spec.md` | `/speckit.specify` | Verificar que SpecKit conserva los 12 atributos IREB del requisito de entrada |
| **B — Conformidad de la implementación** | `diff.patch` | `/speckit.implement` | Evaluar si el código generado satisface el requisito sin desviaciones |
| **C — Verificación y testing** | Tests generados | `/speckit.implement` | Evaluar si los tests verifican el comportamiento especificado |
| **D — Documentación del pipeline** | `plan.md`, `tasks.md`, `checklist.md`, informes de `clarify`/`analyze` | Varios pasos | Evaluar si la documentación intermedia soporta trazabilidad y calidad |

---

## Bloque A — Preservación del requisito en spec.md

> **Fuente**: esta sección replica la rúbrica de validación de formalización de la Fase 2 (`src/2-requisitos/rubrica.md`), aplicada ahora sobre el `spec.md` generado por SpecKit.
>
> **Lo que se evalúa**: si el agente SpecKit, al ejecutar `/speckit.specify` sobre un `REQ-*.md` ya formalizado, **preserva** los atributos de calidad del requisito original o los degrada (pierde atributos, introduce ambigüedad, inventa contexto).
>
> **Criterio de evaluación**: binario (1 = conserva, 0 = degrada o ausente).

### A.1 — Identificación y gestión

| # | Criterio | Condición de cumplimiento | Justificación |
|---|---|---|---|
| **A1** | **Identificador único conservado** | El `spec.md` mantiene el ID del requisito de entrada con formato `REQ-[DOMINIO]-[NNN]`, sin duplicarlo ni alterarlo. | IEEE 29148 e IREB: la identificación única es esencial para trazabilidad. Si SpecKit cambia el ID, rompe la cadena de trazabilidad con el REQ original. |
| **A2** | **Clasificación conservada** | El Tipo se mantiene como uno de: Funcional, Calidad o Restricción, sin cambiarlo a otra categoría ni dejarlo vacío. | IREB distingue estas tres categorías. Un cambio de Tipo altera el significado del requisito. |
| **A3** | **Fuente conservada** | El `spec.md` preserva la referencia trazable al origen (versión, PR, changelog). No la sustituye por una fuente inventada ni la elimina. | IREB define Source como atributo de trazabilidad. ISO 29148 contempla fuentes documentales. Si SpecKit reescribe la fuente, la trazabilidad se corrompe. |
| **A4** | **Prioridad conservada** | La Prioridad se mantiene como Alta, Media o Baja. | IREB incorpora la prioridad para negociación y alcance. |
| **A4b** | **Dependencias conservadas** | Si el REQ original tiene dependencias documentadas, estas aparecen en el `spec.md`. Si no las tenía, no se inventan dependencias nuevas. | IREB define trazabilidad entre requisitos. Dependencias inventadas generan un grafo de requisitos ficticio. |
| **A4c** | **Módulo conservado** | El `spec.md` conserva la referencia al subsistema o componente funcional del REQ original. | La organización por módulos es práctica estándar en ISO 29148. |

### A.2 — Redacción y verificabilidad

| # | Criterio | Condición de cumplimiento | Justificación |
|---|---|---|---|
| **A5** | **Estructura formal conservada** | La descripción en `spec.md` mantiene el patrón "El sistema deberá [verbo] [objeto] [condición]". Si el REQ original tenía esta estructura, SpecKit no la degrada a prosa libre. | IEEE 29148 e INCOSE recomiendan estructura uniforme. Si SpecKit desestructura el requisito, se pierde precisión. |
| **A6** | **Obligación única conservada** | El requisito en `spec.md` sigue describiendo un único comportamiento. SpecKit no fusiona dos requisitos en uno ni descompone artificialmente uno en varios. | INCOSE exige singularidad. La fusión o fragmentación altera la unidad de verificación. |
| **A7** | **Verbo observable conservado** | El verbo principal sigue siendo observable (generar, registrar, rechazar, devolver, etc.). SpecKit no lo sustituye por un verbo débil (gestionar, manejar, soportar). | INCOSE exige verbos que permitan verificación objetiva. Un cambio de verbo altera la verificabilidad. |
| **A8** | **No introducción de ambigüedad** | El `spec.md` no introduce términos subjetivos (rápido, eficiente, robusto, adecuado) que no estuvieran en el REQ original. Si el original era preciso, el spec lo mantiene. | IEEE 29148 e INCOSE exigen requisitos no ambiguos. SpecKit no debe degradar la precisión del input. |
| **A9** | **Verificabilidad conservada** | El `spec.md` mantiene al menos un criterio de verificación observable. Si el REQ original tenía criterios concretos, estos no se diluyen ni se eliminan. | IEEE 29148 exige verificabilidad. Sin criterio de verificación, el requisito no puede evaluarse en fases posteriores. |

### A.3 — Completitud e integridad contextual

| # | Criterio | Condición de cumplimiento | Justificación |
|---|---|---|---|
| **A10** | **Autosuficiencia conservada** | El requisito en `spec.md` puede comprenderse sin consultar otros documentos. Si el original era autosuficiente, el spec no introduce referencias opacas a "el proceso anterior" o "el paso siguiente". | IEEE 29148 exige completitud. Un requisito que requiere consultar otros artefactos no es evaluable de forma independiente. |
| **A11** | **No alucinación de contexto** | El `spec.md` no introduce stakeholders, objetivos de negocio, issues, PRs, documentos ni fuentes que no estuvieran en el REQ de entrada. Si el input no menciona un "equipo de seguridad", el spec no lo inventa. | Artículo 0 de la constitución IREB: la integridad contextual es bloqueante. Inventar contexto corrompe la trazabilidad e introduce requisitos ficticios. |
| **A12** | **Rationale conservado** | El `spec.md` mantiene el Rationale del REQ original sin sustituirlo por una justificación genérica o inventada. Si el original documentaba "inferido", el spec lo respeta. | IREB define Rationale como justificación del requisito. Un rationale inventado falsea la motivación del cambio. |

### Quality gate del Bloque A

| Puntuación (máx. 12) | Resultado | Acción |
|---|---|---|
| **11–12** | **Preservación excelente** | SpecKit conserva la práctica totalidad de atributos IREB. |
| **9–10** | **Preservación aceptable** | Deficiencias menores que no afectan a A5, A7, A8, A9 ni A11. |
| **≤ 8** | **Degradación significativa** | El pipeline degrada la calidad del requisito. Las conclusiones sobre implementación deben contextualizarse. |

**Criterios críticos del Bloque A** (su incumplimiento invalida la evaluación de conformidad posterior): **A5** (estructura formal), **A7** (verbo observable), **A9** (verificabilidad), **A11** (no alucinación).

---

## Bloque B — Conformidad de la implementación

> **Lo que se evalúa**: si el código generado por `/speckit.implement` satisface el comportamiento descrito en el requisito, sin desviaciones funcionales relevantes ni scope creep.
>
> **Evidencia**: `diff.patch`, `changed-files.txt`.

| # | Criterio | Condición de cumplimiento | Evaluación | Justificación |
|---|---|---|---|---|
| **B1** | **Cobertura de la intención principal** | El diff contiene cambios que implementan la acción central del requisito. La funcionalidad principal está presente en el código generado. | ✅ Sí / ⚠️ Parcial / ❌ No | IREB §Validation: la implementación debe satisfacer el requisito. Sin la acción principal, el pipeline no ha cumplido su propósito. |
| **B2** | **Proporcionalidad del cambio** | El tamaño del diff es razonable para el tipo de requisito. Un cambio simple no genera >500 líneas; un cambio medio no genera >1000 líneas. Se valora la proporción, no un límite rígido. | ✅ Sí / ⚠️ Parcial / ❌ No | Artículo II (Minimality): implementar solo lo necesario. Diffs desproporcionados son síntoma de scope creep o alucinación. |
| **B3** | **No regresiones evidentes** | El diff no elimina funcionalidad existente no relacionada con el requisito. No se borran archivos completos, tests existentes ni configuraciones. | ✅ Sí / ❌ No | IREB §Validation, ISO 25010 §Maintainability. Una regresión invalida el caso como implementación conforme. |
| **B4** | **Correspondencia con el dominio técnico** | Los archivos modificados pertenecen a los módulos o componentes mencionados en el requisito. Un requisito sobre OAuth no modifica el módulo de facturación. | ✅ Sí / ⚠️ Parcial / ❌ No | Buenas prácticas de trazabilidad. Modificaciones fuera del dominio esperado sugieren desviación funcional o alucinación. |
| **B5** | **Evidencia de intención en el código** | El diff contiene elementos reconocibles del requisito: nombres de función, validaciones, mensajes de error, constantes o estructuras de datos que reflejan la intención especificada. No se exige coincidencia literal. | ✅ Sí / ⚠️ Parcial / ❌ No | Trazabilidad pragmática: sin necesidad de REQ-ID en comentarios, el código debe mostrar que responde al requisito. |

---

## Bloque C — Verificación

> **Lo que se evalúa**: si los tests generados por `/speckit.implement` verifican el comportamiento especificado en el requisito.
>
> **Evidencia**: tests en el diff, criterios de verificación en `spec.md`.

| # | Criterio | Condición de cumplimiento | Evaluación | Justificación |
|---|---|---|---|
| **C1** | **Presencia de tests** | Existe al menos un test nuevo o modificado en el diff que se relaciona con el requisito. | ✅ Sí / ❌ No | IREB §Verification, ISO 29148 §6.2.2. Sin tests, la implementación no es verificable. |
| **C2** | **Cobertura del criterio de verificación** | Al menos un test aborda el criterio de verificación definido en el requisito (mismo comportamiento observable, mismo resultado esperado). No se exige cobertura completa de todos los criterios. | ✅ Sí / ⚠️ Parcial / ❌ No | ISO 29148 §6.3.1: los criterios de verificación deben tener correspondencia con los tests. |
| **C3** | **Adecuación del tipo de test** | El test generado es apropiado para la naturaleza del requisito: test unitario para lógica interna, test de integración/API para endpoints. No se penaliza si el tipo no es óptimo pero es funcional. | ✅ Sí / ⚠️ Parcial / ❌ No | ISO 25010 §Testability. Un test inapropiado (mock de API para un cambio de UI) reduce la confianza en la verificación. |

---

## Bloque D — Trazabilidad del pipeline

> **Lo que se evalúa**: si los artefactos intermedios generados por el pipeline (`plan.md`, `tasks.md`, `checklist.md`) soportan la trazabilidad requisito → implementación y permiten reconstruir la cadena de decisiones.
>
> **Evidencia**: `plan.md`, `tasks.md`, `checklist.md`, informes de `clarify`/`analyze`.

| # | Criterio | Condición de cumplimiento | Evaluación | Justificación |
|---|---|---|---|
| **D1** | **Plan vinculado al requisito** | El `plan.md` referencia el requisito (por ID o por descripción) y sus decisiones técnicas son coherentes con él. No se exige trazabilidad exhaustiva REQ-ID por decisión. | ✅ Sí / ⚠️ Parcial / ❌ No | IREB §Traceability. Un plan sin vinculación al requisito es genérico y no soporta trazabilidad. |
| **D2** | **Tareas trazables** | Las tareas en `tasks.md` pueden relacionarse con el requisito. Si usan REQ-ID, se considera cumplido. Si no, basta con que describan trabajo coherente con el spec. | ✅ Sí / ❌ No | IREB §Requirements Management. La trazabilidad de tareas permite verificar que todo el trabajo planificado responde a un requisito. |
| **D3** | **Checklist aplicado** | El `checklist.md` contiene criterios aplicados al spec. Aunque la evaluación sea autoevaluación del LLM, su presencia indica que el pipeline ejecutó control de calidad. | ✅ Sí / ❌ No | ISO 29148 §6.2.2. La existencia del checklist es condición necesaria (aunque no suficiente) para el aseguramiento de calidad. |
| **D4** | **Cadena de trazabilidad reconstruible** | Es posible seguir el hilo: requisito → spec → plan → tareas → código → tests sin saltos irrecuperables. No se exige formato de matriz formal; basta con que un evaluador humano pueda reconstruir la cadena. | ✅ Sí / ⚠️ Parcial / ❌ No | ISO 29148 §6.3.1, IREB §Traceability. La trazabilidad completa es el estándar normativo. Se acepta trazabilidad implícita cuando es evidente. |

---

## Puntuación y umbrales

### Sistema de puntuación

Cada criterio se evalúa según su escala:

| Escala | Valores | Cuándo se usa |
|---|---|---|
| **Binaria** | ✅ = 1, ❌ = 0 | Criterios cuya verificación es objetiva (A1–A12, B3, C1, D2, D3) |
| **Ternaria** | ✅ = 1, ⚠️ = 0.5, ❌ = 0 | Criterios que admiten cumplimiento parcial sin forzar decisiones artificiales (B1, B2, B4, B5, C2, C3, D1, D4) |

### Ponderación por bloques

| Bloque | Criterios | Máximo | Peso | Interpretación |
|---|---|---|---|---|
| **A — Preservación del requisito** | A1–A12 (12 binarios) | 12 | 35% | ¿SpecKit conserva la calidad IREB del input? |
| **B — Conformidad de la implementación** | B1–B5 (5 ternarios, salvo B3 binario) | 5 | 30% | ¿El código satisface el requisito? |
| **C — Verificación** | C1 (binario) + C2, C3 (ternarios) | 3 | 20% | ¿Los tests verifican lo especificado? |
| **D — Trazabilidad** | D2, D3 (binarios) + D1, D4 (ternarios) | 4 | 15% | ¿El pipeline documenta sus decisiones? |
| **Total** | **24 criterios** | **24** | **100%** | |

### Fórmula

$$ \text{Puntuación} = \sum \text{A} \times 0.35 + \sum \text{B} \times 0.30 + \sum \text{C} \times 0.20 + \sum \text{D} \times 0.15 $$

Normalizada a escala 0–10: $$ \text{Nota} = \frac{\text{Puntuación}}{\text{Máximo del bloque correspondiente}} \times 10 $$

### Categorías finales

| Nota | Categoría | Significado |
|---|---|---|
| **≥ 8.0** | **Conforme** ✅ | El pipeline preserva la calidad del requisito y genera una implementación alineada. Las deficiencias son menores y no comprometen la cadena de trazabilidad. |
| **6.0 – 7.9** | **Parcialmente conforme** ⚠️ | El pipeline funciona pero con deficiencias en algún bloque. La implementación puede aceptarse con reparos; la trazabilidad tiene eslabones débiles. |
| **4.0 – 5.9** | **Conformidad baja** ⚠️⬇️ | Deficiencias significativas en al menos dos bloques. El caso aporta información diagnóstica pero no es válido como implementación conforme. |
| **< 4.0** | **No conforme** ❌ | El pipeline no ha logrado preservar el requisito ni generar una implementación útil. El caso se registra como fallo del pipeline. |

### Regla de compensación

Un caso puede ser **Conforme** aunque tenga un bloque débil si los otros tres bloques son sólidos (≥80% en cada uno). Esta regla reconoce que el pipeline puede fallar en una dimensión (p. ej., documentación) sin que ello invalide la calidad de la implementación.

### Criterios críticos (no compensables)

Independientemente de la puntuación global, un caso se clasifica automáticamente como **No conforme** si:

- **A11 = ❌** (alucinación de contexto en el spec): la integridad de la trazabilidad está rota.
- **B1 = ❌** (no cubre la intención principal): el pipeline no implementó lo que se le pidió.
- **B3 = ❌** (regresión evidente): la implementación rompe funcionalidad existente.
- **C1 = ❌** (sin tests): la implementación no es verificable.

---

## Procedimiento de evaluación

1. **Preparación**: reunir los artefactos del caso — `spec.md`, `diff.patch`, `changed-files.txt`, `plan.md`, `tasks.md`, `checklist.md`, `summary.json` — y el `REQ-*.md` de entrada como referencia.
2. **Bloque A**: comparar el `REQ-*.md` de entrada con el `spec.md` generado. Para cada criterio A1–A12, verificar si el atributo correspondiente se conserva.
3. **Bloque B**: inspeccionar el `diff.patch`. Verificar B1 (está la acción principal), B2 (tamaño proporcionado), B3 (no hay regresiones), B4 (archivos del dominio correcto), B5 (señales de intención).
4. **Bloque C**: localizar los tests en el diff. Verificar C1 (hay tests), C2 (cubren el criterio de verificación), C3 (tipo de test adecuado).
5. **Bloque D**: verificar existencia y contenido de `plan.md`, `tasks.md`, `checklist.md`. Evaluar si la cadena de trazabilidad es reconstruible.
6. **Cálculo**: aplicar la fórmula de puntuación y determinar la categoría.
7. **Registro**: documentar la puntuación por bloque, la nota global, y un diagnóstico cualitativo de una frase indicando el principal punto fuerte y el principal punto débil del caso.

---

## Justificación del diseño

**¿Por qué 24 criterios y 4 bloques?** La estructura refleja el flujo del pipeline SpecKit y permite localizar dónde se produce la degradación de calidad. La alternativa de una puntuación única ocultaría si el problema está en la especificación, la implementación o la verificación.

**¿Por qué pesos diferenciados (35/30/20/15)?** La preservación del requisito (A) y la conformidad de la implementación (B) son los objetivos centrales del trabajo. La verificación (C) es importante pero subsidiaria. La documentación del pipeline (D) es deseable pero no es el objeto principal de estudio.

**¿Por qué escala 0–10 con cuatro categorías?** Una escala de tres niveles (conforme/parcial/no conforme) era insuficiente para discriminar casos intermedios. Cuatro categorías permiten separar los casos que funcionan bien (≥8), los que funcionan con reparos (6–7.9), los que aportan información pero no son válidos (4–5.9) y los fallos claros (<4). La nota numérica es más informativa que una etiqueta categórica para comparar casos entre sí.

**¿Por qué criterios críticos no compensables?** Ciertas propiedades son condición necesaria: si el spec alucina contexto (A11), la trazabilidad está rota y el caso no es evaluable; si no se implementa la acción principal (B1), el pipeline no ha cumplido su función; si se introducen regresiones (B3) o no hay tests (C1), la implementación no es aceptable como producto de ingeniería. Estos criterios actúan como quality gates: su incumplimiento invalida el caso independientemente de otras dimensiones.

---

## Referencias normativas

| Fuente | Referencia |
|---|---|
| IREB CPRE Foundation Level | Glinz, M. et al. (2024). *CPRE Foundation Level Handbook*, v1.2.0. IREB. |
| ISO/IEC/IEEE 29148:2018 | Systems and software engineering — Life cycle processes — Requirements engineering. |
| INCOSE | *Guide for Writing Requirements* (2012). International Council on Systems Engineering. |
| ISO 25010 | Systems and software engineering — Systems and software Quality Requirements and Evaluation (SQuaRE). |

