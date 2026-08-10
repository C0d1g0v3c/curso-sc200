---
title: Tracker de Progreso — Tutor SC-200
tipo: Seguimiento
relacionado: "[[GUIA_INTENSIVA_24_DIAS]]"
---

# Tracker de Progreso — Lecciones diarias SC-200

Registro de avance del plan intensivo de 24 días. Formato: `- [x] Día N (fecha) — tema — quiz X/Y`.

- [x] Día 1 (2026-07-06 teoría + 2026-07-07 práctica) — Arquitectura de Microsoft Sentinel + tiers de retención (Analytics / Data lake / XDR default) — **quiz 5/5** ✅

## Sesión 2026-07-07 (práctica Día 1)
- ✅ Workspace Log Analytics creado + Sentinel habilitado (suscripción Azure for Students, tenant La Salle — labs vía portal de Azure, NO tocar config M365 del tenant universitario)
- ✅ Watchlist `HighValueHosts` creada (CSV, SearchKey Hostname) — verificable con `_GetWatchlist('HighValueHosts')`
- ✅ Ejercicio Tables: única tabla `Watchlist` (plan Analytics) — aprendizaje: las tablas nacen al llegar datos
- ⏳ Pendiente: simulación completa del Lab 6 (indicador TI + retención SecurityEvent), query `Usage` (correr mañana, ya con `AzureActivity` si conectó el conector), y responder el quiz de la lección
- 📝 Nota: Sentinel en portal de Azure vigente hasta 31-mar-2027 (retiro pospuesto); portal unificado de Defender limitado en tenant universitario → usar simulaciones para esa parte

- [x] Día 2 (2026-07-08 teoría + 2026-07-09 práctica) — Ingestión 1: AMA, DCR, Windows Security Events via AMA y WEF — **quiz 5/5** ✅

## Sesión 2026-07-09 (práctica Día 2)
- ✅ VM Windows desplegada + conector "Windows Security Events via AMA" conectado (nivel Common) → DCR `test1` creada y asociada a la VM (Resource Count 1), extensión `AzureMonitorWindowsAgent` en "Provisioning succeeded"
- ✅ Ingestión verificada end-to-end: query `SecurityEvent | summarize count() by EventID` devolvió 17 EventIDs (4688=419, 4673=95, 4663=80, 4624=33, 4672=31...) → cadena AMA→DCR→SecurityEvent funcionando
- 📝 Aprendizaje: el editor gráfico nuevo de transformaciones (processors On Source / At Destination) exige tabla custom `_CL` y no deja aplicar transformKql limpio contra la tabla estándar `SecurityEvent`. Se dejó la DCR sin transformación (el nivel Common ya filtra en el agente = concepto "On Source"). El KQL `source | where EventID in (...)` se escribió y validó como ejercicio conceptual.
- ⚠️ Recordatorio: dejar la VM en "Stopped (deallocated)" tras cada sesión para no consumir crédito Azure for Students ($100 disponibles)

- [x] Día 3 (lección creada 2026-07-10, quiz respondido 2026-07-13) — Ingestión 2: Syslog/CEF via AMA, Azure Activity + Azure Policy a escala, Threat Intelligence (TAXII/MDTI/Upload API → ThreatIntelIndicators/ThreatIntelObjects) y tablas custom `_CL` — **quiz 5/5** ✅ (quiz nuevo de recuperación, letras variadas C/A/D/B/C)

- [ ] Día 4 (2026-07-13, quiz aprobado el 2026-07-18) — Detecciones Sentinel: analytics rules (Scheduled/NRT/Microsoft Security/TI Map/Fusion) + anomaly rules + cobertura MITRE ATT&CK — **quiz aprobado** ✅ · **lab práctico PENDIENTE** ⏳ (crear Scheduled rule + regla desde cero + explorar Anomalies y blade MITRE ATT&CK)

## 🔄 Reanclaje de calendario (2026-07-13)
El plan empezó el 7-jul pero se acumuló un **desfase de calendario, no de temario**: por fecha hoy tocaría el Día 7, pero por contenido vamos al Día 4 (nada saltado — la secuencia 1→2→3→4 está completa). A petición del alumno se reancló el cronograma:

- **Ayer 12-jul = Día 3 · Hoy 13-jul = Día 4.** El resto de días corre en fechas consecutivas: Día 5 = 14-jul … **Día 24 = 2-ago-2026** (antes 30-jul). Margen holgado antes del examen (29-ago).
- Fechas de estudio REALES (históricas) de cada día: Día 1 = 6–7 jul · Día 2 = 8–9 jul · Día 3 = 10 jul · Día 4 = 13 jul. La guía `GUIA_INTENSIVA_24_DIAS.md` ya muestra el calendario reanclado; este tracker conserva las fechas reales.
- **Pendiente del alumno:** responder el quiz del Día 4 (el del Día 3 ya se respondió 5/5 el 13-jul).
- **Siguiente sesión (Día 5, 14-jul):** Config MDE — ASR rules, advanced features, device groups, custom data collection (crear nota [[MDE_Configuracion_Avanzada]]). Luego Día 6 (15-jul): AIR / attack disruption / automation rules / playbooks.

## Sesión 2026-07-16 (retomando Día 4)
- La lección del Día 4 ya existía completa en el vault (creada 13-jul), pero el quiz seguía sin responder — se retomó hoy sin reescribir la nota (contenido verificado, sigue siendo válido salvo un punto).
- ⚠️ **Corrección verificada hoy en Microsoft Learn** (`create-nrt-rules`, actualizado 2026-06-22): las reglas **NRT ya SÍ pueden referenciar múltiples tablas y watchlists** en la misma query (evolucionó respecto a la restricción vieja de "1 sola tabla, sin joins"). El límite real de NRT sigue siendo: sin scheduling configurable (corre fijo cada 1 min con lookback de 1 min), sin alert threshold configurable, y tope de 30 alertas por corrida (29 individuales + 1 resumen). La nota [[Dia 04 - Detecciones Sentinel Analytics Rules y Anomalias]] tiene este dato desactualizado en el Ejemplo 1 y en la sección "b) NRT" — no se editó automáticamente (regla: no tocar notas de estudio sin permiso explícito), avisado al alumno en la lección.
- 📝 Dato nuevo detectado (no crítico para hoy, mencionado como contexto): Microsoft Learn ahora banner-recomienda **"Custom detections"** (Defender XDR) como "la mejor forma de crear reglas nuevas" hacia adelante, unificando Sentinel + XDR — vigilar si el skills outline lo absorbe explícitamente en la próxima actualización del temario.
- ⏳ Sigue pendiente: que el alumno responda el quiz de 5 preguntas de Día 4 (quedó planteado de nuevo al final de la lección de hoy).
- 🗓️ Nota de calendario: por el reanclaje del 13-jul, hoy 16-jul "tocaría" Día 7, pero por contenido seguimos en Día 4 (Días 5 y 6 — MDE/ASR y AIR/attack disruption — quedan pendientes de retomar en próximas sesiones, nada se saltó).

- [ ] Día 5 (2026-07-18) — Configuración avanzada de MDE: ASR rules (modos audit/block/warn, 16 reglas, exclusiones), advanced features (tamper protection, EDR in block mode, live response, custom network indicators), device groups (RBAC + automation levels) y custom data collection (nuevo, prerelease) — **quiz aprobado** ✅ · **lab práctico PENDIENTE** ⏳

## Sesión 2026-07-18 (Día 5)
- ⚠️ **Hallazgo crítico verificado hoy en Microsoft Learn** (`automation-levels`, actualizado 2026-07-02): a partir del **1 de septiembre de 2026, AIR (Automated Investigation and Response) dejará de correr como experiencia de investigación separada y no podrá activarse manualmente** en Microsoft Defender — sus capacidades quedan absorbidas en la protección antivirus por defecto. El examen del alumno está agendado el 29-ago-2026 (antes del cambio), así que el modelo de "automation levels" enseñado hoy probablemente sigue vigente en el examen, pero es un dato ausente en `GUIA_INTENSIVA_24_DIAS.md` que afecta directamente al Día 6 (AIR vs Attack Disruption). No se editó la guía ni ninguna nota existente (regla: no tocar sin permiso explícito) — queda avisado aquí y en la lección del día.
- 📌 Corrección menor sobre `attack-surface-reduction-rules-reference` (verificado hoy, doc actualizado 2026-07-02): son **dos** las ASR rules que no soportan modo Warn (LSASS credential theft y Office code injection into other processes), no solo una como sugiere el flashcard genérico que circula en algunas guías.
- Sigue pendiente: responder el quiz del Día 4 (Detecciones Sentinel) y el quiz nuevo del Día 5.
- 🗓️ Días 6 (AIR/attack disruption/automation rules/playbooks) y 7 (Workbooks/SOC optimization/repaso Fase 1) siguen pendientes de retomar en próximas sesiones — nada se saltó, solo se corrió la fecha real de estudio.

