# C2 — authentik-10110

**Ejecucion**: C2/authentik-10110/2026-07-21/193401
**Analizado**: 2026-07-22 01:41

## Resultados de herramientas

| Herramienta | Resultado |
|-------------|-----------|
| Archivos modificados | 60 |
| Archivos fuente (sin infraestructura) | 14 |
| Lineas de codigo generadas (cloc) | 12726 |
| &nbsp;-- diff | 7415 lineas |
| &nbsp;-- Markdown | 3978 lineas |
| &nbsp;-- Bourne Shell | 1051 lineas |
| &nbsp;-- Python | 136 lineas |
| &nbsp;-- JSON | 87 lineas |
| &nbsp;-- YAML | 59 lineas |
| Coste generacion | $0.0516 |
| Tokens consumidos | 3447895 |

## Analisis estatico (semgrep)

**Total incidencias**: 0

**Comando**: `/home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/.venv/bin/semgrep --json --quiet --no-git-ignore --config=auto /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C2/authentik-10110/2026-07-21/193401/generated`

**Archivos escaneados**: 59
  - .md: 44 archivos
  - .json: 7 archivos
  - .sh: 5 archivos
  - .yml: 1 archivos
  - .py: 1 archivos
  - .patch: 1 archivos
*(no se encontraron incidencias)*

### Linters por lenguaje

**shellcheck**: 12 incidencias en 5 archivos

**Comando**: `shellcheck --format=json /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C2/authentik-10110/2026-07-21/193401/generated/.specify/scripts/bash/check-prerequisites.sh`

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

**pyflakes**: 1 incidencias en 4 archivos

**Comando**: `pyflakes /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C2/authentik-10110/2026-07-21/193401/generated/authentik/admin/api/system.py`

```
  L3:1 'unittest.mock.MagicMock' imported but unused
```

## Archivos fuente modificados

- `authentik/admin/api/system.py`
- `authentik/admin/tests/test_fips_detection.py`
- `authentik/admin/tests/test_openapi_schema.py`
- `authentik/admin/tests/test_system_api.py`
- `specs/001-fips-api-schema/checklists/fips.md`
- `specs/001-fips-api-schema/checklists/requirements.md`
- `specs/001-fips-api-schema/contracts/rest-api-contract.md`
- `specs/001-fips-api-schema/data-model.md`
- `specs/001-fips-api-schema/plan.md`
- `specs/001-fips-api-schema/quickstart.md`
- `specs/001-fips-api-schema/research.md`
- `specs/001-fips-api-schema/scope-contract.md`
- `specs/001-fips-api-schema/spec.md`
- `specs/001-fips-api-schema/tasks.md`

... y 46 archivos de infraestructura (.specify, .github)
