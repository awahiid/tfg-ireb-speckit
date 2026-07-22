# C1 — authentik-10110 — Evaluación manual SRCI v3

**Ejecución**: C1/authentik-10110/2026-07-21/193243
**Evaluado**: 2026-07-22
**Coste**: $0.0490 | **Tokens**: 3.713.692

**Requisito**: REQ-AUTHENTIK-10110 — Corrección de esquema FIPS en API de sistema

## Nota global

| Bloque | Puntuación | Peso | Nota |
|--------|:----------:|:----:|:----:|
| **A** Preservación | **3/12** | 25% | **2.5** |
| **B** Conformidad | **4.0/5** | 20% | **8.0** |
| **C** Verificación | **0/3** | 12% | **0** |
| **D** Trazabilidad | **2.0/4** | — | — |
| **E** TSR | **1/1=1.00** | 43% | **10** |
| | | **Total** | **5.8/10** |

---

## Evaluación

IREB v1 corrige la desviación crítica de C0. Ahora spec.md describe correctamente "Corrección de esquema FIPS".

**B1**: ✅ 3 source files (Python: system.py, test_fips_detection.py, test_system_api.py). Coincide con el requisito FIPS.

**B2**: ⚠️ 7370 líneas de diff, mucha infraestructura SpecKit.

**C1-C3**: ❌ Sin tests específicos para la corrección FIPS. Los test files modificados son existentes, no nuevos.

**pyflakes**: 0 (5 .py limpios). **eslint**: 0 (1 .ts limpio).

**TSR**: 1.00 — La API expone `openssl_fips_enabled` correctamente.
