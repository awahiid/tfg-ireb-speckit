### ID

REQ-CALCOM-25640

### Nombre

Auto-autorización para clientes OAuth de confianza

### Tipo

Funcional

### Descripción formal

El sistema debe permitir que los clientes OAuth marcados como de confianza (`isTrusted: true`) omitan la pantalla de consentimiento del usuario durante el flujo de autorización OAuth2. Si el cliente es de confianza y el usuario ya ha seleccionado una cuenta (o hay una cuenta preseleccionada), el sistema debe generar automáticamente el código de autorización y redirigir al usuario sin mostrar la interfaz de usuario de consentimiento, mostrando únicamente un estado de carga temporal ("Authorizing..."). Se debe añadir la columna `isTrusted` (tipo booleano, por defecto falso) al modelo de base de datos `OAuthClient` y exponerla a través del endpoint de obtención de detalles del cliente.

### Fuente

Pull Request #25640 (https://github.com/calcom/cal.com/pull/25640)

### Rationale

Para las aplicaciones propias (first-party apps) desarrolladas por Cal.com, mostrar una pantalla de consentimiento solicitando permiso para acceder a los datos del usuario es redundante y empeora la experiencia del usuario, ya que estas aplicaciones son intrínsecamente de confianza. La introducción de la bandera `isTrusted` permite a estas aplicaciones internas completar el flujo OAuth de forma transparente, mientras se mantiene la pantalla de consentimiento estándar para aplicaciones de terceros.

### Prioridad

Baja

### Verificación

1.  Asegurarse de tener un cliente OAuth configurado en la base de datos con `isTrusted = false`.
2.  Iniciar el flujo OAuth para ese cliente y verificar que se muestra la pantalla de consentimiento estándar donde el usuario debe aceptar los permisos.
3.  Modificar la base de datos para establecer `isTrusted = true` para ese mismo cliente.
4.  Iniciar de nuevo el flujo OAuth con una sesión activa.
5.  Verificar que se muestra brevemente el texto "Authorizing..." en lugar de la pantalla de consentimiento y que se es redirigido automáticamente a la URL de retorno del cliente con el código de autorización generado.

### Estado

Borrador

### Versión

1.0
