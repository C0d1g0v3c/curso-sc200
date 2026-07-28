---
tags: [sc-200, sentinel, leccion-diaria, ingestion, ama, dcr, wef]
dia: 2
fecha: 2026-07-08
dominio: "Dominio 1 — Manage a security operations environment (40-45%)"
estado: ✅ Completada
cover: ""
---

# Lección Día 2 — Ingestión 1: AMA, DCR, Windows Security Events y WEF

> [!info] Contexto
> Día 2 del plan de [[GUIA_INTENSIVA_24_DIAS]] (dominio 1, 40–45% del examen). Tema de hoy: cómo llegan los eventos de Windows a Microsoft Sentinel — el agente (AMA, *Azure Monitor Agent*), la regla que le dice qué recolectar (DCR, *Data Collection Rule*) y la técnica para centralizar equipos sin conexión directa (WEF, *Windows Event Forwarding*). Importa porque **toda detección y todo hunting dependen de que la ingestión esté bien diseñada**: si filtras mal, o pierdes visibilidad, o pagas de más por datos que nadie usa.

> [!warning] Cobertura en la guía
> [[GUIA_INTENSIVA_24_DIAS]] marca "Windows Security Events via AMA + DCR" como ✅ Cubierto (apoyado en notas viejas del plan de 4 semanas) pero **WEF sigue como ❌ Falta — no existe nota dedicada en el vault**. Esta lección cierra ese hueco. No detecté datos incorrectos en la fila del Día 2 de la guía; el contenido que sigue está verificado contra Microsoft Learn (jul-2026).

## 📖 Lectura

### Antes de empezar: el problema que hay que resolver

Un servidor Windows genera sus propios logs de seguridad **localmente**, dentro del **Visor de eventos** (Event Viewer) — un componente nativo de Windows que guarda cada inicio de sesión, cada proceso creado, cada cambio de permisos, en un archivo `.evtx` en el propio disco del servidor. El problema: Sentinel vive en la nube, en un **Log Analytics workspace** (la base de datos donde caen todos los logs, como vimos en el Día 1). Nadie va a ir servidor por servidor copiando archivos `.evtx` a mano. Se necesita:

1. Algo instalado en la máquina que **lea** ese log local.
2. Algo que le diga a esa cosa **qué eventos exactamente** recolectar (no quieres subir absolutamente todo: cuesta dinero y ancho de banda).
3. Algo que **envíe** esos eventos ya filtrados hacia el workspace correcto, y a la tabla correcta.

Esas tres piezas son, respectivamente: el **AMA**, la **DCR**, y el conector **Windows Security Events via AMA**. Y para los casos donde ni siquiera se puede instalar ese "algo" en cada máquina, existe una cuarta pieza: **WEF**.

### 1. AMA — Azure Monitor Agent

**Definición:** el AMA es el **agente único y actual** de Microsoft para recolectar telemetría (logs y métricas de rendimiento) de máquinas virtuales, tanto si están en Azure, como si están on-premises o en otra nube (conectadas mediante **Azure Arc**, el servicio que extiende la gestión de Azure a servidores fuera de Azure). Se instala como una **extensión de máquina virtual** (un paquete de software que Azure despliega y actualiza automáticamente sobre la VM, sin que tengas que meterte a instalarlo a mano uno por uno).

**Por qué reemplazó a MMA/OMS:** antes del AMA existía el **Microsoft Monitoring Agent (MMA)**, también conocido como **agente de Log Analytics** o **agente OMS** (Operations Management Suite, el nombre viejo de la plataforma). El problema del MMA era que:

- Era un agente distinto para cada propósito (uno para Log Analytics, otro para System Center, otro para Automation…), lo cual generaba conflictos y duplicación.
- **No podía filtrar nada antes de enviarlo** — subías el log completo tal cual, sin poder decidir "quédate solo con estos eventos" antes de que se guardaran (y se cobraran).
- La configuración se hacía por workspace entero (todas las VMs conectadas a un workspace recibían la misma configuración), sin poder decir "este grupo de servidores manda estos eventos y aquel otro grupo manda otros distintos".

Microsoft anunció el **retiro del MMA/OMS agent** (fin de soporte agosto de 2024), y el AMA es su reemplazo total: un solo agente, multi-destino (puede mandar datos a varios workspaces a la vez), con filtrado nativo antes de guardar el dato, y con configuración granular por grupo de máquinas. La pieza que hace posible ese control granular es la DCR.

