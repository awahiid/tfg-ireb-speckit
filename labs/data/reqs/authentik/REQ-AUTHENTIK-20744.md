### ID

REQ-AUTHENTIK-20744

### Nombre

Configuración de requests máximas en Gunicorn

### Tipo

Funcional

### Descripción formal

El sistema deberá permitir configurar los parámetros de máximo número de peticiones antes de reiniciar un worker y su jitter en Gunicorn mediante las variables de entorno de configuración `AUTHENTIK_WEB__MAX_REQUESTS` y `AUTHENTIK_WEB__MAX_REQUESTS_JITTER`, asumiendo valores por defecto de 1000 y 50 respectivamente si no están presentes.

### Fuente

Pull Request #20744 (https://github.com/goauthentik/authentik/pull/20744) y PR original #20736.

### Rationale

Permitir a los administradores de sistemas ajustar o deshabilitar (asignando a 0) el comportamiento de reinicio automático de workers de Gunicorn para adaptarlo a entornos con cargas de trabajo específicas o problemas de fugas de memoria, aumentando la flexibilidad operativa del servidor web.

### Prioridad

Baja

### Verificación

Validación mediante la configuración de las variables `web.max_requests` y `web.max_requests_jitter` (mapeadas desde las variables de entorno `AUTHENTIK_WEB__MAX_REQUESTS*`) y comprobación de que el archivo de configuración `gunicorn.conf.py` inicializa las propiedades `max_requests` y `max_requests_jitter` leyendo dichos valores mediante `CONFIG.get_int`, preservando los defaults documentados.

### Estado

Borrador

### Versión

1.0