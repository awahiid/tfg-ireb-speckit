# src — Pipeline de laboratorio del TFG

## Estructura

```
src/
├── metodologia.md                  ← Metodología completa (Fases 1–4)
│
├── 1-evidencia/                    ← FASE 1: Extracción de evidencia
│   ├── <repo>.json                 ← Catálogo de cambios por repositorio
│   ├── pr-bundles/                 ← PR bundles raw (GitHub API)
│   ├── informes/                   ← Informes de selección de evidencia
│   ├── repositorios.md             ← Clasificación por tipo de sistema
│   ├── rubrica.md                  ← Rúbrica de selección IR-QM v3
│   └── plantilla.json / .md        ← Plantillas
│
├── 2-requisitos/                   ← FASE 2: Requisitos formalizados
│   ├── <repo>/REQ-*-NNNNN.md       ← Requisitos por repositorio
│   ├── plantilla.md                ← Plantilla IREB/ISO 29148
│   └── rubrica.md                  ← Rúbrica de formalización
│
├── 2.5-prompts/                    ← FASE 2.5: Derivación MRS
│   ├── instrucciones.md            ← Instrucciones para el agente derivador
│   ├── README.md                   ← Documentación de la fase
│   ├── generate_mrs.py             ← Script de generación automatizada
│   └── mrs-prompts.md              ← Salida: 52 MRS generados
│
├── 3-implementacion/               ← FASE 3: Pipeline SpecKit (4 flujos)
│   ├── scripts/                    ← Automatización del pipeline
│   │   ├── lib.sh                  ← Funciones compartidas
│   │   ├── pipeline-c0.sh          ← C0: SpecKit vanilla (4 pasos)
│   │   ├── pipeline-c1.sh          ← C1: SpecKit + IREB v1 (9 pasos)
│   │   ├── pipeline-c2.sh          ← C2: SpecKit + IREB v2 (10 pasos)
│   │   ├── pipeline-c3.sh          ← C3: MRS directo (1 paso)
│   │   └── capturar-metricas.sh    ← Extrae tokens/coste
│   ├── ireb-kit-v1/                ← Plantillas IREB v1
│   ├── ireb-kit-v2/                ← Plantillas IREB v2 + AGENTS.md
│   ├── .bare/                      ← Bare repos para worktrees
│   ├── resultados/                 ← Snapshots C0-C3
│   ├── .env                        ← Configuración (modelo, API key)
│   └── reqs.json                   ← Registro de casos
│
├── 4-evaluacion/                   ← FASE 4: Evaluación en dos fases
│   ├── rubrica-evaluacion.md       ← Rúbrica SRCI v3 (5 bloques)
│   ├── scripts/
│   │   └── analisis-automatico/    ← aauto.py, atodo.py, linters
│   └── evaluaciones/               ← Informes C0-C3
│
└── _original/                      ← Archivos originales sin modificar
    ├── scripts/pr-bundle/          ← Script de extracción de PRs
    ├── speckit-tutorial/           ← Tutorial de SpecKit
    ├── cal-reportes/               ← Reportes previos de cal.com
    ├── metodologia.md / v1.md      ← Versiones anteriores de la metodología
    └── ...
```