## Sesión 2026-07-18 (cierre Días 2, 3 y 4 + corrección de formato de quizzes)
- ✅ **Días 1, 2 y 3 quedan cerrados** (labs + quizzes aprobados). **Días 4 y 5 quedan con el quiz aprobado pero el lab práctico PENDIENTE en ambos** — Día 4: crear Scheduled rule + regla desde cero + explorar Anomalies y blade MITRE ATT&CK; Día 5: explorar ASR rules + Advanced features + crear device group con automation level + revisar Custom data collection. Corregido el 2026-07-18 tras confirmación explícita del alumno (se había marcado el lab del Día 5 por error). Reflejado también en `tasks.md`.
- 🔧 **Corrección de formato aplicada hoy:** las opciones de los quizzes de los Días 1, 2 y 3 marcaban la respuesta correcta en **negrita** dentro del propio enunciado (ej. "A) Analytics extendido · **B) Data lake**"), lo que revelaba la respuesta antes de que el alumno pensara. Se corrigió: ahora las 4 opciones de cada pregunta usan formato neutro idéntico (sin negrita ni resaltado), y la respuesta correcta + explicación solo aparece en el bloque spoiler `> [!note]- Ver respuestas` al final de cada quiz — igual que ya venían los Días 4 y 5, que no tenían el problema. Notas corregidas: [[Dia 01 - Arquitectura Sentinel y Tiers de Retencion]], [[Dia 02 - Ingestion 1 AMA DCR Windows Security Events y WEF]], [[Dia 03 - Ingestion 2 Syslog CEF Azure Activity TI y Tablas Custom]].
- 🗓️ **Siguiente sesión de contenido nuevo: Día 6** — AIR / attack disruption / automation rules / playbooks (recordar aplicar el hallazgo del retiro de AIR el 1-sep-2026, documentado en la sesión del Día 5).

## Sesión 2026-07-23 — Practice Assessment oficial (Microsoft Learn), Intento #1
- 📊 **Score: 46%** (meta ≥80%), 8 minutos para 50 preguntas — recomendable repetir sin presión de tiempo. Los 3 dominios quedaron parejos (todos ~40-50%), sin un punto fuerte claro que compense.
- Esto adelanta al alumno el "Simulacro #1" que el plan tenía en el Día 20 — pendiente repetirlo en el Día 22 (temario nuevo del 28-jul ya vigente) con foco en las áreas débiles de abajo.
- ❌ **Errores agrupados por tema (revisión completa hecha con el alumno hoy):**
  1. **Workbook vs Playbook** (2 fallos) — confundió "visualizar/reporte" (workbook) con acción automatizada (playbook).
  2. **RBAC mínimo privilegio** — rol Sentinel Automation Contributor debe ir sobre el resource group del playbook, no sobre el playbook individual.
  3. **Tabla de ingestión Entra ID Protection** → `SecurityAlert`, no `CommonSecurityLog`.
  4. **TI ingestion con mínimo esfuerzo** → instalar solución TI + conector Premium Defender TI (prearmado), no Upload API manual.
  5. **Analytics rule con entity mapping** → Scheduled, no ML behavioral analytics (Anomaly).
  6. **Portales que muestran alertas DLP** → Purview portal + Defender portal, no SharePoint/M365 admin center.
  7. **Entra ID Protection reports** → Risky users report (por usuario en el tiempo) vs Risky sign-ins report (por evento puntual) — los confundió.
  8-13. **Bloque MDE response (5 fallos, el más débil hoy):** Timeline vs Advanced Hunting vs Live response vs Isolate device vs Collect investigation package — falló en distinguir cuál usar según el calificador del enunciado (minimizar impacto, revisar ANTES de la alerta, analizar EN VIVO).
  14-17. **Bloque Purview Audit/eDiscovery/Graph activity logs (5 fallos)** — **contenido del Día 13, aún no impartido**: audit log search vs Sentinel ASIM, RecordType `AirInvestigation`, división de búsquedas eDiscovery por error CS007, atributo `SignInActivityId` vs `OperationId`.
  18-21. **KQL/Advanced Hunting (4 fallos):** columnas requeridas para custom detection (`ReportId`+`Timestamp`, no `AlertId`), `DeviceEvents` NO incluye Android aunque esté onboardeado, `union` vs `join` para buscar across tablas, nombre real de columna `ActionType` (no `EventType`, que es un distractor inventado).
  22-23. **Sentinel MCP Server (2 fallos) — contenido del Día 17, aún no impartido**: header `x-mcp-client-tenant-id` para multi-tenant, `workspaceId: 'default'` en el prompt para fijar el workspace del data lake.
