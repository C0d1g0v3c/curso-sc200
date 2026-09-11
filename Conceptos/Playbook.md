---
tags: [sc-200, concepto]
dominio: "Dominio 1 - Manage a security operations environment"
dia_origen: 6
---
# Playbook

**Definicion:** Una Logic App de Azure (flujo de trabajo low-code/no-code) que ejecuta acciones complejas mas alla de lo que una automation rule puede hacer por si sola: notificar en Teams, consultar APIs externas, crear tickets, aislar dispositivos, enriquecer indicadores, etc.

**Por que existe:** Las automation rules cubren acciones simples predefinidas; los playbooks agregan logica condicional compleja e integracion con sistemas externos. La automation rule decide cuando actuar, el playbook sabe como hacerlo.

**Como funciona:** Se construye sobre trigger "Microsoft Sentinel incident" o "Microsoft Sentinel alert"; solo playbooks del mismo tipo de trigger pueden llamarse desde automation rules del mismo tipo. Cuando una automation rule lo ejecuta, usa una cuenta de servicio de Sentinel, que necesita el rol Microsoft Sentinel Automation Contributor sobre el resource group del playbook (no sobre el playbook individual). Si falta, el playbook aparece en gris; se concede desde "Manage playbook permissions" (requiere ser Owner del resource group). Timing: menos de 1s, la regla avanza al terminar; menos de 2 min, espera hasta 2 min o 10s tras terminar; mas de 2 min, la regla avanza igual a los 2 min.

**Donde se configura / rol necesario:** Automation > Playbooks > Add playbook (Consumption o Standard). Requiere Contributor sobre el resource group para crearlo, y Microsoft Sentinel Automation Contributor (concedido por un Owner) para que la automation rule lo ejecute.

**Ejemplo:** Un playbook "Isolate-Device-and-Notify" aparece en gris hasta que se le concede el rol Automation Contributor sobre su resource group.

**Trampa de examen:** La causa de un playbook en gris SIEMPRE es el permiso de Automation Contributor faltante sobre el resource group, no un tipo de Logic App incompatible ni un limite de playbooks por workspace. Desde junio de 2023 ya no se puede adjuntar un playbook directamente a una analytics rule sin pasar por una automation rule.

## Lecciones donde aparece
- [[Dia 06 - AIR Attack Disruption Automation Rules y Playbooks]]
