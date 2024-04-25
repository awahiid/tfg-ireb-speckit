# Directus — informe de selección de evidencia

## Objetivo

Este informe documenta la selección de entradas de changelog/release suficientemente buenas para una futura derivación de requisitos. El JSON asociado contiene únicamente evidencia literal y trazable; no contiene requisitos redactados.

## Criterio de selección

Se incluyen entradas que:
1. aparecen en releases o changelogs oficiales;
2. tienen trazabilidad mínima suficiente, preferiblemente mediante referencia a PR;
3. contienen al menos una señal útil para una futura derivación, como método/path, condición explícita, actor explícito, superficie pública o término relevante de dominio.

No se exige perfección ni completitud total. La decisión se basa en suficiencia defendible, no en excelencia absoluta.

## Fuentes

- Releases: https://github.com/directus/directus/releases
- Repositorio: https://github.com/directus/directus

## Tabla resumen

| ID | Release | Entry text | PR | Link exacto | Valoración breve |
|---|---|---|---|---|---|
| directus-e1 | v11.17.1 | `Added keyboard navigation to the cards layout (#26976 by @HZooly)` | #26976 | https://github.com/directus/directus/releases/tag/v11.17.1 | UI observable clara |
| directus-e2 | v11.17.1 | `Added native Tabs group interface. Uninstall the extension if currently using it to avoid unintended side effects. (#26836 by @bryantgillespie)` | #26836 | https://github.com/directus/directus/releases/tag/v11.17.1 | interfaz + condición explícita |
| directus-e3 | v11.17.1 | `Added bulk folder deletion from the files grid with move-up or delete-all options (#26886 by @HZooly)` | #26886 | https://github.com/directus/directus/releases/tag/v11.17.1 | acción UI muy concreta |
| directus-e4 | v11.17.1 | `Used shorter tooltip delay for disabled elements (#26965 by @HZooly)` | #26965 | https://github.com/directus/directus/releases/tag/v11.17.1 | comportamiento UI identificable |
| directus-e5 | v11.16.0 | `Added support for a global draft version that is automatically available for all items when versioning is enabled (#26772)` | #26772 | https://github.com/directus/directus/releases/tag/v11.16.0 | condición + datos/versionado |
| directus-e6 | v11.15.4 | `Fixed translation interface being disabled when delete permission not allowed (#26669 by @AlexGaillard)` | #26669 | https://github.com/directus/directus/releases/tag/v11.15.4 | condición + permisos + UI |
| directus-e7 | v11.15.4 | `Fixed item comparison failing when special characters are present in manual primary keys (#26668 by @AlexGaillard)` | #26668 | https://github.com/directus/directus/releases/tag/v11.15.4 | condición explícita + datos |
| directus-e8 | v11.15.4 | `Fixed non-editable state for relational fields with custom permissions (#26676 by @HZooly)` | #26676 | https://github.com/directus/directus/releases/tag/v11.15.4 | permisos + campos relacionales |
| directus-e9 | v11.15.4 | `Added restriction of allowed MIME types to the system file upload interface (#26646 by @AlexGaillard)` | #26646 | https://github.com/directus/directus/releases/tag/v11.15.4 | validación + interfaz de subida |
| directus-e10 | v11.15.3 | `Added activity logging for explicit user logout (#26638 by @JamesW1)` | #26638 | https://github.com/directus/directus/releases/tag/v11.15.3 | auth + logging + actor |

## Valoración por candidato

### directus-e1
**Release:** v11.17.1  
**Texto literal:**  
`Added keyboard navigation to the cards layout (#26976 by @HZooly)`  
**PR:** #26976  
**Link exacto:** https://github.com/directus/directus/releases/tag/v11.17.1

