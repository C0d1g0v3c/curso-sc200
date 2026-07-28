---
tags: [sc-200, ai-skills-fest, microsoft, sentinel, defender, intune, iot, implementacion, case-study]
fecha: 2026-06-10
ultima_actualizacion: 2026-06-10
estado: 📖 En estudio
tipo: Caso Práctico — Planes de Implementación
relacionado: "[[00_INDEX_SC200]], [[05_CaseStudy_Endpoints_Infrastructure]], [[03_Semana3_Defender_XDR]]"
---

# 📋 Case Study — Implementation Plans (Litware Inc.)

> **Fuente:** Microsoft AI Skills Fest 2026 — Securing Endpoints and Infrastructure
> **Qué son:** Planes de acción recomendados para cada área de seguridad
> **Relevancia SC-200:** Alta — estos pasos son exactamente lo que el examen evalúa en los 3 dominios

---

## 1️⃣ Enhance Threat Detection and Automated Response

> **Herramienta principal:** Microsoft Defender for Endpoint (MDE)

- Habilitar **AIR** (Automated Investigation and Response) — investiga y remedia automáticamente sin intervención humana
- Habilitar **EDR in block mode** — bloquea comportamiento malicioso incluso si el AV principal es de terceros (no-Microsoft)
- Crear **custom detection rules** para amenazas específicas de fábrica: portable executables, remote access tools no autorizados
- Usar el **Microsoft Defender portal** como centro de correlación de incidentes, threat analytics e investigaciones
- Monitorear **Incidents** y **Advanced Hunting dashboards** para identificar patrones de ataque cross-device y priorizar amenazas de alto riesgo

```
Conceptos clave para SC-200:
AIR          → respuesta automática en MDE (sin analista)
EDR in block → funciona con AV de terceros (Symantec, McAfee, etc.)
Custom rules → KQL-based detection en Advanced Hunting
Adv. Hunting → consultas KQL proactivas en Defender XDR
```

---

## 2️⃣ Establish Endpoints Security Baseline and Compliance Enforcement

> **Herramientas:** Microsoft Intune + MDE + Entra Conditional Access

- **Enroll** todos los dispositivos Windows 11 y Linux (incluidos contractors) en **Microsoft Intune**
- Desplegar **MDE** en dispositivos enrollados usando **Intune app deployment policies**
- Definir **compliance policies** para:
  - Niveles de parcheo del OS
  - Estado del antivirus
  - Cifrado de disco (BitLocker)
- Integrar Intune con MDE para exponer **security recommendations** y asignar **remediation tasks**
- Configurar **Entra ID Conditional Access** para restringir acceso desde dispositivos no-compliant o high-risk

```
Flujo de compliance:
Dispositivo enrollado en Intune
        │
        ▼
Compliance Policy evaluada (OS patch + AV + encryption)
        │
   ¿Compliant?
   ├── Sí → Entra Conditional Access permite acceso
   └── No → Acceso bloqueado / remediation task asignada vía MDE
```

---

## 3️⃣ Deploy Centralized Security Monitoring and Correlation

> **Herramienta principal:** Microsoft Sentinel (SIEM + SOAR)

- Desplegar **Microsoft Sentinel** para agregar telemetría de seguridad de todos los SIEMs regionales, entornos cloud e infraestructura on-premises
- Integrar con Sentinel: **Defender for Endpoint**, **Defender for IoT** y otras soluciones relevantes → analytics, alerting, automated workflows
- Configurar **Sentinel Workbooks** adaptados a escenarios de manufactura y requisitos de compliance
- Configurar **Playbooks** (Logic Apps) para respuesta automatizada en esos escenarios
- Usar la integración **Sentinel ↔ Defender XDR** para:
  - Threat hunting unificado
  - Correlación de incidentes cross-domain
  - Automated response workflows en IT y OT

```
Arquitectura de monitoreo centralizado:
SIEMs regionales  ─┐
Defender for MDE   ├─→  Log Analytics Workspace  →  Microsoft Sentinel
Defender for IoT   │              │                        │
Cloud environments ┘         (ingesta)              Analytics Rules (KQL)
                                                          │
                                             ┌────────────┴────────────┐
                                         Workbooks               Playbooks
                                       (dashboards)          (automatización)
```

---

## 4️⃣ Secure Operational Technology and IoT Assets

> **Herramienta principal:** Microsoft Defender for IoT

- Desplegar **sensores Defender for IoT** en sitios de producción para monitorear pasivamente el tráfico OT/IoT y detectar comportamiento anómalo o no autorizado
- Integrar Defender for IoT con **Microsoft Sentinel** y **Microsoft Defender XDR** para correlación cross-domain e investigación unificada
- Iniciar **inventario y risk scoring** de activos OT legacy; priorizar visibilidad en segmentos de red planos (flat networks) y zonas de alto riesgo no gestionadas
- **Segmentar redes OT/IoT** usando firewalls y VLANs para limitar lateral movement entre:
  - Activos no gestionados
  - Estaciones de ingeniería
  - Gateways conectados a internet
