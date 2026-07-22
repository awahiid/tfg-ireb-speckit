# Fase 4 — Evaluación y análisis de resultados

> **Propósito**: evaluar la calidad del código generado por los 4 flujos (C0–C3)
> aplicando dos metodologías complementarias: (1) **análisis automático** mediante
> linters reales (semgrep, eslint, phpcs, shellcheck, pyflakes + cloc), y
> (2) **evaluación manual** mediante rúbrica SRCI v3 (basada en IREB, ISO 29148 e INCOSE).

---

## Metodología de evaluación en dos fases

### Fase 1 — Automática (scripts)

Ejecutada por `scripts/analisis-automatico/{aauto.py, atodo.py}`:

| Herramienta | Propósito | Cobertura |
|-------------|-----------|-----------|
| **cloc** | Conteo de líneas por lenguaje | Todos los archivos generados |
| **semgrep** (1074 reglas, `--config=auto`) | Bugs de seguridad y lógica | JS, TS, Python, PHP, etc. |
| **eslint** (30+ reglas) | Estilo y calidad JS/TS | `.js`, `.ts`, `.jsx`, `.tsx`, `.vue` |
| **phpcs** (standard Generic) | Estilo PHP | `.php` |
| **shellcheck** | Buenas prácticas shell | `.sh`, `.bash` |
| **pyflakes** | Errores Python | `.py` |

**Salida**: `evaluaciones/{C0-C3}/{repo}-{reqid}/{timestamp}/analisis-automatico.md`
**Resumen global**: `evaluaciones/analisis-automatico.md`

### Fase 2 — Manual (rúbrica SRCI v3)

Aplicando la rúbrica `rubrica-evaluacion.md` mediante inspección directa de los artefactos:

| Bloque | Peso | ¿Qué evalúa? |
|--------|:----:|--------------|
| **A** Preservación | 25% | ¿SpecKit conserva los 12 atributos IREB del requisito de entrada en spec.md? |
| **B** Conformidad | 20% | ¿El código generado satisface el requisito sin desviaciones? |
| **C** Verificación | 12% | ¿Los tests verifican el comportamiento especificado? |
| **D** Trazabilidad | — | ¿Los artefactos intermedios (plan, tasks, checklist) soportan trazabilidad? |
| **E** TSR | 43% | ¿Qué porcentaje de requisitos satisface el código? |

**Salida**: `evaluaciones/{C0-C3}/{repo}-{reqid}/{timestamp}/analisis-manual.md`
**Resumen global**: `evaluaciones/analisis-manual.md`

---

## Estructura actual

```
src/4-evaluacion/
├── README.md                              ← Esta guía
├── rubrica-evaluacion.md                  ← Rúbrica SRCI v3 (5 bloques, A–E)
├── scripts/
│   └── analisis-automatico/
│       ├── aauto.py                       ← Análisis individual (semgrep + linters + cloc)
│       ├── atodo.py                       ← Orquestador 24 casos + resumen automático
│       ├── amanual.py                     ← [DEPRECATED] Usar inspección manual directa
│       ├── .venv/                         ← Entorno Python (semgrep, pyflakes)
│       ├── node_modules/                  ← ESLint + TS parser local
│       ├── .eslintrc.json                 ← Config ESLint v8 (30+ reglas)
│       └── requirements.txt               ← Dependencias Python
└── evaluaciones/                          ← Informes generados
    ├── analisis-automatico.md             ← Resumen automático global
    ├── analisis-manual.md                 ← Resumen manual global
    ├── C0/
    │   └── {repo}-{reqid}/
    │       └── {timestamp}/
    │           ├── analisis-automatico.md  ← Linters + cloc + semgrep
    │           └── analisis-manual.md      ← Rúbrica SRCI v3
    ├── C1/...
    ├── C2/...
    └── C3/...
```

---

## Resultados

### Análisis automático — Hallazgos clave

| Herramienta | ¿Qué encontró? |
|-------------|----------------|
| **semgrep** | 1 issue de seguridad (ReDoS potencial en C0 directus). El código generado está limpio de bugs en general. |
| **eslint** | 2–74 incidencias por caso (variables no usadas, `no-undef`). Más incidencias donde hay más TypeScript. |
| **phpcs** | **16.009 issues en C0 appwrite** vs **1.597 en C1** (−90%). La guía IREB v1 reduce drásticamente problemas de estilo PHP. |
| **shellcheck** | 12 incidencias estándar en todos los C0–C2 (boilerplate de infraestructura SpecKit). |
| **pyflakes** | 0–1 incidencias. El código Python generado está limpio. |
| **cloc** | C2 genera más líneas de código (promedio 14.218) que C1 (18.522) y C0 (5.948). |