**Valoración.** Esta entrada se selecciona porque describe una mejora UI muy concreta y claramente observable (`keyboard navigation` en `cards layout`). Su principal limitación es que no explicita teclas, estados ni resultados detallados. Aun así, se considera suficientemente buena para el corpus porque la superficie afectada está bien delimitada y el comportamiento es implementable. ([github.com](https://github.com/directus/directus/releases))

### directus-e2
**Release:** v11.17.1  
**Texto literal:**  
`Added native Tabs group interface. Uninstall the extension if currently using it to avoid unintended side effects. (#26836 by @bryantgillespie)`  
**PR:** #26836  
**Link exacto:** https://github.com/directus/directus/releases/tag/v11.17.1

**Valoración.** Esta entrada se selecciona porque nombra una interfaz concreta (`Tabs group interface`) y además contiene una condición explícita (`if currently using it`). Su principal limitación es que mezcla funcionalidad nueva con una advertencia operativa, lo que puede complicar una derivación unitaria. Aun así, entra porque la superficie es clara y el cambio es suficientemente específico. ([github.com](https://github.com/directus/directus/releases))

### directus-e3
**Release:** v11.17.1  
**Texto literal:**  
`Added bulk folder deletion from the files grid with move-up or delete-all options (#26886 by @HZooly)`  
**PR:** #26886  
**Link exacto:** https://github.com/directus/directus/releases/tag/v11.17.1

**Valoración.** Esta entrada se selecciona porque describe una acción de UI muy concreta (`bulk folder deletion`) y opciones explícitas (`move-up` o `delete-all`). Su principal limitación es que no indica restricciones, permisos ni contexto adicional. Aun así, es suficientemente buena porque el comportamiento esperado se intuye con bastante claridad desde el propio texto. ([github.com](https://github.com/directus/directus/releases))

### directus-e4
**Release:** v11.17.1  
**Texto literal:**  
`Used shorter tooltip delay for disabled elements (#26965 by @HZooly)`  
**PR:** #26965  
**Link exacto:** https://github.com/directus/directus/releases/tag/v11.17.1

**Valoración.** Esta entrada se selecciona porque apunta a un comportamiento UI identificable (`tooltip delay` para `disabled elements`). Su principal limitación es que el nuevo valor temporal no aparece en el texto del release. Aun así, se considera suficientemente buena porque el cambio es acotado, observable y trazable. ([github.com](https://github.com/directus/directus/releases))

### directus-e5
**Release:** v11.16.0  
**Texto literal:**  
`Added support for a global draft version that is automatically available for all items when versioning is enabled (#26772)`  
**PR:** #26772  
**Link exacto:** https://github.com/directus/directus/releases/tag/v11.16.0

**Valoración.** Esta entrada se selecciona porque contiene una condición explícita (`when versioning is enabled`) y un comportamiento de datos/versionado muy claro (`global draft version` disponible para `all items`). Su principal limitación es que no explicita cómo se expone exactamente esa disponibilidad. Aun así, es suficientemente buena para el corpus porque el cambio funcional está muy bien delimitado. ([github.com](https://github.com/directus/directus/releases))

### directus-e6
**Release:** v11.15.4  
**Texto literal:**  
`Fixed translation interface being disabled when delete permission not allowed (#26669 by @AlexGaillard)`  
**PR:** #26669  
**Link exacto:** https://github.com/directus/directus/releases/tag/v11.15.4

**Valoración.** Esta entrada se selecciona porque combina una superficie UI concreta (`translation interface`) con una condición explícita (`when delete permission not allowed`) y un término de permisos. Su principal limitación es que no detalla el estado correcto esperado tras la corrección. Aun así, se considera suficientemente buena porque el escenario problemático está muy claramente acotado. ([github.com](https://github.com/directus/directus/releases))

### directus-e7
**Release:** v11.15.4  
**Texto literal:**  
`Fixed item comparison failing when special characters are present in manual primary keys (#26668 by @AlexGaillard)`  
**PR:** #26668  
**Link exacto:** https://github.com/directus/directus/releases/tag/v11.15.4

**Valoración.** Esta entrada se selecciona porque incluye una condición muy explícita (`when special characters are present in manual primary keys`) y un proceso funcional concreto (`item comparison`). Su principal limitación es que no especifica cuáles caracteres ni el error exacto. Aun así, entra porque el caso está suficientemente bien descrito para una futura formalización. ([github.com](https://github.com/directus/directus/releases))

### directus-e8
**Release:** v11.15.4  
**Texto literal:**  
`Fixed non-editable state for relational fields with custom permissions (#26676 by @HZooly)`  
**PR:** #26676  
**Link exacto:** https://github.com/directus/directus/releases/tag/v11.15.4

**Valoración.** Esta entrada se selecciona porque nombra artefactos claros (`relational fields`, `custom permissions`) y un estado concreto (`non-editable state`). Su principal limitación es que no especifica exactamente cuándo el campo debía ser editable. Aun así, es suficientemente buena porque el problema está bastante bien delimitado por el propio texto. ([github.com](https://github.com/directus/directus/releases))

### directus-e9
**Release:** v11.15.4  
**Texto literal:**  
`Added restriction of allowed MIME types to the system file upload interface (#26646 by @AlexGaillard)`  
**PR:** #26646  
**Link exacto:** https://github.com/directus/directus/releases/tag/v11.15.4

**Valoración.** Esta entrada se selecciona porque describe una restricción funcional clara sobre una superficie bien identificable (`system file upload interface`) y usa un término técnico fuerte (`allowed MIME types`). Su principal limitación es que no enumera los MIME types permitidos. Aun así, se considera suficientemente buena para el corpus porque el tipo de restricción es muy claro y directamente implementable. ([github.com](https://github.com/directus/directus/releases))

### directus-e10
**Release:** v11.15.3  
**Texto literal:**  
`Added activity logging for explicit user logout (#26638 by @JamesW1)`  
**PR:** #26638  
**Link exacto:** https://github.com/directus/directus/releases/tag/v11.15.3

**Valoración.** Esta entrada se selecciona porque combina actor (`user`), condición/contexto (`explicit user logout`) y una acción concreta (`activity logging`). Su principal limitación es que no indica dónde se registra la actividad ni qué campos contiene el evento. Aun así, entra porque el comportamiento está bien delimitado y tiene relevancia funcional y de auditoría. ([github.com](https://github.com/directus/directus/releases))

## Observaciones finales

- Todas las entradas seleccionadas aparecen en releases oficiales de Directus y contienen referencia explícita a PR, lo que satisface la trazabilidad mínima suficiente. ([github.com](https://github.com/directus/directus/releases))
- Las entradas cubren UI, permisos, versionado, validación de archivos y logging, es decir, superficies diversas y potencialmente formalizables en requisitos posteriores. ([github.com](https://github.com/directus/directus/releases))
- Sigue quedando indeterminado el campo `pr_merged`, porque en este artefacto no se ha consultado programáticamente `merged_at` de cada PR.
- La selección es suficientemente rica para una segunda fase, aunque no garantiza que todas las entradas produzcan requisitos finales igual de fuertes.

## Comprobación metodológica final

### Defendibilidad
Sí, la selección es defendible porque cada entrada:
- aparece en una release oficial;
- referencia una PR concreta;
- y tiene una justificación breve con fortaleza y limitación. ([github.com](https://github.com/directus/directus/releases))

### Pragmatismo
Sí, el proceso sigue siendo pragmático porque no exige perfección ni trata el changelog como requisito final; solo selecciona evidencia candidata suficientemente útil.

### Corrección metodológica
Sí, se mantiene la separación entre:
- **evidencia factual** en el JSON;
- **interpretación/defensa** en el informe.  
Eso sigue la metodología definida para la primera fase del TFG.

### Limitaciones
Las limitaciones siguen siendo asumibles:
- algunas entradas necesitarán PR/tests/docs para volverse requisitos fuertes;
- `pr_merged` no está verificado aquí;
- la granularidad de algunas líneas de release es desigual.

### Juicio final
**Sí, el resultado es suficientemente bueno, defendible y metodológicamente coherente como para continuar con el siguiente repositorio.**