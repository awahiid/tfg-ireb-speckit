# n8n — informe de selección de evidencia

## Objetivo

Este informe documenta la selección de entradas de changelog/release suficientemente buenas para una futura derivación de requisitos. El JSON asociado contiene únicamente evidencia literal y trazable; no contiene requisitos redactados.

## Criterio de selección

Se incluyen entradas que:
1. aparecen en releases o changelogs oficiales;
2. tienen trazabilidad mínima suficiente, preferiblemente mediante referencia a PR;
3. contienen al menos una señal útil para una futura derivación, como método/path, condición explícita, actor explícito, superficie pública o término relevante de dominio.

No se exige perfección ni completitud total. La decisión se basa en suficiencia defendible, no en excelencia absoluta.

## Fuentes

- Releases: https://github.com/n8n-io/n8n/releases
- Repositorio: https://github.com/n8n-io/n8n

## Tabla resumen

| ID | Release | Entry text | PR | Link exacto | Valoración breve |
|---|---|---|---|---|---|
| n8n-e1 | 2.25.1 | `core: Align /credentials/for-workflow response with its frontend type` | #31253 | https://github.com/n8n-io/n8n/releases/tag/n8n@2.25.1 | path explícito + contrato de respuesta |
| n8n-e2 | 2.25.1 | `editor, core: Enhance source control endpoint access control` | #31349 | https://github.com/n8n-io/n8n/releases/tag/n8n@2.25.1 | endpoint + control de acceso |
| n8n-e3 | 2.25.1 | `editor: Hide private credential connect controls without update permission` | #31507 | https://github.com/n8n-io/n8n/releases/tag/n8n@2.25.1 | condición + permisos + UI |
| n8n-e4 | 2.25.1 | `Email Trigger (IMAP) Node: Fix emails marked as read without triggering workflow` | #30375 | https://github.com/n8n-io/n8n/releases/tag/n8n@2.25.1 | condición + flujo trigger |
| n8n-e5 | 2.25.1 | `MongoDB Node: Validate update key value type` | #31371 | https://github.com/n8n-io/n8n/releases/tag/n8n@2.25.1 | validación técnica clara |
| n8n-e6 | 2.25.1 | `Only allow specified AWS regions` | #31374 | https://github.com/n8n-io/n8n/releases/tag/n8n@2.25.1 | restricción funcional concreta |
| n8n-e7 | 2.25.1 | `Postgres Node: Return empty array for SELECTs that match no rows` | #30528 | https://github.com/n8n-io/n8n/releases/tag/n8n@2.25.1 | output explícito + condición |
| n8n-e8 | 2.25.1 | `Salesforce Trigger Node: Stop Created triggers refiring on record updates` | #30809 | https://github.com/n8n-io/n8n/releases/tag/n8n@2.25.1 | trigger + condición muy clara |
| n8n-e9 | 2.25.1 | `Send Email Node: Allow non-inline file attachments` | #31071 | https://github.com/n8n-io/n8n/releases/tag/n8n@2.25.1 | capacidad funcional directa |
| n8n-e10 | 2.25.1 | `Stripe Trigger Node: Use stored webhook secret for request verification` | #31212 | https://github.com/n8n-io/n8n/releases/tag/n8n@2.25.1 | verificación + secreto + webhook |

## Valoración por candidato

### n8n-e1
**Release:** 2.25.1  
**Texto literal:**  
`core: Align /credentials/for-workflow response with its frontend type`  
**PR:** #31253  
**Link exacto:** https://github.com/n8n-io/n8n/releases/tag/n8n@2.25.1

