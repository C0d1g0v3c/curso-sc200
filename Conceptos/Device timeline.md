---
tags: [sc-200, concepto]
dominio: "Dominio 2 — Respond to security incidents (35-40%)"
dia_origen: 9
---
# Device timeline

**Definición:** El Timeline (línea de tiempo) es una pestaña dentro de la página de un dispositivo específico en el portal de Microsoft Defender (`security.microsoft.com`) que muestra, en orden cronológico, todos los eventos observados en ESE dispositivo: procesos, archivos, conexiones de red, cambios de registro, inicios de sesión y alertas.

**Por qué existe:** una alerta es solo un punto en el tiempo; el ataque real casi nunca empieza ahí. El Timeline responde "¿qué pasó antes de la alerta, en este dispositivo concreto?" sin obligar al analista a escribir KQL.

**Cómo funciona:** el sensor de MDE envía telemetría continua al servicio en la nube; el Timeline la renderiza cronológicamente para ese dispositivo, resaltando eventos que coinciden con técnicas MITRE ATT&CK y permitiendo marcar eventos (flags), ver árbol de procesos, y lanzar "Hunt for related events" hacia Advanced hunting.

**Dónde se configura / rol necesario:** no requiere configuración; disponible con el permiso mínimo "View data (Security Operations)". Se accede desde Assets → Devices → seleccionar dispositivo → pestaña Timeline. Retención por defecto: 90 días (salvo workspace con retención extendida). Rango visible por defecto: 30 días, pero configurable a rangos mayores dentro de la retención.

**Ejemplo:** reconstruir qué procesos y conexiones ocurrieron en `WKS-042` entre las 13:00 y las 14:32, antes de que se disparara una alerta a las 14:32.

**Trampa de examen:** Timeline (un solo dispositivo, sin KQL, ideal para "antes de la alerta") vs Advanced hunting (multi-dispositivo/multi-SO, con KQL, ideal para "alcance del incidente"). No confundir el límite de retención (90 días) con el rango del selector (30 días por defecto pero ajustable).

## Lecciones donde aparece
- [[Dia 09 - Respuesta MDE Timeline Live Response y Evidencia]]
