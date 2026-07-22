# Instrucciones para GitHub Copilot en este proyecto

## Reglas de comportamiento

- Sé conciso. Respuestas cortas y directas. No expliques lo obvio.
- No repitas código que ya existe en el contexto. Usa referencias.
- No sugieras cambios en archivos de `_archive/`, `_original/`, `datos-pr/` o `resultados/` — son históricos o generados.
- Para LaTeX: solo modifica archivos `.tex` fuente, nunca archivos generados (`.aux`, `.bbl`, `.log`, `.toc`, `.pdf`, `_minted-main/`, etc.).
- Para cambios pequeños (1-3 líneas), usa `replace_string_in_file`. Para cambios múltiples independientes, usa `multi_replace_string_in_file`.
- No ejecutes `git add` ni `git commit` a menos que se pida explícitamente.
- No ejecutes compilaciones de LaTeX a menos que se pida explícitamente.
- Los archivos en `src/1-evidencia/datos-pr/` son volcados crudos de GitHub API. No los analices ni sugieras editarlos.
- `docs/cpre/cpre.txt` es un volcado textual de apuntes. No lo uses como fuente principal; usa los `.tex` en `docs/cpre/sections/`.
- El archivo `docs/memoria/estructura.md` es el índice de la memoria. Consúltalo antes de hacer cambios estructurales en `docs/memoria/`.

## Estructura del proyecto (rápida)

| Ruta | Contenido |
|---|---|
| `docs/memoria/` | Memoria del TFG (LaTeX) |
| `docs/cpre/` | Apuntes de CPRE (LaTeX) |
| `src/0-analisis/` | Análisis IREB vs SpecKit |
| `src/1-evidencia/` | Evidencia (changelogs, informes) |
| `src/2-requisitos/` | Requisitos formalizados por herramienta |
| `src/2.5-prompts/` | Prompts de generación de MRS |
| `src/3-implementacion/` | Implementación con IREB Kit |
| `src/4-evaluacion/` | Evaluación y mapeo de alineación |
| `speckit/` | Apuntes sobre SpecKit |