- 📌 **Diagnóstico:** no es un problema de base conceptual — es (a) no leer el calificador del enunciado que decide entre herramientas parecidas, (b) 7 de ~24 fallos son de contenido de los Días 13 y 17 que el plan aún no cubre, (c) detalles finos de esquema que solo se fijan con repetición.
- 🗓️ **Siguiente sesión de contenido nuevo sigue siendo el Día 6** (AIR/attack disruption/automation rules/playbooks) — este simulacro no cambia el orden del plan, solo confirma qué reforzar cuando lleguemos a los Días 13 y 17.

- [ ] Día 6 (lección 2026-07-24, quiz respondido 2026-07-27) — AIR (Automated Investigation and Response), Automatic attack disruption, Automation rules y Playbooks (Logic Apps) — **quiz 4/5** ✅ · **lab práctico PENDIENTE** ⏳

## Sesión 2026-07-24 (Día 6)
- 📖 Lección creada: [[Dia 06 - AIR Attack Disruption Automation Rules y Playbooks]]. Cubre los huecos 🟡/❌ marcados en la guía para el Día 6: AIR completo (verdicts, Action Center, relación con automation levels ya vistos el Día 5), Automatic attack disruption (3 etapas, tabla completa de acciones incl. Contain device/IP/user, Isolate device, Disable user, Revoke session, Suspend user in Entra, OAuth app compromise, y preview AWS/Okta), Automation rules (triggers, conditions, colas de orden separadas por tipo de trigger, acciones) y Playbooks (Logic Apps, permisos Microsoft Sentinel Automation Contributor sobre el resource group, tabla de timing de ejecución).
- ⚠️ **Hallazgo confirmado hoy en Microsoft Learn** (`automatic-investigation-and-response`, y reconfirmado sobre lo ya adelantado el 18-jul): a partir del **1 de septiembre de 2026, AIR deja de existir como experiencia de investigación separada y de poder activarse manualmente en Microsoft Defender for Endpoint** — sus capacidades quedan integradas en la protección antivirus por defecto. **Confirmado hoy: este cambio aplica SOLO a Defender for Endpoint; AIR en Defender for Office 365 sigue disponible sin cambios.** Dato ausente en `GUIA_INTENSIVA_24_DIAS.md` (omisión, no error, por ser noticia muy reciente) — el examen del alumno (29-ago) es antes del cambio, así que el modelo de automation levels del Día 5 sigue aplicando el día del examen.
- 📌 **Dato nuevo verificado hoy** (`automatic-attack-disruption`, doc actualizado 2026-06-11): la tabla de acciones de Attack Disruption es más amplia de lo que refleja la guía — incluye **Isolate device** (distinta de Contain device), **Contain user**, **Revoke user session** y **Suspend user in Entra** (Microsoft Entra ID), **OAuth app compromise** (Defender for Cloud Apps), y soporte preview para conectores **AWS IAM** y **Okta** de Sentinel. También existe **Predictive shielding** (Safeboot hardening, GPO hardening, Proactive user containment) como categoría preventiva hermana, no reactiva — no está en `GUIA_INTENSIVA_24_DIAS.md`, contexto útil aunque poco probable que el examen profundice ahí por ser muy reciente.
- 📌 Confirmado también (`automate-incident-handling-with-automation-rules`, actualizado 30-jun-2026): Sentinel en el portal de Azure se retira el **31 de marzo de 2027** (dato ya conocido, redirección total al portal unificado de Defender).
- ⏳ Pendiente: que el alumno haga el lab (automation rule + playbook + permisos + revisar Attack Disruption settings) y responda el quiz de 5 preguntas.
- 🗓️ Siguiente sesión de contenido nuevo: **Día 7** — Workbooks + SOC optimization + notificaciones de email + repaso mini-quiz del Dominio 1 completo.

## Sesión 2026-07-27 (quiz Día 6 + control de versiones)

