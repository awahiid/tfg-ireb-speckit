# C1 — appwrite-10832

**Ejecucion**: C1/appwrite-10832/2026-07-21/025946
**Analizado**: 2026-07-22 01:40

## Resultados de herramientas

| Herramienta | Resultado |
|-------------|-----------|
| Archivos modificados | 59 |
| Archivos fuente (sin infraestructura) | 13 |
| Lineas de codigo generadas (cloc) | 6383 |
| &nbsp;-- Markdown | 4145 lineas |
| &nbsp;-- PHP | 1058 lineas |
| &nbsp;-- Bourne Shell | 1019 lineas |
| &nbsp;-- JSON | 102 lineas |
| &nbsp;-- YAML | 59 lineas |
| Coste generacion | $0.0999 |
| Tokens consumidos | 10766195 |

## Analisis estatico (semgrep)

**Total incidencias**: 0

**Comando**: `/home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/.venv/bin/semgrep --json --quiet --no-git-ignore --config=auto /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C1/appwrite-10832/2026-07-21/025946/generated`

**Archivos escaneados**: 61
  - .md: 43 archivos
  - .json: 8 archivos
  - .sh: 5 archivos
  - .php: 4 archivos
  - .yml: 1 archivos
*(no se encontraron incidencias)*

### Linters por lenguaje

**shellcheck**: 12 incidencias en 5 archivos

**Comando**: `shellcheck --format=json /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C1/appwrite-10832/2026-07-21/025946/generated/.specify/scripts/bash/check-prerequisites.sh`

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

**phpcs**: 1597 incidencias en 4 archivos

**Comando**: `phpcs --standard=Generic --report=json --runtime-set ignore_warnings_on_exit 1 /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C1/appwrite-10832/2026-07-21/025946/generated/app/init/constants.php`

```
  constants.php:L1 E: The PHP open tag does not have a corresponding PHP close tag
  constants.php:L1 E: Missing required strict_types declaration
  constants.php:L5 W: Equals sign not aligned with surrounding assignments; expected 3 spaces but found 1 space
  constants.php:L8 W: Equals sign not aligned with surrounding assignments; expected 5 spaces but found 1 space
  constants.php:L12 W: Equals sign not aligned with surrounding assignments; expected 13 spaces but found 1 space
  constants.php:L13 W: Equals sign not aligned with surrounding assignments; expected 9 spaces but found 1 space
  constants.php:L14 W: Equals sign not aligned with surrounding assignments; expected 9 spaces but found 1 space
  constants.php:L15 W: Equals sign not aligned with surrounding assignments; expected 5 spaces but found 1 space
  constants.php:L16 W: Equals sign not aligned with surrounding assignments; expected 8 spaces but found 1 space
  constants.php:L17 W: Equals sign not aligned with surrounding assignments; expected 6 spaces but found 1 space
  ... y 331 mas
  DocumentListCache.php:L1 E: The PHP open tag does not have a corresponding PHP close tag
  DocumentListCache.php:L1 E: Missing required strict_types declaration
  DocumentListCache.php:L1 E: Filename "DocumentListCache.php" doesn't match the expected filename "documentlistcache.php"
  DocumentListCache.php:L11 E: Opening brace should be on the same line as the declaration for class DocumentListCache
  DocumentListCache.php:L12 E: Tabs must be used to indent lines; spaces are not allowed
  DocumentListCache.php:L13 E: Tabs must be used to indent lines; spaces are not allowed
  DocumentListCache.php:L14 E: Tabs must be used to indent lines; spaces are not allowed
  DocumentListCache.php:L16 E: Tabs must be used to indent lines; spaces are not allowed
  DocumentListCache.php:L17 E: Tabs must be used to indent lines; spaces are not allowed
  DocumentListCache.php:L18 E: Tabs must be used to indent lines; spaces are not allowed
  ... y 102 mas
  XList.php:L1 E: The PHP open tag does not have a corresponding PHP close tag
  XList.php:L1 E: Missing required strict_types declaration
  XList.php:L1 E: Filename "XList.php" doesn't match the expected filename "xlist.php"
  XList.php:L3 W: Line exceeds 80 characters; contains 83 characters
  XList.php:L33 E: Opening brace should be on the same line as the declaration for class XList
  XList.php:L34 E: Tabs must be used to indent lines; spaces are not allowed
  XList.php:L35 E: Tabs must be used to indent lines; spaces are not allowed
  XList.php:L35 E: Opening brace should be on the same line as the declaration
  XList.php:L36 E: Tabs must be used to indent lines; spaces are not allowed
  XList.php:L37 E: Tabs must be used to indent lines; spaces are not allowed
  ... y 224 mas
  Databases.php:L1 E: The PHP open tag does not have a corresponding PHP close tag
  Databases.php:L1 E: Missing required strict_types declaration
  Databases.php:L1 E: Filename "Databases.php" doesn't match the expected filename "databases.php"
  Databases.php:L25 E: Opening brace should be on the same line as the declaration for class Databases
  Databases.php:L26 E: Tabs must be used to indent lines; spaces are not allowed
  Databases.php:L26 E: TRUE, FALSE and NULL must be uppercase; expected "NULL" but found "null"
  Databases.php:L28 E: Tabs must be used to indent lines; spaces are not allowed
  Databases.php:L29 E: Tabs must be used to indent lines; spaces are not allowed
  Databases.php:L29 E: Opening brace should be on the same line as the declaration
  Databases.php:L30 E: Tabs must be used to indent lines; spaces are not allowed
  ... y 900 mas
```

## Archivos fuente modificados

- `app/init/constants.php`
- `specs/001-cached-document-lists/checklists/requirements.md`
- `specs/001-cached-document-lists/contracts/cache-class.md`
- `specs/001-cached-document-lists/contracts/documents-list-api.md`
- `specs/001-cached-document-lists/data-model.md`
- `specs/001-cached-document-lists/plan.md`
- `specs/001-cached-document-lists/quickstart.md`
- `specs/001-cached-document-lists/research.md`
- `specs/001-cached-document-lists/spec.md`
- `specs/001-cached-document-lists/tasks.md`
- `src/Appwrite/Cache/DocumentListCache.php`
- `src/Appwrite/Platform/Modules/Databases/Http/Databases/Collections/Documents/XList.php`
- `src/Appwrite/Platform/Modules/Databases/Workers/Databases.php`

... y 46 archivos de infraestructura (.specify, .github)