> [!tip] Regla mental
> El AMA por sí solo **no decide nada**. Es "tonto" a propósito: solo ejecuta lo que la(s) DCR(s) asociada(s) le indiquen. Toda la inteligencia de "qué recolectar y a dónde mandarlo" vive en la DCR, no en el agente.

### 2. DCR — Data Collection Rule (Regla de recolección de datos)

**Definición:** una DCR es un recurso de Azure (una configuración, técnicamente un documento en formato JSON) que define tres cosas:

1. **Fuente de datos (data source):** qué recolectar exactamente — por ejemplo, qué canales del Visor de eventos de Windows leer, con qué filtro **XPath** (un lenguaje de consulta para navegar la estructura XML de los eventos de Windows y decir "tráeme solo los eventos con este EventID o de este nivel de severidad").
2. **Destino:** a qué **Log Analytics workspace** enviar el resultado, y a qué **tabla** dentro de ese workspace (por ejemplo, la tabla `SecurityEvent`).
3. **Transformación (opcional):** una consulta **KQL** (*Kusto Query Language*; el mismo lenguaje que usas para consultar datos ya en el workspace) que se aplica a **cada registro entrante, antes de guardarlo**.

**Por qué importa la transformación:** aquí está el ahorro real de costos. Una transformación puede:

- **Filtrar filas** (`where`) — descartar eventos que no te interesan.
- **Quitar o enmascarar columnas** — por ejemplo, borrar un campo que contiene datos sensibles antes de que quede almacenado.
- **Enriquecer datos** — agregar una columna calculada, unir con datos externos.

Lo clave para el examen: **lo que la transformación descarta nunca llega a guardarse, así que nunca se cobra**. Es distinto a "guardar todo y luego borrar" (eso ya se pagó al ingerir). El nombre técnico de este mecanismo es **ingestion-time transformation** (transformación en tiempo de ingestión): ocurre en el pipeline de la nube, justo antes de escribir en la tabla.

Sintaxis conceptual de una transformación (el stream entrante se representa con la variable `source`):

```kql
source
| where EventID in (4624, 4625, 4672, 4688, 4720)
```

Esto dice: "de todo lo que llegue, quédate solo con estos cinco EventID; todo lo demás, descártalo silenciosamente antes de guardar".

**Asociación agente↔regla:** una DCR se conecta a una o varias VMs mediante un recurso llamado **DCR association** (asociación de regla de recolección). Una sola DCR puede aplicarse a muchas máquinas (por ejemplo, "todas las VMs con la etiqueta `rol=servidor-web`"), lo que permite tener perfiles de recolección distintos por grupo de máquinas sin tocar el agente en sí.

### 3. Windows Security Events via AMA

**Definición:** es el **conector de datos** de Sentinel que usa AMA + una DCR específica para traer el **Windows Security Event Log** (el canal de seguridad del Visor de eventos) y también el log de **AppLocker** (control de aplicaciones) hacia la tabla `SecurityEvent` del workspace. Reemplaza al conector legacy que dependía del MMA.

Al crear la DCR para este conector, Sentinel te ofrece elegir un **nivel de recolección (event set)** — en la práctica son plantillas prearmadas de filtros XPath:

| Nivel       | Qué incluye                                                                                                                                                                                                                            | Cuándo usarlo                                                                                                                                    |
| ----------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| **All**     | Todos los eventos del log de seguridad + AppLocker, sin filtrar                                                                                                                                                                        | Máxima visibilidad forense; el más caro. Útil en servidores críticos donde necesitas cada detalle                                                |
| **Common**  | Conjunto estándar recomendado para auditoría — incluye un **audit trail completo** de la actividad de usuario (logons, logoffs, cambios de política, gestión de cuentas, uso de privilegios, etc.)                                     | El balance recomendado por Microsoft para la mayoría de los servidores. Es lo que usarías por defecto en un SOC típico                           |
| **Minimal** | Un conjunto pequeño de eventos que podrían indicar una brecha exitosa u otros eventos importantes de muy baja frecuencia. **No** tiene audit trail completo (por ejemplo: incluye logons exitosos y fallidos, pero no incluye logoffs) | Cuando el presupuesto es muy limitado y solo te interesan señales de alto valor, sabiendo que pierdes trazabilidad completa para investigaciones |
| **Custom**  | Tú especificas manualmente los Event IDs vía XPath                                                                                                                                                                                     | Cuando ya sabes exactamente qué eventos alimentan tus analytics rules y quieres minimizar costo al máximo                                        |

