# C1 — calcom-26812

**Ejecucion**: C1/calcom-26812/2026-07-21/051020
**Analizado**: 2026-07-22 01:40

## Resultados de herramientas

| Herramienta | Resultado |
|-------------|-----------|
| Archivos modificados | 57 |
| Archivos fuente (sin infraestructura) | 11 |
| Lineas de codigo generadas (cloc) | 5601 |
| &nbsp;-- Markdown | 3676 lineas |
| &nbsp;-- Bourne Shell | 1019 lineas |
| &nbsp;-- TypeScript | 712 lineas |
| &nbsp;-- JSON | 135 lineas |
| &nbsp;-- YAML | 59 lineas |
| Coste generacion | $0.0401 |
| Tokens consumidos | 2231291 |

## Analisis estatico (semgrep)

**Total incidencias**: 0

**Comando**: `/home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/.venv/bin/semgrep --json --quiet --no-git-ignore --config=auto /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C1/calcom-26812/2026-07-21/051020/generated`

**Archivos escaneados**: 59
  - .md: 42 archivos
  - .json: 9 archivos
  - .sh: 5 archivos
  - .ts: 2 archivos
  - .yml: 1 archivos
*(no se encontraron incidencias)*

### Linters por lenguaje

**shellcheck**: 12 incidencias en 5 archivos

**Comando**: `shellcheck --format=json /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C1/calcom-26812/2026-07-21/051020/generated/.specify/scripts/bash/check-prerequisites.sh`

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

**eslint**: 16 incidencias en 2 archivos

**Comando**: `/home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/node_modules/.bin/eslint --config /home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/.eslintrc.json --format json /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C1/calcom-26812/2026-07-21/051020/generated/apps/api/v2/src/ee/event-types/event-types_2024_06_14/services/output-event-types.service.spec.ts`

```
  L9:16 Expected { after 'if' condition. (curly)
  L22:36 Expected { after 'if' condition. (curly)
  L25:10 Unexpected any. Specify a different type. (@typescript-eslint/no-explicit-any)
  L24:3 'Team' is defined but never used. (@typescript-eslint/no-unused-vars)
  L145:7 'length' is already a global variable. (no-shadow)
  L302:22 Expected { after 'if' condition. (curly)
  L307:16 'location' is already a global variable. (no-shadow)
  L320:31 Expected { after 'if' condition. (curly)
  L329:25 Expected { after 'if' condition. (curly)
  L364:26 Expected { after 'if' condition. (curly)
  L366:32 Expected { after 'if' condition. (curly)
  L372:20 Expected { after 'if' condition. (curly)
  L403:25 Expected { after 'if' condition. (curly)
  ... y 3 mas
```

## Archivos fuente modificados

- `.vscode/settings.json`
- `apps/api/v2/src/ee/event-types/event-types_2024_06_14/services/output-event-types.service.spec.ts`
- `apps/api/v2/src/ee/event-types/event-types_2024_06_14/services/output-event-types.service.ts`
- `specs/001-fix-platform-booking-url/checklists/requirements.md`
- `specs/001-fix-platform-booking-url/contracts/README.md`
- `specs/001-fix-platform-booking-url/data-model.md`
- `specs/001-fix-platform-booking-url/plan.md`
- `specs/001-fix-platform-booking-url/quickstart.md`
- `specs/001-fix-platform-booking-url/research.md`
- `specs/001-fix-platform-booking-url/spec.md`
- `specs/001-fix-platform-booking-url/tasks.md`

... y 46 archivos de infraestructura (.specify, .github)
