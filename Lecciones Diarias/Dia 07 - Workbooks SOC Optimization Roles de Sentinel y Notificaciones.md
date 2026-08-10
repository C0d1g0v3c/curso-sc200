---
tags: [sc-200, workbooks, soc-optimization, rbac, roles-sentinel, email-notifications, alert-tuning, sentinel, defender-xdr, leccion-diaria]
dia: 7
fecha: 2026-07-29
dominio: "Dominio 1 — Manage a security operations environment (40-45%)"
estado: 🟡 En curso
cover: ""
---

# Lección Día 7 — Workbooks, SOC optimization, roles de Sentinel, notificaciones y alert tuning

> [!info] Contexto
> Día 7 del plan de [[GUIA_INTENSIVA_24_DIAS]] y **cierre de la Fase 1** (Dominio 1 — Manage a security operations environment, 40–45% del examen, el bloque que más pesa). Con esta lección terminas de cubrir todos los objetivos del Dominio 1 del temario oficial.
>
> ⚠️ **El temario oficial cambió ayer (28 de julio de 2026)** y hoy verifiqué el skills outline nuevo directamente en Microsoft Learn. La buena noticia: el cambio no invalida nada de lo que ya estudiaste. La noticia accionable: aparecen **dos objetivos del Dominio 1 que `GUIA_INTENSIVA_24_DIAS.md` no tenía asignados a ningún día** — "Specify Microsoft Sentinel roles" y "Configure alert notifications in Microsoft Defender XDR, including tuning, suppression, and correlation". Los dos son huecos reales, así que los incorporo hoy en esta lección junto a los temas que ya tocaban. El detalle completo del cambio de temario está en la sección §7 al final.

---

## 📖 Lectura del día

### 0. Punto de partida: qué es "el Dominio 1" y qué falta para cerrarlo

El examen SC-200 se divide en tres **dominios funcionales** (grupos temáticos con un peso porcentual asignado). El Dominio 1 se llama *Manage a security operations environment* — "administrar un entorno de operaciones de seguridad" — y vale entre el 40 % y el 45 % de las preguntas. Es el dominio de **construir y configurar** el entorno: conectar datos, crear detecciones, automatizar respuestas y ajustar la plataforma. (Los otros dos, que verás en las Fases 2 y 3, son *responder a incidentes* y *hacer threat hunting*.)

Según el temario vigente, el Dominio 1 tiene cuatro sub-bloques. Esto es lo que ya cubriste y lo que falta:

| Sub-bloque del temario                             | Estado                                                                                                                                                                                                               |
| -------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Configure automation for Defender XDR and Sentinel | Cubierto en los Días 5 y 6 (ASR, advanced features, device groups, automation levels, AIR, attack disruption, automation rules, playbooks) — **salvo email notifications y alert notifications/tuning, que van hoy** |
| Configure the Microsoft Sentinel SIEM and platform | Retención y tiers, Día 1. **Workbooks, SOC optimization y roles de Sentinel van hoy**                                                                                                                                |
| Ingest data into the Sentinel SIEM and platform    | Cubierto en los Días 2 y 3                                                                                                                                                                                           |
| Configure detections                               | Cubierto en el Día 4                                                                                                                                                                                                 |

Así que hoy tocan cinco temas, y con ellos el Dominio 1 queda completo.

---

### 1. Workbooks de Microsoft Sentinel

#### 1.1 Qué es un workbook, desde cero

Un **workbook** (literalmente "libro de trabajo") es un **informe visual interactivo**: una página compuesta por bloques de texto, gráficas, tablas y filtros, donde cada gráfica se alimenta de una consulta que se ejecuta contra tus datos en el momento en que abres la página. No es un archivo estático tipo captura de pantalla; cada vez que lo abres o lo refrescas, las consultas se vuelven a ejecutar y los números se actualizan.

Para entender qué son, conviene tener claros dos conceptos previos:

- **Log Analytics workspace** (espacio de trabajo de Log Analytics): el almacén donde Microsoft Sentinel guarda los datos que ingiere, organizado en **tablas** (por ejemplo `SecurityEvent`, `SigninLogs`, `AzureActivity`). Ya lo trabajaste desde el Día 1.
- **KQL (Kusto Query Language)**: el lenguaje de consulta con el que se leen esas tablas. Un workbook, por debajo, no es más que un conjunto de consultas KQL con instrucciones de cómo dibujar cada resultado.

Los workbooks de Microsoft Sentinel **están construidos sobre los Azure Monitor workbooks** — es decir, Sentinel no inventó un motor de reportes propio, sino que reutiliza el de Azure Monitor (el servicio general de monitoreo de Azure) y le añade tablas, gráficas y analítica específicas de seguridad. Por eso muchas opciones que verás dentro del editor son genéricas de Azure y no exclusivamente de seguridad.

**Un dato que el examen usa mucho:** cada workbook es **un recurso de Azure más**, como una máquina virtual o una cuenta de almacenamiento. Eso tiene dos consecuencias directas: (a) se le puede aplicar **Azure RBAC** para controlar quién lo ve y quién lo edita, y (b) vive dentro de un **resource group** (grupo de recursos: el contenedor lógico de Azure donde se agrupan recursos relacionados).

#### 1.2 Dónde se guardan y qué se guarda exactamente

Los workbooks que ves dentro de Microsoft Sentinel se guardan **en el resource group del workspace de Sentinel**, y quedan etiquetados (*tagged*) con el workspace en el que se crearon. Eso es lo que hace que aparezcan en la vista de Sentinel y no mezclados con el resto de reportes de Azure Monitor de la suscripción.

**Lo que se guarda es únicamente el archivo JSON del workbook — la definición: qué consultas corre, qué gráficas dibuja, qué filtros ofrece. No se guarda ningún dato.** Los datos siguen viviendo en las tablas del workspace y se leen en el momento de abrir el workbook. Esta es una pregunta clásica de examen: "¿guardar un workbook duplica los datos / consume almacenamiento de ingesta?" — no, solo guarda la definición.

#### 1.3 Permisos necesarios (dato de examen)

| Qué quieres hacer | Qué necesitas |
|---|---|
| Ver / usar workbooks | **Workbook Reader** sobre el resource group del workspace de Sentinel (como mínimo) |
| Editar workbooks | **Workbook Contributor** sobre el resource group |
| Crear o eliminar workbooks | **Microsoft Sentinel Contributor** (o un rol de Sentinel menor) **Y ADEMÁS Workbook Contributor** |
| Usar una plantilla de workbook | Tener instalada la solución que la contiene, o instalar el workbook como elemento suelto desde el **Content hub** |

Fíjate en la fila de "crear o eliminar": hace falta **la combinación de dos roles**. Tener solo Microsoft Sentinel Contributor no basta para crear un workbook — y esto es exactamente el tipo de matiz de mínimo privilegio que el examen convierte en pregunta. Volvemos sobre ello en §3.

#### 1.4 Crear un workbook desde una plantilla

Una **plantilla** (*template*) es un workbook prefabricado por Microsoft o por un proveedor, que ya trae las consultas y gráficas armadas para un escenario concreto (por ejemplo, "inicios de sesión de Microsoft Entra ID" o "tráfico de firewall Palo Alto"). Las plantillas llegan a tu entorno instalando soluciones desde el **Content hub** (el catálogo de contenido listo para usar de Sentinel).

El flujo es:

1. En Microsoft Sentinel, ir a **Threat management > Workbooks**.
2. Pestaña **Templates**: se listan las plantillas instaladas. Al seleccionar una, se abre su panel de detalles.
3. **Revisar el campo `Required data types`** antes de guardar. Una plantilla puede requerir datos que tú no estás ingiriendo; si no tienes esa tabla, el workbook se abrirá vacío. Este campo te dice qué tipos de datos necesita.
4. **Save** → eliges la ubicación (suscripción y resource group). Esto crea el recurso de Azure a partir de la plantilla. Recuerda: solo se guarda el JSON.
5. **View saved workbook** para abrirlo, y **Edit** para personalizarlo.
6. **Done Editing** para guardar los cambios.

Dos detalles importantes de este flujo:

- **`Save as` clona el workbook.** Guardas una copia con otro nombre, bajo la misma suscripción y resource group. Los clones aparecen en la pestaña **My workbooks**.
- **Las plantillas no se pueden eliminar; los workbooks guardados sí.** Puedes borrar tanto las plantillas guardadas (es decir, la instancia que creaste a partir de una plantilla) como los workbooks personalizados, desde la pestaña **My workbooks**. Borrar es **permanente y no se puede deshacer**: se pierde el recurso y todas tus personalizaciones. La plantilla original, en cambio, sigue disponible.

