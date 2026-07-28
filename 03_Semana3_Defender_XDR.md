---
tags: [sc-200, defender, xdr, endpoint, identity, cloud, semana3]
fecha: 2026-06-08
ultima_actualizacion: 2026-06-08
estado: 🟡 En construcción
tipo: Estudio
relacionado: "[[00_INDEX_SC200]], [[02_Semana2_KQL_Labs]]"
---

# 🛡️ Semana 3 — Microsoft Defender XDR

> **Idea central:** Defender XDR es el ecosistema de seguridad de Microsoft que se integra con Sentinel. Cubre endpoints, identidades, email, apps cloud y postura de seguridad. El examen evalúa cómo configurar, conectar y responder con cada componente.

---

## ¿Qué es Microsoft Defender XDR?

```
MICROSOFT DEFENDER XDR (Extended Detection & Response)
├─ Defender for Endpoint (MDE)      → Seguridad en dispositivos
├─ Defender for Identity (MDI)      → Seguridad en AD / identidades
├─ Defender for Office 365 (MDO)    → Seguridad en email y apps M365
├─ Defender for Cloud Apps (MDCA)   → CASB + seguridad de SaaS
└─ Defender for Cloud (MDC)         → Postura de seguridad en Azure/multi-cloud

Portal unificado: security.microsoft.com
```

---

## 1. Microsoft Defender for Endpoint (MDE)

### ¿Qué hace?
- EDR (Endpoint Detection & Response) para Windows, macOS, Linux, Android, iOS
- Detecta amenazas en dispositivos, responde a incidentes, threat hunting

### Onboarding — Cómo agregar dispositivos

```
Métodos de onboarding (importante para el examen):
├─ Script local (manual, para labs/pruebas)
├─ Group Policy (GPO) → Windows corporativos con AD
├─ Microsoft Endpoint Manager (Intune) → Dispositivos MDM
├─ System Center Configuration Manager (SCCM)
├─ VDI onboarding script → Infraestructura virtual no persistente
└─ Azure Arc → Para servidores no-Azure
```

### Tablas KQL de MDE

```kql
// Procesos en dispositivos
DeviceProcessEvents
| where DeviceName == "EQUIPO-01"
| where FileName == "powershell.exe"
| project TimeGenerated, InitiatingProcessFileName, ProcessCommandLine

// Eventos de red
DeviceNetworkEvents
| where RemotePort == 4444  // puerto típico de reverse shells
| project TimeGenerated, DeviceName, RemoteIP, RemotePort

// Archivos creados/modificados
DeviceFileEvents
| where FolderPath contains "\\Temp\\"
| where ActionType == "FileCreated"
| where FileName endswith ".exe" or FileName endswith ".ps1"
```

### Live Response — Acceso remoto a dispositivo

```
Desde portal MDE → Device → Live Response
├─ Correr scripts de investigación
├─ Subir/descargar archivos
├─ Ejecutar comandos en tiempo real
├─ Aislar dispositivo (quarantine)
└─ Collect investigation package (evidencia forense)
```

### Acciones de Respuesta en MDE

| Acción | Cuándo usar |
|--------|-------------|
| **Isolate device** | Contener un dispositivo comprometido |
| **Run AV scan** | Escanear malware |
| **Collect investigation package** | Obtener evidencia forense |
| **Restrict app execution** | Bloquear apps no autorizadas |
| **Stop and quarantine file** | Eliminar archivo malicioso |
| **Add indicator** | Bloquear hash/IP/URL globalmente |

---

## 2. Microsoft Defender for Identity (MDI)

### ¿Qué hace?
- Monitorea Active Directory On-Premise Y Azure AD
- Detecta: ataques de AD (Kerberoasting, Pass-the-Hash, DCSync)
- Alerta sobre comportamiento anómalo de cuentas

### Arquitectura

```
Active Directory DC
        ↓
MDI Sensor (instalado en DC)
        ↓
MDI Cloud Service (microsoft.com/cloud)
        ↓
Alertas en security.microsoft.com / Incidents en Sentinel
```

### Ataques que Detecta MDI (importantes para el examen)

| Ataque | Técnica MITRE | Descripción |
|--------|--------------|-------------|
| **Kerberoasting** | T1558.003 | Solicitar tickets Kerberos de cuentas de servicio para crackear offline |
| **Pass-the-Hash** | T1550.002 | Usar hash NTLM sin conocer la contraseña |
| **Pass-the-Ticket** | T1550.003 | Reusar tickets Kerberos robados |
| **DCSync** | T1003.006 | Simular un DC para obtener hashes de contraseñas |
| **Golden Ticket** | T1558.001 | Ticket Kerberos forjado con clave KRBTGT |
| **Lateral Movement** | T1021 | RDP/SMB sospechoso entre equipos |
| **Reconnaissance** | T1087 | Enumeración de usuarios/grupos de AD |

### Tablas KQL de MDI

```kql
// Logins detectados por MDI
IdentityLogonEvents
| where TimeGenerated > ago(24h)
| where ActionType == "LogonFailed"
| summarize FailedCount = count() by AccountUpn, IPAddress
| where FailedCount > 10

// Alertas de MDI
SecurityAlert
| where ProductName == "Azure Advanced Threat Protection"
| project TimeGenerated, AlertName, Severity, Entities
```

---

## 3. Microsoft Defender for Office 365 (MDO)

### ¿Qué hace?
- Protección de email: anti-phishing, anti-malware, anti-spam
- Protección de links (Safe Links) y archivos (Safe Attachments)
- Simulaciones de phishing y entrenamiento

### Planes

