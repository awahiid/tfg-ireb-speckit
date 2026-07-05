# 1. Flujo de Trabajo de SpecKit

> **Fuente principal**: [github/github/spec-kit](https://github.com/github/spec-kit) — repositorio oficial, commit `1b0556c` (junio 2026), versión `v0.10.2`.  
> **Documentación**: [github.github.io/spec-kit/](https://github.github.io/spec-kit/) — docs site oficial.  
> **Metodología subyacente**: [spec-driven.md](https://github.com/github/spec-kit/blob/main/spec-driven.md) — Spec-Driven Development (SDD).  
> **Fecha del análisis**: Junio 2026.

---

## 1.1 ¿Qué es SpecKit?

SpecKit es un **toolkit open source** (MIT) desarrollado por GitHub para practicar **Spec-Driven Development (SDD)**. Su repositorio tiene ~112k estrellas, 229+ contribuyentes, y 162 releases. Está escrito principalmente en Python (94.7%) con scripts Shell y PowerShell.

Según su README oficial:

> *"Spec-Driven Development flips the script on traditional software development. […] Specifications become executable, directly generating working implementations rather than just guiding them."*

SpecKit no es una herramienta de ingeniería de requisitos. Es un **generador de código asistido por IA** que utiliza un pipeline estructurado de especificaciones para producir implementaciones. Su propósito es eliminar el gap entre especificación e implementación mediante la generación automática.

---

## 1.2 Flujo de trabajo completo (v0.10.2)

### 1.2.1 Inicialización

```bash
specify init my-project --integration copilot
```

Esto genera la estructura base:

```
.specify/
├── extensions/       # Capacidades adicionales
├── integrations/     # Configuración del agente
├── memory/
│   └── constitution.md  # Principios rectores (template)
├── scripts/
│   └── bash/
├── templates/        # Plantillas del flujo (spec, plan, tasks)
└── workflows/
.github/
├── agents/
└── prompts/         # Comandos /speckit.*
.vscode/
```

### 1.2.2 Pipeline Core (6 pasos)

Según la documentación oficial y el archivo `spec-driven.md`, el flujo recomendado es:

```
┌─────────────┐   ┌──────────────┐   ┌───────────┐   ┌───────────┐   ┌──────────────┐
│ Constitution │──▶│   Specify   │──▶│   Plan    │──▶│   Tasks   │──▶│  Implement   │
│  (principios)│   │ (qué y por qué)│   │ (cómo)    │   │ (tareas)  │   │  (código)    │
└─────────────┘   └──────────────┘   └───────────┘   └───────────┘   └──────────────┘
```

**Paso 1 — `/speckit.constitution`**  
Define las reglas de gobierno del proyecto. Produce `memory/constitution.md`. Incluye:
- Nombre del proyecto y principios
- Reglas no negociables (artículos)
- Govierno: versionado, enmiendas
- Ejemplos: Library-First, CLI Interface Mandate, Test-First Imperative

**Paso 2 — `/speckit.specify`**  
Convierte una descripción de funcionalidad en una especificación estructurada. Automatiza:
- Numeración automática de features (001, 002...)
- Creación de rama semántica (`001-feature-name`)
- Generación de `specs/[###-feature]/spec.md` desde plantilla
- **Regla clave**: "Focus on WHAT users need and WHY — avoid HOW to implement"

**Paso 3 — `/speckit.clarify`** (opcional, recomendado)  
Comando de clarificación. Identifica áreas subespecificadas y pide aclaraciones al usuario. Recomendado antes de `/speckit.plan`.

**Paso 4 — `/speckit.plan`**  
Traduce la especificación a un plan técnico. Produce:
- `plan.md` — Arquitectura y decisiones técnicas
- `research.md` — Investigación técnica (comparativas de librerías)
- `data-model.md` — Modelos de datos
- `contracts/` — Contratos de API
- `quickstart.md` — Escenarios de validación clave

**Paso 5 — `/speckit.tasks`**  
Descompone el plan en tareas ejecutables. Produce `tasks.md` con:
- Tareas organizadas por user story
- Grafo de dependencias
- Grupos de paralelización

**Paso 6 — `/speckit.analyze`** (opcional, recomendado)  
Análisis de consistencia cruzada entre spec, plan y tasks. Detecta gaps antes de implementar.

**Paso 7 — `/speckit.checklist`** (opcional)  
Genera checklists de calidad personalizados. Describe como "unit tests for English".

**Paso 8 — `/speckit.implement`**  
Ejecuta todas las tareas y genera la implementación.

### 1.2.3 Workflow completo con quality gates

La documentación oficial (`docs/quickstart.md`) recomienda para producción:

```text
/speckit.constitution
  → /speckit.specify
    → /speckit.clarify        # Reduce ambigüedad
      → /speckit.checklist     # Valida calidad de requisitos
        → /speckit.plan
          → /speckit.tasks
            → /speckit.analyze  # Consistencia cruzada
              → /speckit.implement
                → /speckit.analyze  # Post-implementación (extra)
```

### 1.2.4 Artefactos generados

Por cada feature, se genera:

```
specs/[###-feature-name]/
├── spec.md              # Especificación funcional
├── plan.md              # Plan de implementación
├── research.md          # Investigación técnica
├── data-model.md        # Modelo de datos
├── contracts/           # Contratos de API (REST, WebSocket, etc.)
├── quickstart.md        # Escenarios de validación
└── tasks.md             # Lista de tareas ejecutables
```

---

## 1.3 Mecanismos de calidad incorporados

SpecKit utiliza varios mecanismos para asegurar calidad en sus artefactos:

### 1.3.1 Marcadores de incertidumbre

Las plantillas fuerzan el uso de `[NEEDS CLARIFICATION: specific question]` para marcar ambigüedades. Límite de 3 marcadores por especificación para evitar parálisis.

### 1.3.2 Checklists en plantillas

Las plantillas incluyen checklists de autoverificación:
- "No [NEEDS CLARIFICATION] markers remain"
- "Requirements are testable and unambiguous"
- "Success criteria are measurable"

### 1.3.3 Constitutional Gates

El plan template incluye "Phase -1: Pre-Implementation Gates":
- Simplicity Gate (≤3 proyectos, sin future-proofing)
- Anti-Abstraction Gate (usar framework directamente)
- Integration-First Gate (contratos definidos, contract tests)

### 1.3.4 Test-First Thinking

La plantilla de implementación impone:
1. Crear `contracts/` primero
2. Crear tests en orden: contract → integration → e2e → unit
3. Crear código fuente para que los tests pasen

---

## 1.4 Sistema de extensiones, presets y workflows

SpecKit tiene una arquitectura extensible:

- **Extensions** (~105 comunitarias): Añaden comandos y capacidades (CI Guard, Architecture Guard, integraciones Jira/Linear)
- **Presets** (~22 comunitarios): Personalizan plantillas y terminología (Lean, AIDE, Canon, Product Forge, MAQA)
- **Workflows**: Pipelines multi-paso definidos en YAML con gates de revisión humana y control de flujo
- **Project-local overrides**: Ajustes one-off en `.specify/templates/overrides/`

El workflow built-in "Full SDD Cycle" (`specify workflow run speckit`) automatiza:
```
specify → review-gate → plan → review-gate → tasks → implement
```

---

## 1.5 Filosofía subyacente (SDD)

Según `spec-driven.md`, los principios fundamentales de SDD son:

1. **Specifications as Lingua Franca**: La especificación es el artefacto primario; el código es su expresión
2. **Executable Specifications**: Precisas, completas, no ambiguas para generar sistemas funcionales
3. **Continuous Refinement**: Validación de consistencia continua, no como gate único
4. **Research-Driven Context**: Agentes de investigación recogen contexto técnico
5. **Bidirectional Feedback**: La realidad operativa realimenta la especificación
6. **Branching for Exploration**: Múltiples implementaciones desde una misma spec

El "constitution" (9 artículos) incluye principios como Library-First, CLI Interface Mandate, Test-First Imperative, Simplicity, Anti-Abstraction, Integration-First Testing.

---

## 1.6 Integraciones con agentes AI

SpecKit funciona con 30+ agentes de IA. La integración con Copilot usa comandos slash (`/speckit.*`). Soporta:
- GitHub Copilot Chat
- Claude Code
- Gemini
- Codex CLI
- Windsurf
- Forge, Kiro, etc.
- `generic` como escape hatch

---

## 1.7 Fuentes consultadas

| Fuente | URL | Fecha |
|---|---|---|
| Repositorio oficial | https://github.com/github/spec-kit | Junio 2026 (v0.10.2) |
| Docs site oficial | https://github.github.io/spec-kit/ | Junio 2026 |
| Spec-Driven Development | https://github.com/github/spec-kit/blob/main/spec-driven.md | Commit f92e7e8 (abril 2026) |
| Quickstart Guide | https://github.github.io/spec-kit/quickstart.html | Junio 2026 |
| Workflows reference | https://github.github.io/spec-kit/reference/workflows.html | Junio 2026 |
| README (GitHub) | https://github.com/github/spec-kit#readme | Junio 2026 |
| Community extensions | https://github.github.io/spec-kit/community/extensions.html | Junio 2026 |
| Community presets | https://github.github.io/spec-kit/community/presets.html | Junio 2026 |
