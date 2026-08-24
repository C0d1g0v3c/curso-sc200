---
tags: [sc-200, mdo, defender-for-office-365, mdca, defender-for-cloud-apps, threat-explorer, zap, oauth-apps, session-policies, leccion-diaria]
dia: 10
fecha: 2026-08-24
fecha_programada: 2026-08-24
dominio: "Dominio 2 — Respond to security incidents (35-40%)"
estado: 🟡 En curso
cover: ""
---

# Lección Día 10 — MDO: Threat Explorer y ZAP + MDCA: anomalías, OAuth y session policies

> [!info] Contexto
> Día 10 del plan de [[PLAN_MAESTRO_MULTITRACK]] §8, dentro del **Dominio 2 — Respond to security incidents**, que vale entre el **35 % y el 40 %** del examen. Se imparte en fecha, el lunes 24-ago, tal como marca el calendario estricto — el primer día de contenido nuevo desde que se cerró la deuda de labs. Hoy cubrimos dos productos que responden a amenazas en superficies distintas de las que ya viste: **MDO (Microsoft Defender for Office 365)**, que protege correo y colaboración (Exchange, SharePoint, OneDrive, Teams), y **MDCA (Microsoft Defender for Cloud Apps)**, que vigila el uso de aplicaciones en la nube — tanto las de Microsoft como las de terceros conectadas a tu organización.
>
> El hilo conductor de hoy es el mismo que en el Día 9: varias herramientas que suenan parecidas (Threat Explorer vs ZAP, anomaly detection vs session policy) y que el examen distingue por el **calificador del enunciado** — si pide acción automática o investigación manual, si pide algo en tiempo real dentro de una sesión o una detección basada en patrón histórico. La tabla de decisión de la sección 9 es, otra vez, el entregable de mayor valor del día.

---

## 📖 Lectura del día

### 0. Dónde estamos dentro del Dominio 2

| Sub-bloque | Qué agrupa | Cuándo lo ves |
|---|---|---|
| Respond to alerts and incidents in Microsoft Defender XDR | Gestión de incidentes, case management, respuesta por producto (**MDO, MDCA** hoy; Purview, Defender for Cloud, Entra ID, MDI después), ataques multi-etapa, agentic AI/Copilot | Días 8, **10**, 11, 12, 13 |
| Respond to alerts and incidents in Microsoft Defender for Endpoint | Device timeline, live response, collect investigation package, evidencia, attack disruption | Día 9 (ya cubierto) |
| Investigate Microsoft 365 activities to identify threats | Purview Audit, eDiscovery, Microsoft Graph activity logs | Día 13 |

Hoy avanzamos dos de los cinco productos de respuesta por producto que quedan del primer sub-bloque (MDO y MDCA); Entra ID Protection + MDI llegan el Día 11 y Defender for Cloud el Día 12.

### 1. Microsoft Defender for Office 365 (MDO): qué protege y cómo se licencia

**MDO** es el conjunto de protecciones de Microsoft para correo electrónico y herramientas de colaboración (Exchange Online, SharePoint Online, OneDrive for Business, Microsoft Teams). Se organiza en dos niveles de licencia, y el examen distingue con frecuencia cuál capacidad pertenece a cuál:

- **Plan 1**: protecciones preventivas — Safe Attachments (analiza archivos adjuntos en un entorno aislado antes de entregarlos), Safe Links (reescribe URLs y las valida en el momento del clic, no solo al momento de la entrega), anti-phishing, y **Real-time detections** (una versión reducida de Threat Explorer, ver sección 2). **Dato verificado hoy, cambio reciente**: desde el **1 de julio de 2026**, Defender for Office 365 Plan 1 viene **incluido** en las licencias Office 365 E3 y Microsoft 365 E3 — antes había que comprarlo como add-on separado para esos planes.
- **Plan 2**: incluye todo lo de Plan 1 y añade **Threat Explorer completo**, **Attack Simulation Training** (campañas de phishing simuladas para entrenar usuarios), **Threat Trackers**, y **AIR (Automated Investigation and Response) para MDO** — que es un mecanismo separado del AIR de MDE que ya viste en los Días 5 y 6. **Recordatorio importante que ya quedó anotado esos días: el retiro de AIR del 1-sep-2026 aplica ÚNICAMENTE a Defender for Endpoint — el AIR de MDO sigue funcionando sin cambios.** Plan 2 viene incluido en Microsoft 365 E5.

Todo esto se administra y se investiga desde el portal unificado de Defender (`security.microsoft.com`), bajo el nodo **Email & collaboration**.

### 2. Threat Explorer y Real-time detections: el hunting de correo

**Threat Explorer** (también llamado simplemente "Explorer") y **Real-time detections** son reportes casi en tiempo real que permiten a un analista identificar y analizar amenazas recientes de correo. Contienen la misma información base, pero difieren en licencia y en profundidad:

| | Real-time detections (Plan 1) | Threat Explorer (Plan 2) |
|---|---|---|
| Vistas disponibles | Malware, Phish (2 vistas) | All email, Malware, Phish, **Campaigns**, Content malware, URL clicks (6 vistas) |
| Filtros y consultas guardadas | Filtros básicos | Más propiedades de filtro, **permite guardar consultas** |
| Ventana de tiempo | Hasta 30 días atrás | Hasta 30 días atrás |
| Acciones de remediación | Limitadas | Todo el catálogo de acciones (sección siguiente) |

