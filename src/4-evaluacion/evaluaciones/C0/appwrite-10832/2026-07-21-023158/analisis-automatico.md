# C0 — appwrite-10832

**Ejecucion**: C0/appwrite-10832/2026-07-21/023158
**Analizado**: 2026-07-22 01:39

## Resultados de herramientas

| Herramienta | Resultado |
|-------------|-----------|
| Archivos modificados | 55 |
| Archivos fuente (sin infraestructura) | 16 |
| Lineas de codigo generadas (cloc) | 14572 |
| &nbsp;-- PHP | 10676 lineas |
| &nbsp;-- Markdown | 2718 lineas |
| &nbsp;-- Bourne Shell | 1019 lineas |
| &nbsp;-- JSON | 100 lineas |
| &nbsp;-- YAML | 59 lineas |
| Coste generacion | $0.0677 |
| Tokens consumidos | 7314518 |

## Analisis estatico (semgrep)

**Total incidencias**: 0

**Comando**: `/home/awahiid/cloud/mega/proyectos/tfg/src/4-evaluacion/scripts/analisis-automatico/.venv/bin/semgrep --json --quiet --no-git-ignore --config=auto /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C0/appwrite-10832/2026-07-21/023158/generated`

**Archivos escaneados**: 56
  - .md: 35 archivos
  - .json: 8 archivos
  - .sh: 5 archivos
  - .php: 5 archivos
  - .dockerignore: 1 archivos
  - .gitignore: 1 archivos
  - .yml: 1 archivos
*(no se encontraron incidencias)*

### Linters por lenguaje

**shellcheck**: 12 incidencias en 5 archivos

**Comando**: `shellcheck --format=json /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C0/appwrite-10832/2026-07-21/023158/generated/.specify/scripts/bash/check-prerequisites.sh`

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

**phpcs**: 16009 incidencias en 6 archivos

**Comando**: `phpcs --standard=Generic --report=json --runtime-set ignore_warnings_on_exit 1 /home/awahiid/cloud/mega/proyectos/tfg/src/3-implementacion/resultados/C0/appwrite-10832/2026-07-21/023158/generated/src/Appwrite/Platform/Modules/Databases/Http/Databases/Collections/Documents/Create.php`

```
  Create.php:L1 E: The PHP open tag does not have a corresponding PHP close tag
  Create.php:L1 E: Missing required strict_types declaration
  Create.php:L1 E: Filename "Create.php" doesn't match the expected filename "create.php"
  Create.php:L3 W: Line exceeds 80 characters; contains 83 characters
  Create.php:L37 E: Opening brace should be on the same line as the declaration for class Create
  Create.php:L38 E: Tabs must be used to indent lines; spaces are not allowed
  Create.php:L39 E: Tabs must be used to indent lines; spaces are not allowed
  Create.php:L39 E: Opening brace should be on the same line as the declaration
  Create.php:L40 E: Tabs must be used to indent lines; spaces are not allowed
  Create.php:L41 E: Tabs must be used to indent lines; spaces are not allowed
  ... y 620 mas
  Delete.php:L1 E: The PHP open tag does not have a corresponding PHP close tag
  Delete.php:L1 E: Missing required strict_types declaration
  Delete.php:L1 E: Filename "Delete.php" doesn't match the expected filename "delete.php"
  Delete.php:L3 W: Line exceeds 80 characters; contains 83 characters
  Delete.php:L27 E: Opening brace should be on the same line as the declaration for class Delete
  Delete.php:L28 E: Tabs must be used to indent lines; spaces are not allowed
  Delete.php:L29 E: Tabs must be used to indent lines; spaces are not allowed
  Delete.php:L29 E: Opening brace should be on the same line as the declaration
  Delete.php:L30 E: Tabs must be used to indent lines; spaces are not allowed
  Delete.php:L31 E: Tabs must be used to indent lines; spaces are not allowed
  ... y 260 mas
  Update.php:L1 E: The PHP open tag does not have a corresponding PHP close tag
  Update.php:L1 E: Missing required strict_types declaration
  Update.php:L1 E: Filename "Update.php" doesn't match the expected filename "update.php"
  Update.php:L3 W: Line exceeds 80 characters; contains 83 characters
  Update.php:L33 E: Opening brace should be on the same line as the declaration for class Update
  Update.php:L34 E: Tabs must be used to indent lines; spaces are not allowed
  Update.php:L35 E: Tabs must be used to indent lines; spaces are not allowed
  Update.php:L35 E: Opening brace should be on the same line as the declaration
  Update.php:L36 E: Tabs must be used to indent lines; spaces are not allowed
  Update.php:L37 E: Tabs must be used to indent lines; spaces are not allowed
  ... y 413 mas
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
  ... y 280 mas
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
  ... y 67 mas
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
  ... y 14309 mas
```

## Archivos fuente modificados

- `.dockerignore`
- `.gitignore`
- `specs/000-feature/contracts/cache-key-contract.md`
- `specs/000-feature/contracts/listDocuments-api.md`
- `specs/000-feature/data-model.md`
- `specs/000-feature/plan.md`
- `specs/000-feature/quickstart.md`
- `specs/000-feature/research.md`
- `specs/000-feature/spec.md`
- `specs/000-feature/tasks.md`
- `src/Appwrite/Platform/Modules/Databases/Http/Databases/Collections/Documents/Create.php`
- `src/Appwrite/Platform/Modules/Databases/Http/Databases/Collections/Documents/Delete.php`
- `src/Appwrite/Platform/Modules/Databases/Http/Databases/Collections/Documents/Update.php`
- `src/Appwrite/Platform/Modules/Databases/Http/Databases/Collections/Documents/XList.php`
- `src/Appwrite/Platform/Modules/Databases/Http/TablesDB/Tables/Rows/XList.php`
- `tests/e2e/Services/Databases/DatabasesBase.php`

... y 39 archivos de infraestructura (.specify, .github)
