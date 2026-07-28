---
tags: [sc-200, conceptos, mitre, threat-intelligence, attack-chain, defender-xdr, sentinel]
fecha: 2026-06-17
ultima_actualizacion: 2026-06-17
estado: 🟡 En construcción
tipo: Referencia conceptual
relacionado: "[[00_INDEX_SC200]], [[01_Semana1_Sentinel_Fundamentos]], [[03_Semana3_Defender_XDR]], [[CHEATSHEET_KQL]]"
---
88888888888
# 
📖 Conceptos Clave — SC-200

> **Idea central:** Antes de saber manejar herramientas, el examen SC-200 evalúa que entiendas los modelos conceptuales que las sustentan. Este archivo documenta los dos marcos más importantes: el modelo de cadena de ataque y la inteligencia de amenazas.

Relacionado con: [[00_INDEX_SC200]] | [[03_Semana3_Defender_XDR]] | [[01_Semana1_Sentinel_Fundamentos]] | [[CHEATSHEET_KQL]]

---

## 1. Attack Chain Model — Modelo de Cadena de Ataque

### 1.1 Definición

El **Attack Chain Model** (o "modelo de cadena de ataque") es un marco conceptual que describe un ataque cibernético como una **secuencia ordenada de etapas**, desde el primer movimiento del adversario hasta el logro de su objetivo final. La premisa central es que un ataque raramente es un evento instantáneo: es una cadena donde cada etapa habilita la siguiente.

> [!note] Por qué importa para el SC-200
> El examen presupone que un analista SOC comprende en qué etapa de la cadena se encuentra una alerta. Esto determina la **urgencia de la respuesta**, el **scope de la investigación** y qué herramienta usar. Microsoft Sentinel etiqueta cada alerta con tácticas y técnicas MITRE ATT&CK; sin entender la cadena de ataque, esa información no tiene contexto.

---

### 1.2 Cyber Kill Chain (Lockheed Martin)

El modelo original, publicado en 2011 por Lockheed Martin. Define **7 etapas lineales**:

| #   | Etapa                      | Qué hace el atacante                             | Ejemplo concreto                                      |
| --- | -------------------------- | ------------------------------------------------ | ----------------------------------------------------- |
| 1   | **Reconnaissance**         | Recopilar información del objetivo               | Escaneo de puertos, OSINT en LinkedIn                 |
| 2   | **Weaponization**          | Preparar el payload / exploit                    | Empaquetar malware en un documento Word               |
| 3   | **Delivery**               | Entregar el payload a la víctima                 | Email de phishing con adjunto malicioso               |
| 4   | **Exploitation**           | Ejecutar el exploit en el sistema                | CVE explotado al abrir el documento                   |
| 5   | **Installation**           | Establecer persistencia en el sistema            | Dropper instala RAT en `AppData\Roaming`              |
| 6   | **Command & Control (C2)** | Establecer canal de comunicación con el atacante | Beacon a servidor C2 cada 60 segundos                 |
| 7   | **Actions on Objectives**  | Lograr el objetivo final                         | Exfiltración de datos, ransomware, movimiento lateral |

> [!tip] Limitación del Kill Chain clásico
> El modelo de Lockheed Martin es lineal y fue diseñado pensando en APTs contra infraestructura crítica. No modela bien ataques internos, ataques en cloud-native, ni movimiento lateral post-explotación avanzado. Para eso existe MITRE ATT&CK.

---

### 1.3 Framework MITRE ATT&CK

**MITRE ATT&CK** (Adversarial Tactics, Techniques & Common Knowledge) es una base de conocimiento de libre acceso que documenta el comportamiento real de adversarios observado en el mundo.

La estructura es:

```
TACTIC (¿Por qué? — objetivo del adversario)
  └─ TECHNIQUE (¿Cómo? — método general)
       └─ SUB-TECHNIQUE (¿Cómo exactamente? — variante específica)
```

#### Tácticas principales (las 14 de ATT&CK Enterprise)

| ID | Táctica | Descripción |
|----|---------|-------------|
| TA0043 | **Reconnaissance** | Recopilar información antes del ataque |
| TA0042 | **Resource Development** | Construir infraestructura de ataque |
| TA0001 | **Initial Access** | Ganar entrada al entorno |
| TA0002 | **Execution** | Ejecutar código malicioso |
| TA0003 | **Persistence** | Mantener acceso a través del tiempo |
| TA0004 | **Privilege Escalation** | Ganar permisos más altos |
| TA0005 | **Defense Evasion** | Evitar ser detectado |
| TA0006 | **Credential Access** | Robar credenciales |
| TA0007 | **Discovery** | Entender el entorno comprometido |
| TA0008 | **Lateral Movement** | Moverse a otros sistemas |
| TA0009 | **Collection** | Reunir datos de interés |
| TA0011 | **Command & Control** | Comunicarse con sistemas comprometidos |
| TA0010 | **Exfiltration** | Sacar datos del entorno |
| TA0040 | **Impact** | Afectar disponibilidad/integridad (ransomware, wiper) |

> [!note] Diferencia Kill Chain vs ATT&CK
> Kill Chain modela la **secuencia del ataque** (útil para defensa en capas). ATT&CK documenta **técnicas específicas** (útil para crear reglas de detección y hacer hunting). El SC-200 evalúa ATT&CK con más profundidad porque es lo que usa Sentinel para etiquetar incidentes.

---

### 1.4 Cómo Microsoft modela la cadena de ataque

Microsoft integra el modelo de cadena de ataque en sus productos de forma nativa, correlacionando señales de **múltiples productos** en un **único incidente**.

#### Defender XDR — Attack Story / Attack Graph

Cuando se conecta Defender XDR a Sentinel (ver [[03_Semana3_Defender_XDR]]), el portal unificado `security.microsoft.com` construye automáticamente la **historia del ataque** (Attack Story):