Nota importante: este filtro de "nivel" (All/Common/Minimal/Custom) ocurre **en el agente**, decidiendo qué lee del log local — es un filtro más temprano que la transformación KQL de la DCR (que ocurre después, ya en la nube, sobre lo que el agente decidió enviar). Para el examen: ambos son formas legítimas de "filtrar antes de pagar", pero el filtro de nivel/XPath es el primero en la cadena y ahorra además ancho de banda, no solo almacenamiento.

### 4. WEF — Windows Event Forwarding

**Definición:** WEF es una tecnología **nativa de Windows** (no es un servicio de Azure) que permite que un equipo origen (el **forwarder**, "reenviador") envíe copias de sus eventos del Visor de eventos hacia otro equipo designado, llamado **colector (WEC — Windows Event Collector)**, usando el protocolo **WS-Management** (WinRM) sobre HTTP o HTTPS.

**Cómo funciona:**

- En el colector se configura una **suscripción (subscription)**: una regla que dice "estas máquinas origen, me envían estos eventos, y yo los guardo en mi canal local llamado por defecto **ForwardedEvents**".
- Hay dos modos de suscripción:
  - **Source-initiated** ("iniciada por el origen"): las máquinas origen empujan sus eventos activamente hacia el colector, normalmente configuradas por **GPO** (Group Policy Object, política de grupo de Active Directory). Es el modo más usado cuando administras muchos equipos centralizadamente.
  - **Collector-initiated** ("iniciada por el colector"): el colector es quien pide activamente los eventos a cada máquina origen, una por una. Útil cuando son pocos equipos.
- Una vez que los eventos están acumulados en el canal `ForwardedEvents` del colector, se instala el **AMA únicamente en ese colector**, con una **DCR** que lee ese canal `ForwardedEvents` (en vez de leer el canal `Security` local) y lo sube a Sentinel.

**El resultado:** en vez de instalar y mantener un agente en cada uno de, digamos, 200 servidores, instalas **un solo AMA** en el colector, y WEF hace el trabajo de traer los eventos de los 200 hasta ese colector usando un mecanismo 100% nativo de Windows.

**Dato clave para el examen — el origen NO se pierde:** cuando un evento se reenvía, Windows conserva dentro del propio XML del evento el nombre de la máquina de origen (el campo `Computer`). Es decir, aunque el AMA que sube el dato corre físicamente en el colector, el analista que investiga en Sentinel sigue viendo de qué equipo real vino cada evento — no todos aparecen como si vinieran del colector.

**Cuándo usar WEF (en vez de AMA directo en cada máquina):**

- Redes segmentadas o aisladas donde la mayoría de los servidores **no tiene conectividad de salida** a Azure Monitor, pero sí pueden alcanzar un servidor colector interno que sí tiene esa salida (o que está conectado vía Azure Arc).
- Equipos donde, por política, licenciamiento o superficie de ataque, **no se permite instalar agentes adicionales**.
- Un parque grande de estaciones de trabajo cliente (no servidores) donde mantener un agente en cada una es operacionalmente costoso, y ya existe infraestructura de GPO para gestionar suscripciones WEF.

**Cuándo usar AMA directo (sin WEF):**

- Cuando las máquinas **sí tienen conectividad de salida** a Azure Monitor: es la opción más simple, con menos piezas móviles (no dependes de WinRM, GPOs de suscripción, ni de mantener sano un colector que es un punto único de falla).
- Cuando necesitas telemetría rica **por host individual** sin pasar por un intermediario adicional.

> [!warning] Trampa de examen
> Si el escenario dice "los servidores tienen salida directa a internet/Azure" → la respuesta casi nunca es WEF, es AMA directo (WEF agrega complejidad innecesaria). Si dice "red aislada, solo un servidor puede salir" → WEF + AMA en el colector es la respuesta.

## 💡 Ejemplos

**1 — Elegir el nivel de recolección (tipo examen)**

*Escenario:* "Un SOC (Security Operations Center) tiene exactamente 3 analytics rules, todas basadas en eventos de logon exitoso/fallido (4624/4625), uso de privilegios (4672) y creación de procesos (4688). El presupuesto de ingestión está muy ajustado y no necesitan un audit trail completo por ahora."

*Razonamiento:* No necesitan "Common" (trae de más, incluyendo gestión de cuentas, cambios de política, etc. que no usan sus reglas) ni "Minimal" (no incluye 4688 garantizado y no da control fino). La respuesta correcta es **Custom**, especificando manualmente esos cuatro Event IDs vía XPath en la DCR — minimiza costo al centavo de lo que realmente alimenta las reglas existentes.

**2 — Transformación KQL para filtrar por EventID**

