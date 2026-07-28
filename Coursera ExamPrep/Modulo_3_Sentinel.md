---
tags: [sc-200, coursera, sentinel, siem, soar, kql, sintesis-curso]
fecha: 2026-06-22
ultima_actualizacion: 2026-06-22
estado: 🟢 Síntesis inicial (pendiente ajuste con transcripciones)
tipo: Síntesis de módulo
relacionado: "[[00_INDEX_Coursera_SC200]], [[01_Semana1_Sentinel_Fundamentos]], [[CHEATSHEET_KQL]], [[CONCEPTOS_CLAVE]]"
---

# 🌐 Módulo 3 — Microsoft Sentinel

> **Idea central:** Sentinel es el SIEM/SOAR cloud-native de Microsoft que unifica la recolección de datos, detección de amenazas, investigación y respuesta automatizada sobre un único workspace de Log Analytics — eliminando la infraestructura local y escalando con el volumen de datos de entornos híbridos y multi-cloud.

---

## 1. Arquitectura General

> [!note] Por qué importa para el SC-200
> El SC-200 evalúa si entiendes la capa de dependencias de Sentinel: sin LAW no hay Sentinel. Preguntas frecuentes sobre workspace planning y costes.

Sentinel se construye **sobre** un **Log Analytics Workspace (LAW)**, que a su vez es parte de **Azure Monitor**.

```
┌─────────────────────────────────────────────────┐
│              Microsoft Sentinel                  │
│  Analytics | Incidents | Hunting | Automation   │
│  Workbooks | Watchlists | Notebooks | UEBA       │
├─────────────────────────────────────────────────┤
│          Log Analytics Workspace (LAW)           │
│       Ingestion · Retention · KQL Engine         │
├─────────────────────────────────────────────────┤
│                 Azure Monitor                    │
│    Diagnostic Settings · Metrics · Alerts        │
└─────────────────────────────────────────────────┘
```

### Workspace Planning

| Decisión | Criterio recomendado |
|---|---|
| **Número de workspaces** | Un workspace por tenant en la mayoría de casos; múltiples solo si hay reqs. regulatorios, RBAC granular o latencia regional |
| **Región** | Misma región que la mayoría de recursos para reducir costes de egreso |
| **Multi-tenant** | Usar **Azure Lighthouse** para proyectar workspaces de clientes al tenant del proveedor MSSP |
| **RBAC** | Asignar roles de Sentinel (ver §7); LAW tiene RBAC propio independiente |
| **Costes** | Pay-as-you-go (por GB ingerido) vs Commitment Tiers (1 GB/día hasta 500+ GB/día) — Commitment Tiers más baratos a volumen |

> [!tip] Para el examen
> Azure Lighthouse = escenario MSSP multi-tenant. Si el enunciado dice "proveedor administra Sentinel de varios clientes", la respuesta involucra Lighthouse.

---

## 2. Data Connectors

### Tipos de conectores

| Tipo | Ejemplos | Mecanismo |
|---|---|---|
| **Microsoft service connectors** | M365 Defender, Entra ID, Defender for Cloud, Office 365 | API nativa, 1-click |
| **Diagnostic Settings** | Recursos Azure (NSG, Key Vault, Activity Log) | ARM Diagnostic Settings → LAW |
| **AMA Agent (Azure Monitor Agent)** | VMs Windows/Linux on-prem o Azure | Agent instalado, reemplaza MMA/OMS |
| **CEF / Syslog** | Firewalls, appliances Linux | Forwarder server → Syslog → CEF parser |
| **Codeless Connector Platform (CCP)** | Conectores custom sin código (JSON config) | REST API polling |
| **API / Custom** | Conectores de terceros vía REST | Log ingestion API o Azure Functions |

### Content Hub y Solutions

- **Content Hub** es el marketplace dentro de Sentinel para instalar **solutions** (paquetes de conectores + analytics rules + workbooks + playbooks + hunting queries).
- Permite descubrir y desplegar threat-hunting content de Microsoft y la comunidad.
- Ejemplo: instalar la solución "Palo Alto Networks" despliega de una vez el conector CEF, reglas analíticas y workbooks asociados.

