---
tags: [sc-200, incidentes, case-management, defender-xdr, rbac, sentinel, leccion-diaria]
dia: 8
fecha: 2026-08-05
dominio: "Dominio 2 — Respond to security incidents (35-40%)"
estado: 🟡 En curso
cover: ""
---

# Lección Día 8 — Incidentes unificados y Case Management

> [!info] Contexto
> Día 8 del plan de [[GUIA_INTENSIVA_24_DIAS]] y **arranque del Dominio 2 — Respond to security incidents**, que vale entre el **35 % y el 40 %** del examen (el segundo bloque que más pesa, justo detrás del Dominio 1 que cerraste ayer). Dentro de este dominio, hoy cubrimos el primer sub-bloque, *"Respond to alerts and incidents in Microsoft Defender XDR"*, centrado en dos objetivos concretos del temario: gestionar incidentes en el portal unificado y **"Manage security incidents by using case management"** — el tema más nuevo del examen (entró en el outline de julio de 2026) y el que peor cubierto está en las notas viejas del vault, así que hoy lo construyo entero desde la documentación vigente.
>
> Importa por dos razones prácticas: primero, porque **Case Management no reemplaza nada que ya conozcas** — es una capa nueva por encima de los incidentes, y el examen te va a poner escenarios donde tienes que decidir "¿esto es un incidente o un case?". Segundo, porque el simulacro que ya hiciste (Simulacro 01, Días 1–6) tiene fallos de temas previos que siguen sin fijarse del todo, así que hoy además reforzamos cinco de ellos con un quiz de repaso dedicado.

---

## 📖 Lectura del día

### 0. Dónde estamos: qué cubre el Dominio 2 y qué toca hoy exactamente

El **Dominio 2** del examen, *Respond to security incidents* ("responder a incidentes de seguridad"), tiene tres sub-bloques según el temario vigente (verificado hoy contra el *study guide* oficial):

| Sub-bloque                                                             | Qué agrupa                                                                                                                                                                                       | Cuándo lo ves                        |
| ---------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------ |
| **Respond to alerts and incidents in Microsoft Defender XDR**          | Investigar y remediar amenazas por producto (MDO, Purview, Defender for Cloud, MDCA, Entra ID, MDI, Sentinel), ataques complejos multi-etapa, agentic AI/Copilot embebido, y **case management** | **Hoy (Día 8, parcial)** y Días 9–13 |
| **Respond to alerts and incidents in Microsoft Defender for Endpoint** | Device timeline, live response, collect investigation package, evidencia y entidades, attack disruption                                                                                          | Día 9                                |
| **Investigate Microsoft 365 activities to identify threats**           | Purview Audit, eDiscovery, Microsoft Graph activity logs                                                                                                                                         | Día 13                               |

Hoy me enfoco en dos objetivos concretos de la primera fila: la gestión del ciclo de vida de un **incidente** en el portal unificado de Microsoft Defender (que ya rozaste en los Días 6 y 7 cuando hablamos de tags y clasificación de alertas, pero que hoy completamos del todo a nivel de incidente), y **case management**, que es contenido enteramente nuevo. El resto de "investigar y remediar por producto" (MDO, Purview, MDCA, Entra ID, MDI, Sentinel) se reparte en los Días 10 a 13, porque cada producto necesita su propia sesión.

### 1. Repaso completo: qué es un incidente en el portal unificado de Defender

Antes de hablar de *case management* hace falta tener sólido el concepto de **incidente**, porque un case no sustituye al incidente: se construye encima de él.

Un **incidente** (*incident*) es el resultado de que **Microsoft Defender XDR (Extended Detection and Response)** — la plataforma que unifica la protección de endpoints, identidades, correo y aplicaciones en la nube — agrupe automáticamente varias **alertas** relacionadas en una sola historia de ataque. Una **alerta** (*alert*) es una señal individual: el resultado de una detección puntual, como "este proceso hizo algo sospechoso en este dispositivo" o "este usuario inició sesión desde una ubicación imposible". Cuando varias alertas de distintos productos (Microsoft Defender for Endpoint, Microsoft Defender for Office 365, Microsoft Defender for Identity, Microsoft Defender for Cloud Apps, Microsoft Entra ID Protection, Microsoft Sentinel…) comparten indicadores o pertenecen a la misma cadena de ataque, Defender XDR las **correlaciona** — las agrupa — en un único incidente, para que el analista vea la historia completa en vez de piezas sueltas.

En KQL (**Kusto Query Language**, el lenguaje de consulta de Log Analytics y Advanced Hunting), la regla que ya fijaste en el Día 7 sigue vigente y es la base de hoy: **una alerta individual de un producto vive en la tabla `SecurityAlert`; un incidente correlacionado de Sentinel vive en la tabla `SecurityIncident`**. No hay una tabla "de incidentes de Defender XDR" distinta cuando el workspace de Sentinel está conectado al portal unificado — el incidente que ves en `security.microsoft.com` es, por debajo, el mismo incidente que consultarías en `SecurityIncident`.

Se accede a la cola de incidentes desde el portal de Microsoft Defender, en el menú rápido (*quick launch*): **Investigation & response > Incidents & alerts > Incidents**. Ahí aparece la lista completa, con filtros por severidad, estado, categorías, tags, dispositivos/usuarios afectados, y más — muchos de los mismos filtros que ya viste para la cola de alertas en el Día 7.

### 2. Gestionar un incidente: el panel *Manage incident*

La mayoría de las tareas de gestión de un incidente se hacen desde el panel **Manage incident**, al que se llega de dos formas: seleccionando el checkbox de uno o varios incidentes en la cola y pulsando **Manage incidents** en la barra de herramientas, o abriendo la página del incidente y pulsando **Manage incident** en el panel superior (si no se ve, está bajo los tres puntos **...** de la esquina superior derecha).

Las tareas se agrupan en tres momentos del ciclo de vida del incidente:

#### 2.1 Triage (clasificación inicial)

