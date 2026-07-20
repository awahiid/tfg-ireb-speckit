# IREB Kit for SpecKit

> Inyecta estos archivos en un repo con SpecKit para aplicar
> ingeniería de requisitos profesional (IREB CPRE + ISO 29148 + INCOSE).

## Archivos del kit

| # | Archivo | Dónde se inyecta | Comando | Justificación |
|---|---------|-----------------|---------|---------------|
| 1 | `AGENTS.md` | `./` (raíz) | *Todos* | Instrucciones globales IREB. Define reglas R0-R4 (no alucinar contexto, trazabilidad, verificabilidad, minimalidad). **El más importante**: sin esto el agente no sabe que debe seguir IREB. |
| 2 | `constitution.md` | `.specify/memory/` | `/speckit.constitution` | 9 artículos IREB + ISO 29148 + INCOSE. Marco normativo que gobierna todo el pipeline. |
| 3 | `spec.template.md` | `.specify/templates/` | `/speckit.specify` | 12 atributos IREB. Sin esto, SpecKit genera texto libre sin estructura formal. |
| 4 | `clarify.template.md` | `.specify/templates/` | `/speckit.clarify` | Detector de ambigüedades + alucinaciones de contexto. Tabla de términos no observables → alternativas IREB. |
| 5 | `checklist.template.md` | `.specify/templates/` | `/speckit.checklist` | 13 criterios ISO 29148 (R13: no alucinación, bloqueante). Control de calidad normativo. |
| 6 | `plan.template.md` | `.specify/templates/` | `/speckit.plan` | Gates IREB pre-planificación: verificabilidad, trazabilidad, anti-ambigüedad. |
| 7 | `tasks.template.md` | `.specify/templates/` | `/speckit.tasks` | Trazabilidad obligatoria [REQ-ID] por tarea. Prohíbe tareas huérfanas. |
| 8 | `analyze.template.md` | `.specify/templates/` | `/speckit.analyze` | Matriz de trazabilidad spec→plan→tasks→code→tests. Gates de aceptación. |
| 9 | `prompt.template.md` | `./` | Manual | Prompt LLM para generar REQ-*.md desde changelogs (Fase 2 del TFG). |
| 10 | `pipeline.sh` | `./` | Automático | Pipeline 8 pasos + scope contract vía opencode + DeepSeek. Alternativa automatizada. |

## Por qué este kit mejora Flow A — 6 hilos conductores

Cada archivo del kit ataca un fallo concreto de Flow A (SpecKit sin IREB).
Estos 6 principios garantizan que **Flow B con kit ≥ Flow A simple** en todos los casos:

| # | Hilo | Fallo de Flow A | Cómo lo corrige el kit | Archivos que lo implementan |
|---|------|----------------|----------------------|---------------------------|
| **H1** | No alucinar contexto | Inventa stakeholders, fuentes y objetivos no presentes en el input | Regla R0 bloqueante: Source y Rationale solo del input original. Si no hay → "sin fuente documentada" | `AGENTS.md`, `constitution.md`, `clarify.template.md`, `checklist.template.md` |
| **H2** | Scope contract | Sin límites: puede borrar 2554 líneas (medusa-e5) o generar 4238L para un cambio simple (n8n-e5) | Antes de implementar, se define exactamente qué archivos tocar, cuáles NO tocar, y qué comportamiento implementar | `pipeline.sh` (paso 7.5), `AGENTS.md` (regla R3) |
| **H3** | Trazabilidad obligatoria | Código huérfano sin vincular a requisitos | Cada artefacto (spec, plan, tarea, código, test) debe enlazar a un REQ-ID. Sin trazabilidad → no se genera | `tasks.template.md`, `analyze.template.md`, `spec.template.md` |
| **H4** | Verificación observable | No define cómo comprobar que el código cumple el requisito | Todo requisito debe tener al menos un criterio de verificación concreto (respuesta HTTP, cambio de estado, evento) | `spec.template.md`, `checklist.template.md`, `constitution.md` |
| **H5** | Minimalidad | Scope creep: añade features no solicitadas (feature-opt-in en cal-e1) | "Solo lo necesario para satisfacer el requisito". Prohíbe refactorizar, añadir dependencias o modificar configuraciones globales | `AGENTS.md` (R3), `pipeline.sh` (scope contract), `plan.template.md` |
| **H6** | Contexto destilado | Contexto acumulado de 8 pasos (~15K tokens) induce alucinaciones y scope creep | El paso implement recibe solo spec + scope contract + tasks (~3K tokens). El resto de la documentación IREB se genera pero no se inyecta en el prompt de código | `pipeline.sh` (diseño del paso 8) |

### Cómo se verifican estos hilos en la práctica

```bash
# H1: el clarify debe reportar 0 alucinaciones de contexto
grep "ALUCINACIÓN DE CONTEXTO" resultados/caso/03-clarify.md

# H2: el scope contract debe listar archivos concretos
grep "ARCHIVOS A TOCAR" resultados/caso/07.5-scope-contract.md

# H3: analyze debe mostrar 100% trazabilidad
grep "Trazabilidad completa" resultados/caso/07-analyze.md

# H4: el checklist R7-R9 deben pasar
grep "R7\|R8\|R9" resultados/caso/04-checklist.md

# H5+H6: el diff debe ser proporcionado al cambio
wc -l resultados/caso/diff.patch  # < 200L para cambios pequeños, < 500L para medios
```

## Qué NO está en el kit

| Archivo | ¿Incluido? | Razón |
|---------|-----------|-------|
| `implement-template.md` | ❌ | No existe en SpecKit. Se controla vía scope contract en `pipeline.sh` + restricciones en `AGENTS.md`. |
| `.env` | ❌ | Configuración de entorno, no de requisitos. |
| Presets `.yml` | ❌ | Con los archivos individuales inyectados, los presets son redundantes. |
| Workflows `.yml` | ❌ | `pipeline.sh` los reemplaza con más flexibilidad. |

## Inyección rápida

```bash
cp AGENTS.md                    mi-repo/
cp constitution.md              mi-repo/.specify/memory/
cp spec.template.md             mi-repo/.specify/templates/
cp clarify.template.md          mi-repo/.specify/templates/
cp checklist.template.md        mi-repo/.specify/templates/
cp plan.template.md             mi-repo/.specify/templates/
cp tasks.template.md            mi-repo/.specify/templates/
cp analyze.template.md          mi-repo/.specify/templates/
cp pipeline.sh                  mi-repo/
```

## Dos formas de usar

**A. SpecKit manual (Copilot Chat)** — con el kit inyectado, usa `/speckit.*` normalmente.

**B. Pipeline automático (terminal)**:
```bash
./pipeline.sh . ../reqs/REQ-APP-001.md resultados/caso
```

## Base normativa

| Fuente | Referencia |
|--------|-----------|
| IREB CPRE Foundation Level | Glinz et al. (2024), v1.2.0 |
| ISO/IEC/IEEE 29148:2018 | §6.2.2 Quality Characteristics |
| INCOSE Guide for Writing Requirements | (2012) |
