### REQ-AUTHENTIK-20513 — Prevención de recursión infinita en conectores de endpoint

**MRS:**

> Como cliente de la API,
quiero que el sistema evalue si el conector de una fase Endpoint (EndpointStage) tiene una implementación de sub-fase (stage) y, si carece de ella, deberá finalizar la fase de forma exitosa si el modo está configurado como `OPTIONAL`, o rechazarla con el error `Invalid stage configuration` si el modo es `REQUIRED`, evitando llamadas recursivas al despachador general,
a traves de `OPTIONAL`,
para evitar bucles infinitos y caída del proceso cuando se intenta ejecutar una fase de validación (EndpointStage) cuyo conector no soporta o no implementa una fase específica, respetando la configuración de modo (Opcional/Requerido) definida por el administrador.
Fuente: PR #20513
