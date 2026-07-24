# Authentik — informe de selección de evidencia

## Objetivo

Este informe documenta la selección de entradas de changelog/release suficientemente buenas para una futura derivación de requisitos. El JSON asociado contiene únicamente evidencia literal y trazable; no contiene requisitos redactados.

## Criterio de selección

Se incluyen entradas que:
1. aparecen en releases o changelogs oficiales;
2. tienen trazabilidad mínima suficiente, preferiblemente mediante referencia a PR;
3. contienen al menos una señal útil para una futura derivación, como método/path, condición explícita, actor explícito, superficie pública o término relevante de dominio.

No se exige perfección ni completitud total. La decisión se basa en suficiencia defendible, no en excelencia absoluta.

## Fuentes

- Releases: https://github.com/goauthentik/authentik/releases
- Repositorio: https://github.com/goauthentik/authentik

## Tabla resumen

| ID | Release | Entry text | PR | Link exacto | Valoración breve |
|---|---|---|---|---|---|
| authentik-22337 | 2026.5.0 | `enterprise/providers/scim: add support for interactive OAuth2 (cherry-pick #22072 to version-2026.5) by @authentik-automation[bot] in #22337` | #22337 | https://github.com/goauthentik/authentik/releases/tag/version%2F2026.5.0 | SCIM + OAuth2 + soporte explícito |
| authentik-20712 | 2026.2.3 | `web/flows: continuous login (cherry-pick #19862 to version-2026.2) by @authentik-automation[bot] in #20712` | #20712 | https://github.com/goauthentik/authentik/releases/tag/version%2F2026.2.3 | flujo funcional claro |
| authentik-20744 | 2026.2.3 | `lifecycle: make gunicorn --max-requests configurable (cherry-pick #20736 to version-2026.2) by @authentik-automation[bot] in #20744` | #20744 | https://github.com/goauthentik/authentik/releases/tag/version%2F2026.2.3 | parámetro/configuración explícita |
| authentik-20741 | 2026.2.3 | `packages/django-channels-postgres: provide sync API for group_send (cherry-pick #20740 to version-2026.2) by @authentik-automation[bot] in #20741` | #20741 | https://github.com/goauthentik/authentik/releases/tag/version%2F2026.2.3 | API explícita |
| authentik-20697 | 2025.12.5 | `web/admin: bad width on policy test results (cherry-pick #20668 to version-2026.2) by @authentik-automation[bot] in #20697` | #20697 | https://github.com/goauthentik/authentik/releases/tag/version%2F2025.12.5 | UI/admin + resultado de policy |
| authentik-21749 | 2025.12.5 | `providers/oauth2: don't auto-set redirect_uri (cherry-pick #21746 to version-2025.12) by @authentik-automation[bot] in #21749` | #21749 | https://github.com/goauthentik/authentik/releases/tag/version%2F2025.12.5 | OAuth2 + parámetro técnico fuerte |
| authentik-21803 | 2025.12.5 | `providers/oauth2: device code flow client id via auth header (cherry-pick #20457 to version-2025.12) by @authentik-automation[bot] in #21803` | #21803 | https://github.com/goauthentik/authentik/releases/tag/version%2F2025.12.5 | flujo OAuth2 claramente identificable |
| authentik-20280 | 2025.12.5 | `ci: fix binary outpost build on release (cherry-pick #20248 to version-2025.12) by @rissson in #20280` | #20280 | https://github.com/goauthentik/authentik/releases/tag/version%2F2025.12.5 | build/release explícito |
| authentik-22327 | 2026.5.0 | `endpoints: remove print line (cherry-pick #22325 to version-2026.5) by @authentik-automation[bot] in #22327` | #22327 | https://github.com/goauthentik/authentik/releases/tag/version%2F2026.5.0 | endpoint/componente claro |
| authentik-22324 | 2026.5.0 | `website/docs: release notes 2026.5: add section about package reduction (cherry-pick #22308 to version-2026.5) by @authentik-automation[bot] in #22324` | #22324 | https://github.com/goauthentik/authentik/releases/tag/version%2F2026.5.0 | documentación/release explícita |

## Valoración por candidato

### authentik-22337
**Release:** 2026.5.0  
**Texto literal:**  
`enterprise/providers/scim: add support for interactive OAuth2 (cherry-pick #22072 to version-2026.5) by @authentik-automation[bot] in #22337`  
**PR:** #22337  
**Link exacto:** https://github.com/goauthentik/authentik/releases/tag/version%2F2026.5.0

