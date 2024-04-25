# PocketBase — informe de selección de evidencia

## Objetivo

Este informe documenta la selección de entradas de changelog/release suficientemente buenas para una futura derivación de requisitos. El JSON asociado contiene únicamente evidencia literal y trazable; no contiene requisitos redactados.

## Criterio de selección

Se incluyen entradas que:
1. aparecen en releases o changelogs oficiales;
2. tienen trazabilidad mínima suficiente, preferiblemente mediante referencia a PR;
3. contienen al menos una señal útil para una futura derivación, como método/path, condición explícita, actor explícito, superficie pública o término relevante de dominio.

No se exige perfección ni completitud total. La decisión se basa en suficiencia defendible, no en excelencia absoluta.

## Fuentes

- Releases: https://github.com/pocketbase/pocketbase/releases
- Repositorio: https://github.com/pocketbase/pocketbase

## Tabla resumen

| ID | Release | Entry text | PR | Link exacto | Valoración breve |
|---|---|---|---|---|---|
| pocketbase-e1 | v0.35.1 | `Minor UI fixes (normalized relations picker selection and confirmation message when maxSelect=0/1, updated node deps).` | — | https://github.com/pocketbase/pocketbase/releases/tag/v0.35.1 | condición explícita + UI |
| pocketbase-e2 | v0.35.0 | `Added nullString(), nullInt(), nullFloat(), nullBool, nullArray(), nullObject() JSVM helpers for scanning nullable columns (#7396).` | #7396 | https://github.com/pocketbase/pocketbase/releases/tag/v0.35.0 | helpers concretos + condición |
| pocketbase-e3 | v0.35.0 | `Store the correct image/png as attrs content type when generating a thumb fallback (e.g. for webp).` | — | https://github.com/pocketbase/pocketbase/releases/tag/v0.35.0 | content type + condición |
| pocketbase-e4 | v0.35.0 | `Trimmed custom uploaded file name and extension from leftover . characters after filesystem.File normalization.` | — | https://github.com/pocketbase/pocketbase/releases/tag/v0.35.0 | upload/filesystem + condición |
| pocketbase-e5 | v0.34.2 | `Bumped JS SDK to v0.26.5 to fix Safari AbortError detection introduced with the previous release (#7369).` | #7369 | https://github.com/pocketbase/pocketbase/releases/tag/v0.34.2 | bug técnico claro + navegador |
| pocketbase-e6 | v0.34.1 | `Added missing : char to the autocomplete regex (#7353; thanks @ouvreboite).` | #7353 | https://github.com/pocketbase/pocketbase/releases/tag/v0.34.1 | regex + carácter explícito |
| pocketbase-e7 | v0.34.1 | `Added "Copy raw JSON" collection dropdown option (#7357).` | #7357 | https://github.com/pocketbase/pocketbase/releases/tag/v0.34.1 | UI concreta + acción explícita |
| pocketbase-e8 | v0.34.0 | `Added @request.body.someField:changed modifier.` | — | https://github.com/pocketbase/pocketbase/releases/tag/v0.34.0 | artefacto técnico fuerte |
| pocketbase-e9 | v0.34.0 | `Added MailerRecordEvent.Meta["info"] property for the OnMailerRecordAuthAlertSend hook.` | — | https://github.com/pocketbase/pocketbase/releases/tag/v0.34.0 | hook + propiedad concreta |
| pocketbase-e10 | v0.33.0 | `Added extra id characters validation in addition to the user specified regex pattern (#7312).` | #7312 | https://github.com/pocketbase/pocketbase/releases/tag/v0.33.0 | validación + condición |

## Valoración por candidato

### pocketbase-e1
**Release:** v0.35.1  
**Texto literal:**  
`Minor UI fixes (normalized relations picker selection and confirmation message when maxSelect=0/1, updated node deps).`  
**PR:** null  
**Link exacto:** https://github.com/pocketbase/pocketbase/releases/tag/v0.35.1

