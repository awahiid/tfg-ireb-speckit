### REQ-APPWRITE-10832 — Caché de listados de documentos con TTL configurable

**MRS:**

> Como usuario del sistema,
quiero que el sistema permita que las consultas de listado de documentos se sirvan desde caché cuando se especifique un TTL de caché en la petición, devolviendo resultados cacheados dentro del periodo de validez y renovando la caché cuando el TTL expire,
para reducir la latencia y la carga sobre la base de datos en consultas de listado repetitivas, especialmente en escenarios de alta concurrencia de lectura.
Fuente: PR #10832

**Notas de derivacion:** No se identifico artefacto tecnico nombrable; se omite clausula de contexto
