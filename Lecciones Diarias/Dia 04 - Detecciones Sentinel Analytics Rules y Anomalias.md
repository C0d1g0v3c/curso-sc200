---
tags: [sc-200, sentinel, leccion-diaria, analytics-rules, nrt, fusion, anomalias, mitre-attack]
dia: 4
fecha: 2026-07-13
dominio: "Dominio 1 — Manage a security operations environment (40-45%)"
estado: ✅ Completada
cover: ""
---

# Lección Día 4 — Detecciones en Sentinel: analytics rules, anomalías y cobertura MITRE

> [!info] Contexto
> Día 4 del plan de [[GUIA_INTENSIVA_24_DIAS]] (Dominio 1 — Manage a security operations environment, 40–45% del examen). En el calendario original este día caía el jueves 10 de julio; lo retomamos hoy 13 de julio porque es el siguiente tema sin completar (los Días 5 y 6, ASR/MDE y AIR/attack disruption/playbooks, siguen pendientes — dímelo si quieres reordenar el plan). Hasta ahora resolvimos **cómo llegan los datos** a Sentinel ([[AMA]] – *Azure Monitor Agent*, [[DCR]] – *Data Collection Rule*, WEF – *Windows Event Forwarding*, Syslog/[[CEF]] – *Common Event Format*, TI – *Threat Intelligence*, tablas custom). Hoy resolvemos la otra mitad: **qué hace Sentinel con esos datos para avisarte de una amenaza**. Sin esto, un SIEM (Security Information and Event Management — la plataforma que centraliza logs de seguridad y los analiza) es solo un repositorio caro de texto: la detección es la razón de ser del producto, y es el tema que más preguntas concentra del examen.

## 📖 Lectura

### 1. Qué es una analytics rule y el flujo alerta → incidente

Una **analytics rule** (regla de analítica, también llamada "regla de detección") es un objeto de configuración dentro de Sentinel que define **una condición a vigilar** en los datos que ya llegaron al workspace (el contenedor de logs que configuramos el Día 1, técnicamente un Log Analytics workspace). Esa condición casi siempre se expresa como una consulta **KQL** (Kusto Query Language, el lenguaje de consulta usado para leer los datos almacenados en Sentinel y en Defender XDR (Extended Detection and Response) — ya lo veníamos usando en las lecciones de ingestión). La regla ejecuta esa consulta de forma automática y periódica; cuando el resultado cumple la condición configurada (por ejemplo, "la consulta devolvió al menos una fila"), Sentinel genera una **alert** (alerta): un registro que dice "en este momento, sobre esta entidad —usuario, dispositivo, IP—, se cumplió esta condición sospechosa".

Una sola alerta rara vez basta para actuar: un atacante real deja un rastro de VARIAS señales relacionadas (un inicio de sesión raro, luego un proceso sospechoso, luego una conexión de red anómala). Por eso Sentinel agrupa alertas relacionadas —que comparten entidades, o que provienen de la misma regla en una ventana de tiempo— dentro de un **incident** (incidente): el contenedor que ve el analista en la cola de trabajo, con severidad, estado (Nuevo/Activo/Cerrado) y todas las alertas y entidades asociadas. Todo el trabajo de triage, investigación y respuesta que hace un analista en Sentinel gira sobre incidentes, no sobre alertas sueltas.

### 2. Los tipos de analytics rule (y cuándo usar cada uno)

Sentinel no tiene un solo mecanismo de detección: tiene varios "motores" distintos, cada uno pensado para un tipo de amenaza y un costo computacional distinto.

**a) Scheduled (programada).** Es el tipo más común y el que más se personaliza. Ejecutas una consulta KQL a un **intervalo configurable** (mínimo 5 minutos) sobre un **lookback period** (la ventana de tiempo hacia atrás que la consulta examina en cada corrida — por ejemplo, "cada 15 minutos, revisa la última hora"). Por diseño trae un **retraso incorporado de 5 minutos** antes de ejecutar, para darle margen a los datos de terminar de llegar al workspace (recuerda que la ingestión no es instantánea: un evento generado en un servidor tarda segundos o minutos en aparecer en las tablas). Con Scheduled tienes control total: puedes hacer joins entre varias tablas, usar cualquier operador KQL, y definir cómo se agrupan los resultados en alertas y en qué campos se mapean las entidades (usuario, host, IP) para que el incidente muestre esa información de forma útil.