**Valoración.** Esta entrada se selecciona porque combina dos superficies de alto valor (`providers/scim` y `interactive OAuth2`) y expresa una capacidad funcional clara (`add support`). Su principal limitación es que no detalla el flujo exacto ni las condiciones de uso. Aun así, se considera suficientemente buena para el corpus porque la funcionalidad es claramente implementable y relevante para autenticación/provisión. ([github.com](https://github.com/goauthentik/authentik/releases?utm_source=openai))

### authentik-20712
**Release:** 2026.2.3  
**Texto literal:**  
`web/flows: continuous login (cherry-pick #19862 to version-2026.2) by @authentik-automation[bot] in #20712`  
**PR:** #20712  
**Link exacto:** https://github.com/goauthentik/authentik/releases/tag/version%2F2026.2.3

**Valoración.** Esta entrada se selecciona porque describe una capacidad funcional clara (`continuous login`) en una superficie identificable (`web/flows`). Su principal limitación es que no aporta condición ni output observable detallado. Aun así, se considera suficientemente buena porque el flujo es reconocible y la entrada ofrece trazabilidad adecuada. ([github.com](https://github.com/goauthentik/authentik/releases?utm_source=openai))

### authentik-20744
**Release:** 2026.2.3  
**Texto literal:**  
`lifecycle: make gunicorn --max-requests configurable (cherry-pick #20736 to version-2026.2) by @authentik-automation[bot] in #20744`  
**PR:** #20744  
**Link exacto:** https://github.com/goauthentik/authentik/releases/tag/version%2F2026.2.3

**Valoración.** Esta entrada se selecciona porque introduce un parámetro de configuración concreto (`--max-requests`) sobre un componente de infraestructura identificable (gunicorn). La superficie es `lifecycle`, lo que sugiere que afecta al comportamiento operativo del sistema. Su principal limitación es que no detalla valores por defecto, rangos aceptables ni el impacto observable del cambio. Aun así, se considera suficientemente buena porque el parámetro es enumerable y su efecto es verificable: tras N requests, gunicorn debe reiniciar el worker.

### authentik-20741
**Release:** 2026.2.3  
**Texto literal:**  
`packages/django-channels-postgres: provide sync API for group_send (cherry-pick #20740 to version-2026.2) by @authentik-automation[bot] in #20741`  
**PR:** #20741  
**Link exacto:** https://github.com/goauthentik/authentik/releases/tag/version%2F2026.2.3

**Valoración.** Esta entrada se selecciona porque expone una API síncrona (`sync API`) para una operación concreta (`group_send`) dentro de un paquete identificable (`django-channels-postgres`). El cambio tiene una superficie técnica clara: antes solo existía la variante asíncrona; ahora se ofrece una alternativa síncrona. Su principal limitación es que no especifica la firma exacta de la nueva API ni sus casos de uso. Entra con suficiencia porque la adición de una API es un cambio funcional acotado y verificable.

### authentik-20697
**Release:** 2025.12.5  
**Texto literal:**  
`web/admin: bad width on policy test results (cherry-pick #20668 to version-2026.2) by @authentik-automation[bot] in #20697`  
**PR:** #20697  
**Link exacto:** https://github.com/goauthentik/authentik/releases/tag/version%2F2025.12.5

**Valoración.** Esta entrada se selecciona porque identifica un componente UI concreto (`web/admin`), una funcionalidad afectada (`policy test results`) y un defecto observable (`bad width`). La combinación de admin UI + políticas de seguridad la hace relevante para el corpus. Su principal limitación es que es un fix cosmético sin impacto funcional profundo, y el texto no detalla qué ancho era incorrecto ni cómo se corrigió. Aun así, entra porque el área afectada (policy testing) es central en un sistema IAM y el defecto es verificable visualmente.

### authentik-21749
**Release:** 2025.12.5  
**Texto literal:**  
`providers/oauth2: don't auto-set redirect_uri (cherry-pick #21746 to version-2025.12) by @authentik-automation[bot] in #21749`  
**PR:** #21749  
**Link exacto:** https://github.com/goauthentik/authentik/releases/tag/version%2F2025.12.5

**Valoración.** Esta entrada se selecciona porque describe un cambio de comportamiento en un flujo OAuth2 crítico: el sistema deja de asignar automáticamente `redirect_uri`. Esto es una condición de seguridad relevante, ya que la asignación automática de redirect URI puede ser un vector de ataque. La superficie es `providers/oauth2`, un subsistema bien delimitado. Su principal limitación es que no especifica qué condición disparaba el auto-set ni cómo se comporta ahora. Entra con fuerza porque el cambio es binario (antes auto-set, ahora no) y tiene implicaciones de seguridad verificables.

### authentik-21803
**Release:** 2025.12.5  
**Texto literal:**  
`providers/oauth2: device code flow client id via auth header (cherry-pick #20457 to version-2025.12) by @authentik-automation[bot] in #21803`  
**PR:** #21803  
**Link exacto:** https://github.com/goauthentik/authentik/releases/tag/version%2F2025.12.5

**Valoración.** Esta entrada se selecciona porque modifica un flujo OAuth2 estandarizado (`device code flow`) cambiando el mecanismo de transporte del `client_id` para que viaje mediante `auth header` en lugar de otro canal. Es un cambio técnico muy concreto con una superficie identificable. Su principal limitación es que no detalla cuál era el mecanismo anterior ni las implicaciones de seguridad del cambio. Entra bien porque el device code flow es un flujo OAuth2 bien especificado y el cambio de transporte es acotado y verificable.

### authentik-20280
**Release:** 2025.12.5  
**Texto literal:**  
`ci: fix binary outpost build on release (cherry-pick #20248 to version-2025.12) by @rissson in #20280`  
**PR:** #20280  
**Link exacto:** https://github.com/goauthentik/authentik/releases/tag/version%2F2025.12.5

**Valoración.** Esta entrada se selecciona con reservas. Por un lado, refiere a un artefacto concreto (`binary outpost build`) en un contexto de CI/release, lo que le da trazabilidad. Por otro, es un fix de build sin superficie funcional directa para el usuario final. Su principal limitación es que no hay un observable de producto: el cambio afecta al proceso de build, no al runtime. Entra en el corpus porque el outpost es un componente desplegable de authentik y su build correcta es precondición para la entrega, pero se le asigna una puntuación baja en relevancia funcional.

### authentik-22327
**Release:** 2026.5.0  
**Texto literal:**  
`endpoints: remove print line (cherry-pick #22325 to version-2026.5) by @authentik-automation[bot] in #22327`  
**PR:** #22327  
**Link exacto:** https://github.com/goauthentik/authentik/releases/tag/version%2F2026.5.0

**Valoración.** Esta entrada se selecciona con reservas. Identifica una superficie (`endpoints`) y una acción concreta (`remove print line`), lo que sugiere la eliminación de un artefacto de depuración que podría filtrar información en producción. Su principal limitación es la vaguedad: no se especifica qué endpoint, qué información se imprimía ni el impacto en seguridad. Entra con la puntuación más baja del corpus porque, aunque toca endpoints (superficie pública), el cambio es esencialmente una limpieza de código sin nueva funcionalidad.

### authentik-22324
**Release:** 2026.5.0  
**Texto literal:**  
`website/docs: release notes 2026.5: add section about package reduction (cherry-pick #22308 to version-2026.5) by @authentik-automation[bot] in #22324`  
**PR:** #22324  
**Link exacto:** https://github.com/goauthentik/authentik/releases/tag/version%2F2026.5.0

**Valoración.** Esta entrada se selecciona con reservas. Documenta un cambio en las release notes sobre reducción de paquetes, lo que indirectamente señala un cambio funcional subyacente (la reducción de dependencias). Su principal limitación es que es una entrada puramente documental: el cambio real está en otra PR y esta solo añade la sección correspondiente en las notas. Entra con la puntuación más baja del corpus porque no hay superficie funcional directa, pero se incluye por completitud y porque refleja una decisión de arquitectura (reducción de paquetes) potencialmente relevante.

## Observaciones finales

- **Trazabilidad**: el 100% de las entradas referencian PRs concretas, aunque al ser mayoritariamente cherry-picks, la PR original suele ser distinta de la PR mergeada. Esto añade un nivel de indirección que debe tenerse en cuenta en la fase de derivación.
- **Cobertura de dominio**: las 10 entradas cubren providers/OAuth2 (e1, e6, e7), flows/web (e2), lifecycle/infraestructura (e3), API internas (e4), admin UI (e5), CI/build (e8), endpoints (e9) y documentación (e10). La distribución está sesgada hacia OAuth2 e infraestructura, reflejando la naturaleza de authentik como sistema IAM.
- **Limitaciones**: varias entradas (e8, e9, e10) tienen baja relevancia funcional directa. Esto es consecuencia de muestrear releases de un sistema maduro donde muchos cambios son cherry-picks de mantenimiento. Para la fase de derivación se recomienda priorizar e1–e7.
- **Suficiencia**: las entradas e1–e7 superan el umbral de la rúbrica (puntuaciones estimadas entre 6 y 8 sobre 10). Las entradas e8–e10 se sitúan en el rango 3–5 y se incluyen por completitud del muestreo, no por excelencia individual.