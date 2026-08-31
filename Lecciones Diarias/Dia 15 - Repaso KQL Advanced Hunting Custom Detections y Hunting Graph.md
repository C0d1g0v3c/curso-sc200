---
tags: [sc-200, kql, advanced-hunting, custom-detections, hunting-graph, sentinel-graph, leccion-diaria]
dia: 15
fecha: 2026-08-31
fecha_programada: 2026-08-30
dominio: "Dominio 3 — Perform threat hunting (20-25%) — ARRANCA HOY"
estado: 🟡 En curso
cover: ""
---

# Lección Día 15 — Repaso KQL (Día 14 fusionado) + Advanced Hunting: Custom Detections y Hunting Graph / Sentinel Graph

> [!info] Contexto
> Día 15 del plan de [[PLAN_MAESTRO_MULTITRACK]] §8.3, dentro del **Dominio 3 — Perform threat hunting (20-25% del examen)**, que **arranca hoy** — el Dominio 2 quedó cerrado ayer con el Día 13. Estaba programado para el domingo 30-ago y se retoma hoy lunes 31-ago, un día de retraso real, sin maquillarlo.
>
> Por la **compresión de contenido fijada en §8.2** del plan maestro, el **Día 14 no ocupa día propio**: era un repaso condensado "¿qué tabla uso para X?" de KQL (Kusto Query Language, el lenguaje de consulta de Sentinel y de Advanced Hunting), y se funde en los primeros 15-20 minutos de hoy, porque son temas contiguos — hoy sigues usando KQL, solo que para automatizar detecciones en vez de solo consultarlas.
>
> Objetivo exacto del study guide oficial (skills measured as of July 28, 2026) que cubre la parte nueva de hoy: **"Create and manage custom detection rules by using Advanced Hunting"**, dentro del sub-bloque *Manage Microsoft Sentinel content*. Nota importante de mapeo: este objetivo vive formalmente en el temario dentro del **Dominio 1** (Manage a security operations environment), no del Dominio 3 — se enseña hoy, después de Purview, porque requiere soltura previa con KQL que recién terminas de repasar en la primera sección. La sección de hunting graph / Sentinel Graph sí es contenido nuevo del Dominio 3, dentro de *"Create hunting queries with Kusto Query Language (KQL) that use the graph capabilities of Microsoft Sentinel"*.

---

## 📖 Lectura del día

### 0. Dónde estamos

| Bloque | Qué agrupa | Cuándo |
|---|---|---|
| Dominio 2 completo | Gestión de incidentes, MDE, MDO/MDCA, Entra ID/MDI, Defender for Cloud, Purview, Copilot embebido | Días 8-13, cerrado ayer |
| Repaso KQL "¿qué tabla uso para X?" (Día 14 fusionado) | Consolidar las tablas ya vistas en 13 lecciones | **Primeros 15-20 min de hoy** |
| Custom detection rules (Advanced Hunting) | Convertir una query en una regla automatizada, con acciones de respuesta | **Hoy** |
| Hunting graph / Microsoft Sentinel graph | Visualizar relaciones entre entidades como grafo en vez de tabla | **Hoy — arranca el Dominio 3** |

### 1. Repaso KQL — drill "¿qué tabla uso para X?" (15-20 min)

Antes de seguir, un ejercicio de retrieval activo. Para cada escenario de abajo, **decide primero qué tabla usarías** (no mires la tabla de referencia todavía) y solo después compara. Son las tablas que ya usaste en las lecciones de los Días 1 a 13 — la meta no es aprender nada nuevo aquí, es fijar el reflejo rápido, porque es exactamente el tipo de detalle fino que el examen premia (nombre exacto de tabla, no el concepto general).

**Los 12 escenarios:**

1. Quiero ver las alertas individuales que generó un producto de Defender (MDE, MDO, MDCA, MDI, Defender for Cloud), sin correlacionar nada todavía.
2. Quiero ver el incidente correlacionado que Sentinel armó agrupando varias alertas.
3. Necesito ver qué entidades (dispositivo, cuenta, IP) están vinculadas a una alerta concreta, en una sola fila.
4. Quiero auditar el impacto de una regla ASR (Attack Surface Reduction) antes de pasarla de Audit a Block.
5. Necesito confirmar que mi regla de custom data collection (Día 5) está capturando eventos correctamente.
6. Quiero ver los eventos donde ZAP (Zero-hour Auto Purge) movió o eliminó un correo después de la entrega.
7. Necesito los IOCs (Indicators of Compromise) clásicos — IP, dominio, hash, URL — que llegaron por TAXII, MDTI o la Upload API.
8. Necesito contexto más rico de threat intelligence — actores de amenaza, técnicas MITRE, malware asociado — no solo el indicador simple.
9. Quiero ver actividad del plano de control de Azure (operaciones de Azure Resource Manager) o de Kubernetes.
10. Necesito detectar llamadas sospechosas de una app a Microsoft Graph API, sin licencia Entra ID P1/P2 adicional, con retención de 30 días.
11. Necesito la cobertura completa de llamadas a Microsoft Graph API, con la columna que correlaciona con el inicio de sesión completo.
12. Quiero consultar una lista de referencia que yo mismo subí (por ejemplo, hosts de alto valor) dentro de una query.

**Tabla de referencia — "necesito X → uso la tabla Y":**

