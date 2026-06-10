### ID

REQ-CALCOM-26801

### Nombre

Añadir configuración de ámbito para funcionalidades opt-in

### Tipo

Funcional

### Descripción formal

El sistema debe permitir la configuración de un ámbito (`scope`) opcional para cada funcionalidad de "opt-in" (`OptInFeatureConfig`). El ámbito puede incluir los valores `org`, `team` y/o `user`. Si no se especifica, la funcionalidad estará disponible en todos los ámbitos por defecto. El sistema debe filtrar las funcionalidades mostradas en las páginas de configuración (usuario, equipo, organización) basándose en este ámbito. Además, las operaciones de modificación de estado de una funcionalidad (`setUserFeatureState`, `setTeamFeatureState`) deben validar que la acción se está realizando en un ámbito permitido para esa funcionalidad, devolviendo un error de tipo `BadRequest` si la validación falla.

### Fuente

Pull Request #26801 (https://github.com/calcom/cal.com/pull/26801)

### Rationale

Algunas funcionalidades "opt-in" solo son relevantes para ciertos niveles de la jerarquía del sistema (por ejemplo, solo para administradores de organización o solo para usuarios individuales). Sin un control de ámbito, estas funcionalidades aparecen en todas las páginas de configuración, creando confusión. Esta mejora permite a los desarrolladores especificar dónde debe aparecer y gestionarse cada funcionalidad, mejorando la usabilidad y añadiendo una capa de validación en el backend.

### Prioridad

Media

### Verificación

1.  Añadir una funcionalidad "opt-in" con `scope: ["user"]`.
2.  Verificar que la funcionalidad aparece en la página de configuración del usuario (`/settings/my-account/features`) pero no en las de equipo u organización.
3.  Intentar modificar el estado de dicha funcionalidad a través de un endpoint de equipo u organización y verificar que la API devuelve un error `ErrorWithCode` con código `BadRequest`.
4.  Repetir las verificaciones para los ámbitos `team` y `org`.
5.  Verificar que una funcionalidad sin el campo `scope` aparece en todas las páginas de configuración.

### Estado

Borrador

### Versión

1.0