**Valoración.** Esta entrada se selecciona porque contiene una condición explícita (`when maxSelect=0/1`) y una superficie UI concreta (`relations picker selection`, `confirmation message`). Su principal limitación es que no incluye PR explícita ni separa claramente dos cambios distintos. Aun así, se considera suficientemente buena para el corpus porque describe un comportamiento visible y acotado, útil para una derivación posterior. ([github.com](https://github.com/pocketbase/pocketbase/releases?utm_source=openai))

### pocketbase-e2
**Release:** v0.35.0  
**Texto literal:**  
`Added nullString(), nullInt(), nullFloat(), nullBool, nullArray(), nullObject() JSVM helpers for scanning nullable columns (#7396).`  
**PR:** #7396  
**Link exacto:** https://github.com/pocketbase/pocketbase/releases/tag/v0.35.0

**Valoración.** Esta entrada se selecciona porque nombra artefactos técnicos muy concretos (`nullString()`, `nullInt()`, etc.) y además incluye una condición/contexto explícito (`for scanning nullable columns`). Su principal limitación es que no especifica ejemplos de uso ni comportamiento exacto de cada helper. Aun así, entra con claridad porque el cambio es muy identificable y bastante fácil de formalizar después. ([github.com](https://github.com/pocketbase/pocketbase/releases?utm_source=openai))

### pocketbase-e3
**Release:** v0.35.0  
**Texto literal:**  
`Store the correct image/png as attrs content type when generating a thumb fallback (e.g. for webp).`  
**PR:** null  
**Link exacto:** https://github.com/pocketbase/pocketbase/releases/tag/v0.35.0

**Valoración.** Esta entrada se selecciona porque combina una condición explícita (`when generating a thumb fallback`) con un valor técnico fuerte (`image/png`) y un artefacto concreto (`attrs content type`). Su principal limitación es que no referencia PR y no detalla el flujo completo de generación. Aun así, se considera suficientemente buena porque la corrección técnica está claramente expresada. ([github.com](https://github.com/pocketbase/pocketbase/releases?utm_source=openai))

### pocketbase-e4
**Release:** v0.35.0  
**Texto literal:**  
`Trimmed custom uploaded file name and extension from leftover . characters after filesystem.File normalization.`  
**PR:** null  
**Link exacto:** https://github.com/pocketbase/pocketbase/releases/tag/v0.35.0

**Valoración.** Esta entrada se selecciona porque describe una corrección funcional concreta sobre nombres de archivo y extensiones, con una condición/contexto claro (`after filesystem.File normalization`). Su principal limitación es que no especifica exactamente qué caracteres se eliminan más allá de `.` ni el observable externo detallado. Aun así, es suficientemente buena porque el artefacto afectado está claramente nombrado y el cambio parece implementable. ([github.com](https://github.com/pocketbase/pocketbase/releases?utm_source=openai))

### pocketbase-e5
**Release:** v0.34.2  
**Texto literal:**  
`Bumped JS SDK to v0.26.5 to fix Safari AbortError detection introduced with the previous release (#7369).`  
**PR:** #7369  
**Link exacto:** https://github.com/pocketbase/pocketbase/releases/tag/v0.34.2

**Valoración.** Esta entrada se selecciona porque identifica un problema técnico concreto (`Safari AbortError detection`) y lo ancla a una PR. Su principal limitación es que el comportamiento corregido no queda descrito con detalle funcional. Aun así, se considera suficientemente buena porque el bug está bien delimitado y podría derivarse con apoyo adicional de la PR o del SDK. ([github.com](https://github.com/pocketbase/pocketbase/releases?utm_source=openai))

### pocketbase-e6
**Release:** v0.34.1  
**Texto literal:**  
`Added missing : char to the autocomplete regex (#7353; thanks @ouvreboite).`  
**PR:** #7353  
**Link exacto:** https://github.com/pocketbase/pocketbase/releases/tag/v0.34.1

**Valoración.** Esta entrada se selecciona porque incluye un elemento técnico muy concreto (`:`) y un artefacto claramente identificado (`autocomplete regex`). Su principal limitación es que no indica en qué contexto exacto se usa ese regex. Aun así, entra porque el cambio es acotado, explícito y fácil de defender como evidencia candidata. ([github.com](https://github.com/pocketbase/pocketbase/releases?utm_source=openai))

### pocketbase-e7
**Release:** v0.34.1  
**Texto literal:**  
`Added "Copy raw JSON" collection dropdown option (#7357).`  
**PR:** #7357  
**Link exacto:** https://github.com/pocketbase/pocketbase/releases/tag/v0.34.1

**Valoración.** Esta entrada se selecciona porque describe una acción UI concreta y observable (`Copy raw JSON`) sobre una superficie explícita (`collection dropdown option`). Su principal limitación es que no detalla condiciones de disponibilidad ni formato exacto del contenido copiado. Aun así, se considera suficientemente buena porque es una funcionalidad clara y trazable. ([github.com](https://github.com/pocketbase/pocketbase/releases?utm_source=openai))

### pocketbase-e8
**Release:** v0.34.0  
**Texto literal:**  
`Added @request.body.someField:changed modifier.`  
**PR:** null  
**Link exacto:** https://github.com/pocketbase/pocketbase/releases/tag/v0.34.0

**Valoración.** Esta entrada se selecciona porque introduce un artefacto técnico fuerte y muy explícito (`@request.body.someField:changed`). Su principal limitación es que la línea de release, por sí sola, no explica todo el comportamiento ni los casos de uso. Aun así, entra porque el artefacto añadido está claramente nombrado y parece directamente formalizable en una fase posterior. ([github.com](https://github.com/pocketbase/pocketbase/releases?utm_source=openai))

### pocketbase-e9
**Release:** v0.34.0  
**Texto literal:**  
`Added MailerRecordEvent.Meta["info"] property for the OnMailerRecordAuthAlertSend hook.`  
**PR:** null  
**Link exacto:** https://github.com/pocketbase/pocketbase/releases/tag/v0.34.0

**Valoración.** Esta entrada se selecciona porque nombra una propiedad concreta (`Meta["info"]`) y un hook explícito (`OnMailerRecordAuthAlertSend`). Su principal limitación es que no describe el valor esperado de `info` ni cuándo se rellena. Aun así, es suficientemente buena porque el cambio de interfaz está muy claro y es potencialmente útil para derivación. ([github.com](https://github.com/pocketbase/pocketbase/releases?utm_source=openai))

### pocketbase-e10
**Release:** v0.33.0  
**Texto literal:**  
`Added extra id characters validation in addition to the user specified regex pattern (#7312).`  
**PR:** #7312  
**Link exacto:** https://github.com/pocketbase/pocketbase/releases/tag/v0.33.0

**Valoración.** Esta entrada se selecciona porque combina una acción clara (`validation`) con un artefacto específico (`id characters`) y una condición/contexto explícito (`in addition to the user specified regex pattern`). Su principal limitación es que la línea resumida no incluye toda la lista de caracteres prohibidos, aunque la misma release sí la detalla más abajo. Aun así, se considera suficientemente buena porque el tipo de restricción está claramente identificado. ([github.com](https://github.com/pocketbase/pocketbase/releases?utm_source=openai))

## Observaciones finales

- Todas las entradas seleccionadas aparecen en releases oficiales de PocketBase. ([github.com](https://github.com/pocketbase/pocketbase/releases?utm_source=openai))
- Varias contienen PR explícita, pero no todas. Esto hace que PocketBase sea un caso algo más débil en trazabilidad que otros repositorios donde cada línea viene anclada a PR. ([github.com](https://github.com/pocketbase/pocketbase/releases?utm_source=openai))
- Aun así, las entradas seleccionadas contienen señales estructurales útiles: condiciones, artefactos técnicos concretos, acciones UI, hooks, propiedades y reglas de validación. ([github.com](https://github.com/pocketbase/pocketbase/releases?utm_source=openai))
- Sigue quedando indeterminado el campo `pr_merged`, y en varias entradas también `pr_url`, porque la release no incluye referencia explícita a PR en todos los casos. ([github.com](https://github.com/pocketbase/pocketbase/releases?utm_source=openai))

## Comprobación metodológica final

### Defendibilidad
Sí, pero **con menor fuerza que en otros repositorios**.  
La selección sigue siendo defendible porque todas las entradas provienen de releases oficiales y contienen señales técnicas útiles. Sin embargo, la ausencia de PR explícita en varias líneas reduce la trazabilidad mínima respecto a repositorios como Medusa, Directus o n8n. ([github.com](https://github.com/pocketbase/pocketbase/releases?utm_source=openai))

### Pragmatismo
Sí, el resultado es pragmático. PocketBase publica releases con entradas relativamente cortas y no siempre enlazadas a PR, así que exigir el mismo nivel de precisión que en otros repositorios haría caer demasiadas entradas útiles. Esta selección mantiene utilidad sin sobreexigir. ([github.com](https://github.com/pocketbase/pocketbase/releases?utm_source=openai))

### Corrección metodológica
Sí, la metodología sigue siendo coherente:
- el JSON contiene solo evidencia factual;
- el informe contiene la interpretación y defensa;
- y se reconoce explícitamente lo que no puede comprobarse. ([github.com](https://github.com/pocketbase/pocketbase/releases?utm_source=openai))

### Limitaciones
Las limitaciones aquí son más visibles:
- no todas las entradas tienen PR explícita;
- algunas líneas de release son más cercanas a notas técnicas resumidas que a cambios funcionales plenamente trazables;
- por tanto, PocketBase es un repositorio donde parte de la muestra probablemente caerá en la segunda fase de derivación.

### Juicio final
**Sí, el resultado sigue siendo utilizable y defendible para el TFG, pero PocketBase es probablemente el repositorio más débil del conjunto en trazabilidad directa desde release note a PR.**  
Eso no obliga a rehacerlo, pero sí conviene **documentarlo como una limitación específica del repositorio**. ([github.com](https://github.com/pocketbase/pocketbase/releases?utm_source=openai))