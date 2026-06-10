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
| authentik-e1 | 2026.5.0 | `enterprise/providers/scim: add support for interactive OAuth2 (cherry-pick #22072 to version-2026.5) by @authentik-automation[bot] in #22337` | #22337 | https://github.com/goauthentik/authentik/releases/tag/version%2F2026.5.0 | SCIM + OAuth2 + soporte explícito |
| authentik-e2 | 2026.2.3 | `web/flows: continuous login (cherry-pick #19862 to version-2026.2) by @authentik-automation[bot] in #20712` | #20712 | https://github.com/goauthentik/authentik/releases/tag/version%2F2026.2.3 | flujo funcional claro |
| authentik-e3 | 2026.2.3 | `lifecycle: make gunicorn --max-requests configurable (cherry-pick #20736 to version-2026.2) by @authentik-automation[bot] in #20744` | #20744 | https://github.com/goauthentik/authentik/releases/tag/version%2F2026.2.3 | parámetro/configuración explícita |
| authentik-e4 | 2026.2.3 | `packages/django-channels-postgres: provide sync API for group_send (cherry-pick #20740 to version-2026.2) by @authentik-automation[bot] in #20741` | #20741 | https://github.com/goauthentik/authentik/releases/tag/version%2F2026.2.3 | API explícita |
| authentik-e5 | 2025.12.5 | `web/admin: bad width on policy test results (cherry-pick #20668 to version-2026.2) by @authentik-automation[bot] in #20697` | #20697 | https://github.com/goauthentik/authentik/releases/tag/version%2F2025.12.5 | UI/admin + resultado de policy |
| authentik-e6 | 2025.12.5 | `providers/oauth2: don't auto-set redirect_uri (cherry-pick #21746 to version-2025.12) by @authentik-automation[bot] in #21749` | #21749 | https://github.com/goauthentik/authentik/releases/tag/version%2F2025.12.5 | OAuth2 + parámetro técnico fuerte |
| authentik-e7 | 2025.12.5 | `providers/oauth2: device code flow client id via auth header (cherry-pick #20457 to version-2025.12) by @authentik-automation[bot] in #21803` | #21803 | https://github.com/goauthentik/authentik/releases/tag/version%2F2025.12.5 | flujo OAuth2 claramente identificable |
| authentik-e8 | 2025.12.5 | `ci: fix binary outpost build on release (cherry-pick #20248 to version-2025.12) by @rissson in #20280` | #20280 | https://github.com/goauthentik/authentik/releases/tag/version%2F2025.12.5 | build/release explícito |
| authentik-e9 | 2026.5.0 | `endpoints: remove print line (cherry-pick #22325 to version-2026.5) by @authentik-automation[bot] in #22327` | #22327 | https://github.com/goauthentik/authentik/releases/tag/version%2F2026.5.0 | endpoint/componente claro |
| authentik-e10 | 2026.5.0 | `website/docs: release notes 2026.5: add section about package reduction (cherry-pick #22308 to version-2026.5) by @authentik-automation[bot] in #22324` | #22324 | https://github.com/goauthentik/authentik/releases/tag/version%2F2026.5.0 | documentación/release explícita |

## Valoración por candidato

### authentik-e1
**Release:** 2026.5.0  
**Texto literal:**  
`enterprise/providers/scim: add support for interactive OAuth2 (cherry-pick #22072 to version-2026.5) by @authentik-automation[bot] in #22337`  
**PR:** #22337  
**Link exacto:** https://github.com/goauthentik/authentik/releases/tag/version%2F2026.5.0

**Valoración.** Esta entrada se selecciona porque combina dos superficies de alto valor (`providers/scim` y `interactive OAuth2`) y expresa una capacidad funcional clara (`add support`). Su principal limitación es que no detalla el flujo exacto ni las condiciones de uso. Aun así, se considera suficientemente buena para el corpus porque la funcionalidad es claramente implementable y relevante para autenticación/provisión. ([github.com](https://github.com/goauthentik/authentik/releases?utm_source=openai))

### authentik-e2
**Release:** 2026.2.3  
**Texto literal:**  
`web/flows: continuous login (cherry-pick #19862 to version-2026.2) by @authentik-automation[bot] in #20712`  
**PR:** #20712  
**Link exacto:** https://github.com/goauthentik/authentik/releases/tag/version%2F2026.2.3

**Valoración.** Esta entrada se selecciona porque describe una capacidad funcional clara (`continuous login`) en una superficie identificable (`web/flows`). Su principal limitación es que no aporta condición ni output observable detallado. Aun así, se considera suficientemente buena porque el flujo es reconocible y la entrada ofrece trazabilidad adecuada. ([github.com](https://github.com/goauthentik/authentik/releases?utm_source=openai))

### authentik-e3
**Release:** 2026.2.3  
**Texto literal:**  
`lifecycle: make gunicorn --max-requests configurable (cherry-pick #20736 to version-2026`