```
EMAIL PHISHING detectado por MDO
          ↓  (misma IP, mismo usuario)
EJECUCIÓN de PowerShell detectada por MDE en endpoint
          ↓  (mismo usuario comprometido)
MOVIMIENTO LATERAL detectado por MDI en Active Directory
          ↓  (misma cuenta usada en Azure)
ACCESO A DATOS detectado por MDCA en SharePoint
          ↓
Un solo INCIDENT en Sentinel con:
  • 4 alertas correlacionadas
  • Attack Graph visual de la cadena completa
  • Entidades (usuario, host, IP, email) vinculadas
  • Tácticas MITRE mapeadas: Initial Access → Execution → Lateral Movement → Collection
```

> [!tip] Attack Graph en el examen
> El examen pregunta sobre qué información aparece en el **investigation graph** de un incident. La respuesta siempre incluye: entidades relacionadas, alertas que componen el incident, y las tácticas MITRE ATT&CK identificadas.

#### Sentinel — Fusion Rule y correlación multi-stage

La regla **Fusion** de Sentinel (tipo ML, no editable) es la implementación nativa del attack chain model:

- Correlaciona **señales de baja fidelidad** de múltiples fuentes que individualmente no generarían alerta
- Las combina cuando forman un patrón de ataque coherente (ej. anomalía de login + descarga inusual de datos = posible exfiltración)
- Mapea automáticamente a tácticas MITRE ATT&CK
- Genera un **incident de alta confianza** sin falsos positivos frecuentes

```
Reglas Scheduled → generan alertas individuales (señales débiles)
      +
Reglas Anomaly  → comportamiento inusual (señales débiles)
      +
Señales de Defender XDR
      ↓
Fusion Rule ML correlaciona
      ↓
Incident multi-stage con attack chain completa
```

#### Cómo Sentinel mapea a MITRE ATT&CK

En cada Analytics Rule (ver [[01_Semana1_Sentinel_Fundamentos]]) existe el campo **MITRE ATT&CK** donde se configura:
- La **táctica** (ej. `Credential Access`)
- La **técnica** (ej. `T1110 - Brute Force`)

Esto permite:
1. Ver el **mapa de cobertura de detección** en `Sentinel → Threat Management → MITRE ATT&CK`
2. Filtrar incidents por táctica para priorizar respuesta
3. Identificar **gaps** en la cobertura (tácticas sin reglas asociadas)

---

### 1.5 Ejemplo práctico — Ataque BEC (Business Email Compromise)

```
ETAPA 1 — Initial Access (TA0001)
  • Técnica: T1566.002 Spearphishing Link
  • Alerta: MDO detecta email con link malicioso
  • En Sentinel: EmailEvents | where ThreatTypes has "Phish"

ETAPA 2 — Credential Access (TA0006)
  • Técnica: T1110 Brute Force / T1078 Valid Accounts
  • Alerta: MDI / AAD detecta logins desde IP nueva en país inusual
  • En Sentinel: SigninLogs | where RiskLevelDuringSignIn == "high"

ETAPA 3 — Collection (TA0009)
  • Técnica: T1114.002 Email Collection - Remote Email Collection
  • Alerta: MDCA detecta descarga masiva de emails desde OWA
  • En Sentinel: OfficeActivity | where Operation == "MailboxLogin"

ETAPA 4 — Impact (TA0040) o Exfiltration (TA0010)
  • Técnica: T1567 Exfiltration over Web Service
  • Alerta: MDCA detecta upload a Dropbox personal

→ Defender XDR correlaciona las 4 alertas en 1 incident
→ El Attack Graph muestra la cadena completa
→ El analista responde al incident, no a 4 alertas sueltas
```

---

## 2. Threat Intelligence — Inteligencia de Amenazas

### 2.1 Definición

**Threat Intelligence (TI)** es el conocimiento basado en evidencia sobre amenazas existentes o emergentes, que incluye contexto, mecanismos, indicadores, implicaciones y consejos orientados a la acción. Su propósito es permitir **decisiones informadas** sobre la respuesta a amenazas.

> [!note] Por qué importa para el SC-200
> El Dominio 2 del examen (Configure Protections & Detections, ~40%) incluye explícitamente "Threat Intelligence integration". El examen evalúa cómo conectar fuentes de TI a Sentinel, cómo crear reglas que detecten IOCs, y cómo usar MDTI para enriquecer investigaciones.

---

### 2.2 Tipos de Threat Intelligence

| Tipo | Audiencia | Contenido | Ejemplo |
|------|-----------|-----------|---------|
| **Estratégica** | Ejecutivos / CISO | Tendencias de amenazas, actores, motivaciones | "Ransomware dirigido a sector salud aumentó 40% en 2025" |
| **Táctica** | Arquitectos de seguridad | TTPs de actores de amenaza (Tácticas, Técnicas y Procedimientos) | "APT29 usa T1059.001 PowerShell para persistencia" |
| **Operacional** | Managers SOC / IR | Detalles de campañas activas en curso | "Campaña de phishing activa dirigida a bancos mexicanos esta semana" |
| **Técnica** | Analistas SOC (Tier 1/2) | IOCs concretos: IPs, hashes, dominios, URLs | Hash `d41d8cd98f00b204e9800998ecf8427e` asociado a Emotet |

> [!tip] Para el examen
> Cuando el SC-200 pregunta sobre "cómo un analista SOC Tier 1 usa TI", la respuesta es **IOCs técnicos** para detectar artefactos maliciosos conocidos. Cuando pregunta sobre **MDTI o Threat Analytics**, el contexto es TI operacional/táctica para enriquecer investigaciones.

---

### 2.3 Indicadores de Compromiso (IOCs) y TTPs