#### 1.5 Crear un workbook desde cero

1. **Threat management > Workbooks > Add workbook**.
2. **Edit**, y añadir texto, consultas y **parámetros** según haga falta.
3. Al construir una consulta: **Data source = Logs**, **Resource type = Log Analytics**, y elegir uno o más workspaces.
4. **Done editing** → **Save**, poniendo un nombre significativo y eligiendo suscripción y resource group.

Un **parámetro** es un control interactivo (un desplegable, un selector de rango de tiempo, una caja de texto) cuyo valor se inyecta dentro de las consultas del workbook. El ejemplo más común es el filtro **TimeRange**: cambias el rango y todas las gráficas se recalculan para ese periodo. Los parámetros son lo que convierte un reporte estático en una herramienta interactiva.

> [!tip] Recomendación oficial que aparece en la documentación
> Al escribir la consulta de un workbook, Microsoft recomienda **usar un parser ASIM en lugar de una tabla nativa**. **ASIM (Advanced Security Information Model)** es un modelo de normalización: un conjunto de "traductores" (parsers) que presentan datos de fuentes distintas — varios fabricantes de firewall, por ejemplo — bajo un mismo esquema de columnas con nombres unificados. La ventaja: si mañana cambias de proveedor de firewall o añades uno nuevo, el workbook sigue funcionando sin reescribir la consulta, porque consulta el esquema normalizado y no la tabla específica de un producto.

#### 1.6 Refresco de datos

En la barra de herramientas del workbook tienes dos opciones:

- **Refresh**: refresco manual, ahora mismo.
- **Auto refresh**: refresco automático a intervalos configurables, **de 5 minutos a 1 día**.

Reglas del auto refresh que conviene memorizar:
- Viene **desactivado por defecto**.
- Se **pausa mientras editas** el workbook, y el intervalo se reinicia cada vez que vuelves de modo edición a modo vista.
- El intervalo también se reinicia si refrescas manualmente.
- **Se vuelve a desactivar cada vez que cierras el workbook**, para no dejarlo corriendo en segundo plano consumiendo recursos. Hay que reactivarlo la siguiente vez que lo abras.

#### 1.7 Workbooks en el portal de Defender vs el portal de Azure

Microsoft está unificando todo en el **portal de Microsoft Defender** (`security.microsoft.com`), y **después del 31 de marzo de 2027 Microsoft Sentinel dejará de estar disponible en el portal de Azure**. Mientras tanto conviven los dos, con estas diferencias en workbooks:

- Algunas **visualizaciones solo se pueden ver en el portal de Azure**. Cuando trabajas desde el portal de Defender y te topas con una, aparece la opción **Open in Azure**.
- **Imprimir un workbook o guardarlo como PDF solo existe en el portal de Azure** (menú de opciones a la derecha del título → **Print content** → ajustar o **Save as PDF**). Desde Defender hay que hacer *Open in Azure* primero.
- Si trabajas en el portal de Defender con un origen de datos **Azure Data Explorer**, hay que configurarlo y autenticarse contra él desde el portal de Defender.

#### 1.8 Tiles (mosaicos) personalizados

Un **tile** es un bloque visual individual dentro del workbook. Para añadir uno personalizado, el flujo no empieza en el workbook sino en **Log Analytics**: creas ahí la visualización y luego seleccionas **Pin** (anclar) eligiendo el workbook de destino.

#### 1.9 Recomendaciones de diseño de la documentación

- **Instala la solución de Microsoft Entra** si usas Microsoft Entra ID con Sentinel, y usa sus dos workbooks estrella: **Microsoft Entra sign-ins** (analiza inicios de sesión en el tiempo; fallos por aplicación, dispositivo y ubicación — atención a los inicios de sesión fallidos repetidos) y **Microsoft Entra audit logs** (actividad administrativa: altas y bajas de usuarios, creación y modificación de grupos).
- **Instala la solución del firewall que uses** desde el Content hub para tener sus workbooks.
- **Crea workbooks distintos por persona y por frecuencia**: uno para el administrador de red con los datos de firewall, otro para lo que revisas a diario, otro para lo que miras cada hora.

#### 1.10 Dos consultas de ejemplo de la documentación

Comparar el volumen de eventos de esta semana contra la anterior (útil para detectar caídas de ingesta o picos anómalos):

```kusto
// week over week query
SecurityEvent
| where TimeGenerated > ago(14d)
| summarize count() by bin(TimeGenerated, 1d)
| extend Week = iff(TimeGenerated>ago(7d), "This Week", "Last Week"), TimeGenerated = iff(TimeGenerated>ago(7d), TimeGenerated, TimeGenerated + 7d)
```

Cruzar dos fuentes: usuarios recién creados en Microsoft Entra ID que hicieron cambios de asignación de roles en Azure poco después (patrón clásico de escalada de privilegios):

```kusto
AuditLogs
| where OperationName == "Add user"
| project AddedTime = TimeGenerated, user = tostring(TargetResources[0].userPrincipalName)
| join (AzureActivity
| where OperationName == "Create role assignment"
| project OperationName, RoleAssignmentTime = TimeGenerated, user = Caller) on user
| project-away user1
```

#### 1.11 ⚠️ Workbook vs playbook vs analytics rule vs hunting query

Esta es **tu debilidad medida**: en el practice assessment del 23 de julio fallaste dos preguntas por confundir workbook con playbook. La distinción es de propósito, y el examen la plantea siempre con un verbo delator en el enunciado:

| Herramienta | Para qué sirve | Verbo delator en el enunciado |
|---|---|---|
| **Workbook** | **Visualizar** e informar: gráficas, tablas, dashboards interactivos | "visualizar", "mostrar", "reporte", "dashboard", "tendencia", "presentar a la dirección" |
| **Playbook** | **Ejecutar acciones** automatizadas (Logic Apps): abrir tickets, mandar mensajes, bloquear, aislar | "automatizar", "ejecutar una acción", "notificar a Teams", "crear un ticket", "responder" |
| **Analytics rule** | **Detectar**: corre en un horario y genera alertas/incidentes cuando la consulta encuentra algo | "detectar", "generar una alerta cuando", "crear un incidente si" |
| **Hunting query** | **Buscar proactivamente** a mano, sin generar alertas automáticamente | "buscar", "investigar una hipótesis", "cazar", "sin generar alertas" |

Regla mental corta: **workbook = ojos. Playbook = manos. Analytics rule = alarma. Hunting query = linterna.**

---

### 2. SOC optimization

#### 2.1 Qué es y para qué sirve

**SOC** son las siglas de **Security Operations Center** — el centro de operaciones de seguridad, es decir, el equipo y el conjunto de herramientas que vigilan y responden a amenazas en una organización.

**SOC optimization** es una funcionalidad de Microsoft Sentinel que te da **recomendaciones accionables** sobre tu workspace, con dos objetivos que tiran en direcciones opuestas y hay que equilibrar:

1. **Cerrar huecos de cobertura** frente a amenazas concretas (te falta una detección o una fuente de datos).
2. **Apretar la ingesta de datos que no aporta valor de seguridad** (estás pagando por almacenar datos que ninguna detección usa).

La idea de fondo: sin SOC optimization, ese análisis lo tendría que hacer un humano a mano, revisando tabla por tabla y regla por regla. La herramienta lo hace por ti automáticamente.

#### 2.2 Tipos de recomendación (memoriza esta clasificación)

```
SOC optimization
├── Data value recommendations           → mejora el uso/coste de tus datos
├── Coverage-based recommendations       → cierra huecos de cobertura
│   ├── Threat-based recommendations
│   ├── AI MITRE ATT&CK tagging (Preview)
│   └── Risk-based recommendations (Preview)
└── Similar organizations recommendations → qué ingieren organizaciones parecidas a la tuya
```

#### 2.3 Data value recommendations (optimización de valor del dato)

Buscan mejorar la relación **coste / valor de seguridad**. Detectan conectores de datos y tablas **poco o nada usados** y sugieren o bien reducir su coste, o bien aumentar su valor.

**Restricción importante que el examen puede preguntar: solo miran tablas facturables que hayan ingerido datos en los últimos 30 días.** Si una tabla no es facturable, o no recibió datos en 30 días, queda fuera de este análisis.

