---
tags: [sc-200, mde, endpoint, incident-response, live-response, timeline, forensics, rbac, leccion-diaria]
dia: 9
fecha: 2026-08-12
fecha_programada: 2026-08-11
dominio: "Dominio 2 — Respond to security incidents (35-40%)"
estado: 🟡 En curso
cover: ""
---

# Lección Día 9 — Respuesta en Microsoft Defender for Endpoint: Timeline, Live Response y Evidencia

> [!info] Contexto
> Día 9 del plan de [[PLAN_MAESTRO_MULTITRACK]], dentro del **Dominio 2 — Respond to security incidents**, que vale entre el **35 % y el 40 %** del examen. Esta lección estaba agendada para el martes 11-ago-2026 y no se dio — el alumno tuvo tres entregas de universidad ese día, exactamente el tipo de choque que el reanclaje #3 (9-ago) ya anticipaba. Se imparte hoy, miércoles 12-ago, con **un día de retraso real**, sin maquillarlo. No cambia el calendario de [[PLAN_MAESTRO_MULTITRACK]]: el examen sigue el **sábado 3 de octubre de 2026**.
>
> Este día importa más que el resto por un dato concreto: en tu Practice Assessment oficial del 23-jul (46 %), **el bloque de respuesta en Microsoft Defender for Endpoint (MDE) fue el más débil — cinco fallos seguidos** (Timeline, Live response, Isolate device, Collect investigation package, Advanced hunting, todos mezclados). El diagnóstico que ya quedó registrado entonces sigue siendo preciso: no fallaste por no saber qué hace cada herramienta — fallaste en **leer el calificador del enunciado** que decide entre herramientas parecidas ("minimizar impacto", "revisar ANTES de que saltara la alerta", "analizar EN VIVO", "preservar evidencia"). Por eso hoy, además de explicar cada herramienta desde cero, la lección incluye una **tabla de decisión** que traduce ese calificador directamente a la respuesta correcta — es el entregable de más valor del día.

---

## 📖 Lectura del día

### 0. Dónde estamos dentro del Dominio 2

El Dominio 2, *Respond to security incidents*, tiene tres sub-bloques según el temario vigente ("skills measured as of July 28, 2026"):

| Sub-bloque | Qué agrupa | Cuándo lo ves |
|---|---|---|
| Respond to alerts and incidents in Microsoft Defender XDR | Gestión de incidentes, case management, respuesta por producto (MDO, Purview, Defender for Cloud, MDCA, Entra ID, MDI), ataques multi-etapa, agentic AI/Copilot | Días 8, 10-13 |
| **Respond to alerts and incidents in Microsoft Defender for Endpoint** | **Device timeline, live response, collect investigation package, evidencia y entidades, attack disruption** | **Hoy (Día 9)** |
| Investigate Microsoft 365 activities to identify threats | Purview Audit, eDiscovery, Microsoft Graph activity logs | Día 13 |

Hoy cerramos el segundo sub-bloque casi completo: nos falta únicamente la parte de "entidades" (investigar archivos, usuarios, dominios) que se apoya en las mismas herramientas de hoy y se retoma de forma natural cuando lleguemos a Advanced Hunting (Días 14-16).

### 1. El panorama: seis herramientas, un mismo objetivo distinto momento

Cuando MDE detecta o sospecha una amenaza en un dispositivo (también llamado *machine* en la documentación oficial), un analista tiene, en esencia, seis formas de actuar sobre esa información. Antes de entrar al detalle de cada una, conviene fijar el eje que las organiza, porque es exactamente el eje que el examen explota:

- **¿Estoy mirando el pasado o actuando en el presente?** El Timeline y Advanced Hunting muestran telemetría **ya recolectada** — nada de lo que hagas ahí cambia el dispositivo. Live response, en cambio, es una conexión **en tiempo real** al dispositivo: lo que corres ahí sucede ahora mismo, en la máquina remota.
- **¿Estoy recolectando evidencia o conteniendo una amenaza?** Collect investigation package es **forense pasivo**: descarga un paquete de datos sin tocar la conectividad ni el funcionamiento del dispositivo. Isolate device, Contain device y Restrict app execution son **acciones de contención**: cambian activamente lo que el dispositivo puede hacer.
- **¿El dispositivo está administrado por MDE o no?** Isolate device solo aplica a dispositivos **onboardeados** (con el sensor de MDE instalado). Contain device existe precisamente para el caso contrario: un dispositivo **no administrado** que hay que aislar "desde afuera".

Con ese mapa en la cabeza, vamos herramienta por herramienta.

### 2. Device Timeline: el historial cronológico de un dispositivo

El **Timeline** (línea de tiempo) es una pestaña dentro de la página de un dispositivo específico en el portal de Microsoft Defender (`security.microsoft.com`) que muestra, en orden cronológico, **todos los eventos observados en ESE dispositivo**: procesos que se ejecutaron, archivos creados o modificados, conexiones de red, cambios de registro, inicios de sesión, alertas generadas, y más — toda la telemetría que el sensor de MDE recolectó de esa máquina.

Se llega a ella desde el inventario de dispositivos (**Assets → Devices**), desde una alerta en la cola, o desde un incidente — seleccionas el dispositivo y abres la pestaña **Timeline**.

Capacidades clave que el examen puede preguntar de forma puntual:

- **Rango de fechas personalizado.** Por defecto muestra los últimos **30 días**, pero puedes elegir un rango custom. El **dato de retención importante, verificado hoy**: por defecto, los eventos del Timeline se conservan **90 días** según la política de retención de datos de seguridad del tenant (la del portal, distinta de la retención del workspace de Log Analytics si tienes uno conectado con retención extendida). Si necesitas datos de hace más de 90 días y no tienes un workspace con retención mayor, ya no están disponibles en el Timeline.
- **Vista de árbol de procesos (process tree).** Al seleccionar un evento, un panel lateral muestra la relación padre-hijo entre procesos — útil para entender qué proceso lanzó a cuál.
- **Técnicas MITRE ATT&CK.** Los eventos que están asociados a una técnica o subtécnica del framework MITRE ATT&CK aparecen resaltados en negrita con un ícono azul, con la técnica y su ID visibles en "Additional information".
- **Marcado de eventos (event flags).** Puedes marcar con una bandera los eventos importantes durante una investigación, y luego filtrar/exportar solo los marcados — sirve para construir una "línea de tiempo limpia" del ataque para un reporte.
- **"Hunt for related events".** Desde el panel de detalle de un evento (o de una técnica MITRE), puedes lanzar directamente una query de **Advanced hunting** ya construida que trae el evento seleccionado más otros eventos que ocurrieron alrededor del mismo momento en el mismo endpoint. Es el puente formal entre Timeline y Advanced hunting.
- **Exportación.** Puedes exportar el Timeline del día actual o de un rango de hasta **7 días**.

**El punto que el examen más te va a poner a prueba: Timeline vs Advanced Hunting.** Ambos consultan telemetría ya recolectada, así que suenan intercambiables — no lo son. El Timeline está **acotado a un solo dispositivo** y no necesita que escribas ni una línea de KQL (Kusto Query Language, el lenguaje de consulta de Sentinel y Advanced Hunting): es la herramienta correcta cuando la pregunta ya te dio el dispositivo y quiere que reconstruyas qué pasó ahí, especialmente **antes** de que existiera una alerta formal. Advanced hunting, en cambio, es una consulta libre en KQL que puede cruzar **múltiples dispositivos, sistemas operativos y tablas a la vez** — es la herramienta correcta cuando la pregunta pide **alcance** ("¿en qué otros dispositivos apareció este hash?", "¿qué tan lejos llegó el atacante?").

### 3. Live response: shell remoto en tiempo real

**Live response** le da a un analista acceso instantáneo a un dispositivo mediante una **conexión de shell remota**, para hacer trabajo de investigación profundo y tomar acciones de contención inmediatas **en tiempo real**. A diferencia del Timeline (que solo mira telemetría pasada), Live response te permite **interactuar** con el dispositivo: correr comandos, subir y bajar archivos, ejecutar scripts, y remediar entidades ahí mismo.

**Prerrequisitos, dos capas separadas (y esto es un punto fino de examen):**

1. **A nivel de tenant:** hay que habilitar Live response en **Settings → Endpoints → Advanced features** (solo administradores o usuarios con permiso "Manage portal settings" pueden hacerlo). Hay un toggle adicional para habilitarlo también en **servidores**, y otro opcional para permitir la ejecución de **scripts sin firmar** (aumenta el riesgo, así que es una decisión deliberada).
2. **A nivel de usuario:** el analista necesita el permiso RBAC (Role-Based Access Control, control de acceso basado en roles) de **Live response capabilities**, que se concede en un rol custom (**Settings → Endpoints → Roles**) — y aquí viene la parte importante: este permiso es **independiente** del que te deja isolar o contener dispositivos. Se profundiza en la sección 6.

**Comandos: básicos vs avanzados.** El rol asignado al analista determina qué tipo de comandos puede correr:

- **Básicos** (solo lectura, no ejecutan ni suben nada): `dir`, `cd`, `processes`, `services`, `registry`, `drivers`, `scheduledtasks`, `connections`, `fileinfo`, `getfile` (descargar un archivo).
- **Avanzados** (acción real sobre el dispositivo): `run` (ejecutar un script PowerShell/Bash ya subido a la librería), `putfile` (subir un archivo al dispositivo), `remediate` (eliminar/detener una entidad: archivo, proceso, servicio, entrada de registro, tarea programada), `undo` (revertir una remediación), `scan` (correr un antivirus scan rápido, solo mac/Linux vía live response), `analyze` (analizar una entidad con motores de detección), e **`isolate`/`release`** — y aquí hay una trampa real: dentro de la consola de Live response, los comandos `isolate` y `release` **solo existen para macOS**. En Windows, aislar un dispositivo se hace desde el botón **Isolate device** de la página del dispositivo, no desde un comando dentro de la sesión de Live response.

**Límites operativos que el examen puede citar textualmente:** máximo **50 sesiones de live response simultáneas** en el tenant, un analista puede iniciar hasta **5 sesiones concurrentes**, el timeout por inactividad de una sesión es de **30 minutos**, y cada comando individual tiene un límite de **10 minutos** (30 minutos para `getfile`, `findfile` y `run`).

### 4. Collect investigation package: forense pasivo, sin tocar la red

**Collect investigation package** descarga un archivo comprimido (.zip) con el **estado actual del dispositivo**, pensado para entender qué herramientas y técnicas usó un atacante — sin ejecutar nada en el dispositivo ni alterar su conectividad. Es, junto con el Timeline, la herramienta que más confusión te generó en el simulacro, así que vale la pena fijar bien qué contiene:

**Para Windows**, el paquete incluye carpetas con: **Autoruns** (puntos de arranque automático, para detectar persistencia), **Installed programs**, **Network connections** (conexiones TCP/IP activas, tabla ARP — Address Resolution Protocol —, caché DNS, configuración de firewall), **Prefetch files** (rastro de aplicaciones ejecutadas, incluso ya borradas), **Processes** (lista de procesos corriendo al momento de la recolección), **Scheduled tasks**, **Security event log** (el log de eventos de seguridad de Windows), **Services**, sesiones **SMB** (Server Message Block, para detectar movimiento lateral o exfiltración), **System Information**, **Temp Directories**, **Users and Groups**, y un **CollectionSummaryReport.xls** que resume qué se recolectó y si hubo errores.

**Para macOS y Linux** el contenido es similar pero adaptado: aplicaciones instaladas, historial de shell, módulos de kernel cargados, conexiones de red activas, procesos, historial de inicio de sesión, sudoers, y (solo macOS) información de integridad EFI y estado de SIP (System Integrity Protection).

**El punto que decide el examen:** este paquete **no aísla el dispositivo ni corta su red**. Es exactamente la herramienta cuando el enunciado pide "minimizar el impacto en el usuario" o "evitar alertar al atacante" — porque, a diferencia de Isolate device, el dispositivo sigue funcionando con normalidad mientras se recolecta la evidencia.

### 5. Las acciones de contención: Isolate, Contain, Restrict app execution y Run AV scan

Estas cuatro acciones sí **cambian** algo activamente en el dispositivo o en la red. Se diferencian por **qué** cambian y **a qué tipo de dispositivo** aplican:

- **Isolate device (aislar dispositivo).** Desconecta al dispositivo **onboardeado** de la red, **manteniendo su conexión con el servicio de MDE** (para que se siga pudiendo monitorear y gestionar). Existen dos modos: **aislamiento completo** (corta todo salvo la comunicación con MDE) y **aislamiento selectivo** (permite excepciones configurables — por ejemplo, mantener Outlook y Teams activos, o procesos/destinos específicos vía *isolation exclusions*). Requiere al menos el permiso **Active remediation actions**. Un dato de examen: **la desisolación es automática a los 7 días** si nadie la libera antes manualmente.
- **Contain device (contener dispositivo).** Se usa para un dispositivo **NO administrado** por MDE (no tiene el sensor instalado) — por ejemplo, un dispositivo IoT o de red comprometido que se detectó por su comportamiento. En vez de aislarlo directamente (no se puede, no tiene sensor), Contain hace que **todos los dispositivos onboardeados de MDE bloqueen las comunicaciones entrantes y salientes hacia ese dispositivo** — es una contención "desde afuera". También existe una variante de **Contain critical assets**, más granular, para no tumbar completamente activos críticos como controladores de dominio.
- **Restrict app execution (restringir ejecución de apps).** Aplica una política de integridad de código que solo permite ejecutar archivos **firmados por Microsoft**. Es reversible (**Remove app restrictions**) y es más quirúrgico que Isolate: corta la posibilidad de ejecutar programas nuevos, pero no corta la red del dispositivo.
- **Run antivirus scan.** Inicia remotamente un scan de Microsoft Defender Antivirus, en modalidad **rápido (quick)** o **completo (full)**. Puede correr en paralelo a otro antivirus de terceros, incluso si Defender Antivirus está en modo pasivo.

### 6. RBAC: quién puede hacer qué (la pieza que más falta en tu mapa mental)

Este es un punto que el simulacro no llegó a probarte directamente pero que es una fuente natural de preguntas de examen, y que además explica *por qué* existen escenarios como "minimizar impacto": porque en un SOC real, no todos los analistas tienen permiso para las acciones más invasivas. En **Settings → Endpoints → Roles**, un rol custom se arma combinando permisos independientes:

| Permiso | Qué habilita | Ejemplos de acciones |
|---|---|---|
| View data (Security Operations) | Solo lectura | Ver alertas, incidentes, dispositivos, Timeline |
| **Active remediation actions** | Tomar acciones con impacto real en el dispositivo o la red | Isolate device, Contain device, Restrict app execution, aprobar/rechazar remediaciones pendientes de AIR (Automated Investigation and Response), gestionar listas de indicadores bloqueados/permitidos |
| **Alerts investigation** | Investigar y recolectar evidencia sin necesariamente contener | Gestionar alertas, iniciar Automated investigation, correr Run antivirus scan, **Collect investigation package**, gestionar tags de dispositivo, descargar archivos PE (Portable Executable) |
| **Live response capabilities — Basic** | Sesión de solo lectura | Iniciar sesión, comandos de solo lectura (`dir`, `processes`, `getfile`), sin poder subir ni ejecutar nada |
| **Live response capabilities — Advanced** | Control remoto completo | Subir/ejecutar scripts de la librería, `remediate`, `undo`, `analyze`, `isolate`/`release` (solo macOS) |

Fíjate en algo importante: **Alerts investigation te permite recolectar un investigation package sin darte permiso para aislar el dispositivo** (eso es Active remediation actions, un permiso distinto). Un analista junior podría estar autorizado exactamente para "capturar evidencia" pero no para "cortar la red" — que es, casi textualmente, el tipo de escenario que ya te costó puntos en el simulacro.