#### IOCs — Indicadores de Compromiso

Los IOCs son **artefactos observables** que con alta probabilidad indican actividad maliciosa:

```
TIPOS DE IOCs:
├─ Hashes de archivos      → MD5, SHA-1, SHA-256 de malware conocido
├─ Direcciones IP          → IPs de servidores C2, IPs de atacantes
├─ Dominios                → Dominios maliciosos, dominios de phishing
├─ URLs                    → URLs específicas de phishing o descarga de malware
├─ Direcciones de email    → Remitentes maliciosos
└─ Patrones de red         → User-agents, certificados SSL de C2
```

> [!note] Limitación de los IOCs
> Los IOCs son **efímeros**: un atacante puede cambiar IP o dominio en horas. Son útiles para detección rápida de amenazas conocidas, pero no son suficientes para detectar actores sofisticados que rotan infraestructura. Por eso los TTPs son más valiosos a largo plazo.

#### TTPs — Tácticas, Técnicas y Procedimientos

Los TTPs describen el **comportamiento** del atacante, no sus herramientas específicas. Son más difíciles de cambiar:

```
TÁCTICA     → ¿Qué quiere lograr? (ej. Credential Access)
TÉCNICA     → ¿Cómo lo logra? (ej. T1003 OS Credential Dumping)
PROCEDIMIENTO → ¿Con qué herramienta específicamente? (ej. Mimikatz lsass dump)
```

| Característica | IOCs | TTPs |
|---------------|------|------|
| **Vida útil** | Horas/días | Meses/años |
| **Facilidad de evasión** | Muy fácil (cambiar IP) | Difícil (cambiar técnica implica rediseñar ataque) |
| **Valor para detección** | Alto para amenazas conocidas | Alto para actores sofisticados |
| **Fuente en Sentinel** | `ThreatIntelligenceIndicator` | Analytics Rules mapeadas a MITRE ATT&CK |

---

### 2.4 Integración de Threat Intelligence en Microsoft

#### 2.4.1 Microsoft Defender Threat Intelligence (MDTI)

**MDTI** es la plataforma de inteligencia de amenazas de Microsoft, accesible desde `security.microsoft.com`:

```
MDTI OFRECE:
├─ Base de datos de IOCs con contexto enriquecido
│    → Reputación de IPs, dominios, hashes
│    → Historial de uso por grupos de amenaza
│    → Infraestructura relacionada (WHOIS, DNS pasivo)
│
├─ Perfiles de actores de amenaza
│    → Grupos APT con TTPs documentados
│    → Campañas activas y herramientas usadas
│
├─ Artículos de inteligencia
│    → Análisis técnico de campañas recientes
│    → CVEs explotados activamente
│
└─ Intel Profiles
     → Mapeo de actores a sectores objetivo
     → Indicadores específicos por actor
```

> [!tip] MDTI en el examen
> El examen pregunta sobre MDTI en el contexto de **enriquecimiento de investigaciones**: cuando un analista investiga una IP o dominio en un incident, puede buscarlo directamente en MDTI para obtener contexto sin salir del portal.

#### 2.4.2 Threat Analytics en Defender XDR

**Threat Analytics** es el módulo de TI operacional integrado en `security.microsoft.com`:

```
THREAT ANALYTICS MUESTRA:
├─ Amenazas activas relevantes para TU organización
│    → Calcula exposición basada en configuración actual
│
├─ Informes de analistas de Microsoft
│    → Descripción técnica de la campaña
│    → IOCs específicos de la amenaza
│    → Mitigaciones recomendadas
│
├─ Estado de mitigación en tu entorno
│    → ¿Estás protegido contra esta amenaza?
│    → Dispositivos expuestos / protegidos
│
└─ Reglas de detección asociadas
     → ¿Qué alertas cubrirían esta amenaza?
```

> [!example] Caso de uso de Threat Analytics
> El analista recibe una alerta de ransomware. En lugar de buscar en Google, abre Threat Analytics, filtra por el nombre del ransomware y obtiene: técnicas usadas, IOCs del grupo, estado de protección de sus endpoints, y los pasos exactos de remediación recomendados por Microsoft.

#### 2.4.3 Microsoft Sentinel — Threat Intelligence

Sentinel ofrece la integración más completa y configurable de TI. Tiene múltiples componentes:

##### Data Connector: Threat Intelligence

Existen dos conectores nativos para importar IOCs a Sentinel:

| Conector | Descripción | Protocolo |
|---------|-------------|-----------|
| **Threat Intelligence - TAXII** | Consume feeds STIX/TAXII de fuentes externas | TAXII 2.x |
| **Microsoft Defender Threat Intelligence** | Importa IOCs automáticamente desde MDTI | API interna |
| **Threat Intelligence Platforms (TIP)** | Integra plataformas TIP (MISP, ThreatConnect, Anomali, etc.) via API | REST API |

##### STIX y TAXII — Estándares de intercambio de TI

```
STIX (Structured Threat Information eXpression)
  → Formato estándar para describir IOCs y amenazas
  → Define objetos: Indicator, Malware, Campaign, Threat Actor, etc.
  → Versión actual: STIX 2.1

TAXII (Trusted Automated eXchange of Intelligence Information)
  → Protocolo de transporte para distribuir STIX
  → Funciona sobre HTTPS
  → Versión actual: TAXII 2.1

CÓMO SE CONFIGURA EN SENTINEL:
1. Sentinel → Data Connectors → "Threat Intelligence - TAXII"
2. Introducir: Friendly name, API root URL, Collection ID
3. Credenciales del feed si es privado
4. Frecuencia de importación (cada hora recomendado)
5. Los IOCs aparecen en tabla: ThreatIntelligenceIndicator
```

##### Tabla `ThreatIntelligenceIndicator`

Esta tabla es central para el SC-200. Almacena todos los IOCs importados:

```kql
// Ver IOCs importados recientemente
ThreatIntelligenceIndicator
| where TimeGenerated > ago(24h)
| project TimeGenerated, IndicatorId, Type, NetworkIP, DomainName, 
          FileHashValue, ThreatType, ConfidenceScore, ExpirationDateTime
| order by TimeGenerated desc

// Contar IOCs por tipo
ThreatIntelligenceIndicator
| where Active == true
| summarize count() by Type
| order by count_ desc

// Buscar si una IP específica está en la TI
ThreatIntelligenceIndicator
| where NetworkIP == "185.220.101.45"
| project TimeGenerated, NetworkIP, ThreatType, Description, 
          ConfidenceScore, Tags
```

Campos clave de la tabla:

| Campo | Descripción |
|-------|-------------|
| `Type` | Tipo de IOC: `ip`, `domain-name`, `url`, `file` |
| `NetworkIP` | IP maliciosa (si Type = ip) |
| `DomainName` | Dominio malicioso (si Type = domain-name) |
| `FileHashValue` | Hash del archivo malicioso |
| `FileHashType` | MD5, SHA-256, etc. |
| `ThreatType` | Categoría: `Malware`, `Phishing`, `WatchList`, etc. |
| `ConfidenceScore` | Confianza del indicador (0–100) |
| `ExpirationDateTime` | Cuándo expira el IOC |
| `Active` | Si el IOC está activo actualmente |
| `Tags` | Etiquetas personalizadas |

##### Analytics Rules de tipo "Microsoft Threat Intelligence"

Este tipo especial de regla (no confundir con las Scheduled) hace **matching automático** entre logs de tu entorno y IOCs en `ThreatIntelligenceIndicator`:

```
CÓMO FUNCIONA:
1. Microsoft publica reglas pre-construidas de este tipo
2. La regla compara en tiempo real:
   • NetworkIP en ThreatIntelligenceIndicator  ↔  IPs en tus logs
   • DomainName en ThreatIntelligenceIndicator ↔  Dominios en tus logs
   • FileHashValue en ThreatIntelligenceIndicator ↔ Hashes en DeviceEvents
3. Cuando hay match → genera alerta → crea incident
4. No requiere que escribas KQL (es automática)
```

> [!note] Reglas de TI en el examen
> El examen evalúa que sepas que estas reglas existen como tipo separado en Sentinel y que hacen matching automático. Son distintas de las reglas Scheduled que tú escribes con KQL custom.

---

### 2.5 Caso de uso práctico completo

**Escenario:** Tu organización recibe un informe de que el grupo ransomware **BlackCat** está usando el dominio `malicious-update[.]com` y la IP `45.153.204.48` como C2. Quieres detectar si algún dispositivo de tu entorno ha contactado esos indicadores.

#### Paso 1 — Importar IOCs a Sentinel

```
Opción A (manual via UI):
  Sentinel → Threat Management → Threat Intelligence
  → "+ Add new" → completar formulario con IP/dominio, tipo, expiración

Opción B (bulk import via TAXII):
  Data Connectors → Threat Intelligence - TAXII
  → Configurar feed que incluye los IOCs de BlackCat
  → Los IOCs se importan a ThreatIntelligenceIndicator automáticamente

Opción C (via API):
  POST https://management.azure.com/.../threatIntelligence/indicators
  → Body en formato STIX 2.1
```

#### Paso 2 — Verificar que los IOCs están en Sentinel

```kql
ThreatIntelligenceIndicator
| where DomainName == "malicious-update.com" 
    or NetworkIP == "45.153.204.48"
| project TimeGenerated, Type, DomainName, NetworkIP, 
          ThreatType, ConfidenceScore, Active
```

#### Paso 3 — Crear regla de analítica que detecte el IOC

```kql
// Analytics Rule — Scheduled — "Conexión a IOC de BlackCat Ransomware"
// KQL para hacer join entre logs de red y TI

let TI_IPs = ThreatIntelligenceIndicator
    | where Active == true
    | where ThreatType has "Ransomware"
    | where NetworkIP != ""
    | project NetworkIP, ThreatType, Description;

DeviceNetworkEvents
| where TimeGenerated > ago(1h)
| join kind=inner TI_IPs on $left.RemoteIP == $right.NetworkIP
| project TimeGenerated, DeviceName, RemoteIP, RemotePort,
          ThreatType, Description, InitiatingProcessFileName

// Configuración de la regla:
// Frecuencia: cada 15 minutos
// Lookback: 1 hora  
// Severidad: High
// MITRE Tactic: Command and Control (TA0011)
// MITRE Technique: T1071 Application Layer Protocol
```

#### Paso 4 — Enriquecer la investigación con MDTI

```
Cuando se genera el incident:
1. Abrir incident en Sentinel
2. Ir a entidades → clic en la IP sospechosa
3. Clic en "View in MDTI"
4. MDTI muestra:
   • Historial de la IP: primer visto, último visto
   • Asociación con BlackCat ransomware (infraestructura conocida)
   • Otros IOCs relacionados (más dominios, hashes)
   • Países de origen del tráfico
5. Esto confirma el True Positive y justifica el aislamiento del dispositivo
```

> [!example] Query de hunting proactivo con TI
> Sin esperar a que una regla dispare, un analista puede hacer hunting buscando conexiones históricas a IOCs conocidos:

```kql
// Hunting: ¿Algún equipo contactó dominios maliciosos conocidos en los últimos 7 días?
let MaliciousDomains = ThreatIntelligenceIndicator
    | where Active == true
    | where DomainName != ""
    | distinct DomainName;

DeviceNetworkEvents
| where TimeGenerated > ago(7d)
| where RemoteUrl has_any (MaliciousDomains)
| summarize FirstSeen = min(TimeGenerated), LastSeen = max(TimeGenerated),
            Connections = count() 
            by DeviceName, RemoteUrl
| order by Connections desc
```

