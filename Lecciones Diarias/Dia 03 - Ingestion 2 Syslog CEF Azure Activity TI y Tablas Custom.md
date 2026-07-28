---
tags: [sc-200, sentinel, leccion-diaria, ingestion, syslog, cef, azure-activity, threat-intelligence, custom-logs]
dia: 3
fecha: 2026-07-09
dominio: "Dominio 1 — Manage a security operations environment (40-45%)"
estado: ✅ Completada
cover: ""
---

# Lección Día 3 — Ingestión 2: Syslog/CEF, Azure Activity, Threat Intelligence y tablas custom

> [!info] Contexto
> Día 3 del plan de [[GUIA_INTENSIVA_24_DIAS]] (dominio 1, 40–45% del examen). Ayer resolvimos cómo llegan los eventos de **Windows** a Sentinel (AMA, DCR, WEF). Hoy cerramos el resto del mapa de ingestión: dispositivos que NO son Windows (firewalls, routers, servidores Linux) hablando **Syslog/CEF (Common Event Format)**, la actividad de control del propio **Azure** escalada con **Azure Policy**, la inteligencia de amenazas externa (**Threat Intelligence**) y qué hacer cuando una fuente no encaja en ningún esquema existente (**tablas custom**). Sin dominar esto no puedes responder ni el 40% de preguntas de "elige el conector/tabla correcta".

> [!warning] Corrección sobre la guía del vault
> [[GUIA_INTENSIVA_24_DIAS]] trae en su §3.1 y en la fila del Día 3 una query de ejemplo contra la tabla `ThreatIntelligenceIndicator` (singular, sin plural). **Ese nombre de tabla es legado y quedó retirado el 31 de julio de 2025.** Desde el 3 de abril de 2025 Microsoft Sentinel usa dos tablas nuevas: `ThreatIntelIndicators` (IOCs clásicos) y `ThreatIntelObjects` (objetos STIX ricos: actores, malware, patrones de ataque). Si el examen o un lab te muestra `ThreatIntelligenceIndicator`, es una versión vieja de la documentación — usa las tablas nuevas. Corrijo esto en la lectura de abajo.

## 📖 Lectura

### El mapa completo de ingestión (dónde encaja el día de hoy)

Ayer vimos la mitad "Windows" del mapa. La otra mitad son fuentes que **no hablan el idioma nativo de Windows** (Event Log/XPath) sino protocolos abiertos y multiplataforma, más dos categorías especiales: telemetría que genera el propio **Azure** sobre sí mismo, e información que **no genera tu organización** sino que viene de afuera (threat intelligence). Y al final, la fuente "no clasificable": cualquier cosa custom.

### 1. Syslog vía AMA

**¿Qué es Syslog?** Es un protocolo estándar (definido formalmente en el RFC 5424) para que un sistema — típicamente Linux/Unix, pero también routers, switches, firewalls, hipervisores — emita mensajes de registro de eventos hacia un destino, local o remoto. Cada mensaje syslog trae, entre otras cosas: una **facility** (categoría de origen: kernel, mail, auth, etc.), un **severity level** (de 0=emergencia a 7=debug), una marca de tiempo, el nombre del host que lo generó y un texto de mensaje **libre** — es decir, sin una estructura fija más allá de esos campos. Por defecto viaja por el puerto **514** (UDP o TCP).

**El problema que resuelve el conector "Syslog vía AMA":** un firewall físico, un switch, o un appliance de seguridad normalmente **no te dejan instalar un agente** dentro (no es un sistema operativo de propósito general donde puedas meter software). Lo que SÍ hacen es **emitir mensajes syslog hacia una IP que tú les indiques**. La solución: levantas una **máquina Linux dedicada** (puede ser una VM chica) que actúa de **reenviador (forwarder)**. En esa VM Linux corre un **daemon de syslog** — típicamente `rsyslog` o `syslog-ng`, el proceso nativo de Linux que escucha en el puerto 514 y escribe lo que recibe en un archivo local. Sobre esa MISMA VM Linux instalas el **AMA** (sí, el mismo Azure Monitor Agent del Día 2, que también corre en Linux), con una **DCR** que lee lo que el daemon syslog fue acumulando localmente y lo sube al workspace, a la tabla **`Syslog`**.