| Observación | Acción recomendada |
|---|---|
| La tabla **no fue usada por analytics rules ni detecciones** en los últimos 30 días, pero sí por otras fuentes (workbooks, log queries, hunting queries) | Activar plantillas de analytics rules **O** mover la tabla a un **plan de basic logs** si es elegible |
| La tabla **no se usó en absoluto** en los últimos 30 días | Activar plantillas de analytics rules **O** dejar de ingerir y eliminar la tabla, o moverla a retención a largo plazo |
| La tabla **solo fue usada por Azure Monitor** | Activar plantillas de analytics rules relevantes si tiene valor de seguridad **O** mover a un workspace de Log Analytics no dedicado a seguridad |

**Excepción que aparece en la documentación:** si una tabla está elegida para **UEBA** (*User and Entity Behavior Analytics*, el motor de análisis de comportamiento de usuarios y entidades) o para una **regla de analytics de matching de threat intelligence**, SOC optimization **no recomienda ningún cambio de ingesta** sobre ella — aunque parezca poco usada, está alimentando esos motores.

**Unused columns (Preview).** SOC optimization también detecta **columnas** sin uso dentro de tablas que sí usas. La única que aparece documentada hoy: la columna **`ConditionalAccessPolicies`** en las tablas **`SigninLogs`** o **`AADNonInteractiveUserSignInLogs`**, con la acción de dejar de ingerir esa columna.

> [!warning] Advertencia de la documentación
> Antes de tocar planes de ingesta, asegúrate de tener claros los límites de tu plan y de que las tablas afectadas **no se estén ingiriendo por motivos de cumplimiento normativo u otras razones similares**. Que una tabla no alimente detecciones no significa que la puedas apagar: puede que la ley te obligue a conservarla.

#### 2.4 Threat-based recommendations (basadas en amenazas)

También llamadas **coverage optimization**. Se apoyan en la investigación de seguridad de Microsoft: analizan **los logs que ingieres y las analytics rules que tienes activadas**, y los comparan contra **los logs y detecciones que harían falta para cubrir tipos de ataque concretos**.

Consideran **tanto las detecciones predefinidas como las que hayas creado tú**.

| Observación | Acción recomendada |
|---|---|
| Hay fuentes de datos, pero **faltan detecciones** | Activar plantillas de analytics rules según la amenaza, ajustando nombre, descripción y lógica de la consulta a tu entorno |
| Las plantillas están activadas, pero **faltan fuentes de datos** | Conectar nuevas fuentes de datos |
| **No hay ni detecciones ni fuentes de datos** | Conectar detecciones y fuentes de datos, o instalar una solución completa |

#### 2.5 AI MITRE ATT&CK tagging recommendations (Preview)

**MITRE ATT&CK** es un catálogo público y estandarizado de **tácticas** (el objetivo del atacante: acceso inicial, persistencia, exfiltración…) y **técnicas** (el método concreto). Etiquetar tus detecciones con tácticas y técnicas de ATT&CK es lo que permite ver, en el blade de MITRE que trabajaste el Día 4, qué partes de la matriz cubres y cuáles tienes en blanco.

El problema: mucha gente crea reglas y no las etiqueta, así que el mapa de cobertura miente. Esta función usa un modelo de inteligencia artificial que **corre sobre el workspace del cliente** y propone etiquetas de táctica y técnica para las detecciones sin etiquetar.

Se puede aplicar de **tres formas**:
- Aplicar la recomendación a **una analytics rule concreta**.
- Aplicarla a **todas las analytics rules del workspace**.
- **No aplicarla** a ninguna.

#### 2.6 Risk-based recommendations (Preview)

Parten de escenarios de seguridad del mundo real asociados a **riesgos de negocio**, no a técnicas de ataque. Los cinco tipos de riesgo que contempla: **operacional, financiero, reputacional, de cumplimiento y legal**.

El mecanismo es análogo al de threat-based (comparar logs y reglas contra lo necesario), pero el criterio de "lo necesario" viene de proteger frente a ataques que puedan causar esos daños de negocio. También consideran detecciones predefinidas y propias, y sus tres observaciones y acciones son idénticas a las de la tabla de threat-based.

**La diferencia de examen entre threat-based y risk-based:** threat-based razona desde *el ataque* ("¿estoy cubierto contra ransomware?"); risk-based razona desde *el daño al negocio* ("¿estoy cubierto contra escenarios que me generen pérdida financiera o incumplimiento legal?").

#### 2.7 Similar organizations recommendations

Usa **machine learning** (aprendizaje automático) para identificar tablas que **no tienes en tu workspace pero sí usan organizaciones con tendencias de ingesta y perfil de industria parecidos al tuyo**. Te muestra cómo las usan y recomienda las fuentes de datos y reglas relacionadas.

**Exclusiones** (no recomienda): conectores personalizados, tablas personalizadas, tablas usadas por menos de 10 workspaces, y tablas que contienen múltiples orígenes de log como `Syslog` o `CommonSecurityLog`.

**Dos consideraciones que conviene saber:**
- No todos los workspaces reciben estas recomendaciones — solo si el modelo encuentra similitudes significativas. Los SOC **en fase temprana o de onboarding** son más propensos a recibirlas que los maduros.
- **Privacidad:** los modelos **nunca acceden ni analizan el contenido de los logs del cliente ni los ingieren**. Se basan únicamente en **OII (Organizational Identifiable Information)** y metadatos del sistema; no se expone ningún dato de cliente ni información personal (**EUII**, *End User Identifiable Information*).

---

### 3. Roles y permisos de Microsoft Sentinel

