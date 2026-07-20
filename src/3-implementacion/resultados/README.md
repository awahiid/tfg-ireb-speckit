# Resultados de ejecución

## Estructura

Cada ejecución crea una carpeta con timestamp bajo `<flujo>/<caso>/`:

```
resultados/
├── C0/{caso}/
│   └── 2026-07-19/173000/    ← timestamp: YYYY-MM-DD/HHMMSS
│       ├── summary.json
│       ├── metrics.json
│       ├── diff.patch
│       ├── changed-files.txt
│       ├── README.md
│       ├── 00-input-changelog.txt
│       ├── 01-specify.md          (y prompt)
│       ├── 02-plan.md             (y prompt)
│       ├── 03-tasks.md            (y prompt)
│       ├── 04-implement.md        (y prompt)
│       └── session-ids.txt
├── C1/{caso}/YYYY-MM-DD/HHMMSS/
├── C2/{caso}/YYYY-MM-DD/HHMMSS/
└── C3/{caso}/YYYY-MM-DD/HHMMSS/
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
