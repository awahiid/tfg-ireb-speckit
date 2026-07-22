# C3 — appwrite-10832

**Ejecucion**: C3/appwrite-10832/2026-07-21/022028
**Analizado**: 2026-07-22 01:43

## Resultados de herramientas

| Herramienta | Resultado |
|-------------|-----------|
| Archivos modificados | 2 |
| Archivos fuente (sin infraestructura) | 2 |
| Lineas de codigo generadas (cloc) | 264 |
| &nbsp;-- PHP | 247 lineas |
| &nbsp;-- JSON | 13 lineas |
| &nbsp;-- Markdown | 4 lineas |
| Coste generacion | $0.0210 |
| Tokens consumidos | 1661299 |

## Analisis estatico (semgrep)

**Total incidencias**: 0

**Comando**: `/home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/.venv/bin/semgrep --json --quiet --no-git-ignore --config=auto /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C3/appwrite-10832/2026-07-21/022028/generated`

**Archivos escaneados**: 4
  - .php: 2 archivos
  - .md: 1 archivos
  - .json: 1 archivos
*(no se encontraron incidencias)*

### Linters por lenguaje

**phpcs**: 326 incidencias en 2 archivos

**Comando**: `phpcs --standard=Generic --report=json --runtime-set ignore_warnings_on_exit 1 /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C3/appwrite-10832/2026-07-21/022028/generated/src/Appwrite/Platform/Modules/Databases/Http/Databases/Collections/Documents/XList.php`

```
  XList.php:L1 E: The PHP open tag does not have a corresponding PHP close tag
  XList.php:L1 E: Missing required strict_types declaration
  XList.php:L1 E: Filename "XList.php" doesn't match the expected filename "xlist.php"
  XList.php:L3 W: Line exceeds 80 characters; contains 83 characters
  XList.php:L32 E: Opening brace should be on the same line as the declaration for class XList
  XList.php:L33 E: Tabs must be used to indent lines; spaces are not allowed
  XList.php:L34 E: Tabs must be used to indent lines; spaces are not allowed
  XList.php:L34 E: Opening brace should be on the same line as the declaration
  XList.php:L35 E: Tabs must be used to indent lines; spaces are not allowed
  XList.php:L36 E: Tabs must be used to indent lines; spaces are not allowed
  ... y 238 mas
  XList.php:L1 E: The PHP open tag does not have a corresponding PHP close tag
  XList.php:L1 E: Missing required strict_types declaration
  XList.php:L1 E: Filename "XList.php" doesn't match the expected filename "xlist.php"
  XList.php:L5 W: Line exceeds 80 characters; contains 100 characters
  XList.php:L21 E: Opening brace should be on the same line as the declaration for class XList
  XList.php:L22 E: Tabs must be used to indent lines; spaces are not allowed
  XList.php:L23 E: Tabs must be used to indent lines; spaces are not allowed
  XList.php:L23 E: Opening brace should be on the same line as the declaration
  XList.php:L24 E: Tabs must be used to indent lines; spaces are not allowed
  XList.php:L25 E: Tabs must be used to indent lines; spaces are not allowed
  ... y 68 mas
```

## Archivos fuente modificados

- `src/Appwrite/Platform/Modules/Databases/Http/Databases/Collections/Documents/XList.php`
- `src/Appwrite/Platform/Modules/Databases/Http/TablesDB/Tables/Rows/XList.php`
