### ID

REQ-AUTHENTIK-22503

### Nombre

Resolución de versión en estado de Outpost

### Tipo

Funcional

### Descripción formal

El sistema deberá reportar el atributo `version_should` de un Outpost evaluando dinámicamente el valor actual del módulo en tiempo de respuesta del endpoint de salud (`health`), en lugar de almacenar la versión estáticamente en la instancia de la clase `OutpostState` durante su inicialización.

### Fuente

Pull Request #22503 (https://github.com/goauthentik/authentik/pull/22503) y PR original #22487.

### Rationale

Evitar la persistencia de una versión obsoleta en el estado de los outposts si no se reinicia el worker de la API tras una actualización de la aplicación, garantizando que el dashboard siempre muestre y compare contra la versión correcta real (OUR_VERSION) del servidor en ejecución.

### Prioridad

Media

### Verificación

Validación mediante prueba de integración que consulte el endpoint de health (`/api/v3/outposts/instances/{pk}/health/`) y verifique que `version_should` coincide con `OUR_VERSION` en tiempo real, validando que el campo fue removido del modelo de datos `OutpostState`.

### Estado

Borrador

### Versión

1.0