> [!warning] Nota sobre el modelo de permisos vigente
> Lo anterior es el modelo clásico de roles específico de MDE (`Settings → Endpoints → Roles`), documentado y vigente hoy (verificado contra Microsoft Learn, actualizado 17-jun-2026). Desde el **16 de febrero de 2025**, los tenants **nuevos** de MDE usan por defecto el **Unified RBAC (URBAC)** de Defender XDR — el mismo sistema de permisos "Security operations > ..." que ya viste en case management el Día 8 —, mientras que los tenants existentes conservan sus roles clásicos. Para el examen, ambos modelos son justificables; la tabla de arriba es la que documenta Microsoft Learn con el detalle más fino por acción, así que es la más útil para responder preguntas puntuales.

### 7. La tabla de decisión: el calificador del enunciado manda

Esto es lo que realmente te costó los cinco puntos del simulacro, así que aquí está construida desde cero, con el razonamiento completo de por qué cada calificador elimina a las demás opciones:

| El enunciado dice (calificador) | Herramienta correcta | Por qué NO las demás |
|---|---|---|
| "Reconstruir qué pasó en ESTE dispositivo ANTES de que se disparara la alerta" | **Timeline** | Advanced hunting sirve para consultas libres, no para reconstruir de forma directa un solo host; Live response es en tiempo real, no mira el pasado |
| "Identificar el ALCANCE de un incidente en varios dispositivos o distintos sistemas operativos" | **Advanced hunting** | Timeline está acotado a UN dispositivo a la vez; no cruza hosts ni sistemas operativos |
| "Analizar EN VIVO, interactuar con un proceso sospechoso, correr un comando AHORA" | **Live response** | Timeline y Advanced hunting son telemetría ya recolectada — pasado, no presente; no permiten "tocar" el dispositivo |
| "Capturar evidencia forense MINIMIZANDO el impacto al usuario / sin alertar al atacante / evitando un falso positivo de aislar sin necesidad" | **Collect investigation package** | Isolate device SÍ corta la red del dispositivo — es exactamente el impacto que el enunciado pide evitar |
| "Cortar la red de un dispositivo ONBOARDEADO y comprometido, riesgo alto de propagación" | **Isolate device** | Contain device es para dispositivos NO administrados; Restrict app execution no corta la red, solo la ejecución de apps |
| "Bloquear las comunicaciones de un dispositivo NO administrado (sin sensor de MDE) que otros equipos sí detectan en la red" | **Contain device** | Isolate solo aplica a dispositivos onboardeados — este dispositivo, por definición, no lo está |
| "Impedir que corran programas nuevos no firmados, SIN cortar la red completa" | **Restrict app execution** | Isolate es más agresivo: corta toda la red, no solo la ejecución de apps nuevas |
| "Confirmar si hay malware activo y limpiarlo automáticamente" | **Run antivirus scan** | Collect investigation package no remedia nada, solo recolecta evidencia pasiva |
| "Delegar la investigación automática de una alerta repetida en el mismo dispositivo" | **Initiate automated investigation** | Distinto de Live response, que es manual e interactivo, no automatizado |

**El patrón detrás de la tabla, resumido en una frase:** cuando el enunciado trae un calificador ("minimizar impacto", "antes de la alerta", "en vivo", "sin sensor instalado"), ese calificador casi siempre **elimina la opción más genérica o más agresiva** (Isolate, Advanced hunting sin acotar) a favor de la herramienta más quirúrgica para ese caso puntual.

### 8. La conexión con Attack disruption (Día 6)

Ya viste en el Día 6 que **Automatic attack disruption** puede ejecutar automáticamente algunas de estas mismas acciones — en particular **Isolate device**, **Contain device**, **Contain user**, **Revoke user session** — a nivel de **incidente completo**, sin intervención manual, cuando el sistema tiene alta confianza de que un ataque está en curso. La diferencia con lo que viste hoy no es la acción en sí (el mecanismo de aislamiento es el mismo), sino **quién la dispara**: aquí lo hace un analista manualmente, evaluando el escenario; ahí lo dispara el sistema automáticamente. Isolate device también existe hoy en una variante **"automatic attack disruption isolate device (preview)"**, que es exactamente ese disparo automático aplicado a este botón concreto — el device queda marcado como aislado por el sistema, no por una persona, y se puede liberar desde el mismo lugar donde liberarías un aislamiento manual.

---

## 💡 Ejemplos concretos

### Ejemplo 1 — Timeline vs Advanced hunting: el calificador "antes de la alerta"

**Escenario:** Un incidente se genera a las 14:32 por una alerta de "Suspicious PowerShell commandline" en el dispositivo `WKS-042`. El analista sospecha que el atacante estuvo activo en ese equipo desde antes, y necesita reconstruir qué procesos y conexiones de red ocurrieron en `WKS-042` **entre las 13:00 y las 14:32**, antes de que la alerta se disparara.

**Razonamiento:** el enunciado ya te dio el dispositivo específico (`WKS-042`) y un rango de tiempo concreto, y pide reconstruir una secuencia — exactamente el caso de uso del **Timeline**: abres la página de `WKS-042`, seleccionas la pestaña Timeline, ajustas el rango de fechas personalizado a 13:00-14:32, y filtras por tipo de evento (procesos, red). No hace falta escribir una sola línea de KQL. Si en cambio el enunciado hubiera pedido "confirmar si ese mismo hash de PowerShell apareció en otros dispositivos de la organización", ahí sí correspondería Advanced hunting, porque cruza múltiples hosts:

```kql
DeviceProcessEvents
| where ProcessCommandLine has "IEX" or ProcessCommandLine has "-EncodedCommand"
| where Timestamp between (datetime(2026-08-12T13:00:00Z) .. datetime(2026-08-12T14:32:00Z))
| project Timestamp, DeviceName, AccountName, FileName, ProcessCommandLine, InitiatingProcessFileName
| order by Timestamp asc
```

Esta query es, en esencia, el mismo tipo de consulta que genera el botón **"Hunt for related events"** cuando lo usas desde un evento del Timeline — el puente entre las dos herramientas.

### Ejemplo 2 — Collect investigation package vs Isolate device: el calificador "minimizar impacto"

**Escenario:** En un dispositivo de un ejecutivo (`LT-CEO-01`), Defender genera una alerta de severidad media por un archivo sospechoso. El analista necesita capturar memoria, lista de procesos, conexiones de red activas y el log de eventos de seguridad, **minimizando el impacto al usuario y evitando actuar en falso** si resulta ser un falso positivo — el ejecutivo está en una llamada importante.

**Razonamiento:** el calificador "minimizando el impacto al usuario" es la señal directa. **Isolate device** cortaría la red de inmediato — impacto real, inmediato, sobre alguien que está en una llamada — y si termina siendo un falso positivo, ese impacto fue innecesario. **Collect investigation package** recolecta exactamente los datos que el enunciado pide (procesos, network connections, security event log — todos están en las carpetas documentadas del paquete) **sin tocar la conectividad del dispositivo**. El analista con solo el permiso **Alerts investigation** (sin Active remediation actions) puede hacer esta acción, pero no podría aislar el dispositivo aunque quisiera — el sistema de permisos refleja el mismo principio de "acción mínima necesaria" que pide el enunciado.

### Ejemplo 3 — Live response con RBAC granular: el calificador "en vivo"

**Escenario:** Un proceso sospechoso sigue corriendo en `SRV-DB-07` en este momento. El analista de turno, con el rol **"Analista Nivel 1"** (que solo tiene **Live response capabilities — Basic**), necesita terminar el proceso y eliminar el archivo asociado de inmediato.

**Razonamiento:** "en este momento" y "terminar el proceso ahora" descartan Timeline y Advanced hunting (telemetría pasada) — corresponde **Live response**. Pero aquí hay una segunda capa: el comando `remediate` (que detiene procesos y elimina archivos) es un comando **avanzado**, y el analista solo tiene permisos **básicos** (solo lectura: `dir`, `processes`, `getfile`). El analista puede conectarse, listar el proceso con `processes` y confirmar el archivo con `fileinfo`, pero **no puede ejecutar `remediate`** — necesita escalar a un analista con **Live response capabilities — Advanced**, o usar el botón de acción de dispositivo **Restrict app execution** (que sí cae bajo su alcance si además tiene Active remediation actions) como alternativa de contención mientras espera el escalamiento.

---

## 🎥 Videos

