---
tags: [sc-200, coursera, exposure-management, defender-for-cloud, unified-secops, sintesis-curso]
fecha: 2026-06-22
ultima_actualizacion: 2026-06-22
estado: 🟢 Síntesis inicial (pendiente ajuste con transcripciones)
tipo: Síntesis de módulo
relacionado: "[[00_INDEX_Coursera_SC200]], [[Modulo_3_Sentinel]], [[Modulo_1_Defender_XDR]], [[CONCEPTOS_CLAVE]]"
---

# 🧩 Módulo 4 — Unified Security Operations & Exposure Management

> **Idea central:** El ecosistema de seguridad de Microsoft converge en un único plano de control (`security.microsoft.com`) que une detección, respuesta, postura cloud y gestión de superficie de ataque. El módulo enseña a operar ese ecosistema: cómo medir y reducir la exposición antes de que el atacante la explote, cómo proteger workloads cloud e identidades, y cómo optimizar datos e investigaciones en Sentinel/XDR.

---

> [!note] Por qué importa para el SC-200
> El examen evalúa tres dominios directamente relacionados con este módulo:
> - **Mitigate threats using Microsoft Defender for Cloud** (~15-20 %)
> - **Manage security posture by using Microsoft Security Exposure Management**
> - **Configure Microsoft Sentinel data ingestion, analytics y optimización**
> Dominar la diferencia entre CSPM vs CWPP, Secure Score vs Exposure Score, y los tiers de ingestion en Sentinel es crítico para responder correctamente un ~25 % del examen.

---

## 1. Unified Security Operations Platform

### 1.1 Portal unificado `security.microsoft.com`

El portal unifica en una sola interfaz:

| Capacidad | Antes (portal separado) | Ahora (unificado) |
|---|---|---|
| Incidentes XDR | Defender XDR | Una sola incident queue |
| Incidentes SIEM | Sentinel (portal Azure) | Misma queue + correlación |
| Advanced Hunting | Defender Hunting / Sentinel Log Analytics | Unified KQL workspace |
| Exposure Management | Preview separado | Integrado en el portal |
| Secure Score | Múltiples consolas | Consolidado |

**Qué significa "unified":**
- Una sola incident queue que agrega alertas de Defender XDR, Sentinel, MDC y MDO.
- Advanced Hunting unificado: una sola query KQL puede cruzar tablas de XDR (`DeviceEvents`, `EmailEvents`) y de Sentinel (`SecurityAlert`, `SigninLogs`).
- El workspace de Sentinel se conecta al tenant y los incidentes fluyen al portal sin necesidad de cambiar de consola.

```
┌──────────────────────────────────────────────────────┐
│          security.microsoft.com (portal unificado)   │
│                                                      │
│  ┌─────────────┐  ┌──────────────┐  ┌─────────────┐ │
│  │ Defender XDR│  │   Sentinel   │  │  Exposure   │ │
│  │ (endpoints, │  │ (SIEM/SOAR,  │  │ Management  │ │
│  │  email,     │  │  analytics,  │  │ (attack     │ │
│  │  identity,  │  │  workbooks)  │  │  surface)   │ │
│  │  cloud apps)│  └──────┬───────┘  └──────┬──────┘ │
│  └──────┬──────┘         │                 │        │
│         └────────────────┴─────────────────┘        │
│                   Unified Incident Queue             │
│                   Unified Advanced Hunting           │
└──────────────────────────────────────────────────────┘
```

> [!tip] Para el examen
> Si una pregunta menciona "una sola cola de incidentes que combina XDR y Sentinel" → respuesta: Unified Security Operations Platform en `security.microsoft.com`.

---

## 2. Microsoft Security Exposure Management (MSEM)

### 2.1 ¿Qué es?

MSEM es la herramienta de gestión de superficie de ataque y postura de seguridad de Microsoft que trabaja **por encima** de los productos individuales. Agrega datos de MDC, Defender XDR, Entra ID, Intune y otros para construir un mapa de ataque continuo.

### 2.2 Componentes principales

