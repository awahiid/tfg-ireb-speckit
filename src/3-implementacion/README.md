# Fase 3 — Pipeline de ejecución de SpecKit (observación del flujo SDD)

## ¿Qué es SpecKit y cómo funciona?

SpecKit es un agente de GitHub que opera **dentro de VS Code Copilot Chat**. Su flujo completo recomendado (incluyendo comandos opcionales de calidad) es:

```
specify init
  → /speckit.constitution        (principios rectores)
  → /speckit.specify             (qué construir)
  → /speckit.clarify             (detectar ambigüedades) ← NUEVO
  → /speckit.checklist           (checklist de calidad)  ← NUEVO
  → /speckit.plan                (plan técnico)
  → /speckit.tasks               (descomposición)
  → /speckit.analyze             (consistencia cruzada)  ← NUEVO
  → /speckit.implement           (generación de código)
  → /speckit.analyze             (revisión post)         ← NUEVO
```

Cada comando `/speckit.*` es un **comando de chat** que se escribe en la ventana de Copilot Chat Agent. No es una CLI tradicional. Esto significa que la Fase 3 tiene una parte automatizable (preparación del entorno) y una parte interactiva necesaria (ejecución del agente).

---

## Diseño del pipeline

Para cada requisito se sigue este protocolo:

```
  [Automático]                  [Manual en VS Code]                 [Automático]
  ┌──────────────────┐    ┌─────────────────────────────────┐    ┌──────────────────┐
  │ 1. Clone repo    │    │ 4. /speckit.constitution        │    │ 10. git diff     │
  │ 2. Checkout pre- │────│ 5. /speckit.specify             │────│ 11. snapshot.zip │
  │    PR commit     │    │ 6. /speckit.clarify             │    │ 12. summary.json │
  │ 3. Install deps  │    │ 7. /speckit.checklist           │    │                  │
  │    + verify tests│    │    /speckit.plan                │    │                  │
  └──────────────────┘    │    /speckit.tasks               │    │                  │
                          │ 8. /speckit.analyze             │    │                  │
                          │    /speckit.implement           │    │                  │
                          │ 9. /speckit.analyze             │    │                  │
                          └─────────────────────────────────┘    └──────────────────┘
         preparar-caso.sh            Tú en VS Code                 capturar-resultado.sh
```

---

## IREB Kit para SpecKit

El directorio `ireb-kit/` contiene todos los productos personalizados para ejecutar
el flujo IREB-enhanced (Flow B):

```
ireb-kit/
├── constitution.md          ← Pegar en /speckit.constitution
├── spec-template-ireb.md    ← Plantilla de spec con 12 atributos IREB
├── plan-template-ireb.md    ← Plantilla de plan con gates IREB
├── checklist-ireb.md        ← Checklist de calidad ISO 29148
├── workflow-ireb.yml        ← Pipeline YAML con gates de revisión
├── preset-ireb.yml          ← Preset instalable (specify preset add ireb)
├── prompt-template.md       ← Prompt para generar requisitos con LLM
├── tutorial.md              ← Tutorial paso a paso para el usuario final
└── README.md
```

### `preparar-caso.sh <repo> <case-id> <merge-commit> [requirement]`

Prepara un caso individual. Hace:

1. **Clone + checkout**: clona el repo y hace checkout en el commit **padre del merge commit** (es decir, el código ANTES de que se mergeara la PR original). Esto es el "punto de partida" limpio.
2. **Instalar dependencias**: corre `composer install`, `pip install -r requirements.txt`, etc. según el repo.
3. **Verificar tests**: ejecuta la suite de tests existente para confirmar que el entorno base no está roto.
4. **SpecKit init**: ejecuta `specify init` para preparar la estructura de SpecKit.
5. **Pre-popular spec**: copia el REQ-*.md a `.specify/memory/` para tenerlo a mano al ejecutar `/speckit.specify`.

### `capturar-resultado.sh <case-id>`

Captura el resultado de la implementación de SpecKit. Genera:

| Archivo | Contenido |
|---|---|
| `diff.patch` | Git diff de todos los cambios introducidos |
| `changed-files.txt` | Listado de archivos modificados/creados |
| `summary.json` | Metadata del caso (commit, líneas, archivos) |
| `full-snapshot.zip` | Repositorio completo (sin .git, vendor, node_modules) |

### `preparar-lote.sh <repo>`

Prepara **todos los casos** de un repo de una sola vez. Lee los datos-pr JSON extraídos en la Fase 1 y ejecuta `preparar-caso.sh` para cada uno.

---

## Cómo ejecutar un caso (paso a paso)

### 1. Preparar el entorno

```bash
cd src/3-implementacion

# Para un caso individual:
./scripts/preparar-caso.sh appwrite appwrite-e8 d9ac4f2f2dbd1e24218a627b890358714ff50af7 \
    ../2-requisitos/appwrite/REQ-APPWRITE-10986.md

# O para todos los casos de Appwrite de golpe:
./scripts/preparar-lote.sh appwrite
```

### 2. Ejecutar SpecKit (manual — en VS Code)

```bash
cd src/3-implementation/repos/appwrite-e8
code .
```

En VS Code:
1. Abre **Copilot Chat** y selecciona el **agente** (no el chat normal)
2. Escribe los comandos en orden:

```
/speckit.constitution
```
→ Proporciona principios alineados con RE, por ejemplo:
  'Verificabilidad obligatoria, minimalidad
   (implementar exactamente lo especificado),
   trazabilidad spec→code'

```
/speckit.specify
```
→ Pega el contenido del archivo `REQ-APPWRITE-10986.md` (está en `.specify/memory/requirement-input.md` y originalmente en `src/2-requisitos/appwrite/REQ-APPWRITE-10986.md`)

```
/speckit.clarify           ← NUEVO: identifica ambigüedades en la spec
```

```
/speckit.checklist         ← NUEVO: genera checklist de calidad
```

```
/speckit.plan
```

```
/speckit.tasks
```

```
/speckit.analyze           ← NUEVO: verifica consistencia spec↔plan↔tasks
```

```
/speckit.implement
```

```
/speckit.analyze           ← NUEVO: revisión post-implementación
```

3. Espera a que SpecKit termine en cada paso (puede tomar varios minutos la implementación).

### 3. Capturar el resultado

```bash
./scripts/capturar-resultado.sh appwrite-e8
```

Esto crea `resultados/appwrite-e8/diff.patch`, `summary.json`, `full-snapshot.zip`.

---

## ¿Por qué este diseño?

| Decisión | Justificación |
|---|---|
| **Checkout pre-PR** | El commit `MERGE_COMMIT~1` es el estado del repo antes de que se introdujera el cambio. SpecKit parte de ahí sin conocer la solución. |
| **SpecKit via chat** | SpecKit no tiene API headless. Su interfaz es Copilot Chat Agent. Es la herramienta cuyo flujo SDD estamos observando. |
| **Pipeline ampliado (clarify, checklist, analyze)** | Se añaden los comandos de calidad de SpecKit (clarify, checklist, analyze) para observar el flujo completo que SpecKit ofrece, no solo el subconjunto mínimo. Esto permite un mapeo más completo contra las prácticas IREB. |
| **Constitution personalizado con principios RE** | Se proporcionan principios de verificabilidad, minimalidad y trazabilidad para que el constitution refleje valores de RE en lugar de valores genéricos de desarrollo de librerías (Library-First, TDD). |
| **Snapshot post-ejecución** | El diff generado por SpecKit + el zip completo es el artefacto que se analizará en la Fase 4 para el mapeo. |
| **Sin iteración** | Sólo una ejecución por requisito. Si falla, se registra como fallo. Esto evita que la intervención humana enmascare el comportamiento nativo del pipeline SDD. |

---

## Estructura de directorios

```
src/3-implementacion/
├── README.md
├── constitution.md           ← En ireb-kit/ (9 artículos IREB + Art. 0 anti-alucinación)
├── ireb-kit/                 ← Templates y herramientas para personalizar SpecKit
│   ├── AGENTS.md             ← Reglas R0-R4 para el agente
│   ├── constitution.md       ← Principios IREB (9 artículos)
│   ├── spec.template.md      ← Plantilla de spec con 12 atributos
│   ├── plan.template.md      ← Plantilla de plan con gates IREB
│   ├── tasks.template.md     ← Plantilla de tasks con trazabilidad
│   ├── checklist.template.md ← Checklist ISO 29148 (13 criterios)
│   ├── clarify.template.md   ← Detector de ambigüedades
│   ├── analyze.template.md   ← Matriz de trazabilidad
│   ├── prompt.template.md    ← Prompt para generar REQ desde changelogs
│   ├── pipeline.sh           ← Pipeline automatizado alternativo
│   └── README.md
├── casos-mrs/                ← MRS (Minimal Requirement Seeds) por caso
│   ├── REQ-APPWRITE-10832.txt
│   ├── REQ-AUTHENTIK-10110.txt
│   ├── REQ-CALCOM-26801.txt
│   ├── REQ-DIRECTUS-26646.txt
│   ├── REQ-MEDUSA-13930.txt
│   └── REQ-N8N-30375.txt
├── docs/                     ← Documentación generada por el pipeline
│   ├── trazabilidad.md       ← Matriz de trazabilidad global
│   ├── tasks-template.md     ← Plantilla de descomposición de tareas
│   └── casos/                ← Artefactos por caso (plan, tasks, req)
│       ├── appwrite-10832/
│       ├── authentik-10110/
│       ├── calcom-optin/
│       ├── directus-26646/
│       ├── n8n-30375/
│       └── sku-search-001/
├── scripts/                  ← Scripts de preparación y captura
│   ├── preparar-caso.sh      ← Prepara un caso (clone, checkout, init)
│   ├── preparar-lote.sh      ← Prepara todos los casos de un repo
│   ├── pipeline-flow-a.sh    ← Pipeline Flow A (sin IREB)
│   ├── capturar-resultado.sh ← Captura diff, snapshot y summary
│   └── _archive/             ← Scripts batch/experimentales (no activos)
├── repos/                    ← Repos clonados (infraestructura, no commitear)
└── resultados/               ← Snapshots de implementación
    ├── flujo-kit-v1/         ← Flow B v1 (IREB-enhanced)
    ├── flujo-kit-v2/         ← Flow B v2 (IREB-enhanced mejorado)
    └── flujo-sin-kit/        ← Flow A (baseline, sin IREB)
```
