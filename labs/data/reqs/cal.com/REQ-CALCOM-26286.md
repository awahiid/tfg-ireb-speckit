### ID

REQ-CALCOM-26286

### Nombre

Validar el correo electrónico del propietario en la creación de organizaciones de plataforma

### Tipo

Funcional (Seguridad)

### Descripción formal

El sistema debe validar que el correo electrónico del propietario (`orgOwnerEmail`) de una nueva organización de tipo plataforma (`isPlatform: true`) corresponde al del usuario que está realizando la creación. Se debe eliminar la excepción que permitía a la bandera `isPlatform` omitir esta verificación. Si un usuario no administrador intenta crear una organización de plataforma para otro usuario, el sistema debe devolver un error con el código `FORBIDDEN` y el mensaje "You can only create organization where you are the owner".

### Fuente

Pull Request #26286 (https://github.com/calcom/cal.com/pull/26286)

### Rationale

La omisión de la validación del propietario para las organizaciones de plataforma representaba una vulnerabilidad de seguridad. Permitía a un usuario crear una organización y asignarle la propiedad a otro usuario sin su consentimiento, lo que podría llevar a una apropiación indebida de la cuenta o a la creación de organizaciones no autorizadas. Al aplicar la misma regla de propiedad que a las organizaciones normales, se cierra esta brecha de seguridad y se asegura que solo los administradores puedan crear organizaciones en nombre de otros.

### Prioridad

Alta

### Verificación

1.  Iniciar sesión como un usuario que no sea administrador.
2.  Realizar una llamada a la API para crear una organización (`/api/trpc/organizations/create`) con los siguientes parámetros:
    -   `isPlatform: true`
    -   `orgOwnerEmail`: un correo electrónico que no sea el del usuario autenticado.
3.  Verificar que la API devuelve un error con el código `FORBIDDEN` y el mensaje "You can only create organization where you are the owner".
4.  Realizar otra llamada a la API con `isPlatform: true` pero utilizando el correo electrónico del propio usuario como `orgOwnerEmail`.
5.  Verificar que la organización de plataforma se crea correctamente.
6.  Iniciar sesión como administrador y repetir el paso 2.
7.  Verificar que el administrador sí puede crear una organización de plataforma para otro usuario.

### Estado

Borrador

### Versión

1.0
