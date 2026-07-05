### REQ-MEDUSA-15264 — Prevención de error en creación de sesiones de pago sin account holders

**MRS:**

> Como usuario del sistema de reservas,
quiero que el sistema gestione de manera segura la creación de sesiones de pago (`createPaymentSessionsWorkflow`) para clientes que no tienen registros vinculados en `account_holders`. Durante este flujo, si la consulta para recuperar los datos del cliente devuelve una lista de `account_holders` vacía o no definida (`undefined`), el sistema deberá interpretarla como...,
a traves de `createPaymentSessionsWorkflow`,
para anteriormente, al invocar la API para crear sesiones de pago (`POST /store/payment-collections/:id/payment-sessions`) para un cliente autenticado que no tenía ningún `account_holder` asociado, la consulta remota devolvía `undefined` para ese campo.
Fuente: PR #15264