| Necesito... | Uso la tabla | De dónde la conoces | Nota clave |
|---|---|---|---|
| Alertas individuales de un producto Defender | **`SecurityAlert`** | Regla fijada Día 6, reforzada Días 9-13 | Alerta de producto = `SecurityAlert`. Incidente correlacionado = `SecurityIncident`. No son intercambiables |
| Incidente correlacionado de Sentinel | **`SecurityIncident`** | Día 6, esquema explicado Día 6 (bis) | Guarda **una fila por actualización**, no una por incidente — usa `summarize arg_max(LastModifiedTime, *) by IncidentNumber` para el estado final |
| Entidades vinculadas a una alerta en una sola fila | **`AlertEvidence`** | Distractor correcto identificado en el Día 6 (quiz) | Combina las entidades relacionadas (archivos, IPs, cuentas) de una alerta — no reemplaza a `SecurityAlert`, la complementa |
| Auditar impacto de una regla ASR antes de Block | **`DeviceEvents`**, `ActionType` con prefijo `Asr` | Día 5 | El ID de la regla concreta vive en `AdditionalFields` |
| Confirmar custom data collection | **`DeviceCustomFileEvents`** | Día 5 | Tabla específica para las reglas de recolección custom, distinta de `DeviceFileEvents` |
| Eventos de ZAP sobre correo entregado | **`EmailPostDeliveryEvents`**, `ActionType` = `Phish ZAP` / `Malware ZAP` | Día 10 | El nombre genérico "ZAP" solo existe como filtro de UI en Threat Explorer, no como valor real de columna |
| IOCs clásicos (IP, dominio, hash, URL) | **`ThreatIntelIndicators`** | Día 3 | Reemplaza a la tabla retirada `ThreatIntelligenceIndicator` (dejó de recibir datos el 31-jul-2025) |
| Contexto rico de TI (actores, técnicas, malware) | **`ThreatIntelObjects`** | Día 3 | Objetos STIX que NO son indicadores simples — Threat Actors, Attack Patterns, Relationships |
| Actividad del plano de control Azure / Kubernetes | **`CloudAuditEvents`** | Día 12 | Operaciones de Azure Resource Manager y `KubeAudit`, tabla de Defender for Cloud |
| Llamadas a Graph API, gratis, sin licencia adicional, 30 días | **`GraphApiAuditEvents`** | Día 13 | Vive en el esquema de Advanced Hunting, no en Log Analytics. No trae `SignInActivityId` |
| Cobertura completa de Graph API + correlación con sign-in | **`MicrosoftGraphActivityLogs`** | Día 13 | Requiere Entra ID P1/P2, vía diagnostic settings. Columna clave: `SignInActivityId` |
| Lista de referencia propia dentro de una query | **`Watchlist`** (vía `_GetWatchlist('nombre')`) | Día 1 | La única tabla del plan gratuito Analytics cuando aún no hay más datos conectados |

**Dos tablas más que ya usaste y que no entran en el drill de arriba pero conviene tener frescas:** `SecurityEvent` (Windows Security Events vía AMA — Azure Monitor Agent —, Día 2) y `AzureActivity` (diagnostic setting "Azure Activity", Día 3, distinta de `CloudAuditEvents` porque esta última es específica de Defender for Cloud sobre recursos evaluados por sus planes, mientras `AzureActivity` es el log de control plane general de toda la suscripción).

**El patrón de fondo que conecta las 12 filas:** en casi todos los casos, el error no es "no sé qué hace la tabla" — es confundir dos tablas de nombre parecido que responden preguntas distintas (`SecurityAlert`/`SecurityIncident`, `ThreatIntelIndicators`/`ThreatIntelObjects`, `GraphApiAuditEvents`/`MicrosoftGraphActivityLogs`, `AzureActivity`/`CloudAuditEvents`). Es el mismo patrón de "el calificador del enunciado decide" que ya viste en las tablas de decisión de los Días 9 y 13, aplicado ahora a nombres de tabla en vez de a nombres de herramienta.

---

### 2. El problema que resuelven las custom detection rules

Hasta ahora, cada vez que corrías una query en **Advanced Hunting** (el motor de búsqueda basado en KQL dentro de Microsoft Defender XDR que ya usaste en ejemplos de días anteriores), la ejecutabas manualmente: tú decides cuándo correrla, tú lees el resultado, tú decides si actuar. Eso funciona para investigar un incidente puntual, pero no escala para monitoreo continuo — nadie va a estar re-ejecutando la misma query cada hora para ver si apareció un nuevo caso.

Una **custom detection rule** (regla de detección personalizada) resuelve exactamente ese problema: toma una query de Advanced Hunting que tú ya preparaste y validaste, y la convierte en una regla que **corre sola, a intervalos fijos, genera una alerta cuando encuentra coincidencias, y opcionalmente ejecuta una acción de respuesta automatizada** (aislar un dispositivo, poner en cuarentena un archivo, deshabilitar un usuario, mover un correo). Verificado hoy en Microsoft Learn (`custom-detection-rules`, ms.date 2-jul-2026, actualizado 11-ago-2026): es, en esencia, el mismo concepto que las **Scheduled analytics rules de Sentinel** que viste el Día 4, pero viviendo dentro del ecosistema de Advanced Hunting de Defender XDR en vez de Sentinel — y con una diferencia importante que rara vez se explica bien: **una custom detection rule puede combinar datos de Defender XDR y de Microsoft Sentinel en la misma query**, algo que una analytics rule clásica de Sentinel no hace al revés (no puede leer tablas nativas de Defender XDR que no estén ya ingeridas en el workspace).

### 3. Cómo se crea una custom detection rule, paso a paso

Hay dos puntos de entrada, verificados hoy en la misma fuente:

- **Desde Advanced Hunting**: preparas y corres tu query, y seleccionas **Create detection rule**. Ventaja: validas los resultados antes de convertirla en regla.
- **Desde la lista de Custom detection rules**: seleccionas **+ Create detection rule** directamente, y escribes o pegas la query en el asistente.

Cualquiera de los dos caminos sigue los mismos seis pasos:

**Paso 1 — Preparar la query.** No cualquier query sirve igual de bien. Para que la regla identifique correctamente el dispositivo, la cuenta o el buzón afectado, Microsoft Learn recomienda que la query devuelva columnas específicas:

- `Timestamp` o `TimeGenerated` — define la marca de tiempo de la alerta generada. Si no las proyectas, la alerta usa el lookback (ventana de tiempo hacia atrás que cubre la regla) de la detección en su lugar.
- Para tablas de **MDE**: `DeviceId` o `DeviceName` — sin esto, la alerta no queda etiquetada con el grupo de dispositivos correcto y la vista de árbol de procesos no se construye.
- Para el resto de tablas de Defender: `Timestamp` + `ReportId` juntos, del mismo evento — permite que Defender identifique el evento original que disparó la alerta.
- Para mapear automáticamente el activo afectado: una columna identificadora fuerte (`DeviceId`/`DeviceName` para dispositivo; `RecipientEmailAddress`/`SenderFromAddress`/`SenderObjectId` para buzón; `AccountObjectId`/`AccountSid`/`AccountUpn` para cuenta).

**Regla de límite dura, la trampa de examen de esta sección:** cada regla puede generar **como máximo 150 alertas por corrida**. Si tu query es demasiado amplia (por ejemplo, detecta actividad normal del día a día en vez de algo anómalo), hay que ajustarla antes de crear la regla, no después de que empiece a saturar el Action Center con ruido.

**Paso 2 — Crear la regla y los detalles de la alerta.** Nombre, frecuencia, lookback, título y descripción de la alerta (sin HTML ni Markdown, se sanitizan por seguridad), severidad, categoría, técnica y sub-técnica de MITRE ATT&CK (el framework de tácticas y técnicas de adversarios que ya usaste en el Día 4), y opcionalmente vincularla a un reporte de threat analytics existente.