> [!example]
> Escenario examen: "Quieres monitorear Azure Activity Log en Sentinel" → Habilitar conector **Azure Activity** (Diagnostic Settings). No necesitas instalar agente.

---

## 3. Tablas de Datos y Normalización ASIM

Las tablas más comunes en Sentinel/LAW:

| Tabla | Datos |
|---|---|
| `SecurityEvent` | Eventos Windows (ID 4624, 4625, 4688…) |
| `SigninLogs` | Logins de Entra ID |
| `AuditLogs` | Operaciones en Entra ID |
| `OfficeActivity` | Actividad Office 365 |
| `CommonSecurityLog` | Logs CEF de firewalls/appliances |
| `Syslog` | Eventos Syslog Linux |
| `AzureActivity` | Operaciones en plano de control Azure |
| `ThreatIntelligenceIndicator` | IOCs de feeds TI |
| `BehaviorAnalytics` | Output de UEBA |
| `SecurityAlert` | Alertas generadas por analytics rules |
| `SecurityIncident` | Incidentes en Sentinel |

**ASIM (Advanced Security Information Model):** capa de normalización que estandariza datos de distintas fuentes en esquemas comunes (ej. `imAuthentication`, `imNetworkSession`, `imProcess`). Permite escribir queries KQL agnósticas a la fuente.

> [!tip] Para el examen
> ASIM usa **parser functions** (`imAuthentication()` en vez de `SigninLogs | union ...`). Si el enunciado menciona "normalización" o "query independiente de la fuente", piensa ASIM.

---

## 4. Analytics Rules

> [!note] Por qué importa para el SC-200
> Sección MUY preguntada. Debes conocer los 6 tipos, sus diferencias y cuándo usar cada uno.

### Tipos de Analytics Rules

| Tipo | Cómo funciona | Cuándo usarlo |
|---|---|---|
| **Scheduled** | KQL query que corre cada N minutos sobre una ventana de lookback | Detecciones custom basadas en logs |
| **NRT (Near-Real-Time)** | Query KQL que corre ~cada 1 minuto; latencia mínima | Detecciones críticas que no pueden esperar 5+ min |
| **Microsoft Security / Incident Creation** | Convierte alertas de productos Microsoft (MDE, MDO, MDI…) en incidentes Sentinel | Integrar alertas del M365 Defender stack |
| **Fusion (ML)** | Correlaciona señales débiles de múltiples productos con ML para detectar ataques multi-stage | Detección automática de kill chains; no configurable manualmente |
| **Anomaly / ML Behavior Analytics** | Modelos ML sobre baseline de comportamiento | Detectar desviaciones sin umbral fijo (complementa UEBA) |
| **Threat Intelligence** | Correlaciona logs con IOCs de la tabla `ThreatIntelligenceIndicator` | Matching de IPs/dominios/hashes contra feeds TI |

### Componentes de una Scheduled Rule (los más preguntados)

```
Scheduled Analytics Rule
├── Query KQL          → lógica de detección
├── Query Frequency    → cada cuánto corre (5 min – 14 días)
├── Lookback Period    → ventana de datos analizada (5 min – 14 días)
├── Threshold          → min. resultados para generar alerta
├── Entity Mapping     → extrae entidades (Account, IP, Host, URL…) de los resultados
├── MITRE ATT&CK       → tácticas y técnicas asociadas
├── Alert Grouping     → agrupa alertas similares en un incidente
└── Incident Settings  → crear incidente automáticamente o no
```

> [!tip] Para el examen
> **NRT vs Scheduled:** NRT no tiene "lookback window" configurable (es ~1 min implícita) y no soporta todos los operadores KQL (ej. `join` con tablas externas tiene limitaciones). Si el enunciado dice "latencia mínima", elige NRT.
>
> **Fusion:** no se configura, no se edita, solo se habilita. Detecta ataques multi-stage correlacionando señales de bajo fidelidad de múltiples fuentes.