**b) NRT (Near-Real-Time, "casi en tiempo real").** Es un **subconjunto limitado** de las reglas Scheduled, pensado para amenazas donde cada minuto cuenta. Corre **una vez por minuto** con un retraso de solo 2 minutos (en vez de 5), y además consulta por el **momento de ingestión** del dato en vez de por su `TimeGenerated` (el momento en que el evento ocurrió en el origen) — esto es clave: así evita quedarse esperando datos que llegaron tarde. Las limitaciones que el examen pregunta: puede generar hasta **30 alertas de un solo evento** por ejecución; si la consulta devuelve más de 30 resultados en una corrida, genera 29 alertas individuales y una trigésima alerta que resume el resto. No tiene sentido usar NRT sobre una fuente de datos que tarda mucho en llegar al workspace (por ejemplo, una fuente con horas de retraso de ingestión) porque pierdes la ventaja de "casi en tiempo real" sin importar qué tan rápido corra la regla.

**c) Microsoft Security (regla de seguridad de Microsoft).** No ejecuta una consulta KQL propia: simplemente **importa automáticamente** las alertas que ya generaron otros productos de seguridad de Microsoft conectados (Defender for Endpoint, Defender for Identity, Defender for Office 365, Defender for Cloud Apps, Entra ID Protection) y las convierte en incidentes de Sentinel. Es la manera en que la telemetría de todo el ecosistema Defender XDR termina también visible dentro de Sentinel como incidentes unificados.

**d) TI Map (mapeo de Threat Intelligence).** Compara los indicadores de amenaza que ingeriste (las tablas `ThreatIntelIndicators` que vimos el Día 3 — IPs, dominios, hashes, URLs maliciosos conocidos) contra tu propia telemetría de red o de logs (por ejemplo `CommonSecurityLog` o `DeviceNetworkEvents`), y genera una alerta cuando encuentra una coincidencia exacta. Es la forma automática de responder "¿algún IOC (Indicator of Compromise, indicador de compromiso) conocido apareció en mi entorno?".

**e) Fusion (detección de ataques multi-etapa por machine learning).** Este es un motor distinto a todos los anteriores: usa **machine learning** (algoritmos que aprenden patrones a partir de datos históricos, en vez de seguir una regla fija escrita por un humano) para **correlacionar alertas de baja fidelidad** —señales sueltas que individualmente no dirían mucho— **de múltiples productos distintos**, uniéndolas quiere decir por **entidades compartidas** (el mismo usuario, la misma IP) para formar un incidente de **alta confianza** que representa un ataque de varias etapas: por ejemplo, un inicio de sesión sospechoso seguido, horas después, del despliegue de ransomware. Viene **habilitada por defecto** y entrena sus modelos con **30 días de datos históricos** de tu propio workspace. Punto importante para el examen: **Fusion no se puede editar** — no puedes tocar su lógica interna de correlación. Lo único que puedes hacer si un escenario específico de Fusion te genera ruido es crear una **exclusión de escenario** (scenario exclusion) para apagar ESE patrón concreto, sin afectar el resto del motor.

**f) Anomaly rules (reglas de anomalía).** Otro motor de machine learning, pero con un objetivo distinto a Fusion: en vez de correlacionar alertas ya existentes, analiza **comportamiento normal (baseline)** de una entidad a lo largo del tiempo — por ejemplo, desde qué países suele iniciar sesión un usuario, a qué hora, con qué frecuencia — y marca como **anomalía** cualquier evento que se desvíe significativamente de ese patrón (un inicio de sesión desde un país nuevo a las 3 AM). Estas anomalías se guardan en una tabla especial llamada **`Anomalies`**, consultable como cualquier otra tabla con KQL. **Detalle crítico para el examen: las anomaly rules NO generan incidentes ni alertas por sí solas.** Solo pueblan la tabla `Anomalies`. Si quieres que una anomalía dispare un incidente, tienes que construir una regla Scheduled o NRT adicional que consulte la tabla `Anomalies` y decida cuándo convertir eso en alerta — o dejar que Fusion la use como una señal más dentro de su correlación.

Las reglas de anomalía que vienen out-of-the-box **no se pueden editar ni borrar directamente**. Si quieres ajustar su umbral (threshold, el valor que decide qué tan "raro" debe ser un evento para contar como anomalía) o sus parámetros, el proceso es: **duplicar** la regla original (botón "Duplicate"), lo que crea una copia con el sufijo "- Customized", **deshabilitada** y en modo **Flighting**. "Flighting" significa modo de prueba en paralelo: la copia corre y genera resultados, pero no reemplaza a la original — así puedes comparar los resultados de ambas configuraciones antes de decidir. Solo puedes tener **una copia customizada por regla** (un segundo intento de duplicar falla). Cuando confirmas que la copia funciona mejor, la cambias de Flighting a **Production** — y automáticamente la regla original vigente pasa a Flighting, porque el sistema no permite tener dos versiones de la misma regla en producción al mismo tiempo.

