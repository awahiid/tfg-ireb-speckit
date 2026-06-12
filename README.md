# Mapeo de SpecKit contra flujos profesionales de ingeniería de requisitos basados en normas

**Trabajo de Fin de Grado (TFG)** | Grado en Ingeniería Informática del Software

## Objetivo General

Este proyecto **mapea sistemáticamente el flujo de trabajo de GitHub SpecKit (Spec-Driven Development) contra un flujo profesional de ingeniería de requisitos basado en normas** (IREB CPRE Foundation Level, ISO/IEC/IEEE 29148 e INCOSE Guide for Writing Requirements), con el propósito de identificar alineaciones, brechas y áreas grises entre ambos.

## Objetivo Específico

Producir un mapa de alineación que documente, para cada actividad, criterio de calidad y artefacto del flujo normativo, si SpecKit lo cubre, lo cubre parcialmente o no lo cubre, respaldado por evidencia obtenida de casos de estudio reales.

## Descripción del Trabajo

### Enfoque y Metodología

El análisis se fundamenta en:

- **IREB Foundation Level Handbook + ISO/IEC/IEEE 29148 + INCOSE Guide**: Marco normativo de referencia para ingeniería de requisitos profesional
- **SpecKit (v0.10.2)**: Documentación oficial, repositorio, spec-driven.md y observación del pipeline SDD frente a requisitos reales

### Componentes Principales

1. **Definición del flujo normativo de referencia**
   - Actividades IREB: elicitación, documentación, validación, gestión
   - Criterios de calidad ISO 29148
   - Buenas prácticas INCOSE

2. **Caracterización del flujo SpecKit**
   - Comandos, artefactos, mecanismos de calidad
   - Pipeline SDD: constitution → specify → clarify → checklist → plan → tasks → analyze → implement

3. **Mapeo sistemático SpecKit ↔ normas**
   - Tablas de cobertura por actividad y criterio
   - Evidencia de casos de estudio reales (6 repositorios Open Source)
   - Identificación de brechas y áreas grises

4. **Recomendaciones de alineación**
   - Cómo aproximar el flujo SpecKit a un flujo normativo
   - Limitaciones inherentes del enfoque SDD
