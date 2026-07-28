---
tags: [sc-200, kql, kusto, sentinel, semana2, queries]
fecha: 2026-06-08
ultima_actualizacion: 2026-06-08
estado: 🟡 En construcción
tipo: Estudio
relacionado: "[[00_INDEX_SC200]], [[01_Semana1_Sentinel_Fundamentos]], [[CHEATSHEET_KQL]]"
---

# 🔍 Semana 2 — KQL: Kusto Query Language

> **Idea central:** KQL es el lenguaje de consulta de Microsoft Sentinel. Si ya usaste Kibana Query Language (KQL de ELK) o SPL de Splunk, la lógica es la misma — diferente sintaxis. Es el tema más importante del examen.

---

## ¿Qué es KQL?

```
KQL (Kusto Query Language)
├─ Lenguaje de consulta de solo lectura
├─ Usado en: Azure Monitor, Log Analytics, Microsoft Sentinel, ADX
├─ Sintaxis: tabular (como SQL pero pipe-based)
└─ Filosofía: tabla | operador | operador | operador...
```

### Comparativa con lo que ya conoces

| Concepto | KQL | Kibana/ELK | Splunk SPL | SQL |
|----------|-----|-----------|-----------|-----|
| Seleccionar columnas | `project` | `_source` | `fields` | `SELECT` |
| Filtrar | `where` | `filter` | `where` | `WHERE` |
| Contar/agrupar | `summarize count() by` | `aggregation` | `stats count by` | `GROUP BY` |
| Ordenar | `order by` | `sort` | `sort` | `ORDER BY` |
| Limitar resultados | `take 10` | `size: 10` | `head 10` | `LIMIT 10` |
| Buscar texto | `search "término"` | `query_string` | `search` | `LIKE` |

---

## Estructura Básica de una Query

```kql
NombreTabla
| operador1 condición
| operador2 condición
| operador3 condición
```

### Ejemplo Real

```kql
SecurityEvent
| where TimeGenerated > ago(1h)
| where EventID == 4625
| where AccountType == "User"
| project TimeGenerated, Account, Computer, IpAddress
| order by TimeGenerated desc
| take 100
```

**Traducción**: De la tabla SecurityEvent, dame los eventos de la última hora, solo logins fallidos (4625) de usuarios, mostrando solo las columnas importantes, ordenados del más reciente al más viejo, máximo 100 resultados.

---

## Operadores Fundamentales

### `where` — Filtrar

```kql
// Igualdad
SecurityEvent | where EventID == 4624

// Rango de tiempo (más importante en Sentinel)
SecurityEvent | where TimeGenerated > ago(24h)
SecurityEvent | where TimeGenerated between (datetime(2026-06-01) .. datetime(2026-06-08))

// Múltiples condiciones
SecurityEvent | where EventID == 4625 and AccountType == "User"
SecurityEvent | where EventID == 4625 or EventID == 4624

// Contiene texto
SecurityEvent | where Account contains "admin"
SecurityEvent | where Account startswith "svc_"
SecurityEvent | where Computer !contains "DC"

// IN (lista de valores)
SecurityEvent | where EventID in (4624, 4625, 4648, 4672)
```

### `project` — Seleccionar columnas

```kql
// Solo las columnas que quiero
SecurityEvent
| where EventID == 4625
| project TimeGenerated, Account, Computer, IpAddress, LogonType

// Renombrar columna
SecurityEvent
| project Timestamp = TimeGenerated, Usuario = Account, Equipo = Computer
```

### `summarize` — Agrupar y agregar

```kql
// Contar eventos por tipo
SecurityEvent
| summarize Conteo = count() by EventID

// Contar fallos de login por usuario
SecurityEvent
| where EventID == 4625
| summarize FailedLogins = count() by Account
| where FailedLogins > 5

// Múltiples agregaciones
SecurityEvent
| where EventID == 4625
| summarize 
    TotalFallos = count(),
    PrimerIntento = min(TimeGenerated),
    UltimoIntento = max(TimeGenerated)
    by Account, Computer

// Contar IPs únicas por usuario
SecurityEvent
| where EventID == 4624
| summarize IPsUsadas = dcount(IpAddress) by Account
```

### `extend` — Agregar columnas calculadas

```kql
// Agregar columna derivada
SecurityEvent
| where EventID == 4625
| extend HoraLocal = TimeGenerated - 6h  // UTC-6 México
| extend EsHorarioLaboral = iff(hourofday(TimeGenerated) between (8 .. 18), "Laboral", "Fuera de horario")
| project TimeGenerated, HoraLocal, EsHorarioLaboral, Account
```

### `join` — Unir tablas

```kql
// INNER JOIN entre dos tablas
SecurityEvent
| where EventID == 4625
| summarize FailedLogins = count() by Account
| join kind=inner (
    SecurityEvent
    | where EventID == 4624
    | summarize SuccessLogins = count() by Account
) on Account
| project Account, FailedLogins, SuccessLogins
```

### `union` — Combinar tablas

```kql
// Buscar en múltiples tablas
union SecurityEvent, Syslog
| where TimeGenerated > ago(1h)
| where * contains "failed"
| project TimeGenerated, Type, Computer
```

### `parse` y `extract` — Parsear texto

```kql
// Extraer datos de strings con regex
Syslog
| where SyslogMessage contains "Invalid user"
| parse SyslogMessage with * "Invalid user " Usuario " from " IPOrigen " port " *
| project TimeGenerated, Usuario, IPOrigen

// extract con regex
SecurityEvent
| where EventID == 4688
| extend ProcessName = extract(@"\\([^\\]+)$", 1, NewProcessName)
```

