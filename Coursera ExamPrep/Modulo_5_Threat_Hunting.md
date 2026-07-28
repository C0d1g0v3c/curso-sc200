---
tags: [sc-200, coursera, threat-hunting, mitre-attack, kql, sentinel, sintesis-curso]
fecha: 2026-06-22
ultima_actualizacion: 2026-06-22
estado: 🟢 Síntesis inicial (pendiente ajuste con transcripciones)
tipo: Síntesis de módulo
relacionado: "[[00_INDEX_Coursera_SC200]], [[Modulo_3_Sentinel]], [[CONCEPTOS_CLAVE]], [[CHEATSHEET_KQL]]"
---

# 🎯 Módulo 5 — Microsoft Sentinel: Threat Hunting

> **Idea central:** El threat hunting proactivo con Microsoft Sentinel consiste en formular hipótesis sobre amenazas no detectadas, construir queries KQL para buscarlas en los datos, analizar resultados y —si el hunt tiene éxito— promover los hallazgos a incidentes o convertirlos en reglas analíticas permanentes. MITRE ATT&CK es el mapa que guía las hipótesis; Sentinel provee las herramientas (Hunting page, Livestream, Notebooks) para ejecutarlas.

---

## 1. Threat Hunting: Fundamentos

### 1.1 Proactivo vs. Reactivo

| Dimensión | Detección reactiva (Analytics Rules) | Threat Hunting proactivo |
|---|---|---|
| Disparo | Alerta automática al cumplirse una condición | Analista ejecuta manualmente una investigación |
| Hipótesis | La regla ya codifica el patrón conocido | El analista define una hipótesis sobre amenaza no vista |
| Resultado | Incidente creado automáticamente | Hallazgo → Bookmark → Incidente (manual) |
| Cobertura | Amenazas conocidas y modeladas | Amenazas avanzadas, latentes, APTs |
| Trigger | Continuo / scheduled | On-demand o Livestream |

> [!note] Por qué importa para el SC-200
> El examen distingue claramente entre analytics rules (detección automática) y hunting (investigación manual proactiva). Debes saber cuándo usar cada uno, qué herramientas corresponden y cómo se conectan (hunt exitoso → analytics rule).

### 1.2 El Ciclo de Hunting

```
┌─────────────────────────────────────────────────────────┐
│                   CICLO DE HUNTING                       │
│                                                         │
│  1. HIPÓTESIS                                           │
│     ↓  ("¿Hay movimiento lateral via PsExec?")         │
│  2. QUERY KQL                                           │
│     ↓  (construir en Hunting > Queries)                │
│  3. EJECUTAR & ANALIZAR                                 │
│     ↓  (revisar resultados, buscar anomalías)          │
│  4. REFINAR                                             │
│     ↓  (ajustar filtros, ampliar/acotar tiempo)        │
│  5a. RESULTADO NEGATIVO → documentar, ajustar hipótesis │
│  5b. RESULTADO POSITIVO                                 │
│       ↓                                                 │
│       Marcar filas como BOOKMARK                        │
│       ↓                                                 │
│       Promover Bookmark a INCIDENT                      │
│       O convertir query en ANALYTICS RULE               │
└─────────────────────────────────────────────────────────┘
```

### 1.3 Modelos de Hunting

| Modelo | Descripción | Ejemplo |
|---|---|---|
| Hipótesis-driven | Analista formula una suposición basada en inteligencia o experiencia | "Creo que hay un adversario usando Living-off-the-Land" |
| IOC-driven | Buscar indicadores concretos (hashes, IPs, dominios) | Buscar SHA256 de malware conocido en DeviceFileEvents |
| TTP-driven (MITRE) | Buscar patrones de comportamiento mapeados a ATT&CK | Buscar T1059.001 (PowerShell) con flags sospechosos |
| Anomaly-driven | Detectar desviaciones estadísticas del baseline | Procesos raros ejecutados en múltiples hosts el mismo día |

### 1.4 Pyramid of Pain

Concepto clave para entender qué nivel de IoC hace más daño al adversario si lo bloqueas:

```
         /\
        /TT\        ← TTPs (máximo dolor al adversario)
       /----\
      / Tools \     ← Herramientas (alto valor)
     /----------\
    /  Network   \  ← Artefactos de red
   /--------------\
  /  Host Artifacts \ ← Artefactos de host
 /------------------\
/   Domain Names     \← Dominio (fácil de cambiar)
/--------------------\
       IP / Hash      ← Trivial de cambiar para el atacante
```