1. **[Live Response | Microsoft Defender for Endpoint](https://www.youtube.com/watch?v=z9gODTDljBU)** — canal oficial de Microsoft Security. Nota de honestidad: es un video más antiguo (circulando desde 2023) y no encontré un reemplazo 2025/2026 mejor en YouTube; lo mecánico de Live response (consola, comandos básicos/avanzados, subir/bajar archivos) no ha cambiado de fondo, así que sigue siendo útil como introducción visual. Duración aproximada 3-5 minutos.
2. **[Perform actions on a device using Microsoft Defender for Endpoint](https://learn.microsoft.com/en-us/training/modules/perform-actions-device-microsoft-defender-for-endpoint/)** — módulo oficial de Microsoft Learn (actualizado 22-jun-2026), 7 unidades que cubren exactamente el temario de hoy: acciones de dispositivo, antivirus scan, **Collect investigation package** y **Live response**. No es un video, pero es la fuente más alineada y más al día que encontré — recomendado como complemento directo de esta lección, con quiz de módulo incluido.

---

## 🧪 Ejercicio práctico

> [!info] Requisito
> Usa tu trial M365 E5 / portal de Defender (`security.microsoft.com`), **no** el tenant universitario de La Salle (portal unificado limitado, ya detectado en sesiones anteriores).

- [ ] **Paso 1 — Explorar Roles.** Ve a **Settings → Endpoints → Roles**. Abre el rol por defecto (o crea uno de prueba) y localiza los cinco permisos de la tabla de la sección 6: View data, Active remediation actions, Alerts investigation, y las dos opciones de Live response capabilities (Basic/Advanced). Confirma que son casillas independientes entre sí.
- [ ] **Paso 2 — Confirmar prerrequisitos de Live response.** Ve a **Settings → Endpoints → Advanced features** y confirma que el toggle de **Live response** esté visible (ya lo viste en el Día 5). Anota si el toggle de "servidores" y el de "scripts sin firmar" están activados por defecto en tu trial.
- [ ] **Paso 3 — Explorar un dispositivo (si tienes uno onboardeado).** Ve a **Assets → Devices**, abre cualquier dispositivo disponible y explora la pestaña **Timeline**: prueba el selector de rango de fechas, marca un evento con la bandera, y si aparece algún evento con técnica MITRE ATT&CK, ábrelo para ver el panel lateral.
- [ ] **Paso 4 — Collect investigation package (si tienes un dispositivo real onboardeado).** Selecciona **Collect investigation package** desde la barra de acciones del dispositivo, escribe un comentario, confírmalo, y cuando el Action center te avise que está listo, descarga el .zip y abre las carpetas para verificar que coinciden con la tabla de la sección 4 (Autoruns, Processes, Network connections, etc.).
- [ ] **Paso 5 (si no tienes un dispositivo onboardeado) —** haz el módulo de Learn del apartado de Videos (unidades 2 a 5), que simula el flujo completo con capturas de pantalla reales, y complementa con el lab oficial [Lab 4 Ex2 — Mitigate Attacks with Microsoft Defender for Endpoint](https://microsoftlearning.github.io/SC-200T00A-Microsoft-Security-Operations-Analyst/Instructions/Labs/LAB_AK_04_Lab1_Ex02_Mitigate_Attacks.html) si tienes acceso al sandbox de pago de Microsoft Learn — genera un incidente real en `WIN1` que puedes luego explorar en su Timeline.
- [ ] **Paso 6 —** responde el quiz del día y el repaso acumulativo de abajo.

---

## ✅ Quiz del día

Cinco preguntas sobre el contenido nuevo de hoy. Responde antes de abrir el bloque de respuestas.

**1.** Un analista abre el Timeline de un dispositivo para revisar un incidente que ocurrió hace 120 días, pero no encuentra ningún evento de esa fecha aunque el dispositivo sigue onboardeado y activo. ¿Cuál es la explicación más probable?

- A) El Timeline solo admite un máximo de 30 días de rango de fechas configurable, sin excepción
- B) El Timeline requiere reprocesar manualmente cada evento con Advanced hunting antes de mostrarlo
- C) La retención por defecto del Timeline es de 90 días y ese evento ya expiró sin un workspace de retención extendida
- D) El evento fue movido automáticamente a la tabla `SecurityIncident` y ya no aparece en el Timeline

**2.** Una organización detecta que un dispositivo IoT sin sensor de MDE instalado se está comunicando con varios equipos administrados de la red y podría estar comprometido. ¿Qué acción usan para bloquear esas comunicaciones?

- A) Isolate device, en modo de aislamiento selectivo
- B) Contain device, para bloquear comunicaciones desde los dispositivos administrados hacia él
- C) Restrict app execution, aplicando la política de integridad de código
- D) Collect investigation package, para documentar el comportamiento antes de actuar

**3.** Ana tiene un rol con el permiso "Alerts investigation" pero no tiene "Active remediation actions" ni "Live response capabilities". ¿Cuál de las siguientes acciones SÍ puede realizar?

- A) Aislar el dispositivo desde el botón Isolate device
- B) Recolectar un investigation package del dispositivo
- C) Iniciar una sesión de live response con comandos básicos
- D) Ejecutar el comando `remediate` sobre un archivo malicioso

**4.** Durante una sesión de Live response contra un dispositivo Windows, un analista escribe el comando `isolate` en la consola esperando cortar la red del equipo. ¿Qué ocurre?

- A) El comando se ejecuta con éxito y el dispositivo queda aislado de inmediato
- B) El comando `isolate` dentro de Live response solo existe para macOS; en Windows se usa el botón Isolate device de la página del dispositivo
- C) El comando requiere primero ejecutar `connect` para habilitarse en cualquier sistema operativo
- D) El comando funciona, pero solo aplica aislamiento selectivo, nunca aislamiento completo

**5.** El equipo de cumplimiento pregunta si el paquete descargado con Collect investigation package interrumpe la conectividad de red del dispositivo mientras se recolecta. ¿Cuál es la respuesta correcta?

- A) Sí, el dispositivo queda aislado automáticamente durante la recolección y se libera al terminar
- B) No, es una recolección pasiva de datos que no cambia la conectividad ni el funcionamiento del dispositivo
- C) Depende del sistema operativo: en Windows sí aísla, en macOS y Linux no
- D) Sí, pero solo si el dispositivo forma parte de un incidente activo en ese momento

