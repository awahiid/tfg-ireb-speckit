# Mapeo de SpecKit contra flujos profesionales de ingeniería de requisitos basados en normas

**Trabajo de Fin de Grado (TFG)** | Grado en Ingeniería Informática del Software

## Objetivo General

Este proyecto persigue **dos objetivos complementarios**:

1. **Mapear** sistemáticamente el flujo de trabajo de SpecKit (SDD) contra un flujo profesional
   de ingeniería de requisitos basado en normas (IREB CPRE Foundation Level, ISO/IEC/IEEE 29148,
   INCOSE Guide for Writing Requirements).
2. **Evaluar** si las diferencias identificadas se traducen en resultados medibles, comparando
   la implementación que genera SpecKit con y sin un marco IREB de entrada (Flow A vs Flow B).

## Productos del trabajo

### Análisis (`src/0-analisis/`)

| Documento | Contenido |
|---|---|
| `01-flujo-speckit.md` | Caracterización del flujo SDD de SpecKit v0.10.2 |
| `02-mapeo-ireb-speckit.md` | Mapeo sistemático IREB ↔ SpecKit por actividad y criterio |
| `03-deficiencias-grises.md` | Deficiencias y áreas grises de SpecKit frente a IREB |
| `04-plantillas-elicitacion.md` | Plantillas, elicitación, rúbricas y fuentes |
| `05-sistemas-profesionales.md` | Comparativa con herramientas RE profesionales |
| `06-propuesta-integracion.md` | Propuesta de integración IREB + SpecKit |
| `07-gaps-metodologia.md` | Gaps y funciones de SpecKit no utilizadas |
| `08-partes-personalizables.md` | Partes personalizables de SpecKit y productos faltantes |
| `09-divergencias-puntos-encuentro.md` | Divergencias y puntos de encuentro entre RE estandarizado y SpecKit |

### IREB Kit (`src/3-implementacion/ireb-kit/`)

| Producto | Descripción |
|---|---|
| `constitution.md` | 9 artículos IREB para SpecKit (verificabilidad, minimalidad, trazabilidad...) |
| `spec-template-ireb.md` | Plantilla de especificación con 12 atributos IREB |
| `plan-template-ireb.md` | Plantilla de plan con gates IREB |
| `checklist-ireb.md` | Checklist de calidad basado en ISO 29148 (12 criterios) |
| `workflow-ireb.yml` | Pipeline YAML con gates de revisión IREB |
| `preset-ireb.yml` | Preset instalable con `specify preset add ireb` |
| `prompt-template.md` | Prompt para generar requisitos IREB con LLM |
| `tutorial.md` | Tutorial paso a paso para el usuario final |

### Metodología y datos (`src/`)

- `src/metodologia.md` — Diseño metodológico completo (4 fases, Flow A vs Flow B)
- `src/1-evidencia/` — Corpus de 56 entradas extraídas de changelogs
- `src/2-requisitos/` — 52 requisitos formalizados con plantilla IREB
- `src/3-implementacion/` — Scripts de preparación y ejecución
- `src/4-evaluacion/` — Rúbrica SRCI para evaluación de conformidad