> [!tip] Para el examen
> Hunting orientado a TTPs (parte alta de la pirámide) es más resistente a la evasión del adversario que bloquear IPs o hashes. Sentinel mapea cada hunting query a una táctica/técnica de MITRE ATT&CK.

---

## 2. MITRE ATT&CK Aplicado al Hunting

> [!note] Sin duplicar [[CONCEPTOS_CLAVE]] §1
> Las 14 tácticas (Reconnaissance → Impact) y la estructura ATT&CK están cubiertas en [[CONCEPTOS_CLAVE]] §1. Este módulo se enfoca en **cómo usar ATT&CK para guiar hunts**, no en re-explicar las tácticas.

### 2.1 ATT&CK como Mapa de Hipótesis

El flujo práctico:

1. Selecciona una táctica de interés (ej. **Persistence** - TA0003).
2. Elige técnicas plausibles según el entorno (ej. T1053 Scheduled Task, T1547 Registry Run Keys).
3. Formula hipótesis: "¿Hay scheduled tasks creadas fuera del horario de trabajo por cuentas no-admin?"
4. Construye la query KQL que busca exactamente ese patrón de comportamiento.
5. Ejecuta en Sentinel Hunting; analiza resultados.

### 2.2 Mapa de Cobertura y Gap Analysis

```
┌──────────────┬─────────────────────────────────────────┐
│ Táctica      │ Cobertura en Sentinel (hunting queries)  │
├──────────────┼─────────────────────────────────────────┤
│ Initial Access │ ✅ Phishing, Exploit Public-Facing App  │
│ Execution    │ ✅ PowerShell, WMI, scripting            │
│ Persistence  │ ✅ Scheduled tasks, registry, services   │
│ Priv. Escal. │ ✅ Token impersonation, UAC bypass       │
│ Defense Eva. │ ✅ Obfuscation, log clearing             │
│ Credential   │ ✅ LSASS dump, Kerberoasting             │
│ Discovery    │ ⚠️ Parcial (depende de data sources)    │
│ Lateral Mov. │ ✅ PsExec, WMI lateral, Pass-the-Hash   │
│ C2           │ ✅ Beaconing, DNS tunneling              │
│ Exfiltration │ ⚠️ Requiere DLP/CASB integrado         │
│ Impact       │ ✅ Ransomware, data destruction          │
└──────────────┴─────────────────────────────────────────┘
```

**Gap analysis**: Si una táctica no tiene queries built-in relevantes para tu entorno, es candidata a crear una hunting query custom. Esa brecha es precisamente donde el adversario puede operar sin ser detectado.

> [!tip] Para el examen
> Sentinel muestra el MITRE ATT&CK mapping de cada hunting query en la columna "Tactics". Puedes filtrar la página de Hunting por táctica para focalizar el trabajo. Identificar gaps de cobertura = hunting proactivo.

---

## 3. Hunting en Microsoft Sentinel

### 3.1 La Página Hunting (Threat Management > Hunting)

Componentes principales:

| Elemento | Descripción |
|---|---|
| **Queries** tab | Biblioteca de cientos de hunting queries built-in + custom |
| **Hunts** tab | Permite agrupar queries en una "campaña" de hunting con objetivo definido |
| **Bookmarks** tab | Filas de resultados marcadas como relevantes durante el hunt |
| **Livestream** tab | Ejecución near-real-time de queries contra eventos nuevos |
| Columna Tactics | MITRE ATT&CK táctica(s) de cada query |
| Columna Techniques | MITRE ATT&CK técnica(s) específica(s) |
| Run all queries | Ejecuta todas las queries seleccionadas y muestra conteo de resultados |

### 3.2 Hunting Queries: Built-in vs. Custom

**Built-in**: Sentinel incluye cientos de queries pre-construidas por Microsoft y la comunidad. Se pueden ejecutar, clonar y modificar.

**Custom**: Puedes crear tus propias queries en KQL, asignarles tácticas/técnicas MITRE, y guardarlas en la biblioteca. Las queries exitosas pueden guardarse como analytics rules desde el mismo menú.

### 3.3 Bookmarks: Del Hallazgo al Incidente

El flujo de un hallazgo positivo:

```
Query ejecutada → Resultados en tabla
        ↓
Analista identifica fila(s) sospechosas
        ↓
Selecciona fila → "Add bookmark"
        ↓  (puede agregar notas, tags, MITRE mapping)
Bookmark guardado en pestaña Bookmarks
        ↓
Opciones:
  A) Investigate → abre el investigation graph
  B) Create incident → genera incidente directamente
  C) Add to existing incident → agrega evidencia a incidente ya abierto
```

> [!warning] Diferencia clave para el examen
> Los **Bookmarks** no son alertas automáticas. Son marcadores manuales que el analista crea durante un hunt. Se promueven a incidente de forma explícita. Esto contrasta con las analytics rules, que crean incidentes automáticamente.

### 3.4 Hunts (Campañas de Hunting)

La pestaña **Hunts** permite organizar un esfuerzo de hunting estructurado:
- Definir objetivo / hipótesis del hunt
- Asociar múltiples queries al hunt
- Registrar el estado (Active, Closed)
- Documentar hallazgos y bookmarks relacionados
- Colaboración entre analistas del SOC

---

## 4. Livestream

### 4.1 Qué es Livestream

Livestream permite ejecutar una hunting query de forma **continua o near-real-time** y recibir notificaciones cuando hay nuevas coincidencias. Es el punto medio entre una query manual y una analytics rule.

```
┌────────────────────────────────────────────────────────┐
│               COMPARATIVA DE EJECUCIÓN                 │
├──────────────┬──────────────┬───────────────────────── │
│              │ Query Manual │ Livestream │ Analytics R.│
├──────────────┼──────────────┼────────────┼─────────────┤
│ Frecuencia   │ Una vez      │ Continua   │ Scheduled   │
│ Notificación │ No           │ Sí (toast) │ Alerta/Inc. │
│ Incidente    │ Manual (bkm) │ Manual     │ Automático  │
│ Uso típico   │ Exploración  │ Monitoring │ Producción  │
│              │ inicial      │ de un hunt │ continuo    │
└──────────────┴──────────────┴────────────┴─────────────┘
```

### 4.2 Cuándo Usar Livestream

- Durante un **incident response activo**: quieres monitorear si el adversario sigue activo en tiempo real.
- Para **validar una hipótesis** antes de convertirla en analytics rule.
- Cuando necesitas monitorear una situación específica temporalmente sin crear una regla permanente.

> [!tip] Para el examen
> Livestream NO crea incidentes automáticamente. Notifica al analista que hay coincidencias; el analista decide qué hacer. Diferente de Scheduled Analytics Rules que sí crean alertas/incidentes.

---

## 5. Notebooks (Jupyter) para Hunting Avanzado

### 5.1 Cuándo Usar Notebooks vs. Queries KQL

| Escenario | Herramienta recomendada |
|---|---|
| Hunt estándar con datos en Log Analytics | KQL en Hunting page |
| Análisis estadístico avanzado, ML, clustering | Jupyter Notebook |
| Correlación con fuentes externas (VirusTotal, WHOIS) | Jupyter Notebook |
| Visualizaciones complejas personalizadas | Jupyter Notebook |
| Threat intel enrichment automatizado | Jupyter Notebook |

### 5.2 MSTICPy

**MSTICPy** (Microsoft Threat Intelligence Center Python) es la librería Python diseñada para usar con los Notebooks de Sentinel:
- Conecta directamente a Log Analytics workspace
- Funciones helper para queries KQL desde Python
- Enriquecimiento con threat intel (VirusTotal, OTX, etc.)
- Análisis de timelines, grafos de entidades, clustering
- Los Notebooks de Sentinel usan Azure ML o Azure Notebooks como runtime

> [!note] Para el examen
> No se profundiza en MSTICPy a nivel de código. Debes saber que los Notebooks existen para hunting avanzado, que usan Python + MSTICPy, y que se integran con el workspace de Sentinel.

---

## 6. Principios de Construcción de Queries de Hunting

### 6.1 Filosofía: Amplio → Específico

```
Paso 1: Query AMPLIA (sin filtros agresivos)
         ↓ Ver volumen y distribución
Paso 2: SUMMARIZE para baseline
         ↓ Entender lo "normal"
Paso 3: Detectar OUTLIERS
         ↓ Filtrar lo inusual
Paso 4: Refinar con contexto
         ↓ Agregar correlaciones, tiempo, entidades
Paso 5: Query FINAL de hunting (o analytics rule)
```

### 6.2 Técnicas KQL Clave para Hunting

