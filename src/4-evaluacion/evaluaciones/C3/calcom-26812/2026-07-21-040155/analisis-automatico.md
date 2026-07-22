# C3 — calcom-26812

**Ejecucion**: C3/calcom-26812/2026-07-21/040155
**Analizado**: 2026-07-22 01:43

## Resultados de herramientas

| Herramienta | Resultado |
|-------------|-----------|
| Archivos modificados | 2 |
| Archivos fuente (sin infraestructura) | 2 |
| Lineas de codigo generadas (cloc) | 706 |
| &nbsp;-- TypeScript | 687 lineas |
| &nbsp;-- JSON | 14 lineas |
| &nbsp;-- Markdown | 5 lineas |
| Coste generacion | $0.0071 |
| Tokens consumidos | 457887 |

## Analisis estatico (semgrep)

**Total incidencias**: 0

**Comando**: `/home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/.venv/bin/semgrep --json --quiet --no-git-ignore --config=auto /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C3/calcom-26812/2026-07-21/040155/generated`

**Archivos escaneados**: 4
  - .ts: 2 archivos
  - .md: 1 archivos
  - .json: 1 archivos
*(no se encontraron incidencias)*

### Linters por lenguaje

**eslint**: 16 incidencias en 2 archivos

**Comando**: `/home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/node_modules/.bin/eslint --config /home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/.eslintrc.json --format json /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C3/calcom-26812/2026-07-21/040155/generated/apps/api/v2/src/ee/event-types/event-types_2024_06_14/services/output-event-types.service.spec.ts`

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

- `apps/api/v2/src/ee/event-types/event-types_2024_06_14/services/output-event-types.service.spec.ts`
- `apps/api/v2/src/ee/event-types/event-types_2024_06_14/services/output-event-types.service.ts`
