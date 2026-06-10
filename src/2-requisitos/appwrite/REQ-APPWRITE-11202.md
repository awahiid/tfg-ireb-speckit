### ID

REQ-APPWRITE-11202

### Nombre

Suscripciones en tiempo real con filtros de consulta

### Tipo

Funcional

### Descripción formal

El sistema deberá permitir que los clientes se suscriban a canales de tiempo real aplicando filtros de consulta, de modo que solo reciban notificaciones de eventos cuyos datos satisfagan las condiciones del filtro especificado.

### Fuente

Release 1.9.0 (https://github.com/appwrite/appwrite/releases/tag/1.9.0), PR #11202 (https://github.com/appwrite/appwrite/pull/11202) y PR #11237 (https://github.com/appwrite/appwrite/pull/11237), entrada: "Query subscriptions — Subscribe to realtime channels with query filters for targeted updates".

### Rationale

Reducir el tráfico de red y el procesamiento en cliente permitiendo suscripciones selectivas que solo entreguen los eventos relevantes para cada cliente conectado.

### Prioridad

Media

### Verificación

Suscribir un cliente a un canal de tiempo real con un filtro de consulta, realizar una operación que genera un evento que satisface el filtro y otra que no lo satisface, y verificar que el cliente solo recibe notificación del primer evento.

### Estado

Borrador

### Versión

1.0
