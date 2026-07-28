---
tags: [sc-200, coursera, defender-xdr, soc, sintesis-curso]
fecha: 2026-06-22
ultima_actualizacion: 2026-06-22
estado: 🟢 Alineada con TOC real del curso (Lesson 1 — What is Defender XDR? integrada)
tipo: Síntesis de módulo
relacionado: "[[00_INDEX_Coursera_SC200]], [[CONCEPTOS_CLAVE]], [[03_Semana3_Defender_XDR]], [[CHEATSHEET_KQL]]"
---

# 🛡️ Módulo 1 — Microsoft Defender XDR

> **Idea central:** Defender XDR es la plataforma unificada de detección y respuesta extendida de Microsoft. Correlaciona señales de endpoints, identidades, correo, apps cloud y vulnerabilidades en un único portal (`security.microsoft.com`), permitiendo al analista investigar, contener y remediar incidentes de extremo a extremo sin saltar entre consolas.

> [!abstract] Learning Outcomes (oficiales del curso)
> - Understand the incident response lifecycle and the role of Microsoft Defender XDR.
> - Investigate security incidents using Microsoft Sentinel alerts and advanced analytics.
> - Apply forensic analysis techniques to track, categorize, and mitigate threats.
> - Optimize custom detection rules and refine alert configurations for improved security monitoring.
> - Develop hands-on expertise in KQL for in-depth security investigations.

> [!note] Por qué importa para el SC-200
> El examen SC-200 pesa ~35% del contenido en "Mitigate threats using Microsoft Defender XDR". Este módulo es el núcleo operativo: portal, incidentes, entidades, Advanced Hunting y respuesta. Todo lo demás se construye sobre esta base.

---

## 🗂️ Estructura del Módulo (lecciones del curso)

| Lección | Tema | Cubierto en | Estado |
|---|---|---|---|
| **Lesson 1** | Course Overview | §Lesson 1 — Course Overview | ✅ |
| **Lesson 1** | Exam Overview | §Lesson 1 — Exam Overview | ✅ |
| **Lesson 1** | What is Microsoft Defender XDR? | §Lesson 1 — What is Microsoft Defender XDR? | ✅ |
| **Lesson 1** | Key Benefits of Microsoft Defender XDR | §1.1 Key Benefits | ✅ |
| **Lesson 1** | Defender XDR vs. Traditional Security Tools | §1.2 Comparativa | ✅ |
| **Lesson 1** | Threat Analytics Overview | §1.3 Threat Analytics | ✅ |
| **Lesson 1** | Creating Lab Environment - Step by Step | §1.4 Lab Setup | ✅ |
| **Lesson 1** | Connecting Defender XDR to Microsoft Sentinel | §7 + §1.5 Conector | ✅ |
| **Lesson 2** | Alert Configuration & Notifications - Incidents | §2 Correlación de alertas | ✅ |
| **Lesson 2** | Alert Configuration & Notifications - Threat Analytics | §1.3 Threat Analytics | ✅ |
| **Lesson 2** | Automated Investigation & Response (AIR) - Theory | [[CONCEPTOS_CLAVE]] §3 | ✅ (referenciado) |
| **Lesson 2** | AIR - Demo | [[CONCEPTOS_CLAVE]] §3 | 🔧 Demo pendiente |
| **Lesson 2** | Investigating & Responding to Incidents | §3 + §4 | ✅ |
| **Lesson 2** | Custom Detection Rules | §1.6 Custom Detection Rules | ✅ |
| **Lesson 2** | Alert Tuning & Deception | §1.7 Alert Tuning & Deception | ✅ |
| **Lesson 2** | Best Practices for Microsoft Defender XDR | §4 Response Actions | ✅ (integrado) |
| **Lesson 2** | Data Loss Prevention (DLP) | §1.8 DLP | ✅ |
| **Lesson 2** | Aligning security solutions with MCRA | §1.9 MCRA | ✅ |
| **Lesson 2** | Module 1 - Exam Tips | §Exam Tips | ✅ |

---

## 🎬 Lesson 1 — Course Overview

> [!summary] Resumen del video (instructor, transcripción verbatim integrada)

El instructor presenta el curso como una preparación para el examen **SC-200: Microsoft Security Operations Analyst**. El curso cubre las herramientas de seguridad de Microsoft organizadas en **5 módulos clave** (según el video):

1. **Microsoft Defender XDR** — la plataforma unificada de detección y respuesta extendida.
2. **Microsoft Defender for Endpoint** — protección de dispositivos con antivirus + EDR + gestión de vulnerabilidades.
3. **Microsoft Sentinel** — SIEM cloud-native para detección, investigación y automatización de respuestas.
4. **Microsoft Defender Security Technologies** — tecnologías subyacentes (machine learning, behavioral analytics, threat intelligence) que habilitan los productos de la familia Defender.
5. **Threat Hunting Services** — técnicas y servicios para la búsqueda proactiva de amenazas.

### Puntos clave de la introducción

- **XDR = Extended Detection and Response**: el instructor lo describe como la "next generation of threat protection". Va más allá del endpoint protection tradicional al unificar señales de **endpoints, email, identity y cloud applications**, ofreciendo visibilidad integral y respuesta automatizada para detectar ataques sofisticados.
- **Defender for Endpoint**: combina **antivirus + EDR (Endpoint Detection and Response) + threat & vulnerability management** para proteger contra malware, ransomware y otras amenazas en dispositivos.
- **Microsoft Sentinel**: SIEM cloud-native que recolecta y analiza datos de todo el entorno para detectar, investigar y automatizar respuestas a incidentes.

### Objetivos del curso (según el instructor)

- Entender los componentes y capacidades de cada producto de la familia Defender.
- Implementar y configurar cada producto.
- Investigar incidentes con **Threat Explorer** y **Microsoft Sentinel**.
- Responder con **automated playbooks** y acciones de remediación.
- Realizar threat hunting proactivo.
- Construir una estrategia de seguridad integral usando la familia Defender.

### Audiencia objetivo

Security professionals, IT administrators y cualquier persona responsable de proteger activos digitales. El curso está diseñado tanto para **principiantes** que empiezan en seguridad como para **veteranos** que buscan profundizar en las herramientas Microsoft.

> [!warning] Discrepancia temario hablado vs. escrito
> En el video de overview el instructor menciona **5 módulos** y nombra el módulo 4 como *"Microsoft Defender Security Technologies"*, sin mencionar Microsoft Security Copilot. El temario escrito de Coursera lista **6 módulos** e incluye *"Unified Security Operations and Exposure Management"* (Módulo 4) y *"Microsoft Security Copilot"* (Módulo 6). La síntesis del vault sigue la estructura escrita de 6 módulos (ver [[00_INDEX_Coursera_SC200]]). Posible que el curso se haya actualizado tras grabar el overview. 🔧 confirmar al avanzar.

---

## 🎬 Lesson 1 — Exam Overview

> [!summary] Resumen del video (instructor, transcripción verbatim integrada)

