---
tags: [sc-200, ai-skills-fest, microsoft, sentinel, defender, multicloud, devSecOps, kubernetes]
fecha: 2026-06-08
ultima_actualizacion: 2026-06-08
estado: ✅ Completado
tipo: Estudio
relacionado: "[[00_INDEX_SC200]], [[01_Semana1_Sentinel_Fundamentos]], [[03_Semana3_Defender_XDR]]"
---

# 🏅 AI Skills Fest 2026 — Security Pro: Strengthen Security Foundations

> **Fuente:** Microsoft AI Skills Fest 2026 — Playlist completada para voucher SC-200
> **Fecha:** 2026-06-08
> **Relevancia SC-200:** Alta — cubre Sentinel, Defender for Cloud, identidades y multi-cloud

---

## 📋 Módulos del Playlist

1. [[#Módulo 1 Extend Azure Governance to Amazon EKS]]
2. [[#Módulo 2 Secure CI/CD Pipelines y IaC]]
3. [[#Módulo 3 Secure Identity y Secret Management]]
4. [[#Módulo 4 Private Access a SQL, Cosmos DB y Key Vault]]
5. [[#Módulo 5 Centralize Monitoring, Threat Detection e IR]]
6. [[#Módulo 6 Automate Container y Dependency Risk]]

---

## Módulo 1: Extend Azure Governance to Amazon EKS

> **Objetivo**: Llevar los controles de Azure a clusters Kubernetes en AWS (EKS)

### Conceptos Clave

```
AZURE ARC
├─ Permite registrar recursos NO-Azure en Azure Resource Manager
├─ EKS (Amazon Kubernetes) → registrado en Azure vía Arc
├─ Una vez registrado: Azure Policy + Defender for Containers aplicados
└─ Gestión centralizada desde Azure aunque el cluster esté en AWS
```

### Pasos del Módulo

- **Azure Arc para EKS** → Onboard EKS clusters al control plane de Azure
- **Azure Resource Manager** → Centraliza management y enforcement de políticas
- **Azure Policy on EKS** → Governance consistente entre Azure y AWS
- **Defender for Containers on EKS** → Protección de runtime en clusters AWS
- **Workload Identity Federation** → Pods de EKS acceden a recursos Azure vía Entra ID sin credenciales hardcodeadas

### Relación con SC-200

```
Defender for Containers → Defender for Cloud (MDC) → Semana 3
Azure Policy enforcement → Postura de seguridad → Secure Score
Multi-cloud visibility → todo en un solo panel en Defender for Cloud
```

---

## Módulo 2: Secure CI/CD Pipelines y IaC

> **Objetivo**: Integrar seguridad en el pipeline de desarrollo (DevSecOps)

### Conceptos Clave

```
DEFENDER FOR CLOUD DEVOPS
├─ Conectar pipelines de GitHub Actions, Azure DevOps, GitLab
├─ Escanea IaC (Terraform, Bicep, ARM) buscando misconfigurations
├─ Escanea containers en el pipeline antes del deploy
└─ Resultados visibles en Defender for Cloud como recomendaciones
```

### Pasos del Módulo

- **Security scanning en CI/CD** → Antes de que el código llegue a producción
- **Secret management** → No hardcodear secretos — usar Key Vault / Managed Identities
- **Defender for Cloud DevOps** → IaC misconfiguration detection automática
- **Azure Policy + admission control** → Bloquea deployments que no cumplan políticas
- **AKS + EKS via Azure Arc** → Governance uniforme en ambos clouds

### Conceptos que Entran en SC-200

```
Defender for Cloud → Semana 3 ← importante
IaC security       → Postura de seguridad, Secure Score
Admission control  → Azure Policy en Kubernetes (AKS)
```

---

## Módulo 3: Secure Identity y Secret Management

> **Objetivo**: Eliminar secretos de larga duración, usar identidades en su lugar

### Conceptos Clave

```
MANAGED IDENTITIES (Azure)
├─ Identidad asignada a un workload/VM/pod en AKS
├─ No hay contraseña ni API key guardada en código
├─ Azure AD / Entra ID gestiona el token automáticamente
└─ Equivalente AWS: IAM Roles for Service Accounts (IRSA) en EKS

WORKLOAD IDENTITY FEDERATION
├─ EKS pods obtienen acceso a recursos Azure (SQL, Cosmos, Key Vault)
├─ Sin secretos embebidos en el código
└─ Vía Azure Arc + Entra ID
```

### Pasos del Módulo

- **Managed Identities para AKS** → Pods acceden a recursos Azure sin secrets
- **IRSA para EKS** → Equivalente en AWS — IAM Roles por Service Account
- **Arc Workload Identity Federation** → EKS → Azure Key Vault / SQL / Cosmos DB
- **Eliminar secrets embebidos** → Migrar a workload identities
- **Azure Key Vault** → Always Encrypted Column Encryption Keys (CEKs) — solo acceso por workloads autorizados vía políticas de identidad

### Always Encrypted

```
Azure SQL + Always Encrypted:
├─ Datos cifrados en el cliente antes de llegar a la BD
├─ Column Encryption Keys (CEKs) guardadas en Azure Key Vault
├─ La BD nunca ve los datos en claro
└─ Solo workloads con identidad autorizada pueden descifrar
```

---

## Módulo 4: Private Access a SQL, Cosmos DB y Key Vault

> **Objetivo**: Eliminar endpoints públicos, todo por red privada

### Conceptos Clave

```
AZURE PRIVATE ENDPOINTS
├─ IP privada dentro de tu VNet para un servicio Azure (SQL, Key Vault, etc.)
├─ El tráfico nunca sale a internet público
├─ Azure Private Link = el servicio que habilita esto
└─ Azure DNS Private Resolver = resuelve FQDNs de Private Link desde otras redes

CROSS-CLOUD CONNECTIVITY (Azure ↔ AWS)
├─ AKS → Azure VNet → Private Endpoint (fácil, misma red)
└─ EKS → VPN Gateway o SD-WAN → Azure VNet → Private Endpoint
```

### Pasos del Módulo

- **Private Endpoints** para SQL Database, Cosmos DB, Key Vault
- **VNet peering** → AKS clusters a la VNet con los private endpoints
- **VPN Gateway / SD-WAN** → EKS (AWS) a Azure VNet
- **Azure DNS Private Resolver** → Resolver nombres privados desde workloads de AWS
- **Dynamic Data Masking** → Oculta datos sensibles a usuarios no autorizados
- **Always Encrypted** → Cifrado del lado del cliente, llaves en Key Vault

### Para SC-200

```
Network isolation → Seguridad de infraestructura
Key Vault → Gestión de secretos (MDC lo evalúa)
Private Endpoints → Recomendaciones de Secure Score en MDC
```

---

## Módulo 5: Centralize Monitoring, Threat Detection e IR

> **Objetivo**: Un solo panel para señales de seguridad de toda la infraestructura

### Arquitectura del Módulo

```
FUENTES DE DATOS → MICROSOFT SENTINEL

Azure Monitor          ─┐
Defender for Cloud     ─┤
Defender for Endpoint  ─┤→  Log Analytics Workspace → Sentinel
Defender for Identity  ─┤         (KQL queries)         ↓
GitHub                 ─┤                          Analytics Rules
Microsoft Entra ID     ─┘                               ↓
                                                    Incidents
                                                        ↓
                                                   Playbooks
                                                   (automatización)
                                                        ↓
                                              Ticketing / GitHub Issues
```

### Pasos del Módulo

- **Centralizar señales** en Sentinel desde todos los productos
- **Analytics Rules custom** para detectar: anomalías, deployment events, IaC drift
- **Playbooks automatizados** para containment y remediación
- **Integración con ticketing** (ServiceNow, Jira) y GitHub para triage
- **Root cause tracking** directo desde el incident en Sentinel

### ⭐ MUY RELEVANTE para SC-200

```
Este módulo ES el SC-200:
├─ Sentinel analytics rules → Dominio 2 (40%)
├─ Playbooks de respuesta → Dominio 3 (25%)
├─ Centralización de fuentes → Dominio 1 (35%)
└─ IaC drift detection → Defender for Cloud DevOps
```

---

## Módulo 6: Automate Container y Dependency Risk

> **Objetivo**: Automatizar la gestión de vulnerabilidades en containers

### Conceptos Clave

```
ACR TASKS (Azure Container Registry)
├─ Tareas que se disparan automáticamente
├─ Trigger: nuevo commit al repo / actualización de imagen base
├─ Acción: build + scan de vulnerabilidades
└─ Resultado: imagen segura antes de llegar a producción

DEFENDER FOR CLOUD
├─ Recibe resultados de ACR Tasks
├─ Prioriza vulnerabilidades por severidad y explotabilidad
├─ Integra con Sentinel para alertar sobre riesgos críticos
└─ Secure Score afectado por imágenes sin parchear
```

### Pasos del Módulo

- **Monitoreo continuo** de base images y paquetes open-source
- **ACR Tasks** → scan automático en cada commit o actualización de imagen
- **Defender for Cloud** → tracking de image risks con priorización
- **Sentinel** → alertas sobre dependencias críticas

---

## 🔗 Mapa de Conceptos → SC-200

| Concepto del Playlist | Dominio SC-200 | Nota Relacionada |
|-----------------------|---------------|-----------------|
| Microsoft Sentinel centralización | Dominio 1 (35%) | [[01_Semana1_Sentinel_Fundamentos]] |
| Analytics Rules custom | Dominio 2 (40%) | [[01_Semana1_Sentinel_Fundamentos]] |
| Playbooks de respuesta | Dominio 3 (25%) | [[01_Semana1_Sentinel_Fundamentos]] |
| Defender for Cloud (MDC) | Dominio 2 | [[03_Semana3_Defender_XDR]] |
| Defender for Containers | Dominio 2 | [[03_Semana3_Defender_XDR]] |
| Managed Identities / Entra ID | Dominio 2 | [[03_Semana3_Defender_XDR]] |
| Azure Arc multi-cloud | Bonus | Contexto avanzado |
| KQL para detection rules | Transversal | [[02_Semana2_KQL_Labs]] |

---

## ✅ Status del Playlist

- [x] Módulo 1 — Azure Arc + EKS Governance
- [x] Módulo 2 — Secure CI/CD + IaC
- [x] Módulo 3 — Identity + Secret Management
- [x] Módulo 4 — Private Access + Encryption
- [x] Módulo 5 — Sentinel Centralization
- [x] Módulo 6 — Container Risk Management
- [ ] **Llenar claim form del voucher en aiskillsnavigator.microsoft.com**

> ⚠️ Voucher vence: **18 de agosto 2026** — No olvidar canjear

---

*Nota creada el 2026-06-08 | AI Skills Fest 2026 — Security Pro Playlist completada*
