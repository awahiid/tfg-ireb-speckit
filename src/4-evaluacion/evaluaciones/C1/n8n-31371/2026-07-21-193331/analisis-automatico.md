# C1 — n8n-31371

**Ejecucion**: C1/n8n-31371/2026-07-21/193331
**Analizado**: 2026-07-22 01:41

## Resultados de herramientas

| Herramienta | Resultado |
|-------------|-----------|
| Archivos modificados | 62 |
| Archivos fuente (sin infraestructura) | 16 |
| Lineas de codigo generadas (cloc) | 14319 |
| &nbsp;-- diff | 7404 lineas |
| &nbsp;-- Markdown | 3878 lineas |
| &nbsp;-- TypeScript | 1839 lineas |
| &nbsp;-- Bourne Shell | 1051 lineas |
| &nbsp;-- JSON | 88 lineas |
| &nbsp;-- YAML | 59 lineas |
| Coste generacion | $0.0677 |
| Tokens consumidos | 6182626 |

## Analisis estatico (semgrep)

**Total incidencias**: 0

**Comando**: `/home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/.venv/bin/semgrep --json --quiet --no-git-ignore --config=auto /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C1/n8n-31371/2026-07-21/193331/generated`

**Archivos escaneados**: 63
  - .md: 45 archivos
  - .json: 7 archivos
  - .sh: 5 archivos
  - .ts: 4 archivos
  - .yml: 1 archivos
  - .patch: 1 archivos
*(no se encontraron incidencias)*

### Linters por lenguaje

**shellcheck**: 12 incidencias en 5 archivos

**Comando**: `shellcheck --format=json /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C1/n8n-31371/2026-07-21/193331/generated/.specify/scripts/bash/check-prerequisites.sh`

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

**eslint**: 15 incidencias en 5 archivos

**Comando**: `/home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/node_modules/.bin/eslint --config /home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/.eslintrc.json --format json /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C1/n8n-31371/2026-07-21/193331/generated/packages/nodes-base/nodes/MongoDb/GenericFunctions.test.ts`

```
  L5:1 'n8n-workflow' import is duplicated. (no-duplicate-imports)
  L158:22 Expected { after 'if' condition. (curly)
  L159:29 Expected { after 'if' condition. (curly)
  L160:33 Expected { after 'if' condition. (curly)
  L161:33 Expected { after 'if' condition. (curly)
  L162:34 Expected { after 'if' condition. (curly)
  L163:33 Expected { after 'if' condition. (curly)
  L7:1 'mongodb' import is duplicated. (no-duplicate-imports)
  L9:1 'n8n-workflow' import is duplicated. (no-duplicate-imports)
  L534:25 Expected { after 'if' condition. (curly)
  L773:14 'name' is already a global variable. (no-shadow)
  L31:8 'test' is already a global variable. (no-shadow)
  L197:29 '_itemIndex' is assigned a value but never used. (@typescript-eslint/no-unused-vars)
  L383:31 '_itemIndex' is assigned a value but never used. (@typescript-eslint/no-unused-vars)
  L463:31 'itemIndex' is assigned a value but never used. (@typescript-eslint/no-unused-vars)
```

## Archivos fuente modificados

- `packages/nodes-base/nodes/MongoDb/GenericFunctions.test.ts`
- `packages/nodes-base/nodes/MongoDb/GenericFunctions.ts`
- `packages/nodes-base/nodes/MongoDb/MongoDb.node.ts`
- `packages/nodes-base/nodes/MongoDb/mongoDb.types.ts`
- `packages/nodes-base/nodes/MongoDb/test/MongoDB.test.ts`
- `specs/001-mongodb-updatekey-validation/checklists/requirements.md`
- `specs/001-mongodb-updatekey-validation/checklists/validation.md`
- `specs/001-mongodb-updatekey-validation/contracts/error-message.md`
- `specs/001-mongodb-updatekey-validation/contracts/operation-integration.md`
- `specs/001-mongodb-updatekey-validation/contracts/validation-function.md`
- `specs/001-mongodb-updatekey-validation/data-model.md`
- `specs/001-mongodb-updatekey-validation/plan.md`
- `specs/001-mongodb-updatekey-validation/quickstart.md`
- `specs/001-mongodb-updatekey-validation/research.md`
- `specs/001-mongodb-updatekey-validation/spec.md`
- `specs/001-mongodb-updatekey-validation/tasks.md`

... y 46 archivos de infraestructura (.specify, .github)