- ✅ **Quiz del Día 6 respondido: 4/5.** Aciertos: P1 (Attack Disruption actúa a nivel de incidente, independiente del automation level del device group), P2 (automation rules del mismo trigger corren secuencialmente por Order y evalúan el estado ACTUAL del incidente), P3 (falta rol Sentinel Automation Contributor sobre el resource group del playbook), P4 (retiro de AIR el 1-sep-2026 aplica solo a Defender for Endpoint, MDO no se afecta).
- ❌ **Único fallo — P5:** respondió `SecurityAlert`/`AlertName`; la correcta es **`SecurityIncident`**, campo `Title` (sufijo "(attack disruption)") o `Tags`. **Patrón detectado:** no es hueco conceptual — acertó la P1 justamente porque identificó que Disruption opera a nivel de incidente, y aun así fue a la tabla de alertas en la P5. Interferencia probable con el error #3 del simulacro del 23-jul (Entra ID Protection → `SecurityAlert`). **Regla a fijar: alerta individual de producto → `SecurityAlert` · incidente correlacionado de Sentinel → `SecurityIncident`.**
- 📌 Dato de esquema adelantado del Día 18: `SecurityIncident` guarda **una fila por actualización** del incidente, no una por incidente. Consultarla en crudo duplica incidentes; usar `summarize arg_max(LastModifiedTime, *) by IncidentNumber` para el estado final.
- ⚠️ **Defecto de formato encontrado en el quiz de la nota [[Dia 06 - AIR Attack Disruption Automation Rules y Playbooks]]:** las 5 respuestas correctas eran **B**, y en las 5 preguntas la opción B era la más larga y detallada — se podía sacar 5/5 eligiendo la opción larga, sin saber el tema. Es el mismo tipo de fuga que se corrigió en los Días 1–3 el 18-jul (ahí era negrita). El quiz se administró hoy en el chat con opciones reordenadas (clave C,A,D,A,C) y longitudes parejas. **La nota NO se editó** (regla: no tocar notas de estudio sin permiso explícito) — pendiente de confirmación del alumno para aplicar el arreglo ahí.
- 🔧 **Control de versiones activado:** la carpeta `certs en curso/SC-200/` es ahora un repo Git privado en `https://github.com/C0d1g0v3c/curso-sc200`. Commit + push al cerrar cada lección; la regla ya está en el agente `sc200-study-tutor`.
- 🗓️ Sigue pendiente: labs prácticos de los Días 4, 5 y 6. Siguiente contenido nuevo: **Día 7** (cierra el Dominio 1).

- [ ] Día 7 (lección 2026-07-29) — Workbooks de Sentinel, SOC optimization, roles/RBAC de Sentinel, notificaciones por correo en Defender XDR y alert tuning/suppression/correlación — **cierra el Dominio 1** · quiz PENDIENTE ⏳ · lab práctico PENDIENTE ⏳

## Sesión 2026-07-29 (Día 7 + replanteamiento de temario y calendario)

