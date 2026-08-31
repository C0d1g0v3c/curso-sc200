---
tags: [sc-200, purview, audit, ediscovery, graph-activity-logs, security-copilot, copilot-embebido, leccion-diaria]
dia: 13
fecha: 2026-08-31
fecha_programada: 2026-08-27
dominio: "Dominio 2 — Respond to security incidents (35-40%) — CIERRA HOY"
estado: 🟡 En curso
cover: ""
---

# Lección Día 13 — Purview Audit, eDiscovery, Microsoft Graph Activity Logs y Copilot Embebido

> [!info] Contexto
> Día 13 del plan de [[PLAN_MAESTRO_MULTITRACK]] §8.3, dentro del **Dominio 2 — Respond to security incidents (35-40% del examen)**. Estaba programado para el jueves 27-ago y se retoma hoy, tercera lección del día dentro del mismo catch-up que ya cerró los Días 11 y 12 — el retraso queda anotado en el tracker, sin maquillar.
>
> Objetivos exactos del study guide oficial (skills measured as of July 28, 2026) que cierra hoy: **"Investigate Microsoft 365 activities to identify threats using Microsoft Purview Audit, eDiscovery, and Microsoft Graph activity logs"** (dentro del sub-bloque *Investigate Microsoft 365 activities to identify threats*) y **"Investigate and manage agentic AI systems and Copilot embedded experiences"** (dentro de *Respond to alerts and incidents in Microsoft Defender XDR*). Con esta lección **se completa el Dominio 2 al 100%**: es el último día de contenido nuevo de ese dominio.
>
> Este día es distinto a los tres anteriores (MDO/MDCA, Entra ID Protection/MDI, Defender for Cloud): hasta ahora investigabas amenazas dentro de un producto de seguridad. Hoy investigas **actividad de usuarios y aplicaciones dentro de los servicios de Microsoft 365 mismos** (¿quién compartió qué documento? ¿qué hizo una app contra Microsoft Graph?), con herramientas que viven en un portal distinto (Microsoft Purview, no Defender) y que la mayoría de las veces **no aparecen en ninguna tabla de Sentinel ni de Advanced Hunting** — el dato más importante que debes fijar hoy antes de cualquier otro.

---

## 📖 Lectura del día

### 0. Dónde estamos: hoy se completa el Dominio 2

| Sub-bloque del Dominio 2 | Qué agrupa | Cuándo lo viste |
|---|---|---|
| Respond to alerts and incidents in Microsoft Defender XDR — gestión de incidentes | Manage incident pane, Case management, ataques multi-etapa | Día 8 |
| Respond to alerts and incidents in Microsoft Defender XDR — respuesta por producto | MDO, MDCA (Día 10) · Entra ID Protection, MDI (Día 11) · Defender for Cloud (Día 12) | Días 10, 11, 12 |
| Respond to alerts and incidents in Microsoft Defender XDR — agentic AI / Copilot embebido | Qué hace Copilot dentro de Defender XDR y cómo se usa al investigar | **Hoy** |
| Respond to alerts and incidents in Microsoft Defender for Endpoint | Device timeline, live response, investigation package, evidencia | Día 9 |
| **Investigate Microsoft 365 activities to identify threats** | Purview Audit, eDiscovery, Microsoft Graph activity logs | **Hoy — cierra el Dominio 2** |

### 1. El problema que resuelve Purview y por qué es distinto a todo lo visto hasta ahora

Hasta el Día 12, cada herramienta que estudiaste vivía dentro de un producto de seguridad (Defender for Endpoint, Defender for Office 365, Defender for Cloud) y generaba **alertas** que terminaban, casi siempre, en las tablas `SecurityAlert` y `SecurityIncident` de Sentinel. **Microsoft Purview** es distinto: es la plataforma de gobernanza, cumplimiento normativo (compliance) y protección de datos de Microsoft 365 — no genera alertas de "ataque detectado", sino **registros de actividad**: quién hizo qué, cuándo, sobre qué archivo o buzón. El examen no te pide administrar Purview como plataforma completa (eso incluiría DLP — Data Loss Prevention —, Insider Risk Management, retención); te pide **investigar amenazas usando tres piezas concretas de Purview**, que resuelven tres preguntas distintas:

| Herramienta | Pregunta que responde | Ejemplo de uso |
|---|---|---|
| **Purview Audit** | "¿QUÉ HIZO este usuario/admin/app? (una operación puntual, ya ocurrida)" | "¿User1 compartió un archivo de OneDrive la semana pasada?" |
| **Purview eDiscovery** | "¿QUÉ CONTENIDO existe o se movió, para preservarlo o exportarlo?" | "Encuentra todos los correos con el adjunto malicioso X, en toda la organización, y colócalos en retención legal" |
| **Microsoft Graph activity logs** | "¿Qué llamadas hizo una aplicación o un token contra la API de Microsoft Graph?" | "¿Una app OAuth comprometida está enumerando usuarios o descargando archivos vía API, en vez de por la interfaz normal?" |

**Regla de una línea para no confundirlas en el examen:** Audit = una **operación** ya registrada sobre un objeto. eDiscovery = **preservar y exportar contenido** para una investigación legal o forense. Graph activity logs = **tráfico de API**, no interacción humana en un portal.

### 2. Microsoft Purview Audit: Standard vs Premium

**Microsoft Purview Audit** es el registro unificado de actividad (unified audit log) de Microsoft 365: cuando un usuario o un administrador realiza una acción auditable (abrir un archivo, compartir un enlace, cambiar un permiso, iniciar sesión, eliminar un buzón), el sistema genera un **registro de auditoría** y lo guarda en este log central. Verificado hoy en Microsoft Learn (`audit-solutions-overview`, actualizado 8-jul-2026): existe en dos niveles, y **Audit (Premium) incluye toda la funcionalidad de Audit (Standard)**, no es un producto aparte.

| Capacidad | Audit (Standard) | Audit (Premium) |
|---|---|---|
| Habilitado por defecto | ✅ | ✅ |
| Búsqueda de miles de eventos auditados | ✅ | ✅ |
| Retención por defecto | **180 días** | **180 días** para la mayoría de actividades |
| Retención de Entra ID, Exchange, OneDrive, SharePoint | 180 días | **1 año** por defecto (vía política de retención automática) |
| Retención extendida hasta 10 años | ❌ | ✅ (requiere licencia add-on adicional de 10 años, por usuario) |
| Políticas de retención de auditoría personalizadas | ❌ | ✅ |
| **Intelligent insights** (eventos forenses de alto valor) | ❌ | ✅ |
| Ancho de banda a la Office 365 Management Activity API | Baseline (2,000 solicitudes/min) | ~2x el baseline (escala con el tamaño y licenciamiento del tenant) |

