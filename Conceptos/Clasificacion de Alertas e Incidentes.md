---
tags: [sc-200, concepto]
dominio: "Dominio 2 — Respond to security incidents"
dia_origen: 8
---
# Clasificación de alertas e incidentes

**Definición:** campo del panel "Manage alert" / "Manage incident" que cataloga el resultado de una alerta o incidente en cuatro valores: Not set (por defecto), True positive (con tipo de amenaza), Informational expected activity (con tipo de actividad) y False positive.

**Por qué existe:** clasificar bien alimenta la mejora de la calidad de detección de Microsoft Defender XDR con el tiempo, y ayuda al equipo a detectar patrones repetidos de amenazas reales.

**Cómo funciona:** True positive = amenaza real confirmada. Informational, expected activity = alerta técnicamente correcta pero sobre actividad benigna/esperada (pruebas de seguridad, red team, comportamiento inusual pero confiable) — se sigue queriendo ver en el futuro. False positive = la alerta fue generada por error, sin actividad maliciosa ni esperada — no se quiere volver a ver.

**Dónde se configura / rol necesario:** panel Manage alert (nivel alerta) o Manage incident (nivel incidente completo), campo Classification. Gestionar requiere rol Responder o superior.

**Ejemplo:** un pentest autorizado dispara alertas reales de movimiento lateral durante una semana programada — se clasifican como Informational, expected activity, no como False positive, porque la técnica sí es real y se quiere seguir detectando si la usa un atacante de verdad.

**Trampa de examen:** Informational, expected activity ≠ False positive. La primera es una alerta/incidente correcto sobre actividad benigna conocida; la segunda es una alerta/incidente que estaba mal generado desde el inicio.

## Lecciones donde aparece
- [[Dia 08 - Incidentes Unificados y Case Management]]
- [[Dia 07 - Workbooks SOC Optimization Roles de Sentinel y Notificaciones]]
