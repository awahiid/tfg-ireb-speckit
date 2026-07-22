# C3 — n8n-31371

**Ejecucion**: C3/n8n-31371/2026-07-21/040320
**Analizado**: 2026-07-22 01:44

## Resultados de herramientas

| Herramienta | Resultado |
|-------------|-----------|
| Archivos modificados | 1 |
| Archivos fuente (sin infraestructura) | 1 |
| Lineas de codigo generadas (cloc) | 863 |
| &nbsp;-- TypeScript | 844 lineas |
| &nbsp;-- JSON | 14 lineas |
| &nbsp;-- Markdown | 5 lineas |
| Coste generacion | $0.0208 |
| Tokens consumidos | 2267397 |

## Analisis estatico (semgrep)

**Total incidencias**: 0

**Comando**: `/home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/.venv/bin/semgrep --json --quiet --no-git-ignore --config=auto /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C3/n8n-31371/2026-07-21/040320/generated`

**Archivos escaneados**: 3
  - .md: 1 archivos
  - .ts: 1 archivos
  - .json: 1 archivos
*(no se encontraron incidencias)*

### Linters por lenguaje

**eslint**: 4 incidencias en 1 archivos

**Comando**: `/home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/node_modules/.bin/eslint --config /home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/.eslintrc.json --format json /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C3/n8n-31371/2026-07-21/040320/generated/packages/nodes-base/nodes/MongoDb/MongoDb.node.ts`

```
  L7:1 'mongodb' import is duplicated. (no-duplicate-imports)
  L9:1 'n8n-workflow' import is duplicated. (no-duplicate-imports)
  L565:25 Expected { after 'if' condition. (curly)
  L820:14 'name' is already a global variable. (no-shadow)
```

## Archivos fuente modificados

- `packages/nodes-base/nodes/MongoDb/MongoDb.node.ts`
