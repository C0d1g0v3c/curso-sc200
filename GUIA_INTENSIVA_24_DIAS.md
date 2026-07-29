---
title: Guía Intensiva 24 Días — SC-200 (Temario Julio 2026)
date: 2026-07-06
tags: [sc-200, certificacion, microsoft, sentinel, defender-xdr, defender-for-cloud, kql, plan-estudio, hunting]
tipo: Plan de Estudio
estado: 🟢 Activo
relacionado: "[[00_INDEX_SC200]], [[PLAN_INTENSIVO_4SEMANAS]], [[CHEATSHEET_KQL]], [[CONCEPTOS_CLAVE]], [[00_INDEX_Coursera_SC200]]"
---

# 🚀 Guía Intensiva 24 Días — SC-200: Microsoft Security Operations Analyst

> **Idea central:** Plan día a día alineado al **temario oficial vigente**, que integra tus notas del vault, los huecos detectados y recursos gratuitos con labs concretos. Meta: 700+/1000.
>
> 🔄 **Calendario reanclado el 13-jul-2026:** el plan empezó el 7-jul pero se acumuló un desfase de calendario (no de temario). Se reancló para que **ayer 12-jul = Día 3** y **hoy 13-jul = Día 4**; el resto de días corre en fechas consecutivas hasta el **2 de agosto 2026**. No se saltó ningún tema — solo se corrieron las fechas. Las fechas reales de estudio de los Días 1–4 (7–13 jul) están en `TRACKER_TUTOR.md`.

---

## ⚠️ ALERTA CRÍTICA — El temario cambió (y vuelve a cambiar el 28 de julio)

Tu [[PLAN_INTENSIVO_4SEMANAS]] y parte de [[00_INDEX_SC200]] usan el outline **viejo** (Defender XDR 25–30% / Sentinel 50–55% / Purview 15–20%). **Ese outline ya no existe.** Desde abril 2026 el examen se organiza por **funciones del analista**, no por productos, y el **28 de julio 2026** entra una actualización menor que añade explícitamente: Sentinel **data lake**, **KQL jobs**, **Summary rules**, **Sentinel Graph**, **Sentinel MCP Server**, **case management** y **agentic AI / Copilot embebido**.

### Temario oficial vigente (verificado 2026-07-06 en Microsoft Learn)

| Dominio oficial                                 | Peso       | Qué contiene (productos)                                                                                                                                                                                                                                              |
| ----------------------------------------------- | ---------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **1. Manage a security operations environment** | **40–45%** | Automatización XDR+Sentinel, config MDE (ASR, device groups), plataforma Sentinel (roles, retención/tiers, workbooks, SOC optimization), ingestión (AMA, DCR, WEF, CEF/Syslog, TI, custom tables), detecciones (analytics rules, custom detections, anomalías, MITRE) |
| **2. Respond to security incidents**            | **35–40%** | Respuesta en XDR (MDO, Purview, **MDC workload protections**, MDCA, Entra ID, MDI, Sentinel, Copilot embebido, case management), respuesta en MDE (timeline, live response, attack disruption), investigación M365 (Purview Audit, eDiscovery, Graph activity logs)   |
| **3. Perform threat hunting**                   | **20–25%** | KQL + Advanced Hunting, threat analytics, hunting graphs/blast radius, Sentinel Graph, hunting queries, KQL jobs en data lake, Summary rules, Notebooks + MCP Server                                                                                                  |

> [!warning] Implicaciones para ti
> - **Security Copilot como producto a configurar fue ELIMINADO** → tu [[Modulo_6_Security_Copilot]] solo es relevante en su parte de "experiencia embebida" para investigar incidentes.
> - **Purview DLP / Insider Risk / Communication Compliance ya no son un dominio** → lo que se evalúa ahora es **investigar** con Purview Audit, eDiscovery Content search y Graph activity logs. No dediques 3 días a Purview como decía el plan viejo.
> - **Defender for Cloud sigue** pero como sub-skill de respuesta (workload protections), no como dominio completo.
> - Si presentas el examen **después del 28 de julio** (recomendado por tu calendario), te tocan los temas nuevos de plataforma Sentinel (data lake, Graph, MCP). Esta guía ya los cubre.

### Fechas clave

| Evento | Fecha |
|---|---|
| Inicio real del plan | Lun 7 julio 2026 |
| **Reanclaje #2 del calendario (29 jul)** | **Hoy 29 jul = Día 7** — ver §2 |
| Fin del plan (Día 24) | Lun 17 agosto 2026 |
| Actualización del examen (temario nuevo) | **28 julio 2026 — YA VIGENTE** (verificado 29-jul) |
| Colchón de refuerzo y simulacros | 18–28 agosto 2026 (11 días) |
| **Examen agendado** | **Sáb 29 agosto 2026** (reprogramable +24 h) |
| Voucher AI Skills Fest vence | 18 agosto 2026 |

---

## 📋 1. Mapeo: Temario oficial vs tus notas de Obsidian

Leyenda: ✅ [Cubierto] · 🟡 [Parcial] · ❌ [Falta]

> [!success] Actualizado el 29-jul-2026 tras cerrar el Dominio 1
> Los estados de abajo reflejan lo **realmente impartido en las lecciones diarias de los Días 1–7**, no solo lo que existía en las notas viejas del vault. La columna "Nota del vault" apunta ahora a la lección diaria cuando esta sustituye o amplía a la nota antigua. Verificado además contra el skills outline oficial **"as of July 28, 2026"**.

### Dominio 1 — Manage a security operations environment (40–45%) — ✅ CERRADO

| Skill oficial | Estado | Nota del vault | Hueco |
|---|---|---|---|
| Notificaciones de email en XDR (incidents, actions, threat analytics) | ✅ | [[Dia 07 - Workbooks SOC Optimization Roles de Sentinel y Notificaciones]] §4 | — |
| Notificaciones de alertas en XDR (**tuning, suppression, correlación**) | ✅ | [[Dia 07 - Workbooks SOC Optimization Roles de Sentinel y Notificaciones]] §5 | — |
| MDE advanced features y rules settings | ✅ | [[Dia 05 - Configuracion Avanzada de MDE ASR Rules Advanced Features Device Groups y Custom Data Collection]] | — |
| Custom data collection en MDE | ✅ | [[Dia 05 - Configuracion Avanzada de MDE ASR Rules Advanced Features Device Groups y Custom Data Collection]] | Sigue en prerelease — vigilar cambios |
| Políticas de seguridad MDE + **ASR rules** | ✅ | [[Dia 05 - Configuracion Avanzada de MDE ASR Rules Advanced Features Device Groups y Custom Data Collection]] | — |
| AIR (automated investigation & response) | ✅❗ | [[Dia 06 - AIR Attack Disruption Automation Rules y Playbooks]] | ⚠️ **AIR se retira en MDE el 1-sep-2026** (no en MDO). El examen del 29-ago es ANTES del cambio → el modelo de automation levels sigue siendo examinable |
| **Automatic attack disruption** | ✅ | [[Dia 06 - AIR Attack Disruption Automation Rules y Playbooks]] | — |
| Device groups, permisos, automation levels | ✅ | [[Dia 05 - Configuracion Avanzada de MDE ASR Rules Advanced Features Device Groups y Custom Data Collection]] | — |
| Automation rules en Sentinel | ✅ | [[Dia 06 - AIR Attack Disruption Automation Rules y Playbooks]] | — |
| Playbooks (Logic Apps) | ✅ | [[Dia 06 - AIR Attack Disruption Automation Rules y Playbooks]] | — |
| **Specify Microsoft Sentinel roles** | ✅ | [[Dia 07 - Workbooks SOC Optimization Roles de Sentinel y Notificaciones]] §3 | ❗ Este objetivo **no estaba asignado a ningún día** hasta el 29-jul. La tabla RBAC de [[04_Semana4_Simulacros]] está incompleta — usar la de la lección del Día 7 |
| **Retención y tiers: Analytics, Data lake, XDR** | ✅ | [[Dia 01 - Arquitectura Sentinel y Tiers de Retencion]] | ⚠️ [[Modulo_4_Unified_SecOps_Exposure]] §8.1 sigue usando los nombres viejos **Basic/Auxiliary** — el modelo vigente es Analytics tier + **Data lake tier** + XDR default (30 días) |
| Workbooks | ✅ | [[Dia 07 - Workbooks SOC Optimization Roles de Sentinel y Notificaciones]] §1 | — |
| **SOC optimization** | ✅ | [[Dia 07 - Workbooks SOC Optimization Roles de Sentinel y Notificaciones]] §2 | Ampliado: además de data value y coverage/threat-based, existen **AI MITRE ATT&CK tagging (Preview)**, **risk-based (Preview)** y **similar organizations** |
| Connectors (selección por fuente) | ✅ | [[Dia 02 - Ingestion 1 AMA DCR Windows Security Events y WEF]] | — |
| Windows Security Events via AMA + DCR | ✅ | [[Dia 02 - Ingestion 1 AMA DCR Windows Security Events y WEF]] | — |
| **Windows Event Forwarding (WEF)** | ✅ | [[Dia 02 - Ingestion 1 AMA DCR Windows Security Events y WEF]] | — |
| Syslog/CEF via AMA | ✅ | [[Dia 03 - Ingestion 2 Syslog CEF Azure Activity TI y Tablas Custom]] | — |
| Azure activities vía Azure Policy / diagnostic settings | ✅ | [[Dia 03 - Ingestion 2 Syslog CEF Azure Activity TI y Tablas Custom]] | — |
| Ingestión de threat indicators (TI) | ✅ | [[Dia 03 - Ingestion 2 Syslog CEF Azure Activity TI y Tablas Custom]] | ⚠️ Nombre de tabla actualizado: el destino ya no es `ThreatIntelligenceIndicator` sino **`ThreatIntelIndicators` / `ThreatIntelObjects`** |
| **Custom log tables** | ✅ | [[Dia 03 - Ingestion 2 Syslog CEF Azure Activity TI y Tablas Custom]] | — |
| Custom detection rules (Advanced Hunting XDR) — crear y **gestionar** | 🟡 | [[Modulo_1_Defender_XDR]] | **Desplazado a propósito al Día 15** (requiere soltura previa con KQL). Ojo con las columnas obligatorias: `ReportId` + `Timestamp`, no `AlertId` |
| Analytics rules (scheduled, NRT, TI, machine learning) | ✅ | [[Dia 04 - Detecciones Sentinel Analytics Rules y Anomalias]] | ⚠️ El outline **ya no nombra "Fusion"**, dice "machine learning" — estudiar el concepto por función, no por nombre comercial |
| Cobertura MITRE ATT&CK | ✅ | [[Dia 04 - Detecciones Sentinel Analytics Rules y Anomalias]] | — |
| **Anomalías en Sentinel (anomaly rules)** | ✅ | [[Dia 04 - Detecciones Sentinel Analytics Rules y Anomalias]] | — |