- **Asignar un propietario (*owner*).** Por defecto, un incidente nuevo nace **sin propietario**. Se asigna un único usuario o grupo del tenant desde el campo **Assign to** — al escribir, aparece una lista dinámica de candidatos. **Asignar el incidente asigna automáticamente la misma propiedad a todas las alertas asociadas** a ese incidente: no hace falta asignarlas una por una. Para quitar una asignación se pulsa la **X** junto al nombre y luego se guarda.
- **Asignar o cambiar la severidad.** La severidad del incidente **se fija automáticamente como la severidad más alta entre las alertas que lo componen**, y puede tomar los valores **High, Medium, Low o Informational**. Se puede sobrescribir manualmente desde el desplegable **Severity** del panel.
- **Agregar tags al incidente.** Igual que las alertas (Día 7), los incidentes admiten **tags personalizados** (fondo blanco, texto libre que tú escribes — si el tag no existía antes, la lista te ofrece la opción "*(Create new)*") y **tags de sistema** (fondo rojo o negro, generados automáticamente) que identifican: el **tipo de ataque** (por ejemplo *credential phishing* o *BEC fraud* — fraude de compromiso de correo de negocio), que actuaron **acciones automáticas** (AIR o *automatic attack disruption*), que **Defender Experts** está gestionando el caso, o que hay **activos críticos** involucrados (el etiquetado de activos críticos lo hace **Security Exposure Management** de forma automática sobre dispositivos, identidades y recursos cloud, según clasificaciones predefinidas). Los tags son un criterio de filtro: puedes filtrar después la cola completa por un tag concreto.
- **Cambiar el estado (*status*) del incidente.** Un incidente nace con estado **Active**. Mientras se trabaja en él, se cambia a **In progress**.

#### 2.2 Investigación y resolución

- **Resolver el incidente.** Al cambiar **Status** a **Resolved**, el panel muestra de inmediato un campo nuevo para escribir una **nota de resolución** — el motivo por el que se considera resuelto. Esa nota queda visible tanto en el **activity log** (registro de actividad) del incidente como en el panel de detalles, junto a la entrada que marca la resolución. **Resolver un incidente resuelve automáticamente todas las alertas activas vinculadas a él.** Un incidente que no está resuelto se muestra como **Active** en la cola.
- **Especificar la clasificación (*classification*).** Se puede hacer al resolver o en cualquier momento de la investigación, en cuanto sepas cómo catalogar el incidente. Los valores posibles — ya los viste para alertas individuales en el Día 7, y aquí aplican igual a nivel de incidente completo —:
  - **Not set** (por defecto).
  - **True positive**, con un tipo de amenaza asociado. Para incidentes que reflejan una amenaza real; especificar el tipo ayuda al equipo a detectar patrones repetidos.
  - **Informational, expected activity**, con un tipo de actividad. Para pruebas de seguridad, ejercicios de red team, o comportamiento inusual pero esperado de aplicaciones y usuarios de confianza — el incidente es técnicamente correcto, pero la actividad es benigna y ya conocida.
  - **False positive**: el incidente no refleja actividad maliciosa real; es una alarma equivocada.
  
  Clasificar bien alimenta la mejora de detección de Microsoft Defender XDR con el tiempo — igual que la clasificación a nivel de alerta.
- **Agregar comentarios.** Desde el **activity log** del incidente (tres puntos **...** en la esquina superior derecha → **Activities**), el botón **Add comment** permite escribir texto con formato, enlaces e imágenes. **Cada comentario admite hasta 30.000 caracteres**, y quedan todos registrados en el historial del incidente, visibles también desde el enlace **Comments and history** en la página **Summary**.

#### 2.3 Registro y reporte

- **Editar el nombre del incidente.** Defender asigna un nombre automático según atributos de las alertas (número de endpoints afectados, usuarios afectados, orígenes de detección, categorías) — por ejemplo *"Multi-stage incident on multiple endpoints reported by multiple sources"*. Se puede sobrescribir en el campo **Incident name** del panel *Manage incident*. Dos matices de examen: los incidentes creados **antes** de que existiera el nombrado automático conservan su nombre original, y **si otro incidente se fusiona (merge) dentro de uno que ya renombraste, Defender le asigna un nombre nuevo y sobrescribe el que pusiste**.
- **Revisar el activity log.** Registra automáticamente todas las acciones ("*Audits*") realizadas sobre el incidente, por un usuario o por el sistema, más los comentarios. Se puede filtrar por origen, categoría, proveedor, disparador, estado de la actividad, tipo, nombre del objetivo y quién la realizó.
- **Generar notas de analista con IA (*AI-generated analyst notes*)** — capacidad nueva de Microsoft Security Copilot embebido. Al terminar una investigación, desde los tres puntos de la página del incidente se puede pedir **Generate analyst notes**: un resumen automático de alto nivel de la investigación más el detalle paso a paso, incluidas las **queries KQL** que se corrieron. Sirve para entrenar analistas nuevos, auditorías, o traspasar el trabajo a un compañero. **Requisitos para usarlo:** que el tenant tenga habilitada la característica avanzada *Opt-in to analyst notes* (**Settings > Microsoft Defender XDR > Advanced features**), **licencia de Security Copilot**, y uno de los permisos RBAC **Security Data Read** o **Security Data Manage**. El generado tarda hasta 20 minutos y queda marcado como contenido generado por IA hasta que alguien lo edita manualmente.
- **Exportar el incidente a PDF** (**Export incident as PDF**, en los tres puntos de la página del incidente): incluye resumen, el grafo de *attack story*, activos afectados (hasta 10 por tipo), lista de evidencia (hasta 100 elementos) y todas las alertas y actividades relacionadas. Con licencia de Copilot for Security, el PDF incluye además el resumen y el reporte generados por IA.

### 3. Qué es Case Management, y qué problema resuelve

**Case Management** (gestión de casos) es una capacidad **nativa del portal de Microsoft Defender**, lanzada en 2025 y confirmada en **disponibilidad general (GA)** a mediados de 2026, diseñada para que los equipos de operaciones de seguridad (SOC) gestionen su trabajo de investigación **sin salir del portal y sin depender de herramientas externas de ticketing** (Jira, ServiceNow, ese tipo de plataformas). El problema que resuelve: cuando un SOC usa una herramienta de tickets externa para dar seguimiento a su trabajo, esa herramienta no tiene contexto de seguridad — no sabe qué es un incidente, una alerta o un indicador de compromiso — y eso genera vistas genéricas, ineficiencia y comunicación pobre dentro del equipo.

Los casos de uso que Microsoft documenta explícitamente para case management:

- Responder a eventos de seguridad que **abarcan varios incidentes** a la vez.
- Gestionar el trabajo de **threat hunting** (búsqueda proactiva de amenazas).
- Dar seguimiento a **IoCs (Indicators of Compromise, indicadores de compromiso)** y actores de amenaza a lo largo del tiempo.
- Dar seguimiento a **lógica de detección que necesita ajuste** (por ejemplo, una analytics rule que hay que retocar, sin que eso sea en sí mismo un incidente).

**Requisito indispensable:** para usar case management necesitas tener **un workspace de Microsoft Sentinel conectado al portal de Defender**. Los casos **solo son accesibles desde el portal de Defender**; no existen en el portal de Azure, ni siquiera si el workspace de Sentinel sigue viviendo ahí.

### 4. Case vs Incident — la diferencia que el examen va a explotar

Esta es la distinción central de hoy, y es fácil confundirla porque ambos "agrupan cosas relacionadas". La diferencia de fondo:

| | **Incidente** (`SecurityIncident`) | **Case** (Case Management) |
|---|---|---|
| **Quién lo crea** | Defender XDR, **automáticamente**, al correlacionar alertas de productos por indicadores compartidos | Un **analista, manualmente**, cuando decide que hace falta un contenedor de trabajo |
| **Qué agrupa** | **Alertas** de uno o varios productos que pertenecen al mismo ataque | **Incidentes** (uno o varios) e **indicadores (IOCs)**, ademas de tareas y evidencia propias del caso |
| **Alcance típico** | Una historia de ataque concreta y acotada | Un esfuerzo de trabajo más amplio: puede cubrir varios incidentes relacionados, una campaña de hunting, o el seguimiento de un actor de amenaza a lo largo de semanas |
| **Ciclo de vida** | Nace **Active**, pasa a **In progress**, se cierra como **Resolved**, con clasificación True/False positive o Informational | Nace con estado **New** (de una lista **personalizable** por el administrador: *New, Open, Closed* por defecto), y avanza según el flujo de trabajo propio del SOC |
| **Dónde vive** | `SecurityIncident` en el workspace de Log Analytics — consultable por KQL | **Servicio de Case Management del portal de Defender** — **no existe una tabla de Log Analytics ni de Advanced Hunting para los casos** (ver §8) |
| **Verbo delator en el enunciado** | "se generó automáticamente", "correlacionó alertas", "responder a la alerta X" | "escalar a otro equipo", "dar seguimiento a una campaña de hunting", "vincular varios incidentes", "gestionar tareas y evidencia de una investigación larga" |

La relación entre ambos no es de sustitución sino de **jerarquía**: un case puede contener uno o varios incidentes vinculados, pero un incidente sigue existiendo y gestionándose igual que siempre (con su propio *Manage incident* pane, sus tags, su clasificación) independientemente de si está o no vinculado a un case.

### 5. Anatomía de un case

Cada case tiene su propia página de detalle, con estos campos gestionables:

| Campo | Valores / comportamiento |
|---|---|
| **Priority** | `Very low`, `Low`, `Medium`, `High`, `Critical`. Sin valor por defecto (*none*) |
| **Status** | Definido por los analistas, **personalizable por los administradores**. Los tres valores de fábrica son **New**, **Open** y **Closed**; el valor por defecto de un case nuevo es **New** |
| **Assigned to** | Un **único usuario** del tenant (igual que en los incidentes: no se permite asignar a varios a la vez) |
| **Description** | Texto plano |
| **Case ID** | Numérico, **empieza en 1000** y **nunca se purga** (no se reutilizan ni se borran los números); se asigna automáticamente |
| **Created by / Created on / Last updated by / Last updated on** | Metadatos automáticos |
| **Due on** | Fecha límite del case completo |
| **Linked incidents** | Los incidentes vinculados a este case (ver §7) |

**Sobre personalizar el status:** como los IDs de case nunca se purgan y no hay un mecanismo de borrado masivo, la recomendación de la documentación para "archivar" casos viejos es **usar estados personalizados y filtros** — por ejemplo, un equipo de threat hunting que trabaja con backlog semanal puede crear estados como *"Research phase"* y *"Generating hypothesis"* en lugar de limitarse a New/Open/Closed.

### 6. Tareas (*tasks*) dentro de un case

Un case se puede descomponer en **tasks** — componentes granulares de trabajo. Cada task tiene: **nombre**, **estado**, **prioridad**, **propietario (owner)** y **fecha límite (due date)**. Los estados posibles de una task son seis: **New, In progress, Failed, Partially completed, Skipped, Completed**. La task también incluye un campo de **descripción** (qué hay que hacer) y, al completarla, **notas de cierre (*closing notes*)** que documentan el resultado. Esto es lo que permite que en cualquier momento se sepa exactamente quién es responsable de qué parte del caso y para cuándo.

### 7. Vincular objetos a un case: incidentes e indicadores

**Vincular (link)** un case a otros objetos del entorno le da al equipo el contexto completo de una amenaza. Se pueden vincular dos tipos de objeto: **incidentes** e **indicadores de compromiso (IOCs)**.

#### 7.1 Vincular incidentes

Ejemplo del escenario que usa la propia documentación: un threat hunter encuentra actividad maliciosa y crea un **incidente** para que lo trabaje el equipo de respuesta (IR). El threat hunter **vincula ese incidente a su case de hunting**, dejando explícito que están relacionados — así el equipo de IR entiende de dónde viene la pista.

Se puede hacer en cualquiera de las dos direcciones:
- **Desde el case**: pestaña **Linked Objects** de la página del case → elegir el incidente a vincular.
- **Desde el incidente**: en la página de detalles del incidente, menú de los tres puntos **...** → **Link to case** (o similar, según la vista).

#### 7.2 Vincular indicadores (preview)

También se pueden vincular **indicadores de compromiso (TI Indicators)** a un case, para centralizar el seguimiento de IOCs relacionados con la misma investigación. Se hace desde la pestaña **Linked Objects** del case → **Indicators** → **Add** → elegir el workspace donde vive el indicador → seleccionar el indicador → **Link**. También se puede hacer al revés, desde la vista de gestión de indicadores de inteligencia de amenazas, seleccionando el indicador y pulsando **Link Cases**.