### Evaluación manual — Notas globales /10

| Flow | A (12) | B (5) | C (3) | TSR | **Nota/10** |
|------|:------:|:-----:|:-----:|:---:|:-----------:|
| **C0** SpecKit | 3.0 | 3.9 | 0.3 | 0.92 | **6.3** |
| **C1** IREB v1 | 3.2 | 4.0 | 0.7 | 1.00 | **6.8** |
| **C2** IREB v2 | 3.2 | 4.0 | 1.7 | 1.00 | **7.2** |
| **C3** Combinado | 3.0 | 3.6 | 0.0 | 0.17 | **2.8** |

### Comparativa por repositorio (phpcs — solo appwrite)

| Flow | phpcs issues | Diferencia |
|------|:------------:|:----------:|
| C0 | 16.009 | Baseline |
| C1 | **1.597** | **−90%** |
| C2 | 14.577 | −9% |
| C3 | 326 | −98% (pero código mínimo) |

### Comparativa por repositorio (eslint)

| Repo | C0 | C1 | C2 | C3 |
|------|:--:|:--:|:--:|:--:|
| authentik | 13 | 0 | 0 | 0 |
| calcom | 0 | 16 | 38 | 16 |
| directus | 15 | 16 | 42 | 14 |
| medusa | 0 | 1 | 74 | 0 |
| n8n | 0 | 15 | 8 | 4 |

---

## Conclusiones cruzadas

### 1. IREB mejora la generación respecto a SpecKit vanilla

C0 (SpecKit sin IREB) falla en 4/6 casos: no genera spec.md ni implementación real para inputs cortos. En C0 authentik-10110, SpecKit alucinó una feature de SCIM provisioning en lugar de la corrección FIPS solicitada. Los flujos con guía IREB (C1, C2) generan spec.md, plan.md, tasks.md y checklist en todos los casos.

### 2. C2 (IREB v2) es el mejor flujo global

- **Nota media**: 7.2/10 vs 6.8 (C1) y 6.3 (C0)
- **Tests**: es el único flow que genera tests en todos los casos
- **TSR**: 1.00 en todos los casos (implementación completa)
- **Trazabilidad**: spec → plan → tasks → code → tests completa

### 3. IREB v1 reduce drásticamente issues de estilo PHP

La mayor diferencia cuantitativa del estudio: C1 genera **90% menos** incidencias de phpcs que C0 (1.597 vs 16.009) para el mismo requisito appwrite-10832. Esto sugiere que la guía IREB v1 influye positivamente en el estilo del código generado.

### 4. Verificación (tests) es el punto débil del pipeline

C0: solo 1/6 casos tiene tests. C1: 3/6. C2: **6/6** (todos). C3: 0/6. La capacidad de generar tests verificables es la principal mejora de IREB v2 sobre v1.

### 5. C3 no es comparable con los demás flujos

C3 genera código mínimo (promedio 2 source files, 289 líneas) a bajo coste ($0.0115), pero no implementa la funcionalidad completa. Es útil para cambios pequeños pero no para features enteras.

### 6. Correlación coste-calidad

| Flow | Coste medio | Nota/10 | Ratio |
|------|:-----------:|:-------:|:-----:|
| C0 | $0.0407 | 6.3 | 155 pts/$ |
| C1 | $0.0608 | 6.8 | 112 pts/$ |
| C2 | $0.0696 | 7.2 | 103 pts/$ |
| C3 | $0.0115 | 2.8 | 243 pts/$ |

C2 cuesta más pero ofrece la mejor calidad absoluta. C3 ofrece el mejor ratio calidad/precio para cambios triviales.

---

## Uso

```bash
# Activar entorno
source scripts/analisis-automatico/.venv/bin/activate

# Analizar un caso individual
python3 scripts/analisis-automatico/aauto.py <ruta-al-resultado>

# Analizar los 24 casos + generar resumen global
python3 scripts/analisis-automatico/atodo.py

# Los informes manuales se crean por inspección directa en:
# evaluaciones/{C0-C3}/{repo}-{reqid}/{timestamp}/analisis-manual.md
```
