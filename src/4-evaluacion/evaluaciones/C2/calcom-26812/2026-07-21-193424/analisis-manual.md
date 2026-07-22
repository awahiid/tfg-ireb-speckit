# C2 — calcom-26812 — Evaluación manual SRCI v3

**Ejecución**: C2/calcom-26812/2026-07-21/193424
**Evaluado**: 2026-07-22
**Coste**: $0.0621 | **Tokens**: 5.294.683

**Requisito**: REQ-CALCOM-26812 — Corregir la URL de reserva para organizaciones de plataforma

## Nota global

| Bloque | Puntuación | Peso | Nota |
|--------|:----------:|:----:|:----:|
| **A** Preservación | **11/12** | 25% | **9.2** |
| **B** Conformidad | **4.5/5** | 20% | **9.0** |
| **C** Verificación | **3/3** | 12% | **10** |
| **D** Trazabilidad | **4/4** | — | — |
| **E** TSR | **1.00** | 43% | **10** |
| | | **Total** | **9.6/10** |

**🟢 Punto fuerte**: Verificación (tests exhaustivos, 7 vectores) y TSR (3/3 requisitos cumplidos).
**🟡 A mejorar**: Proporcionalidad del cambio (89 archivos, 8635 líneas — mucho infraestructura SpecKit).

---

## Bloque A — Preservación del requisito (spec.md)

**Puntuación**: 11/12

El `spec.md` generado por SpecKit con guía IREB v2 preserva prácticamente todos los atributos del REQ original. Solo se pierde el campo `Dependencias` que el REQ original no tenía.

| # | Criterio | Puntos | Evidencia |
|---|---|---|---|
| **A1** | ID único conservado | ✅ 1 | `spec.md` Metadata: ID = `REQ-CALCOM-26812` |
| **A2** | Clasificación conservada | ✅ 1 | Los FR se clasifican como "Funcional" (no explícito pero todos son funcionales) |
| **A3** | Fuente conservada | ✅ 1 | `Source: Pull Request #26812 (https://github.com/calcom/cal.com/pull/26812)` |
| **A4** | Prioridad conservada | ✅ 1 | `Priority: High` (coincide con "Alta" del REQ) |
| **A5** | Estructura formal | ✅ 1 | FR1: "The system MUST generate..." — estructura formal en inglés |
| **A6** | Obligación única | ✅ 1 | Cada FR describe un único comportamiento |
| **A7** | Verbo observable | ✅ 1 | `generate`, `use`, `change`, `exclude` — todos observables |
| **A8** | Sin ambigüedad | ✅ 1 | Términos precisos: `isPlatform: true`, `MEMBER`, `ADMIN`, `OWNER`, `bookingUrl` |
| **A9** | Verificabilidad | ✅ 1 | Acceptance Criteria concretos + tabla Success Criteria con métricas y métodos |
| **A10** | Autosuficiencia | ✅ 1 | Se entiende sin consultar otros documentos |
| **A11** | No alucinación | ✅ 1 | No inventa contexto ni fuentes |
| **A12** | Rationale conservado | ✅ 1 | Executive Summary reproduce fielmente el Rationale del REQ |

**Valoración**: El spec.md es de alta calidad. Añade valor sobre el REQ original: incluye clarifications de una sesión de clarify, escenarios de usuario, casos borde y una tabla de criterios de éxito con métricas cuantificables. No pierde ningún atributo IREB del input.

---

## Bloque B — Conformidad de la implementación

**Puntuación**: 4.5/5

| # | Criterio | Puntos | Evidencia |
|---|---|---|---|
| **B1** | Cobertura intención principal | ✅ 1.0 | `diff.patch` modifica `buildBookingUrl` en `output-event-types.service.ts` para añadir lógica condicional con `isPlatform` y `membershipRole`. Se implementan los 3 FR. |
| **B2** | Proporcionalidad del cambio | ⚠️ 0.5 | 89 archivos modificados, ~8635 líneas. Aunque ~46 son infraestructura SpecKit, el cambio real en source es grande porque toca muchos transformers y archivos de interfaz. |
| **B3** | Sin regresiones | ✅ 1.0 | No se eliminan archivos existentes. Los tests de backward compatibility (vectores 5-7) verifican que no hay regresión en orgs no-platform. |
| **B4** | Correspondencia dominio | ✅ 1.0 | Todos los archivos modificados pertenecen a `apps/api/v2/src/ee/event-types/` — el dominio técnico correcto para un cambio en la API v2 de event types. |
| **B5** | Evidencia de intención | ✅ 1.0 | El diff contiene `isPlatform`, `membershipRole`, `MEMBER`, `ADMIN`, `buildBookingUrl`, `bookingUrl` — todos los conceptos clave del requisito aparecen en el código. |