Este objetivo ("Specify Microsoft Sentinel roles") **no estaba asignado a ningún día en la guía del vault**, y además el simulacro del 23 de julio te cazó justo aquí (error #2: el rol *Microsoft Sentinel Automation Contributor* va sobre el **resource group** del playbook, no sobre el playbook individual). Lo cubro completo.

#### 3.1 Qué es RBAC

**RBAC (Role-Based Access Control)** — control de acceso basado en roles — es el modelo de permisos: en lugar de dar permisos sueltos a cada persona, se definen **roles** (paquetes de permisos) y se **asignan** a usuarios, grupos o aplicaciones **sobre un ámbito** (*scope*): una suscripción entera, un resource group o un recurso individual. Un permiso siempre es la combinación de las tres cosas: **quién + qué rol + sobre qué ámbito**.

Microsoft Sentinel usa **dos sistemas de RBAC distintos** según la pieza:
- **Azure RBAC** para el **SIEM** de Microsoft Sentinel (lo clásico: workspace, reglas, incidentes, workbooks).
- **Microsoft Entra ID RBAC** para el **data lake** de Microsoft Sentinel (la capa de almacenamiento barato y masivo que viste el Día 1).

#### 3.2 Los cinco roles integrados de Microsoft Sentinel

| Rol | Qué puede en el SIEM | Soporte de data lake |
|---|---|---|
| **Microsoft Sentinel Reader** | Ver datos, incidentes, workbooks, recomendaciones y otros recursos | Acceder a analítica avanzada y correr consultas interactivas, **solo sobre workspaces** |
| **Microsoft Sentinel Responder** | Todo lo de Reader **+ gestionar incidentes** | No aplica |
| **Microsoft Sentinel Contributor** | Todo lo de Responder **+ instalar/actualizar soluciones y crear/editar recursos** | Acceder a analítica avanzada y correr consultas interactivas, **solo sobre workspaces** |
| **Microsoft Sentinel Playbook Operator** | Listar, ver y **ejecutar manualmente** playbooks | No aplica |
| **Microsoft Sentinel Automation Contributor** | Permite que **Microsoft Sentinel** añada playbooks a automation rules. **No se usa para cuentas de usuario** | No aplica |

Matriz de tareas concretas (así es como el examen lo pregunta):

| Rol | Ejecutar playbooks | Crear/editar playbooks | Crear/editar analytics rules, workbooks… | Gestionar incidentes | Ver datos, incidentes, workbooks | Gestionar Content hub |
|---|---|---|---|---|---|---|
| Sentinel Reader | — | — | —\* | — | ✓ | — |
| Sentinel Responder | — | — | —\* | ✓ | ✓ | — |
| Sentinel Contributor | — | — | ✓ | ✓ | ✓ | ✓ |
| Sentinel Playbook Operator | ✓ | — | — | — | — | — |
| **Logic App Contributor** | ✓ | ✓ | — | — | — | — |

\* Sí puede si se le añade además el rol **Workbook Contributor**.

**Observa dos cosas que el examen explota:**
1. **Ningún rol de Sentinel puede crear o editar playbooks.** Para eso hace falta **Logic App Contributor**, que es un rol de Azure Logic Apps, no de Sentinel. Recuerda del Día 6: un playbook *es* una Logic App.
2. **Sentinel Contributor no ejecuta playbooks.** Ejecutarlos requiere **Playbook Operator** (o Logic App Contributor). Ser "el rol más alto de Sentinel" no implica poder correr automatización.

#### 3.3 El ámbito correcto: resource group

**Recomendación oficial: asigna estos roles al resource group que contiene el workspace de Microsoft Sentinel**, no al workspace ni a recursos individuales. La razón: así quedan cubiertos de una sola vez todos los recursos relacionados — las Logic Apps, los playbooks, los workbooks — que viven en ese mismo resource group.

Si en cambio asignas los roles **directamente al workspace** de Sentinel, tienes que asignar además los mismos roles al **recurso de solución SecurityInsights** dentro de ese workspace, y probablemente a otros recursos, y luego mantener esas asignaciones a mano cada vez que aparezca un recurso nuevo. Es más frágil y más trabajo.

#### 3.4 Roles adicionales para tareas específicas

| Tarea | Roles / permisos requeridos |
|---|---|
| **Conectar fuentes de datos** | Permiso de **Write** sobre el workspace (más lo que pida cada conector concreto) |
| **Gestionar contenido del Content hub** | **Microsoft Sentinel Contributor** a nivel de resource group |
| **Automatizar respuestas con playbooks** | **Microsoft Sentinel Playbook Operator** para ejecutarlos, y **Logic App Contributor** para crearlos/editarlos |
| **Permitir que Sentinel ejecute playbooks desde automation rules** | La **cuenta de servicio** necesita permisos explícitos sobre el **resource group del playbook**; tu cuenta necesita ser **Owner** para poder otorgarlos |
| **Que usuarios invitados (guest) asignen incidentes** | **Directory Reader** (rol de Microsoft Entra ID, no de Azure) **Y Microsoft Sentinel Responder** |
| **Crear / eliminar workbooks** | **Microsoft Sentinel Contributor** (o un rol de Sentinel menor) **Y Workbook Contributor** |

> [!important] Tu error del simulacro, explicado
> Sentinel usa una **cuenta de servicio especial** (no tu cuenta de usuario) para ejecutar los playbooks de trigger de incidente, ya sea manualmente o llamados desde una automation rule. Se hace así deliberadamente, para elevar el nivel de seguridad del servicio. Para que una automation rule pueda ejecutar un playbook, **esa cuenta debe tener permisos explícitos sobre el resource group donde reside el playbook**. Y ojo con la consecuencia: **a partir de ese momento, cualquier automation rule puede ejecutar cualquier playbook de ese resource group**. Por eso el ámbito es el resource group y no el playbook individual — y por eso, si quieres aislar playbooks sensibles, tienes que ponerlos en un resource group aparte.

> [!warning] Las asignaciones de rol son acumulativas
> Un usuario con **Microsoft Sentinel Reader** *y* **Contributor** tiene los permisos de Contributor, no los de Reader. Quitar permisos exige quitar la asignación, no añadir un rol más restrictivo encima. Esto choca con la intuición y el examen lo aprovecha.

#### 3.5 Otros roles de Azure y Log Analytics que te vas a encontrar

Conceden accesos más amplios que incluyen tu workspace de Sentinel:
- **Roles de Azure**: Owner, Contributor, Reader — acceso amplio a recursos de Azure.
- **Roles de Log Analytics**: Log Analytics Contributor, Log Analytics Reader — acceso a workspaces de Log Analytics.

#### 3.6 Asignaciones recomendadas por perfil

| Perfil | Rol | Resource group | Para qué |
|---|---|---|---|
| **Analistas de seguridad** | Microsoft Sentinel Responder | El de Sentinel | Ver y gestionar incidentes, datos, workbooks |
| | Microsoft Sentinel Playbook Operator | El de Sentinel / el del playbook | Adjuntar y ejecutar playbooks |
| **Ingenieros de seguridad** | Microsoft Sentinel Contributor | El de Sentinel | Gestionar incidentes, contenido, recursos |
| | Logic App Contributor | El de Sentinel / el del playbook | Ejecutar y modificar playbooks |
| **Service Principal** | Microsoft Sentinel Contributor | El de Sentinel | Tareas de gestión automatizadas |

#### 3.7 Permisos del data lake de Microsoft Sentinel

Aquí cambia el sistema: **se usan roles de Microsoft Entra ID**, que dan acceso amplio a todo el contenido del data lake. Requisito previo: el workspace debe estar **onboardeado al portal de Defender** y tener el data lake habilitado.

**Lectura en todos los workspaces del data lake:** Global reader, Security reader, Security operator, Security administrator o Global administrator.

**Escritura en tablas del data lake, y escritura en tablas del tier de analytics vía KQL jobs o notebooks:** Security operator, Security administrator o Global administrator.

**Crear o gestionar jobs en el data lake:** Security operator, Security administrator o Global administrator.

Si en cambio quieres acotar a **un workspace concreto**, se usan roles de Azure RBAC (Log Analytics Reader/Contributor, Microsoft Sentinel Reader/Contributor, Reader, Contributor, Owner) o un rol personalizado de **Defender XDR unified RBAC** con permisos *security data basics (read)* sobre la colección de datos de Microsoft Sentinel.

**Regla mnemotécnica:** *SIEM → roles de Azure sobre el resource group. Data lake → roles de Microsoft Entra ID sobre el tenant.*

#### 3.8 RBAC avanzado

Para restringir el acceso a datos concretos sin dar acceso al workspace entero:
- **Resource-context RBAC**: el usuario ve solo los datos de los recursos de Azure sobre los que ya tiene permisos.
- **Table-level RBAC**: permisos por tabla.
- **Roles personalizados**: Azure custom roles para el SIEM; roles personalizados de Defender XDR unified RBAC para el data lake.

---

### 4. Notificaciones por correo en Microsoft Defender XDR

El objetivo del temario dice: *"Configure email notifications in Microsoft Defender XDR, including incidents, actions, and threat analytics"*. Hay varios tipos de notificación y se configuran en sitios distintos — el examen pregunta exactamente **dónde** se configura cada una.

#### 4.1 Notificaciones de incidentes

**Para qué:** avisar por correo a tu equipo cuando aparece un incidente nuevo o se actualiza uno existente, sin tener que estar mirando el portal.

**Permiso necesario:** **Manage security settings**. Si la organización usa gestión de permisos básica, los usuarios con rol **Security Administrator** o superior pueden configurarlas. Si usa **RBAC**, solo puedes crear, editar, borrar y recibir notificaciones **de los device groups que tengas permitido gestionar**.

**Ruta:** portal de Microsoft Defender → **Settings > Microsoft Defender XDR** → **Email notifications** (bajo General) → pestaña **Incidents** → **Add incident notification rule**.

**Pasos y ajustes:**

1. **Basics**: nombre y descripción de la regla.
2. **Notification settings**:
   - **Alert severity** — qué severidades de alerta disparan la notificación (por ejemplo, solo *High*).
   - **Device group scope** — todos los device groups o una selección de los del tenant.
   - **Send only one notification per incident** — una sola notificación por incidente, en lugar de una por cada actualización.
   - **Include organization name in the email** — incluir el nombre de la organización en el correo.
   - **Include tenant-specific portal link** — incluir un enlace con el tenant ID, para entrar directo al tenant correcto (útil si gestionas varios).
3. **Recipients**: añadir direcciones de correo, una a una con **Add**. Existe **Send test email** para verificar que llegan y no caen en spam.
4. **Review rule** → **Create rule**.

**Granularidad adicional** que ofrece la configuración: elegir notificaciones **solo para orígenes de servicio específicos**, **solo para orígenes de detección específicos**, y **severidad distinta por origen** — por ejemplo, Medium y High para EDR pero todas las severidades para Microsoft Defender Experts.

**Contenido del correo:** nombre del incidente, severidad, categorías, entre otros datos, más un enlace para ir directo al incidente.

**Nuevos destinatarios:** empiezan a recibir avisos **a partir del momento en que se añaden** (no reciben los incidentes anteriores).

**Editar / borrar:** seleccionar la regla de la lista → **Edit rule**, o **Delete**. ⚠️ **Borrar una regla de notificación es permanente y no se puede deshacer.**

#### 4.2 Notificaciones de vulnerabilidades

Vienen de **Microsoft Defender Vulnerability Management** y **se configuran en otro sitio**: portal de Defender → **Settings > Endpoints > General > Email notifications > Vulnerabilities** → **Add notification rule**.

**Permiso:** igual, **Manage security settings** (o Security Administrator con permisos básicos).

**Eventos de vulnerabilidad que puedes elegir** (varios por regla):
- **New vulnerability found**, con umbral de severidad. Incluye vulnerabilidades **zero-day** recién detectadas y parches publicados para zero-days existentes.
- **Exploit was verified** — se verificó que el exploit funciona.
- **New public exploit** — apareció un exploit público.
- **Exploit added to an exploit kit** — el exploit se integró en un kit de explotación (lo que dispara su uso masivo).

También se eligen los **device groups** a los que aplica, y si incluir el nombre de la organización. El correo incluye enlaces a vistas filtradas del portal: la página **Security recommendations** y la página **Weaknesses**.

**Con RBAC:** los destinatarios solo reciben notificaciones de los device groups fijados en la regla, y solo se pueden crear/editar/borrar reglas dentro del propio ámbito de device groups. **Solo un rol de administrador, como Security Administrator, puede gestionar reglas de todos los device groups.**

**Nota para Defender for Business:** las notificaciones de vulnerabilidad se configuran **solo para usuarios específicos**, no para roles ni grupos, y los device groups no aplican.

**Si no llegan los correos**, la documentación sugiere revisar en este orden: carpeta de correo no deseado (marcar como *Not junk*), que el producto de seguridad de correo no los esté bloqueando, y las reglas del cliente de correo que puedan estar moviéndolos.

#### 4.3 Resumen de dónde se configura cada notificación

| Tipo de notificación | Ruta |
|---|---|
| **Incidentes** | Settings > **Microsoft Defender XDR** > Email notifications > pestaña **Incidents** |
| **Vulnerabilidades** | Settings > **Endpoints** > General > Email notifications > **Vulnerabilities** |
| **Alertas / actividad de usuarios en Microsoft 365** | **Alert policies** en el portal de Defender (mecanismo aparte de los alerts de XDR) |

---

### 5. Alert tuning, suppression y correlación de alertas

Este es el otro objetivo huérfano del temario: *"Configure alert notifications in Microsoft Defender XDR, including tuning, suppression, and correlation"*.

#### 5.1 Alerta vs incidente, y qué es "correlación"

Repaso deliberado, porque es **el punto exacto que fallaste en la P5 del quiz del Día 6**:

- Una **alerta** (*alert*) es **una señal individual**: el resultado de una actividad de detección concreta. "Este proceso hizo algo sospechoso en este dispositivo."
- Un **incidente** (*incident*) es **el conjunto de alertas relacionadas agrupadas en una sola historia de ataque**. Defender XDR **correlaciona** automáticamente alertas de distintos productos que pertenecen al mismo ataque y las mete en un mismo incidente.

Eso es la **correlación**: el mecanismo por el que múltiples alertas — de endpoint, de identidad, de correo, de apps SaaS — se agrupan en un incidente que cuenta la historia completa. Las alertas son las piezas de evidencia; el incidente es el caso.

En KQL, la traducción de esto es la regla que ya te marcaste:
> **Alerta individual de producto → tabla `SecurityAlert`. Incidente correlacionado de Sentinel → tabla `SecurityIncident`.**

**Dónde se ven las alertas:** cola de alertas en **Incidents & alerts > Alerts** del portal de Defender. Por defecto muestra las alertas **nuevas y en progreso de los últimos 7 días**, la más reciente arriba. El número total aparece junto a la barra de búsqueda y varía según los filtros aplicados. Se puede buscar por **título de la alerta o por alert ID**, y filtrar por rango de fechas personalizado.

**Filtros disponibles:** severidad, estado, categorías, origen de servicio/detección, tags, política/regla de política, tipo de alerta, nombre del producto, ID de suscripción de la alerta, entidades (activos afectados), estado de la investigación automatizada, workspace, data stream y etiqueta de confidencialidad.

**Tags de sistema vs tags personalizados:** los personalizados usan fondo blanco; los de sistema, típicamente fondo rojo o negro. Los tags de sistema identifican: **el tipo de ataque** (ransomware, phishing de credenciales), **acciones automáticas** (AIR y automatic attack disruption), que **Defender Experts** está gestionando el incidente, y que hay **activos críticos** involucrados. (El etiquetado automático de activos críticos lo hace Security Exposure Management sobre dispositivos, identidades y recursos cloud.)

#### 5.2 Prefijos del alert ID según el origen — tabla de examen

Cuando una alerta llega a la experiencia unificada, su ID lleva **caracteres antepuestos** que identifican de qué producto viene. Es material de examen muy concreto y muy preguntable:

| Origen de la alerta | Prefijo del alert ID |
|---|---|
| Microsoft Defender XDR | `ra{GUID}` · `ta{GUID}` si viene de ThreatExperts · `ea{GUID}` si viene de custom detections |
| Microsoft Defender for Office 365 | `fa{GUID}` |
| Microsoft Defender for Endpoint | `da{GUID}` · `ed{GUID}` si viene de custom detections |
| Microsoft Defender for Identity | `aa{GUID}` · `ri{GUID}` si viene del motor de detección de XDR |
| Microsoft Defender for Cloud Apps | `ca{GUID}` · `ma{GUID}` si viene de App Governance · `rm{GUID}` si viene del motor de XDR |
| Microsoft Entra ID Protection | `ad{GUID}` |
| App Governance | `ma{GUID}` |
| Microsoft Data Loss Prevention | `dl{GUID}` |
| Microsoft Defender for Cloud | `dc{GUID}` |
| Microsoft Sentinel | `sn{GUID}` |
| Microsoft Purview Insider Risk Management | `ir{GUID}` |
| Microsoft Security Copilot | `sc{GUID}` |

(Un **GUID** es un identificador único global, la cadena larga hexadecimal. El prefijo **no cambia el GUID de la alerta**: solo se le antepone un componente.)

#### 5.3 Permisos para ver alertas

Se obtienen por asignación de rol, de dos maneras:
- **Roles de Microsoft Entra**: Security Reader, Security Operator o Security Administrator.
- **Roles personalizados de Microsoft Defender** que incluyan permisos de acceso a datos de seguridad, como *Security data basics (read)*.

⚠️ **Excepción importante:** los datos de Microsoft Sentinel **siguen usando los permisos del workspace de Sentinel**. Para ver alertas que contengan datos de Sentinel, necesitas los permisos de **Azure RBAC** correspondientes sobre ese workspace — no basta con los roles de Defender. Es el puente entre §3 y esta sección.

#### 5.4 Qué es alert tuning (antes llamado alert suppression)

El problema real de un SOC: el volumen diario de alertas. El analista quiere centrarse en lo grave, pero igual tiene que triar y resolver alertas de baja prioridad, normalmente a mano.

**Alert tuning** (ajuste de alertas; **antes se llamaba *alert suppression*, supresión de alertas**) permite **ocultar o resolver alertas automáticamente cuando ocurre un comportamiento esperado de la organización y se cumplen las condiciones de una regla**. Reduce la cola de alertas y ahorra tiempo de triaje.

Caso de uso típico: una aplicación interna de negocio, o una prueba de seguridad programada, dispara la misma alerta todos los días y ya sabes que es benigna.

> [!caution] Advertencia explícita de la documentación
> Usa alert tuning **con precaución**, solo para escenarios donde aplicaciones internas conocidas o pruebas de seguridad generan actividad esperada. Suprimir de más es cegarte.

#### 5.5 Reglas de tuning integradas (built-in)

Defender XDR **ya trae reglas de alert tuning integradas** que suprimen ruido de actividad benigna común. Dos propiedades clave:

- **Suprimen la alerta sin afectar a otras funcionalidades** como las investigaciones de **AIR** y las **notificaciones por correo**.
- **Si la investigación de AIR detecta actividad maliciosa o sospechosa, la alerta suprimida se reactiva.**

**Dónde verlas:** portal de Defender → **System > Settings > Microsoft Defender XDR > sección Rules > Alert tuning** (o directo en `https://security.microsoft.com/securitysettings/defender/alert_suppression`). Conviene revisarlas para entender por qué ciertas alertas no aparecen en tu cola.

*Nota operativa:* el **Phishing Triage Agent** de Microsoft Security Copilot **no clasifica alertas suprimidas por alert tuning**. Si lo usas, hay que desactivar la regla integrada *"Auto-Resolve - Email reported by user as malware or phish"* y cualquier regla propia que suprima esa alerta.

#### 5.6 Reglas de tuning personalizadas: las tres acciones

Puedes crear tus propias reglas con **una de estas tres acciones** cuando se cumplan las condiciones. **Memoriza las diferencias, incluidas las restricciones por producto:**

| Acción | Qué hace | Restricción / dónde quedan los datos |
|---|---|---|
| **Hide alert** | Suprime la alerta y **evita la creación del incidente** | **Solo aplicable a alertas de Defender for Endpoint.** Las alertas ocultas **siguen existiendo en las tablas `AlertInfo` y `AlertEvidence`** |
| **Resolve alert** | **Resuelve automáticamente** la alerta y los incidentes relacionados. Las alertas coincidentes y sus incidentes se generan ya con estado *resolved* | Sin restricción de producto |
| **Set as behavior** | Convierte las señales coincidentes en **behaviors**: no aparecen en la cola de alertas ni generan incidentes. Los datos quedan en las tablas **`BehaviorInfo` y `BehaviorEntities`** para hunting | **No soportada para alertas de Defender for Cloud ni de Defender for Office 365** |

El matiz que distingue las tres: *Hide* esconde pero no crea incidente y solo va en MDE; *Resolve* sí crea la alerta pero ya cerrada; *Set as behavior* la degrada a un dato consultable que ni siquiera es alerta. **En los tres casos el dato sigue siendo consultable en alguna tabla** — tunear no borra evidencia.

#### 5.7 Cómo se construyen las condiciones

Las reglas de alert tuning se basan en **tipos de evidencia**: archivos, procesos, tareas programadas y otros elementos que disparan alertas. Todos los disparadores son **IOCs (Indicators of Compromise**, indicadores de compromiso): archivos, procesos, tareas programadas, scripts de **AMSI (AntiMalware Scan Interface)**, eventos de **WMI (Windows Management Instrumentation)**, etc.

**Se puede crear la regla desde dos sitios:**

*Desde Settings:* **Settings > Microsoft Defender XDR > Alert tuning** → **Add new rule** → en el panel **Tune alert**, elegir en **Select service sources** los orígenes de servicio donde aplica (solo aparecen los servicios sobre los que tienes permisos) → definir condiciones → elegir acción → nombre y comentario → **Save**.

*Desde una alerta concreta:* página **Alerts** o detalle de una alerta → **Tune alert** (puede estar bajo los puntos suspensivos **...** según la resolución de pantalla). Aquí aparece un paso extra, el área **Alert types**, donde eliges si la regla aplica **solo a alertas del tipo seleccionado** o a **cualquier tipo de alerta que cumpla las mismas condiciones** (en cuyo caso también eliges orígenes de servicio).

**Detalles de las condiciones que conviene retener:**
- Los disparadores disponibles **cambian según los orígenes de servicio** que hayas seleccionado.
- Con **Add filter** se combinan varias condiciones usando **AND**, **OR** y agrupaciones.
- **Los valores de las condiciones no distinguen mayúsculas de minúsculas**, y **algunas propiedades admiten comodines** (*wildcards*).

**Después de crear la regla desde una alerta**, aparece una pantalla *Successful rule creation* donde puedes añadir los IOCs relacionados a una **lista de permitidos (*allow list*)** para que no se bloqueen en el futuro. Los IOCs que forman parte de la regla vienen preseleccionados; se define un **scope** (que también viene preseleccionado con el que aplica a tu alerta) y se guarda.

> [!warning] Dos límites que el examen puede preguntar
> - **El título de la alerta (*Name*) se basa en el tipo de alerta (`IoaDefinitionId`)**, que es lo que decide el título. Dos alertas del mismo tipo pueden acabar con títulos distintos.
> - **La supresión de alertas NO es compatible con custom detections.** Si una custom detection genera falsos positivos, no la silencias con alert tuning: hay que **afinar la propia custom detection**.

#### 5.8 Gestionar y clasificar una alerta

Desde **Manage alert** en la página de la alerta puedes ver o especificar:
- **Estado**: New, In progress, Resolved.
- **Usuario asignado**.
- **Clasificación**:
  - **Not Set** (valor por defecto).
  - **True positive**, con un tipo de amenaza. Para alertas que reflejan una amenaza real; especificar el tipo ayuda al equipo a ver patrones.
  - **Informational, expected activity**, con un tipo de actividad. Para alertas **técnicamente correctas pero que reflejan comportamiento normal o actividad simulada** — pruebas de seguridad, ejercicios de red team, comportamiento inusual esperado de apps y usuarios de confianza. Las quieres ignorar, pero **sí quieres seguir viéndolas** si mañana las provoca un atacante real.
  - **False positive**: alertas creadas sin actividad maliciosa alguna, falsas alarmas. **Estas no las quieres volver a ver.**
- Un **comentario**.

**La distinción entre *Informational, expected activity* y *False positive* es pregunta de examen**: la primera es una alerta *correcta* sobre actividad *benigna*; la segunda es una alerta *incorrecta*. Clasificar bien alimenta la mejora de la calidad de detección de Microsoft Defender XDR.

**Gestión en lote:** desde el cuadro **INSIGHT** de una alerta, **View similar alerts** permite clasificar de golpe todas las relacionadas. Y si alertas similares ya se clasificaron antes, la pestaña **Recommendations** propone los siguientes pasos y consejos de investigación, remediación y prevención basándose en cómo se resolvieron.

#### 5.9 Alert service settings

**Settings > Microsoft Defender XDR > Alert service settings** (también accesible desde la página **Incidents**) permite configurar los ajustes de alerta por servicio.

Dato reciente a tener en el radar: desde el **11 de diciembre de 2025** se desplegaron en public preview opciones de configuración ampliadas para las alertas de **Microsoft Entra ID Protection**, con control más granular sobre el alertado basado en riesgo. **El valor por defecto nuevo es *High-risk detections only***, y se puede cambiar a *High + Medium* o *All detections*. Es decir: por defecto **no recibes alertas de riesgo medio ni bajo de Entra ID Protection** salvo que lo cambies — justo el tipo de detalle que el examen convierte en escenario ("el analista no ve alertas de riesgo medio, ¿por qué?").

---

### 6. Cierre de la Fase 1 — mapa de los 7 días

| Día | Tema | Objetivos del temario que cubre |
|---|---|---|
| 1 | Arquitectura de Sentinel y tiers de retención | Manage data retention for XDR and Sentinel tables (Analytics, Data lake, XDR) |
| 2 | Ingestión 1: AMA, DCR, Windows Security Events, WEF | Select data connectors · Windows Security Events via AMA + DCRs · WEF |
| 3 | Ingestión 2: Syslog/CEF, Azure Activity, TI, tablas custom | Syslog/CEF via AMA · Azure Policy y diagnostic settings · Ingest threat indicators · Custom log tables |
| 4 | Detecciones: analytics rules y anomalías | Analytics rules (scheduled, NRT, TI, machine learning) · MITRE ATT&CK coverage · Anomalies |
| 5 | Configuración avanzada de MDE | MDE advanced features · rules settings · custom data collection · ASR rules · device groups, permissions, automation levels |
| 6 | AIR, attack disruption, automation rules, playbooks | Manage AIR · Configure automatic attack disruption · Automation rules · Playbooks |
| **7** | **Workbooks, SOC optimization, roles, notificaciones, alert tuning** | **Sentinel workbooks · SOC optimization · Specify Sentinel roles · Email notifications · Alert notifications: tuning, suppression, correlation** |

Queda **un objetivo del Dominio 1 que se cubre más adelante por afinidad temática**: *"Create custom detection rules by using Advanced Hunting in Microsoft Defender XDR"* y *"Manage custom detection rules"*, que van en el **Día 15** junto a Advanced Hunting, porque necesitas primero soltura con KQL. No es un hueco: es un desplazamiento deliberado.

---

### 7. 📋 Replanteamiento del temario (verificado hoy, 29-jul-2026)

Verifiqué hoy el skills outline oficial. **La página dice "Skills measured as of July 28, 2026"** — el temario nuevo ya está vigente, desde ayer.

#### 7.1 Lo que se confirma

Los tres dominios y sus pesos **no cambian**: Manage SecOps environment 40–45 %, Respond to security incidents 35–40 %, Perform threat hunting 20–25 %. El change log marca el dominio *Respond to security incidents* como **"No change"** a nivel de grupo, con cambios **"Minor"** en sus tres sub-bloques.

Los temas nuevos que ya teníamos identificados aparecen efectivamente en el outline:

| Tema nuevo | Dónde cae | Día del plan |
|---|---|---|
| Manage security incidents by using **case management** | Dominio 2 | Día 8 |
| Investigate incidents by using **agentic AI, including embedded Microsoft Security Copilot** | Dominio 2 | Día 13 |
| Create **hunting graphs, including blast radius** | Dominio 3 | Día 15 |
| Analyze relationships between entities by using **Sentinel Graph** | Dominio 3 | Día 15 |
| Create and manage **KQL jobs in Data lake** | Dominio 3 | Día 17 |
| Create and manage **Summary rule tables** | Dominio 3 | Día 17 |
| Hunt by using Notebooks, **including connection to the Sentinel MCP Server** | Dominio 3 | Día 17 |

#### 7.2 Lo que hay que corregir en el plan

**a) Dos objetivos del Dominio 1 no estaban asignados a ningún día.** Ya resuelto: los cubrí hoy.
- *Specify Microsoft Sentinel roles* → §3 de esta lección.
- *Configure alert notifications in Microsoft Defender XDR, including tuning, suppression, and correlation* → §5 de esta lección.

