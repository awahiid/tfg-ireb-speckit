# Medusa — informe de selección de evidencia

## Objetivo

Este informe documenta la selección de entradas de changelog/release suficientemente buenas para una futura derivación de requisitos. El JSON asociado contiene únicamente evidencia literal y trazable; no contiene requisitos redactados.

## Criterio de selección

Se incluyen entradas que:
1. aparecen en releases o changelogs oficiales;
2. tienen trazabilidad mínima suficiente, preferiblemente mediante referencia a PR;
3. contienen al menos una señal útil para una futura derivación, como método/path, condición explícita, actor explícito, superficie pública o término relevante de dominio.

No se exige perfección ni completitud total. La decisión se basa en suficiencia defendible, no en excelencia absoluta.

## Fuentes

- Releases: https://github.com/medusajs/medusa/releases
- Repositorio: https://github.com/medusajs/medusa

## Tabla resumen

| ID | Release | Entry text | PR | Link exacto | Valoración breve |
|---|---|---|---|---|---|
| medusa-e1 | v2.15.3 | `When promotion codes are skipped due to budget or usage limits, the system now surfaces this information to provide better visibility into why certain promotions weren't applied. This helps merchants understand promotion application behavior and troubleshoot issues.` | #15396 | https://github.com/medusajs/medusa/releases/tag/v2.15.3 | condición explícita + actor + comportamiento observable |
| medusa-e2 | v2.15.3 | `feat(js-sdk): add MFA auth helpers by @christiananese in #15441` | #15441 | https://github.com/medusajs/medusa/releases/tag/v2.15.3 | auth/MFA + helper explícito |
| medusa-e3 | v2.15.3 | `fix(core-flows): harden create payment sessions when customer has no account holders by @Suh0161 in #15264` | #15264 | https://github.com/medusajs/medusa/releases/tag/v2.15.3 | condición explícita + actor + pagos |
| medusa-e4 | v2.15.2 | `feat(medusa): enable index when querying products via promotion attribute values and enable sku search in products entrypoint by @NicolasGorga in #15386` | #15386 | https://github.com/medusajs/medusa/releases/tag/v2.15.2 | superficie funcional identificable |
| medusa-e5 | v2.14.2 | `feat(product): add SKU search support to admin API by @bqst in #13930` | #13930 | https://github.com/medusajs/medusa/releases/tag/v2.14.2 | API pública sugerida + capacidad concreta |
| medusa-e6 | v2.14.2 | `feat(medusa,js-sdk,types): add POST /admin/payment-collections/:id/payment-sessions by @GBreg19 in #15169` | #15169 | https://github.com/medusajs/medusa/releases/tag/v2.14.2 | método HTTP + path explícito |

## Valoración por candidato

### medusa-e1
**Release:** v2.15.3  
**Texto literal:**  
`When promotion codes are skipped due to budget or usage limits, the system now surfaces this information to provide better visibility into why certain promotions weren't applied. This helps merchants understand promotion application behavior and troubleshoot issues.`  
**PR:** #15396  
**Link exacto:** https://github.com/medusajs/medusa/releases/tag/v2.15.3

