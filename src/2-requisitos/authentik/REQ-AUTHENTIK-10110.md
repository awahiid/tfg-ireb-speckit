### ID

REQ-AUTHENTIK-10110

### Nombre

Corrección de esquema FIPS en API de sistema

### Tipo

Funcional

### Descripción formal

El sistema deberá exponer el estado de compatibilidad FIPS mediante el atributo `openssl_fips_enabled` en la API de información de runtime, manteniendo coherencia con el esquema OpenAPI y la interfaz de administración.

### Fuente

Pull Request #10110 ([https://github.com/goauthentik/authentik/pull/10110](https://github.com/goauthentik/authentik/pull/10110)), issue derivado implícitamente de cambios de esquema de sistema (sin issue explícito asociado en los datos proporcionados)

### Rationale

Evitar inconsistencias entre backend, esquema OpenAPI y frontend en la representación del estado FIPS, garantizando consistencia del contrato de datos del sistema.

### Prioridad

Media

### Verificación

Validación mediante consulta al endpoint de runtime verificando que la respuesta incluye `openssl_fips_enabled` y no contiene `openssl_fips_mode`; inspección del esquema OpenAPI y comprobación de la UI de administración.

### Estado

Borrador

### Versión

1.0
