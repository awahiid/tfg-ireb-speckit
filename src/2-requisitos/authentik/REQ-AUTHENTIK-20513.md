### ID

REQ-AUTHENTIK-20513

### Nombre

Prevención de recursión infinita en conectores de endpoint

### Tipo

Funcional

### Descripción formal

El sistema deberá evaluar si el conector de una fase Endpoint (EndpointStage) tiene una implementación de sub-fase (stage) y, si carece de ella, deberá finalizar la fase de forma exitosa si el modo está configurado como `OPTIONAL`, o rechazarla con el error `Invalid stage configuration` si el modo es `REQUIRED`, evitando llamadas recursivas al despachador general.

### Fuente

Pull Request #20513 (https://github.com/goauthentik/authentik/pull/20513) y PR original #20485.

### Rationale

Evitar bucles infinitos y caída del proceso cuando se intenta ejecutar una fase de validación (EndpointStage) cuyo conector no soporta o no implementa una fase específica, respetando la configuración de modo (Opcional/Requerido) definida por el administrador.

### Prioridad

Alta

### Verificación

Validación mediante tests unitarios que configuren un EndpointStage con un conector sin fase asociada simulado (mock), verificando que cuando el modo es `OPTIONAL` la fase no bloquea el flujo (stage_ok), y cuando el modo es `REQUIRED` la fase falla limpiamente devolviendo el error predefinido (`ak-stage-access-denied`) sin causar un límite de recursión.

### Estado

Borrador

### Versión

1.0