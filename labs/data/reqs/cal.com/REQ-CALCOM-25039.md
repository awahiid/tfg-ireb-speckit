### ID

REQ-CALCOM-25039

### Nombre

Implementar página de administración de la lista de bloqueo del sistema

### Tipo

Funcional

### Descripción formal

El sistema debe proporcionar una nueva página de administración en "Settings > Admin > System Blocklist" para gestionar correos electrónicos y dominios bloqueados a nivel de toda la plataforma. Esta página debe incluir dos vistas principales: "Blocked Entries" y "Pending Reports".

La vista "Blocked Entries" debe mostrar una tabla de todas las entradas de la lista de bloqueo (tanto a nivel de sistema como de organización, con las del sistema marcadas como de solo lectura para los administradores de organización), con funcionalidades de búsqueda, paginación, selección múltiple y acciones masivas de eliminación. Debe permitir a los administradores del sistema crear nuevas entradas (email/dominio), ver detalles de una entrada (incluyendo su historial de auditoría) y eliminarla.

La vista "Pending Reports" debe mostrar una tabla de informes de reservas pendientes de revisión, con funcionalidades de búsqueda, paginación y selección múltiple. Los administradores deben poder revisar un informe y decidir si bloquear el correo electrónico o el dominio a nivel de sistema, o desestimar el informe.

Los componentes de tablas, modales y otros elementos de la interfaz de usuario deben ser reutilizables y aplicarse también a la funcionalidad de lista de bloqueo existente a nivel de organización.

### Fuente

Pull Request #25039 (https://github.com/calcom/cal.com/pull/25039), Issue #24477 (https://github.com/calcom/cal.com/issues/24477)

### Rationale

La gestión de abusos y spam a nivel de plataforma es crucial para mantener la integridad del servicio. Actualmente, el bloqueo se gestiona a nivel de organización, lo que es ineficiente para bloquear actores maliciosos que afectan a múltiples organizaciones. Una lista de bloqueo a nivel de sistema centraliza esta gestión, permitiendo a los administradores actuar de forma global y proactiva. La revisión de informes de reservas en esta misma interfaz agiliza el proceso de moderación. La refactorización de componentes para su reutilización mejora la mantenibilidad del código.

### Prioridad

Alta

### Verificación

1.  Como administrador del sistema, navegar a `/settings/admin/blocklist`.
2.  Verificar que la página se carga y muestra las pestañas "Blocked" y "Pending".
3.  **En la pestaña "Blocked":**
    a. Crear una nueva entrada de bloqueo para un correo electrónico.
    b. Verificar que la entrada aparece en la tabla.
    c. Ver los detalles de la entrada y confirmar que el historial de auditoría es correcto.
    d. Eliminar la entrada y confirmar que desaparece de la tabla.
4.  **En la pestaña "Pending":**
    a. Crear una reserva y reportarla desde la vista de reservas.
    b. Verificar que el informe aparece en la tabla de "Pending Reports".
    c. Revisar el informe y bloquear el dominio del correo electrónico del reservante.
    d. Verificar que el informe desaparece de la lista de pendientes y que se ha creado una nueva entrada en la lista de bloqueo del sistema.
5.  **Como administrador de una organización:**
    a. Navegar a la lista de bloqueo de la organización.
    b. Verificar que la entrada de bloqueo creada por el administrador del sistema aparece en la lista y está marcada como de solo lectura.

### Estado

Borrador

### Versión

1.0