### 3. La cobertura MITRE ATT&CK

**MITRE ATT&CK** es un marco de referencia público y ampliamente adoptado en la industria que cataloga las **tácticas** (el objetivo general de un atacante en una fase del ataque — por ejemplo, "Acceso inicial", "Movimiento lateral", "Exfiltración") y las **técnicas** (el método concreto para lograr esa táctica — por ejemplo, "Phishing" como técnica dentro de "Acceso inicial"). Cada analytics rule en Sentinel se puede etiquetar, al crearla, con las tácticas y técnicas MITRE que esa regla ayuda a detectar.

El **blade (panel) de MITRE ATT&CK** dentro de Sentinel toma todas esas etiquetas y las pinta como un **mapa de calor** (heatmap) sobre la matriz completa de MITRE: cada celda de la matriz (una técnica) se colorea según cuánta cobertura de detección tienes ahí. Esto te deja responder de un vistazo: "¿qué técnicas de ataque NO tengo cubiertas con ninguna detección?" — información clave para priorizar qué reglas nuevas crear.

El panel distingue dos tipos de cobertura:
- **Active** (activa): el mapa de calor construido solo con las reglas de tipo Scheduled, NRT o Anomaly que ya están **habilitadas y corriendo** en tu workspace ahora mismo.
- **Simulated** (simulada): agrega, además de las activas, las **plantillas de reglas** (analytics rule templates que aún no activaste), las **hunting queries** guardadas, y las anomaly rules disponibles — para mostrarte tu cobertura *potencial* si activaras todo lo disponible.

### Tabla resumen de los 6 tipos de analytics rule

| Tipo | Motor | Genera incidente directo | Editable | Frecuencia |
|---|---|---|---|---|
| Scheduled | KQL propio | Sí | Total | ≥5 min |
| NRT | KQL propio (subset) | Sí (máx 30 alertas/corrida) | Total, con límites | 1 min |
| Microsoft Security | Importa alertas de productos Defender | Sí | No aplica (no es KQL) | Continuo |
| TI Map | Match contra IOCs | Sí | Total | Configurable |
| Fusion | ML — correlación multi-producto | Sí | No editable (solo exclusiones de escenario) | Continuo |
| Anomaly | ML — desviación de baseline | **No** (solo puebla tabla `Anomalies`) | Solo vía duplicado (Flighting→Production) | Según el algoritmo |

## 💡 Ejemplos concretos

**Ejemplo 1 — Elegir el tipo de regla correcto (tipo examen)**

*Escenario:* "El SOC (Security Operations Center) de Contoso necesita detectar, con la menor latencia posible, cuando una cuenta de servicio con privilegios elevados ejecuta un comando desde una IP fuera de la red corporativa. La fuente de datos (`SigninLogs`) se ingiere sin retrasos significativos. ¿Qué tipo de regla eligen?"

*Razonamiento:* la prioridad explícita es "la menor latencia posible" y la fuente no tiene problemas de retraso de ingestión — exactamente el caso de uso de una regla **NRT**: corre cada minuto con solo 2 minutos de delay, en vez de los 5 minutos de una Scheduled. Si el escenario dijera que la consulta necesita cruzar (join) tres tablas distintas con lógica compleja, la respuesta cambiaría a Scheduled, porque NRT está limitada a consultas simples.

```kql
// Regla NRT: cuenta de servicio con IP fuera del rango corporativo conocido
SigninLogs
| where AppDisplayName == "" and UserType == "ServicePrincipal" // ejemplo simplificado
| where IPAddress !startswith "203.0.113." // rango corporativo de ejemplo
| project TimeGenerated, UserPrincipalName, IPAddress, AppDisplayName
```

**Ejemplo 2 — Anomaly rule que no genera incidentes (tipo examen)**

*Escenario:* "Un analista revisó la tabla `Anomalies` y confirmó que la regla 'Unusual Sign-In' está detectando eventos correctamente, pero nota que ningún incidente aparece en la cola de trabajo relacionado con esas anomalías. ¿Cuál es la causa más probable y qué falta configurar?"