### Qué es el SC-200

El SC-200 es una **evaluación rigurosa** que valida el expertise como **Security Operations Analyst** en el ecosistema Microsoft. Demuestra proficiency en **threat mitigation, incident response y vulnerability management** a través de las soluciones de seguridad Microsoft.

### Dominios y skills evaluadas

El examen cubre los siguientes temas principales:

- **Microsoft Defender XDR** — plataforma unificada de detección y respuesta extendida.
- **Microsoft Defender for Endpoint** — protección y EDR de dispositivos.
- **KQL (Kusto Query Language)** — herramienta de queries para Microsoft Sentinel y Advanced Hunting.
- **Microsoft Sentinel (SIEM)** — fuerte énfasis en este tema según el instructor.

Skills que evalúa el examen: threat mitigation, incident response, vulnerability management, KQL, y uso de las soluciones de seguridad Microsoft.

### Formato del examen (según el video)

| Atributo | Valor |
|---|---|
| **Nº de preguntas** | 40 – 60 |
| **Duración** | 100 minutos (~1 h 40 min) |
| **Passing score** | 700 / 1000 (escala 100 – 1000) |
| **Formatos de pregunta** | Multiple choice, multiple response, drag-and-drop / ordenar en secuencia, case study, scenario-based |
| **Revisión de preguntas** | Se pueden marcar preguntas para revisión y volver después |
| **Idiomas disponibles** | Japonés, Chino, Coreano, Alemán, Francés, Español, Portugués, Italiano, Inglés |
| **Costo (EE.UU.)** | $165 USD con impuestos (varía por país) |
| **Certificación obtenida** | Microsoft Certified: Security Operations Analyst Associate |

### Recursos de preparación recomendados por el instructor

- **Microsoft Learn** — documentación oficial de Microsoft (principal recurso gratuito).
- **Whizlabs** — curso de práctica (el instructor lo menciona como "Wiz Labs" en la transcripción).
- **Practice tests** — exámenes de práctica para familiarizarse con el formato.

> [!warning] Discrepancias con [[00_INDEX_SC200]] — verificar en fuente oficial
> El video del curso indica datos distintos a los registrados en [[00_INDEX_SC200]]:
> - **Idioma:** el instructor dice que el examen **SÍ está disponible en español**. El índice actual dice "Inglés (sin opción español)".
> - **Duración:** el video dice **100 minutos**; el índice dice 120 minutos.
> Los datos del curso pueden estar desactualizados o variar por región. 🔧 Confirmar en la página oficial de Microsoft (learn.microsoft.com/credentials/certifications/exams/sc-200) antes de agendar. No se modificó [[00_INDEX_SC200]] hasta tu verificación.

---

## 🎬 Lesson 1 — What is Microsoft Defender XDR?

> [!summary] Resumen del video (instructor, transcripción verbatim integrada)

### El problema que resuelve

El instructor abre con el contexto: el panorama de ciberseguridad **evoluciona constantemente** y las herramientas de seguridad tradicionales, aunque útiles, **no alcanzan el ritmo** de los ataques sofisticados modernos. Defender XDR existe para resolver ese desfase.

### Definición central del instructor

> "Microsoft Defender XDR is an **Extended Detection and Response** solution that acts as a **security command center** for your Microsoft 365 environment."

Más adelante en el video el instructor refina la metáfora:

> "Think of it as the **central nervous system** of your security infrastructure."

Ambas frases son las que el instructor repite y enfatiza como definición canónica del producto.

### Las 4 fuentes de datos que unifica XDR

El valor diferencial de XDR frente a herramientas aisladas es que **recolecta y analiza datos de múltiples fuentes** para dar una vista integral de la postura de seguridad. El instructor enumera cuatro:

| Fuente | Datos recolectados | Qué detecta |
|---|---|---|
| **Endpoints** | Laptops, desktops, servers | Unauthorized access attempts, malware executions, unusual file modifications |
| **Emails** | Attachments, sender information, content | Phishing, spam campaigns, otras amenazas de email |
| **Applications** | Uso de apps en el entorno | Apps no autorizadas, actividad sospechosa dentro de apps autorizadas, vulnerabilidades de apps |
| **User identities** | Login attempts, access requests, data modifications | Cuentas comprometidas, comportamientos sospechosos |