Cadena completa: `[Appliance] --syslog UDP/TCP 514--> [VM Linux con rsyslog escuchando] --AMA lee el log local + DCR--> [tabla Syslog en el workspace]`.

### 2. [[CEF]] vía AMA

**¿Qué es CEF (Common Event Format)?** Es un **formato de estructuración** de eventos, creado originalmentente por ArcSight y adoptado como estándar de facto por la mayoría de fabricantes de seguridad (firewalls de próxima generación, IDS/IPS, proxies, EDR de terceros). CEF **viaja sobre syslog** (usa el mismo transporte, mismo puerto 514) pero el cuerpo del mensaje sigue una plantilla fija: una cabecera con campos obligatorios (versión CEF, fabricante, producto, versión del producto, ID de clase de evento, nombre, severidad) seguida de una lista de pares **clave=valor** (extensiones) como IP origen, IP destino, usuario, acción tomada, etc.

**Por qué importa la diferencia con Syslog plano:** un mensaje Syslog genérico es texto libre — Sentinel lo guarda tal cual en la tabla `Syslog`, como una sola columna de texto sin parsear campo por campo. Un mensaje **CEF**, en cambio, SÍ tiene una estructura predecible, así que el conector **CEF vía AMA** puede parsearlo automáticamente y guardarlo en una tabla con **columnas propias y con nombre** — la tabla **`CommonSecurityLog`** (`DeviceVendor`, `DeviceProduct`, `SourceIP`, `DestinationIP`, `Activity`, etc.). Eso hace que escribir detecciones sobre `CommonSecurityLog` sea mucho más directo que sobre `Syslog` en texto libre.

**Regla para el examen:** si el fabricante del dispositivo dice explícitamente "soporta CEF" (la gran mayoría de firewalls empresariales lo hacen) → usa **CEF vía AMA** (mejor estructura, mejor para analytics rules). Si es un servidor Linux/Unix genérico que solo emite syslog plano de aplicación (sin formato CEF) → usa **Syslog vía AMA**. Arquitectónicamente son casi idénticos (mismo daemon, mismo puerto, misma VM Linux forwarder incluso pueden convivir en la misma máquina), la diferencia real está en el **parseo** y la **tabla destino**.

### 3. Azure Activity y Azure Policy para escalar

**¿Qué es el Azure Activity Log?** Es el registro de **auditoría del plano de control** de una suscripción de Azure: quién hizo qué operación sobre qué recurso (crear una VM, borrar un Key Vault, cambiar un rol RBAC), cuándo, y desde qué IP — todo lo que pasa **a través de Azure Resource Manager (ARM)**, el motor que procesa cualquier operación de gestión sobre recursos de Azure. Esto es distinto de los **logs de recurso** (resource logs), que registran lo que pasa **dentro** de un recurso específico (por ejemplo, las queries que corren dentro de una base de datos SQL).

**Cómo llega a Sentinel:** el conector "Azure Activity" en realidad es una **diagnostic setting** — una configuración de Azure Monitor que existe **por cada suscripción** y le dice "manda tu Activity Log a este Log Analytics workspace, tabla `AzureActivity`". El problema aparece cuando tienes **muchas suscripciones** (una organización real puede tener decenas): configurar la diagnostic setting una por una, a mano, no escala y es fácil olvidar una suscripción nueva que se crea el mes que viene.

**La solución: Azure Policy con efecto `DeployIfNotExists`.** Azure Policy es el servicio de gobierno de Azure que evalúa reglas contra tus recursos y puede, además de solo "avisar", **desplegar automáticamente una configuración faltante**. El efecto `DeployIfNotExists` significa exactamente eso: "si este recurso no tiene la configuración X, despliégala tú mismo". Microsoft ofrece una **política integrada (built-in)** justo para esto: aplicada a nivel de **management group** (el contenedor que agrupa varias suscripciones, arriba en la jerarquía de Azure), la política revisa cada suscripción de ese management group y, si le falta la diagnostic setting hacia tu workspace, la crea.

