---
tags: [sc-200, chronicle, sentinel, traduccion, ventaja]
fecha: 2026-06-08
ultima_actualizacion: 2026-06-08
estado: ✅ Referencia permanente
tipo: Referencia
relacionado: "[[01_Semana1_Sentinel_Fundamentos]], [[CHEATSHEET_KQL]]"
---

# 🔄 Chronicle → Microsoft Sentinel: Tu Ventaja

> Esta nota traduce directamente lo que ya sabes de Chronicle al ecosistema de Sentinel. No empieces desde cero — adapta.

---

## Equivalencias Directas

| Concepto | Chronicle (Google) | Microsoft Sentinel |
|----------|-------------------|-------------------|
| **SIEM backend** | Chronicle SIEM | Log Analytics Workspace |
| **Lenguaje de query** | UDM Query / YARA-L | KQL (Kusto) |
| **Tablas de logs** | UDM Events | SecurityEvent, SigninLogs, etc. |
| **Reglas de detección** | Detection Rules (YARA-L) | Analytics Rules (KQL) |
| **Alertas** | Detections | Alerts |
| **Cases** | Cases | Incidents |
| **Playbooks SOAR** | Playbooks (SOAR) | Logic Apps + Playbooks |
| **Dashboards** | Dashboards | Workbooks |
| **Threat hunting** | Hunting (UDM) | Hunting (KQL) |
| **IoCs** | Threat Intelligence | ThreatIntelligenceIndicator |
| **Ingesta de datos** | Log ingestion / feeds | Data Connectors |
| **Normalización** | UDM (Unified Data Model) | ASIM (Advanced SIEM Info Model) |

---

## Traducción de Queries

### Buscar logins fallidos

**Chronicle UDM:**
```
metadata.event_type = "USER_LOGIN" AND security_result.action = "FAIL"
```

**Sentinel KQL:**
```kql
SecurityEvent
| where EventID == 4625
| where TimeGenerated > ago(24h)
```

---

### Contar eventos por usuario

**Chronicle:**
```
$user = principal.user.userid
match $user over 1h
condition: #events > 10
```

**Sentinel KQL:**
```kql
SecurityEvent
| where TimeGenerated > ago(1h)
| summarize Conteo = count() by Account
| where Conteo > 10
```

---

### Buscar por IP de origen

**Chronicle:**
```
principal.ip = "192.168.1.100"
```

**Sentinel KQL:**
```kql
SecurityEvent
| where IpAddress == "192.168.1.100"
```

---

### Correlación de eventos (detection rule)

**Chronicle YARA-L:**
```yaml
rule brute_force_login {
  meta:
    description = "Multiple failed logins"
  events:
    $event.metadata.event_type = "USER_LOGIN"
    $event.security_result.action = "FAIL"
    $user = $event.principal.user.userid
  match:
    $user over 10m
  condition:
    #event > 5
}
```

**Sentinel Analytics Rule (KQL):**
```kql
SecurityEvent
| where TimeGenerated > ago(10m)
| where EventID == 4625
| summarize FailedCount = count() by Account
| where FailedCount > 5
```

---

## Conceptos que Son Idénticos

```
✅ Incident Response lifecycle     → Igual en ambos (Detect→Investigate→Respond)
✅ MITRE ATT&CK mapping           → Ambos usan T-numbers para técnicas
✅ Alert severity levels           → Informational/Low/Medium/High
✅ Entity extraction               → Usuarios, IPs, hosts como entidades
✅ Threat Intelligence feeds       → IoCs importados como indicadores
✅ SOAR automation philosophy      → Trigger → Condition → Action
✅ Case/Incident management        → Assignment, evidence, closure
```

---

## Conceptos Nuevos (Solo en Sentinel)

```
🆕 Log Analytics Workspace   → La capa de storage (detrás de Sentinel)
🆕 Azure RBAC para Sentinel   → Roles: Reader, Responder, Contributor
🆕 Logic Apps               → Motor de Playbooks (Azure-native)
🆕 ASIM parsers             → Normalización de logs multi-fuente
🆕 Fusion rules             → Correlación ML cross-producto (no en Chronicle)
🆕 Defender XDR integration  → Integración nativa con el ecosistema MS
🆕 Azure Policy              → Compliance y governance (MDC)
```

---

## Tu Estrategia de Estudio Basada en Esto

```
SEMANA 1 — Sentinel
Foco: Aprende la interfaz y terminología Azure.
El concepto ya lo tienes. Solo adapta.

SEMANA 2 — KQL
Foco: Es diferente a UDM/YARA-L pero la lógica es igual.
pipe-based como Splunk SPL.

SEMANA 3 — Defender XDR
Foco: Esto SÍ es nuevo. No hay equivalente directo en Chronicle.
Dale tiempo extra aquí.

SEMANA 4 — Simulacros
Dominio 3 (Response, 25%) ya lo dominas desde HTB.
Dominio 2 (Config, 40%) es donde más tiempo necesitas.
```

---

*Nota creada el 2026-06-08 | Referencia permanente — actualizar durante el estudio*