**Qué son los "Intelligent insights" de Premium, en concreto (el dato que el examen más pregunta):** son eventos forenses que **Standard no registra en absoluto**, no una versión "resumida" de lo mismo. Los dos ejemplos que Microsoft Learn cita explícitamente: **`MailItemsAccessed`** (cuándo y qué correos accedió un usuario o proceso, incluida la etiqueta de confidencialidad — sensitivity label — del correo) y eventos de **búsqueda dentro de Exchange y SharePoint** (qué buscó un usuario y cuándo). Estos dos eventos son exactamente el tipo de evidencia que necesitas para responder "¿el atacante leyó/exfiltró contenido sensible, o solo tocó el buzón sin abrir nada?" — la pregunta central de una investigación de compromiso de cuenta (BEC — Business Email Compromise —, ya visto en el Día 10). **Sin licencia de Audit Premium en el usuario investigado, esos eventos simplemente no existen en el log**, sin importar cuánto busques.

**Trampa de licenciamiento fijada:** Audit (Premium) no se activa a nivel de tenant solamente — los eventos de "Intelligent insights" **requieren que el usuario específico tenga asignada la licencia de Audit (Premium)** (incluida en E5, o vía el add-on "Microsoft 365 E5 eDiscovery and Audit"). Si el atacante comprometió una cuenta con licencia E3 sin el add-on, `MailItemsAccessed` no va a aparecer aunque el resto del tenant sea E5.

### 3. Cómo se busca el audit log: el flujo de Search y sus límites reales

Verificado hoy (`audit-search`, actualizado 14-jul-2026): la búsqueda vive en el **Microsoft Purview portal** (`purview.microsoft.com` — el portal actual; ya no es "Microsoft Purview compliance portal", nombre retirado), en la solución **Audit → Search**. Es importante fijar el flujo real, porque el examen pregunta tanto por el portal como por el equivalente en PowerShell:

- **Permisos necesarios:** rol **Audit Logs** o **View-Only Audit Logs**, asignado en el Microsoft Purview portal (para acceso vía cmdlets, el mismo rol pero asignado en el Exchange admin center).
- **Los search jobs corren en segundo plano.** No necesitas mantener el navegador abierto — el trabajo sigue corriendo aunque cierres la pestaña, y el resultado queda disponible en el dashboard por 30 días.
- **Límite de rango de fechas por búsqueda: 180 días máximo**, aunque la retención total del tenant sea de 1 año o 10 años con Premium. Si necesitas cubrir un año completo, tienes que dividir la búsqueda en múltiples jobs de 180 días o menos — **el mismo principio de "divide el rango" que necesitas para el error CS007 de eDiscovery (sección 4)**.
- **Cada usuario puede correr hasta 10 search jobs en paralelo**, con el límite de que solo uno puede ser una búsqueda sin filtros (unfiltered).
- **Exportación:** hasta 50,000 filas con Audit Standard, hasta 1,000,000 de filas con Audit Premium.
- **El cmdlet equivalente es `Search-UnifiedAuditLog`** (Exchange Online PowerShell) — hace exactamente lo mismo que la búsqueda del portal, y admite el parámetro `-RecordType` para filtrar por el servicio/producto que generó el registro.

**El dato de esquema más citado en el examen — `RecordType`:** cada registro de auditoría trae un campo `RecordType` que identifica **qué producto o workload generó ese registro** — no es un campo genérico, cada producto tiene el suyo. Verificado hoy contra el esquema oficial de `AuditLogRecordType`: el valor **`AirInvestigation`** (valor numérico 64 en el enum) corresponde específicamente a eventos de **AIR (Automated Investigation and Response)**. Conecta directo con un hallazgo de días anteriores: el retiro de AIR del 1-sep-2026 (mañana, según la fecha de esta sesión) **aplica solo a Defender for Endpoint** — el AIR de **Defender for Office 365** (Plan 2) sigue existiendo sin cambios, y sus eventos son justamente los que caen bajo `RecordType: AirInvestigation` en el audit log. Si el examen pregunta "¿en qué RecordType busco las acciones automatizadas de investigación que tomó Defender for Office 365 sobre un correo?", la respuesta es ese valor exacto.

### 4. Microsoft Purview eDiscovery: qué es hoy, después del retiro de la experiencia clásica

**eDiscovery** (electronic discovery) es el proceso de identificar, preservar y exportar **ESI (Electronically Stored Information — información almacenada electrónicamente)** para usarla como evidencia en una investigación legal, interna o de seguridad. A diferencia de Audit (que te dice qué operación ocurrió), eDiscovery te deja **buscar contenido real** — el texto de correos, archivos, chats de Teams — y ponerlo bajo retención legal (hold) para que nadie pueda borrarlo mientras dura la investigación.

**Hallazgo crítico verificado hoy, con fecha exacta** (`ediscovery-legacy-retirement`, actualizado 11-jun-2026): **Microsoft retiró TODAS las experiencias clásicas de eDiscovery el 31 de agosto de 2025** — esto incluye el **Content Search clásico**, el **eDiscovery (Standard) clásico** y el **eDiscovery (Premium) clásico** del portal de cumplimiento viejo. Esta retirada ya pasó hace más de un año respecto a la fecha de esta lección; si estudias con cualquier guía o video anterior a esa fecha que hable de "Content search" como una herramienta separada con su propia página, esa terminología está desactualizada para el examen de octubre. Lo que existe hoy, verificado en la documentación vigente (`edisc`, actualizado 29-jun-2026):

