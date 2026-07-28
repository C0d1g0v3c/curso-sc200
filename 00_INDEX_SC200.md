---
tags: [certificacion, microsoft, sc-200, sentinel, soc, seguridad]
fecha: 2026-06-08
ultima_actualizacion: 2026-06-08
estado: 🟡 En progreso
tipo: Certificación
relacionado: "[[00_MASTER_INDEX]], [[SIEM]], [[Conceptos Clave/SIEM]]"
---

# 🛡️ SC-200 — Microsoft Security Operations Analyst

> **Idea central:** Certificación práctica de SOC que valida habilidades en Microsoft Sentinel, Defender XDR y respuesta a incidentes dentro del ecosistema Azure.

---

## 📋 Info del Examen

| Dato | Detalle |
|------|---------|
| **Código** | SC-200 |
| **Nombre completo** | Microsoft Security Operations Analyst Associate |
| **Costo** | $165 USD (gratis con voucher AI Skills Fest 2026) |
| **Duración** | 120 minutos |
| **Preguntas** | 40–60 (opción múltiple + casos prácticos) |
| **Aprobación** | 700 / 1000 (~70%) |
| **Idioma** | Inglés (sin opción español) |
| **Validez** | 2 años (renovación por examen o learning paths) |
| **Voucher vence** | 18 de agosto 2026 |
| **Examen límite** | 18 de octubre 2026 |

---

## 🎯 Dominios del Examen (Actualización Abril 2026)

```
┌─────────────────────────────────────────────────┐
│  DOMINIO 1: Manage Security Operations Env.     │
│  ████████████████░░░░░░░░  ~35%                 │
│  • Microsoft Sentinel workspace                  │
│  • Datos e ingestión de logs                     │
│  • RBAC y permisos                               │
├─────────────────────────────────────────────────┤
│  DOMINIO 2: Configure Protections & Detections  │
│  ████████████████████░░░░  ~40%                 │
│  • Analytics rules y alertas                     │
│  • Defender for Endpoint / Identity / Cloud      │
│  • Threat intelligence integration               │
├─────────────────────────────────────────────────┤
│  DOMINIO 3: Respond to Incidents & Alerts       │
│  ████████████░░░░░░░░░░░░  ~25%                 │
│  • Incident management en Sentinel               │
│  • Investigation y hunting                       │
│  • Playbooks y automatización SOAR               │
└─────────────────────────────────────────────────┘
```

---

### Objetivos Oficiales del Examen — Desglose por Habilidad

> [!note] Fuente
> Sub-objetivos extraídos del skills outline oficial "Manage a security operations environment (1/2)" del curso SC-200 (actualización 2026). Cada bloque corresponde a competencias evaluadas directamente.

#### 1.1 Configure settings in Microsoft Defender XDR

- Configure Microsoft Defender for Endpoint advanced features
- Configure endpoint rules (attack surface reduction, etc.)
- Manage automated investigation and response ([[CONCEPTOS_CLAVE]] § 3.3.2 — AIR, verdicts, automation level por device group)
- Configure Microsoft Defender Vulnerability Management
- Configure Exposure Management in Microsoft Defender XDR

#### 1.2 Manage assets and environments

- Configure and manage device groups, permissions, and automation levels for devices in Microsoft Defender for Endpoint
- Identify unmanaged devices in Microsoft Defender for Endpoint

#### 1.3 Design and configure a Microsoft Sentinel workspace

- Discover unprotected resources using Defender for Cloud Identity / Defender Vulnerability Management
- Specify Azure RBAC roles for Microsoft Sentinel (Reader, Responder, Contributor, Automation Contributor)
- Design Microsoft Sentinel data storage, including log types and log retention

> [!tip] Para el examen
> El bloque 1.1 (automated investigation) es el más evaluado de este grupo. Conoce los verdicts de AIR (Malicious/Suspicious/No threats found), las remediation actions posibles y cómo configurar el Automation level por device group. Ver [[CONCEPTOS_CLAVE]] § 3.3.2.
![[Pasted image 20260617205354.png]]

---

## 🗓️ Plan de Estudio — 4 Semanas

| Semana       | Tema                             | Horas   | Estado |
| ------------ | -------------------------------- | ------- | ------ |
| **Semana 1** | Microsoft Sentinel — Fundamentos | ~15 hrs | ⬜      |
| **Semana 2** | KQL + Labs en sandbox            | ~15 hrs | ⬜      |
| **Semana 3** | Microsoft Defender XDR completo  | ~15 hrs | ⬜      |
| **Semana 4** | Simulacros + Repaso + Examen     | ~10 hrs | ⬜      |

