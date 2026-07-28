---
tags: [sc-200, ai-skills-fest, microsoft, intune, defender, entra, endpoints, case-study]
fecha: 2026-06-10
ultima_actualizacion: 2026-06-10
estado: 📖 En estudio
tipo: Caso Práctico
relacionado: "[[00_INDEX_SC200]], [[03_Semana3_Defender_XDR]], [[AI_Skills_Fest_Security_Pro]]"
---

# 🖥️ Case Study — Securing Endpoints and Infrastructure

> **Fuente:** Microsoft AI Skills Fest 2026 — Interactive Case Study
> **Escenario:** Litware Inc. necesita establecer gestión consistente de endpoints en todos sus dispositivos
> **Relevancia SC-200:** Alta — Dominio 2 (Configure Protections & Detections, ~40%)

---

## 🎯 Pregunta del Caso

**¿Qué solución ayuda a Litware Inc. a establecer gestión consistente de endpoints y seguridad en todos los dispositivos?**

---

## ✅ Soluciones Correctas

### 1. Microsoft Intune
> *"Centralizes device management, enforces compliance, and surfaces remediation tasks through Defender integration."*

- Gestión centralizada de todos los dispositivos (Windows, iOS, Android, macOS)
- Aplica políticas de cumplimiento (compliance policies)
- Se integra con **Defender for Endpoint** para exponer tareas de remediación directamente en Intune
- Punto clave: Intune + Defender = visibilidad de vulnerabilidades + acción desde un solo lugar

### 2. Microsoft Entra Conditional Access
> *"Blocks non-compliant devices. Policies adapt to role, risk, and zones to prevent security incidents."*

- Bloquea el acceso a dispositivos que no cumplan con las políticas
- Las políticas se adaptan dinámicamente según:
  - **Rol** del usuario (admin, empleado, invitado)
  - **Riesgo** de la sesión/usuario (señal de Entra ID Protection)
  - **Zonas** o ubicaciones (red corporativa, red externa)
- Previene incidentes antes de que ocurran — control de acceso preventivo

### 3. Microsoft Defender for Endpoint (MDE)
> *"Provides real-time threat detection, surfaces vulnerabilities in Intune, and automates response and remediation."*

- Detección de amenazas en tiempo real sobre los endpoints
- **Expone vulnerabilidades en Intune** → el equipo de seguridad ve y actúa desde Intune
- Automatiza respuesta y remediación (aislar dispositivo, iniciar AV scan, etc.)
- Puente entre seguridad (Defender) y gestión de dispositivos (Intune)

---

### 4. Microsoft Defender for IoT
> *"Provides agentless detection and response, identifies anomalies and integrates alerts to Sentinel and Defender XDR."*

- **Agentless** — no requiere instalar agente en los dispositivos OT/IoT (crítico para entornos industriales donde no se puede instalar software)
- Detecta anomalías en tráfico de red de dispositivos IoT/OT
- Integra alertas directamente a **Microsoft Sentinel** y **Defender XDR**
- Ideal para entornos como plantas industriales (Litware Inc. plant en el escenario)

```
Casos de uso:
├── Plantas industriales (OT/SCADA)
├── Cámaras IP, sensores, PLCs
├── Dispositivos sin OS actualizable
└── Todo lo que NO puede tener un agente instalado
```

---

## ❌ Solución Incorrecta — Trampa de Examen

### Microsoft Purview Information Protection
> *"NOT a suitable solution component. It is designed to classify, label, and protect sensitive data — not to enforce security baselines or provide device-level threat protection."*

⚠️ **Por qué es un distractor:**
- Purview clasifica y etiqueta datos sensibles (ej: "Confidencial", "Interno")
- **No** aplica baselines de seguridad en dispositivos
- **No** detecta amenazas a nivel de endpoint
- Se confunde porque también "protege" — pero protege **datos**, no **dispositivos**

```
PURVIEW = protección de DATOS (clasificación, etiquetas, DLP)
MDE     = protección de DISPOSITIVOS (detección, respuesta)
```

---

## 🌐 Pregunta 2 — Hybrid Cloud & Multi-Azure Environments

**¿Qué solución ayuda a Litware Inc. a estandarizar seguridad y monitoreo en entornos híbridos y Azure independientes?**

### ✅ Microsoft Defender for Cloud (MDC)
> *"Secures hybrid environments, identifies misconfigurations, aligns with Zero Trust, and ensures consistent monitoring."*

- Visibilidad y postura de seguridad unificada en Azure, on-premises y otras clouds
- Identifica **misconfigurations** y las prioriza con Secure Score
- Alineado con **Zero Trust** — verifica, nunca confía implícitamente
- Monitoreo consistente en todos los entornos desde un solo panel

