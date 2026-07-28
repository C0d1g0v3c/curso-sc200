---
tags: [sc-200, kql, cheatsheet, referencia, queries]
fecha: 2026-06-08
ultima_actualizacion: 2026-06-08
estado: ✅ Referencia permanente
tipo: Cheatsheet
relacionado: "[[02_Semana2_KQL_Labs]], [[01_Semana1_Sentinel_Fundamentos]]"
---

# ⚡ CHEATSHEET — KQL Kusto Query Language

> Referencia rápida para consultas en Microsoft Sentinel / Log Analytics

---

## Operadores Esenciales

```kql
| where          → Filtrar filas
| project        → Seleccionar columnas
| extend         → Agregar columna calculada
| summarize      → Agrupar + agregar
| order by       → Ordenar (desc / asc)
| take / limit   → Limitar resultados
| count          → Contar filas totales
| distinct       → Valores únicos
| join           → Unir tablas
| union          → Combinar tablas
| parse          → Parsear strings estructurados
| extract        → Regex sobre strings
| mv-expand      → Expandir arrays
| render         → Visualizar (timechart, barchart...)
```

---

## Tiempo — Lo Más Usado

```kql
| where TimeGenerated > ago(1h)      // última hora
| where TimeGenerated > ago(24h)     // últimas 24 horas
| where TimeGenerated > ago(7d)      // últimos 7 días
| where TimeGenerated > ago(30d)     // último mes

// Rango específico
| where TimeGenerated between (datetime(2026-06-01) .. datetime(2026-06-08))

// Agrupar por tiempo
| summarize count() by bin(TimeGenerated, 1h)   // por hora
| summarize count() by bin(TimeGenerated, 1d)   // por día

// Funciones de tiempo
hourofday(TimeGenerated)    // 0-23
dayofweek(TimeGenerated)    // 0=domingo, 6=sábado
startofday(now())           // inicio del día actual
```

---

## Tablas Clave por Producto

```
WINDOWS / ACTIVE DIRECTORY
SecurityEvent               → Eventos Windows (4624, 4625, 4688, etc.)
SecurityAlert               → Alertas de todos los Defender products

AZURE AD / ENTRA ID
SigninLogs                  → Logins interactivos
AADNonInteractiveUserSignInLogs → Logins de apps/tokens
AuditLogs                   → Cambios en Azure AD

DEFENDER FOR ENDPOINT (MDE)
DeviceEvents                → Eventos generales del dispositivo
DeviceProcessEvents         → Procesos creados
DeviceNetworkEvents         → Conexiones de red
DeviceFileEvents            → Archivos creados/modificados/eliminados
DeviceLogonEvents           → Logins en el dispositivo
DeviceRegistryEvents        → Cambios en registro

DEFENDER FOR IDENTITY (MDI)
IdentityLogonEvents         → Logins detectados por MDI
IdentityQueryEvents         → Consultas LDAP/AD (reconocimiento)
IdentityDirectoryEvents     → Cambios en AD

MICROSOFT 365 / EMAIL
OfficeActivity              → Actividad en SharePoint, OneDrive, Teams
EmailEvents                 → Emails (envíos, recepciones)
UrlClickEvents              → Clicks en links de emails

DEFENDER FOR CLOUD (MDC)
SecurityRecommendation      → Recomendaciones de postura
SecurityBaseline            → Cumplimiento de baselines

THREAT INTELLIGENCE
ThreatIntelligenceIndicator → IoCs importados

SENTINEL
SecurityIncident            → Incidents de Sentinel
```

---

## Event IDs Windows — Los Más Evaluados