*Escenario:* ya tienes el conector Windows Security Events via AMA en nivel "All" desplegado en un servidor crítico (para no perder nada de contexto forense a nivel de agente), pero quieres que Sentinel solo almacene en `SecurityEvent` los eventos que de verdad usas para detección, sin tener que reconfigurar el nivel de recolección.

```kql
// Transformación en la DCR: se aplica a cada registro antes de guardarlo en SecurityEvent
source
| where EventID in (4624, 4625, 4648, 4672, 4688, 4697, 4720, 4726)
| where not(EventID == 4688 and Process has_any ("conhost.exe", "svchost.exe"))
```

Línea por línea:
- `source` — representa el flujo de eventos que el agente ya leyó del log local (en este caso, todo el nivel "All").
- `| where EventID in (...)` — se queda solo con los EventID de interés (logons, uso de tokens especiales, creación/eliminación de procesos, cuentas privilegiadas, servicios instalados, gestión de cuentas de usuario/grupo).
- `| where not(...)` — dentro de los eventos de creación de proceso (4688), descarta el ruido de procesos legítimos y muy frecuentes como `conhost.exe` o `svchost.exe`.

Resultado: el agente sigue viendo "All" en el disco local (por si se necesita forense completo vía otra vía), pero **lo que se guarda y se cobra en Sentinel** ya viene pre-filtrado por la transformación.

**3 — Decisión WEF vs conexión directa**

*Escenario (caso de estudio):* "Contoso tiene una subred de fábrica con 150 servidores Windows Server 2016 que ejecutan software industrial legacy. Por política de seguridad de la planta, esa subred **no tiene salida a internet**; solo un servidor de gestión (`MGMT-01`) dentro de la misma subred tiene una ruta autorizada de salida hacia Azure a través de un firewall interno. El equipo de seguridad quiere ingerir los eventos de seguridad de los 150 servidores en Sentinel."

*Razonamiento:* los 150 servidores no pueden hablar directo con Azure Monitor → instalar AMA en cada uno no serviría de nada (no hay salida). La solución: configurar **WEF** con los 150 servidores como *forwarders* (source-initiated, vía GPO) apuntando a `MGMT-01` como **colector (WEC)**; instalar el **AMA solo en `MGMT-01`**; crear una **DCR** que lea el canal `ForwardedEvents` de `MGMT-01` (no `Security`) y lo envíe a la tabla `SecurityEvent` de Sentinel. Un solo agente resuelve la ingestión de los 150 servidores.

## 🎥 Recursos

1. [Microsoft Azure Monitor Agent (AMA) and Data Collection Rule (DCR) Overview](https://www.youtube.com/watch?v=Z1zDlXCwI9k) — explicación técnica de por qué existe AMA, cómo se relaciona con las DCR y el modelo de asociación agente↔regla. ~15-20 min.
2. [Microsoft Sentinel Tutorial: How to Ingest Windows Events | Step-by-Step Guide (Part 1)](https://www.youtube.com/watch?v=tzRPt5q9msw) — demo práctica de conectar el conector Windows Security Events via AMA y configurar la DCR paso a paso. ~15 min.
3. Si prefieres documentación en vez de video: [Windows security event sets que se pueden enviar a Microsoft Sentinel](https://learn.microsoft.com/en-us/azure/sentinel/windows-security-event-id-reference) (tabla oficial de qué Event IDs entran en All/Common/Minimal) y [Custom data ingestion and transformation in Microsoft Sentinel](https://learn.microsoft.com/en-us/azure/sentinel/data-transformation) (transformaciones KQL en DCR).

## 🧪 Ejercicio práctico

> [!info] Requisito
> Necesitas el workspace de Sentinel del Día 1 y una VM Windows (puede ser una VM nueva y pequeña en Azure free tier — un `Standard_B1s` con Windows Server 2022 alcanza para este lab y cuesta céntimos si la apagas al terminar).

- [x] **Paso 1 — Desplegar una VM Windows** en el mismo resource group que tu workspace (si no tienes una del Día 1). Anota su nombre.
- [x] **Paso 2 — Conectar el conector "Windows Security Events via AMA"**: en el portal de Sentinel (o Defender), ve a *Content hub* / *Data connectors* → busca "Windows Security Events via AMA" → *Open connector page* → *Create data collection rule*. Selecciona tu VM como recurso destino y el nivel **Common** (el recomendado por defecto).
- [x] **Paso 3 — Verificar el estado del agente**: en la VM (Virtual machine > Extensions + Applications), confirma que la extensión `AzureMonitorWindowsAgent` quedó instalada y en estado "Succeeded".
- [x] **Paso 4 — Crear/editar la DCR con una transformación KQL**: entra al recurso "Data Collection Rules" en Azure, abre la DCR que se creó automáticamente, ve a la pestaña **Data sources**, edita la fuente de tipo "Windows Event Logs" y en la sección de transformación agrega:
  ```kql
  source
  | where EventID in (4624, 4625, 4672, 4688)
  ```
  Guarda. Esto simula "quedarme solo con logons y creación de procesos" sin importar qué tan ruidoso sea el nivel "Common" elegido.
- [x] **Paso 5 — Confirmar la ingestión con KQL** (dale 10-15 min a que lleguen los primeros eventos):
  ```kql
  SecurityEvent
  | where TimeGenerated > ago(1h)
  | summarize count() by EventID
  | order by count_ desc
  ```
  Si tu transformación funcionó, **solo deberías ver EventID 4624/4625/4672/4688** en el resultado, nada más.
- [x] **Paso 6 — Decisión WEF (sin necesidad de montarlo completo)**: como ejercicio de diseño (no hace falta desplegar WEF de verdad para el examen), escribe en una nota propia cuál sería la arquitectura si en vez de 1 VM tuvieras 50 VMs en una subred sin salida a internet, con un único jump server con salida. Identifica: quién es el forwarder, quién el colector, qué canal lee la DCR del colector.

## ✅ Quiz del día

**P1.** ¿Qué agente reemplazó Microsoft para la recolección de logs, retirando el soporte del agente anterior en agosto de 2024?
A) Azure Monitor Agent (AMA), reemplazando a MMA/OMS · B) Log Analytics agent sigue vigente · C) Diagnostics extension · D) Telegraf