- **Todo vive dentro de la experiencia unificada de eDiscovery** en el Microsoft Purview portal. La unidad organizativa central ya no es el "custodian" (persona de interés) como en versiones viejas — es el **caso (case)**.
- **"Content Search" ya no es una página independiente.** Toda esa funcionalidad se movió dentro de un **caso de eDiscovery generado automáticamente por el sistema** para todos los miembros de los grupos de roles *eDiscovery Manager* y *Administrator* — o puedes seleccionar explícitamente **"Content Search"** dentro de eDiscovery para crear un caso de Content Search que agrupa todas las búsquedas nuevas y existentes. Tiene exactamente las mismas capacidades que cualquier otro caso creado por un usuario (holds, review sets, etc.), solo cambia el nombre con el que se etiqueta.
- **Dos niveles siguen existiendo, ahora como capacidades dentro de la misma experiencia**, no como productos separados: **eDiscovery** (búsqueda, estadísticas, exportación, holds — disponible con licencias base) y **Premium eDiscovery** (review sets, indexación avanzada, OCR — Optical Character Recognition —, threading de conversaciones, analítica, y **Security Copilot** — requiere licencia E5 o el add-on correspondiente).
- **Terminología nueva que reemplaza a la vieja:** "Collections" (estimaciones inmutables) → ahora es **"Statistics"** dentro de una búsqueda normal, y las búsquedas ya no son inmutables, se pueden re-ejecutar en cualquier momento. "Jobs" → ahora se llaman **"Processes"**.
- **Search-and-Purge sigue existiendo dentro de eDiscovery**: puedes buscar y eliminar mensajes de correo o chats de Teams directamente, sin exportarlos primero — útil para contener contenido malicioso ya entregado (conecta con el Threat Explorer y ZAP del Día 10, que actúan sobre correo entregado desde el lado de seguridad de MDO; eDiscovery lo hace desde el lado de cumplimiento, con el mismo objetivo de contención).

**El error CS007, verificado hoy:** cuando una búsqueda de eDiscovery falla con el código **CS007**, la causa típica es que la búsqueda tiene **demasiados resultados o una consulta demasiado compleja** (por ejemplo, exceso de comodines/wildcards). **La solución correcta es dividir la búsqueda en fragmentos más pequeños — por rango de fechas o por número de ubicaciones (mailboxes/sitios) —**, no cambiar destinatarios ni tocar permisos. Es el mismo patrón operativo que el límite de 180 días de Audit Search (sección 3): cuando una consulta es demasiado grande, la respuesta casi siempre es "acótala por tiempo o por alcance", no "cambia de herramienta".

**Roles que controlan el acceso** (RBAC — Role-Based Access Control — dentro del Microsoft Purview portal): los grupos de roles **eDiscovery Manager** (acceso limitado a los casos donde es miembro explícito) y **eDiscovery Administrator** (acceso a todos los casos de la organización, incluido el caso de Content Search generado por el sistema) son los que determinan quién puede buscar, exportar y gestionar holds.

### 5. Microsoft Graph activity logs: el tráfico de API, no la actividad humana en el portal

**Microsoft Graph** es la API unificada con la que casi todas las aplicaciones (incluidas Outlook, Teams, y apps de terceros autorizadas) leen y escriben datos de Microsoft 365 — correos, calendarios, archivos, usuarios. **Microsoft Graph activity logs** es el registro de **cada solicitud HTTP** que ese API procesa para tu tenant: quién la hizo, con qué aplicación, a qué recurso, con qué resultado.

Verificado hoy (`microsoft-graph-activity-logs-overview`, actualizado 4-jul-2026), los requisitos son distintos a todo lo anterior de hoy:

- **Requiere licencia Microsoft Entra ID P1 o P2** (no una licencia de Purview) — es un producto de la plataforma de identidad, no de compliance.
- **Se configura vía Diagnostic settings de Azure Monitor**, con un rol admin de Entra soportado; **Security Administrator es el rol de menor privilegio soportado** para configurarlo.
- **El destino es una tabla en tu workspace de Log Analytics**, la misma infraestructura que ya usas para Sentinel: **`MicrosoftGraphActivityLogs`**. No es gratis: se factura como cualquier otra tabla de ingesta en Log Analytics, y el volumen puede ser alto — Microsoft Learn da un estimado de referencia de ~15 GiB/mes de datos de Azure Monitor Logs para un tenant de 1,000 usuarios.
- **Columnas clave, verificadas hoy contra el esquema oficial:** `OperationId` (identificador de una solicitud individual, o de todo un lote si la solicitud viene agrupada/"batched") y **`SignInActivityId`** (el identificador que te permite **correlacionar esa llamada a Graph con el inicio de sesión** que la originó, uniéndola contra `SigninLogs` u otras tablas de sign-in). Esta es exactamente la distinción que ya te costó puntos en el Simulacro 01: si el enunciado pide identificar todas las llamadas hechas **por el mismo token/sesión**, usas `SignInActivityId`, no `OperationId` (que solo agrupa por lote de solicitud, no por sesión completa).

**Hallazgo nuevo verificado hoy, no documentado antes en el vault:** existe una **alternativa gratuita** con menor alcance, llamada **`GraphApiAuditEvents`** — una tabla del esquema de **Advanced Hunting** de Defender XDR (no de Azure Monitor/Log Analytics vía diagnostic settings). Se activa marcando la casilla correspondiente en el conector de Microsoft Defender XDR hacia Sentinel, **sin requerir licencia Entra ID P1/P2 adicional ni configuración de diagnostic settings**, con retención fija de **30 días** (la retención por defecto de Advanced Hunting). Cubre las llamadas de Microsoft Entra ID a Graph API, pero con menos columnas que la versión paga — por ejemplo, **no trae `SignInActivityId`** (usa `UniqueTokenIdentifier` y `OperationId` en su lugar). Diferénciarlas es sencillo con un calificador: **"sin licencia adicional / gratis / 30 días" → `GraphApiAuditEvents` (Advanced Hunting)**; **"cobertura completa, retención configurable, requiere Entra ID P1/P2" → `MicrosoftGraphActivityLogs` (Log Analytics)**.

### 6. Copilot embebido en Defender XDR y en Purview: qué hace, no cómo se despliega

**Security Copilot** es la capa de inteligencia artificial generativa de Microsoft para seguridad. El examen **no evalúa cómo se despliega o se administra** — evalúa que sepas **usarlo como analista** dentro de las herramientas que ya conoces, en dos superficies distintas cubiertas hoy:

**a) Dentro de Microsoft Defender XDR (portal de incidentes), verificado hoy** (`security-copilot-in-microsoft-365-defender`, actualizado 2-ago-2026):