**Valoración.** Esta entrada se selecciona porque contiene una superficie técnica explícita (`/credentials/for-workflow`) y describe un cambio de contrato de respuesta bastante claro. Su principal limitación es que no especifica el tipo exacto esperado ni el payload concreto. Aun así, se considera suficientemente buena para el corpus porque apunta a una interfaz bien delimitada y con potencial claro de formalización. ([github.com](https://github.com/n8n-io/n8n/releases))

### n8n-e2
**Release:** 2.25.1  
**Texto literal:**  
`editor, core: Enhance source control endpoint access control`  
**PR:** #31349  
**Link exacto:** https://github.com/n8n-io/n8n/releases/tag/n8n@2.25.1

**Valoración.** Esta entrada se selecciona porque combina una superficie identificable (`source control endpoint`) con un término de alto valor para derivación (`access control`). Su principal limitación es que no explicita actores, permisos concretos ni comportamiento observable exacto. Aun así, es suficientemente buena porque el dominio y la intención funcional están claros. ([github.com](https://github.com/n8n-io/n8n/releases))

### n8n-e3
**Release:** 2.25.1  
**Texto literal:**  
`editor: Hide private credential connect controls without update permission`  
**PR:** #31507  
**Link exacto:** https://github.com/n8n-io/n8n/releases/tag/n8n@2.25.1

**Valoración.** Esta entrada se selecciona porque contiene una condición explícita (`without update permission`) y una superficie UI concreta (`private credential connect controls`). Su principal limitación es que no especifica qué permisos alternativos existen ni el contexto exacto de visualización. Aun así, es suficientemente buena porque la restricción funcional es bastante clara y observable. ([github.com](https://github.com/n8n-io/n8n/releases))

### n8n-e4
**Release:** 2.25.1  
**Texto literal:**  
`Email Trigger (IMAP) Node: Fix emails marked as read without triggering workflow`  
**PR:** #30375  
**Link exacto:** https://github.com/n8n-io/n8n/releases/tag/n8n@2.25.1

**Valoración.** Esta entrada se selecciona porque delimita bien un escenario (`emails marked as read`) y un fallo funcional concreto (`without triggering workflow`). Su principal limitación es que no describe la condición completa del trigger ni el comportamiento corregido con precisión total. Aun así, entra porque el escenario problemático es muy claro y potencialmente testeable. ([github.com](https://github.com/n8n-io/n8n/releases))

### n8n-e5
**Release:** 2.25.1  
**Texto literal:**  
`MongoDB Node: Validate update key value type`  
**PR:** #31371  
**Link exacto:** https://github.com/n8n-io/n8n/releases/tag/n8n@2.25.1

**Valoración.** Esta entrada se selecciona porque usa un término técnico fuerte (`update key value type`) y expresa una acción muy concreta (`Validate`). Su principal limitación es que no especifica tipos válidos, mensajes de error ni contexto exacto. Aun así, es suficientemente buena porque la intención del cambio es muy clara y directamente convertible en una restricción verificable. ([github.com](https://github.com/n8n-io/n8n/releases))

### n8n-e6
**Release:** 2.25.1  
**Texto literal:**  
`Only allow specified AWS regions`  
**PR:** #31374  
**Link exacto:** https://github.com/n8n-io/n8n/releases/tag/n8n@2.25.1

**Valoración.** Esta entrada se selecciona porque expresa una restricción funcional muy clara sobre configuración (`specified AWS regions`). Su principal limitación es que no enumera las regiones permitidas ni la superficie exacta donde se aplica. Aun así, entra porque la restricción está formulada de manera suficientemente concreta para una derivación posterior. ([github.com](https://github.com/n8n-io/n8n/releases))

### n8n-e7
**Release:** 2.25.1  
**Texto literal:**  
`Postgres Node: Return empty array for SELECTs that match no rows`  
**PR:** #30528  
**Link exacto:** https://github.com/n8n-io/n8n/releases/tag/n8n@2.25.1

**Valoración.** Esta entrada se selecciona porque combina una condición explícita (`SELECTs that match no rows`) con un output bastante concreto (`empty array`). Su principal limitación es que no especifica otros modos de consulta ni formato de respuesta adicional. Aun así, se considera una de las mejores del conjunto porque la relación entre condición y resultado está muy bien definida. ([github.com](https://github.com/n8n-io/n8n/releases))

### n8n-e8
**Release:** 2.25.1  
**Texto literal:**  
`Salesforce Trigger Node: Stop Created triggers refiring on record updates`  
**PR:** #30809  
**Link exacto:** https://github.com/n8n-io/n8n/releases/tag/n8n@2.25.1

**Valoración.** Esta entrada se selecciona porque el escenario es muy concreto: `Created triggers` no deben redispararse `on record updates`. Su principal limitación es que no explicita condiciones adicionales del flujo de Salesforce. Aun así, entra porque el comportamiento incorrecto y la corrección esperada están bastante bien delimitados. ([github.com](https://github.com/n8n-io/n8n/releases))

### n8n-e9
**Release:** 2.25.1  
**Texto literal:**  
`Send Email Node: Allow non-inline file attachments`  
**PR:** #31071  
**Link exacto:** https://github.com/n8n-io/n8n/releases/tag/n8n@2.25.1

**Valoración.** Esta entrada se selecciona porque describe una capacidad funcional directa (`Allow non-inline file attachments`) sobre una superficie identificable (`Send Email Node`). Su principal limitación es que no indica formatos, límites ni condiciones. Aun así, se considera suficientemente buena porque la funcionalidad es simple, concreta y fácilmente derivable. ([github.com](https://github.com/n8n-io/n8n/releases))

### n8n-e10
**Release:** 2.25.1  
**Texto literal:**  
`Stripe Trigger Node: Use stored webhook secret for request verification`  
**PR:** #31212  
**Link exacto:** https://github.com/n8n-io/n8n/releases/tag/n8n@2.25.1

**Valoración.** Esta entrada se selecciona porque contiene términos técnicos fuertes (`webhook secret`, `request verification`) en un dominio de alto valor (`Stripe Trigger Node`). Su principal limitación es que no especifica el mecanismo exacto de verificación ni el error esperado al fallar. Aun así, entra porque el comportamiento de seguridad/autenticidad está claramente identificado. ([github.com](https://github.com/n8n-io/n8n/releases))

## Observaciones finales

- Todas las entradas seleccionadas aparecen en la release oficial `2.25.1` de n8n y contienen referencia explícita a PR, lo que satisface la trazabilidad mínima suficiente. ([github.com](https://github.com/n8n-io/n8n/releases))
- Varias entradas contienen señales estructurales fuertes, como paths (`/credentials/for-workflow`), condiciones explícitas, outputs concretos (`empty array`) o dominios de seguridad (`webhook secret`, `access control`). ([github.com](https://github.com/n8n-io/n8n/releases))
- Sigue quedando indeterminado el campo `pr_merged`, porque en este artefacto no se ha consultado programáticamente `merged_at` de las PRs.
- La selección es suficientemente rica para una segunda fase, aunque no garantiza que todas las entradas produzcan requisitos finales de la misma calidad.

## Comprobación metodológica final

### Defendibilidad
Sí, el resultado es defendible porque cada entrada:
- está anclada a una release oficial;
- referencia una PR concreta;
- y tiene una justificación breve con fortaleza y limitación. ([github.com](https://github.com/n8n-io/n8n/releases))

### Pragmatismo
Sí, el proceso sigue siendo pragmático porque selecciona evidencia suficientemente útil sin exigir que el changelog ya sea un requisito formal. ([github.com](https://github.com/n8n-io/n8n/releases))

### Corrección metodológica
Sí, se mantiene la separación entre:
- **evidencia factual** en el JSON;
- **interpretación/defensa** en el informe.  
Eso es coherente con la metodología definida para la primera fase del TFG. ([github.com](https://github.com/n8n-io/n8n/releases))

### Limitaciones
Las limitaciones siguen siendo razonables:
- algunas entradas requerirán PR/tests/docs para derivarse bien;
- `pr_merged` no está verificado en este artefacto;
- todas las entradas provienen de una sola release, lo que simplifica pero también concentra el muestreo temporal. ([github.com](https://github.com/n8n-io/n8n/releases))

### Juicio final
**Sí, el resultado es suficientemente bueno, defendible y metodológicamente coherente como para continuar.**