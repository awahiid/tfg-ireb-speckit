# C2 — calcom-26812

**Ejecucion**: C2/calcom-26812/2026-07-21/193424
**Analizado**: 2026-07-22 01:42

## Resultados de herramientas

| Herramienta | Resultado |
|-------------|-----------|
| Archivos modificados | 89 |
| Archivos fuente (sin infraestructura) | 43 |
| Lineas de codigo generadas (cloc) | 18953 |
| &nbsp;-- diff | 8037 lineas |
| &nbsp;-- TypeScript | 5818 lineas |
| &nbsp;-- Markdown | 3867 lineas |
| &nbsp;-- Bourne Shell | 1051 lineas |
| &nbsp;-- JSON | 121 lineas |
| &nbsp;-- YAML | 59 lineas |
| Coste generacion | $0.0621 |
| Tokens consumidos | 5294683 |

## Analisis estatico (semgrep)

**Total incidencias**: 0

**Comando**: `/home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/.venv/bin/semgrep --json --quiet --no-git-ignore --config=auto /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C2/calcom-26812/2026-07-21/193424/generated`

**Archivos escaneados**: 91
  - .md: 43 archivos
  - .ts: 33 archivos
  - .json: 8 archivos
  - .sh: 5 archivos
  - .yml: 1 archivos
  - .patch: 1 archivos
*(no se encontraron incidencias)*

### Linters por lenguaje

**shellcheck**: 12 incidencias en 5 archivos

**Comando**: `shellcheck --format=json /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C2/calcom-26812/2026-07-21/193424/generated/.specify/scripts/bash/check-prerequisites.sh`

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

**eslint**: 38 incidencias en 33 archivos

**Comando**: `/home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/node_modules/.bin/eslint --config /home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/.eslintrc.json --format json /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C2/calcom-26812/2026-07-21/193424/generated/apps/api/v2/src/ee/event-types/event-types_2024_06_14/controllers/event-types.controller.ts`

```
  L37:1 '@/ee/event-types/event-types_2024_06_14/services/output-event-types.service' import is duplicated. (no-duplicate-imports)
  L50:10 'Permissions' is already a global variable. (no-shadow)
  L47:34 '_destinationCalendar' is assigned a value but never used. (@typescript-eslint/no-unused-vars)
  L217:42 Unexpected block statement surrounding arrow body; parenthesize the returned value and move it immediately after the `=>`. (arrow-body-style)
  L225:42 Unexpected block statement surrounding arrow body; parenthesize the returned value and move it immediately after the `=>`. (arrow-body-style)
  L405:19 Expected { after 'if' condition. (curly)
  L477:21 Expected { after 'if' condition. (curly)
  L482:16 'location' is already a global variable. (no-shadow)
  L523:5 Unnecessary return statement. (no-useless-return)
  L548:5 Unnecessary return statement. (no-useless-return)
  L564:5 Unnecessary return statement. (no-useless-return)
  L572:34 'location' is already a global variable. (no-shadow)
  L8:16 Expected { after 'if' condition. (curly)
  L21:36 Expected { after 'if' condition. (curly)
  L24:10 Unexpected any. Specify a different type. (@typescript-eslint/no-explicit-any)
  L24:3 'Team' is defined but never used. (@typescript-eslint/no-unused-vars)
  L148:7 'length' is already a global variable. (no-shadow)
  L305:22 Expected { after 'if' condition. (curly)
  L310:16 'location' is already a global variable. (no-shadow)
  L323:31 Expected { after 'if' condition. (curly)
  L332:25 Expected { after 'if' condition. (curly)
  L367:26 Expected { after 'if' condition. (curly)
  L369:32 Expected { after 'if' condition. (curly)
  L375:20 Expected { after 'if' condition. (curly)
  L406:25 Expected { after 'if' condition. (curly)
  ... y 3 mas
  L116:8 'field' is already declared in the upper scope on line 53 column 28. (no-shadow)
  L119:8 'field' is already declared in the upper scope on line 53 column 28. (no-shadow)
  L11:33 Expected { after 'if' condition. (curly)
  L19:3 Expected a default case. (default-case)
  L15:3 Expected an assignment or function call and instead saw an expression. (no-unused-expressions)
  L46:64 'location' is already a global variable. (no-shadow)
  L89:24 Expected { after 'if' condition. (curly)
  L91:30 'location' is already a global variable. (no-shadow)
  L11:5 Expected { after 'if' condition. (curly)
  L56:14 'location' is already a global variable. (no-shadow)
```

## Archivos fuente modificados