### Dominio 2 — Respond to security incidents (35–40%)

| Skill oficial | Estado | Nota del vault | Hueco |
|---|---|---|---|
| MDO: investigar/remediar (incl. attack disruption) | 🟡 | [[Modulo_4_Unified_SecOps_Exposure]] §5, [[03_Semana3_Defender_XDR]] §3 | Falta: ZAP, remediar con Threat Explorer (soft/hard delete) |
| Purview: entidades comprometidas | ❌ | [[PLAN_INTENSIVO_4SEMANAS]] S4 cubre el scope VIEJO (DLP/IRM) | Reorientar a investigación de alertas Purview en XDR |
| **MDC workload protections: investigar/remediar** | ✅ | [[Modulo_4_Unified_SecOps_Exposure]] §3 (planes, CSPM/CWPP) | Practicar sample alerts |
| MDCA: riesgos de seguridad | ✅ | [[Modulo_4_Unified_SecOps_Exposure]] §4 | — |
| Entra ID: identidades comprometidas | ✅ | [[Modulo_4_Unified_SecOps_Exposure]] §6 | — |
| MDI: alertas de identidad | ✅ | [[03_Semana3_Defender_XDR]] §2 (tabla de ataques) | — |
| Sentinel: incidents (investigar/remediar) | ✅ | [[01_Semana1_Sentinel_Fundamentos]], [[Modulo_3_Sentinel]] | — |
| **Agentic AI / Security Copilot embebido** | 🟡 | [[Modulo_6_Security_Copilot]] | Reenfocar: solo experiencia embebida (incident summary, guided response, KQL desde lenguaje natural) |
| Ataques complejos (multi-stage, lateral movement) | ✅ | [[CONCEPTOS_CLAVE]] §1, [[03_Semana3_Defender_XDR]] | — |
| **Case management** | ❌ | — | Nuevo: casos en Defender portal, tareas, evidencia, vínculo con incidents |
| MDE: device timeline | ✅ | [[03_Semana3_Defender_XDR]] §1 | — |
| MDE: live response + investigation package | ✅ | [[03_Semana3_Defender_XDR]] §1 | — |
| MDE: evidence & entity investigation | 🟡 | [[Modulo_2_Defender_for_Endpoint]] | Falta: file/user/IP page, verdicts de evidencia |
| **Purview Audit (investigar amenazas)** | ❌ | — | Audit Standard vs Premium, búsquedas de actividad |
| **eDiscovery Content search** | ❌ | — | Búsqueda de contenido para investigación |
| **Microsoft Graph activity logs** | ❌ | — | Tabla MicrosoftGraphActivityLogs, detección de abuso de API |

### Dominio 3 — Perform threat hunting (20–25%)

| Skill oficial | Estado | Nota del vault | Hueco |
|---|---|---|---|
| Elegir la tabla correcta para cada KQL | ✅ | [[CHEATSHEET_KQL]], [[02_Semana2_KQL_Labs]] | — |
| KQL para identificar amenazas | ✅ | [[02_Semana2_KQL_Labs]], [[PLAN_INTENSIVO_4SEMANAS]] (7 queries) | — |
| Advanced Hunting queries | ✅ | [[Modulo_1_Defender_XDR]], [[CHEATSHEET_KQL]] | — |
| Interpretar threat analytics en XDR | 🟡 | [[Modulo_1_Defender_XDR]] | Falta: secciones del informe (analyst report, related incidents, exposure) |
| **Hunting graphs / blast radius** | ❌ | — | Nuevo julio 2026 |
| **Sentinel Graph (relaciones entre entidades)** | ❌ | — | Nuevo julio 2026 |
| Hunting queries (crear/monitorizar) | ✅ | [[Modulo_5_Threat_Hunting]] §3 | — |
| **KQL jobs en Data lake** | ❌ | — | Nuevo julio 2026 |
| **Summary rule tables** | ❌ | — | Nuevo julio 2026 |
| Notebooks + **Sentinel MCP Server** | 🟡 | [[Modulo_5_Threat_Hunting]] §5 (Notebooks/MSTICPy) | Falta MCP Server |

> [!important] Resumen del gap analysis — actualizado 29-jul-2026
> **Tu base es sólida** en: Sentinel core (connectors, analytics rules, playbooks, RBAC), KQL, hunting clásico, Defender XDR (MDE/MDI/MDO/MDCA), MDC y Entra ID.
>
> **Ya cerrados** (Días 1–7): attack disruption, WEF, custom log tables, custom data collection en MDE, roles de Sentinel, alert tuning/suppression/correlación, email notifications, workbooks y SOC optimization.
>
> **Siguen ❌ pendientes, todos de las actualizaciones abril–julio 2026:** case management (Día 8), Purview Audit, eDiscovery y Graph activity logs (Día 13), hunting graphs/blast radius y Sentinel Graph (Día 15), KQL jobs/data lake, Summary rules y MCP Server (Día 17). **Estos son exactamente los temas donde el simulacro del 23-jul concentró 7 de ~24 fallos** — no por hueco conceptual, sino porque el plan aún no los había impartido.

---

## 📅 2. Cronograma de 24 días

**Ritmo:** 4 h/día entre semana (2 h teoría + 2 h lab) · 5 h sáb/dom. Total ≈ 100 h.

### 🔄 Reanclaje #2 del calendario (29 julio 2026) — CALENDARIO VIGENTE

El reanclaje del 13-jul quedó obsoleto: por contenido se avanzó más despacio que por fecha. Situación real al 29-jul: **Días 1–6 impartidos y con quiz aprobado**; pendientes los **labs prácticos de los Días 4, 5 y 6**. Quedan **18 lecciones (Días 7–24) y 31 días hasta el examen** (Sáb 29-ago).

**Diseño del nuevo calendario:** las lecciones corren consecutivas, con **tres días de recuperación (R1, R2, R3)** intercalados en fin de semana para saldar los labs atrasados sin acumular más deuda —que es exactamente lo que produjo el atraso anterior— y un **colchón final de 11 días** de refuerzo y simulacros. El colchón no es tiempo muerto: el Practice Assessment del 23-jul dio **46 %** contra una meta de 80 %, así que ese margen es necesario.

