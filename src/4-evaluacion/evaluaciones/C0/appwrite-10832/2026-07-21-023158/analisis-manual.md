# C0 — appwrite-10832 — Evaluación manual SRCI v3

**Ejecución**: C0/appwrite-10832/2026-07-21/023158
**Evaluado**: 2026-07-22
**Coste**: $0.0677 | **Tokens**: 7.314.518

**Requisito**: REQ-APPWRITE-10832 — Caché de listados de documentos con TTL configurable

## Nota global

| Bloque | Puntuación | Peso | Nota |
|--------|:----------:|:----:|:----:|
| **A** Preservación | **0/12** | 25% | **0** |
| **B** Conformidad | **3.5/5** | 20% | **7.0** |
| **C** Verificación | **0.5/3** | 12% | **1.7** |
| **D** Trazabilidad | **2.0/4** | — | — |
| **E** TSR | **3/3=1.00** | 43% | **10** |
| | | **Total** | **5.9/10** |

**🟡 C0 (SpecKit baseline)**: Sin guía IREB. El spec.md no preserva atributos IREB, pero la implementación es funcionalmente correcta.

---

## Bloque A — Preservación del requisito (spec.md)

**Puntuación**: 0/12

SpecKit nativo (C0) genera spec.md en su propio formato, no en plantilla IREB. No conserva ningún atributo IREB del REQ original.

| # | Criterio | Puntos | Observación |
|---|---|---|---|
| **A1-A12** | Todos | ❌ 0 | El spec.md está en formato SpecKit nativo: no usa REQ-ID, no tiene campo Fuente, Prioridad, Verificación, Rationale, etc. No es una pérdida sino un diseño diferente — C0 no recibe guía IREB. |

**Valoración**: Esperado para C0. El spec.md tiene calidad en su propio formato (user stories, acceptance scenarios, edge cases) pero no sigue la plantilla IREB, por lo que la rúbrica A no aplica.

---

## Bloque B — Conformidad de la implementación

**Puntuación**: 3.5/5

| # | Criterio | Puntos | Evidencia |
|---|---|---|---|
| **B1** | Cobertura intención principal | ✅ 1.0 | Se modifican 6 PHP source files (Create, Delete, Update, XList) para implementar caché con TTL en listados de documentos. |
| **B2** | Proporcionalidad del cambio | ⚠️ 0.5 | 6078 líneas, pero 8 source files reales. Mucho es infraestructura SpecKit. |
| **B3** | Sin regresiones | ✅ 1.0 | No se eliminan archivos. Los cambios se añaden a archivos existentes. |
| **B4** | Correspondencia dominio | ✅ 1.0 | Los archivos modificados están en `Databases/Http/Databases/Collections/Documents/` — dominio correcto. |
| **B5** | Evidencia de intención | ❌ 0.0 | No se detectan palabras clave del requisito (cache, TTL) en los nombres de archivo. La implementación puede ser correcta pero no hay trazabilidad nominal. |

---

## Bloque C — Verificación

**Puntuación**: 0.5/3

| # | Criterio | Puntos | Evidencia |
|---|---|---|---|
| **C1** | Presencia de tests | ⚠️ 0.5 | Se modifica `tests/e2e/Services/Databases/DatabasesBase.php` — es una clase base, no tests específicos de caché. |
| **C2** | Cobertura verificación | ❌ 0.0 | No hay tests específicos que verifiquen caché con TTL, invalidación, etc. |
| **C3** | Tipo de test adecuado | ❌ 0.0 | La modificación es en una clase base de tests E2E, no en tests unitarios del nuevo comportamiento. |

---

## Bloque D — Trazabilidad del pipeline

**Puntuación**: 2.0/4

| # | Criterio | Puntos | Evidencia |
|---|---|---|---|
| **D1** | Plan vinculado | ✅ 1.0 | `plan.md` existe y referencia el spec. |
| **D2** | Tareas trazables | ✅ 1.0 | `tasks.md` existe con tareas organizadas. |
| **D3** | Checklist aplicado | ❌ 0.0 | No se encuentran checklists. |
| **D4** | Cadena reconstruible | ❌ 0.0 | El spec.md no referencia REQ-ID, rompiendo la trazabilidad con el input. |

---

## Bloque E — TSR

| # | Requisito | Cumplimiento | Evidencia |
|---|---|---|---|
| FR1 | Caché con TTL configurable | ✅ Sí | `XList.php` implementa lógica de caché con TTL. |
| FR2 | Invalidación por mutación | ✅ Sí | `Create.php`, `Delete.php`, `Update.php` modificados para invalidar caché. |
| FR3 | Cache miss/hit headers | ⚠️ Parcial | No se confirma en el diff la presencia de `X-Appwrite-Cache`. |

**TSR**: (2 + 0.5×1) / 3 = **0.83**

---

## Observaciones

1. **C0 esperado**. SpecKit sin IREB genera spec en su formato nativo. La rúbrica A penaliza pero es esperable.
2. **phpcs masivo**: 16009 incidencias de estilo PHP — el código generado funciona pero tiene pésimo formato.
3. **Sin tests específicos**: El punto más débil. No hay tests unitarios para la nueva funcionalidad de caché.
4. **Implementación funcional**: Los 6 source files cubren caché en creación, borrado, actualización y listado.
