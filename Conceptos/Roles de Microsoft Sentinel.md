---
tags: [sc-200, concepto]
dominio: "Dominio 1 — Manage a security operations environment"
dia_origen: 7
---
# Roles de Microsoft Sentinel

**Definición:** cinco roles integrados de Azure RBAC específicos de Sentinel: Reader (ver), Responder (ver + gestionar incidentes), Contributor (ver + gestionar + crear/editar recursos + Content hub), Playbook Operator (ejecutar playbooks manualmente) y Automation Contributor (permite a la cuenta de servicio de Sentinel ejecutar playbooks desde automation rules — no se asigna a usuarios).

**Por qué existen:** para dar acceso escalonado según la función del analista/ingeniero, sin tener que crear roles personalizados desde cero para las tareas más comunes del SOC.

**Cómo funciona:** ningún rol de Sentinel crea/edita playbooks (eso es Logic App Contributor, un rol de Azure Logic Apps); Sentinel Contributor no ejecuta playbooks (eso es Playbook Operator); crear/eliminar workbooks exige Sentinel Contributor + Workbook Contributor combinados.

**Dónde se configura / rol necesario:** se asignan sobre el resource group del workspace de Sentinel (recomendación oficial), vía Access control (IAM) en el portal de Azure.

**Ejemplo:** para que una automation rule ejecute un playbook de otro resource group, la cuenta de servicio de Sentinel necesita el rol Microsoft Sentinel Automation Contributor sobre ESE resource group, otorgado por alguien con rol Owner.

**Trampa de examen:** el permiso de ejecución de playbooks vía automation rules va a la cuenta de servicio sobre el resource group del playbook — nunca al usuario ni al playbook individual.

## Lecciones donde aparece
- [[Dia 07 - Workbooks SOC Optimization Roles de Sentinel y Notificaciones]]