---

## 5. KQL para Investigación

Para queries detalladas de KQL, consulta [[CHEATSHEET_KQL]].

### Operadores clave (resumen rápido)

| Operador | Uso |
|---|---|
| `where` | Filtrar filas |
| `project` | Seleccionar/renombrar columnas |
| `extend` | Crear columnas calculadas |
| `summarize` | Agrupar y agregar |
| `join` | Combinar tablas |
| `parse` | Extraer campos de strings |
| `render` | Visualizar (timechart, barchart…) |
| `let` | Definir variables o sub-queries |
| `union` | Combinar resultados de múltiples tablas |

### Queries de ejemplo en contexto Sentinel

**Detectar múltiples fallos de login seguidos de éxito (Password Spray / Brute Force):**

```kql
let threshold = 10;
let timeWindow = 1h;
SigninLogs
| where TimeGenerated > ago(timeWindow)
| where ResultType != "0"                          // solo fallos
| summarize FailCount = count() by UserPrincipalName, IPAddress, bin(TimeGenerated, 5m)
| where FailCount >= threshold
| join kind=inner (
    SigninLogs
    | where TimeGenerated > ago(timeWindow)
    | where ResultType == "0"                      // logins exitosos
    | project SuccessTime = TimeGenerated, UserPrincipalName, IPAddress
) on UserPrincipalName
| where SuccessTime > TimeGenerated
| project UserPrincipalName, IPAddress, FailCount, SuccessTime
```

**Buscar procesos sospechosos lanzados por Office (Living off the Land):**

```kql
SecurityEvent
| where EventID == 4688
| where ParentProcessName has_any ("winword.exe", "excel.exe", "powerpnt.exe")
| where NewProcessName has_any ("cmd.exe", "powershell.exe", "wscript.exe", "mshta.exe")
| project TimeGenerated, Computer, Account, ParentProcessName, NewProcessName, CommandLine
| order by TimeGenerated desc
```

**Correlacionar IOCs de Threat Intelligence con logins:**

```kql
ThreatIntelligenceIndicator
| where Active == true and ExpirationDateTime > now()
| where NetworkIP != ""
| join kind=inner (
    SigninLogs
    | where TimeGenerated > ago(1d)
    | project TimeGenerated, UserPrincipalName, IPAddress
) on $left.NetworkIP == $right.IPAddress
| project TimeGenerated, UserPrincipalName, IPAddress, IndicatorId, ThreatType, Confidence
```

> [!tip] Para el examen
> El SC-200 puede incluir preguntas de "qué operador usar para X tarea". `summarize` = agregaciones; `join` = correlacionar tablas; `parse` = extraer campos de columnas de texto libre; `extend` = columna calculada sin agrupar.

---

## 6. Threat Intelligence en Sentinel

Para fundamentos de TI (STIX/TAXII, IOCs, TTP) ver [[CONCEPTOS_CLAVE]] §2.

### Integración en Sentinel

| Componente | Detalle |
|---|---|
| **Conector TAXII** | Conecta a feeds externos TAXII 2.0/2.1; poll cada N minutos |
| **Conector Threat Intelligence Platforms** | Integra con plataformas TI (MISP, Anomali…) vía API |
| **Tabla `ThreatIntelligenceIndicator`** | Almacena IOCs importados (IPs, dominios, hashes, URLs) |
| **Analytics Rule tipo TI** | Correlaciona automáticamente logs con IOCs activos |
| **TI Workbook** | Visualiza cobertura y hits de indicadores |

- Los IOCs tienen campo `Active` y `ExpirationDateTime` — filtrar siempre en queries.
- STIX 2.1 es el estándar de formato; TAXII 2.1 es el protocolo de distribución.

> [!tip] Para el examen
> Si el enunciado dice "importar IOCs desde un feed externo" → conector TAXII. Si dice "conectar con plataforma TI existente" → conector Threat Intelligence Platforms.

---

## 7. Incident Management