---

## Operadores de Tiempo (Críticos en Sentinel)

```kql
// Últimas N horas/días
| where TimeGenerated > ago(1h)
| where TimeGenerated > ago(24h)
| where TimeGenerated > ago(7d)

// Bin: agrupar por intervalos de tiempo
SecurityEvent
| where TimeGenerated > ago(24h)
| where EventID == 4625
| summarize Conteo = count() by bin(TimeGenerated, 1h)
// Resultado: número de fallos por hora en las últimas 24h

// startofday / startofweek / startofmonth
| where TimeGenerated >= startofday(ago(7d))
```

---

## Funciones de String Útiles

```kql
// Manipulación de strings
| extend DomainUser = split(Account, "\\")[1]     // extraer usuario de DOMAIN\user
| extend Domain = split(Account, "\\")[0]          // extraer dominio
| extend FileName = tostring(split(FilePath, "\\")[-1])  // nombre de archivo

// Conversiones
| extend EventIDStr = tostring(EventID)
| extend CountNum = toint(CountColumn)

// iif / iff: equivalente a IF en Excel
| extend Severidad = iff(FailedLogins > 10, "Alta", iff(FailedLogins > 5, "Media", "Baja"))
```

---

## Detección de Amenazas con KQL

### Brute Force (Login Múltiple Fallido)

```kql
SecurityEvent
| where TimeGenerated > ago(1h)
| where EventID == 4625
| summarize 
    FailedCount = count(),
    FirstAttempt = min(TimeGenerated),
    LastAttempt = max(TimeGenerated)
    by Account, IpAddress
| where FailedCount >= 10
| order by FailedCount desc
```

### Cuentas Privilegiadas Activas Fuera de Horario

```kql
SecurityEvent
| where TimeGenerated > ago(24h)
| where EventID == 4624
| where AccountType == "User"
| where MemberName contains "admin" or Account contains "admin"
| extend Hora = hourofday(TimeGenerated)
| where Hora < 8 or Hora > 20  // fuera de 8am-8pm
| project TimeGenerated, Account, Computer, IpAddress, Hora
| order by TimeGenerated desc
```

### Nuevos Procesos Sospechosos (Lateral Movement)

```kql
DeviceProcessEvents
| where TimeGenerated > ago(24h)
| where FileName in ("mimikatz.exe", "procdump.exe", "psexec.exe", "wmic.exe")
| project TimeGenerated, DeviceName, InitiatingProcessAccountName, FileName, ProcessCommandLine
| order by TimeGenerated desc
```

### Descarga Masiva de Datos (Data Exfiltration)

```kql
OfficeActivity
| where TimeGenerated > ago(24h)
| where Operation == "FileDownloaded"
| summarize TotalDescargas = count() by UserId, ClientIP
| where TotalDescargas > 100
| order by TotalDescargas desc
```

---

## Hunting Queries (Threat Hunting)

### Encontrar Beaconing (C2 Communication)

```kql
// Conexiones regulares a IP externa = posible C2
DeviceNetworkEvents
| where TimeGenerated > ago(24h)
| where RemoteIPType == "Public"
| summarize 
    Conexiones = count(),
    Bytes = sum(SentBytes),
    Intervalos = make_list(TimeGenerated)
    by DeviceName, RemoteIP, RemotePort
| where Conexiones > 50  // muchas conexiones = posible beacon
| order by Conexiones desc
```

### Usuarios con Múltiples IPs (Impossible Travel)

```kql
SigninLogs
| where TimeGenerated > ago(24h)
| where ResultType == "0"  // login exitoso
| summarize 
    IPsUsadas = dcount(IPAddress),
    Paises = dcount(LocationDetails)
    by UserPrincipalName
| where IPsUsadas > 3 or Paises > 2
| order by IPsUsadas desc
```

---

## 🧪 Labs a Completar Esta Semana

- [ ] **Lab KQL 1**: 10 queries básicas en Log Analytics sandbox (where, project, take)
- [ ] **Lab KQL 2**: Queries con summarize — contar eventos por tipo
- [ ] **Lab KQL 3**: Crear una detection rule en Sentinel con KQL personalizado
- [ ] **Lab KQL 4**: Hunting query — buscar logins fallidos en las últimas 24h
- [ ] **Lab KQL 5**: Join entre SigninLogs y AuditLogs para correlacionar

### Recursos para Practicar KQL

| Recurso | URL | Tipo |
|---------|-----|------|
| Log Analytics Demo | portal.azure.com (workspace demo) | Gratis |
| KQL Tutorial | learn.microsoft.com/kusto | Gratis |
| Must Learn KQL (series) | github.com/rod-trent/MustLearnKQL | Gratis |
| SC-200 KQL Practice | microsoft.github.io/SC-200T00A | Gratis |

---

## 📝 Mis Queries Personalizadas

> _Guarda aquí las queries que vayas creando_

```kql
// Query 1: [Nombre]
// Propósito: 

// Query 2: [Nombre]
// Propósito: 
```

---

## 🔗 Notas Relacionadas

- [[00_INDEX_SC200]] — Índice principal
- [[CHEATSHEET_KQL]] — Referencia rápida completa
- [[01_Semana1_Sentinel_Fundamentos]] — Anterior
- [[03_Semana3_Defender_XDR]] — Siguiente

---

*Nota creada el 2026-06-08 | SC-200 Semana 2 — KQL Kusto Query Language*