| Componente | Descripción |
|---|---|
| **Attack Surface Map** | Grafo visual de activos, relaciones y rutas de ataque posibles |
| **Attack Paths** | Cadenas de vulnerabilidades/configuraciones que un atacante puede encadenar de un activo a otro |
| **Critical Asset Management** | Identificación y etiquetado de activos críticos (Domain Controllers, VIPs, etc.) para priorización |
| **Security Initiatives** | Agrupaciones de recomendaciones por objetivo (ej. "Protect Privileged Identities") |
| **Exposure Score** | Puntuación 0-100 que refleja el nivel de exposición global (más bajo = mejor) |

### 2.3 Attack Paths — Flujo

```
  [Device sin parche] ──conecta──► [Servidor con credencial expuesta]
         │                                      │
         │  MSEM detecta la cadena               │
         ▼                                      ▼
  [Ruta de ataque visible] ──► [Activo crítico: Domain Controller]
         │
         ▼
  Remediación sugerida: parchear el device o aislar credencial
```

### 2.4 Secure Score vs Exposure Score

> [!warning] Diferencia crítica para el examen
> Esta distinción aparece frecuentemente en preguntas de opción múltiple.

| | **Microsoft Secure Score** | **Exposure Score (MSEM)** |
|---|---|---|
| **Enfoque** | Postura de seguridad por recomendaciones de hardening | Exposición real a ataques (rutas, activos críticos) |
| **Métrica** | Puntos por acciones completadas (más alto = mejor) | Puntuación de riesgo (más bajo = mejor) |
| **Granularidad** | Recomendaciones individuales (MFA habilitado, etc.) | Rutas de ataque, impacto en activos críticos |
| **Producto fuente** | Defender XDR, MDC, Entra ID | Todos los productos + correlación entre ellos |
| **Pregunta tipo examen** | "¿Qué mide el improvement de configurar MFA?" → Secure Score | "¿Qué herramienta visualiza rutas de ataque end-to-end?" → MSEM |

---

## 3. Microsoft Defender for Cloud (MDC)

### 3.1 Arquitectura dual: CSPM + CWPP

```
              Microsoft Defender for Cloud
                         │
          ┌──────────────┴──────────────┐
          │                             │
   ┌──────▼──────┐               ┌──────▼──────┐
   │    CSPM     │               │    CWPP     │
   │  (postura)  │               │ (workloads) │
   └─────────────┘               └─────────────┘
   - Secure Score                - Alertas runtime
   - Recomendaciones             - Defender plans
   - Regulatory compliance       - Just-in-time VM access
   - Multicloud visibility       - Threat detection activa
   - Agentless scanning          - File integrity monitoring
```

> [!tip] Para el examen
> **CSPM** = saber QUÉ está mal en tu postura (reactive/preventive).
> **CWPP** = detectar y bloquear ataques EN EJECUCIÓN sobre workloads (active/runtime).
> Si la pregunta habla de "recomendaciones", "Secure Score" o "compliance" → **CSPM**.
> Si habla de "detección de amenazas activas", "alertas en servidores" → **CWPP**.

### 3.2 Secure Score en MDC

- Puntuación de 0-100 basada en recomendaciones implementadas.
- Cada recomendación tiene un **max score** y un **current score**.
- Las recomendaciones se agrupan en **security controls**.
- Cuanto más crítico el control (ej. "Remediate vulnerabilities"), mayor el peso.

### 3.3 Defender Plans (CWPP)

| Plan | Protege | Capacidades clave |
|---|---|---|
| **Defender for Servers** (P1/P2) | VMs Azure, AWS, GCP, on-prem | Vulnerability assessment, JIT, FIM, MDE integration |
| **Defender for Storage** | Azure Blob, Files, ADLS | Malware scanning, sensitive data discovery |
| **Defender for SQL** | Azure SQL, SQL Server en VMs | Advanced threat protection, vulnerability assessment |
| **Defender for Containers** | AKS, EKS, GKE, Arc | Runtime protection, image scanning, network visibility |
| **Defender for App Service** | Azure App Service | Detección de ataques web, dangling DNS |
| **Defender for Key Vault** | Azure Key Vault | Acceso anómalo, exfiltración de secretos |
| **Defender for DNS** | Resoluciones DNS Azure | Detección de tunneling, C2 |
| **Defender for Resource Manager** | Operaciones ARM | Lateral movement via ARM, privilege escalation |

> [!example] Ejemplo de pregunta
> "Un atacante exfiltró secretos de Key Vault mediante acceso anómalo desde IP desconocida. ¿Qué Defender plan generó la alerta?"
> → **Defender for Key Vault**

