---
tags: [sc-200, coursera, security-copilot, ai-security, sintesis-curso]
fecha: 2026-06-22
ultima_actualizacion: 2026-06-22
estado: 🟢 Síntesis inicial (pendiente ajuste con transcripciones)
tipo: Síntesis de módulo
relacionado: "[[00_INDEX_Coursera_SC200]], [[Modulo_1_Defender_XDR]], [[Modulo_3_Sentinel]], [[07_Fundamentals_AI_Security]]"
---

# 🤖 Módulo 6 — Microsoft Security Copilot

> **Idea central:** Microsoft Security Copilot es un asistente de seguridad generativo (GenAI) que combina los modelos de OpenAI (GPT-4) con modelos propietarios de inteligencia de seguridad de Microsoft, diseñado para amplificar la capacidad del analista de SecOps: acelera investigaciones, genera KQL, interpreta scripts maliciosos y automatiza respuestas — todo dentro del contexto de los productos de seguridad de Microsoft que ya uses.

---

## 1. ¿Qué es Microsoft Security Copilot?

> [!note] Por qué importa para el SC-200
> El SC-200 evalúa si conoces las **dos experiencias** (embedded vs standalone), los **plugins**, los **promptbooks**, el modelo de **permisos RBAC** y las métricas de coste (**SCUs**). No basta con saber que "es una IA"; el examen profundiza en cómo se integra con Defender XDR y Sentinel.

Microsoft Security Copilot es un producto de seguridad impulsado por IA generativa que:

- Está basado en **GPT-4 (OpenAI)** combinado con modelos de seguridad exclusivos de Microsoft que consumen señales de **65 billones de señales de amenaza diarias** del ecosistema Microsoft.
- Orientado a **Security Operations (SecOps)**: analistas Tier 1–3, threat hunters, equipos de respuesta a incidentes.
- Se presenta en **dos experiencias**:

| Experiencia | Dónde se usa | Cuándo usarla |
|---|---|---|
| **Embedded** | Dentro de Defender XDR, Microsoft Sentinel, Intune, Entra ID | Contexto inline, sin salir del producto; ideal para workflows diarios |
| **Standalone** | Portal dedicado (`securitycopilot.microsoft.com`) | Investigaciones complejas, uso de múltiples plugins simultáneos, promptbooks |

---

## 2. Arquitectura de Security Copilot

```
┌───────────────────────────────────────────────────────────┐
│                      ANALISTA / USUARIO                    │
│              (escribe un prompt en lenguaje natural)       │
└─────────────────────────┬─────────────────────────────────┘
                          │  Prompt
                          ▼
┌─────────────────────────────────────────────────────────────┐
│               PROMPT ORCHESTRATOR (núcleo)                  │
│  - Interpreta la intención del prompt                       │
│  - Decide qué plugins invocar                               │
│  - Orquesta llamadas paralelas/secuenciales a plugins       │
│  - Agrega y sintetiza las respuestas                        │
└──────┬─────────────────┬──────────────────┬────────────────┘
       │                 │                  │
       ▼                 ▼                  ▼
┌─────────────┐  ┌──────────────┐  ┌──────────────────────┐
│ LLM (GPT-4) │  │  Plugins     │  │  Knowledge Base      │
│ + modelos   │  │  Microsoft   │  │  Microsoft Security  │
│  Microsoft  │  │  third-party │  │  Graph / MDTI        │
└─────────────┘  │  custom      │  └──────────────────────┘
                 │  files/webs  │
                 └──────────────┘
                          │
                          ▼
              ┌───────────────────────┐
              │   RESPUESTA           │
              │ (texto, tabla, KQL,   │
              │  script analizado,    │
              │  informe de incidente)│
              └───────────────────────┘
```

**Flujo resumido:** El prompt del analista llega al **Prompt Orchestrator**, que lo desglosa, consulta los **plugins** relevantes (p.ej. Defender XDR para datos del incidente + MDTI para threat intel), llama al **LLM** para razonamiento y síntesis, y devuelve una respuesta contextualizada.

---

