---
tags: [sc-200, workbooks, soc-optimization, rbac, roles-sentinel, email-notifications, alert-tuning, repaso-rapido, leccion-diaria]
dia: 7
tipo: Repaso rápido
fecha_creacion: 2026-08-24
dominio: "Dominio 1 — Manage a security operations environment (40-45%)"
relacionado: "[[Dia 07 - Workbooks SOC Optimization Roles de Sentinel y Notificaciones]]"
---

# 🎴 Repaso rápido — Día 7: Workbooks, SOC optimization, Roles de Sentinel y Notificaciones

> [!info] Para qué sirve esta nota
> El Día 7 mete **tres objetivos distintos del temario en una sola lección** (workbooks + SOC optimization, roles de Sentinel, notificaciones + alert tuning) — es, con diferencia, el día más denso del Dominio 1. Esta nota **no repite la lección completa**: la condensa en formato pregunta-respuesta para repasar rápido, y sirve como fuente para generar el Audio Overview de repaso en NotebookLM (ver [[PLAN_MAESTRO_MULTITRACK]] §7.4/§7.7). Para el detalle completo, con ejemplos y razonamiento, la fuente sigue siendo [[Dia 07 - Workbooks SOC Optimization Roles de Sentinel y Notificaciones]].
>
> **Dato que justifica repasar esto en concreto:** el quiz del Día 7 se retesteó el 9-ago (11 días después de la lección) y bajó de aprobado a **3/5**. Los dos fallos —P1 y P5— van marcados abajo como **refuerzo dirigido**, no como contenido genérico.

---

## 🔴 Refuerzo dirigido — los dos puntos que ya fallaron

### P1 — Workbooks: el rol que falta

**P:** Un analista con el rol **Microsoft Sentinel Contributor** sobre el resource group del workspace intenta crear un workbook nuevo y no puede guardarlo. ¿Qué le falta?

**R:** El rol **Workbook Contributor**, sobre el mismo resource group, **además** del rol de Sentinel. Crear o eliminar workbooks exige la **combinación de los dos roles** — ninguno de los dos solo alcanza. Ver un workbook necesita como mínimo Workbook Reader; editarlo, Workbook Contributor; crearlo o borrarlo, un rol de Sentinel **y** Workbook Contributor a la vez.

**Por qué se falla esto:** el reflejo natural es pensar "Contributor" ya es "el rol más alto", así que debería bastar. No alcanza porque un workbook es un recurso de Azure aparte (como una VM o una cuenta de almacenamiento), y los roles de Sentinel no cubren automáticamente los recursos de Azure Monitor sobre los que están construidos los workbooks.

### P5 — Notificaciones: la ruta correcta según el tipo

**P:** Estás en **Settings → Endpoints → General → Email notifications** configurando avisos de incidentes de severidad alta. ¿Es la rama correcta del portal?

**R:** No. Esa ruta es la de **notificaciones de vulnerabilidades** (Defender Vulnerability Management). Las notificaciones de **incidentes** viven en **Settings → Microsoft Defender XDR → Email notifications → pestaña Incidents**.

**Regla mental para no confundirlas:** *Incidentes* → rama **Microsoft Defender XDR**. *Vulnerabilidades* → rama **Endpoints**. Son dos objetivos de temario distintos, configurados en dos sitios distintos del mismo portal — el examen las usa como par-trampa a propósito.

---

## 🟢 Workbooks — lo esencial en 6 flashcards

1. **P: ¿Qué es un workbook?** R: Un informe visual interactivo construido sobre Azure Monitor workbooks — bloques de texto, gráficas y tablas que ejecutan consultas KQL cada vez que abres o refrescas la página.
2. **P: ¿Qué se guarda exactamente al guardar un workbook?** R: Solo el JSON con la definición (qué consultas corre, qué dibuja). Nunca se duplican datos ni se consume almacenamiento de ingesta — los datos siguen viviendo en las tablas del workspace.
3. **P: ¿Qué revisar antes de guardar un workbook desde plantilla?** R: El campo `Required data types` — si no tienes esa tabla ingerida, el workbook se abre vacío.
4. **P: ¿Qué hace `Save as`?** R: Clona el workbook con otro nombre, en la misma suscripción y resource group. Aparece en "My workbooks".
5. **P: ¿Qué pasa con el auto refresh al cerrar el workbook?** R: Se desactiva solo — hay que reactivarlo cada vez que lo abres de nuevo. También se pausa mientras editas.
6. **P: ¿Cuál es el verbo delator de workbook vs playbook vs analytics rule vs hunting query?** R: Workbook = "visualizar/reporte/dashboard". Playbook = "ejecutar una acción/automatizar". Analytics rule = "detectar/generar alerta". Hunting query = "buscar/investigar sin generar alertas". Regla mental: workbook = ojos, playbook = manos, analytics rule = alarma, hunting query = linterna.

## 🟡 SOC optimization — lo esencial en 5 flashcards

