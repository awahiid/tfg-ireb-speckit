### ID

REQ-CALCOM-26737

### Nombre

Documentación del patrón de importación de API v2 en AGENTS.md

### Tipo

No funcional (Documentación)

### Descripción formal

El sistema debe incluir en el archivo `AGENTS.md` documentación sobre el patrón de importación correcto para la aplicación `apps/api/v2`. Específicamente, debe indicar que las importaciones de `@calcom/features` y `@calcom/trpc` no deben hacerse directamente debido a la falta de mapeos de rutas en el `tsconfig.json` de la API v2. En su lugar, se debe instruir a los desarrolladores a reexportar los módulos necesarios desde `packages/platform/libraries/index.ts` y luego importarlos utilizando `@calcom/platform-libraries`.

### Fuente

Pull Request #26737 (https://github.com/calcom/cal.com/pull/26737)

### Rationale

La API v2 carece de configuraciones de ruta para ciertos paquetes internos, lo que resulta en errores de "módulo no encontrado" durante la compilación o ejecución si se importan directamente. Al documentar el patrón de reexportación e importación a través de `@calcom/platform-libraries`, se guía a los desarrolladores (y a los agentes de IA) para evitar este problema, manteniendo la coherencia y el funcionamiento correcto del código.

### Prioridad

Baja

### Verificación

1.  Abrir el archivo `AGENTS.md`.
2.  Verificar que existe una sección titulada "API v2 Imports (apps/api/v2)" o similar.
3.  Verificar que la sección explica el problema con las importaciones directas de `@calcom/features` y `@calcom/trpc`.
4.  Verificar que la sección proporciona un ejemplo de cómo reexportar desde `packages/platform/libraries/index.ts` y cómo importar desde `@calcom/platform-libraries`.

### Estado

Borrador

### Versión

1.0