### Flujo de un incidente

```
Analytics Rule detecta    →   Alert generada   →   Incident creado
                                                        │
                         ┌──────────────────────────────┤
                         ▼                              ▼
                  Investigation Graph            Incident Queue
                  (entidades + relaciones)       (triage, asignación)
                         │
                         ▼
                    Bookmarks (evidencia)
                    Entity pages (timeline)
                    Playbooks (respuesta)
```

### Elementos clave

| Elemento | Función |
|---|---|
| **Incident Queue** | Lista de incidentes; filtrar por severity, status, owner, MITRE tactic |
| **Investigation Graph** | Visualización interactiva de entidades y sus relaciones |
| **Entities** | Objetos extraídos de alertas: Account, Host, IP, URL, File, Process… |
| **Bookmarks** | Guardar resultados de queries de hunting como evidencia vinculada al incidente |
| **Comments** | Notas del analista en el incidente |
| **Tasks** | Lista de tareas asignables dentro del incidente |

---

## 8. Automatización SOAR

> [!note] Por qué importa para el SC-200
> Automation Rules vs Playbooks es uno de los temas más preguntados del examen. Debes distinguirlos con claridad.

### Automation Rules vs Playbooks

| | **Automation Rules** | **Playbooks** |
|---|---|---|
| **Motor** | Nativo de Sentinel (sin servicio externo) | Azure Logic Apps |
| **Trigger** | Incident created / updated; Alert created | Incident trigger o Alert trigger |
| **Acciones posibles** | Asignar owner, cambiar status/severity, añadir tags, correr playbook, suprimir incidente | Acciones ilimitadas: Teams, email, ITSM, bloquear IP, resetear contraseña… |
| **Orden de ejecución** | Se evalúan en orden numérico | Ejecutados por Automation Rule o manualmente |
| **Latencia** | Inmediata | Depende de Logic Apps (segundos a minutos) |
| **Caso de uso** | Lógica rápida de triage y enrutamiento | Respuesta compleja o con pasos manuales de aprobación |

### Flujo típico SOAR

```
Incidente creado
      │
      ▼
Automation Rule #1 → Si severity=High AND tactic=Exfiltration → run Playbook "Block-IP-and-Notify"
      │
      ▼
Logic App (Playbook)
  ├── Obtener IP del incidente
  ├── Llamar API de firewall para bloquear IP
  ├── Crear ticket en ServiceNow
  └── Enviar mensaje a Teams al equipo SOC
```

> [!tip] Para el examen
> - **Automation Rule** = lógica de triage simple, sin código, nativa de Sentinel.
> - **Playbook** = Logic App, para acciones externas o flujos complejos.
> - Para correr un playbook automáticamente, necesitas una Automation Rule que lo invoque.
> - El rol **Microsoft Sentinel Automation Contributor** es necesario para que Sentinel tenga permisos de ejecutar playbooks.

---

## 9. RBAC de Microsoft Sentinel

| Rol | Permisos |
|---|---|
| **Microsoft Sentinel Reader** | Ver incidentes, alertas, workbooks, datos (solo lectura) |
| **Microsoft Sentinel Responder** | Reader + gestionar incidentes (asignar, cambiar status, añadir comentarios) |
| **Microsoft Sentinel Contributor** | Responder + crear/editar analytics rules, workbooks, playbooks, conectores |
| **Microsoft Sentinel Automation Contributor** | Permite a Sentinel ejecutar playbooks en nombre del workspace |

> [!warning]
> El rol **Automation Contributor** no es para humanos — es el service principal de Sentinel. Sin este rol asignado al workspace en el resource group de la Logic App, los playbooks no pueden ejecutarse automáticamente desde Automation Rules.

---

## 10. Workbooks, Watchlists y Notebooks

### Workbooks
- Dashboards interactivos basados en Azure Monitor Workbooks.
- Usan KQL para visualizar datos de Sentinel (métricas de incidentes, actividad de usuarios, cobertura de conectores).
- Content Hub incluye workbooks prediseñados por conector/solución.

