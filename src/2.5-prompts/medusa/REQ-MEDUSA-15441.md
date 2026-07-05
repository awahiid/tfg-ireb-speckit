### REQ-MEDUSA-15441 — Soporte de Multi-Factor Authentication (MFA) en el SDK JS

**MRS:**

> Como cliente de la API,
quiero que el sistema proporcione soporte para el manejo de Autenticación de Múltiples Factores (MFA) a través del SDK de JavaScript (`@medusajs/js-sdk`). El SDK deberá incorporar las siguientes capacidades: 1. **Gestión de factores MFA**: Proporcionar métodos bajo un objeto `mfa` para listar (`list`), iniciar la configuración (`start`), confirmar la configuración...,
a traves de `@medusajs/js-sdk`,
para antes de esta implementación, el SDK de JavaScript no ofrecía utilidades para gestionar la autenticación de múltiples factores (MFA), lo que dificultaba a las aplicaciones cliente soportar configuraciones de seguridad avanzadas.
Fuente: PR #15441

