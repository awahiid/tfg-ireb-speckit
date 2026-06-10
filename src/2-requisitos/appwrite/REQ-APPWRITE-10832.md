### ID

REQ-APPWRITE-10832

### Nombre

Caché de listados de documentos con TTL configurable

### Tipo

Funcional

### Descripción formal

El sistema deberá permitir que las consultas de listado de documentos se sirvan desde caché cuando se especifique un TTL de caché en la petición, devolviendo resultados cacheados dentro del periodo de validez y renovando la caché cuando el TTL expire.

### Fuente

Release 1.9.0 (https://github.com/appwrite/appwrite/releases/tag/1.9.0), PR #10832 (https://github.com/appwrite/appwrite/pull/10832), entrada: "Cached document lists — Document list queries can be cached with configurable TTL".

### Rationale

Reducir la latencia y la carga sobre la base de datos en consultas de listado repetitivas, especialmente en escenarios de alta concurrencia de lectura.

### Prioridad

Media

### Verificación

Realizar una consulta de listado con un TTL especificado, verificar que una segunda consulta idéntica dentro del TTL devuelve la respuesta cacheada sin impactar la base de datos, y verificar que tras expirar el TTL la consulta se resuelve contra la base de datos.

### Estado

Borrador

### Versión

1.0