| Capacidad | Qué hace | Dónde se usa |
|---|---|---|
| **Incident summary** | Genera automáticamente, al abrir un incidente, un resumen de cuándo empezó el ataque, dónde, la línea de tiempo, activos involucrados e IOCs (Indicators of Compromise) | Página del incidente, pestaña Copilot |
| **Guided response** | Recomienda acciones de respuesta específicas contextualizadas al incidente concreto (no genéricas) | Página del incidente |
| **Script analysis** | Analiza scripts/comandos sospechosos (PowerShell, líneas de comando ofuscadas) y explica qué hacen | Vista de attack story del incidente |
| **Device summary** | Resume postura de seguridad, comportamientos inusuales, software vulnerable de un dispositivo | Página del dispositivo |
| **File analysis** | Resume un archivo sospechoso: veredicto, certificados, llamadas a API, strings encontrados | Página del archivo |
| **Identity summary** | Resume el riesgo de una identidad: rol, cambios de rol, comportamiento de inicio de sesión, dispositivos | Página de la identidad |
| **Incident report** | Redacta un reporte consolidado del incidente (resumen + acciones tomadas + equipo involucrado) | Página del incidente |
| **Query assistant (NL→KQL)** | Convierte una pregunta en lenguaje natural en una consulta KQL lista para ejecutar en Advanced Hunting | Página de Advanced Hunting |
| **Defender Chat (preview)** | Chat abierto, consciente del contexto de la página actual, que puede proponer un plan de pasos (que apruebas o rechazas) antes de ejecutar una investigación de varios pasos | Botón Copilot en la barra superior, disponible en cualquier página |

**Trampa de nombres — no confundas "Guided response" con "Incident summary":** el enunciado que dice "resumir lo que pasó" pide **Incident summary**; el que dice "qué acción tomo ahora" pide **Guided response**. Son dos tarjetas separadas dentro de la misma pestaña Copilot del incidente, no la misma función con dos nombres.

**b) Dentro de eDiscovery (Purview), verificado hoy** (`edisc`, sección de integración con Security Copilot): dos capacidades, distintas de las de Defender XDR:

- **Traduce lenguaje natural a KeyQL** (Keyword Query Language, el lenguaje de consulta de eDiscovery) — no necesitas conocer los operadores de KeyQL para construir una búsqueda compleja.
- **Resume un ítem dentro de un review set** (el conjunto de documentos ya recolectados para revisión) — incluye documentos, transcripciones de reuniones y adjuntos, útil para que un revisor decida rápido si un ítem es relevante sin leerlo completo.

**Licenciamiento, dato importante para el ejercicio práctico de hoy:** Copilot en Defender y en eDiscovery requiere **acceso provisionado a Security Copilot** — un modelo de consumo basado en **SCU (Security Compute Units)**, que se compran o asignan aparte de las licencias de Defender/Purview/E5. No viene incluido automáticamente con ninguna licencia de las que ya usas en tus labs (Azure for Students, trial M365 E5) — es razonable que tu tenant de prácticas no tenga esta capacidad activa, y el ejercicio de hoy lo tiene en cuenta.

### 7. Tabla de decisión: el enunciado dice X → la respuesta es Y

| El enunciado dice (calificador) | Herramienta / respuesta correcta | Por qué NO las demás |
|---|---|---|
| "¿Qué hizo el usuario X con el documento Y? (una operación puntual, ya ocurrida)" | **Purview Audit → Search** | eDiscovery está diseñado para preservar/exportar contenido para litigio, no para responder "qué operación puntual ocurrió" de forma rápida |
| "Encuentra todos los correos con el adjunto malicioso X en toda la organización y ponlos en retención legal" | **Purview eDiscovery** (caso, hold, búsqueda) | Audit te dice que un correo se abrió o se envió, pero no te deja preservar el contenido en bloque para litigio ni aplicar un hold |
| "El sistema no permite buscar los últimos 12 meses en una sola búsqueda de Audit" | Dividir la búsqueda en rangos de **180 días o menos** (límite por job) | No es un límite de licencia ni de retención — es el límite operativo de cada search job, documentado explícitamente |
| "La búsqueda de eDiscovery falla con el código CS007 por demasiados resultados" | **Dividir la búsqueda por rango de fechas o por menos ubicaciones** | No es un problema de destinatarios duplicados (eso es un error distinto, de resolución de identidades) |
| "¿Qué acciones automatizadas tomó Defender for Office 365 al investigar un correo?" | `RecordType == "AirInvestigation"` en el audit log | `AzureActiveDirectory` es el RecordType de eventos de identidad, no de investigaciones de MDO |
| "Detectar que una app OAuth está llamando a la API de Graph para enumerar usuarios, sin licencia Entra ID P1/P2 adicional, con retención de 30 días" | Tabla **`GraphApiAuditEvents`** (Advanced Hunting) | `MicrosoftGraphActivityLogs` sí existe pero requiere licencia Entra ID P1/P2 y diagnostic settings — no cumple el calificador "sin licencia adicional" |
| "Correlacionar una llamada a Graph API con el inicio de sesión completo que la originó" | Columna **`SignInActivityId`** (en `MicrosoftGraphActivityLogs`) | `OperationId` agrupa por lote de solicitud, no identifica la sesión de inicio de sesión completa |
| "Resumir automáticamente lo que pasó en un incidente al abrirlo" | **Incident summary** (Copilot en Defender) | Guided response da acciones a tomar, no un resumen de lo ocurrido |
| "Recomendar la próxima acción de respuesta específica para este incidente" | **Guided response** (Copilot en Defender) | Incident summary describe el pasado del ataque, no recomienda el siguiente paso |
| "Construir una consulta KeyQL en eDiscovery sin conocer sus operadores" | **Security Copilot dentro de eDiscovery** (traducción lenguaje natural → KeyQL) | El query assistant de Advanced Hunting traduce a KQL, un lenguaje distinto para un producto distinto |
| "¿El atacante realmente abrió/leyó el correo sensible, o solo tocó el buzón?" | `MailItemsAccessed`, evento exclusivo de **Audit Premium** (Intelligent insights) | Audit Standard no registra este evento en absoluto, no es que lo muestre con menos detalle |

---

## 💡 Ejemplos concretos

### Ejemplo 1 — Correlacionar una llamada sospechosa a Microsoft Graph con el inicio de sesión que la originó

**Escenario:** El SOC (Security Operations Center) recibe una alerta de Entra ID Protection: un inicio de sesión desde una IP de riesgo alto. El analista necesita confirmar si, durante esa misma sesión, la cuenta hizo alguna llamada a Microsoft Graph API que fallara por falta de autorización (posible intento de acceder a recursos fuera de sus permisos, típico de reconocimiento tras un compromiso).

**Razonamiento:** el analista ya tiene el evento de sign-in en `SigninLogs` (tabla vista en días anteriores del curso). Para encontrar las llamadas a Graph asociadas a esa misma sesión, necesita unir `MicrosoftGraphActivityLogs` contra las tablas de sign-in usando `SignInActivityId` — el campo diseñado exactamente para esta correlación, distinto de `OperationId` (que solo agrupa lotes de solicitudes, no sesiones).

