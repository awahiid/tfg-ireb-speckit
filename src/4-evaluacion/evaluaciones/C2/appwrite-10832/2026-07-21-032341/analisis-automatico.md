# C2 — appwrite-10832

**Ejecucion**: C2/appwrite-10832/2026-07-21/032341
**Analizado**: 2026-07-22 01:41

## Resultados de herramientas

| Herramienta | Resultado |
|-------------|-----------|
| Archivos modificados | 58 |
| Archivos fuente (sin infraestructura) | 12 |
| Lineas de codigo generadas (cloc) | 14784 |
| &nbsp;-- PHP | 9599 lineas |
| &nbsp;-- Markdown | 4005 lineas |
| &nbsp;-- Bourne Shell | 1019 lineas |
| &nbsp;-- JSON | 102 lineas |
| &nbsp;-- YAML | 59 lineas |
| Coste generacion | $0.0870 |
| Tokens consumidos | 6825840 |

## Analisis estatico (semgrep)

**Total incidencias**: 0

**Comando**: `/home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/.venv/bin/semgrep --json --quiet --no-git-ignore --config=auto /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C2/appwrite-10832/2026-07-21/032341/generated`

**Archivos escaneados**: 59
  - .md: 43 archivos
  - .json: 8 archivos
  - .sh: 5 archivos
  - .php: 2 archivos
  - .yml: 1 archivos
*(no se encontraron incidencias)*

### Linters por lenguaje

**shellcheck**: 12 incidencias en 5 archivos

**Comando**: `shellcheck --format=json /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C2/appwrite-10832/2026-07-21/032341/generated/.specify/scripts/bash/check-prerequisites.sh`

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

**phpcs**: 14577 incidencias en 3 archivos

**Comando**: `phpcs --standard=Generic --report=json --runtime-set ignore_warnings_on_exit 1 /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C2/appwrite-10832/2026-07-21/032341/generated/src/Appwrite/Platform/Modules/Databases/Http/Databases/Collections/Documents/XList.php`

```
  XList.php:L1 E: The PHP open tag does not have a corresponding PHP close tag
  XList.php:L1 E: Missing required strict_types declaration
  XList.php:L1 E: Filename "XList.php" doesn't match the expected filename "xlist.php"
  XList.php:L3 W: Line exceeds 80 characters; contains 83 characters
  XList.php:L31 E: Opening brace should be on the same line as the declaration for class XList
  XList.php:L32 E: Tabs must be used to indent lines; spaces are not allowed
  XList.php:L33 E: Tabs must be used to indent lines; spaces are not allowed
  XList.php:L33 E: Opening brace should be on the same line as the declaration
  XList.php:L34 E: Tabs must be used to indent lines; spaces are not allowed
  XList.php:L35 E: Tabs must be used to indent lines; spaces are not allowed
  ... y 252 mas
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
  DatabasesBase.php:L1 E: The PHP open tag does not have a corresponding PHP close tag
  DatabasesBase.php:L1 E: Missing required strict_types declaration
  DatabasesBase.php:L1 E: Filename "DatabasesBase.php" doesn't match the expected filename "databasesbase.php"
  DatabasesBase.php:L19 E: Trait names must be suffixed with "Trait"; found "DatabasesBase"
  DatabasesBase.php:L20 E: Opening brace should be on the same line as the declaration for trait DatabasesBase
  DatabasesBase.php:L21 E: Tabs must be used to indent lines; spaces are not allowed
  DatabasesBase.php:L22 E: Tabs must be used to indent lines; spaces are not allowed
  DatabasesBase.php:L24 E: Tabs must be used to indent lines; spaces are not allowed
  DatabasesBase.php:L25 E: Tabs must be used to indent lines; spaces are not allowed
  DatabasesBase.php:L25 W: Line exceeds 80 characters; contains 86 characters
  ... y 14227 mas
```

## Archivos fuente modificados

- `specs/001-cached-document-lists/checklists/requirements.md`
- `specs/001-cached-document-lists/contracts/README.md`
- `specs/001-cached-document-lists/contracts/scope-contract.md`
- `specs/001-cached-document-lists/data-model.md`
- `specs/001-cached-document-lists/plan.md`
- `specs/001-cached-document-lists/quickstart.md`
- `specs/001-cached-document-lists/research.md`
- `specs/001-cached-document-lists/spec.md`
- `specs/001-cached-document-lists/tasks.md`
- `src/Appwrite/Platform/Modules/Databases/Http/Databases/Collections/Documents/XList.php`
- `src/Appwrite/Platform/Modules/Databases/Http/TablesDB/Tables/Rows/XList.php`
- `tests/e2e/Services/Databases/DatabasesBase.php`

... y 46 archivos de infraestructura (.specify, .github)
