---
tags: [sc-200, sentinel, hunting, bookmarks, hunts, kql, leccion-diaria]
dia: 16
fecha: 2026-09-11
fecha_programada: 2026-08-31
dominio: "Dominio 3 — Perform threat hunting (20-25%)"
estado: 🟡 En curso
cover: ""
---

# Lección Día 16 — Hunting en Microsoft Sentinel: Queries, Bookmarks y Hunts

> [!info] Contexto
> Día 16 del plan de [[PLAN_MAESTRO_MULTITRACK]], dentro del **Dominio 3 — Perform threat hunting (20-25% del examen)**, que arrancó el Día 15 con custom detections y hunting graph. Hoy cubre la otra mitad de "hunting" que pide el temario: la **experiencia de hunting nativa de Microsoft Sentinel** — hunting queries basadas en hipótesis, bookmarks para preservar hallazgos, y la función **Hunts** que organiza todo eso en una investigación estructurada de principio a fin.
>
> **Nota de calendario, sin maquillar:** este día estaba programado para el lunes 31-ago según [[PLAN_MAESTRO_MULTITRACK]] §8.3. Se retoma hoy, viernes 11-sep, con **11 días de retraso real** — los Días 16, 17, 18 y el Simulacro #2 nunca se dieron. El detalle completo y la reconciliación del calendario quedan documentados al cierre de esta sesión en [[TRACKER_TUTOR]] y en el plan maestro; aquí solo queda dicho con honestidad antes de empezar, porque es el mismo patrón que ya generó tres reanclajes anteriores. Lo que cambia hoy: liberaste tu horario, con **3 horas disponibles ahora mismo y ~1 hora diaria de aquí al examen** (fijo, sábado 3-oct, quedan 22 días). Eso alcanza para retomar el ritmo sin comprimir contenido — hoy se cubre el Día 16 completo, bien hecho, sin forzar cantidad.

---

## 📖 Lectura del día

### 0. Dónde estamos y por qué esto es distinto de Advanced Hunting

El Día 15 cubrió **Advanced Hunting**: el motor de búsqueda KQL (Kusto Query Language) dentro del portal unificado de Defender (`security.microsoft.com`), que combina datos de Defender XDR y de Sentinel en una sola experiencia de consulta, y a partir del cual construiste custom detection rules.

Hoy el foco es distinto: la **experiencia de hunting que vive específicamente dentro de Microsoft Sentinel** — la pestaña **Threat management → Hunting**, disponible tanto en el portal de Azure (`portal.azure.com`) como, con matices que vas a ver hoy, dentro de Microsoft Sentinel en el portal de Defender. No son dos productos distintos compitiendo entre sí: son dos experiencias con propósitos algo diferentes que comparten el mismo lenguaje (KQL) y, en varios puntos, los mismos datos.

**Verificado hoy en Microsoft Learn** (`hunting`, ms.date 1-jul-2026, actualizado 8-ago-2026): hay una diferencia funcional importante entre ambas que el examen puede usar como distractor — **los bookmarks (la pieza central de hoy) NO existen en Advanced Hunting.** Solo existen en la experiencia de Hunting específica de Sentinel. Si un enunciado describe "preservar una fila de resultados con notas y tags para revisarla después", la respuesta nunca es Advanced Hunting por sí solo — es la función de bookmarks de Sentinel.

| Experiencia | Dónde vive | Combina datos de | ¿Tiene bookmarks? |
|---|---|---|---|
| **Advanced Hunting** (Día 15) | Portal de Defender, `security.microsoft.com` | Defender XDR + Sentinel en una sola query | No |
| **Hunting de Sentinel** (hoy) | Portal de Azure y Microsoft Sentinel dentro del portal de Defender | Datos ya ingeridos en el workspace de Log Analytics | Sí |

### 1. Hunting queries: el punto de entrada de una investigación proactiva

Una **hunting query** (query de caza de amenazas) es, técnicamente, una query de KQL igual que cualquier otra — la diferencia no está en la sintaxis, está en el propósito: en vez de confirmar una alerta que ya se disparó, la usas para **buscar proactivamente** patrones sospechosos que tus reglas automatizadas todavía no detectan. El ejemplo clásico que da la propia documentación: una query que muestra los procesos menos comunes de tu infraestructura. No querrías una alerta cada vez que corre un proceso poco común — la mayoría son inocentes — pero de vez en cuando vale la pena revisarla manualmente para ver si algo destaca.

**Dónde se accede:** en Sentinel dentro del portal de Defender, **Threat management → Hunting → pestaña Queries**. Ahí ves dos tipos de queries:

- **Queries integradas (out of the box):** vienen instaladas con las soluciones que agregas desde el **Content hub** (el catálogo de soluciones de Sentinel). Investigadores de seguridad de Microsoft las mantienen y actualizan continuamente.
- **Queries personalizadas:** las que tú creas o modificas, guardables como propias o compartibles con todo tu tenant.

**Cómo se usa la pestaña Queries en la práctica, verificado hoy:**