## 3. Plugins — El corazón de la extensibilidad

> [!example] Ejemplo de orquestación multi-plugin
> Prompt: *"Resume el incidente #4521 y dime si el dominio encontrado tiene reputación conocida"*
> El orchestrator invoca simultáneamente **Defender XDR** (para el incidente) + **MDTI** (para reputación del dominio) y fusiona la respuesta.

### 3.1 Plugins Microsoft (built-in)

| Plugin | Qué aporta |
|---|---|
| **Microsoft Defender XDR** | Incidentes, alertas, dispositivos, usuarios, hunting avanzado |
| **Microsoft Sentinel** | Logs, workbooks, reglas analíticas, incidents de Sentinel |
| **Microsoft Intune** | Estado de dispositivos, cumplimiento, configuración MDM |
| **Microsoft Entra ID** | Usuarios, grupos, sign-ins, risky users, apps registradas |
| **Microsoft Defender Threat Intelligence (MDTI)** | Reputación de IPs/dominios, indicadores de amenaza (IoCs), actor profiles |
| **Microsoft Defender for Cloud** | Recomendaciones de seguridad en Azure, alertas cloud |
| **Microsoft Purview** | Datos sensibles, compliance, DLP |
| **Azure Firewall** | Logs de red, reglas de firewall |
| **Natural Language to KQL** | Genera consultas KQL desde lenguaje natural para Sentinel/Defender |

### 3.2 Plugins de terceros (third-party)

- Instalables desde el **plugin marketplace**
- Ejemplos: CrowdStrike, Splunk, ServiceNow, VirusTotal
- Se integran vía **OpenAPI spec** o conectores certificados

### 3.3 Plugins personalizados (custom)

- Creados por la organización
- Basados en **OpenAPI 3.0 spec** (JSON/YAML) o **Logic Apps**
- Permiten conectar APIs internas, SIEMs propios, bases de datos corporativas

### 3.4 Files y Websites

- **Files**: sube ficheros (PDFs, TXT, logs, scripts) directamente al contexto de Copilot para que los analice
- **Websites**: conecta URLs públicas como fuente de contexto adicional

### 3.5 Gestión de plugins

- Los **Copilot Owners** pueden habilitar/deshabilitar plugins para toda la organización
- Los **Copilot Contributors** sólo pueden activar plugins a nivel personal (si el owner lo permite)
- Principio de **least privilege**: Copilot sólo accede a los datos a los que el usuario ya tiene permisos en cada producto — nunca eleva privilegios

---

## 4. Promptbooks — Automatización de workflows repetibles

> [!tip] Para el examen
> Un **Promptbook** es una secuencia de prompts predefinidos que se ejecutan en cadena. Recuerda la diferencia: un **prompt único** resuelve una consulta puntual; un **promptbook** automatiza una investigación multi-paso completa (p.ej. triage de incidente de 6 pasos en un clic).

- Son **secuencias de prompts reutilizables** que se ejecutan en orden para tareas repetibles
- Ejemplos de uso:
  - Investigación completa de un incidente (resumen → IoCs → KQL → remediación → reporte)
  - Análisis de usuario sospechoso (sign-ins → risky detections → lateral movement → recomendación)
  - Triage de alerta de phishing (email → URL → attachment → veredicto)
- Se pueden compartir entre analistas del equipo
- Disponibles en la biblioteca de promptbooks de Microsoft o creados desde cero
- Admiten **variables de entrada** (p.ej. `{{incidentId}}`) para parametrizarlos

---

## 5. Casos de uso clave para el analista SC-200

### 5.1 Incident Summarization
- Copilot lee todos los eventos, alertas y entidades de un incidente y genera un **resumen ejecutivo** en segundos
- Incluye: cronología del ataque, entidades afectadas (usuarios, dispositivos, IPs), técnicas MITRE ATT&CK detectadas
- **Embedded en Defender XDR**: botón "Summarize with Copilot" en la vista del incidente

