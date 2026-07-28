---
tags: [sc-200, plan, labs]
creado: 2026-07-06
descripcion: Mapa día por día — qué módulo de Microsoft Learn (teoría) y qué lab SC-200T00A (práctica) tocan cada día del plan de 24 días
---

# 🗺️ Mapa diario: Learn + Labs SC-200

> [!info] Cómo usar esta nota
> Cada día del [[GUIA_INTENSIVA_24_DIAS|plan de 24 días]] tiene dos mitades (2h + 2h):
> 1. **📖 Learn** = teoría en Microsoft Learn (el [curso oficial SC-200T00](https://learn.microsoft.com/es-es/training/courses/sc-200t00), actualizado abr-2026; varios módulos traen sandbox gratis).
> 2. **🧪 Lab** = práctica de los [labs oficiales SC-200T00A](https://microsoftlearning.github.io/SC-200T00A-Microsoft-Security-Operations-Analyst/) (actualizados jun-2026; muchos son simulaciones interactivas que no requieren tenant).
>
> Usar siempre las variantes **"Defender"** de los labs (portal unificado), no las "Azure" (portal viejo). El Sentinel Training Lab del Marketplace está descartado (abandonado desde ene-2024).

## Fase 1 — Dominio 1: Manage SecOps environment (Días 1–7)

| Día | Tema | 📖 Learn (teoría) | 🧪 Lab (práctica) |
|---|---|---|---|
| **1** (7-jul) | Arquitectura Sentinel + tiers | [Configuración del entorno de Microsoft Sentinel](https://learn.microsoft.com/es-es/training/paths/sc-200-configure-azure-sentinel-environment/) | [Lab 6 Ex1 — Configure your Sentinel environment](https://microsoftlearning.github.io/SC-200T00A-Microsoft-Security-Operations-Analyst/Instructions/Labs/LAB_AK_06_Lab1_Ex01_Deploy_Sentinel_Defender.html) |
| **2** (8-jul) | Ingestión 1: AMA, DCR, Windows events, WEF | [Conexión de registros a Microsoft Sentinel](https://learn.microsoft.com/es-es/training/paths/sc-200-connect-logs-to-azure-sentinel/) (módulos de Windows/AMA) | [Lab 7 Ex2 — Connect Windows devices](https://microsoftlearning.github.io/SC-200T00A-Microsoft-Security-Operations-Analyst/Instructions/Labs/LAB_AK_07_Lab1_Ex02_Connect_Windows_Defender.html) |
| **3** (9-jul) | Ingestión 2: Syslog/CEF, TI, custom tables | [Conexión de registros a Microsoft Sentinel](https://learn.microsoft.com/es-es/training/paths/sc-200-connect-logs-to-azure-sentinel/) (módulos de Linux/CEF/TI) | [Lab 7 Ex1 — Connect M365/Entra services](https://microsoftlearning.github.io/SC-200T00A-Microsoft-Security-Operations-Analyst/Instructions/Labs/LAB_AK_07_Lab1_Ex01_Connect_Services_Defender.html) + [Lab 7 Ex3 — Connect Linux hosts](https://microsoftlearning.github.io/SC-200T00A-Microsoft-Security-Operations-Analyst/Instructions/Labs/LAB_AK_07_Lab1_Ex03_Connect_Linux_Defender.html) |
| **4** (10-jul) | Detecciones: analytics rules + anomalías | [Creación de detecciones y realización de investigaciones](https://learn.microsoft.com/es-es/training/paths/sc-200-create-detections-perform-investigations-azure-sentinel/) (módulos de analytics rules) | [Lab 8 Ex2 — Scheduled Query from template](https://microsoftlearning.github.io/SC-200T00A-Microsoft-Security-Operations-Analyst/Instructions/Labs/LAB_AK_08_Lab1_Ex02_Scheduled_Query_Defender.html) + [Lab 8 Ex6 — Create Detections](https://microsoftlearning.github.io/SC-200T00A-Microsoft-Security-Operations-Analyst/Instructions/Labs/LAB_AK_08_Lab1_Ex06_Detections_Defender.html) |
| **5** (11-jul) | Config MDE: ASR, advanced features | [Mitigación de amenazas con Defender for Endpoint](https://learn.microsoft.com/es-es/training/paths/sc-200-mitigate-threats-using-microsoft-defender-for-endpoint/) | [Lab 4 Ex1 — Deploy Defender for Endpoint](https://microsoftlearning.github.io/SC-200T00A-Microsoft-Security-Operations-Analyst/Instructions/Labs/LAB_AK_04_Lab1_Ex01_Deploy_Defender_Endpoint.html) |
| **6** (12-jul) | Automatización: AIR, attack disruption, playbooks | [Creación de detecciones e investigaciones](https://learn.microsoft.com/es-es/training/paths/sc-200-create-detections-perform-investigations-azure-sentinel/) (módulos SOAR) | [Lab 8 Ex1 — Create a Playbook](https://microsoftlearning.github.io/SC-200T00A-Microsoft-Security-Operations-Analyst/Instructions/Labs/LAB_AK_08_Lab1_Ex01_Playbook_Defender.html) |
| **7** (13-jul) | Workbooks + SOC optimization + repaso | [Configuración del entorno de Sentinel](https://learn.microsoft.com/es-es/training/paths/sc-200-configure-azure-sentinel-environment/) (repaso + SOC optimization) | [Lab 8 Ex9 — Create workbooks](https://microsoftlearning.github.io/SC-200T00A-Microsoft-Security-Operations-Analyst/Instructions/Labs/LAB_AK_08_Lab1_Ex09_Workbooks_Defender.html) |

## Fase 2 — Dominio 2: Respond to incidents (Días 8–13)

| Día | Tema | 📖 Learn (teoría) | 🧪 Lab (práctica) |
|---|---|---|---|
| **8** (14-jul) | Incidentes unificados + case management | [Mitigación de amenazas con Defender XDR](https://learn.microsoft.com/es-es/training/paths/sc-200-mitigate-threats-using-microsoft-365-defender/) (módulos de incidents) | [Lab 8 Ex7 — Investigate Incidents](https://microsoftlearning.github.io/SC-200T00A-Microsoft-Security-Operations-Analyst/Instructions/Labs/LAB_AK_08_Lab1_Ex07_Investigate_Defender.html) |
| **9** (15-jul) | Respuesta MDE: timeline, live response | [Mitigación con Defender for Endpoint](https://learn.microsoft.com/es-es/training/paths/sc-200-mitigate-threats-using-microsoft-defender-for-endpoint/) (módulos de investigación) | [Lab 4 Ex2 — Mitigate Attacks with MDE](https://microsoftlearning.github.io/SC-200T00A-Microsoft-Security-Operations-Analyst/Instructions/Labs/LAB_AK_04_Lab1_Ex02_Mitigate_Attacks.html) |
| **10** (16-jul) | MDO + MDCA | [Mitigación de amenazas con Defender XDR](https://learn.microsoft.com/es-es/training/paths/sc-200-mitigate-threats-using-microsoft-365-defender/) (módulos MDO y MDCA) | [Lab 1 Ex1 — Explore Defender XDR](https://microsoftlearning.github.io/SC-200T00A-Microsoft-Security-Operations-Analyst/Instructions/Labs/LAB_AK_01_Lab1_Ex01_Explore_Defender_XDR.html) |
| **11** (17-jul) | Identidades: Entra ID Protection + MDI | [Mitigación de amenazas con Defender XDR](https://learn.microsoft.com/es-es/training/paths/sc-200-mitigate-threats-using-microsoft-365-defender/) (módulos de identidad) | Sin lab de GitHub — práctica KQL propia (`AADRiskyUsers`, `IdentityLogonEvents`) según la guía |
| **12** (18-jul) | Defender for Cloud | [Mitigación de amenazas con Defender for Cloud](https://learn.microsoft.com/es-es/training/paths/sc-200-mitigate-threats-using-azure-defender/) | Sin lab de GitHub — generar **sample alerts** en MDC y triarlas (gratis) |
| **13** (19-jul) | Purview Audit/eDiscovery + Security Copilot | [Mitigación con Microsoft Purview](https://learn.microsoft.com/es-es/training/paths/sc-200-mitigate-threats-using-microsoft-purview/) + [Security Copilot](https://learn.microsoft.com/es-es/training/paths/sc-200-mitigate-threats-using-microsoft-copilot-for-security/) | [Lab 3 Ex1 — Explore Purview Audit](https://microsoftlearning.github.io/SC-200T00A-Microsoft-Security-Operations-Analyst/Instructions/Labs/LAB_AK_03_Lab1_Ex01_Explore_Purview_Audit.html) + [Lab 2 Ex1 — Security Copilot](https://microsoftlearning.github.io/SC-200T00A-Microsoft-Security-Operations-Analyst/Instructions/Labs/LAB_AK_02_Lab1_Ex01_Explore_Copilot_Security.html) |

## Fase 3 — Dominio 3: Threat hunting (Días 14–18)

| Día | Tema | 📖 Learn (teoría) | 🧪 Lab (práctica) |
|---|---|---|---|
| **14** (20-jul) | KQL total | [KQL para Microsoft Sentinel](https://learn.microsoft.com/es-es/training/paths/sc-200-utilize-kql-for-azure-sentinel/) | [Lab 5 Ex1 — KQL queries](https://microsoftlearning.github.io/SC-200T00A-Microsoft-Security-Operations-Analyst/Instructions/Labs/LAB_AK_05_Lab1_Ex01_KQL_Defender.html) + [KQL playground](https://aka.ms/lademo) |
| **15** (21-jul) | Advanced Hunting XDR + threat analytics | [Mitigación con Defender XDR](https://learn.microsoft.com/es-es/training/paths/sc-200-mitigate-threats-using-microsoft-365-defender/) (módulo Advanced Hunting) | [Lab 8 Ex4 — Prepare attacks](https://microsoftlearning.github.io/SC-200T00A-Microsoft-Security-Operations-Analyst/Instructions/Labs/LAB_AK_08_Lab1_Ex04_Attacks_Defender.html) + [Lab 8 Ex5 — Conduct attacks](https://microsoftlearning.github.io/SC-200T00A-Microsoft-Security-Operations-Analyst/Instructions/Labs/LAB_AK_08_Lab1_Ex05_Perform_Attacks_Defender.html) (generan datos para huntear) |
| **16** (22-jul) | Hunting en Sentinel: bookmarks, livestream | [Búsqueda de amenazas en Microsoft Sentinel](https://learn.microsoft.com/es-es/training/paths/sc-200-perform-threat-hunting-azure-sentinel/) | [Lab 9 Ex1 — Threat Hunting in Sentinel](https://microsoftlearning.github.io/SC-200T00A-Microsoft-Security-Operations-Analyst/Instructions/Labs/LAB_AK_09_Lab1_Ex01_Hunting_Defender.html) |
| **17** (23-jul) | Data lake, KQL jobs, Summary rules, Notebooks | [Búsqueda de amenazas en Sentinel](https://learn.microsoft.com/es-es/training/paths/sc-200-perform-threat-hunting-azure-sentinel/) (módulo notebooks) + docs de [data lake](https://learn.microsoft.com/es-es/azure/sentinel/datalake/sentinel-lake-overview) | [Lab 9 Ex2 — Hunting with Notebooks](https://microsoftlearning.github.io/SC-200T00A-Microsoft-Security-Operations-Analyst/Instructions/Labs/LAB_AK_09_Lab1_Ex02_Notebooks_Defender.html) |
| **18** (24-jul) | KQL avanzado gamificado | Repaso de [KQL para Sentinel](https://learn.microsoft.com/es-es/training/paths/sc-200-utilize-kql-for-azure-sentinel/) | [Kusto Detective Agency](https://detective.kusto.io) o [KC7](https://kc7cyber.com) |

## Fase 4 — Integración (Día 19)

| Día | Tema | 📖 Learn | 🧪 Lab |
|---|---|---|---|
| **19** (25-jul) | Lab integral end-to-end | — (sin teoría nueva) | Ciclo completo: [Lab 8 Ex4](https://microsoftlearning.github.io/SC-200T00A-Microsoft-Security-Operations-Analyst/Instructions/Labs/LAB_AK_08_Lab1_Ex04_Attacks_Defender.html) → [Ex5](https://microsoftlearning.github.io/SC-200T00A-Microsoft-Security-Operations-Analyst/Instructions/Labs/LAB_AK_08_Lab1_Ex05_Perform_Attacks_Defender.html) → [Ex6](https://microsoftlearning.github.io/SC-200T00A-Microsoft-Security-Operations-Analyst/Instructions/Labs/LAB_AK_08_Lab1_Ex06_Detections_Defender.html) → [Ex7](https://microsoftlearning.github.io/SC-200T00A-Microsoft-Security-Operations-Analyst/Instructions/Labs/LAB_AK_08_Lab1_Ex07_Investigate_Defender.html); opcionales: [Ex8 ASIM](https://microsoftlearning.github.io/SC-200T00A-Microsoft-Security-Operations-Analyst/Instructions/Labs/LAB_AK_08_Lab1_Ex08_ASIM_Defender.html) y [Ex10 Repositories](https://microsoftlearning.github.io/SC-200T00A-Microsoft-Security-Operations-Analyst/Instructions/Labs/LAB_AK_08_Lab1_Ex10_Content_Management_Defender.html) |

Los días 20–24 son simulacros y repaso — sin labs nuevos (ver [[GUIA_INTENSIVA_24_DIAS]] Fase 5).

---

*Relacionadas: [[GUIA_INTENSIVA_24_DIAS]] · [[TRACKER_TUTOR]] · [[00_INDEX_SC200]]*