Se llega a Threat Explorer desde el portal de Defender en **Email & collaboration → Explorer**, o directamente con la URL `security.microsoft.com/threatexplorerv3`.

**Vistas clave para el examen:**
- **All email**: todos los mensajes entrantes, salientes e intra-organización, con su veredicto y ubicación de entrega.
- **Campaigns**: agrupa automáticamente mensajes de phishing o malware que Microsoft identifica como parte de una **campaña coordinada** (mismo atacante, mismo patrón, dirigida a varios destinatarios) — útil para ver el alcance de un ataque sin tener que correlacionar mensaje por mensaje a mano.
- **URL clicks**: registra cada clic de usuario sobre una URL vigilada por Safe Links, en correo y en herramientas de colaboración — es la vista que responde "¿quién hizo clic en el enlace malicioso, y quién lo hizo *después* de que Safe Links ya lo había marcado como malo?".

**Acciones sobre los mensajes, y el detalle de RBAC (Role-Based Access Control) que el examen pregunta con frecuencia:** seleccionar uno o más mensajes habilita un menú de "Take action" con **Soft delete** (mueve el mensaje a Elementos eliminados del destinatario, recuperable), **Hard delete** (elimina el mensaje de forma permanente, no recuperable) y **Move to Junk** (lo manda a la carpeta de correo no deseado). Estas acciones — igual que previsualizar o descargar un mensaje — requieren permisos específicos, y son dos permisos **independientes**:

- **Preview** (previsualizar/descargar el mensaje): asignado por defecto a los grupos de rol *Data Investigator* y *eDiscovery Manager*.
- **Search and Purge** (mover o eliminar mensajes de buzones): asignado por defecto a *Data Investigator* y *Organization Management*.

Un analista puede tener permiso para **ver** el contenido de un correo sospechoso sin tener permiso para **borrarlo** — el mismo principio de "acción mínima necesaria" que ya viste con el RBAC granular de MDE en el Día 9.

### 3. ZAP (Zero-hour Auto Purge): la limpieza automática después de la entrega

**ZAP** es un mecanismo **automático** — no algo que un analista dispara manualmente — que detecta y neutraliza **retroactivamente** mensajes de phishing, spam o malware que ya fueron entregados a un buzón en la nube. Existe porque el filtrado de correo no es perfecto en el momento de la entrega: un archivo puede ser malware de día cero indetectable en ese instante, o un enlace puede "armarse" (volverse malicioso) recién después de haber sido entregado. ZAP resuelve ese hueco monitoreando continuamente las firmas de amenazas y actuando sobre mensajes que **ya están** en el buzón del usuario.

**Cómo funciona, punto por punto (verificado hoy contra Microsoft Learn, doc actualizada 1-jun-2026 y confirmada vigente el 7-ago-2026):**

- **Alcance temporal**: la búsqueda de ZAP está limitada a los **últimos 48 horas** de correo entregado.
- **El resultado depende del veredicto y de la acción configurada en la política**, no es siempre "lo mismo":
  - **Malware**: ZAP siempre pone el mensaje en **cuarentena** (los destinatarios no pueden liberarlo, como mucho pueden *solicitar* su liberación).
  - **High confidence phishing**: igual que malware, siempre **cuarentena**.
  - **Phishing** (sin ser "high confidence") y **Spam / High confidence spam**: el resultado depende de la acción configurada en la política anti-spam para ese veredicto — si la política dice "Move to Junk Email", ZAP mueve el mensaje a Correo no deseado; si dice "Quarantine message", ZAP lo pone en cuarentena; si dice "Add X-Header" o "Delete message" (entre otras), **ZAP no actúa** sobre el mensaje.
- **No se notifica al usuario** cuando ZAP mueve un mensaje.
- **Novedad verificada hoy, dato reciente**: ZAP ahora también actúa sobre mensajes que ya están en la carpeta **Elementos eliminados** — esta expansión empezó a desplegarse en junio de 2026 y se esperaba completa hacia finales de julio de 2026, así que a la fecha de tu examen ya debería estar vigente en todos los tenants.
- **ZAP también protege Microsoft Teams** (mensajes de chat y canal identificados como malware o high-confidence phishing, desde enero de 2026) — esto **sí requiere** licencia MDO Plan 1 o Plan 2. El resto de ZAP (correo) **no tiene requisito de licencia especial**: funciona en cualquier buzón alojado en Exchange Online.
- **Cómo verificar si ZAP actuó**: en el portal, con el **Mailflow status report** (vista Mailflow, para contar cuántos mensajes afectó ZAP en un rango de fechas) o en **Threat Explorer**, filtrando la columna **"Additional action"** por el valor **ZAP** en la vista All email. En Advanced Hunting, la tabla **`EmailPostDeliveryEvents`** registra estas acciones con `ActionType` = **`Phish ZAP`** o **`Malware ZAP`** (y también `Manual remediation` cuando fue un analista quien actuó, por ejemplo desde Threat Explorer).

**El punto que más confunde en el examen: Threat Explorer vs ZAP.** Ambos actúan sobre correo ya entregado, pero uno es investigación manual (Threat Explorer: tú decides, tú seleccionas, tú aplicas soft/hard delete) y el otro es un mecanismo automático de la plataforma que corre solo, sin que nadie lo dispare (ZAP). Si el enunciado dice "el sistema removió el mensaje automáticamente, sin intervención de un analista" → ZAP. Si dice "un analista investigó y decidió eliminar el mensaje" → Threat Explorer.

