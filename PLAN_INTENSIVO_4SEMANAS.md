---
title: Plan de Estudios Intensivo 4 Semanas — SC-200
date: 2026-06-17
tags: [sc-200, certificacion, microsoft, sentinel, defender-xdr, purview, plan-estudio, kql]
tipo: Plan de Estudio
estado: 🟡 En progreso
relacionado: "[[00_INDEX_SC200]], [[CHEATSHEET_KQL]], [[01_Semana1_Sentinel_Fundamentos]], [[02_Semana2_KQL_Labs]], [[03_Semana3_Defender_XDR]], [[04_Semana4_Simulacros]]"
---

# 🗺️ Plan Intensivo 4 Semanas — SC-200: Microsoft Security Operations Analyst

> [!danger] OBSOLETO — sustituido por [[PLAN_MAESTRO_MULTITRACK]]
> Este plan usa el **outline viejo por producto** (Defender XDR 25–30% / Sentinel 50–55% / Purview 15–20%, estructura Semana 1 = XDR / Semanas 2-3 = Sentinel / Semana 4 = Purview) y el **Sentinel Training Lab abandonado**. Desde abril 2026 el examen se organiza por **funciones del analista** (3 dominios: Manage SecOps 40–45%, Respond 35–40%, Threat hunting 20–25%), y el 28-jul-2026 se sumaron KQL jobs, Sentinel Graph, data lake, MCP Server, case management. Calendario y contenido vigentes: [[PLAN_MAESTRO_MULTITRACK]] y las notas de `Lecciones Diarias/`. Mapeo completo temario↔lección: [[GUIA_INTENSIVA_24_DIAS]] §1. No usar esta nota para repasar ni como fuente de un podcast de NotebookLM — es histórico.

> **Arquitecto Tutor:** Enfoque de Arquitecto de Ciberseguridad Microsoft  
> **Voucher vence:** 18 agosto 2026 | **Examen límite:** 18 octubre 2026  
> **Meta:** 700+/1000 — aprobación garantizada con este ritmo

---

## 🎯 Mapa de Peso por Dominio (Guía Oficial Abril 2026)

| Dominio | Peso Oficial | Semanas Asignadas | Días dedicados |
|---------|-------------|-------------------|---------------|
| Mitigar amenazas con **Microsoft Defender XDR** | 25–30% | Semana 1 | Lun–Vie (5 días) |
| Mitigar amenazas con **Microsoft Sentinel** | 50–55% | Semanas 2 y 3 | 10 días |
| Mitigar amenazas con **Microsoft Purview** | 15–20% | Semana 4 (Lun–Mié) | 3 días |
| Simulacros y repaso integral | — | Semana 4 (Jue–Vie) | 2 días |

> [!NOTE]
> El dominio de Sentinel (50–55%) es el más pesado del examen. Las semanas 2 y 3 lo atacan en profundidad: arquitectura + fuentes de datos primero, luego analítica avanzada, automatización y hunting.

---

## ⏱️ Ritmo Diario Recomendado

| Bloque | Tiempo | Actividad |
|--------|--------|-----------|
| Bloque A — Mañana | 1.5 hrs | Teoría: Microsoft Learn / documentación oficial |
| Bloque B — Tarde | 1.5 hrs | Lab práctico: sandbox Azure / ejercicios KQL |
| Repaso diario | 20 min | Flashcard mental: 3 conceptos del día |
| **Total por día hábil** | **~3.5 hrs** | |
| Fin de semana | 2–3 hrs | Revisión semanal + autoevaluación + puntos débiles |

---

## 📅 SEMANA 1 — Microsoft Defender XDR (25–30%)

> [!TIP]
> Defender XDR es el paraguas unificado: agrupa MDE (Endpoint), MDI (Identity), MDCA (Cloud Apps) y MDO (Office 365). Aprender a navegar el portal `security.microsoft.com` es tan importante como los conceptos técnicos.

**Objetivo de la semana:** Configurar, gestionar e investigar amenazas con los 4 pilares de Defender XDR. Conectar Defender a Sentinel como fundamento para las semanas siguientes.