| Acción | Qué hace |
|---|---|
| **Run all queries** / **Run selected queries** | Ejecuta todas las queries o solo las que marcaste. Puede tardar segundos o varios minutos según el volumen |
| **Filtrar por Results** | Ordena por cuáles devolvieron más o menos resultados; filtra por `N/A` para ver las que necesitan una fuente de datos que todavía no tienes conectada |
| **Results delta / Results delta percentage** | Compara los resultados de las últimas 24h contra las 24-48h anteriores — el indicador más directo de "algo cambió aquí" |
| **Filtrar por táctica/técnica MITRE ATT&CK** | Las queries se agrupan automáticamente por táctica MITRE; puedes ver qué técnicas tienen o no cobertura de hunting queries |
| **Save a query to favorites** | Las queries favoritas corren automáticamente cada vez que abres la página de Hunting |
| **View query results** | Abre los resultados en el panel de **Logs** (Log Analytics) — desde ahí, y solo desde ahí, puedes crear un bookmark |

**Cuándo usar hunting queries, según el propio Microsoft Learn:** antes de un incidente (proactivamente, al menos una vez por semana, para detectar zonas débiles antes de que las exploten), durante un compromiso activo (monitorear el siguiente movimiento del atacante), y después de un incidente (mejorar la cobertura con lo aprendido — si una query mostró tener valor real, conviértela en una custom analytics rule, exactamente el flujo que ya viste el Día 4 y el Día 15).

### 2. Bookmarks: preservar lo que encontraste

Cazar amenazas implica revisar montañas de datos. Cuando encuentras una fila que parece relevante — un proceso raro, una IP sospechosa, un patrón de login fuera de horario — necesitas una forma de **preservarla** sin depender de tu memoria ni de volver a correr la query exacta con el mismo rango de tiempo. Para eso existe el **bookmark**.

**Cómo se crea, verificado hoy en Microsoft Learn** (`bookmarks`, ms.date 1-jul-2026, actualizado 8-ago-2026):

1. Corres una hunting query y seleccionas **View query results**, lo que abre el panel de **Logs**.
2. Marcas el checkbox de las filas que te interesan.
3. Seleccionas **Add bookmark**. Esto crea un bookmark por cada fila marcada, con el resultado de esa fila **y** la query que lo generó.
4. Opcionalmente agregas nombre, tags, notas, mapeo de entidades (igual que en las analytics rules) y técnicas/tácticas MITRE ATT&CK — por defecto heredan el mapeo de la query que los generó.

**El detalle de "mapa" más importante de hoy, y el tipo de dato que este curso ya midió como punto débil recurrente (ubicación exacta de dónde vive cada función, no el concepto):**

> [!warning] Bookmarks: solo se crean en el portal de Azure
> **Solo puedes CREAR bookmarks nuevos en el portal de Azure**, dentro de Microsoft Sentinel → Threat management → Hunting. **En el portal de Defender puedes VER los bookmarks que ya existen, pero no puedes crear ninguno nuevo desde ahí.** Es una restricción real de la plataforma, verificada hoy contra la documentación oficial (no un capricho de configuración) — y es exactamente el tipo de trampa "ubicación de portal" que ya te costó puntos en el Día 7 (workbooks) y en el Día 5 de hoy hace eco: sabes qué hace la función, el examen prueba si sabes dónde vive.

**Qué puedes hacer con un bookmark ya creado:**

- **Verlo en la pestaña Bookmarks** de la página Hunting, con filtros por tag (útil para agrupar todos los bookmarks de una campaña de investigación bajo el mismo tag).
- **Investigarlo** en el **investigation graph** (grafo de investigación, un diagrama interactivo de entidades y su timeline) — pero **requiere que el bookmark tenga al menos una entidad mapeada**; sin eso, la opción de investigar no muestra nada útil.
- **Escalarlo a un incidente:** desde la pestaña Bookmarks, seleccionas uno o varios bookmarks y usas **Incident actions → Create new incident** o **Add to existing incident**. Es la vía formal para convertir un hallazgo de hunting en algo que el SOC (Security Operations Center) trabaja como incidente reglado.
- **Consultarlo en crudo vía KQL:** todos los bookmarks viven en la tabla **`HuntingBookmark`** de tu workspace de Log Analytics. Puedes filtrarla, resumirla, o cruzarla (`join`) con otras tablas para buscar evidencia corroborante.
- **Borrarlo:** lo quita de la pestaña Bookmarks, pero la tabla `HuntingBookmark` conserva el historial — la fila más reciente pasa a tener `SoftDelete == true` en vez de desaparecer físicamente.

### 3. La función Hunts: organizar una investigación completa, no solo una query suelta

Hasta aquí, cada query y cada bookmark viven algo sueltos entre sí. Cuando una investigación crece — varias hipótesis, decenas de queries, docenas de bookmarks — necesitas un contenedor que mantenga todo junto, con contexto persistente. Para eso existe **Hunts**, verificado hoy contra Microsoft Learn como **función en preview** (`hunts`, ms.date 1-jul-2026, actualizado 8-ago-2026).