| Técnica | Operador KQL | Uso en hunting |
|---|---|---|
| Baselining | `summarize count() by bin(TimeGenerated, 1d)` | Ver tendencias en el tiempo |
| Outlier detection | `summarize ... \| where count_ < threshold` | Encontrar actividad rara |
| Time-series | `make-series count() on TimeGenerated` | Detectar patrones periódicos (beaconing) |
| Join entre tablas | `join kind=inner` | Correlacionar eventos de distintos orígenes |
| Argmax/Argmin | `summarize arg_max(TimeGenerated, *)` | Obtener el evento más reciente por entidad |
| Distinct count | `dcount()` | Contar usuarios/hosts únicos por proceso |

### 6.3 Queries KQL de Hunting — Ejemplos Realistas

#### Query 1: PowerShell con comandos codificados en Base64

```kql
// Hunt: Detectar PowerShell ejecutando comandos encoded (T1059.001)
// Táctica: Execution | Técnica: T1059.001 - PowerShell
SecurityEvent
| where EventID == 4688
| where Process has "powershell.exe" or Process has "pwsh.exe"
| where CommandLine has_any ("-EncodedCommand", "-enc", "-ec", "-e ")
| project TimeGenerated, Computer, Account, CommandLine, ParentProcessName
| order by TimeGenerated desc
```

> [!example]
> Este hunt busca invocaciones de PowerShell con parámetros de encoding. Los adversarios usan `-EncodedCommand` para ofuscar payloads. Un analista revisaría las líneas de comando para decodificar el Base64 y determinar si el contenido es malicioso.

---

#### Query 2: Procesos raros ejecutados en múltiples hosts (Living off the Land)

```kql
// Hunt: Identificar procesos poco comunes ejecutados en varios equipos
// Táctica: Execution / Defense Evasion | Técnica: T1218 (Signed Binary Proxy Execution)
let RareThreshold = 3;
SecurityEvent
| where EventID == 4688
| where TimeGenerated > ago(7d)
| summarize HostCount = dcount(Computer), EventCount = count() by Process
| where HostCount <= RareThreshold
| where Process !in ("svchost.exe", "lsass.exe", "csrss.exe", "wininit.exe")
| order by HostCount asc
```

> [!example]
> Procesos que corren en 1-3 hosts distintos en 7 días son candidatos a inspección. Si un LOLBin (certutil.exe, mshta.exe, regsvr32.exe) aparece aquí con HostCount = 1, merece atención inmediata.

---

#### Query 3: Detección de Beaconing (conexiones periódicas a C2)

```kql
// Hunt: Detectar posible C2 beaconing por intervalos regulares de conexión
// Táctica: Command and Control | Técnica: T1071 (Application Layer Protocol)
let TimeWindow = 24h;
let MinConnections = 10;
let JitterTolerance = 30; // segundos
CommonSecurityLog
| where TimeGenerated > ago(TimeWindow)
| where DeviceAction !in ("deny", "drop")
| summarize 
    ConnectionCount = count(),
    TimeList = make_list(TimeGenerated, 500)
  by SourceIP, DestinationIP, DestinationPort
| where ConnectionCount >= MinConnections
| extend 
    TimeDiffs = array_sort_asc(TimeList),
    AvgInterval = (todatetime(TimeList[-1]) - todatetime(TimeList[0])) / ConnectionCount
| where AvgInterval between (1min .. 60min)
| project SourceIP, DestinationIP, DestinationPort, ConnectionCount, AvgInterval
| order by ConnectionCount desc
```

> [!example]
> El beaconing es un patrón clásico de C2: el malware se conecta a su servidor cada N minutos. Este hunt busca pares IP:Puerto con muchas conexiones y un intervalo promedio regular (entre 1 y 60 minutos). Alta tasa de falsos positivos — requiere filtrar IPs legítimas conocidas.

---

#### Query 4: Logins anómalos — primer login desde país inusual

```kql
// Hunt: Detectar logins exitosos desde países que nunca antes usó el usuario
// Táctica: Initial Access / Credential Access | Técnica: T1078 (Valid Accounts)
let LookbackPeriod = 30d;
let RecentPeriod = 1d;
let HistoricalLogins = 
    SigninLogs
    | where TimeGenerated between (ago(LookbackPeriod) .. ago(RecentPeriod))
    | where ResultType == "0"
    | summarize HistoricCountries = make_set(Location) by UserPrincipalName;
SigninLogs
| where TimeGenerated > ago(RecentPeriod)
| where ResultType == "0"
| join kind=inner HistoricalLogins on UserPrincipalName
| where Location !in (HistoricCountries)
| project TimeGenerated, UserPrincipalName, Location, IPAddress, AppDisplayName, HistoricCountries
| order by TimeGenerated desc
```