| Fecha | Día del plan | Tema |
|---|---|---|
| **Mié 29 jul** | **Día 7** | Workbooks + SOC optimization + roles de Sentinel + notificaciones + alert tuning · **cierra Dominio 1** |
| Jue 30 jul | Día 8 | Incidentes unificados + case management |
| Vie 31 jul | Día 9 | Respuesta MDE: timeline, live response, evidence |
| **Sáb 1 ago** | **R1 — Recuperación** | Labs atrasados de los **Días 4 y 5** (Scheduled rule + Anomalies + blade MITRE · ASR + advanced features + device group con automation level) |
| Dom 2 ago | Día 10 | MDO (Threat Explorer, ZAP) + MDCA |
| Lun 3 ago | Día 11 | Identidades: Entra ID Protection + MDI |
| Mar 4 ago | Día 12 | Defender for Cloud workload protections |
| Mié 5 ago | Día 13 | Purview Audit, eDiscovery, Graph activity logs + Copilot embebido · **cierra Dominio 2** |
| Jue 6 ago | Día 14 | KQL total: repaso + drill "¿qué tabla uso para X?" |
| Vie 7 ago | Día 15 | Advanced Hunting + custom detections + threat analytics + hunting graphs / Sentinel Graph |
| **Sáb 8 ago** | **R2 — Recuperación** | Lab atrasado del **Día 6** (automation rule + playbook + permisos + Attack Disruption settings) **+ Simulacro #2** (Practice Assessment, sin presión de tiempo) |
| Dom 9 ago | Día 16 | Hunting en Sentinel: queries, bookmarks, livestream, hunts |
| Lun 10 ago | Día 17 | Data lake, KQL jobs, Summary rules, Notebooks + MCP Server |
| Mar 11 ago | Día 18 | KQL avanzado gamificado · **cierra Dominio 3** |
| Mié 12 ago | Día 19 | Lab integral end-to-end |
| Jue 13 ago | Día 20 | Refuerzo dirigido sobre los fallos del Simulacro #2 |
| Vie 14 ago | Día 21 | Repaso Dominio 1 + Dominio 2 completos |
| **Sáb 15 ago** | **Día 22** | **Simulacro #3** — meta >80 % |
| Dom 16 ago | Día 23 | Flashcards + trampas + logística (verificar cita Pearson VUE) |
| Lun 17 ago | Día 24 | Repaso ligero + [exam sandbox](https://aka.ms/examdemo) · **fin del plan de 24 días** |
| **Mar 18 ago** | **R3 — Colchón** | ⚠️ **Vence el voucher AI Skills Fest** — la cita ya está agendada, solo verificar |
| Mié 19 – Vie 21 ago | Colchón | Refuerzo de las áreas <70 % del Simulacro #3 |
| Sáb 22 ago | Colchón | **Simulacro #4** — meta >85 % |
| Dom 23 – Mar 25 ago | Colchón | Repaso de los 5 temas de plataforma nuevos (data lake, KQL jobs, summary rules, Sentinel Graph, MCP Server) |
| Mié 26 – Jue 27 ago | Colchón | Bloques débiles medidos: **MDE response** (timeline vs advanced hunting vs live response vs isolate vs investigation package) y **Purview Audit/eDiscovery** |
| Vie 28 ago | Víspera | Solo flashcards y trampas. Nada nuevo. Dormir 7+ h |
| **Sáb 29 ago** | **EXAMEN** | SC-200 |

> [!warning] Punto de decisión
> Si el **Simulacro #3 del 15-ago** queda por debajo del 70 %, la opción sensata es **reprogramar el examen** (gratis con más de 24 h de anticipación) hacia la primera semana de septiembre y usar el colchón para una segunda pasada completa de los dominios flojos. El límite duro del voucher para la **fecha de examen** es el **30 de octubre de 2026**, así que hay margen real.

> [!note] Las columnas "Fecha" de las tablas de fases que siguen son del anclaje ANTIGUO
> Se conservan por trazabilidad histórica. **La tabla de arriba es la vigente.** El detalle de objetivos y labs de cada día sigue siendo válido en las tablas de fase.

### Fase 1 — Dominio 1: Manage SecOps environment (Días 1–7, 40–45% del examen)

| Día | Fecha | Tema | Objetivo concreto del día | Lab / práctica |
|---|---|---|---|---|
| 1 | Jue 10 jul | Setup + arquitectura Sentinel + retención | Leer study guide oficial completo; desplegar Azure free + Sentinel Training Lab; dominar tiers **Analytics / Data lake / XDR** y retención (90d analytics, hasta 12 años data lake) | Desplegar [Sentinel Training Lab](https://github.com/Azure/Azure-Sentinel/tree/master/Solutions/Training/Azure-Sentinel-Training-Lab) (módulos 1–2); actualizar [[Modulo_4_Unified_SecOps_Exposure]] §8.1 con el modelo de tiers vigente |
| 2 | Vie 11 jul | Ingestión 1: AMA, DCR, Windows Security Events, **WEF** | Explicar AMA vs MMA (retirado), crear una DCR con transformation KQL, entender cuándo usar WEF (equipos sin conectividad directa / colección centralizada) | Conectar VM Windows con "Windows Security Events via AMA"; crear DCR con filtro por EventID; crear nota nueva **[[WEF_y_DCR]]** |
| 3 | Sáb 12 jul | Ingestión 2: Syslog/CEF, Azure Activity, TI, **custom tables** | Configurar CEF via AMA; forzar diagnostic settings con Azure Policy; ingerir TI (STIX/TAXII + upload API → tabla `ThreatIntelligenceIndicator`); crear tabla custom `_CL` | Training Lab módulo de connectors; crear custom log table con la ingestion API (DCR-based) |
| 4 | Dom 13 jul | Detecciones Sentinel: analytics rules + anomalías | Crear Scheduled + NRT rule desde cero; saber límites NRT; configurar **anomaly rules** (customizable, tabla `Anomalies`); Fusion (ML, no editable); revisar cobertura en el blade MITRE | Training Lab módulo Analytics; repasar [[PLAN_INTENSIVO_4SEMANAS]] §KQL queries 1–3 |
| 5 | Lun 14 jul | Config MDE: **ASR rules**, advanced features, device groups, **custom data collection** | Saber los 3 modos ASR (audit/block/warn) y exclusiones; advanced features clave (tamper protection, EDR block mode, live response, custom network indicators); automation levels por device group | En trial XDR: crear device group con automation level "Full"; auditar ASR con KQL (ver §3.1); crear nota **[[MDE_Configuracion_Avanzada]]** |
| 6 | Mar 15 jul | Automatización: AIR, **attack disruption**, automation rules, playbooks | Distinguir AIR (investiga y remedia evidencia con verdicts) vs **attack disruption** (contiene device/usuario automáticamente en ataques en curso: BEC, ransomware, AiTM); crear automation rule + playbook y saber el orden de ejecución | Training Lab módulo SOAR: playbook "When incident is created" + automation rule que lo llama; crear nota **[[Attack_Disruption]]** |
| 7 | Mié 16 jul | Workbooks + SOC optimization + notificaciones + repaso Fase 1 | Crear workbook custom; revisar recomendaciones de **SOC optimization** (coverage/data value); configurar email notifications de incidents en XDR; mini-quiz de 15 preguntas del dominio 1 | Workbook desde plantilla; autoevaluación con [[04_Semana4_Simulacros]] |

### Fase 2 — Dominio 2: Respond to incidents (Días 8–13, 35–40%)

| Día | Fecha | Tema | Objetivo concreto del día | Lab / práctica |
|---|---|---|---|---|
| 8 | Jue 17 jul | Flujo unificado de incidentes + **case management** | Dominar Triage → Investigate → Respond ([[CONCEPTOS_CLAVE]] §3); investigation graph de Sentinel; **cases** en Defender portal: agrupar incidents, tareas, evidencia, asignación | Training Lab módulo Incidents; crear un case y vincular un incident; crear nota **[[Case_Management_XDR]]** |
| 9 | Vie 18 jul | Respuesta MDE: timeline, live response, evidence | Investigar device timeline; comandos live response (`getfile`, `run`, `remediate`); collect investigation package; file/user/device pages; remediar incidents de attack disruption (liberar contención) | Simulaciones de ataque del portal XDR (Endpoints > Tutorials, EICAR); [[03_Semana3_Defender_XDR]] labs 1–2 |
| 10 | Sáb 19 jul | MDO + MDCA | Threat Explorer: hunting de email, soft/hard delete, ZAP; attack disruption en BEC; MDCA: anomaly detections (impossible travel, mass download), OAuth apps, session policies | Threat Explorer en trial; revisar [[Modulo_4_Unified_SecOps_Exposure]] §4–5 |
| 11 | Dom 20 jul | Identidades: Entra ID Protection + MDI | User risk vs sign-in risk + políticas CA; confirm compromise / dismiss; MDI: Kerberoasting, Pass-the-Hash, DCSync, Golden Ticket (tabla en [[03_Semana3_Defender_XDR]] §2) | KQL sobre `AADRiskyUsers`, `IdentityLogonEvents`; remediation de usuario en Entra |
| 12 | Lun 21 jul | **Defender for Cloud workload protections** | Investigar/remediar alertas de MDC en el portal XDR; planes Defender (Servers, Storage, SQL, Containers, Key Vault…); JIT VM access; sample alerts | Generar **sample alerts** en MDC (gratis, sin atacar nada) y triarlas; [[Modulo_4_Unified_SecOps_Exposure]] §3 |
| 13 | Mar 22 jul | Investigación M365: **Purview Audit, eDiscovery, Graph activity logs** + Copilot embebido | Audit Standard vs Premium (retención 180d vs 1 año); Content search para investigar exfiltración por email/SharePoint; `MicrosoftGraphActivityLogs` para abuso de API; Copilot embebido: incident summary, guided responses, NL→KQL | Búsqueda en Purview Audit del trial; crear nota **[[Purview_Audit_eDiscovery_Investigacion]]**; mini-quiz dominio 2 |

### Fase 3 — Dominio 3: Threat hunting (Días 14–18, 20–25%)

| Día | Fecha | Tema | Objetivo concreto del día | Lab / práctica |
|---|---|---|---|---|
| 14 | Mié 23 jul | KQL total: repaso + tablas por escenario | Repasar [[CHEATSHEET_KQL]] y [[02_Semana2_KQL_Labs]] completos; drill "¿qué tabla uso para X?" (Device*, Email*, Identity*, CloudAppEvents, Signin, SecurityEvent, CommonSecurityLog) | 90 min en [KQL playground](https://aka.ms/lademo) sin notas; escribir de memoria las 7 queries de [[PLAN_INTENSIVO_4SEMANAS]] |
| 15 | Jue 24 jul | Advanced Hunting XDR + threat analytics + **hunting graphs / Sentinel Graph** | Crear custom detection desde Advanced Hunting (frecuencias y acciones); leer un informe de threat analytics (analyst report, related incidents, exposure); **hunting graph con blast radius** y análisis de relaciones con **Sentinel Graph** | Advanced Hunting en trial XDR; crear nota **[[Sentinel_Graph_y_Hunting_Graphs]]** |
| 16 | Vie 25 jul | Hunting en Sentinel: queries, bookmarks, livestream, hunts | Ciclo completo hipótesis → query → bookmark → incident/analytics rule ([[Modulo_5_Threat_Hunting]] §1–3); livestream vs NRT rule | Training Lab módulo Hunting; ejecutar 3 hunts con bookmarks |
| 17 | Sáb 26 jul | **Plataforma nueva: Data lake, KQL jobs, Summary rules, Notebooks + MCP Server** | Data lake tier: quién lo consulta y cómo; **KQL jobs** (one-time/scheduled sobre data lake → promueve resultados a analytics); **Summary rules** (agregan logs de alto volumen a tablas summary); Notebooks conectados al **Sentinel MCP Server** (agentes IA consultan el data lake) | Si el tenant lo permite: crear un KQL job y una summary rule; crear nota **[[Sentinel_DataLake_Jobs_SummaryRules]]** |
| 18 | Dom 27 jul | KQL avanzado gamificado + mini-quiz dominio 3 | Consolidar `join`, `make-series`, `arg_max`, `mv-expand`, `parse` con retos; queries de beaconing y anomalías de [[Modulo_5_Threat_Hunting]] §6 | [Kusto Detective Agency](https://detective.kusto.io) (1–2 casos) o [KC7](https://kc7cyber.com); mini-quiz |

### Fase 4 — Integración y diagnóstico (Días 19–21)

| Día | Fecha | Tema | Objetivo concreto del día | Lab / práctica |
|---|---|---|---|---|
| 19 | Lun 28 jul | Lab integral end-to-end · **hoy entra en vigor el temario nuevo** | Ciclo completo sin ayuda: ingestión → detección → incident → investigación → playbook → cierre + post-incident. **Hoy (28 jul) el examen adopta el temario nuevo** — repasar de reojo los 5 temas de plataforma (data lake, KQL jobs, summary rules, Sentinel Graph, MCP) | Training Lab módulos finales + simulación de ataque XDR |
| 20 | Mar 29 jul | **Simulacro #1: Practice Assessment oficial** | Hacer el [Practice Assessment gratuito](https://learn.microsoft.com/credentials/certifications/exams/sc-200/practice/assessment?assessment-type=practice&assessmentId=59) completo en condiciones de examen; registrar score y clasificar fallos por dominio | Mapa de calor de áreas débiles en [[04_Semana4_Simulacros]] |
| 21 | Mié 30 jul | Refuerzo dirigido | Estudiar SOLO las áreas <70% del simulacro; releer notas ❌/🟡 creadas en los días 2–17 | 2ª pasada de Exam Readiness Zone en las áreas débiles |

### Fase 5 — Repaso final y examen (Días 22–24)

| Día | Fecha | Tema | Objetivo concreto del día |
|---|---|---|---|
| 22 | Jue 31 jul | Simulacro #2 | Repetir Practice Assessment (las preguntas rotan) o simulacro de terceros; meta: **>80%**. El temario nuevo ya está vigente (desde el 28 jul) — verificar dominio de los 5 temas de plataforma (data lake, jobs, summary rules, Graph, MCP) |
| 23 | Vie 1 ago | Flashcards + trampas + logística | Sección §4 completa de esta nota; repasar [[CHEATSHEET_KQL]] y [[Chronicle_vs_Sentinel]]; **verificar la cita del examen** (ya agendado 29 ago) y requisitos Pearson VUE; queda margen de sobra para más simulacros hasta el examen |
| 24 | Sáb 2 ago | Repaso ligero + descanso | Solo flashcards y trampas (nada nuevo); probar el [exam sandbox](https://aka.ms/examdemo); dormir 7+ h |

---

## 📚 3. Guía por dominio: conceptos, notas, recursos y labs

### 3.1 Dominio 1 — Manage a security operations environment (40–45%)

#### Conceptos que más caen
- **Tiers de datos (modelo vigente 2026):** *Analytics tier* = query en tiempo real, retención interactiva 90 días incluida, para logs que alimentan detecciones. *Data lake tier* = bajo costo, retención hasta 12 años, se consulta con KQL jobs/notebooks (no en tiempo real). *XDR default* = 30 días en Advanced Hunting sin Sentinel. Regla mental: ¿alimenta alertas? → Analytics. ¿Solo compliance/hunting histórico? → Data lake.
- **AMA + DCR:** todo pasa por Data Collection Rules; las *transformations* KQL filtran ANTES de la ingestión = ahorro de costos. **WEF** cuando necesitas centralizar eventos de equipos sin agente directo (colector → AMA).
- **Analytics rules:** Scheduled (KQL periódico) · NRT (≤ ~1 min, con limitaciones: 1 tabla, sin joins complejos) · Microsoft security (promueve alertas de productos) · TI (matching con indicadores) · ML/Fusion (no editable) · **Anomalías** (customizables, alimentan la tabla `Anomalies`, no crean incidents por sí solas).
- **ASR rules:** audit / block / warn; se despliegan por Intune/GPO; se auditan con KQL (abajo). ⚠️ *Precisión añadida el 29-jul-2026:* **son DOS las reglas ASR que no soportan modo Warn** — *Block credential stealing from the Windows local security authority subsystem (LSASS)* y *Block Office applications from injecting code into other processes* — no una sola, como sugiere el flashcard genérico que circula en varias guías. Detalle completo en [[Dia 05 - Configuracion Avanzada de MDE ASR Rules Advanced Features Device Groups y Custom Data Collection]].
- **Custom detections (vigilar):** Microsoft Learn ya recomienda por banner las **custom detections de Defender XDR** como "la mejor forma de crear reglas nuevas" hacia adelante, unificando Sentinel + XDR. El temario del 28-jul mantiene separados los objetivos de analytics rules (Sentinel) y custom detection rules (XDR), pero conviene dominar ambos y saber cuándo el escenario pide uno u otro.
- **AIR vs Attack disruption:** AIR investiga alertas y propone/ejecuta remediación de evidencia según *automation level* del device group (verdicts: Malicious / Suspicious / No threats found). **Attack disruption** actúa a nivel de **incidente** (ataque en curso, confianza ≥99 %): contiene automáticamente, **aun con automation level bajo o nulo**, porque no depende del device group. ⚠️ **AIR se retira en Defender for Endpoint el 1-sep-2026** — deja de ser experiencia separada y de poder dispararse manualmente; queda absorbido en la protección antivirus por defecto. **Aplica solo a MDE: AIR en Defender for Office 365 sigue igual.** El examen del 29-ago es antes del cambio.
- **Acciones de Attack disruption (más amplias de lo que se creía):** *Contain device* y *Contain IP* (MDE) · *Isolate device* (MDE — distinta de Contain) · *Disable user* (MDI) · *Contain user* (MDE) · *Revoke user session* y *Suspend user* (Entra ID) · *OAuth app compromise* (MDCA) · preview de *AWS IAM deny policy* y *Suspend user in Okta* vía conectores de Sentinel. Categoría hermana preventiva: **Predictive shielding** (Safeboot hardening, GPO hardening, Proactive user containment).
- **Automation rules vs playbooks:** la automation rule es el orquestador (condiciones, orden, puede llamar playbooks); el playbook es la Logic App que ejecuta acciones. Para que una automation rule ejecute un playbook, la **cuenta de servicio de Sentinel** necesita permisos explícitos (**Microsoft Sentinel Automation Contributor**) sobre el **resource group** del playbook — no sobre el playbook individual. Consecuencia: una vez otorgados, **cualquier automation rule puede ejecutar cualquier playbook de ese resource group**.
- **Roles Sentinel** (corregido 29-jul-2026 — la versión anterior de esta línea era incorrecta): Reader (ver) · **Responder** (todo lo de Reader + gestionar incidents; NO editar reglas) · **Contributor** (todo lo de Responder + crear/editar recursos e instalar soluciones) · **Playbook Operator** (listar, ver y **ejecutar** playbooks) · **Automation Contributor** (permite que *Sentinel* añada playbooks a automation rules — **NO se asigna a cuentas de usuario y NO sirve para ejecutar playbooks a mano**). Ojo: **ningún rol de Sentinel crea o edita playbooks** → eso es **Logic App Contributor**. Y **crear workbooks exige un rol de Sentinel + Workbook Contributor**. Tabla completa en [[Dia 07 - Workbooks SOC Optimization Roles de Sentinel y Notificaciones]] §3 (la tabla de [[04_Semana4_Simulacros]] está incompleta).

📝 Notas del vault: [[01_Semana1_Sentinel_Fundamentos]], [[Modulo_3_Sentinel]], [[Modulo_4_Unified_SecOps_Exposure]] §7–8, [[00_INDEX_SC200]] §1.1–1.3

🆓 Recursos:
- [Exam Readiness Zone — Preparing for SC-200 (serie de 4 videos)](https://learn.microsoft.com/shows/exam-readiness-zone/preparing-for-sc-200-manage-a-security-operations-environment) — videos oficiales por dominio, con tips de cómo pregunta el examen. **El recurso #1 de esta guía.**
- [Learning path oficial SC-200T00](https://learn.microsoft.com/training/courses/sc-200t00) — módulos con sandbox gratis integrado.
- [Microsoft Sentinel Ninja Training](https://aka.ms/sentinelninja) — la ruta más completa de Sentinel, gratuita.

🧪 Lab principal: [labs oficiales SC-200T00A](https://microsoftlearning.github.io/SC-200T00A-Microsoft-Security-Operations-Analyst/) — actualizados el 29-jun-2026, con simulaciones interactivas que no siempre requieren tenant propio.

📍 **[[MAPA_DIARIO_LEARN_LABS]]** — mapa día por día que cruza cada día de este plan con su módulo de Microsoft Learn (teoría) y su lab SC-200T00A (práctica), con enlaces directos. **Consultar esta nota para saber qué Learn y qué lab tocan cada día.**

> [!warning] Sentinel Training Lab abandonado (verificado 6-jul-2026)
> El [Sentinel Training Lab](https://github.com/Azure/Azure-Sentinel/tree/master/Solutions/Training/Azure-Sentinel-Training-Lab) del Marketplace **no recibe cambios desde enero 2024**: es anterior al portal unificado de Defender y al modelo Analytics/Data lake, así que sus capturas y pasos ya no coinciden. **Donde esta guía diga "Training Lab módulo X", usar el learning path equivalente de SC-200T00A**: Setup/Connectors → "Configure your Microsoft Sentinel environment" y "Connect logs to Microsoft Sentinel"; Analytics → "Create detections and perform investigations"; SOAR/Incidents → mismos paths de detección e investigación; Hunting → "Perform threat hunting in Microsoft Sentinel". Sigue siendo útil solo como fuente de ~10 MB de datos de muestra baratos.

```kql
// Auditar actividad de reglas ASR (Día 5)
DeviceEvents
| where ActionType startswith "Asr"
| summarize Eventos = count(), Dispositivos = dcount(DeviceName)
    by ActionType, RuleId = tostring(AdditionalFields.RuleId)
| order by Eventos desc
```

```kql
// Verificar ingestión de threat indicators (Día 3)
ThreatIntelligenceIndicator
| where TimeGenerated > ago(7d)
| summarize count() by SourceSystem, ThreatType
| order by count_ desc
```

### 3.2 Dominio 2 — Respond to security incidents (35–40%)

#### Conceptos que más caen
- **Flujo del analista:** Triage (severidad, entidades) → Investigate (attack story, investigation graph, go hunt) → Respond (acciones de dispositivo/usuario/archivo) → Close (True/False Positive, Benign). Ver [[CONCEPTOS_CLAVE]] §3.
- **Case management (nuevo):** los *cases* del portal Defender agrupan múltiples incidents, tareas asignables y evidencia para investigaciones largas; el incident sigue siendo la unidad de correlación automática.
- **MDE response:** Isolate device (contener manteniendo conexión con MDE) · Restrict app execution · Collect investigation package (forense) · Live response (shell remoto; `getfile`, `run`, scripts). Attack disruption produce dispositivos "contained" y usuarios deshabilitados que TÚ liberas al remediar.
- **MDO:** Threat Explorer (P2) para hunting de email + acciones (soft delete, hard delete, move to junk); ZAP remueve mensajes ya entregados; attack disruption interrumpe BEC/AiTM.
- **Entra ID Protection:** user risk (cuenta comprometida → password change + MFA) vs sign-in risk (login sospechoso → MFA). La acción vive en Conditional Access. Ver [[Modulo_4_Unified_SecOps_Exposure]] §6.
- **MDI:** memoriza la tabla ataque→detección de [[03_Semana3_Defender_XDR]] §2 (Kerberoasting, PtH, PtT, DCSync, Golden Ticket).
- **MDC workload protections:** cada plan Defender genera alertas propias (Key Vault access anómalo, SQL injection, cryptomining en VM…); se investigan en el portal unificado. CSPM = postura, CWPP = runtime ([[Modulo_4_Unified_SecOps_Exposure]] §3).
- **Investigación M365:** Purview **Audit** (Standard 180 días / Premium 1 año, búsqueda de operaciones: quién accedió/borró/compartió qué) · **eDiscovery Content search** (buscar contenido en Exchange/SharePoint/Teams para una investigación) · **Graph activity logs** (llamadas a Microsoft Graph API — detectar apps/tokens abusando de la API).
- **Copilot embebido:** incident summary, guided response, script analysis, NL→KQL. No te preguntarán cómo desplegarlo, sino cómo **usarlo** al investigar.

📝 Notas del vault: [[CONCEPTOS_CLAVE]] §3, [[03_Semana3_Defender_XDR]], [[Modulo_2_Defender_for_Endpoint]], [[Modulo_4_Unified_SecOps_Exposure]] §3–6, [[Modulo_6_Security_Copilot]] (solo parte embebida)

🆓 Recursos:
- [Exam Readiness Zone — Respond to security incidents](https://learn.microsoft.com/shows/exam-readiness-zone/) (parte de la serie de 4).
- [MDE Ninja Training](https://aka.ms/mdeninja) y [MDO Ninja](https://aka.ms/mdoninja) — solo los módulos de investigación/respuesta.
- [Guía SC-200 de Charbel Nemnom](https://charbelnemnom.com/sc-200-exam-study-guide/) — mapeo tema→módulo de Learn siempre actualizado.

🧪 Lab: simulaciones del portal XDR (**Endpoints > Evaluation & tutorials > Tutorials**: documento malicioso, EICAR, script C2) + **sample alerts de MDC** (Defender for Cloud > Security alerts > Sample alerts — genera alertas realistas gratis) + trial M365 E5 (30 días desde el admin center).

```kql
// Usuarios que hicieron clic en URLs de phishing (Día 10)
UrlClickEvents
| where ThreatTypes has "Phish" and ActionType == "ClickAllowed"
| join kind=inner (IdentityInfo | distinct AccountUpn, Department) on $left.AccountUpn == $right.AccountUpn
| project Timestamp, AccountUpn, Department, Url
```

```kql
// Abuso de Graph API: app con volumen anómalo de llamadas (Día 13)
MicrosoftGraphActivityLogs
| where TimeGenerated > ago(24h)
| summarize Llamadas = count(), Endpoints = dcount(RequestUri) by AppId, UserAgent
| order by Llamadas desc
| take 20
```

### 3.3 Dominio 3 — Perform threat hunting (20–25%)

#### Conceptos que más caen
- **Elegir tabla correcta:** procesos → `DeviceProcessEvents`; red endpoint → `DeviceNetworkEvents`; email → `EmailEvents`/`UrlClickEvents`; identidad on-prem → `IdentityLogonEvents`; SaaS → `CloudAppEvents`; sign-ins cloud → `SigninLogs`; firewall/appliances → `CommonSecurityLog`. Drill diario con [[CHEATSHEET_KQL]].
- **Ciclo de hunting:** hipótesis (MITRE) → query → bookmark → incident o analytics rule. Livestream = monitoreo near-real-time SIN crear incidents ([[Modulo_5_Threat_Hunting]]).
- **Threat analytics:** informes de Microsoft TI con analyst report, incidents relacionados, impacted assets y exposure/recomendaciones — sirve para priorizar hunting de campañas activas.
- **Hunting graphs / blast radius (nuevo):** visualización de grafo desde una entidad comprometida para ver el "radio de explosión" (qué puede alcanzar el atacante). **Sentinel Graph** analiza relaciones entre entidades a escala (usuarios↔dispositivos↔recursos) en el portal Defender.
- **KQL jobs (nuevo):** consultas programadas o one-time sobre el **data lake** cuyo resultado se promueve a una tabla del analytics tier (para hunting histórico barato).
- **Summary rules (nuevo):** agregan logs de alto volumen (p. ej. flujos de red) en tablas resumen consultables de forma eficiente — piensa "summarize programado que persiste".
- **Notebooks + MCP Server (nuevo):** los notebooks (y agentes IA) se conectan al **Sentinel MCP Server** para consultar el data lake con herramientas de lenguaje natural. Para el examen: saber qué es y cuándo usarlo (hunting asistido por agentes, análisis sobre data lake).

📝 Notas del vault: [[Modulo_5_Threat_Hunting]] (excelente, tu mejor nota), [[CHEATSHEET_KQL]], [[02_Semana2_KQL_Labs]], [[CONCEPTOS_CLAVE]] §1 (MITRE, Pyramid of Pain)

🆓 Recursos:
- [Must Learn KQL (Rod Trent)](https://github.com/rod-trent/MustLearnKQL) — libro/serie gratuita, el estándar para SC-200.
- [Kusto Detective Agency](https://detective.kusto.io) y [KC7](https://kc7cyber.com) — KQL gamificado con casos de intrusión realistas.
- [KQL playground (aka.ms/lademo)](https://aka.ms/lademo) — Log Analytics demo con datos reales, sin costo ni suscripción.

🧪 Lab: módulo Hunting del Sentinel Training Lab + 2 casos de Kusto Detective + crear un KQL job y una summary rule en tu workspace (Día 17).

```kql
// Patrón examen: "¿qué operador falta?" — beaconing con make-series (Día 18)
DeviceNetworkEvents
| where RemoteIPType == "Public"
| make-series Conexiones = count() on Timestamp step 1h by DeviceName, RemoteIP
| extend (anomalias, score, baseline) = series_decompose_anomalies(Conexiones, 1.5)
| mv-expand Timestamp to typeof(datetime), Conexiones to typeof(long), anomalias to typeof(int)
| where anomalias == 1
```

---

## 🎴 4. Repaso rápido

### Flashcards (pregunta → respuesta)

1. **¿Qué tier de Sentinel usarías para logs de compliance que consultas una vez al año?** → Data lake tier (retención hasta 12 años, consulta vía KQL jobs/notebooks).
2. **¿AIR encontró un archivo "Malicious" pero no lo remedió automáticamente. ¿Por qué?** → El device group tiene automation level "Semi" (requiere aprobación) en vez de "Full".
3. **¿Qué feature deshabilita automáticamente a un usuario en un ataque BEC en curso?** → Automatic attack disruption (no AIR).
4. **¿Rol mínimo de Sentinel para gestionar incidents sin editar analytics rules?** → Microsoft Sentinel Responder.
5. **¿Dónde filtras eventos ANTES de pagar su ingestión?** → DCR transformation (KQL en el pipeline).
6. **¿Regla NRT vs Scheduled: la diferencia clave?** → *(corregido 29-jul-2026)* NRT corre **fijo cada 1 min con lookback de 1 min**, sin scheduling configurable, sin alert threshold configurable y con **tope de 30 alertas por corrida** (29 individuales + 1 resumen). Scheduled es flexible con frecuencia ≥5 min. ⚠️ **NRT ya SÍ puede referenciar múltiples tablas y watchlists** en la misma query — la restricción vieja de "una sola tabla, sin joins" quedó obsoleta.
7. **¿Un bookmark crea un incident automáticamente?** → No. Es marcado manual; el analista lo promueve a incident o lo añade a uno existente.
8. **¿Livestream genera alertas?** → No, solo notifica en sesión. Para alertas automáticas → analytics rule.
9. **¿Qué tabla consultas para ver clics en URLs maliciosas de email?** → `UrlClickEvents`.
10. **¿Audit Standard vs Premium: retención?** → 180 días vs 1 año (+ eventos de "intelligent insights" como MailItemsAccessed).
11. **¿Herramienta para ver el blast radius de una cuenta comprometida?** → Hunting graph (con Sentinel Graph) en el portal Defender.
12. **¿Qué son las summary rules?** → Agregaciones programadas de logs de alto volumen hacia tablas summary de bajo costo consultables con KQL.
13. **¿Para qué se conecta un notebook al Sentinel MCP Server?** → Para que agentes IA/notebooks consulten el data lake con herramientas de lenguaje natural.
14. **¿User risk High en Entra ID Protection: acción recomendada?** → Require password change + MFA (política de user risk en Conditional Access).
15. **¿Contain device vs Isolate device?** → *(matizado 29-jul-2026)* **Contain device** bloquea la comunicación *desde* un dispositivo sospechoso aplicando una política en todos los dispositivos onboardeados a MDE; **Contain IP** hace lo mismo para una IP de un dispositivo NO onboardeado/no descubierto. **Isolate device** aísla el propio dispositivo comprometido, cortando casi todo el tráfico salvo servicios de seguridad esenciales. ⚠️ Ojo: **Attack disruption puede ejecutar las tres**, no solo Contain — Isolate no es exclusiva de la acción manual o de AIR.
17. **¿Dónde se configura cada notificación por correo?** → Incidentes: Settings > **Microsoft Defender XDR** > Email notifications > Incidents. Vulnerabilidades: Settings > **Endpoints** > General > Email notifications > Vulnerabilities. Rutas distintas.
18. **¿Las tres acciones de alert tuning?** → **Hide alert** (suprime e impide el incidente; **solo MDE**; el dato queda en `AlertInfo`/`AlertEvidence`) · **Resolve alert** (alerta e incidentes se generan ya resueltos) · **Set as behavior** (pasa a `BehaviorInfo`/`BehaviorEntities`; **no soportada en MDC ni MDO**).
19. **¿Qué guarda un workbook al salvarlo?** → **Solo el JSON** con la definición. Ningún dato: las consultas se ejecutan contra el workspace al abrirlo.
20. **¿Qué mira "data value optimization" de SOC optimization?** → **Solo tablas facturables con ingesta en los últimos 30 días**, y **nunca** recomienda cambios sobre tablas usadas por UEBA o por matching de threat intelligence.
16. **¿Secure Score vs Exposure Score?** → Secure Score: más alto = mejor (postura). Exposure Score: más bajo = mejor (exposición). Ver [[Modulo_4_Unified_SecOps_Exposure]] §2.4.

### Errores comunes y trampas del examen

- **Trampa de nombres viejos:** si estudiaste "Basic/Auxiliary logs", el examen ahora dice **data lake tier**. Igual: "Microsoft 365 Defender" → **Defender XDR**; "Azure AD" → **Entra ID**; MMA/OMS agent → **AMA**.
- **Automation rule ≠ playbook:** si la pregunta pide "asignar owner y cambiar severidad automáticamente" → automation rule sola, sin Logic App. Si pide "aislar el dispositivo / postear en Teams" → playbook.
- **Permisos de playbook:** el error clásico es que la **cuenta de servicio** de Sentinel no tiene **Automation Contributor** sobre el **resource group** del playbook (no sobre el playbook suelto) → el playbook nunca corre. Y para *crear/editar* playbooks hace falta **Logic App Contributor**; para *ejecutarlos a mano*, **Playbook Operator**. Ningún rol de Sentinel hace lo primero, y Contributor no hace lo segundo.
- **Las asignaciones de rol son acumulativas.** Añadir un rol más restrictivo encima **no quita** permisos: hay que retirar la asignación.
- **SIEM = Azure RBAC sobre el resource group. Data lake = roles de Microsoft Entra ID sobre el tenant** (Security operator / Security administrator / Global administrator para escribir y para gestionar jobs). No los mezcles.
- **Fusion no se edita.** Si la pregunta pide "modificar la lógica de la detección multi-stage" → no puedes; creas reglas complementarias. *(Nota: el temario del 28-jul ya no dice "Fusion" sino "machine learning" — el concepto se pregunta igual, el nombre puede no aparecer.)*
- ~~**NRT no soporta múltiples tablas/joins complejos**~~ → **CORREGIDO (29-jul-2026): NRT ya SÍ admite múltiples tablas y watchlists.** Lo que sigue sin poder es configurar scheduling, configurar alert threshold, y pasar de 30 alertas por corrida. Si el escenario pide frecuencia personalizada o umbral → Scheduled.
- **Responder no puede** crear/editar reglas ni conectar data connectors. Contributor sí.
- **Workbook ≠ playbook** (tu fallo repetido en el simulacro del 23-jul): "visualizar / reporte / dashboard / tendencia" → **workbook**. "Automatizar / ejecutar acción / notificar / crear ticket" → **playbook**. "Detectar / generar alerta" → **analytics rule**. "Buscar / hipótesis, sin alertas" → **hunting query**.
- **Alert suppression NO funciona con custom detections.** Si una custom detection genera falsos positivos, se afina la propia detección — no se silencia con alert tuning.
- **"Informational, expected activity" ≠ "False positive".** La primera es una alerta *correcta* sobre actividad *benigna* (red team, apps de confianza) que quieres seguir viendo; la segunda es una alerta *incorrecta* que no quieres volver a ver.
- **Alerta individual de producto → `SecurityAlert`. Incidente correlacionado de Sentinel → `SecurityIncident`** (tu fallo en la P5 del quiz del Día 6). Y `SecurityIncident` guarda **una fila por actualización**: usa `summarize arg_max(LastModifiedTime, *) by IncidentNumber` para el estado final.
- **Tabla de TI renombrada:** el destino de los indicadores ya no es `ThreatIntelligenceIndicator` sino **`ThreatIntelIndicators` / `ThreatIntelObjects`**.
- **Entra ID Protection alerta por defecto solo en *High-risk detections only***. Si el escenario dice "el analista no ve alertas de riesgo medio" → revisar **Alert service settings**, no la analytics rule.
- **"Investigar email ya entregado"** → Threat Explorer (P2), no el incident queue.
- **eDiscovery vs Audit:** Audit = QUÉ HIZO el usuario (operaciones); Content search = QUÉ CONTENIDO existe/se movió. Escenario "encontrar todos los correos con el adjunto X" → Content search.
- **KQL:** `summarize ... by bin(TimeGenerated, 1h)` para ventanas; `arg_max(TimeGenerated, *)` para "el más reciente por entidad"; `join kind=anti` para "los que NO aparecen". El examen ama preguntar el operador que falta en una query a medio escribir.
- **Case studies:** responde con la info del caso, no con "lo ideal". Si el caso dice que solo tienen licencia P1, Threat Explorer avanzado no es opción.

---

## 📝 5. Preguntas tipo examen (respuestas al final)

**Q1.** Necesitas retener `SecurityEvent` 3 años por compliance minimizando costos. Los datos solo se consultan en auditorías. ¿Qué configuras?
A) Analytics tier con retención 3 años · B) Data lake tier · C) Exportar a Storage Account · D) Tabla custom con retención extendida

**Q2.** Una scheduled analytics rule debe correlacionar `SigninLogs` con una watchlist. ¿Qué función usas en el KQL?
A) `externaldata()` · B) `_GetWatchlist()` · C) `materialize()` · D) `toscalar()`

**Q3.** Tu SOC recibe cientos de alertas de una herramienta admin legítima que ejecuta PowerShell programado en 5 servidores. ¿Acción correcta?
A) Deshabilitar la analytics rule · B) Regla de **alert tuning** (antes llamada *suppression*) con scope a esos 5 dispositivos y condición por proceso · C) Excluir los servidores de MDE · D) Cambiar automation level a No automation

**Q4.** Durante un ataque de ransomware operado por humanos, Defender XDR deshabilitó automáticamente una cuenta de usuario on-prem. ¿Qué capability actuó?
A) AIR · B) Automatic attack disruption · C) Conditional Access · D) MDI remediation