**Paso 3 — Enriquecimiento de la alerta.** Puedes construir un título/descripción dinámicos usando el resultado de la query (por ejemplo: `El usuario {{AccountName}} inició sesión inesperadamente desde {{Location}}`, hasta 3 columnas por campo), agregar hasta 20 pares clave-valor de "custom details" que aparecen en el panel lateral de la alerta (límite combinado de 4 KB), y vincular entidades (dispositivo, cuenta, buzón como activos afectados; proceso, archivo, IP, app OAuth como evidencia relacionada) para que el motor de correlación agrupe bien las alertas en incidentes.

**Paso 4 — Especificar acciones.** Ver sección 5 de hoy, es la parte que más pregunta el examen.

**Paso 5 — Definir el alcance (scope).** Todos los dispositivos o grupos de dispositivos específicos — solo afecta a reglas que consultan datos de dispositivo, no a las que solo miran buzones o cuentas.

**Paso 6 — Revisar y activar.** La regla corre inmediatamente al guardarse, y luego según la frecuencia configurada.

**Permisos necesarios, verificado hoy (dato de "mapa" — el tipo de detalle que este curso ya midió como punto débil recurrente):**

| Dato objetivo de la regla | Permiso/rol necesario |
|---|---|
| Datos de Microsoft Defender (MDE, MDO, MDCA, MDI) | **Security settings (manage)** dentro del portal de Defender, o el rol de Entra **Security Administrator**, o **Security Operator** (este último solo alcanza si el RBAC de MDE está desactivado; si está activo, necesita además el permiso **Manage Security Settings** dentro de MDE) |
| Datos de Microsoft Sentinel | Rol de Azure **Microsoft Sentinel Contributor** o superior, asignado sobre el workspace, el resource group o la suscripción |
| Regla que combina datos de varios productos (ej. MDE + Sentinel) | Necesitas **todos** los roles aplicables de cada producto involucrado — el permiso no se "hereda" entre productos |

Un detalle de esquema fino: la tabla `IdentityLogonEvents` trae datos tanto de MDCA como de MDI, así que una regla que la consulte necesita permisos de **ambos** productos, no de uno solo — otro ejemplo del patrón "el nombre de la tabla no te dice de qué producto necesitas el rol".

### 4. Frecuencia y lookback: la tabla que más confunde en el examen

Verificado hoy contra la misma fuente. Al guardar una regla nueva, la primera corrida siempre cubre los últimos 30 días. Después, corre según la frecuencia elegida:

| Frecuencia | Lookback (si la query usa datos de Defender XDR) | ¿Aplica a datos 100% de Sentinel? |
|---|---|---|
| Cada 24 horas | 30 días | Lookback configurable hasta 30 días |
| Cada 12 horas | 48 horas | — |
| Cada 3 horas | 12 horas | Lookback limitado a menos de 48 horas |
| Cada hora | 4 horas | — |
| **Continuous (NRT)** | Corre en near real-time (NRT — near real-time), evaluando eventos casi al momento de ingerirse | Tablas soportadas listadas abajo |
| **Custom** | — | **Solo disponible si la regla usa exclusivamente datos ingeridos en Microsoft Sentinel** — frecuencia configurable de 5 minutos a 14 días |

**Requisitos para que una query sea elegible a Continuous (NRT), el detalle que más se pregunta:**

- Referencia **una sola tabla** (nada de `join` ni `union`).
- Usa solo operadores de la lista de KQL soportada para transformaciones — no todos los operadores de KQL funcionan aquí.
- No tiene comentarios (`//`) dentro de la query.

Si tu query hace `union` entre `SigninLogs` y `AADNonInteractiveUserSignInLogs` (como el Ejemplo 1 del Día 13), **no puede correr en Continuous (NRT)** aunque ambas tablas individualmente sí lo soporten — el límite es sobre la query completa, no sobre las tablas por separado.

**Tablas que sí soportan Continuous (NRT), verificado hoy (lista parcial, las relevantes para este curso):** de Defender XDR — `AlertEvidence`, `DeviceEvents`, `DeviceProcessEvents`, `DeviceNetworkEvents`, `DeviceFileEvents`, `DeviceLogonEvents`, `EmailEvents`, `EmailPostDeliveryEvents`, `IdentityLogonEvents`, `IdentityDirectoryEvents`; de Microsoft Sentinel — `AzureActivity`, `CommonSecurityLog`, `MicrosoftGraphActivityLogs`, `SecurityAlert`, `SecurityEvent`, `SigninLogs`.

**Dato de esquema que conecta con lo aprendido hoy en la sección 1:** `ThreatIntelIndicators`, `ThreatIntelObjects`, `GraphApiAuditEvents` y `CloudAuditEvents` **no están en la lista de tablas compatibles con Continuous (NRT)** — si el examen pregunta por una detección casi en tiempo real sobre indicadores de threat intelligence, la respuesta correcta nunca es NRT sobre esas tablas, es una frecuencia fija corta (cada hora) o el flujo de TI Map de Sentinel visto el Día 4.

### 5. Acciones automatizadas: qué se puede tomar y qué columna lo habilita

Verificado hoy, misma fuente. Cada tipo de acción exige que la query devuelva una columna específica — si falta, la acción no aparece disponible en el asistente:

| Acción | Sobre qué actúa | Columna requerida en la query |
|---|---|---|
| **Isolate device** | Aísla el dispositivo de la red por completo (mismo concepto del Día 9) | `DeviceId` |
| **Collect investigation package** | Recolecta información del dispositivo en un ZIP (mismo concepto del Día 9) | `DeviceId` |
| **Run antivirus scan** | Escaneo completo de Microsoft Defender Antivirus | `DeviceId` |
| **Initiate investigation** | Dispara una investigación automatizada (AIR) sobre el dispositivo | `DeviceId` |
| **Restrict app execution** | Solo permite ejecutar binarios firmados por Microsoft (mismo concepto del Día 9) | `DeviceId` |
| **Allow/Block file** | Bloquea el archivo en todos los dispositivos (requiere permiso Remediate sobre archivos) | Hash `SHA1` o `SHA256` |
| **Quarantine file** | Elimina el archivo de su ubicación y deja una copia en cuarentena | `SHA1`/`InitiatingProcessSHA1`/`SHA256`/`InitiatingProcessSHA256` |
| **Mark user as compromised** | Sube el risk level del usuario a "High" en Entra ID (conecta con el Día 11) | `AccountObjectId`/`InitiatingProcessAccountObjectId`/`RecipientObjectId` |
| **Disable user** / **Reset user authentication** | Bloquea el inicio de sesión o fuerza re-autenticación | `AccountSid`/`InitiatingProcessAccountSid` (identidades Entra: `AccountObjectId`) |
| **Move to mailbox folder** / **Delete email** | Mueve o elimina el correo (soft o hard delete) | `NetworkMessageId` **y** `RecipientEmailAddress` |

