### REQ-AUTHENTIK-20744 — Configuración de requests máximas en Gunicorn

**MRS:**

> Como administrador de sistemas,
quiero que el sistema permita configurar los parámetros de máximo número de peticiones antes de reiniciar un worker y su jitter en Gunicorn mediante las variables de entorno de configuración `AUTHENTIK_WEB__MAX_REQUESTS` y `AUTHENTIK_WEB__MAX_REQUESTS_JITTER`, asumiendo valores por defecto de 1000 y 50 respectivamente si no están presentes,
a traves de `AUTHENTIK_WEB__MAX_REQUESTS`,
para permitir a los administradores de sistemas ajustar o deshabilitar (asignando a 0) el comportamiento de reinicio automático de workers de Gunicorn para adaptarlo a entornos con cargas de trabajo específicas o problemas de fugas de memoria, aumentando la flexibilidad operativa del servidor web.
Fuente: PR #20744
