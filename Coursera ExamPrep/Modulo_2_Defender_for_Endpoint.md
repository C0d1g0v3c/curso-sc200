---
tags: [sc-200, coursera, defender-endpoint, mde, edr, sintesis-curso]
fecha: 2026-06-22
ultima_actualizacion: 2026-06-22
estado: 🟢 Síntesis inicial (pendiente ajuste con transcripciones)
tipo: Síntesis de módulo
relacionado: "[[00_INDEX_Coursera_SC200]], [[Modulo_1_Defender_XDR]], [[CONCEPTOS_CLAVE]], [[CHEATSHEET_KQL]]"
---

# 💻 Módulo 2 — Microsoft Defender for Endpoint

> **Idea central:** MDE es la solución EDR de Microsoft que protege endpoints (Windows, macOS, Linux, iOS, Android) con detección y respuesta avanzada, reducción de superficie de ataque y gestión de vulnerabilidades — y se extiende a servidores on-prem y multicloud a través de Azure Arc, lo que lo convierte en el pilar de protección de dispositivos dentro de Microsoft Defender XDR.

---

## 1. ¿Qué es Microsoft Defender for Endpoint?

> [!note] Por qué importa para el SC-200
> MDE es uno de los productos más pesados del examen. Aparece en preguntas de onboarding, configuración de features avanzadas, hunting con KQL, y gestión de dispositivos no gestionados. Entenderlo a fondo es rentable.

MDE es una plataforma de seguridad de endpoints de tipo **EDR (Endpoint Detection and Response)** que combina:

| Capacidad | Descripción |
|-----------|-------------|
| **Next-Generation Antivirus (NGAV)** | Microsoft Defender Antivirus con protección en tiempo real, basada en comportamiento y cloud |
| **EDR** | Detección y respuesta a amenazas post-breach con telemetría de 6 meses |
| **Attack Surface Reduction (ASR)** | Reglas que bloquean comportamientos maliciosos comunes (macros, scripts, exploits) |
| **Threat & Vulnerability Management (TVM)** | Inventario de vulnerabilidades, configuraciones incorrectas y remediación priorizada |
| **Auto Investigation & Remediation (AIR)** | Investigación automática de alertas y remediación de amenazas |
| **Microsoft Threat Experts** | Servicio de expertos MDR on-demand (Endpoint Attack Notifications) |

### 1.1 Planes: MDE P1 vs P2

| Feature | Plan 1 (P1) | Plan 2 (P2) |
|---------|-------------|-------------|
| NGAV + ASR | ✅ | ✅ |
| Device control | ✅ | ✅ |
| EDR (detección post-breach) | ❌ | ✅ |
| Threat & Vulnerability Management | ❌ | ✅ |
| Auto Investigation & Remediation | ❌ | ✅ |
| Threat Experts / Attack Notifications | ❌ | ✅ |
| Sandbox analysis (detonación) | ❌ | ✅ |
| Live Response | ❌ | ✅ |
| Histórico de 6 meses de telemetría | ❌ | ✅ |

> [!tip] Para el examen
> P1 = protección proactiva (prevención). P2 = protección proactiva + detección/respuesta (prevención + investigación). Microsoft 365 E5 incluye P2. M365 E3 incluye P1. Defender for Business incluye una versión simplificada orientada a PyMEs.

---

## 2. Onboarding de Dispositivos

> [!note] Por qué importa para el SC-200
> El onboarding es el tema más preguntado de MDE. Debes saber qué método usar para cada plataforma/escenario y el rol de Azure Arc para servidores no-Azure.

### 2.1 Métodos de Onboarding

| Método | Cuándo usarlo | SO soportado |
|--------|---------------|--------------|
| **Local Script** | Pruebas, laboratorios, máquinas individuales (hasta 10 dispositivos) | Windows, macOS, Linux |
| **Group Policy (GPO)** | Entornos on-prem con Active Directory | Windows |
| **Microsoft Intune / Endpoint Manager** | Dispositivos gestionados con MDM en nube | Windows, macOS, iOS, Android |
| **Microsoft Endpoint Configuration Manager (SCCM/ConfigMgr)** | Entornos híbridos con ConfigMgr existente | Windows, Linux |
| **VDI Onboarding Script** | Infraestructuras de escritorio virtual (non-persistent VDI) | Windows |
| **Azure Arc** | Servidores on-prem, multicloud (AWS, GCP) no-Azure | Windows Server, Linux Server |

