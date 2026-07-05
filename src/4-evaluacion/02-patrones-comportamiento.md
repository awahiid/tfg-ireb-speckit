# Producto 2 — Patrones de comportamiento del pipeline SDD

> **Objetivo**: identificar condiciones en las que SpecKit se alinea mejor o peor con el flujo normativo IREB.

---

## 2.1 Metodología de identificación

Los patrones se infieren de la observación de los 6 casos ejecutados con Flow B, complementados con el análisis estructural del pipeline SpecKit documentado en el Producto 1. No son conclusiones estadísticas sino observaciones cualitativas basadas en la evidencia disponible.

---

## 2.2 Patrones identificados

### P1. Sensibilidad a la calidad del input

**Observación**: La calidad de la salida de SpecKit es directamente proporcional a la especificidad del input.

| Input | Resultado | Caso |
|---|---|---|
| Changelog vago ("fix: validate key type") | diff extenso (4238 líneas) pero posiblemente sobredimensionado | n8n-e5 |
| Changelog concreto ("Added restriction of allowed MIME types") | diff moderado (337 líneas) y acotado | directus-e9 |
| Changelog mínimo ("fix FIPS status schema") | 0 líneas — el LLM no supo qué hacer | authentik-e1 |

**Implicación para IREB**: Los requisitos formalizados con criterios de verificación explícitos (Flow B) producen implementaciones más acotadas que los changelogs crudos (Flow A). La formalización IREB actúa como *filtro de ambigüedad*.

**Criterio IREB relacionado**: Documentación (CPRE §4), ISO 29148 §6.2.2 (no ambiguo, verificable).

---

### P2. Deriva de alcance (scope creep) en requisitos abiertos

**Observación**: Cuando el input no especifica restricciones explícitas, SpecKit tiende a implementar más de lo solicitado.

Ejemplo: `n8n-e5` (4238 líneas para "Validate update key value type") sugiere que el LLM interpretó liberalmente el alcance, posiblemente añadiendo validaciones adicionales, refactorización, o tests no estrictamente necesarios.

**Implicación para IREB**: Los criterios de verificación IREB (comportamiento observable) acotan el alcance. Sin ellos, el pipeline SDD tiende a *maximizar* la respuesta en lugar de *minimizarla*.

**Criterio IREB relacionado**: Verificabilidad, singularidad (ISO 29148).

---

### P3. Eficacia del constitution IREB

**Observación**: El `constitution.md` personalizado con principios RE (verificabilidad, minimalidad, trazabilidad) introducido en Flow B modifica el comportamiento del pipeline completo, no solo de `/speckit.specify`. Los principios del constitution se propagan a `plan`, `tasks` e `implement`.

**Implicación para IREB**: El constitution es el **punto de mayor palanca** para aproximar SpecKit a un flujo normativo. Es el equivalente funcional de una política de calidad RE.

**Criterio IREB relacionado**: Principios fundamentales (CPRE §4).

---

### P4. Clarify y checklist como sustitutos parciales de validación

**Observación**: `/speckit.clarify` detecta ambigüedades léxicas (términos como "rápido", "eficiente") y `/speckit.checklist` evalúa criterios de calidad. Sin embargo, ambos son autoevaluaciones del LLM: no reemplazan la validación con stakeholders.

En los casos ejecutados, `clarify` generó entre 2 y 60 líneas de observaciones. `checklist` generó entre 33 y 161 líneas. La variabilidad sugiere que la eficacia depende del input y del modelo.

**Implicación para IREB**: `clarify` + `checklist` son herramientas útiles como *primer filtro* de calidad, pero no sustituyen la validación externa. Son ⚠️ parcial, no ✅ alineado.

**Criterio IREB relacionado**: Validación (CPRE §7).

---

### P5. Analyze como trazabilidad interna (no externa)

**Observación**: `/speckit.analyze` verifica consistencia spec↔plan↔tasks↔code y genera una matriz de trazabilidad. Esta trazabilidad es *interna al pipeline*: no conecta con la fuente original del requisito (changelog, stakeholder, issue).

**Implicación para IREB**: La trazabilidad de SpecKit es útil para integridad interna pero no satisface la trazabilidad *externa* exigida por ISO 29148 (requisito ↔ fuente ↔ stakeholder).

**Criterio IREB relacionado**: Trazabilidad (CPRE §8, ISO 29148).

---

### P6. Eficiencia del pipeline completo vs parcial

**Observación**: El pipeline completo de Flow B (8 pasos) produce artefactos intermedios (spec, clarify, checklist, plan, tasks, analyze, implement, post-analyze) que en conjunto forman un *expediente de trazabilidad*. El pipeline reducido de Flow A (4 pasos) solo produce spec, plan, tasks, implement.

| Métrica | Flow B (IREB) | Flow A (baseline) |
|---|---|---|
| Pasos | 8 | 4 |
| Artefactos intermedios | 11 archivos | 5 archivos |
| Trazabilidad | Interna + constitution | Solo interna |
| Tiempo estimado | ~15-20 min | ~8-12 min |

**Implicación para IREB**: El pipeline completo Flow B genera un expediente más rico para auditoría y revisión. La diferencia de tiempo (~7-8 min adicionales) es insignificante frente al valor de la trazabilidad añadida.

---

## 2.3 Condiciones que favorecen la alineación

SpecKit se alinea mejor con IREB cuando:

1. **El input es concreto y verificable** — changelogs con verbos observables (validar, impedir, rechazar, notificar) producen mejores resultados que descripciones vagas (mejorar, optimizar, soportar).

2. **Se usa constitution IREB** — los principios de verificabilidad, minimalidad y trazabilidad se propagan a todo el pipeline.

3. **Se ejecuta el pipeline completo** — `clarify` + `checklist` + `analyze` añaden capas de calidad que aproximan el flujo a una revisión RE.

4. **El dominio es técnicamente acotado** — cambios en APIs, validaciones, y configuraciones (directus-e9, n8n-e5) producen implementaciones más alineadas que cambios arquitectónicos o de diseño.

## 2.4 Condiciones que dificultan la alineación

SpecKit se alinea peor con IREB cuando:

1. **El input es ambiguo o mínimo** — authentik-e1 (0 líneas) es el caso extremo.

2. **No hay restricciones explícitas** — sin criterios de verificación, el LLM tiende al scope creep (n8n-e5: 4238 líneas para un cambio aparentemente pequeño).

3. **El cambio requiere conocimiento de dominio especializado** — si el changelog asume conocimiento implícito que el LLM no tiene, la implementación será incorrecta o incompleta.

4. **El cambio es transversal** — modificaciones que afectan a muchos archivos sin un patrón claro son difíciles de acotar para el LLM.

---

## 2.5 Pendiente: comparación Flow A vs Flow B

> ⚠️ **Los patrones P1-P6 se basan únicamente en los datos de Flow B.** La comparación formal Flow A vs Flow B requiere ejecutar el pipeline `pipeline-flow-a.sh` para los 6 casos y aplicar la rúbrica SRCI (Producto 3). Sin datos de Flow A, las diferencias son inferencias cualitativas, no observaciones empíricas.