**Valoración**: La implementación cubre completamente la intención del requisito. El único pero es el tamaño del diff, que incluye muchos archivos de infraestructura SpecKit no relacionados. El código fuente relevante (~33 archivos TypeScript) está bien estructurado y muestra trazabilidad clara con el spec.

---

## Bloque C — Verificación

**Puntuación**: 3.0/3

| # | Criterio | Puntos | Evidencia |
|---|---|---|---|
| **C1** | Presencia de tests | ✅ 1.0 | `output-event-types.service.spec.ts` contiene los 7 vectores de test (T010-T016) definidos en tasks.md |
| **C2** | Cobertura verificación | ✅ 1.0 | Los tests cubren los 3 criterios de verificación del REQ: (1) non-admin platform → root URL, (2) admin platform → subdomain, (3) non-platform → existing behavior |
| **C3** | Tipo de test adecuado | ✅ 1.0 | Tests unitarios sobre `buildBookingUrl()` — exactamente el tipo correcto para verificar lógica de generación de URLs |

**Valoración**: Excelente cobertura de tests. Los 7 vectores cubren: MEMBER→root, ADMIN→subdomain, OWNER→subdomain, null slug, non-platform, null isPlatform, sin membership. Esto es más completo de lo que pedía el REQ original.

---

## Bloque D — Trazabilidad del pipeline

**Puntuación**: 4.0/4

| # | Criterio | Puntos | Evidencia |
|---|---|---|---|
| **D1** | Plan vinculado al requisito | ✅ 1.0 | `plan.md` referencia `specs/001-fix-platform-booking-url/spec.md` como input, y todas las tareas se vinculan al spec. |
| **D2** | Tareas trazables | ✅ 1.0 | `tasks.md` organiza las tareas por user story. T007-T009 implementan US1, T010-T016 implementan US2. |
| **D3** | Checklist aplicado | ✅ 1.0 | Existen `checklists/requirements.md` y `checklists/url-generation.md` con criterios aplicados al spec. |
| **D4** | Cadena reconstruible | ✅ 1.0 | REQ → spec.md → plan.md → tasks.md → diff.patch → tests. Todos los artefactos existen y son coherentes entre sí. |

**Valoración**: Trazabilidad completa. La cadena requisito → especificación → plan → tareas → código → tests se reconstruye sin saltos. El plan.md incluye incluso un constitution check con gates que verifican el spec antes de proceder.

---

## Bloque E — TSR (Test Satisfaction Rate)

**Requisitos evaluados**: 3 (FR1, FR2, FR3 del spec.md)

| # | Requisito | Cumplimiento | Evidencia |
|---|---|---|---|
| FR1 | Non-admin platform user booking URL correction | ✅ Sí | `buildBookingUrl`: cuando `isPlatform=true` y `role=MEMBER` → `https://cal.com/...` |
| FR2 | Backward compatibility non-platform orgs | ✅ Sí | Tests T014-T016 verifican que `isPlatform=false/null` mantienen comportamiento original |
| FR3 | Backward compatibility platform org admins | ✅ Sí | Tests T011-T012 verifican que `ADMIN`/`OWNER` mantienen subdominio |

**TSR**: 3/3 = **1.00**

**Funcionalidad no solicitada**: No se detecta. Los cambios se limitan estrictamente al ámbito del requisito.

---

## Observaciones

1. **Calidad del spec.md**: El spec generado es mejor que el REQ original. Añade clarifications reales de una sesión de clarify, casos borde documentados y criterios de éxito cuantificables. Esto demuestra que el pipeline IREB v2 no solo conserva, sino que **mejora** la especificación de entrada.

2. **Tests exhaustivos**: Los 7 vectores de prueba cubren todos los casos del espec, incluyendo casos borde (null isPlatform, sin membership) que no estaban en el REQ original pero sí en el spec generado.

3. **Tamaño del diff**: El diff es grande (89 archivos) porque incluye la infraestructura SpecKit (.github/agents, .github/prompts, .specify/). El código fuente real modificado son ~33 archivos TypeScript en el módulo de event-types, que es un cambio proporcionado para la funcionalidad añadida.

4. **Linters**: ESLint encontró 2 incidencias (variables no usadas) en 33 archivos TypeScript — mínimas para la cantidad de código generado.

5. **Conclusión**: Este es un caso ejemplar de cómo IREB v2 guía a SpecKit para producir especificaciones de alta calidad, implementaciones conformes y tests exhaustivos. 02:00
**Coste generacion**: $0.0621 | **Tokens**: 5294683