**Qué resuelve un Hunt, en palabras del propio Microsoft Learn:** te deja conducir la investigación con **múltiples pestañas de queries persistidas** (para no perder el contexto con el tiempo), recolectar evidencia e investigar fuentes de **UEBA** (User and Entity Behavior Analytics, el análisis de comportamiento de usuarios y entidades) mediante bookmarks propios del hunt, colaborar con comentarios, actuar sobre los resultados creando analytics rules / incidentes / indicadores de threat intelligence, y **medir el impacto** de tu programa de hunting con una barra de métricas.

**El ciclo completo, paso a paso:**

**Paso 1 — Definir la hipótesis.** Es un proceso abierto y flexible. Microsoft Learn da tres puntos de partida típicos, cada uno con su propio flujo recomendado:

| Tipo de hipótesis | De dónde parte | Cómo arrancar |
|---|---|---|
| **Comportamiento sospechoso** | Algo visible en tu entorno que quieres confirmar si es un ataque | Pestaña Queries → **Run All queries** → filtrar por resultados distintos de `N/A`/`0` → ordenar por **Results Delta** |
| **Nueva campaña de amenaza** | Una amenaza recién conocida (noticia, feed de threat intel) | Instalar una solución específica desde el **Content Hub** (ej. detección de una vulnerabilidad concreta) → correr sus queries |
| **Brecha de detección** | Un hueco identificado en tu cobertura MITRE ATT&CK | Página **MITRE ATT&CK (Preview)** → filtrar por técnicas sin "Hunting queries" asociadas → partir de ahí |

**Paso 2 — Crear el hunt.** Dos caminos: (a) si ya seleccionaste queries relacionadas con tu hipótesis, usas **Hunt actions → Create new hunt** y esas queries se clonan automáticamente dentro del hunt nuevo; (b) si todavía no decidiste queries, usas **Hunts (Preview) → New Hunt** para crear un hunt en blanco y agregar queries después. Completas nombre, descripción (buen lugar para verbalizar la hipótesis) y el estado de la hipótesis.

**Paso 3 — Trabajar dentro del hunt.** Cada hunt tiene tres pestañas propias:

- **Queries:** las queries específicas de este hunt son **clones independientes** de las originales del workspace — editarlas o borrarlas aquí no afecta a la query general ni a la de otros hunts. Desde el menú contextual puedes Run, Edit, Clone, Delete, o **Create analytics rule** directamente (mismo flujo del Día 4/15, con nombre/descripción/KQL ya prellenados).
- **Bookmarks:** igual que los bookmarks generales, pero vinculados al hunt — mismo flujo de creación (seleccionar filas → Add bookmark), mismo requisito de entidad mapeada para verlos en el investigation graph.
- **Entities:** lista consolidada, sin duplicados, de todas las entidades recolectadas en los bookmarks del hunt. Desde ahí puedes ir a la página UEBA de una entidad o ejecutar un playbook específico de ese tipo de entidad (por ejemplo, agregar una IP directamente a Threat Intelligence).

**Paso 4 — Comentarios.** Espacio de colaboración dentro del propio hunt — puedes enlazar el resultado de una query como referencia para que un compañero entienda el contexto sin repetir la investigación.

**Paso 5 — Crear incidentes desde el hunt.** Dos rutas: desde la pestaña Bookmarks (igual que en el flujo general de bookmarks) o desde **Hunt Actions → Create incident**, que te deja elegir qué bookmarks del hunt incluir. El incidente resultante queda enlazado en la lista **Related incidents** del hunt.

**Paso 6 — Actualizar y cerrar.** A medida que avanza la investigación, actualizas el estado de la hipótesis (validada / no validada / en progreso) y, cuando ya creaste todas las analytics rules, incidentes o indicadores de TI que hacían falta, cierras el hunt. Ambos estados alimentan la **barra de métricas** de la pestaña Hunts (Preview): hipótesis validadas, incidentes nuevos creados, analytics rules nuevas creadas.

**Permiso necesario, verificado hoy:** rol de Azure **Microsoft Sentinel Contributor**, o un rol RBAC personalizado con permisos sobre el ámbito `Microsoft.SecurityInsights/hunts`. No basta con un rol de solo lectura como Sentinel Reader.

### 4. La trampa de examen más importante de hoy: Livestream ya no existe

Si estudiaste con cualquier guía o material anterior a marzo de 2026 — incluida la [[GUIA_INTENSIVA_24_DIAS]] de este mismo curso, que todavía lista "livestream" como tema del Día 16 — vas a encontrar la palabra **Livestream** descrita como "monitorea una hunting query en near-real-time y te notifica sin crear incidentes". Ese feature **fue retirado**.

