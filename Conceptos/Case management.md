---
tags: [sc-200, concepto]
dominio: "Dominio 2 — Respond to security incidents"
dia_origen: 8
---
# Case management

**Definición:** capacidad nativa del portal de Microsoft Defender (GA a mediados de 2026) para gestionar trabajo de SecOps sin salir del portal ni depender de ticketing externo. Un case agrupa incidentes e indicadores relacionados con tasks, evidencia y colaboración propias.

**Por qué existe:** herramientas de ticketing externas no tienen contexto de seguridad (no saben qué es un incidente o un IOC), generando ineficiencia. Casos de uso: eventos que abarcan varios incidentes, gestión de threat hunting, seguimiento de IOCs/actores de amenaza, seguimiento de lógica de detección a ajustar.

**Cómo funciona:** requiere un workspace de Sentinel conectado al portal de Defender; los cases solo existen ahí, nunca en Azure portal. Campos: Priority (Very low a Critical), Status (New/Open/Closed por defecto, personalizable), Assigned to (un único usuario), Case ID (empieza en 1000, nunca se purga). Se vinculan incidentes e indicadores (IOCs) desde Linked Objects. No existe tabla de Log Analytics ni Advanced Hunting para cases — viven solo en el servicio de Case Management.

**Dónde se configura / rol necesario:** portal de Defender > Cases. RBAC en espejo de Sentinel: Reader = solo ver (Security data basics read); Responder = crear/gestionar (Alerts manage); Contributor = además personalizar estados (Core Security settings manage).

**Ejemplo:** un threat hunter crea un case para una campaña que generó 3 incidentes en distintos endpoints, vincula los 3 incidentes y el IOC (hash) compartido, y asigna tasks a analistas.

**Trampa de examen:** un case NO reemplaza al incidente — es una capa manual por encima. No existe `SecurityCase` como tabla consultable. Borrar un case exige escribir literalmente "delete" en el cuadro de confirmación. Los Projects de MDTI están deprecados; la ruta vigente para IOCs es vincularlos a un case.

## Lecciones donde aparece
- [[Dia 08 - Incidentes Unificados y Case Management]]