*Razonamiento:* esto es el comportamiento **esperado** de las anomaly rules: pueblan `Anomalies` pero **no crean incidentes por sí solas**. Falta una regla Scheduled o NRT que consulte esa tabla y decida cuándo generar una alerta a partir de ella.

```kql
// Regla Scheduled que promueve anomalías de "Unusual Sign-In" a alerta
Anomalies
| where AnomalyTemplateName == "Unusual Sign-In"
| where Score > 2 // umbral configurable de gravedad de la anomalía
| project TimeGenerated, UserName = tostring(parse_json(Description)), Score, RuleId
```
**revisar la ultima parte de la consulta** 
**Ejemplo 3 — Ajustar una anomaly rule ruidosa (tipo examen)**

*Escenario:* "Una regla de anomalía llamada 'Unusual Volume of Data Uploaded to Cloud Apps' genera decenas de resultados diarios por un equipo de marketing que sube archivos grandes de forma legítima cada semana. El analista quiere ajustar el umbral sin perder la detección para el resto de la organización. ¿Cuál es el procedimiento correcto?"

*Razonamiento:* como las reglas out-of-the-box no se editan directamente, el procedimiento es: 1) **Duplicar** la regla original desde el panel de Anomalies (queda deshabilitada, en modo Flighting, con sufijo "- Customized"); 2) editar la copia para subir el umbral (threshold) o ajustar sus parámetros; 3) habilitar la copia y comparar resultados en la tabla `Anomalies` filtrando por `AnomalyTemplateId` durante unos días; 4) si el resultado convence, cambiar la copia a **Production** — lo que automáticamente manda la regla original a Flighting.

```kql
// Comparar resultados entre la regla original y su copia customizada
Anomalies
| where AnomalyTemplateId contains "<RuleId-original>"
| summarize count() by RuleName, bin(TimeGenerated, 1d)
```

## 🎥 Videos

1. **"Sentinel 3 | How to Create analytic rules (detailed explained)"** — [YouTube](https://www.youtube.com/watch?v=uZQ3DcYQ5Fk), publicado en abril de 2026. Muestra paso a paso el asistente de creación de una analytics rule (Scheduled) en el portal, incluyendo las pestañas de lógica de la regla, mapeo de entidades y configuración de incidentes — es exactamente el flujo que vas a practicar hoy. Duración aproximada 15-20 min según el listado de búsqueda (verifícala al abrirlo).
2. **"Understanding your MITRE ATT&CK coverage | Microsoft Sentinel in the Field #6"** — [YouTube](https://www.youtube.com/watch?v=fpkIzt9dRKU). Nota de honestidad: este video es de 2022, más viejo de lo que me pediste priorizar, pero la mecánica del blade de MITRE (heatmap Active vs Simulated) que explica sigue siendo la misma en 2026 según la [documentación oficial vigente](https://learn.microsoft.com/en-us/azure/sentinel/mitre-coverage). Si prefieres una fuente 100% actualizada en vez de este video, usa directamente esa página de Microsoft Learn.

## 🧪 Ejercicio práctico

> [!info] Requisito
> Usa el mismo workspace de Sentinel de los Días 1–3. No hace falta infraestructura nueva.

- [ ] **Paso 1 — Crear una Scheduled rule desde plantilla.** En el portal, ve a Analytics → Rule templates, elige una plantilla simple (por ejemplo, alguna sobre `SigninLogs` o sobre la tabla `Syslog` que ya tienes poblada desde el Día 3). Sigue el asistente completo: General (nombre, severidad, táctica/técnica MITRE), Set rule logic (la consulta KQL, el lookback period, el umbral), Incident settings (agrupación de alertas) y Automated response. Sigue como referencia el lab oficial [Lab 8 Ex2 — Scheduled Query from template](https://microsoftlearning.github.io/SC-200T00A-Microsoft-Security-Operations-Analyst/Instructions/Labs/LAB_AK_08_Lab1_Ex02_Scheduled_Query_Defender.html).
- [ ] **Paso 2 — Crear una regla desde cero (no desde plantilla)** usando una de las queries de ejemplo de arriba (adapta el Ejemplo 1 a tus datos reales de `Syslog` o `SecurityEvent`). Complementa con [Lab 8 Ex6 — Create Detections](https://microsoftlearning.github.io/SC-200T00A-Microsoft-Security-Operations-Analyst/Instructions/Labs/LAB_AK_08_Lab1_Ex06_Detections_Defender.html).
- [ ] **Paso 3 — Explorar el panel de Anomalies.** Ve a Analytics → pestaña Anomalies. Abre 2–3 reglas y lee su Description, Parameters y Threshold. Identifica cuál está en modo Production.
- [ ] **Paso 4 — Duplicar una anomaly rule** (right-click → Duplicate) solo para ver el flujo (no hace falta habilitarla ni gastar cuota): confirma que aparece con sufijo "- Customized", en Flighting y Disabled.
- [ ] **Paso 5 — Revisar el blade de MITRE ATT&CK.** Ve a la vista MITRE de Analytics, alterna entre Active y Simulated coverage, e identifica al menos 2 técnicas sin cobertura activa en tu workspace.
- [ ] **Paso 6 (teoría complementaria) —** repasa el módulo de Microsoft Learn [Creación de detecciones y realización de investigaciones](https://learn.microsoft.com/es-es/training/paths/sc-200-create-detections-perform-investigations-azure-sentinel/), enfocado en los submódulos de analytics rules.

## ✅ Quiz del día

**P1.** Tu equipo necesita detectar un patrón que cruza `DeviceProcessEvents`, `DeviceNetworkEvents` y una watchlist con lógica de correlación compleja, sin restricción de latencia. ¿Qué tipo de regla usas?
A) NRT · B) Anomaly · C) TI Map · D) Scheduled

**P2.** Una anomaly rule "Unusual Sign-In" lleva una semana poblando la tabla `Anomalies` con resultados de calidad, pero el equipo SOC se queja de que nunca ve un incidente relacionado en su cola de trabajo. ¿Qué es lo que falta?
A) Crear una regla Scheduled o NRT adicional que consulte la tabla `Anomalies` y genere la alerta · B) Habilitar la regla, que estaba deshabilitada · C) Subir su severidad a High · D) Nada, es un bug que hay que reportar a Microsoft