### 5.2 KQL Query Assistance
- **Generación**: "Escribe una KQL query para encontrar todos los sign-ins fallidos de un usuario externo en las últimas 24h"
- **Explicación**: pega una KQL existente y Copilot la explica línea a línea en lenguaje natural
- **Optimización**: sugiere mejoras de rendimiento o correcciones de sintaxis
- Funciona con **Sentinel** (Log Analytics) y **Defender Advanced Hunting**

### 5.3 Script Analysis (Reverse Engineering)
- Pega un script PowerShell, Python, Bash o código obfuscado
- Copilot explica qué hace el script, identifica comportamientos maliciosos, mapea a técnicas MITRE
- Crucial para análisis de malware sin necesidad de entorno sandbox dedicado

### 5.4 Threat Intelligence Enrichment
- Enriquece IoCs (IPs, dominios, hashes) con datos de **MDTI** automáticamente
- Responde: "¿Este dominio es conocido?", "¿Qué actor lo usa?", "¿Hay CVEs relacionados?"

### 5.5 Incident Report Generation
- Genera reportes formales post-incidente listos para stakeholders (resumen ejecutivo + detalles técnicos)
- Ahorra horas de trabajo manual de documentación

### 5.6 Guided Response
- Sugiere **pasos de remediación** contextualizados al incidente específico
- Ejemplos: "Aisla el dispositivo comprometido", "Revoca la sesión del usuario", "Bloquea estos IoCs en Defender"

> [!example] Flujo completo de investigación con Copilot
> 1. Alerta en Defender XDR → Copilot resume el incidente automáticamente
> 2. Analista pregunta: "¿Qué técnicas MITRE usó el atacante?"
> 3. Copilot enriquece con MDTI: "Este dominio está asociado al grupo APT29"
> 4. Analista: "Genera una KQL para buscar actividad similar en los últimos 7 días"
> 5. Copilot genera la query, analista la ejecuta en Advanced Hunting
> 6. Analista ejecuta promptbook "Incident Report" → reporte listo en 2 minutos

---

## 6. Capacity & Cost Monitoring — Security Compute Units (SCUs)

> [!warning] Punto importante para el examen
> Las **SCUs** son la unidad de coste de Copilot. El SC-200 puede preguntarte qué son y cómo se monitorizan. No son licencias de usuario: es **capacidad provisionada** que se comparte entre todos los usuarios de la organización.

### Modelo de costes

| Concepto | Detalle |
|---|---|
| **SCU (Security Compute Unit)** | Unidad de medida de capacidad de procesamiento de Copilot |
| **Provisioned Capacity** | Se compra en bloques de SCUs por hora; capacidad reservada para la organización |
| **Usage-based** | Alternativa: pago por uso sin reserva previa |
| **Compartición** | Las SCUs provisionadas se comparten entre todos los usuarios del tenant |

### Monitoreo de uso

- Desde el **portal de Security Copilot → Settings → Usage Monitoring**
- Métricas disponibles: SCUs consumidas por periodo, distribución por usuario, distribución por plugin
- Alertas configurables si se supera un umbral de consumo
- Los **Copilot Owners** son los responsables de monitorear y ajustar la capacidad

---

## 7. Permissions & RBAC

### Roles de Security Copilot

| Rol | Permisos |
|---|---|
| **Copilot Owner** | Configura la capacidad, gestiona plugins (habilitar/deshabilitar a nivel org), accede a usage monitoring, puede compartir promptbooks |
| **Copilot Contributor** | Usa Copilot (prompts, promptbooks), puede habilitar plugins sólo a nivel personal (si el owner lo permite) |

### Principio fundamental de acceso

> [!warning] Regla crítica — No elevation of privilege
> **Copilot no escala privilegios.** Si un analista no tiene acceso a un incidente en Defender XDR, Copilot tampoco podrá mostrarle esa información aunque se lo pida. Cada plugin respeta los permisos del usuario en el producto subyacente.

- Los permisos de Copilot se **suman** a los permisos de Microsoft 365 / Azure existentes del usuario
- Para usar Copilot con Sentinel: el usuario necesita permisos en el workspace de Sentinel
- Para usar Copilot con Defender XDR: el usuario necesita rol en Defender (p.ej. Security Reader, Security Operator)

