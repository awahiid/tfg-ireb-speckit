# C1 — medusa-13930

**Ejecucion**: C1/medusa-13930/2026-07-21/052832
**Analizado**: 2026-07-22 01:41

## Resultados de herramientas

| Herramienta | Resultado |
|-------------|-----------|
| Archivos modificados | 56 |
| Archivos fuente (sin infraestructura) | 10 |
| Lineas de codigo generadas (cloc) | 9384 |
| &nbsp;-- TypeScript | 4251 lineas |
| &nbsp;-- Markdown | 3953 lineas |
| &nbsp;-- Bourne Shell | 1019 lineas |
| &nbsp;-- JSON | 102 lineas |
| &nbsp;-- YAML | 59 lineas |
| Coste generacion | $0.0550 |
| Tokens consumidos | 3628713 |

## Analisis estatico (semgrep)

**Total incidencias**: 0

**Comando**: `/home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/.venv/bin/semgrep --json --quiet --no-git-ignore --config=auto /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C1/medusa-13930/2026-07-21/052832/generated`

**Archivos escaneados**: 58
  - .md: 42 archivos
  - .json: 8 archivos
  - .sh: 5 archivos
  - .ts: 2 archivos
  - .yml: 1 archivos
*(no se encontraron incidencias)*

### Linters por lenguaje

**shellcheck**: 12 incidencias en 5 archivos

**Comando**: `shellcheck --format=json /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C1/medusa-13930/2026-07-21/052832/generated/.specify/scripts/bash/check-prerequisites.sh`

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

**eslint**: 1 incidencias en 2 archivos

**Comando**: `/home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/node_modules/.bin/eslint --config /home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/.eslintrc.json --format json /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C1/medusa-13930/2026-07-21/052832/generated/integration-tests/http/__tests__/product/admin/product.spec.ts`

```
  L4846:5 Parsing error: ',' expected. (None)
```

## Archivos fuente modificados

- `integration-tests/http/__tests__/product/admin/product.spec.ts`
- `packages/modules/product/src/models/product.ts`
- `specs/001-variant-sku-search/checklists/requirements.md`
- `specs/001-variant-sku-search/contracts/api.md`
- `specs/001-variant-sku-search/data-model.md`
- `specs/001-variant-sku-search/plan.md`
- `specs/001-variant-sku-search/quickstart.md`
- `specs/001-variant-sku-search/research.md`
- `specs/001-variant-sku-search/spec.md`
- `specs/001-variant-sku-search/tasks.md`

... y 46 archivos de infraestructura (.specify, .github)
