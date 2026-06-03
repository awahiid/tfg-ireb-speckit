## Plantilla formal de especificación de requisitos

La presente plantilla define un conjunto mínimo de atributos para documentar requisitos de forma consistente, verificable y trazable. Su diseño se basa en las recomendaciones de la norma ISO/IEC/IEEE 29148, el handbook de IREB CPRE Foundation Level Handbook y las guías de redacción de INCOSE Guide for Writing Requirements. Se han seleccionado únicamente aquellos atributos que contribuyen directamente a la identificación, comprensión, validación y gestión del requisito durante su ciclo de vida.

| Atributo               | Descripción formal reproducible                                                                                                                                                                                                                             | Ejemplo                                                                                                                                                      | Justificación bibliográfica                                                                                                                                                                                                                                                                                             |
| ---------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **ID**                 | Identificador único e inmutable del requisito. Debe seguir un esquema consistente y no reutilizarse aunque el requisito sea eliminado. Formato recomendado: `REQ-[DOMINIO]-[NÚMERO]`.                                                                       | `REQ-PAGO-012`                                                                                                                                               | IREB define la identificación única como atributo básico de todo requisito para soportar trazabilidad y gestión de cambios (CPRE Foundation Handbook, sección *Requirements Documentation*, atributo *Identification*). IEEE 29148 requiere la identificación inequívoca de cada requisito dentro de la especificación. |
| **Nombre**             | Título breve que describa la capacidad o necesidad principal. Debe contener entre 2 y 8 palabras y evitar detalles de implementación.                                                                                                                       | `Confirmación de pago`                                                                                                                                       | IREB incluye el nombre como atributo descriptivo que facilita navegación, revisión y comunicación entre stakeholders (CPRE Foundation Handbook, atributo *Name*).                                                                                                                                                       |
| **Tipo**               | Clasificación del requisito según su naturaleza. Valores permitidos: **Funcional**, **Calidad** o **Restricción**. Debe seleccionarse una única categoría.                                                                                                  | `Funcional`                                                                                                                                                  | IREB distingue explícitamente entre requisitos funcionales, requisitos de calidad y restricciones (CPRE Foundation Handbook, capítulo *Requirements Types*). IEEE 29148 establece diferentes categorías de requisitos dentro de una especificación.                                                                     |
| **Descripción formal** | Enunciado que describe una única obligación del sistema. Debe seguir la estructura: **"El sistema deberá [acción] [objeto] [condición]"**. Debe emplear verbos observables y evitar términos ambiguos como *rápido*, *eficiente*, *intuitivo* o *adecuado*. | `El sistema deberá generar una confirmación de pago con identificador de transacción y marca temporal en menos de 5 segundos tras una autorización exitosa.` | IEEE 29148 establece que los requisitos deben ser claros, completos, no ambiguos y verificables. INCOSE identifica como características esenciales que un requisito sea necesario, singular, claro y verificable (*Guide for Writing Requirements*, sección *Characteristics of Individual Requirements*).              |
| **Fuente**             | Origen documentado del requisito. Debe identificar explícitamente al stakeholder, documento, normativa, sistema legado o cualquier fuente primaria. Siempre que sea posible debe incluir fecha o versión.                                                   | `Entrevista con Responsable de Finanzas (2026-04-10)`                                                                                                        | IREB define el atributo *Source* para registrar el origen del requisito y soportar la trazabilidad hacia los stakeholders (CPRE Foundation Handbook, atributo *Source*).                                                                                                                                                |
| **Rationale**          | Explicación de la necesidad que motiva el requisito. Debe responder a la pregunta: **¿por qué existe este requisito?**. Debe expresar el problema que resuelve o el beneficio esperado.                                                                     | `Reducir reclamaciones de clientes y facilitar auditorías de cobros.`                                                                                        | IREB define *Rationale* como la justificación del requisito y recomienda documentarla para facilitar validación y mantenimiento (CPRE Foundation Handbook, atributo *Rationale*). INCOSE considera la justificación un elemento clave para comprender la necesidad subyacente.                                          |
| **Prioridad**          | Importancia relativa del requisito para el negocio. Debe utilizar una escala cerrada previamente definida. Valores recomendados: **Alta**, **Media** o **Baja**.                                                                                            | `Alta`                                                                                                                                                       | IREB incorpora la prioridad como atributo para apoyar negociación y gestión del alcance (CPRE Foundation Handbook, atributo *Stakeholder Priority*). IEEE 29148 contempla la prioridad como atributo de gestión del requisito.                                                                                          |
| **Verificación**       | Método objetivo para demostrar que el requisito se cumple. Debe incluir métricas observables, criterios de aceptación o condiciones de prueba medibles.                                                                                                     | `Prueba E2E con 100 transacciones consecutivas; el 100 % deberá generar comprobante y el tiempo de respuesta deberá ser inferior a 5 segundos.`              | IEEE 29148 exige que los requisitos sean verificables. INCOSE establece que todo requisito debe poder comprobarse mediante prueba, análisis, inspección o demostración (*Guide for Writing Requirements*, característica *Verifiable*).                                                                                 |
| **Estado**             | Situación actual del requisito dentro de su ciclo de vida. Valores recomendados: **Borrador**, **Elaborado**, **Validado**, **Implementado** o **Archivado**.                                                                                               | `Validado`                                                                                                                                                   | IREB Requirements Management describe la necesidad de gestionar estados y transiciones para controlar la evolución de los requisitos durante todo su ciclo de vida.                                                                                                                                                     |
| **Versión**            | Identificador de revisión del requisito. Debe incrementarse cuando se modifique el contenido aprobado. Formato recomendado: `Mayor.Menor`.                                                                                                                  | `1.2`                                                                                                                                                        | IREB Requirements Management recomienda mantener control de versiones para soportar cambios, configuraciones y baselines. IEEE 29148 también contempla la gestión de versiones como parte del ciclo de vida del requisito.                                                                                              |

### Plantilla resultante

```text
ID:
REQ-XXX-NNN

Nombre:

Tipo:
[Funcional | Calidad | Restricción]

Descripción formal:
El sistema deberá ...

Fuente:

Rationale:

Prioridad:
[Alta | Media | Baja]

Verificación:

Estado:
[Borrador | Elaborado | Validado | Implementado | Archivado]

Versión:
```

### Reglas obligatorias para la descripción formal

1. Debe expresar una única obligación.
2. Debe comenzar por la fórmula "El sistema deberá...".
3. Debe contener un verbo observable y verificable.
4. Debe evitar términos subjetivos o ambiguos.
5. Debe incluir condiciones cuantificables cuando sea posible.
6. Debe poder verificarse mediante prueba, análisis, inspección o demostración.
7. Debe ser comprensible sin necesidad de interpretar otros requisitos.
8. No debe describir detalles de implementación salvo que se trate de una restricción explícita.