**Valoración.** Esta entrada se selecciona porque contiene una condición explícita (`when promotion codes are skipped due to budget or usage limits`), un actor explícito (`merchants`) y un comportamiento visible del sistema (`surfaces this information`). Su principal limitación es que no explicita el artefacto exacto donde se muestra esa información. Aun así, se considera suficientemente buena para el corpus porque el cambio es funcionalmente claro, observable y trazable. ([github.com](https://github.com/medusajs/medusa/releases?utm_source=openai))

### medusa-e2
**Release:** v2.15.3  
**Texto literal:**  
`feat(js-sdk): add MFA auth helpers by @christiananese in #15441`  
**PR:** #15441  
**Link exacto:** https://github.com/medusajs/medusa/releases/tag/v2.15.3

**Valoración.** Esta entrada se selecciona porque menciona un artefacto técnico concreto (`js-sdk`) y un dominio crítico (`MFA auth helpers`). Su principal limitación es que el comportamiento exacto de los helpers no se describe en la línea de release. Aun así, entra porque introduce una capacidad clara relacionada con autenticación y parece derivable con apoyo de la PR. ([github.com](https://github.com/medusajs/medusa/releases?utm_source=openai))

### medusa-e3
**Release:** v2.15.3  
**Texto literal:**  
`fix(core-flows): harden create payment sessions when customer has no account holders by @Suh0161 in #15264`  
**PR:** #15264  
**Link exacto:** https://github.com/medusajs/medusa/releases/tag/v2.15.3

**Valoración.** Esta entrada se selecciona porque combina buena trazabilidad con dos señales estructurales muy útiles: una condición explícita (`when customer has no account holders`) y un actor explícito (`customer`). Además, el texto apunta claramente al dominio de pagos (`create payment sessions`). Su principal limitación es que el resultado observable exacto no aparece en el release text, por lo que una futura derivación de requisito necesitará consultar PR o tests. Aun así, se considera suficientemente buena para el corpus porque reduce bastante la ambigüedad y ofrece una base razonable para formalización posterior. ([github.com](https://github.com/medusajs/medusa/releases?utm_source=openai))

### medusa-e4
**Release:** v2.15.2  
**Texto literal:**  
`feat(medusa): enable index when querying products via promotion attribute values and enable sku search in products entrypoint by @NicolasGorga in #15386`  
**PR:** #15386  
**Link exacto:** https://github.com/medusajs/medusa/releases/tag/v2.15.2

**Valoración.** Esta entrada se selecciona porque describe una capacidad funcional concreta y trazable relacionada con búsqueda de productos y soporte de SKU. La superficie afectada (`products entrypoint`) es identificable y el cambio parece razonablemente observable en una fase posterior. Su principal limitación es que el texto agrega dos aspectos en la misma línea y no aporta endpoint, parámetro ni output literal. Aun así, se considera suficientemente buena para el corpus porque la funcionalidad es clara y el cambio parece derivable con apoyo adicional de la PR. ([github.com](https://github.com/medusajs/medusa/releases?utm_source=openai))

### medusa-e5
**Release:** v2.14.2  
**Texto literal:**  
`feat(product): add SKU search support to admin API by @bqst in #13930`  
**PR:** #13930  
**Link exacto:** https://github.com/medusajs/medusa/releases/tag/v2.14.2

**Valoración.** Esta entrada se selecciona porque tiene trazabilidad clara y una superficie pública sugerida (`admin API`), además de una capacidad concreta (`SKU search support`). Su principal limitación es que no explicita endpoint, método ni estructura de respuesta, por lo que no basta por sí sola para generar un requisito plenamente verificable. Aun así, se considera suficientemente buena para el corpus porque describe una funcionalidad pública razonablemente acotada y utilizable en una fase posterior de derivación. ([github.com](https://github.com/medusajs/medusa/releases?utm_source=openai))

### medusa-e6
**Release:** v2.14.2  
**Texto literal:**  
`feat(medusa,js-sdk,types): add POST /admin/payment-collections/:id/payment-sessions by @GBreg19 in #15169`  
**PR:** #15169  
**Link exacto:** https://github.com/medusajs/medusa/releases/tag/v2.14.2

**Valoración.** Esta entrada se selecciona porque es una de las evidencias más fuertes del conjunto: incluye un método HTTP explícito (`POST`) y un path completo (`/admin/payment-collections/:id/payment-sessions`), además de referencia trazable a PR. Su principal limitación es que no aporta todavía el resultado esperado de la operación, como código HTTP o cuerpo de respuesta. Aun así, se considera suficientemente buena para el corpus porque minimiza la inferencia necesaria en la futura derivación de requisitos. ([github.com](https://github.com/medusajs/medusa/releases?utm_source=openai))

## Observaciones finales

- Las entradas seleccionadas aparecen en releases oficiales recientes de Medusa y contienen PR explícita o referencia directa asociada, lo que satisface la trazabilidad mínima suficiente. ([github.com](https://github.com/medusajs/medusa/releases?utm_source=openai))
- El conjunto ahora es más útil que la versión anterior porque ya no depende solo de 4 entradas y cubre pagos, promociones, búsqueda de productos y MFA. ([github.com](https://github.com/medusajs/medusa/releases?utm_source=openai))
- Sigue quedando indeterminado el estado `pr_merged`, porque en este artefacto no se ha consultado programáticamente `merged_at`.
- La selección es defendible y pragmática: no garantiza que todas las entradas se conviertan en requisitos finales igual de fuertes, pero sí mejora la base de evidencia para la segunda fase. ([github.com](https://github.com/medusajs/medusa/releases?utm_source=openai))