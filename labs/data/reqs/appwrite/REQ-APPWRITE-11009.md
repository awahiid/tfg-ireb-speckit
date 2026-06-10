### ID

REQ-APPWRITE-11009

### Nombre

Duración configurable de tokens JWT

### Tipo

Funcional

### Descripción formal

El sistema deberá permitir especificar la duración de expiración de los tokens JWT en el momento de su creación, aceptando un valor de tiempo de vida personalizado que prevalezca sobre la duración por defecto del proyecto.

### Fuente

Release 1.9.0 (https://github.com/appwrite/appwrite/releases/tag/1.9.0), PR #11009 (https://github.com/appwrite/appwrite/pull/11009), entrada: "Custom JWT duration — Configure JWT expiration time when creating tokens".

### Rationale

Permitir a los clientes ajustar la duración de los tokens según sus requisitos de seguridad, reduciendo la ventana de exposición en contextos sensibles o ampliándola para sesiones de larga duración.

### Prioridad

Media

### Verificación

Crear un token JWT especificando una duración de N segundos, decodificar el token y verificar que el campo `exp` refleja una expiración N segundos posterior a la emisión del token.

### Estado

Borrador

### Versión

1.0