### Watchlists
- Listas de datos de referencia importadas en CSV (usuarios VIP, IPs de redes corporativas, activos críticos).
- Se consultan en KQL como tabla: `_GetWatchlist('VIP-Users')`.
- Casos de uso: reducir falsos positivos, enriquecer alertas con contexto.

```kql
// Ejemplo: alertar solo si la IP NO está en la watchlist de IPs corporativas
let CorporateIPs = (_GetWatchlist('CorporateIPs') | project IPAddress);
SecurityEvent
| where EventID == 4625
| where not (IpAddress in (CorporateIPs))
| summarize FailCount = count() by IpAddress, Account
| where FailCount > 5
```

### Notebooks (Jupyter)
- Integración con Azure Machine Learning para análisis avanzado fuera del portal.
- Casos de uso: threat hunting complejo, análisis forense, ML personalizado.
- Acceso a datos Sentinel mediante la librería **MSTICPY** (Microsoft Threat Intelligence Python).

---

## 11. UEBA (User and Entity Behavior Analytics)

- Analiza el comportamiento de usuarios, hosts, IPs y aplicaciones para establecer baselines y detectar anomalías.
- Requiere habilitar UEBA en la configuración de Sentinel y seleccionar fuentes de datos (Entra ID, Active Directory, Microsoft 365).
- Output en tabla `BehaviorAnalytics` y `UserPeerAnalytics`.
- Genera **Insights** en las entity pages (ej. "este usuario inició sesión desde un país nuevo").
- Las **Anomaly rules** (tipo ML Behavior Analytics) son el output de reglas basadas en UEBA.

> [!tip] Para el examen
> UEBA requiere licencia específica (Microsoft Sentinel con UEBA habilitado). Las entity pages muestran un timeline de actividad + insights de UEBA. Si el enunciado dice "detectar comportamiento inusual de usuarios sin reglas predefinidas", piensa UEBA + Anomaly rules.

---

## 12. Deploy, Monitor y Optimizar Sentinel

### Pasos de deployment recomendados

1. Crear LAW en la región correcta.
2. Habilitar Microsoft Sentinel sobre el LAW.
3. Configurar data connectors por prioridad (Microsoft services primero).
4. Instalar Content Hub solutions relevantes.
5. Revisar y habilitar analytics rules de las solutions instaladas.
6. Configurar automation rules básicas (asignación de incidentes, supresión de ruido).
7. Habilitar UEBA.
8. Configurar workbooks de monitoreo operacional.

### Optimización de costes

| Palanca | Acción |
|---|---|
| **Commitment Tiers** | Cambiar a tier de compromiso si > 100 GB/día |
| **Data retention** | Ajustar retención por tabla (default 90 días; mínimo 30 gratis con Sentinel) |
| **Basic Logs** | Tablas de alta volumen/bajo valor (ej. logs de red verbose) en tier "Basic" — más barato, KQL limitado |
| **Filtrado en conector** | Algunos conectores (AMA) permiten filtrar eventos antes de ingerir |
| **Workspace transformation rules** | Descartar/filtrar columnas en tiempo de ingesta con DCR transformations |

> [!warning]
> Eliminar datos innecesarios en la capa de ingestión (DCR transformations) es más eficiente que filtrar en KQL después — los datos ya ingeridos se cobran independientemente de si los consultas.

---

## 🎴 Flash Cards

**Q: ¿Cuál es la diferencia principal entre Automation Rules y Playbooks?**
A: Automation Rules son nativas de Sentinel (sin motor externo), ejecutan acciones simples de triage; Playbooks son Logic Apps que permiten acciones complejas externas. Las Automation Rules pueden invocar Playbooks.

**Q: ¿Qué tipo de Analytics Rule usa ML para correlacionar señales débiles de múltiples productos y detectar ataques multi-stage?**
A: Fusion (ML). No es configurable manualmente, solo se habilita.

**Q: ¿Qué rol de Sentinel necesita un humano para crear analytics rules y workbooks?**
A: Microsoft Sentinel Contributor.

