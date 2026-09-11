---
tags: [sc-200, concepto]
dominio: "Dominio 1 - Manage a security operations environment"
dia_origen: 6
---
# Attack disruption

**Definicion:** Capacidad de Microsoft Defender (automatic attack disruption) que correlaciona senales de multiples productos en un incidente de muy alta confianza y contiene automaticamente los activos que el atacante controla, mientras el ataque esta en curso.

**Por que existe:** Limita el movimiento lateral temprano y reduce el costo/perdida de productividad de un ataque sofisticado (ransomware operado por humanos, BEC, AiTM), actuando en tiempo real sin esperar aprobacion humana.

**Como funciona:** Tres etapas: correlacionar senales XDR en un incidente unico, identificar activos bajo control del atacante, y ejecutar acciones de contencion en los productos relevantes. Requiere confianza (signal-to-noise ratio) igual o mayor a 99%. Acciones: Contain device/IP/user, Isolate device (Defender for Endpoint), Disable user (Defender for Identity), Revoke user session/Suspend user in Entra (Entra ID), OAuth app compromise (Defender for Cloud Apps), mas Predictive shielding (Safeboot hardening, GPO hardening, Proactive user containment) que actua antes del incidente confirmado. Ignora el automation level del device group.

**Donde se configura / rol necesario:** Settings > Microsoft Defender XDR > Attack disruption (tambien en Advanced features). Se pueden configurar exclusiones por usuario/dispositivo/IP. Requiere Security Administrator.

**Ejemplo:** Durante ransomware operado por humanos, MDE contiene un dispositivo y Defender for Identity deshabilita la cuenta asociada en segundos, aunque el device group tenga "No automated response".

**Trampa de examen:** "No automated response" en el device group NO desactiva Attack disruption; son mecanismos independientes. Se identifica en el portal con etiqueta "Attack Disruption", barra amarilla, y sufijo "(attack disruption)" en el titulo via API.

## Lecciones donde aparece
- [[Dia 06 - AIR Attack Disruption Automation Rules y Playbooks]]