---

## 📚 Módulos del Path

1. **[[01_Semana1_Sentinel_Fundamentos]]** — Arquitectura, workspace, connectors, analytics rules
2. **[[02_Semana2_KQL_Labs]]** — Kusto Query Language: sintaxis, operadores, funciones
3. **[[03_Semana3_Defender_XDR]]** — Defender for Endpoint, Identity, Cloud, Office 365
4. **[[04_Semana4_Simulacros]]** — Practice tests, áreas débiles, estrategia examen
5. **[[CHEATSHEET_KQL]]** — Referencia rápida de queries KQL más usados
6. **[[Chronicle_vs_Sentinel]]** — Tu ventaja: traducción directa de Chronicle a Sentinel

---

## ⚡ Tu Ventaja vs. Candidato Promedio

```
LO QUE YA SABES               →    LO QUE MAPEA EN SC-200
─────────────────────────────────────────────────────────
Chronicle SIEM                 →    Microsoft Sentinel (mismo concepto)
Wazuh + reglas de detección    →    Analytics Rules en Sentinel
SOAR con playbooks             →    Logic Apps + Playbooks en Sentinel
Incident response (HTB CDSA)   →    Dominio 3 completo
Kibana KQL (ELK Stack)         →    KQL de Azure (sintaxis similar)
GCP IAM + RBAC                 →    Azure RBAC + Sentinel permisos
```

> 💡 Dominio 3 (Respond to Incidents, 25%) ya lo dominas desde el HTB SOC path.
> Enfócate en Dominio 2 (40%) que es el más pesado y más Azure-específico.

---

## 🔗 Recursos Oficiales

| Recurso | Tipo | Costo |
|---------|------|-------|
| [Microsoft Learn — SC-200 Path](https://learn.microsoft.com/training/paths/sc-200-mitigate-threats-sentinel/) | Curso oficial + labs | ✅ Gratis |
| [Exam SC-200 Study Guide (abril 2026)](https://learn.microsoft.com/certifications/exams/sc-200) | Blueprint oficial | ✅ Gratis |
| Udemy — Simulados SC-200 2026 | Practice tests | ~$12 USD |
| GitHub: microsoft/SC-200T00A | Labs oficiales | ✅ Gratis |

---

## ✅ Checklist de Progreso Global

### Semana 1 — Sentinel
- [ ] Crear workspace de Microsoft Sentinel en sandbox
- [ ] Conectar al menos 3 data connectors
- [ ] Crear analytics rule manual
- [ ] Entender Log Analytics workspace
- [ ] Revisar Workbooks predefinidos

### Semana 2 — KQL
- [ ] Completar módulo KQL en Microsoft Learn
- [ ] Escribir 10 queries básicas sin referencia
- [ ] Practicar: where, project, summarize, join
- [ ] Crear una detection rule con KQL custom
- [ ] Completar labs de Log Analytics

### Semana 3 — Defender XDR
- [ ] Configurar Defender for Endpoint (MDE) básico
- [ ] Entender Defender for Identity (MDI) arquitectura
- [ ] Revisar Microsoft Defender for Cloud (MDC) posturas
- [ ] Conectar Defender XDR a Sentinel
- [ ] Revisar Secure Score

### Semana 4 — Examen
- [ ] Practice test 1 — Score inicial sin estudiar
- [ ] Repasar áreas con < 70%
- [ ] Practice test 2 — Meta: 75%+
- [ ] Practice test 3 — Meta: 80%+
- [ ] Agendar examen con voucher
- [ ] 🎯 Presentar examen

---

## 📊 Mis Scores de Práctica

| Intento | Fecha | Score | Área débil |
|---------|-------|-------|------------|
| Práctica 1 | | | |
| Práctica 2 | | | |
| Práctica 3 | | | |
| **REAL** | | | |

---

## 🔑 Conceptos Críticos (No Olvidar)

> Estos son los que más salen en el examen según la comunidad

- **KQL** — Domínalo. Es el 30%+ del examen implícitamente
- **Sentinel Analytics Rules** — Scheduled vs NRT vs Fusion vs ML
- **MITRE ATT&CK en Sentinel** — Cómo mapear técnicas a incidents
- **Playbooks** — Logic Apps + incident trigger
- **MDE onboarding** — Métodos y scripts de deployment
- **Defender for Identity** — Lateral movement detection
- **Secure Score** — Recomendaciones y remediación

---

*Nota creada el 2026-06-08 | Ruta: Certificaciones → SC-200 Microsoft Security Operations Analyst*