> [!danger] Hallazgo crítico verificado hoy en Microsoft Learn
> La página oficial de Hunting (`hunting`, actualizada 8-ago-2026) lo dice explícitamente: **"Microsoft Sentinel livestreams are no longer available."** El retiro ocurrió **a mediados de marzo de 2026**. La alternativa recomendada oficialmente para automatizar queries y notificaciones es usar **analytics rules** (incluidas las NRT — Near Real-Time — que ya viste el Día 4), **KQL jobs** (que vas a ver a fondo el Día 17, dentro del Sentinel data lake) o **playbooks**. Este dato es ausente en [[GUIA_INTENSIVA_24_DIAS]] y en [[REPASO_RAPIDO_Errores_Simulacro]] (ítem 7 de esa nota todavía pregunta "¿Livestream genera alertas?") porque ambos se escribieron antes del retiro — no se editaron sin tu permiso explícito, queda avisado aquí y anotado en el tracker.

**Por qué esto es examinable, no solo trivia de producto:** el examen SC-200 tiene fecha de corte de contenido, y una pregunta que described "quieres monitoreo continuo sin generar incidentes" ya no puede tener a Livestream como respuesta correcta — el distractor correcto pasa a ser "usa una NRT analytics rule" o, si el escenario específicamente pide **no** generar ninguna alerta automática, la respuesta correcta es revisar manualmente la columna **Results delta** de la pestaña Queries (sección 1 de hoy), no ningún tipo de regla automatizada.

### 5. Tabla de decisión: el enunciado dice X → la respuesta/herramienta es Y

| El enunciado dice (calificador) | Herramienta / respuesta correcta | Por qué NO las demás |
|---|---|---|
| "Preservar una fila de resultados de una query, con notas y tags, para revisarla más tarde" | **Bookmark** (Add bookmark, desde el panel Logs) | Advanced Hunting no tiene bookmarks (sección 0); "guardar como favorita" preserva la query, no el resultado puntual |
| "Crear un bookmark nuevo desde el portal de Defender" | **No es posible** — hay que crearlo desde el portal de Azure | En el portal de Defender solo se pueden VER bookmarks ya creados, nunca crear uno nuevo |
| "Monitorear una query continuamente y recibir notificación cuando cambien los resultados, sin crear un incidente" | **NRT analytics rule** o **KQL job** (Día 17) — Livestream ya no existe | Livestream fue retirado desde marzo de 2026; sigue apareciendo en materiales viejos como trampa |
| "Organizar una investigación completa con hipótesis, varias queries persistentes y seguimiento de progreso a través del tiempo" | **Hunts (Preview)** — New hunt | Una query o un bookmark sueltos no mantienen el contexto agregado de una investigación completa; Hunts es el contenedor diseñado para eso |
| "Editar una query dentro de un hunt sin afectar la query general del workspace" | Se puede sin problema — las queries de un hunt son **clones independientes** | Un analista podría asumir erróneamente que edita la fuente compartida; no es así |
| "Identificar técnicas MITRE ATT&CK sin cobertura de hunting queries" | Página **MITRE ATT&CK (Preview)** → filtro de Hunting queries en Simulated | Las hunting queries individuales no muestran cobertura agregada por técnica; la vista MITRE sí |
| "Encontré un patrón valioso en una hunting query y quiero que dispare una alerta automáticamente de ahora en adelante" | **Create analytics rule** desde los resultados de la query (mismo flujo del Día 4/15) | Una hunting query nunca alerta por sí sola — necesita convertirse en analytics rule o custom detection |
| "Consultar en KQL todos mis bookmarks históricos, incluidos los ya borrados de la vista" | Tabla **`HuntingBookmark`** en Log Analytics, filtrando `SoftDelete` | La pestaña Bookmarks de la UI solo muestra hasta 1,000 activos; la tabla cruda conserva el historial completo |

---

## 💡 Ejemplos concretos

### Ejemplo 1 — De hipótesis a bookmark: detectar logons fuera de horario

**Escenario:** El SOC de Contoso sospecha que una cuenta administrativa puede estar comprometida, porque las alertas automáticas configuradas hasta ahora solo cubren fuerza bruta, no uso anómalo de una cuenta ya autenticada. Se decide una hunting query manual como primer paso.

**Razonamiento:** es exactamente el tipo de hipótesis "comportamiento sospechoso" de la sección 3 — parte de algo visible (la preocupación por la cuenta) sin esperar a que dispare una alerta ya existente. La query corre sobre `SecurityEvent`, la misma tabla que ya usaste desde el Día 2 (ingerida vía AMA — Azure Monitor Agent).

```kql
// Hunting query: logons interactivos fuera de horario laboral (00:00-06:00 o después de 22:00)
SecurityEvent
| where EventID == 4624          // logon exitoso
| where LogonType in (2, 10)     // 2 = interactivo, 10 = RDP/RemoteInteractive
| extend HourOfDay = datetime_part("Hour", TimeGenerated)
| where HourOfDay < 6 or HourOfDay > 22
| project TimeGenerated, Account, Computer, LogonType, IpAddress, HourOfDay
| order by TimeGenerated desc
```

