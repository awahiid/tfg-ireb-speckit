# Producto 1 — Mapa de alineación IREB ↔ SpecKit

> **Objetivo**: contrastar cada actividad IREB y cada criterio de calidad ISO 29148 contra los comandos y artefactos de SpecKit.
>
> **Leyenda**: ✅ Alineado &nbsp; ⚠️ Parcial &nbsp; ❌ No cubierto

---

## 1.1 Actividades IREB (CPRE Foundation Level)

| Actividad IREB | Comando / Artefacto SpecKit | Cobertura | Evidencia |
|---|---|---|---|
| **Elicitación** — Identificar fuentes, stakeholders y necesidades | ❌ Ninguno | ❌ | SpecKit no tiene mecanismo de elicitación. El input (`/speckit.specify`) lo proporciona el usuario. No hay entrevistas, observación, ni análisis de documentos. |
| **Documentación** — Redactar requisitos con atributos | `/speckit.specify` | ⚠️ | SpecKit genera una especificación en lenguaje natural, pero sin atributos formales (ID único, tipo, prioridad, fuente, versión). La plantilla IREB de 12 atributos no tiene equivalente nativo. |
| **Validación** — Verificar que los requisitos son correctos | `/speckit.clarify` + `/speckit.checklist` | ⚠️ | `clarify` detecta ambigüedades y `checklist` aplica criterios de calidad, pero son autoevaluaciones del LLM sin validación externa con stakeholders reales. |
| **Negociación** — Resolver conflictos entre requisitos | ❌ Ninguno | ❌ | No hay mecanismo de negociación. SpecKit asume un único requisito de entrada sin conflictos. |
| **Gestión de cambios** — Versionado, trazabilidad de cambios | ❌ Ninguno | ❌ | SpecKit no versiona requisitos ni mantiene historial de cambios. Cada ejecución es independiente. |
| **Verificación** — Confirmar que la implementación cumple los requisitos | `/speckit.analyze` | ⚠️ | `analyze` verifica consistencia spec↔plan↔tasks↔code, pero es una verificación interna del LLM, no una verificación formal con criterios externos. |
| **Trazabilidad** — Enlaces requisito→diseño→implementación→test | `/speckit.analyze` (matriz de trazabilidad) | ⚠️ | `analyze` genera una matriz spec↔tasks↔code, pero no hay trazabilidad hacia la fuente original ni hacia stakeholders. |

---

## 1.2 Criterios de calidad ISO/IEC/IEEE 29148 §6.2.2

Aplicados sobre los requisitos generados por `/speckit.specify` (Flow B):

| Criterio | ¿Lo cubre SpecKit? | Cobertura | Observación |
|---|---|---|---|
| **Necesario** — El requisito refleja una necesidad real | ❌ | ❌ | SpecKit no evalúa necesidad; acepta cualquier input sin cuestionar su pertinencia. |
| **No ambiguo** — Una única interpretación | ⚠️ (vía `clarify`) | ⚠️ | `clarify` detecta ambigüedades léxicas pero no garantiza interpretación única. Depende de la calidad del LLM. |
| **Verificable** — Puede comprobarse objetivamente | ⚠️ (vía `checklist`) | ⚠️ | El checklist evalúa verificabilidad pero la generación de criterios no siempre es observable (verbos como "gestionar", "soportar"). |
| **Singular** — Un único requisito por declaración | ❌ | ❌ | SpecKit no fuerza atomicidad. Puede generar requisitos compuestos. |
| **Factible** — Técnicamente realizable | ⚠️ (vía `plan`) | ⚠️ | El plan evalúa factibilidad técnica pero no considera restricciones reales del proyecto (presupuesto, plazo, dependencias externas). |
| **Trazable** — Enlace a fuente y artefactos derivados | ⚠️ (vía `analyze`) | ⚠️ | Trazabilidad interna (spec→code) pero no a la fuente original (stakeholder, documento). |
| **Consistente** — Sin contradicciones con otros requisitos | ❌ | ❌ | SpecKit procesa un requisito a la vez. No detecta conflictos entre requisitos. |
| **Completo** — Toda la información necesaria está presente | ⚠️ | ⚠️ | Depende completamente de la calidad del input. Si el changelog es vago, la especificación será incompleta. |

---

## 1.3 Actividades del pipeline SpecKit vs flujo IREB

| Fase SpecKit | Actividad IREB más próxima | Cobertura | Brecha principal |
|---|---|---|---|
| **Constitution** | Definición de principios y criterios de calidad | ⚠️ | IREB define criterios normativos (ISO 29148); SpecKit permite principios libres. En Flow B se usó constitution IREB → ✅ |
| **Specify** | Documentación de requisitos | ⚠️ | IREB exige 12 atributos; SpecKit genera texto libre. Flow B usó plantilla IREB → mejora parcial. |
| **Clarify** | Validación (detección de defectos) | ⚠️ | IREB exige validación con stakeholders; SpecKit es autovalidación. |
| **Checklist** | Control de calidad (revisión) | ⚠️ | Similar a una revisión por pares, pero sin par humano. |
| **Plan** | Diseño preliminar | ✅ | Equivalente funcional: ambos traducen requisitos a decisiones técnicas. |
| **Tasks** | Descomposición en unidades de trabajo | ✅ | Equivalente funcional: ambos descomponen en tareas trazables. |
| **Analyze** | Verificación y trazabilidad | ⚠️ | Interna (spec↔code) vs externa (stakeholder↔spec↔code). |
| **Implement** | Implementación | ✅ | Equivalente funcional: ambos generan código que satisface la especificación. |

---

## 1.4 Mapa de alineación agregado

| Dimensión | ✅ Alineado | ⚠️ Parcial | ❌ No cubierto |
|---|---|---|---|
| Actividades IREB | 0/7 | 4/7 (Doc, Val, Verif, Traz) | 3/7 (Elic, Neg, Gestión) |
| Criterios ISO 29148 | 0/8 | 5/8 (No-amb, Verif, Fact, Traz, Compl) | 3/8 (Nec, Sing, Cons) |
| Fases pipeline | 3/8 (Plan, Tasks, Impl) | 4/8 (Const, Spec, Clar, Check) | 1/8 (Analyze — solo interna) |

**Alineación global estimada: ~35% (⚠️ PARCIAL).** SpecKit cubre la mitad derecha del flujo RE (de especificación a implementación) pero carece de la mitad izquierda (elicitación, negociación, gestión). Dentro de lo que cubre, la calidad depende críticamente de la configuración (Flow B con constitution y plantillas IREB mejora significativamente respecto a Flow A).

---

## 1.5 Análisis por caso (Flow B — IREB-enhanced)

Resultados preliminares basados en los 6 casos ejecutados (antes de aplicar rúbrica SRCI formal):

| Caso | diff (líneas) | archivos | ¿Compila? | Observación |
|---|---|---|---|---|
| **appwrite-e3** | 224 | 9 | Pendiente | Cambio document lists cache TTL |
| **authentik-e1** | 0 | 0 | ❌ | No generó cambios — posible problema con el repo o el prompt |
| **cal-e1** | 749 | N/D | Pendiente | bookingUrl en organizations |
| **directus-e9** | 337 | N/D | Pendiente | MIME types restriction |
| **medusa-e5** | 262 | N/D | Pendiente | SKU search en admin API |
| **n8n-e5** | 4238 | 5 | Pendiente | MongoDB validate key type |

> ⚠️ Los datos de compilación y tests están pendientes de verificación (filtro técnico de la Fase 4). `authentik-e1` con 0 líneas de diff es un caso fallido técnicamente.