> [!important] Dato de migración que el examen puede mencionar
> Los **Projects de Microsoft Defender Threat Intelligence (MDTI)** — la forma anterior de organizar y dar seguimiento a indicadores de amenaza — **están deprecados**. La ruta vigente para organizar y hacer seguimiento de indicadores es precisamente **vincularlos a un case**, no crear un Project.

### 8. Colaboración, evidencia y borrado

- **Activity log del case.** Igual que en los incidentes, cada case lleva un registro de actividad con **comentarios en texto enriquecido** (tablas, enlaces, formato) y **eventos de auditoría automáticos** — los cambios en el case (de estado, de prioridad, vínculos añadidos, etc.) quedan registrados solos, con los más recientes arriba. Se puede filtrar para ver solo comentarios o solo historial de auditoría.
- **Adjuntos (*Attachments*).** Pestaña propia del case para centralizar reportes, correos, capturas de pantalla, archivos de log — hasta **10 archivos por comentario**. Al subir un archivo se escanea en segundo plano contra malware; una vez completado el escaneo, cualquiera con acceso al case puede descargarlo. **Si necesitas subir una muestra de malware real como evidencia, hay que envolverla en un ZIP protegido por contraseña** para que el escaneo no la elimine ni la bloquee.
- **Borrar un case (preview).** Desde la pantalla de **Cases**, seleccionar el case → **Delete**. Aparece un cuadro de confirmación donde **hay que escribir literalmente la palabra "delete"** antes de poder confirmar — una fricción deliberada para evitar borrados accidentales, igual que ya viste con los workbooks en el Día 7 (aunque ahí el borrado no pide escribir una palabra, aquí sí).

### 9. RBAC de case management — quién puede hacer qué

**RBAC (Role-Based Access Control)**, el control de acceso basado en roles, gobierna quién ve y quién gestiona los cases. Se puede conceder de dos maneras equivalentes, según el sistema de permisos que use tu organización: **Microsoft Defender unified RBAC** (el modelo de permisos granular del portal de Defender, organizado en categorías y sub-permisos) o los **roles integrados de Microsoft Sentinel** que ya trabajaste el Día 7.

| Qué se puede hacer | Permiso de Defender unified RBAC | Rol equivalente de Microsoft Sentinel |
|---|---|---|
| **Solo ver**: cola de cases, detalles del case, tasks, comentarios, auditorías del case | **Security operations > Security data basics (read)** | **Microsoft Sentinel Reader** |
| **Crear y gestionar**: cases y sus tasks, asignar, actualizar estado, vincular/desvincular incidentes | **Security operations > Alerts (manage)** | **Microsoft Sentinel Responder** |
| **Personalizar las opciones de status** del case | **Authorization and setting > Core Security settings (manage)** | **Microsoft Sentinel Contributor** |

Fíjate en el paralelismo exacto con la tabla de roles de Sentinel del Día 7: **Reader ve, Responder gestiona el trabajo del día a día, Contributor además configura el sistema** (en este caso, los estados personalizados). Es el mismo patrón de escalón de privilegio que ya memorizaste, aplicado a una superficie nueva.

### 10. Límites de servicio de case management (dato de examen, verificado hoy)

La documentación de límites de servicio de Microsoft Sentinel incluye una sección dedicada a case management:

| Límite | Valor |
|---|---|
| Cases por tenant | **100.000** |
| Adjuntos por tenant | **500 GB** |
| Incidentes vinculados por case | **100** |

Y, ya que estamos repasando límites, conviene tener frescos también los **límites de incidentes** (`SecurityIncident`), porque el examen los mezcla con los de case management en el mismo tipo de pregunta:

| Límite de incidentes | Valor |
|---|---|
| Disponibilidad de la experiencia de investigación | **90 días** desde la última actualización del incidente |
| Retención de entidades del incidente | **180 días** |
| Alertas por incidente | **150 alertas** |
| Comentarios por incidente | **100 comentarios**, de hasta **30.000 caracteres** cada uno |
| Tasks (dentro de automation rules, no confundir con las tasks de un case) | — |
| Incidentes devueltos por una llamada a la API `list` | **1.000 incidentes** como máximo |

### 11. La tabla que NO existe — y por qué es importante saberlo

Este es el punto que más vale la pena subrayar, porque la instrucción de hoy pedía documentar "la tabla nueva relacionada con cases" — y la respuesta honesta, verificada contra la documentación de Microsoft Learn de hoy (agosto 2026), es que **no existe ninguna tabla de Log Analytics ni de Advanced Hunting llamada algo como `SecurityCase` o similar**. Los datos de case management (los cases en sí, sus tasks, comentarios, adjuntos y vínculos) **viven únicamente en el servicio de Case Management del portal de Defender**, no en el workspace de Log Analytics de Sentinel. Por eso no se pueden consultar con una query KQL de Advanced Hunting ni de Sentinel — se gestionan exclusivamente desde la interfaz de **Cases** en `security.microsoft.com`, o mediante programación vía Microsoft Graph.

Esto contrasta directamente con el incidente, que sí vive como fila consultable en `SecurityIncident`. Si el examen te presenta una opción del estilo *"consulta la tabla `SecurityCase` para ver los cases abiertos"*, es un distractor inventado — exactamente el patrón de "nombres de columna razonables pero falsos" que ya te costó puntos en el simulacro (ver §12, punto 3 del repaso).

### 12. Gestión multi-tenant (mención breve)

Si tu organización opera varios tenants de Microsoft 365/Defender (por ejemplo, un MSSP que da servicio a varios clientes), los cases también se pueden gestionar de forma centralizada desde el **portal de gestión multi-tenant (MTO, Multitenant Organization)**. No es examinable en detalle hoy, pero conviene saber que existe como extensión natural de case management para quien administra más de un tenant.

---

## 💡 Ejemplos concretos

### Ejemplo 1 — De hunting a IR: cuándo crear un case y vincular incidentes

**Escenario:** Un threat hunter, revisando patrones de tráfico DNS inusual durante una sesión de hunting semanal, descubre indicadores que apuntan a una campaña activa de un actor de amenaza conocido. En el transcurso de dos días aparecen **tres incidentes distintos** en la cola, generados por Defender XDR en tres dispositivos diferentes, todos con el mismo hash de archivo malicioso.

