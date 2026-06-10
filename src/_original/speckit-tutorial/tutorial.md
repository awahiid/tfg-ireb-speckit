# Tutorial rápido de SpecKit

Este tutorial resume el flujo habitual de trabajo y qué estructura base crea SpecKit al inicializar un proyecto.

## 1) Inicialización

Comando usado (ejemplo):

```bash
uvx --from git+https://github.com/github/spec-kit.git specify init speckit-tutorial
```

Alternativa con CLI instalada:

```bash
specify init speckit-tutorial --ai copilot
```

## 2) Workflow habitual

Flujo recomendado dentro del chat del agente:

1. `/speckit.constitution`
2. `/speckit.specify`
3. `/speckit.plan`
4. `/speckit.tasks`
5. `/speckit.implement`

Resumen de cada fase:

- `constitution`: define reglas del proyecto.
- `specify`: crea la especificación funcional de la feature.
- `plan`: traduce requisitos a plan técnico.
- `tasks`: descompone el plan en tareas ejecutables.
- `implement`: ejecuta las tareas y construye la solución.

## 3) Qué contiene el repositorio base al crearlo

Tras `specify init`, se genera una estructura como esta:

```text
.github/
	agents/
	prompts/
.specify/
	extensions/
	integrations/
	memory/
	scripts/
		bash/
	templates/
.vscode/
```

Qué significa cada bloque:

- `.github/`
	- `prompts/`: comandos tipo `/speckit.*` que usa el agente.
	- `agents/`: configuración o prompts específicos según integración.

- `.specify/`
	- `templates/`: plantillas maestras del flujo (spec, plan, tasks).
	- `scripts/`: scripts auxiliares que ejecutan pasos del workflow.
	- `memory/`: documentos de contexto compartido (por ejemplo, constitution).
	- `integrations/`: instalación concreta para el agente elegido (por ejemplo, Copilot).
	- `extensions/`: extensiones adicionales instaladas en el proyecto.

- `.vscode/`
	- Ajustes locales para abrir el proyecto con una configuración recomendada.

En términos prácticos, el repositorio base queda preparado así:

1. **Capa de interacción con el agente**: `.github/`.
2. **Capa de motor metodológico de SpecKit**: `.specify/`.
3. **Capa de entorno local**: `.vscode/`.

Lo importante es que el valor principal está en `.specify/`, porque ahí vive el flujo reproducible de especificación.

## 4) Qué se crea después (no en init)

Los artefactos de una feature (`specs/.../spec.md`, `plan.md`, `tasks.md`) aparecen cuando ejecutas `/speckit.specify`, `/speckit.plan` y `/speckit.tasks`.

