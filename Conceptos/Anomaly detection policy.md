---
tags: [sc-200, concepto]
dominio: "Dominio 2 — Respond to security incidents (35-40%)"
dia_origen: 10
---
# Anomaly detection policy (MDCA)

**Definición:** políticas de UEBA (User and Entity Behavior Analytics) y machine learning de MDCA (Microsoft Defender for Cloud Apps), habilitadas por defecto, que detectan comportamiento desviado de la línea base normal de un usuario u organización.

**Por qué existe:** un ataque exitoso suele producir comportamiento anómalo (login desde país nuevo, descargas masivas, múltiples fallos de login) que conviene detectar automáticamente sin revisión manual sesión por sesión.

**Cómo funciona:** tiene un período de aprendizaje inicial de 7 días; luego compara cada sesión contra más de 30 indicadores de riesgo y la línea base de los últimos 30 días. Políticas vigentes con nombre propio: Impossible travel (con slider de sensibilidad Low/Medium/High), Activity from infrequent country/region, Malware detection (deshabilitada por defecto), Suspicious OAuth app file download activities, Multiple failed login attempts, Multiple delete VM activities, Unusual activities (by user). Desde junio de 2025, varias políticas "clásicas" (Activity from suspicious IP addresses, Ransomware activity, Activity performed by terminated user, Suspicious inbox forwarding, entre otras) fueron migradas a un modelo de detección dinámico y renombradas o deshabilitadas sin acción requerida del cliente.

**Dónde se configura / rol necesario:** Cloud apps → Policies → Policy management, tipo "Anomaly detection policy". Requiere rol con permisos de administración de Cloud Apps. Cada política se puede acotar (scope) a usuarios/grupos y configurar con governance actions (remediación automática).

**Ejemplo:** un usuario inicia sesión en Ciudad de México y 40 minutos después en Singapur; Impossible travel dispara una alerta porque ningún vuelo cubre esa distancia en ese tiempo.

**Trampa de examen:** siempre alerta DESPUÉS del hecho — no bloquea nada en tiempo real. Si el enunciado pide "bloquear en el momento", la respuesta es session policy, no anomaly detection.

## Lecciones donde aparece
- [[Dia 10 - MDO Threat Explorer ZAP y MDCA]]