### 3.4 Multicloud (AWS / GCP)

- Se conectan mediante **connectors** nativos en MDC.
- AWS: usa AWS Security Hub o conector nativo.
- GCP: conector nativo con permisos IAM mínimos.
- Las recomendaciones multicloud aparecen en el mismo Secure Score y compliance dashboard.
- Defender for Servers P2 puede proteger instancias EC2 y GCE via Azure Arc.

### 3.5 Regulatory Compliance

- MDC mapea recomendaciones contra estándares: **PCI DSS, ISO 27001, NIST SP 800-53, CIS Benchmarks, SWIFT CSP**.
- Se puede añadir estándares personalizados.
- El compliance dashboard muestra el porcentaje de controles satisfechos por estándar.

---

## 4. Microsoft Defender for Cloud Apps (MDCA) — CASB

### 4.1 Funciones principales como CASB

```
  CASB = Cloud Access Security Broker
  
  4 pilares de MDCA:
  ┌──────────────┬──────────────┬──────────────┬──────────────┐
  │  Visibility  │  Compliance  │  Data Sec.   │  Threat Prot │
  │              │              │              │              │
  │ Cloud Disc.  │ App risk     │ DLP policies │ UEBA         │
  │ Shadow IT    │ assessment   │ Session ctrl │ Anomaly det. │
  │ OAuth apps   │ Certific.    │              │ OAuth abuse  │
  └──────────────┴──────────────┴──────────────┴──────────────┘
```

### 4.2 Cloud Discovery (Shadow IT)

- Analiza logs de firewall/proxy para identificar apps cloud usadas sin autorización.
- Asigna **risk score** a cada app (0-10, 10 = más segura).
- Se puede "sancionar" o "bloquear" apps directamente desde la consola.

### 4.3 Conditional Access App Control (Session Policies)

- Integra con Azure AD Conditional Access para interceptar sesiones en tiempo real.
- Permite: bloquear descarga, forzar etiquetado, monitorear sesión, bloquear copia.
- Requiere que la app esté configurada como proxy en MDCA.

> [!example] Caso de uso
> Un usuario accede a SharePoint desde un dispositivo no administrado. La session policy bloquea la descarga de archivos pero permite la lectura.

### 4.4 OAuth App Governance

- Detecta apps OAuth que solicitan permisos excesivos o con comportamiento anómalo.
- Permite revocar permisos de apps OAuth directamente.

### 4.5 Anomaly Detection

- Detección basada en UEBA: impossible travel, actividad desde IP anónima, ransomware activity, mass download/delete.
- Las alertas se integran en la queue de incidentes de Defender XDR.

---

## 5. Microsoft Defender for Office 365 (MDO)

### 5.1 P1 vs P2

| Capacidad | MDO P1 | MDO P2 |
|---|---|---|
| Safe Attachments | ✅ | ✅ |
| Safe Links | ✅ | ✅ |
| Anti-phishing (basic) | ✅ | ✅ |
| Anti-phishing (advanced/impersonation) | ✅ | ✅ |
| Spoof intelligence | ✅ | ✅ |
| Threat Explorer (real-time) | ❌ | ✅ |
| Automated Investigation & Response (AIR) | ❌ | ✅ |
| Attack Simulation Training | ❌ | ✅ |
| Threat Trackers | ❌ | ✅ |
| Campaign Views | ❌ | ✅ |

### 5.2 Capacidades clave

**Safe Attachments:** Detonación en sandbox de adjuntos de email antes de entrega. Modos: Off / Monitor / Block / Replace / Dynamic Delivery.

**Safe Links:** Reescritura de URLs + verificación en tiempo de clic. Protege email y Office apps.

**Threat Explorer:** Vista en tiempo real de emails maliciosos detectados. Permite hunting manual y acciones (mover, eliminar) sobre mensajes individuales.

**Attack Simulation Training:** Campañas de phishing simulado para medir y entrenar usuarios. Resultados integrados en postura de seguridad.

> [!tip] Para el examen
> Si la pregunta menciona "investigar emails maliciosos en tiempo real" → **Threat Explorer** (requiere MDO P2).
> Si menciona "entrenamiento anti-phishing para usuarios" → **Attack Simulation Training** (MDO P2).

---

## 6. Microsoft Entra ID Protection