---

## 3. Ciclo Operativo de Defender XDR — Tres Pasos del Analista SOC

### 3.1 Definición y encuadre oficial

El **ciclo operativo de Microsoft Defender XDR** es el flujo de trabajo que sigue un analista SOC dentro del portal unificado `security.microsoft.com` para gestionar una amenaza de principio a fin. Microsoft Learn lo formaliza como tres pasos consecutivos:

```
PASO 1 — TRIAGE        →   PASO 2 — INVESTIGATE   →   PASO 3 — RESPOND/REMEDIATE
Priorizar incidente         Profundizar en evidencia    Contener, remediar, aprender
```

> [!note] Por qué importa para el SC-200
> El examen SC-200 evalúa los tres pasos de forma independiente: preguntas sobre la incident queue pertenecen al Paso 1; preguntas sobre AIR, advanced hunting o entities pertenecen al Paso 2; preguntas sobre response actions (aislar dispositivo, suspender usuario, eliminar email) pertenecen al Paso 3. Reconocer a qué paso corresponde cada pregunta es clave para responder correctamente.

---

### 3.2 Paso 1 — Triage: Priorizar la Incident Queue

El analista empieza en la **cola de incidentes** (`Incidents & Alerts → Incidents`) y decide qué incidente atender primero.

| Elemento | Descripción | Dónde se ve |
|---|---|---|
| **Incident queue** | Lista de todos los incidentes activos, ordenables por severidad, estado, tiempo | `security.microsoft.com → Incidents` |
| **Severidad** | High / Medium / Low / Informational, asignada automáticamente | Columna en la queue |
| **Correlación de alertas** | Defender XDR agrupa alertas relacionadas en un solo incidente (evita alert fatigue) | Badge "X alerts" en el incident |
| **Attack story** | Vista narrativa del incidente completo con la cadena de eventos | Tab "Attack story" dentro del incident |
| **Entidades resumen** | Usuarios, dispositivos, IPs, buzones involucrados en un vistazo | Panel lateral del incident |
| **Assigned to** | Asignación del incidente a un analista o equipo | Campo en la queue |
| **Tags & Classification** | Etiquetado para organización y futura búsqueda | Editable en el incident |

> [!tip] Señales de prioridad en el Triage
> Un analista experimentado prioriza por: (1) severidad High + activos críticos afectados, (2) incidentes con movimiento lateral activo (tácticas Lateral Movement o Persistence visibles en el Attack Story), (3) incidentes con gran número de alertas correlacionadas (indica ataque coordinado, no anomalía aislada).

```
EJEMPLO DE TRIAGE:
Incident #1247 — Severity: High
├─ 7 alerts correlacionadas
├─ Tácticas: Initial Access → Credential Access → Lateral Movement
├─ Entidades: 3 dispositivos, 2 usuarios, 1 IP externa
├─ Attack story: email phishing → PowerShell → LSASS dump → RDP lateral
└─ Decisión: ATENDER PRIMERO — ataque activo multi-stage
```

---

### 3.3 Paso 2 — Investigate: Profundizar en el Incidente

Una vez priorizado el incidente, el analista investiga su alcance completo usando todas las herramientas disponibles en el portal.

#### 3.3.1 Vistas de investigación principales

| Vista / Herramienta | Propósito | Acceso |
|---|---|---|
| **Attack story (Attack Graph)** | Visualización gráfica de la cadena de ataque completa con entidades y alertas | Tab "Attack story" |
| **Entities** | Lista de todas las entidades involucradas: usuarios, dispositivos, IPs, URLs, buzones, apps | Tab "Entities" |
| **Evidence & Response** | Evidencia asociada: archivos, procesos, emails, conexiones de red | Tab "Evidence & Response" |
| **Alerts** | Alertas individuales que componen el incidente, con detalle de cada una | Tab "Alerts" |
| **Investigations** | Automated Investigation & Response (AIR): investigaciones automáticas disparadas | Tab "Investigations" |

#### 3.3.2 Automated Investigation & Response (AIR)

**AIR** es el motor de automatización de Defender XDR que lanza investigaciones automáticas cuando se detectan ciertas amenazas:

```
FLUJO DE AIR:
Alerta generada (ej. malware en endpoint)
        ↓
AIR se dispara automáticamente
        ↓
Recopila evidencia: procesos, archivos, conexiones, emails relacionados
        ↓
Asigna verdict a cada evidencia: Malicious / Suspicious / No threats found
        ↓
Propone o ejecuta acciones de remediación (según nivel de automatización)
        ↓
Genera informe de investigación para revisión del analista

NIVELES DE AUTOMATIZACIÓN EN MDE:
• Full — AIR remedia automáticamente sin aprobación
• Semi — AIR propone acciones; analista aprueba
• No automated remediation — Solo investiga, no actúa
```

#### Verdicts de AIR

Cada pieza de evidencia que analiza AIR recibe uno de estos tres verdicts:

| Verdict | Significado | Acción resultante |
|---|---|---|
| **Malicious** | El elemento es claramente malicioso | AIR propone o ejecuta remediación inmediata |
| **Suspicious** | El elemento es potencialmente malicioso pero no confirmado | AIR propone remediación; requiere revisión del analista |
| **No threats found** | El elemento es limpio | No se toma acción; se documenta en el informe |

> [!note] Verdicts en el examen
> El examen puede presentar un escenario donde AIR marcó un elemento como "Suspicious" y preguntar qué paso sigue: la respuesta es que el analista debe revisar la propuesta en Action Center → Pending antes de que se ejecute cualquier acción.

#### Remediation actions que puede proponer/ejecutar AIR

