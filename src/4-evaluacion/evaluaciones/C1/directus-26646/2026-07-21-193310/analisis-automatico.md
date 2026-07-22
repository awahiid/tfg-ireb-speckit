# C1 — directus-26646

**Ejecucion**: C1/directus-26646/2026-07-21/193310
**Analizado**: 2026-07-22 01:41

## Resultados de herramientas

| Herramienta | Resultado |
|-------------|-----------|
| Archivos modificados | 62 |
| Archivos fuente (sin infraestructura) | 16 |
| Lineas de codigo generadas (cloc) | 14175 |
| &nbsp;-- diff | 7287 lineas |
| &nbsp;-- Markdown | 3897 lineas |
| &nbsp;-- Vuejs Component | 1220 lineas |
| &nbsp;-- Bourne Shell | 1051 lineas |
| &nbsp;-- TypeScript | 551 lineas |
| &nbsp;-- JSON | 110 lineas |
| &nbsp;-- YAML | 59 lineas |
| Coste generacion | $0.0534 |
| Tokens consumidos | 3830953 |

## Analisis estatico (semgrep)

**Total incidencias**: 0

**Comando**: `/home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/.venv/bin/semgrep --json --quiet --no-git-ignore --config=auto /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C1/directus-26646/2026-07-21/193310/generated`

**Archivos escaneados**: 64
  - .md: 44 archivos
  - .json: 8 archivos
  - .sh: 5 archivos
  - .vue: 3 archivos
  - .ts: 2 archivos
  - .yml: 1 archivos
  - .patch: 1 archivos
*(no se encontraron incidencias)*

### Linters por lenguaje

**shellcheck**: 12 incidencias en 5 archivos

**Comando**: `shellcheck --format=json /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C1/directus-26646/2026-07-21/193310/generated/.specify/scripts/bash/check-prerequisites.sh`

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

**eslint**: 16 incidencias en 5 archivos

**Comando**: `/home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/node_modules/.bin/eslint --config /home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/.eslintrc.json --format json /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C1/directus-26646/2026-07-21/193310/generated/api/src/services/server.ts`

```
  L2:10 'performance' is already a global variable. (no-shadow)
  L41:45 Unexpected any. Specify a different type. (@typescript-eslint/no-explicit-any)
  L42:30 Unexpected any. Specify a different type. (@typescript-eslint/no-explicit-any)
  L153:52 Expected { after 'if' condition. (curly)
  L158:41 Unexpected any. Specify a different type. (@typescript-eslint/no-explicit-any)
  L178:13 Unexpected any. Specify a different type. (@typescript-eslint/no-explicit-any)
  L221:33 Expected { after 'if' condition. (curly)
  L311:18 Unexpected any. Specify a different type. (@typescript-eslint/no-explicit-any)
  L351:18 Unexpected any. Specify a different type. (@typescript-eslint/no-explicit-any)
  L393:18 Unexpected any. Specify a different type. (@typescript-eslint/no-explicit-any)
  ... y 3 mas
  L1:8 Parsing error: '>' expected. (None)
  L1:8 Parsing error: '>' expected. (None)
  L1:8 Parsing error: '>' expected. (None)
```

## Archivos fuente modificados

- `.vscode/settings.json`
- `api/src/services/server.ts`
- `app/src/interfaces/file-image/file-image.vue`
- `app/src/interfaces/file/file.vue`
- `app/src/interfaces/files/files.vue`
- `app/src/stores/server.ts`
- `specs/001-mime-type-upload-restriction/checklists/mime-restriction.md`
- `specs/001-mime-type-upload-restriction/checklists/requirements.md`
- `specs/001-mime-type-upload-restriction/contracts/api-server-info.md`
- `specs/001-mime-type-upload-restriction/contracts/component-v-upload.md`
- `specs/001-mime-type-upload-restriction/data-model.md`
- `specs/001-mime-type-upload-restriction/plan.md`
- `specs/001-mime-type-upload-restriction/quickstart.md`
- `specs/001-mime-type-upload-restriction/research.md`
- `specs/001-mime-type-upload-restriction/spec.md`
- `specs/001-mime-type-upload-restriction/tasks.md`

... y 46 archivos de infraestructura (.specify, .github)
