---
tags: [sc-200, concepto]
dominio: "Dominio 2 — Respond to security incidents (35-40%)"
dia_origen: 13
---
# Copilot embebido en Defender XDR

**Definición:** la experiencia embebida de Security Copilot (capa de IA generativa de Microsoft para seguridad) dentro del portal de Defender XDR y de eDiscovery — no un producto aparte, sino paneles y botones integrados en las páginas que ya usa el analista. El examen SC-200 solo evalúa esta experiencia embebida, no la configuración de Security Copilot como producto standalone.

**Por qué existe:** acelera tareas que consumen mucho tiempo de analista (resumir un incidente de 40 alertas, analizar un script ofuscado, redactar el reporte final) sin reemplazar la decisión final, que sigue siendo del analista.

**Cómo funciona:** en Defender XDR, cada página del incidente/dispositivo/archivo/identidad tiene tarjetas de Copilot: **Incident summary** (resumen automático al abrir el incidente: cuándo empezó, activos, línea de tiempo, IOCs), **Guided response** (recomendaciones de acción específicas al incidente), **Script analysis**, **Device summary**, **File analysis**, **Identity summary**, **Incident report**, **Query assistant** (NL→KQL en Advanced Hunting), y **Defender Chat** (preview, chat consciente del contexto de la página, propone un plan de pasos aprobable). En eDiscovery, Copilot traduce lenguaje natural a **KeyQL** (no KQL) y resume ítems dentro de un review set.

**Dónde se configura / rol necesario:** requiere **acceso provisionado a Security Copilot**, modelo de consumo por **SCU** (Security Compute Units), comprado/asignado aparte de las licencias de Defender/Purview/E5.

**Ejemplo:** un analista abre un incidente con 40 alertas correlacionadas. Usa Incident summary para entender el ataque sin leer alerta por alerta, luego Guided response para decidir la acción concreta (aislar un dispositivo específico), luego Script analysis si aparece un artefacto sospechoso, y cierra con Incident report.

**Trampa de examen:** "resumir lo que pasó" → Incident summary. "Qué acción tomo ahora" → Guided response. Son dos tarjetas distintas dentro de la misma pestaña Copilot, no la misma función con dos nombres.

## Lecciones donde aparece
- [[Dia 13 - Purview Audit eDiscovery Graph Activity Logs y Copilot Embebido]]
