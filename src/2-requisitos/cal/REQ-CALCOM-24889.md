### ID

REQ-CALCOM-24889

### Nombre

Encolar o cancelar el flujo de recordatorio de pago

### Tipo

Funcional

### Descripción formal

El sistema debe gestionar los recordatorios de pago para reservas pendientes de la siguiente manera:

1.  **Encolamiento con retraso:** Al crear una reserva que requiere pago, en lugar de enviar inmediatamente un correo de "pago pendiente", el sistema debe encolar una tarea (`sendAwaitingPaymentEmail`) para ser ejecutada después de un retraso configurable. El retraso por defecto será de 15 minutos, pero puede ser modificado a través de la variable de entorno `AWAITING_PAYMENT_EMAIL_DELAY_MINUTES`.

2.  **Cancelación de la tarea:** Si se recibe la confirmación de un pago exitoso para una reserva, el sistema debe intentar cancelar la tarea de recordatorio de pago encolada (`sendAwaitingPaymentEmail`) asociada a esa reserva (identificada por el `booking.uid`).

3.  **Verificación previa al envío:** Antes de enviar el correo de recordatorio, la tarea `sendAwaitingPaymentEmail` debe verificar el estado actual del pago. Si el pago ya se ha completado (`payment.success` o `booking.paid` es verdadero), o si una verificación directa con la API de Stripe confirma que el `PaymentIntent` ha sido exitoso, el envío del correo debe ser omitido.

4.  **Gestión de eventos con asientos:** Para eventos con asientos, el recordatorio de pago debe dirigirse específicamente al asistente que ocupa el asiento correspondiente. El enlace de pago incluido en el correo debe estar pre-rellenado con la información de dicho asistente.

5.  **Manejo de redirección de Stripe:** La página de éxito de la reserva debe ocultar el estado de "pago pendiente" si la URL contiene el parámetro `redirect_status=succeeded`, indicando que el usuario acaba de regresar de un flujo de pago exitoso en Stripe.

### Fuente

Pull Request #24889 (https://github.com/calcom/cal.com/pull/24889), Issue #11272 (https://github.com/calcom/cal.com/issues/11272)

### Rationale

Enviar un correo de recordatorio de pago inmediatamente después de la reserva puede ser prematuro y confuso para los usuarios, que pueden estar en medio del proceso de pago. Introducir un retraso y un mecanismo de cancelación mejora la experiencia del usuario, dándoles tiempo para completar el pago sin recibir un recordatorio innecesario. La verificación adicional antes del envío y el manejo de las redirecciones de Stripe hacen que el sistema sea más robusto frente a retrasos en los webhooks de pago. La gestión específica para eventos con asientos asegura que el recordatorio llegue a la persona correcta.

### Prioridad

Media

### Verificación

1.  **Flujo de pago exitoso rápido:**
    a. Realizar una reserva con pago y completarla antes de que transcurra el tiempo de retraso.
    b. Verificar que la tarea de envío de correo de recordatorio se cancela.
    c. Confirmar que no se recibe ningún correo de "pago pendiente".

2.  **Flujo de pago demorado:**
    a. Realizar una reserva con pago pero no completarlo.
    b. Esperar a que transcurra el tiempo de retraso.
    c. Verificar que se recibe un correo de "pago pendiente" con un enlace de pago válido.

3.  **Verificación de estado en la tarea:**
    a. Simular un escenario donde la tarea se ejecuta pero el pago ya ha sido marcado como exitoso en la base de datos.
    b. Verificar en los logs que la tarea omite el envío del correo.

4.  **Evento con asientos:**
    a. Crear un evento con asientos que requiera pago.
    b. Reservar un asiento pero no pagar.
    c. Verificar que el correo de recordatorio se envía al asistente correcto y que el enlace de pago está pre-rellenado con sus datos.

5.  **Redirección de Stripe:**
    a. Completar un pago a través de Stripe que redirija de nuevo a la página de éxito de la reserva.
    b. Verificar que la URL contiene `redirect_status=succeeded`.
    c. Confirmar que la página no muestra el mensaje de "pago pendiente".

### Estado

Borrador

### Versión

1.0
