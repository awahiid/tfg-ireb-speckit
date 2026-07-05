### REQ-CALCOM-24889 — Encolar o cancelar el flujo de recordatorio de pago

**MRS:**

> Como usuario del sistema de reservas,
quiero que el sistema gestione los recordatorios de pago para reservas pendientes de la siguiente manera: 1. **Encolamiento con retraso:** Al crear una reserva que requiere pago, en lugar de enviar inmediatamente un correo de "pago pendiente", el sistema debe encolar una tarea (`sendAwaitingPaymentEmail`) para ser ejecutada después de un retraso configurable. El...,
a traves de `AWAITING_PAYMENT_EMAIL_DELAY_MINUTES`,
para enviar un correo de recordatorio de pago inmediatamente después de la reserva puede ser prematuro y confuso para los usuarios, que pueden estar en medio del proceso de pago.
Fuente: PR #24889
