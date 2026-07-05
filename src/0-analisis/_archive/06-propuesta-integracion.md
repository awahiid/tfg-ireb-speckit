# 6. Propuesta de Integración IREB + SpecKit

> **Este documento sintetiza los análisis anteriores y propone cómo se podría integrar IREB en el flujo de SpecKit, tanto para este TFG como para uso general.**

---

## 6.1 Diagnóstico breve

| SpecKit | IREB | Relación |
|---|---|---|
| Pipeline estructurado | Proceso sistemático | Compatibles |
| Plantillas para artefactos | Document templates | Mejorables con atributos IREB |
| `[NEEDS CLARIFICATION]` | Calidad de requisitos | Parcial (falta sistemática) |
| Constitution | Restricciones + Governance | Mezcla conceptos |
| Analyze (consistencia interna) | Validación | Parcial (falta externa) |
| No tiene elicitación | Elicitación | Gap completo |
| No tiene tipos de req. | Funcional/Calidad/Restr. | Gap completo |
| Trazabilidad forward | Trazabilidad bidireccional | Gap parcial |

**Conclusión del diagnóstico**: SpecKit no necesita convertirse en una herramienta IREB. Necesita que el **proceso que lo alimenta** sea IREB-compliant. Eso es exactamente lo que hace la metodología de este TFG.

---

## 6.2 Propuesta para el TFG: Pipeline IREB → SpecKit

El diseño metodológico actual ya implementa esta integración:

```
┌───────────────────────────────────────────────────────────────────────┐
│                         PROCESO IREB                                  │
│  (ejecutado manualmente por el investigador, no por SpecKit)          │
├──────────────────┬────────────────────┬───────────────────────────────┤
│  FASE 1          │  FASE 2            │  FASE 3        │  FASE 4     │
│  ELICITACIÓN     │  DOCUMENTACIÓN     │  SPEC-KIT     │  VALIDACIÓN │
│                  │                    │               │             │
│  Changelogs      │  Plantilla IREB    │  /speckit.*   │  Rúbrica    │
│  ↓               │  ↓                 │  ↓            │  SRCI       │
│  Evidencia       │  REQ-[...].md      │  PR generada  │  Conforme/  │
│  candidata       │  (10 atributos)    │  + tests      │  Parcial/No │
│  (JSON literal)  │  Rúbrica calidad   │               │             │
└──────────────────┴────────────────────┴───────────────┴───────────────┘
     ↑                                      ↑
     └── IREB puro (elicitación doc.)      └── SpecKit puro (generación)
```

### 6.2.1 Separación de responsabilidades

| Componente | Responsabilidad | Marco |
|---|---|---|
| Investigador (tú) | Elicitar, formalizar, validar | IREB |
| SpecKit | Generar implementación desde requisitos formales | SDD |
| Rúbrica SRCI | Evaluar conformidad de la implementación | ISO 29148 + INCOSE |

SpecKit **no necesita** hacer IREB. Solo necesita recibir requisitos que ya han pasado por un proceso IREB.

---

## 6.3 Propuesta implementada: IREB Kit para SpecKit

Los productos descritos en las secciones anteriores se han materializado en
el directorio `src/3-implementacion/ireb-kit/`. El kit incluye:

- **Constitution IREB** (`constitution.md`): 9 artículos con justificación bibliográfica
- **Spec template IREB** (`spec-template-ireb.md`): plantilla con 12 atributos
- **Plan template IREB** (`plan-template-ireb.md`): plan con gates IREB
- **Checklist IREB** (`checklist-ireb.md`): 12 criterios de calidad ISO 29148
- **Workflow IREB** (`workflow-ireb.yml`): pipeline completo de 14 pasos
- **Preset IREB** (`preset-ireb.yml`): instalable con `specify preset add ireb`
- **Prompt template** (`prompt-template.md`): para generar requisitos con LLM
- **Tutorial** (`tutorial.md`): guía paso a paso para el usuario final

Cada producto referencia explícitamente las normas en las que se basa
(IREB [1], ISO 29148 [2], INCOSE [3], Fagan [4]).

### 6.3.1 Constitution IREB

El constitution incluye 9 artículos que reemplazan los valores por defecto
de SpecKit (Library-First, TDD, CLI Mandate):