**Trampa de examen fijada aquí:** si el enunciado describe una query que agrupa resultados con `summarize` por `AccountObjectId` pero nunca proyecta `DeviceId`, la acción **Isolate device** no puede configurarse sobre esa regla, sin importar que el escenario "suene" a que hace falta aislar algo. La disponibilidad de cada acción depende únicamente de qué columnas devuelve la query, no de la intención del analista.

### 6. Hunting graph y Microsoft Sentinel graph: visualizar relaciones en vez de leer filas

Hasta ahora, toda investigación que hiciste fue **tabular**: filas y columnas, un `join` aquí, un `summarize` allá. Eso funciona bien para preguntas puntuales, pero se vuelve lento y propenso a errores cuando la pregunta real es sobre **relaciones**: "si comprometen esta cuenta, ¿qué activos críticos puede alcanzar?", "¿qué camino conecta a este usuario con el grupo de Domain Admins?". Verificado hoy en Microsoft Learn, aquí es donde entra el **hunting graph**.

**Primero, la jerarquía de nombres, porque el plan de estudio los menciona casi como sinónimos y no lo son del todo:**

- **Microsoft Sentinel graph** (`sentinel-graph-overview`, ms.date 7-ago-2026) es la **capacidad de analítica de grafos subyacente** — la plataforma que representa datos de seguridad como nodos (entidades: usuarios, dispositivos, recursos) y aristas (relaciones entre ellas) en vez de tablas. No es una pantalla única; es el motor que **alimenta varias experiencias embebidas** distintas en Defender y en Purview.
- El **hunting graph** (`advanced-hunting-graph`, ms.date 4-may-2026) es **una de esas experiencias**: la que vive dentro de la página de **Advanced Hunting** en el portal de Defender XDR, pensada específicamente para threat hunting.
- Otras experiencias que corren sobre el mismo motor de Sentinel graph, para que no las confundas entre sí: el **Incident graph con Blast Radius** (dentro de la página de un incidente concreto, evalúa el "radio de impacto" — qué activos críticos podría alcanzar el atacante desde el punto ya comprometido), y los **Data risk graphs de Purview** (dentro de Insider Risk Management y Data Security Investigations, fuera del alcance de este curso).
- Existen también los **custom graphs** (en preview): en vez de usar los grafos ya construidos por Microsoft, tú modelas tus propias relaciones con datos del Sentinel data lake (el mismo data lake del Día 17) y hasta de fuentes de terceros, usando **GQL** (Graph Query Language, el lenguaje de consulta para grafos, distinto de KQL) desde un notebook de Visual Studio Code con la extensión de Sentinel.

**Requisitos de acceso al hunting graph, verificado hoy:** además del rol correspondiente en Entra ID para Advanced Hunting, necesitas tener habilitado el **Microsoft Sentinel data lake** y acceso de **al menos solo lectura a Microsoft Security Exposure Management (MSEM)** — la plataforma de gestión de superficie de exposición y postura de seguridad de Microsoft. Si tu tenant ya tiene el Sentinel data lake activo, el hunting graph y el blast radius del incident graph se aprovisionan automáticamente al iniciar sesión en el portal de Defender — no hace falta un paso de activación aparte.

**Dónde se encuentra:** dentro de **Investigation & response → Hunting → Advanced hunting** en el portal de Defender, seleccionando el ícono de hunting graph o **Create new → Hunting graph**.

**Los dos modos de trabajo dentro del hunting graph:**

1. **Escenarios predefinidos** (predefined scenarios): consultas de grafo ya construidas por Microsoft para preguntas comunes de investigación, con inputs específicos según el escenario. Los más relevantes para el examen, con el input que piden y la técnica MITRE ATT&CK asociada:

| Escenario | Qué responde | Input requerido |
|---|---|---|
| **Attack paths to critical asset** | Rutas potenciales de movimiento lateral hacia un activo crítico específico | El activo crítico objetivo |
| **Entity relationship map** | Conexiones directas (entrantes y salientes) de una entidad dada | La entidad de origen |
| **Paths between two entities** | Si existe una ruta entre dos entidades concretas | Dos entidades (origen y destino) |
| **Access to key vaults** | Qué entidades tienen acceso directo o indirecto a un key vault (almacén de secretos de Azure) concreto | El key vault objetivo |
| **Potential data exfiltration by device** | A qué storage accounts tiene acceso un dispositivo concreto | El dispositivo de origen |
| **Paths to domain admins** | Rutas desde usuarios sin privilegios hasta el grupo Domain Admins | Ninguno (corre sobre todo el entorno) |
| **Kerberoast paths to critical assets** | Cuentas vulnerables a Kerberoasting (técnica ya vista el Día 11) con ruta hacia activos sensibles | Ninguno |

2. **Filtros avanzados**: puedes refinar el grafo generado por nodo (crítico, vulnerable, expuesto a internet), por arista (tipo de relación: "has permissions to", "can authenticate as", "member of", entre otros) y por dirección de la relación (entrante, saliente, ambas).

**Por qué esto le importa al examen de un analista, no solo a un arquitecto:** las preguntas de threat hunting del Dominio 3 no piden que escribas la query de grafo desde cero — piden que reconozcas **cuándo una pregunta de investigación es mejor resuelta con un grafo que con una tabla**. Si el enunciado pregunta por "el camino más corto/las rutas posibles entre A y B" o "el radio de impacto desde un punto comprometido", la respuesta correcta casi nunca es "escribe una query KQL con múltiples joins" — es usar el hunting graph o el blast radius del incident graph, que existen exactamente para evitar ese tipo de query compleja y propensa a errores.

### 7. Tabla de decisión: el enunciado dice X → la respuesta/herramienta es Y

