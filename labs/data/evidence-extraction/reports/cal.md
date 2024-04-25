# Cal.com — informe de selección de evidencia

## Objetivo

Este informe documenta la selección de entradas de changelog/release suficientemente buenas para una futura derivación de requisitos. El JSON asociado contiene únicamente evidencia literal y trazable; no contiene requisitos redactados.

## Criterio de selección

Se incluyen entradas que:
1. aparecen en releases o changelogs oficiales;
2. tienen trazabilidad mínima suficiente, preferiblemente mediante referencia a PR;
3. contienen al menos una señal útil para una futura derivación, como método/path, condición explícita, actor explícito, superficie pública o término relevante de dominio.

No se exige perfección ni completitud total. La decisión se basa en suficiencia defendible, no en excelencia absoluta.

## Fuentes

- Releases: https://github.com/calcom/cal.com/releases
- Repositorio: https://github.com/calcom/cal.com

## Tabla resumen

| ID | Release | Entry text | PR | Link exacto | Valoración breve |
|---|---|---|---|---|---|
| cal-e1 | v6.0.12 | `fix(api): use cal.com for bookingUrl in platform organizations by @dhairyashiil in #26812` | #26812 | https://github.com/calcom/cal.com/releases/tag/v6.0.12 | API + campo identificable |
| cal-e2 | v6.0.12 | `fix(api): return empty bookingUrl for managed users in API v2 by @dhairyashiil in #26826` | #26826 | https://github.com/calcom/cal.com/releases/tag/v6.0.12 | actor + API v2 + output sugerido |
| cal-e3 | v6.0.12 | `feat: add scope configuration for feature opt-in by @eunjae-lee in #26801` | #26801 | https://github.com/calcom/cal.com/releases/tag/v6.0.12 | configuración funcional explícita |
| cal-e4 | v6.0.11 | `feat: added the API v2 Imports section to your AGENTS.md by @dhairyashiil in #26737` | #26737 | https://github.com/calcom/cal.com/releases/tag/v6.0.11 | artefacto documental/API identificable |
| cal-e5 | v6.0.10 | `fix(auth): block OAuth linking for unverified accounts by @pedroccastro in #26598` | #26598 | https://github.com/calcom/cal.com/releases/tag/v6.0.10 | auth + actor explícito |
| cal-e6 | v6.0.10 | `feat: system admin blocklist table by @Udit-takkar in #25039` | #25039 | https://github.com/calcom/cal.com/releases/tag/v6.0.10 | actor + superficie UI/datos |
| cal-e7 | v6.0.9 | `fix: validate owner email on platform org creation by @pedroccastro in #26286` | #26286 | https://github.com/calcom/cal.com/releases/tag/v6.0.9 | condición + validación |
| cal-e8 | v6.0.8 | `fix(auth): enhance SAML login handling by introducing userId field and updating JWT token structure by @hariombalhara in #26428` | #26428 | https://github.com/calcom/cal.com/releases/tag/v6.0.8 | auth + campos técnicos fuertes |
| cal-e9 | v6.0.8 | `feat: queue or cancel payment reminder flow by @dhairyashiil in #24889` | #24889 | https://github.com/calcom/cal.com/releases/tag/v6.0.8 | flujo de pagos identificable |
| cal-e10 | v6.0.3 | `feat: auto skip consent screen for trusted oauth clients by @CarinaWolli in #25640` | #25640 | https://github.com/calcom/cal.com/releases/tag/v6.0.3 | actor + auth/oauth + flujo UI |

## Valoración por candidato

### cal-e1
**Release:** v6.0.12  
**Texto literal:**  
`fix(api): use cal.com for bookingUrl in platform organizations by @dhairyashiil in #26812`  
**PR:** #26812  
**Link exacto:** https://github.com/calcom/cal.com/releases/tag/v6.0.12