### 4. Attack disruption en MDO: conexión con lo que ya viste el Día 6

Ya conoces **Automatic attack disruption** del Día 6: un mecanismo que, con alta confianza de que un ataque multi-etapa está en curso, actúa automáticamente sobre varias señales de XDR (Extended Detection and Response) a la vez. En un ataque de **BEC (Business Email Compromise, compromiso de correo de negocios)** o **AiTM (Adversary-in-the-Middle, un atacante interceptando la sesión entre el usuario y el servicio real para robar tokens de sesión)**, attack disruption combina, en la misma respuesta automática: **deshabilitar o contener al usuario comprometido** (señal de identidad), **aislar su dispositivo** (señal de endpoint) y **remover el correo malicioso ya entregado** (señal de MDO) — todo en minutos y sin intervención humana.

**La diferencia con ZAP, otra vez un punto fino de examen**: ZAP solo actúa sobre el correo (lo mueve o lo cuarentena). Attack disruption es más amplio — actúa sobre identidad, dispositivo **y** correo a la vez, porque su objetivo no es limpiar un mensaje sino **cortar un ataque activo que ya comprometió una cuenta**.

### 5. Microsoft Defender for Cloud Apps (MDCA): qué es

**MDCA** es la plataforma de Microsoft para vigilar y controlar el uso de aplicaciones en la nube — tanto aplicaciones de Microsoft (SharePoint, OneDrive, Exchange Online) como aplicaciones de terceros conectadas a tu organización (Salesforce, Box, Dropbox, Google Workspace, y miles más). Su función central es responder tres preguntas que ni MDE ni MDO responden: **¿qué apps en la nube usa realmente mi organización (incluidas las que nadie autorizó)?**, **¿qué comportamiento anómalo ocurre dentro de esas apps?**, y **¿puedo controlar en tiempo real lo que un usuario hace dentro de una sesión de una app, sin bloquearle el acceso por completo?**.

Se organiza en cuatro capacidades principales, y el examen espera que sepas en cuál cae cada escenario:

1. **Cloud Discovery**: descubre qué aplicaciones en la nube se están usando en la organización (incluyendo Shadow IT, aplicaciones no aprobadas por TI), analizando logs de tráfico.
2. **App governance / OAuth apps**: evalúa el riesgo de las aplicaciones OAuth (aplicaciones de terceros a las que un usuario les dio permiso de acceder a sus datos de Microsoft 365 — correo, archivos, calendario) y permite revocar sus permisos si resultan riesgosas.
3. **Information protection**: extiende las etiquetas de confidencialidad de Microsoft Purview a aplicaciones de terceros.
4. **Threat protection**: las políticas de **anomaly detection** (sección 6) y las **session policies** vía Conditional Access App Control (sección 8) — la parte que más pregunta el examen dentro de "respond to security incidents".

Se administra desde el portal de Defender, en el nodo **Cloud apps**.

### 6. Anomaly detection policies en MDCA

Las **anomaly detection policies** son políticas de **UEBA (User and Entity Behavior Analytics)** y machine learning que vienen **habilitadas por defecto** y empiezan a detectar de inmediato — con un **período de aprendizaje inicial de 7 días** durante el cual no se generan todas las alertas todavía, mientras el sistema construye una línea base de comportamiento normal por usuario y por organización (ubicaciones habituales, dispositivos, horarios, IPs).

**Políticas vigentes que sí siguen activas con nombre propio (verificado hoy, doc actualizada 8-ago-2026):**

- **Impossible travel** (viaje imposible): dos inicios de sesión del mismo usuario, desde ubicaciones geográficamente muy distantes, en una ventana de tiempo demasiado corta para haber viajado físicamente entre ellas. Tiene un **slider de sensibilidad** (Low/Medium/High) que controla cuánta actividad se suprime como falso positivo (VPNs, ubicaciones habituales de otros usuarios de la organización).
- **Activity from infrequent country/region**: inicio de sesión desde una ubicación que el usuario nunca o casi nunca había usado antes.
- **Malware detection**: identifica archivos maliciosos en tu almacenamiento en la nube (Microsoft o de terceros), comparando contra threat intelligence de Microsoft. **Deshabilitada por defecto** (a diferencia de la mayoría, que vienen activas).
- **Suspicious OAuth app file download activities**: una aplicación OAuth conectada descarga múltiples archivos de SharePoint/OneDrive de forma atípica para ese usuario — señal de que la cuenta o la app pueden estar comprometidas.
- **Multiple failed login attempts**: múltiples intentos fallidos de inicio de sesión en una sola sesión, relativo a la línea base — posible ataque de fuerza bruta.
- **Multiple delete VM activities**: eliminación de múltiples máquinas virtuales en una sola sesión — posible intento de sabotaje o cobertura de huellas.
- **Unusual activities (by user)**: una familia de detecciones (descargas masivas inusuales, uso compartido inusual de archivos, eliminación inusual de archivos, actividad administrativa inusual, entre otras) que compara el comportamiento de un usuario contra su propia línea base.