**b) El perfil de audiencia ahora exige familiaridad con "AI agents and Copilots".** Es un cambio de encuadre, no un objetivo suelto, pero refuerza que el bloque de Copilot embebido del Día 13 y el MCP Server del Día 17 **no son opcionales**.

**c) Matiz sobre analytics rules.** El outline enumera hoy *"scheduled, near-real time (NRT), threat intelligence, and machine learning"*. **Ya no nombra "Fusion" explícitamente**, aunque Fusion sigue siendo el motor de machine learning correspondiente. Estudia el concepto por su función (correlación multi-etapa basada en ML), no solo por el nombre comercial.

**d) SOC optimization tiene más tipos de recomendación de los que recoge la guía del vault.** `GUIA_INTENSIVA_24_DIAS.md` menciona solo *coverage* y *data value*. La documentación actual añade **AI MITRE ATT&CK tagging (Preview)**, **risk-based recommendations (Preview)** y **similar organizations recommendations** — todo cubierto en §2 de hoy.

> [!note] Nota metodológica
> El bloque del change log que devuelve la página al consultarla programáticamente llega **truncado**: muestra las filas de *Audience profile* y de los tres sub-bloques de *Respond to security incidents*, pero **no las filas de *Manage a security operations environment* ni de *Perform threat hunting***. La comparación de arriba la hice contrastando el outline completo actual contra el mapeo del vault, no contra esas filas del change log. Si quieres el detalle oficial fila por fila, conviene abrir la página del study guide a mano y mirar la tabla completa: [Study guide for Exam SC-200](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/sc-200).

