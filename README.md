# curso-sc200

Apuntes de estudio para la certificación **SC-200 — Microsoft Security Operations Analyst Associate**.

Repositorio personal de notas en Markdown, escritas y mantenidas dentro de un vault de Obsidian. Cubre Microsoft Sentinel, Defender XDR, Defender for Cloud, KQL y respuesta a incidentes.

> **Estado:** en progreso · Voucher válido hasta el 18 de agosto de 2026 · Fecha límite de examen: 18 de octubre de 2026

---

## Estructura

```
.
├── 00_INDEX_SC200.md              Índice maestro: dominios, plan, checklist global
├── 01_Semana1_Sentinel_Fundamentos.md
├── 02_Semana2_KQL_Labs.md
├── 03_Semana3_Defender_XDR.md
├── 04_Semana4_Simulacros.md
├── 05_CaseStudy_Endpoints_Infrastructure.md
├── 06_CaseStudy_Implementation_Plans.md
├── 07_Fundamentals_AI_Security.md
├── 08_AI_Security_Controls.md
│
├── Coursera ExamPrep/             Notas del curso "Exam Prep SC-200" (Coursera)
│   ├── 00_INDEX_Coursera_SC200.md
│   └── Modulo_1..6_*.md           XDR · MDE · Sentinel · Unified SecOps · Hunting · Copilot
│
├── Lecciones Diarias/             Una nota por día de la guía intensiva
│   ├── Dia 01..06 - *.md
│   └── Lecciones.base             Vista de Obsidian Bases sobre las lecciones
│
├── GUIA_INTENSIVA_24_DIAS.md      Plan día a día
├── PLAN_INTENSIVO_4SEMANAS.md     Plan por semanas
├── MAPA_DIARIO_LEARN_LABS.md      Mapeo a módulos y labs de Microsoft Learn
├── CHEATSHEET_KQL.md              Referencia rápida de KQL
├── CONCEPTOS_CLAVE.md             Glosario de conceptos evaluados
├── Chronicle_vs_Sentinel.md       Traducción de conceptos entre SIEMs
├── Caso_Fabrikam_Multicloud_Security.md
├── AI_Skills_Fest_Security_Pro.md
├── Simulacro 01 - Dominio 1 (hasta Dia 6).md
├── REPASO_RAPIDO_Errores_Simulacro.md
├── TRACKER_TUTOR.md               Seguimiento del avance
└── notas.md                       Notas sueltas / bandeja de entrada
```

## Dominios del examen (actualización abril 2026)

| Dominio | Peso | Contenido |
|---------|------|-----------|
| 1. Manage Security Operations Environment | ~35% | Workspace de Sentinel, ingesta de logs, RBAC |
| 2. Configure Protections & Detections | ~40% | Analytics rules, Defender for Endpoint/Identity/Cloud, threat intelligence |
| 3. Respond to Incidents & Alerts | ~25% | Gestión de incidentes, investigación, hunting, playbooks |

## Cómo usar estas notas

Están pensadas para leerse en **Obsidian**: usan wikilinks (`[[nota]]`), callouts (`> [!tip]`) y frontmatter YAML.

- **En Obsidian:** abre esta carpeta como vault, o clónala dentro de uno existente.
- **En GitHub:** el Markdown se lee bien, pero los wikilinks no son navegables y los embeds de imágenes (`![[imagen.png]]`) no se renderizan — las imágenes viven en la carpeta de adjuntos del vault y no se versionan aquí.

## Notas sobre el repositorio

- Repositorio **privado**: contiene apuntes derivados de material de Microsoft Learn y Coursera.
- `.obsidian/` está excluido a propósito: es configuración local de la máquina, no contenido.
- Los finales de línea se normalizan a LF vía `.gitattributes` para mantener los diffs legibles.

## Recursos oficiales

- [Microsoft Learn — Ruta SC-200](https://learn.microsoft.com/training/paths/sc-200-mitigate-threats-sentinel/)
- [Study guide oficial del examen](https://learn.microsoft.com/certifications/exams/sc-200)
- [microsoft/SC-200T00A — labs oficiales](https://github.com/microsoft/SC-200T00A)
