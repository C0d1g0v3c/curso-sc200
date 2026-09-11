---
tags: [sc-200, concepto]
dominio: "Dominio 1 - Manage a security operations environment"
dia_origen: 5
---
# Automation levels

**Definicion:** Configuracion de un device group en MDE que determina que tan agresivamente actua la remediacion automatica (historicamente AIR de forma manual; desde el 1-sep-2026, la remediacion integrada en el antivirus por defecto) sobre evidencia maliciosa encontrada en esos dispositivos.

**Por que existe:** No todos los entornos toleran remediacion automatica sin aprobacion (por ejemplo servidores criticos de produccion); los niveles permiten graduar esa agresividad.

**Como funciona:** 5 niveles: Full (remedia todo automaticamente, recomendado), Semi - all folders (requiere aprobacion siempre), Semi - core folders (requiere aprobacion solo bajo \windows\*), Semi - non-temp folders (requiere aprobacion fuera de carpetas temporales conocidas), No automated response (no remedia nada). Las acciones pendientes de aprobacion expiran a los 7 dias (se tratan como rechazadas).

**Donde se configura / rol necesario:** Settings > Endpoints > Device groups, al crear o editar el device group. Requiere Security Administrator.

**Ejemplo:** Un archivo en `C:\Windows\Temp\` bajo nivel "core folders" requiere aprobacion (esta bajo windows\*); el mismo archivo bajo nivel "non-temp folders" se remediaria automaticamente (Temp es carpeta temporal reconocida).

**Trampa de examen:** El examen confunde "core folders" con "non-temp folders" usando rutas con la palabra Temp; el criterio real depende del nivel exacto mencionado en el enunciado, no de la palabra Temp en si.

## Lecciones donde aparece
- [[Dia 05 - Configuracion Avanzada de MDE ASR Rules Advanced Features Device Groups y Custom Data Collection]]
- [[Dia 06 - AIR Attack Disruption Automation Rules y Playbooks]]