> [!warning] Hallazgo verificado hoy: varias políticas "clásicas" ya no existen con ese nombre
> Desde **junio de 2025**, MDCA empezó a migrar sus políticas de anomaly detection a un **modelo de detección dinámico** que adapta la lógica automáticamente sin necesidad de configuración manual. Como parte de esa migración, varias políticas que **sí aparecen listadas en materiales de estudio más viejos** quedaron deshabilitadas y renombradas — por ejemplo: *"Activity from suspicious IP addresses"* → ahora es **"Successful logon from a suspicious IP address"** y **"Activity from a password-spray associated IP address"**; *"Ransomware activity"* → ahora **"Ransomware payment instruction file uploaded to {Application}"*; *"Activity from anonymous IP addresses"* → ahora **"Activity from a TOR IP address"** y **"Anonymous proxy activity"**. La protección sigue existiendo, solo cambió el nombre y el mecanismo interno — si el examen (o una guía vieja) menciona el nombre clásico, reconoce que describe el mismo tipo de amenaza aunque el portal ya muestre otro nombre.

**Governance actions**: cada política de anomaly detection permite configurar acciones automáticas de remediación (por app conectada o para todas) cuando se dispara — por ejemplo, suspender al usuario o revocar su sesión — sin que un analista tenga que hacerlo a mano cada vez.

### 7. App governance y OAuth apps

Cuando un usuario le da permiso a una aplicación de terceros para acceder a sus datos de Microsoft 365 (por ejemplo, "Permitir que esta app lea mi correo y mis archivos"), esa aplicación queda registrada como una **aplicación OAuth** en Microsoft Entra ID. **App governance** es la capa de MDCA que evalúa el riesgo de esas aplicaciones (qué permisos tiene, cuántos usuarios la usan, si su comportamiento coincide con patrones maliciosos conocidos) y te deja **investigar y remediar** — por ejemplo, revocando los permisos de una app sospechosa para todos los usuarios de la organización de un solo lugar, sin tener que pedirle a cada usuario que la desconecte manualmente.

### 8. Session policies vs access policies: la diferencia que más pregunta el examen

Aquí está la distinción central de la capacidad de **Threat protection** de MDCA, y es exactamente el tipo de par que el examen usa para poner a prueba si detectas el calificador correcto:

- **Access policies**: deciden si un usuario puede entrar o no a una aplicación en la nube — **todo o nada**. Se evalúan al momento del inicio de sesión.
- **Session policies**: **no bloquean el acceso** — dejan entrar al usuario, pero **monitorean y controlan lo que hace dentro de la sesión**, en tiempo real. Pueden bloquear una descarga específica, bloquear una subida, bloquear copiar-pegar, o forzar que se aplique una etiqueta de confidencialidad a un archivo antes de que salga de OneDrive — todo esto **sin impedir que el usuario use la aplicación**.

Ambas dependen de un mecanismo llamado **Conditional Access App Control**: MDCA actúa como un **proxy inverso** entre el usuario y la aplicación en la nube, lo que le permite ver e interceptar el tráfico de esa sesión en tiempo real. Las aplicaciones de Microsoft Entra quedan **automáticamente incorporadas (onboarded)** para Conditional Access App Control y están disponibles de inmediato como condición dentro de una política de acceso o de sesión.

**El caso de uso que el examen cita con frecuencia**: bloquear la descarga de información sensible desde un dispositivo no administrado, en tiempo real, sin bloquear el acceso completo a la aplicación — eso es exactamente una **session policy**, no una access policy (demasiado radical: bloquearía todo) ni una anomaly detection policy (esa solo alerta *después* de que ya ocurrió, no previene la descarga en el momento).

### 9. La tabla de decisión: el calificador del enunciado, otra vez

| El enunciado dice (calificador) | Herramienta correcta | Por qué NO las demás |
|---|---|---|
| "Investigar manualmente un correo YA entregado y decidir si se elimina" | **Threat Explorer** (soft/hard delete) | ZAP es automático, no algo que un analista dispare a mano |
| "El sistema removió un mensaje malicioso automáticamente, sin intervención de un analista, después de la entrega" | **ZAP** | Threat Explorer es la herramienta de investigación manual, no el mecanismo automático de la plataforma |
| "Un correo malicioso fue detectado ya dentro de la carpeta de Elementos eliminados" | **ZAP** (cubre Deleted Items desde 2026) | Threat Explorer no purga de forma automática; requeriría acción manual |
| "Detectar un inicio de sesión desde un país que ese usuario nunca había usado antes" | **Anomaly detection policy** (Activity from infrequent country/region) | Session policy solo actúa DURANTE una sesión ya en curso, no analiza patrón histórico de ubicaciones |
| "Bloquear en tiempo real la descarga de un archivo confidencial desde un dispositivo no administrado, sin bloquear el resto de la sesión" | **Session policy** (Conditional Access App Control) | Anomaly detection solo alerta después del hecho; access policy bloquearía toda la sesión, no solo la descarga |
| "Una app OAuth de terceros descargó cientos de archivos de SharePoint de forma atípica para ese usuario" | **Suspicious OAuth app file download activities** + revisión en **App governance** | No es una sesión de navegador de un usuario web, es una app con permisos delegados |
| "Ataque de BEC en curso: contener usuario, aislar dispositivo y limpiar el correo entregado, todo automático y a la vez" | **Automatic attack disruption** | ZAP solo actúa sobre el correo; no contiene identidad ni dispositivo |

---

## 💡 Ejemplos concretos

### Ejemplo 1 — Threat Explorer vs ZAP: quién actuó sobre el mensaje