- `.vscode/settings.json`
- `apps/api/v2/src/ee/event-types/event-types_2024_06_14/controllers/event-types.controller.ts`
- `apps/api/v2/src/ee/event-types/event-types_2024_06_14/event-types.module.ts`
- `apps/api/v2/src/ee/event-types/event-types_2024_06_14/event-types.repository.ts`
- `apps/api/v2/src/ee/event-types/event-types_2024_06_14/inputs/create-phone-call.input.ts`
- `apps/api/v2/src/ee/event-types/event-types_2024_06_14/outputs/create-event-type.output.ts`
- `apps/api/v2/src/ee/event-types/event-types_2024_06_14/outputs/create-phone-call.output.ts`
- `apps/api/v2/src/ee/event-types/event-types_2024_06_14/outputs/delete-event-type.output.ts`
- `apps/api/v2/src/ee/event-types/event-types_2024_06_14/outputs/get-event-type.output.ts`
- `apps/api/v2/src/ee/event-types/event-types_2024_06_14/outputs/get-event-types.output.ts`
- `apps/api/v2/src/ee/event-types/event-types_2024_06_14/outputs/update-event-type.output.ts`
- `apps/api/v2/src/ee/event-types/event-types_2024_06_14/pipes/event-type-response.transformer.ts`
- `apps/api/v2/src/ee/event-types/event-types_2024_06_14/services/event-types.service.ts`
- `apps/api/v2/src/ee/event-types/event-types_2024_06_14/services/input-event-types.service.ts`
- `apps/api/v2/src/ee/event-types/event-types_2024_06_14/services/output-event-types.service.spec.ts`
- `apps/api/v2/src/ee/event-types/event-types_2024_06_14/services/output-event-types.service.ts`
- `apps/api/v2/src/ee/event-types/event-types_2024_06_14/transformed/event-type.tranformed.ts`
- `apps/api/v2/src/ee/event-types/event-types_2024_06_14/transformers/api-to-internal/api-to-internal.spec.ts`
- `apps/api/v2/src/ee/event-types/event-types_2024_06_14/transformers/api-to-internal/booking-fields.ts`
- `apps/api/v2/src/ee/event-types/event-types_2024_06_14/transformers/api-to-internal/confirmation-policy.ts`
- `apps/api/v2/src/ee/event-types/event-types_2024_06_14/transformers/api-to-internal/future-booking-limits.ts`
- `apps/api/v2/src/ee/event-types/event-types_2024_06_14/transformers/api-to-internal/index.ts`
- `apps/api/v2/src/ee/event-types/event-types_2024_06_14/transformers/api-to-internal/interval-limits.ts`
- `apps/api/v2/src/ee/event-types/event-types_2024_06_14/transformers/api-to-internal/locations.ts`
- `apps/api/v2/src/ee/event-types/event-types_2024_06_14/transformers/api-to-internal/seats.ts`
- `apps/api/v2/src/ee/event-types/event-types_2024_06_14/transformers/index.ts`
- `apps/api/v2/src/ee/event-types/event-types_2024_06_14/transformers/internal-to-api/booking-fields.ts`
- `apps/api/v2/src/ee/event-types/event-types_2024_06_14/transformers/internal-to-api/event-type-colors.ts`
- `apps/api/v2/src/ee/event-types/event-types_2024_06_14/transformers/internal-to-api/future-booking-limits.ts`
- `apps/api/v2/src/ee/event-types/event-types_2024_06_14/transformers/internal-to-api/index.ts`
- `apps/api/v2/src/ee/event-types/event-types_2024_06_14/transformers/internal-to-api/internal-to-api.spec.ts`
- `apps/api/v2/src/ee/event-types/event-types_2024_06_14/transformers/internal-to-api/locations.ts`
- `apps/api/v2/src/ee/event-types/event-types_2024_06_14/transformers/internal-to-api/requires-confirmation.ts`
- `apps/api/v2/src/ee/event-types/event-types_2024_06_14/transformers/internal-to-api/seats.ts`
- `specs/001-fix-platform-booking-url/checklists/requirements.md`
- `specs/001-fix-platform-booking-url/checklists/url-generation.md`
- `specs/001-fix-platform-booking-url/contracts/event-types-api-v2.md`
- `specs/001-fix-platform-booking-url/data-model.md`
- `specs/001-fix-platform-booking-url/plan.md`
- `specs/001-fix-platform-booking-url/quickstart.md`
- `specs/001-fix-platform-booking-url/research.md`
- `specs/001-fix-platform-booking-url/spec.md`
- `specs/001-fix-platform-booking-url/tasks.md`

... y 46 archivos de infraestructura (.specify, .github)