> [!note]- Ver respuestas
> **1 — C.** Verificado hoy contra Microsoft Learn: la retención por defecto de los eventos del Timeline en Microsoft Defender for Endpoint es de **90 días**, salvo que el tenant tenga un workspace de Log Analytics o Sentinel conectado con retención extendida. **A** es falso: el rango configurable admite fechas más allá de 30 días, el límite real es de retención, no de selector. **B** inventa un paso que no existe: Timeline no depende de Advanced hunting para mostrar eventos. **D** confunde el nivel del dato: `SecurityIncident` es una tabla de Sentinel a nivel de incidente correlacionado, no un destino de migración de eventos individuales del Timeline.
>
> **2 — B.** Contain device existe exactamente para este escenario: un dispositivo **no administrado** (sin sensor de MDE) que no se puede aislar directamente porque Isolate solo funciona sobre dispositivos onboardeados. Contain hace que los dispositivos administrados bloqueen las comunicaciones hacia y desde ese dispositivo, conteniéndolo "desde afuera". **A** es incorrecta porque Isolate no aplica a dispositivos sin sensor. **C** restringe apps, no bloquea comunicaciones de red entre dispositivos. **D** solo recolecta evidencia, no bloquea nada.
>
> **3 — B.** El permiso "Alerts investigation" incluye explícitamente Collect investigation package, además de gestionar alertas, iniciar Automated investigation, correr AV scan y gestionar tags — sin necesitar Active remediation actions. **A** requiere el permiso Active remediation actions, que Ana no tiene. **C** requiere el permiso separado Live response capabilities (Basic como mínimo), que tampoco tiene. **D** requiere Live response capabilities — Advanced específicamente, un escalón más arriba de lo que ni siquiera pide la opción C.
>
> **4 — B.** Dentro de la consola de Live response, los comandos `isolate` y `release` solo están disponibles para dispositivos macOS; en Windows y Linux no existen como comandos de Live response, y el aislamiento en Windows se hace desde la acción de dispositivo Isolate device, fuera de la sesión de Live response. **A** describe el comportamiento en macOS, no en Windows. **C** inventa un requisito técnico que no existe. **D** es falso: la elección entre aislamiento completo y selectivo se hace al iniciar Isolate device desde la página del dispositivo, no depende del comando `isolate` de Live response.
>
> **5 — B.** Collect investigation package es forense pasivo: descarga un paquete con el estado del dispositivo (procesos, conexiones de red, autoruns, logs, etc.) sin alterar su conectividad ni su funcionamiento normal — es justamente lo que lo distingue de Isolate device. **A** describe Isolate device, no esta acción. **C** inventa una diferencia por sistema operativo que no existe para esta acción específica. **D** también es falso por el mismo motivo que A: no hay aislamiento asociado a esta acción bajo ninguna condición.

---

## 🔁 Repaso acumulativo — re-test espaciado

Estas preguntas re-testean puntos ya medidos como débiles en sesiones anteriores, con otro enunciado. Incluye, como estaba marcado para hoy, el re-test de P1 y P5 del quiz del Día 7.

**R1.** Un administrador con el rol **Microsoft Sentinel Contributor** intenta crear un workbook nuevo desde cero en un resource group donde nunca antes se había creado ninguno, y la operación falla. ¿Qué le falta?

- A) Nada le falta: Sentinel Contributor ya incluye todo lo necesario para crear workbooks
- B) El rol **Workbook Contributor** sobre ese resource group, además de su rol de Sentinel
- C) El rol Logic App Contributor, porque los workbooks se ejecutan como Logic Apps por debajo
- D) Acceso de administrador global de Azure, porque crear workbooks es una operación a nivel de suscripción

**R2.** Un analista de SOC está en **Settings → Microsoft Defender XDR → Email notifications**, revisando cómo configurar el envío de correos cuando aparezca un nuevo incidente de severidad alta. ¿En qué rama del portal está correctamente parado?

- A) Está en la rama correcta: las notificaciones de incidentes viven exactamente ahí
- B) Está equivocado: las notificaciones de incidentes viven en Settings → Endpoints → General
- C) Está equivocado: las notificaciones de incidentes se configuran solo desde una automation rule, no desde Settings
- D) Está equivocado: las notificaciones de incidentes requieren primero crear un playbook de Logic Apps

**R3.** Una analytics rule de Sentinel correlaciona tres alertas individuales de distintos productos (Defender for Endpoint, Entra ID Protection y Defender for Cloud Apps) en un solo caso de investigación. ¿En qué tabla de Log Analytics consultas ese caso correlacionado como una sola entidad?

- A) `SecurityAlert`, filtrando por el campo `ProductName`
- B) `SecurityIncident`, que representa la correlación hecha por Sentinel
- C) `AlertEvidence`, que combina las tres alertas en una fila
- D) `ThreatIntelIndicators`, porque ahí se guardan las correlaciones automáticas

**R4.** El reporte **Risky users** y el reporte **Risky sign-ins** de Entra ID Protection muestran información distinta. Un analista necesita identificar qué usuarios acumularon actividad de riesgo **a lo largo de las últimas dos semanas**, no un evento de inicio de sesión puntual. ¿Qué reporte usa?

- A) Risky sign-ins report, porque agrupa todos los inicios de sesión sospechosos del periodo
- B) Risky users report, porque agrega el riesgo de un usuario a través del tiempo, no por evento individual
- C) Ninguno de los dos: esa vista solo existe en Microsoft Sentinel vía KQL
- D) Risky sign-ins report, filtrando por el campo `RiskState` en lugar de por usuario