---

## 8. Seguridad, Privacidad y Data Residency

- **Los datos del cliente NO se usan para entrenar los modelos foundacionales** (GPT-4 ni modelos Microsoft)
- Los prompts y respuestas son procesados dentro del **Microsoft Azure trust boundary**
- **Data residency**: los datos se procesan en la región geográfica configurada (UE, US, etc.)
- Copilot cumple con los compromisos de privacidad de Microsoft 365 y Azure
- Auditoría: todos los prompts y respuestas quedan registrados en los **audit logs** del tenant

---

## 9. Best Practices para usar Security Copilot

### Prompting efectivo

| Práctica | Ejemplo |
|---|---|
| **Ser específico** | "Resume el incidente #4521 incluyendo las técnicas MITRE identificadas" vs "dime qué pasó" |
| **Dar contexto** | "El usuario john@empresa.com ha sido marcado como risky. Analiza sus últimos sign-ins y actividad de correo" |
| **Iterar** | Si la respuesta es incompleta, refina el prompt: "Amplía el análisis de lateral movement" |
| **Usar variables** | En promptbooks, usa `{{incidentId}}` para hacerlos reutilizables |

### Gestión de plugins

- Habilita sólo los plugins necesarios (reduce superficie de exposición y coste de SCUs)
- Revisa periódicamente los plugins de terceros habilitados
- Para plugins custom, revisa la OpenAPI spec antes de desplegar en producción

### File Handling

- Sube archivos de logs o scripts directamente para análisis contextual
- Limita los archivos a lo relevante para la investigación (no suba dumps completos innecesariamente)
- Los archivos son temporales en la sesión; no persisten entre conversaciones

### Conectar fuentes de datos

- Asegúrate de que los **connectors de Sentinel** estén activos para maximizar el contexto disponible
- Configura los **data connectors** en Sentinel antes de esperar resultados de Copilot sobre esos logs
- Más datos conectados = respuestas más contextualizadas

---

## 10. Demos típicas (conocimiento práctico para el examen)

### Demo 1: Análisis de incidente
1. Abrir un incidente en **Microsoft Defender XDR**
2. Click en **"Summarize with Copilot"** (experiencia embedded)
3. Copilot genera: resumen del ataque, entidades afectadas, técnicas MITRE, puntuación de severidad
4. Preguntar: "¿Cuál es el primer punto de entrada?"
5. Solicitar pasos de remediación guiados

### Demo 2: Detección de amenaza / KQL
1. En **Microsoft Sentinel**, ir a Advanced Hunting o Logs
2. En el panel de Copilot embedded: "Escribe una query para detectar exfiltración de datos por DNS tunneling"
3. Copilot genera la KQL con comentarios explicativos
4. Ejecutar la query y analizar resultados

### Demo 3: Investigación de riesgo (usuario comprometido)
1. En **Microsoft Entra ID**, navegar a un usuario marcado como "risky"
2. Copilot embedded: "Analiza por qué este usuario fue marcado como risky y qué acciones recomiendas"
3. Copilot agrega: sign-in logs, impossible travel detection, MFA anomalies, recomendaciones de remediación

---

## 11. Career Pathways en AI-Driven Cybersecurity

El módulo menciona que Security Copilot representa un cambio de paradigma en las carreras de ciberseguridad:

- Los analistas que dominan el **prompting efectivo** se vuelven más productivos que sus pares
- Nuevos roles emergentes: **AI Security Analyst**, **SecOps Prompt Engineer**, **AI Security Architect**
- La certificación SC-200 posiciona al profesional en la intersección de **seguridad + IA generativa**
- Microsoft espera que Copilot reduzca el tiempo de triage de incidentes de horas a minutos, liberando a los analistas para tareas de mayor valor

---

## 🎴 Flash Cards

**P: ¿Cuáles son las dos experiencias de Security Copilot?**
R: **Embedded** (dentro de Defender XDR, Sentinel, Intune, Entra) y **Standalone** (portal `securitycopilot.microsoft.com`).