- 📖 Lección creada: [[Dia 07 - Workbooks SOC Optimization Roles de Sentinel y Notificaciones]]. Con ella **el Dominio 1 queda cubierto al completo** salvo "Create/Manage custom detection rules by using Advanced Hunting", desplazado a propósito al Día 15 (requiere soltura previa con KQL).
- 🔍 **Temario oficial reverificado hoy en Microsoft Learn.** La pagina del study guide ya dice "Skills measured as of July 28, 2026" — el temario nuevo esta vigente desde ayer. Dominios y pesos SIN cambios (40-45 / 35-40 / 20-25). Confirmados en el outline los temas nuevos que ya teniamos mapeados: case management (Dia 8), agentic AI + Copilot embebido (Dia 13), hunting graphs con blast radius y Sentinel Graph (Dia 15), KQL jobs + Summary rules + MCP Server (Dia 17).
- ❗ **Dos huecos reales detectados en `GUIA_INTENSIVA_24_DIAS.md`:** los objetivos del Dominio 1 **"Specify Microsoft Sentinel roles"** y **"Configure alert notifications in Microsoft Defender XDR, including tuning, suppression, and correlation"** no estaban asignados a NINGUN dia del plan. Ambos quedan cubiertos en la leccion de hoy (secciones §3 y §5).
- 📌 Otros ajustes de temario anotados en la leccion (§7): el perfil de audiencia ahora exige familiaridad con "AI agents and Copilots"; el outline ya **no nombra "Fusion" explicitamente** (dice "machine learning") — estudiar el concepto por funcion, no por nombre comercial; y SOC optimization tiene mas tipos de recomendacion de los que recoge la guia (AI MITRE ATT&CK tagging en preview, risk-based en preview, y similar organizations).
- ⚠️ Limitacion metodologica anotada: la tabla de change log de la pagina llega **truncada** al consultarla programaticamente (solo devuelve las filas de Audience profile y de "Respond to security incidents"). La comparacion se hizo contrastando el outline completo actual contra el mapeo del vault, no contra esas filas. Conviene abrir el study guide a mano para ver el change log fila por fila.
- 🗓️ **Reanclaje #2 del calendario (aplicado en `GUIA_INTENSIVA_24_DIAS.md` §2).** Situacion: 18 lecciones pendientes (Dias 7-24) y 31 dias al examen. Nuevo diseno: lecciones consecutivas del 29-jul al 17-ago, con **tres dias de recuperacion intercalados en fin de semana** (R1 = 1-ago para los labs de los Dias 4 y 5; R2 = 8-ago para el lab del Dia 6 + Simulacro #2; R3 = 18-ago) y **colchon final de 11 dias** (18-28 ago) con Simulacro #4, refuerzo de areas debiles medidas y repaso de los 5 temas de plataforma nuevos. **Punto de decision anotado: si el Simulacro #3 del 15-ago queda por debajo del 70 %, reprogramar el examen a la primera semana de septiembre** (gratis con +24 h; limite duro del voucher para la fecha de examen = 30-oct-2026).
- 📝 Solo se edito la **seccion de cronograma y fechas clave** de `GUIA_INTENSIVA_24_DIAS.md`. Los mapeos de contenido por dominio de la guia **no se tocaron** (regla: no editar notas de estudio sin permiso explicito) — pendiente de confirmacion del alumno para corregirlos con los hallazgos de arriba.
- ⏳ Pendiente: que el alumno responda el quiz de 5 preguntas del Dia 7 y haga el lab (workbook desde plantilla + workbook desde cero + auto refresh + revisar SOC optimization, IAM del resource group, notificaciones de incidentes y alert tuning).
- 🗓️ Siguiente sesion: **Dia 8 (jue 30-jul)** — incidentes unificados + case management.

## Sesión 2026-07-29 (bis) — Correcciones aplicadas con permiso explícito del alumno

El alumno pidió "corrige todo con los cambios nuevos", lo que autoriza por fin a tocar las notas de estudio que llevaban semanas con correcciones anotadas pero sin aplicar. Aplicado:

**En `GUIA_INTENSIVA_24_DIAS.md`:**
- §1 Mapeo del Dominio 1 **reescrito completo**: el dominio queda marcado como CERRADO. Los estados ahora reflejan lo realmente impartido en los Días 1-7 y la columna de notas apunta a las lecciones diarias, no a las notas viejas del vault. Añadido el objetivo "Specify Microsoft Sentinel roles", que no figuraba.
- §1 Resumen del gap analysis reescrito: separa lo ya cerrado (Dias 1-7) de lo que sigue pendiente (case management D8, Purview/eDiscovery/Graph D13, hunting graphs/Sentinel Graph D15, KQL jobs/summary rules/MCP D17) y señala que ahi se concentraron 7 de ~24 fallos del simulacro.
- §3.1 **Linea de roles de Sentinel corregida** — la version anterior era ERRONEA: decia "Automation Contributor (ejecutar playbooks)". Automation Contributor NO se asigna a usuarios ni sirve para ejecutar playbooks; ejecutarlos es Playbook Operator, y crearlos/editarlos es Logic App Contributor. Añadido que crear workbooks exige rol de Sentinel + Workbook Contributor.
- §3.1 AIR vs Attack disruption ampliado con el retiro del 1-sep-2026 (solo MDE) y la tabla completa de acciones de disruption + Predictive shielding.
- §3.1 Permisos de playbook: precisado que es la **cuenta de servicio** sobre el **resource group**.
- §3.1 ASR: precisado que son **DOS** las reglas sin modo Warn (LSASS y Office code injection). Añadida nota sobre el banner de custom detections.
- §4 Flashcard 6 (NRT) **corregida**; añadidas flashcards 17-20 (rutas de notificaciones, 3 acciones de alert tuning, que guarda un workbook, alcance de data value optimization). Flashcard 15 (Contain vs Isolate) matizada: attack disruption puede ejecutar las tres acciones.
- §4 Trampas: corregida la de NRT (tachada la afirmacion vieja), ampliada la de permisos de playbook, y añadidas 8 trampas nuevas (roles acumulativos, SIEM vs data lake RBAC, workbook vs playbook, alert tuning y custom detections, informational vs false positive, SecurityAlert vs SecurityIncident, tabla de TI renombrada, default de Entra ID Protection).
- §5 Q3: terminologia actualizada de "suppression rule" a "alert tuning".