**Escenario:** Un usuario reporta que recibió un correo de phishing hace tres días. El analista abre Threat Explorer, filtra por remitente y encuentra el mensaje. La columna "Additional action" muestra el valor **ZAP**, y el mensaje ya no está en la bandeja de entrada del usuario. El analista se pregunta si necesita eliminarlo manualmente.

**Razonamiento:** el valor `ZAP` en esa columna significa que **el sistema ya actuó automáticamente** sobre ese mensaje después de la entrega — no hace falta ninguna acción manual adicional del analista, el mensaje ya fue movido o puesto en cuarentena según el veredicto y la política vigente. Si en cambio la columna mostrara vacío o "Manual remediation" con el nombre de otro analista, ahí sí sabrías que hizo falta o hizo falta una intervención manual. Para confirmar el detalle exacto vía KQL:

```kql
EmailPostDeliveryEvents
| where NetworkMessageId == "<id-del-mensaje>"
| project Timestamp, ActionType, RecipientEmailAddress, ActionResult
// ActionType esperado aquí: "Phish ZAP" o "Malware ZAP"
```

### Ejemplo 2 — Anomaly detection vs Session policy: cuándo cada una

**Escenario:** El equipo legal pide dos cosas distintas: (1) que les avisen si algún usuario descarga una cantidad inusual de archivos de SharePoint comparado con su comportamiento habitual, y (2) que se **impida en el momento** la descarga de cualquier archivo con etiqueta de confidencialidad "Altamente confidencial" desde un dispositivo no administrado por la organización.

**Razonamiento:** son dos mecanismos distintos aunque suenen parecidos. La petición (1) es un patrón de comportamiento a lo largo del tiempo comparado contra una línea base — eso es una **anomaly detection policy** (la familia "Unusual activities by user", específicamente descargas inusuales), que **alerta después** de detectar el patrón. La petición (2) exige **bloquear la acción en el momento exacto en que ocurre**, dentro de una sesión activa, condicionado al tipo de dispositivo — eso solo lo hace una **session policy** vía Conditional Access App Control, configurada para bloquear la acción de descarga cuando el archivo tiene esa etiqueta de confidencialidad y el dispositivo no está marcado como administrado.

```kql
// Confirmar descargas masivas de SharePoint capturadas por MDCA (Día 10)
CloudAppEvents
| where Application == "Microsoft SharePoint" and ActionType == "FileDownloaded"
| summarize Descargas = count() by AccountDisplayName, bin(Timestamp, 1h)
| where Descargas > 50
| order by Descargas desc
```

### Ejemplo 3 — Attack disruption en un BEC: qué se dispara y qué no

**Escenario:** Se detecta con alta confianza que la cuenta de un empleado del área de finanzas está comprometida y siendo usada para enviar correos de fraude (BEC) a proveedores, pidiendo cambiar datos bancarios. En minutos, sin intervención humana, el sistema deshabilita la cuenta, aísla el dispositivo del empleado y remueve los correos fraudulentos que ya habían sido enviados a otros buzones internos.

**Razonamiento:** la combinación de **tres acciones simultáneas sobre tres superficies distintas** (identidad, dispositivo, correo) sin intervención humana es la firma de **Automatic attack disruption**, no de ZAP. ZAP por sí solo podría haber limpiado el correo fraudulento, pero **no tiene capacidad de deshabilitar una cuenta ni aislar un dispositivo** — esas acciones vienen de las señales de MDI/Entra ID Protection y MDE que attack disruption correlaciona junto con la señal de MDO, exactamente como ya viste con la tabla de acciones del Día 6 (Contain user, Isolate device, Revoke user session).

---

## 🎥 Videos

