# Resultados de ejecución

Cada ejecución produce un directorio autocontenido con traza, métricas y diff.
El worktree Git se crea temporalmente y se elimina al finalizar.

## Estructura

```
resultados/
├── C0/appwrite-10832/
│   └── 2026-07-21/123456/        ← YYYY-MM-DD/HHMMSS
│       ├── env/                   ← opencode aislado (~8MB)
│       │   └── .local/share/opencode/
│       │       ├── opencode.db    ← sesiones, mensajes, tokens
│       │       └── auth.json      ← API key (copiado al iniciar)
│       ├── trace/
│       │   ├── terminal.log       ← stdout+stderr completo
│       │   └── transcript.json    ← sesión exportada (mensajes + costes)
│       ├── metrics/
│       │   ├── costs.csv          ← coste por sesión
│       │   └── metrics.json       ← agregado de todas las sesiones
│       ├── diff.patch             ← TODO el código generado por el agente
│       ├── changed-files.txt      ← git diff --stat
│       ├── summary.json           ← resumen: tiempo, tokens, coste
│       └── README.md
├── C1/appwrite-10832/...
├── C2/appwrite-10832/...
└── C3/appwrite-10832/...
```

No se almacenan archivos redundantes:
- **Sin worktree**: se crea para ejecutar y se elimina al terminar
- **Sin copias de artefactos**: el `diff.patch` captura todos los archivos
- **Sin prompts separados**: el `transcript.json` tiene el prompt y la respuesta

## Notas

- `summary.json` es el artefacto principal para análisis comparativo
- `diff.patch` permite reconstruir todos los cambios con `git apply`
- `env/opencode.db` contiene la sesión completa (exportable con `opencode export`)
- Cada re-ejecución crea su propia carpeta con timestamp — nunca se sobreescribe
