### ID

REQ-AUTHENTIK-20692

### Nombre

Configuración de search_path en PostgreSQL

### Tipo

Funcional

### Descripción formal

El sistema deberá aplicar la configuración del esquema de base de datos (`search_path`) mediante la ejecución de la consulta `select pg_catalog.set_config('search_path', $1, false)` después de establecer la conexión (`AfterConnect`), eliminando dicho parámetro de los `RuntimeParams` de inicio para garantizar compatibilidad con multiplexadores como PgBouncer.

### Fuente

Pull Request #20692 (https://github.com/goauthentik/authentik/pull/20692) y PR original #20662.

### Rationale

Evitar que el establecimiento de la conexión falle en arquitecturas con PgBouncer (especialmente en modo transacción), ya que PgBouncer no soporta el pase de parámetros `search_path` durante el startup de la conexión, resolviéndolo mediante su inyección explícita tras establecer el canal.

### Prioridad

Alta

### Verificación

Validación mediante tests unitarios de configuración (`BuildConnConfig`) verificando que la clave `search_path` no está presente en el mapa `RuntimeParams` resultante, y que el callback `AfterConnect` no es nulo cuando se define un `DefaultSchema`, demostrando que la asignación se difiere correctamente.

### Estado

Borrador

### Versión

1.0