> [!tip] Para el examen
> - **Local Script** = solo para testing, no para producción a escala.
> - **GPO** = on-prem AD, no requiere Intune.
> - **Azure Arc** = el camino para servidores fuera de Azure. Habilita Defender for Servers sobre esos servidores.
> - Para VDI non-persistent existe un paquete específico que evita alertas duplicadas por imágenes clonadas.

### 2.2 Diagrama de Flujo: Onboarding con Azure Arc

```
Servidor On-Prem / Multicloud
        │
        ▼
  Instalar Azure Arc Agent
  (azcmagent connect --resource-group ... --tenant-id ...)
        │
        ▼
  Servidor aparece en Azure Resource Manager
  como recurso "Microsoft.HybridCompute/machines"
        │
        ▼
  Habilitar Defender for Servers (Plan 1 o 2)
  en Microsoft Defender for Cloud
        │
        ▼
  MDE agent se despliega automáticamente
  via Defender for Cloud / MMA o AMA extension
        │
        ▼
  Dispositivo aparece en Microsoft Defender XDR
  portal → Assets → Devices
```

> [!example]
> **Escenario típico de examen:** Empresa con 200 servidores Linux en AWS que necesitan visibilidad en Defender XDR. Solución: instalar Azure Arc agent en cada servidor → habilitarlos en Defender for Cloud → Defender for Servers P2 los incorpora a MDE automáticamente.

### 2.3 Defender for Servers: Plan 1 vs Plan 2

| Feature | Plan 1 | Plan 2 |
|---------|--------|--------|
| MDE P2 integrado | ✅ | ✅ |
| Evaluación de vulnerabilidades (Qualys / TVM) | ❌ | ✅ |
| Acceso JIT a VMs | ❌ | ✅ |
| Monitoreo de integridad de archivos (FIM) | ❌ | ✅ |
| Adaptive application controls | ❌ | ✅ |
| Network map | ❌ | ✅ |
| Threat intelligence integrada | Básica | Avanzada |

---

## 3. Features Avanzadas de MDE

> [!note] Por qué importa para el SC-200
> Esta sección del módulo cubre features que aparecen como opciones en preguntas de escenario. Debes saber qué hace cada una y cuándo activarla.

### 3.1 Restrict Correlation to Within Scoped Device Groups

- Limita la correlación de alertas para que los incidentes solo se formen con alertas del mismo **device group**.
- Útil en organizaciones con múltiples clientes (MSSPs) o BUs aisladas.
- Se configura en Settings → Microsoft Defender XDR → Incidents.

### 3.2 EDR in Block Mode

- Permite que MDE **bloquee activamente** artefactos maliciosos detectados por el sensor EDR, incluso cuando el antivirus primario **no es** Microsoft Defender Antivirus (ej. un AV de tercero es el primario).
- En modo normal, si el AV primario es de tercero, MDE opera solo en modo pasivo (detecta pero no bloquea).
- **EDR in Block Mode = MDE actúa como AV secundario con capacidad de remediación.**

> [!tip] Para el examen
> EDR in Block Mode solo aplica cuando hay un antivirus de tercero como primario. Si el primario es MDAV, este modo no es necesario. Muy preguntado en escenarios de migración o coexistencia.

### 3.3 Custom Network Indicators (IoCs)

- Permite definir listas de **IPs, URLs, dominios o certificados** que MDE debe bloquear, permitir o auditar.
- Va más allá de las listas de inteligencia de amenazas predefinidas.
- Se configura en Settings → Endpoints → Indicators.
- Requiere que **Network Protection** esté habilitada en el endpoint.

### 3.4 Tamper Protection

- Previene que actores maliciosos (o malware con privilegios elevados) **deshabiliten las protecciones de MDE** desde el endpoint:
  - No permite desactivar MDAV via PowerShell/Registry.
  - Bloquea cambios en la protección en tiempo real.
  - Bloquea modificación de exclusiones.
- Se puede gestionar via **Intune** (recomendado para empresas) o localmente.
- Cuando está habilitado, los cambios a la configuración de seguridad solo son posibles desde el portal de Defender o Intune.

> [!tip] Para el examen
> Si un escenario dice que el malware deshabilitó el AV antes de ejecutarse → Tamper Protection no estaba activada. La solución es habilitarla vía Intune para evitar que se desactive localmente.

### 3.5 Web Content Filtering

- Bloquea acceso a sitios web por **categoría** (ej. gambling, adult content, social media).
- No requiere proxy adicional; funciona a nivel de red en el endpoint con Network Protection.
- Se configuran **policies** que aplican a device groups.
- Categorías disponibles: Adult content, High bandwidth, Legal liability, Leisure, Uncategorized.

