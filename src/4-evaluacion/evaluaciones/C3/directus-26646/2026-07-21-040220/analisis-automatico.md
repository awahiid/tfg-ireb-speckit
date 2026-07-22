# C3 — directus-26646

**Ejecucion**: C3/directus-26646/2026-07-21/040220
**Analizado**: 2026-07-22 01:43

## Resultados de herramientas

| Herramienta | Resultado |
|-------------|-----------|
| Archivos modificados | 3 |
| Archivos fuente (sin infraestructura) | 3 |
| Lineas de codigo generadas (cloc) | 664 |
| &nbsp;-- Vuejs Component | 494 lineas |
| &nbsp;-- TypeScript | 151 lineas |
| &nbsp;-- JSON | 14 lineas |
| &nbsp;-- Markdown | 5 lineas |
| Coste generacion | $0.0104 |
| Tokens consumidos | 809667 |

## Analisis estatico (semgrep)

**Total incidencias**: 0

**Comando**: `/home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/.venv/bin/semgrep --json --quiet --no-git-ignore --config=auto /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C3/directus-26646/2026-07-21/040220/generated`

**Archivos escaneados**: 5
  - .ts: 2 archivos
  - .vue: 1 archivos
  - .md: 1 archivos
  - .json: 1 archivos
*(no se encontraron incidencias)*

### Linters por lenguaje

**eslint**: 14 incidencias en 3 archivos

**Comando**: `/home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/node_modules/.bin/eslint --config /home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/.eslintrc.json --format json /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C3/directus-26646/2026-07-21/040220/generated/api/src/services/server.ts`

```
  L2:10 'performance' is already a global variable. (no-shadow)
  L41:45 Unexpected any. Specify a different type. (@typescript-eslint/no-explicit-any)
  L42:30 Unexpected any. Specify a different type. (@typescript-eslint/no-explicit-any)
  L160:52 Expected { after 'if' condition. (curly)
  L165:41 Unexpected any. Specify a different type. (@typescript-eslint/no-explicit-any)
  L185:13 Unexpected any. Specify a different type. (@typescript-eslint/no-explicit-any)
  L228:33 Expected { after 'if' condition. (curly)
  L318:18 Unexpected any. Specify a different type. (@typescript-eslint/no-explicit-any)
  L358:18 Unexpected any. Specify a different type. (@typescript-eslint/no-explicit-any)
  L400:18 Unexpected any. Specify a different type. (@typescript-eslint/no-explicit-any)
  ... y 3 mas
  L1:8 Parsing error: '>' expected. (None)
```

## Archivos fuente modificados

- `api/src/services/server.ts`
- `app/src/components/v-upload.vue`
- `app/src/stores/server.ts`
