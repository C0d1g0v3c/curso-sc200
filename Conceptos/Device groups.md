---
tags: [sc-200, concepto]
dominio: "Dominio 1 - Manage a security operations environment"
dia_origen: 5
---
# Device groups

**Definicion:** Agrupacion logica de endpoints en MDE, construida normalmente con reglas basadas en atributos (dominio, rango de IP, tag, nombre) en vez de asignacion manual uno por uno.

**Por que existe:** No todos los dispositivos deben tratarse igual: permite separar visibilidad entre equipos de SOC (RBAC) y aplicar niveles distintos de agresividad de remediacion automatica (automation level) por subconjunto de dispositivos.

**Como funciona:** Cada device group puede asociarse a un grupo de Microsoft Entra ID (para RBAC, controla que analistas ven que dispositivos) y tiene asignado un automation level (ver [[Conceptos/Automation levels]]).

**Donde se configura / rol necesario:** Settings > Endpoints > Device groups > Add device group. Requiere Security Administrator; el grupo de Entra ID asociado debe existir previamente.

**Ejemplo:** Un device group "Servidores-LATAM" asociado al grupo de Entra "SOC-LATAM" hace que esos analistas solo vean esos servidores.

**Trampa de examen:** RBAC (visibilidad) y automation level (agresividad de remediacion) son dos configuraciones independientes del mismo device group, no deben confundirse.

## Lecciones donde aparece
- [[Dia 05 - Configuracion Avanzada de MDE ASR Rules Advanced Features Device Groups y Custom Data Collection]]