### 3.6 Live Response

- Consola de shell remota sobre un dispositivo desde el portal de Defender XDR.
- Permite: ejecutar scripts, subir/descargar archivos, correr comandos forenses, aislar procesos.
- Requiere MDE P2.
- Comandos relevantes:

```
run <scriptname>         # Ejecutar script desde librería
getfile <path>           # Descargar archivo del dispositivo
putfile <localpath>      # Subir archivo al dispositivo
remediate file <path>    # Poner en cuarentena un archivo
processes                # Listar procesos activos
connections              # Ver conexiones de red activas
```

> [!tip] Para el examen
> Live Response = investigación forense remota en vivo. No confundir con **Automated Investigation** (automática) ni con **Device Isolation** (corta red pero no da acceso a shell).

### 3.7 Attack Notifications (Microsoft Threat Experts / Endpoint Attack Notifications)

- Servicio **Endpoint Attack Notifications (EAN)**: analistas de Microsoft notifican proactivamente sobre ataques sofisticados detectados en el tenant.
- Reemplazó al anterior "Targeted Attack Notifications".
- Complementario: **Experts on Demand** permite consultar a expertos de Microsoft en incidentes específicos (requiere suscripción adicional).
- Se activa en Settings → Endpoints → Advanced features → Endpoint Attack Notifications.

---

## 4. Attack Surface Reduction (ASR) Rules

### 4.1 Modos de ASR

| Modo | Comportamiento |
|------|---------------|
| **Audit** | Registra eventos sin bloquear — ideal para fase de evaluación |
| **Block** | Bloquea la acción y genera alerta |
| **Warn** | Bloquea + muestra advertencia al usuario con opción de override |
| **Disabled** | Regla inactiva |

> [!tip] Para el examen
> El flujo correcto de despliegue es: **Audit primero** → analizar falsos positivos → **Block**. Nunca activar en Block directamente en producción sin auditar.

### 4.2 Reglas ASR Importantes (para el examen)

| Regla | GUID (parcial) | Qué bloquea |
|-------|----------------|-------------|
| Block Office apps from creating executable content | `3b576869...` | Office creando .exe, .dll |
| Block all Office apps from creating child processes | `d4f940ab...` | Evita shell desde Word/Excel |
| Block credential stealing from LSASS | `9e6c4e1f...` | Mimikatz-style attacks |
| Block executable content from email/webmail | `be9ba2d9...` | Malware via email |
| Block untrusted/unsigned processes from USB | `b2b3f03d...` | Ataques via USB |
| Use advanced protection against ransomware | `c1db55ab...` | Comportamiento ransomware |
| Block abuse of exploited vulnerable signed drivers | `56a863a9...` | BYOVD attacks |

> [!example]
> Si una pregunta menciona que los usuarios reciben Office y crean macros que descargan payloads → la regla "Block Office apps from creating executable content" o "Block Office apps from creating child processes" es la respuesta.

---

## 5. Unmanaged Devices — Device Discovery

> [!note] Por qué importa para el SC-200
> Defender XDR puede descubrir dispositivos en la red que NO están onboardeados a MDE. Esta visibilidad es el primer paso para llevarlos a un marco gestionado.

### 5.1 Modos de Device Discovery

| Modo | Comportamiento | Cuándo usarlo |
|------|---------------|---------------|
| **Standard Discovery** (recomendado) | Los dispositivos onboardeados a MDE sondean activamente la red (multicast, ARP, Bonjour) para descubrir vecinos | Organizaciones que quieren visibilidad completa de la red |
| **Basic Discovery** | Solo escucha tráfico pasivo que llega a los dispositivos MDE, sin sondeo activo | Entornos sensibles donde el sondeo activo puede causar problemas |

> [!tip] Para el examen
> **Standard = activo** (genera tráfico de descubrimiento). **Basic = pasivo** (no genera tráfico adicional). En entornos OT/IoT o redes críticas se prefiere Basic para evitar interrupciones.

### 5.2 Authenticated Scans

- Para dispositivos **que no son Windows** (impresoras de red, switches, routers, NAS, dispositivos IoT/OT) que no pueden tener el agente MDE:
- Se configura un **scanner** (un dispositivo Windows con MDE ya onboardeado) que realiza scans autenticados usando credenciales SNMP o WinRM.
- El resultado aparece en el inventario de dispositivos de Defender XDR con información de vulnerabilidades.
- Se configura en Settings → Device Discovery → Authenticated scans.

