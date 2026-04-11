# Como usar SpecKit

## Uso rapido

SpecKit se usa para convertir una idea en una especificacion estructurada y, a partir de ella, generar plan, tareas e implementacion. El flujo base es:

1. Definir las reglas del proyecto con `/speckit.constitution`.
2. Describir lo que se quiere construir con `/speckit.specify`.
3. Crear el plan tecnico con `/speckit.plan`.
4. Generar tareas con `/speckit.tasks`.
5. Ejecutar la implementacion con `/speckit.implement`.

## Que contiene el repositorio oficial

El repositorio oficial es [github/spec-kit](https://github.com/github/spec-kit). Su contenido principal es:

- `README.md`: vision general, comandos y flujo de uso.
- `spec-driven.md`: explicacion completa del proceso SDD.
- `templates/`: plantillas de `spec.md`, `plan.md`, `tasks.md` y comandos.
- `scripts/`: scripts auxiliares del flujo.
- `docs/`: guias de instalacion, uso y desarrollo local.
- `presets/`: presets y sistema de personalizacion.
- `extensions/`: extensiones para integrar agentes o flujos externos.
- `src/`: codigo de `specify-cli`.
- `tests/`: pruebas del CLI, integraciones y extensiones.

## Funciones principales

- Convertir una descripcion en una especificacion.
- Traducir la especificacion a un plan tecnico.
- Desglosar el plan en tareas ejecutables.
- Mantener el flujo de trabajo estructurado con comandos y plantillas.
- Permitir extensiones y presets para adaptar el proceso.

## Limitaciones

- No impone por si mismo IREB ni una plantilla de requisitos completa.
- Da libertad al usuario para el contenido y la estructura.
- Si no se define una disciplina externa, la salida puede quedar incompleta o inconsistente.

## Estado actual

- El flujo central ya esta definido: constitution, specify, plan, tasks e implement.
- Hay soporte para agentes, presets, extensiones y distintos tipos de integracion.
- La estructura esta pensada para generar artefactos de especificacion y desarrollo de forma ordenada.