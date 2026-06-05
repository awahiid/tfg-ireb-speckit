### ID

REQ-CALCOM-26826

### Nombre

Devolver URL de reserva vacía para usuarios administrados en API v2

### Tipo

Funcional

### Descripción formal

El sistema debe devolver una cadena vacía (`""`) en el campo `bookingUrl` de la respuesta de tipos de eventos en la API v2 cuando el usuario consultado sea un usuario administrado por la plataforma (`isPlatformManaged: true`). Para obtener este valor, el repositorio de tipos de eventos debe recuperar el campo `isPlatformManaged` de los usuarios.

### Fuente

Pull Request #26826 (https://github.com/calcom/cal.com/pull/26826)

### Rationale

Los usuarios administrados creados a través de la Platform API no tienen páginas de reserva públicas de Cal.com, ya que su programación se maneja completamente a través de la aplicación de la plataforma. Devolver una `bookingUrl` para ellos es engañoso e incorrecto.

### Prioridad

Media

### Verificación

1.  Consultar el endpoint de tipos de eventos de la API v2 para un usuario administrado (`isPlatformManaged: true`).
2.  Verificar que el valor del campo `bookingUrl` en la respuesta sea una cadena vacía `""`.
3.  Añadir una prueba unitaria para validar que el servicio `buildBookingUrl` devuelve una cadena vacía cuando se pasa un usuario con `isPlatformManaged: true`.

### Estado

Borrador

### Versión

1.0
