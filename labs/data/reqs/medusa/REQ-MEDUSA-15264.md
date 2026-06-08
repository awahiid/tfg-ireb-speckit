### ID

REQ-MEDUSA-15264

### Nombre

Prevención de error en creación de sesiones de pago sin account holders

### Tipo

Funcional

### Descripción formal

El sistema deberá gestionar de manera segura la creación de sesiones de pago (`createPaymentSessionsWorkflow`) para clientes que no tienen registros vinculados en `account_holders`. Durante este flujo, si la consulta para recuperar los datos del cliente devuelve una lista de `account_holders` vacía o no definida (`undefined`), el sistema deberá interpretarla como una lista vacía `[]` antes de intentar realizar operaciones de búsqueda (`.find()`) sobre ella. Además, la búsqueda del proveedor (`provider_id`) dentro de los `account_holders` deberá utilizar el encadenamiento opcional (optional chaining `?.`) para evitar errores en tiempo de ejecución si algún elemento del array resultase estar indefinido.

### Fuente

Pull Request #15264 (https://github.com/medusajs/medusa/pull/15264), Issue #15152 (https://github.com/medusajs/medusa/issues/15152)

### Rationale

Anteriormente, al invocar la API para crear sesiones de pago (`POST /store/payment-collections/:id/payment-sessions`) para un cliente autenticado que no tenía ningún `account_holder` asociado, la consulta remota devolvía `undefined` para ese campo. El flujo de trabajo intentaba invocar `.find()` directamente sobre ese valor `undefined`, lo que provocaba una excepción no controlada y devolvía un error HTTP 500 al cliente. Este cambio defensivo garantiza que el flujo crítico de checkout no falle abruptamente por la ausencia de datos estructurales pre-esperados.

### Prioridad

Alta

### Verificación

1.  **Cliente sin `account_holders`**:
    a. Identificar o crear un cliente (`customer`) en el sistema que no tenga ninguna entrada asociada en la relación `account_holders` (o que la consulta de la API retorne `undefined` para este campo).
    b. Iniciar un proceso de pago y crear una colección de pagos (`payment_collection`).
    c. Invocar la API `POST /store/payment-collections/:id/payment-sessions` asignando el ID del cliente del paso (a) y un `provider_id` válido.
    d. Verificar que la API responde exitosamente (código de estado 200 OK) y se crea la sesión de pago, en lugar de lanzar un error 500.
    e. (Opcional, si es posible consultar el estado posterior) Verificar que se ha creado correctamente la relación de `account_holders` para ese cliente tras la operación exitosa.

### Estado

Borrador

### Versión

1.0
