### ID

REQ-MEDUSA-15441

### Nombre

Soporte de Multi-Factor Authentication (MFA) en el SDK JS

### Tipo

Funcional

### Descripción formal

El sistema deberá proporcionar soporte para el manejo de Autenticación de Múltiples Factores (MFA) a través del SDK de JavaScript (`@medusajs/js-sdk`). El SDK deberá incorporar las siguientes capacidades:

1.  **Gestión de factores MFA**: Proporcionar métodos bajo un objeto `mfa` para listar (`list`), iniciar la configuración (`start`), confirmar la configuración (`verify`), deshabilitar un factor (`disable`) y generar códigos de recuperación (`generateRecoveryCodes`).
2.  **Verificación de desafío**: Proporcionar un método `verifyChallenge` para resolver un desafío MFA, el cual, en caso de éxito, devolverá y almacenará localmente el token de autenticación.
3.  **Flujos de inicio de sesión y callbacks**: Los métodos existentes de autenticación (`login` y `callback`) deberán procesar las respuestas que requieran MFA. Si el servidor exige MFA, el SDK deberá devolver un objeto indicando `mfa_required: true` junto con la información del desafío (`mfa_challenge`), sin llegar a almacenar ningún token de sesión en ese momento.

### Fuente

Pull Request #15441 (https://github.com/medusajs/medusa/pull/15441)

### Rationale

Antes de esta implementación, el SDK de JavaScript no ofrecía utilidades para gestionar la autenticación de múltiples factores (MFA), lo que dificultaba a las aplicaciones cliente soportar configuraciones de seguridad avanzadas. Al añadir estas funciones, los clientes pueden construir flujos nativos donde los usuarios configuran y usan MFA, incrementando así la seguridad general del sistema.

### Prioridad

Alta

### Verificación

1.  **Inicio de sesión con MFA requerido**:
    a. Llamar a `sdk.auth.login` con credenciales válidas de un usuario que posea MFA habilitado y activo.
    b. Verificar que la función devuelve un objeto con `mfa_required: true` y los datos del `mfa_challenge`, en lugar de devolver directamente el token.
    c. Comprobar que no se almacena ningún token en el sistema de almacenamiento del SDK durante este paso.

2.  **Verificación de desafío exitoso**:
    a. Utilizar el ID del desafío del paso anterior y llamar a `sdk.auth.mfa.verifyChallenge` pasando el código correcto del segundo factor.
    b. Verificar que el método devuelve el token de sesión.
    c. Confirmar que el token de sesión queda correctamente almacenado en el cliente para futuras peticiones.

3.  **Configuración de factores MFA**:
    a. Estando autenticado, llamar a `sdk.auth.mfa.start` para iniciar la configuración de un nuevo factor (ej. TOTP).
    b. Usar la respuesta (secret/URL) para obtener un código, y enviarlo a través de `sdk.auth.mfa.verify`.
    c. Confirmar que la verificación fue exitosa y que el factor queda habilitado en la cuenta del usuario llamando a `sdk.auth.mfa.list`.

### Estado

Borrador

### Versión

1.0
