### REQ-CALCOM-26826 — Devolver URL de reserva vacía para usuarios administrados en API v2

**MRS:**

> Como administrador del sistema,
quiero que el sistema devuelva una cadena vacía (`""`) en el campo `bookingUrl` de la respuesta de tipos de eventos en la API v2 cuando el usuario consultado sea un usuario administrado por la plataforma (`isPlatformManaged: true`),
a traves de `""`,
para los usuarios administrados creados a través de la Platform API no tienen páginas de reserva públicas de Cal.
Fuente: PR #26826

