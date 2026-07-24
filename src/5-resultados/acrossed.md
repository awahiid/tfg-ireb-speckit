# Análisis cruzado — 24 requisitos × 4 flujos

**Generado**: 2026-07-23 19:45
**Total evaluaciones**: 96 (24 casos × 4 flujos)

## Descripción de métricas

- **F1 vs PR real**: Similaridad F1 entre archivos generados y el PR real del repositorio.
- **Precisión vs PR real**: Fracción del código generado que aparece en el PR real.
- **Recall vs PR real**: Fracción del PR real cubierta por el código generado.
- **Artefactos (encontrados/esperados)**: Ratio de artefactos IREB generados vs esperados según el diseño del flujo (C0: spec.md; C1: +constitution, clarify, analyze; C2: +scope-contract; C3: ninguno).
- **Coste medio ($)**: Coste en USD de la ejecución del pipeline (API calls).
- **Tokens medios**: Tokens totales consumidos (entrada + salida).
- **Líneas de código (cloc)**: Líneas de código fuente generadas (excluye docs/.md).
- **Archivos fuente**: Archivos de código generados (solo extensiones de código).
- **Incidencias semgrep**: Vulnerabilidades/defectos detectados por semgrep.
- **Incidencias linters**: Problemas de estilo/calidad (ESLint, etc.).

## 1. Comparativa global por flujo

| Métrica | SpecKit vanilla | IREB v1 | IREB v2 | Vibe Coding |
|--------|--------|--------|--------|--------|
| **F1 vs PR real** | 0.46 | 0.52 | 0.62 | 0.62 |
| **Precisión vs PR real** | 49.5% | 53.2% | 70.2% | 83.0% |
| **Recall vs PR real** | 54.0% | 64.8% | 62.5% | 57.8% |
| **Artefactos (encontrados/esperados)** | 100% | 48% | 57% | 0% |
| **Coste medio ($)** | $0.0573 | $0.0915 | $0.0763 | $0.0191 |
| **Tokens medios** | 4,877,245 | 6,686,810 | 4,642,567 | 1,608,276 |
| **Líneas de código (cloc)** | 13453 | 19696 | 12491 | 3221 |
| **Archivos fuente** | 14 | 15 | 15 | 3 |
| **Incidencias semgrep** | 0 | 0 | 0 | 0 |
| **Incidencias linters** | 126 | 2096 | 1068 | 364 |
## 2. Métricas por flujo

### C0 — SpecKit vanilla

- **Artefactos (flow)**: 1.0/10
- **F1 vs PR real**: 0.46
- **Calidad código**: 0 semgrep, 126 linters
- **Tamaño**: 14 archivos, 13453 líneas
- **Coste**: $0.0573

### C1 — IREB v1

- **Artefactos (flow)**: 0.5/10
- **F1 vs PR real**: 0.52
- **Calidad código**: 0 semgrep, 2096 linters
- **Tamaño**: 15 archivos, 19696 líneas
- **Coste**: $0.0915

### C2 — IREB v2

- **Artefactos (flow)**: 0.6/10
- **F1 vs PR real**: 0.62
- **Calidad código**: 0 semgrep, 1068 linters
- **Tamaño**: 15 archivos, 12491 líneas
- **Coste**: $0.0763

### C3 — Vibe Coding

- **Artefactos (flow)**: 0.0/10
- **F1 vs PR real**: 0.62
- **Calidad código**: 0 semgrep, 364 linters
- **Tamaño**: 3 archivos, 3221 líneas
- **Coste**: $0.0191

## 3. Mejor flujo por métrica

| Métrica | Líder | Valor |
|---------|---------|-------|
| F1 vs PR real | **C2** (IREB v2) | 0.62 |
| Artefactos (encontrados/esperados) | **C0** (SpecKit vanilla) | 100% |
| Precisión | **C3** (Vibe Coding) | 83.0% |
| Recall | **C1** (IREB v1) | 64.8% |
| Menor coste | **C3** (Vibe Coding) | $0.0191 |
| Menos semgrep | **C2** (IREB v2) | 0 |
| Menos linters | **C0** (SpecKit vanilla) | 126 |

## 4. Mejor y peor caso por flujo

| Flow | Mejor caso (F1) | F1 | Peor caso (F1) | F1 |
|------|-----------------|----|----------------|----|
| C0 | authentik-10124 | 1.00 | appwrite-11009 | 0.00 |
| C1 | authentik-10124 | 1.00 | appwrite-11465 | 0.00 |
| C2 | appwrite-11009 | 1.00 | appwrite-11312 | 0.00 |
| C3 | authentik-10110 | 1.00 | appwrite-11465 | 0.00 |

## 5. Ranking global (top 10 por F1)

| # | Flow | Caso | F1 | Artf | Coste |
|---|------|------|----|------|-------|
| 1 | C0 | authentik-10124 | 1.00 | 100% | $0.0413 |
| 2 | C0 | calcom-26826 | 1.00 | 100% | $0.0805 |
| 3 | C1 | authentik-10124 | 1.00 | 50% | $0.0595 |
| 4 | C2 | appwrite-11009 | 1.00 | 60% | $0.0677 |
| 5 | C2 | authentik-10124 | 1.00 | 60% | $0.0570 |
| 6 | C2 | authentik-21803 | 1.00 | 60% | $0.0553 |
| 7 | C2 | calcom-26826 | 1.00 | 60% | $0.0728 |
| 8 | C2 | directus-26976 | 1.00 | 60% | $0.0425 |
| 9 | C2 | medusa-15264 | 1.00 | 60% | $0.0516 |
| 10 | C3 | authentik-10110 | 1.00 | 0% | $0.0066 |

## 6. Comparativa frente a C2 (IREB v2)

C2 es el flujo con mejor F1 medio (0.62). La siguiente tabla compara C2 con cada
alternativa en las métricas principales:

| vs | F1 | Precisión | Recall | Artefactos | Coste | Linters |
|----|----|-----------|--------|-----------------|-------|---------|
| **C2** | **0.62** | **70.2%** | **62.5%** | 57% | $0.0763 | 1068 |
| C0 | 0.46 | 49.5% | 54.0% | 100% | $0.0573 | 126 |
| C1 | 0.52 | 53.2% | 64.8% | 48% | $0.0915 | 2096 |
| C3 | 0.62 | 83.0% | 57.8% | 0% | $0.0191 | 364 |
