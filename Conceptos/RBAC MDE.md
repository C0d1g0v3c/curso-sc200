---
tags: [sc-200, concepto]
dominio: "Dominio 2 — Respond to security incidents (35-40%)"
dia_origen: 9
---
# RBAC MDE

**Definición:** RBAC (Role-Based Access Control) clásico de Microsoft Defender for Endpoint: sistema de roles custom configurables en Settings → Endpoints → Roles, donde cada rol combina permisos independientes.

**Por qué existe:** en un SOC real no todos los analistas deben tener permiso para las acciones más invasivas (contener, aislar); el RBAC granular aplica el principio de "acción mínima necesaria" — un analista puede recolectar evidencia sin poder cortar la red.

**Cómo funciona:** los permisos son independientes entre sí: View data (Security Operations) = solo lectura; Active remediation actions = Isolate/Contain/Restrict app execution + gestión de indicadores; Alerts investigation = gestionar alertas, AV scan, Collect investigation package, tags; Manage portal system settings y Manage security settings in Security Center = configuración; Live response capabilities Basic/Advanced = shell remoto de solo lectura o control completo. Un rol se construye marcando combinaciones de estos permisos y asignándolo a un grupo de seguridad de Microsoft Entra.

**Dónde se configura / rol necesario:** Settings → Endpoints → Roles, requiere el rol Security Administrator para crear/editar/eliminar roles. Desde el 16-feb-2025, tenants nuevos usan por defecto el Unified RBAC (URBAC) de Defender XDR en vez de este modelo clásico; los tenants existentes conservan sus roles clásicos.

**Ejemplo:** un analista con "Alerts investigation" pero sin "Active remediation actions" puede recolectar un investigation package pero no puede aislar el dispositivo.

**Trampa de examen:** tener un permiso no implica tener los otros — son independientes. El examen suele probar exactamente esta independencia con escenarios de "¿qué SÍ puede hacer este analista?".

## Lecciones donde aparece
- [[Dia 09 - Respuesta MDE Timeline Live Response y Evidencia]]