### 6.1 Tipos de riesgo

| Tipo | Descripción | Ejemplos de detección |
|---|---|---|
| **Sign-in risk** | Probabilidad de que el sign-in no sea legítimo | Impossible travel, anonymous IP, malware-linked IP, unfamiliar sign-in properties |
| **User risk** | Probabilidad de que la cuenta esté comprometida | Leaked credentials, user reported phishing, anomalous user activity |

### 6.2 Niveles de riesgo

```
  Low → Medium → High
  
  Cada nivel activa diferentes políticas de Conditional Access.
```

### 6.3 Risk-based Conditional Access

Dos políticas recomendadas por Microsoft:

1. **Sign-in risk policy**: Si sign-in risk ≥ Medium → require MFA.
2. **User risk policy**: Si user risk ≥ High → require password change + MFA.

> [!warning]
> Entra ID Protection **detecta** el riesgo pero la **acción** (bloquear, MFA, etc.) se define en **Conditional Access**. Son herramientas separadas que trabajan juntas.

### 6.4 Uso en investigaciones SC-200

- Las alertas de Entra ID Protection fluyen a Sentinel y a la queue de Defender XDR.
- En Sentinel: tablas `AADUserRiskEvents`, `AADRiskyUsers`, `SigninLogs`.
- Un analista puede "dismiss" o "confirm compromise" desde el portal para actualizar el estado de riesgo.

```kql
// Usuarios con riesgo alto en los últimos 7 días
AADRiskyUsers
| where RiskLevel == "high"
| where RiskLastUpdatedDateTime > ago(7d)
| project UserDisplayName, UserPrincipalName, RiskLevel, RiskDetail, RiskLastUpdatedDateTime
| sort by RiskLastUpdatedDateTime desc
```

---

## 7. Alert Suppression / Tuning

### 7.1 Nueva experiencia de suppression en Defender XDR

La experiencia actualizada permite crear reglas de supresión con mayor granularidad:

| Parámetro | Opciones |
|---|---|
| **Scope** | Dispositivo específico, grupo de dispositivos, toda la organización |
| **Trigger** | Alerta específica + condición (ej. proceso = `legitimo.exe`) |
| **Duración** | Permanente o con fecha de expiración |
| **Estado de alerta al suprimir** | Resolved (cerrado) o Hidden (oculto pero rastreable) |

### 7.2 Cuándo usar suppression vs tuning

> [!example] Cuándo suprimir
> Herramienta de administración legítima que genera alertas de "suspicious PowerShell" en cada ejecución programada. Se suprime para ese proceso específico en esos dispositivos.

> [!warning] Riesgo de suppression excesiva
> Suprimir muy amplamente puede ocultar actividad maliciosa real que usa el mismo proceso/archivo. Siempre definir el scope más restrictivo posible.

**Best practices:**
- Revisar periódicamente las reglas de supresión activas.
- Preferir supresión con fecha de expiración sobre supresión permanente.
- Documentar el rationale de cada regla.

---

## 8. Data Ingestion Optimization en Microsoft Sentinel

### 8.1 Log Tiers (Niveles de ingestion)

Esta es una de las áreas más examinadas en optimización de costes de Sentinel.

| Tier | Nombre | Coste relativo | Retención | Búsqueda | Uso recomendado |
|---|---|---|---|---|---|
| **Analytics Logs** | Tier estándar | Alto | 90 días hot + configurable | Inmediata (KQL real-time) | Logs de alta prioridad: alertas, sign-ins, security events |
| **Basic Logs** | Tier económico | ~80 % más barato | 8 días | On-demand (job-based, más lenta) | Logs verbosos de bajo valor: diagnósticos, verbose application logs |
| **Auxiliary Logs** | Tier archivo | Mínimo | 30 días hot, hasta 12 años | On-demand | Compliance, retención a largo plazo, logs raramente consultados |

```
  Decisión de tier por log:
  
  ¿El log genera alertas frecuentemente?
       │
       ├── Sí → Analytics Logs
       │
       └── No → ¿Necesitas búsqueda inmediata (<1 min)?
                    │
                    ├── Sí → Analytics Logs
                    │
                    └── No → ¿Solo para compliance/retención?
                                 │
                                 ├── Sí → Auxiliary Logs
                                 └── No → Basic Logs
```

