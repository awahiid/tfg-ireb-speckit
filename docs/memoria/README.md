# Memoria — TFG: Mapeo de SpecKit contra flujos profesionales de ingeniería de requisitos

**Autor:** Abdel Wahed Mahfoud Mouhandizi  
**Titulación:** Grado en Ingeniería Informática en Ingeniería del Software  
**Tutora:** Julia González Rodríguez  
**Cotutor:** Emilio Delgado Muñoz  
**Convocatoria:** Septiembre 2026  
**Escuela Politécnica — Universidad de Extremadura**

---

## Compilar

```bash
pdflatex -interaction=nonstopmode main.tex
bibtex main
pdflatex -interaction=nonstopmode main.tex
pdflatex -interaction=nonstopmode main.tex
```

Compilación limpia: **71 páginas, 0 errores, 0 warnings**.

---

## Estructura del documento

```
main.tex                     # Fichero principal (compila con pdflatex + bibtex)
tfeEPCC.cls                  # Clase de documento UEx (no modificar)
LocalBibliography.bib        # Referencias bibliográficas (25 entradas)

chapters/
  01_introduccion.tex        # Cap. 1 — Introducción
  02_objetivos.tex           # Cap. 2 — Objetivos, preguntas y alcance
  03_estado_del_arte.tex     # Cap. 3 — Estado del arte (IREB, SpecKit, relacionados)
  04_metodologia.tex         # Cap. 4 — Metodología (5 fases, decisiones, defensibilidad)
  05_implementacion_y_desarrollo.tex  # Cap. 5 — IREB Kit, corpus, ejecución
  06_resultados.tex          # Cap. 6 — Resultados y discusión
  07_conclusiones_y_trabajos_futuros.tex  # Cap. 7 — Conclusiones

appendices/
  01_ejemplo_de_anexo.tex    # Anexo 1 (placeholder de la plantilla)
  02_plantilla_requisitos.tex # Anexo 2 — Plantilla IREB + ejemplo real

code/                        # Fragmentos de código
pictures/                    # Logos UEx para portada/contraportada
```

---

## Datos clave del trabajo

- **Corpus:** 52 requisitos formalizados (12 atributos IREB) de 6 proyectos Open Source
- **Evaluación:** 6 casos × 3 flujos = 18 ejecuciones de SpecKit
- **Resultado:** Kit v2 gana 6–0 con 9.2/10 frente a 5.3/10 del baseline
- **Producto:** IREB Kit for SpecKit (10 artefactos)
- **Rúbrica:** SRCI v3 — 24 criterios en 4 bloques