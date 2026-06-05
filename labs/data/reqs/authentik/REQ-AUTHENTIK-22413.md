### ID

REQ-AUTHENTIK-22413

### Nombre

Estabilización temporal en tests de certificados mTLS

### Tipo

Calidad

### Descripción formal

El sistema deberá ejecutar los tests unitarios de la fase de validación mTLS (`MTLSStageTests`) fijando el contexto temporal de forma estática en "2026-05-10 12:38:46" para evitar fallos de aserción provocados por la caducidad natural de los certificados hardcodeados utilizados en los fixtures de prueba.

### Fuente

Pull Request #22413 (https://github.com/goauthentik/authentik/pull/22413) y PR original #22411.

### Rationale

Prevenir el fallo prematuro de los tests continuos debido a la fecha de expiración de los certificados SSL/TLS estáticos utilizados en las pruebas de autenticación mutua, garantizando la reproducibilidad y estabilidad de las validaciones de CI en el futuro.

### Prioridad

Alta

### Verificación

Validación mediante ejecución de tests unitarios verificando que la clase `MTLSStageTests` utiliza la librería `freezegun` y el decorador `@freeze_time` con la fecha especificada y que dichos tests de mTLS se ejecutan de manera exitosa sin errores de certificado expirado, independientemente de la fecha del sistema host.

### Estado

Borrador

### Versión

1.0