| El enunciado dice (calificador) | Herramienta / respuesta correcta | Por qué NO las demás |
|---|---|---|
| "Automatizar una query de Advanced Hunting para que corra sola y tome acción cuando encuentre coincidencias" | **Custom detection rule** | Una query manual de Advanced Hunting no corre sola ni toma acciones — necesita convertirse en regla |
| "La detección debe correr prácticamente al momento en que ocurre el evento, con mínima demora, y la query solo toca una tabla sin joins" | Frecuencia **Continuous (NRT)** | Las frecuencias fijas (24h/12h/3h/1h) siempre tienen un lookback de horas, nunca son "al momento" |
| "La query hace `union` de dos tablas de sign-in para correlacionar sesiones" | Frecuencia fija (**cada hora** o más frecuente si el volumen lo permite) o **Custom** si es 100% datos de Sentinel | Continuous (NRT) exige una sola tabla sin `join` ni `union` — esta query queda descalificada aunque las tablas individuales sí lo soporten |
| "Los datos de la regla vienen exclusivamente de tablas ya ingeridas en Microsoft Sentinel, y necesito correrla cada 6 horas exactas" | Frecuencia **Custom** (5 min–14 días) | **Every 12 hours** o **Every 3 hours** son las opciones fijas más cercanas, pero no permiten "cada 6 horas" exacto — solo Custom lo permite, y solo si es 100% datos de Sentinel |
| "Quiero que la regla aísle automáticamente los dispositivos que identifique" | Acción **Isolate device**, requiere columna `DeviceId` en el resultado | Si la query no proyecta `DeviceId` (por ejemplo, agrupó solo por `AccountObjectId`), la acción no está disponible aunque el escenario la necesite |
| "Quiero eliminar automáticamente el correo malicioso detectado por la regla" | Acción **Delete email**, requiere `NetworkMessageId` y `RecipientEmailAddress` | `Move to mailbox folder` también actúa sobre correo, pero mueve en vez de eliminar — dos acciones distintas para el mismo tipo de dato |
| "Encontrar todas las rutas posibles desde un usuario comprometido hasta el grupo de Domain Admins" | **Hunting graph**, escenario **Paths to domain admins** | Escribir la query en KQL con joins múltiples es técnicamente posible pero es exactamente el trabajo lento y propenso a error que el hunting graph reemplaza |
| "Dentro de la página de un incidente activo, ver qué activo crítico podría comprometerse a continuación desde el punto ya vulnerado" | **Incident graph con Blast Radius** | El hunting graph vive en la página de Advanced Hunting, una pantalla distinta — el blast radius es la experiencia embebida específicamente dentro del incidente |
| "Modelar relaciones propias de mi organización usando datos del Sentinel data lake y de una fuente de terceros" | **Custom graphs** (preview), vía GQL desde VS Code | Los escenarios predefinidos del hunting graph son fijos, diseñados por Microsoft — no aceptan un modelo de datos propio |
| "Configurar permisos para gestionar custom detections que combinan una tabla de MDE y una tabla de Sentinel" | Roles aplicables de **ambos** productos (ej. Security Administrator/Security settings manage + Microsoft Sentinel Contributor) | Tener solo el rol de uno de los dos productos no alcanza — el permiso no se hereda entre ellos |

---

## 💡 Ejemplos concretos

### Ejemplo 1 — Crear una custom detection rule elegible para Continuous (NRT)

**Escenario:** El SOC (Security Operations Center) quiere una alerta automática cuando un mismo dispositivo acumule más de 5 detecciones de antivirus en el último día, con la menor demora posible.

**Razonamiento:** la query debe referenciar una sola tabla, sin `join` ni `union`, y devolver `Timestamp`/`ReportId` además de un identificador de dispositivo para que la alerta se etiquete bien y sea elegible a Continuous (NRT). Usar `summarize` con `arg_max` permite agregar y seguir devolviendo el timestamp más reciente del evento que disparó la coincidencia:

```kql
// Elegible para Continuous (NRT): una sola tabla, sin joins/unions, sin comentarios en la query real
DeviceEvents
| where ingestion_time() > ago(1d)
| where ActionType == "AntivirusDetection"
| summarize (Timestamp, ReportId) = arg_max(Timestamp, ReportId), count() by DeviceId
| where count_ > 5
```

Al crear la regla desde esta query, el asistente detecta automáticamente `DeviceId` como columna de mapeo de activo afectado (dispositivo), y las acciones de dispositivo (Isolate device, Run antivirus scan, etc.) quedan disponibles porque `DeviceId` está presente. Si el analista hubiera usado `union DeviceEvents, DeviceProcessEvents` para ampliar la cobertura, la regla seguiría siendo válida como detección, pero **dejaría de ser elegible para Continuous (NRT)** — tendría que correr con una frecuencia fija en su lugar.

### Ejemplo 2 — Elegir la frecuencia correcta según el origen de los datos

**Escenario:** Un analista necesita dos reglas distintas: (a) una que dispare cuando `DeviceProcessEvents` (tabla de MDE) muestre un patrón de ejecución sospechoso, revisada cada 3 horas; (b) otra que dispare sobre `AzureActivity` (tabla ingerida solo en Sentinel) exactamente cada 90 minutos.

**Razonamiento:** para (a), `DeviceProcessEvents` es una tabla de Defender XDR, así que la frecuencia "Every 3 hours" trae un lookback fijo de 12 horas — no es configurable, y no hace falta que lo sea porque el escenario no pide un intervalo exacto no estándar. Para (b), "cada 90 minutos" no es ninguna de las frecuencias fijas (24h/12h/3h/1h) ni tampoco corresponde a Continuous (NRT, que corre en NRT — near real-time, no a un intervalo fijo elegido) — como `AzureActivity` es una tabla ingerida exclusivamente en Microsoft Sentinel, la única opción que permite un intervalo arbitrario como 90 minutos es la frecuencia **Custom**, con el lookback calculado automáticamente según la frecuencia elegida (para corridas más frecuentes que diarias, el lookback es 4 veces la frecuencia — en este caso, 6 horas).

### Ejemplo 3 — Usar el hunting graph para investigar movimiento lateral hacia un key vault

**Escenario:** Durante la investigación de un incidente de Contoso, el equipo sospecha que una cuenta de servicio comprometida podría tener una ruta de acceso, directa o indirecta, hacia un Azure Key Vault (almacén de secretos de Azure) que guarda las credenciales de producción.