El analista corre la query desde la pestaña Queries, selecciona **View query results**, y encuentra una fila con la cuenta administrativa haciendo login interactivo a las 3:14 AM desde una IP que no reconoce. Marca el checkbox de esa fila y selecciona **Add bookmark**, agrega la nota "IP no reconocida, fuera de horario — validar con el usuario antes de escalar" y mapea la entidad `Account` y la entidad `IP address`. Como el bookmark quedó con al menos una entidad mapeada, puede abrirlo en el investigation graph para ver rápidamente si esa misma cuenta o IP aparece en otros eventos correlacionados del workspace.

### Ejemplo 2 — Un Hunt completo desde una brecha de detección MITRE

**Escenario:** Durante una revisión trimestral, el equipo de Contoso quiere saber si tienen cobertura de hunting queries para la técnica **Kerberoasting** (ya vista el Día 11, dentro de MDI) fuera del propio Defender for Identity — es decir, si Sentinel tiene alguna forma independiente de detectarlo sobre los logs de seguridad ya ingeridos.

**Razonamiento:** es la hipótesis "brecha de detección" de la sección 3. El analista va a la página **MITRE ATT&CK (Preview)**, filtra la vista **Simulated** por "Hunting queries" para ver qué técnicas sí tienen queries asociadas, y confirma que Kerberoasting no aparece cubierta. Selecciona la tarjeta de la técnica y, si no hay ninguna query lista para clonar, decide construir una desde cero.

En vez de trabajar con una query suelta, crea un **Hunt** nuevo (**Hunts (Preview) → New Hunt**) llamado "Cobertura Kerberoasting - Sentinel", describe la hipótesis ("Contoso no tiene visibilidad de solicitudes TGS anómalas de tickets Kerberos fuera de MDI"), y agrega la query nueva a la pestaña Queries del hunt. Corre la query, bookmarkea los hallazgos relevantes, y usa la pestaña Entities para revisar de forma centralizada qué cuentas de servicio aparecieron marcadas en más de un bookmark — un patrón que sería fácil de perder revisando bookmarks sueltos uno por uno. Al validar la hipótesis (encontró cuentas de servicio con SPNs débiles), usa **Create analytics rule** desde la query del hunt para convertirla en detección automática permanente, y cierra el hunt marcando la hipótesis como validada — la barra de métricas de Hunts suma una analytics rule nueva a su conteo.

### Ejemplo 3 — Resolver la trampa de Livestream con la alternativa correcta

**Escenario:** Un enunciado de práctica (redactado con vocabulario de una guía vieja) dice: *"Configura Livestream sobre una hunting query para recibir una notificación cada vez que aparezca una nueva coincidencia, sin generar un incidente."*

**Razonamiento:** el enunciado describe con precisión lo que Livestream hacía — pero Livestream ya no existe (sección 4). La respuesta correcta hoy depende de un matiz que el propio enunciado no aclara del todo: si "notificación" implica generar una alerta automática, la vía correcta es una **NRT analytics rule** (Día 4) cuya query cumpla los requisitos de elegibilidad ya vistos el Día 15 (una sola tabla, sin `join`/`union`, sin comentarios). Si en cambio el objetivo es monitoreo puramente manual sin ninguna alerta — el "sin generar un incidente" del enunciado empuja hacia esa lectura — la vía correcta es simplemente **guardar la query como favorita** y revisar periódicamente la columna **Results delta** en la pestaña Queries, que ya te muestra si aparecieron resultados nuevos en las últimas 24 horas sin que nada se dispare automáticamente. Ninguna de las dos vías se llama "Livestream", y reconocer eso — no solo saber para qué servía Livestream — es lo que el examen puede estar probando si el escenario usa terminología retirada a propósito.

---

## 🎥 Videos

