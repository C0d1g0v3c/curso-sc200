---
tags: [sc-200, ai-skills-fest, fabrikam, zero-trust, devsecops, caso-estudio, multicloud]
fecha: 2026-06-08
ultima_actualizacion: 2026-06-08
estado: ✅ Completado
tipo: Caso de Estudio
relacionado: "[[AI_Skills_Fest_Security_Pro]], [[00_INDEX_SC200]], [[03_Semana3_Defender_XDR]]"
---

# 🏢 Caso de Estudio — Fabrikam Inc. Multicloud Security

> **Fuente:** AI Skills Fest 2026 — Security Pro Unit: Application & Data Security Posture
> **Relevancia SC-200:** Alta — modelo real de Zero Trust + DevSecOps que el examen evalúa

---

## 🔍 Situation Assessment — Los 5 Problemas

```
FABRIKAM INC. (dual-cloud: Azure + AWS)
├─ 1. Kubernetes secrets estáticos + tokens de larga duración
│       → Rotación manual, visibilidad limitada
│
├─ 2. DB con endpoints públicos + connection strings
│       → Sin aislamiento de red, controles de acceso débiles
│
├─ 3. CI/CD sin governance centralizada
│       → Misconfigurations llegan a producción sin detección
│
├─ 4. Dependencias open-source sin escaneo integrado
│       → Solo vigilancia manual de desarrolladores
│
└─ 5. Monitoreo fragmentado entre herramientas cloud-native
        → Triage inconsistente, detección de amenazas limitada
```

**Causa raíz**: Prácticas de seguridad descentralizadas + gaps de visibilidad típicos de arquitecturas cloud-native.

---

## ⚠️ Threat Analysis — Las 5 Amenazas Resultantes

| Problema | Amenaza Resultante | Técnica MITRE |
|----------|-------------------|---------------|
| Secrets estáticos + tokens manuales | **Credential exposure** | T1552 - Unsecured Credentials |
| IaC misconfiguration + admission policies | **Persistent vulnerabilities** | T1190 - Exploit Public-Facing App |
| CI/CD sin escaneo + deps sin scan | **Supply chain attack** | T1195 - Supply Chain Compromise |
| DB públicas + cifrado insuficiente | **Data exposure** | T1530 - Data from Cloud Storage |
| Monitoreo fragmentado + diagnósticos reactivos | **Delayed incident detection** | T1562 - Impair Defenses |

> 💡 **Key insight**: Las prácticas DevOps mal aseguradas + complejidad multicloud = superficie de ataque amplificada.

---

## 🏗️ Architectural Solution — Zero Trust DevSecOps Framework

### El Framework Completo

```
PROBLEMA                    SOLUCIÓN MICROSOFT
──────────────────────────────────────────────────────────────
Kubernetes EKS sin gov.  →  Azure Arc extiende Azure Policy a EKS
CI/CD sin seguridad      →  GitHub Advanced Security + Defender for Cloud DevOps
Secrets estáticos        →  Workload Identities (tokens efímeros por pod)
DB expuestas             →  Azure Key Vault + Always Encrypted + Private Link
Monitoreo fragmentado    →  Microsoft Sentinel (correlación unificada)
```

### Arquitectura Detallada

```
                    ZERO TRUST BOUNDARY
┌─────────────────────────────────────────────────────────┐
│                                                         │
│  DEV → [GitHub Advanced Security] → CI/CD Pipeline     │
│              ↓ scan IaC + deps                          │
│  [Defender for Cloud DevOps] → detect misconfigs       │
│              ↓                                          │
│  DEPLOY → AKS (Azure) + EKS (AWS via Azure Arc)        │
│              ↓                                          │
│  [Workload Identity] → no static secrets               │
│              ↓                                          │
│  DATA → Azure SQL / Cosmos DB / Key Vault              │
│         [Private Link] → sin endpoints públicos        │
│         [Always Encrypted] → datos cifrados en cliente │
│              ↓                                          │
│  MONITOR → Microsoft Sentinel                          │
│  ← Azure Monitor + Defender tools + Entra ID + GitHub  │
└─────────────────────────────────────────────────────────┘
```

---

## 🎯 3 Pilares de la Arquitectura