> [!note] Mapeo a productos de arquitectura
> Estas 4 fuentes corresponden a los productos detallados en [[#1. Arquitectura — Qué integra Defender XDR]]: Endpoints → MDE, Emails → MDO, Applications → MDCA, User identities → MDI + Entra ID Protection. Ver esa sección para el desglose técnico completo por producto.

### El valor diferencial: correlación cross-domain

El instructor subraya que el verdadero poder de XDR **no está en identificar eventos aislados** sino en la **correlación**:

- Al analizar el gran volumen de datos de distintos productos, XDR **correlaciona eventos entre datasets**, revelando **patrones de ataque complejos**.
- Las herramientas "siloed" (centradas en un único workload) ven eventos aislados que individualmente no alertarían; XDR los conecta en un único incidente coherente.
- Esta correlación cross-domain es la capacidad que permite detectar ataques sofisticados de forma proactiva.

### Cierre del instructor

El instructor concluye que esta **vista holística** es clave para la detección proactiva, pero advierte que el verdadero poder de XDR va **más allá de la mera identificación** de actividades sospechosas — las capacidades de respuesta y automatización se cubren en los videos siguientes del módulo.

> [!tip] Para el examen
> La frase clave que repite el curso: Defender XDR unifica señales de **endpoints + email + applications + identities** y su valor está en la **correlación cross-domain** (un solo incidente a partir de señales que aisladas no alertarían). Relaciona esto con la Fusion Rule y el Attack Graph (ver [[CONCEPTOS_CLAVE]] §1.4).

---

## 1. Arquitectura — Qué integra Defender XDR

| Producto | Cobertura | Señales que aporta al portal unificado |
|---|---|---|
| **Defender for Endpoint (MDE)** | Dispositivos (Windows, macOS, Linux, Android, iOS) | Proceso, red, archivo, registro, alertas EDR |
| **Defender for Identity (MDI)** | Active Directory / AD DS + Entra ID | Logons, lateral movement, pass-the-hash, Kerberoasting |
| **Defender for Office 365 (MDO)** | Email, Teams, SharePoint, OneDrive | Phishing, malware en adjuntos, links maliciosos, BEC |
| **Defender for Cloud Apps (MDCA)** | SaaS (OAuth apps, shadow IT) | Impossible travel, anomalías de sesión, app risky |
| **Defender Vulnerability Management (MDVM)** | Inventario de activos + CVEs | Exposure score, software vulnerable, missing patches |
| **Entra ID Protection** | Identidades cloud | Sign-in risk, user risk, risky sign-ins |

> [!tip] Para el examen
> Cuando una pregunta mencione **"correlate signals across workloads"** o **"single pane of glass"**, la respuesta es el portal unificado `security.microsoft.com`. Si pregunta qué producto detecta **pass-the-hash o lateral movement en on-prem AD**, es **MDI**, no MDE.

**Portal unificado:** `https://security.microsoft.com`
- Sustituye a los portales heredados (security.microsoft.com ya absorbió defender.microsoft.com).
- Requiere al menos una licencia habilitante (M365 E5 / E5 Security / licencias individuales de cada producto).

---

### 1.1 Key Benefits of Microsoft Defender XDR

> [!info] Por qué XDR supera al modelo tradicional de productos aislados

| Beneficio | Descripción operativa |
|---|---|
| **Correlación cross-domain** | Fusiona señales de endpoint, identidad, email y cloud en un único incidente; elimina la necesidad de correlacionar manualmente entre consolas |
| **Auto-healing / Self-healing** | AIR remedia automáticamente amenazas comunes (quarantine file, disable user, block IP) sin intervención humana — reduce MTTR |
| **Single pane of glass** | Un único portal para investigar, responder y huntear sin pivotear entre MDE, MDI, MDO y MDCA por separado |
| **Reduced alert fatigue** | El motor de correlación agrupa decenas de alertas individuales en un incidente coherente; el analista ve 1 incidente en lugar de 40 alertas |
| **MITRE ATT&CK mapping** | Cada alerta lleva etiqueta de técnica/táctica ATT&CK; facilita contexto de ataque y priorización |
| **Threat Intelligence integrada** | Threat Analytics (§1.3) integra inteligencia de amenazas de Microsoft Threat Intelligence Center directamente en el portal |
| **Cobertura de identidad on-prem y cloud** | MDI + Entra ID Protection juntos cubren AD DS y Entra ID; cubre el gap que EDR puro no cubre |

> [!tip] Para el examen
> Si una pregunta pregunta **qué ventaja concreta ofrece XDR sobre un SIEM tradicional**, la respuesta clave es la **correlación automática cross-domain + auto-healing (AIR)**. El SIEM requiere correlación manual con reglas; XDR lo hace out-of-the-box.

---

### 1.2 Defender XDR vs. Traditional Security Tools

| Dimensión | Antivirus tradicional | EDR (solo) | SIEM (solo) | **Microsoft Defender XDR** |
|---|---|---|---|---|
| **Alcance de detección** | Solo endpoint (signatures) | Solo endpoint (behavioral) | Multi-fuente (logs) | Multi-workload nativo (endpoint + identity + email + cloud) |
| **Correlación** | Ninguna | En el device | Manual (reglas) | Automática cross-domain por motor XDR |
| **Respuesta** | Quarantine local | Isolate, AV scan | Alertar / SOAR externo | Respuesta integrada nativa (AIR + manual actions) |
| **Threat Hunting** | No | Limitado al EDR | Sí (con KQL/SPL) | Sí (Advanced Hunting KQL sobre 30 días, todos los workloads) |
| **Inteligencia de amenazas** | Signatures actualizadas | Threat feeds básicos | TI connector manual | Threat Analytics nativo (Microsoft TI) |
| **Identidad (AD/Entra)** | No | No | Sí (logs SIEM) | Sí nativo (MDI + Entra ID P) |
| **Gestión de casos** | No | Limitada | Sí | Sí (Incidents con full context) |
| **Auto-remediación** | Sí (quarantine) | Limitada | No (requiere SOAR) | Sí (AIR) |

> [!note] XDR no reemplaza a SIEM
> En el stack Microsoft moderno, Defender XDR y Microsoft Sentinel son **complementarios**: XDR gestiona los workloads Microsoft con correlación nativa y AIR; Sentinel añade la capa SIEM/SOAR para fuentes externas, retención larga, Playbooks y Analytics Rules complejas. Ver §7 y [[Modulo_3_Sentinel]].

---

### 1.3 Threat Analytics

**Threat Analytics** es el módulo de inteligencia de amenazas operacional integrado en el portal XDR (`security.microsoft.com/threatanalytics3`). Publica **threat reports** redactados por Microsoft Threat Intelligence Center sobre campañas activas, malware y técnicas de ataque.

#### Estructura de un Threat Report

| Sección | Contenido |
|---|---|
| **Overview** | Resumen ejecutivo de la amenaza: actores, técnicas MITRE, impacto global |
| **Analyst report** | Informe técnico completo del equipo de TI de Microsoft |
| **Related incidents** | Incidentes en el tenant del cliente relacionados con esta amenaza |
| **Impacted assets** | Devices y usuarios expuestos o afectados |
| **Exposure & mitigations** | CVEs relevantes, configuraciones de riesgo y acciones recomendadas |
| **Recommended actions** | Controles y configuraciones para mitigar la amenaza específica |

#### Métricas clave en el dashboard de Threat Analytics

- **Exposure score**: Cuántos activos del tenant son vulnerables a la amenaza.
- **Impact**: Cuántos incidentes activos en el tenant están relacionados.
- **Recommended actions completadas / pendientes**: Progreso de hardening contra la amenaza.

> [!tip] Para el examen
> Threat Analytics sirve para **priorizar remediaciones basándose en amenazas activas** contra el tenant específico — no es un feed genérico de TI sino inteligencia contextualizada. Pregunta frecuente: "¿Dónde ves si tu tenant tiene activos expuestos a una campaña de ransomware activa?" → Threat Analytics.

> [!note] Enlace a CONCEPTOS_CLAVE
> El ciclo de TI (STIX/TAXII, TI platform connector, IOC management en Sentinel) está en [[CONCEPTOS_CLAVE]] §2.4.2.

---

### 1.4 Creating Lab Environment

> [!tip] Nota práctica para los labs del curso

Para realizar los labs del módulo se necesita un **tenant de prueba con licencias M365 E5** (o E5 Security). Opciones:

- **M365 Developer Program**: tenant gratuito de 90 días renovable con 25 licencias E5 en `developer.microsoft.com/microsoft-365/dev-program`.
- **Microsoft 365 E5 Trial**: trial de 30 días en el portal de admin (`admin.microsoft.com`).

**Pasos básicos de onboarding para el lab:**
1. Crear tenant → activar licencias M365 E5.
2. Ir a `security.microsoft.com` → Settings → Endpoints → Onboard device.
3. Descargar el script de onboarding (Local Script para lab) y ejecutar en la VM de prueba.
4. Verificar que el device aparece en `security.microsoft.com/machines` (~5-10 min).
5. Habilitar **Microsoft Defender XDR** desde Settings → Microsoft Defender XDR → Turn on.
6. Verificar los conectores activos en Settings → Connected workloads.

---

### 1.5 Connecting Defender XDR to Microsoft Sentinel

Ver §7 de esta nota para la cobertura completa de modos de integración (one-way vs. bi-directional).

**Resumen del conector Defender XDR en Sentinel:**

- Se instala desde **Microsoft Sentinel → Content Hub** (solución "Microsoft Defender XDR").
- Habilita la ingesta de incidentes y alertas de todos los workloads Defender en el workspace de Log Analytics de Sentinel.
- Permite elegir qué tablas de datos raw se sincronizan (ej. `DeviceEvents`, `EmailEvents`) para Advanced Hunting combinado.
- En el **modo Unified SecOps Platform** (bi-directional), Sentinel se onboardea directamente al portal `security.microsoft.com` y los analistas trabajan desde allí.

> [!note] Ver [[Modulo_3_Sentinel]] para la configuración detallada del conector, incident sync y Unified portal.

---

### 1.6 Custom Detection Rules

Las **Custom Detection Rules** (Reglas de Detección Personalizadas) se crean en Defender XDR a partir de queries de **Advanced Hunting**. Permiten al SOC automatizar la detección de comportamientos específicos que las detecciones out-of-the-box no cubren.

#### Diferencia clave: Custom Detection Rules (XDR) vs. Analytics Rules (Sentinel)

| Aspecto | Custom Detection Rules (Defender XDR) | Analytics Rules (Microsoft Sentinel) |
|---|---|---|
| **Fuente de datos** | Solo tablas de Advanced Hunting (XDR) | Cualquier tabla del workspace Log Analytics |
| **Lenguaje** | KQL (Advanced Hunting) | KQL (Log Analytics) |
| **Acciones automáticas** | Response actions nativas (isolate, quarantine, disable user) | Playbooks (Logic Apps) — más flexibles pero externas |
| **Portal** | `security.microsoft.com` → Hunting → Custom detections | `portal.azure.com` / Sentinel blade → Analytics |
| **Frecuencia de evaluación** | Cada 1h, 3h, 12h o 24h | Cada 5 min hasta cada 14 días (configurable) |
| **Entidades impactadas** | Se definen en la query (DeviceName, AccountName…) | Se extraen con Entity mapping |
| **Mejor para** | Detecciones sobre actividad de endpoint/identity/email/cloud | Detecciones sobre fuentes externas, UEBA, tablas custom |

#### Crear una Custom Detection Rule — flujo

1. Ir a **Advanced Hunting** → construir y validar la query KQL.
2. Click en **"Create detection rule"** desde el resultado de la query.
3. Configurar:
   - **Nombre y descripción** de la regla.
   - **Frecuencia**: cada 1h, 3h, 12h o 24h.
   - **Alert severity**: Informational / Low / Medium / High.
   - **MITRE ATT&CK techniques**: mapear la táctica/técnica correspondiente.
   - **Impacted entities**: indicar qué columnas de la query representan Device, User, IP, URL, File.
   - **Response actions**: opcionalmente configurar acciones automáticas (isolate device, quarantine file, disable user).

#### Ejemplo KQL para Custom Detection — ejecución de script desde Office

```kql
DeviceProcessEvents
| where InitiatingProcessFileName in~ ("winword.exe", "excel.exe", "powerpnt.exe", "outlook.exe")
| where FileName in~ ("cmd.exe", "powershell.exe", "wscript.exe", "cscript.exe", "mshta.exe")
| where Timestamp > ago(1h)
| project Timestamp, DeviceName, AccountName, FileName, ProcessCommandLine,
          InitiatingProcessFileName, InitiatingProcessCommandLine
```

> [!tip] Para el examen
> La diferencia crítica: Custom Detection Rules en XDR generan **alertas e incidentes nativos** con response actions integradas; las Analytics Rules de Sentinel también generan incidentes pero requieren **Playbooks (Logic Apps)** para la automatización de respuesta. Si la pregunta dice "automatizar aislamiento de device al detectar comportamiento X", la respuesta es Custom Detection Rule en Defender XDR (o AIR).

---

### 1.7 Alert Tuning & Deception

#### Alert Tuning (Ajuste de alertas)

**Alert Tuning** permite crear reglas para **suprimir o ajustar alertas** específicas y reducir el ruido en el portal. No elimina la detección subyacente; solo filtra las alertas que cumplen ciertos criterios (ej. actividad administrativa legítima que dispara alertas de forma recurrente).

| Aspecto | Descripción |
|---|---|
| **Dónde se configura** | `security.microsoft.com` → Settings → Alert tuning |
| **Tipos de condición** | Por título de alerta, entidad (device/user), evidencia (file hash, IP, URL) |
| **Acción** | Suppress (no generar alerta) o cambiar la severidad hacia abajo |
| **Scope** | Toda la organización o específico a un device/usuario |
| **Duración** | Permanente o con fecha de expiración |
| **Diferencia con FP** | Alert Tuning es proactiva (prevenir alertas futuras); clasificar como FP es retrospectiva (cerrar las ya generadas) |

> [!warning] Uso correcto
> Alert Tuning debe usarse con criterios muy específicos (ej. hash exacto de una herramienta de admin, IP interna conocida). Reglas demasiado amplias pueden suprimir amenazas reales — **blind spot risk**.

#### Deception (Engaño / Honeytokens)

**Deception en Defender XDR** consiste en desplegar **leurres (decoys)** — cuentas, hosts y tokens falsos — dentro del entorno para detectar movimiento lateral y reconocimiento de atacantes. Cuando un atacante interactúa con un decoy, se genera una alerta de alta fidelidad.

| Componente | Descripción |
|---|---|
| **Decoy accounts** | Cuentas de usuario falsas en AD/Entra ID; ningún usuario legítimo las usa; cualquier autenticación es maliciosa |
| **Decoy hosts** | Dispositivos ficticios que aparecen en la red; cualquier conexión a ellos es sospechosa |
| **Honeytokens** | Credenciales o archivos atractivos para un atacante (ej. `passwords.txt` falso con credenciales trampa) |
| **Cobertura** | Detección de lateral movement, credential harvesting, internal reconnaissance |
| **Señal** | Alta fidelidad — muy bajo false positive rate; cualquier interacción con un decoy es casi certeza de actividad maliciosa |
| **Dónde se configura** | `security.microsoft.com` → Settings → Identities → Deception |

| | Alert Tuning | Deception |
|---|---|---|
| **Propósito** | Reducir ruido / false positives | Detectar atacantes activos con alta fidelidad |
| **Acción** | Suprimir o ajustar alertas existentes | Generar nuevas alertas de alta fidelidad |
| **Target** | Actividad legítima que dispara alertas | Atacantes que hacen reconocimiento/lateral movement |
| **Resultado** | Menos alertas (signal-to-noise improvement) | Más alertas (pero de máxima confianza) |

> [!tip] Para el examen
> Deception + honeytokens es la técnica de **detección de movimiento lateral de alta fidelidad** en Defender XDR. Si una pregunta pregunta cómo detectar atacantes que realizan internal reconnaissance sin generar falsos positivos, la respuesta es **Deception/honeytokens**.

---

### 1.8 Data Loss Prevention (DLP)

**Microsoft Purview DLP** integrado con Defender XDR permite a los analistas de seguridad ver y responder a **alertas de pérdida de datos** directamente desde el portal unificado.

#### Componentes DLP relevantes para el SOC

| Componente | Descripción |
|---|---|
| **DLP Policies** | Reglas que definen qué información sensible está protegida y qué acciones tomar (bloquear, auditar, notificar) |
| **Sensitive Information Types (SIT)** | Patrones predefinidos o custom que identifican datos sensibles: números de tarjeta, CURP/RFC, secretos industriales, etc. |
| **Endpoint DLP** | Extensión de DLP al endpoint (via MDE): controla copia a USB, upload a cloud, impresión de datos sensibles |
| **DLP Alerts en el portal unificado** | Las alertas DLP aparecen en `security.microsoft.com` bajo **Data loss prevention** — el analista SOC puede verlas junto con incidentes de seguridad |
| **Purview Compliance Portal** | Portal separado (`compliance.microsoft.com`) para administración de políticas DLP; las alertas se consumen desde el portal unificado |

#### Flujo DLP en el portal unificado

```
Purview DLP Policy detecta violación
        │
        ▼
Alerta DLP generada en compliance.microsoft.com
        │
        ▼ [conector Defender XDR]
Alerta visible en security.microsoft.com → Data loss prevention
        │
        ├─ Ver archivos/actividad implicada
        ├─ Ver usuario + device + acción (ej. "uploaded 'Contrato_cliente.docx' to personal OneDrive")
        └─ Escalar como incidente si hay indicios de insider threat
```

> [!note] DLP ≠ Security Alert
> Las alertas DLP son de **compliance/datos**, no necesariamente de un ataque externo. Pueden indicar **insider threat** (empleado exfiltrando datos) o accidental data leakage. El analista SOC debe distinguir entre exfiltración maliciosa e incumplimiento accidental de políticas.

> [!tip] Para el examen
> **Endpoint DLP** requiere que el device esté **onboarded en MDE** — es un requisito de la integración. Si la pregunta dice "controlar la copia de datos sensibles a USB en endpoints", la respuesta es **Endpoint DLP** (Microsoft Purview DLP + MDE integrado).

---

### 1.9 Aligning Security Solutions with MCRA

**Microsoft Cybersecurity Reference Architecture (MCRA)** es el framework de arquitectura de referencia de Microsoft que mapea los productos y servicios de seguridad a escenarios, capas y capacidades de ciberseguridad.

#### Qué es MCRA

- Documento/diagrama publicado por Microsoft (disponible en `aka.ms/mcra`).
- Muestra **cómo los productos Microsoft de seguridad se interrelacionan** y cubren las distintas capas del stack de seguridad: identidad, endpoints, datos, apps, infraestructura, red, operaciones SOC.
- Permite a arquitectos y equipos SOC **diseñar arquitecturas completas** sin brechas de cobertura.
- Actualizado periódicamente por el equipo de seguridad de Microsoft.

#### Capas cubiertas por MCRA

| Capa | Productos Microsoft principales |
|---|---|
| **Identidad y acceso** | Entra ID, MDI, Entra ID Protection, Entra Privileged Identity Management |
| **Endpoints** | MDE, Intune, Defender Vulnerability Management |
| **Email y colaboración** | MDO, Defender for Teams |
| **Aplicaciones cloud (SaaS/PaaS)** | MDCA, Defender for Cloud |
| **Infraestructura y red** | Defender for Cloud (IaaS), Azure Firewall, DDoS Protection |
| **Datos** | Microsoft Purview (DLP, Information Protection, Insider Risk) |
| **Operaciones SOC** | Defender XDR (portal unificado), Microsoft Sentinel, MXDR service |

#### Uso para diseño de arquitecturas SOC

- **Gap analysis**: comparar el stack actual del cliente contra MCRA para identificar capas sin cobertura.
- **Roadmap de implementación**: priorizar qué productos habilitar primero según el riesgo del cliente.
- **Justificación ante stakeholders**: el diagrama MCRA comunica la estrategia de seguridad de forma visual.
- **SC-200**: el examen espera que el candidato entienda qué producto Microsoft cubre cada capacidad/capa — MCRA es el mapa mental de referencia.

> [!tip] Para el examen
> Si una pregunta describe un escenario ("la organización necesita proteger datos sensibles en email + endpoints + cloud storage"), aplica MCRA mentalmente: MDO (email) + Endpoint DLP/MDE (endpoint) + MDCA + Purview (cloud storage). MCRA es el framework que conecta todos los módulos del SC-200.

---

## 2. Correlación de alertas en Incidentes

```
Alertas individuales (MDE + MDI + MDO + MDCA)
        │
        ▼  [Motor de correlación XDR]
  INCIDENT (entidad unificada)
        │
        ├─ Attack Story (gráfico + línea de tiempo)
        ├─ Alerts (lista de alertas correlacionadas)
        ├─ Entities (usuarios, devices, IPs, URLs, mailboxes, files)
        ├─ Evidence & Response (IOCs + acciones de remediación)
        └─ Investigations (procesos AIR asociados)
```

### Incident Queue — campos clave

| Campo | Descripción | Valores relevantes |
|---|---|---|
| **Severity** | Calculado por el motor XDR | Informational / Low / Medium / High |
| **Status** | Estado operativo | Active / In Progress / Resolved |
| **Assigned to** | Analista asignado | (cola compartida o personal) |
| **Categories** | Tipo de ataque MITRE | Ransomware, Phishing, Credential Access… |
| **Service sources** | Qué productos generaron alertas | MDE, MDI, MDO, MDCA, Entra ID P |
| **Tags** | Etiquetas personalizadas | Para organización / SLA tracking |

> [!tip] Para el examen
> El SC-200 pregunta **cómo priorizar incidentes**: usa **severity + categories + número de entities afectadas**. Un incidente con múltiples usuarios comprometidos + lateral movement siempre escala sobre uno de malware aislado en un único device.

### Attack Story / Attack Graph

El **Attack Story** es la vista principal de un incidente. Muestra:
- **Gráfico interactivo** de entidades y cómo se conectan (device → user → mailbox → lateral move).
- **Línea de tiempo** de alertas en orden cronológico.
- **MITRE ATT&CK techniques** etiquetadas en cada alerta.

> [!note] Enlace a CONCEPTOS_CLAVE
> El ciclo completo **Triage → Investigate → Respond** y el concepto de **Attack Chain / Kill Chain** están desarrollados en profundidad en [[CONCEPTOS_CLAVE]] §3 (ciclo XDR) y §1 (attack chain). Aquí solo se referencia el punto de entrada operativo.

---

## 3. Investigación de Incidentes — Tabs del portal

Cuando abres un incidente en `security.microsoft.com/incidents`, dispones de estas pestañas:

| Tab | Qué muestra | Cuándo usarla |
|---|---|---|
| **Attack story** | Gráfico + timeline + MITRE | Primera vista; entender el alcance |
| **Alerts** | Lista detallada de cada alerta | Profundizar en una alerta específica |
| **Entities** | Usuarios, devices, IPs, URLs, files, mailboxes | Identificar activos afectados |
| **Evidence & Response** | IOCs confirmados + acciones de remediación pendientes/completadas | Tomar o revisar acciones de respuesta |
| **Investigations** | Procesos AIR lanzados (automáticos o manuales) | Ver qué encontró AIR; aprobar/rechazar |
| **Graph** (vista avanzada) | Grafo expandible de entidades | Análisis forense de relaciones |

> [!example] Flujo típico de investigación
> 1. **Attack story** → entender qué pasó a alto nivel.
> 2. **Alerts** → revisar la alerta de mayor severidad; leer el proceso tree / evidence.
> 3. **Entities** → ¿qué usuario o device es el paciente cero?
> 4. **Evidence & Response** → ¿hay archivos o URLs maliciosos confirmados?
> 5. **Investigations** → ¿AIR ya encontró algo más? ¿hay pending actions?
> 6. Tomar **response actions** → ver §4.
> 7. **Cerrar incidente** con clasificación → ver §5.

---

## 4. Respuesta y Remediación — Response Actions por Entidad

Dependiendo del tipo de entidad, el portal expone distintas acciones directamente desde la ficha del incidente o desde la entidad:

### Device (MDE)

| Acción | Descripción | Cuándo usarla |
|---|---|---|
| **Isolate device** | Corta toda conectividad de red excepto canal MDE | Contener un device comprometido activamente |
| **Run antivirus scan** | Lanza scan completo de Defender AV | Verificar limpieza |
| **Collect investigation package** | Descarga artefactos forenses (logs, memoria) | Análisis forense offline |
| **Restrict app execution** | Solo permite ejecutables firmados por Microsoft | Bloquear malware en ejecución |
| **Initiate live response** | Shell remota para análisis/remediación manual | Incidentes complejos |
| **Release from isolation** | Restaura conectividad | Tras confirmar limpieza |

### User / Identity (MDI + Entra ID)

| Acción | Descripción |
|---|---|
| **Disable user in AD** | Deshabilita la cuenta en Active Directory |
| **Force password reset** | Obliga cambio de contraseña en próximo logon |
| **Revoke Entra ID sessions** | Invalida todos los tokens de sesión activos |
| **Mark user as compromised** | Sube el user risk en Entra ID Protection |

### Email / Mailbox (MDO)

| Acción | Descripción |
|---|---|
| **Soft delete email** | Mueve a carpeta de elementos eliminados (recuperable) |
| **Hard delete email** | Eliminación permanente |
| **Move to junk** | Mueve a carpeta Junk del usuario |
| **Block sender** | Añade al tenant block list |

### File (MDE)

| Acción | Descripción |
|---|---|
| **Quarantine file** | Elimina el archivo de todos los devices del tenant donde se vea |
| **Add indicator** | Añade SHA-256/IP/URL/domain como IoC (Allow / Block / Audit) |
| **Stop and quarantine** | Detiene proceso en ejecución y pone en cuarentena el archivo |

> [!tip] Para el examen
> Pregunta frecuente: **"¿Qué acción tomas primero ante un device con ransomware activo?"** → **Isolate device** (contener antes de investigar). Separar siempre **contención** (isolate, disable user) de **erradicación** (quarantine file, AV scan) de **recuperación** (release from isolation).

> [!note] Enlace a CONCEPTOS_CLAVE
> El **Action Center** (aprobación de acciones AIR pendientes y log de acciones pasadas) y los **verdicts de AIR** (Malicious / Suspicious / No threats found) están cubiertos en [[CONCEPTOS_CLAVE]] §3 (ciclo XDR / AIR).

---

## 5. Incident Classification al Cerrar

Cuando resuelves un incidente, el portal exige una clasificación. Esto alimenta la mejora continua de detecciones:

| Clasificación | Cuándo usarla |
|---|---|
| **True Positive (TP)** | La amenaza era real; las alertas eran correctas |
| **False Positive (FP)** | No hubo amenaza; las alertas fueron incorrectas |
| **Benign True Positive** | Actividad real pero legítima (ej. pen test autorizado, admin tool) |
| **Undetermined** | No hay suficiente evidencia para decidir |

**Sub-clasificaciones de TP** (determinación de la amenaza):
- Phishing / Malware / Compromised account / Ransomware / Other…

> [!warning] Error común en el examen
> **"Benign True Positive"** NO es un False Positive. La detección fue correcta (la actividad ocurrió), pero la actividad era legítima. Ejemplo: un analista de seguridad ejecutó mimikatz en un laboratorio autorizado → la alerta es correcta (TP), pero la actividad es benigna.

> [!tip] Para el examen
> Clasificar incidentes correctamente reduce el **noise** futuro: FP bien marcados permiten al equipo crear **suppression rules** o ajustar políticas de detección sin eliminar la detección base.

---

## 6. KQL en Defender XDR — Advanced Hunting

Advanced Hunting (`security.microsoft.com/v2/advanced-hunting`) permite consultas KQL sobre 30 días de datos brutos del tenant.

### Tablas principales por workload

| Tabla | Workload | Qué contiene |
|---|---|---|
| `DeviceEvents` | MDE | Eventos genéricos de device (ASR, Firewall, etc.) |
| `DeviceProcessEvents` | MDE | Creación de procesos (cmd, powershell, etc.) |
| `DeviceNetworkEvents` | MDE | Conexiones de red iniciadas desde devices |
| `DeviceFileEvents` | MDE | Creación, modificación, eliminación de archivos |
| `DeviceRegistryEvents` | MDE | Cambios en el registro de Windows |
| `DeviceLogonEvents` | MDE | Logons locales e interactivos en devices |
| `EmailEvents` | MDO | Emails recibidos/enviados (metadata) |
| `EmailAttachmentInfo` | MDO | Adjuntos de email + hash SHA-256 |
| `EmailUrlInfo` | MDO | URLs extraídas de emails |
| `IdentityLogonEvents` | MDI | Autenticaciones AD / Entra ID |
| `IdentityQueryEvents` | MDI | Consultas LDAP, enumeración de AD |
| `CloudAppEvents` | MDCA | Actividad en apps cloud |
| `AlertInfo` | XDR | Metadata de alertas (AlertId, Title, Severity, Category) |
| `AlertEvidence` | XDR | Entidades vinculadas a alertas (device, user, file) |

> [!tip] Para el examen
> El examen pregunta **qué tabla usar** para un escenario dado. Memoriza: proceso → `DeviceProcessEvents`; red → `DeviceNetworkEvents`; email → `EmailEvents`; identidad AD → `IdentityLogonEvents`; correlacionar alerta con evidencia → `AlertInfo join AlertEvidence`.

### Queries de ejemplo

**1. Detectar ejecución de PowerShell con commandline sospechosa (encoded commands)**

```kql
DeviceProcessEvents
| where FileName =~ "powershell.exe"
| where ProcessCommandLine has_any ("-enc", "-encodedcommand", "-e ")
| project Timestamp, DeviceName, AccountName, ProcessCommandLine, InitiatingProcessFileName
| order by Timestamp desc
```

**2. Buscar emails con adjunto ejecutable recibidos en las últimas 24 h**

```kql
EmailAttachmentInfo
| where Timestamp > ago(24h)
| where FileType in ("exe", "bat", "ps1", "vbs", "js", "hta")
| join kind=inner (EmailEvents | where DeliveryAction != "Blocked") on NetworkMessageId
| project Timestamp, RecipientEmailAddress, FileName, FileType, SHA256, SenderFromAddress
| order by Timestamp desc
```

**3. Correlacionar alertas con el device y usuario afectado**

```kql
AlertInfo
| where Severity in ("High", "Medium")
| where Timestamp > ago(7d)
| join kind=leftouter AlertEvidence on AlertId
| where EntityType == "Machine" or EntityType == "User"
| project Timestamp, Title, Severity, Category, EntityType, EvidenceRole, AccountName, DeviceName
| order by Timestamp desc
```

> [!example] Cuándo usar `AlertInfo` vs tablas raw
> - `AlertInfo` + `AlertEvidence`: para correlacionar alertas con entidades; más rápido para triage.
> - Tablas raw (`DeviceProcessEvents`, etc.): para threat hunting proactivo sin alerta previa; más granular.

> [!note] Enlace a CONCEPTOS_CLAVE
> Operadores KQL avanzados (join, summarize, mv-expand), time operators y queries de Sentinel están en [[CHEATSHEET_KQL]]. La inteligencia de amenazas y IOCs en el contexto de hunting están en [[CONCEPTOS_CLAVE]] §2 (TI).

---

## 7. Integración Defender XDR ⇄ Microsoft Sentinel

Defender XDR y Sentinel pueden integrarse de dos formas:

### Modo One-way (clásico)

```
Defender XDR  ──[conector MDE/MDO/MDI/MDCA]──▶  Microsoft Sentinel
   (incidentes)                                    (incidentes + alertas)
```
- Los incidentes de Defender XDR se **replican** en Sentinel.
- Se gestionan en Sentinel (workspace de Log Analytics).
- Flujo unidireccional: cambios en Sentinel NO se sincronizan de vuelta.

### Modo Bi-directional (Unified SecOps Platform — recomendado)

```
Defender XDR  ◀──────────────────────────────▶  Microsoft Sentinel
  (portal unificado security.microsoft.com)         (onboarded)
```
- Sentinel se **onboardea** al portal unificado de Defender XDR.
- Los incidentes se sincronizan en **ambas direcciones**: cambios de estado, asignación y comentarios se reflejan en ambos sistemas.
- Los analistas trabajan desde `security.microsoft.com`; KQL de Sentinel accesible desde Advanced Hunting.
- Requiere: workspace de Sentinel en la misma tenant + rol adecuado.

| Aspecto | One-way | Bi-directional (Unified) |
|---|---|---|
| Portal de trabajo | Sentinel (portal separado) | security.microsoft.com |
| Sync de cambios | Solo Defender → Sentinel | Bidireccional |
| Advanced Hunting | Solo tablas XDR | XDR + tablas de Sentinel |
| Recomendado para | Entornos legacy / en migración | Nuevo despliegue / modernización |

> [!tip] Para el examen
> Si la pregunta menciona **"unified portal"** o **"analysts work in a single portal"**, la respuesta es el modo **bi-directional / Unified SecOps Platform**. Si menciona solo que Sentinel "ingiere" alertas de Defender, es el conector one-way.

---

## 8. RBAC — Unified RBAC de Defender XDR

El **Unified RBAC** de Defender XDR centraliza permisos para MDE, MDI, MDO y MDCA. Reemplaza los RBAC individuales heredados.

### Roles built-in relevantes para SOC

| Rol (Entra ID / M365 Defender) | Permisos clave |
|---|---|
| **Security Administrator** | Gestionar todas las configuraciones de seguridad; crear políticas |
| **Security Operator** | Investigar incidentes, tomar response actions; NO puede cambiar configuración global |
| **Security Reader** | Solo lectura: ver incidentes, alertas, reportes |
| **Global Administrator** | Control total (incluye seguridad); usar solo para emergencias |
| **Compliance Administrator** | Compliance center; no tiene acceso a incidentes de seguridad |

> [!warning] Principio de mínimo privilegio
> Para un analista SOC Tier 1, el rol correcto es **Security Operator**: puede investigar y responder sin poder modificar políticas de detección ni configuraciones globales. El examen puede preguntar qué rol asignar a un analista que "solo necesita investigar incidentes".

### Unified RBAC Custom Roles

Permite crear roles granulares combinando permisos de distintos workloads. Ejemplo:
- Role "SOC L1": `alerts.read` + `incidents.read` + `response.actions.manage` (solo para MDE).
- Role "SOC L2": lo anterior + `hunting.run` + `incidents.manage`.

> [!note] Enlace a CONCEPTOS_CLAVE
> Threat Intelligence (STIX/TAXII, TI platform connector, IOC management) está cubierto en [[CONCEPTOS_CLAVE]] §2 (TI).

---

## 📝 Module 1 — Exam Tips

> [!abstract] Tips de alto impacto para el examen SC-200

1. **AIR Verdicts y Action Center**: AIR produce tres veredictos: `Malicious`, `Suspicious`, `No threats found`. Las acciones derivadas de veredictos `Malicious` se aprueban (o rechazan) en el **Action Center** (`security.microsoft.com/action-center`). El analista SOC necesita el rol **Security Operator** para aprobar acciones pendientes en el Action Center.

2. **Custom Detection Rule vs. Analytics Rule**: Si la pregunta involucra **detección sobre datos de endpoint/identity/email dentro de Defender XDR con respuesta automática nativa** (isolate, quarantine), la respuesta es **Custom Detection Rule**. Si involucra datos externos, UEBA o Playbooks complejos, es **Analytics Rule de Sentinel**.

3. **Alert Tuning — no confundir con exclusiones de AV**: Alert Tuning suprime alertas en el portal unificado (nivel SOC/incidentes). Las exclusiones de Defender AV suprimen detecciones a nivel de motor AV en el endpoint. Son mecanismos distintos en distintas capas.

4. **Deception / Honeytokens**: Cualquier mención a "detectar movimiento lateral con mínimos falsos positivos" o "detectar acceso a cuentas señuelo" apunta a **Deception en Defender XDR**. Las interacciones con decoys tienen near-zero false positive rate por definición.

5. **DLP en el portal unificado**: Las alertas DLP de Microsoft Purview son visibles en `security.microsoft.com` pero las **políticas DLP se administran en `compliance.microsoft.com`** (Purview). El analista SOC las consume; el compliance officer las configura. Para **Endpoint DLP**, el device debe estar onboarded en MDE.

6. **MCRA como mapa mental del examen**: Cuando el escenario mencione múltiples capas de seguridad (identidad + endpoint + datos + cloud), usa MCRA mentalmente para mapear qué producto Microsoft cubre cada capa. El SC-200 evalúa si sabes qué herramienta usar en cada escenario.

7. **Threat Analytics vs. Threat Intelligence en Sentinel**: Threat Analytics (en XDR) es inteligencia operacional contextualizada al tenant + recomendaciones de hardening. El TI Platform connector de Sentinel ingesta IOCs externos (STIX/TAXII) para detecciones. Son complementarios, no equivalentes.

8. **Benign True Positive vs. False Positive**: Distinción crítica en preguntas de clasificación de incidentes. BTP = la detección fue correcta pero la actividad era legítima. FP = no hubo actividad maliciosa. Clasificar un pen test autorizado como FP es incorrecto — es BTP.

---

## 🎴 Flash Cards

| Concepto | Definición en una línea |
|---|---|
| **Defender XDR** | Plataforma SIEM+XDR unificada en `security.microsoft.com` que correlaciona señales de MDE, MDI, MDO, MDCA y MDVM |
| **MDE** | Defender for Endpoint: EDR para devices (Windows/macOS/Linux/móvil) |
| **MDI** | Defender for Identity: detección de ataques en AD on-prem (pass-the-hash, lateral movement) |
| **MDO** | Defender for Office 365: protección de email, Teams, SharePoint contra phishing y malware |
| **MDCA** | Defender for Cloud Apps: CASB; shadow IT, OAuth risky apps, impossible travel |
| **MDVM** | Defender Vulnerability Management: exposure score, CVEs, software inventory |
| **Incident** | Agrupación de alertas correlacionadas por el motor XDR sobre un mismo ataque |
| **Attack Story** | Vista principal de un incidente: gráfico de entidades + timeline + MITRE techniques |
| **Isolate device** | Response action que corta la red del device excepto el canal MDE (contención) |
| **True Positive** | Clasificación de cierre: amenaza real, alertas correctas |
| **Benign True Positive** | Actividad real detectada correctamente pero legítima (ej. pen test autorizado) |
| **Advanced Hunting** | Motor KQL sobre 30 días de datos brutos del tenant en el portal XDR |
| **DeviceProcessEvents** | Tabla KQL con creación de procesos en devices gestionados por MDE |
| **AlertInfo** | Tabla KQL con metadata de alertas generadas por el motor XDR |
| **One-way sync** | Incidentes de Defender XDR replicados a Sentinel sin sincronización de vuelta |
| **Bi-directional sync** | Unified SecOps Platform: Sentinel onboarded en portal XDR, sync total |
| **Security Operator** | Rol M365 para analistas SOC: investiga y responde, sin cambiar configuración global |
| **Unified RBAC** | Control de acceso centralizado para todos los workloads de Defender XDR |
| **Threat Analytics** | Módulo de TI operacional en XDR: threat reports contextualizados al tenant con exposure + recomendaciones |
| **Custom Detection Rule** | Regla de detección creada desde una Advanced Hunting query con response actions automáticas nativas |
| **Alert Tuning** | Reglas en el portal XDR para suprimir o ajustar alertas legítimas recurrentes y reducir ruido |
| **Deception / Honeytokens** | Decoy accounts, hosts y tokens falsos en Defender XDR para detectar lateral movement con alta fidelidad |
| **Endpoint DLP** | Microsoft Purview DLP extendido al endpoint via MDE: controla copia a USB, upload a cloud, impresión |
| **MCRA** | Microsoft Cybersecurity Reference Architecture: mapa de productos Microsoft a capas/escenarios de seguridad |
| **Action Center** | Hub en el portal XDR para aprobar/rechazar acciones AIR pendientes y revisar historial de acciones |
| **KQL** | Kusto Query Language: lenguaje de queries usado en Advanced Hunting y Microsoft Sentinel |
| **SC-200 passing score** | 700 / 1000 en escala de 100 a 1000 |

---

## ✅ Checklist SC-200 — Módulo 1

- [ ] Identificar qué producto Defender cubre cada workload (endpoint / identity / email / cloud apps / vulnerabilities)
- [ ] Explicar los key benefits de XDR sobre herramientas tradicionales (correlación, auto-healing, single pane of glass)
- [ ] Distinguir XDR vs. SIEM vs. EDR vs. antivirus en una tabla comparativa
- [ ] Describir qué es Threat Analytics y para qué sirve (exposure, impact, recommended actions)
- [ ] Explicar cómo el motor XDR correlaciona alertas en incidentes
- [ ] Navegar las tabs de un incidente: Attack story, Entities, Evidence & Response, Investigations
- [ ] Seleccionar la response action correcta según tipo de entidad (device, user, email, file)
- [ ] Clasificar incidentes al cierre (TP / FP / Benign TP / Undetermined)
- [ ] Distinguir cuándo usar cada tabla de Advanced Hunting por workload
- [ ] Escribir una query KQL básica en `DeviceProcessEvents` y `EmailAttachmentInfo`
- [ ] Crear una Custom Detection Rule desde una Advanced Hunting query (frecuencia, entidades, response actions)
- [ ] Diferenciar Custom Detection Rule (XDR) de Analytics Rule (Sentinel)
- [ ] Explicar Alert Tuning: cuándo usarlo y riesgo de blind spots
- [ ] Explicar Deception/honeytokens: qué son y por qué tienen bajo FP rate
- [ ] Describir Endpoint DLP y su dependencia de MDE onboarding
- [ ] Usar MCRA para mapear productos Microsoft a capas de seguridad
- [ ] Explicar diferencia entre integración one-way y bi-directional con Sentinel
- [ ] Identificar qué rol asignar a un analista SOC según el principio de mínimo privilegio
- [ ] Distinguir MDI (AD on-prem) de MDE (endpoint) para detecciones de identity
- [ ] Configurar un lab tenant M365 E5 y onboardear un device en MDE

---

## 🔗 Notas Relacionadas

- [[00_INDEX_Coursera_SC200]] — Índice general del curso con mapa de módulos
- [[00_INDEX_SC200]] — Índice del examen con datos oficiales (verificar discrepancias de duración e idioma)
- [[CONCEPTOS_CLAVE]] — §1 Attack Chain/Kill Chain · §2 Threat Intelligence · §3 Ciclo XDR / AIR / Action Center
- [[03_Semana3_Defender_XDR]] — Notas de semana 3 (sesiones en vivo)
- [[CHEATSHEET_KQL]] — Referencia rápida de operadores KQL, tablas y queries completas
- [[Modulo_2_Defender_for_Endpoint]] — Siguiente módulo: configuración y hardening de MDE
- [[Modulo_3_Sentinel]] — Sentinel: workspace, conectores, analytic rules

---

*Nota actualizada el 2026-06-22 | Lesson 1 — What is Microsoft Defender XDR? integrada desde transcripción del curso Coursera SC-200*