**Razonamiento:** cada incidente ya agrupa correctamente las alertas de *su* dispositivo. Pero el threat hunter necesita **una vista que abarque los tres a la vez**, más un lugar donde documentar la campaña completa, asignar tareas de investigación a distintos analistas y dar seguimiento al IOC (el hash) a lo largo del tiempo — eso es exactamente lo que un incidente individual no está diseñado para hacer.

**Acción:** el threat hunter crea un **case** nuevo (Priority = High, Status = New), lo describe como "Campaña [nombre del actor] — múltiples endpoints", **vincula los tres incidentes** desde la pestaña Linked Objects, **vincula el indicador** (el hash) desde la misma pestaña, y crea **tasks** para cada analista asignado (por ejemplo, "Revisar persistencia en Host-03", owner = Analista B, due date = mañana). El equipo de IR, al abrir cualquiera de los tres incidentes, ve que están vinculados a un case y entiende de inmediato que forman parte de algo más grande.

### Ejemplo 2 — RBAC: quién puede hacer qué con los cases

**Escenario de examen tipo:** Un analista con el rol **Microsoft Sentinel Reader** intenta crear un case nuevo y no puede. Su compañero, con **Microsoft Sentinel Responder**, sí puede crearlo, pero cuando intenta añadir un estado personalizado llamado "Esperando parche", la opción no está disponible.

**Razonamiento:** Reader solo tiene el permiso equivalente a **Security data basics (read)** — ver la cola, ver detalles, ver tasks y comentarios, nunca crear ni modificar nada. Responder sube un escalón: **Alerts (manage)** le permite crear cases, gestionar sus tasks, asignar y vincular/desvincular incidentes — pero **personalizar las opciones de status es una tarea de configuración del sistema**, que exige **Core Security settings (manage)**, equivalente a **Microsoft Sentinel Contributor**. Ninguno de los dos primeros roles la incluye.

**Conclusión:** para que el analista pueda crear estados propios como "Esperando parche", necesita que alguien le asigne (o le sume) el rol **Microsoft Sentinel Contributor** — no basta con subir a Responder.

### Ejemplo 3 — Reforzando P3 del Simulacro 01: retención larga dentro de un case

**Escenario:** Un case de threat hunting sigue abierto desde hace 14 meses, dando seguimiento a un actor de amenaza persistente. El equipo de compliance pide, una vez al año, una auditoría de los eventos de firewall (`CommonSecurityLog`) asociados a ese case, con retención obligatoria de 7 años, pero el resto del año casi nadie consulta esos datos.

**Razonamiento (repaso directo del error del simulacro):** el caso de uso — retener años, consultar rara vez — es el escenario canónico del **Data lake tier** de Microsoft Sentinel: retención extendida (hasta 12 años), coste bajo de almacenamiento, y consulta bajo demanda vía **KQL jobs** cuando de verdad hace falta (por ejemplo, en la auditoría anual). La alternativa de "exportar a una Storage Account de Azure" suena parecida pero **pierde la capacidad de consultar con KQL nativo** — habría que reconstruir el dato en otro sistema para analizarlo. Y extender la retención completa del **Analytics tier** es la opción cara: pagas el precio alto de consulta instantánea todos los días del año, aunque solo la necesites uno.

```kql
// Consulta que correrías como KQL job contra el Data lake tier
// durante la auditoría anual, NO como parte de la operación diaria
CommonSecurityLog
| where TimeGenerated between (datetime(2019-01-01) .. datetime(2026-01-01))
| where DeviceVendor == "Contoso-NGFW"
| summarize EventCount = count() by DeviceAction, bin(TimeGenerated, 30d)
```

**Conclusión:** dentro de un case que documenta una investigación larga, la evidencia histórica de más de un año casi siempre se apoya en el Data lake tier, no en exportaciones externas ni en retención cara del tier de Analytics.

---

## 🎥 Videos

