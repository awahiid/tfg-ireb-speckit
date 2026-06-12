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
├── 3-implementacion/               ← FASE 3: Pipeline SpecKit
│   ├── scripts/                    ← Automatización del pipeline
│   │   ├── preparar-caso.sh        ← Prepara un caso (clone + checkout)
│   │   ├── capturar-resultado.sh   ← Captura diff post-SpecKit
│   │   └── preparar-lote.sh        ← Prepara todos los casos de un repo
│   ├── repos/                      ← Git clones (auto-generado)
│   └── resultados/                 ← Snapshots de implementación
│
├── 4-evaluacion/                   ← FASE 4: Evaluación SRCI
│   └── (pendiente de completar)
│
└── _original/                      ← Archivos originales sin modificar
    ├── scripts/pr-bundle/          ← Script de extracción de PRs
    ├── speckit-tutorial/           ← Tutorial de SpecKit
    ├── cal-reportes/               ← Reportes previos de cal.com
    ├── metodologia.md / v1.md      ← Versiones anteriores de la metodología
    └── ...
```