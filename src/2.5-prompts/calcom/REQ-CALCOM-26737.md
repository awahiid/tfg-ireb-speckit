### REQ-CALCOM-26737 — Documentación del patrón de importación de API v2 en AGENTS.md

**MRS:**

> Como usuario del modulo de archivos,
quiero que el sistema incluya en el archivo `AGENTS.md` documentación sobre el patrón de importación correcto para la aplicación `apps/api/v2`. Específicamente, debe indicar que las importaciones de `@calcom/features` y `@calcom/trpc` no deben hacerse directamente debido a la falta de mapeos de rutas en el `tsconfig.json` de la API v2,
a traves de `AGENTS.md`,
para la API v2 carece de configuraciones de ruta para ciertos paquetes internos, lo que resulta en errores de "módulo no encontrado" durante la compilación o ejecución si se importan directamente.
Fuente: PR #26737