**Q5.** Debes recolectar eventos de seguridad de servidores Windows en una red aislada que solo alcanza un servidor colector. ¿Qué configuras?
A) Syslog via AMA · B) Windows Event Forwarding hacia el colector + AMA en el colector · C) CEF via AMA en cada servidor · D) Logstash

**Q6.** Un analista con rol **Microsoft Sentinel Responder** intenta editar una scheduled rule y falla. ¿Solución con menor privilegio para que gestione incidents Y edite reglas?
A) Owner · B) Sentinel Contributor · C) Sentinel Automation Contributor · D) Contributor de Azure

**Q7.** Quieres que cada incident con la tag "VIP" se asigne automáticamente al equipo Tier 2 y suba a High, sin acciones externas. ¿Qué usas?
A) Playbook con incident trigger · B) Automation rule · C) Workbook · D) Custom detection rule

**Q8.** ¿Qué tabla de Advanced Hunting usas para detectar un proceso hijo sospechoso lanzado por winword.exe?
A) DeviceEvents · B) DeviceProcessEvents · C) DeviceFileEvents · D) EmailAttachmentInfo

**Q9.** Un hunt confirma actividad de un adversario. Quieres detección continua heredando el mapeo MITRE de la query. ¿Camino más eficiente?
A) Copiar el KQL a una regla nueva manualmente · B) "Create analytics rule" desde la hunting query · C) Convertir el bookmark en incident · D) Livestream permanente