**Detalle importante para el examen:** `DeployIfNotExists` **actúa automáticamente sobre recursos NUEVOS** que se crean después de asignar la política (los detecta al nacer y los remedia solos). Pero para los recursos que **ya existían antes** de asignar la política, la evaluación solo los marca como "no cumplen" (non-compliant) — **no les aplica el arreglo solo**. Para corregir el pasado hace falta lanzar manualmente una **remediation task** (tarea de remediación), que sí ejecuta el despliegue sobre todos los recursos ya existentes marcados como no conformes.

### 4. Threat Intelligence (TI): traer inteligencia externa

**¿Qué es Threat Intelligence en este contexto?** Información sobre amenazas conocidas, producida por **terceros** (proveedores comerciales, comunidades de intercambio, el propio Microsoft), que tú importas para **comparar contra tu propia telemetría** y detectar coincidencias — por ejemplo, "esta IP aparece en tus logs de red Y también aparece en una lista de servidores de comando y control conocidos".

**STIX (Structured Threat Information eXpression):** es el **lenguaje/formato** (en JSON) para describir esa información de forma estandarizada. STIX no solo describe "indicadores" simples (una IP, un hash de archivo, un dominio, una URL) sino también objetos más ricos: **Threat Actor** (un grupo o individuo atacante conocido), **Malware** (una familia de malware), **Attack Pattern** (una técnica, típicamente mapeada a MITRE ATT&CK), **Identity** y **Relationship** (cómo se conectan estos objetos entre sí — "este actor usa este malware").

**TAXII (Trusted Automated Exchange of Intelligence Information):** es el **protocolo de transporte** — el "cómo se mueve" el contenido STIX entre un servidor que publica feeds (TAXII server) y un cliente que se suscribe (TAXII client, en este caso, Sentinel).

**Tres formas de traer TI a Sentinel:**
1. **Conector "Threat Intelligence - TAXII"**: te conectas a cualquier servidor TAXII 2.0/2.1 (feeds comerciales, ISACs — centros de intercambio de información sectorial — o feeds abiertos).
2. **Conector MDTI (Microsoft Defender Threat Intelligence)**: el feed curado propio de Microsoft.
3. **Threat Intelligence Upload Indicators API**: una API REST para cuando tu fuente **no habla TAXII** — por ejemplo, tu propia plataforma SOAR o un feed casero — y necesitas empujar indicadores por tu cuenta mediante programación.

**Las tablas destino (¡esto cambió y es donde la guía del vault quedó desactualizada!):** desde el 3 de abril de 2025, todo lo anterior aterriza en dos tablas nuevas:
- **`ThreatIntelIndicators`**: los IOCs clásicos (IP, dominio, URL, hash de archivo, email) — el objeto STIX tipo "Indicator".
- **`ThreatIntelObjects`**: los objetos STIX que NO son indicadores simples — Threat Actors, Attack Patterns (técnicas MITRE), Identities, Relationships, Malware — contexto más rico para hunting.

La tabla legada **`ThreatIntelligenceIndicator`** (singular) siguió recibiendo datos en paralelo solo como período de transición, y **dejó de recibir datos nuevos el 31 de julio de 2025**. Está retirada. Cualquier analytics rule, workbook o hunting query que aún la referencie hay que migrarla a las dos tablas nuevas.

### 5. Tablas custom (`_CL`): cuando nada encaja

**¿Cuándo hace falta esto?** Cuando tu fuente de datos no tiene conector nativo ni encaja en ningún esquema existente — por ejemplo, una aplicación interna que emite eventos propios en JSON, o un SaaS de nicho sin integración con Sentinel. La solución es crear tu **propia tabla**, cuyo nombre debe terminar obligatoriamente en el sufijo **`_CL`** (Custom Log) — el portal lo agrega automáticamente y sirve para distinguir de un vistazo una tabla estándar de una custom.

**El método vigente: Logs Ingestion API basada en DCR.** Reemplaza al método legado, la **HTTP Data Collector API** (una API más vieja, autenticada con una clave compartida de todo el workspace, sin soporte de transformación). Ese método legado **deja de tener soporte para incidentes de Microsoft a partir del 14 de septiembre de 2026** — para el examen de julio 2026, ya se considera el camino a evitar; el vigente es el basado en DCR.