**Razonamiento:** escribir esta pregunta como query KQL requeriría encadenar varios `join` entre tablas de identidad, de permisos de Azure Resource Manager y de configuración de Key Vault — lento, propenso a error, y exactamente el tipo de pregunta relacional para la que existe el hunting graph. El analista, en la página de Advanced Hunting, abre el hunting graph, selecciona el escenario predefinido **Access to key vaults**, ingresa el key vault objetivo como input, y renderiza el grafo. El resultado muestra visualmente todos los nodos (dispositivos, cuentas, roles) con una arista de tipo "has permissions to" o "can authenticate as" hacia el key vault — incluidas rutas indirectas de varios saltos que una query manual fácilmente pasaría por alto. Si el analista necesitara, además, saber qué otros activos críticos quedan expuestos si esa misma cuenta de servicio se compromete del todo (no solo el key vault), usaría el escenario **Entity relationship map** con la cuenta como entidad de origen — dos escenarios distintos para dos preguntas relacionadas pero no idénticas.

---

## 🎥 Videos

1. **[Microsoft Sentinel graph demo | Accelerate incident response with unified security insights](https://www.youtube.com/watch?v=HdeCiMh97g0)** — video oficial vinculado desde el blog de anuncio de Microsoft Sentinel graph en Microsoft Community Hub, publicado el 2-oct-2025. Es una demo corta enfocada en blast radius del incident graph y el hunting graph en acción — cubre exactamente la sección 6 de hoy. No pude confirmar la duración exacta desde la búsqueda (las demos de este tipo en el blog de Sentinel suelen rondar los 5-10 min); si al abrirlo resulta muy distinta de eso, avísame para corregir el dato.
2. Sobre custom detection rules específicamente: **búsqueda verificada hoy sin resultado de un video reciente (2026) dedicado**, ni de Exam Readiness Zone ni de un canal reconocido — la mayoría del contenido en video sobre este tema en YouTube es de 2025 o anterior y no refleja los cambios de frecuencia/lookback confirmados hoy contra la documentación (actualizada 11-ago-2026). En su lugar, usa el módulo oficial de Microsoft Learn **[Create custom detection rules in Microsoft Defender XDR](https://learn.microsoft.com/en-us/defender-xdr/custom-detection-rules)** — es la misma fuente que usé para escribir las secciones 2-5 de hoy, así que ya la tienes verificada de primera mano.

> [!note] Honestidad sobre la búsqueda de video de hoy
> Igual que en el Día 13, prefiero decir con claridad que no encontré un video reciente y específico para la mitad de la lección de hoy (custom detections) en vez de forzar un enlace de relleno que pudiera traer un dato ya desactualizado sobre frecuencias o límites — el área que más cambió recientemente según la propia documentación (actualizada hace apenas 3 semanas al momento de escribir esto).

---

## 🧪 Ejercicio práctico

> [!note] Este lab cabe en un bloque normal entre semana, con una parte que depende de qué tenga habilitado tu trial
> Advanced Hunting y las custom detection rules corren sobre tu **trial M365 E5** (`security.microsoft.com`), el mismo tenant de días anteriores — no hace falta esperar al sábado. El hunting graph, en cambio, **requiere el Microsoft Sentinel data lake habilitado y acceso de lectura a Microsoft Security Exposure Management** — si tu trial no tiene esas dos piezas activas (es razonable que no las tenga, son capacidades más nuevas), la parte 3 del lab queda documentada como paso teórico usando las capturas del artículo de Microsoft Learn.

- [ ] **Paso 1 — Repasar el drill de la sección 1.** Sin mirar la tabla de referencia, responde en voz alta o por escrito los 12 escenarios. Marca cuáles fallaste y vuelve a leer solo esas filas.
- [ ] **Paso 2 — Preparar y validar una query candidata a custom detection.** En Advanced Hunting, corre una versión adaptada de la query del Ejemplo 1 (`DeviceEvents` con `AntivirusDetection`, o cualquier tabla equivalente disponible en tu trial) y confirma que devuelve `DeviceId`, `Timestamp` y `ReportId`.
- [ ] **Paso 3 — Crear la regla (sin activar acciones automáticas todavía).** Selecciona **Create detection rule**, completa nombre/severidad/categoría/técnica MITRE, y en el paso de frecuencia compara qué lookback te ofrece el asistente según cada opción — confirma en pantalla los números de la tabla de la sección 4.
- [ ] **Paso 4 — Explorar las acciones disponibles.** Sin guardar la regla con una acción destructiva, revisa qué acciones aparecen habilitadas o deshabilitadas según las columnas que tu query devuelve — confirma en vivo la trampa de la sección 5 (sin `DeviceId`, no hay `Isolate device`).
- [ ] **Paso 5 (si tu trial tiene Sentinel data lake + MSEM) — Explorar el hunting graph.** Ve a Advanced hunting → ícono de hunting graph → Search with Predefined scenarios, y corre el escenario **Entity relationship map** sobre tu propia cuenta o un dispositivo de prueba, solo para ver el grafo renderizarse.
- [ ] **Paso 6 —** responde el quiz de hoy y el repaso acumulativo.

---

## ✅ Quiz del día

Cinco preguntas sobre el contenido nuevo de hoy. Responde antes de abrir el bloque de respuestas.

**1.** Un analista crea una custom detection rule usando datos de la tabla `DeviceProcessEvents` (Defender XDR) con frecuencia "Every 12 hours". ¿Cuál es el lookback period que aplica a esa regla?

- A) 4 horas
- B) 12 horas
- C) 48 horas
- D) 30 días

**2.** Una query de custom detection usa `union DeviceEvents, DeviceProcessEvents` para ampliar su cobertura. ¿Qué le impide a esta regla ser elegible para la frecuencia Continuous (NRT), sin importar qué tan simple sea el resto de la query?

- A) Que use la función `ingestion_time()`
- B) Que combine más de una tabla mediante `union`
- C) Que no tenga la palabra `where` en la consulta
- D) Que esté escrita desde la lista de Custom detection rules en vez de desde Advanced Hunting

**3.** Un analista quiere que una custom detection rule configure automáticamente la acción "Isolate device" sobre los dispositivos que identifique. ¿Qué columna debe devolver la query para que esa acción esté disponible?

- A) `ReportId`
- B) `DeviceId`
- C) `AccountObjectId`
- D) `NetworkMessageId`

**4.** Un tenant tiene el Microsoft Sentinel data lake habilitado y acceso de lectura a Microsoft Security Exposure Management. Un analista abre Advanced Hunting y quiere usar el hunting graph para investigar rutas de acceso hacia un recurso sensible. ¿Qué necesita hacer antes de poder usarlo?

- A) Configurar manualmente un conector adicional de AWS o GCP
- B) Nada adicional — con esos dos requisitos ya cumplidos, el hunting graph se aprovisiona automáticamente al iniciar sesión
- C) Adquirir una licencia separada de Microsoft Purview
- D) Escribir primero la query en GQL desde Visual Studio Code

