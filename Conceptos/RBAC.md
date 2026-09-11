---
tags: [sc-200, concepto]
dominio: "Dominio 1 — Manage a security operations environment"
dia_origen: 7
---
# RBAC (Role-Based Access Control)

**Definición:** modelo de control de acceso basado en roles: en lugar de otorgar permisos sueltos a cada persona, se definen roles (paquetes de permisos) y se asignan a usuarios, grupos o aplicaciones sobre un ámbito (scope) — suscripción, resource group o recurso individual. Un permiso = quién + qué rol + sobre qué ámbito.

**Por qué existe:** otorgar permisos uno por uno es lento y propenso a errores de auditoría. Con roles predefinidos se da o quita un paquete completo de permisos de una sola vez.

**Cómo funciona:** Microsoft Sentinel usa dos sistemas de RBAC distintos: Azure RBAC para el SIEM (workspace, reglas, incidentes, workbooks) y Microsoft Entra ID RBAC para el data lake. Las asignaciones son acumulativas — un usuario con dos roles tiene la suma de permisos de ambos, nunca el menor.

**Dónde se configura / rol necesario:** Azure Portal > resource group > Access control (IAM) > Role assignments. Se recomienda asignar en el resource group del workspace de Sentinel, no en el workspace ni en recursos individuales sueltos.

**Ejemplo:** un analista con Microsoft Sentinel Reader y Contributor asignados tiene los permisos de Contributor (el mayor), no los de Reader.

**Trampa de examen:** "quitar permisos" no se hace añadiendo un rol más restrictivo encima — hay que remover la asignación existente. SIEM = Azure RBAC; Data lake = Microsoft Entra ID RBAC, no los mezcles.

## Lecciones donde aparece
- [[Dia 07 - Workbooks SOC Optimization Roles de Sentinel y Notificaciones]]
- [[Dia 08 - Incidentes Unificados y Case Management]]