Dependiendo del verdict y del tipo de entidad afectada, AIR puede proponer estas acciones concretas:

| Acción | Entidad | Cuándo se aplica |
|---|---|---|
| **Quarantine file** | Archivo | Verdict Malicious/Suspicious en un archivo |
| **Stop and quarantine process** | Proceso en ejecución | Proceso malicioso detectado en endpoint |
| **Isolate device** | Dispositivo | Compromiso confirmado en el host |
| **Block URL** | URL/dominio | URL maliciosa contactada por el dispositivo |

> [!tip] AIR también actúa sobre email (Office 365)
> Las alertas de seguridad y las alert policies en Office 365 también pueden disparar AIR automáticamente para investigar y remediar amenazas en email y contenido. En ese caso, las acciones propuestas por AIR para email (p. ej. mover emails maliciosos) también requieren revisión en el **Action Center**. El rol de Security Administrator es necesario para aprobar acciones de remediación de email.

#### Configurar el Automation level por Device Group

El Automation level determina si AIR actúa automáticamente o espera aprobación, y se configura por Device Group (no de forma global):

```
RUTA DE CONFIGURACIÓN:
Settings → Endpoints → Device groups → columna "Automation level"

NIVELES DISPONIBLES POR DEVICE GROUP:
• Full - remediate threats automatically
• Semi - require approval for core folders remediation
• Semi - require approval for non-temp folders remediation
• Semi - require approval for all remediation
• No automated response

REQUISITO DE ROL:
Security Administrator (en Entra ID) o
Global Administrator
para modificar el Automation level de un Device Group.
```

> [!note] AIR en el examen
> El examen pregunta sobre qué hace AIR, los verdicts posibles, las remediation actions disponibles, el nivel de automatización y dónde se aprueba o rechaza una acción pendiente. Las acciones pendientes de AIR se aprueban en: `security.microsoft.com → Action Center → Pending`. La ruta para cambiar el Automation level es: **Settings → Endpoints → Device groups**.

#### 3.3.3 Advanced Hunting

Cuando AIR o las alertas automáticas no son suficientes, el analista usa **Advanced Hunting** para búsqueda proactiva:

```kql
// Ejemplo: investigar todos los procesos lanzados por un usuario sospechoso
// en las últimas 24 horas desde el incidente
DeviceProcessEvents
| where AccountName == "usuario_sospechoso"
| where TimeGenerated > ago(24h)
| project TimeGenerated, DeviceName, FileName, ProcessCommandLine, 
          InitiatingProcessFileName
| order by TimeGenerated asc
```

Ver [[CHEATSHEET_KQL]] para queries de hunting organizados por tabla y escenario.

#### 3.3.4 Entidades: qué investiga el analista por tipo

| Tipo de entidad | Preguntas de investigación | Fuente de datos |
|---|---|---|
| **Dispositivo** | ¿Está aislado? ¿Tiene alertas previas? ¿Procesos sospechosos? | MDE → Device page |
| **Usuario** | ¿Risk level? ¿Logins desde IPs inusuales? ¿Cambios de permisos? | MDI / Entra ID |
| **Email / buzón** | ¿Emails maliciosos entregados? ¿Reglas de reenvío sospechosas? | MDO → Threat Explorer |
| **IP** | ¿Reputación en TI? ¿Historial de conexiones? ¿Geolocalización inusual? | MDTI |
| **Archivo** | ¿Hash en ThreatIntelligenceIndicator? ¿Firmado? ¿Dónde se ejecutó? | MDE + TI |
| **App cloud** | ¿Permisos OAuth excesivos? ¿Actividad de descarga masiva? | MDCA |

---

### 3.4 Paso 3 — Respond/Remediate: Contener y Remediar

Una vez completada la investigación, el analista ejecuta acciones de respuesta para contener la amenaza y evitar que se expanda.

#### 3.4.1 Response Actions por tipo de entidad

| Entidad | Acción de respuesta | Efecto |
|---|---|---|
| **Dispositivo** | **Isolate device** | Corta toda la conectividad de red del dispositivo (solo mantiene canal MDE) |
| **Dispositivo** | **Restrict app execution** | Bloquea ejecución de aplicaciones no firmadas por Microsoft |
| **Dispositivo** | **Run AV scan** | Lanza escaneo antivirus completo de forma remota |
| **Dispositivo** | **Collect investigation package** | Descarga artefactos forenses (procesos, logs, memoria) |
| **Dispositivo** | **Initiate Live Response** | Acceso remoto a línea de comandos para investigación manual |
| **Usuario** | **Disable user in Entra ID** | Deshabilita la cuenta de usuario en Azure AD |
| **Usuario** | **Reset password** | Fuerza cambio de contraseña |
| **Usuario** | **Revoke sessions** | Invalida todos los tokens de sesión activos |
| **Email** | **Soft delete email** | Mueve el email a la carpeta de elementos eliminados del usuario |
| **Email** | **Hard delete email** | Elimina permanentemente el email del buzón |
| **Email** | **Move to junk** | Reclasifica el email como spam |
| **Archivo** | **Stop and quarantine file** | Detiene el proceso y pone el archivo en cuarentena |
| **Indicador** | **Add indicator (block)** | Bloquea una IP, dominio, URL o hash a nivel global en la organización |

> [!tip] Contener antes que remediar
> El orden correcto es siempre: **Contain → Eradicate → Recover**. Aislar el dispositivo antes de eliminar malware; suspender el usuario antes de revocar permisos. Actuar en orden inverso puede alertar al atacante o perder evidencia.

#### 3.4.2 Action Center — Centro de control de acciones

El **Action Center** (`security.microsoft.com → Action Center`) es el panel centralizado donde se gestionan todas las acciones de respuesta:

```
ACTION CENTER TIENE DOS PESTAÑAS:

PENDING (acciones que requieren aprobación):
├─ Acciones propuestas por AIR en modo Semi-automated
├─ El analista revisa y aprueba o rechaza cada una
└─ Incluye justificación automática de por qué se propuso

HISTORY (acciones completadas):
├─ Registro completo de todas las acciones ejecutadas
├─ Quién aprobó, cuándo, resultado
└─ Útil para informes post-incidente y auditoría
```

> [!note] Action Center en el examen
> Cuando el examen pregunta "dónde se aprueban las acciones de remediación automatizada", la respuesta es siempre **Action Center → Pending**. Este es uno de los conceptos más evaluados del flujo de respuesta.

#### 3.4.3 Cierre del incidente y mejora continua

Después de remediar, el analista cierra el incidente con la clasificación correcta:

| Clasificación | Cuándo usar |
|---|---|
| **True Positive — Security threat** | Amenaza real confirmada y remediada |
| **False Positive — Incorrect alert logic** | La alerta se disparó por error, la regla necesita ajuste |
| **False Positive — Inaccurate data** | La alerta tenía datos incorrectos |
| **Informational, expected activity** | Actividad legítima que genera alerta (ej. red team, pentest) |
| **Undetermined** | No se pudo determinar |

Acciones de mejora post-incidente:

```
MEJORA CONTINUA POST-INCIDENTE:
├─ Crear Suppression Rule (si fue FP repetitivo)
├─ Ajustar Analytics Rule en Sentinel (threshold, exclusiones)
├─ Agregar IOC nuevo al ThreatIntelligenceIndicator
├─ Actualizar Playbook de SOAR si la respuesta fue manual
├─ Revisar si el Attack Vector era prevenible (postura de seguridad)
└─ Documentar lecciones aprendidas
```

---

### 3.5 Resumen visual — Los tres pasos

```
┌─────────────────────────────────────────────────────────────────────────┐
│          CICLO OPERATIVO MICROSOFT DEFENDER XDR                         │
├──────────────────┬──────────────────────┬───────────────────────────────┤
│  PASO 1          │  PASO 2              │  PASO 3                       │
│  TRIAGE          │  INVESTIGATE         │  RESPOND / REMEDIATE          │
├──────────────────┼──────────────────────┼───────────────────────────────┤
│ • Incident queue │ • Attack story/graph │ • Isolate device              │
│ • Severidad      │ • Entities           │ • Disable user                │
│ • Alert correl.  │ • Evidence & Response│ • Delete/move email           │
│ • Attack story   │ • AIR automático     │ • Stop & quarantine file      │
│ • Asignar        │ • Advanced Hunting   │ • Add block indicator         │
│ • Priorizar      │ • KQL queries        │ • Action Center (Pending)     │
│                  │                      │ • Cerrar + clasificar         │
│                  │                      │ • Suppression / tuning        │
└──────────────────┴──────────────────────┴───────────────────────────────┘
```

> [!example] Flujo completo — Incidente de ransomware
> **Triage**: La queue muestra Incident #1503, Severity High, 9 alertas correlacionadas, táctica "Impact". Se asigna inmediatamente.
> **Investigate**: El Attack Graph muestra: phishing email → macro execution → credential dump → lateral movement → ransomware deployment en 5 hosts. AIR ya investigó automáticamente 3 de los 5 hosts. El analista hace hunting con KQL para confirmar el cuarto y quinto host.
> **Respond**: Aislar los 5 dispositivos → Suspender la cuenta de usuario comprometida → Hard delete de los emails de phishing pendientes → Agregar el hash del ransomware como indicador de bloqueo → Aprobar las acciones pendientes en Action Center → Cerrar como True Positive. Post-incidente: crear regla de supresión para variante conocida y revisar por qué el Safe Attachment no bloqueó el adjunto original.

---

### 3.6 Flash Cards — Tres Pasos

| Concepto | Definición en una línea |
|---|---|
| **Incident queue** | Cola de incidentes en `security.microsoft.com` ordenada por severidad; punto de entrada del Paso 1 |
| **Attack story** | Visualización narrativa + gráfica del incidente con entidades y cadena de eventos; central en Paso 1 y 2 |
| **AIR** | Motor de automatización que lanza investigaciones y propone/ejecuta remediaciones; protagonista del Paso 2 |
| **AIR Verdict** | Clasificación que AIR asigna a cada evidencia: Malicious / Suspicious / No threats found |
| **AIR Automation level** | Nivel de automatización de AIR por Device Group; se configura en Settings → Endpoints → Device groups |
| **Advanced Hunting** | Query engine KQL para búsqueda proactiva de amenazas; complementa la investigación en Paso 2 |
| **Action Center** | Panel centralizado para aprobar/rechazar acciones pendientes de AIR y ver historial; esencial en Paso 3 |
| **Isolate device** | Response action que desconecta un dispositivo de la red manteniendo canal MDE; primera acción de contención |
| **Suppress rule** | Regla que suprime alertas repetitivas de FP conocidos; acción de mejora post-Paso 3 |

---

### 3.7 Checklist SC-200 — Ciclo Operativo XDR

- [ ] Saber los tres pasos en orden: Triage → Investigate → Respond/Remediate
- [ ] Identificar qué información aparece en la Incident Queue
- [ ] Conocer qué muestra el Attack Story / Attack Graph dentro de un incidente
- [ ] Saber qué es AIR, sus niveles de automatización y dónde se aprueban acciones pendientes
- [ ] Conocer los verdicts de AIR: Malicious / Suspicious / No threats found
- [ ] Saber las remediation actions específicas que puede proponer AIR: quarantine file, stop/quarantine process, isolate device, block URL
- [ ] Saber cómo configurar el Automation level por Device Group: Settings → Endpoints → Device groups
- [ ] Entender que AIR también funciona en Office 365 (email/content) y que esas acciones pasan por Action Center
- [ ] Conocer las Response Actions disponibles por tipo de entidad (dispositivo, usuario, email)
- [ ] Saber que el Action Center tiene pestañas Pending e History
- [ ] Conocer las clasificaciones al cerrar un incidente (TP, FP, Benign, Undetermined)
- [ ] Entender qué hacer post-incidente: suppression rules, ajuste de analytics rules, lecciones aprendidas