**No se ha editado `GUIA_INTENSIVA_24_DIAS.md`** con estos hallazgos, salvo el cronograma (que sí actualicé a petición tuya). Los mapeos de contenido de la guía siguen como estaban — dime si quieres que los corrija también.

---

## 🧪 Ejercicio práctico del día

**Módulo de Microsoft Learn:** [Configuración del entorno de Microsoft Sentinel](https://learn.microsoft.com/es-es/training/paths/sc-200-configure-azure-sentinel-environment/) (repaso completo + SOC optimization)

**Lab:** [Lab 8 Ex9 — Create workbooks](https://microsoftlearning.github.io/SC-200T00A-Microsoft-Security-Operations-Analyst/Instructions/Labs/LAB_AK_08_Lab1_Ex09_Workbooks_Defender.html)

**Checklist del lab de hoy:**

1. **Workbook desde plantilla.** Abre **Threat management > Workbooks > Templates**. Elige una plantilla y **antes de guardarla, lee el campo `Required data types`** y comprueba si tienes esa tabla. Guárdala, ábrela y edita al menos un elemento.
2. **Workbook desde cero.** **Add workbook > Edit**. Añade un bloque de texto y una consulta con **Data source = Logs**, **Resource type = Log Analytics**. Usa la consulta *week over week* de §1.10 sobre `SecurityEvent` (tienes datos ahí desde el lab del Día 2). Añade un parámetro **TimeRange** y comprueba que las gráficas reaccionan al cambiarlo.
3. **Auto refresh.** Actívalo a 5 minutos, cierra el workbook, vuelve a abrirlo y **confirma que se desactivó solo** — es el comportamiento documentado.
4. **SOC optimization.** Entra en la sección de SOC optimization de tu workspace y revisa qué recomendaciones te salen. Con un workspace joven como el tuyo, lo esperable son recomendaciones de **cobertura** (te faltan detecciones y fuentes) y quizá de **similar organizations**, precisamente porque los SOC en onboarding son los que más las reciben.
5. **Roles.** En el portal de Azure, ve al **resource group** de tu workspace → **Access control (IAM)** → **Role assignments**, y localiza los roles `Microsoft Sentinel *`. **No cambies nada**: solo verifica en qué ámbito están asignados y contrástalo con la tabla de §3.6.
6. **Notificaciones de incidentes.** En el portal de Defender, recorre **Settings > Microsoft Defender XDR > Email notifications > Incidents** y abre el asistente de creación de regla hasta la pantalla de **Recipients** para ver todos los ajustes en vivo. Puedes cancelar sin crearla.
7. **Alert tuning.** Ve a **Settings > Microsoft Defender XDR > Rules > Alert tuning** y **lee las reglas integradas** que trae tu tenant. Identifica al menos una y razona qué ruido concreto está suprimiendo.

> [!warning] Recordatorio de crédito Azure
> Si enciendes la VM Windows del Día 2 para generar datos frescos, **déjala en "Stopped (deallocated)"** al terminar.

---

## 🎯 Quiz del día

Cinco preguntas. Responde antes de abrir el bloque de respuestas.

**1.** Un analista con el rol **Microsoft Sentinel Contributor** asignado sobre el resource group del workspace intenta crear un nuevo workbook y no puede guardarlo. ¿Cuál es la causa más probable?

- A) Los workbooks solo se pueden crear desde el portal de Azure, no desde el portal de Defender
- B) Necesita además el rol **Microsoft Sentinel Playbook Operator** sobre el mismo resource group
- C) El rol Contributor de Sentinel no permite crear recursos, solo gestionar incidentes existentes
- D) Necesita además el rol **Workbook Contributor** sobre el resource group

