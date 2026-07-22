# C2 — directus-26646

**Ejecucion**: C2/directus-26646/2026-07-21/193452
**Analizado**: 2026-07-22 01:42

## Resultados de herramientas

| Herramienta | Resultado |
|-------------|-----------|
| Archivos modificados | 65 |
| Archivos fuente (sin infraestructura) | 19 |
| Lineas de codigo generadas (cloc) | 15200 |
| &nbsp;-- diff | 8144 lineas |
| &nbsp;-- Markdown | 4300 lineas |
| &nbsp;-- Bourne Shell | 1051 lineas |
| &nbsp;-- TypeScript | 1040 lineas |
| &nbsp;-- Vuejs Component | 502 lineas |
| &nbsp;-- JSON | 104 lineas |
| &nbsp;-- YAML | 59 lineas |
| Coste generacion | $0.0710 |
| Tokens consumidos | 5966230 |

## Analisis estatico (semgrep)

**Total incidencias**: 0

**Comando**: `/home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/.venv/bin/semgrep --json --quiet --no-git-ignore --config=auto /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C2/directus-26646/2026-07-21/193452/generated`

**Archivos escaneados**: 67
  - .md: 45 archivos
  - .json: 8 archivos
  - .ts: 6 archivos
  - .sh: 5 archivos
  - .yml: 1 archivos
  - .vue: 1 archivos
  - .patch: 1 archivos
*(no se encontraron incidencias)*

### Linters por lenguaje

**shellcheck**: 12 incidencias en 5 archivos

**Comando**: `shellcheck --format=json /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C2/directus-26646/2026-07-21/193452/generated/.specify/scripts/bash/check-prerequisites.sh`

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

**eslint**: 42 incidencias en 7 archivos

**Comando**: `/home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/node_modules/.bin/eslint --config /home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/.eslintrc.json --format json /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C2/directus-26646/2026-07-21/193452/generated/api/src/services/server.test.ts`

```
  L2:10 'describe' is already a global variable. (no-shadow)
  L2:20 'expect' is already a global variable. (no-shadow)
  L2:28 'test' is already a global variable. (no-shadow)
  L46:40 Unexpected any. Specify a different type. (@typescript-eslint/no-explicit-any)
  L48:21 Unexpected any. Specify a different type. (@typescript-eslint/no-explicit-any)
  L49:25 Unexpected any. Specify a different type. (@typescript-eslint/no-explicit-any)
  L60:7 Unexpected any. Specify a different type. (@typescript-eslint/no-explicit-any)
  L77:8 Unexpected any. Specify a different type. (@typescript-eslint/no-explicit-any)
  L96:8 Unexpected any. Specify a different type. (@typescript-eslint/no-explicit-any)
  L2:10 'performance' is already a global variable. (no-shadow)
  L41:45 Unexpected any. Specify a different type. (@typescript-eslint/no-explicit-any)
  L42:30 Unexpected any. Specify a different type. (@typescript-eslint/no-explicit-any)
  L152:52 Expected { after 'if' condition. (curly)
  L157:41 Unexpected any. Specify a different type. (@typescript-eslint/no-explicit-any)
  L177:13 Unexpected any. Specify a different type. (@typescript-eslint/no-explicit-any)
  L220:33 Expected { after 'if' condition. (curly)
  L310:18 Unexpected any. Specify a different type. (@typescript-eslint/no-explicit-any)
  L350:18 Unexpected any. Specify a different type. (@typescript-eslint/no-explicit-any)
  L392:18 Unexpected any. Specify a different type. (@typescript-eslint/no-explicit-any)
  ... y 3 mas
  L3:10 'afterEach' is already a global variable. (no-shadow)
  L3:21 'beforeEach' is already a global variable. (no-shadow)
  L3:33 'describe' is already a global variable. (no-shadow)
  L3:43 'expect' is already a global variable. (no-shadow)
  L3:51 'it' is already a global variable. (no-shadow)
  L30:11 Expected { after 'if' condition. (curly)
  L36:7 'global' is already a global variable. (no-shadow)
  L1:8 Parsing error: '>' expected. (None)
  L3:10 'afterEach' is already a global variable. (no-shadow)
  L3:21 'beforeEach' is already a global variable. (no-shadow)
  L3:33 'describe' is already a global variable. (no-shadow)
  L3:43 'expect' is already a global variable. (no-shadow)
  L3:70 'test' is already a global variable. (no-shadow)
  L74:4 Unnecessary return statement. (no-useless-return)
  L100:4 Unnecessary return statement. (no-useless-return)
  L125:4 Unnecessary return statement. (no-useless-return)
  L155:4 Unnecessary return statement. (no-useless-return)
  L179:4 Unnecessary return statement. (no-useless-return)
  ... y 2 mas
```

## Archivos fuente modificados

- `.vscode/settings.json`
- `api/src/services/server.test.ts`
- `api/src/services/server.ts`
- `app/src/components/v-upload.test.ts`
- `app/src/components/v-upload.vue`
- `app/src/stores/server.test.ts`
- `app/src/stores/server.ts`
- `sdk/src/rest/commands/server/info.ts`
- `specs/001-mime-type-upload-restriction/checklists/mime-restriction.md`
- `specs/001-mime-type-upload-restriction/checklists/requirements.md`
- `specs/001-mime-type-upload-restriction/contracts/server-info.md`
- `specs/001-mime-type-upload-restriction/contracts/v-upload-accept.md`
- `specs/001-mime-type-upload-restriction/data-model.md`
- `specs/001-mime-type-upload-restriction/plan.md`
- `specs/001-mime-type-upload-restriction/quickstart.md`
- `specs/001-mime-type-upload-restriction/research.md`
- `specs/001-mime-type-upload-restriction/scope-contract.md`
- `specs/001-mime-type-upload-restriction/spec.md`
- `specs/001-mime-type-upload-restriction/tasks.md`

... y 46 archivos de infraestructura (.specify, .github)