1. **[Perform threat hunting in Microsoft Sentinel | SC-200 | Episode 10](https://www.youtube.com/watch?v=z6QbN4rpAvA)** — episodio de la serie oficial "SC-200: Defend against cyberthreats with Microsoft's security operations platform" (parte de la playlist oficial vinculada desde el propio Microsoft Learn training path del Dominio 3). Actualizado el 4-may-2026. No pude confirmar la duración exacta desde la búsqueda — los episodios de esta serie suelen rondar 10-20 minutos; si al abrirlo resulta muy distinto, avísame para corregir el dato. Cubre el flujo clásico de hunting queries + bookmarks; es razonablemente probable que **no** cubra todavía la función Hunts (Preview), que es más reciente — compénsalo con la lectura de la sección 3 de hoy.
2. **Sobre la función Hunts (Preview) específicamente:** búsqueda verificada hoy sin resultado de un video reciente y dedicado — es un feature demasiado nuevo (documentación con `ms.date` de julio de 2026) para tener cobertura amplia en video todavía. En su lugar, usa el módulo oficial de Microsoft Learn **[Conduct end-to-end proactive threat hunting in Microsoft Sentinel](https://learn.microsoft.com/en-us/azure/sentinel/hunts)** — es la misma fuente verificada hoy para escribir la sección 3 completa.

> [!note] Honestidad sobre la búsqueda de video de hoy
> Mismo patrón que en los Días 13 y 15: prefiero decir con claridad que no hay un video reciente dedicado a Hunts en vez de forzar un enlace de relleno que traiga un dato ya desactualizado — es justo el área que más cambió recientemente (retiro de Livestream en marzo-2026, función Hunts todavía en preview).

---

## 🧪 Ejercicio práctico

> [!note] Este lab usa tu workspace de Sentinel ya existente (Azure for Students)
> La pestaña Hunting vive dentro del mismo workspace de Log Analytics + Sentinel que configuraste desde el Día 1, en `portal.azure.com` (no el trial M365 E5 de los labs de MDE/MDO). Ya tienes datos reales corriendo ahí desde el Día 2 (`SecurityEvent` vía AMA) — suficiente para practicar hunting queries y bookmarks de verdad, sin depender de datos simulados. Recuerda: **los bookmarks solo se crean desde el portal de Azure**, así que haz todo el lab ahí, no en `security.microsoft.com`.

- [ ] **Paso 1 — Correr la query del Ejemplo 1.** En Microsoft Sentinel → Threat management → Hunting → Queries, crea una query personalizada con el KQL de la sección de ejemplos (ajusta el rango horario si tu VM no tiene logons recientes fuera de horario — puedes simular uno con un RDP de prueba, o simplemente usar cualquier filtro que devuelva resultados de tu `SecurityEvent` real).
- [ ] **Paso 2 — Crear un bookmark real.** Desde View query results, marca al menos una fila, selecciona Add bookmark, y complétalo con nota, tag y al menos una entidad mapeada (Account o IP).
- [ ] **Paso 3 — Confirmar la restricción de portal.** Abre Microsoft Sentinel dentro del portal de Defender (`security.microsoft.com` → Microsoft Sentinel → Hunting → Bookmarks) y confirma que ves el bookmark que acabas de crear, pero que no aparece la opción de crear uno nuevo ahí — es la confirmación práctica de la sección 2 de hoy.
- [ ] **Paso 4 — Consultar `HuntingBookmark` directamente.** En Logs, corre `HuntingBookmark | take 10` y revisa las columnas — confirma que ahí vive el dato crudo del bookmark que creaste.
- [ ] **Paso 5 — Crear un Hunt (si tu suscripción ya muestra la pestaña Hunts (Preview)).** Si aparece, crea un hunt en blanco, agrégale la query del Paso 1, corre la query dentro del hunt y confirma en la pestaña Queries del hunt que es un clon independiente (edítala ligeramente y verifica que la query general de la sección Queries del workspace no cambió). Si tu suscripción todavía no tiene Hunts habilitado (es razonable, sigue en preview), documenta el flujo como paso teórico usando las capturas del artículo de Microsoft Learn.
- [ ] **Paso 6 —** responde el quiz de hoy y el repaso acumulativo.

---

## ✅ Quiz del día

Cinco preguntas sobre el contenido nuevo de hoy. Responde antes de abrir el bloque de respuestas.

**1.** ¿En qué portal puedes CREAR una nueva hunting bookmark en Microsoft Sentinel?

- A) Solo en el portal de Defender (security.microsoft.com), nunca en el portal de Azure
- B) Solo en el portal de Azure (portal.azure.com); en el portal de Defender solo puedes verlas
- C) En cualquiera de los dos portales indistintamente, sin restricción
- D) En ninguno de los dos directamente; se crean solo por API o PowerShell

**2.** Un analista, guiándose por una guía de estudio antigua, busca la opción "Livestream" en la página de Hunting para monitorear una query en near-real-time sin crear incidentes. ¿Qué es correcto hoy?

- A) Livestream sigue disponible sin cambios en ambos portales
- B) Livestream ahora se llama "Live monitor" y vive dentro de la pestaña Hunts
- C) Livestream fue retirado desde mediados de marzo de 2026; la alternativa recomendada es una analytics rule (incluida NRT) o un KQL job
- D) Livestream sigue activo, pero solo si el tenant tiene el Sentinel data lake habilitado

**3.** Un analista agrega una hunting query existente a un Hunt nuevo y edita el filtro de esa copia dentro del hunt. ¿Qué ocurre con la query original en la pestaña general Queries de Hunting, fuera del hunt?

- A) No se modifica: las queries dentro de un hunt son clones independientes del resto del workspace
- B) Se actualiza automáticamente, porque los hunts comparten instancia con las queries generales
- C) Se elimina de la pestaña general en cuanto se agrega a un hunt
- D) Queda bloqueada para edición hasta que el hunt se cierre

**4.** ¿Qué permiso mínimo, verificado en la documentación oficial, necesita un analista para usar la función Hunts en Microsoft Sentinel?

- A) Rol de Entra ID Global Reader, sin necesidad de ningún rol de Azure
- B) Rol de Microsoft Sentinel Reader es suficiente, porque Hunts solo lee datos
- C) Licencia de Microsoft Defender for Cloud Apps además del rol de Sentinel
- D) Rol de Azure Microsoft Sentinel Contributor, o un rol RBAC personalizado con permisos sobre Microsoft.SecurityInsights/hunts