---

## 4. Relación entre Attack Chain y Threat Intelligence

Los dos conceptos se complementan directamente en el trabajo SOC:

```
THREAT INTELLIGENCE                    ATTACK CHAIN MODEL
─────────────────────────────────────────────────────────────
IOCs (IPs, dominios, hashes)    →    Detectan etapas específicas
                                      del Kill Chain:
  • IP de C2                    →    Command & Control (etapa 6)
  • Hash de malware             →    Installation (etapa 5)
  • Dominio de phishing         →    Delivery (etapa 3)

TTPs (MITRE ATT&CK)             →    Mapean directamente a
                                      tácticas del attack chain:
  • T1566 Phishing              →    Initial Access
  • T1059 Command & Scripting   →    Execution
  • T1078 Valid Accounts        →    Persistence / Lateral Movement
  • T1041 Exfiltration over C2  →    Exfiltration

SENTINEL une ambos:
  ThreatIntelligenceIndicator   →    IOCs que disparan alertas
  Analytics Rules (MITRE tags)  →    TTPs que modelan el ataque
  Fusion Rule                   →    Correlaciona el attack chain completo
  Incidents + Attack Graph      →    Visualiza la cadena completa
```

> [!tip] Para el examen — La pregunta clave
> Si el examen pregunta "¿cómo un analista sabe en qué etapa del ataque está?", la respuesta es: **mirando las tácticas MITRE ATT&CK etiquetadas en las alertas del incident**, que Sentinel asigna automáticamente basándose en las reglas que las generaron.

---

## 4. Resumen Rápido — Flash Cards Mentales

| Concepto | Definición en una línea |
|----------|------------------------|
| **Kill Chain** | 7 etapas lineales de un ataque (Lockheed Martin): Recon → Weaponize → Deliver → Exploit → Install → C2 → Act |
| **MITRE ATT&CK** | 14 tácticas + cientos de técnicas que documentan comportamiento real de adversarios |
| **Attack Graph en XDR** | Visualización automática de la cadena de ataque correlacionando señales de MDE + MDI + MDO + MDCA |
| **Fusion Rule** | Regla ML en Sentinel que correlaciona señales débiles de múltiples fuentes para detectar ataques multi-stage |
| **IOC** | Artefacto observable que indica compromiso: IP, dominio, hash, URL |
| **TTP** | Comportamiento del atacante: Táctica (qué quiere) + Técnica (cómo) + Procedimiento (con qué herramienta) |
| **MDTI** | Plataforma Microsoft de TI para enriquecer investigaciones con contexto de IOCs y actores |
| **Threat Analytics** | Módulo en Defender XDR con informes de amenazas activas y estado de mitigación en tu org |
| **STIX/TAXII** | STIX = formato de IOCs; TAXII = protocolo para distribuirlos. Estándar de la industria para compartir TI |
| **ThreatIntelligenceIndicator** | Tabla KQL en Sentinel que almacena todos los IOCs importados |
| **TI Analytics Rule** | Tipo de regla en Sentinel que hace matching automático entre IOCs y logs del entorno |
| **Ciclo operativo XDR** | Tres pasos del analista SOC: Triage (incident queue) → Investigate (AIR, hunting, entities) → Respond/Remediate (response actions, Action Center) |
| **AIR** | Automated Investigation & Response: motor de automatización de Defender XDR que investiga y propone/ejecuta remediaciones |
| **Action Center** | Panel en `security.microsoft.com` para aprobar/rechazar acciones pendientes de AIR y ver historial de acciones ejecutadas |

---

## 5. Checklist SC-200 — Estos Conceptos

### Attack Chain
- [ ] Saber las 7 etapas del Cyber Kill Chain en orden
- [ ] Conocer las 14 tácticas de MITRE ATT&CK Enterprise
- [ ] Entender qué muestra el Attack Graph en Defender XDR
- [ ] Saber cómo Sentinel mapea alertas a tácticas MITRE ATT&CK en las Analytics Rules
- [ ] Entender qué es la Fusion Rule y para qué sirve

### Threat Intelligence
- [ ] Diferenciar IOCs vs TTPs y sus casos de uso
- [ ] Conocer los 4 tipos de TI: estratégica, táctica, operacional, técnica
- [ ] Saber qué es MDTI y cómo se usa en una investigación
- [ ] Saber configurar el conector TAXII en Sentinel
- [ ] Conocer la tabla `ThreatIntelligenceIndicator` y sus campos clave
- [ ] Saber escribir un join entre `ThreatIntelligenceIndicator` y tablas de eventos
- [ ] Entender qué son las Analytics Rules de tipo "Microsoft Threat Intelligence"
- [ ] Conocer STIX 2.1 como formato estándar de IOCs

---

## 🔗 Notas Relacionadas

- [[00_INDEX_SC200]] — Índice principal y dominios del examen
- [[01_Semana1_Sentinel_Fundamentos]] — Analytics Rules, tipos, configuración MITRE
- [[03_Semana3_Defender_XDR]] — Attack Story, Incident Investigation, tablas KQL por producto
- [[CHEATSHEET_KQL]] — Referencia rápida de queries KQL
- [[PLAN_INTENSIVO_4SEMANAS]] — Plan de estudio y calendario

---

*Nota creada el 2026-06-17 | SC-200 — Conceptos Clave: Attack Chain Model y Threat Intelligence*
