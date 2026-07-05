### REQ-AUTHENTIK-22413 — Estabilización temporal en tests de certificados mTLS

**MRS:**

> Como equipo de desarrollo,
quiero que el sistema ejecute los tests unitarios de la fase de validación mTLS (`MTLSStageTests`) fijando el contexto temporal de forma estática en "2026-05-10 12:38:46" para evitar fallos de aserción provocados por la caducidad natural de los certificados hardcodeados utilizados en los fixtures de prueba,
a traves de `MTLSStageTests`,
para prevenir el fallo prematuro de los tests continuos debido a la fecha de expiración de los certificados SSL/TLS estáticos utilizados en las pruebas de autenticación mutua, garantizando la reproducibilidad y estabilidad de las validaciones de CI en el futuro.
Fuente: PR #22413