**5.** Un analista quiere abrir uno de sus bookmarks en el investigation graph para visualizar entidades relacionadas. ¿Qué requisito debe cumplir el bookmark para poder hacerlo?

- A) Debe tener al menos un tag asignado
- B) Debe tener al menos una entidad mapeada
- C) Debe estar vinculado ya a un incidente existente
- D) Debe haberse creado desde una query elegible para Continuous (NRT)

> [!note]- Ver respuestas
> **1 — B.** Verificado hoy: los bookmarks solo se crean en el portal de Azure, bajo Microsoft Sentinel → Threat management → Hunting. **A** es al revés. **C** es falso — hay una restricción real de plataforma, no es indistinto. **D** es falso, la UI del portal de Azure sí permite crearlos directamente.
>
> **2 — C.** Confirmado en la documentación oficial actualizada el 8-ago-2026: Livestream se retiró a mediados de marzo de 2026. Las alternativas oficiales son analytics rules (incluida NRT), KQL jobs o playbooks. **A** y **D** son falsos — ya no está disponible en ningún caso. **B** inventa un nombre que no existe en la documentación.
>
> **3 — A.** Las queries dentro de un hunt son clones independientes de las del workspace general — editarlas ahí no afecta a la original ni a las de otros hunts. **B** y **C** describen un comportamiento que no existe. **D** tampoco: nada se bloquea por tener un hunt abierto.
>
> **4 — D.** Verificado hoy: se necesita el rol de Azure Microsoft Sentinel Contributor o un rol RBAC personalizado con permisos sobre el ámbito Microsoft.SecurityInsights/hunts. **A** no es un rol de Azure aplicable a este recurso. **B** es falso — un rol de solo lectura no alcanza para crear y gestionar hunts. **C** mezcla un producto sin relación (MDCA) con el requisito real.
>
> **5 — B.** El bookmark necesita al menos una entidad mapeada para poder visualizarse en el investigation graph — sin eso, no hay nada que el grafo pueda dibujar. **A** (tag) es útil para filtrar, no es requisito del grafo. **C** es falso — puedes investigar un bookmark sin que esté vinculado todavía a ningún incidente. **D** confunde un requisito de custom detection rules (Día 15) con uno de bookmarks, dos features distintas.

---

## 🔁 Repaso acumulativo — re-test espaciado

Cuatro preguntas que re-testean puntos ya medidos en sesiones anteriores.

**R1.** Un analista necesita revisar qué procesos y conexiones ocurrieron en un dispositivo específico en los minutos ANTES de que se disparara una alerta, sin necesidad de escribir una query. ¿Qué usa?

- A) Timeline del dispositivo
- B) Advanced Hunting
- C) Live response
- D) Collect investigation package

**R2.** Un analista crea un bookmark desde una hunting query y luego, desde la pestaña Bookmarks, selecciona "Create new incident". Días después, quiere consultar en KQL el incidente resultante para ver su severidad actual. ¿Qué tabla usa?

- A) SecurityAlert
- B) HuntingBookmark
- C) SecurityIncident
- D) AlertEvidence

**R3.** Durante una hunting query sobre Graph activity logs, el analista necesita correlacionar varias llamadas hechas por el MISMO token de acceso, usando la tabla que sí trae esa columna. ¿Qué columna usa?

- A) OperationId
- B) UniqueTokenIdentifier
- C) AccountObjectId
- D) SignInActivityId

**R4.** Un analista escribe una hunting query que necesita apilar (combinar en un solo resultado, sin cruzar columnas) los registros de dos tablas distintas de logon. ¿Qué operador de KQL usa?

- A) join
- B) union
- C) summarize
- D) extend

> [!note]- Ver respuestas
> **R1 — A.** Otro ángulo del bloque más débil del curso (Timeline vs Advanced Hunting vs Live response vs Isolate vs Collect investigation package): "antes de la alerta, sin escribir query" apunta directo a Timeline, la vista cronológica ya lista del dispositivo. **B** (Advanced Hunting) exige escribir una query — el enunciado lo descarta explícitamente. **C** (Live response) es interacción en vivo, no revisión de eventos pasados. **D** (Collect investigation package) recolecta un ZIP para análisis externo, no te deja "revisar" en pantalla directamente.
>
> **R2 — C.** Regla fijada desde el Día 6 y reforzada muchas veces desde entonces: incidente correlacionado de Sentinel → `SecurityIncident`. **A** (`SecurityAlert`) es para alertas individuales de producto, no incidentes. **B** (`HuntingBookmark`) tiene el bookmark original, no el estado del incidente creado a partir de él. **D** (`AlertEvidence`) trae entidades relacionadas a una alerta, no el estado del incidente.
>
> **R3 — D.** Primer retest formal del dato de esquema del Día 13: `SignInActivityId` es la columna que correlaciona múltiples eventos del mismo token/sesión completa en `MicrosoftGraphActivityLogs`. **A** (`OperationId`) identifica una operación individual, no la sesión completa. **B** es una columna inventada, no existe en el esquema real. **C** (`AccountObjectId`) identifica la cuenta, no el token específico usado.
>
> **R4 — B.** Retest del Día 15 (sección 1, ítem 22 de [[REPASO_RAPIDO_Errores_Simulacro]]): `union` apila filas de varias tablas sin cruzar columnas. **A** (`join`) cruza columnas entre dos tablas por una clave común — es para relacionar, no para apilar. **C** (`summarize`) agrega resultados, no combina tablas. **D** (`extend`) crea columnas calculadas, tampoco combina tablas.