**P3.** Fusion generó varios incidentes de un escenario específico que en tu organización es ruido conocido (una herramienta legítima de administración). No quieres perder el resto de la cobertura de Fusion. ¿Qué haces?
A) Editar la lógica de correlación de Fusion para excluir ese patrón · B) Crear una exclusión de ese escenario específico dentro de la configuración de Fusion · C) Deshabilitar Fusion por completo · D) Crear una suppression rule sobre los incidentes ya generados

**P4.** Necesitas duplicar por segunda vez la misma anomaly rule original porque quieres probar dos configuraciones de umbral distintas en paralelo. ¿Qué ocurre?
A) El intento falla: solo se permite una copia customizada por regla · B) Se crea sin problema, con sufijo "- Customized2" · C) Se crea pero queda en modo Production automáticamente · D) Reemplaza silenciosamente la copia customizada anterior

**P5.** En el blade de MITRE ATT&CK, activas la vista "Simulated" en vez de "Active". ¿Qué diferencia ves en el mapa de calor?
A) Simulated solo muestra las técnicas cubiertas por Fusion · B) Simulated es una vista de solo lectura sin datos reales, usada solo para demos · C) Simulated suma, a las reglas activas, las plantillas de reglas sin activar, las hunting queries guardadas y las anomaly rules disponibles, para mostrar la cobertura potencial · D) Simulated excluye las reglas de tipo Anomaly del cálculo

### Respuestas explicadas

> [!note]- Ver respuestas (spoiler)
> **P1 — D.** Joins complejos entre varias tablas y sin restricción de latencia es exactamente el terreno de Scheduled; NRT está limitada a consultas simples de baja complejidad.
> **P2 — A.** Las anomaly rules solo pueblan la tabla `Anomalies`; nunca generan alertas ni incidentes por sí mismas. Se necesita una regla adicional (Scheduled o NRT) que las consuma.
> **P3 — B.** Fusion no se edita directamente, pero sí soporta exclusiones a nivel de escenario específico sin apagar el resto del motor de correlación.
> **P4 — A.** Sentinel solo permite una copia customizada activa por cada anomaly rule original; un segundo intento de duplicar falla.
> **P5 — C.** Active = solo lo que ya corre habilitado en tu workspace. Simulated = Active + templates sin activar + hunting queries + anomaly rules disponibles, para ver el potencial de cobertura si activaras todo.

---

*Relacionadas: [[GUIA_INTENSIVA_24_DIAS]] · [[TRACKER_TUTOR]] · [[MAPA_DIARIO_LEARN_LABS]] · [[Dia 03 - Ingestion 2 Syslog CEF Azure Activity TI y Tablas Custom]] · [[CHEATSHEET_KQL]]*
