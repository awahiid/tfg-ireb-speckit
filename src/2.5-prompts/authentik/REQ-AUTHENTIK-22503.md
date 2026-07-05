### REQ-AUTHENTIK-22503 — Resolución de versión en estado de Outpost

**MRS:**

> Como administrador de infraestructura,
quiero que el sistema reporte el atributo `version_should` de un Outpost evaluando dinámicamente el valor actual del módulo en tiempo de respuesta del endpoint de salud (`health`), en lugar de almacenar la versión estáticamente en la instancia de la clase `OutpostState` durante su inicialización,
a traves de `version_should`,
para evitar la persistencia de una versión obsoleta en el estado de los outposts si no se reinicia el worker de la API tras una actualización de la aplicación, garantizando que el dashboard siempre muestre y compare contra la versión correcta real (OUR_VERSION) del servidor en ejecución.
Fuente: PR #22503

