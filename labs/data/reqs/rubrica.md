# Rúbrica para la evaluación de calidad de requisitos

La presente rúbrica permite evaluar de forma sistemática la calidad de un requisito individual documentado mediante la plantilla propuesta. Está basada en las características de calidad definidas por ISO/IEC/IEEE 29148, las recomendaciones de documentación de IREB CPRE Foundation Level Handbook y los criterios de redacción de INCOSE Guide for Writing Requirements.

Con el objetivo de maximizar la reproducibilidad entre evaluadores, cada criterio se evalúa de forma binaria:

* **1 punto** → Cumple el criterio.
* **0 puntos** → No cumple el criterio.

La puntuación total se calcula como la suma de los criterios cumplidos.

| Resultado   | Interpretación          |
| ----------- | ----------------------- |
| 9–10 puntos | Requisito aceptable     |
| 7–8 puntos  | Requiere revisión menor |
| ≤ 6 puntos  | Rechazado               |

Se considera que un requisito alcanza el umbral mínimo de calidad cuando obtiene **al menos 9 puntos sobre 10**. Este umbral permite tolerar pequeñas deficiencias sin aceptar requisitos ambiguos o difíciles de verificar.

---

## Criterios de evaluación

| Requisito a cumplir                                                                                                               | Justificación bibliográfica                                                                                          | Ejemplo                                                                                                                                                        |
| --------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **R1. Posee un identificador único.** El requisito dispone de un ID único y estable.                                              | IEEE 29148 e IREB consideran la identificación única un atributo esencial para trazabilidad y gestión de cambios.    | ✔ `REQ-PAGO-012`<br>✘ Sin identificador                                                                                                                        |
| **R2. Tiene una clasificación válida.** El atributo Tipo contiene únicamente Funcional, Calidad o Restricción.                    | IREB clasifica los requisitos en estas categorías para facilitar análisis y validación.                              | ✔ `Funcional`<br>✘ `Importante`                                                                                                                                |
| **R3. Existe una fuente identificable.** Se documenta explícitamente el origen del requisito.                                     | IREB define Source como atributo fundamental para trazabilidad hacia stakeholders y documentación origen.            | ✔ `Entrevista con Responsable de Finanzas (2026-04-10)`<br>✘ `Lo pidió el cliente`                                                                             |
| **R4. Existe una justificación (Rationale).** Se explica la necesidad o beneficio asociado al requisito.                          | IREB e INCOSE recomiendan documentar la razón de existencia del requisito para facilitar validación y mantenimiento. | ✔ `Reducir reclamaciones de clientes.`<br>✘ Campo vacío                                                                                                        |
| **R5. Existe un criterio de verificación objetivo.** Se especifica cómo comprobar el cumplimiento del requisito.                  | IEEE 29148 e INCOSE exigen que los requisitos sean verificables.                                                     | ✔ `Prueba E2E con 100 transacciones.`<br>✘ `Se comprobará durante las pruebas.`                                                                                |
| **R6. Expresa una única obligación.** El requisito describe un único comportamiento o necesidad.                                  | INCOSE establece que los requisitos deben ser singulares (*singular*).                                               | ✔ `El sistema deberá generar un comprobante.`<br>✘ `El sistema deberá generar un comprobante y enviarlo por correo.`                                           |
| **R7. Utiliza la estructura formal definida.** Sigue el patrón "El sistema deberá...".                                            | IEEE 29148 e INCOSE recomiendan una redacción uniforme para reducir ambigüedad.                                      | ✔ `El sistema deberá registrar...`<br>✘ `Sería conveniente que el sistema registrara...`                                                                       |
| **R8. Utiliza verbos observables y verificables.** El comportamiento puede observarse directamente.                               | INCOSE recomienda emplear verbos que permitan verificar objetivamente el cumplimiento.                               | ✔ `generar`, `registrar`, `calcular`, `enviar`<br>✘ `facilitar`, `optimizar`, `mejorar`                                                                        |
| **R9. No contiene términos ambiguos o subjetivos.** No aparecen expresiones abiertas a interpretación.                            | IEEE 29148 e INCOSE exigen requisitos no ambiguos.                                                                   | ✔ `menos de 5 segundos`<br>✘ `rápidamente`, `de forma eficiente`, `fácilmente`                                                                                 |
| **R10. Es completo y autosuficiente.** Contiene acción, objeto y condición necesaria para comprenderlo sin información adicional. | IEEE 29148 establece que un requisito debe ser completo y comprensible.                                              | ✔ `El sistema deberá generar una confirmación de pago en menos de 5 segundos tras una autorización exitosa.`<br>✘ `El sistema deberá generar la confirmación.` |

---

## Cálculo de la puntuación

Sea:

* ( P ) = suma de criterios cumplidos.

La puntuación de calidad se calcula mediante:

Score=P

donde:

* (0 \le P \le 10)

Opcionalmente puede expresarse como porcentaje:

Score_{%}=\frac{P}{10}\times100

---

## Ejemplo de evaluación

Requisito:

> El sistema deberá generar una confirmación de pago con identificador de transacción y marca temporal en menos de 5 segundos tras una autorización exitosa.

Resultado:

| Criterio | Puntos |
| -------- | ------ |
| R1       | 1      |
| R2       | 1      |
| R3       | 1      |
| R4       | 1      |
| R5       | 1      |
| R6       | 1      |
| R7       | 1      |
| R8       | 1      |
| R9       | 1      |
| R10      | 1      |

**Puntuación total: 10/10 (Aceptable).**

Esta rúbrica prioriza la objetividad y la reproducibilidad frente a evaluaciones subjetivas de "claridad" o "calidad general", permitiendo que distintos evaluadores lleguen a resultados similares sobre un mismo requisito.