1. **[Exploring Case Management in the Unified SecOps Platform](https://www.youtube.com/watch?v=G-vfMJSL11g)** — YouTube, publicado el 28 de mayo de 2025 por el equipo de producto de Microsoft Sentinel. Un *Senior Product Manager* (Ben Nick) hace un recorrido en vivo por la funcionalidad de Case Management recién lanzada: cómo se ve la cola de cases, cómo se vincula un incidente, y el impacto en el flujo de trabajo del SOC. Duración aproximada 10-15 minutos. Es el video más directo y actual sobre el tema de hoy que existe en YouTube.
2. **[Preparing for SC-200: Manage incident response (Part 3 of 4)](https://learn.microsoft.com/en-us/shows/exam-readiness-zone/preparing-for-sc-200-manage-incident-response)** — episodio de *Exam Readiness Zone* (serie oficial de Microsoft Learn) con Bob Tichelman, dedicado íntegramente al bloque de gestión de respuesta a incidentes del examen SC-200. Duración aproximada 20-30 minutos (formato habitual de la serie).
   > ⚠️ **Advertencia de vigencia:** este episodio referencia la **estructura de pesos ANTERIOR** del examen (fila "Manage incident response: 25-30%" de un desglose de cuatro bloques), que **ya no es la vigente** — hoy son tres dominios con los pesos 40-45/35-40/20-25 que usas en este plan. El contenido conceptual sobre gestión de incidentes sigue siendo válido y útil, pero **ignora los porcentajes y la estructura de bloques que menciona el presentador**; guíate por la tabla de arriba (§0) para la estructura vigente.

Si prefieres una fuente 100% escrita y garantizada al día, la página de Microsoft Learn [Manage security operations cases natively in the Microsoft Defender portal](https://learn.microsoft.com/en-us/unified-secops/cases-overview) (actualizada el 31 de julio de 2026, la fuente principal de la lección de hoy) trae capturas de pantalla de cada paso descrito en §3-§8.

---

## 🧪 Ejercicio práctico

**Módulo de Microsoft Learn:** [Mitigación de amenazas con Microsoft Defender XDR](https://learn.microsoft.com/es-es/training/paths/sc-200-mitigate-threats-using-microsoft-365-defender/) (módulos de gestión de incidentes)

**Lab:** [Lab 8 Ex7 — Investigate Incidents (Defender)](https://microsoftlearning.github.io/SC-200T00A-Microsoft-Security-Operations-Analyst/Instructions/Labs/LAB_AK_08_Lab1_Ex07_Investigate_Defender.html)

**Checklist del lab de hoy:**

1. **Manage incident pane completo.** Abre un incidente de tu entorno (si no tienes uno reciente, usa cualquiera de los generados en labs anteriores, o crea uno manualmente siguiendo [Manually create an incident or alert in Microsoft Defender](https://learn.microsoft.com/en-us/defender-xdr/manually-create-incident)). Practica en orden: asignar un owner, cambiar la severidad, añadir un tag personalizado, cambiar el status a **In progress**, clasificarlo (elige cualquier valor de la lista de §2.2 para ver las opciones), añadir un comentario en el activity log, y — si el botón está disponible en tu tenant — probar **Export incident as PDF**.
2. **Explorar Cases.** En el menú rápido del portal de Defender, busca la opción **Cases**. Si tu tenant tiene un workspace de Sentinel conectado al portal unificado, entra y revisa la cola. Si la opción no aparece (frecuente en tenants de laboratorio o estudiantiles sin el onboarding completo a Defender), documenta esa limitación y repasa el flujo completo mirando las capturas de la página de Microsoft Learn de §3-§8 en vez de ejecutarlo en vivo.
3. **Si Cases está disponible:** crea un case de prueba con Priority = Medium, agrega una task con un due date, vincula el incidente que trabajaste en el paso 1 desde **Linked Objects > Incidents**, y añade un comentario con formato (una tabla o un enlace) para ver el editor de texto enriquecido en acción.
4. **RBAC.** En **Microsoft Entra ID** o en el resource group de tu workspace de Sentinel, revisa qué rol tiene asignada tu cuenta y contrástalo contra la tabla de §9: ¿podrías crear un case? ¿Podrías personalizar sus estados?
5. **Repaso de límites.** Sin necesidad de alcanzarlos, anota mentalmente los tres límites de case management de §10 (100.000 cases/tenant, 500 GB adjuntos/tenant, 100 incidentes vinculados/case) — son el tipo de dato que el examen pregunta tal cual.

---

## ✅ Quiz del día — Case Management

Tres preguntas sobre el contenido nuevo de hoy. Responde antes de abrir el bloque de respuestas.

**1.** Un SOC quiere dar seguimiento, a lo largo de varias semanas, a una campaña de threat hunting que ya generó cuatro incidentes distintos en dispositivos diferentes, todos con el mismo indicador de compromiso. ¿Qué construyen para centralizar el trabajo sin perder el detalle de cada incidente individual?

- A) Un incidente nuevo, fusionando manualmente los cuatro incidentes existentes en uno solo
- B) Una automation rule que asigne los cuatro incidentes al mismo owner
- C) Un case, vinculando los cuatro incidentes y el indicador desde la pestaña Linked Objects
- D) Un workbook que muestre los cuatro incidentes en una misma tabla visual

**2.** Un analista necesita consultar, con una query KQL, todos los cases abiertos con Priority = High de las últimas dos semanas. ¿Qué ocurre al intentarlo?

- A) La consulta funciona sobre la tabla `SecurityCase`, que se puebla automáticamente al crear un case
- B) La consulta funciona sobre `SecurityIncident`, filtrando por un campo `CasePriority`
- C) La consulta funciona sobre `Cases_CL`, la tabla custom que Sentinel crea al habilitar case management
- D) La consulta no es posible: case management no expone ninguna tabla de Log Analytics ni de Advanced Hunting, los datos viven solo en el servicio de Case Management del portal de Defender

**3.** Un administrador quiere que su equipo de threat hunting use estados personalizados como "Research phase" y "Generating hypothesis" en lugar de los estados de fábrica de los cases. ¿Qué rol o permiso necesita, como mínimo, para configurar esto?

- A) Microsoft Sentinel Reader, porque personalizar estados es solo una preferencia de visualización
- B) Microsoft Sentinel Responder, porque ya incluye la gestión completa de cases
- C) Ningún rol adicional: cualquier usuario con acceso al portal de Defender puede renombrar los estados
- D) Microsoft Sentinel Contributor (o el permiso equivalente Core Security settings - manage), porque personalizar estados es una tarea de configuración del sistema

> [!success]- Respuestas — Quiz del día
> **1 — C.** Un case está diseñado exactamente para este escenario: agrupar varios incidentes e indicadores relacionados sin tocar la estructura de cada incidente individual, que sigue viviendo y gestionándose por su cuenta. **A** es incorrecto y además arriesgado: fusionar incidentes reales a mano no es el mecanismo pensado para esto y perdería granularidad. **B** resuelve solo la asignación de owner, no centraliza la campaña completa ni permite tasks ni seguimiento de IOCs. **D** confunde propósito: un workbook visualiza datos ya existentes, no crea un contenedor de trabajo con tasks y vínculos.
>
> **2 — D.** Verificado hoy contra la documentación (agosto 2026): case management no tiene una tabla de Log Analytics ni de Advanced Hunting asociada. Los cases se gestionan únicamente desde la interfaz de Cases del portal de Defender. **A**, **B** y **C** son nombres de tabla plausibles pero inventados — exactamente el patrón de distractor que ya te costó puntos con columnas de KQL "razonables pero falsas" en el simulacro anterior.
>
> **3 — D.** Personalizar las opciones de status de un case es una tarea de configuración del sistema, que en Defender unified RBAC corresponde al permiso **Authorization and setting > Core Security settings (manage)**, equivalente al rol **Microsoft Sentinel Contributor**. **A** describe mal a Reader, que solo puede ver, nunca configurar nada. **B** confunde a Responder, que sí puede crear y gestionar cases y tasks, pero no configurar el sistema de estados — ese es un escalón más arriba. **C** es falso: sin el permiso correcto, la opción de personalizar estados ni siquiera aparece en la interfaz.

---

## 🔁 Repaso acumulativo — Refuerzo de errores del Simulacro 01

Estas cinco preguntas reformulan, con otro enunciado, los cinco puntos que el Simulacro 01 (Días 1–6) detectó como flojos. No son contenido de hoy — son la mitad "de mantenimiento" de la lección, para que estos cinco errores queden fijados antes de seguir avanzando.

