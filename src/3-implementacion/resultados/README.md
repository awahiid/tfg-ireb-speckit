# Resultados de ejecución

## Estructura

Cada ejecución crea una carpeta con timestamp bajo `<flujo>/<repo-id>/`:

```
resultados/
├── C0/appwrite-10832/
│   └── 2026-07-21/123456/        ← YYYY-MM-DD/HHMMSS
│       ├── env/                   ← opencode aislado (DB, auth)
│       ├── trace/
│       │   ├── terminal.log       ← stdout+stderr completo
│       │   └── transcript.json    ← mensajes, tokens, costes
│       ├── metrics/
│       │   ├── costs.csv          
│       │   └── metrics.json       
│       ├── diff.patch             ← cambios en el código
│       ├── changed-files.txt
│       ├── summary.json           ← resumen agregado
│       └── README.md
├── C1/appwrite-10832/...
├── C2/appwrite-10832/...
└── C3/appwrite-10832/...
```

Las re-ejecuciones no sobreescriben: cada una crea su propia subcarpeta con timestamp.

## Artefactos por ejecución

| Archivo | Contenido |
|---|---|
| `summary.json` | Caso, flujo, modelo, duración, ficheros, diff_lines, tokens, coste |
| `metrics.json` | Tokens (input/output/total), coste USD, sesiones analizadas |
| `diff.patch` | Diff completo (`git diff --cached`) |
| `changed-files.txt` | `git diff --stat` |
| `0X-*.md` | Output del modelo en cada paso |
| `0X-prompt.txt` | Prompt enviado al modelo |
| `session-ids.txt` | IDs de sesión opencode |

## Notas

- Todos los archivos son texto plano sin comprimir
- `summary.json` es el artefacto principal para análisis
- Los prompts incluyen los templates oficiales de SpecKit (.github/agents/speckit.*.agent.md)