```kql
// Top 20 entidades que llaman a recursos de "groups" y fallan por autorización (401/403)
MicrosoftGraphActivityLogs
| where TimeGenerated >= ago(3d)
| where ResponseStatusCode == 401 or ResponseStatusCode == 403
| where RequestUri contains "/groups"
| summarize UniqueRequests = count_distinct(RequestId) by AppId, ServicePrincipalId, UserId
| sort by UniqueRequests desc
| take 20
```

```kql
// Correlacionar esas llamadas de Graph con el inicio de sesión completo que las originó
MicrosoftGraphActivityLogs
| where TimeGenerated > ago(7d)
| join kind=leftouter (
    union SigninLogs, AADNonInteractiveUserSignInLogs, AADServicePrincipalSignInLogs, AADManagedIdentitySignInLogs
    | where TimeGenerated > ago(7d)
) on $left.SignInActivityId == $right.UniqueTokenIdentifier
```

Si el analista hubiera intentado correlacionar por `OperationId` en vez de `SignInActivityId`, la unión (join) no encontraría coincidencias reales contra las tablas de sign-in — `OperationId` no está diseñado para eso, solo agrupa solicitudes dentro del mismo lote/batch.

### Ejemplo 2 — Resolver el error CS007 al investigar exfiltración masiva vía SharePoint con eDiscovery

**Escenario:** Contoso necesita encontrar, preservar y exportar todos los documentos de SharePoint que contienen el término "proyecto-fénix" compartidos externamente en los últimos 18 meses, como parte de una investigación de fuga de datos. Al lanzar la búsqueda en un caso de eDiscovery, el analista recibe el error **CS007**.

**Razonamiento:** CS007 casi siempre significa que la búsqueda es demasiado grande o demasiado compleja para procesarse en un solo job — 18 meses de actividad en toda la organización, con un término de búsqueda amplio, es exactamente ese escenario. La solución no es cambiar el término de búsqueda ni resolver duplicados de destinatarios (eso corrige un error distinto, de identidades ambiguas) — es **dividir la búsqueda en fragmentos más pequeños**, típicamente por rango de fechas:

1. Dividir los 18 meses en 3 búsquedas de 6 meses cada una (o más fragmentos si sigue fallando).
2. Ejecutar cada búsqueda como un proceso separado dentro del mismo caso de eDiscovery.
3. Revisar las estadísticas (Statistics) de cada fragmento antes de agregar los resultados a un review set — así el analista ve el volumen real antes de comprometerse a exportar o revisar todo de golpe.
4. Si el caso tiene licencia Premium, usar el review set combinado (con OCR, threading y analítica) para reducir el volumen antes de exportar, en vez de exportar los 18 meses en crudo.

El mismo principio — "cuando el rango es demasiado grande, se fragmenta por tiempo o por alcance, no se cambia de herramienta" — es idéntico al límite de 180 días por búsqueda de Audit Search (sección 3 de hoy). El examen premia reconocer que es el mismo patrón operativo en dos productos distintos.

### Ejemplo 3 — Usar Copilot embebido correctamente según la fase de la investigación

**Escenario:** Un analista Tier 1 abre un incidente de alta severidad con 40 alertas correlacionadas. No sabe por dónde empezar, y después necesita decidir qué hacer con la cuenta comprometida.

**Razonamiento, en el orden correcto de uso:** primero, para entender el ataque, usa **Incident summary** — Copilot genera automáticamente (al abrir la página) el resumen de cuándo empezó, qué activos están involucrados y la línea de tiempo, sin que el analista tenga que leer las 40 alertas una por una. Segundo, una vez entendido el alcance, para decidir la acción usa **Guided response** — la pestaña separada que da recomendaciones de remediación específicas a este incidente (por ejemplo, aislar un dispositivo concreto o revocar la sesión de una cuenta concreta, no una lista genérica de buenas prácticas). Si durante la investigación aparece un script PowerShell ofuscado en la línea de tiempo del ataque, el analista usa **Script analysis** para entender qué hace sin tener que descifrarlo manualmente. Al cerrar el caso, usa **Incident report** para generar la documentación final. Un error común es pedir el resumen y las acciones de respuesta como si fueran la misma tarjeta — son dos pasos distintos, en ese orden, dentro de la misma pestaña Copilot del incidente.

---

## 🎥 Videos

1. **[Copilot in Microsoft Defender: incident summary, guided response, and more](https://learn.microsoft.com/en-us/training/modules/security-copilot-embedded-experiences/)** — módulo oficial de Microsoft Learn (parte de la ruta de entrenamiento de Security Copilot), con las mismas capacidades embebidas cubiertas hoy en la sección 6. Búsqueda verificada hoy: no encontré un video reciente y específico de Exam Readiness Zone dedicado a Purview Audit/eDiscovery/Graph activity logs para el temario 2026 — es contenido demasiado nuevo (actualización de julio 2026) para que exista todavía una sesión grabada de esa serie. En su lugar, uso el módulo oficial de Learn, que sí está verificado y actualizado.
2. Módulo oficial de Microsoft Learn: **[Search the audit log in Microsoft Purview](https://learn.microsoft.com/en-us/training/modules/m365-compliance-audit-logs/)** — recorrido práctico del flujo de búsqueda cubierto en la sección 3 de hoy (Standard vs Premium, límites, Search-UnifiedAuditLog). Si tu conexión no permite abrir el módulo, la documentación de `audit-search` citada en fuentes cubre exactamente lo mismo por escrito.

> [!note] Honestidad sobre la búsqueda de video de hoy
> A diferencia de días anteriores (donde encontré una sesión de Ignite o un canal reconocido), el contenido de Purview de este día es tan reciente (retiro de eDiscovery clásico en ago-2025, cambios de terminología documentados en jun-2026) que la oferta de video de calidad todavía no alcanzó al temario. Prefiero decir esto con claridad en vez de forzar un enlace de relleno — los dos módulos de Learn de arriba están verificados y actualizados.

---

## 🧪 Ejercicio práctico

> [!note] Este lab cabe en un bloque normal entre semana — con una parte opcional que probablemente no vas a poder ejecutar
> Purview Audit y eDiscovery corren sobre tu **trial M365 E5** (el mismo tenant de `security.microsoft.com` que ya usaste en los Días 8, 9, 10 y 11) — no hace falta esperar al sábado. La parte de Microsoft Graph activity logs necesita licencia Entra ID P1/P2 y un workspace de Log Analytics (el mismo de tus labs de Sentinel); si tu trial no incluye Entra ID P1/P2, queda documentado como paso teórico. La parte de Copilot **probablemente no tendrás cómo ejecutarla en un tenant de prueba** sin SCUs provisionadas — está marcada como opcional/exploratoria.

- [ ] **Paso 1 — Buscar el audit log.** En `purview.microsoft.com` → **Audit** → **Search**, configura una búsqueda de los últimos 7 días, sin filtro de actividad (para ver el volumen real), y revisa el dashboard de resultados. Identifica el `RecordType` de al menos 3 eventos distintos en los resultados.
- [ ] **Paso 2 — Confirmar el límite de rango.** Intenta configurar una búsqueda con un rango de fechas mayor a 180 días y confirma que el portal muestra el error de rango máximo descrito en la sección 3.
- [ ] **Paso 3 — Explorar eDiscovery.** Dentro de **eDiscovery**, localiza el caso de **Content Search** generado automáticamente por el sistema (o créalo si no existe) y lanza una búsqueda simple por palabra clave contra un buzón o sitio de prueba. Revisa la pestaña **Statistics** de los resultados.
- [ ] **Paso 4 (si tu trial tiene Entra ID P1/P2) — Configurar Microsoft Graph activity logs.** En `portal.azure.com`, ve a **Microsoft Entra ID** → **Diagnostic settings**, crea una nueva configuración que envíe los logs a tu workspace de Log Analytics de Sentinel, y espera ~30 minutos. Corre la primera query del Ejemplo 1 contra `MicrosoftGraphActivityLogs` para confirmar que llegan datos.
- [ ] **Paso 5 (opcional, probablemente no disponible en tu trial) — Copilot embebido.** Si tu tenant tiene acceso provisionado a Security Copilot, abre un incidente existente y compara la tarjeta de **Incident summary** contra la de **Guided response**. Si no tienes acceso, revisa las capturas de pantalla del módulo de Learn del Paso 1 de la sección de Videos para familiarizarte visualmente con la interfaz.
- [ ] **Paso 6 —** responde el quiz de hoy y el repaso acumulativo.

---

## ✅ Quiz del día

Cinco preguntas sobre el contenido nuevo de hoy. Responde antes de abrir el bloque de respuestas.

**1.** Una organización tiene únicamente usuarios con licencia Office 365 E3 (sin ningún add-on de auditoría). ¿Cuál es el período de retención por defecto de sus registros de Purview Audit?

- A) 90 días
- B) 180 días
- C) 1 año
- D) 10 años

