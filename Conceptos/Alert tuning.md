---
tags: [sc-200, concepto]
dominio: "Dominio 1 — Manage a security operations environment"
dia_origen: 7
---
# Alert tuning

**Definición:** funcionalidad de Microsoft Defender XDR (antes llamada alert suppression) que oculta o resuelve alertas automáticamente cuando ocurre un comportamiento esperado de la organización y se cumplen las condiciones de una regla.

**Por qué existe:** el volumen diario de alertas de un SOC obliga a los analistas a triar manualmente muchas alertas de baja prioridad ya conocidas como benignas (apps internas, pruebas de seguridad programadas). Alert tuning automatiza ese descarte.

**Cómo funciona:** las reglas se basan en tipos de evidencia (IOCs: archivos, procesos, tareas programadas, AMSI, WMI). Tres acciones posibles: Hide alert (suprime la alerta e impide el incidente, solo MDE, dato queda en AlertInfo/AlertEvidence), Resolve alert (resuelve alerta e incidente, sin restricción de producto), Set as behavior (convierte en behavior consultable en BehaviorInfo/BehaviorEntities, no soportada en MDC ni MDO). Hay reglas integradas que no afectan a AIR ni a notificaciones, y se reactivan si AIR detecta actividad maliciosa.

**Dónde se configura / rol necesario:** Settings > Microsoft Defender XDR > Alert tuning, o desde una alerta concreta (Tune alert). Requiere permisos sobre los orígenes de servicio seleccionados.

**Ejemplo:** una app interna dispara la misma alerta de MDE cada día; se crea una regla con acción Hide alert para que no genere incidente, pero el dato sigue disponible para hunting.

**Trampa de examen:** alert tuning NO es compatible con custom detection rules — ahí hay que afinar la propia detección, no suprimirla.

## Lecciones donde aparece
- [[Dia 07 - Workbooks SOC Optimization Roles de Sentinel y Notificaciones]]
