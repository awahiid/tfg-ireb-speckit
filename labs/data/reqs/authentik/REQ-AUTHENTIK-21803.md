### ID

REQ-AUTHENTIK-21803

### Nombre

Extracción de client_id mediante HTTP Basic Auth en Device Code

### Tipo

Funcional

### Descripción formal

El sistema deberá permitir la autenticación y extracción del parámetro `client_id` tanto desde el cuerpo de la petición POST como desde la cabecera HTTP `Authorization: Basic` (codificado en base64) durante el inicio del flujo Device Code OAuth2, utilizando la función unificada `extract_client_auth` en lugar de leer únicamente del cuerpo de la petición.

### Fuente

Pull Request #21803 (https://github.com/goauthentik/authentik/pull/21803) y PR original #20457.

### Rationale

Homogeneizar el comportamiento de la validación del identificador de cliente con el estándar OAuth2 y otros endpoints del sistema, permitiendo a dispositivos clientes enviar sus credenciales a través de la cabecera estándar de autorización en lugar de incluirlas forzosamente en el payload.

### Prioridad

Media

### Verificación

Validación mediante ejecución de tests unitarios (`test_backchannel_client_id_via_auth_header`), realizando peticiones POST al endpoint de inicialización del dispositivo enviando el `client_id` codificado junto con un secreto vacío (`client_id:`) dentro del encabezado `Authorization: Basic` y verificando que la respuesta es un HTTP 200 OK con un JSON conteniendo `expires_in`.

### Estado

Borrador

### Versión

1.0