**P2.** ¿En qué momento del pipeline se aplica una transformación KQL de una DCR?
A) Después de guardarse en la tabla, como una vista · B) Solo si usas Basic Logs · C) Solo en tablas custom `_CL` · D) Antes de guardarse (ingestion-time transformation): lo descartado nunca se almacena ni se cobra

**P3.** Necesitas EXACTAMENTE los EventID 4624, 4688 y 4720 de un grupo de servidores, sin nada más, para minimizar costo al máximo. ¿Qué nivel eliges en el conector Windows Security Events via AMA?
A) All · B) Custom, con esos Event IDs vía XPath · C) Common · D) Minimal

**P4.** Un grupo de 150 servidores en una subred sin salida a internet solo puede alcanzar un servidor interno con conectividad a Azure. ¿Qué configuras?
A) AMA directo en cada uno de los 150 · B) Syslog via AMA · C) WEF: los 150 como forwarders hacia un colector, con AMA + DCR solo en el colector leyendo `ForwardedEvents` · D) CEF via AMA

**P5.** Después de reenviar un evento con WEF hasta el colector, ¿el analista en Sentinel pierde de vista qué máquina originó el evento?
A) No, el XML del evento conserva el nombre de la máquina de origen en el campo Computer · B) Sí, todos los eventos muestran al colector como origen · C) Solo si se usa collector-initiated · D) Solo en el nivel "Minimal"

### Respuestas explicadas

> [!note]- Ver respuestas (spoiler)
> **P1 — A.** El AMA es el agente unificado y actual; MMA (Microsoft Monitoring Agent, también llamado OMS agent) fue retirado. Diagnostics extension y Telegraf son mecanismos distintos, no reemplazos directos del agente de Log Analytics.
> **P2 — D.** Las transformaciones de DCR son ingestion-time: se ejecutan antes de escribir en la tabla, así que lo filtrado nunca se guarda ni se paga. No son exclusivas de tablas custom.
> **P3 — B.** Cuando necesitas control exacto sobre Event IDs específicos y no calzan con los presets, "Custom" con XPath es la única opción que da ese nivel de precisión.
> **P4 — C.** Sin conectividad directa, AMA en cada servidor no sirve de nada. WEF centraliza en un colector con salida, y solo ahí se instala AMA + DCR (leyendo el canal `ForwardedEvents`, no `Security`).
> **P5 — A.** WEF preserva el campo `Computer` con el nombre de la máquina origen dentro del XML del evento reenviado; el analista sigue identificando el host real, no el colector.

---

*Relacionadas: [[GUIA_INTENSIVA_24_DIAS]] · [[TRACKER_TUTOR]] · [[Dia 01 - Arquitectura Sentinel y Tiers de Retencion]] · [[WEF_y_DCR]] · [[CHEATSHEET_KQL]]*