**2.** Un analista necesita filtrar el audit log de Microsoft 365 para encontrar únicamente las acciones automatizadas que Defender for Office 365 tomó al investigar un correo de phishing. ¿Qué valor de `RecordType` usa?

- A) `AzureActiveDirectory`
- B) `ExchangeItem`
- C) `AirInvestigation`
- D) `ComplianceSearch`

**3.** Una búsqueda de eDiscovery sobre 15 meses de actividad de SharePoint falla con el código de error CS007. ¿Qué acción resuelve el problema de forma correcta?

- A) Dividir la búsqueda en rangos de fechas más pequeños
- B) Eliminar destinatarios duplicados con un cmdlet de PowerShell
- C) Cambiar el rol del analista a eDiscovery Administrator
- D) Convertir la búsqueda en una regla de Advanced Hunting

**4.** Un equipo de seguridad quiere detectar llamadas sospechosas de una aplicación a Microsoft Graph API, sin adquirir licencias adicionales de Microsoft Entra ID y aceptando una retención de solo 30 días. ¿Qué tabla usan?

- A) `MicrosoftGraphActivityLogs`
- B) `SecurityAlert`
- C) `CloudAuditEvents`
- D) `GraphApiAuditEvents`

**5.** Un analista abre un incidente con múltiples alertas correlacionadas y quiere que Copilot le recomiende la acción de remediación específica para ese incidente (por ejemplo, aislar un dispositivo concreto), no un resumen de lo que ya pasó. ¿Qué capacidad usa?

- A) Incident summary
- B) Guided response
- C) Script analysis
- D) Incident report

> [!note]- Ver respuestas
> **1 — B.** Sin ningún add-on de Audit Premium, el período de retención por defecto de Audit (Standard) es 180 días — cambió de 90 a 180 días desde el 17-oct-2023, y aplica a cualquier organización sin la licencia de Premium. **A** (90 días) era el valor viejo, ya no vigente. **C** y **D** son valores exclusivos de Audit (Premium) con licencia adicional, que este escenario no tiene.
>
> **2 — C.** `AirInvestigation` es el `RecordType` específico para eventos de AIR (Automated Investigation and Response), que en Defender for Office 365 sigue operando sin cambios (el retiro del 1-sep-2026 aplica solo a MDE). **A** (`AzureActiveDirectory`) es el RecordType de eventos de identidad, no de investigaciones de correo. **B** y **D** son nombres de RecordType inventados/no reales.
>
> **3 — A.** CS007 casi siempre indica una búsqueda demasiado grande o compleja; la solución documentada es dividirla en fragmentos más pequeños, típicamente por rango de fechas o por número de ubicaciones. **B** resuelve un error distinto (ambigüedad de destinatarios), no el volumen de resultados. **C** es un cambio de permisos que no afecta el tamaño de la búsqueda. **D** mezcla dos productos distintos (eDiscovery no se convierte en una regla de Advanced Hunting).
>
> **4 — D.** `GraphApiAuditEvents` es la tabla gratuita del esquema de Advanced Hunting, sin requisito de licencia Entra ID P1/P2 adicional, con retención fija de 30 días. **A** (`MicrosoftGraphActivityLogs`) sí existe pero exige licencia Entra ID P1/P2 y configuración de diagnostic settings — no cumple el calificador "sin licencias adicionales". **B** y **C** son tablas de otro dominio (alertas de Sentinel y eventos de nube de Defender for Cloud, vistos el Día 12), no de tráfico de Graph API.
>
> **5 — B.** Guided response es la capacidad que da recomendaciones de acción específicas al incidente concreto. **A** (Incident summary) describe lo que ya ocurrió, no recomienda el siguiente paso. **C** (Script analysis) analiza un script puntual, no da un plan de remediación del incidente completo. **D** (Incident report) documenta el incidente después de resuelto, no recomienda acciones durante la investigación.

---

## 🔁 Repaso acumulativo — re-test espaciado

Cuatro preguntas que re-testean puntos ya medidos en sesiones anteriores, dos de ellas nunca antes puestas en un quiz formal de este curso.

**R1.** Un analista busca en Sentinel el incidente correlacionado que agrupó los casos abiertos hoy en Case Management, y también busca en qué tabla vive la actividad que acaba de auditar en Purview de la sección de hoy. ¿Qué tienen en común Case Management y Purview Audit/eDiscovery respecto a Sentinel?

