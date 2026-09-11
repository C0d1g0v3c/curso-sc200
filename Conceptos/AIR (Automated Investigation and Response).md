---
tags: [sc-200, concepto]
dominio: "Dominio 1 - Manage a security operations environment"
dia_origen: 6
---
# AIR (Automated Investigation and Response)

**Definicion:** Capacidad de Microsoft Defender que, al dispararse por una alerta, examina automaticamente cada entidad relacionada (archivo, proceso, procesos hijo, persistencia, otros dispositivos afectados) para decidir un veredicto y, si aplica, remediar.

**Por que existe:** Automatiza la parte repetible de una investigacion para que el analista humano solo intervenga en casos ambiguos o de alto impacto, dado el volumen de alertas diarias en un SOC.

**Como funciona:** Produce uno de tres veredictos (Malicious, Suspicious, No threats found). La agresividad de la remediacion la determina el automation level del device group (ver [[Conceptos/Automation levels]]). Acciones pendientes de aprobacion viven en el Action Center y expiran a los 7 dias.

**Dónde se configura / rol necesario:** Historicamente, el interruptor maestro vivia en Advanced features > Automated Investigation; retirado de la documentacion desde el 1-sep-2026. Lo que sigue siendo configurable es el automation level en Settings > Endpoints > Device groups. Requiere Security Administrator; aprobar acciones requiere rol con "Remediation actions".

**Ejemplo:** Un archivo malicioso detectado en 13 dispositivos se pone en cuarentena automaticamente si el device group esta en Full automation.

**Trampa de examen:** Distinguir el alcance de AIR (una alerta, gobernado por automation level) de Attack disruption (incidente completo, ignora automation level). Ademas: AIR se retiro como experiencia separada y de activacion manual en Microsoft Defender for Endpoint desde el 1-sep-2026 (sus capacidades quedaron integradas en la proteccion antivirus por defecto); esto NO aplica a Defender for Office 365, donde AIR sigue funcionando sin cambios.

## Lecciones donde aparece
- [[Dia 05 - Configuracion Avanzada de MDE ASR Rules Advanced Features Device Groups y Custom Data Collection]]
- [[Dia 06 - AIR Attack Disruption Automation Rules y Playbooks]]