**En `Dia 04 - Detecciones Sentinel Analytics Rules y Anomalias.md`:**
- Corregido el dato obsoleto que se detecto el 16-jul y nunca se aplico: **las reglas NRT SI admiten multiples tablas y watchlists**. Añadido callout de correccion en la seccion b) NRT con los limites reales (sin scheduling configurable, sin alert threshold, tope de 30 alertas/corrida), y corregido el razonamiento del Ejemplo 1 y de la respuesta P1 del quiz. La respuesta P1 sigue siendo D, pero por el motivo correcto.

**En `Dia 06 - AIR Attack Disruption Automation Rules y Playbooks.md`:**
- **Quiz reescrito.** Defecto original detectado el 27-jul: las 5 correctas eran B y B era siempre la opcion mas larga → se sacaba 5/5 eligiendo la larga. Nueva clave **C, A, D, A, C** con longitudes parejas (es la version que se administro en el chat el 27-jul). Explicaciones ampliadas: ahora justifican por que cada distractor es incorrecto, no solo por que la correcta es correcta. En P5 se marca explicitamente que fue el fallo del alumno y se fija la regla SecurityAlert vs SecurityIncident.

📌 **Queda pendiente de una pasada futura:** aplicar retroactivamente la regla de "siglas siempre con su forma completa entre parentesis" a las lecciones de los Dias 1-5, que se escribieron antes de que se fijara esa regla el 18-jul.

- [ ] Dia 8 (leccion 2026-08-05) — Incidentes unificados (repaso completo de gestion de incidentes: triage, clasificacion, AI-generated analyst notes) + Case Management (nuevo, arranca el Dominio 2) — quiz del dia PENDIENTE + repaso acumulativo PENDIENTE ⏳ · lab practico PENDIENTE ⏳

## Sesion 2026-08-05 (Dia 8 — arranca el Dominio 2)

- Leccion creada: [[Dia 08 - Incidentes Unificados y Case Management]]. Cubre el arranque del Dominio 2 (Respond to security incidents, 35-40%): repaso completo del ciclo de vida de un incidente en el portal unificado de Defender (Manage incident pane: triage, severidad, tags, status, clasificacion, comentarios, renombrado, activity log, AI-generated analyst notes con Security Copilot, export a PDF) y **Case Management completo desde cero** (que problema resuelve, requisitos, case vs incidente, anatomia del case, tasks, vincular incidentes e indicadores, activity log/adjuntos/borrado, RBAC, limites de servicio).
- Verificado hoy contra Microsoft Learn (`unified-secops/cases-overview` actualizado 31-jul-2026, `manage-incidents` actualizado 16-jun-2026, `sentinel-service-limits` actualizado 14-may-2026, study guide SC-200 skills-as-of-28-jul-2026): confirmado el desglose exacto del Dominio 2 (tres sub-bloques) y que **case management NO expone ninguna tabla de Log Analytics ni de Advanced Hunting** — los datos viven solo en el servicio de Case Management del portal de Defender, dato clave que se documenta explicitamente en la leccion para evitar que el alumno invente un nombre de tabla en el examen.
- Tablas/roles nuevos documentados con nombre exacto: RBAC de case management (Security operations > Security data basics (read) = Sentinel Reader; Security operations > Alerts (manage) = Sentinel Responder; Authorization and setting > Core Security settings (manage) = Sentinel Contributor); limites de servicio (100,000 cases/tenant, 500 GB adjuntos/tenant, 100 incidentes vinculados/case, 150 alertas/incidente, 100 comentarios/incidente de 30,000 caracteres c/u).
- Quiz del dia (3 preguntas, case management) + **repaso acumulativo dedicado (5 preguntas)** reforzando los 5 puntos debiles reales del Simulacro 01 (Dias 1-6): P3 Data lake tier vs Storage Account, P8 tabla `DeviceEvents`/`ActionType startswith "Asr"` para auditar ASR antes de Block, P21 Tamper protection vs Automated Investigation, P22 prerequisito dynamic tag en Asset Rule Management + tabla `DeviceCustomFileEvents`, P24 rol Microsoft Sentinel Automation Contributor de la cuenta de servicio sobre el resource group del playbook.
- Pendiente: que el alumno responda ambos quizzes (del dia + repaso) y haga el lab (Manage incident pane completo + explorar Cases si el tenant lo tiene onboardeado + revisar RBAC + repasar limites).
- Siguiente sesion: **Dia 9** — Respuesta MDE: timeline, live response, evidence (segun el calendario vigente de `GUIA_INTENSIVA_24_DIAS.md` §2).