> [!example]
> Este hunt compara los países de login de los últimos 30 días contra el login del último día. Un login desde un país nunca visto antes es un hallazgo de alto valor, posible Impossible Travel o cuenta comprometida.

---

## 7. Convertir un Hunt Exitoso en Analytics Rule

El lifecycle completo de un hunt positivo:

```
Hunt exitoso (Bookmark creado)
        ↓
Opción A: Promover Bookmark → Incident (caso único)
        ↓
Opción B: Guardar query como Analytics Rule
  - Abre la query en Hunting
  - Menú: "Create analytics rule"
  - Configura: scheduled query, lookback, threshold, entity mapping
  - La regla corre automáticamente de ahí en adelante
        ↓
La táctica/técnica MITRE del hunt
se hereda automáticamente a la nueva analytics rule
```

> [!tip] Para el examen
> Este es el flujo que cierra el ciclo: hunting proactivo → detección automática. Una analytics rule creada desde un hunt ya trae el MITRE mapping configurado. Debes saber que este camino existe y cómo iniciarlo desde la Hunting page.

---

## 8. SOC Efficiency Workbook / SOC Optimization

### 8.1 Qué es el SOC Efficiency Workbook

Es un **Azure Workbook** incluido en Sentinel que visualiza métricas operacionales del SOC para identificar cuellos de botella y optimizar workflows.

### 8.2 Métricas Clave

| Métrica | Definición | Objetivo |
|---|---|---|
| **MTTA** (Mean Time to Acknowledge) | Tiempo desde creación de incidente hasta primer cambio de estado | Lo más bajo posible |
| **MTTR** (Mean Time to Respond/Remediate) | Tiempo desde creación hasta cierre del incidente | Lo más bajo posible |
| Incidentes por analista | Carga de trabajo distribuida en el equipo | Detectar sobrecargas |
| True Positive Rate | % de incidentes que resultan ser reales | Optimizar reglas |
| False Positive Rate | % de incidentes descartados como benignos | Reducir alert fatigue |
| Cobertura MITRE | Tácticas/técnicas cubiertas por reglas activas | Identificar gaps |

### 8.3 Cómo Apoya la Optimización del Hunting

- Identifica qué tácticas de MITRE ATT&CK tienen **baja cobertura** → candidatas para nuevos hunts
- Muestra qué reglas generan más **false positives** → ajustar umbral o convertir en hunt manual
- Visualiza **tendencias** de incidentes para detectar campañas en curso
- Ayuda a justificar inversión en nuevas fuentes de datos (data connectors)

> [!note] Por qué importa para el SC-200
> El examen puede preguntar cómo medir la efectividad del SOC en Sentinel. MTTA y MTTR son las métricas primarias. El SOC Efficiency Workbook es la herramienta para visualizarlas dentro de Sentinel.

---

## 9. Resumen Visual del Módulo