- A) Ambos exponen sus datos en la tabla `SecurityIncident`
- B) Ninguno de los dos expone sus datos en ninguna tabla de Log Analytics ni de Advanced Hunting — viven solo dentro de sus propios portales/servicios
- C) Ambos exponen sus datos únicamente en `SecurityAlert`
- D) Case Management expone datos en `CloudAuditEvents`, y Purview Audit en `SecurityIncident`

**R2.** El equipo de cumplimiento necesita revisar las alertas de DLP (Data Loss Prevention) generadas la semana pasada por una política de protección de datos sensibles. ¿En qué portal(es) las revisa?

- A) Únicamente en el SharePoint admin center
- B) Únicamente en el Microsoft 365 admin center
- C) En el Microsoft Purview portal y en el Defender portal (unificado)
- D) Únicamente en Microsoft Entra admin center

**R3.** El SOC necesita un reporte de qué usuarios de alto riesgo hicieron un restablecimiento de contraseña en los últimos 14 días, para confirmar si la amenaza persiste en el tiempo o ya se resolvió. ¿Qué reporte de Entra ID Protection usan?

- A) Risky sign-ins report
- B) Sign-in logs sin filtrar
- C) Risky users report
- D) Identity Protection alerts

**R4.** Durante una investigación de MDE, el analista necesita capturar memoria, procesos y conexiones de red de un dispositivo comprometido, minimizando el impacto al usuario y evitando cortar la sesión de trabajo activa. ¿Qué acción usa?

- A) Isolate device
- B) Restrict app execution
- C) Live response con sesión interactiva
- D) Collect investigation package

> [!note]- Ver respuestas
> **R1 — B.** Refuerza el hallazgo del Día 8 (Case Management no expone ninguna tabla de Log Analytics ni Advanced Hunting) con el hallazgo nuevo de hoy (Purview Audit y eDiscovery tampoco): ambos son servicios cuyos datos viven solo dentro de su propio portal — no hay ningún nombre de tabla que inventar para consultarlos vía KQL. **A**, **C** y **D** asumen que existe una tabla, exactamente el error que el examen premia detectar (inventar un nombre de tabla razonable que no existe, patrón ya visto con `EventType` en el Día 9).
>
> **R2 — C.** Fallo original del Simulacro 01 del 23-jul (nunca retesteado hasta hoy): las alertas DLP se revisan tanto en el Microsoft Purview portal como en el Defender portal unificado — no en SharePoint admin center ni en Microsoft 365 admin center, que no muestran alertas DLP. **A**, **B** y **D** enumeran portales reales de administración, pero ninguno expone esas alertas.
>
> **R3 — C.** Segundo retest espaciado (primero en el repaso del Día 9, 12-ago): Risky users report agrega el riesgo de una cuenta **a través del tiempo** (útil para "¿sigue en riesgo 14 días después?"), mientras que Risky sign-ins report es por evento puntual de inicio de sesión. **A** es la trampa clásica confundida en el simulacro original. **B** y **D** no son el reporte diseñado para esta pregunta específica sobre riesgo persistente.
>
> **R4 — D.** El bloque más débil históricamente de este curso, reforzado de nuevo: "minimizar impacto" + "evitar cortar la sesión activa" descarta Isolate device (si corta la red) y apunta a un forense pasivo. Collect investigation package recolecta memoria, procesos y red sin aislar el dispositivo. **A** corta la red del usuario, justo el impacto que el enunciado pide evitar. **B** solo bloquea ejecución de apps, no recolecta evidencia forense completa. **C** (Live response) permite interactuar en vivo, pero el enunciado no pide análisis interactivo — pide recolección pasiva, que es exactamente lo que resuelve Collect investigation package con menor fricción.

---

## ⚠️ Trampas del examen en los temas de hoy

1. **Audit = qué OPERACIÓN hizo alguien. eDiscovery = qué CONTENIDO existe/se preserva/se exporta.** No son la misma pregunta aunque ambas vivan en el mismo portal de Purview.
2. **Content Search ya no es una página independiente** desde el retiro de la experiencia clásica (31-ago-2025) — vive dentro de un caso de eDiscovery, generado por el sistema o creado explícitamente.
3. **`MailItemsAccessed` y los eventos de búsqueda son exclusivos de Audit Premium** — no es que Standard los muestre con menos detalle, **no existen en absoluto** sin la licencia adecuada en el usuario investigado.
4. **Límite de 180 días por búsqueda de Audit** — es un límite operativo del search job, no de retención total del tenant (que puede ser de hasta 1 o 10 años con Premium).
5. **CS007 se resuelve dividiendo el alcance (fechas o ubicaciones), no cambiando permisos ni destinatarios.**
6. **`RecordType == "AirInvestigation"`** es el filtro correcto para acciones automatizadas de AIR en el audit log — y AIR de Defender for Office 365 sigue vigente después del 1-sep-2026 (el retiro es solo de MDE).
7. **`GraphApiAuditEvents` (gratis, Advanced Hunting, 30 días) ≠ `MicrosoftGraphActivityLogs`** (requiere Entra ID P1/P2, retención configurable, vía diagnostic settings) — el calificador de licencia/costo decide cuál usar.
8. **`SignInActivityId` correlaciona con la sesión de inicio de sesión completa; `OperationId` solo agrupa un lote de solicitudes** — no son intercambiables para "encontrar todo lo que hizo esta sesión".
9. **Incident summary describe el pasado del ataque; Guided response recomienda el siguiente paso.** Son dos tarjetas distintas del mismo Copilot embebido en Defender, no la misma función.
10. **Ni Case Management (Día 8) ni Purview Audit/eDiscovery (hoy) exponen tabla de Log Analytics o Advanced Hunting** — si el examen sugiere una tabla KQL para consultarlos, es un distractor inventado.

---

## 🎓 Cierre del Dominio 2 — Respond to security incidents (35-40%)

Con la lección de hoy, el **Dominio 2 completo queda cubierto**. Resumen de qué se vio en cada pieza, para tenerlo de un vistazo antes de pasar al Dominio 3:

| Pieza del Dominio 2 | Qué cubre | Día(s) |
|---|---|---|
| Gestión de incidentes unificados | Manage incident pane: triage, severidad, tags, clasificación, AI-generated analyst notes | Día 8 |
| Case Management | Casos, tareas, vínculo con incidentes/indicadores, RBAC, límites de servicio | Día 8 |
| MDO — Microsoft Defender for Office 365 | Threat Explorer, ZAP, attack disruption en BEC/AiTM | Día 10 |
| MDCA — Microsoft Defender for Cloud Apps | Anomaly detection policies, app governance, session/access policies | Día 10 |
| Entra ID Protection | Risk levels, Risky users vs Risky sign-ins, retiro de políticas legacy (1-oct-2026) | Día 11 |
| MDI — Microsoft Defender for Identity | Arquitectura de sensores, técnicas de ataque AD, Attack paths, remediación | Día 11 |
| Defender for Cloud (workload protections) | CNAPP, CSPM vs CWPP, planes CWPP, integración con Defender XDR | Día 12 |
| MDE — respuesta y evidencia | Timeline, Live response, Collect investigation package, RBAC granular | Día 9 |
| Ataques multi-etapa / lateral movement | Correlación entre productos dentro de un mismo incidente | Día 8 (repaso), reforzado en Días 10-12 |
| **Purview Audit / eDiscovery / Graph activity logs** | Investigación de actividad M365, no de alertas de producto | **Día 13 (hoy)** |
| **Agentic AI / Copilot embebido** | Incident summary, Guided response, Script/File/Identity/Device summary, NL→KQL, Copilot en eDiscovery | **Día 13 (hoy)** |

**El patrón de mayor valor que se repite en las siete lecciones del dominio:** cada producto tiene su propio conjunto de herramientas de investigación, casi siempre con nombres parecidos entre sí (Timeline vs Advanced Hunting vs Live response; Audit vs eDiscovery vs Graph activity logs; Incident summary vs Guided response), y el examen decide cuál usar por el **calificador exacto del enunciado**, no por el concepto general. Es el mismo hábito que costó 5 fallos seguidos en el Simulacro 01 del 23-jul en el bloque de MDE, y 5 más en el bloque de Purview — ambos bloques ya quedaron cubiertos y con tablas de decisión dedicadas (Día 9 y hoy).

Con el Dominio 2 cerrado, sigue el **Dominio 3 — Perform threat hunting (20-25%)**, que arranca según [[PLAN_MAESTRO_MULTITRACK]] §8.3 con el Día 15 (Advanced Hunting + custom detections + hunting graphs/Sentinel Graph, con el repaso de KQL del Día 14 fusionado al inicio).

---

## 🔗 Notas relacionadas

- [[Dia 08 - Incidentes Unificados y Case Management]] — origen del hallazgo "Case Management no expone tabla", reforzado hoy con Purview en R1
- [[Dia 09 - Respuesta MDE Timeline Live Response y Evidencia]] — bloque MDE reforzado hoy en R4, mismo patrón de tabla de decisión
- [[Dia 10 - MDO Threat Explorer ZAP y MDCA]] — origen del retiro de AIR (1-sep-2026, solo MDE), conectado hoy con `RecordType: AirInvestigation` de MDO
- [[Dia 11 - Identidades Entra ID Protection y MDI]] — origen de Risky users vs Risky sign-ins, retesteado hoy en R3
- [[Dia 12 - Defender for Cloud Workload Protections]] — mismo patrón de tabla de decisión y de hallazgo de esquema/licenciamiento
- [[PLAN_MAESTRO_MULTITRACK]] — calendario vigente §8, examen 3-oct-2026 fijo
- [[REPASO_RAPIDO_Errores_Simulacro]] — §7 (Purview Audit/eDiscovery/Graph activity logs), origen de los 5 fallos del Simulacro 01 atacados hoy
- [[TRACKER_TUTOR]]

## 📚 Fuentes verificadas hoy (31-ago-2026)

- [Learn about auditing solutions in Microsoft Purview](https://learn.microsoft.com/en-us/purview/audit-solutions-overview) — ms.date 18-may-2026, actualizado 8-jul-2026, fuente principal de la sección 2 (Standard vs Premium, retención, Intelligent insights, licenciamiento por usuario)
- [Search the audit log](https://learn.microsoft.com/en-us/purview/audit-search) — ms.date 19-jun-2026, actualizado 14-jul-2026, fuente principal de la sección 3 (roles, límite de 180 días, search jobs, límites de exportación, Search-UnifiedAuditLog)
- [Legacy eDiscovery tools retired](https://learn.microsoft.com/en-us/purview/ediscovery-legacy-retirement) — actualizado 11-jun-2026, confirma la fecha exacta del retiro de la experiencia clásica (31-ago-2025) usada en la sección 4
- [Learn about eDiscovery](https://learn.microsoft.com/en-us/purview/edisc) — ms.date 29-jun-2026, actualizado 29-jun-2026, fuente principal de la sección 4 (terminología nueva, Content Search dentro de eDiscovery, Copilot en eDiscovery de la sección 6)
- [Access Microsoft Graph activity logs for tenant monitoring](https://learn.microsoft.com/en-us/graph/microsoft-graph-activity-logs-overview) — ms.date 25-nov-2025, actualizado 4-jul-2026, fuente principal de la sección 5 (requisitos, columnas `SignInActivityId`/`OperationId`, ejemplos de KQL usados en el Ejemplo 1)
- [GraphAPIAuditEvents table in the advanced hunting schema](https://learn.microsoft.com/en-us/defender-xdr/advanced-hunting-graphapiauditevents-table) — ms.date 27-jul-2026, actualizado 3-ago-2026, fuente de la tabla gratuita alternativa de la sección 5
- [Microsoft Security Copilot and Chat in Microsoft Defender](https://learn.microsoft.com/en-us/defender-xdr/security-copilot-in-microsoft-365-defender) — ms.date 17-jul-2026, actualizado 2-ago-2026, fuente principal de la sección 6a (Incident summary, Guided response, Query assistant, Defender Chat)
- Búsqueda verificada: `RecordType: AirInvestigation` (valor 64 del enum `AuditLogRecordType`) para eventos de AIR — confirmado contra la referencia oficial del esquema de Office 365 Management Activity API
- Búsqueda verificada: código de error **CS007** de eDiscovery como indicador de búsqueda con demasiados resultados/complejidad, con la corrección de dividir por rango de fechas o ubicaciones

---

> [!tip] Orden de consumo de hoy (fijado el 24-ago, ver [[PLAN_MAESTRO_MULTITRACK]] §7.7)
> 🎧 Escucha primero el Audio Overview de esta lección en NotebookLM → 📖 luego lee esta nota completa, con foco en la sección 7 (tabla de decisión) → ✅ y cierra con el quiz. Escuchar no sustituye leer, y leer no sustituye el quiz — el día se cierra con el quiz respondido, no antes.