- Diseñar zonas de red que aíslen sistemas de control críticos, aplicar **least-privilege routing** y alinearse con principios de **Zero Trust segmentation**

```
Principios OT/IoT Security:
├── Pasivo primero  → Defender for IoT no interrumpe operaciones
├── Inventario      → No puedes proteger lo que no ves
├── Segmentación    → Firewalls + VLANs = contener lateral movement
├── Least privilege → Solo el tráfico necesario entre zonas
└── Zero Trust      → Verificar siempre, incluso dentro de la red OT
```

---

## 5️⃣ Modernize Edge and Hybrid Infrastructure

> **Herramientas:** Azure Arc + Defender for Cloud + Azure Management Groups + Azure Policy

- **Onboard** servidores on-premises (bases de datos, middleware) a **Azure Arc** para gestión unificada de lifecycle y políticas
- Habilitar **Defender for Cloud** para evaluar y monitorear la postura de seguridad de VMs en Azure y máquinas conectadas por Arc
- Configurar **Secure Score dashboards por región** para benchmarking y guiar remediación
- Introducir **Azure Management Groups** para organizar suscripciones bajo una jerarquía de governance común
- Asignar **Azure Policy e initiative definitions** a nivel de Management Group para:
  - Aplicar security baselines
  - Cumplir requisitos regulatorios
  - Estandarizar monitoring

```
Jerarquía de governance:
Management Group (Litware Inc.)
├── Azure Policy aplicada aquí  →  hereda a todos los hijos
├── Suscripción: Plant Azure
├── Suscripción: Facility Azure
└── Suscripción: Corp Azure
         │
    Arc-connected machines (on-premises)
    también reciben las políticas
```

---

## 6️⃣ Deploy Unified Edge Telemetry and Secure IoT Integration

> **Herramientas:** Azure IoT Edge + IoT Hub + Private Endpoint + Sentinel + DPS

- Instalar **Azure IoT Edge runtime** en nodos de cómputo edge existentes → procesamiento local, filtrado y transformación de telemetría
- Configurar **forwarding de telemetría** desde módulos IoT Edge hacia **Azure IoT Hub** como gateway centralizado
- Establecer **Private Endpoint connectivity** a IoT Hub → telemetría dentro de redes internas seguras (factory network isolation)
- Integrar telemetría de IoT Hub con **Log Analytics** y **Microsoft Sentinel** para continuidad de monitoreo y analytics workflows
- Usar **IoT Hub Device Provisioning Service (DPS)** para estandarizar identidad, registro y gestión del ciclo de vida de futuros activos IoT

```
Stack completo de IoT seguro:
[Edge compute node]
      │ IoT Edge runtime
      ▼
[IoT Edge Modules]  ← filtrado + transformación local
      │ telemetría procesada
      ▼
[Azure IoT Hub]  ←── Private Endpoint (sin internet público)
      │
      ├── DPS → identity + provisioning de nuevos dispositivos
      ├── Log Analytics → retención y queries
      └── Microsoft Sentinel → detección, alertas, hunting
```

---

## 🔗 Mapa de Planes → Dominios SC-200

| Plan | Dominio SC-200 | Peso |
|------|---------------|------|
| Enhance threat detection (AIR, EDR, Advanced Hunting) | Dominio 2 — Configure Protections | ~40% |
| Endpoints baseline (Intune + Compliance + CA) | Dominio 2 | ~40% |
| Centralized monitoring (Sentinel + Workbooks + Playbooks) | Dominio 1 + 3 | 35%+25% |
| Secure OT/IoT (Defender for IoT + segmentación) | Dominio 2 | ~40% |
| Modernize hybrid (Arc + MDC + Management Groups) | Dominio 1 | ~35% |
| Unified IoT telemetry (IoT Edge + Hub + DPS + Private Endpoint) | Dominio 2 | ~40% |

---

## ⚡ Conceptos Críticos que Repiten en los 6 Planes

| Concepto | Aparece en |
|----------|-----------|
| **EDR in block mode** | Plan 1 |
| **AIR (Automated Investigation & Response)** | Plan 1 |
| **Intune compliance policies** | Plan 2 |
| **Entra Conditional Access** | Plan 2 |
| **Sentinel Workbooks + Playbooks** | Plan 3 |
| **Sentinel ↔ Defender XDR integration** | Plan 3 |
| **Defender for IoT (pasivo, agentless)** | Plan 4 |
| **OT network segmentation (VLANs + firewalls)** | Plan 4 |
| **Azure Arc + Azure Policy** | Plan 5 |
| **Secure Score por región** | Plan 5 |
| **DPS (Device Provisioning Service)** | Plan 6 |
| **Private Endpoint para IoT Hub** | Plan 6 |

---

*Nota creada el 2026-06-10 | Fuente: AI Skills Fest 2026 — Securing Endpoints and Infrastructure — Implementation Plans*
