# C0 — medusa-13930

**Ejecucion**: C0/medusa-13930/2026-07-21/041640
**Analizado**: 2026-07-22 01:40

## Resultados de herramientas

| Herramienta | Resultado |
|-------------|-----------|
| Archivos modificados | 43 |
| Archivos fuente (sin infraestructura) | 1 |
| Lineas de codigo generadas (cloc) | 4402 |
| &nbsp;-- Markdown | 3171 lineas |
| &nbsp;-- Bourne Shell | 1019 lineas |
| &nbsp;-- JSON | 153 lineas |
| &nbsp;-- YAML | 59 lineas |
| Coste generacion | $0.0506 |
| Tokens consumidos | 4813009 |

## Analisis estatico (semgrep)

**Total incidencias**: 0

**Comando**: `/home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/.venv/bin/semgrep --json --quiet --no-git-ignore --config=auto /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C0/medusa-13930/2026-07-21/041640/generated`

**Archivos escaneados**: 45
  - .md: 30 archivos
  - .json: 9 archivos
  - .sh: 5 archivos
  - .yml: 1 archivos
*(no se encontraron incidencias)*

### Linters por lenguaje

**shellcheck**: 12 incidencias en 5 archivos

**Comando**: `shellcheck --format=json /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C0/medusa-13930/2026-07-21/041640/generated/.specify/scripts/bash/check-prerequisites.sh`

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

## Archivos fuente modificados

- `packages/modules/api-key/tsconfig.resolved.json`

... y 42 archivos de infraestructura (.specify, .github)
