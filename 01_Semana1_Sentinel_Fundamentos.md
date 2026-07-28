---
tags: [sc-200, sentinel, microsoft, siem, semana1]
fecha: 2026-06-08
ultima_actualizacion: 2026-06-08
estado: 🟡 En construcción
tipo: Estudio
relacionado: "[[00_INDEX_SC200]], [[SIEM]], [[Chronicle_vs_Sentinel]]"
---
si
# 🔵 Semana 1 — Microsoft Sentinel: Fundamentos

> **Idea central:** Sentinel es el SIEM/SOAR cloud-native de Azure. Si ya sabes Chronicle, esto es el mismo concepto con diferente sintaxis y dentro del ecosistema Azure.

---

## ¿Qué es Microsoft Sentinel?

```
Microsoft Sentinel = SIEM + SOAR cloud-native en Azure

Funciones principales:
├─ COLLECT   → Ingesta logs de toda la organización
├─ DETECT    → Analytics rules que generan alertas
├─ INVESTIGATE → Correlaciona alertas en incidents
├─ RESPOND   → Playbooks automatizan la respuesta
└─ HUNT      → Búsqueda proactiva de amenazas
```

> 💡 **Tu contexto**: Chronicle hace exactamente esto pero en el stack de Google.
> Sentinel = Chronicle pero dentro de Azure + integración nativa con Defender.

---

## Arquitectura de Sentinel

```
┌──────────────────────────────────────────────────────────┐
│                  MICROSOFT SENTINEL                       │
│                                                          │
│  DATA CONNECTORS → LOG ANALYTICS WORKSPACE → SENTINEL   │
│       ↓                    ↓                    ↓        │
│  Azure AD              Tablas KQL           Analytics    │
│  Microsoft 365         (SecurityEvent,      Rules        │
│  Defender XDR          SigninLogs,          Incidents    │
│  Syslog/CEF            CommonSecLogs...)    Playbooks    │
│  Custom/API                                 Workbooks    │
└──────────────────────────────────────────────────────────┘
```

### Componentes Clave

| Componente | Descripción | Equivalente Chronicle |
|-----------|-------------|----------------------|
| **Log Analytics Workspace** | Base de datos donde viven los logs | SIEM backend de Chronicle |
| **Data Connectors** | Fuentes de datos conectadas | Feeds/ingesta en Chronicle |
| **Analytics Rules** | Reglas que generan alertas | Detection rules en Chronicle |
| **Incidents** | Alertas correlacionadas | Cases en Chronicle |
| **Playbooks** | Automatización con Logic Apps | SOAR playbooks en Chronicle |
| **Workbooks** | Dashboards visuales | Dashboards en Chronicle |
| **Hunting** | Búsqueda proactiva con KQL | Hunting en Chronicle |

---

## Log Analytics Workspace

### ¿Qué es?
- Repositorio centralizado de logs en Azure
- Sentinel vive ENCIMA de un workspace de Log Analytics
- Los datos se consultan con **KQL (Kusto Query Language)**

### Tablas Principales que Debes Conocer

```
SecurityEvent          → Eventos de seguridad de Windows (Event IDs)
SigninLogs             → Logins de Azure AD / Entra ID
AADNonInteractiveUserSignInLogs → Logins no interactivos (apps, tokens)
AuditLogs              → Cambios de configuración en Azure AD
OfficeActivity         → Actividad de Microsoft 365
SecurityAlert          → Alertas de Defender y otros productos
SecurityIncident       → Incidents de Sentinel
Syslog                 → Logs de Linux
CommonSecurityLog      → Logs CEF (firewalls, otros dispositivos)
DeviceEvents           → Eventos de Defender for Endpoint
DeviceProcessEvents    → Procesos en dispositivos (MDE)
DeviceNetworkEvents    → Conexiones de red (MDE)
IdentityLogonEvents    → Logins detectados por Defender for Identity
ThreatIntelligenceIndicator → IoCs de threat intelligence
```

---

## Data Connectors

### Tipos de Connectors

```
BUILT-IN (nativos):
├─ Microsoft 365 Defender (XDR completo)
├─ Azure Active Directory / Entra ID
├─ Azure Activity
├─ Microsoft Defender for Cloud
└─ Office 365

AGENT-BASED:
├─ Windows Security Events (via AMA o MMA)
├─ Syslog (Linux via AMA)
└─ CEF (Common Event Format) para firewalls

API-BASED:
├─ Threat Intelligence Platforms
├─ Custom REST API
└─ Amazon Web Services (CloudTrail, S3)
```

### Proceso de Conexión (importante para el examen)

```
1. Ir a Sentinel → Data Connectors
2. Seleccionar connector
3. Revisar prerequisites (permisos necesarios)
4. Instalar agent si se requiere (AMA preferido sobre MMA legacy)
5. Verificar en Logs que datos llegan
   → query: <NombreTabla> | take 10
```

---

## Analytics Rules — Tipos

### Los 4 Tipos que Debes Saber