> [!tip] Para el examen
> Authenticated scans = para dispositivos de red y no-Windows que NO pueden instalar el agente MDE. El scanner es un Windows con MDE que actúa como proxy de escaneo. Muy preguntado.

### 5.3 Exclusiones de Discovery

- Se pueden excluir rangos IP o subnets del descubrimiento para evitar falsos positivos o ruido.
- Settings → Device Discovery → Exclusions.

### 5.4 Medidas Proactivas para Endpoints No Gestionados

```
Dispositivo descubierto (unmanaged)
        │
        ▼
  Clasificar: ¿Es Windows? ¿Es servidor? ¿Es IoT/OT?
        │
   ┌────┴────┐
   ▼         ▼
Windows    Network device / IoT
   │              │
Onboardear   Authenticated Scan
vía GPO /    + monitoreo pasivo
Intune /     + segmentación de red
ConfigMgr
        │
        ▼
  Aparece como "Managed" en inventario
```

---

## 6. Device Groups, Permisos y Automation Levels

> Ver también: [[CONCEPTOS_CLAVE]] §3.3.2 para la tabla completa.

### 6.1 Device Groups (Grupos de Dispositivos)

- Permiten segmentar el inventario de dispositivos para aplicar:
  - Políticas de remediación diferenciadas.
  - Permisos de acceso por equipo (RBAC).
  - Configuraciones de onboarding específicas.
- Se definen en Settings → Endpoints → Device groups.
- Un dispositivo puede pertenecer a **un solo grupo** (se usa el primero que coincida, por prioridad).

### 6.2 Automation Levels (Niveles de Automatización)

| Nivel | Comportamiento |
|-------|---------------|
| **Full — remediate threats automatically** | AIR remedia automáticamente todas las amenazas detectadas |
| **Semi — require approval for all remediations** | Toda remediación requiere aprobación manual del analista |
| **Semi — require approval for non-temp folders** | Auto-remediación solo en carpetas temporales; el resto requiere aprobación |
| **Semi — require approval for core folders** | Auto-remediación excepto en carpetas del sistema (Windows, Program Files) |
| **No automated response** | Solo detección, sin remediación automática |

> [!tip] Para el examen
> Para organizaciones maduras con SOC dedicado → Full automation. Para entornos críticos o regulados → Semi con aprobación manual. El nivel se configura por **device group**, no globalmente.

---

## 7. KQL Hunting en MDE

> Ver también: [[CHEATSHEET_KQL]] para queries completas.

### 7.1 Tablas Principales de MDE en Advanced Hunting

| Tabla | Contenido |
|-------|-----------|
| `DeviceInfo` | Inventario de dispositivos: SO, hostname, IP, estado de onboarding, nivel de riesgo |
| `DeviceNetworkInfo` | Interfaces de red, IPs, MACs por dispositivo |
| `DeviceProcessEvents` | Procesos iniciados, con cmdline, hash, parent process |
| `DeviceNetworkEvents` | Conexiones de red: IP destino, puerto, protocolo, proceso |
| `DeviceFileEvents` | Creación, modificación, borrado de archivos |
| `DeviceRegistryEvents` | Cambios en el registro de Windows |
| `DeviceLogonEvents` | Inicios de sesión locales, remote, etc. |
| `DeviceTvmSoftwareInventory` | Software instalado por dispositivo (TVM) |
| `DeviceTvmSoftwareVulnerabilities` | CVEs por dispositivo y software (TVM) |

### 7.2 Queries de Ejemplo

**Dispositivos onboardeados con nivel de riesgo alto:**

```kql
DeviceInfo
| where Timestamp > ago(1d)
| where RiskScore == "High"
| summarize arg_max(Timestamp, *) by DeviceId
| project DeviceName, OSPlatform, RiskScore, ExposureLevel, OnboardingStatus
| order by RiskScore desc
```

**Conexiones salientes a puertos inusuales desde dispositivos MDE:**

```kql
DeviceNetworkEvents
| where Timestamp > ago(1h)
| where ActionType == "ConnectionSuccess"
| where RemotePort !in (80, 443, 53, 22, 3389)
| summarize count() by DeviceName, RemoteIP, RemotePort
| where count_ > 10
| order by count_ desc
```

**Inventario de software vulnerable (TVM):**