**Q10.** Necesitas investigar qué usuario eliminó archivos masivamente de SharePoint hace 6 meses. Tienen Audit Premium. ¿Herramienta?
A) Advanced Hunting (CloudAppEvents) · B) Purview Audit search · C) Content search · D) Graph activity logs

**Q11.** ¿Qué mecanismo reduce el costo de consultar 500 GB/día de logs de firewall que solo usas para agregados de conexiones?
A) NRT rules · B) Summary rules sobre el data lake · C) Watchlists · D) Basic Logs con archive

**Q12.** Un dispositivo NO onboardeado a MDE está propagando ransomware. Attack disruption lo marcó como "contained". ¿Qué significa?
A) El dispositivo fue apagado · B) Los dispositivos onboardeados bloquean toda comunicación con él · C) Se aisló vía firewall de Windows · D) Se movió a una VLAN de cuarentena

**Q13.** Escribes un KQL que debe devolver el login MÁS RECIENTE por usuario. ¿Qué agregación usas en `summarize`?
A) `max(TimeGenerated)` · B) `arg_max(TimeGenerated, *)` · C) `take 1` · D) `top 1 by TimeGenerated`

**Q14.** ¿Qué usas para que un agente de IA consulte el data lake de Sentinel con lenguaje natural desde un notebook?
A) Logic Apps connector · B) Sentinel MCP Server · C) Graph API · D) Azure OpenAI on your data