**Valoración.** Esta entrada se selecciona porque menciona una superficie identificable (`api`) y un artefacto concreto (`bookingUrl`) en un contexto funcional claro (`platform organizations`). Su principal limitación es que no detalla endpoint, condición ni estructura completa de respuesta. Aun así, se considera suficientemente buena para el corpus porque el cambio parece observable y derivable con apoyo adicional de la PR. ([github.com](https://github.com/calcom/cal.com/releases?utm_source=openai))

### cal-e2
**Release:** v6.0.12  
**Texto literal:**  
`fix(api): return empty bookingUrl for managed users in API v2 by @dhairyashiil in #26826`  
**PR:** #26826  
**Link exacto:** https://github.com/calcom/cal.com/releases/tag/v6.0.12

**Valoración.** Esta entrada se selecciona porque combina superficie técnica (`API v2`), actor explícito (`managed users`) y una señal fuerte de output (`return empty bookingUrl`). Su principal limitación es que el release text no especifica endpoint ni condición exacta de ejecución. Aun así, entra con claridad porque el comportamiento sugerido es bastante concreto y potencialmente verificable. ([github.com](https://github.com/calcom/cal.com/releases?utm_source=openai))

### cal-e3
**Release:** v6.0.12  
**Texto literal:**  
`feat: add scope configuration for feature opt-in by @eunjae-lee in #26801`  
**PR:** #26801  
**Link exacto:** https://github.com/calcom/cal.com/releases/tag/v6.0.12

**Valoración.** Esta entrada se selecciona porque describe una capacidad funcional clara relacionada con configuración (`scope configuration`) y activación de características (`feature opt-in`). Su principal limitación es que la superficie técnica exacta no queda especificada. Aun así, es suficientemente buena porque el cambio es funcionalmente recognoscible y defendible para derivación posterior. ([github.com](https://github.com/calcom/cal.com/releases?utm_source=openai))

### cal-e4
**Release:** v6.0.11  
**Texto literal:**  
`feat: added the API v2 Imports section to your AGENTS.md by @dhairyashiil in #26737`  
**PR:** #26737  
**Link exacto:** https://github.com/calcom/cal.com/releases/tag/v6.0.11

**Valoración.** Esta entrada se selecciona porque menciona artefactos claramente identificables (`API v2`, `AGENTS.md`) y un cambio concreto sobre documentación/guía operativa. Su principal limitación es que puede ser menos directamente implementable como requisito funcional del sistema que otras entradas más claramente runtime. Aun así, se considera suficientemente buena porque el artefacto afectado está nombrado explícitamente y puede ser útil en la evaluación de agentes. ([github.com](https://github.com/calcom/cal.com/releases?utm_source=openai))

### cal-e5
**Release:** v6.0.10  
**Texto literal:**  
`fix(auth): block OAuth linking for unverified accounts by @pedroccastro in #26598`  
**PR:** #26598  
**Link exacto:** https://github.com/calcom/cal.com/releases/tag/v6.0.10

**Valoración.** Esta entrada se selecciona porque combina dominio crítico (`auth`, `OAuth`) con un actor explícito (`unverified accounts`) y una restricción funcional clara (`block OAuth linking`). Su principal limitación es que no expone el flujo exacto donde se aplica la restricción. Aun así, es claramente suficiente para el corpus por su valor de dominio y su potencial de derivación en un requisito implementable. ([github.com](https://github.com/calcom/cal.com/releases?utm_source=openai))

### cal-e6
**Release:** v6.0.10  
**Texto literal:**  
`feat: system admin blocklist table by @Udit-takkar in #25039`  
**PR:** #25039  
**Link exacto:** https://github.com/calcom/cal.com/releases/tag/v6.0.10

**Valoración.** Esta entrada se selecciona porque incluye un actor explícito (`system admin`) y una superficie bastante identificable (`blocklist table`). Su principal limitación es que el release text no indica operaciones concretas ni observables exactos. Aun así, entra porque la funcionalidad es reconocible y parece susceptible de formalización posterior. ([github.com](https://github.com/calcom/cal.com/releases?utm_source=openai))

### cal-e7
**Release:** v6.0.9  
**Texto literal:**  
`fix: validate owner email on platform org creation by @pedroccastro in #26286`  
**PR:** #26286  
**Link exacto:** https://github.com/calcom/cal.com/releases/tag/v6.0.9

**Valoración.** Esta entrada se selecciona porque contiene una condición/contexto explícito (`on platform org creation`) y una acción funcional concreta (`validate owner email`). Su principal limitación es que no detalla criterios de validación ni error observable. Aun así, se considera suficientemente buena porque delimita con bastante claridad cuándo aplica el cambio. ([github.com](https://github.com/calcom/cal.com/releases?utm_source=openai))

### cal-e8
**Release:** v6.0.8  
**Texto literal:**  
`fix(auth): enhance SAML login handling by introducing userId field and updating JWT token structure by @hariombalhara in #26428`  
**PR:** #26428  
**Link exacto:** https://github.com/calcom/cal.com/releases/tag/v6.0.8

**Valoración.** Esta entrada se selecciona porque contiene varios términos técnicos fuertes (`SAML login`, `userId field`, `JWT token structure`) y pertenece a un dominio crítico de autenticación. Su principal limitación es que mezcla dos cambios en una misma línea y no explicita el resultado externo. Aun así, sigue siendo suficientemente buena porque los artefactos técnicos están claramente nombrados. ([github.com](https://github.com/calcom/cal.com/releases?utm_source=openai))

### cal-e9
**Release:** v6.0.8  
**Texto literal:**  
`feat: queue or cancel payment reminder flow by @dhairyashiil in #24889`  
**PR:** #24889  
**Link exacto:** https://github.com/calcom/cal.com/releases/tag/v6.0.8

**Valoración.** Esta entrada se selecciona porque describe un flujo funcional claro relacionado con pagos (`payment reminder flow`) y dos acciones reconocibles (`queue` o `cancel`). Su principal limitación es que no define condiciones ni actores explícitos. Aun así, se considera suficientemente buena porque la funcionalidad es bastante concreta y claramente implementable. ([github.com](https://github.com/calcom/cal.com/releases?utm_source=openai))

### cal-e10
**Release:** v6.0.3  
**Texto literal:**  
`feat: auto skip consent screen for trusted oauth clients by @CarinaWolli in #25640`  
**PR:** #25640  
**Link exacto:** https://github.com/calcom/cal.com/releases/tag/v6.0.3

**Valoración.** Esta entrada se selecciona porque combina un actor explícito (`trusted oauth clients`) con una acción funcional clara (`auto skip consent screen`) en un dominio crítico (`oauth`). Su principal limitación es que no detalla condiciones adicionales ni el flujo exacto donde se omite la pantalla. Aun así, entra porque apunta a un comportamiento implementable y bastante bien delimitado. ([github.com](https://github.com/calcom/cal.com/releases?utm_source=openai))

## Observaciones finales

- Todas las entradas seleccionadas proceden de releases oficiales de `calcom/cal.com` y contienen referencia explícita a PR, lo que satisface la trazabilidad mínima suficiente. ([github.com](https://github.com/calcom/cal.com/releases?utm_source=openai))
- Varias entradas contienen señales estructurales fuertes para derivación posterior, incluyendo `API v2`, `bookingUrl`, `OAuth`, `SAML login`, `JWT token structure`, `payment reminder flow` y `consent screen`. ([github.com](https://github.com/calcom/cal.com/releases?utm_source=openai))
- Sigue quedando indeterminado en este artefacto el campo `pr_merged`, porque no se ha consultado programáticamente `merged_at` en la API de PRs. ([github.com](https://github.com/calcom/cal.com/releases?utm_source=openai))
- La selección sigue siendo pragmática: no garantiza que todas las entradas acabarán convertidas en requisitos finales igual de fuertes, pero sí construye un corpus trazable y suficientemente rico para una segunda fase de derivación. ([github.com](https://github.com/calcom/cal.com/releases?utm_source=openai))