**5.** Durante la investigación de un incidente activo, un analista quiere ver, dentro de la propia página del incidente, qué activo crítico podría verse comprometido a continuación a partir del recurso ya vulnerado. ¿Qué capacidad usa?

- A) Custom graphs (preview) vía GQL
- B) Hunting graph, escenario "Entity relationship map"
- C) Incident graph con Blast Radius
- D) Query assistant (NL→KQL) de Copilot

> [!note]- Ver respuestas
> **1 — C.** Para datos de Defender XDR con frecuencia "Every 12 hours", el lookback fijo es 48 horas. **A** (4 horas) corresponde a la frecuencia "Every hour". **B** (12 horas) corresponde a "Every 3 hours". **D** (30 días) corresponde a "Every 24 hours" — cada frecuencia tiene su propio lookback fijo, no son intercambiables.
>
> **2 — B.** El requisito de Continuous (NRT) es que la query referencie una sola tabla, sin `join` ni `union`, sin importar que las tablas individuales sí estén en la lista de tablas compatibles. **A** es al revés: las custom detections sí evalúan `ingestion_time()` internamente, eso no descalifica nada. **C** no es un requisito real — muchas queries válidas para NRT sí usan `where`. **D** es falso: el punto de entrada (desde Advanced Hunting o desde la lista de reglas) no afecta la elegibilidad de frecuencia, solo el flujo de creación.
>
> **3 — B.** `Isolate device` actúa sobre dispositivos identificados en la columna `DeviceId` de los resultados. **A** (`ReportId`) ayuda a identificar el evento original, no a mapear el dispositivo para acciones. **C** (`AccountObjectId`) es la columna para acciones sobre usuarios (Mark user as compromised), no dispositivos. **D** (`NetworkMessageId`) es para acciones sobre correo.
>
> **4 — B.** Verificado hoy en Microsoft Learn: si el Sentinel data lake ya está habilitado, el hunting graph y el blast radius del incident graph se aprovisionan automáticamente al iniciar sesión en el portal de Defender, sin paso de activación aparte. **A** no es un requisito del hunting graph en sí (los conectores AWS/GCP son para escenarios específicos de recursos en esas nubes, no un prerequisito general). **C** confunde el hunting graph con un producto de Purview. **D** describe el flujo de custom graphs (preview), un feature distinto y opcional, no un prerequisito del hunting graph con escenarios predefinidos.
>
> **5 — C.** El Incident graph con Blast Radius es la experiencia embebida específicamente dentro de la página del incidente, diseñada para evaluar el radio de impacto desde el punto ya comprometido. **A** y **B** son experiencias reales de Sentinel graph, pero viven en pantallas distintas (Advanced Hunting, no la página del incidente) y responden preguntas más generales de exploración, no específicamente "qué sigue desde este incidente". **D** es una capacidad de Copilot que traduce lenguaje natural a KQL, no una visualización de grafo.

---

## 🔁 Repaso acumulativo — re-test espaciado

Cuatro preguntas que re-testean puntos ya medidos en sesiones anteriores.

**R1.** Un analista consulta `SecurityAlert` en Sentinel filtrando por `ProductName == "Microsoft Defender for Cloud"` para encontrar las alertas generadas por los planes de Defender for Cloud, y obtiene cero resultados aunque sabe que hay alertas activas. ¿Cuál es la causa?

- A) Las alertas de Defender for Cloud no llegan nunca a `SecurityAlert`, solo a `SecurityIncident`
- B) El valor real de `ProductName` para esas alertas sigue siendo el nombre legado `"Azure Security Center"`
- C) Hace falta activar el conector Tenant-based antes de que existan alertas
- D) `ProductName` no es una columna válida de `SecurityAlert`

**R2.** Una búsqueda de eDiscovery sobre 15 meses de correo corporativo falla con el código de error CS007. ¿Qué acción resuelve el problema correctamente?

- A) Cambiar el rol del analista a eDiscovery Administrator
- B) Convertir la búsqueda en una regla de Advanced Hunting
- C) Dividir la búsqueda en rangos de fechas más pequeños
- D) Eliminar destinatarios duplicados con un cmdlet de PowerShell

**R3.** Durante una investigación de MDE, el analista necesita capturar memoria, procesos y conexiones de red de un dispositivo comprometido, minimizando el impacto al usuario y sin cortar la sesión de trabajo activa. ¿Qué acción usa?

- A) Live response con sesión interactiva
- B) Restrict app execution
- C) Isolate device
- D) Collect investigation package

**R4.** Un equipo de seguridad necesita ingerir indicadores de threat intelligence externos (feeds comerciales de IOCs) con el mínimo esfuerzo de configuración posible, evitando programar llamadas manuales a una API. ¿Qué opción usan?

- A) La Upload Indicators API, programada con un script propio
- B) La solución de Threat Intelligence + el conector Premium Defender TI (prearmado)
- C) Una tabla custom `_CL` alimentada por Logs Ingestion API
- D) El conector legacy "Threat Intelligence Platforms"

> [!note]- Ver respuestas
> **R1 — B.** Primer retest del hallazgo del Día 12: la columna `ProductName` de `SecurityAlert` sigue usando el valor legado `"Azure Security Center"` para las alertas de Defender for Cloud, sin importar el renombre comercial. **A** es falso — sí llegan a `SecurityAlert` como alertas individuales. **C** describe un paso real de la migración de conectores (Día 12), pero no es la causa de una query con cero resultados si el conector ya está activo. **D** es falso, la columna existe y es válida — el problema es el valor que contiene, no su existencia.
>
> **R2 — C.** Primer retest del hallazgo del Día 13: CS007 indica una búsqueda demasiado grande o compleja; la solución es dividirla en fragmentos más pequeños, típicamente por rango de fechas o número de ubicaciones. **A** es un cambio de permisos que no afecta el volumen de resultados. **B** mezcla dos productos distintos sin relación entre sí. **D** resuelve un error diferente (ambigüedad de destinatarios), no el de CS007.
>
> **R3 — D.** El bloque más débil de este curso, reforzado de nuevo: "minimizar impacto" + "sin cortar la sesión activa" descarta `Isolate device` (corta la red) y apunta a recolección forense pasiva. `Collect investigation package` recolecta memoria, procesos y red sin aislar el dispositivo ni requerir interacción en vivo. **A** (Live response) permite interactuar en vivo, pero el enunciado pide recolección pasiva, no análisis interactivo. **B** solo bloquea ejecución de apps, no recolecta evidencia forense completa. **C** corta la red del usuario, justo el impacto que el enunciado pide evitar.
>
> **R4 — B.** Tercer retest espaciado (primero en el Simulacro 01 del 23-jul, segundo en el Día 10, hoy con el tema de tablas de TI recién repasado en la sección 1): la solución de Threat Intelligence junto con el conector Premium Defender TI prearmado es la ruta de mínimo esfuerzo. **A** exige programar y mantener llamadas manuales a la API — es la ruta de mayor esfuerzo, no menor. **C** es la ruta correcta para una fuente sin conector ni esquema existente, no para feeds comerciales que sí tienen conector dedicado. **D** es un conector legado, no la vía recomendada actual.