> [!note]- Ver respuestas
> **R1 — B (re-test P1, Día 7).** Crear o eliminar workbooks exige la **combinación** de un rol de Sentinel **más** el rol **Workbook Contributor** sobre el resource group — ninguno de los dos solo es suficiente. **A** es justamente el error que cometiste el 9-ago: Sentinel Contributor no incluye por sí solo el permiso de Azure Resource Manager para gestionar el recurso "workbook". **C** confunde tecnologías: los workbooks no corren sobre Logic Apps (eso son los playbooks). **D** es un permiso excesivo e innecesario.
>
> **R2 — B (re-test P5, Día 7).** Las notificaciones de **incidentes** se configuran en **Settings → Endpoints → General**, no en la rama de Microsoft Defender XDR de Email notifications (que es la ruta de notificaciones de **vulnerabilidades**). Es la trampa exacta que ya te costó puntos: dos rutas de notificación que suenan intercambiables y no lo son. **A** describe la ruta de vulnerabilidades, no la de incidentes. **C** y **D** inventan requisitos previos que no existen para simplemente recibir un correo.
>
> **R3 — B.** Regla fijada tras el fallo del quiz del Día 6: una **alerta individual** de un producto vive en `SecurityAlert`; un **incidente correlacionado** por Sentinel (varias alertas de distintos productos unidas en una sola historia de ataque) vive en `SecurityIncident`. **A** describe la tabla de alertas sueltas, no de la correlación. **C** describe mal `AlertEvidence`, que guarda entidades de evidencia de una alerta, no la correlación de varias alertas. **D** es un distractor inventado: esa tabla es de indicadores de threat intelligence, sin relación con correlación de alertas.
>
> **R4 — B.** El **Risky users report** agrega el riesgo de un usuario **a través del tiempo** (varias señales acumuladas), mientras que el **Risky sign-ins report** muestra riesgo **por evento puntual** de inicio de sesión. El enunciado pide explícitamente "a lo largo de las últimas dos semanas", que es la definición misma del primero. **A** y **D** describen el reporte equivocado para ese calificador de tiempo. **C** es falso: ambos reportes existen de forma nativa en el portal de Entra ID Protection, sin necesidad de Sentinel.

---

## ⚠️ Trampas del examen en los temas de hoy

1. **Timeline ≠ Advanced hunting.** Timeline: un solo dispositivo, sin KQL, ideal para "antes de la alerta". Advanced hunting: multi-dispositivo/multi-SO, con KQL, ideal para "alcance del incidente".
2. **Collect investigation package NO aísla el dispositivo.** Es forense pasivo; si el enunciado pide "minimizar impacto" o "sin cortar la red", esta es casi siempre la respuesta, no Isolate device.
3. **Isolate device (dispositivo onboardeado) ≠ Contain device (dispositivo NO administrado).** El criterio que decide es si el dispositivo tiene o no el sensor de MDE instalado.
4. **La retención por defecto del Timeline es de 90 días**, no ilimitada ni de 30 — dato nuevo, verificado hoy contra Microsoft Learn.
5. **RBAC de MDE es granular y las tres capas son independientes:** Active remediation actions (contener) ≠ Alerts investigation (recolectar/AIR/AV scan) ≠ Live response capabilities Basic/Advanced (shell remoto). Tener uno no implica tener los otros.
6. **Dentro de Live response, `isolate`/`release` solo existen como comandos para macOS.** En Windows, aislar es un botón de la página del dispositivo, no un comando de la consola.
7. **El aislamiento manual se levanta automáticamente a los 7 días** si nadie lo libera antes.
8. **Restrict app execution no corta la red** — solo bloquea la ejecución de programas no firmados por Microsoft. Es más quirúrgico que Isolate device, no un sinónimo.
9. **`SecurityAlert` (alerta individual de producto) vs `SecurityIncident` (incidente correlacionado de Sentinel)** — regla que ya falló dos veces en este curso, reforzada hoy en R3.

---

## 🔗 Notas relacionadas

- [[Dia 06 - AIR Attack Disruption Automation Rules y Playbooks]] — Attack disruption, sus acciones automáticas (Isolate/Contain/Revoke session) y el retiro de AIR del 1-sep-2026 (solo Defender for Endpoint), que hoy se conecta directamente con la sección 8
- [[Dia 07 - Workbooks SOC Optimization Roles de Sentinel y Notificaciones]] — origen de R1 y R2 del repaso acumulativo de hoy
- [[Dia 08 - Incidentes Unificados y Case Management]] — RBAC unificado de Defender XDR (Security operations > ...), mencionado como contraste con el RBAC clásico de MDE de la sección 6
- [[PLAN_MAESTRO_MULTITRACK]] — calendario vigente, examen 3-oct-2026
- [[REPASO_RAPIDO_Errores_Simulacro]] — §6, origen del diagnóstico que hoy se ataca de raíz
- [[TRACKER_TUTOR]]

## 📚 Fuentes verificadas hoy (12-ago-2026)

- [Investigate devices in Microsoft Defender for Endpoint](https://learn.microsoft.com/en-us/defender-endpoint/investigate-machines) — actualizado 23-jul-2026, fuente principal de la sección 2 (Timeline, retención de 90 días, MITRE ATT&CK, event flagging)
- [Investigate entities on devices using live response](https://learn.microsoft.com/en-us/defender-endpoint/live-response) — actualizado 29-jul-2026, fuente principal de la sección 3 (prerrequisitos, comandos básicos/avanzados, límites)
- [Take response actions on a device in Microsoft Defender for Endpoint](https://learn.microsoft.com/en-us/defender-endpoint/respond-machine-alerts) — actualizado 7-ago-2026, fuente principal de las secciones 4 y 5 (contenido del investigation package, Isolate vs Contain, Restrict app execution)
- [Create and manage roles for role-based access control](https://learn.microsoft.com/en-us/defender-endpoint/user-roles) — actualizado 17-jun-2026, fuente principal de la sección 6 (permisos RBAC exactos, y el aviso sobre URBAC desde 16-feb-2025)
- [Study guide for Exam SC-200](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/sc-200) — skills measured as of July 28, 2026, verificado el desglose del Dominio 2