```
MDC cubre:
├── Azure (nativo)
├── On-premises (vía Azure Arc)
├── AWS y GCP (vía conectores multi-cloud)
└── Containers, VMs, DBs, App Services
```

### ✅ Azure Arc
> *"Enforces policy and compliance on-premises and edge systems, enables centralized governance, and supports Defender for Cloud deployment."*

- Extiende el control de Azure a recursos **fuera de Azure** (on-premises, edge, otras clouds)
- Aplica **Azure Policy** en sistemas edge y on-premises
- Habilita governance centralizado desde Azure Resource Manager
- Es el **prerequisito** para desplegar Defender for Cloud en recursos no-Azure

```
Flujo:
Edge/On-premises resource
        │
        ▼
    Azure Arc  (registra el recurso en ARM)
        │
        ▼
  Azure Policy  (aplica compliance)
        │
        ▼
  Defender for Cloud  (protección y monitoreo)
```

### ✅ Azure Bastion
- Acceso RDP/SSH seguro a VMs **sin exponer puertos públicos**
- Elimina la necesidad de IPs públicas en VMs
- Reduce la superficie de ataque en acceso remoto a infraestructura

### ℹ️ Microsoft Security Copilot (mencionado en diagrama)
- Asistente de IA para analistas SOC — acelera investigación de incidentes
- No es una solución de enforcement/compliance sino de **asistencia al analista**

---

## 🔍 Pregunta 3 — Unify Threat Detection Across IT, OT & Cloud

**¿Qué solución ayuda a Litware Inc. a unificar la detección y respuesta de amenazas en entornos IT, OT y cloud?**

### ✅ Microsoft Defender XDR
> *"Unifies investigation across endpoints and uses AI to speed up containment."*

- Correlaciona señales de múltiples productos Defender en **una sola investigación unificada**
- Usa **IA** para acelerar el containment automático
- Cubre: endpoints (MDE), identidades (MDI), email (MDO), cloud apps (MDCA), IoT
- Reduce el tiempo de respuesta al eliminar el pivoteo entre herramientas separadas

```
Defender XDR correlaciona:
├── MDE  (Defender for Endpoint)      ← IT endpoints
├── MDI  (Defender for Identity)       ← Active Directory / Entra ID
├── MDO  (Defender for Office 365)     ← Email / colaboración
├── MDCA (Defender for Cloud Apps)     ← SaaS / Shadow IT
└── MD IoT (Defender for IoT)          ← OT / entornos industriales
         │
         ▼
  Incident unificado con contexto completo
  + Auto-containment por IA
```

### ✅ Microsoft Sentinel
> *"Centralizes alerts, correlates threat signals, and enables automated response."*

- **SIEM + SOAR** en un solo servicio cloud-native
- Centraliza alertas de Defender XDR, MDC, fuentes externas y logs propios
- Correlaciona señales de amenaza con **Analytics Rules** (KQL)
- Automatiza respuesta vía **Playbooks** (Logic Apps)

```
Sentinel en este escenario:
Defeender XDR  ┐
Defender IoT   ├─→  Microsoft Sentinel  ─→  Incident  ─→  Playbook (respuesta)
Azure Monitor  ┘           (correlación KQL)              (automatización)
```

### ❌ Azure Lighthouse (distractor en este contexto)
- Permite a MSPs gestionar múltiples tenants de clientes desde un solo panel
- **No** es una herramienta de detección de amenazas
- Aparece como opción drag pero no aplica para unificar threat detection

### 🔑 Diferencia clave Sentinel vs Defender XDR

| | Microsoft Sentinel | Defender XDR |
|---|---|---|
| **Tipo** | SIEM + SOAR | XDR |
| **Alcance** | Cualquier fuente (logs, APIs, externo) | Productos Microsoft Defender |
| **Fortaleza** | Correlación amplia + automatización custom | Investigación profunda entre productos MS |
| **KQL** | Sí (central) | Sí (Advanced Hunting) |
| **Ideal para** | SOC completo, multi-fuente | Respuesta rápida en ecosistema Microsoft |

> 💡 En el examen SC-200 pueden ser **complementarios** — Sentinel ingiere alertas de Defender XDR

---

## 📡 Pregunta 4 — Secure Telemetry Processing (IoT Edge + IoT Hub)

**¿Qué solución ayuda a Litware Inc. a crear procesamiento seguro de telemetría con IoT Edge e IoT Hub con conectividad privada?**

### ✅ Azure IoT Edge
> *"Runs on Ubuntu-based nodes, hosts containerized workloads, filters telemetry locally, and translates protocols from legacy OT systems."*

- Corre en nodos Ubuntu en el edge (fábrica, planta)
- Hostea **workloads containerizados** (módulos IoT Edge)
- Filtra y procesa telemetría **localmente** antes de enviarla a la nube
- Traduce protocolos legacy OT (Modbus, OPC-UA) a formatos cloud-compatible
- Funciona offline — sigue procesando aunque se pierda conectividad

