### ID

REQ-DIRECTUS-26976

### Nombre

Navegación por teclado en diseño de tarjetas

### Tipo

Funcional

### Descripción formal

El sistema debe permitir la navegación y activación de elementos en la vista de tarjetas (`cards layout`) utilizando el teclado, de acuerdo a las siguientes reglas:

1.  **Enfoque de tarjetas:** Cuando no hay elementos seleccionados, las tarjetas individuales deben ser alcanzables mediante la tecla `Tab` (`tabindex="0"`).
2.  **Activación de tarjetas:** Presionar la tecla `Enter` o la barra espaciadora (`Space`) sobre una tarjeta enfocada debe activar la acción principal de la tarjeta (navegación al detalle del elemento), siempre y cuando no haya elementos seleccionados y no se esté en modo de selección.
3.  **Comportamiento en modo selección:** Si existe al menos un elemento seleccionado (`modelValue.length > 0`), las tarjetas deben quedar excluidas del orden de tabulación (`tabindex="-1"`), dejando únicamente los iconos de selección de cada tarjeta como elementos enfocables por teclado.
4.  **Activación durante selección:** Si se presiona `Enter` o `Space` sobre una tarjeta o se hace clic en ella mientras hay elementos seleccionados o el modo de selección está activo (`selectMode === true`), el sistema debe alternar el estado de selección de la tarjeta (`toggleSelection`), y no debe navegar a la vista de detalle.
5.  **Indicador visual:** El enfoque por teclado debe mostrar un anillo de enfoque (`focus ring`) alrededor de la cabecera (`.header`) de la tarjeta, que respete los estilos de diseño globales del proyecto.

### Fuente

Pull Request #26976 (https://github.com/directus/directus/pull/26976), Issue #26945 (https://github.com/directus/directus/issues/26945)

### Rationale

La interfaz de vista de tarjetas carecía de soporte para navegación por teclado, lo que impedía el acceso a estos elementos para usuarios que no utilizan ratón y rompía las pautas de accesibilidad. Implementar navegación con `Tab`, `Enter` y `Space` corrige este problema. Además, modificar el comportamiento de enfoque cuando hay selecciones activas previene activaciones accidentales que llevarían a cambios de vista no deseados.

### Prioridad

Alta

### Verificación

1.  **Navegación básica:**
    a. Acceder a una colección configurada con la vista de tarjetas sin selecciones activas.
    b. Presionar `Tab` y verificar que el foco se mueve a cada tarjeta de la lista.
    c. Verificar visualmente que el indicador de enfoque aparece solo alrededor de la cabecera de la tarjeta.
2.  **Activación básica:**
    a. Con una tarjeta enfocada, presionar `Enter` y verificar que se navega al detalle del elemento.
    b. Repetir el proceso presionando `Space` y verificar el mismo resultado.
3.  **Exclusión de tabulación con selección activa:**
    a. Seleccionar un elemento de la vista de tarjetas.
    b. Presionar `Tab` repetidamente.
    c. Verificar que el foco salta únicamente por los iconos de selección (checkboxes) y no por la tarjeta completa.
4.  **Alternancia de selección con teclado:**
    a. Con un elemento ya seleccionado, enfocar el icono de selección de otra tarjeta mediante `Tab`.
    b. Presionar `Enter` o `Space`.
    c. Verificar que el elemento se selecciona o deselecciona, y no se navega a su vista de detalle.

### Estado

Borrador

### Versión

1.0
