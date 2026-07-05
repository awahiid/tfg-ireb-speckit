### REQ-DIRECTUS-26669 — Corrección de la lógica de deshabilitación de la interfaz de traducción

**MRS:**

> Como usuario del sistema,
quiero que el sistema asegure que la interfaz de traducción se deshabilita de forma granular, basándose en los permisos del usuario: 1. **Deshabilitación completa de la interfaz**: La interfaz de traducción completa (incluyendo campos de entrada y controles de edición) deberá deshabilitarse únicamente cuando el usuario no tenga permisos para guardar cambios...,
a traves de `!isSaveAllowed`,
para una regresión anterior causaba que toda la interfaz de traducción se deshabilitara si el usuario carecía de permisos para eliminar, incluso si tenía permisos para editar y guardar traducciones.
Fuente: PR #26669