---

## ⚠️ Trampas del examen en los temas de hoy

1. **Livestream ya no existe** (retirado desde marzo de 2026) — si aparece en un enunciado con lenguaje de guía vieja, la respuesta correcta es NRT analytics rule, KQL job o playbook, nunca "Livestream".
2. **Bookmarks solo se crean en el portal de Azure** — el portal de Defender solo permite verlos, nunca crearlos.
3. **Advanced Hunting no tiene bookmarks** — es exclusivo de la experiencia de Hunting de Sentinel.
4. **Las queries dentro de un Hunt son clones independientes** — editarlas no afecta a la query general del workspace ni a las de otros hunts.
5. **Un bookmark necesita al menos una entidad mapeada** para poder abrirse en el investigation graph.
6. **Hunts (Preview) exige Microsoft Sentinel Contributor** (o RBAC personalizado sobre `Microsoft.SecurityInsights/hunts`) — un rol de solo lectura no alcanza.
7. **`HuntingBookmark` conserva el historial aunque borres un bookmark** — la última fila pasa a `SoftDelete == true` en vez de desaparecer.
8. **"Results delta" no es una alerta** — es una columna de la pestaña Queries que compara volumen de resultados entre periodos; sirve para revisión manual, no dispara nada automáticamente.

---

## 🔗 Notas relacionadas

- [[Dia 02 - Ingestion 1 AMA DCR Windows Security Events y WEF]] — origen de la tabla `SecurityEvent`, usada en el Ejemplo 1 de hoy
- [[Dia 04 - Detecciones Sentinel Analytics Rules y Anomalias]] — Scheduled/NRT analytics rules, la alternativa vigente a Livestream
- [[Dia 11 - Identidades Entra ID Protection y MDI]] — origen de Kerberoasting, usado en el Ejemplo 2 de hoy
- [[Dia 13 - Purview Audit eDiscovery Graph Activity Logs y Copilot Embebido]] — origen de `SignInActivityId`, retesteado hoy en R3
- [[Dia 15 - Repaso KQL Advanced Hunting Custom Detections y Hunting Graph]] — custom detection rules y el flujo "convertir hunting query en analytics rule", extendido hoy con Hunts
- [[REPASO_RAPIDO_Errores_Simulacro]] — el ítem 7-8 sobre Livestream de esa nota queda desactualizado por el retiro de hoy; no se editó sin permiso explícito, avisado aquí y en el tracker
- [[PLAN_MAESTRO_MULTITRACK]] — calendario vigente, examen 3-oct-2026 fijo, reconciliación del atraso real documentada al cierre de esta sesión
- [[TRACKER_TUTOR]]

## 📚 Fuentes verificadas hoy (11-sep-2026)

- [Hunting Capabilities in Microsoft Sentinel](https://learn.microsoft.com/en-us/azure/sentinel/hunting) — ms.date 1-jul-2026, actualizado 8-ago-2026, fuente principal de las secciones 1, 2 y 4 (hunting queries, bookmarks, retiro de Livestream)
- [Hunt with bookmarks in Microsoft Sentinel](https://learn.microsoft.com/en-us/azure/sentinel/bookmarks) — ms.date 1-jul-2026, actualizado 8-ago-2026, fuente de la sección 2 (flujo completo de creación/gestión de bookmarks, restricción de portal, tabla `HuntingBookmark`)
- [Conduct End-to-end Threat Hunting with Hunts](https://learn.microsoft.com/en-us/azure/sentinel/hunts) — ms.date 1-jul-2026, actualizado 8-ago-2026, fuente de la sección 3 completa (hipótesis, creación de hunt, pestañas Queries/Bookmarks/Entities, permisos, métricas)
- Búsqueda verificada: el retiro de Livestream se anunció para mediados de marzo de 2026, coherente con el aviso vigente en la documentación de hunting al día de hoy

---

> [!tip] Orden de consumo de hoy (fijado el 24-ago, ver [[PLAN_MAESTRO_MULTITRACK]] §7.7)
> 🎧 Escucha primero el Audio Overview de esta lección en NotebookLM (si ya lo generaste) → 📖 luego lee esta nota completa, con foco en la sección 2 (restricción de portal de bookmarks) y la sección 4 (retiro de Livestream) → ✅ y cierra con el quiz. Escuchar no sustituye leer, y leer no sustituye el quiz — el día se cierra con el quiz respondido, no antes.