**2.** El SOC quiere dejar de recibir en la cola de alertas una alerta de Defender for Endpoint que dispara todos los días una aplicación interna conocida, **sin que se cree ningún incidente** por ella, pero conservando el dato para poder consultarlo después en hunting. ¿Qué acción de alert tuning corresponde?

- A) **Resolve alert**, que cierra la alerta y sus incidentes con estado resuelto
- B) **Hide alert**, que suprime la alerta e impide la creación del incidente
- C) Clasificar la alerta como **False positive** en el panel Manage alert
- D) **Set as behavior**, no disponible para alertas de Defender for Endpoint

**3.** SOC optimization te sugiere para una tabla: *"activar plantillas de analytics rules O mover la tabla a un plan de basic logs"*. ¿Qué observación disparó esa recomendación?

- A) La tabla no fue usada por analytics rules ni detecciones en 30 días, pero sí por workbooks, log queries o hunting queries
- B) La tabla no se usó en absoluto durante los últimos 30 días
- C) La tabla solo fue usada por Azure Monitor y no tiene valor de seguridad
- D) La tabla está seleccionada para UEBA y su ingesta debe reducirse

**4.** Tu organización necesita que una **automation rule** de Microsoft Sentinel ejecute un playbook alojado en un resource group distinto al del workspace. ¿Qué hay que configurar?

- A) Asignar **Logic App Contributor** al usuario que creó la automation rule, sobre el playbook concreto
- B) Asignar **Microsoft Sentinel Responder** a la cuenta de servicio sobre el workspace de Sentinel
- C) Otorgar permisos explícitos a la **cuenta de servicio de Sentinel sobre el resource group** donde reside el playbook
- D) Mover obligatoriamente el playbook al mismo resource group del workspace, ya que no se admiten otros

**5.** Un analista se queja de que no recibe correos de incidentes de severidad media, aunque la regla de notificación existe. Revisas la configuración de la regla en **Settings > Microsoft Defender XDR > Email notifications > Incidents**. ¿Cuál de estos ajustes explica el comportamiento?

