# Brechas entre IREB y SpecKit

## Propósito

Este documento recopila, de forma sistemática, las principales cuestiones que no quedan garantizadas de manera inmediata por SpecKit frente a los criterios y prácticas definidos por IREB/CPRE. La idea no es asumir que SpecKit incorpore automáticamente un proceso de Requirements Engineering completo, sino identificar qué aspectos deben imponerse, verificarse o complementar para que los requisitos generados queden alineados con IREB.

## Idea central

SpecKit ofrece libertad al usuario para definir el contenido, la forma y el flujo de trabajo de la especificación. Esa flexibilidad es útil, pero implica que el sistema no asegura por sí mismo:

- la cobertura de todos los principios fundamentales de RE;
- la presencia de un proceso explícito de elicitación, análisis, validación y gestión;
- la calidad formal mínima de los requisitos;
- la trazabilidad y el control de cambios;
- la consistencia entre versiones, artefactos y decisiones.

Por tanto, el objetivo del proyecto es mapear el estilo de requisitos de SpecKit con el marco IREB para forzar, o al menos verificar, que las características que CPRE considera necesarias aparezcan en los requisitos producidos por SpecKit.

## Cuestiones que SpecKit no garantiza de forma inmediata

### 1. Principios fundamentales de RE

SpecKit no obliga a que los requisitos estén redactados siguiendo principios IREB como orientación al valor, comprensión compartida, consideración del contexto, validación explícita o evolución controlada.

### 2. Identificación y tratamiento de stakeholders

No asegura que se identifiquen todos los stakeholders relevantes, ni que se mantenga su participación a lo largo del ciclo de vida del requisito.

### 3. Elicitación estructurada

No impone técnicas concretas de extracción de información, ni exige que los requisitos provengan de fuentes claramente trazadas como entrevistas, talleres, observación, documentos o sistemas existentes.

### 4. Análisis y resolución de conflictos

No garantiza la detección de conflictos entre requisitos, ni ofrece por sí mismo un mecanismo formal para negociarlos, priorizarlos o resolverlos.

### 5. Formalización homogénea

No fuerza una plantilla común ni un formato uniforme de redacción. Eso significa que los requisitos pueden quedar con distinto nivel de detalle, ambigüedad o estructura si no se define una convención adicional.

### 6. Calidad del requisito

No asegura propiedades como claridad, verificabilidad, consistencia, atomicidad, completitud, corrección o ausencia de ambigüedad.

### 7. Validación explícita

No impone revisiones sistemáticas para comprobar si los requisitos reflejan correctamente las necesidades de los stakeholders antes de pasar a fases posteriores.

### 8. Trazabilidad

No garantiza enlaces formales entre requisito, fuente, justificación, decisiones, cambios, pruebas y elementos de implementación.

### 9. Gestión del ciclo de vida

No establece por defecto estados, transiciones, baselines, versionado, control de cambios ni políticas de retiro o archivo del requisito.

### 10. Priorización basada en valor y riesgo

No fuerza a decidir qué requisitos son más importantes, urgentes o riesgosos según criterios explícitos y compartidos.

### 11. Cobertura de requisitos no funcionales

No obliga a distinguir ni a modelar de forma explícita requisitos funcionales, de calidad y restricciones del contexto.

### 12. Consistencia entre artefactos

No garantiza que la especificación textual, los agentes, las tareas y los artefactos auxiliares mantengan una coherencia metodológica alineada con RE.

### 13. Evidencia de conformidad

No produce por sí sola una justificación de que el resultado cumpla un marco externo de Requirements Engineering como IREB.

## Consecuencia para el proyecto

La conclusión operativa es que SpecKit debe tratarse como una infraestructura flexible de especificación, mientras que IREB actúa como marco normativo de referencia. El proyecto consiste precisamente en definir el puente entre ambos: qué condiciones, restricciones y estructuras hay que introducir para que la salida de SpecKit sea compatible con las exigencias metodológicas de IREB.
