---
tags: [sc-200, concepto]
dominio: "Dominio 2 — Respond to security incidents (35-40%)"
dia_origen: 10
---
# Threat Explorer

**Definición:** reporte casi en tiempo real dentro del portal de Defender (`security.microsoft.com/threatexplorerv3`) que permite a un analista buscar, filtrar e investigar mensajes de correo recientes de MDO (Microsoft Defender for Office 365) y tomar acciones de remediación sobre ellos. Su versión reducida, disponible en licencias Plan 1, se llama Real-time detections.

**Por qué existe:** cuando un usuario reporta un correo sospechoso o llega una alerta de MDO, el analista necesita buscar mensajes por remitente, asunto, URL o adjunto y ver su veredicto y ubicación de entrega, sin depender de un administrador de Exchange para cada búsqueda.

**Cómo funciona:** Threat Explorer (Plan 2) tiene 6 vistas: All email, Malware, Phish, Campaigns, Content malware, URL clicks. Real-time detections (Plan 1) tiene 3: Malware, Phish, Content malware. Ambas consultan el mismo almacén de metadatos y verdictos de MDO. La remediación se hace con el asistente "Take action" → "Move or delete", que ofrece 5 destinos (Junk, Inbox, Deleted items, Soft deleted items, Hard deleted items) — esta opción NO existe en Real-time detections, solo en Threat Explorer.

**Dónde se configura / rol necesario:** Email & collaboration → Explorer. Previsualizar/descargar requiere el permiso "Preview" (por defecto: Data Investigator, eDiscovery Manager); mover/eliminar requiere "Search and Purge" (por defecto: Data Investigator, Organization Management) o, en Unified RBAC, "Email & collaboration advanced actions (manage)". Sin Search and Purge, un analista puede usar "Propose remediation" para dejar una acción pendiente de aprobación por otro con más permisos.

**Ejemplo:** un analista filtra por remitente en Threat Explorer, confirma que un mensaje es phishing, y usa Take action → Move or delete → Hard deleted items para purgarlo definitivamente.

**Trampa de examen:** Real-time detections (Plan 1) solo permite "Submit to Microsoft for review" y entradas en la Tenant Allow/Block List — NO permite mover/eliminar mensajes. Esa capacidad requiere Plan 2 (Threat Explorer).

## Lecciones donde aparece
- [[Dia 10 - MDO Threat Explorer ZAP y MDCA]]
