### ID

REQ-AUTHENTIK-10124

### Nombre

Actualización de reputación concurrente

### Tipo

Funcional

### Descripción formal

El sistema deberá actualizar el valor de reputación asociado a una dirección IP y un identificador sumando el incremento especificado de forma segura contra condiciones de carrera mediante transacciones atómicas.

### Fuente

Pull Request #10124 (https://github.com/goauthentik/authentik/pull/10124)

### Rationale

Evitar que actualizaciones concurrentes de reputación sobrescriban valores mediante el uso de locks en base de datos.

### Prioridad

Alta

### Verificación

Validación mediante tests unitarios que verifiquen que la actualización de un valor de reputación existente no reinicia el valor al incremento, sino que suma el nuevo incremento de forma correcta, incluso con peticiones concurrentes.

### Estado

Borrador

### Versión

1.0