1. **[Preparing for SC-200: Manage incident response (Part 3 of 4)](https://learn.microsoft.com/en-us/shows/exam-readiness-zone/preparing-for-sc-200-manage-incident-response)** — Exam Readiness Zone, Microsoft Learn Shows. Nota de honestidad, la misma que ya viste en el Día 5: esta serie usa los **pesos de dominio viejos** (4 dominios de 15-30% cada uno, ya no vigentes — los correctos son los 3 dominios 40-45/35-40/20-25 de tu guía), pero el contenido de respuesta con MDO y MDCA que cubre sigue siendo conceptualmente correcto y vale la pena verlo solo por esa parte.
2. No encontré un video reciente (2025-2026) de buena calidad específico sobre Threat Explorer/ZAP o sobre session policies de MDCA — el candidato más visto sobre Threat Explorer es de 2021, demasiado viejo para citarlo como "reciente". En su lugar, usa el módulo oficial [Implement threat protection by using Microsoft Defender for Office 365](https://learn.microsoft.com/en-us/training/modules/implement-threat-protection-use-microsoft-defender-office-365/) de Microsoft Learn como fuente principal para MDO, y la documentación de [Create session policies](https://learn.microsoft.com/en-us/defender-cloud-apps/session-policy-aad) para MDCA — ambas están activamente mantenidas y son las que se usaron para verificar esta lección.

---

## 🧪 Ejercicio práctico

> [!info] Requisito
> Usa tu trial M365 E5 / portal de Defender (`security.microsoft.com`), **no** el tenant universitario de La Salle. MDCA necesita estar habilitado/onboardeado en el tenant — si algún paso no está disponible, documenta la limitación y sigue con el siguiente en vez de forzarlo.

- [ ] **Paso 1 — Explorar Threat Explorer.** Ve a **Email & collaboration → Explorer** (o `security.microsoft.com/threatexplorerv3`). Revisa las vistas disponibles (All email, Malware, Phish, Campaigns, Content malware, URL clicks) y confirma si tu trial trae Plan 1 o Plan 2 según cuántas vistas ves.
- [ ] **Paso 2 — Confirmar tus permisos.** Intenta seleccionar un mensaje (si hay alguno en el rango de 30 días) y revisa qué opciones de "Take action" aparecen disponibles vs en gris — eso te dice si tu cuenta tiene Preview, Search and Purge, o ambos.
- [ ] **Paso 3 — Anomaly detection policies.** Ve a **Cloud apps → Policies → Policy management**, filtra por tipo **Anomaly detection policy**, y localiza al menos 3 de las políticas de la sección 6 (Impossible travel, Suspicious OAuth app file download activities, Multiple failed login attempts). Abre la de Impossible travel y localiza el slider de sensibilidad.
- [ ] **Paso 4 — Session policies.** En la misma pantalla de Policy management, ve a la pestaña **Conditional Access** y revisa si hay alguna app de Microsoft Entra ya incorporada automáticamente para Conditional Access App Control.
- [ ] **Paso 5 — App governance (si está disponible).** Busca **Cloud apps → App governance** y revisa la lista de aplicaciones OAuth conectadas, si el tenant tiene alguna.
- [ ] **Paso 6 —** responde el quiz de hoy y el repaso acumulativo.

---

## ✅ Quiz del día

Cinco preguntas sobre el contenido nuevo de hoy. Responde antes de abrir el bloque de respuestas.

**1.** Un mensaje de phishing fue entregado a un buzón y, 6 horas después, el sistema lo movió automáticamente a la carpeta de correo no deseado del destinatario, sin que ningún analista lo tocara. ¿Qué mecanismo actuó?

- A) Threat Explorer, mediante una acción de "Move to Junk" aplicada por un analista
- B) ZAP (Zero-hour Auto Purge), según la acción configurada para el veredicto Phishing en la política anti-spam
- C) Automatic attack disruption, por una señal de identidad comprometida
- D) App governance, al detectar una aplicación OAuth riesgosa

**2.** Un analista con el permiso "Preview" asignado, pero sin el permiso "Search and Purge", investiga un mensaje sospechoso en Threat Explorer. ¿Qué puede hacer con ese mensaje?

- A) Aplicar hard delete de forma permanente
- B) Moverlo a la carpeta de correo no deseado del destinatario
- C) Previsualizar y descargar el mensaje, sin poder moverlo ni eliminarlo
- D) Ninguna acción, ambos permisos son obligatorios en conjunto

**3.** El equipo legal pide bloquear, en el momento exacto en que ocurre y sin cortar el resto del acceso a la aplicación, la descarga de archivos con etiqueta de confidencialidad alta desde dispositivos no administrados. ¿Qué configuran en MDCA?

- A) Una anomaly detection policy de descargas inusuales
- B) Una session policy usando Conditional Access App Control
- C) Una access policy que bloquee la aplicación completa
- D) Una regla de app governance sobre la aplicación OAuth correspondiente

**4.** Durante un ataque de BEC (Business Email Compromise) detectado con alta confianza, el sistema deshabilita automáticamente la cuenta comprometida, aísla el dispositivo del usuario y elimina el correo fraudulento ya entregado a otros buzones, todo en la misma respuesta automática. ¿Qué mecanismo describe mejor este comportamiento?

- A) ZAP actuando de forma coordinada sobre identidad, dispositivo y correo
- B) Automatic attack disruption, correlacionando señales de MDO, MDE y MDI/Entra ID
- C) Una session policy de MDCA aplicada al buzón comprometido
- D) Threat Explorer ejecutando una remediación en lote sobre la campaña detectada

**5.** Una organización con licencia Office 365 E3 (sin add-ons de seguridad adicionales) pregunta si tiene disponible Safe Links y Safe Attachments a partir de julio de 2026. ¿Cuál es la respuesta correcta?

- A) No, esas capacidades solo existen en Defender for Office 365 Plan 2
- B) Sí, porque desde el 1 de julio de 2026 Defender for Office 365 Plan 1 viene incluido en Office 365 E3
- C) No, Office 365 E3 nunca incluye ninguna capacidad de Defender for Office 365
- D) Sí, pero solo si además compran por separado Microsoft Defender for Cloud Apps

