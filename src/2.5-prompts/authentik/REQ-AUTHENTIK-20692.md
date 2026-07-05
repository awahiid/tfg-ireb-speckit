### REQ-AUTHENTIK-20692 — Configuración de search_path en PostgreSQL

**MRS:**

> Como equipo de desarrollo,
quiero que el sistema aplique la configuración del esquema de base de datos (`search_path`) mediante la ejecución de la consulta `select pg_catalog.set_config('search_path', $1, false)` después de establecer la conexión (`AfterConnect`), eliminando dicho parámetro de los `RuntimeParams` de inicio para garantizar compatibilidad con multiplexadores como PgBouncer,
a traves de `search_path`,
para evitar que el establecimiento de la conexión falle en arquitecturas con PgBouncer (especialmente en modo transacción), ya que PgBouncer no soporta el pase de parámetros `search_path` durante el startup de la conexión, resolviéndolo mediante su inyección explícita tras establecer el canal.
Fuente: PR #20692
