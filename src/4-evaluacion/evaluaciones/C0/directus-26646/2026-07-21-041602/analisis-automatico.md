# C0 — directus-26646

**Ejecucion**: C0/directus-26646/2026-07-21/041602
**Analizado**: 2026-07-22 01:40

## Resultados de herramientas

| Herramienta | Resultado |
|-------------|-----------|
| Archivos modificados | 47 |
| Archivos fuente (sin infraestructura) | 8 |
| Lineas de codigo generadas (cloc) | 4851 |
| &nbsp;-- Markdown | 2388 lineas |
| &nbsp;-- Bourne Shell | 1019 lineas |
| &nbsp;-- TypeScript | 767 lineas |
| &nbsp;-- Vuejs Component | 496 lineas |
| &nbsp;-- JSON | 122 lineas |
| &nbsp;-- YAML | 59 lineas |
| Coste generacion | $0.0319 |
| Tokens consumidos | 2458386 |

## Analisis estatico (semgrep)

**Total incidencias**: 1

**Comando**: `/home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/.venv/bin/semgrep --json --quiet --no-git-ignore --config=auto /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C0/directus-26646/2026-07-21/041602/generated`

**Archivos escaneados**: 49
  - .md: 30 archivos
  - .json: 9 archivos
  - .sh: 5 archivos
  - .ts: 3 archivos
  - .yml: 1 archivos
  - .vue: 1 archivos
### 🔴 Errores criticos (bugs, seguridad): 0

### 🟡 Warnings (code smells, practicas): 1

```
  L275 [javascript.lang.security.audit.detect-non-literal-regexp.detect-non-literal-regexp] RegExp() called with a `name` function argument, this might allow an attacker to cause a Regular Expression Denial-of-Service (ReDoS) within your application as RegExP blocks the main thread. For this reason, it is recommended to use hardcoded regexes instead. If your regex is run on user-controlled input, consider performing input validation or use a regex checking/sanitization library such as https://www.npmjs.com/package/recheck to verify that the regex does not appear vulnerable to ReDoS.
```

### 🔵 Informacion/Estilo (formato, naming): 0

### Linters por lenguaje

**shellcheck**: 12 incidencias en 5 archivos

**Comando**: `shellcheck --format=json /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C0/directus-26646/2026-07-21/041602/generated/.specify/scripts/bash/check-prerequisites.sh`

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

**eslint**: 15 incidencias en 4 archivos

**Comando**: `/home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/node_modules/.bin/eslint --config /home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/.eslintrc.json --format json /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C0/directus-26646/2026-07-21/041602/generated/api/src/services/server.ts`

```
  L2:10 'performance' is already a global variable. (no-shadow)
  L41:45 Unexpected any. Specify a different type. (@typescript-eslint/no-explicit-any)
  L42:30 Unexpected any. Specify a different type. (@typescript-eslint/no-explicit-any)
  L155:52 Expected { after 'if' condition. (curly)
  L160:41 Unexpected any. Specify a different type. (@typescript-eslint/no-explicit-any)
  L180:13 Unexpected any. Specify a different type. (@typescript-eslint/no-explicit-any)
  L223:33 Expected { after 'if' condition. (curly)
  L313:18 Unexpected any. Specify a different type. (@typescript-eslint/no-explicit-any)
  L353:18 Unexpected any. Specify a different type. (@typescript-eslint/no-explicit-any)
  L395:18 Unexpected any. Specify a different type. (@typescript-eslint/no-explicit-any)
  ... y 3 mas
  L1:8 Parsing error: '>' expected. (None)
  L275:65 'name' is already a global variable. (no-shadow)
```

## Archivos fuente modificados

- `.vscode/settings.json`
- `api/src/services/server.ts`
- `app/src/components/v-upload.vue`
- `app/src/stores/server.ts`
- `packages/env/src/constants/directus-variables.ts`
- `specs/plan.md`
- `specs/spec.md`
- `specs/tasks.md`

... y 39 archivos de infraestructura (.specify, .github)