| Día | Tema Central | Objetivos Clave | Enfoque Práctico (Labs / KQL) |
|-----|-------------|-----------------|-------------------------------|
| **Lun** | Microsoft Defender XDR — Portal y arquitectura unificada | Navegar `security.microsoft.com`; entender la correlación de señales entre pilares; roles y permisos (Security Admin vs Reader vs Operator) | **Lab MS Learn:** [Explorar el portal de Microsoft Defender XDR](https://learn.microsoft.com/training/modules/introduction-microsoft-365-threat-protection/) — Activar trial M365 E5 Developer sandbox |
| **Mar** | Microsoft Defender for Endpoint (MDE) — Onboarding y configuración | Métodos de onboarding (Intune, Group Policy, script local, Azure Arc); Device Inventory; Attack Surface Reduction (ASR) rules; Endpoint Detection & Response (EDR) activado | **Lab:** Desplegar MDE con script local en VM Windows 10 — Verificar en portal que el device aparece; explorar el timeline de eventos del dispositivo |
| **Mié** | MDE — Investigación de alertas y respuesta | Alert queue; Incident graph; Live Response (comandos básicos: `getfile`, `run`, `dir`); Aislamiento de dispositivo; Indicadores de compromiso (IoC) — bloqueo de hash/IP/dominio | **Lab:** Simular alerta con [EICAR test file](https://www.eicar.org/download-anti-malware-testfile/); investigar el incidente generado; ejecutar Live Response en la VM sandbox |
| **Jue** | Microsoft Defender for Identity (MDI) + Defender for Cloud Apps (MDCA) | MDI: sensor deployment en DC, detección de Pass-the-Hash y Lateral Movement; MDCA: Cloud Discovery, políticas de sesión, OAuth app governance; Shadow IT detection | **Lab MS Learn:** [Módulo MDI](https://learn.microsoft.com/training/modules/m365-threat-safeguard/) — Revisar en MDCA el app catalog; crear una policy de sesión para bloquear descarga desde app no sancionada |
| **Vie** | Integración Defender XDR ↔ Microsoft Sentinel + Secure Score | Conectar el conector `Microsoft Defender XDR` en Sentinel (ingestión de `AlertInfo`, `DeviceEvents`); Secure Score: leer recomendaciones, priorizarlas; MITRE ATT&CK coverage map en Defender | **KQL en Sentinel:** Verificar ingestión post-conexión: `AlertInfo \| where TimeGenerated > ago(1h) \| summarize count() by AlertSeverity` — Revisar que las alertas de MDE aparecen en Sentinel |
| **Sáb–Dom** | Repaso Semana 1 | Repasar portal Defender XDR sin notas; revisar notas en [[03_Semana3_Defender_XDR]]; autoevaluación: 10 preguntas sobre onboarding MDE, MDI y MDCA | **Flashcards clave:** Diferencia MDE vs MDI vs MDCA; cuándo usar Live Response vs aislamiento; qué tablas KQL genera cada pilar en Sentinel |

---

## 📅 SEMANA 2 — Microsoft Sentinel: Arquitectura, Fuentes de Datos y Gestión de Logs (Sentinel 50–55%, parte 1)

> [!NOTE]
> Sentinel es el corazón del examen. Esta semana establece los cimientos: workspace, conectores, transformación de datos y RBAC. Sin esto, las semanas 3 no tiene base.

**Objetivo de la semana:** Desplegar y configurar un workspace de Sentinel funcional con múltiples fuentes de datos, entender la gestión de costos y dominar la arquitectura de Log Analytics.

| Día | Tema Central | Objetivos Clave | Enfoque Práctico (Labs / KQL) |
|-----|-------------|-----------------|-------------------------------|
| **Lun** | Arquitectura de Microsoft Sentinel — Workspace y Log Analytics | Relación Sentinel ↔ Log Analytics Workspace (LAW); tablas: Analytics, Basic, Auxiliary; retención de datos (plan de precios); workspace dedicado vs compartido; multi-workspace con Lighthouse | **Lab:** Crear un Microsoft Sentinel workspace en Azure Free Trial — Navegar: Logs, Data Connectors, Workbooks; ejecutar la primera query: `SecurityEvent \| take 10` |
| **Mar** | Data Connectors — Parte 1: Fuentes Microsoft nativas | Conectores: Microsoft Defender XDR, Microsoft Entra ID (SignIn Logs, AuditLogs), Microsoft 365 (Office Activity), Azure Activity; diferencia entre connector gratuito vs billable; Content Hub | **Lab:** Activar conector `Microsoft Entra ID`; verificar ingestión con: `SigninLogs \| where TimeGenerated > ago(1h) \| project UserPrincipalName, ResultType, Location \| take 20` |
| **Mié** | Data Connectors — Parte 2: Fuentes de terceros y Syslog/CEF | AMA (Azure Monitor Agent) vs DCR (Data Collection Rules); Syslog connector; CEF via AMA; Windows Security Events (niveles: Minimal, Common, All); configurar Heartbeat para verificar conectividad | **Lab:** Conectar Syslog de una VM Linux en Azure; crear DCR para filtrar eventos por EventID; validar con: `Syslog \| where Facility == "auth" \| summarize count() by SyslogMessage \| order by count_ desc` |
| **Jue** | RBAC, gestión de costos y watchlists | Roles de Sentinel: Reader, Responder, Contributor, Automation Contributor; RBAC granular por tabla; Watchlists: crear, importar CSV, usar en queries; estimación de costos con Azure Calculator | **Lab:** Crear una Watchlist de IPs maliciosas conocidas (importar CSV de 10 entradas); referenciarla en KQL: `_GetWatchlist('IPsMaliciosas') \| join kind=inner (CommonSecurityLog) on $left.ip == $right.SourceIP` |
| **Vie** | Workbooks, Incident Management y entidades | Workbooks predefinidos vs custom; Entidades en Sentinel (Account, IP, Host, URL); correlación de entidades entre incidentes; Fusion rule (detección ML multi-stage); configurar notificaciones de alertas | **Lab MS Learn:** [Módulo Sentinel workspace](https://learn.microsoft.com/training/paths/sc-200-configure-azure-sentinel-environment/) — Revisar Workbook `Azure Activity`; generar un incidente manualmente desde una alerta y asignarlo |
| **Sáb–Dom** | Repaso Semana 2 | Repasar notas [[01_Semana1_Sentinel_Fundamentos]]; dibujar de memoria el diagrama: fuente → connector → LAW → Sentinel; autoevaluación: 10 preguntas sobre conectores, RBAC y Watchlists | **Práctica libre KQL:** 30 min de queries sobre `SecurityEvent`, `SigninLogs`, `AzureActivity` sin copiar de notas |

---

## 📅 SEMANA 3 — Microsoft Sentinel: Analítica, Automatización, Hunting y KQL Avanzado (Sentinel 50–55%, parte 2)

> [!TIP]
> Esta semana es la más técnica y la que más diferencia a los candidatos que aprueban de los que fallan. Las Analytics Rules y los Playbooks son el corazón operativo de Sentinel — domínalos con práctica real, no solo teoría.

**Objetivo de la semana:** Crear y gestionar reglas de detección avanzadas, automatizar respuestas con Logic Apps/Playbooks y realizar threat hunting proactivo con KQL.

| Día | Tema Central | Objetivos Clave | Enfoque Práctico (Labs / KQL) |
|-----|-------------|-----------------|-------------------------------|
| **Lun** | Analytics Rules — Tipos y creación | Tipos: **Scheduled** (KQL periódico), **NRT** (Near Real-Time, <5 min), **Fusion** (ML multi-etapa, no editable), **ML Behavioral** (anomalías de usuario), **Microsoft Security** (desde Defender alerts); anatomía de una regla: query, entity mapping, incident settings, tactics MITRE | **Lab:** Crear una Scheduled rule que detecte `5+ failed logins` en 10 min: `SecurityEvent \| where EventID == 4625 \| summarize FailedLogins=count() by Account, bin(TimeGenerated, 10m) \| where FailedLogins >= 5` — Configurar severity Medium, mapear entidad Account |
| **Mar** | KQL Avanzado para detección — Parte 1 | Funciones de ventana temporal (`bin`, `ago`, `between`); joins entre tablas (`inner`, `leftouter`, `anti`); `arg_max` y `arg_min` para estado más reciente; `make_set` y `make_list` para agregaciones; parseo con `parse` y `extract` | **Queries de práctica específicas:** Ver sección [[#KQL Avanzado — Queries de Práctica]] debajo de esta tabla |
| **Mié** | KQL Avanzado para detección — Parte 2 + Anomalías | `let` statements para subqueries reutilizables; funciones `series_decompose_anomalies` para detección de anomalías de volumen; `bag_unpack` para columnas dinámicas; hunting hypothesis → query → bookmark → incident | **Queries de práctica específicas:** Ver sección [[#KQL Avanzado — Queries de Práctica]] debajo de esta tabla |
| **Jue** | Automatización — Playbooks y Logic Apps | Playbooks = Logic Apps + trigger Sentinel; triggers: `When incident is created`, `When alert is created`, `When entity updated`; acciones comunes: enviar email, crear ticket, aislar host via MDE, bloquear IP via Firewall; SOAR vs SIEM en el contexto del examen; Automation Rules (pre-Playbook) | **Lab:** Crear un Playbook con trigger `When incident is created` que envíe email con los detalles del incidente (usar Logic Apps connector Gmail/Outlook); crear una Automation Rule que asigne el incidente automáticamente al owner correcto según la entidad |
| **Vie** | Threat Hunting, Notebooks y MITRE ATT&CK | Hunting queries predefinidas en Sentinel; crear y guardar custom hunting queries; Bookmarks: marcar evidencia durante hunting; Livestream; Azure Notebooks (Jupyter) para hunting avanzado; mapear detecciones a MITRE ATT&CK en el MITRE blade de Sentinel | **Lab MS Learn:** [Módulo Threat Hunting](https://learn.microsoft.com/training/modules/hunt-threats-sentinel/) — Ejecutar 3 hunting queries predefinidas, guardar bookmarks, crear un incidente desde los bookmarks |
| **Sáb–Dom** | Repaso Semana 3 + Mini simulacro Sentinel | Repasar notas [[02_Semana2_KQL_Labs]]; hacer 15 preguntas de práctica enfocadas solo en Sentinel; reescribir de memoria las 5 queries más importantes de la semana | **Práctica KQL sin notas:** 1 hora — crear una Scheduled rule desde cero, un Playbook básico y una hunting query, todo sin consultar referencias |

---

### ⚡ KQL Avanzado — Queries de Práctica (Semana 3, Mar–Mié)

> [!NOTE]
> Estas queries representan los patrones más frecuentes en el examen SC-200. Práctica cada una en el Log Analytics Workspace de tu sandbox hasta entenderla sin leer la documentación.

#### Detección de Brute Force (Semana 3 — Lunes)
```kql
// Detectar 5+ failed logins en una ventana de 10 minutos por cuenta
SecurityEvent
| where EventID == 4625
| summarize FailedLogins = count(), 
            FirstAttempt = min(TimeGenerated),
            LastAttempt = max(TimeGenerated)
          by Account, Computer, bin(TimeGenerated, 10m)
| where FailedLogins >= 5
| extend TimeDelta = LastAttempt - FirstAttempt
| project Account, Computer, FailedLogins, FirstAttempt, LastAttempt, TimeDelta
| order by FailedLogins desc
```

#### Detección de Impossible Travel (Semana 3 — Martes)
```kql
// Detectar logins desde países distintos en < 1 hora para el mismo usuario
SigninLogs
| where ResultType == 0  // successful login
| project UserPrincipalName, Location, TimeGenerated, IPAddress
| order by UserPrincipalName, TimeGenerated asc
| serialize
| extend PrevLocation = prev(Location, 1),
         PrevTime = prev(TimeGenerated, 1),
         PrevUser = prev(UserPrincipalName, 1)
| where UserPrincipalName == PrevUser
| where Location != PrevLocation
| where TimeGenerated - PrevTime < 1h
| project UserPrincipalName, Location, PrevLocation, TimeGenerated, PrevTime, IPAddress
```

#### Detección de Ejecución de PowerShell Sospechoso (Semana 3 — Martes)
```kql
// Detectar PowerShell con parámetros de evasión (encoding, bypass, hidden)
DeviceProcessEvents
| where FileName =~ "powershell.exe" or FileName =~ "pwsh.exe"
| where ProcessCommandLine has_any ("-enc", "-EncodedCommand", "-w hidden", 
                                    "bypass", "-nop", "-noni", "downloadstring",
                                    "iex", "invoke-expression", "webclient")
| project Timestamp, DeviceName, AccountName, ProcessCommandLine, 
          InitiatingProcessFileName, InitiatingProcessCommandLine
| order by Timestamp desc
```

#### Detección de Lateral Movement con Pass-the-Hash (Semana 3 — Martes)
```kql
// Detectar autenticación NTLM con IP de origen = destino sospechoso
SecurityEvent
| where EventID == 4624  // successful logon
| where LogonType == 3   // network logon
| where AuthenticationPackageName == "NTLM"
| where AccountName !endswith "$"  // excluir cuentas de máquina
| summarize LogonCount = count(), 
            TargetHosts = make_set(Computer),
            SourceIPs = make_set(IpAddress)
          by AccountName, bin(TimeGenerated, 1h)
| where LogonCount > 3 and array_length(TargetHosts) > 1
| project AccountName, LogonCount, TargetHosts, SourceIPs, TimeGenerated
```

#### Uso de Watchlist en Detección (Semana 2 — Jueves)
```kql
// Cruzar IPs de SigninLogs con watchlist de IPs maliciosas conocidas
let MaliciousIPs = _GetWatchlist('IPsMaliciosas')
    | project SearchKey, ThreatType, Confidence;
SigninLogs
| where TimeGenerated > ago(24h)
| where ResultType == 0
| join kind=inner (MaliciousIPs) on $left.IPAddress == $right.SearchKey
| project TimeGenerated, UserPrincipalName, IPAddress, Location, ThreatType, Confidence
| order by TimeGenerated desc
```

#### Detección de Anomalía de Volumen con Series (Semana 3 — Miércoles)
```kql
// Detectar spike anómalo en volumen de eventos de autenticación
let StartTime = ago(7d);
let EndTime = now();
let BinSize = 1h;
SecurityEvent
| where EventID in (4624, 4625)
| where TimeGenerated between (StartTime .. EndTime)
| make-series LoginCount = count() on TimeGenerated 
              from StartTime to EndTime step BinSize
              by Computer
| extend (anomalies, score, baseline) = series_decompose_anomalies(LoginCount, 1.5)
| mv-expand TimeGenerated to typeof(datetime), 
            LoginCount to typeof(long), 
            anomalies to typeof(int)
| where anomalies == 1  // solo los puntos anómalos
| project Computer, TimeGenerated, LoginCount
```

#### Hunting — Descubrimiento de Nuevos Procesos Padre-Hijo Sospechosos (Semana 3 — Viernes)
```kql
// Detectar procesos inusuales lanzados por Word/Excel (macros maliciosas)
DeviceProcessEvents
| where InitiatingProcessFileName has_any ("winword.exe", "excel.exe", 
                                           "powerpnt.exe", "outlook.exe")
| where FileName has_any ("powershell.exe", "cmd.exe", "wscript.exe", 
                          "cscript.exe", "mshta.exe", "certutil.exe",
                          "regsvr32.exe", "rundll32.exe")
| project Timestamp, DeviceName, AccountName, FileName, ProcessCommandLine,
          InitiatingProcessFileName, InitiatingProcessCommandLine
| order by Timestamp desc
```

---

## 📅 SEMANA 4 — Microsoft Purview + Simulacros y Repaso Integral (Purview 15–20% + Cierre)

> [!TIP]
> Purview es el dominio más subestimado del SC-200. No requiere profundidad técnica como Sentinel, pero sus conceptos (Insider Risk, DLP, Communication Compliance) salen en escenarios de examen que muchos candidatos no estudian.

**Objetivo de la semana:** Cubrir los controles de Microsoft Purview relevantes para operaciones de seguridad, luego usar Jue–Vie para simulacros intensivos y cerrar puntos débiles.

| Día | Tema Central | Objetivos Clave | Enfoque Práctico (Labs / KQL) |
|-----|-------------|-----------------|-------------------------------|
| **Lun** | Microsoft Purview — Insider Risk Management | Políticas de riesgo interno: Data Theft by Departing Users, Data Leaks, Security Policy Violations; indicadores de riesgo; casos e investigaciones; integración con Sentinel (conector Insider Risk Management); alertas de Purview en Sentinel | **Lab MS Learn:** [Módulo Insider Risk](https://learn.microsoft.com/training/modules/m365-compliance-insider-prepare/) — Crear una política de `Data Theft` en Purview trial; ver cómo las alertas aparecen en Sentinel si el conector está activo |
| **Mar** | Microsoft Purview — DLP y Communication Compliance | DLP policies: endpoints, Exchange, SharePoint, Teams; sensitive info types (SIT) vs trainable classifiers; Communication Compliance: políticas para detectar harassment, regulatory compliance; rol de Purview en el flujo SOC → investigación de incidentes con datos exfiltrados | **Lab:** Crear una DLP policy para detectar tarjetas de crédito en Teams/SharePoint; revisar las coincidencias en el portal de Purview; mapear cómo un analista SOC investigaría una alerta de DLP en el contexto de un incidente mayor |
| **Mié** | Integración Purview ↔ Sentinel + Unified Security Operations | Conector de Microsoft Purview en Sentinel; tabla `PurviewAuditEvents`; correlacionar eventos de Purview con otros signals; Microsoft Unified Security Operations Platform (Sentinel + Defender XDR en el mismo portal); casos de uso cross-domain (alerta DLP + alerta MDE = insider threat + malware) | **KQL:** `PurviewAuditEvents \| where Operation == "FileCopied" \| summarize count() by UserId, SiteUrl \| order by count_ desc` — Correlacionar con `DeviceFileEvents` de Defender para ver si el mismo usuario copió archivos localmente |
| **Jue** | Simulacro de Examen #1 + Análisis de gaps | Completar practice test 1 completo (60 preguntas, 120 min); anotar cada pregunta fallida con el tema; categorizar fallos: ¿Sentinel? ¿Defender? ¿Purview? ¿KQL? | **Recursos:** [MeasureUp SC-200](https://www.measureup.com/sc-200.html) o Udemy "SC-200 Practice Tests 2026"; tras el test: hacer mapa de calor de áreas débiles y estudiar solo esas áreas 2 horas |
| **Vie** | Simulacro de Examen #2 + Estrategia de examen | Completar practice test 2; consolidar notas rápidas de los conceptos más fallados; estrategia de examen: cómo manejar case studies, preguntas de drag-and-drop, respuesta múltiple; revisar [[CHEATSHEET_KQL]] como repaso final | **Meta de score:** Practice Test 1: >70% | Practice Test 2: >75% | Si no alcanzas: añadir 1–2 días de refuerzo antes de agendar el examen real |
| **Sáb–Dom** | Repaso final + Logística del examen | Revisar todos los cheatsheets: [[CHEATSHEET_KQL]], [[Chronicle_vs_Sentinel]]; repasar las notas de puntos débiles identificados; confirmar fecha del examen con voucher; leer las instrucciones de Pearson VUE | **Día del examen:** Revisar solo los conceptos clave el día anterior — no estudiar temas nuevos. Dormir 7+ horas. |

---

## 🧪 Laboratorios prácticos por tema

> [!NOTE]
> Los labs listados aquí son el complemento práctico de cada semana. Priorizados por impacto en el examen. Ver también [[CHEATSHEET_KQL]] para referencia rápida de queries y [[02_Semana2_KQL_Labs]] para ejercicios KQL detallados.

### Fuentes principales de labs (gratuitas)

| Entorno | Descripción | Enlace |
|---------|-------------|--------|
| **Microsoft Learn (sandbox)** | Módulos con entorno temporal gratuito integrado — no requiere suscripción propia | [learn.microsoft.com](https://learn.microsoft.com) |
| **Ruta oficial SC-200** | Learning path completo con labs guiados | [SC-200T00](https://learn.microsoft.com/training/courses/sc-200t00) |
| **Azure Free Account** | $200 USD crédito por 30 días + servicios gratuitos permanentes | [azure.microsoft.com/free](https://azure.microsoft.com/free) |
| **Microsoft 365 E5 Developer Program** | Tenant completo con Defender XDR + Purview, gratis 90 días renovable | [developer.microsoft.com/microsoft-365/dev-program](https://developer.microsoft.com/microsoft-365/dev-program) |

---

### Defender XDR — Labs (Semana 1)

| Lab | Tipo | Descripción | Enlace |
|-----|------|-------------|--------|
| MS Learn: "Mitigate threats with MDE" | Learning Path guiado | Cubre onboarding, alertas, respuesta — sandbox incluido | [link](https://learn.microsoft.com/training/paths/sc-200-mitigate-threats-using-microsoft-defender-for-endpoint/) |
| **MDE Evaluation Lab** | Lab autoguiado (el más valioso de esta semana) | Dentro del portal en `Endpoints > Evaluation & tutorials`. Despliega VMs preconfiguradas y lanza ataques simulados reales para ver alertas/incidentes generados | [security.microsoft.com](https://security.microsoft.com) |
| Defender for Identity — simulación de ataques | Tutorial oficial | Simula Pass-the-Hash, reconnaissance y Lateral Movement para ver detecciones en MDI | [security.microsoft.com](https://security.microsoft.com) |
| Defender for Cloud Apps — Shadow IT y sesiones | Lab manual | Crear políticas de sesión y descubrimiento de Shadow IT en MDCA | [security.microsoft.com](https://security.microsoft.com) |

> [!TIP]
> El **MDE Evaluation Lab** es el recurso más valioso de la Semana 1: permite ver el ciclo completo ataque → alerta → incidente → investigación sin configurar nada desde cero. Úsalo el martes y miércoles.

---

### Microsoft Sentinel — Labs (Semanas 2 y 3) — dominio 50–55%

| Lab | Tipo | Descripción | Enlace |
|-----|------|-------------|--------|
| MS Learn: "Connect logs to Microsoft Sentinel" | Learning Path con sandbox | Cubre conectores, LAW, configuración básica | [link](https://learn.microsoft.com/training/paths/sc-200-utilize-kql-for-azure-sentinel/) |
| **KQL Playground — cluster público** | Gratuito, sin login | Datos de muestra reales; ideal para practicar queries del [[CHEATSHEET_KQL]] | [help.kusto.windows.net](https://help.kusto.windows.net) |
| **KQL Playground — demo LA** | Gratuito, sin login | Dataset de Log Analytics de muestra con tablas de seguridad | [aka.ms/lademo](https://aka.ms/lademo) |
| **Microsoft Sentinel Training Lab** | Repo GitHub oficial (el mejor recurso del examen) | Despliega workspace con datos de muestra vía plantilla ARM; incluye módulos guiados de analytics rules, workbooks, playbooks y hunting | [Azure/Azure-Sentinel en GitHub](https://github.com/Azure/Azure-Sentinel) — carpeta `/Sentinel-Training-Lab` |
| **Kusto Detective Agency** | KQL gamificado, gratis | Retos de KQL con narrativa; excelente para interiorizar funciones avanzadas (`series_decompose_anomalies`, `joins`, `let`) | [detective.kusto.io](https://detective.kusto.io) |

> [!TIP]
> El **Sentinel Training Lab** (GitHub) es el recurso práctico más importante de todo el examen — cubre en torno al 50% del contenido evaluado. Configúralo al inicio de la Semana 2 y úsalo durante toda la semana y la semana 3. Ver [[02_Semana2_KQL_Labs]] para las queries de práctica asociadas.

---

### Microsoft Purview — Labs (Semana 4)

| Lab | Tipo | Descripción | Enlace |
|-----|------|-------------|--------|
| MS Learn: Insider Risk, DLP, Communication Compliance | Módulos guiados | Labs con sandbox incluido; cubre configuración de políticas y flujo de investigación | [learn.microsoft.com](https://learn.microsoft.com) |
| **Microsoft 365 E5 Developer Sandbox** | Tenant completo | Único entorno donde se practica Purview de verdad (incluye datos de muestra preconfigurados para DLP, eDiscovery, Insider Risk) | [developer.microsoft.com/microsoft-365/dev-program](https://developer.microsoft.com/microsoft-365/dev-program) |

> [!NOTE]
> Para Purview es indispensable el tenant E5 Developer. El sandbox de MS Learn cubre la teoría pero el tenant propio permite explorar el flujo completo: alerta DLP → caso → investigación → acción correctiva.

---

### Orden de prioridad recomendado

> [!TIP]
> Si el tiempo es limitado, este es el orden que maximiza la cobertura del examen:
>
> 1. **Sentinel Training Lab (GitHub)** — cubre ~50% del examen; configúralo en Semana 2, día 1
> 2. **KQL Playground + Kusto Detective Agency** — KQL es donde se gana o se pierde el SC-200; ver [[CHEATSHEET_KQL]]
> 3. **MDE Evaluation Lab** — entender el ciclo completo alerta/incidente en Defender XDR
> 4. **M365 E5 Developer Sandbox** — único entorno real para practicar Purview

---

## 🔗 Recursos por Dominio

### Microsoft Defender XDR
| Recurso | Tipo | Enlace |
|---------|------|--------|
| Learning Path SC-200: Defender XDR | MS Learn oficial | [link](https://learn.microsoft.com/training/paths/sc-200-mitigate-threats-using-microsoft-365-defender/) |
| Defender for Endpoint Labs | GitHub oficial | [SC-200T00A Labs](https://github.com/MicrosoftLearning/SC-200T00A-Microsoft-Security-Operations-Analyst) |
| MDE Ninja Training | Microsoft Tech Community | [Endpoint Ninja](https://techcommunity.microsoft.com/t5/microsoft-defender-for-endpoint/become-a-microsoft-defender-for-endpoint-ninja/ba-p/1515647) |

### Microsoft Sentinel
| Recurso | Tipo | Enlace |
|---------|------|--------|
| Learning Path SC-200: Sentinel | MS Learn oficial | [link](https://learn.microsoft.com/training/paths/sc-200-mitigate-threats-sentinel/) |
| KQL Quick Reference | Docs oficiales | [KQL Reference](https://learn.microsoft.com/azure/data-explorer/kusto/query/) |
| Must Learn KQL Series | GitHub | [Rod Trent - Must Learn KQL](https://github.com/rod-trent/MustLearnKQL) |
| Sentinel Notebooks Samples | GitHub | [Azure Sentinel Notebooks](https://github.com/Azure/Azure-Sentinel-Notebooks) |
| KQL for Beginners (módulo Learn) | MS Learn | [link](https://learn.microsoft.com/training/modules/write-first-query-kusto-query-language/) |

### Microsoft Purview
| Recurso | Tipo | Enlace |
|---------|------|--------|
| Learning Path SC-200: Purview | MS Learn oficial | [link](https://learn.microsoft.com/training/paths/sc-200-mitigate-threats-microsoft-purview/) |
| Purview Compliance Trial | Portal | [compliance.microsoft.com](https://compliance.microsoft.com) |

### Simulacros
| Recurso | Tipo | Notas |
|---------|------|-------|
| MeasureUp SC-200 | Oficial Microsoft | Más cercano al examen real |
| Udemy — SC-200 Practice Tests 2026 | Terceros | Más económico (~$12 USD) |
| Microsoft Learn — Assessment | Gratuito | [SC-200 Free Practice Assessment](https://learn.microsoft.com/certifications/exams/sc-200/practice/assessment) |

---

## 🏁 Checklist de Preparación Final

### Semana 1 — Defender XDR
- [ ] Navegar portal `security.microsoft.com` sin ayuda
- [ ] Explicar diferencia MDE / MDI / MDCA / MDO de memoria
- [ ] Simular y resolver una alerta de MDE en sandbox
- [ ] Entender qué tablas genera cada pilar en Sentinel (`AlertInfo`, `DeviceEvents`, `IdentityLogonEvents`, `CloudAppEvents`)

### Semana 2 — Sentinel Arquitectura
- [ ] Desplegar workspace Sentinel desde cero en <15 minutos
- [ ] Conectar 3 fuentes de datos diferentes (al menos 1 nativa Microsoft, 1 CEF/Syslog)
- [ ] Crear una Watchlist y usarla en una query KQL
- [ ] Describir diferencia entre tablas Analytics, Basic y Auxiliary

### Semana 3 — Sentinel Analítica y Automatización
- [ ] Crear Scheduled rule con KQL desde cero (sin copiar)
- [ ] Crear NRT rule y entender cuándo usarla vs Scheduled
- [ ] Crear un Playbook funcional con trigger `When incident is created`
- [ ] Ejecutar 3 hunting queries y marcar bookmarks
- [ ] Escribir las 7 queries de práctica de esta nota sin referencia

### Semana 4 — Purview y Examen
- [ ] Crear una política de Insider Risk en Purview
- [ ] Crear una DLP policy y explicar sus componentes
- [ ] Score >70% en Practice Test 1
- [ ] Score >75% en Practice Test 2
- [ ] Agendar examen con voucher antes de 18 agosto 2026

---

## 📊 Tracker de Scores

| Intento | Fecha | Score | Áreas débiles identificadas |
|---------|-------|-------|----------------------------|
| Practice Test 1 | | | |
| Practice Test 2 | | | |
| Practice Test 3 | | | |
| **EXAMEN REAL** | | | |

---

## 🧠 Conceptos Críticos — Lo que más sale en el examen

> [!NOTE]
> Basado en el feedback de la comunidad y la guía oficial de abril 2026.

| Tema | Peso estimado en examen | Nivel requerido |
|------|------------------------|-----------------|
| KQL — queries de detección | Alto | Escribir sin referencia |
| Analytics Rules — tipos y configuración | Alto | Saber cuándo usar cada tipo |
| Playbooks — arquitectura Logic Apps | Alto | Crear uno funcional |
| MDE Onboarding — métodos | Medio | Saber las diferencias |
| MDI — detección de Lateral Movement | Medio | Entender qué detecta |
| Sentinel RBAC — roles y permisos | Medio | Asignar rol correcto al escenario |
| Watchlists — creación y uso en KQL | Medio | Uso con `_GetWatchlist()` |
| Insider Risk — políticas y casos | Bajo-Medio | Saber crear y gestionar |
| DLP — políticas y ubicaciones | Bajo-Medio | Distinguir endpoint vs cloud |
| Fusion Rule — qué es y límites | Bajo | No editable, detección ML |

---

*Plan creado el 2026-06-17 | Arquitecto tutor: Microsoft Security Architect perspective*  
*Vault: [[00_INDEX_SC200]] | Cheatsheet: [[CHEATSHEET_KQL]]*
