# C0 — authentik-10110

**Ejecucion**: C0/authentik-10110/2026-07-21/041504
**Analizado**: 2026-07-22 01:39

## Resultados de herramientas

| Herramienta | Resultado |
|-------------|-----------|
| Archivos modificados | 54 |
| Archivos fuente (sin infraestructura) | 15 |
| Lineas de codigo generadas (cloc) | 4911 |
| &nbsp;-- Markdown | 2718 lineas |
| &nbsp;-- Bourne Shell | 1019 lineas |
| &nbsp;-- TypeScript | 644 lineas |
| &nbsp;-- Python | 372 lineas |
| &nbsp;-- JSON | 99 lineas |
| &nbsp;-- YAML | 59 lineas |
| Coste generacion | $0.0488 |
| Tokens consumidos | 5147488 |

## Analisis estatico (semgrep)

**Total incidencias**: 0

**Comando**: `/home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/.venv/bin/semgrep --json --quiet --no-git-ignore --config=auto /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C0/authentik-10110/2026-07-21/041504/generated`

**Archivos escaneados**: 56
  - .md: 34 archivos
  - .json: 8 archivos
  - .sh: 5 archivos
  - .py: 5 archivos
  - .ts: 3 archivos
  - .yml: 1 archivos
*(no se encontraron incidencias)*

### Linters por lenguaje

**shellcheck**: 12 incidencias en 5 archivos

**Comando**: `shellcheck --format=json /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C0/authentik-10110/2026-07-21/041504/generated/.specify/scripts/bash/check-prerequisites.sh`

```
  L79:8 INFO: Not following: ./common.sh was not specified as input (see shellcheck -x). (1091)
  L6:1 WARNING: find_specify_root references arguments, but none are ever passed. (2120)
  L65:23 INFO: Use find_specify_root "$@" if function's $1 should mean script's $1. (2119)
  L71:11 WARNING: Declare and assign separately to avoid masking return values. (2155)
  L571:36 WARNING: This pattern always overrides a later one on line 571. (2221)
  L571:42 WARNING: This pattern never matches because of a previous pattern on line 571. (2222)
  L124:8 INFO: Not following: ./common.sh was not specified as input (see shellcheck -x). (1091)
  L143:11 WARNING: Declare and assign separately to avoid masking return values. (2155)
  L180:15 WARNING: Declare and assign separately to avoid masking return values. (2155)
  L228:24 STYLE: See if you can use ${variable//search/replace} instead. (2001)
  L28:8 INFO: Not following: ./common.sh was not specified as input (see shellcheck -x). (1091)
  L23:8 INFO: Not following: ./common.sh was not specified as input (see shellcheck -x). (1091)
```

**pyflakes**: 0 incidencias en 5 archivos

**Comando**: `pyflakes /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C0/authentik-10110/2026-07-21/041504/generated/authentik/providers/scim/api/providers.py`

*(sin incidencias)*

**eslint**: 13 incidencias en 3 archivos

**Comando**: `/home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/node_modules/.bin/eslint --config /home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/.eslintrc.json --format json /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C0/authentik-10110/2026-07-21/041504/generated/web/src/admin/providers/scim/SCIMProviderForm.ts`

```
  L138:72 Unexpected block statement surrounding arrow body; move the returned value immediately after the `=>`. (arrow-body-style)
  L141:88 Unexpected block statement surrounding arrow body; move the returned value immediately after the `=>`. (arrow-body-style)
  L144:68 Unexpected block statement surrounding arrow body; move the returned value immediately after the `=>`. (arrow-body-style)
  L183:100 Unexpected block statement surrounding arrow body; move the returned value immediately after the `=>`. (arrow-body-style)
  L190:56 Unexpected block statement surrounding arrow body; parenthesize the returned value and move it immediately after the `=>`. (arrow-body-style)
  L260:49 Unexpected block statement surrounding arrow body; move the returned value immediately after the `=>`. (arrow-body-style)
  L261:55 Expected '===' and instead saw '=='. (eqeqeq)
  L293:52 Unexpected block statement surrounding arrow body; move the returned value immediately after the `=>`. (arrow-body-style)
  L294:51 Expected '===' and instead saw '=='. (eqeqeq)
  L38:49 Expected { after 'if' condition. (curly)
  L68:37 Expected { after 'if' condition. (curly)
  L195:44 Unexpected block statement surrounding arrow body; move the returned value immediately after the `=>`. (arrow-body-style)
  L202:50 Unexpected block statement surrounding arrow body; move the returned value immediately after the `=>`. (arrow-body-style)
```

## Archivos fuente modificados

- `authentik/providers/scim/api/providers.py`
- `authentik/providers/scim/migrations/0009_scimprovider_push_group_mode_push_group_and_more.py`
- `authentik/providers/scim/models.py`
- `authentik/providers/scim/settings.py`
- `authentik/providers/scim/tasks.py`
- `specs/001-authentik-10110/contracts/api.md`
- `specs/001-authentik-10110/data-model.md`
- `specs/001-authentik-10110/plan.md`
- `specs/001-authentik-10110/quickstart.md`
- `specs/001-authentik-10110/research.md`
- `specs/001-authentik-10110/spec.md`
- `specs/001-authentik-10110/tasks.md`
- `web/src/admin/providers/scim/SCIMProviderForm.ts`
- `web/src/admin/providers/scim/SCIMProviderPush.ts`
- `web/src/admin/providers/scim/SCIMProviderViewPage.ts`

... y 39 archivos de infraestructura (.specify, .github)