### 8.2 Data Collection Rules (DCR)

- Definen qué datos se recolectan, desde dónde y hacia qué destino (Log Analytics workspace).
- Permiten **transformations**: filtrar, enriquecer o modificar datos EN EL PIPELINE antes de que lleguen al workspace.
- Reducen costes al filtrar eventos innecesarios antes de la ingestion.

```kql
// Ejemplo: transformación en DCR para filtrar solo eventos de seguridad críticos
// (esto se define en el DCR como KQL transformation, no se ejecuta en el workspace)
source
| where EventID in (4624, 4625, 4648, 4672, 4688, 4698, 4720, 4732)
```

### 8.3 Optimización de costes — Best Practices

1. **Auditar fuentes de datos**: identificar cuáles tablas tienen mayor volumen y menor valor de alertas.
2. **Usar DCR transformations** para filtrar eventos de bajo valor en el pipeline.
3. **Asignar tiers correctos**: mover logs verbosos a Basic o Auxiliary.
4. **Configurar retention policies**: reducir retención hot para logs menos críticos.
5. **Revisar connectors**: algunos conectores (ej. CEF genérico) ingerieren datos duplicados.

### 8.4 Behavior Analytics (UEBA en Sentinel)

- Sentinel tiene UEBA integrado: analiza comportamiento de usuarios y entidades (hosts).
- Genera **anomaly scores** por entidad.
- Tablas relevantes: `BehaviorAnalytics`, `UserPeerAnalytics`.
- Los insights de UEBA enriquecen los incidentes automáticamente.

```kql
// Usuarios con anomalías de comportamiento recientes
BehaviorAnalytics
| where TimeGenerated > ago(24h)
| where ActivityInsights has "FirstTimeUserConnectedFromCountry"
| project UserName, SourceIPAddress, ActivityType, ActivityInsights
| sort by TimeGenerated desc
```

> [!tip] Para el examen
> DCR transformation = modificar/filtrar datos ANTES de que entren al workspace = reducción de costes.
> Basic Logs = búsqueda más lenta pero costo menor = ideal para logs verbosos de bajo valor.

---

## 9. Azure Lighthouse — Gestión Multi-Tenant

### 9.1 ¿Qué es Azure Lighthouse?

Permite a proveedores de servicios (MSSPs) o equipos centrales gestionar **múltiples tenants de Azure** desde un único tenant de gestión, sin necesidad de una cuenta en cada tenant cliente.

### 9.2 Arquitectura

```
  MSSP Tenant (gestión)
         │
         │  Azure Lighthouse delegation
         │
  ┌──────▼──────┬──────────────┬──────────────┐
  │  Cliente A  │  Cliente B   │  Cliente C   │
  │  Tenant     │  Tenant      │  Tenant      │
  │  (Azure sub)│  (Azure sub) │  (Azure sub) │
  └─────────────┴──────────────┴──────────────┘
  
  El MSSP gestiona MDC, Sentinel, Defender desde SU tenant
  con roles delegados en los tenants de sus clientes.
```

### 9.3 Capacidades en contexto SC-200

- Gestionar **Defender for Cloud** de múltiples clientes desde un solo dashboard.
- Ver alertas de **Sentinel** de varios workspaces en una vista consolidada.
- Aplicar **policies** de Azure en subscripciones de clientes.
- Los clientes mantienen visibilidad de quién tiene acceso y qué permisos.

> [!example] Caso de uso MSSP
> Una empresa de ciberseguridad gestiona 50 clientes. Con Azure Lighthouse, desde su propio tenant pueden ver el Secure Score de MDC de todos los clientes, responder incidentes de Sentinel y aplicar remediaciones, sin tener cuentas de usuario en cada tenant cliente.

> [!tip] Para el examen
> Azure Lighthouse → respuesta correcta cuando la pregunta menciona "gestión centralizada de múltiples suscripciones/tenants" o "MSSP que gestiona varios clientes".

---

## 10. Governance y Compliance Transversal

### 10.1 Azure Policy en contexto de seguridad

- **Azure Policy** puede forzar configuraciones de seguridad en subscripciones.
- Se integra con MDC: las políticas de seguridad de MDC son implementadas como Azure Policy initiatives.
- Un **initiative** = conjunto de policies agrupadas (ej. "Azure Security Benchmark").