**Q15.** (Case study) Contoso tiene Sentinel + XDR unificado. Un incident muestra: phishing → clic en URL → token robado → acceso a SharePoint desde IP nueva → descarga masiva. El CISO pide ver TODO el alcance potencial desde la cuenta comprometida antes de remediar. ¿Qué usas?
A) Investigation graph clásico · B) Hunting graph con blast radius (Sentinel Graph) · C) Threat analytics · D) Exposure Management attack paths

**Q16.** ¿Qué connector/formato eliges para un firewall Palo Alto que envía logs en formato CEF?
A) Syslog via AMA · B) CEF via AMA · C) Custom logs API · D) Windows Security Events

**Q17.** Una anomaly rule de Sentinel detecta comportamiento inusual pero genera demasiado ruido. ¿Qué haces primero?
A) Deshabilitarla · B) Duplicarla y ajustar thresholds/scope en la copia · C) Crear suppression rule · D) Bajar la severidad

**Q18.** Necesitas evidencia forense completa (procesos, autoruns, event logs) de un endpoint comprometido ANTES de reimaginarlo. ¿Acción de MDE?
A) Live response `getfile` · B) Collect investigation package · C) Run antivirus scan · D) Isolate device

### Respuestas explicadas

1. **B** — El data lake tier existe exactamente para retención larga y barata con consulta ocasional (KQL jobs). Exportar a Storage (C) pierde la consulta KQL nativa.
2. **B** — `_GetWatchlist('nombre')` es la función oficial; ya la tienes practicada en [[PLAN_INTENSIVO_4SEMANAS]].
3. **B** — Suppression con el scope MÁS restrictivo posible (dispositivos + proceso). A y C destruyen visibilidad; D no afecta la generación de alertas.
4. **B** — Deshabilitar usuarios/contener dispositivos automáticamente ante ransomware/BEC en curso es la firma de attack disruption. AIR remedia evidencia, no interrumpe ataques a nivel identidad.
5. **B** — WEF centraliza eventos hacia un colector; el AMA del colector los sube con su DCR. Es el escenario clásico de WEF en el temario nuevo.
6. **B** — Sentinel Contributor: crea/edita reglas y gestiona incidents. Es el mínimo que cumple ambos requisitos.
7. **B** — Cambios internos del incident (owner, severity, status, tags) = automation rule sin playbook.
8. **B** — Procesos y sus padres viven en `DeviceProcessEvents` (`InitiatingProcessFileName`).
9. **B** — Desde la Hunting page, "Create analytics rule" hereda el MITRE mapping ([[Modulo_5_Threat_Hunting]] §7).
10. **B** — "Qué operación hizo un usuario hace meses" = Audit search (Premium da 1 año de retención). Content search (C) busca contenido, no operaciones; CloudAppEvents no retiene 6 meses por defecto.
11. **B** — Summary rules agregan logs de alto volumen en tablas resumen; es el caso de uso canónico nuevo. (D era la respuesta del temario viejo.)
12. **B** — "Contain" para dispositivos no onboardeados = los endpoints administrados cortan comunicación entrante/saliente con él.
13. **B** — `arg_max(TimeGenerated, *)` devuelve la fila completa del evento más reciente por grupo; `max()` solo devuelve el timestamp.
14. **B** — El Sentinel MCP Server expone herramientas para que agentes/notebooks consulten el data lake. Tema nuevo de julio 2026.
15. **B** — "Alcance potencial desde una entidad" = blast radius en hunting graphs con Sentinel Graph. Attack paths de MSEM (D) es postura preventiva, no respuesta a incident activo.
16. **B** — CEF via AMA para appliances que hablan CEF; Syslog plano solo si no es CEF.
17. **B** — Las anomaly rules se ajustan duplicándolas y tuneando la copia (la original queda como referencia).
18. **B** — Investigation package = paquete forense completo. Isolate (D) contiene pero no captura evidencia.