El preset modificaría la plantilla de spec para incluir:

```markdown
## Requisitos

### REQ-001: [Nombre]
- **Tipo**: Funcional
- **Prioridad**: Alta
- **Fuente**: [origen]
- **Rationale**: [justificación]
- **Descripción**: El sistema deberá [acción] [objeto] [condición]
- **Criterio de verificación**: [método observable]

### REQ-002: [Nombre]
- **Tipo**: Calidad (Rendimiento)
- **Prioridad**: Media
- **Descripción**: El sistema deberá responder en menos de [X]ms...
```

### Nuevos comandos opcionales (vía extensiones)

- **`/speckit.elicit`**: Asistente de elicitación. Pregunta por stakeholders, fuentes, contexto antes de generar la spec.
- **`/speckit.check-ireb`**: Valida requisitos contra criterios IREB (no ambigüedad, completitud, verificabilidad).
- **`/speckit.trace`**: Genera matriz de trazabilidad requisitos → plan → tasks → implementación.

### Modificaciones al constitution

El constitution podría incluir secciones IREB:
- Tipos de requisitos permitidos (functional, quality, constraint)
- Criterios de calidad obligatorios (basados en ISO 29148)
- Proceso de validación (revisión por pares, gates)
- Política de trazabilidad

---

## 6.4 Lecciones para el TFG

### 6.4.1 Lo que SpecKit necesita del proceso IREB

Para que SpecKit funcione bien, los requisitos deben tener:

1. **Descripción formal clara**: "El sistema deberá..." con verbo observable
2. **Una obligación por requisito**: Sin mezclar comportamientos
3. **Criterio de verificación explícito**: Observable y comprobable
4. **Sin ambigüedad crítica**: Términos técnicos de dominio OK, subjetivos NO

Esto es exactamente lo que asegura la rúbrica de formalización (Fase 2).

### 6.4.2 Lo que IREB necesita de SpecKit

Para que la evaluación sea válida:

1. **Ejecución única**: Sin iteración ni corrección humana (contaminaría la medición)
2. **Estado base verificable**: El repo debe compilar y pasar tests antes de SpecKit
3. **Entrada sin reformular**: El requisito se pasa tal como salió de Fase 2
4. **Salida capturada completa**: diff, tests, snapshot

Esto es exactamente lo que define el protocolo de ejecución (Fase 3).

### 6.4.3 Áreas de mejora identificadas para la metodología

1. **Elicitación más rica**: Actualmente solo changelogs. Se podría complementar con:
   - Lectura del diff completo de la PR original
   - Análisis de comentarios de code review
   - Issues relacionados

2. **Validación adicional**: La rúbrica SRCI podría incluir un criterio de "completitud frente a la fuente original" (¿el requisito captura todo el comportamiento del diff original?).

3. **Trazabilidad extendida**: Vincular cada requisito no solo a la fuente (changelog entry) sino también al diff concreto que implementa el cambio.

---

## 6.5 Mapa de decisiones de diseño

| Decisión | Alternativa descartada | Razón |
|---|---|---|
| Usar IREB como marco | IEEE 830, RUP, Agile RE | IREB suficientemente abstracto, adaptable a changelogs |
| Elicitación vía changelogs | Elicitación con stakeholders | No hay acceso a stakeholders reales; changelogs son trazables |
| Plantilla IREB con 10 atributos | Plantilla Rupp (formal) | Proporcionado para TFG, no necesita lógica formal |
| Ejecución única de SpecKit | Ejecución iterativa con refinamiento | Evita contaminar la medición |
| Rúbrica SRCI con 3 niveles | Binario conforme/no conforme | Mayor granularidad analítica |
| SpecKit como caja negra | Modificar SpecKit | SpecKit no tiene API headless; se usa tal cual |

---

## 6.6 Referencias

- IREB CPRE Foundation Level Handbook (syllabus oficial, v3.x)
- IREB CPRE Glossary — cpre.ireb.org/en/downloads-and-resources/glossary
- ISO/IEC/IEEE 29148:2018 — Requirements Engineering
- INCOSE Guide for Writing Requirements
- github/github/spec-kit — README, spec-driven.md, docs (junio 2026)
- github.github.io/spec-kit/ — Documentación oficial SpecKit