### 10.2 Microsoft Cloud Security Benchmark (MCSB)

- Sucesor del Azure Security Benchmark.
- Controles mapeados a: CIS, NIST, PCI DSS.
- Es el baseline por defecto en MDC para el Secure Score.

### 10.3 Compliance continuo

```
  Recurso nuevo desplegado
         │
         ▼
  Azure Policy evalúa → ¿Cumple? → No → MDC genera recomendación
         │                                       │
         ▼                                       ▼
  Sí → Estado: Compliant             Analista remedia
                                              │
                                              ▼
                                     Secure Score sube
                                     Compliance % sube
```

---

## 🎴 Flash Cards

**Q:** ¿Cuál es la diferencia principal entre CSPM y CWPP?
**A:** CSPM gestiona postura y compliance (recomendaciones, Secure Score); CWPP protege workloads en runtime (alertas, detección de amenazas activa).

---

**Q:** ¿Qué herramienta de Microsoft muestra "attack paths" entre activos?
**A:** Microsoft Security Exposure Management (MSEM).

---

**Q:** ¿El Exposure Score es mejor cuando es alto o bajo?
**A:** Bajo (indica menor exposición). Contrario a Secure Score donde más alto = mejor.

---

**Q:** ¿Qué tier de logs en Sentinel es el más económico para logs verbosos con búsqueda ocasional?
**A:** Basic Logs (~80 % más barato que Analytics, búsqueda on-demand).

---

**Q:** ¿Qué componente de Sentinel filtra y transforma datos antes de ingestion?
**A:** Data Collection Rules (DCR) con transformations.

---

**Q:** ¿Qué política de Conditional Access activa Entra ID Protection si el user risk es alto?
**A:** User risk policy: user risk ≥ High → require password change + MFA.

---

**Q:** ¿Qué herramienta de Microsoft permite a un MSSP gestionar Sentinel/MDC de múltiples clientes desde un solo tenant?
**A:** Azure Lighthouse.

---

**Q:** ¿MDO P1 o P2 incluye Threat Explorer y Attack Simulation Training?
**A:** Solo MDO P2.

---

**Q:** ¿Qué hace Conditional Access App Control en MDCA?
**A:** Intercepta sesiones de apps cloud en tiempo real para aplicar políticas (bloquear descarga, monitorear, etiquetar).

---

**Q:** ¿Cuál es el estándar de compliance por defecto en MDC?
**A:** Microsoft Cloud Security Benchmark (MCSB).

---

## ✅ Checklist SC-200 — Módulo 4

- [ ] Explicar qué unifica el portal `security.microsoft.com` (incident queue + Advanced Hunting).
- [ ] Distinguir CSPM vs CWPP con ejemplos de cada uno.
- [ ] Listar al menos 5 Defender plans de MDC y qué protegen.
- [ ] Explicar Secure Score vs Exposure Score (dirección de la métrica, foco, herramienta).
- [ ] Describir los componentes de MSEM: Attack Surface Map, Attack Paths, Critical Assets, Initiatives.
- [ ] Comparar MDO P1 vs P2 (capacidades exclusivas de P2).
- [ ] Explicar los 3 tiers de logs de Sentinel y cuándo usar cada uno.
- [ ] Describir qué son DCR y cómo reducen costes con transformations.
- [ ] Explicar sign-in risk vs user risk en Entra ID Protection.
- [ ] Describir el rol de Azure Lighthouse para MSSPs.
- [ ] Explicar Cloud Discovery y OAuth App Governance en MDCA.
- [ ] Describir las best practices de alert suppression (scope restrictivo, expiración).
- [ ] Escribir una query KQL básica sobre `AADRiskyUsers` o `BehaviorAnalytics`.

---

## 🔗 Notas Relacionadas

- [[00_INDEX_Coursera_SC200]] — Índice general del curso
- [[Modulo_1_Defender_XDR]] — Fundamentos de Defender XDR y detección de endpoints
- [[Modulo_3_Sentinel]] — Microsoft Sentinel: SIEM/SOAR, analytic rules, workbooks
- [[CONCEPTOS_CLAVE]] — Glosario de términos SC-200
- [[KQL_Cheatsheet]] — Referencia de queries KQL para el examen

---

*Nota creada el 2026-06-22 | Síntesis Coursera SC-200 — Módulo 4*