**Meta:** ≥14/18 (~78%) antes de agendar el examen.

---

## ✅ 6. Checklist "Listo para el examen"

### Conocimiento
- [ ] Explico los 3 tiers de datos (Analytics/Data lake/XDR) y elijo el correcto por escenario de costo/retención
- [ ] Creo DCR con transformation, y sé cuándo WEF vs AMA directo vs CEF/Syslog
- [ ] Distingo los 5 tipos de analytics rules + anomalías, y sus límites (NRT, Fusion)
- [ ] Distingo AIR / attack disruption / automation rules / playbooks y sus permisos
- [ ] Asigno el rol de Sentinel/MDE correcto por escenario (mínimo privilegio)
- [ ] Domino el flujo Triage→Investigate→Respond y case management
- [ ] Sé qué acción de respuesta MDE usar (isolate, contain, restrict, package, live response)
- [ ] Elijo Purview Audit vs Content search vs Graph activity logs por escenario
- [ ] Escribo sin ayuda las 7 queries de [[PLAN_INTENSIVO_4SEMANAS]] + `arg_max`, `make-series`, joins
- [ ] Explico KQL jobs, summary rules, Sentinel Graph, blast radius y MCP Server (temas julio 2026)
- [ ] Score ≥80% en el Practice Assessment oficial (2 intentos distintos)

