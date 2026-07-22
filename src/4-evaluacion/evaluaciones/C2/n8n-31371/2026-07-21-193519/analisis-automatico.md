# C2 — n8n-31371

**Ejecucion**: C2/n8n-31371/2026-07-21/193519
**Analizado**: 2026-07-22 01:43

## Resultados de herramientas

| Herramienta | Resultado |
|-------------|-----------|
| Archivos modificados | 57 |
| Archivos fuente (sin infraestructura) | 11 |
| Lineas de codigo generadas (cloc) | 13813 |
| &nbsp;-- diff | 7259 lineas |
| &nbsp;-- Markdown | 3801 lineas |
| &nbsp;-- TypeScript | 1555 lineas |
| &nbsp;-- Bourne Shell | 1051 lineas |
| &nbsp;-- JSON | 88 lineas |
| &nbsp;-- YAML | 59 lineas |
| Coste generacion | $0.0746 |
| Tokens consumidos | 6012643 |

## Analisis estatico (semgrep)

**Total incidencias**: 0

**Comando**: `/home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/.venv/bin/semgrep --json --quiet --no-git-ignore --config=auto /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C2/n8n-31371/2026-07-21/193519/generated`

**Archivos escaneados**: 58
  - .md: 43 archivos
  - .json: 7 archivos
  - .sh: 5 archivos
  - .yml: 1 archivos
  - .patch: 1 archivos
  - .ts: 1 archivos
*(no se encontraron incidencias)*

### Linters por lenguaje

**shellcheck**: 12 incidencias en 5 archivos

**Comando**: `shellcheck --format=json /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C2/n8n-31371/2026-07-21/193519/generated/.specify/scripts/bash/check-prerequisites.sh`

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

**eslint**: 8 incidencias en 2 archivos

**Comando**: `/home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/node_modules/.bin/eslint --config /home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/.eslintrc.json --format json /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C2/n8n-31371/2026-07-21/193519/generated/packages/nodes-base/nodes/MongoDb/MongoDb.node.ts`

```
  L7:1 'mongodb' import is duplicated. (no-duplicate-imports)
  L9:1 'n8n-workflow' import is duplicated. (no-duplicate-imports)
  L547:25 Expected { after 'if' condition. (curly)
  L793:14 'name' is already a global variable. (no-shadow)
  L31:8 'test' is already a global variable. (no-shadow)
  L197:29 '_itemIndex' is assigned a value but never used. (@typescript-eslint/no-unused-vars)
  L383:31 '_itemIndex' is assigned a value but never used. (@typescript-eslint/no-unused-vars)
  L439:31 '_itemIndex' is assigned a value but never used. (@typescript-eslint/no-unused-vars)
```

## Archivos fuente modificados

- `packages/nodes-base/nodes/MongoDb/MongoDb.node.ts`
- `packages/nodes-base/nodes/MongoDb/test/MongoDB.test.ts`
- `specs/001-validate-updatekey-type/checklists/requirements.md`
- `specs/001-validate-updatekey-type/checklists/type-validation.md`
- `specs/001-validate-updatekey-type/contracts/README.md`
- `specs/001-validate-updatekey-type/data-model.md`
- `specs/001-validate-updatekey-type/plan.md`
- `specs/001-validate-updatekey-type/quickstart.md`
- `specs/001-validate-updatekey-type/research.md`
- `specs/001-validate-updatekey-type/spec.md`
- `specs/001-validate-updatekey-type/tasks.md`

... y 46 archivos de infraestructura (.specify, .github)
