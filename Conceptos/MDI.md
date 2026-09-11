---
tags: [sc-200, concepto]
dominio: "Dominio 2 — Respond to security incidents (35-40%)"
dia_origen: 11
---
# MDI (Microsoft Defender for Identity)

**Definición:** MDI es el producto de Microsoft que monitorea señales de identidad provenientes de **Active Directory on-premises** (el directorio tradicional, con controladores de dominio) y de Microsoft Entra ID, además de otras soluciones de IAM (Identity and Access Management) externas como Okta. A diferencia de [[Entra ID Protection]] — que solo ve la nube — MDI tiene visibilidad sobre protocolos y comportamientos exclusivos de un entorno Active Directory clásico: Kerberos, LDAP, replicación entre controladores de dominio, SAM-R.

**Por qué existe:** muchas organizaciones siguen operando un Active Directory local para autenticar usuarios y equipos, incluso si también usan Microsoft Entra ID en la nube (modelo híbrido). Ese AD local tiene sus propios vectores de ataque (Kerberoasting, Pass-the-Hash, DCSync, Golden Ticket) que Entra ID Protection no puede ver porque nunca pasan por la nube. MDI cierra ese punto ciego.

**Cómo funciona:** usa **sensores** ligeros instalados en la infraestructura de identidad (domain controllers, AD FS, AD CS, Microsoft Entra Connect) más conectores de API para IAM externos. Los sensores capturan y analizan localmente el tráfico de red y los eventos de Windows relevantes, y solo envían al servicio en la nube las señales necesarias para detección. Desde el sensor v3.x, la funcionalidad de MDI se integra dentro del mismo agente unificado de Microsoft Defender for Endpoint (MDE) que ya corre en ese servidor (requiere Windows Server 2019+ con la cumulative update de julio-2026 o posterior; servidores más antiguos usan el sensor v2.x independiente). Organiza sus detecciones en 4 etapas de un ataque: Reconnaissance, Compromised credentials, Lateral movement, AD Domain dominance.

**Dónde se configura / rol necesario:** el portal unificado de Defender (`security.microsoft.com`), página de Identidad de cada entidad. Instalar sensores requiere acceso administrativo al servidor de destino. Ejecutar acciones de remediación (Disable, Force password change, etc.) requiere un rol con el permiso "Response (manage)" del RBAC unificado de Defender, o el rol nuevo **SOC Identity Responder** (jul-2026) diseñado para dar ese permiso sin necesitar un rol amplio de Entra ID.

**Ejemplo:** MDI detecta un volumen anómalo de solicitudes de tickets de servicio (TGS) desde una cuenta normal contra varias cuentas con SPN — genera una alerta de Kerberoasting en la fase "Compromised credentials", que un analista investiga en el portal de Defender.

**Trampa de examen:** solo los sensores instalados en **controladores de dominio** pueden ejecutar acciones de remediación sobre cuentas de AD — los sensores en AD FS, AD CS o Entra Connect solo aportan señal, no ejecutan acciones. Ver también [[Ataques a Kerberos y Active Directory]], [[Honeytoken]], [[Attack paths]].

## Lecciones donde aparece
- [[Dia 11 - Identidades Entra ID Protection y MDI]]
