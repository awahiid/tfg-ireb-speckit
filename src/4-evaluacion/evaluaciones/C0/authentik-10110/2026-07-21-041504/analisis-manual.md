# C0 — authentik-10110 — Evaluación manual SRCI v3

**Ejecución**: C0/authentik-10110/2026-07-21/041504
**Evaluado**: 2026-07-22
**Coste**: $0.0488 | **Tokens**: 5.147.488

**Requisito**: REQ-AUTHENTIK-10110 — Corrección de esquema FIPS en API de sistema

## Nota global

| Bloque | Puntuación | Peso | Nota |
|--------|:----------:|:----:|:----:|
| **A** Preservación | **0/12** | 25% | **0** |
| **B** Conformidad | **2.0/5** | 20% | **4.0** |
| **C** Verificación | **0.0/3** | 12% | **0** |
| **D** Trazabilidad | **1.0/4** | — | — |
| **E** TSR | **0/1=0.00** | 43% | **0** |
| | | **Total** | **1.3/10** |

**🔴 Hallazgo crítico**: SpecKit generó una feature de SCIM provisioning en lugar de la corrección FIPS solicitada. La implementación no corresponde al requisito.

---

## Bloque A — Preservación del requisito (spec.md)

**Puntuación**: 0/12

SpecKit nativo genera spec.md en formato propio. Caso agravado: el spec.md describe "SCIM Group Push Provisioning", que no es el requisito solicitado.

---

## Bloque B — Conformidad de la implementación

**Puntuación**: 2.0/5

| # | Criterio | Puntos | Evidencia |
|---|---|---|---|
| **B1** | Cobertura intención principal | ❌ 0.0 | El input era "fix FIPS status schema". Se generó SCIM provisioning. Desviación total. |
| **B2** | Proporcionalidad | ❌ 0.0 | 8 source files implementando SCIM que no se pidió. |
| **B3** | Sin regresiones | ✅ 1.0 | No se eliminan archivos. |
| **B4** | Correspondencia dominio | ❌ 0.0 | SCIM providers no corresponden a "system API FIPS schema". |
| **B5** | Evidencia de intención | ✅ 1.0 | El código SCIM tiene coherencia interna aunque no responde al input. |

---

## Bloque C — Verificación: **0/3** (sin tests)

## Bloque D — Trazabilidad: **1/4** (solo plan.md existe)

## Bloque E — TSR: **0/1**

---

## Observaciones

1. **Desviación crítica**: SpecKit generó una feature no solicitada. Posible causa: el input "admin: system api: fix FIPS status schema" es demasiado corto y ambiguo para SpecKit sin IREB.
2. **phpcs**: 0 (no hay PHP). **pyflakes**: 0 (5 .py limpios). **eslint**: 13 (3 .ts con variables no usadas).