**Piezas necesarias para el método vigente:**
1. **Data Collection Endpoint (DCE)**: la URL pública concreta a la que tu aplicación/script hace la llamada HTTP POST con los datos.
2. **La tabla custom (`_CL`)**: se crea en el workspace definiendo su esquema (columnas y tipos), normalmente arrancando de un JSON de ejemplo que subes en el asistente del portal.
3. **La DCR**: define el esquema del stream entrante, una transformación KQL opcional (exactamente como la del Día 2), y el mapeo hacia la tabla destino.
4. **Una aplicación registrada en Microsoft Entra ID** (un service principal) con el rol RBAC (*Role-Based Access Control*) **"Monitoring Metrics Publisher"** asignado sobre esa DCR — es la identidad que se autentica (vía OAuth) cuando tu script llama a la API.

**Flujo:** tu aplicación arma un payload JSON → se autentica como la app de Entra → hace `POST` al DCE, indicando el `immutableId` de la DCR y el nombre del stream → la DCR aplica la transformación si existe → el dato queda en la tabla `_CL`.

**Ventaja sobre el método legado:** autenticación OAuth (en vez de una clave compartida de todo el workspace), transformación en tiempo de ingestión (puedes filtrar/enmascarar antes de guardar, igual que con DCR de Windows), y permisos finos por DCR en vez de un solo secreto que abre todo el workspace.

### Regla mental del día — qué conector uso según la fuente

| Fuente | Conector/mecanismo | Tabla destino |
|---|---|---|
| Windows Security Event Log (repaso Día 2) | Windows Security Events via AMA (+ WEF si no hay salida directa) | `SecurityEvent` |
| Servidor Linux/Unix, syslog genérico sin formato CEF | Syslog vía AMA | `Syslog` |
| Firewall/IDS/appliance que habla CEF | CEF vía AMA | `CommonSecurityLog` |
| Actividad de control de Azure (ARM) | Diagnostic setting "Azure Activity" (+ Azure Policy `DeployIfNotExists` a escala) | `AzureActivity` |
| Inteligencia de amenazas externa | TAXII / MDTI / Upload Indicators API | `ThreatIntelIndicators` + `ThreatIntelObjects` |
| Fuente sin conector ni esquema existente | Tabla custom `_CL` + Logs Ingestion API (DCE + DCR + app Entra) | `NombreQueElijas_CL` |

## 💡 Ejemplos

**1 — Elegir Syslog vs CEF (tipo examen)**

*Escenario:* "Contoso despliega un firewall Palo Alto de nueva generación que, según su ficha técnica, soporta exportar sus logs en formato CEF. El equipo levanta una VM Ubuntu en la misma red que actuará de intermediaria."

*Razonamiento:* como el fabricante confirma soporte CEF, la respuesta es **CEF vía AMA**, no Syslog vía AMA genérico — obtienes la tabla estructurada `CommonSecurityLog` con columnas ya parseadas (`DeviceVendor`, `SourceIP`, etc.) en vez de texto libre en `Syslog`. Arquitectura: el firewall se configura para enviar CEF por syslog UDP 514 hacia la IP de la VM Ubuntu; en la VM, `rsyslog` escucha ese puerto; se instala AMA en la VM con el conector "CEF vía AMA" y su DCR asociada.

```kql
// Verificar ingestión CEF y qué fabricantes están llegando
CommonSecurityLog
| where TimeGenerated > ago(1h)
| summarize Eventos = count() by DeviceVendor, DeviceProduct
| order by Eventos desc
```

**2 — Azure Policy a escala (tipo examen)**

*Escenario:* "Contoso tiene 40 suscripciones bajo un management group llamado `mg-contoso-prod`. Quieren que el Activity Log de TODAS ellas, incluidas las que se creen el próximo trimestre, llegue automáticamente al workspace central de Sentinel, sin depender de que cada equipo configure su diagnostic setting a mano."

*Razonamiento:* se asigna la política integrada de Azure Policy para desplegar diagnostic settings de Azure Activity (efecto `DeployIfNotExists`) con **scope en `mg-contoso-prod`** (el management group, no cada suscripción individual, para que herede a todas, incluidas las futuras). Para las 40 suscripciones que **ya existen hoy**, la asignación de la política **no las corrige sola** — solo las marca como "non-compliant" en la primera evaluación. Hay que lanzar una **remediation task** para aplicar el fix retroactivamente. Las suscripciones que se creen después del día de la asignación sí quedan cubiertas automáticamente desde su creación.

