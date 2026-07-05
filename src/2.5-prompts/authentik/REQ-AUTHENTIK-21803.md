### REQ-AUTHENTIK-21803 — Extracción de client_id mediante HTTP Basic Auth en Device Code

**MRS:**

> Como usuario autenticado,
quiero que el sistema permita la autenticación y extracción del parámetro `client_id` tanto desde el cuerpo de la petición POST como desde la cabecera HTTP `Authorization: Basic` (codificado en base64) durante el inicio del flujo Device Code OAuth2, utilizando la función unificada `extract_client_auth` en lugar de leer únicamente del cuerpo de la petición,
a traves de `client_id`,
para homogeneizar el comportamiento de la validación del identificador de cliente con el estándar OAuth2 y otros endpoints del sistema, permitiendo a dispositivos clientes enviar sus credenciales a través de la cabecera estándar de autorización en lugar de incluirlas forzosamente en el payload.
Fuente: PR #21803
