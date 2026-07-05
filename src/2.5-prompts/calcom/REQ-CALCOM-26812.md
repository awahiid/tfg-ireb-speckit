### REQ-CALCOM-26812 — Corregir la URL de reserva para organizaciones de plataforma

**MRS:**

> Como administrador del sistema,
quiero que el sistema genere la `bookingUrl` para los tipos de eventos de la API v2 utilizando `cal.com` como base para los usuarios no administrados que pertenecen a una organización de plataforma (`isPlatform: true`). La URL no debe contener el subdominio de la organización de la plataforma,
a traves de `bookingUrl`,
para las organizaciones de plataforma son contenedores internos para desarrolladores de API y no tienen subdominios de cara al público.
Fuente: PR #26812