**3 — Threat Intelligence: tablas correctas (corrigiendo el error de la guía)**

*Escenario:* "Un analista configuró el conector Threat Intelligence - TAXII apuntando a un feed abierto y quiere confirmar que los indicadores IOC (*Indicator of Compromise*; IPs, dominios) están llegando, además de revisar si el feed trae contexto de threat actors."

*Razonamiento:* la query NO debe usar `ThreatIntelligenceIndicator` (tabla retirada desde el 31-jul-2025). Se consulta:

```kql
// IOCs clásicos (IP, dominio, hash, URL) llegados por TAXII/MDTI/Upload API
ThreatIntelIndicators
| where TimeGenerated > ago(7d)
| extend PatternType = tostring(parse_json(Data).pattern_type)
| summarize count() by PatternType
| order by count_ desc
```

```kql
// Contexto rico: threat actors y malware asociados (objetos STIX no-indicador)
ThreatIntelObjects
| where TimeGenerated > ago(7d)
| extend ObjectType = tostring(parse_json(Data).type)
| summarize count() by ObjectType
```

## 🎥 Recursos

1. [Microsoft Sentinel: Threat Intelligence | TAXII | Defender TI](https://www.youtube.com/watch?v=ngOfQ_WFXgk) — demo práctico de configurar los conectores de threat intelligence (TAXII y MDTI) en Sentinel. Bueno para ver el flujo completo de configuración, aunque no cubre todavía el split de tablas de abril 2025 — mira los pasos de configuración, no los nombres de tabla que mencione.
2. No encontré un video reciente (2025–2026) específicamente bueno sobre CEF/Syslog vía AMA o sobre la Logs Ingestion API para tablas custom — te lo digo honestamente en vez de inventar un enlace. En su lugar, usa la documentación oficial, que sí está actualizada a 2026: [Syslog and CEF AMA connectors — overview](https://learn.microsoft.com/en-us/azure/sentinel/cef-syslog-ama-overview) y [Logs Ingestion API in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/logs-ingestion-api-overview) (tutorial paso a paso con el asistente del portal para crear la tabla `_CL`, la DCE y la DCR).

## 🧪 Ejercicio práctico

> [!info] Requisito
> Usa el mismo workspace de Sentinel del Día 1. Para hoy no hace falta un firewall real: simulamos la parte Syslog con una VM Linux barata (Ubuntu `Standard_B1s`, apágala al terminar para no gastar crédito).

- [x] **Paso 1 — Desplegar una VM Linux** (Ubuntu Server, tamaño B1s) en el mismo resource group. Anota su IP privada.
- [x] **Paso 2 — Conectar "Syslog vía AMA"**: en Content hub/Data connectors, abre "Syslog via AMA" → crea la DCR → selecciona tu VM Linux como recurso, elige las facilities que quieras recolectar (por ejemplo `auth`, `daemon`, `local4`).
- [x] **Paso 3 — Generar tráfico syslog de prueba**: conéctate por SSH a la VM y ejecuta `logger -p local4.info "Prueba SC-200 Dia 3 - evento de prueba"` para inyectar un mensaje syslog local.
- [x] **Paso 4 — Verificar ingestión**:
  ```kql
  Syslog
  | where TimeGenerated > ago(20m)
  | where SyslogMessage has "SC-200"
  ```
- [x] **Paso 5 — Azure Policy a escala**: en Azure Policy, busca la política integrada para desplegar diagnostic settings de Activity Log hacia un Log Analytics workspace (busca "Activity log" en las definiciones built-in). Asígnala con scope en tu suscripción (o management group si tienes uno) apuntando a tu workspace del Día 1. Si tu suscripción ya tenía recursos, lanza una **remediation task** y confirma que el Activity Log empieza a llegar:
  ```kql
  AzureActivity
  | where TimeGenerated > ago(1h)
  | summarize count() by OperationNameValue, Caller
  ```
- [x] **Paso 6 — Conectar Threat Intelligence**: activa el conector "Threat Intelligence - TAXII" con un feed abierto de prueba (documentación oficial trae ejemplos de servidores TAXII públicos para práctica) y confirma con las queries del Ejemplo 3 de arriba (`ThreatIntelIndicators` / `ThreatIntelObjects`, NO la tabla vieja).
- [ ] **Paso 7 — (Opcional, si el tiempo alcanza) Crear una tabla custom**: en el workspace, ve a Tables → Create → "New custom log (DCR-based)", sube un JSON de ejemplo simple (`{"Mensaje": "prueba", "Nivel": "info"}`), deja que el asistente cree la tabla `_CL`, la DCE y la DCR automáticamente. No hace falta programar el envío por API hoy — con ver el asistente y entender las 4 piezas (DCE, tabla, DCR, app Entra) alcanza para el examen.

## ✅ Quiz del día

**P1.** Un dispositivo de red confirma soporte para CEF. ¿Qué conector eliges y en qué tabla aterrizan los datos ya estructurados?
A) Syslog vía AMA → `Syslog` · B) Windows Security Events via AMA → `SecurityEvent` · C) Custom logs API → tabla `_CL` · D) CEF vía AMA → `CommonSecurityLog`