```
SCHEDULED
├─ Más común en el examen
├─ Se ejecuta en intervalos (cada 5min, 1hr, etc.)
├─ Usa KQL personalizado
├─ Genera alertas basadas en resultados
└─ Ejemplo: Detectar 5+ logins fallidos en 10 minutos

NEAR REAL-TIME (NRT)
├─ Latencia de ~1 minuto
├─ También usa KQL
├─ Para detecciones críticas que no pueden esperar
└─ Límite: 50 reglas NRT por workspace

MICROSOFT SECURITY
├─ Importa alertas de otros productos Defender
├─ Convierte alertas en incidents en Sentinel
└─ Sin KQL personalizado (solo filtros)

FUSION
├─ ML de Microsoft
├─ Correlaciona señales débiles de múltiples fuentes
├─ Detecta ataques multi-stage (APTs)
└─ No editable

ANOMALY
├─ ML basado en comportamiento
├─ Detecta desviaciones del baseline
└─ Requiere período de aprendizaje (~7 días)
```

### Configuración de Scheduled Rule

```yaml
Nombre: "Multiple Failed Logins - Brute Force"
Descripción: "5+ intentos fallidos en 10 minutos"

KQL Query:
  SecurityEvent
  | where EventID == 4625
  | where TimeGenerated > ago(10m)
  | summarize FailedAttempts = count() by Account, Computer
  | where FailedAttempts >= 5

Frecuencia: Cada 5 minutos
Lookback: 10 minutos
Severidad: Medium
MITRE Tactics: Credential Access (T1110 - Brute Force)
```

---

## Incidents en Sentinel

### Flujo de Alert → Incident

```
Logs entran al workspace
        ↓
Analytics Rule se ejecuta
        ↓
KQL devuelve resultados
        ↓
Se genera ALERT (alerta individual)
        ↓
Alert Grouping (opcional: agrupar alertas similares)
        ↓
Se crea INCIDENT (conjunto de alertas relacionadas)
        ↓
SOC Analyst recibe incident en la cola
        ↓
Triage → Investigate → Respond → Close
```

### Campos Clave de un Incident

| Campo | Descripción |
|-------|-------------|
| **Severity** | Informational / Low / Medium / High |
| **Status** | New / Active / Closed |
| **Owner** | Analista asignado |
| **Entities** | Usuarios, IPs, hosts involucrados |
| **Evidence** | Alertas y bookmarks relacionados |
| **MITRE Tactics** | Técnicas ATT&CK detectadas |

---

## Playbooks (SOAR)

### ¿Qué son?
- Flujos de automatización construidos con **Azure Logic Apps**
- Se disparan cuando se crea/actualiza un incident o alert
- Ejemplo: recibir incident → buscar en VirusTotal → notificar en Teams → bloquear IP

### Triggers Disponibles

```
Microsoft Sentinel Incident → Cuando se crea/actualiza un incident
Microsoft Sentinel Alert   → Cuando se genera una alerta
Microsoft Sentinel Entity  → Al enriquecer una entidad
```

### Ejemplo Simple: Auto-notificación Teams

```
Trigger: Sentinel Incident (Severity = High)
    ↓
Action: Get incident details
    ↓
Action: Post message in Teams channel
         "🚨 High Severity Incident: [name]
          Entities: [entities]
          Link: [incident URL]"
    ↓
Action: Assign to on-call analyst
```

---

## Workbooks

- Dashboards interactivos basados en datos de Sentinel
- Usan KQL para visualizar métricas
- Templates predefinidos disponibles (Azure AD, Windows Events, etc.)

### Workbooks Importantes para el Examen

```
Azure AD Sign-in Logs    → Analizar patrones de autenticación
Azure Activity           → Cambios en recursos Azure
Microsoft Entra Audit    → Modificaciones de identidades
Security Operations      → KPIs del SOC
Threat Intelligence      → IoCs activos
```

---

## 🧪 Labs a Completar Esta Semana

- [ ] **Lab 1**: Crear workspace Sentinel en Azure sandbox (Microsoft Learn)
- [ ] **Lab 2**: Conectar Azure AD y Office 365 como data sources
- [ ] **Lab 3**: Crear Analytics Rule tipo Scheduled con KQL básico
- [ ] **Lab 4**: Revisar Incidents generados y asignar a usuario
- [ ] **Lab 5**: Explorar Workbooks predefinidos de Azure AD

---

## 📝 Notas Personales

> _Usa este espacio para agregar tus propias observaciones durante el estudio_

```
Fecha:
Tema:
Observación:
```

---

## 🔗 Notas Relacionadas

- [[00_INDEX_SC200]] — Índice principal del path SC-200
- [[02_Semana2_KQL_Labs]] — Siguiente: KQL en profundidad
- [[Chronicle_vs_Sentinel]] — Traducción de tu conocimiento de Chronicle
- [[CHEATSHEET_KQL]] — Referencia rápida de queries

---

*Nota creada el 2026-06-08 | SC-200 Semana 1 — Microsoft Sentinel Fundamentos*