```
AUTENTICACIÓN
4624  → Login exitoso
4625  → Login FALLIDO ← el más importante
4634  → Logoff
4648  → Login con credenciales explícitas (runas)
4672  → Login con privilegios especiales (admin)
4768  → Kerberos TGT solicitado
4769  → Kerberos Service Ticket solicitado (Kerberoasting si muchos)
4771  → Kerberos pre-auth fallida

PROCESOS
4688  → Nuevo proceso creado
4689  → Proceso terminado
4698  → Scheduled Task creada
4702  → Scheduled Task modificada

USUARIOS Y GRUPOS
4720  → Cuenta de usuario creada
4722  → Cuenta habilitada
4723  → Contraseña cambiada
4724  → Contraseña reseteada
4725  → Cuenta deshabilitada
4726  → Cuenta eliminada
4732  → Usuario agregado a grupo local

ACCESO A OBJETOS
4663  → Acceso a objeto (archivo/carpeta)
4698  → Tarea programada creada ← persistencia
```

---

## Queries Listas para Usar

### 🔴 Brute Force

```kql
SecurityEvent
| where TimeGenerated > ago(1h)
| where EventID == 4625
| summarize Fallos = count() by Account, Computer, IpAddress
| where Fallos >= 10
| order by Fallos desc
```

### 🔴 Login Exitoso Post-Brute Force

```kql
let FallosPrevios = SecurityEvent
    | where EventID == 4625
    | where TimeGenerated > ago(1h)
    | summarize count() by Account
    | where count_ >= 5;
SecurityEvent
| where EventID == 4624
| where TimeGenerated > ago(1h)
| join kind=inner FallosPrevios on Account
| project TimeGenerated, Account, IpAddress, Computer
```

### 🔴 Proceso Sospechoso

```kql
DeviceProcessEvents
| where TimeGenerated > ago(24h)
| where FileName in~ ("mimikatz.exe", "psexec.exe", "procdump.exe", 
                       "mshta.exe", "regsvr32.exe", "certutil.exe")
| project TimeGenerated, DeviceName, AccountName, FileName, ProcessCommandLine
```

### 🔴 PowerShell Encoded (ofuscación)

```kql
DeviceProcessEvents
| where TimeGenerated > ago(24h)
| where FileName == "powershell.exe"
| where ProcessCommandLine contains "-enc" or ProcessCommandLine contains "-encodedcommand"
| project TimeGenerated, DeviceName, AccountName, ProcessCommandLine
```

### 🔴 Impossible Travel

```kql
SigninLogs
| where TimeGenerated > ago(24h)
| where ResultType == "0"
| summarize 
    Paises = dcount(tostring(LocationDetails.countryOrRegion)),
    IPs = dcount(IPAddress),
    ListaPaises = make_set(tostring(LocationDetails.countryOrRegion))
    by UserPrincipalName
| where Paises > 1
| order by Paises desc
```

### 🟡 Actividad Fuera de Horario

```kql
SigninLogs
| where TimeGenerated > ago(7d)
| where ResultType == "0"
| extend Hora = hourofday(TimeGenerated)
| where Hora < 7 or Hora > 21
| project TimeGenerated, UserPrincipalName, IPAddress, Hora, Location
```

### 🟡 Usuarios con Muchos Accesos a Datos

```kql
OfficeActivity
| where TimeGenerated > ago(24h)
| where Operation in ("FileAccessed", "FileDownloaded", "FileCopied")
| summarize Accesos = count() by UserId, ClientIP
| where Accesos > 500
| order by Accesos desc
```

### 🟢 Inventario de Dispositivos Onboarded en MDE

```kql
DeviceInfo
| summarize arg_max(TimeGenerated, *) by DeviceName
| project DeviceName, OSPlatform, OSVersion, OnboardingStatus, LastSeen = TimeGenerated
| order by LastSeen desc
```

---

## Visualizaciones Rápidas

```kql
// Timechart: eventos por hora
SecurityEvent
| where TimeGenerated > ago(24h)
| where EventID == 4625
| summarize count() by bin(TimeGenerated, 1h)
| render timechart

// Barchart: top amenazas
SecurityAlert
| where TimeGenerated > ago(7d)
| summarize count() by AlertName
| order by count_ desc
| take 10
| render barchart

// Piechart: distribución por severidad
SecurityAlert
| where TimeGenerated > ago(24h)
| summarize count() by AlertSeverity
| render piechart
```

---

*Referencia creada el 2026-06-08 | Actualizar con queries nuevas durante el estudio*