**P: ¿Qué es un Promptbook?**
R: Una secuencia de prompts predefinidos y reutilizables que se ejecutan en cadena para automatizar una tarea de investigación completa (p.ej. triage de incidente de múltiples pasos).

**P: ¿Qué es una SCU?**
R: **Security Compute Unit** — unidad de medida de capacidad de procesamiento de Copilot. Se compra como capacidad provisionada (por hora) compartida entre todos los usuarios del tenant.

**P: ¿Copilot puede mostrar datos a un analista que no tiene permisos en Defender XDR?**
R: **No.** Copilot respeta los permisos del usuario en cada producto subyacente — nunca eleva privilegios.

**P: ¿Quién puede habilitar plugins para toda la organización?**
R: El **Copilot Owner**. El Copilot Contributor sólo puede activar plugins a nivel personal (si el owner lo permite).

**P: ¿Los datos del cliente se usan para entrenar el modelo GPT-4?**
R: **No.** Los datos del cliente no entrenan modelos foundacionales. Se procesan dentro del Azure trust boundary.

**P: Nombra 4 plugins Microsoft built-in de Security Copilot.**
R: Defender XDR, Microsoft Sentinel, Microsoft Entra ID, Microsoft Defender Threat Intelligence (MDTI). (También: Intune, Defender for Cloud, Purview, Azure Firewall.)

**P: ¿Qué hace la capacidad de "Script Analysis" de Copilot?**
R: Analiza scripts obfuscados o maliciosos (PowerShell, Python, Bash, etc.), explica su comportamiento en lenguaje natural y mapea las técnicas a MITRE ATT&CK.

**P: ¿Dónde se monitoriza el uso de SCUs?**
R: En el portal de Security Copilot → **Settings → Usage Monitoring** (acceso reservado a Copilot Owners).

**P: ¿Qué componente del arquitectura decide qué plugins invocar ante un prompt?**
R: El **Prompt Orchestrator**.

---

## ✅ Checklist SC-200 — Módulo 6

- [ ] Diferencio **Embedded experience** vs **Standalone experience** y sé cuándo usar cada una
- [ ] Conozco el flujo: **prompt → prompt orchestrator → plugins / LLM → respuesta**
- [ ] Sé qué plugins Microsoft existen (Defender XDR, Sentinel, Intune, Entra, MDTI, Defender for Cloud)
- [ ] Entiendo qué son los **plugins custom** (OpenAPI 3.0 spec) y cómo se gestionan
- [ ] Sé qué es un **Promptbook** y cómo difiere de un prompt único
- [ ] Conozco los casos de uso: incident summarization, KQL assistance, script analysis, threat intel enrichment, incident report, guided response
- [ ] Entiendo el modelo de costes: **SCUs**, provisioned capacity, usage monitoring
- [ ] Distingo los roles **Copilot Owner** vs **Copilot Contributor** y sus permisos
- [ ] Comprendo el principio de **no elevation of privilege** de Copilot
- [ ] Sé que los datos del cliente **no entrenan** los modelos foundacionales
- [ ] Conozco las **best practices de prompting** (ser específico, dar contexto, iterar)
- [ ] He revisado los demos prácticos (incident analysis, KQL generation, risky user investigation)

---

## 🔗 Notas Relacionadas

- [[00_INDEX_Coursera_SC200]] — Índice general del curso
- [[Modulo_1_Defender_XDR]] — Plataforma principal donde vive la experiencia embedded de Copilot
- [[Modulo_3_Sentinel]] — Sentinel como fuente de datos clave para Copilot (KQL, logs, incidentes)
- [[07_Fundamentals_AI_Security]] — Fundamentos de IA aplicada a seguridad
- [[MITRE_ATT&CK]] — Framework de técnicas que Copilot mapea automáticamente
- [[KQL_Cheatsheet]] — Referencia de KQL que Copilot puede generar y explicar

---

*Nota creada el 2026-06-22 | Síntesis Coursera SC-200 — Módulo 6*
