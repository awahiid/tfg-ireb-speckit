### ID

REQ-DIRECTUS-26965

### Nombre

Reducción del retardo de los tooltips para elementos deshabilitados

### Tipo

Funcional

### Descripción formal

El sistema deberá reducir el tiempo de retardo (delay) para mostrar los tooltips al pasar el cursor sobre los elementos de la interfaz deshabilitados a 125 milisegundos, manteniendo el retardo estándar de 500 milisegundos para los elementos habilitados. El sistema deberá considerar que un elemento está deshabilitado si cumple alguna de las siguientes condiciones:
1. Posee el atributo nativo `disabled`.
2. Posee el atributo `aria-disabled="true"`.
3. Contiene al menos un hijo directo (evaluado mediante `:scope >`) que cumpla con alguna de las dos condiciones anteriores.

### Fuente

Pull Request #26965 (https://github.com/directus/directus/pull/26965), Issue CMS-2050 (https://linear.app/directus/issue/CMS-2050/reduce-tooltip-delay-for-disabled-elements)

### Rationale

Los usuarios necesitan una retroalimentación rápida al intentar interactuar con controles que no están disponibles (elementos deshabilitados) para comprender rápidamente por qué no pueden realizar una acción. Un retardo de 500ms es adecuado para elementos interactivos (para evitar mostrar tooltips constantemente al mover el ratón por la pantalla), pero resulta lento como retroalimentación de error o indisponibilidad. Reducir este tiempo a 125ms mejora la usabilidad proporcionando información casi instantánea sobre el estado del elemento. El sistema revisa los hijos directos porque los tooltips a menudo se colocan en contenedores envolventes (wrappers) de los elementos deshabilitados.

### Prioridad

Baja

### Verificación

1.  **Elemento deshabilitado**:
    a. Localizar un botón o control en la interfaz que esté deshabilitado (por ejemplo, mediante el atributo `disabled`).
    b. Pasar el cursor sobre el elemento.
    c. Comprobar que el tooltip aparece rápidamente (aprox. 125ms).

2.  **Elemento habilitado**:
    a. Localizar un botón o control habilitado en la interfaz que posea un tooltip.
    b. Pasar el cursor sobre el elemento.
    c. Comprobar que el tooltip aparece con el retardo estándar normal (aprox. 500ms).

3.  **Hijo directo deshabilitado**:
    a. Localizar o crear una estructura en el DOM donde un elemento contenedor posea un tooltip y su hijo directo esté deshabilitado (`aria-disabled="true"` o `disabled`).
    b. Pasar el cursor sobre el contenedor.
    c. Comprobar que el tooltip aparece rápidamente (aprox. 125ms).

### Estado

Borrador

### Versión

1.0