7. **P: ¿Cuáles son los 4 tipos de recomendación de SOC optimization?** R: Data value (coste/valor del dato), Coverage-based (huecos de detección — incluye threat-based, AI MITRE tagging en preview, y risk-based en preview), y Similar organizations (qué ingieren organizaciones parecidas a la tuya).
8. **P: ¿Qué tablas mira Data value optimization?** R: Solo tablas **facturables** con ingesta en los **últimos 30 días**. Nunca toca tablas usadas por **UEBA** o por una regla de matching de **threat intelligence**, aunque parezcan poco usadas.
9. **P: ¿Diferencia entre threat-based y risk-based recommendations?** R: Threat-based razona desde el ataque ("¿estoy cubierto contra ransomware?"). Risk-based razona desde el daño de negocio (operacional, financiero, reputacional, cumplimiento, legal).
10. **P: ¿Qué hace la recomendación de Similar organizations?** R: Usa machine learning para sugerir tablas que no tienes pero sí usan organizaciones de perfil parecido al tuyo. Más frecuente en SOCs jóvenes/en onboarding. Nunca accede al contenido de tus logs, solo a metadatos.
11. **P: ¿Qué exige la documentación antes de tocar un plan de ingesta por una recomendación de SOC optimization?** R: Confirmar que la tabla no se está reteniendo por cumplimiento normativo u otra obligación legal — que no aparezca en detecciones no significa que se pueda apagar sin más.

## 🔵 Roles de Sentinel — lo esencial en 6 flashcards

12. **P: ¿Los 5 roles integrados de Sentinel?** R: Reader (ver), Responder (ver + gestionar incidentes), Contributor (+ instalar soluciones y crear/editar recursos), Playbook Operator (ejecutar playbooks), Automation Contributor (permite que Sentinel añada playbooks a automation rules — no se asigna a cuentas de usuario).
13. **P: ¿Qué rol crea o edita playbooks?** R: **Ninguno de Sentinel.** Hace falta **Logic App Contributor** (rol de Azure Logic Apps) — recuerda: un playbook ES una Logic App.
14. **P: ¿Sentinel Contributor puede ejecutar playbooks?** R: No. Ejecutarlos requiere **Playbook Operator** (o Logic App Contributor). Ser el rol "más alto" de Sentinel no incluye automatización.
15. **P: ¿Dónde se recomienda asignar los roles de Sentinel?** R: Sobre el **resource group** que contiene el workspace — así cubres de una vez las Logic Apps, playbooks y workbooks que viven ahí, sin mantener asignaciones sueltas.
16. **P: ¿Qué necesita la cuenta de servicio de Sentinel para que una automation rule ejecute un playbook en otro resource group?** R: Permisos explícitos (rol **Microsoft Sentinel Automation Contributor**) sobre el **resource group del playbook** — tu cuenta necesita ser Owner para otorgarlos. Consecuencia: cualquier automation rule podrá ejecutar cualquier playbook de ese resource group después.
17. **P: ¿Las asignaciones de rol son acumulativas o se sobreescriben?** R: Acumulativas. Un usuario con Reader y Contributor tiene los permisos de Contributor. Quitar acceso exige quitar la asignación, no añadir un rol más restrictivo encima.

## 🟣 Notificaciones y alert tuning — lo esencial en 7 flashcards

18. **P: ¿Ruta de notificaciones de incidentes?** R: Settings → **Microsoft Defender XDR** → Email notifications → pestaña **Incidents**.
19. **P: ¿Ruta de notificaciones de vulnerabilidades?** R: Settings → **Endpoints** → General → Email notifications → **Vulnerabilities**.
20. **P: ¿Qué pasa con un destinatario añadido después de crear la regla de notificación?** R: Empieza a recibir avisos desde ese momento — **no** recibe los incidentes anteriores.
21. **P: ¿Las 3 acciones de alert tuning?** R: **Hide alert** (suprime e impide el incidente; solo Defender for Endpoint; el dato sigue en `AlertInfo`/`AlertEvidence`). **Resolve alert** (alerta e incidente se generan ya resueltos; sin restricción de producto). **Set as behavior** (pasa a `BehaviorInfo`/`BehaviorEntities`, no genera alerta ni incidente; no soportada en Defender for Cloud ni Defender for Office 365).
22. **P: ¿Alert tuning funciona con custom detections?** R: No. Si una custom detection da falsos positivos, hay que afinar la propia detección, no suprimirla con alert tuning.
23. **P: ¿`SecurityAlert` o `SecurityIncident`?** R: Alerta individual de cualquier producto → `SecurityAlert`. Incidente correlacionado por Sentinel (varias alertas juntas) → `SecurityIncident`, y esta última guarda una fila **por actualización** — usa `summarize arg_max(LastModifiedTime, *) by IncidentNumber` para el estado final.
24. **P: ¿Diferencia entre clasificar una alerta como "Informational, expected activity" vs "False positive"?** R: La primera es una alerta **correcta** sobre actividad **benigna** (pruebas de seguridad, red team) — la quieres seguir viendo por si mañana la dispara un atacante real. La segunda es una alerta **incorrecta**, una falsa alarma que no quieres volver a ver.

---

## 🧠 Los 4 pares-trampa del Día 7, en una frase cada uno

1. **Workbook ≠ Playbook** — visualizar vs ejecutar acción.
2. **Rol de Sentinel solo ≠ Rol de Sentinel + Workbook Contributor** — crear workbooks exige los dos.
3. **Notificaciones de incidentes (Defender XDR) ≠ Notificaciones de vulnerabilidades (Endpoints)** — dos ramas del portal, dos objetivos de temario.
4. **`SecurityAlert` (alerta suelta) ≠ `SecurityIncident` (caso correlacionado)** — ya falló dos veces en este curso.

---

*Fuente completa: [[Dia 07 - Workbooks SOC Optimization Roles de Sentinel y Notificaciones]]. Relacionado: [[PLAN_MAESTRO_MULTITRACK]], [[TRACKER_TUTOR]], [[REPASO_RAPIDO_Errores_Simulacro]].*
