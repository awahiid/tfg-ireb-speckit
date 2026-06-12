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

## Scripts disponibles

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
├── scripts/
│   ├── preparar-caso.sh
│   ├── capturar-resultado.sh
│   └── preparar-lote.sh
├── repos/                   ← Repos clonados (uno por caso)
├── resultados/                 ← Snapshots de implementación
```
