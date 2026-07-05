### REQ-AUTHENTIK-10124 — Actualización de reputación concurrente

**MRS:**

> Como usuario del sistema,
quiero que el sistema actualice el valor de reputación asociado a una dirección IP y un identificador sumando el incremento especificado de forma segura contra condiciones de carrera mediante transacciones atómicas,
para evitar que actualizaciones concurrentes de reputación sobrescriban valores mediante el uso de locks en base de datos.
Fuente: PR #10124

**Notas de derivacion:** No se identifico artefacto tecnico nombrable; se omite clausula de contexto