**R1.** Un case de investigación lleva 18 meses abierto dando seguimiento a un actor de amenaza. El equipo legal exige conservar los logs de firewall asociados durante 7 años, pero solo los consulta una vez al año. ¿Qué configuración de retención de Microsoft Sentinel minimiza el costo sin perder la capacidad de consulta KQL nativa cuando llegue la auditoría?

- A) Exportar los datos a una Storage Account de Azure, donde se pueden reabrir con cualquier herramienta el día de la auditoría
- B) Configurar el Data lake tier con retención extendida a 7 años, y consultar vía KQL jobs solo cuando haga falta
- C) Extender la retención del Analytics tier a 7 años para tener siempre disponibilidad instantánea
- D) Crear una tabla custom `_CL` separada con su propia retención de 7 años

**R2.** Antes de mover la regla ASR (Attack Surface Reduction) "Block execution of potentially obfuscated scripts" de modo Audit a modo Block, el equipo quiere ver cuántos eventos generó en las últimas dos semanas y qué procesos los dispararon. ¿Qué consulta KQL corren?

- A)
```kql
SecurityIncident
| where Title has "Asr"
| summarize count() by Severity
```
- B)
```kql
ThreatIntelIndicators
| where ThreatType == "Obfuscation"
```
- C)
```kql
Anomalies
| where AnomalyTemplateName has "obfuscated"
```
- D)
```kql
DeviceEvents
| where ActionType startswith "Asr"
| where TimeGenerated > ago(14d)
| summarize Eventos = count() by ActionType, InitiatingProcessFileName
```

**R3.** Un atacante que ya obtuvo credenciales de administrador local intenta, vía PowerShell y Registro, deshabilitar la protección en tiempo real de Microsoft Defender Antivirus para desplegar su payload sin ser detectado. ¿Qué advanced feature de Microsoft Defender for Endpoint bloquea específicamente este intento, incluso con privilegios de administrador local?

- A) Tamper protection
- B) Automated Investigation (AIR)
- C) Web content filtering
- D) EDR in block mode

**R4.** Un equipo de compliance necesita evidencia forense detallada de todo acceso a archivos dentro de la carpeta de una aplicación financiera propietaria, en 40 servidores específicos, sin aumentar el costo de ingesta del resto del entorno. ¿Qué deben configurar primero, antes de poder crear la regla de custom data collection, y en qué tabla aparecen los resultados?

- A) Un playbook que etiquete los 40 servidores; los resultados aparecen en la tabla estándar `DeviceFileEvents`
- B) Nada: la regla de custom data collection se puede crear apuntando directo a los 40 nombres de dispositivo, sin configuración previa
- C) Una dynamic tag en Asset Rule Management que identifique esos 40 servidores; los resultados aparecen en la tabla `DeviceCustomFileEvents`
- D) Una analytics rule Scheduled que identifique los 40 servidores; los resultados aparecen en `SecurityAlert`

**R5.** Un analista con el rol "Microsoft Sentinel Contributor" crea una automation rule y agrega la acción "Run playbook", pero el playbook aparece en gris, no seleccionable. ¿Cuál es la causa y cómo se resuelve?

- A) El playbook debe reconfigurarse como Logic App Standard en lugar de Consumption antes de poder usarse en automation rules
- B) Falta que la cuenta de servicio de Microsoft Sentinel tenga el rol Microsoft Sentinel Automation Contributor sobre el resource group donde vive el playbook; se concede desde "Manage playbook permissions", lo cual exige permisos Owner sobre ese resource group
- C) El analista necesita el rol Microsoft Sentinel Reader sobre la suscripción completa donde vive el playbook
- D) Las automation rules solo admiten ejecutar un playbook por suscripción, y ya existe uno asignado en otra regla

> [!success]- Respuestas — Repaso acumulativo Simulacro 01
> **R1 — B.** "Retener años, consultar poco" es el caso de uso canónico del **Data lake tier**: retención extendida (hasta 12 años), coste bajo, consulta bajo demanda vía **KQL jobs** cuando de verdad hace falta. **A** pierde la consulta KQL nativa — hay que sacar los datos de Sentinel para analizarlos en otro sistema, justo lo que el enunciado pide evitar. **C** es la opción cara: pagar consulta instantánea los 365 días del año para un dato que se mira una vez. **D** no resuelve nada: una tabla custom `_CL` sigue estando sujeta a los mismos tiers de retención que cualquier otra tabla, no es una alternativa de arquitectura.
>
> **R2 — D.** Los eventos generados por las reglas ASR, tanto en modo Audit como en Block, quedan en la tabla **`DeviceEvents`** con un `ActionType` que **empieza con el prefijo `Asr`** (por ejemplo `AsrScriptObfuscationBlocked`). Agrupar por `ActionType` e `InitiatingProcessFileName` muestra exactamente qué procesos disparan la regla y con qué frecuencia. **A** confunde el nivel: `SecurityIncident` es para incidentes correlacionados de Sentinel, no para eventos granulares de endpoint. **B** es la tabla de indicadores de threat intelligence, sin relación con ASR. **C** es la tabla de resultados de anomaly rules (machine learning), no de reglas ASR.
>
> **R3 — A.** **Tamper protection** (protección contra manipulación) bloquea específicamente los intentos de cambiar configuraciones críticas de seguridad de Microsoft Defender Antivirus — como deshabilitar la protección en tiempo real — incluso si quien lo intenta tiene privilegios de administrador local y usa PowerShell, el Registro o una GPO. **B** es la opción trampa clásica: **AIR (Automated Investigation and Response)** sirve para *investigar alertas ya generadas*, no para *impedir* que alguien apague la configuración del antivirus — son objetivos completamente distintos. **C** filtra contenido web malicioso, sin relación con proteger la configuración del AV. **D** permite que el motor EDR bloquee post-ejecución cuando el AV principal es de terceros, un escenario distinto al del enunciado.
>
> **R4 — C.** Custom data collection en Microsoft Defender for Endpoint exige, como prerrequisito obligatorio, crear primero una **dynamic tag en Asset Rule Management** que identifique los dispositivos objetivo (aquí, los 40 servidores) — sin esa tag no se puede definir el alcance de la regla. Los eventos de acceso a archivos resultantes aterrizan en la tabla nueva **`DeviceCustomFileEvents`**, que es distinta de la tabla estándar `DeviceFileEvents` (esta última recoge la telemetría normal de archivos, no la recolección personalizada). **A** y **D** apuntan a tablas equivocadas para este mecanismo. **B** es falso: sin la dynamic tag no hay forma de acotar la regla a esos 40 dispositivos concretos.
>
> **R5 — B.** Microsoft Sentinel ejecuta los playbooks disparados desde una automation rule usando una **cuenta de servicio propia**, no la cuenta del usuario que creó la regla. Esa cuenta de servicio necesita el rol **Microsoft Sentinel Automation Contributor** otorgado explícitamente **sobre el resource group donde vive el playbook** — se concede desde el enlace "Manage playbook permissions" dentro del propio asistente de la automation rule, y quien lo otorgue necesita ser **Owner** de ese resource group. **A** inventa un requisito técnico (Standard vs Consumption) que no tiene relación con el permiso faltante. **C** asigna el rol equivocado (Reader, que ni siquiera existe para este propósito) sobre el ámbito equivocado (la suscripción). **D** es falso: no hay un límite de "un playbook por suscripción" en automation rules.