## Sesion 2026-08-09 (Reanclaje #3 — plan multitrack)

- **Diagnostico del atasco.** El Dia 8 se impartio el 5-ago y el curso CCNA ITN arranco el 5-ago. El Dia 9 nunca ocurrio. La colision es exacta: el plan de leccion diaria asumia SC-200 como ocupacion unica, y esa premisa murio el dia que arranco el semestre. El alumno confirma **carga universitaria completa (4+ materias)**.
- **Examen movido del sab 29-ago al sab 3-oct-2026.** Decision del alumno sobre recomendacion. Razon de elegir el 3-oct y no octubre tardio: deja **tres sabados de reserva** (10, 17 y 24 de oct) antes del muro del voucher del 30-oct; el sab 24-oct es el ultimo posible. Los dos reanclajes anteriores fallaron por gastar todo el margen de golpe.
- **HTB Academy en pausa formal hasta el 4-oct** (dia siguiente al examen). Es el amortiguador de los tres tracks: sin fecha, sin instructor, sin caducidad. Llevaba sin tocarse desde el 22-jun, asi que la pausa solo formaliza lo que ya pasaba.
- **Nuevo ritmo: 3 lecciones por semana** (mar / jue / dom, 1-1.5 h) + **bloque grande el sabado** (2-3 h) para labs o simulacros. Lun/mie/vie quedan para universidad y CCNA. Son ~6 h semanales de SC-200.
- **Regla nueva fijada: el sabado es el recurso escaso, no las tardes.** Los labs exigen bloque continuo con el tenant abierto; una leccion no. En semana mala se sacrifica leccion entre semana, nunca el sabado. El atraso de julio se produjo por lo contrario (5 labs acumulados mientras las lecciones seguian corriendo).
- **Deuda de labs con fecha asignada:** Dias 4 y 5 el sab 15-ago, Dia 6 el sab 22-ago (+ Simulacro #2), Dias 7 y 8 el sab 29-ago. Deuda a cero al terminar agosto.
- **Tareas NetAcad de CCNA slotteadas** (M5 el 12-ago, M11 el 19-ago, examen de punto de control el 26-ago) en vez de dejarlas correr al 19-dic: la materia es acumulativa y subnetting depende de sistemas numericos.
- **Punto de decision: Simulacro #3 el sab 12-sep.** Por debajo del 70 % → mover al sab 24-oct. **Regla de deriva anadida:** si al terminar agosto faltan 2+ lecciones respecto al calendario, ejecutar el movimiento sin volver a replanificar. Tres reanclajes son suficientes.
- Documento creado: [[PLAN_MAESTRO_MULTITRACK]]. El cronograma §2 de [[GUIA_INTENSIVA_24_DIAS]] queda marcado con callout de OBSOLETO y la tabla de fechas clave actualizada.
- **Pendiente sobre el temario viejo** (pregunta del alumno esta sesion): medido el dano real. Son 28 hits en `CONCEPTOS_CLAVE.md` (17+ de ellos `ThreatIntelligenceIndicator`, varios dentro de consultas KQL completas), 2 en `04_Semana4_Simulacros.md` (Fusion como respuesta literal), 1 en `CHEATSHEET_KQL.md`, 2 en `01_Semana1`. Recomendacion dada: **jubilar el corpus del 6-jul, no reescribirlo** — arreglar a mano el split de TI (no es rename: `ThreatIntelligenceIndicator` se partio en `ThreatIntelIndicators` + `ThreatIntelObjects` y cambio el esquema de columnas, asi que un sed dejaria queries rotas con nombre nuevo), poner banner de caducidad al corpus viejo y archivar `Chronicle_vs_Sentinel.md` (viola la regla de estilo del alumno). ~30 min. Sigue **sin ejecutar**.
- **Deuda de repo saldada:** el Dia 8 llevaba sin commitear desde su creacion el 5-ago, junto con cambios sin subir del Dia 7 y del tracker. Todo commiteado en esta sesion.
- Siguiente sesion de contenido: **Dia 9 (mar 11-ago)** — Respuesta MDE: timeline, live response, evidence.
