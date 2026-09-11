---
tags: [sc-200, concepto]
dominio: "Dominio 1 — Manage a security operations environment"
dia_origen: 7
---
# Notificaciones de Defender XDR

**Definición:** mensajes de correo automáticos que el portal de Microsoft Defender envía a direcciones configuradas cuando ocurre algo relevante: incidentes nuevos/actualizados o vulnerabilidades/exploits nuevos.

**Por qué existen:** para que el equipo se entere de eventos críticos sin tener que vigilar el portal constantemente.

**Cómo funciona:** las notificaciones de incidentes se filtran por Alert severity y Device group scope, con opciones de una notificación por incidente, incluir nombre de organización y enlace específico de tenant. Las de vulnerabilidades se disparan por eventos como new vulnerability found, exploit verified, new public exploit o exploit added to kit.

**Dónde se configura / rol necesario:** Incidentes → Settings > Microsoft Defender XDR > Email notifications > Incidents. Vulnerabilidades → Settings > Endpoints > General > Email notifications > Vulnerabilities. Ambas requieren el permiso "Manage security settings" (o rol Security Administrator).

**Ejemplo:** una regla de notificación de incidentes limitada a severidad High no avisa de incidentes Medium, aunque la regla exista y esté activa.

**Trampa de examen:** las dos rutas de configuración son distintas y no intercambiables — "Endpoints" es para vulnerabilidades, "Microsoft Defender XDR" es para incidentes. Es el error más repetido del alumno en este tema.

## Lecciones donde aparece
- [[Dia 07 - Workbooks SOC Optimization Roles de Sentinel y Notificaciones]]
