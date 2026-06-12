# 2. Mapeo Sistemático IREB ↔ SpecKit

> **Fuentes IREB**: [CPRE Foundation Level Handbook](https://cpre.ireb.org/en/downloads-and-resources/downloads), [CPRE Glossary](https://cpre.ireb.org/en/downloads-and-resources/glossary), [The Nine Fundamental Principles of RE](https://ireb.org/en/downloads).  
> **Fuentes SpecKit**: [github/spec-kit](https://github.com/github/spec-kit), [spec-driven.md](https://github.com/github/spec-kit/blob/main/spec-driven.md), docs site oficial.  
> **Fecha del análisis**: Junio 2026.

---

## 2.1 Las tres actividades fundamentales de IREB

IREB (CPRE Foundation Level) define tres actividades fundamentales en RE:

```
┌─────────────────────────────────────────────────────────────────┐
│                    INGENIERÍA DE REQUISITOS (IREB)              │
├────────────────┬──────────────────────┬─────────────────────────┤
│  ELICITACIÓN   │    DOCUMENTACIÓN     │      VALIDACIÓN         │
│  (Elicitation) │  (Documentation)     │    (Validation)         │
├────────────────┼──────────────────────┼─────────────────────────┤
│ Buscar, capturar│ Especificar requisitos│ Confirmar que los      │
│ y consolidar   │ de forma estructurada│ requisitos reflejan     │
│ requisitos desde│ con criterios de     │ las necesidades reales  │
│ fuentes        │ calidad              │ de los stakeholders     │
└────────────────┴──────────────────────┴─────────────────────────┘
```

A estas tres actividades se añade una transversal:

- **Requirements Management**: Gestionar requisitos existentes, incluyendo almacenamiento, cambios y trazabilidad.

---

## 2.2 Mapeo por actividad

### 2.2.1 Elicitación

| Aspecto IREB | ¿SpecKit lo cubre? | Evidencia / Explicación |
|---|---|---|
| Identificación de stakeholders | ❌ No | SpecKit no tiene concepto de stakeholders. Asume que el usuario describe la feature. |
| Identificación de fuentes de requisitos | ❌ No | No hay registro de fuentes (documentos, sistemas legacy, observaciones). |
| Técnicas de elicitación (entrevistas, workshops, prototipado) | ❌ No | SpecKit no incluye técnicas de elicitación. El input es un prompt del usuario. |
| Análisis de contexto del sistema | ❌ No | No hay modelado de contexto ni diagramas de contexto. |
| Modelado de dominio | ⚠️ Parcial | `data-model.md` modela datos, pero no el dominio del problema. |
| Reconstrucción de requisitos desde fuentes existentes | ❌ No | No hay mecanismo para derivar requisitos de documentación existente. |
| Observación / análisis de procesos | ❌ No | No aplicable. |
| **Valoración global** | **Bajo (1/10)** | SpecKit no hace elicitación. Asume que el usuario ya tiene claras las necesidades. |

### 2.2.2 Documentación

| Aspecto IREB | ¿SpecKit lo cubre? | Evidencia / Explicación |
|---|---|---|
| Plantillas de requisitos | ✅ Sí | Usa `spec-template.md`, `plan-template.md`, `tasks-template.md`. |
| Tipos de requisitos (Funcional, Calidad, Restricción) | ❌ No | SpecKit no clasifica requisitos por tipo. Usa user stories. |
| Atributos de requisitos (ID, fuente, prioridad, rationale) | ❌ No | No hay atributos formales. Solo descripción narrativa. |
| Criterios de calidad (no ambigüedad, completitud, verificabilidad) | ⚠️ Parcial | Checklist y gates de calidad, pero no basados en estándares RE. |
| Lenguaje natural estructurado | ✅ Sí | Plantillas fuerzan estructura: "Focus on WHAT, not HOW". |
| Modelado (UML, ER, state machines) | ❌ No | No hay modelado formal. Solo markdown. |
| Glosario de términos | ❌ No | No se genera glosario automáticamente. |
| Especificación de interfaces | ✅ Sí | `contracts/` para APIs REST, WebSocket, etc. |
| **Valoración global** | **Media (5/10)** | Buena estructura documental, pero carece de rigor RE clásico. |

### 2.2.3 Validación

| Aspecto IREB | ¿SpecKit lo cubre? | Evidencia / Explicación |
|---|---|---|
| Revisión con stakeholders | ❌ No | No hay concepto de stakeholder en el flujo. |
| Prototipado para validación | ❌ No | SpecKit genera código directamente, no prototipos. |
| Checklist-based reading | ⚠️ Parcial | `/speckit.checklist` genera checklists, pero no para validación con stakeholders. |
| Inspección formal | ❌ No | No hay inspección estructurada. |
| Validación contra necesidades reales | ❌ No | No hay mecanismo para verificar que lo especificado coincide con lo necesario. |
| **Valoración global** | **Bajo (2/10)** | Solo existe `analyze` para consistencia interna. No hay validación externa. |

### 2.2.4 Requirements Management

| Aspecto IREB | ¿SpecKit lo cubre? | Evidencia / Explicación |
|---|---|---|
| Versionado de requisitos | ⚠️ Parcial | Git versiona los archivos, pero no hay versionado semántico de requisitos individuales. |
| Trazabilidad | ⚠️ Parcial | Trazabilidad spec→plan→tasks→implement, pero no bidireccional ni a fuentes. |
| Gestión de cambios | ❌ No | No hay CCB, ni proceso de cambio, ni impacto analysis. |
| Baselines | ❌ No | No hay concepto de baseline de requisitos. |
| Priorización | ❌ No | No hay priorización formal de requisitos. |
| **Valoración global** | **Bajo (2/10)** | Solo la trazabilidad lineal del pipeline es un punto débilmente positivo. |

---

## 2.3 Mapeo contra los 9 Principios Fundamentales de IREB

Según el póster oficial "The Nine Fundamental Principles of Requirements Engineering" (IREB):

| # | Principio IREB | SpecKit | Observación |
|---|---|---|---|
| 1 | **Value Orientation** — RE aporta valor al sistema | ✅ Sí | SDD pone la especificación como centro. |
| 2 | **Stakeholder Involvement** — Involucrar stakeholders | ❌ No | No hay concepto de stakeholder. |
| 3 | **Shared Understanding** — Comprensión compartida | ⚠️ Parcial | Las plantillas ayudan, pero no hay validación con stakeholders. |
| 4 | **Problem-First** — Entender el problema antes que la solución | ✅ Sí | "Focus on WHAT, not HOW" es un pilar de SDD. |
| 5 | **Common Language** — Lenguaje común | ⚠️ Parcial | Markdown es accesible, pero no hay glosario. |
| 6 | **System Context** — Considerar el contexto del sistema | ❌ No | No hay modelado de contexto del sistema. |
| 7 | **Requirement Types** — Distinguir tipos de requisitos | ❌ No | No clasifica requisitos. |
| 8 | **Prioritization** — Priorizar requisitos | ❌ No | No hay priorización. |
| 9 | **Quality Assurance** — Asegurar calidad de requisitos | ⚠️ Parcial | Checklists y gates, pero no basados en estándares RE. |

**Puntuación**: 2/9 completamente cubiertos, 3/9 parcialmente, 4/9 no cubiertos.

---

## 2.4 Mapeo contra atributos de calidad de requisitos (IEEE 29148 / IREB)

| Atributo de calidad | SpecKit | ¿Cómo se cubre / dónde falla? |
|---|---|---|
| **Necesario** | ❌ | No distingue requisitos esenciales de deseables. |
| **Singular** | ❌ | Una user story puede contener múltiples comportamientos. |
| **Completo** | ❌ | No hay verificación de completitud. |
| **Realizable** | ❌ | No hay estudio de viabilidad. |
| **Verificable** | ⚠️ | Quickstart con escenarios, pero no verificabilidad formal. |
| **No ambiguo** | ⚠️ | `[NEEDS CLARIFICATION]` ayuda, pero no es sistemático. |
| **Consistente** | ⚠️ | `analyze` revisa consistencia cruzada, pero limitado. |
| **Trazable** | ✅ | Trazabilidad spec→plan→tasks→implement. |
| **Comprensible** | ✅ | Markdown + plantillas estructuradas. |

---

## 2.5 Resumen del mapeo

| Actividad IREB | Cobertura SpecKit | Justificación |
|---|---|---|
| Elicitación | ❌ **1/10** | No hay técnicas de elicitación. Input = prompt de usuario. |
| Documentación | ⚠️ **5/10** | Buena estructura de plantillas, pero sin tipos ni atributos formales. |
| Validación | ❌ **2/10** | Solo consistencia interna. No hay validación con stakeholders. |
| Management | ❌ **2/10** | Solo trazabilidad lineal del pipeline. |
| **Global** | ⚠️ **2.5/10** | SpecKit no es una herramienta RE, es un generador de código con estructura. |

---

## 2.6 Conclusión

**SpecKit no está diseñado para ser IREB-compliant ni norm-based.** Su propósito es diferente: generar implementaciones a partir de especificaciones narrativas. Sin embargo, su arquitectura de plantillas, su pipeline estructurado y su sistema de extensiones ofrecen puntos de entrada claros para incorporar prácticas IREB.

La valoración 2.5/10 no es una crítica a SpecKit — es una constatación de que **SpecKit y IREB operan en niveles diferentes de abstracción**:
- IREB define **qué** debe hacerse en RE (actividades, principios, calidad)
- SpecKit define **cómo** generar código a partir de descripciones

La pregunta del TFG es precisamente si pueden complementarse.