```
┌─────────────────────────────────────────────────────────────────┐
│              THREAT HUNTING EN SENTINEL — MAPA COMPLETO         │
│                                                                 │
│  MITRE ATT&CK                                                   │
│  (Tácticas → Técnicas → TTPs)                                   │
│         ↓ guía hipótesis                                        │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │              SENTINEL HUNTING PAGE                        │   │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌────────┐  │   │
│  │  │ Queries  │  │  Hunts   │  │Bookmarks │  │ Live-  │  │   │
│  │  │ (KQL     │  │(campañas)│  │(hallazgos│  │stream  │  │   │
│  │  │ built-in │  │          │  │ marcados)│  │        │  │   │
│  │  │ + custom)│  │          │  │          │  │        │  │   │
│  └──┴──────────┴──┴──────────┴──┴──────────┴──┴────────┴──┘   │
│         ↓ hunt exitoso                                          │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │              ACCIONES POST-HUNT                           │   │
│  │  Bookmark → Incident (caso puntual)                      │   │
│  │  Query → Analytics Rule (detección continua)             │   │
│  └──────────────────────────────────────────────────────────┘   │
│         ↓ métricas                                              │
│  SOC Efficiency Workbook (MTTA, MTTR, cobertura MITRE)         │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🎴 Flash Cards

**P: ¿Cuál es la diferencia fundamental entre una Analytics Rule y un Threat Hunt en Sentinel?**
R: Las Analytics Rules detectan amenazas automáticamente y crean alertas/incidentes de forma continua. El Threat Hunting es una investigación manual proactiva donde el analista formula hipótesis, ejecuta queries y marca hallazgos como Bookmarks antes de promoverlos a incidentes.

---

**P: ¿Qué es un Bookmark en Sentinel Hunting y cómo se promueve a incidente?**
R: Un Bookmark es una fila de resultados de una hunting query que el analista marca manualmente como relevante (puede añadir notas y MITRE mapping). Desde la pestaña Bookmarks se puede crear un nuevo incidente o adjuntarlo a uno existente.

---

**P: ¿Cuándo usarías Livestream en lugar de una Analytics Rule?**
R: Livestream se usa durante hunts activos o incident response para monitorear near-real-time sin crear una regla permanente. No genera incidentes automáticamente — solo notifica al analista. Una Analytics Rule es para detección continua y automatizada en producción.

---

**P: ¿Qué son MTTA y MTTR y dónde se visualizan en Sentinel?**
R: MTTA (Mean Time to Acknowledge) = tiempo hasta primer cambio de estado del incidente. MTTR (Mean Time to Respond) = tiempo hasta cierre. Ambas se visualizan en el SOC Efficiency Workbook de Sentinel.

---

**P: ¿Cómo conviertes un hunt exitoso en detección continua?**
R: Desde la hunting query, usas la opción "Create analytics rule". La nueva regla hereda automáticamente el MITRE ATT&CK mapping de la query original y pasa a ejecutarse de forma scheduled.

---

**P: ¿Qué operador KQL usarías para detectar beaconing (conexiones periódicas C2)?**
R: `make-series` para generar time-series de conexiones, combinado con `summarize` por par de IPs y análisis de intervalos. También se puede calcular el intervalo promedio entre conexiones y filtrar por regularidad.

---

**P: ¿Para qué sirven los Notebooks (Jupyter) en Sentinel y qué librería Python se usa?**
R: Para hunting avanzado que requiere análisis estadístico, machine learning, enriquecimiento con fuentes externas o visualizaciones complejas. La librería es MSTICPy (Microsoft Threat Intelligence Center Python).

---

**P: ¿Cómo usa MITRE ATT&CK la página de Hunting de Sentinel?**
R: Cada hunting query (built-in o custom) tiene MITRE Tactics y Techniques asignadas. Puedes filtrar la biblioteca por táctica para focalizar hunts. El SOC Efficiency Workbook muestra la cobertura MITRE de las reglas activas para identificar gaps.

---

## ✅ Checklist SC-200 — Módulo 5

- [ ] Explicar la diferencia entre threat hunting proactivo y detección reactiva (analytics rules)
- [ ] Describir el ciclo de hunting: hipótesis → query → análisis → bookmark → incidente/regla
- [ ] Enumerar los 4 modelos de hunting: hipótesis-driven, IOC, TTP/MITRE, anomaly
- [ ] Saber cómo navegar la página Hunting en Sentinel (Queries, Hunts, Bookmarks, Livestream)
- [ ] Explicar qué es un Bookmark y cómo se promueve a incidente
- [ ] Distinguir Livestream de una Analytics Rule (manual vs. automático)
- [ ] Conocer el uso de MITRE ATT&CK para estructurar hipótesis de hunting y hacer gap analysis
- [ ] Saber cuándo usar Notebooks/MSTICPy en lugar de KQL puro
- [ ] Construir queries KQL básicas de hunting (PowerShell encoded, procesos raros, logins anómalos)
- [ ] Explicar cómo convertir una hunting query exitosa en analytics rule
- [ ] Definir MTTA, MTTR y saber que el SOC Efficiency Workbook los visualiza
- [ ] Entender la Pyramid of Pain y por qué hunting en TTPs es superior a IoC-based

---

## 🔗 Notas Relacionadas

- [[CONCEPTOS_CLAVE]] — §1: MITRE ATT&CK (14 tácticas, Attack Chain) — base teórica de ATT&CK
- [[CHEATSHEET_KQL]] — Referencia rápida de operadores KQL usados en las queries de este módulo
- [[Modulo_3_Sentinel]] — Arquitectura de Sentinel, data connectors, analytics rules (detección reactiva)
- [[00_INDEX_Coursera_SC200]] — Índice general del curso y estado de cada módulo

---

*Nota creada el 2026-06-22 | Síntesis Coursera SC-200 — Módulo 5*