> [!note]- Ver respuestas
> **1 — B.** El comportamiento descrito (movimiento automático, sin intervención de un analista, después de la entrega) es exactamente ZAP. El resultado (Move to Junk) depende de la acción configurada para el veredicto Phishing en la política anti-spam vigente. **A** describe una acción manual, contradice "sin que ningún analista lo tocara". **C** es un mecanismo más amplio (identidad + dispositivo + correo), no solo mover un mensaje. **D** no tiene nada que ver con correo entregado, gestiona aplicaciones OAuth.
>
> **2 — C.** El permiso Preview habilita previsualizar y descargar el mensaje; moverlo o eliminarlo (soft/hard delete, move to junk) requiere el permiso independiente Search and Purge, que el analista no tiene en este escenario. **A** y **B** requieren Search and Purge. **D** es falso: los dos permisos son independientes, no un paquete obligatorio conjunto — se puede tener uno sin el otro, que es justo el punto del RBAC de Threat Explorer.
>
> **3 — B.** "En el momento exacto en que ocurre" y "sin cortar el resto del acceso" son las dos señales que apuntan a una session policy vía Conditional Access App Control: permite la sesión pero controla una acción específica dentro de ella en tiempo real. **A** solo alerta después del hecho, no bloquea nada en el momento. **C** bloquearía toda la aplicación, no solo la descarga — más agresivo de lo que pide el enunciado. **D** gestiona permisos de aplicaciones OAuth de terceros, no sesiones de navegador de usuarios dentro de una app.
>
> **4 — B.** La combinación simultánea de tres acciones sobre tres superficies distintas (identidad, dispositivo, correo) sin intervención humana es la firma de Automatic attack disruption, que correlaciona señales de varios productos XDR a la vez. **A** es incorrecta porque ZAP solo actúa sobre el correo, no tiene capacidad de deshabilitar cuentas ni aislar dispositivos. **C** no aplica: las session policies actúan sobre sesiones de aplicaciones en la nube, no sobre buzones de correo. **D** describe una acción manual de Threat Explorer, no una respuesta automática multi-señal.
>
> **5 — B.** Verificado en esta lección: desde el 1 de julio de 2026, Defender for Office 365 Plan 1 (que incluye Safe Links y Safe Attachments) viene incluido en las licencias Office 365 E3 y Microsoft 365 E3, sin necesidad de comprarlo como add-on separado. **A** describe el estado anterior a julio de 2026. **C** es falso tras el cambio verificado. **D** confunde productos: MDCA no es un requisito para tener Safe Links/Safe Attachments, esas son capacidades de MDO Plan 1.

---

## 🔁 Repaso acumulativo — re-test espaciado

Tres preguntas que re-testean puntos ya medidos como débiles en sesiones anteriores, con un enunciado nuevo.

**R1.** Un analista de Contoso necesita crear una regla de detección con lógica de correlación compleja (joins entre varias tablas y una watchlist), y el escenario **no menciona ninguna restricción de latencia**. ¿Qué tipo de analytics rule de Sentinel usa?

- A) NRT, porque puede referenciar múltiples tablas y watchlists en la misma query
- B) Scheduled, porque da control total sobre frecuencia, umbral de alerta y ventana de lookback
- C) Anomaly, porque el machine learning maneja mejor la correlación compleja
- D) TI Map, porque compara automáticamente contra indicadores de amenaza

**R2.** Contoso ya tiene licencia Microsoft Defender Threat Intelligence (MDTI) Premium y quiere ingerir los indicadores de amenaza curados por Microsoft a Sentinel con el **mínimo esfuerzo de configuración posible**. ¿Qué hacen?

- A) Instalar la solución Threat Intelligence y habilitar el conector Premium Defender TI ya prearmado
- B) Configurar la Upload API para subir manualmente los indicadores todos los días
- C) Crear una analytics rule TI Map que genere los indicadores automáticamente
- D) Exportar los indicadores desde MDTI a un archivo CSV y cargarlos en una watchlist

**R3.** Una anomaly detection policy de MDCA genera una alerta individual porque detecta un inicio de sesión desde un país infrecuente para un usuario. Ese mismo evento, correlacionado con otras dos señales de distintos productos, termina generando un caso completo en Sentinel. ¿En qué tabla consultas cada uno de los dos elementos?

- A) La alerta individual y el caso correlacionado están ambos en `SecurityIncident`
- B) La alerta individual está en `SecurityAlert`; el caso correlacionado está en `SecurityIncident`
- C) La alerta individual está en `SecurityIncident`; el caso correlacionado está en `SecurityAlert`
- D) Ambos elementos están en `CloudAppEvents`, ya que el origen es MDCA

> [!note]- Ver respuestas
> **R1 — B.** Recordatorio del Día 4: la corrección de 29-jul dejó claro que NRT sí admite múltiples tablas y joins, así que eso ya no descarta NRT por sí solo. Lo que decide aquí es que el escenario no pide latencia mínima y sí pide control fino — frecuencia, umbral y lookback configurables — que solo da Scheduled. **A** ya no es incorrecta por la razón vieja (no admitir joins), pero sigue siendo incorrecta porque NRT no permite ese nivel de configuración. **C** confunde: Anomaly rules no generan incidentes por sí solas, solo pueblan la tabla `Anomalies`. **D** es para comparar contra indicadores de amenaza conocidos, no para correlación de lógica custom.
>
> **R2 — A.** Regla fijada tras el fallo del simulacro del 23-jul: con licencia Premium ya pagada, instalar la solución Threat Intelligence + el conector Premium Defender TI prearmado es la ruta de **menor** esfuerzo. **B** es la opción de **mayor** esfuerzo (manual, recurrente) — el distractor más tentador de este ítem. **C** es un tipo de analytics rule que consume indicadores, no una forma de ingerirlos. **D** añade pasos manuales innecesarios cuando ya existe un conector prearmado.
>
> **R3 — B.** Regla fijada tras el fallo del quiz del Día 6, reforzada hoy con un origen distinto (MDCA en vez de MDE): una **alerta individual** que emite cualquier producto (aquí, MDCA) vive en `SecurityAlert`; un **caso correlacionado** por Sentinel a partir de varias alertas de distintos productos vive en `SecurityIncident`. **A** y **C** invierten la regla. **D** confunde la tabla de origen de la telemetría de MDCA (`CloudAppEvents`, usada para hunting) con las tablas de alertas/incidentes de Sentinel, que son conceptos distintos.

