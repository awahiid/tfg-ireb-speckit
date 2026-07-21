# Fase 3 — Ejecución de pipelines

## Objetivo del experimento

Evaluar 4 condiciones experimentales para la implementación de requisitos
software con agentes IA. Cada pipeline recibe un requisito real de un proyecto
open-source y pide a un agente (opencode + DeepSeek) que lo implemente.

## Flujos experimentales

| Flujo | Script | Prompt | Descripción |
|---|---|---|---|
| **C0** | `pipeline-c0.sh` | SpecKit vanilla | El agente sigue el flujo SpecKit estándar (specify → plan → tasks → implement) |
| **C1** | `pipeline-c1.sh` | SpecKit + IREB v1 | SpecKit con plantillas y constitución basadas en IREB CPRE (9 pasos) |
| **C2** | `pipeline-c2.sh` | SpecKit + IREB v2 | Igual que C1 + contrato de alcance anti-scope-creep (10 pasos) |
| **C3** | `pipeline-c3.sh` | MRS directo | Sin SpecKit. Se pasa el MRS (especificación en lenguaje natural) directamente |

Los prompts se leen de `casos.json` y los ficheros generados en fases anteriores
(`2.5-prompts/` para MRS, `2-requisitos/` para los requisitos IREB).

## Estructura del proyecto

```
src/3-implementacion/
├── scripts/
│   ├── lib.sh                ← Funciones compartidas
│   ├── pipeline-c0.sh        ← C0: SpecKit vanilla (4 pasos)
│   ├── pipeline-c1.sh        ← C1: SpecKit + IREB v1 (9 pasos)
│   ├── pipeline-c2.sh        ← C2: SpecKit + IREB v2 (10 pasos)
│   ├── pipeline-c3.sh        ← C3: Vibe coding puro (1 prompt)
│   └── capturar-metricas.sh  ← Extrae tokens/coste de opencode
├── ireb-kit-v1/              ← Plantillas y constitución IREB v1
├── ireb-kit-v2/              ← Plantillas y constitución IREB v2
├── repos/                    ← Repositorios clonados de proyectos open-source
├── resultados/               ← Resultados de ejecución (ver abajo)
└── casos.json                ← Registro de casos (repo, commit pre-PR, resumen)
```

## Registro de casos (`casos.json`)

Cada caso experimental se define en `casos.json` con la estructura:

```json
{
  "appwrite": {
    "reqs": {
      "10832": {
        "summary": "Resumen del PR o requisito",
        "pre_pr": "a71f3555ae"
      }
    }
  }
}
```

- **Clave raíz**: nombre del repo (`appwrite`, `authentik`, etc.)
- **`reqs`**: map de ID de requisito → datos del caso
- **`summary`**: texto descriptivo que se usa como changelog en C0
- **`pre_pr`**: commit padre del merge (punto de partida limpio para el pipeline)

Los pipelines resuelven automáticamente:
- Ruta al repo: `repos/<repo>/`
- Ruta al MRS: `2.5-prompts/<repo>/REQ-<REPO>-<ID>.md`
- Ruta al requisito IREB: `2-requisitos/<repo>/REQ-<REPO>-<ID>.md`

## Aislamiento: `env/`

Cada ejecución crea un directorio `env/` que actúa como `$HOME` temporal para
opencode. Todas las sesiones, DBs y conversaciones se almacenan ahí:

```
resultados/C3/appwrite-10832/2026-07-21/123456/
├── env/                          ← HOME aislado
│   └── .local/share/opencode/
│       ├── opencode.db           ← solo sesiones de esta ejecución
│       └── auth.json             ← copia del API key
├── trace/                        ← traza completa de la ejecución
│   ├── terminal.log              ← stdout+stderr combinado
│   └── transcript.json           ← mensajes, tokens y costes por sesión
├── metrics/                      ← costs.csv, metrics.json
├── diff.patch                    ← cambios en el código generados
├── summary.json                  ← resumen agregado
└── changed-files.txt             ← lista de archivos modificados
```

Ventajas del aislamiento:
- **Reproducible**: cada ejecución es autocontenida
- **Inspectable**: abres la carpeta y ves todo lo que pasó
- **Portable**: puedes llevarte la carpeta a otra máquina

## Uso

Cada pipeline acepta dos argumentos: repo e ID de requisito.
Los pipelines buscan el resto en `casos.json` y resetean el repo automáticamente.

### Ejecución individual

```bash
# C3 — Vibe coding (más rápido, 1 solo prompt)
./scripts/pipeline-c3.sh appwrite 10832

# C0 — SpecKit vanilla
./scripts/pipeline-c0.sh appwrite 10832

# C1 — SpecKit + IREB v1
./scripts/pipeline-c1.sh appwrite 10832

# C2 — SpecKit + IREB v2
./scripts/pipeline-c2.sh appwrite 10832
```

### Ejecución secuencial completa

```bash
MODEL=deepseek/deepseek-v4-flash
TIMEOUT=900
for flow in c3 c0 c1 c2; do
  OPENCODE_MODEL=$MODEL PIPELINE_TIMEOUT=$TIMEOUT \
    bash scripts/pipeline-$flow.sh appwrite 10832
done
```

### Variables de entorno

| Variable | Defecto | Descripción |
|---|---|---|
| `OPENCODE_MODEL` | `deepseek/deepseek-v4-flash` | Modelo para opencode |
| `PIPELINE_TIMEOUT` | `900` | Timeout por paso (segundos) |

## Salida de cada ejecución

```
resultados/<flujo>/<repo-id>/YYYY-MM-DD/HHMMSS/
├── env/                   ← opencode aislado (DB, auth, sesiones)
├── trace/
│   ├── terminal.log       ← stdout+stderr completo
│   └── transcript.json    ← mensajes, tokens, costes
├── metrics/
│   ├── costs.csv          ← coste por sesión
│   └── metrics.json       ← métricas agregadas
├── diff.patch             ← diff del código generado
├── changed-files.txt      ← git diff --stat
├── summary.json           ← resumen: tiempo, tokens, coste
└── README.md              ← resumen legible
```

## lib.sh — Helpers compartidos

Todos los pipelines usan `scripts/lib.sh`:
- `oc_run` — ejecuta opencode `--pure`, captura stderr, extrae session IDs
- `oc_extract_code` — extrae bloques de código (stdout limpio: solo el número)
- `oc_capture_diff` — `git add -A && git diff --cached` (incluye archivos nuevos)
- `oc_extract_mrs` — extrae MRS de ficheros `2.5-prompts/*.md`
- `oc_capture_metrics` — tokens/coste desde sesiones opencode
- `oc_summary` — genera `summary.json` + `README.md`
- **Sin `set -e`**: cada paso decide si un fallo es crítico o no.
