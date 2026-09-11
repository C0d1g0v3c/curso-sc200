---
tags: [sc-200, concepto]
dominio: "Dominio 2 — Respond to security incidents (35-40%)"
dia_origen: 13
---
# eDiscovery

**Definición:** Microsoft Purview eDiscovery (electronic discovery) es el proceso de identificar, preservar y exportar ESI (Electronically Stored Information) para usarla como evidencia en una investigación legal, interna o de seguridad. Permite buscar contenido real (texto de correos, archivos, chats de Teams) y ponerlo bajo retención legal (hold).

**Por qué existe:** una investigación legal o de cumplimiento no solo necesita saber "qué pasó" (eso lo responde Audit) — necesita el contenido mismo, protegido de eliminación mientras se decide qué hacer. eDiscovery encadena "buscar y ver" → "preservar" → "exportar/revisar en profundidad" dentro de un mismo caso.

**Cómo funciona:** Microsoft retiró todas las experiencias clásicas de eDiscovery el 31-ago-2025 (Content Search clásico, eDiscovery Standard/Premium clásicos). Hoy todo vive en una experiencia unificada organizada por **casos**, no por "custodians". "Collections" se reemplazó por **Statistics** (ya no inmutable), "Jobs" ahora son **Processes**, y "Content Search" es un caso generado por el sistema (o creado explícitamente) con las mismas capacidades que cualquier otro caso. Dos niveles: eDiscovery (búsqueda, estadísticas, export, holds, search-and-purge) y Premium eDiscovery (añade review sets en Azure Storage, OCR, threading de conversaciones, analítica, Security Copilot).

**Dónde se configura / rol necesario:** dentro de **eDiscovery** en `purview.microsoft.com`. Roles RBAC: **eDiscovery Manager** (solo los casos donde es miembro) y **eDiscovery Administrator** (todos los casos, incluido el de Content Search del sistema).

**Ejemplo:** una búsqueda de 18 meses de actividad de SharePoint falla con el error **CS007** (demasiados resultados/complejidad). Se resuelve dividiendo la búsqueda en fragmentos más pequeños por rango de fechas — no cambiando permisos ni destinatarios.

**Trampa de examen:** "Content Search" ya no es una página independiente (terminología pre-31-ago-2025). Audit responde "qué operación ocurrió"; eDiscovery responde "qué contenido existe/se preserva/se exporta" — no son la misma pregunta aunque vivan en el mismo portal.

## Lecciones donde aparece
- [[Dia 13 - Purview Audit eDiscovery Graph Activity Logs y Copilot Embebido]]