### ✅ Hybrid Network Connectivity (VPN Gateway)
> *"Establishes secure VPN or ExpressRoute links to Azure, enabling private telemetry routing, segmentation, and isolated data flows with Private DNS."*

- Crea enlaces seguros **VPN o ExpressRoute** entre on-premises/planta y Azure
- Permite enrutamiento privado de telemetría (no sale a internet público)
- Habilita segmentación de red y flujos de datos aislados
- Usa **Private DNS** para resolver nombres de servicios Azure internamente

### ✅ Azure Private Link
> *"Enables secure, private access to IoT Hub, keeps telemetry off the public internet, and integrates with network policies and Azure Firewall for controlled access."*

- IP privada dentro de la VNet para acceder a **Azure IoT Hub**
- El tráfico de telemetría **nunca toca internet público**
- Se integra con **Azure Firewall** y network policies para control de acceso
- Complementa al VPN Gateway: la conectividad privada + el endpoint privado

### ✅ Azure IoT Hub
> *"Ingests telemetry from edge nodes, supports secure authentication and device provisioning via DPS, and integrates with Defender for IoT using RBAC access control."*

- Recibe (ingesta) telemetría de los nodos edge
- **DPS** (Device Provisioning Service) — autenticación y aprovisionamiento seguro de dispositivos
- Se integra con **Defender for IoT** para monitorear amenazas en dispositivos
- **RBAC** para controlar quién puede leer/escribir datos de dispositivos

```
Flujo completo:
Legacy OT device
      │ (protocolo Modbus/OPC-UA)
      ▼
  Azure IoT Edge  (traduce protocolo + filtra + containeriza)
      │ (datos procesados)
      ▼
  VPN Gateway / ExpressRoute  (enlace privado planta → Azure)
      │
      ▼
  Private Link  (endpoint privado en VNet)
      │
      ▼
  Azure IoT Hub  (ingesta + DPS + RBAC + Defender for IoT)
      │
      ▼
  Microsoft Sentinel / Defender XDR  (detección y respuesta)
```

### ❌ Azure Event Hubs (distractor)
> *"Built for big-data streaming, NOT for IoT Edge integration or private connectivity with IoT Hub."*

- Event Hubs = ingesta masiva de eventos/datos (big data, analytics)
- **No** gestiona dispositivos ni aprovisionamiento
- **No** tiene integración nativa con IoT Edge
- Se confunde porque también "recibe datos" — pero es para streaming de big data, no para IoT device management

```
COMPARACIÓN:
IoT Hub     = gestiona DISPOSITIVOS (autenticación, DPS, comandos, métodos)
Event Hubs  = ingesta masiva de EVENTOS (logs, telemetría genérica, analytics)
→ Para IoT seguro con Edge: siempre IoT Hub
```

---

## 🗺️ Arquitectura del Escenario

```
Litware Inc. (plantas + facilities)
         │
         ▼
   [Microsoft Intune]  ←──────────────────── Compliance Enforcement
         │                                          │
         ▼                                          │
[Defender for Endpoint] ──── vulnerabilidades ──────┘
         │
         ▼
  [Microsoft Entra]
  ├── Conditional Access (bloqueo por rol/riesgo/zona)
  ├── Entra ID Lifecycle Workflows
  ├── User portal
  ├── App Registrations
  └── Enterprise Applications
         │
         ▼
    Azure Resources
    ├── Azure VMs
    ├── Azure management groups
    └── Litware Inc. Azure subscriptions
         │
         ▼
       [SIEM]  ← Microsoft Sentinel
```

---

## 🔑 Conceptos Clave para el Examen

| Concepto | Recordar |
|----------|---------|
| Intune + MDE | Se integran: MDE expone vulns en Intune para remediación |
| Conditional Access | Bloquea por rol + riesgo + zona (no solo por usuario) |
| MDE vs Purview | MDE = endpoints / Purview = datos — NO intercambiables |
| Entra ID Lifecycle Workflows | Automatiza onboarding/offboarding de identidades |
| Compliance Policy | Intune evalúa si el dispositivo cumple antes de dar acceso |

---

## 🔗 Relación con Dominios SC-200

| Solución | Dominio SC-200 |
|----------|---------------|
| Microsoft Intune | Dominio 2 — Configure Protections & Detections |
| Entra Conditional Access | Dominio 2 — Manage identities & access |
| Defender for Endpoint | Dominio 2 — Configure MDE (40% del examen) |
| Microsoft Sentinel (SIEM) | Dominio 1 — Manage Security Ops Environment |

---

*Nota creada el 2026-06-10 | Fuente: AI Skills Fest 2026 — Interactive Case Study: Securing Endpoints and Infrastructure*
