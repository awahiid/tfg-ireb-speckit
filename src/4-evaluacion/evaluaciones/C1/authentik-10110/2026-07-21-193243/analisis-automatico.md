# C1 — authentik-10110

**Ejecucion**: C1/authentik-10110/2026-07-21/193243
**Analizado**: 2026-07-22 01:40

## Resultados de herramientas

| Herramienta | Resultado |
|-------------|-----------|
| Archivos modificados | 59 |
| Archivos fuente (sin infraestructura) | 13 |
| Lineas de codigo generadas (cloc) | 61270 |
| &nbsp;-- YAML | 48930 lineas |
| &nbsp;-- diff | 7228 lineas |
| &nbsp;-- Markdown | 3845 lineas |
| &nbsp;-- Bourne Shell | 1051 lineas |
| &nbsp;-- JSON | 87 lineas |
| &nbsp;-- Python | 84 lineas |
| &nbsp;-- TypeScript | 45 lineas |
| Coste generacion | $0.0490 |
| Tokens consumidos | 3713692 |

## Analisis estatico (semgrep)

**Total incidencias**: 0

**Comando**: `/home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/.venv/bin/semgrep --json --quiet --no-git-ignore --config=auto /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C1/authentik-10110/2026-07-21/193243/generated`

**Archivos escaneados**: 60
  - .md: 43 archivos
  - .json: 7 archivos
  - .sh: 5 archivos
  - .yml: 2 archivos
  - .py: 1 archivos
  - .patch: 1 archivos
  - .ts: 1 archivos
*(no se encontraron incidencias)*

### Linters por lenguaje

**shellcheck**: 12 incidencias en 5 archivos

**Comando**: `shellcheck --format=json /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C1/authentik-10110/2026-07-21/193243/generated/.specify/scripts/bash/check-prerequisites.sh`

```
  L79:8 INFO: Not following: ./common.sh was not specified as input (see shellcheck -x). (1091)
  L6:1 WARNING: find_specify_root references arguments, but none are ever passed. (2120)
  L65:23 INFO: Use find_specify_root "$@" if function's $1 should mean script's $1. (2119)
  L71:11 WARNING: Declare and assign separately to avoid masking return values. (2155)
  L571:36 WARNING: This pattern always overrides a later one on line 571. (2221)
  L571:42 WARNING: This pattern never matches because of a previous pattern on line 571. (2222)
  L152:8 INFO: Not following: ./common.sh was not specified as input (see shellcheck -x). (1091)
  L171:11 WARNING: Declare and assign separately to avoid masking return values. (2155)
  L208:15 WARNING: Declare and assign separately to avoid masking return values. (2155)
  L271:24 STYLE: See if you can use ${variable//search/replace} instead. (2001)
  L28:8 INFO: Not following: ./common.sh was not specified as input (see shellcheck -x). (1091)
  L23:8 INFO: Not following: ./common.sh was not specified as input (see shellcheck -x). (1091)
```

**pyflakes**: 0 incidencias en 1 archivos

**Comando**: `pyflakes /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C1/authentik-10110/2026-07-21/193243/generated/authentik/admin/api/system.py`

*(sin incidencias)*

**eslint**: 0 incidencias en 1 archivos

**Comando**: `/home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/node_modules/.bin/eslint --config /home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/.eslintrc.json --format json /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C1/authentik-10110/2026-07-21/193243/generated/web/src/admin/admin-overview/cards/FipsStatusCard.ts`

*(sin incidencias)*

## Archivos fuente modificados

- `authentik/admin/api/system.py`
- `schema.yml`
- `specs/001-fix-fips-schema/checklists/api.md`
- `specs/001-fix-fips-schema/checklists/requirements.md`
- `specs/001-fix-fips-schema/contracts/README.md`
- `specs/001-fix-fips-schema/contracts/rest-api-runtime.yml`
- `specs/001-fix-fips-schema/data-model.md`
- `specs/001-fix-fips-schema/plan.md`
- `specs/001-fix-fips-schema/quickstart.md`
- `specs/001-fix-fips-schema/research.md`
- `specs/001-fix-fips-schema/spec.md`
- `specs/001-fix-fips-schema/tasks.md`
- `web/src/admin/admin-overview/cards/FipsStatusCard.ts`

... y 46 archivos de infraestructura (.specify, .github)
