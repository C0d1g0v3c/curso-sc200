---
tags: [sc-200, concepto]
dominio: "Dominio 2 — Respond to security incidents"
dia_origen: 8
---
# Incidente (Defender XDR)

**Definición:** resultado de que Microsoft Defender XDR agrupe automáticamente varias alertas relacionadas (correlación) en una sola historia de ataque. Vive en la tabla `SecurityIncident` del workspace de Log Analytics.

**Por qué existe:** sin correlación, un analista vería alertas sueltas de distintos productos (MDE, MDO, MDI, Entra ID Protection, Sentinel) sin saber que pertenecen al mismo ataque. El incidente convierte piezas dispersas en una narrativa única.

**Cómo funciona:** nace con estado Active y sin owner. Su severidad se fija automáticamente como la más alta entre sus alertas (se puede sobrescribir). Triage (owner, severidad, tags, estado) → Investigación y resolución (clasificación: Not set / True positive / Informational expected activity / False positive, comentarios) → Logging y reporte (nombre automático editable, activity log, AI-generated analyst notes, export a PDF). Resolver el incidente resuelve automáticamente todas sus alertas activas vinculadas.

**Dónde se configura / rol necesario:** Investigation & response > Incidents & alerts > Incidents, panel "Manage incident". Gestionar requiere Microsoft Sentinel Responder (o "Alerts manage" en Defender unified RBAC); solo ver requiere Reader.

**Ejemplo:** un incidente agrupa una alerta de MDE (proceso sospechoso), una de MDI (movimiento lateral) y una de Entra ID Protection (login de riesgo) de la misma cuenta comprometida.

**Trampa de examen:** alerta individual → `SecurityAlert`; incidente correlacionado → `SecurityIncident`. No existe una tabla separada "de incidentes de Defender XDR unificado".

## Lecciones donde aparece
- [[Dia 08 - Incidentes Unificados y Case Management]]
- [[Dia 07 - Workbooks SOC Optimization Roles de Sentinel y Notificaciones]]
