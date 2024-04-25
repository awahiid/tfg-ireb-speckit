# <Repo name> — informe de selección de evidencia

## Objetivo

Este informe documenta la selección de entradas de changelog/release suficientemente buenas para una futura derivación de requisitos. El JSON asociado contiene únicamente evidencia literal y trazable; no contiene requisitos redactados.

## Criterio de selección

Se incluyen entradas que:
1. aparecen en releases o changelogs oficiales;
2. tienen trazabilidad mínima suficiente, preferiblemente mediante referencia a PR;
3. contienen al menos una señal útil para una futura derivación, como método/path, condición explícita, actor explícito, superficie pública o término relevante de dominio.

No se exige perfección ni completitud total. La decisión se basa en suficiencia defendible, no en excelencia absoluta.

## Fuentes

- Releases: <release-index-url>
- Repositorio: <repo-url>

## Tabla resumen

| ID | Release | Entry text | PR | Valoración breve |
|---|---|---|---|---|
| <repo>-e1 | <tag> | `<literal text>` | #<n> | <motivo breve> |

## Valoración por candidato

### <repo>-e1
**Release:** <tag>  
**Texto literal:**  
`<literal text>`  
**PR:** <#n or null>

**Valoración.** Esta entrada se selecciona porque <fortaleza principal: trazabilidad, condición, actor, path, superficie, etc.>. Su principal limitación es <qué falta o qué no puede comprobarse solo con esta evidencia>. Aun así, se considera suficientemente buena para el corpus porque <defensa breve de inclusión>.

## Observaciones finales

- Qué puede comprobarse con esta evidencia.
- Qué queda indeterminado.
- Por qué la selección es suficiente para la siguiente fase de derivación de requisitos.