**P2.** ¿Por qué un mensaje Syslog genérico (no-CEF) no puede aprovechar columnas estructuradas como `SourceIP` o `DeviceVendor` en Sentinel?
A) Porque es texto libre sin una plantilla de campos fija, a diferencia de CEF que sí define cabecera + pares clave=valor · B) Porque Syslog usa un puerto distinto · C) Porque requiere licencia adicional · D) Porque el AMA no soporta Linux

**P3.** Asignas una política `DeployIfNotExists` para diagnostic settings de Activity Log a nivel de management group. Tenías 40 suscripciones ya existentes antes de asignarla. ¿Qué pasa con esas 40 automáticamente?
A) Se corrigen solas en la siguiente evaluación · B) Se marcan como "non-compliant" pero necesitan una remediation task manual para corregirse · C) Se bloquea la creación de nuevos recursos hasta corregirlas · D) Nada, ni siquiera se marcan

**P4.** ¿En qué tabla aterrizan hoy los indicadores clásicos (IP, dominio, hash, URL) ingeridos vía TAXII, MDTI o la Upload API?
A) `ThreatIntelligenceIndicator` (aún vigente) · B) `CommonSecurityLog` · C) `ThreatIntelIndicators` · D) `ThreatIntelObjects`

**P5.** Necesitas ingerir eventos JSON de una aplicación interna sin conector nativo, con transformación en tiempo de ingestión y autenticación OAuth (no una clave compartida de todo el workspace). ¿Qué método usas?
A) HTTP Data Collector API (legado) · B) Syslog vía AMA · C) Conector genérico REST de Sentinel · D) Logs Ingestion API basada en DCR, con tabla `_CL`, DCE, DCR y una app de Entra con rol Monitoring Metrics Publisher

### Respuestas explicadas

> [!note]- Ver respuestas (spoiler)
> **P1 — D.** El fabricante soporta CEF, así que el conector correcto es CEF vía AMA, que parsea el mensaje en columnas propias dentro de `CommonSecurityLog`.
> **P2 — A.** Syslog plano es texto libre; CEF define una cabecera y extensiones clave=valor que sí se pueden parsear en columnas con nombre.
> **P3 — B.** `DeployIfNotExists` solo remedia automáticamente recursos nuevos evaluados después de la asignación; los que ya existían quedan marcados como non-compliant hasta correr una remediation task.
> **P4 — C.** `ThreatIntelIndicators` es la tabla vigente para IOCs desde abril de 2025; `ThreatIntelObjects` es para objetos STIX no-indicador (actores, malware, etc.); la tabla legada `ThreatIntelligenceIndicator` dejó de recibir datos el 31-jul-2025.
> **P5 — D.** Es exactamente el caso de uso de la Logs Ingestion API basada en DCR: tabla custom `_CL`, DCE como endpoint, DCR con transformación opcional, y autenticación OAuth vía una app de Entra con el rol Monitoring Metrics Publisher sobre la DCR.

---

*Relacionadas: [[GUIA_INTENSIVA_24_DIAS]] · [[TRACKER_TUTOR]] · [[Dia 02 - Ingestion 1 AMA DCR Windows Security Events y WEF]] · [[CHEATSHEET_KQL]]*
