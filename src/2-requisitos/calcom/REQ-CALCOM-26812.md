### ID

REQ-CALCOM-26812

### Nombre

Corregir la URL de reserva para organizaciones de plataforma

### Tipo

Funcional

### Descripción formal

El sistema debe generar la `bookingUrl` para los tipos de eventos de la API v2 utilizando `cal.com` como base para los usuarios no administrados que pertenecen a una organización de plataforma (`isPlatform: true`). La URL no debe contener el subdominio de la organización de la plataforma.

### Fuente

Pull Request #26812 (https://github.com/calcom/cal.com/pull/26812)

### Rationale

Las organizaciones de plataforma son contenedores internos para desarrolladores de API y no tienen subdominios de cara al público. El uso de un subdominio de la organización de la plataforma en la `bookingUrl` para usuarios no administrados da como resultado una URL incorrecta e inaccesible. Esta corrección garantiza que los usuarios reciban una URL de reserva válida.

### Prioridad

Alta

### Verificación

1.  Consultar el endpoint de tipos de eventos de la API v2 para un usuario no administrado en una organización de plataforma.
2.  Verificar que la `bookingUrl` devuelta utiliza `https://cal.com/` como base y no `https://[org-slug].cal.com/`.
3.  Añadir una prueba unitaria que compruebe este comportamiento específico.

### Estado

Borrador

### Versión

1.0