```kql
DeviceTvmSoftwareInventory
| where SoftwareName contains "log4j"
| join kind=leftouter DeviceTvmSoftwareVulnerabilities
    on DeviceId, SoftwareName, SoftwareVersion
| project DeviceName, SoftwareName, SoftwareVersion, CveId, VulnerabilitySeverityLevel
| order by VulnerabilitySeverityLevel desc
```

---

## 8. Integración MDE → Defender XDR

- MDE es uno de los **workloads de señal** de Defender XDR.
- Las alertas de MDE se correlacionan con alertas de MDO, MDI, MDA para formar **incidentes unificados**.
- El portal unificado (`security.microsoft.com`) centraliza:
  - Gestión de dispositivos (Assets → Devices).
  - Advanced Hunting con tablas de todos los productos.
  - Incidents que correlacionan endpoints + identidades + email + cloud apps.

> [!warning]
> Defender for Endpoint tiene su propio portal legacy (`security.microsoft.com/mde`) pero el examen asume el portal unificado de Defender XDR. Algunas configuraciones granulares aún viven en Settings → Endpoints dentro del portal unificado.

---

## 🎴 Flash Cards

| Pregunta | Respuesta |
|----------|-----------|
| ¿Qué habilita EDR in Block Mode? | MDE bloquea activamente aunque el AV primario sea de tercero (modo pasivo → activo) |
| ¿Cuál es el método de onboarding para servidores AWS? | Azure Arc Agent → Defender for Cloud → Defender for Servers |
| ¿Qué hace Tamper Protection? | Impide que malware o usuarios deshabiliten MDAV/MDE localmente |
| ¿Cuál es la diferencia entre Standard y Basic Discovery? | Standard = sondeo activo; Basic = escucha pasiva únicamente |
| ¿Para qué sirven los Authenticated Scans? | Escanear dispositivos no-Windows / de red que no pueden instalar el agente MDE |
| ¿Qué modo ASR usar antes de aplicar Block en producción? | Audit mode, para evaluar falsos positivos |
| ¿Qué requiere Live Response? | MDE Plan 2 |
| ¿Qué tabla KQL tiene el inventario de CVEs por dispositivo? | `DeviceTvmSoftwareVulnerabilities` |
| ¿Qué son Endpoint Attack Notifications? | Alertas proactivas de analistas de Microsoft sobre ataques sofisticados detectados en el tenant |
| ¿Cuándo aplica el automation level "Full"? | Cuando AIR debe remediar automáticamente sin aprobación manual |
| ¿Diferencia MDE P1 vs P2? | P1 = prevención (NGAV, ASR, device control); P2 = P1 + EDR, TVM, AIR, Live Response |
| ¿Qué ocurre si onboardeas via Local Script más de 10 dispositivos? | No está soportado para producción — es solo para testing/labs |

---

## ✅ Checklist SC-200 — Módulo 2

- [ ] Sé explicar qué incluye MDE P1 vs P2 y cuándo aplica cada uno
- [ ] Conozco todos los métodos de onboarding y el escenario de uso de cada uno
- [ ] Entiendo el rol de Azure Arc para servidores no-Azure
- [ ] Puedo distinguir Defender for Servers P1 vs P2
- [ ] Sé cuándo y por qué activar EDR in Block Mode
- [ ] Entiendo qué protege Tamper Protection y cómo se gestiona
- [ ] Conozco los modos de ASR (Audit/Block/Warn) y el flujo de despliegue correcto
- [ ] Sé la diferencia entre Standard Discovery y Basic Discovery
- [ ] Entiendo qué son los Authenticated Scans y para qué dispositivos aplican
- [ ] Conozco las tablas principales de MDE en Advanced Hunting
- [ ] Puedo escribir una query básica en `DeviceInfo` y `DeviceTvmSoftwareInventory`
- [ ] Sé qué son los Automation Levels y cómo se configuran por device group
- [ ] Entiendo qué ofrece Live Response y que requiere P2
- [ ] Conozco Web Content Filtering y Custom Network Indicators

---

## 🔗 Notas Relacionadas

- [[00_INDEX_Coursera_SC200]] — Índice general del curso
- [[Modulo_1_Defender_XDR]] — Módulo anterior: arquitectura XDR y correlación
- [[CONCEPTOS_CLAVE]] — Glosario y definiciones clave (§3.3.2 para device groups)
- [[CHEATSHEET_KQL]] — Queries completas de MDE, MDI, MDO
- [[Modulo_3_Defender_for_Identity]] — Siguiente módulo (MDI)

---

*Nota creada el 2026-06-22 | Síntesis Coursera SC-200 — Módulo 2*