---

## ⚠️ Trampas del examen en los temas de hoy

1. **Un case NO reemplaza a un incidente.** Un case puede contener incidentes vinculados, pero cada incidente sigue viviendo y gestionándose igual (`Manage incident`, clasificación, tags) independientemente de si está vinculado a algún case.
2. **No existe tabla de Log Analytics ni de Advanced Hunting para cases.** Nada de `SecurityCase`, `Cases_CL` ni similares — es un distractor inventado si aparece en una opción.
3. **Case management exige un workspace de Sentinel conectado al portal de Defender**, y los cases solo se ven ahí — nunca en el portal de Azure.
4. **RBAC de cases es un espejo del RBAC de Sentinel:** Reader = solo ver · Responder = crear y gestionar cases/tasks/vínculos · Contributor = además personalizar el sistema de estados.
5. **El Case ID empieza en 1000 y nunca se purga.** Para "archivar" cases viejos se usan estados personalizados y filtros, no borrado masivo.
6. **Borrar un case exige escribir la palabra "delete"** en el cuadro de confirmación — fricción deliberada, dato literal de examen.
7. **Los Projects de Microsoft Defender Threat Intelligence están deprecados** — la forma vigente de organizar IOCs es vincularlos a un case.
8. **La severidad de un incidente es automática** (la más alta entre sus alertas) pero se puede sobrescribir manualmente; asignar un owner al incidente asigna esa misma propiedad a todas sus alertas.
9. **Resolver un incidente resuelve automáticamente todas sus alertas activas vinculadas** — no hay que resolverlas una por una.
10. **Informational, expected activity ≠ False positive**, también a nivel de incidente completo (no solo de alerta suelta, ver Día 7): la primera es un incidente correcto sobre actividad benigna; la segunda es un incidente que directamente estaba mal generado.
11. **Data lake tier vs exportar a Storage Account:** el Data lake conserva consulta KQL nativa vía KQL jobs; exportar a Storage Account la pierde.
12. **ASR events → `DeviceEvents`, `ActionType startswith "Asr"`.** No están en tablas de threat intelligence ni de incidentes.
13. **Tamper protection ≠ Automated Investigation (AIR).** Tamper protection impide que se toque la configuración del AV; AIR investiga alertas, no protege la configuración.
14. **Custom data collection exige una dynamic tag previa en Asset Rule Management**, y sus resultados van a `DeviceCustomFileEvents`, no a `DeviceFileEvents`.
15. **Permisos de playbook en automation rules: la cuenta de servicio de Sentinel necesita Microsoft Sentinel Automation Contributor sobre el resource group del playbook**, concedido por alguien Owner de ese resource group — nunca sobre el playbook individual ni sobre la suscripción.

---

## 🔗 Notas relacionadas

- [[Dia 07 - Workbooks SOC Optimization Roles de Sentinel y Notificaciones]] — roles de Sentinel (RBAC), que hoy se extienden a case management con el mismo patrón Reader/Responder/Contributor
- [[Dia 06 - AIR Attack Disruption Automation Rules y Playbooks]] — automation rules, playbooks y el permiso Microsoft Sentinel Automation Contributor reforzado en el repaso de hoy (R5)
- [[Dia 05 - Configuracion Avanzada de MDE ASR Rules Advanced Features Device Groups y Custom Data Collection]] — ASR rules, Tamper protection y custom data collection reforzados en el repaso de hoy (R2, R3, R4)
- [[Dia 01 - Arquitectura Sentinel y Tiers de Retencion]] — Analytics tier vs Data lake tier, reforzado en el repaso de hoy (R1)
- [[Simulacro 01 - Dominio 1 (hasta Dia 6)]] — origen de las cinco preguntas de refuerzo de hoy
- [[GUIA_INTENSIVA_24_DIAS]] · [[TRACKER_TUTOR]] · [[MAPA_DIARIO_LEARN_LABS]]

## 📚 Fuentes verificadas hoy (5-ago-2026)

- [Manage security operations cases natively in the Microsoft Defender portal](https://learn.microsoft.com/en-us/unified-secops/cases-overview) — doc actualizado 31-jul-2026, fuente principal de §3-§8
- [Manage incidents in Microsoft Defender](https://learn.microsoft.com/en-us/defender-xdr/manage-incidents) — doc actualizado 16-jun-2026, fuente de §1-§2
- [Microsoft Sentinel service limits](https://learn.microsoft.com/en-us/azure/sentinel/sentinel-service-limits) — sección "Case management limits" e "Incident limits", doc actualizado 14-may-2026
- [Study guide for Exam SC-200](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/sc-200) — skills measured as of July 28, 2026, verificado el desglose exacto del Dominio 2
- [Case Management is now Generally Available](https://techcommunity.microsoft.com/blog/microsoftsentinelblog/case-management-is-now-generally-available/4398558) — Microsoft Tech Community, anuncio de GA
- [Case Management: Incidents, Cases, and When to Use Them](https://techcommunity.microsoft.com/blog/microsoftsentinelblog/case-management-incidents-cases-and-when-to-use-them/4422181) — Microsoft Tech Community, guía de cuándo usar cada uno
