---
tags: [sc-200, concepto]
dominio: "Dominio 2 — Respond to security incidents (35-40%)"
dia_origen: 11
---
# Ataques a Kerberos y Active Directory

**Definición:** Kerberos es el protocolo de autenticación por defecto de Active Directory. En vez de mandar la contraseña cada vez, el usuario recibe **tickets**: un **TGT** (Ticket Granting Ticket) para autenticarse ante el dominio, y **TGS** (Ticket Granting Service tickets) para acceder a un servicio específico. El **KDC** (Key Distribution Center, un rol que corre en cada controlador de dominio) emite ambos tickets. La cuenta especial **krbtgt** firma todos los TGT del dominio — quien controla su hash controla la confianza de todo el dominio. Varias técnicas de ataque muy citadas en el examen abusan de este mecanismo.

**Por qué existe el vocabulario:** cada técnica roba o falsifica algo distinto (un hash, un ticket, permisos de replicación), y el examen exige distinguirlas por lo que específicamente comprometen, no solo reconocer que "son ataques a Kerberos".

**Cómo funciona cada técnica:**

| Técnica | Qué usa el atacante | Qué obtiene |
|---|---|---|
| Kerberoasting | Solicitud masiva de TGS (cuenta normal, sin privilegios) contra cuentas con SPN | Hashes de cuentas de servicio, para romper offline |
| AS-REP Roasting | Solicitud de AS-REP a cuentas sin preautenticación Kerberos | Hash de la cuenta objetivo, para romper offline |
| Pass-the-Hash | Hash NTLM robado | Autenticación sin conocer la contraseña real |
| Pass-the-Ticket | Ticket Kerberos robado (TGT o TGS) de memoria | Movimiento lateral reutilizando la sesión ya autenticada |
| DCSync | Permisos de replicación (legítimos o robados) | Hashes de TODAS las cuentas del dominio, haciéndose pasar por un DC |
| Golden Ticket | Hash de la cuenta krbtgt | TGT forjado, válido para cualquier usuario, acceso ilimitado y persistente a todo el dominio |
| Silver Ticket | Hash de la cuenta de un servicio | TGS forjado, acceso ilimitado a ESE servicio específico |

**Dónde se investiga / rol necesario:** [[MDI]] genera alertas automáticas para estas técnicas dentro de sus 4 etapas de ataque (Kerberoasting y AS-REP Roasting caen en "Compromised credentials"; Pass-the-Ticket en "Lateral movement"; DCSync y Golden Ticket en "AD Domain dominance"). Investigar requiere acceso al portal de Defender; remediar un Golden Ticket exige higiene de dominio (rotar el hash de krbtgt dos veces) que está fuera del catálogo de acciones de un clic de MDI.

**Ejemplo:** un analista ve una alerta de DCSync sobre una cuenta de servicio sin permisos de replicación esperados — investiga si esos permisos fueron otorgados legítimamente o si el atacante los escaló primero.

**Trampa de examen:** "Force password change" NO remedia un Golden Ticket (depende del hash de krbtgt, no de la contraseña de una cuenta de usuario). Kerberoasting solicita TGS nuevos en volumen; Pass-the-Ticket reutiliza un ticket YA robado, sin generar solicitudes nuevas — no las confundas.

## Lecciones donde aparece
- [[Dia 11 - Identidades Entra ID Protection y MDI]]