### Logística (día 23)
- [ ] Examen agendado en Pearson VUE con el voucher (antes del 18 ago)
- [ ] Decidido: presencial vs online proctored (online: room scan, escritorio limpio, ID oficial vigente, test de sistema hecho)
- [ ] Probé el [exam sandbox](https://aka.ms/examdemo) (tipos de pregunta: multiple choice, drag-drop, case studies, hot area)
- [ ] **Recuerda: puedes abrir Microsoft Learn DURANTE el examen** (role-based exams). Úsalo solo para 3–5 preguntas dudosas — el reloj no se detiene
- [ ] Estrategia de tiempo: ~100–120 min para 40–60 preguntas; case studies primero se lee la pregunta, luego el caso; las preguntas de "yes/no series" no permiten volver atrás
- [ ] Día previo: solo flashcards, dormir 7+ h; llegar/conectarse 30 min antes

---

## 🔍 7. Validación final — Qué reforzar y qué corregir en el vault

**Temas AUSENTES en tus notas (prioridad máxima — crea las 6 notas nuevas del cronograma):**
1. Automatic attack disruption (Día 6)
2. WEF + custom log tables + custom data collection MDE (Días 2–3, 5)
3. Case management (Día 8)
4. Purview Audit + eDiscovery Content search + Graph activity logs (Día 13)
5. Hunting graphs / blast radius / Sentinel Graph (Día 15)
6. Data lake: KQL jobs + Summary rules + MCP Server (Día 17)

**Notas DESACTUALIZADAS (corrige al pasar por el día correspondiente):**
- [[PLAN_INTENSIVO_4SEMANAS]] — outline viejo (Purview 15–20% ya no existe como dominio); las queries KQL siguen siendo oro, consérvalas
- [[00_INDEX_SC200]] — pesos de dominios viejos; actualizar a 40-45/35-40/20-25
- [[Modulo_4_Unified_SecOps_Exposure]] §8.1 — tiers Basic/Auxiliary → modelo Analytics/Data lake/XDR
- [[Modulo_6_Security_Copilot]] — la configuración de Copilot (SCUs, plugins, standalone) salió del examen; solo la experiencia embebida es evaluable
- **MDE Evaluation Lab** (referenciado en [[PLAN_INTENSIVO_4SEMANAS]]) — **fue retirado por Microsoft**; usa las simulaciones de Endpoints > Tutorials
- **M365 E5 Developer Program** — restringido desde 2024 (requiere Visual Studio Enterprise); usa el trial E5 de 30 días desde el admin center

**Cobertura verificada:** los 3 dominios y sus 12 sub-skills oficiales quedan cubiertos por el cronograma (Días 1–7 → Dominio 1; Días 8–13 → Dominio 2; Días 14–18 → Dominio 3; Días 19–24 → integración y simulacros). Cada subtema tiene ≥1 recurso gratuito y ≥1 lab. Fuente del temario: [Study guide oficial SC-200](https://learn.microsoft.com/credentials/certifications/resources/study-guides/sc-200) (verificado 2026-07-06).

---

*Guía creada el 2026-07-06 | Basada en el skills outline oficial vigente (con cambios del 28-jul-2026) | Índice: [[00_INDEX_SC200]]*