**Q: ¿Cuál es el rol que debe asignarse al workspace para que los playbooks se ejecuten automáticamente desde Automation Rules?**
A: Microsoft Sentinel Automation Contributor (es para el service principal de Sentinel, no para humanos).

**Q: ¿Qué es ASIM y para qué sirve?**
A: Advanced Security Information Model — capa de normalización de Sentinel que estandariza logs de diferentes fuentes en esquemas comunes, permitiendo queries KQL independientes de la fuente.

**Q: ¿Cómo se integran IOCs externos de un feed TAXII en Sentinel?**
A: Mediante el conector TAXII, que hace polling al endpoint TAXII 2.x y almacena los indicadores en la tabla `ThreatIntelligenceIndicator`.

**Q: ¿Qué mecanismo usarías para que un analista SOC de un MSSP gestione Sentinel de múltiples clientes desde un solo tenant?**
A: Azure Lighthouse — proyecta los workspaces de clientes al tenant del proveedor.

**Q: ¿Qué son las Watchlists y cómo se usan en KQL?**
A: Listas CSV de referencia (VIPs, IPs corporativas…). Se consultan con `_GetWatchlist('NombreLista')`.

**Q: ¿Cuál es la diferencia entre NRT y Scheduled analytics rules?**
A: NRT corre ~cada 1 minuto con latencia mínima, sin lookback configurable ni soporte completo de KQL. Scheduled corre cada N minutos (mín. 5) con ventana de lookback configurable.

**Q: ¿Qué tabla contiene los resultados de análisis de comportamiento de UEBA?**
A: `BehaviorAnalytics` (y `UserPeerAnalytics` para comparación con pares).

---

## ✅ Checklist SC-200 — Módulo 3

- [ ] Explicar la arquitectura Sentinel → LAW → Azure Monitor
- [ ] Describir los 5 tipos de data connectors y cuándo usar cada uno
- [ ] Nombrar los 6 tipos de analytics rules y sus diferencias clave
- [ ] Explicar todos los componentes de una Scheduled rule (query, frequency, lookback, threshold, entity mapping, MITRE, alert grouping)
- [ ] Distinguir NRT vs Scheduled (cuándo usar cada uno)
- [ ] Explicar Fusion ML (qué es, si es configurable)
- [ ] Escribir o interpretar queries KQL básicas: `where`, `summarize`, `join`, `extend`, `parse`
- [ ] Explicar ASIM y el uso de parser functions
- [ ] Describir el flujo completo de un incidente en Sentinel (alert → incident → investigation)
- [ ] Distinguir Automation Rules vs Playbooks (motor, acciones, cuándo usar)
- [ ] Enumerar los 4 roles RBAC de Sentinel y sus permisos
- [ ] Explicar el rol Automation Contributor (para qué es, quién lo necesita)
- [ ] Describir Threat Intelligence en Sentinel: conector TAXII, tabla ThreatIntelligenceIndicator, analytics rule TI
- [ ] Explicar Watchlists y uso en KQL con `_GetWatchlist()`
- [ ] Describir UEBA: qué analiza, qué habilita, tablas de output
- [ ] Explicar workspace planning: cuándo usar múltiples workspaces, Azure Lighthouse para MSSP
- [ ] Describir estrategias de optimización de costes (Commitment Tiers, Basic Logs, DCR transformations)
- [ ] Identificar el propósito de Content Hub y las solutions

---

## 🔗 Notas Relacionadas

- [[00_INDEX_Coursera_SC200]] — Índice general del curso
- [[01_Semana1_Sentinel_Fundamentos]] — Fundamentos de Sentinel (Módulo 1-2)
- [[CHEATSHEET_KQL]] — Referencia completa de KQL con operadores y queries
- [[CONCEPTOS_CLAVE]] — Glosario técnico; §2 para Threat Intelligence (STIX/TAXII/IOCs)

---

*Nota creada el 2026-06-22 | Síntesis Coursera SC-200 — Módulo 3*