```
MDO Plan 1:
├─ Safe Links
├─ Safe Attachments  
└─ Anti-phishing básico

MDO Plan 2 (agrega):
├─ Threat Explorer (investigar emails)
├─ Attack Simulator
├─ Automated Investigation & Response (AIR)
└─ Advanced hunting en email
```

### Tablas KQL de MDO

```kql
// Emails con malware
EmailEvents
| where ThreatTypes has "Malware"
| project TimeGenerated, SenderFromAddress, RecipientEmailAddress, Subject, ThreatTypes

// Links maliciosos clickeados
UrlClickEvents
| where ActionType == "ClickAllowed"  // usuario accedió al link
| where ThreatTypes has "Phish"
| project TimeGenerated, AccountUpn, Url, ThreatTypes
```

---

## 4. Microsoft Defender for Cloud (MDC)

### ¿Qué hace?
- Cloud Security Posture Management (CSPM): evalúa configuraciones
- Cloud Workload Protection (CWP): protege VMs, containers, databases
- Multicloud: Azure, AWS, GCP

### Conceptos Clave

```
SECURE SCORE
├─ Puntuación de postura de seguridad (0-100%)
├─ Recomendaciones ordenadas por impacto
└─ Cada recomendación tiene pasos de remediación

ALERTS (en MDC):
├─ Detecciones de amenazas en tiempo real
├─ VMs comprometidas, ataques a contenedores, etc.
└─ Se pueden enviar a Sentinel como incidents

REGULATORY COMPLIANCE:
├─ Dashboard de cumplimiento normativo
├─ PCI-DSS, ISO 27001, NIST, etc.
└─ Estado actual vs requerimientos
```

### Tablas KQL de MDC

```kql
// Alertas de Defender for Cloud
SecurityAlert
| where ProductName == "Azure Security Center"
| where AlertSeverity in ("High", "Medium")
| project TimeGenerated, AlertName, AlertSeverity, CompromisedEntity, Description
| order by TimeGenerated desc

// Recomendaciones de seguridad
SecurityRecommendation
| where RecommendationState == "Unhealthy"
| summarize count() by RecommendationName
| order by count_ desc
```

---

## Conectar Defender XDR con Sentinel

### Pasos (examen frecuente)

```
1. En Sentinel → Data Connectors
2. Buscar "Microsoft Defender XDR"
3. Clic en "Open connector page"
4. Seleccionar los productos a conectar:
   ✅ Defender for Endpoint
   ✅ Defender for Identity
   ✅ Defender for Office 365
   ✅ Defender for Cloud Apps
5. Conectar
6. Elegir si incluir incidents o solo alerts
   → Recomendado: incidents (evita duplicados)
```

> ⚠️ **Importante**: Cuando conectas Defender XDR a Sentinel, las alertas de Defender se convierten en incidents en Sentinel. Configura "incident sync" para tener un solo panel.

---

## Incident Investigation — Flujo Completo

> [!note] Ciclo operativo formal (Tres Pasos)
> El flujo de trabajo del analista en el portal unificado de Defender XDR se modela como tres pasos: **Triage → Investigate → Respond/Remediate**. Incluye la Incident Queue, Attack Story, AIR, Advanced Hunting, Response Actions y Action Center. Ver documentación completa en [[CONCEPTOS_CLAVE]] § 3.

```
SENTINEL recibe incident
        ↓
Revisar: Título, Severidad, Entidades involucradas
        ↓
Abrir Investigation Graph (visualización automática)
        ↓
Revisar entidades:
├─ IP → Threat Intelligence? ¿Historial?
├─ Usuario → ¿Actividad anómala? ¿Ubicación?
└─ Host → ¿Estado en MDE? ¿Otros incidents?
        ↓
Go Hunt → Queries KQL relacionadas
        ↓
Bookmark hallazgos importantes
        ↓
Ejecutar Playbook si corresponde
        ↓
Respond: Aislar host / Bloquear usuario / Bloquear IP
        ↓
Cerrar incident: True Positive / False Positive / Benign
```

---

## Secure Score (Puntos Clave)

```
Secure Score en Microsoft 365 Defender:
├─ Refleja postura de seguridad en M365/identidades
├─ Acciones de mejora con puntos asignados
└─ Comparación con industria y sector

Secure Score en Defender for Cloud:
├─ Refleja postura de seguridad en recursos Azure
├─ Recomendaciones por severidad
└─ Quick Fix disponible en muchas recomendaciones
```

---

## 🧪 Labs a Completar Esta Semana

- [ ] **Lab 1**: Onboarding de VM Windows en MDE con script local
- [ ] **Lab 2**: Revisar alertas de MDE y responder (aislar dispositivo)
- [ ] **Lab 3**: Configurar Safe Links y Safe Attachments en MDO
- [ ] **Lab 4**: Revisar Secure Score en MDC y aplicar una recomendación
- [ ] **Lab 5**: Conectar Defender XDR a Sentinel y validar incidents

---

## 📊 Resumen Comparativo — Cuándo usar qué

| Situación | Herramienta |
|-----------|-------------|
| Dispositivo posiblemente comprometido | MDE → Investigate + Isolate |
| Credenciales robadas / ataque AD | MDI → Identity alerts |
| Email phishing recibido | MDO → Threat Explorer |
| App cloud con datos expuestos | MDCA → Session policies |
| VM en Azure con configuración insegura | MDC → Recommendations |
| Correlacionar TODO en un solo incident | Sentinel → Investigation |

---

## 🔗 Notas Relacionadas

- [[00_INDEX_SC200]] — Índice principal
- [[02_Semana2_KQL_Labs]] — KQL para queries de estos productos
- [[04_Semana4_Simulacros]] — Siguiente: práctica y examen

---

*Nota creada el 2026-06-08 | SC-200 Semana 3 — Microsoft Defender XDR*