---

## ⚠️ Trampas del examen en los temas de hoy

1. **Threat Explorer (manual) ≠ ZAP (automático).** El calificador "sin intervención de un analista" es la señal de ZAP; "un analista investigó y decidió" es Threat Explorer.
2. **ZAP ya cubre Elementos eliminados**, no solo Bandeja de entrada — dato reciente de 2026, ausente en materiales de estudio más viejos.
3. **Preview y Search and Purge son permisos independientes** en Threat Explorer — se puede previsualizar sin poder eliminar.
4. **Anomaly detection policy (alerta después del hecho) ≠ Session policy (bloquea en tiempo real dentro de la sesión).** Si el enunciado pide detener algo *en el momento*, es session policy, no anomaly detection.
5. **Session policy ≠ Access policy.** Session policy deja pasar pero vigila/controla; access policy es todo-o-nada.
6. **Varias anomaly detection policies "clásicas" de MDCA cambiaron de nombre desde junio de 2025** (modelo de detección dinámico) — reconoce el concepto aunque el nombre en el portal ya no coincida con guías viejas.
7. **Automatic attack disruption es más amplio que ZAP en un BEC**: actúa sobre identidad + dispositivo + correo a la vez, no solo sobre el mensaje.
8. **Defender for Office 365 Plan 1 viene incluido en Office 365/Microsoft 365 E3 desde el 1-jul-2026** — antes había que comprarlo aparte.
9. **`SecurityAlert` (alerta individual, cualquier producto) vs `SecurityIncident` (caso correlacionado de Sentinel)** — regla que ya falló dos veces en este curso, reforzada hoy con MDCA como origen nuevo.

---

## 🔗 Notas relacionadas

- [[Dia 06 - AIR Attack Disruption Automation Rules y Playbooks]] — Attack disruption y sus acciones (Contain user, Isolate device, Revoke session), base de la sección 4 de hoy
- [[Dia 09 - Respuesta MDE Timeline Live Response y Evidencia]] — mismo patrón de RBAC granular (permisos independientes) y de tabla de decisión por calificador del enunciado
- [[PLAN_MAESTRO_MULTITRACK]] — calendario vigente §8, examen 3-oct-2026 fijo
- [[REPASO_RAPIDO_Errores_Simulacro]] — origen de los ítems del repaso acumulativo de hoy (§4 TI ingestion, §10 SecurityAlert vs SecurityIncident)
- [[TRACKER_TUTOR]]

## 📚 Fuentes verificadas hoy (24-ago-2026)

- [About Threat Explorer and Real-time detections](https://learn.microsoft.com/en-us/defender-office-365/threat-explorer-real-time-detections-about) — actualizado 2-jun-2026, fuente principal de la sección 2 (vistas, licenciamiento Plan 1 vs Plan 2, roles Preview/Search and Purge)
- [Zero-hour auto purge in Microsoft Defender for Office 365](https://learn.microsoft.com/en-us/defender-office-365/zero-hour-auto-purge) — actualizado 1-jun-2026, confirmado vigente 7-ago-2026, fuente principal de la sección 3 (comportamiento por veredicto, expansión a Deleted Items, ZAP en Teams, verificación vía Threat Explorer/Mailflow)
- [EmailPostDeliveryEvents table in the advanced hunting schema](https://learn.microsoft.com/en-us/defender-xdr/advanced-hunting-emailpostdeliveryevents-table) — valores de `ActionType` (`Phish ZAP`, `Malware ZAP`, `Manual remediation`) usados en el Ejemplo 1
- [Anomaly detection policies in Microsoft Defender for Cloud Apps](https://learn.microsoft.com/en-us/defender-cloud-apps/anomaly-detection-policy) — actualizado 8-ago-2026, fuente principal de la sección 6, incluida la migración al modelo de detección dinámico de junio 2025
- [CloudAppEvents table in the advanced hunting schema](https://learn.microsoft.com/en-us/defender-xdr/advanced-hunting-cloudappevents-table) — usada en el Ejemplo 2
- [Use Defender for Cloud Apps Conditional Access app control](https://learn.microsoft.com/en-us/defender-cloud-apps/conditional-access-app-control-how-to-overview) y [Create session policies](https://learn.microsoft.com/en-us/defender-cloud-apps/session-policy-aad) — fuente principal de la sección 8 (session vs access policies, proxy inverso, onboarding automático de apps de Entra)
- [Microsoft Defender for Office 365 Features service description](https://learn.microsoft.com/en-us/office365/servicedescriptions/microsoft-defender-for-office-365-features) — confirmación del cambio de licenciamiento de Plan 1 en Office 365/Microsoft 365 E3 desde el 1-jul-2026

---

> [!tip] Orden de consumo de hoy (fijado el 24-ago, ver [[PLAN_MAESTRO_MULTITRACK]] §7.7)
> 🎧 Escucha primero el Audio Overview de esta lección en NotebookLM → 📖 luego lee esta nota completa, con foco en la sección 9 (tabla de decisión) → ✅ y cierra con el quiz. Escuchar no sustituye leer, y leer no sustituye el quiz — el día se cierra con el quiz respondido, no antes.