### Pilar 1: Automation + Continuous Validation

```
Sin automatización → error humano → breach

Con automatización:
├─ ACR Tasks: scan de imagen en cada commit
├─ Defender for Cloud DevOps: IaC scan automático en PR
├─ Analytics Rules en Sentinel: detección continua 24/7
└─ Playbooks: respuesta automática sin intervención manual
```

### Pilar 2: Policy Consistency Across Clouds

```
Problema: Azure tiene políticas, AWS tiene otras → gaps

Solución con Azure Arc:
├─ Un solo plano de control para AKS + EKS
├─ Azure Policy aplicada a AMBOS clouds
├─ Admission control uniforme (bloquea deployments inseguros)
└─ Compliance reportado en un solo dashboard (MDC)
```

### Pilar 3: Integrated Telemetry + Threat Detection

```
Problema: 5 herramientas distintas → nadie ve el cuadro completo

Solución con Sentinel:
Pipeline events (GitHub) ─┐
Runtime events (MDE)      ─┤→ Log Analytics → Sentinel
Network events (Azure)    ─┤       KQL           ↓
Identity events (Entra)   ─┘    Analytics     Incidents
                                  Rules           ↓
                                              Playbooks
```

---

## 🔒 Workload Identity — El Cambio Más Importante

```
ANTES (Fabrikam problema):
Pod en EKS → usa secret estático "DB_PASSWORD=xyz123"
├─ Guardado en código / env variable
├─ Rotación manual cada 90 días (si se acuerdan)
└─ Si se expone el secret → acceso permanente hasta que roten

DESPUÉS (solución):
Pod en EKS → solicita token efímero vía IRSA / Arc Federation
├─ Token válido por 1 hora (máximo)
├─ Atado a la identidad del pod específico
├─ Si se expone → ya expiró antes de que lo usen
└─ Revocación inmediata si se compromete el pod
```

---

## 📊 Mapa de Soluciones → Dominios SC-200

| Solución Fabrikam | Producto | Dominio SC-200 | Peso |
|-------------------|---------|---------------|------|
| Sentinel correlación unificada | Microsoft Sentinel | Dominio 1 + 3 | 60% |
| Defender for Cloud DevOps | MDC | Dominio 2 | 40% |
| Workload Identities | Entra ID / MDI | Dominio 2 | 40% |
| Always Encrypted + Key Vault | MDC Recomendaciones | Dominio 2 | 40% |
| Private Link / endpoints privados | MDC Postura | Dominio 2 | 40% |
| Playbooks de respuesta | Sentinel SOAR | Dominio 3 | 25% |
| Azure Arc multicloud | MDC multi-cloud | Dominio 2 | 40% |

---

## 💡 Lecciones Clave para el Examen

> Estas son las conclusiones que el examen puede preguntar de forma teórica

**1. Zero Trust = "nunca confiar, siempre verificar"**
```
Fabrikam confiaba en:
- Secrets estáticos (mal → workload identities)
- Red pública (mal → private endpoints)
- Monitoreo manual (mal → automatización Sentinel)
```

**2. Shift-Left Security = detectar antes, no después**
```
La detección de misconfigurations en el pipeline (CI/CD)
es más barata y segura que detectarlas en producción.
Defender for Cloud DevOps = herramienta de shift-left
```

**3. Multicloud governance = Azure Arc**
```
Si el examen pregunta cómo aplicar políticas Azure a recursos
fuera de Azure (AWS, on-prem) → siempre es Azure Arc
```

**4. Credential sprawl = mayor vector de ataque**
```
Secrets en código > rotación manual > exposición
Solución siempre = Managed Identities + Key Vault
```

---

## 🔗 Notas Relacionadas

- [[AI_Skills_Fest_Security_Pro]] — Slides del playlist completo
- [[01_Semana1_Sentinel_Fundamentos]] — Sentinel en profundidad
- [[03_Semana3_Defender_XDR]] — Defender for Cloud (MDC)
- [[CHEATSHEET_KQL]] — Queries para detectar los problemas de Fabrikam
- [[Chronicle_vs_Sentinel]] — Contexto de tu experiencia previa

---

*Nota creada el 2026-06-08 | AI Skills Fest — Caso de Estudio Fabrikam Inc.*