---

## ⚠️ Trampas del examen en los temas de hoy

1. **150 alertas máximo por corrida de una custom detection rule.** Si una query es demasiado amplia, hay que ajustarla antes de crear la regla, no confiar en que el límite la "filtre" sola.
2. **Continuous (NRT) exige una sola tabla, sin `join`/`union`/`externaldata`, y sin comentarios en la query** — el límite es sobre la query completa, no sobre si las tablas individuales están en la lista de soportadas.
3. **El lookback de las frecuencias fijas (24h/12h/3h/1h) no es configurable si la regla usa datos de Defender XDR** — solo es configurable cuando la regla usa exclusivamente datos de Microsoft Sentinel.
4. **La frecuencia Custom (5 min–14 días) solo existe si la regla es 100% datos de Sentinel** — no es una opción general disponible siempre.
5. **Cada acción automatizada depende de una columna específica en el resultado de la query** — no de la intención del analista ni del tipo de escenario descrito en el enunciado.
6. **`IdentityLogonEvents` mezcla datos de MDCA y de MDI** — gestionar una custom detection sobre esa tabla exige permisos de ambos productos.
7. **Hunting graph ≠ Incident graph con Blast Radius ≠ Custom graphs** — los tres corren sobre el motor de Microsoft Sentinel graph, pero viven en pantallas distintas y responden preguntas de investigación distintas.
8. **El hunting graph requiere Sentinel data lake + acceso de lectura a Microsoft Security Exposure Management** — no viene habilitado por defecto en cualquier tenant con Defender XDR.
9. **`ThreatIntelIndicators`, `ThreatIntelObjects`, `GraphApiAuditEvents` y `CloudAuditEvents` no soportan Continuous (NRT)** — si el examen pide "casi en tiempo real" sobre esas tablas, la respuesta correcta es una frecuencia fija corta, no NRT.

---

## 🔗 Notas relacionadas

- [[Dia 01 - Arquitectura Sentinel y Tiers de Retencion]] — origen de `Watchlist`, reforzada hoy en el drill de la sección 1
- [[Dia 03 - Ingestion 2 Syslog CEF Azure Activity TI y Tablas Custom]] — origen de `ThreatIntelIndicators`/`ThreatIntelObjects` y `AzureActivity`, reforzados hoy
- [[Dia 04 - Detecciones Sentinel Analytics Rules y Anomalias]] — Scheduled analytics rules de Sentinel, el concepto hermano de las custom detection rules de hoy pero del lado de Sentinel
- [[Dia 05 - Configuracion Avanzada de MDE ASR Rules Advanced Features Device Groups y Custom Data Collection]] — origen de `DeviceEvents`/`DeviceCustomFileEvents`, reforzados hoy
- [[Dia 09 - Respuesta MDE Timeline Live Response y Evidencia]] — origen de Isolate device / Collect investigation package, reforzado hoy en R3 y conectado con las acciones automatizadas de la sección 5
- [[Dia 10 - MDO Threat Explorer ZAP y MDCA]] — origen de `EmailPostDeliveryEvents`, reforzado hoy
- [[Dia 12 - Defender for Cloud Workload Protections]] — origen de `CloudAuditEvents` y la trampa `ProductName == "Azure Security Center"`, retesteada hoy en R1
- [[Dia 13 - Purview Audit eDiscovery Graph Activity Logs y Copilot Embebido]] — origen de `GraphApiAuditEvents`/`MicrosoftGraphActivityLogs` y CS007, reforzados hoy
- [[PLAN_MAESTRO_MULTITRACK]] — calendario vigente §8, compresión Día 14→15 en §8.2, examen 3-oct-2026 fijo
- [[TRACKER_TUTOR]]

## 📚 Fuentes verificadas hoy (31-ago-2026)

- [Create custom detection rules in Microsoft Defender XDR](https://learn.microsoft.com/en-us/defender-xdr/custom-detection-rules) — ms.date 2-jul-2026, actualizado 11-ago-2026, fuente principal de las secciones 2-5 (flujo de creación, columnas requeridas, permisos, frecuencia/lookback, Continuous NRT, acciones automatizadas, límite de 150 alertas)
- [Hunting graph in Microsoft Defender advanced hunting](https://learn.microsoft.com/en-us/defender-xdr/advanced-hunting-graph) — ms.date 4-may-2026, actualizado 26-jun-2026, fuente principal de la sección 6 (requisitos de acceso, escenarios predefinidos, filtros)
- [What is Microsoft Sentinel graph?](https://learn.microsoft.com/en-us/azure/sentinel/datalake/sentinel-graph-overview) — ms.date 7-ago-2026, actualizado 7-ago-2026, fuente de la jerarquía de nombres de la sección 6 (Sentinel graph como motor, hunting graph/incident graph/data risk graphs como experiencias embebidas, custom graphs en preview)
- Búsqueda verificada: el hunting graph alcanzó disponibilidad general en diciembre de 2025, con escenarios adicionales enfocados en identidad añadidos en mayo de 2026 — contexto de por qué es un feature demasiado reciente para tener todavía cobertura amplia en video de terceros
- [Microsoft Sentinel graph demo | Accelerate incident response with unified security insights](https://www.youtube.com/watch?v=HdeCiMh97g0) — publicado 2-oct-2025, video oficial vinculado desde el anuncio de Microsoft Sentinel graph en Microsoft Community Hub

---

> [!tip] Orden de consumo de hoy (fijado el 24-ago, ver [[PLAN_MAESTRO_MULTITRACK]] §7.7)
> 🎧 Escucha primero el Audio Overview de esta lección en NotebookLM → 📖 luego lee esta nota completa, con foco en la sección 1 (drill de tablas) y la sección 7 (tabla de decisión) → ✅ y cierra con el quiz. Escuchar no sustituye leer, y leer no sustituye el quiz — el día se cierra con el quiz respondido, no antes.
