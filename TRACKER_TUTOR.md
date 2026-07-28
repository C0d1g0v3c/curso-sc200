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

- [ ] Día 6 (2026-07-24) — AIR (Automated Investigation and Response), Automatic attack disruption, Automation rules y Playbooks (Logic Apps) — lección impartida, quiz y lab práctico PENDIENTES ⏳

## Sesión 2026-07-24 (Día 6)
- 📖 Lección creada: [[Dia 06 - AIR Attack Disruption Automation Rules y Playbooks]]. Cubre los huecos 🟡/❌ marcados en la guía para el Día 6: AIR completo (verdicts, Action Center, relación con automation levels ya vistos el Día 5), Automatic attack disruption (3 etapas, tabla completa de acciones incl. Contain device/IP/user, Isolate device, Disable user, Revoke session, Suspend user in Entra, OAuth app compromise, y preview AWS/Okta), Automation rules (triggers, conditions, colas de orden separadas por tipo de trigger, acciones) y Playbooks (Logic Apps, permisos Microsoft Sentinel Automation Contributor sobre el resource group, tabla de timing de ejecución).
- ⚠️ **Hallazgo confirmado hoy en Microsoft Learn** (`automatic-investigation-and-response`, y reconfirmado sobre lo ya adelantado el 18-jul): a partir del **1 de septiembre de 2026, AIR deja de existir como experiencia de investigación separada y de poder activarse manualmente en Microsoft Defender for Endpoint** — sus capacidades quedan integradas en la protección antivirus por defecto. **Confirmado hoy: este cambio aplica SOLO a Defender for Endpoint; AIR en Defender for Office 365 sigue disponible sin cambios.** Dato ausente en `GUIA_INTENSIVA_24_DIAS.md` (omisión, no error, por ser noticia muy reciente) — el examen del alumno (29-ago) es antes del cambio, así que el modelo de automation levels del Día 5 sigue aplicando el día del examen.
- 📌 **Dato nuevo verificado hoy** (`automatic-attack-disruption`, doc actualizado 2026-06-11): la tabla de acciones de Attack Disruption es más amplia de lo que refleja la guía — incluye **Isolate device** (distinta de Contain device), **Contain user**, **Revoke user session** y **Suspend user in Entra** (Microsoft Entra ID), **OAuth app compromise** (Defender for Cloud Apps), y soporte preview para conectores **AWS IAM** y **Okta** de Sentinel. También existe **Predictive shielding** (Safeboot hardening, GPO hardening, Proactive user containment) como categoría preventiva hermana, no reactiva — no está en `GUIA_INTENSIVA_24_DIAS.md`, contexto útil aunque poco probable que el examen profundice ahí por ser muy reciente.
- 📌 Confirmado también (`automate-incident-handling-with-automation-rules`, actualizado 30-jun-2026): Sentinel en el portal de Azure se retira el **31 de marzo de 2027** (dato ya conocido, redirección total al portal unificado de Defender).
- ⏳ Pendiente: que el alumno haga el lab (automation rule + playbook + permisos + revisar Attack Disruption settings) y responda el quiz de 5 preguntas.
- 🗓️ Siguiente sesión de contenido nuevo: **Día 7** — Workbooks + SOC optimization + notificaciones de email + repaso mini-quiz del Dominio 1 completo.
