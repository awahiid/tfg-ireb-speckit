# Resultados de ejecución

Este directorio contiene los resultados de 24 ejecuciones experimentales (6 repos × 4 flujos) que comparan
distintos niveles de guiado por requisitos en la generación de código con IA.

> ⚠️ **Seguridad**: Los `auth.json` en `env/` están **sanitizados automáticamente**
> al finalizar cada pipeline (el contenido se reemplaza por un marcador). La API key
> se inyecta durante la ejecución desde `OPENCODE_API_KEY` o desde `~/.local/share/opencode/auth.json`,
> pero nunca persiste en los resultados. Consulta `.env.example`.

---

## Índice

1. [Diseño experimental](#1-diseño-experimental)
2. [Los 4 flujos (C0–C3)](#2-los-4-flujos-c0-c3)
3. [Tecnología base](#3-tecnología-base)
4. [Arquitectura de la ejecución](#4-arquitectura-de-la-ejecución)
5. [Estructura de resultados](#5-estructura-de-resultados)
6. [Métricas capturadas](#6-métricas-capturadas)
7. [Decisiones de diseño](#7-decisiones-de-diseño)
8. [Casos de estudio](#8-casos-de-estudio)

---

## 1. Diseño experimental

### Objetivo

Medir cómo afecta la formalidad del guiado por requisitos (IREB CPRE) a la calidad,
coste y tiempo de la implementación automática de PRs en repositorios open-source reales.

### Variable independiente

El **flujo de trabajo** que sigue el agente IA para implementar un PR:

| Flujo | Guiado | Pasos |
|---|---|---|
| **C0** | SpecKit vanilla (mínimo) | 4 |
| **C1** | SpecKit + IREB Kit v1 | 8 |
| **C2** | SpecKit + IREB Kit v2 | 9 |
| **C3** | Vibe coding (sin guiado) | 1 |

### Variable dependiente

- Coste en USD por implementación
- Tokens consumidos (input / output / total)
- Número de sesiones y mensajes
- Tiempo de ejecución
- Archivos modificados y líneas de diff
- Trazabilidad REQ → spec → plan → tasks → code (via analyze)

### Repositorios objetivo

6 repositorios open-source reales, cada uno con 1 PR seleccionado:

| Repo | PR | Descripción |
|---|---|---|
| appwrite | 10832 | cached documents list |
| authentik | 10110 | admin: system api: fix FIPS status schema |
| calcom | 26812 | fix(api): use cal.com for bookingUrl in platform organizations |
| directus | 26646 | Add MIME type restriction to system upload interface |
| medusa | 13930 | — |
| n8n | 31371 | fix(MongoDB Node): Validate update key value type |

### Modelo utilizado

**DeepSeek v4-flash** (`deepseek/deepseek-v4-flash`) en todas las ejecuciones,
vía [opencode](https://github.com/opencode-ai/opencode) como agente CLI.

---

## 2. Los 4 flujos (C0–C3)

### C0 — SpecKit vanilla (4 pasos)

SpecKit es un framework de especificación progresiva que guía al agente a través de
etapas de análisis antes de escribir código. Usa ficheros `.agent.md` en
`.github/agents/` como prompts oficiales.

**Secuencia**: `specify → plan → tasks → implement`

1. **`/speckit.specify`** — Analiza el changelog/issue y produce un `spec.md`
   con requisitos funcionales, criterios de verificación y modelo de datos.
2. **`/speckit.plan`** — A partir del spec, genera un `plan.md` con decisiones
   de arquitectura, descomposición y orden de implementación.
3. **`/speckit.tasks`** — Descompone el plan en tareas concretas (`tasks.md`).
4. **`/speckit.implement`** — Ejecuta las tareas, escribiendo el código directamente
   en el repositorio.

No hay intervención de IREB — es el baseline mínimo de guiado.

### C1 — SpecKit + IREB Kit v1 (8 pasos)

Añade una **constitución IREB** y **templates override** para cada paso de SpecKit.
Los templates IREB añaden directrices de ingeniería de requisitos a los prompts
nativos de SpecKit.

**Secuencia**: `constitution → specify → clarify → checklist → plan → tasks → implement → analyze`

1. **`/speckit.constitution`** — Carga la constitución IREB en la memoria del agente.
   Establece los principios rectores (trazabilidad, completitud, verificabilidad).
2. **`/speckit.specify`** — Sobrescrito con template IREB: exige REQ-ID, criterios
   de verificación, y trazabilidad a la fuente original.
3. **`/speckit.clarify`** — Paso de clarificación: el agente identifica ambigüedades
   en el requisito y las resuelve automáticamente (sin preguntar al usuario).
4. **`/speckit.checklist`** — Genera listas de verificación basadas en los criterios
   del spec, para validar la implementación después.
5. **`/speckit.plan`** — Plan con más estructura: decisiones arquitectónicas
   trazables a REQ-IDs, priorización, y análisis de impacto.
6. **`/speckit.tasks`** — Descomposición en tareas con asignación a REQ-IDs.
7. **`/speckit.implement`** — Implementación siguiendo las tareas.
8. **`/speckit.analyze`** — **Post-implement** (ver decisión de diseño más abajo).
   Construye una matriz de trazabilidad REQ → spec → plan → tasks → code → tests,
   identificando eslabones rotos y código huérfano.

### C2 — SpecKit + IREB Kit v2 (anti-scope-creep, 9 pasos)

Variante del v1 con un **scope contract** explícito entre tasks e implement,
diseñado para evitar que el agente añada funcionalidades no solicitadas.

**Secuencia**: `constitution → specify → clarify → checklist → plan → tasks → scope-contract → implement → analyze`

Los pasos 1–7 son idénticos a C1. La diferencia clave:

7. **`/speckit.scope-contract`** (paso 7.5) — Antes de implementar, el agente
   produce un contrato de alcance que declara explícitamente:
   - **ARCHIVOS A TOCAR**: lista concreta
   - **ARCHIVOS PROHIBIDOS**: qué no modificar
   - **COMPORTAMIENTO EXACTO**: descripción precisa del cambio
   - **NO**: refactorizar, añadir features, borrar código, modificar configs,
     añadir dependencias

### C3 — Vibe coding puro (1 paso)

**Sin SpecKit, sin IREB, sin guiado estructurado.** El agente recibe un único
prompt con el MRS (Model Requirements Specification) extraído de la carpeta
`2.5-prompts/`. El prompt dice esencialmente: "implementa esto".

Es el control negativo: el mínimo absoluto de guiado, representante del enfoque
"vibe coding" donde simplemente se le pide al modelo que haga algo.

### Decisión de diseño: analyze post-implement

En C1 y C2, el paso `/speckit.analyze` se ejecuta **al final** (después de implementar),
no en su orden natural (que sería antes de implementar, como paso 7/9).

**Motivación**: Si analyze se ejecuta antes de implementar, la matriz de trazabilidad
está vacía — no hay código que trazar. Al ejecutarlo después, el analyze puede:
- Examinar el diff real generado
- Verificar que cada archivo modificado corresponde a una tarea
- Detectar código huérfano (archivos tocados sin REQ-ID)
- Detectar requisitos no implementados

El analyze **no bloquea** la implementación — si falla o da timeout, el pipeline
continúa y los resultados (diff, métricas) ya están capturados.

---

## 3. Tecnología base

### opencode

[opencode](https://github.com/opencode-ai/opencode) es un agente CLI que ejecuta
tareas de codigo usando modelos de IA. Características clave:

- Ejecuta prompts directamente: `opencode run "mensaje" --model provider/model`
- Almacena sesiones en SQLite (`opencode.db`) con mensajes, tokens y costes
- Soporta exportación de sesiones a JSON (`opencode export <session-id>`)
- Las credenciales se guardan en `~/.local/share/opencode/auth.json`

En este experimento se usa en **modo no interactivo**: se inyecta un preámbulo
en cada prompt con directrices estrictas para que el agente nunca pregunte ni
pida confirmación (ver `lib.sh` → `oc_run()`).

### SpecKit

SpecKit (GitHub) es un framework de especificación progresiva que proporciona:

- **Agentes oficiales** en `.github/agents/speckit.{command}.agent.md`
- **Comandos**: `specify`, `plan`, `tasks`, `implement`, `clarify`, `checklist`,
  `analyze`, `constitution`
- **Integración con Copilot** vía `.specify/integrations/copilot.manifest.json`
- **Templates overrides** para personalizar cada paso

### IREB Kit v1 y v2

Los kits IREB son colecciones de templates que sobrescriben los prompts nativos
de SpecKit con directrices de ingeniería de requisitos basadas en:

- IREB CPRE (Certified Professional for Requirements Engineering)
- ISO 29148 (Ingeniería de requisitos para sistemas y software)
- INCOSE (Traceability)

Cada kit contiene:
- `constitution.md` → se carga en `.specify/memory/` como constitución
- `{comando}.template.md` → se copia a `.specify/templates/overrides/` para
  sustituir el prompt nativo de SpecKit

**v1 vs v2**: La diferencia principal es que v2 incluye un **scope contract**
explícito y templates más restrictivos para anti-scope-creep.

### Git worktrees

Los worktrees permiten tener varios checkouts del mismo repo simultáneamente
sin duplicar el historial. Se crean desde bare repos en `.bare/<repo>.git`.

---

## 4. Arquitectura de la ejecución

### Visión general

```
casos.json ────→ pipeline-cx.sh ──→ pipeline-c0/c1/c2/c3.sh
                    │                      │
                    │               ┌──────┴──────┐
                    │               │   lib.sh     │
                    │               └──────┬──────┘
                    │                      │
                    ├── init_output_dir()   → crea resultados/{Cx}/{repo-id}/{timestamp}/
                    │                          ├── env/          (HOME aislado)
                    │                          ├── trace/        (logs + transcripts)
                    │                          └── metrics/      (costes)
                    │
                    ├── oc_create_worktree()  → git worktree add desde .bare/<repo>.git
                    │
                    ├── oc_speckit_init()     → uvx specify init --here
                    │
                    ├── oc_apply_kit()        → copia templates IREB
                    │
                    ├── oc_run()              → opencode run con HOME aislado
                    │
                    ├── oc_capture_diff()     → git diff --cached > diff.patch
                    │
                    ├── oc_capture_metrics()  → opencode export + costs.csv
                    │
                    ├── oc_save_generated()   → copia archivos a generated/
                    │
                    ├── oc_summary()          → summary.json + README.md
                    │
                    └── oc_sanitize_auth()    → elimina credenciales de env/
```

### Flujo completo (ejemplo: C1 con authentik-10110)

```
1. Leer casos.json → obtener pre_pr (commit padre del PR), summary
2. init_output_dir → crear timestamp dir con env/ trace/ metrics/
3. Inyectar API key en env/.local/share/opencode/auth.json
   (desde OPENCODE_API_KEY o copiando de ~/.local/share/)
4. oc_create_worktree → git worktree add desde .bare/authentik.git
5. oc_speckit_init → uvx specify init en el worktree
6. oc_apply_kit → copiar templates IREB v1
7. Para cada paso del flujo:
   a. oc_load_agent_prompt → leer .github/agents/speckit.{cmd}.agent.md
   b. oc_run → opencode run con HOME=$OUTPUT_DIR/env
   c. opencode escribe archivos directamente en el worktree
8. oc_capture_diff → git add -A; git diff --cached > diff.patch
9. oc_capture_metrics → opencode session list + export → metrics.json
10. oc_save_generated → copia archivos modificados a generated/
11. oc_summary → consolidar todo en summary.json
12. oc_sanitize_auth → reemplazar auth.json por marcador
13. trap EXIT → oc_remove_worktree
```

### Aislamiento

Cada ejecución es **totalmente aislada**:

- **HOME aislado**: `HOME=$OUTPUT_DIR/env` para que opencode no contamine
  ni sea contaminado por otras ejecuciones
- **Worktree propio**: cada pipeline crea su propio worktree desde bare repos,
  evitando conflictos entre ejecuciones paralelas
- **Timestamp único**: los resultados nunca se sobrescriben — cada re-ejecución
  crea su propia carpeta con `YYYY-MM-DD/HHMMSS`
- **Trap EXIT**: el worktree se elimina automáticamente al terminar (incluso
  si el script falla)

### Control de no-interactividad

Cada prompt que se envía al agente incluye un preámbulo que fuerza el modo
no interactivo:

```
## AUTOMATED PIPELINE — RULES
1. Never ask questions.
2. Never stop for gates.
3. Always produce output.
4. No interactive prompts.
5. Execute and produce.
FAILURE MODE: If you ask a question, the pipeline will hang until timeout.
```

Esto es crítico: sin esta guarda, el agente podría preguntar "¿qué hago con
este caso ambiguo?" y bloquear el pipeline hasta timeout.

---

## 5. Estructura de resultados

Cada ejecución produce un directorio autocontenido:

```
resultados/
├── C0/appwrite-10832/
│   └── 2026-07-21/123456/        ← YYYY-MM-DD/HHMMSS (nunca se sobreescribe)
│       ├── env/                   ← HOME aislado de opencode (~8MB con node_modules)
│       │   └── .local/share/opencode/
│       │       ├── opencode.db    ← sesiones, mensajes, tokens (SQLite)
│       │       ├── auth.json      ← SANITIZADO al finalizar
│       │       └── log/           ← logs internos de opencode (vaciados al finalizar)
│       ├── trace/
│       │   ├── terminal.log       ← stdout+stderr completo del pipeline
│       │   └── transcript.json    ← última sesión exportada (mensajes + costes)
│       ├── metrics/
│       │   ├── costs.csv          ← coste por sesión (una fila por sesión)
│       │   └── metrics.json       ← agregado de todas las sesiones
│       ├── diff.patch             ← git diff --cached (código generado)
│       ├── changed-files.txt      ← git diff --cached --stat
│       ├── generated/             ← copia de los archivos generados (sin git)
│       │   ├── .specify/          ← artefactos de SpecKit
│       │   ├── (archivos modificados)
│       │   └── summary.json
│       ├── 00-input-changelog.txt ← input original (summary del PR)
│       ├── summary.json           ← resumen consolidado (tiempo, tokens, coste)
│       └── README.md              ← resumen legible
├── C1/appwrite-10832/...
├── C2/appwrite-10832/...
└── C3/appwrite-10832/...
```

### ¿Qué NO se almacena (y por qué)?

- **Worktree**: se crea temporalmente y se elimina al terminar (trap EXIT).
  Ocuparía ~1GB por repo si persistiera.
- **node_modules completos**: aunque `env/` contiene node_modules de opencode,
  no se copian los del repo objetivo.
- **Copias redundantes de artefactos SpecKit**: el `diff.patch` captura todo
  el código generado. La carpeta `generated/` añade una copia plana para
  inspección rápida sin aplicar el patch.

---

## 6. Métricas capturadas

### Por sesión (costs.csv)

Extraídas via `opencode export <session-id>` + script Python:

| Columna | Descripción |
|---|---|
| `session_id` | ID único de opencode |
| `messages` | Número de mensajes en la sesión |
| `input_tokens` | Tokens de entrada (prompt + contexto) |
| `output_tokens` | Tokens de salida (respuesta del modelo) |
| `total_tokens` | Suma input + output |
| `cost_usd` | Coste estimado en USD |
| `model` | Proveedor/modelo usado |

### Agregadas (metrics.json)

| Campo | Descripción |
|---|---|
| `sessions_analyzed` | Sesiones encontradas (1 por paso de pipeline) |
| `total_messages` | Suma de mensajes |
| `input_tokens` | Tokens de entrada totales |
| `output_tokens` | Tokens de salida totales |
| `total_tokens` | Tokens totales |
| `total_cost_usd` | Coste total en USD |
| `model` | Modelo utilizado |

### Por ejecución (summary.json)

| Campo | Descripción |
|---|---|
| `case` | `{repo}-{req-id}` |
| `flow` | Nombre del flujo (C0/C1/C2/C3) |
| `model` | Modelo utilizado |
| `elapsed_seconds` | Tiempo real de ejecución |
| `files_created` | Archivos modificados (del diff) |
| `diff_lines` | Líneas totales del diff |
| `tokens` | Tokens totales (de metrics) |
| `cost_usd` | Coste total (de metrics) |
| `sessions` | Sesiones analizadas (de metrics) |

### Cálculo de costes

El coste se calcula a partir de los precios del modelo declarados por opencode.
Para DeepSeek v4-flash: $0.15/1M input tokens, $0.60/1M output tokens.
El coste total se obtiene sumando `info.cost` de cada mensaje en la sesión
exportada.

---

## 7. Decisiones de diseño

### ¿Por qué worktrees en lugar de clonar?

Los worktrees comparten el almacenamiento Git (objetos) con el bare repo,
evitando duplicar el historial. Crear un clon completo de cada repo para cada
ejecución (24×) habría ocupado >10GB.

### ¿Por qué HOME aislado?

opencode guarda la sesión en `~/.local/share/opencode/opencode.db`. Sin
aislamiento, 24 ejecuciones paralelas mezclarían sus sesiones en la misma DB.
Además, el HOME aislado permite:
- Capturar la DB exacta de cada pipeline
- Evitar contaminación entre ejecuciones
- Poder borrar `env/` sin afectar al sistema

### ¿Por qué no se usa `set -e`?

Cada paso del pipeline decide si un fallo es crítico o no. Por ejemplo:
- Si `specify` falla → warning, pero se puede continuar
- Si `implement` falla → error, se aborta (no hay código que analizar)
- Si `analyze` falla → warning (el diff ya está capturado)

### ¿Por qué analyze al final en C1/C2?

Ver sección [Decisión de diseño: analyze post-implement](#decisión-de-diseño-analyze-post-implement).

### ¿Por qué la sanitización automática de auth.json?

La API key se necesita durante la ejecución (opencode la lee de
`env/.local/share/opencode/auth.json`). Si el pipeline falla a mitad o el
usuario olvida limpiar, la key quedaría en los resultados. La función
`oc_sanitize_auth()` se ejecuta **siempre** al final (esté en `trap` o
explícitamente tras `oc_summary`), reemplazando todo el contenido del
`auth.json` por un marcador y vaciando los logs internos de opencode.

### ¿Por qué no se almacenan los prompts de cada paso por separado?

El `transcript.json` exportado contiene la conversación completa con todos los
mensajes (prompts incluidos). Almacenar cada prompt por separado sería
redundante. La excepción es el `00-input-changelog.txt` que documenta el input
original del problema.

---

## 8. Casos de estudio

Los casos están registrados en `casos.json` con esta estructura:

```json
{
  "appwrite": {
    "reqs": {
      "10832": {
        "summary": "cached documents list",
        "pre_pr": "8368a28ff5de~1"
      }
    }
  }
}
```

- `pre_pr`: commit padre del PR (el ~1 indica el commit anterior). El worktree
  se crea en este punto para simular el estado del repo antes del PR.
- `summary`: descripción corta del PR, usada como input en C0 y C3.
- `requisitos_map`: algunos repos (como calcom) tienen nombres distintos entre
  el directorio del repo y el de requisitos.

Los requisitos formales (REQ-*.md) están en `src/2-requisitos/` y se usan como
input en C1 y C2 (donde el pipeline necesita el requisito completo, no solo el
summary).

---

## Ejecución de pipelines

```bash
cd /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion

# Configurar key (opción 1 — recomendada)
export OPENCODE_API_KEY="sk-tu-key-aqui"

# Configurar key (opción 2 — archivo)
# echo '{"deepseek":{"type":"api","key":"sk-tu-key-aqui"}}' > ~/.local/share/opencode/auth.json

# Ejecutar
OPENCODE_MODEL=deepseek/deepseek-v4-flash PIPELINE_TIMEOUT=3600 \
  bash scripts/pipeline-cx.sh <repo> <req-id>

# Equivalente directo:
OPENCODE_MODEL=deepseek/deepseek-v4-flash PIPELINE_TIMEOUT=3600 \
  bash scripts/pipeline-c2.sh authentik 10110
```

### Variables de entorno

| Variable | Default | Descripción |
|---|---|---|
| `OPENCODE_MODEL` | `deepseek/deepseek-v4-flash` | Modelo de IA |
| `PIPELINE_TIMEOUT` | `300` | Timeout por paso (segundos) |
| `OPENCODE_API_KEY` | — | API key (alternativa a auth.json) |
| `OPENCODE_BIN` | `opencode` | Ruta del binario |
| `OPENAI_API_BASE` | — | URL base alternativa de API |