- A) La opción **Include tenant-specific portal link** está desactivada en la regla
- B) El **Alert severity** de la regla está limitado a *High*, y el **Device group scope** puede no incluir el grupo afectado
- C) El analista fue añadido como destinatario después de crearse la regla, y eso lo excluye de todas las notificaciones futuras
- D) Las notificaciones de incidentes se configuran en **Settings > Endpoints > General > Email notifications**, así que la regla revisada no aplica

> [!note]- Ver respuestas
> **1 → D.** Crear o eliminar workbooks exige **la combinación** de *Microsoft Sentinel Contributor* (o un rol de Sentinel menor) **y** *Workbook Contributor* sobre el resource group. Un rol de Sentinel por sí solo no basta. **A** es falso: se pueden crear desde ambos portales (lo que sí es exclusivo del portal de Azure es imprimir/guardar como PDF y algunas visualizaciones). **B** es incorrecto: Playbook Operator sirve para ejecutar playbooks, nada que ver con workbooks. **C** describe mal el rol: Sentinel Contributor sí crea y edita recursos — su límite aquí es específicamente el de workbooks.
>
> **2 → B.** **Hide alert** es la única acción que suprime la alerta **e impide la creación del incidente**, y las alertas ocultas **siguen existiendo en `AlertInfo` y `AlertEvidence`**, así que el dato queda disponible para hunting. Es aplicable solo a alertas de Defender for Endpoint, que es justo el caso del enunciado. **A** falla porque *Resolve alert* sí genera la alerta y el incidente, solo que ya con estado resuelto. **C** falla porque clasificar es una acción manual sobre una alerta ya existente, no una regla que actúe automáticamente hacia adelante. **D** invierte la restricción: *Set as behavior* no está soportada para Defender for Cloud ni Defender for Office 365, pero **sí** para Defender for Endpoint; aun así no es la mejor respuesta porque el enunciado pide expresamente impedir el incidente y conservar el dato, que es la definición de *Hide alert*.
>
> **3 → A.** Esa combinación de acciones — activar plantillas **o** pasar a **basic logs** — corresponde exactamente a la tabla que **no usan las detecciones pero sí usan workbooks, log queries o hunting queries**: como algo la consume, la opción es abaratarla, no eliminarla. **B** es distinto: si no se usó en absoluto, la alternativa es **dejar de ingerir y eliminar la tabla o mover a retención a largo plazo**. **C** también es distinto: si solo la usó Azure Monitor, la alternativa es **mover a un workspace de Log Analytics no dedicado a seguridad**. **D** es directamente falso: si una tabla está elegida para UEBA o para una regla de matching de threat intelligence, SOC optimization **no recomienda ningún cambio de ingesta** sobre ella.
>
> **4 → C.** Sentinel usa una **cuenta de servicio especial** para ejecutar playbooks de trigger de incidente, y esa cuenta necesita **permisos explícitos sobre el resource group donde reside el playbook**. Para otorgarlos tú necesitas ser **Owner**. Consecuencia a recordar: una vez otorgados, **cualquier automation rule puede ejecutar cualquier playbook de ese resource group**. **A** confunde el sujeto (los permisos van a la cuenta de servicio, no al usuario creador) y el ámbito (resource group, no playbook individual). **B** asigna el rol equivocado sobre el recurso equivocado. **D** es falso: el playbook puede vivir en otro resource group, solo hay que dar los permisos correctos.
>
> **5 → B.** Los dos ajustes que filtran qué genera notificación son **Alert severity** (qué severidades disparan el aviso) y **Device group scope** (todos los device groups o una selección). Si la severidad está limitada a *High*, los incidentes de severidad media no notifican. **A** es irrelevante: *Include tenant-specific portal link* solo añade un enlace con el tenant ID al cuerpo del correo. **C** invierte el comportamiento documentado: los destinatarios nuevos **sí** empiezan a recibir notificaciones a partir de que se añaden; lo que no reciben son los incidentes anteriores. **D** confunde rutas: en *Settings > Endpoints > General > Email notifications* se configuran las notificaciones de **vulnerabilidades**, no las de incidentes.

---

## ⚠️ Trampas del examen en los temas de hoy

1. **Workbook ≠ playbook.** Visualizar/reportar → workbook. Ejecutar una acción → playbook. Es tu fallo repetido: verbo delator en el enunciado.
2. **Guardar un workbook guarda solo el JSON**, nunca los datos. No duplica almacenamiento ni ingesta.
3. **Crear workbooks pide dos roles**: un rol de Sentinel **+ Workbook Contributor**.
4. **Ningún rol de Sentinel crea o edita playbooks** — eso es **Logic App Contributor**. Y **Sentinel Contributor no los ejecuta** — eso es **Playbook Operator**.
5. **Automation rule → playbook: permisos sobre el resource group del playbook, a la cuenta de servicio.** Nunca sobre el playbook suelto.
6. **Las asignaciones de rol son acumulativas.** Añadir un rol restrictivo no quita permisos.
7. **SIEM = Azure RBAC. Data lake = roles de Microsoft Entra ID.** No los mezcles.
8. **Data value optimization solo mira tablas facturables con ingesta en los últimos 30 días**, y **nunca** toca tablas usadas por UEBA o por matching de threat intelligence.
9. **Threat-based razona desde el ataque; risk-based razona desde el daño al negocio** (operacional, financiero, reputacional, cumplimiento, legal).
10. **Hide alert es solo de Defender for Endpoint**; **Set as behavior no va en Defender for Cloud ni Defender for Office 365**.
11. **Alert suppression no funciona con custom detections** — ahí hay que afinar la propia detección.
12. **Notificaciones de incidentes** → Settings > **Microsoft Defender XDR**. **Notificaciones de vulnerabilidades** → Settings > **Endpoints**. Rutas distintas.
13. **Informational, expected activity ≠ False positive.** La primera es una alerta correcta sobre actividad benigna; la segunda es una alerta incorrecta.
14. **Alerta individual de producto → `SecurityAlert`. Incidente correlacionado de Sentinel → `SecurityIncident`.** (Y `SecurityIncident` guarda **una fila por actualización**: usa `summarize arg_max(LastModifiedTime, *) by IncidentNumber` para el estado final.)

---

## 🔗 Notas relacionadas

- [[Dia 06 - AIR Attack Disruption Automation Rules y Playbooks]] — automation rules y playbooks, cuyos permisos se detallan hoy
- [[Dia 05 - Configuracion Avanzada de MDE ASR Rules Advanced Features Device Groups y Custom Data Collection]] — device groups, que son el ámbito de las notificaciones y del alert tuning
- [[Dia 04 - Detecciones Sentinel Analytics Rules y Anomalias]] — analytics rules y MITRE, que es lo que SOC optimization evalúa
- [[Dia 01 - Arquitectura Sentinel y Tiers de Retencion]] — workspace, tiers y data lake
- [[GUIA_INTENSIVA_24_DIAS]] · [[TRACKER_TUTOR]] · [[CHEATSHEET_KQL]]

## 📚 Fuentes verificadas hoy (29-jul-2026)

- [Study guide for Exam SC-200](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/sc-200) — skills measured as of July 28, 2026
- [Visualize your data using workbooks in Microsoft Sentinel](https://learn.microsoft.com/en-us/azure/sentinel/monitor-your-data) — doc actualizado 24-jun-2026
- [SOC optimization reference](https://learn.microsoft.com/en-us/azure/sentinel/soc-optimization/soc-optimization-reference) — doc actualizado 3-may-2026
- [Roles and permissions in the Microsoft Sentinel platform](https://learn.microsoft.com/en-us/azure/sentinel/roles) — doc actualizado 14-may-2026
- [Get incident notifications by email — Microsoft Defender XDR](https://learn.microsoft.com/en-us/defender-xdr/m365d-notifications-incidents) — doc actualizado 25-jun-2026
- [Configure vulnerability email notifications](https://learn.microsoft.com/en-us/defender-endpoint/configure-vulnerability-email-notifications) — doc actualizado 29-jul-2026
- [Investigate alerts in Microsoft Defender XDR](https://learn.microsoft.com/en-us/defender-xdr/investigate-alerts) — doc actualizado 28-jul-2026
- [Go to the Action center](https://learn.microsoft.com/en-us/defender-xdr/m365d-action-center) — doc actualizado 6-jul-2026
